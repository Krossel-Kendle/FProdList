unit frPrimaryButton;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Objects, Utils;

type
  TPrimaryButton = class(TFrame)
    Background: TRectangle;
    Button: TSpeedButton;
    Shadow: TShadowEffect;
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    Method:string;
    { Public declarations }
  end;

implementation
  uses FoProdList;
{$R *.fmx}


procedure TPrimaryButton.ButtonClick(Sender: TObject);
begin
  ExecMethod(self.Hint,[]);
end;

end.
