unit NotifyEngine;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.JSON, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.Objects,
  FMX.Effects, FMX.Ani, FMX.Filter.Effects, Generics.Collections, Methoder,
  Rtti, System.UIConsts, System.SyncObjs, System.Threading;

type
  RNotify = record
    Text: String;
    Color: String;
    Delay: integer;
  end;

type
  TNotifyEngine = class
  private
    RQueue: array of RNotify;
    DoQueueTask: ITask;
    isProcessing: boolean;
    procedure MakeTasks;
    procedure ShowNotify(pMsg: string; pColor: string);
    procedure HideNotify;
    procedure RemoveLastNotify;
    function FindDuplicates(Msg: string): boolean;
  public
    constructor Create;
    procedure AddQueue(pMessage: String; pColor: String;
      pDelay: integer); overload;
    procedure AddQueue(pMessage: String; pColor: String); overload;
    procedure AddQueue(pMessage: String; pDelay: integer); overload;
    procedure AddQueue(pMessage: String); overload;
    procedure DoQueue;
  end;

implementation

uses FoProdList, functions;

procedure TNotifyEngine.MakeTasks; // Создаем нужные нам задачи
begin
  DoQueueTask := TTask.Create( // Задача по обработке очереди уведомлений
    procedure()
    begin
      while length(RQueue) > 0 do
      begin
        TThread.Synchronize(nil,
          procedure()
          begin
            ShowNotify(RQueue[0].Text, RQueue[0].Color);
          end);
        if RQueue[0].Delay > 1000 then
          Sleep(RQueue[0].Delay)
        else
          Sleep(3000);
        TThread.Synchronize(nil,
          procedure()
          begin
            HideNotify;
            RemoveLastNotify;
          end);
        Sleep(300); // Даем анимации проиграть
      end;
      isProcessing := false;
    end);
end;

constructor TNotifyEngine.Create;
begin
  SetLength(RQueue, 0); // Инициализируем массив
  isProcessing := false; // И переменную
end;

function TNotifyEngine.FindDuplicates(Msg: string): boolean;
begin
  Result := false;
  for var I := 0 to length(RQueue) - 1 do
    if Msg = RQueue[I].Text then
      Result := true;
end;

procedure TNotifyEngine.RemoveLastNotify;
// Удаляет последнее уведомление из очереди
var
  I: integer;
begin
  if length(RQueue) >= 2 then
  begin
    for I := 1 to length(RQueue) - 1 do
      RQueue[I - 1] := RQueue[I];
    SetLength(RQueue, length(RQueue) - 1);
  end
  else
    SetLength(RQueue, 0);
end;

procedure TNotifyEngine.HideNotify; // Скрывает визуальное уведомление
begin
  with FoodsForm.frNotify do
  begin
    Caption.Text := '';
    Anim.Inverse := true;
    Anim.Start;
  end;
end;

procedure TNotifyEngine.ShowNotify(pMsg: string; pColor: string);
// Показывает визуальное уведомление
begin
  with FoodsForm.frNotify do
  begin
    Caption.Visible := false;
    Caption.Text := pMsg;
    Background.Fill.Color := StringToAlphaColor(pColor);
    Anim.StopValue := Caption.Height + 6;
    Anim.Inverse := false;
    Anim.Start;
  end;
end;

procedure TNotifyEngine.AddQueue(pMessage: string; pColor: string;
// Добавляет в очередь
pDelay: integer);
begin
  if not FindDuplicates(pMessage) then
  begin
    SetLength(RQueue, length(RQueue) + 1);
    with RQueue[length(RQueue) - 1] do
    begin
      Text := pMessage;
      Color := pColor;
      Delay := pDelay;
    end;
  end;
  DoQueue(); // Запускаем задачу по обработке очереди, если она еще не запущена
end;

procedure TNotifyEngine.AddQueue(pMessage: string; pColor: string);
begin
  AddQueue(pMessage, pColor, 3000);
end;

procedure TNotifyEngine.AddQueue(pMessage: string; pDelay: integer);
begin
  AddQueue(pMessage, '#FF27AE60', pDelay);
end;

procedure TNotifyEngine.AddQueue(pMessage: string);
begin
  AddQueue(pMessage, '#FF27AE60', 3000);
end;

procedure TNotifyEngine.DoQueue;
begin
  if not isProcessing then // Если задача по обработке очереди не выполняется
  begin
    MakeTasks; // Создаем задачу
    isProcessing := true; // Говорим, что она выполняется
    DoQueueTask.Start; // Выполняем ее.
  end;
end;

end.
