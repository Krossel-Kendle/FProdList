program FProdCart;

uses
  System.StartUpCopy,
  FMX.Forms,
  FoProdList in 'FoProdList.pas' {FoodsForm},
  functions in 'functions.pas',
  Utils in 'Utils.pas',
  WebHelper in 'WebHelper.pas',
  FoodEngine in 'FoodEngine.pas',
  Prototype in 'Prototype.pas' {FProtoComposed},
  ObjectProvider in 'ObjectProvider.pas',
  Decomposed in 'Decomposed.pas' {fElement},
  frPrimaryButton in 'frames\frPrimaryButton.pas' {PrimaryButton: TFrame},
  Methoder in 'Methoder.pas',
  frPrimaryEdit in 'frames\frPrimaryEdit.pas' {PrimaryEdit: TFrame},
  frMenuItem in 'frames\frMenuItem.pas' {flElement: TFrame},
  frNotify in 'frames\frNotify.pas' {Notify: TFrame},
  ColorEngine in 'ColorEngine.pas',
  NotifyEngine in 'NotifyEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFoodsForm, FoodsForm);
  Application.CreateForm(TFProtoComposed, FProtoComposed);
  Application.CreateForm(TFProto, FProto);
  Application.Run;
end.
