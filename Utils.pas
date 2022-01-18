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

procedure ShowNotify(Msg: string; Color: string);
begin
  FoodsForm.NotifyEng.AddQueue(Msg,Color);
end;

procedure ShowNotify(Msg: string);
begin
  ShowNotify(Msg, '#FF27AE60');
end;

end.
