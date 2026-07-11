unit BatchReplaceRaceColors;

{
  BatchReplaceRaceColors.pas

  Replaces references to specific CLFM color records inside selected RACE
  records.

  Example:
    aaaCaNColor001 from AlicornRace.esp
    becomes
    RC_001_Black from Race Colours.esp

  Instructions:
    1. Place this file in the "Edit Scripts" folder.
    2. Load AlicornRace.esp and Race Colours.esp in xEdit.
    3. Select the RACE record or records you want to modify.
    4. Right-click and choose "Apply Script."
    5. Select BatchReplaceRaceColors.
}

const
  OLD_COLOR_PLUGIN = 'Crimes against Nature.esm';
  NEW_COLOR_PLUGIN = 'Race Colours.esp';

var
  Replacements: TStringList;
  ReplacementCount: Integer;
  OldColorFile: IInterface;
  NewColorFile: IInterface;


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
  Finds a CLFM record with a particular EditorID inside one particular plugin.
}
function FindColorRecord(
  PluginFile: IInterface;
  const ColorEditorID: string
): IInterface;
var
  ColorGroup: IInterface;
  Candidate: IInterface;
  i: Integer;
begin
  Result := nil;

  if not Assigned(PluginFile) then
    Exit;

  ColorGroup := GroupBySignature(PluginFile, 'CLFM');

  if not Assigned(ColorGroup) then
    Exit;

  for i := 0 to ElementCount(ColorGroup) - 1 do begin
    Candidate := ElementByIndex(ColorGroup, i);

    if SameText(EditorID(Candidate), ColorEditorID) then begin
      Result := Candidate;
      Exit;
    end;
  end;
end;


{
  Checks every mapping before any records are edited.

  This prevents the script from performing half of the replacement job and
  then discovering that one of the requested colors does not exist.
}
function ValidateReplacements: Boolean;
var
  i: Integer;
  OldEditorID: string;
  NewEditorID: string;
  OldRecord: IInterface;
  NewRecord: IInterface;
begin
  Result := False;

  for i := 0 to Replacements.Count - 1 do begin
    OldEditorID := Trim(Replacements.Names[i]);
    NewEditorID := Trim(Replacements.ValueFromIndex[i]);

    OldRecord := FindColorRecord(OldColorFile, OldEditorID);

    if not Assigned(OldRecord) then begin
      AddMessage(
        'ERROR: Could not find old color "' +
        OldEditorID +
        '" in ' +
        OLD_COLOR_PLUGIN
      );

      Exit;
    end;

    NewRecord := FindColorRecord(NewColorFile, NewEditorID);

    if not Assigned(NewRecord) then begin
      AddMessage(
        'ERROR: Could not find replacement color "' +
        NewEditorID +
        '" in ' +
        NEW_COLOR_PLUGIN
      );

      Exit;
    end;

    AddMessage(
      'Validated mapping: ' +
      EditorID(OldRecord) +
      ' -> ' +
      EditorID(NewRecord)
    );
  end;

  Result := True;
end;


{
  Recursively walks through an element and all of its children.

  When it finds a field linking to one of the configured old CLFM records,
  it changes that field to link to the configured replacement CLFM record.
}
procedure ScanElement(
  CurrentElement: IInterface;
  ParentRecord: IInterface
);
var
  i: Integer;
  MappingIndex: Integer;

  LinkedRecord: IInterface;
  NewRecord: IInterface;

  LinkedEditorID: string;
  NewEditorID: string;
begin
  if not Assigned(CurrentElement) then
    Exit;

  {
    LinksTo returns the record referenced by a FormID field.

    For ordinary fields, structs, and arrays that do not directly reference
    another record, it normally returns nil.
  }
  LinkedRecord := LinksTo(CurrentElement);

  if Assigned(LinkedRecord) then begin
    if Signature(LinkedRecord) = 'CLFM' then begin

      {
        Only replace colors originally defined in AlicornRace.esp.

        This prevents an identically named color in some unrelated plugin
        from being replaced accidentally.
      }
      if SameText(
        GetFileName(GetFile(MasterOrSelf(LinkedRecord))),
        OLD_COLOR_PLUGIN
      ) then begin

        LinkedEditorID := EditorID(LinkedRecord);
        MappingIndex := Replacements.IndexOfName(LinkedEditorID);

        if MappingIndex >= 0 then begin
          NewEditorID :=
            Trim(Replacements.ValueFromIndex[MappingIndex]);

          NewRecord :=
            FindColorRecord(NewColorFile, NewEditorID);

          if not Assigned(NewRecord) then begin
            AddMessage(
              'ERROR: Replacement color disappeared or could not be found: ' +
              NewEditorID
            );

            Exit;
          end;

          AddMessage(
            'Replacing in ' +
            Name(ParentRecord) +
            ' at ' +
            Path(CurrentElement) +
            ': ' +
            EditorID(LinkedRecord) +
            ' -> ' +
            EditorID(NewRecord)
          );

          {
            SetEditValue accepts xEdit's displayed representation of the
            linked record, such as:

              RC_001_Black [CLFM:xx123456]
          }
          SetEditValue(CurrentElement, Name(NewRecord));

          Inc(ReplacementCount);

          {
            This element has already been replaced, so there is no reason
            to search below it.
          }
          Exit;
        end;
      end;
    end;
  end;

  {
    Recursively scan all child elements.
  }
  for i := 0 to ElementCount(CurrentElement) - 1 do begin
    ScanElement(
      ElementByIndex(CurrentElement, i),
      ParentRecord
    );
  end;
end;


function Initialize: Integer;
begin
  {
    Returning 1 cancels the script.
    Returning 0 allows it to process the selected records.
  }
  Result := 1;
  ReplacementCount := 0;

  Replacements := TStringList.Create;
  Replacements.NameValueSeparator := '=';
  Replacements.CaseSensitive := False;

  {
    ================================================================
    ADD YOUR COLOR REPLACEMENTS HERE
    ================================================================

    Format:

      Replacements.Add('OLD_EDITOR_ID=NEW_EDITOR_ID');

    Left side:
      Color currently used by AlicornRace.esp

    Right side:
      Replacement color from Race Colours.esp
  }

  Replacements.Add('aaaCaNColor001=RC_001_Black');
  Replacements.Add('aaaCaNColor002=RC_002_DarkGray');
  Replacements.Add('aaaCaNColor003=RC_003_Gray');
  Replacements.Add('aaaCaNColor004=RC_004_LightGray');
  Replacements.Add('aaaCaNColor005=RC_005_White');
  
  
  Replacements.Add('aaaCaNColor01AA=RC_006_RedDarkDeep');
  Replacements.Add('aaaCaNColor01AB=RC_007_RedDarkMed');
  Replacements.Add('aaaCaNColor01AC=RC_008_RedDarkPale');
  
  Replacements.Add('aaaCaNColor01BA=RC_009_RedMedDeep');
  Replacements.Add('aaaCaNColor01BB=RC_010_RedMedMed');
  Replacements.Add('aaaCaNColor01BC=RC_011_RedMedPale');
  
  Replacements.Add('aaaCaNColor01CA=RC_012_RedLightDeep');
  Replacements.Add('aaaCaNColor01CB=RC_013_RedLightMed');
  Replacements.Add('aaaCaNColor01CC=RC_014_RedLightPale');
  
  
  Replacements.Add('aaaCaNColor02AA=RC_015_OrangeDarkDeep');
  Replacements.Add('aaaCaNColor02AB=RC_016_OrangeDarkMed');
  Replacements.Add('aaaCaNColor02AC=RC_017_OrangeDarkPale');
  
  Replacements.Add('aaaCaNColor02BA=RC_018_OrangeMedDeep');
  Replacements.Add('aaaCaNColor02BB=RC_019_OrangeMedMed');
  Replacements.Add('aaaCaNColor02BC=RC_020_OrangeMedPale');
  
  Replacements.Add('aaaCaNColor02CA=RC_021_OrangeLightDeep');
  Replacements.Add('aaaCaNColor02CB=RC_022_OrangeLightMed');
  Replacements.Add('aaaCaNColor02CC=RC_023_OrangeLightPale');
  
  
  Replacements.Add('aaaCaNColor03AA=RC_024_YellowDarkDeep');
  Replacements.Add('aaaCaNColor03AB=RC_025_YellowDarkMed');
  Replacements.Add('aaaCaNColor03AC=RC_026_YellowDarkPale');
  
  Replacements.Add('aaaCaNColor03BA=RC_027_YellowMedDeep');
  Replacements.Add('aaaCaNColor03BB=RC_028_YellowMedMed');
  Replacements.Add('aaaCaNColor03BC=RC_029_YellowMedPale');
  
  Replacements.Add('aaaCaNColor03CA=RC_030_YellowLightDeep');
  Replacements.Add('aaaCaNColor03CB=RC_031_YellowLightMed');
  Replacements.Add('aaaCaNColor03CC=RC_032_YellowLightPale');
  
  
  Replacements.Add('aaaCaNColor04AA=RC_033_ChartreuseDarkDeep');
  Replacements.Add('aaaCaNColor04AB=RC_034_ChartreuseDarkMed');
  Replacements.Add('aaaCaNColor04AC=RC_035_ChartreuseDarkPale');
  
  Replacements.Add('aaaCaNColor04BA=RC_036_ChartreuseMedDeep');
  Replacements.Add('aaaCaNColor04BB=RC_037_ChartreuseMedMed');
  Replacements.Add('aaaCaNColor04BC=RC_038_ChartreuseMedPale');
  
  Replacements.Add('aaaCaNColor04CA=RC_039_ChartreuseLightDeep');
  Replacements.Add('aaaCaNColor04CB=RC_040_ChartreuseLightMed');
  Replacements.Add('aaaCaNColor04CC=RC_041_ChartreuseLightPale');
  
  
  Replacements.Add('aaaCaNColor05AA=RC_042_GreenDarkDeep');
  Replacements.Add('aaaCaNColor05AB=RC_043_GreenDarkMed');
  Replacements.Add('aaaCaNColor05AC=RC_044_GreenDarkPale');
  
  Replacements.Add('aaaCaNColor05BA=RC_045_GreenMedDeep');
  Replacements.Add('aaaCaNColor05BB=RC_046_GreenMedMed');
  Replacements.Add('aaaCaNColor05BC=RC_047_GreenMedPale');
  
  Replacements.Add('aaaCaNColor05CA=RC_048_GreenLightDeep');
  Replacements.Add('aaaCaNColor05CB=RC_049_GreenLightMed');
  Replacements.Add('aaaCaNColor05CC=RC_050_GreenLightPale');
  
  
  Replacements.Add('aaaCaNColor06AA=RC_051_TurquoiseDarkDeep');
  Replacements.Add('aaaCaNColor06AB=RC_052_TurquoiseDarkMed');
  Replacements.Add('aaaCaNColor06AC=RC_053_TurquoiseDarkPale');
  
  Replacements.Add('aaaCaNColor06BA=RC_054_TurquoiseMedDeep');
  Replacements.Add('aaaCaNColor06BB=RC_055_TurquoiseMedMed');
  Replacements.Add('aaaCaNColor06BC=RC_056_TurquoiseMedPale');
  
  Replacements.Add('aaaCaNColor06CA=RC_057_TurquoiseLightDeep');
  Replacements.Add('aaaCaNColor06CB=RC_058_TurquoiseLightMed');
  Replacements.Add('aaaCaNColor06CC=RC_059_TurquoiseLightPale');
  
  
  Replacements.Add('aaaCaNColor07AA=RC_060_CyanDarkDeep');
  Replacements.Add('aaaCaNColor07AB=RC_061_CyanDarkMed');
  Replacements.Add('aaaCaNColor07AC=RC_062_CyanDarkPale');
  
  Replacements.Add('aaaCaNColor07BA=RC_063_CyanMedDeep');
  Replacements.Add('aaaCaNColor07BB=RC_064_CyanMedMed');
  Replacements.Add('aaaCaNColor07BC=RC_065_CyanMedPale');
  
  Replacements.Add('aaaCaNColor07CA=RC_066_CyanLightDeep');
  Replacements.Add('aaaCaNColor07CB=RC_067_CyanLightMed');
  Replacements.Add('aaaCaNColor07CC=RC_068_CyanLightPale');
  
  
  Replacements.Add('aaaCaNColor08AA=RC_069_AzureDarkDeep');
  Replacements.Add('aaaCaNColor08AB=RC_070_AzureDarkMed');
  Replacements.Add('aaaCaNColor08AC=RC_071_AzureDarkPale');
  
  Replacements.Add('aaaCaNColor08BA=RC_072_AzureMedDeep');
  Replacements.Add('aaaCaNColor08BB=RC_073_AzureMedMed');
  Replacements.Add('aaaCaNColor08BC=RC_074_AzureMedPale');
  
  Replacements.Add('aaaCaNColor08CA=RC_075_AzureLightDeep');
  Replacements.Add('aaaCaNColor08CB=RC_076_AzureLightMed');
  Replacements.Add('aaaCaNColor08CC=RC_077_AzureLightPale');
  
  
  Replacements.Add('aaaCaNColor09AA=RC_078_BlueDarkDeep');
  Replacements.Add('aaaCaNColor09AB=RC_079_BlueDarkMed');
  Replacements.Add('aaaCaNColor09AC=RC_080_BlueDarkPale');
  
  Replacements.Add('aaaCaNColor09BA=RC_081_BlueMedDeep');
  Replacements.Add('aaaCaNColor09BB=RC_082_BlueMedMed');
  Replacements.Add('aaaCaNColor09BC=RC_083_BlueMedPale');
  
  Replacements.Add('aaaCaNColor09CA=RC_084_BlueLightDeep');
  Replacements.Add('aaaCaNColor09CB=RC_085_BlueLightMed');
  Replacements.Add('aaaCaNColor09CC=RC_086_BlueLightPale');
  
  
  Replacements.Add('aaaCaNColor10AA=RC_087_VioletDarkDeep');
  Replacements.Add('aaaCaNColor10AB=RC_088_VioletDarkMed');
  Replacements.Add('aaaCaNColor10AC=RC_089_VioletDarkPale');
  
  Replacements.Add('aaaCaNColor10BA=RC_090_VioletMedDeep');
  Replacements.Add('aaaCaNColor10BB=RC_091_VioletMedMed');
  Replacements.Add('aaaCaNColor10BC=RC_092_VioletMedPale');
  
  Replacements.Add('aaaCaNColor10CA=RC_093_VioletLightDeep');
  Replacements.Add('aaaCaNColor10CB=RC_094_VioletLightMed');
  Replacements.Add('aaaCaNColor10CC=RC_095_VioletLightPale');
  
  
  Replacements.Add('aaaCaNColor11AA=RC_096_MagentaDarkDeep');
  Replacements.Add('aaaCaNColor11AB=RC_097_MagentaDarkMed');
  Replacements.Add('aaaCaNColor11AC=RC_098_MagentaDarkPale');
  
  Replacements.Add('aaaCaNColor11BA=RC_099_MagentaMedDeep');
  Replacements.Add('aaaCaNColor11BB=RC_100_MagentaMedMed');
  Replacements.Add('aaaCaNColor11BC=RC_101_MagentaMedPale');
  
  Replacements.Add('aaaCaNColor11CA=RC_102_MagentaLightDeep');
  Replacements.Add('aaaCaNColor11CB=RC_103_MagentaLightMed');
  Replacements.Add('aaaCaNColor11CC=RC_104_MagentaLightPale');
  
  
  Replacements.Add('aaaCaNColor12AA=RC_105_RoseDarkDeep');
  Replacements.Add('aaaCaNColor12AB=RC_106_RoseDarkMed');
  Replacements.Add('aaaCaNColor12AC=RC_107_RoseDarkPale');
  
  Replacements.Add('aaaCaNColor12BA=RC_108_RoseMedDeep');
  Replacements.Add('aaaCaNColor12BB=RC_109_RoseMedMed');
  Replacements.Add('aaaCaNColor12BC=RC_110_RoseMedPale');
  
  Replacements.Add('aaaCaNColor12CA=RC_111_RoseLightDeep');
  Replacements.Add('aaaCaNColor12CB=RC_112_RoseLightMed');
  Replacements.Add('aaaCaNColor12CC=RC_113_RoseLightPale');
  {
    Add further mappings like this:

    Replacements.Add('aaaCaNColor002=RC_002_White');
    Replacements.Add('aaaCaNColor003=RC_003_Grey');
    Replacements.Add('aaaCaNColor004=RC_004_Red');
  }

  if Replacements.Count = 0 then begin
    AddMessage('ERROR: No replacement mappings were configured.');
    Exit;
  end;

  OldColorFile := FindLoadedFile(OLD_COLOR_PLUGIN);

  if not Assigned(OldColorFile) then begin
    AddMessage(
      'ERROR: Required plugin is not loaded: ' +
      OLD_COLOR_PLUGIN
    );

    Exit;
  end;

  NewColorFile := FindLoadedFile(NEW_COLOR_PLUGIN);

  if not Assigned(NewColorFile) then begin
    AddMessage(
      'ERROR: Required plugin is not loaded: ' +
      NEW_COLOR_PLUGIN
    );

    Exit;
  end;

  if not ValidateReplacements then begin
    AddMessage(
      'Script cancelled because one or more colors could not be found.'
    );

    Exit;
  end;

  AddMessage('');
  AddMessage('Batch Race Color Replacement started.');
  AddMessage(
    'Configured mappings: ' +
    IntToStr(Replacements.Count)
  );
  AddMessage('');

  Result := 0;
end;


function Process(e: IInterface): Integer;
var
  TargetFile: IInterface;
begin
  Result := 0;

  if Signature(e) <> 'RACE' then begin
    AddMessage(
      'Skipping non-RACE record: ' +
      Name(e)
    );

    Exit;
  end;

  TargetFile := GetFile(e);

  {
    The edited plugin must list Race Colours.esp as a master before it can
    save references to records from Race Colours.esp.
  }
  AddMasterIfMissing(
    TargetFile,
    NEW_COLOR_PLUGIN
  );

  AddMessage(
    'Scanning race: ' +
    Name(e)
  );

  ScanElement(e, e);
end;


function Finalize: Integer;
begin
  AddMessage('');
  AddMessage(
    'Finished. Replaced ' +
    IntToStr(ReplacementCount) +
    ' color reference(s).'
  );

  Replacements.Free;

  Result := 0;
end;

end.