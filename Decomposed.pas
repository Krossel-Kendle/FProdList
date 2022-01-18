unit Decomposed;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Objects, FMX.Ani;

type
  TFProto = class(TForm)
    Protoback: TRectangle;
    ProtoBar: TLayout;
    PrtotoTrash: TSpeedButton;
    ProtoClient: TScrollBox;
    ProtoName: TSpeedButton;
    ProtoComment: TLabel;
    ProtoPin: TLayout;
    ProtoPinSub: TRectangle;
    ProtoPinPro: TRectangle;
    ProtoAnim: TFloatAnimation;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FProto: TFProto;

implementation
  uses FoProdList;

{$R *.fmx}

end.
