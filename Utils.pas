unit Utils;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.JSON, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.Objects,
  FMX.Effects, FMX.Ani, FMX.Filter.Effects, Generics.Collections, Methoder,
  Rtti, System.UIConsts;

procedure ExecMethod(MethodName: string; const Args: array of TValue);
procedure ShowNotify(Msg: String); overload;
procedure ShowNotify(Msg: string; Color: string); overload;
procedure HideNotify(Delay: integer);

implementation

uses FoProdList, functions, System.Threading;

procedure ExecMethod(MethodName: string; const Args: array of TValue);
var
  R: TRttiContext;
  T: TRttiType;
  M: TRttiMethod;
begin
  T := R.GetType(TMethodsBook);
  for M in T.GetMethods do
    if (M.Parent = T) and (M.Name = MethodName) then
      M.Invoke(TMethodsBook.Create, Args)
end;

procedure HideNotify(Delay: integer);
var
  task: ITask;
begin
  task := TTask.Create(
    procedure()
    begin
      Sleep(Delay);
      with FoodsForm.frNotify do
      begin
        if not Anim.Inverse then // Если еще не убрали нотификацию
        begin
          Anim.Inverse := true;
          Anim.Start;
        end;
      end;
    end);
  task.Start;
end;

procedure ShowNotify(Msg: string; Color: string);
var
  task: ITask;
begin
  task := TTask.Create(
    procedure()
    begin
      with FoodsForm.frNotify do
      begin
        while not Anim.Inverse do
          HideNotify(1);

        Caption.Text := Msg;
        Background.Fill.Color := StringToAlphaColor(Color);
        Anim.StopValue := Caption.Height + 6;
        Anim.Inverse := false;
        Anim.Start;
      end;
    end);
  task.Start;
  HideNotify(3000);
end;

procedure ShowNotify(Msg: string);
begin
  ShowNotify(Msg, '#FF27AE60');
end;

end.
