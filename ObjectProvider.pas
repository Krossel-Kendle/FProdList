unit ObjectProvider;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.JSON, FoodEngine, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.Objects, FMX.Effects, Decomposed, FMX.Ani,
  System.UIConsts;

type
  TFoodItem = class
  public
    Back: TRectangle;
    Anim: TFloatAnimation;
    Bar: TLayout;
    Trash: TSpeedButton;
    Client: TScrollbox;
    Name: TSpeedButton;
    Comment: TLabel;
    Pin: TLayout;
    PinPro: TRectangle;
    PinSub: TRectangle;
    id: integer;
    itemID: integer;
    isDeleted: boolean;
    constructor Create(idx: integer; pdx: integer; isDel: boolean); overload;
    constructor Create(idx: integer; pdx: integer); overload;
    destructor Destroy();
    procedure TrashClick(Sender: TObject);
    procedure Animfinish(Sender: TObject);
    procedure PinProClick(Sender: TObject);
  end;

type
  TFoodItems = class
  private
    Foode: array of TFoodItem;
    OldFoode: Array of TFoodItem;
  public
    procedure Build;
  end;

implementation

uses FoProdList, functions, Utils;

constructor TFoodItem.Create(idx: integer; pdx: integer; isDel: boolean);
var
  M: TMethod;
begin
  // base
  self.id := idx;
  itemID := pdx;
  isDeleted := isDel;
  // cloning
  Back := TRectangle(FProto.Protoback.Clone(FoodsForm.Scroller));
  Anim := TFloatAnimation(FProto.ProtoAnim.Clone(Back));
  Bar := TLayout(FProto.ProtoBar.Clone(Back));
  Trash := TSpeedButton(FProto.PrtotoTrash.Clone(Bar));
  Client := TScrollbox(FProto.ProtoClient.Clone(Back));
  Name := TSpeedButton(FProto.ProtoName.Clone(Client));
  Comment := TLabel(FProto.ProtoComment.Clone(Client));
  Pin := TLayout(FProto.ProtoPin.Clone(Back));
  PinPro := TRectangle(FProto.ProtoPinPro.Clone(Pin));
  PinSub := TRectangle(FProto.ProtoPinSub.Clone(Pin));
  // SettingUp TAG
  Trash.Tag := idx;
  name.Tag := idx;
  Back.Tag := idx;
  PinPro.Tag := idx;
  Anim.Tag := idx;
  // Configurating
  // --Parents
  Back.Parent := FoodsForm.Scroller;
  Anim.Parent := Back;
  Bar.Parent := Back;
  Client.Parent := Back;
  Pin.Parent := Back;
  Trash.Parent := Bar;
  Comment.Parent := Client;
  Name.Parent := Client;
  PinSub.Parent := Pin;
  PinPro.Parent := Pin;
  // --Naming by pdx
  if isDel then
  begin
    Name.Text := FoodsForm.eng.OldFoods[itemID].Name;
    Comment.Text := FoodsForm.eng.OldFoods[itemID].Comment;
  end else
  begin
    Name.Text := FoodsForm.eng.Foods[itemID].Name;
    Comment.Text := FoodsForm.eng.Foods[itemID].Comment;
  end;
  // ---Colorize Pins
  var PinProColor: string;
  if isDel then
    PinProColor :='#'+FoodsForm.eng.oldFoods[itemID].color
    else PinProColor :='#'+FoodsForm.eng.Foods[itemID].color;
  if length(PinProColor)>4 then
  try
    PinPro.Fill.color := StringToAlphaColor(PinProColor);
    var
      PinSubColor: TAlphaColorRec;
      PinSubColor.Color := StringToAlphaColor(PinProColor);   //Присваиваем цвет
      PinSubColor.A := Byte(trunc(Integer(PinSubColor.A)/3)); //Делаем полупрозрачным
    PinSub.Fill.color := PinSubColor.Color;
  except
  end;
  // --Trash click action
  Trash.OnClick := TrashClick;
  Anim.OnFinish := Animfinish;
  PinPro.OnClick := PinProClick;
  //IsDelCheck
  Trash.Visible := not isdel;
  anim.Inverse := isdel;
end;

Constructor TFoodItem.Create(idx: integer; pdx: integer);
begin
  Create(idx, pdx, false);
end;

destructor TFoodItem.Destroy;
begin
  Name.Destroy;
  PinPro.Destroy;
  PinSub.Destroy;
  Comment.Destroy;
  Anim.Destroy;
  Trash.Destroy;
  Client.Destroy;
  Bar.Destroy;
  Pin.Destroy;
  Back.Destroy;
  FoodsForm.Scroller.Repaint;
end;

procedure TFoodItem.TrashClick(Sender: TObject);
begin
  Anim.Start;
  TSpeedButton(Sender).Enabled := false;
end;

procedure TFoodItem.Animfinish(Sender: TObject);
begin
  //Если скрываем, а не показываем
  if not TFloatAnimation(Sender).Inverse then
    FoodsForm.eng.RemoveFood(TComponent(Sender).Tag);
end;

procedure TFoodItem.PinProClick(Sender: TObject);
begin
  if isDeleted then
  ShowNotify('Удалено: '+DateToStr(FoodsForm.eng.OldFoods[itemID].datetime)) else
  ShowNotify(FoodsForm.eng.GetAddictInfoByID(TComponent(Sender).Tag));
end;

procedure TFoodItems.Build;
var
  itemsCnt: integer;
  oldoldf: integer;
begin
  oldoldf := length(oldfoode);
  // //Remove old old foode
   for var i := 0 to length(oldfoode)-1 do
   begin
   oldFoode[i].Destroy;
   end;
  // Remove old new foode
  for var i := 0 to length(Foode) - 1 do
  begin
    Foode[i].Destroy;
  end;
   // SettingUp old foode
   itemsCnt := length(FoodsForm.eng.OldFoods);
   SetLength(OldFoode, itemsCnt);
   for var i := 0 to itemsCnt - 1 do
   begin
   //Creating component
   OldFoode[i] := TFoodItem.Create(FoodsForm.eng.OldFoods[i].id, i,true);
   if itemsCnt<>oldoldf then    //Если различается количество устаревших товаров
    OldFoode[i].Anim.Start;
   //SetName
   end;
  // SettingUp new foode
  itemsCnt := length(FoodsForm.eng.Foods);
  SetLength(Foode, itemsCnt);
  for var i := 0 to itemsCnt - 1 do
  begin
    // Creating component
    Foode[i] := TFoodItem.Create(FoodsForm.eng.Foods[i].id, i);
    // SetName
  end;
end;

end.
