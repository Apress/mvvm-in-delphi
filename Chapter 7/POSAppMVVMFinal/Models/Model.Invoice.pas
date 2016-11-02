unit Model.Invoice;

interface

uses
  Model.Interfaces;

function CreateInvoiceModelClass: IInvoiceModelInterface;

implementation

uses
  Model.Declarations, System.Generics.Collections, Model.Database, System.SysUtils;

type
  TInvoiceModel = class (TInterfacedObject, IInvoiceModelInterface)
  private
    fInvoiceFormLabelsText: TInvoiceFormLabelsText;
    fDatabase: IDatabaseInterface;
    fInvoice: TInvoice;
    fCurrentInvoiceItems: TObjectList<TInvoiceItem>;
    fRunningBalance,
    fDiscount: Currency;
    function GetInvoiceRunningBalance:Currency;
    procedure CalculateInvoiceAmounts;
    function GetNumberOfInvoiceItems:integer;
    procedure GetCustomerFromID (const customerID: integer; var customer: TCustomer);
    function GetInvoiceDiscount: Currency;
  public
    function GetInvoiceFormLabelsText: TInvoiceFormLabelsText;
    constructor Create;
    destructor Destroy; override;
    procedure SetInvoice(const newInvoice: TInvoice);
    procedure GetInvoice(var invoice: TInvoice);
    procedure GetCustomerList(var customers: TObjectList<TCustomer>);
    procedure GetItems(var items: TObjectList<TItem>);
    procedure GetCustomer (const customerName: string; var customer: TCustomer);
    procedure AddInvoiceItem(const itemDescription: string; const quantity: integer);
    procedure GetInvoiceItems (var itemsList: TObjectList<TInvoiceItem>);
    procedure GetInvoiceItemFromID (const itemID: Integer; var item: TItem);
    procedure DeleteAllInvoiceItems;
    procedure DeleteInvoiceItem (const delItemID: integer);
    procedure PrintInvoice;

    property InvoiceRunningBalance: Currency read GetInvoiceRunningBalance;
    property NumberOfInvoiceItems: integer read GetNumberOfInvoiceItems;
    property InvoiceDiscount: Currency read GetInvoiceDiscount;
  end;

function CreateInvoiceModelClass: IInvoiceModelInterface;
begin
  result:=TInvoiceModel.Create;
end;


{ TInvoiceModel }

procedure TInvoiceModel.AddInvoiceItem(const itemDescription: string; const quantity: integer);
var
  tmpInvoiceItem: TInvoiceItem;
  tmpItem: TItem;
begin
  if trim(itemDescription)='' then
    Exit;

  tmpItem:=fDatabase.GetItemFromDescription(trim(itemDescription));
  if not Assigned(tmpItem) then
    Exit;

  tmpInvoiceItem:=TInvoiceItem.Create;
  tmpInvoiceItem.ID:=tmpItem.ID;
  tmpInvoiceItem.InvoiceID:=fInvoice.ID;
  tmpInvoiceItem.UnitPrice:=tmpItem.Price;
  tmpInvoiceItem.Quantity:=quantity;

  fCurrentInvoiceItems.Add(tmpInvoiceItem);

end;

procedure TInvoiceModel.CalculateInvoiceAmounts;
var
  tmpItem: TInvoiceItem;
begin
  fRunningBalance:=0.00;
  for tmpItem in fCurrentInvoiceItems do
    fRunningBalance:=fRunningBalance+(tmpItem.Quantity*tmpItem.UnitPrice);
end;

constructor TInvoiceModel.Create;
begin
  fDatabase:=CreateDatabaseClass;
  fInvoice:=TInvoice.Create;
  fInvoice.ID:=1;
  fInvoice.Number:=Random(3000);
  fCurrentInvoiceItems:=TObjectList<TInvoiceItem>.Create;
end;

procedure TInvoiceModel.DeleteAllInvoiceItems;
begin
  fCurrentInvoiceItems.Clear;
end;

procedure TInvoiceModel.DeleteInvoiceItem(const delItemID: integer);
var
  i: integer;
begin
  if delItemID<=0 then
    Exit;
  for i := 0 to fCurrentInvoiceItems.Count-1 do
  begin
    if fCurrentInvoiceItems.Items[i].ID=delItemID then
    begin
      fCurrentInvoiceItems.Delete(i);
      break;
    end;
  end;
end;

destructor TInvoiceModel.Destroy;
begin
  fCurrentInvoiceItems.Free;
  fInvoice.Free;
  inherited;
end;

procedure TInvoiceModel.GetCustomer(const customerName: string;
  var customer: TCustomer);
begin
  if not Assigned(customer) then
    Exit;
  if trim(customerName)<>'' then
  begin
    customer.ID:=fDatabase.GetCustomerFromName(trim(customerName)).ID;
    customer.Name:=fDatabase.GetCustomerFromName(trim(customerName)).Name;
    customer.DiscountRate:=fDatabase.GetCustomerFromName(trim(customerName)).DiscountRate;
    customer.Balance:=fDatabase.GetCustomerFromName(trim(customerName)).Balance;

    fInvoice.CustomerID:=customer.ID;
  end;
end;

procedure TInvoiceModel.GetCustomerFromID(const customerID: integer;
  var customer: TCustomer);
var
  tmpCustomerList: TObjectList<TCustomer>;
  tmpCustomer: TCustomer;
begin
  if not Assigned(customer) then
    Exit;
  GetCustomerList(tmpCustomerList);
  for tmpCustomer in tmpCustomerList do
    if tmpCustomer.ID=customerID then
    begin
      customer.ID:=tmpCustomer.ID;
      customer.Name:=tmpCustomer.Name;
      customer.DiscountRate:=tmpCustomer.DiscountRate;
      customer.Balance:=tmpCustomer.Balance;
      break;
    end;
end;

procedure TInvoiceModel.GetCustomerList(var customers: TObjectList<TCustomer>);
begin
  customers:=fDatabase.GetCustomerList
end;

procedure TInvoiceModel.GetInvoice(var invoice: TInvoice);
begin
  invoice:=fInvoice;
end;

function TInvoiceModel.GetInvoiceDiscount: Currency;
var
  tmpCustomer: TCustomer;
  tmpDiscount: Double;
begin
  fDiscount:=0.00;
  tmpDiscount:=0.00;
  tmpCustomer:=TCustomer.Create;
  GetCustomerFromID(fInvoice.CustomerID, tmpCustomer);
  tmpDiscount:=tmpCustomer.DiscountRate;
  tmpCustomer.Free;

  CalculateInvoiceAmounts;
  fDiscount:=fRunningBalance*tmpDiscount/100;
  Result:=fDiscount;
end;

procedure TInvoiceModel.SetInvoice(const newInvoice: TInvoice);
begin
  fInvoice:=newInvoice;
end;

function TInvoiceModel.GetInvoiceFormLabelsText: TInvoiceFormLabelsText;
begin
  fInvoiceFormLabelsText.Title:='Sales Invoice';
  fInvoiceFormLabelsText.CustomerDetailsGroupText:='Customer Details';
  fInvoiceFormLabelsText.CustomerText:='Customer:';
  fInvoiceFormLabelsText.CustomerDiscountRateText:='Discount Rate:';
  fInvoiceFormLabelsText.CustomerOutstandingBalanceText:='Outstanding Balance:';

  fInvoiceFormLabelsText.InvoiceItemsGroupText:='Invoice Items';
  fInvoiceFormLabelsText.InvoiceItemsText:='Item:';
  fInvoiceFormLabelsText.InvoiceItemsQuantityText:='Quantity:';
  fInvoiceFormLabelsText.InvoiceItemsAddItemButtonText:='Add Item';

  fInvoiceFormLabelsText.InvoiceItemsGridItemText:='Item';
  fInvoiceFormLabelsText.InvoiceItemsGridQuantityText:='Quantity';
  fInvoiceFormLabelsText.InvoiceItemsGridUnitPriceText:='Unit Price';
  fInvoiceFormLabelsText.InvoiceItemsGridAmountText:='Amount';

  fInvoiceFormLabelsText.BalanceGroupText:='Balance';
  fInvoiceFormLabelsText.BalanceInvoiceBalanceText:='Invoice Balance:';
  fInvoiceFormLabelsText.BalanceDiscountText:='Discount';
  fInvoiceFormLabelsText.BalanceTotalText:='Total:';

  fInvoiceFormLabelsText.PrintInvoiceButtonText:='Print Invoice';
  fInvoiceFormLabelsText.PrintingText:='Printing Invoice...';
  fInvoiceFormLabelsText.CancelButtonText:='Cancel';

  result:=fInvoiceFormLabelsText;
end;

procedure TInvoiceModel.GetInvoiceItemFromID(const itemID: Integer;
  var item: TItem);
var
  tmpItem: TItem;
begin
  if (not Assigned(item)) then
    Exit;
  tmpItem:=fDatabase.GetItemFromID(itemID);
  if Assigned(tmpItem) then
  begin
    item.ID:=tmpItem.ID;
    item.Description:=tmpItem.Description;
    item.Price:=tmpItem.Price
  end;
end;

procedure TInvoiceModel.GetInvoiceItems(
  var itemsList: TObjectList<TInvoiceItem>);
var
  tmpInvoiceItem: TInvoiceItem;
  i: integer;
begin
  if not Assigned(itemsList) then
    Exit;
  itemsList.Clear;
  for i:=0 to fCurrentInvoiceItems.Count-1 do
  begin
    tmpInvoiceItem:=TInvoiceItem.Create;
    tmpInvoiceItem.ID:=fCurrentInvoiceItems.Items[i].ID;
    tmpInvoiceItem.InvoiceID:=fCurrentInvoiceItems.Items[i].InvoiceID;
    tmpInvoiceItem.ItemID:=fCurrentInvoiceItems.Items[i].ItemID;
    tmpInvoiceItem.UnitPrice:=fCurrentInvoiceItems.Items[i].UnitPrice;
    tmpInvoiceItem.Quantity:=fCurrentInvoiceItems.Items[i].Quantity;

    itemsList.Add(tmpInvoiceItem);
  end;
end;

function TInvoiceModel.GetInvoiceRunningBalance: Currency;
begin
  CalculateInvoiceAmounts;
  Result:=fRunningBalance;
end;

procedure TInvoiceModel.GetItems(var items: TObjectList<TItem>);
begin
  items:=fDatabase.GetItems
end;

function TInvoiceModel.GetNumberOfInvoiceItems: integer;
begin
  result:=fCurrentInvoiceItems.Count;
end;

procedure TInvoiceModel.PrintInvoice;
begin
  fDatabase.SaveCurrentSales(fRunningBalance-fDiscount);
end;

end.
