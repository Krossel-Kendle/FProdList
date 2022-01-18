unit functions;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, idHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, Utils, WebHelper, System.JSON;

procedure LoadCart(params: TStrings; ms: TStream); overload;
function LoadCart(params: TStrings): string; overload;
function LoadCart(): string; overload;
function CheckUID(UID: String): boolean;
function UrlEncode(const s: AnsiString): string;
function JsonItemsCount(JsonString: string; path: string): integer;
function ValidateEnText(Text: string): string;

implementation



function ValidateEnText(Text: string): string;
var
  Ac: string; // Accepted Symbols
  tmp, s: string; // temporary string
  i: integer;
begin
  Ac := ' qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  tmp := Text;
  i := 0;
  while i < length(tmp) do
  begin
    s := copy(tmp, i + 1, 1);
    if pos(s, Ac) < 1 then
      Delete(tmp, i + 1, 1)
    Else
      inc(i);
  end;
  Result := tmp;
end;

function JsonItemsCount(JsonString: string; path: string): integer;
var
  JSonValue: TJSonValue;
  i: integer;
  tmp: string;
  lpath, rpath: string;
begin
  Result := 0;
  i := 0;
  try
    // --prepare
    JSonValue := TJSonObject.ParseJSONValue(JsonString);
    lpath := copy(path, 1, pos('[', path));
    rpath := copy(path, pos(']', path), length(path));
    // --do while
    while JSonValue.TryGetValue<string>(lpath + inttostr(i) + rpath, tmp) do
    begin
      inc(i);
    end;
  finally
    Result := i;
  end;
end;

function CheckUID(UID: String): boolean;
var
  web: TWebRequest;
  resp: string;
begin
  web := TWebRequest.Create(false);
  Result := false;
  try
    resp := web.GetStringResponse
      ('https://foods.krossel-apps.ru/checkuid.php?uid=' + UID, nil, true);
    if trim(resp) = UID then
      Result := true
    else
      Result := false;
  finally
    web.Free;
  end;
end;

function LoadCart(): string;
begin
  Result := LoadCart(nil);
end;

function UrlEncode(const s: AnsiString): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(s) do
    case s[i] of
      '%', ' ', '&', '=', '@', '.', #13, #10, #128 .. #255:
        Result := Result + '%' + IntToHex(Ord(s[i]), 2);
    else
      Result := Result + s[i];
    end;
end;

function LoadCart(params: TStrings): String;
var
  ms: TMEmoryStream;
  temp: TStringList;
begin
  temp := TStringList.Create;
  ms := TMEmoryStream.Create;
  try
    try
      LoadCart(nil, ms);
      ms.Position := 0;
      temp.LoadFromStream(ms);
      Result := temp.Text;
    except
      on e: exception do
        Result := e.Message;
    end;
  finally
    temp.Free;
    ms.Free;
  end;
end;

procedure LoadCart(params: TStrings; ms: TStream);
var
  reqstr: String; // Строка запроса
  web: TWebRequest;
begin
  web := TWebRequest.Create(false);
  try
    web.GetStreamResponse('https://foods.krossel-apps.ru/list.php?uid=3', nil,
      true, ms);
  finally
    web.Free;
  end;
end;

end.
