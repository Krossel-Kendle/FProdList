unit frPrimaryEdit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Objects, Utils, FMX.Edit,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.VirtualKeyboard,
  FMX.Platform;

type
  TPrimaryEdit = class(TFrame)
    Background: TRectangle;
    Shadow: TShadowEffect;
    Header: TLayout;
    Caption: TLabel;
    Help: TLabel;
    Edit: TMemo;
    procedure HelpClick(Sender: TObject);
    procedure EditChangeTracking(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FService: IFMXVirtualKeyboardService;

implementation

uses FoProdList;

{$R *.fmx}

procedure TPrimaryEdit.HelpClick(Sender: TObject);
begin
  ShowMessage(TLabel(Sender).Hint);
end;

procedure TPrimaryEdit.EditChangeTracking(Sender: TObject);
begin
  if TMemo(Sender).Lines.Count > 1 then
  begin
    TMemo(Sender).Lines.Delete(1);
    TPlatformServices.Current.SupportsPlatformService
      (IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) then
    begin
      FService.HideVirtualKeyboard;
    end;
  end;
end;

end.
