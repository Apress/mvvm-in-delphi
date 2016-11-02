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

implementation

end.
