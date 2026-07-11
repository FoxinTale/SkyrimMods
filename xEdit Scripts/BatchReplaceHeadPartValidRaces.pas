unit BatchReplaceHeadPartValidRaces;

{
  BatchReplaceHeadPartValidRaces.pas

  Replaces the RNAM - Valid Races reference on selected HDPT records.

  Typical structure:

    Head Part [HDPT]
      RNAM - Valid Races
        SomeRaceHeadParts [FLST]

  Configure:
    OLD_RNAM_PLUGIN
    OLD_RNAM_EDITOR_ID
    NEW_RNAM_PLUGIN
    NEW_RNAM_EDITOR_ID

  Then select one or more HDPT records in xEdit and apply the script.
}

const
  {
    Plugin containing the FormList currently referenced by RNAM.
  }
  OLD_RNAM_PLUGIN = 'Crimes against Nature.esm';

  {
    EditorID of the FormList currently referenced by RNAM.
    Replace this example with the actual EditorID.
  }
  OLD_RNAM_EDITOR_ID = 'aaaPonyHeadParts';

  {
    Plugin containing the replacement FormList.
  }
  NEW_RNAM_PLUGIN = 'Alicorn Race.esp';

  {
    EditorID of the replacement FormList.
    Replace this example with the actual EditorID.
  }
  NEW_RNAM_EDITOR_ID = 'AlicornHeadParts';


var
  OldPluginFile: IInterface;
  NewPluginFile: IInterface;

  OldValidRacesRecord: IInterface;
  NewValidRacesRecord: IInterface;

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
  Recursively searches an element and its children for a main record
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
  Confirms that the configured source and replacement records exist.
}
function ValidateConfiguration: Boolean;
begin
  Result := False;

  OldPluginFile := FindLoadedFile(OLD_RNAM_PLUGIN);

  if not Assigned(OldPluginFile) then begin
    AddMessage(
      'ERROR: Source plugin is not loaded: ' +
      OLD_RNAM_PLUGIN
    );

    Exit;
  end;

  NewPluginFile := FindLoadedFile(NEW_RNAM_PLUGIN);

  if not Assigned(NewPluginFile) then begin
    AddMessage(
      'ERROR: Replacement plugin is not loaded: ' +
      NEW_RNAM_PLUGIN
    );

    Exit;
  end;

  OldValidRacesRecord := FindRecordInPlugin(
    OldPluginFile,
    'FLST',
    OLD_RNAM_EDITOR_ID
  );

  if not Assigned(OldValidRacesRecord) then begin
    AddMessage(
      'ERROR: Could not find old valid-races FormList "' +
      OLD_RNAM_EDITOR_ID +
      '" in ' +
      OLD_RNAM_PLUGIN
    );

    Exit;
  end;

  NewValidRacesRecord := FindRecordInPlugin(
    NewPluginFile,
    'FLST',
    NEW_RNAM_EDITOR_ID
  );

  if not Assigned(NewValidRacesRecord) then begin
    AddMessage(
      'ERROR: Could not find replacement valid-races FormList "' +
      NEW_RNAM_EDITOR_ID +
      '" in ' +
      NEW_RNAM_PLUGIN
    );

    Exit;
  end;

  AddMessage(
    'Validated RNAM replacement: ' +
    Name(OldValidRacesRecord) +
    ' -> ' +
    Name(NewValidRacesRecord)
  );

  Result := True;
end;


function Initialize: Integer;
begin
  Result := 1;
  ReplacementCount := 0;

  AddMessage('');
  AddMessage('Validating head-part RNAM replacement...');

  if not ValidateConfiguration then begin
    AddMessage('Script cancelled.');
    Exit;
  end;

  AddMessage('');
  AddMessage('Batch head-part RNAM replacement started.');
  AddMessage('');

  Result := 0;
end;


function Process(e: IInterface): Integer;
var
  RNAMElement: IInterface;
  CurrentRNAMRecord: IInterface;
  TargetFile: IInterface;
begin
  Result := 0;

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
    Locate RNAM - Valid Races.
  }
  RNAMElement := ElementByPath(e, 'RNAM');

  if not Assigned(RNAMElement) then begin
    AddMessage(
      'Skipping ' +
      Name(e) +
      ': no RNAM - Valid Races field'
    );

    Exit;
  end;

  {
    Resolve the record currently referenced by RNAM.
  }
  CurrentRNAMRecord := LinksTo(RNAMElement);

  if not Assigned(CurrentRNAMRecord) then begin
    AddMessage(
      'Skipping ' +
      Name(e) +
      ': RNAM does not resolve to a record'
    );

    Exit;
  end;

  {
    Only replace an exact reference to the configured old FormList.

    Comparing load-order FormIDs avoids accidentally replacing a different
    record that happens to have the same EditorID.
  }
  if GetLoadOrderFormID(CurrentRNAMRecord) <>
     GetLoadOrderFormID(OldValidRacesRecord) then begin

    AddMessage(
      'Skipping ' +
      Name(e) +
      ': RNAM currently points to ' +
      Name(CurrentRNAMRecord)
    );

    Exit;
  end;

  TargetFile := GetFile(e);

  {
    Ensure the plugin being edited can legally reference the replacement
    plugin.
  }
  AddMasterIfMissing(
    TargetFile,
    NEW_RNAM_PLUGIN
  );

  AddMessage(
    'Replacing RNAM in ' +
    Name(e) +
    ': ' +
    Name(CurrentRNAMRecord) +
    ' -> ' +
    Name(NewValidRacesRecord)
  );

  SetEditValue(
    RNAMElement,
    Name(NewValidRacesRecord)
  );

  Inc(ReplacementCount);
end;


function Finalize: Integer;
begin
  AddMessage('');
  AddMessage(
    'Finished. Replaced RNAM on ' +
    IntToStr(ReplacementCount) +
    ' head-part record(s).'
  );

  Result := 0;
end;

end.