unit BatchReplaceAdditionalHeadPart;

{
  BatchReplaceAdditionalHeadPart.pas

  Replaces one HDPT reference with another inside:

    HNAM - Additional Head Parts

  on selected HDPT records.

  Example:

    OldExtraEars [HDPT]
      becomes
    NewExtraEars [HDPT]

  Only the configured old reference is replaced. Other additional
  head parts in the HNAM array remain unchanged.
}

const
  {
    Plugin where the OLD additional head part is defined.
  }
  OLD_HEADPART_PLUGIN = 'Crimes against Nature.esm';

  {
    EditorID of the OLD additional head part.
  }
  OLD_HEADPART_EDITOR_ID = 'aaaPonyXtraEyesGloss';

  {
    Plugin where the NEW additional head part is defined.
  }
  NEW_HEADPART_PLUGIN = 'Alicorn Race.esp';

  {
    EditorID of the NEW additional head part.
  }
  NEW_HEADPART_EDITOR_ID = 'AlicornExtraEyeGloss';


var
  OldPluginFile: IInterface;
  NewPluginFile: IInterface;

  OldHeadPartRecord: IInterface;
  NewHeadPartRecord: IInterface;

  ReplacementCount: Integer;


{
  Finds a loaded plugin by its exact filename.
}
function FindLoadedFile(const FileName: string): IInterface;
var
  i: Integer;
  CurrentFile: IInterface;
begin
  Result := nil;

  for i := 0 to FileCount - 1 do begin
    CurrentFile := FileByIndex(i);

    if SameText(GetFileName(CurrentFile), FileName) then begin
      Result := CurrentFile;
      Exit;
    end;
  end;
end;


{
  Recursively searches an element and its children for a record
  with the requested signature and EditorID.
}
function FindRecordInElement(
  CurrentElement: IInterface;
  const RecordSignature: string;
  const RecordEditorID: string
): IInterface;
var
  i: Integer;
  Child: IInterface;
begin
  Result := nil;

  if not Assigned(CurrentElement) then
    Exit;

  if Signature(CurrentElement) = RecordSignature then begin
    if SameText(EditorID(CurrentElement), RecordEditorID) then begin
      Result := CurrentElement;
      Exit;
    end;
  end;

  for i := 0 to ElementCount(CurrentElement) - 1 do begin
    Child := ElementByIndex(CurrentElement, i);

    Result := FindRecordInElement(
      Child,
      RecordSignature,
      RecordEditorID
    );

    if Assigned(Result) then
      Exit;
  end;
end;


{
  Finds a record of a given signature and EditorID inside one plugin.
}
function FindRecordInPlugin(
  PluginFile: IInterface;
  const RecordSignature: string;
  const RecordEditorID: string
): IInterface;
var
  RecordGroup: IInterface;
begin
  Result := nil;

  if not Assigned(PluginFile) then
    Exit;

  RecordGroup := GroupBySignature(
    PluginFile,
    RecordSignature
  );

  if not Assigned(RecordGroup) then begin
    AddMessage(
      'ERROR: No ' +
      RecordSignature +
      ' group found in ' +
      GetFileName(PluginFile)
    );

    Exit;
  end;

  Result := FindRecordInElement(
    RecordGroup,
    RecordSignature,
    RecordEditorID
  );
end;


{
  Finds the HNAM field on a head-part record.

  ElementBySignature is preferable here because the displayed name may be
  "HNAM - Additional Head Parts", while the underlying signature is HNAM.
}
function FindHNAMElement(
  HeadPartRecord: IInterface
): IInterface;
begin
  Result := ElementBySignature(
    HeadPartRecord,
    'HNAM'
  );
end;


{
  Confirms that the configured files and head-part records exist before
  editing anything.
}
function ValidateConfiguration: Boolean;
begin
  Result := False;

  OldPluginFile := FindLoadedFile(
    OLD_HEADPART_PLUGIN
  );

  if not Assigned(OldPluginFile) then begin
    AddMessage(
      'ERROR: Old head-part plugin is not loaded: ' +
      OLD_HEADPART_PLUGIN
    );

    Exit;
  end;

  NewPluginFile := FindLoadedFile(
    NEW_HEADPART_PLUGIN
  );

  if not Assigned(NewPluginFile) then begin
    AddMessage(
      'ERROR: New head-part plugin is not loaded: ' +
      NEW_HEADPART_PLUGIN
    );

    Exit;
  end;

  OldHeadPartRecord := FindRecordInPlugin(
    OldPluginFile,
    'HDPT',
    OLD_HEADPART_EDITOR_ID
  );

  if not Assigned(OldHeadPartRecord) then begin
    AddMessage(
      'ERROR: Could not find old head part "' +
      OLD_HEADPART_EDITOR_ID +
      '" in ' +
      OLD_HEADPART_PLUGIN
    );

    Exit;
  end;

  NewHeadPartRecord := FindRecordInPlugin(
    NewPluginFile,
    'HDPT',
    NEW_HEADPART_EDITOR_ID
  );

  if not Assigned(NewHeadPartRecord) then begin
    AddMessage(
      'ERROR: Could not find new head part "' +
      NEW_HEADPART_EDITOR_ID +
      '" in ' +
      NEW_HEADPART_PLUGIN
    );

    Exit;
  end;

  AddMessage(
    'Validated HNAM replacement: ' +
    Name(OldHeadPartRecord) +
    ' -> ' +
    Name(NewHeadPartRecord)
  );

  Result := True;
end;


function Initialize: Integer;
begin
  Result := 1;
  ReplacementCount := 0;

  AddMessage('');
  AddMessage('Validating HNAM replacement...');

  if not ValidateConfiguration then begin
    AddMessage('Script cancelled.');
    Exit;
  end;

  AddMessage('');
  AddMessage('Batch HNAM replacement started.');
  AddMessage('');

  Result := 0;
end;


function Process(e: IInterface): Integer;
var
  HNAMElement: IInterface;
  HNAMEntry: IInterface;
  LinkedHeadPart: IInterface;
  TargetFile: IInterface;

  i: Integer;
  ReplacedInRecord: Boolean;
begin
  Result := 0;
  ReplacedInRecord := False;

  {
    Only process Head Part records.
  }
  if Signature(e) <> 'HDPT' then begin
    AddMessage(
      'Skipping non-HDPT record: ' +
      Name(e)
    );

    Exit;
  end;

  {
    Find HNAM - Additional Head Parts.
  }
  HNAMElement := FindHNAMElement(e);

  if not Assigned(HNAMElement) then begin
    AddMessage(
      'Skipping ' +
      Name(e) +
      ': no HNAM - Additional Head Parts field'
    );

    Exit;
  end;

  {
    Examine each individual reference in the HNAM array.
  }
  for i := 0 to ElementCount(HNAMElement) - 1 do begin
    HNAMEntry := ElementByIndex(
      HNAMElement,
      i
    );

    LinkedHeadPart := LinksTo(HNAMEntry);

    if not Assigned(LinkedHeadPart) then
      Continue;

    if Signature(LinkedHeadPart) <> 'HDPT' then
      Continue;

    {
      Compare the exact linked records by load-order FormID.
    }
    if GetLoadOrderFormID(LinkedHeadPart) =
       GetLoadOrderFormID(OldHeadPartRecord) then begin

      {
        The edited plugin must be able to reference the replacement
        plugin.
      }
      TargetFile := GetFile(e);

      AddMasterIfMissing(
        TargetFile,
        NEW_HEADPART_PLUGIN
      );

      AddMessage(
        'Replacing HNAM entry in ' +
        Name(e) +
        ': ' +
        Name(LinkedHeadPart) +
        ' -> ' +
        Name(NewHeadPartRecord)
      );

      SetEditValue(
        HNAMEntry,
        Name(NewHeadPartRecord)
      );

      Inc(ReplacementCount);
      ReplacedInRecord := True;
    end;
  end;

  if not ReplacedInRecord then begin
    AddMessage(
      'No matching HNAM entry in ' +
      Name(e)
    );
  end;
end;


function Finalize: Integer;
begin
  AddMessage('');
  AddMessage(
    'Finished. Replaced ' +
    IntToStr(ReplacementCount) +
    ' HNAM reference(s).'
  );

  Result := 0;
end;

end.