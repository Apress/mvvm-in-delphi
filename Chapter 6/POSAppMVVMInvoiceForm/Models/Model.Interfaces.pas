unit Model.Interfaces;

interface

uses
  Model.Declarations, System.Generics.Collections;

type
  IDatabaseInterface = interface
  ['{DDE3E13A-0EC5-4712-B068-9B510977CF71}']
    function GetCustomerList: TObjectList<TCustomer>;
    function GetCustomerFromName(const nameStr: string): TCustomer;
    function GetItems: TObjectList<TItem>;
    function GetItemFromDescription(const desc: string): TItem;
    function GetItemFromID(const id: Integer): TItem;
    function GetTotalSales: Currency;
    procedure SaveCurrentSales(const currentSales: Currency);
  end;

  IMainModelInterface = interface
    ['{1345E22D-6229-4C27-8D08-6EA8584BE718}']
    function GetMainFormLabelsText: TMainFormLabelsText;
    function GetTotalSales: Currency;
  end;

  IMainViewModelInterface = interface
    ['{62CF0DAC-C808-4B1A-A6DC-57D7DC1912CB}']
    function GetModel: IMainModelInterface;
    procedure SetModel (const newModel: IMainModelInterface);
    function GetLabelsText: TMainFormLabelsText;
    function GetTotalSalesValue: string;

    property Model: IMainModelInterface read GetModel write SetModel;
    property LabelsText: TMainFormLabelsText read GetlabelsText;
  end;

  IInvoiceModelInterface = interface
    ['{A286914B-7979-4726-8D9C-18865B47CD12}']
    function GetInvoiceFormLabelsText: TInvoiceFormLabelsText;
    procedure SetInvoice(const newInvoice: TInvoice);
    procedure GetInvoice(var invoice: TInvoice);
    procedure GetCustomerList(var customers: TObjectList<TCustomer>);
    procedure GetItems(var items: TObjectList<TItem>);
  end;

  IInvoiceViewModelInterface = interface
    ['{87D2F27E-8B33-46C5-B44C-DBFC58A871BC}']
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

    property Model: IInvoiceModelInterface read GetModel write SetModel;
    property LabelsText: TInvoiceFormLabelsText read GetLabelsText;
    property TitleText: string read GetTitleText;
    property GroupBoxInvoiceItemsEnabled: boolean read GetGroupBoxInvoiceItemsEnabled;
    property GroupBoxBalanceEnabled: boolean read GetGroupBoxBalanceEnabled;
    property ButtonPrintInvoiceEnabled: Boolean read GetButtonPrintInvoiceEnabled;
    property AniIndicatorProgressVisible: Boolean read GetAniIndicatorProgressVisible;
    property LabelPrintingVisible: Boolean read GetLabelPrintingVisible;
  end;

implementation

end.
