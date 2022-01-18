unit fosets;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Layouts, FMX.Effects, FMX.Objects, FMX.ListBox, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.Ani, FoProdList, functions,
  FMX.VirtualKeyboard, FMX.Platform;

type
  TfoSettings = class(TForm)
    HeadBack: TRectangle;
    HeadLayout: TLayout;
    ClientBack: TRectangle;
    Scroller: TScrollBox;
    Back: TSpeedButton;
    lbSettings: TLabel;
    lUIDInput: TLayout;
    lNameInput: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    edUID: TEdit;
    edName: TEdit;
    FooterBack: TRectangle;
    BtAdd: TSpeedButton;
    GenGradColor: TGradientAnimation;
    Layout1: TLayout;
    lbUIDWhat: TLabel;
    SubheadShadow: TShadowEffect;
    rtUIDInput: TRectangle;
    seUID: TShadowEffect;
    rtNameInput: TRectangle;
    seName: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    KbdLayout: TLayout;
    gShadow: TRectangle;
    ShadowHide: TTimer;
    procedure lbUIDWhatClick(Sender: TObject);
    procedure BtAddClick(Sender: TObject);
    procedure edNameChange(Sender: TObject);
    procedure edUIDChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edUIDClick(Sender: TObject);
    procedure edNameClick(Sender: TObject);
    procedure gShadowMouseEnter(Sender: TObject);
    procedure ShadowHideTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foSettings: TfoSettings;
  FService: IFMXVirtualKeyboardService;

implementation

{$R *.fmx}

procedure TfoSettings.BackClick(Sender: TObject);
begin
  Close;
end;

procedure TfoSettings.BtAddClick(Sender: TObject);
begin
  Close;
end;

procedure TfoSettings.edNameChange(Sender: TObject);
begin
  FoodsForm.eng.Settings.UserName := TEdit(Sender).Text;
end;

procedure TfoSettings.edNameClick(Sender: TObject);
begin
  gShadow.Visible := true;
  gShadow.BringToFront;
  rtNameInput.BringToFront;
end;

procedure TfoSettings.edUIDChange(Sender: TObject);
begin
  if CheckUID(TEdit(Sender).Text) then
    FoodsForm.eng.Settings.UnionID := StrToInt(TEdit(Sender).Text)
  else
  begin
    ShowMessage('Union ID не найден.');
    TEdit(Sender).Text := IntToStr(FoodsForm.eng.Settings.UnionID);
  end;
  gShadow.Visible := false;
end;

procedure TfoSettings.edUIDClick(Sender: TObject);
begin
  gShadow.Visible := true;
  gShadow.BringToFront;
  rtUIDInput.BringToFront;
end;

procedure TfoSettings.FormShow(Sender: TObject);
begin
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
    IInterface(FService));
  edUID.Text := IntToStr(FoodsForm.eng.Settings.UnionID);
  edName.Text := FoodsForm.eng.Settings.UserName;
  gShadow.Height := Screen.Height * 2;
  gShadow.Width := Screen.Width;
end;

procedure TfoSettings.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if KeyboardVisible then
    KbdLayout.Height := Bounds.Height
  else
  begin
    KbdLayout.Height := 0;
    gShadow.Visible := false;
  end;
end;

procedure TfoSettings.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if KeyboardVisible then
    KbdLayout.Height := Bounds.Height
  else
  begin
    KbdLayout.Height := 0;
    gShadow.Visible := false;
  end;
end;

procedure TfoSettings.gShadowMouseEnter(Sender: TObject);
begin
  ShadowHide.Enabled:=true;
end;

procedure TfoSettings.lbUIDWhatClick(Sender: TObject);
begin
  ShowMessage
    ('Union ID - это "идентификатор объединения". Вы можете ввести такой же на других устройствах для синхронизации списка покупок.');
end;

procedure TfoSettings.ShadowHideTimer(Sender: TObject);
begin
  FService.HideVirtualKeyboard;
  KbdLayout.Height := 0;
  TRectangle(Sender).Visible := false;
  ShadowHide.Enabled:=false;
end;

end.
