unit frMenuItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Ani, FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, System.UIConsts;

type
  TflElement = class(TFrame)
    Back: TRectangle;
    RBar: TLayout;
    sbPrimary: TSpeedButton;
    CBar: TScrollBox;
    lbName: TSpeedButton;
    lbComment: TLabel;
    LBar: TLayout;
    PinSub: TRectangle;
    PinPro: TRectangle;
    Anim: TFloatAnimation;
    procedure sbPrimaryClick(Sender: TObject);
    procedure AnimFinish(Sender: TObject);
    procedure PinProClick(Sender: TObject);
  private
    { Private declarations }
  public
    isDeleted: boolean;
    itemID: integer;
    procedure MakeDeleted();
    procedure Init;
    { Public declarations }
  end;

implementation

uses FoProdList, Utils;

{$R *.fmx}

procedure TflElement.Init;
begin
  Self.BeginUpdate;
  // Making Deleted if needed
  if isDeleted then
    MakeDeleted();
  // Naming labels
  if isDeleted then
  begin
    lbName.Text := FoodsForm.eng.OldFoods[itemID].Name;
    lbComment.Text := FoodsForm.eng.OldFoods[itemID].Comment;
  end
  else
  begin
    self.lbName.Text := FoodsForm.eng.Foods[itemID].Name;
    self.lbComment.Text := FoodsForm.eng.Foods[itemID].Comment;
  end;
  // Colorize Pin's
  var
    PinProColor: string;
  if isDeleted then
    PinProColor := '#' + FoodsForm.eng.OldFoods[itemID].color
  else
    PinProColor := '#' + FoodsForm.eng.Foods[itemID].color;
  if length(PinProColor) > 4 then
    try
      PinPro.Fill.color := StringToAlphaColor(PinProColor);
      var
        PinSubColor: TAlphaColorRec;
      PinSubColor.color := StringToAlphaColor(PinProColor); // Присваиваем цвет
      PinSubColor.A := Byte(trunc(integer(PinSubColor.A) / 3));
      // Делаем полупрозрачным
      PinSub.Fill.color := PinSubColor.color;
    except
    end;
  Anim.Inverse := isDeleted;
  self.EndUpdate;
end;

procedure TflElement.AnimFinish(Sender: TObject);
begin
  if not TFloatAnimation(Sender).Inverse then
  begin
    if isDeleted then
      FoodsForm.eng.AddFood(lbName.Text, lbComment.Text, PinPro.Fill.color)
    else
      FoodsForm.eng.RemoveFood(Tag);
  end;
end;

procedure TflElement.MakeDeleted;
begin
  sbPrimary.StyleLookup := 'refreshtoolbutton';
end;

procedure TflElement.PinProClick(Sender: TObject);
begin
  if isDeleted then
    ShowNotify('Удалено: ' + DateToStr(FoodsForm.eng.OldFoods[itemID]
      .datetime))
  else
    ShowNotify(FoodsForm.eng.GetAddictInfoByID(Self.Tag));
end;

procedure TflElement.sbPrimaryClick(Sender: TObject);
begin
  Anim.Start;
  sbPrimary.Enabled := false;
end;

end.
