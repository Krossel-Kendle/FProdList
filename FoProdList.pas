unit FoProdList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, functions,
  FMX.Controls.Presentation, FMX.StdCtrls, System.JSON, FoodEngine, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.Objects, Prototype, ObjectProvider,
  FMX.Effects, FMX.Ani, FMX.Filter.Effects, frPrimaryButton, FMX.Edit,
  FMX.Colors, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, frPrimaryEdit,
  FMX.VirtualKeyboard, FMX.Platform, FMX.ComboEdit, System.UIConsts,
  System.Threading,{$IFDEF Android} Androidapi.Helpers, FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText,{$ENDIF} frNotify;

type
  TFoodsForm = class(TForm)
    generalBackground: TLayout;
    ClientBack: TRectangle;
    Scroller: TScrollBox;
    WebSync: TTimer;
    VisualSync: TTimer;
    AfterShow: TTimer;
    SubheadBack: TRectangle;
    SubheadShadow: TShadowEffect;
    sbSubHeadExpandButton: TSpeedButton;
    lbHello: TLabel;
    SubheadLayout: TLayout;
    SubheadMenuButtons: TLayout;
    sbSettings: TSpeedButton;
    sbAbout: TSpeedButton;
    SubheadAnimation: TFloatAnimation;
    genColor: TBrushObject;
    GradPrimary: TBrushObject;
    WhiteBackground: TBrushObject;
    DarkBackground: TBrushObject;
    btExit: TSpeedButton;
    Rectangle1: TRectangle;
    WhiteBackGradient: TBrushObject;
    Refresh: TSpeedButton;
    SingleAfterShow: TTimer;
    Generic: TTabControl;
    tiAddFood: TTabItem;
    tiFoods: TTabItem;
    tiSettings: TTabItem;
    batAddFood: TPrimaryButton;
    HeadBack: TRectangle;
    HeadLayout: TLayout;
    Back: TSpeedButton;
    lbSettings: TLabel;
    ShadowEffect1: TShadowEffect;
    sbSaveScroll: TScrollBox;
    KbdLayout: TLayout;
    btSave: TPrimaryButton;
    DeprecatorLayout: TLayout;
    edUser: TPrimaryEdit;
    edUID: TPrimaryEdit;
    rtFoodAdHeader: TRectangle;
    lFoodAddHeader: TLayout;
    sbFoodBack: TSpeedButton;
    lbFoodAddHeaderText: TLabel;
    ShadowEffect2: TShadowEffect;
    btFoodAdd: TPrimaryButton;
    ScrollBox1: TScrollBox;
    rtColorer: TRectangle;
    ShadowEffect4: TShadowEffect;
    lColorer: TLayout;
    Label2: TLabel;
    BadgeColor: TComboColorBox;
    FoodName: TPrimaryEdit;
    FoodComment: TPrimaryEdit;
    SingleColorAccent: TBrushObject;
    frNotify: TNotify;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure VisualSyncTimer(Sender: TObject);
    procedure WebSyncTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AfterShowTimer(Sender: TObject);
    procedure BtAddClick(Sender: TObject);
    procedure SubheadAnimationFinish(Sender: TObject);
    procedure btExitClick(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SingleAfterShowTimer(Sender: TObject);
    procedure sbSettingsClick(Sender: TObject);
    procedure Memo1ChangeTracking(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure DeprecatorLayoutClick(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure edUserEditChangeTracking(Sender: TObject);
    procedure GenericChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FoodNameEditChangeTracking(Sender: TObject);
    procedure btFoodAddButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbAboutClick(Sender: TObject);
    procedure MainHeaderExpander1Click(Sender: TObject);
    procedure frNotifyAnimProcess(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    eng: TFoodEngine;
  end;

var
  FoodsForm: TFoodsForm;
  Cart: TFoodItems;
  FService: IFMXVirtualKeyboardService;

implementation

uses FoAdd, fosets, Utils, Methoder;

{$R *.fmx}

procedure TFoodsForm.AfterShowTimer(Sender: TObject);
begin
  eng.UpdateFoodList;
  VisualSync.Enabled := true;
  AfterShow.Enabled := false;
end;

procedure TFoodsForm.BackClick(Sender: TObject);
begin
  // Generic.SetActiveTabWithTransition(Generic.Tabs[1],);
  Generic.GotoVisibleTab(1);
end;

procedure TFoodsForm.BtAddClick(Sender: TObject);
begin
  // AddForm.Show;
  // btAddFood.Clo
end;

procedure TFoodsForm.btExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFoodsForm.btFoodAddButtonClick(Sender: TObject);
begin
  btFoodAdd.ButtonClick(Sender);
end;

procedure TFoodsForm.Button2Click(Sender: TObject);
begin
  eng := TFoodEngine.Create(3);
  eng.UpdateFoodList;
end;

procedure TFoodsForm.Button3Click(Sender: TObject);
var
  b: Boolean;
begin
  b := checkuid('3');
  b := b;
end;

procedure TFoodsForm.Button4Click(Sender: TObject);
begin
  eng.UpdateFoodList;
end;

procedure TFoodsForm.DeprecatorLayoutClick(Sender: TObject);
begin
  TLayout(Sender).Visible := false;
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
    IInterface(FService));
  if (FService <> nil) then
  begin
    FService.HideVirtualKeyboard;
  end;
end;

procedure TFoodsForm.edUserEditChangeTracking(Sender: TObject);
begin
  edUser.EditChangeTracking(Sender);
  TMemo(Sender).Text := ValidateEnText(TMemo(Sender).Text);
  TMemo(Sender).CaretPosition.Create(0, length(TMemo(Sender).Text));
end;

procedure TFoodsForm.FoodNameEditChangeTracking(Sender: TObject);
begin
  FoodName.EditChangeTracking(Sender);

  var
    task: ITask;
  task := TTask.Create(
    procedure()
    begin
      var
        Colore: String;
      Colore := eng.GetColor(FoodName.Edit.Text);
      if Colore <> '' then
      begin
        Colore := '#' + Colore;
        BadgeColor.Color := StringToAlphaColor(Colore);
      end;
    end);
  task.Start;
end;

procedure TFoodsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  eng.SaveSettings;
end;

procedure TFoodsForm.FormCreate(Sender: TObject);
begin
  // Делаем таскбар таким же цветом, что и хэдер
{$IFDEF Android}
  try
    CallInUIThreadAndWaitFinishing(
      procedure
      begin
        TAndroidHelper.Activity.getWindow.addFlags
          (TJWindowManager_LayoutParams.JavaClass.
          FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        TAndroidHelper.Activity.getWindow.clearFlags
          (TJWindowManager_LayoutParams.JavaClass.FLAG_TRANSLUCENT_STATUS);
        TAndroidHelper.Activity.getWindow.setStatusBarColor($FF6A86A4);
      end);
  except
  end;
{$ENDIF}
end;

procedure TFoodsForm.FormHide(Sender: TObject);
begin
  WebSync.Enabled := false;
  VisualSync.Enabled := false;
end;

procedure TFoodsForm.FormKeyUp(Sender: TObject; var Key: Word;
var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if Generic.TabIndex <> 1 then
    begin
      Generic.GotoVisibleTab(1);
      Key := 0;
    end;
  end;
end;

procedure TFoodsForm.FormShow(Sender: TObject);
begin
  WebSync.Enabled := true;
  AfterShow.Enabled := true;
end;

procedure TFoodsForm.FormVirtualKeyboardHidden(Sender: TObject;
KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if KeyboardVisible then
  begin
    KbdLayout.Height := Bounds.Height;
    DeprecatorLayout.BringToFront;
    DeprecatorLayout.Visible := true;
  end
  else
  begin
    KbdLayout.Height := 0;
    DeprecatorLayout.Visible := false;
  end;
end;

procedure TFoodsForm.FormVirtualKeyboardShown(Sender: TObject;
KeyboardVisible: Boolean; const Bounds: TRect);
begin
  if KeyboardVisible then
  begin
    KbdLayout.Height := Bounds.Height;
    DeprecatorLayout.BringToFront;
    DeprecatorLayout.Visible := true;
  end
  else
  begin
    KbdLayout.Height := 0;
    DeprecatorLayout.Visible := false;
  end;
end;

procedure TFoodsForm.frNotifyAnimProcess(Sender: TObject);
begin
  frNotify.Height := frNotify.Background.Height;
end;

procedure TFoodsForm.GenericChange(Sender: TObject);
begin
  edUser.Edit.Text := eng.Settings.UserName;
  edUID.Edit.Text := IntToStr(eng.Settings.UnionID);
end;

procedure TFoodsForm.MainHeaderExpander1Click(Sender: TObject);
begin
  MainHeaderExpanderClick(Self);
end;

procedure TFoodsForm.Memo1ChangeTracking(Sender: TObject);
begin
  if TMemo(Sender).Lines.Count > 1 then
    TMemo(Sender).Lines.Delete(1);
end;

procedure TFoodsForm.sbAboutClick(Sender: TObject);
begin
  MainHeaderExpanderClick(Self);
end;

procedure TFoodsForm.sbSettingsClick(Sender: TObject);
begin
  MainHeaderExpanderClick(Self);
  Generic.GotoVisibleTab(2);
end;

procedure TFoodsForm.SingleAfterShowTimer(Sender: TObject);
begin
  Cart := TFoodItems.Create;
  eng := TFoodEngine.Create(3);
  lbHello.Text := '' + eng.Settings.UserName;
  SingleAfterShow.Enabled := false;
end;

procedure TFoodsForm.RefreshClick(Sender: TObject);
begin
  eng.NeedRebuild := true;
  ShowNotify('Обновлено!');
end;

procedure TFoodsForm.SubheadAnimationFinish(Sender: TObject);
begin
  sbSubHeadExpandButton.Enabled := true;
  if SubheadAnimation.Inverse = false then
    SubheadMenuButtons.Visible := not SubheadMenuButtons.Visible;
end;

procedure TFoodsForm.VisualSyncTimer(Sender: TObject);
begin
  if eng.NeedRebuild then
  begin
    Cart.Build;
    eng.NeedRebuild := false;
  end;
end;

procedure TFoodsForm.WebSyncTimer(Sender: TObject);
begin
  eng.UpdateFoodList;
end;

end.
