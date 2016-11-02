unit ViewModel.Invoice;

interface

uses
  Model.Interfaces;

function CreateInvoiceViewModelClass: IInvoiceViewModelInterface;

implementation

uses
  Model.Declarations, System.SysUtils, System.Generics.Collections,
  Model.ProSu.Interfaces, Model.ProSu.Provider, Model.ProSu.InterfaceActions;

type
  TInvoiceViewModel = class(TInterfacedObject, IInvoiceViewModelInterface)
  private
    fModel: IInvoiceModelInterface;
    fLabelsText: TInvoiceFormLabelsText;
    fTitle: string;
    fInvoiceItemsEnabled,
    fBalanceEnabled,
    fPrintButtonEnabled,
    fAniIndicatorVisible,
    fPrintingLabelVisible,
    fDiscountChecked: boolean;
    fProvider: IProviderInterface;
    fInvoiceItemsText: TInvoiceItemsText;
    function GetModel: IInvoiceModelInterface;
    procedure SetModel(const newModel: IInvoiceModelInterface);
    function GetLabelsText: TInvoiceFormLabelsText;
    function GetTitleText: string;
    function GetGroupBoxInvoiceItemsEnabled: Boolean;
    function GetGroupBoxBalanceEnabled: Boolean;
    function GetButtonPrintInvoiceEnabled: Boolean;
    function GetAniIndicatorProgressVisible: Boolean;
    function GetLabelPrintingVisible: Boolean;
    procedure GetCustomerList(var customers: TObjectList<TCustomer>);
    procedure GetItems(var items: TObjectList<TItem>);
    function GetProvider: IProviderInterface;
    procedure GetCustomerDetails (const customerName: string; var customerDetails: TCustomerDetailsText);
    function GetInvoiceItemsText: TInvoiceItemsText;
    procedure SendNotification (const actions: TInterfaceActions);
    procedure SendErrorNotification (const errorType: TInterfaceErrors;
                                         const errorMessage: string);
    procedure SetDiscountApplied (const discount: boolean);
    function GetDiscountApplied: boolean;
  public
    constructor Create;
    procedure AddInvoiceItem(const itemDescription: string; const quantity: integer);
    procedure DeleteAllInvoiceItems;
    procedure ValidateItem (const newItem: string);
    procedure ValidateQuantity (const newQuantityText: string);
    procedure DeleteInvoiceItem (const delItemIDAsText: string);
    procedure PrintInvoice;

    property Model: IInvoiceModelInterface read GetModel write SetModel;
    property LabelsText: TInvoiceFormLabelsText read GetLabelsText;
    property TitleText: string read GetTitleText;
    property GroupBoxInvoiceItemsEnabled: boolean read GetGroupBoxInvoiceItemsEnabled;
    property GroupBoxBalanceEnabled: boolean read GetGroupBoxBalanceEnabled;
    property ButtonPrintInvoiceEnabled: Boolean read GetButtonPrintInvoiceEnabled;
    property AniIndicatorProgressVisible: Boolean read GetAniIndicatorProgressVisible;
    property LabelPrintingVisible: Boolean read GetLabelPrintingVisible;
    property Provider: IProviderInterface read GetProvider;
    property InvoiceItemsText: TInvoiceItemsText read GetInvoiceItemsText;
    property DiscountApplied: boolean read GetDiscountApplied write SetDiscountApplied;
  end;

function CreateInvoiceViewModelClass: IInvoiceViewModelInterface;
begin
  result:=TInvoiceViewModel.Create;
end;

{ TInvoiceViewModel }

procedure TInvoiceViewModel.AddInvoiceItem(const itemDescription: string;
  const quantity: integer);
begin
  fModel.AddInvoiceItem(itemDescription, quantity);
  SendNotification([actInvoiceItemsChanges]);
end;

constructor TInvoiceViewModel.Create;
begin
  fInvoiceItemsEnabled:=false;
  fBalanceEnabled:=false;
  fPrintButtonEnabled:=false;
  fAniIndicatorVisible:=false;
  fPrintingLabelVisible:=false;
  fDiscountChecked:=false;
  fProvider:=CreateProSuProviderClass;
end;

procedure TInvoiceViewModel.DeleteAllInvoiceItems;
begin
  fModel.DeleteAllInvoiceItems;
  SendNotification([actInvoiceItemsChanges]);
end;

procedure TInvoiceViewModel.DeleteInvoiceItem(const delItemIDAsText: string);
begin
  if (trim(delItemIDAsText)='') then
    Exit;
  fModel.DeleteInvoiceItem(delItemIDAsText.ToInteger);
  SendNotification([actInvoiceItemsChanges]);
end;

function TInvoiceViewModel.GetAniIndicatorProgressVisible: Boolean;
begin
  result:=fAniIndicatorVisible;
end;

function TInvoiceViewModel.GetButtonPrintInvoiceEnabled: Boolean;
begin
  result:=fPrintButtonEnabled;
end;

procedure TInvoiceViewModel.GetCustomerDetails(const customerName: string;
  var customerDetails: TCustomerDetailsText);
var
  tmpCustomer: TCustomer;
begin
  if trim(customerName)='' then
  begin
    customerDetails.DiscountRate:='Please Choose a Customer';
    customerDetails.OutstandingBalance:='Please Choose a Customer';
  end
  else
  begin
    tmpCustomer:=TCustomer.Create;
    fModel.GetCustomer(trim(customerName), tmpCustomer);
    customerDetails.DiscountRate:=Format('%5.2f', [tmpCustomer.DiscountRate])+'%';
    customerDetails.OutstandingBalance:=Format('%-n',[tmpCustomer.Balance]);
    tmpCustomer.Free;

    fInvoiceItemsEnabled:=true;
    fBalanceEnabled:=true;
    fDiscountChecked:=false;
  end;
end;

procedure TInvoiceViewModel.GetCustomerList(
  var customers: TObjectList<TCustomer>);
begin
  fModel.GetCustomerList(customers);
end;

function TInvoiceViewModel.GetDiscountApplied: boolean;
begin
  result:=fDiscountChecked;
end;

function TInvoiceViewModel.GetGroupBoxBalanceEnabled: Boolean;
begin
  result:=fBalanceEnabled;
end;

function TInvoiceViewModel.GetGroupBoxInvoiceItemsEnabled: Boolean;
begin
  Result:=fInvoiceItemsEnabled;
end;

function TInvoiceViewModel.GetInvoiceItemsText: TInvoiceItemsText;
var
  tmpRunning,
  tmpDiscount: Currency;
  tmpInvoiceItems: TObjectList<TInvoiceItem>;
  i, tmpLen: integer;
  tmpItem: TItem;
begin
  tmpLen:=0;
  SetLength(fInvoiceItemsText.DescriptionText,tmpLen);
  SetLength(fInvoiceItemsText.QuantityText,tmpLen);
  SetLength(fInvoiceItemsText.UnitPriceText,tmpLen);
  SetLength(fInvoiceItemsText.PriceText,tmpLen);
  SetLength(fInvoiceItemsText.IDText, tmpLen);
  tmpRunning:=0.00;
  tmpDiscount:=0.00;

  tmpInvoiceItems:=TObjectList<TInvoiceItem>.Create;
  fModel.GetInvoiceItems(tmpInvoiceItems);
  for i := 0 to tmpInvoiceItems.Count-1 do
  begin
    tmpLen:=Length(fInvoiceItemsText.DescriptionText)+1;
    SetLength(fInvoiceItemsText.DescriptionText,tmpLen);
    SetLength(fInvoiceItemsText.QuantityText,tmpLen);
    SetLength(fInvoiceItemsText.UnitPriceText,tmpLen);
    SetLength(fInvoiceItemsText.PriceText,tmpLen);
    SetLength(fInvoiceItemsText.IDText, tmpLen);

    tmpItem:=TItem.Create;
    fModel.GetInvoiceItemFromID(tmpInvoiceItems.Items[i].ID, tmpItem);
    fInvoiceItemsText.DescriptionText[tmpLen-1]:=tmpItem.Description;
    tmpItem.Free;

    fInvoiceItemsText.QuantityText[tmpLen-1]:=tmpInvoiceItems.Items[i].Quantity.ToString;
    fInvoiceItemsText.UnitPriceText[tmpLen-1]:=format('%10.2f',[tmpInvoiceItems.Items[i].UnitPrice]);
    fInvoiceItemsText.PriceText[tmpLen-1]:=
       format('%10.2f',[tmpInvoiceItems.Items[i].UnitPrice*tmpInvoiceItems.items[i].Quantity]);
    fInvoiceItemsText.IDText[tmpLen-1]:=tmpInvoiceItems.Items[i].ID.ToString;
  end;
  tmpInvoiceItems.Free;

  tmpRunning:=fModel.InvoiceRunningBalance;

  if fDiscountChecked then
    tmpDiscount:=fModel.InvoiceDiscount;


  fInvoiceItemsText.InvoiceRunningBalance:=Format('%10.2f', [tmpRunning]);
  fInvoiceItemsText.InvoiceDiscountFigure:=Format('%10.2f', [tmpDiscount]);
  fInvoiceItemsText.InvoiceTotalBalance:=Format('%10.2f', [tmpRunning-tmpDiscount]);

  fPrintButtonEnabled:=fModel.NumberOfInvoiceItems > 0;

  Result:=fInvoiceItemsText;
end;

procedure TInvoiceViewModel.GetItems(var items: TObjectList<TItem>);
begin
  fModel.GetItems(items);
end;

function TInvoiceViewModel.GetLabelPrintingVisible: Boolean;
begin
  result:=fPrintingLabelVisible;
end;

function TInvoiceViewModel.GetLabelsText: TInvoiceFormLabelsText;
begin
  result:=fModel.GetInvoiceFormLabelsText;
end;

function TInvoiceViewModel.GetModel: IInvoiceModelInterface;
begin
  result:=fModel;
end;

function TInvoiceViewModel.GetProvider: IProviderInterface;
begin
  result:=fProvider;
end;

function TInvoiceViewModel.GetTitleText: string;
var
  tmpInvoice: TInvoice;
begin
  fModel.GetInvoice(tmpInvoice);
  if Assigned(tmpInvoice) then
    result:=fModel.GetInvoiceFormLabelsText.Title+' #'+IntToStr(tmpInvoice.Number)
end;

procedure TInvoiceViewModel.PrintInvoice;
var
  tmpNotifClass: TNotificationClass;
begin
  fAniIndicatorVisible:=true;
  fPrintingLabelVisible:=true;

  SendNotification([actPrintingStart]);

  fModel.PrintInvoice;

  fAniIndicatorVisible:=false;
  fPrintingLabelVisible:=false;

  SendNotification([actPrintingFinish]);
end;

procedure TInvoiceViewModel.SendErrorNotification (const errorType: TInterfaceErrors;
                                         const errorMessage: string);
var
  tmpErrorNotificationClass: TErrorNotificationClass;
begin
  tmpErrorNotificationClass:=TErrorNotificationClass.Create;
  try
    tmpErrorNotificationClass.Actions:=errorType;
    tmpErrorNotificationClass.ActionMessage:=errorMessage;
    fProvider.NotifySubscribers(tmpErrorNotificationClass);
  finally
    tmpErrorNotificationClass.Free;
  end;

end;

procedure TInvoiceViewModel.SendNotification(const actions: TInterfaceActions);
var
  tmpNotificationClass: TNotificationClass;
begin
  tmpNotificationClass:=TNotificationClass.Create;
  tmpNotificationClass.Actions:=actions;
  if Assigned(fProvider) then
   fProvider.NotifySubscribers(tmpNotificationClass);
  tmpNotificationClass.Free;
end;

procedure TInvoiceViewModel.SetDiscountApplied(const discount: boolean);
begin
  fDiscountChecked:=discount;
end;

procedure TInvoiceViewModel.SetModel(const newModel: IInvoiceModelInterface);
begin
  fModel:=newModel;
end;

procedure TInvoiceViewModel.ValidateItem(const newItem: string);
begin
  if trim(newItem)='' then
    SendErrorNotification([errInvoiceItemEmpty], 'Please choose an item');
end;

procedure TInvoiceViewModel.ValidateQuantity(const newQuantityText: string);
var
  value,
  code: integer;
begin
  if trim(newQuantityText)='' then
  begin
    SendErrorNotification([errInvoiceItemQuantityEmpty], 'Please enter quantity');
    Exit;
  end;

  Val(trim(newQuantityText), value, code);
  if code<>0 then
  begin
    SendErrorNotification([errInvoiceItemQuantityNotNumber], 'Quantity must be a number');
    Exit;
  end;

  if trim(newQuantityText).ToInteger<=0 then
  begin
    SendErrorNotification([errInvoiceItemQuantityNonPositive],
                                      'The quantity must be positive number');
    Exit;
  end;

  SendErrorNotification([errNoError], '');
end;

end.
