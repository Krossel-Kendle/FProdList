unit Methoder;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, System.JSON, FoodEngine, FMX.Layouts,
  FMX.ListBox, FMX.TabControl, FMX.Objects, Prototype, ObjectProvider,
  FMX.Effects, FMX.Ani, FMX.Filter.Effects, Generics.Collections,
  FMX.DialogService, FMX.Colors, System.UIConsts;

type
  TMethodsBook = class
  public
    m: string;
    procedure AddFood;
    procedure SaveFood;
    procedure SaveSettings;
  end;

procedure MainHeaderExpanderClick(Sender: TObject);

implementation

uses
  Rtti, FoProdList, functions, FoAdd, Utils;

{ TMethodsBook }

procedure TMethodsBook.AddFood;
begin
  foodsform.Generic.GotoVisibleTab(0);
end;

procedure TMethodsBook.SaveFood;
begin
  with foodsform do
  begin
    TDialogService.MessageDialog('Сохраняем?', TMsgDlgType.mtConfirmation,
      mbYesNo, TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      begin
        if (AResult = mrYes) then
        begin
          eng.AddFood(FoodName.Edit.Text, FoodComment.Edit.Text,
            BadgeColor.Color);
          ColorEng.AddColor(FoodName.Edit.Text, BadgeColor.Color);
          FoodName.Edit.Text := '';
          FoodComment.Edit.Text := '';
          Generic.GotoVisibleTab(1);
        end;
      end);
  end;
end;

procedure TMethodsBook.SaveSettings;
begin
  with foodsform do
  begin
    if checkUID(edUID.Edit.Text) then
    begin
      eng.Settings.UnionID := StrToInt(edUID.Edit.Text);
      eng.Settings.UserName := edUser.Edit.Text;
      ShowNotify('Настройки сохранены.');
      Generic.GotoVisibleTab(1);
    end
    else
    begin
      edUID.Edit.Text := IntToStr(eng.Settings.UnionID);
      ShowNotify('Такой UID не существует!', '#FFEA580C');
    end;
    eng.SaveSettings;
  end;
end;

procedure MainHeaderExpanderClick(Sender: TObject);
begin
  with foodsform do
    if sbSubHeadExpandButton.StyleLookup = 'arrowdowntoolbutton' then
    begin
      SubheadAnimation.Inverse := false;
      SubheadAnimation.Start;
      sbSubHeadExpandButton.StyleLookup := 'arrowuptoolbutton';
      sbSubHeadExpandButton.Enabled := false;
    end
    else
    begin
      SubheadAnimation.Inverse := true;
      SubheadAnimation.Start;
      sbSubHeadExpandButton.StyleLookup := 'arrowdowntoolbutton';
      sbSubHeadExpandButton.Enabled := false;
      SubheadMenuButtons.Visible := false;
    end;
end;

end.
