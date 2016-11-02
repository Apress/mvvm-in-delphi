unit InvoiceForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls, System.Rtti, FMX.Grid,
  FMX.Layouts, FMX.Objects, Database, Declarations, FMX.Edit, FMX.ListBox,
  System.Generics.Collections, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Menus;

type
  TSalesInvoiceForm = class(TForm)
    LabelCustomer: TLabel;
    PopupBoxCustomer: TPopupBox;
    GroupBoxCustomerDetails: TGroupBox;
    LabelDiscountRate: TLabel;
    LabelDiscountRateFigure: TLabel;
    LabelTotalBalanceBig: TLabel;
    LabelOutstandingBalance: TLabel;
    LabelInvoiceBalance: TLabel;
    GroupBoxInvoiceItems: TGroupBox;
    PopupBoxItems: TPopupBox;
    LabelItem: TLabel;
    GroupBoxBalance: TGroupBox;
    LabelRunningBalance: TLabel;
    LabelInvBalance: TLabel;
    CheckBoxDiscount: TCheckBox;
    LabelDiscount: TLabel;
    LineHorizontal: TLine;
    LabelTotalBalance: TLabel;
    ButtonCancel: TButton;
    ButtonPrintInvoice: TButton;
    LabelQuantity: TLabel;
    EditQuantity: TEdit;
    ButtonAddItem: TButton;
    StringGridItems: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    LabelTotal: TLabel;
    AniIndicatorProgress: TAniIndicator;
    LabelPrinting: TLabel;
    LabelTitle: TLabel;
    PopupMenuItems: TPopupMenu;
    MenuItemDeleteItem: TMenuItem;
    StringColumn5: TStringColumn;
    procedure ButtonCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PopupBoxCustomerChange(Sender: TObject);
    procedure ButtonAddItemClick(Sender: TObject);
    procedure CheckBoxDiscountChange(Sender: TObject);
    procedure ButtonPrintInvoiceClick(Sender: TObject);
    procedure MenuItemDeleteItemClick(Sender: TObject);
  private
    fDatabase: TDatabase;
    fInvoice: TInvoice;
    fCurrentCustomer:TCustomer;
    fCurrentInvoiceItems: TObjectList<TInvoiceItem>;
    fCurrentInvoiceBalance: Currency;
    //Sets up the graphical elements of the form
    procedure SetupGUI;
    //Updates the current balance based on the items in the invoice
    procedure UpdateBalance;
    procedure UpdateInvoiceGrid;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TSalesInvoiceForm.ButtonAddItemClick(Sender: TObject);
var
  tmpInvoiceItem: TInvoiceItem;
  tmpItem: TItem;
begin
  if trim(PopupBoxItems.Text)='' then
  begin
    ShowMessage('Please choose an item');
    PopupBoxItems.SetFocus;
    Exit;
  end;

  if trim(EditQuantity.Text)='' then
  begin
    ShowMessage('Please enter quantity');
    EditQuantity.SetFocus;
    Exit;
  end;

  if EditQuantity.Text.ToInteger<=0 then
  begin
    ShowMessage('The quantity must be positive number');
    EditQuantity.SelectAll;
    EditQuantity.SetFocus;
  end;

  tmpInvoiceItem:=TInvoiceItem.Create;
  tmpInvoiceItem.ID:=StringGridItems.RowCount+1;
  tmpInvoiceItem.InvoiceID:=fInvoice.ID;
  tmpInvoiceItem.Quantity:=EditQuantity.Text.ToInteger;

  tmpItem:=fDatabase.GetItemFromDescription(PopupBoxItems.Text);
  if not Assigned(tmpItem) then Exit;

  tmpInvoiceItem.ItemID:=tmpItem.ID;
  tmpInvoiceItem.UnitPrice:=tmpItem.Price;

  fCurrentInvoiceItems.Add(tmpInvoiceItem);

  UpdateInvoiceGrid;

  UpdateBalance;

end;

procedure TSalesInvoiceForm.ButtonCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TSalesInvoiceForm.ButtonPrintInvoiceClick(Sender: TObject);
begin
  if fCurrentInvoiceItems.Count>0 then
  begin
    AniIndicatorProgress.Visible:=true;
    LabelPrinting.Visible:=true;
    ShowMessage('Invoice Printed');
    if Assigned(fDatabase) then
      fDatabase.SaveCurrentSales(fCurrentInvoiceBalance);
    self.Close;
  end;
end;

procedure TSalesInvoiceForm.CheckBoxDiscountChange(Sender: TObject);
begin
  UpdateBalance;
end;

procedure TSalesInvoiceForm.FormCreate(Sender: TObject);
begin
  fDatabase:=TDatabase.Create;
  fInvoice:=TInvoice.Create;
  fInvoice.ID:=1;
  fInvoice.Number:=Random(3000);
  SetupGUI;
end;

procedure TSalesInvoiceForm.FormDestroy(Sender: TObject);
begin
  fInvoice.Free;
  fCurrentInvoiceItems.Free;
  fDatabase.Free;
end;

procedure TSalesInvoiceForm.MenuItemDeleteItemClick(Sender: TObject);
var
  tmpInvoiceItem: TInvoiceItem;
begin
  if (StringGridItems.Selected>=0) and
    (StringGridItems.Selected<=StringGridItems.RowCount-1) then
  begin
    for tmpInvoiceItem in fCurrentInvoiceItems do
      if tmpInvoiceItem.ID=
        StringGridItems.Cells[4,StringGridItems.Selected].ToInteger then
        begin
          fCurrentInvoiceItems.RemoveItem(tmpInvoiceItem, TDirection.FromBeginning);
          break;
        end;
  end;
  UpdateInvoiceGrid;
  UpdateBalance;
end;

procedure TSalesInvoiceForm.PopupBoxCustomerChange(Sender: TObject);
var
 tmpCustomer: TCustomer;
begin
  if not Assigned(fDatabase) then Exit;
  fCurrentInvoiceItems.Free;

  tmpCustomer:=fDatabase.GetCustomerFromName(PopupBoxCustomer.Text);
  if Assigned(tmpCustomer) then
  begin
    LabelDiscountRateFigure.Text:=Format('%5.2f',[tmpCustomer.DiscountRate])+'%';
    LabelTotalBalanceBig.Text:=Format('%-n',[tmpCustomer.Balance]);
    if tmpCustomer.Balance>=0 then
      LabelTotalBalanceBig.FontColor:=TAlphaColorRec.Green
    else
      LabelTotalBalanceBig.FontColor:=TAlphaColorRec.Red;
    fCurrentCustomer:=tmpCustomer;
    fInvoice.CustomerID:=tmpCustomer.ID;
    fCurrentInvoiceItems:=TObjectList<TInvoiceItem>.Create;

    GroupBoxInvoiceItems.Enabled:=true;
    GroupBoxBalance.Enabled:=true;
    CheckBoxDiscount.IsChecked:=false;

    PopupBoxItems.ItemIndex:=-1;

    UpdateInvoiceGrid;
    UpdateBalance;

  end;

end;

procedure TSalesInvoiceForm.SetupGUI;
var
  tmpCustomerList: TObjectList<TCustomer>;
  tmpCustomer: TCustomer;
  tmpItemsList: TObjectList<TItem>;
  tmpItem: TItem;
begin
  LabelTitle.Text:='Sales Invoice #'+fInvoice.Number.ToString;
  PopupBoxCustomer.Clear;
  PopupBoxItems.Clear;
  GroupBoxInvoiceItems.Enabled:=false;
  GroupBoxBalance.Enabled:=false;
  ButtonPrintInvoice.Enabled:=false;
  LabelInvoiceBalance.Text:=Format('%-n',[0.00]);

  //Load data from "database"
  tmpCustomerList:=fDatabase.GetCustomerList;
  if Assigned(tmpCustomerList) then
  begin
    for tmpCustomer in tmpCustomerList  do
      if Assigned(tmpCustomer) then
        PopupBoxCustomer.Items.Add(tmpCustomer.Name);
  end;
  PopupBoxCustomer.ItemIndex:=-1;

  tmpItemsList:=fDatabase.GetItems;
  if Assigned(tmpItemsList) then
  begin
    for tmpItem in tmpItemsList do
      if Assigned(tmpItem) then
        PopupBoxItems.Items.Add(tmpItem.Description);
  end;
  PopupBoxItems.ItemIndex:=-1;

  EditQuantity.Text:='1';

  StringGridItems.RowCount:=0;

  AniIndicatorProgress.Visible:=false;
  LabelPrinting.Visible:=false;

end;

procedure TSalesInvoiceForm.UpdateBalance;
var
  RunningBalance,
  discount: Currency;
  i: integer;
begin
  RunningBalance:=0.00;
  discount:=0.00;
  fCurrentInvoiceBalance:=0.00;
  for i := 0 to StringGridItems.RowCount-1 do
    RunningBalance:=RunningBalance+StringGridItems.Cells[3,i].ToDouble;
  LabelRunningBalance.Text:=Format('%10.2f',[RunningBalance]);
  if CheckBoxDiscount.IsChecked then
    discount:=RunningBalance*fCurrentCustomer.DiscountRate/100;
  LabelDiscount.Text:=Format('%10.2f',[-discount]);
  RunningBalance:=RunningBalance - discount;
  fCurrentInvoiceBalance:=RunningBalance;

  LabelTotalBalance.Text:=Format('%10.2f',[runningBalance]);
  LabelInvoiceBalance.Text:=Format('%10.2f',[runningBalance]);

  ButtonPrintInvoice.Enabled:=StringGridItems.RowCount > 0;
end;

procedure TSalesInvoiceForm.UpdateInvoiceGrid;
var
  tmpInvoiceItem: TInvoiceItem;
  tmpItem: TItem;
begin
  StringGridItems.RowCount:=0;
  for tmpInvoiceItem in fCurrentInvoiceItems do
  begin
    tmpItem:=fDatabase.GetItemFromID(tmpInvoiceItem.ItemID);
    if Assigned(tmpItem) then
    begin
      StringGridItems.RowCount := StringGridItems.RowCount + 1;
      StringGridItems.Cells[0, StringGridItems.RowCount - 1] := tmpItem.Description;
      StringGridItems.Cells[1, StringGridItems.RowCount - 1] := tmpInvoiceItem.Quantity.ToString;
      StringGridItems.Cells[2, StringGridItems.RowCount - 1] := format('%10.2f', [tmpInvoiceItem.UnitPrice]);
      StringGridItems.Cells[3, StringGridItems.RowCount - 1] := format('%10.2f', [tmpInvoiceItem.Quantity * tmpInvoiceItem.UnitPrice]);
      StringGridItems.Cells[4, StringGridItems.RowCount - 1] := tmpInvoiceItem.ID.ToString;
    end;
  end;
  PopupMenuItems.Items[0].Enabled := StringGridItems.RowCount > 0;
end;

end.
