unit BatchRelocateHeadPartModels;

{
  BatchRelocateHeadPartModels.pas

  Relocates asset paths on selected HDPT records.

  Changes:
    Model\MODL  - NIF model filename
    Every NAM1  - TRI morph filename

  NAM0 is not edited because it is the option/type field associated
  with each NAM1 entry, not a texture or model path.
}

const
  {
    Existing asset directory.

    Do not include Data\meshes\.
    Include the final backslash.
  }
  OLD_FOLDER =
    '1Custom\Crimes Against Nature\Pony\FaceParts\';

  {
    Replacement asset directory.

    Do not include Data\meshes\.
    Include the final backslash.
  }
  NEW_FOLDER =
    'actors\character\Pony\FaceParts\';


var
  ChangedRecordCount: Integer;
  ChangedModelCount: Integer;
  ChangedTriCount: Integer;
  SkippedPathCount: Integer;
  MissingModelCount: Integer;


function NormalizePath(const PathValue: string): string;
var
  i: Integer;
begin
  Result := PathValue;

  for i := 1 to Length(Result) do begin
    if Result[i] = '/' then
      Result[i] := '\';
  end;
end;


function ExtractAssetFileName(const FullAssetPath: string): string;
var
  i: Integer;
begin
  Result := FullAssetPath;

  for i := Length(FullAssetPath) downto 1 do begin
    if (FullAssetPath[i] = '\') or
       (FullAssetPath[i] = '/') then begin

      Result := Copy(
        FullAssetPath,
        i + 1,
        Length(FullAssetPath) - i
      );

      Exit;
    end;
  end;
end;


function PathStartsWith(
  const FullAssetPath: string;
  const FolderPath: string
): Boolean;
begin
  Result := False;

  if Length(FullAssetPath) < Length(FolderPath) then
    Exit;

  Result := SameText(
    Copy(
      FullAssetPath,
      1,
      Length(FolderPath)
    ),
    FolderPath
  );
end;


{
  Changes the path stored in one specific string element.

  Returns True when the element was changed.
}
function RelocatePathElement(
  PathElement: IInterface;
  const FieldLabel: string
): Boolean;
var
  CurrentPath: string;
  NormalizedCurrentPath: string;
  NormalizedOldFolder: string;
  NormalizedNewFolder: string;
  AssetFileName: string;
  ReplacementPath: string;
begin
  Result := False;

  if not Assigned(PathElement) then
    Exit;

  CurrentPath := GetEditValue(PathElement);

  if CurrentPath = '' then begin
    AddMessage(
      '  ' +
      FieldLabel +
      ': empty'
    );

    Inc(SkippedPathCount);
    Exit;
  end;

  NormalizedCurrentPath :=
    NormalizePath(CurrentPath);

  NormalizedOldFolder :=
    NormalizePath(OLD_FOLDER);

  NormalizedNewFolder :=
    NormalizePath(NEW_FOLDER);

  if not PathStartsWith(
    NormalizedCurrentPath,
    NormalizedOldFolder
  ) then begin

    AddMessage(
      '  ' +
      FieldLabel +
      ': skipped; path does not begin with old folder: "' +
      CurrentPath +
      '"'
    );

    Inc(SkippedPathCount);
    Exit;
  end;

  AssetFileName :=
    ExtractAssetFileName(
      NormalizedCurrentPath
    );

  if AssetFileName = '' then begin
    AddMessage(
      '  ' +
      FieldLabel +
      ': could not extract filename from "' +
      CurrentPath +
      '"'
    );

    Inc(SkippedPathCount);
    Exit;
  end;

  ReplacementPath :=
    NormalizedNewFolder +
    AssetFileName;

  if SameText(
    NormalizedCurrentPath,
    ReplacementPath
  ) then begin

    AddMessage(
      '  ' +
      FieldLabel +
      ': already correct'
    );

    Inc(SkippedPathCount);
    Exit;
  end;

  AddMessage(
    '  ' +
    FieldLabel +
    ': "' +
    CurrentPath +
    '" -> "' +
    ReplacementPath +
    '"'
  );

  SetEditValue(
    PathElement,
    ReplacementPath
  );

  Result := True;
end;


{
  Recursively scans the entire HDPT record and changes every NAM1 field.

  Head-part records may contain multiple NAM0/NAM1 pairs, so stopping
  after the first NAM1 would leave later TRI paths unchanged.
}
function RelocateAllTriPaths(
  CurrentElement: IInterface;
  var TriIndex: Integer
): Boolean;
var
  i: Integer;
  ChildElement: IInterface;
  FieldSignature: string;
begin
  Result := False;

  if not Assigned(CurrentElement) then
    Exit;

  FieldSignature := Signature(CurrentElement);

  if FieldSignature = 'NAM1' then begin
    Inc(TriIndex);

    if RelocatePathElement(
      CurrentElement,
      'NAM1 TRI #' + IntToStr(TriIndex)
    ) then begin

      Inc(ChangedTriCount);
      Result := True;
    end;

    Exit;
  end;

  for i := 0 to ElementCount(CurrentElement) - 1 do begin
    ChildElement :=
      ElementByIndex(CurrentElement, i);

    if RelocateAllTriPaths(
      ChildElement,
      TriIndex
    ) then
      Result := True;
  end;
end;


function Initialize: Integer;
begin
  Result := 0;

  ChangedRecordCount := 0;
  ChangedModelCount := 0;
  ChangedTriCount := 0;
  SkippedPathCount := 0;
  MissingModelCount := 0;

  AddMessage('');
  AddMessage('Batch head-part asset relocation started.');
  AddMessage('Old folder: ' + OLD_FOLDER);
  AddMessage('New folder: ' + NEW_FOLDER);
  AddMessage('');
end;


function Process(e: IInterface): Integer;
var
  ModelElement: IInterface;
  RecordWasChanged: Boolean;
  TriIndex: Integer;
begin
  Result := 0;
  RecordWasChanged := False;
  TriIndex := 0;

  if Signature(e) <> 'HDPT' then begin
    AddMessage(
      'Skipping non-HDPT record: ' +
      Name(e)
    );

    Exit;
  end;

  AddMessage(
    'Processing ' +
    Name(e)
  );

  {
    MODL is nested inside the Model structure.
  }
  ModelElement :=
    ElementByPath(
      e,
      'Model\MODL'
    );

  if not Assigned(ModelElement) then begin
    AddMessage(
      '  MODL: could not find Model\MODL'
    );

    Inc(MissingModelCount);
  end
  else begin
    if RelocatePathElement(
      ModelElement,
      'MODL model'
    ) then begin

      Inc(ChangedModelCount);
      RecordWasChanged := True;
    end;
  end;

  {
    Change every NAM1 TRI filename in the record.
  }
  if RelocateAllTriPaths(
    e,
    TriIndex
  ) then
    RecordWasChanged := True;

  if TriIndex = 0 then
    AddMessage('  No NAM1 TRI fields found.');

  if RecordWasChanged then
    Inc(ChangedRecordCount)
  else
    AddMessage('  No paths changed.');

  AddMessage('');
end;


function Finalize: Integer;
begin
  AddMessage('');
  AddMessage('Batch head-part asset relocation finished.');

  AddMessage(
    'Head-part records changed: ' +
    IntToStr(ChangedRecordCount)
  );

  AddMessage(
    'NIF model paths changed: ' +
    IntToStr(ChangedModelCount)
  );

  AddMessage(
    'TRI paths changed: ' +
    IntToStr(ChangedTriCount)
  );

  AddMessage(
    'Paths skipped: ' +
    IntToStr(SkippedPathCount)
  );

  AddMessage(
    'Missing model fields: ' +
    IntToStr(MissingModelCount)
  );

  Result := 0;
end;

end.