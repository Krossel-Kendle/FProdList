unit Prototype;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Objects, FMX.Ani;

type
  TFProtoComposed = class(TForm)
    Protoback: TRectangle;
    PrtotoTrash: TSpeedButton;
    ProtoBar: TLayout;
    ProtoClient: TScrollBox;
    ProtoName: TSpeedButton;
    ProtoPin: TLayout;
    ProtoComment: TLabel;
    ProtoPinPro: TRectangle;
    ProtoPinSub: TRectangle;
    ProtoAnim: TFloatAnimation;
    procedure PrtotoTrashClick(Sender: TObject);
    procedure ProtoPinProClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProtoComposed: TFProtoComposed;

implementation
uses FoProdList;

{$R *.fmx}

procedure TFProtoComposed.ProtoPinProClick(Sender: TObject);
begin
  ShowMessage(FoodsForm.eng.GetAddictInfoByID(Tag));
end;

procedure TFProtoComposed.PrtotoTrashClick(Sender: TObject);
begin
  FoodsForm.eng.RemoveFood(Tag);
end;

end.
