unit frNotify;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Ani, FMX.Effects, FMX.Objects;

type
  TNotify = class(TFrame)
    Background: TRectangle;
    FrameShadow: TShadowEffect;
    Anim: TFloatAnimation;
    Caption: TLabel;
    TextShadow: TShadowEffect;
    procedure AnimProcess(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TNotify.AnimProcess(Sender: TObject);
begin
  Self.Height := Background.Height;
end;

end.
