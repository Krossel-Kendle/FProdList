unit ColorEngine;

interface

uses System.Threading, System.SyncObjs, System.SysUtils, System.Types,
  System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, idHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, System.JSON, System.UIConsts;

type
  TColorEngine = class
  public
    Colors: array of array of string;
    constructor Create;
    procedure LoadColors();
    function AddColor(Food: string; color: TAlphaColor): boolean;
    function GetColor(Food: string): string;
  end;

implementation

constructor TColorEngine.Create;
begin
  LoadColors;
end;

procedure TColorEngine.LoadColors;
begin
  var
    FoodColour: TStrings;
  FoodColour := TStringList.Create;
  try
    if fileexists(GetHomePath + '/colours.dat') then
    begin
      FoodColour.LoadFromFile(GetHomePath + '/colours.dat');
      SetLength(Colors, 2, FoodColour.Count);
      for var I := 0 to FoodColour.Count - 1 do
      begin
        var
          p: integer;
        var
          bef, aft: string;
        p := pos('|', FoodColour.Strings[I]);
        bef := copy(FoodColour.Strings[I], 0, p - 1);
        aft := copy(FoodColour.Strings[I], p + 1,
          length(FoodColour.Strings[I]));
        Colors[0][I] := bef;
        Colors[1][I] := aft;
      end;
    end
    else
      FoodColour.SaveToFile(GetHomePath + '/colours.dat');
  finally
    FoodColour.Free;
  end;
end;

function TColorEngine.AddColor(Food: string; color: TAlphaColor): boolean;
begin
  var
    FoodColour: TStrings;
  var
    ARec: TAlphaColorRec;
  ARec.color := color;
  FoodColour := TStringList.Create;
  try
    var
      pasted: boolean;
    pasted := false;
    for var I := 0 to length(Colors[1]) - 1 do
    begin
      if Colors[1][I] = Food then // Если Цвет
      begin
        Colors[0][I] := intToHex(integer(ARec.A), 1) + intToHex(integer(ARec.R),
          1) + intToHex(integer(ARec.G), 1) + intToHex(integer(ARec.b), 1);
        pasted := true;
      end;
    end;
    if not pasted then
    begin
      SetLength(Colors, 2, length(Colors[0]) + 1);
      Colors[0][length(Colors[0]) - 1] := intToHex(integer(ARec.A), 1) +
        intToHex(integer(ARec.R), 1) + intToHex(integer(ARec.G), 1) +
        intToHex(integer(ARec.b), 1);
      Colors[1][length(Colors[0]) - 1] := Food;
    end;
    for var I := 0 to length(Colors[0]) - 1 do
    begin
      FoodColour.Add(Colors[0][I] + '|' + Colors[1][I]);
    end;
    FoodColour.SaveToFile(GetHomePath + '/colours.dat');
  finally
    FoodColour.Free;
  end;
end;

function TColorEngine.GetColor(Food: string): string;
begin
  Result := '';
  try
    for var I := 0 to length(Colors[1]) - 1 do
    begin
      if Colors[1][I] = Food then
        Result := Colors[0][I];
    end;
  except

  end;
end;

end.
