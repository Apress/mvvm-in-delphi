unit Model.Declarations;

interface

uses
  Model.ProSu.InterfaceActions, Model.ProSu.Interfaces;

type
  TCustomer = class
  private
    fID: Integer;
    fName: string;
    fDiscountRate: Double;
    fBalance: Currency;
  public
    property ID: integer read fID write fID;
    property Name: string read fName write fName;
    property DiscountRate: double read fDiscountRate write fDiscountRate;
    property Balance: Currency read fBalance write fBalance;
  end;

  TItem = class
  private
    fID: Integer;
    fDescription: string;
    fPrice: Currency;
  public
    property ID: integer read fID write fID;
    property Description: string read fDescription write fDescription;
    property Price: Currency read fPrice write fPrice;
  end;

  TInvoice = class
  private
    fID: integer;
    fNumber: integer;
    fCustomerID: Integer;
  public
    property ID: Integer read fID write fID;
    property Number: Integer read fNumber write fNumber;
    property CustomerID: Integer read fCustomerID write fCustomerID;
  end;

  TInvoiceItem = class
  private
    fID: integer;
    fInvoiceID: integer;
    fItemID: integer;
    fUnitPrice: Currency;
    fQuantity: integer;
  public
    property ID: integer read fID write fID;
    property InvoiceID: integer read fInvoiceID write fInvoiceID;
    property ItemID: integer read fItemID write fItemID;
    property UnitPrice: Currency read fUnitPrice write fUnitPrice;
    property Quantity: Integer read fQuantity write fQuantity;
  end;

  TMainFormLabelsText = record
    Title,
    IssueButtonCaption,
    TotalSalesText: string;
  end;

  TNotificationClass = class (TInterfacedObject, INotificationClass)
  private
    fActions: TInterfaceActions;
    fActionValue: Double;
  public
    property Actions: TInterfaceActions read fActions write fActions;
    property ActionValue: double read fActionValue write fActionValue;
  end;

  TInvoiceFormLabelsText = record
    Title,
    CustomerDetailsGroupText,
    CustomerText,
    CustomerDiscountRateText,
    CustomerOutstandingBalanceText,

    InvoiceItemsGroupText,
    InvoiceItemsText,
    InvoiceItemsQuantityText,
    InvoiceItemsAddItemButtonText,
    InvoiceItemsGridItemText,
    InvoiceItemsGridQuantityText,
    InvoiceItemsGridUnitPriceText,
    InvoiceItemsGridAmountText,

    BalanceGroupText,
    BalanceInvoiceBalanceText,
    BalanceDiscountText,
    BalanceTotalText,

    PrintInvoiceButtonText,
    PrintingText,
    CancelButtonText: string;
  end;

  TCustomerDetailsText = record
    DiscountRate,
    OutstandingBalance: string;
  end;

  TInvoiceItemsText = record
    DescriptionText,
    QuantityText,
    UnitPriceText,
    PriceText,
    IDText: array of string;
    InvoiceRunningBalance,
    InvoiceDiscountFigure,
    InvoiceTotalBalance: string;
  end;

  TErrorNotificationClass = class (TInterfacedObject, INotificationClass)
  private
    fActions: TInterfaceErrors;
    fActionMessage: string;
  public
    property Actions: TInterfaceErrors read fActions write fActions;
    property ActionMessage: string read fActionMessage write fActionMessage;
  end;

implementation

end.

