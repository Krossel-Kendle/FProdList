unit FoAdd;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Effects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Filter.Effects, FMX.DialogService, FMX.VirtualKeyboard, FMX.Platform,
  FMX.Colors, System.UIConsts;

type
  TAddForm = class(TForm)
    HeaderBack: TRectangle;
    ClientBack: TRectangle;
    Scroller: TScrollBox;
    Protoback: TRectangle;
    ProtoShadow: TShadowEffect;
    Backpack: TLayout;
    FoodName: TEdit;
    AddLabel: TLabel;
    ShadowEffect1: TShadowEffect;
    lbHeader: TLabel;
    SpeedButton1: TSpeedButton;
    FillRGBEffect1: TFillRGBEffect;
    Rectangle1: TRectangle;
    ShadowEffect2: TShadowEffect;
    Layout1: TLayout;
    Comment: TEdit;
    Label1: TLabel;
    Author: TLabel;
    Rectangle2: TRectangle;
    ShadowEffect3: TShadowEffect;
    SpeedButton2: TSpeedButton;
    Btns: TLayout;
    BadgeColor: TComboColorBox;
    Rectangle3: TRectangle;
    ShadowEffect4: TShadowEffect;
    Layout2: TLayout;
    Label2: TLabel;
    BoardShow: TTimer;
    LBox2: TLang;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FoodNameChange(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure BoardShowTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddForm: TAddForm;
  FService: IFMXVirtualKeyboardService;
  CurrEdit: TObject;

implementation

uses FoProdList;

{$R *.fmx}

procedure TAddForm.BoardShowTimer(Sender: TObject);
begin
TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
  if (FService <> nil) then
  begin
    FService.HideVirtualKeyboard;
    FService.ShowVirtualKeyboard(TFmxObject(CurrEdit));
  //  edit.SetFocus;
  end;
  boardshow.Enabled:=false;
end;

procedure TAddForm.FoodNameChange(Sender: TObject);
begin
  CurrEdit := Comment;
  boardshow.Enabled:=true;
end;

procedure TAddForm.FormShow(Sender: TObject);
begin
  Author.Text := string(FoodsForm.eng.Settings.UserName) + ' добавит товар';
 // foodName.SetFocus;
  //CurrEdit := FoodName;
  //BoardShow.Enabled := true;
end;

procedure TAddForm.SpeedButton1Click(Sender: TObject);
begin
  TDialogService.MessageDialog('—охран€ем?', TMsgDlgType.mtConfirmation,
    mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      if (AResult = mrYes) then
      begin
        FoodsForm.eng.AddFood(FoodName.Text, Comment.Text,AlphaColorToString(BadgeColor.Color));
        FoodName.Text := '';
        Comment.Text := '';
        AddForm.Close;
      end;
    end);
end;

procedure TAddForm.SpeedButton2Click(Sender: TObject);
begin
//SpeedButton1Click(self);
TDialogservice.InputQuery('¬ведите что-нибудь', ['¬вод чего-нибудь'], [''],
    procedure(const AResult: TModalResult; const AValues: array of string)
      begin
        case AResult of
          mrOk:
             ShowMessage('12');//result:=AValues[0];
          mrCancel:
             ShowMessage('1');//result:='¬вод чего-нибудь отменен';
        end;
      end
    );
end;

end.
