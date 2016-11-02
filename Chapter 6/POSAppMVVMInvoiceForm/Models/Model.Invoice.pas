unit Model.Invoice;

interface

uses
  Model.Interfaces;

function CreateInvoiceModelClass: IInvoiceModelInterface;

implementation

uses
  Model.Declarations, System.Generics.Collections, Model.Database;

type
  TInvoiceModel = class (TInterfacedObject, IInvoiceModelInterface)
  private
    fInvoiceFormLabelsText: TInvoiceFormLabelsText;
    fDatabase: IDatabaseInterface;
    fInvoice: TInvoice;
    fCurrentInvoiceItems: TObjectList<TInvoiceItem>;
  public
    function GetInvoiceFormLabelsText: TInvoiceFormLabelsText;
    constructor Create;
    destructor Destroy; override;
    procedure SetInvoice(const newInvoice: TInvoice);
    procedure GetInvoice(var invoice: TInvoice);
    procedure GetCustomerList(var customers: TObjectList<TCustomer>);
    procedure GetItems(var items: TObjectList<TItem>);
  end;

function CreateInvoiceModelClass: IInvoiceModelInterface;
begin
  result:=TInvoiceModel.Create;
end;


{ TInvoiceModel }

constructor TInvoiceModel.Create;
begin
  fDatabase:=CreateDatabaseClass;
  fInvoice:=TInvoice.Create;
  fInvoice.ID:=1;
  fInvoice.Number:=Random(3000);
  fCurrentInvoiceItems:=TObjectList<TInvoiceItem>.Create;
end;

destructor TInvoiceModel.Destroy;
begin
  fCurrentInvoiceItems.Free;
  fInvoice.Free;
  inherited;
end;

procedure TInvoiceModel.GetCustomerList(var customers: TObjectList<TCustomer>);
begin
  customers:=fDatabase.GetCustomerList
end;

procedure TInvoiceModel.GetInvoice(var invoice: TInvoice);
begin
  invoice:=fInvoice;
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



procedure TInvoiceModel.GetItems(var items: TObjectList<TItem>);
begin
  items:=fDatabase.GetItems
end;

end.
