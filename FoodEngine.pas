unit FoodEngine;

interface

uses System.Threading, System.SyncObjs, System.SysUtils, System.Types,
  System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, idHTTP, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, System.JSON, System.UIConsts;

type
  RFood = Record
    id: integer;
    lid: integer;
    name: string;
    comment: string;
    user: string;
    color: string;
    datetime: TDateTime;
  End;

type
  RSettings = record
    Host: string[180];
    UnionID: integer;
    UserName: string[180];
    LastSync: TDateTime;
    color: array [0 .. 255] of string[18];
  end;

type
  AppSets = record
    AppLang: string[10];
    AppTheme: string[30];
  end;

type
  AppSettings = class
  public
    Sets: AppSets;
    procedure save();
    procedure load();
  end;

type
  TFoodEngine = class
  private
    UID: integer;
    Colors: array of array of string;

    procedure LoadSettings;
    procedure LoadColours;
    function GetUnionID(): integer;
    procedure removelocal(id: integer);
    procedure AddLocal(val: string; comm: string; lidx: integer);
    procedure ReadDump();
  public
    Foods: array of RFood;
    OldFoods: array of RFood;
    Settings: RSettings;
    tt: string; // Для отладки
    NeedRebuild: boolean;
    constructor Create; overload;
    constructor Create(UnID: integer); overload;
    procedure SaveSettings();
    procedure SaveColours();
    procedure UpdateFoodList();
    function AddColor(Food: String; color: TAlphaColor): boolean;
    function GetColor(Food: string): string;
    procedure AddFood(name: string; comment: string; color: string); overload;
    procedure AddFood(name: string; comment: string;
      color: TAlphaColor); overload;
    procedure AddFood(name: string; comment: string); overload;
    procedure AddFood(name: string); overload;
    procedure RemoveFood(id: integer);
    procedure WebSync(url: string; params: TStrings; isGet: boolean;
      ProcUpdate: boolean); overload;
    procedure WebSync(url: string; isGet: boolean;
      ProcUpdate: boolean); overload;
    procedure WebSync(url: string; ProcUpdate: boolean); overload;
    procedure NotifyAndUpdate(resp: string);
    function GetAddictInfoByID(id: integer): string;
    function GenerateID(): integer;
    function OldFound(id: integer): boolean;
    function FoodFound(id: integer): boolean;
    // Ищет в массиве со старой едой указанный индекс
  end;

implementation

uses Utils, WebHelper, functions;

procedure AppSettings.save;
begin

end;

procedure AppSettings.load;
begin

end;

// --FOODENGINE

constructor TFoodEngine.Create;
begin
  LoadSettings;
  LoadColours;

  // ReadDump;
end;

constructor TFoodEngine.Create(UnID: integer);
begin
  UID := UnID;
  LoadSettings;
  LoadColours;
  // ReadDump;
end;

procedure TFoodEngine.SaveColours;
begin
  try
    // FoodColour.LoadFromFile(GetHomePath + '/colours.dat');
  finally

  end;
end;

procedure TFoodEngine.LoadColours;
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

function TFoodEngine.AddColor(Food: string; color: TAlphaColor): boolean;
var
  JSON: TJSONObject;
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
      if Colors[1][I] = Food then
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

function TFoodEngine.GetColor(Food: string): string;
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

procedure TFoodEngine.ReadDump; // Генерит исключения
begin
  // // Читаем в foods
  // for var I := 0 to Length(Settings.FoodsDump) - 1 do
  // if Settings.FoodsDump[I].id > 0 then
  // begin
  // SetLength(Foods, I + 1);
  // Foods[I] := Settings.FoodsDump[I];
  // end;
  // // Читаем в OldFoods
  // for var I := 0 to Length(Settings.OldFoodsDump) - 1 do
  // if Settings.OldFoodsDump[I].id > 0 then
  // begin
  // SetLength(OldFoods, I + 1);
  // OldFoods[I] := Settings.OldFoodsDump[I];
  // end;
end;

function TFoodEngine.GetAddictInfoByID(id: integer): string;
begin
  Result := '';
  for var I := 0 to length(Foods) - 1 do
    if Foods[I].id = id then
    begin
      Result := 'Добавлено ' + FormatDateTime('dd.mm.yyyy в hh:mm',
        Foods[I].datetime) + ' пользователем ' + Foods[I].user;
      break;
    end;
end;

procedure TFoodEngine.AddLocal(val: string; comm: string; lidx: integer);
begin
  try
    SetLength(Foods, length(Foods) + 1);
    Foods[length(Foods) - 1].id := -1;
    Foods[length(Foods) - 1].lid := lidx;
    Foods[length(Foods) - 1].name := val;
    Foods[length(Foods) - 1].user := Settings.UserName;
    Foods[length(Foods) - 1].comment := comm;
    Foods[length(Foods) - 1].datetime := now;
  finally
    NeedRebuild := true;
  end;
end;

procedure TFoodEngine.removelocal(id: integer);
begin
  try
    for var I := 0 to length(Foods) - 1 do
      if Foods[I].id = id then
      begin
        // ---Add to oldfoods
        var
          OldCnt: integer; // количество устаревших
        OldCnt := length(OldFoods);
        inc(OldCnt);
        SetLength(OldFoods, OldCnt);
        OldFoods[OldCnt - 1] := Foods[I];
        OldFoods[OldCnt - 1].datetime := now;
        // --empty Array
        for var j := I to length(Foods) - 1 do
          if j < (length(Foods) - 1) then
            Foods[j] := Foods[j + 1];
        SetLength(Foods, length(Foods) - 1);
        break;
      end;
  finally
    NeedRebuild := true;
  end;
end;

function TFoodEngine.OldFound(id: integer): boolean;
begin
  Result := false;
  for var I := 0 to length(OldFoods) - 1 do
    if id = OldFoods[I].id then
    begin
      Result := true;
      break;
    end;
end;

function TFoodEngine.FoodFound(id: integer): boolean;
begin
  Result := false;
  for var I := 0 to length(Foods) - 1 do
    if id = Foods[I].id then
    begin
      Result := true;
      break;
    end;
end;

function TFoodEngine.GenerateID(): integer;
var
  I: integer;
  b: boolean;
  j: integer;
begin
  b := false;
  while not(b) do
  begin
    I := Random(999999999);
    b := true;
    for j := 0 to length(Foods) - 1 do
    begin
      if Foods[j].lid = I then
        b := false;
    end;
  end;
  Result := I;
end;

procedure TFoodEngine.NotifyAndUpdate(resp: string);
begin
  // --TODO Notify
  // ShowMessage(resp);
  // --END TODO
  UpdateFoodList;
end;

procedure TFoodEngine.WebSync(url: string; params: TStrings; isGet: boolean;
  ProcUpdate: boolean); // Для выполнения событий add и remove
var
  task: ITask;
  tp: TStrings;
begin
  tp := TStringList.Create;
  tp.Assign(params);
  task := TTask.Create(
    procedure()
    begin
      var
        wr: TWebRequest;
      var
        temp: TStringList;
      var
        resp: String;
      wr := TWebRequest.Create(false);
      temp := TStringList.Create;
      try
        if params <> nil then
        begin
          temp.Assign(tp);
          resp := wr.GetStringResponse(url, temp, isGet);
        end
        else
          resp := wr.GetStringResponse(url, nil, isGet);
        if ProcUpdate then
          NotifyAndUpdate(resp);
      finally
        temp.Free;
        wr.Free;
        tp.Free;
      end;
    end);
  task.Start;
end;

procedure TFoodEngine.WebSync(url: string; isGet: boolean; ProcUpdate: boolean);
begin
  WebSync(url, nil, isGet, ProcUpdate);
end;

procedure TFoodEngine.WebSync(url: string; ProcUpdate: boolean);
begin
  WebSync(url, nil, true, ProcUpdate);
end;

procedure TFoodEngine.AddFood(name: string; comment: string; color: string);
var
  resp: String;
  temp: TStringList;
  lidx: integer;
begin
  temp := TStringList.Create;
  try
    // AddLocal
    lidx := self.GenerateID;
    AddLocal(name, comment, lidx);
    var
      ARec: TAlphaColorRec;
    ARec.color := StringToAlphaColor(color);
    // SyncPreparetaion
    temp.Add('uid=' + Settings.UnionID.ToString);
    temp.Add('val=' + name);
    temp.Add('user=' + Settings.UserName);
    temp.Add('comm=' + comment);
    temp.Add('color=' + intToHex(integer(ARec.A), 1) + intToHex(integer(ARec.R),
      1) + intToHex(integer(ARec.G), 1) + intToHex(integer(ARec.b), 1));
    temp.Add('lidx=' + inttostr(lidx));
    WebSync(Settings.Host + 'add.php', temp, true, true);
  finally
    temp.Free;
  end;
end;

procedure TFoodEngine.AddFood(name: string; comment: string;
color: TAlphaColor);
begin
  AddFood(name, comment, AlphaColorToString(color));
end;

procedure TFoodEngine.AddFood(name: string; comment: string);
begin
  AddFood(name, comment, 'nill');
end;

procedure TFoodEngine.AddFood(name: string);
begin
  AddFood(name, 'null', 'nill');
end;

procedure TFoodEngine.RemoveFood(id: integer);
var
  resp: String;
  temp: TStringList;
begin
  temp := TStringList.Create;
  try
    if id > 0 then
    begin
      // RemoveLocal
      removelocal(id);
      // SyncPreparetaion
      temp.Add('uid=' + Settings.UnionID.ToString);
      temp.Add('idx=' + inttostr(id));
      WebSync(Settings.Host + 'rem.php', temp, true, true);
    end;
  finally
    temp.Free;
  end;
end;

function TFoodEngine.GetUnionID: integer;
var
  wr: TWebRequest;
  preUID: String;
begin
  Result := -1;
  wr := TWebRequest.Create(false);
  try
    preUID := wr.GetStringResponse(Settings.Host + 'getuid.php', nil, true);
    if TryStrToInt(trim(preUID), Result) = false then
      raise Exception.Create('UID hasn''t got.');
  finally
    wr.Free;
  end;
end;

procedure TFoodEngine.LoadSettings;
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    if fileexists(GetHomePath + '/settings.dat') then
      ms.LoadFromFile(GetHomePath + '/settings.dat')
    else // Если нет дампа настроек, генерируем новые
    begin
      with Settings do
      begin
        Host := 'http://foods.krossel-apps.ru/';
        UserName := 'Anonymous';
        LastSync := now;
        if UID <> 0 then
          UnionID := UID
        else
          UnionID := GetUnionID;
        // Для colors проставляем значения
        for var I := 0 to 255 do
        begin
          color[I] := '';
        end;
      end;
      SaveSettings;
    end;
    ms.LoadFromFile(GetHomePath + '/settings.dat');
    ms.Position := 0;
    ms.ReadBuffer(Settings, SizeOf(Settings)); // Возможно надо 0
  finally
    ms.Free;
  end;
end;

procedure TFoodEngine.SaveSettings;
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.WriteBuffer(Settings, SizeOf(Settings));
    ms.SaveToFile(GetHomePath + '/settings.dat');
  finally
    ms.Free;
  end;
end;

procedure TFoodEngine.UpdateFoodList;
var
  task: ITask;
  TMPFoods: array of RFood; // Временные Food
begin
  NeedRebuild := false;
  task := TTask.Create(
    procedure()
    begin
      var
        wr: TWebRequest; // Обработчик веб запросов
      var
        params: TStringList; // Параметры запроса (Передается UID)
      var
        temp: TStringList; // Принимающий массив строк
      var
        ms: TMemoryStream; // Поток, в который пишется весь рещультат
      var
        response: string; // Конечная json строка
      var
        fs: TFormatSettings; // Формат времени для парсера
      var
        JSonValue: TJSonValue; // JSON парсер
      wr := TWebRequest.Create(false);
      temp := TStringList.Create;
      params := TStringList.Create;
      ms := TMemoryStream.Create;
      try
        // Prepare params and get data
        params.Add('uid=' + inttostr(Settings.UnionID));
        wr.GetStreamResponse(Settings.Host + 'list.php', params, true, ms);
        ms.Position := 0;
        // Work with Stream
        temp.LoadFromStream(ms);
        response := '{"result":' + temp.Text + '}';
        // Потому что PHP JSON и DELPHI JSON отличаются
        // Work with parser
        try
          JSonValue := TJSONObject.ParseJSONValue(response);
          // TEMP load
          // prepare datesettings
          fs := TFormatSettings.Create;
          fs.DateSeparator := '-';
          fs.ShortDateFormat := 'yyyy-MM-dd';
          fs.TimeSeparator := ':';
          fs.ShortTimeFormat := 'hh:mm';
          fs.LongTimeFormat := 'hh:mm:ss';
          // start loader
          SetLength(TMPFoods, JsonItemsCount(response, 'result[].name'));
          for var I := 0 to JsonItemsCount(response, 'result[].name') - 1 do
          begin
            TryStrToInt(JSonValue.GetValue<string>('result[' + inttostr(I) +
              '].foodid'), TMPFoods[I].id);
            TryStrToInt(JSonValue.GetValue<string>('result[' + inttostr(I) +
              '].localid'), TMPFoods[I].lid);
            // tt := JSonValue.GetValue<string>('result[' +
            // inttostr(I) + '].name');
            TMPFoods[I].name := (JSonValue.GetValue<string>('result[' +
              inttostr(I) + '].name'));
            tt := String(TMPFoods[I].name);
            TMPFoods[I].comment := JSonValue.GetValue<string>('result[' +
              inttostr(I) + '].comment');
            TMPFoods[I].user := JSonValue.GetValue<string>('result[' +
              inttostr(I) + '].by_user');
            TMPFoods[I].color := JSonValue.GetValue<string>('result[' +
              inttostr(I) + '].COLOR_CODE');
            TMPFoods[I].datetime :=
              StrToDateTime(JSonValue.GetValue<string>('result[' + inttostr(I) +
              '].CHANGEDATETIME'), fs);
            // END OF Datetime
          end;
          // Compare foods
          if length(TMPFoods) = length(Foods) then
          begin
            for var I := 0 to length(Foods) - 1 do
              if (TMPFoods[I].id <> Foods[I].id) then
              begin
                NeedRebuild := true;
                break;
              end;
          end
          else
            NeedRebuild := true;
          // Install new foods
          if NeedRebuild then
          begin
            SetLength(Foods, length(TMPFoods));
            for var I := 0 to length(Foods) - 1 do
            begin
              Foods[I] := TMPFoods[I];
            end;
          end;
        finally
        end;
      finally
        wr.Free;
        params.Free;
        temp.Free;
        ms.Free;
        JSonValue.Free;
      end;
      // Обновление элементов на форме
    end);
  task.Start;
end;

end.
