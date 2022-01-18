unit WebHelper;

interface

uses System.Threading, System.SyncObjs, System.SysUtils, System.Types,
  System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, idHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, idGlobal, IdURI;

type
  TWebRequest = class
  private
    { Private declarations }
    inet: TidHTTP;
    isSSL: boolean;
    Id_HandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    function formatURL(url: string): string;
  public
    Constructor Create(isSecure: boolean);
    function GetStringResponse(url: string; params: TStrings;
      isGet: boolean): string;
    procedure GetStreamResponse(url: string; params: TStrings; isGet: boolean;
      ms: TStream);
    { Public declarations }
  end;

implementation
uses functions;

constructor TWebRequest.Create(isSecure: boolean);
begin
  // initialization
  self.isSSL := isSecure;
  inet := TidHTTP.Create;

  // Base Configurations
  inet.HandleRedirects := true;
  inet.Request.UserAgent :=
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
//  inet.CreateIOHandler();
//  inet.IOHandler.DefStringEncoding := IndyTextEncoding(TEncoding.ANSI);
  // SSL Configure
  if isSSL then
  begin
    Id_HandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(inet);
    try
      Id_HandlerSocket.SSLOptions.Mode := sslmClient;
      Id_HandlerSocket.SSLOptions.Method := sslvSSLv23;
      inet.IOHandler := Id_HandlerSocket;
    finally
    end;
  end;
end;

function TWebRequest.formatURL(url: string): string;
var
  s, preUrl: string;
begin
  result := '';
  try
    // Delte HTTP prefix
    preUrl := StringReplace(url, 'http://', '', [rfReplaceAll, rfIgnoreCase]);
    //ƒальше уже работаем с preURL, т.к. возможно изменили url
    preUrl := StringReplace(preUrl, 'https://', '', [rfReplaceAll, rfIgnoreCase]);
    // check for last /
    if copy(preUrl, length(preUrl) - 1, 1) = '/' then
      SetLength(preUrl, (length(preUrl) - 1));
    // Add protocol
    if isSSL then
      preUrl := 'https://' + preUrl
    else
      preUrl := 'http://' + preUrl;
  finally
    result := preUrl;
  end;
end;

procedure TWebRequest.GetStreamResponse(url: string; params: TStrings; isGet: boolean;
  ms: TStream);
var
  reqstr: String; // —трока запроса
begin
  try
    reqstr := formatURL(url);
    if ((params <> nil)and(isGet)) then
    begin
      reqstr := formatURL(url);
      reqstr := reqstr+'?';
      for var param:string in params do
      begin
        reqstr := reqstr+param+'&';
      end;
      SetLength(ReqStr,Length(ReqStr)-1);
    end;
    if isGet then
      inet.Get(TIdURI.URLEncode(ReqStr),ms)
    else inet.Post(TIdURI.URLEncode(ReqStr),params,ms); //params=ы тоже надо кодировать скорее всего
  finally

  end;
end;

function TWebRequest.GetStringResponse(url: string; params: TStrings;
  isGet: boolean): string;
  var ms:TMemoryStream;
      temp:TStringList;
begin
  ms := TMemoryStream.Create;
  temp := TStringList.Create;
  try
    self.GetStreamResponse(url,params,isGet,ms);
    ms.Position := 0;
    temp.LoadFromStream(ms);
    Result := temp.Text;
  finally
    ms.Free;
    temp.Free;
  end;
end;

end.
