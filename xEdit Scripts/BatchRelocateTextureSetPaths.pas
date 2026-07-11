unit BatchRelocateTextureSetPaths;

{
  BatchRelocateTextureSetPaths.pas

  Changes one configured texture path on selected TXST records.

  The script:
    1. Reads a configured texture slot.
    2. Confirms it starts with the expected old folder.
    3. Extracts and preserves the filename.
    4. Prepends the replacement folder.

  Example:

    1Custom\Crimes Against Nature\Pony\Eyes\Eyes__001.dds

  becomes:

    actors\character\pony\eyes\Eyes__001.dds
}

const
  {
    Full xEdit element path to the texture slot.

    Change TX00 to TX01, TX02, etc. as needed.
  }
  TEXTURE_PATH = 'Textures (RGB/A)\TX02';

  {
    Used only for log messages.
  }
  TEXTURE_SLOT = 'TX00';

  {
    Existing directory.

    Do not include Data\textures\ at the beginning.
    Include the final backslash.
  }
  OLD_FOLDER =
    '1Custom\Crimes Against Nature\Pony\Eyes\';

  {
    Replacement directory.

    Do not include Data\textures\ at the beginning.
    Include the final backslash.
  }
  NEW_FOLDER =
    'actors\character\Pony\Eyes\';


var
  ReplacementCount: Integer;
  SkippedCount: Integer;
  MissingFieldCount: Integer;


{
  Converts forward slashes to backslashes.
}
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


{
  Returns the filename at the end of a path.
}
function ExtractTextureFileName(const FullPath: string): string;
var
  i: Integer;
begin
  Result := FullPath;

  for i := Length(FullPath) downto 1 do begin
    if (FullPath[i] = '\') or
       (FullPath[i] = '/') then begin

      Result := Copy(
        FullPath,
        i + 1,
        Length(FullPath) - i
      );

      Exit;
    end;
  end;
end;


{
  Case-insensitive check that FullPath begins with FolderPath.
}
function PathStartsWith(
  const FullPath: string;
  const FolderPath: string
): Boolean;
begin
  Result := False;

  if Length(FullPath) < Length(FolderPath) then
    Exit;

  Result := SameText(
    Copy(FullPath, 1, Length(FolderPath)),
    FolderPath
  );
end;


function Initialize: Integer;
begin
  Result := 0;

  ReplacementCount := 0;
  SkippedCount := 0;
  MissingFieldCount := 0;

  AddMessage('');
  AddMessage('Batch texture-set path relocation started.');
  AddMessage('Texture element: ' + TEXTURE_PATH);
  AddMessage('Old folder: ' + OLD_FOLDER);
  AddMessage('New folder: ' + NEW_FOLDER);
  AddMessage('');
end;


function Process(e: IInterface): Integer;
var
  TextureElement: IInterface;

  CurrentPath: string;
  NormalizedCurrentPath: string;
  NormalizedOldFolder: string;
  NormalizedNewFolder: string;

  TextureFileName: string;
  ReplacementPath: string;
begin
  Result := 0;

  if Signature(e) <> 'TXST' then begin
    AddMessage(
      'Skipping non-TXST record: ' +
      Name(e)
    );

    Inc(SkippedCount);
    Exit;
  end;

  {
    Locate the texture field using its complete path beneath
    "Textures (RGB/A)".
  }
  TextureElement := ElementByPath(
    e,
    TEXTURE_PATH
  );

  if not Assigned(TextureElement) then begin
    AddMessage(
      'Skipping ' +
      Name(e) +
      ': could not find ' +
      TEXTURE_PATH
    );

    Inc(MissingFieldCount);
    Exit;
  end;

  CurrentPath := GetEditValue(TextureElement);

  AddMessage(
    'Read ' +
    Name(e) +
    ' [' +
    TEXTURE_SLOT +
    ']: "' +
    CurrentPath +
    '"'
  );

  if CurrentPath = '' then begin
    AddMessage(
      'Skipping ' +
      Name(e) +
      ': texture path is empty'
    );

    Inc(SkippedCount);
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
      'Skipping ' +
      Name(e) +
      ': path does not begin with the old folder: "' +
      CurrentPath +
      '"'
    );

    Inc(SkippedCount);
    Exit;
  end;

  TextureFileName :=
    ExtractTextureFileName(
      NormalizedCurrentPath
    );

  if TextureFileName = '' then begin
    AddMessage(
      'Skipping ' +
      Name(e) +
      ': could not extract filename from "' +
      CurrentPath +
      '"'
    );

    Inc(SkippedCount);
    Exit;
  end;

  ReplacementPath :=
    NormalizedNewFolder +
    TextureFileName;

  AddMessage(
    'Changing ' +
    Name(e) +
    ' [' +
    TEXTURE_SLOT +
    ']: "' +
    CurrentPath +
    '" -> "' +
    ReplacementPath +
    '"'
  );

  SetEditValue(
    TextureElement,
    ReplacementPath
  );

  Inc(ReplacementCount);
end;


function Finalize: Integer;
begin
  AddMessage('');
  AddMessage('Batch texture-set path relocation finished.');

  AddMessage(
    'Changed: ' +
    IntToStr(ReplacementCount)
  );

  AddMessage(
    'Skipped: ' +
    IntToStr(SkippedCount)
  );

  AddMessage(
    'Missing texture field: ' +
    IntToStr(MissingFieldCount)
  );

  Result := 0;
end;

end.