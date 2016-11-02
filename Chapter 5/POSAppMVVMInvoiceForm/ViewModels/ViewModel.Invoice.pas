unit ViewModel.Invoice;

interface

uses
  Model.Interfaces;

function CreateInvoiceViewModelClass: IInvoiceViewModelInterface;

implementation

uses
  Model.Declarations, System.SysUtils, System.Generics.Collections;

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
    fPrintingLabelVisible: boolean;
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
  public
    constructor Create;
    property Model: IInvoiceModelInterface read GetModel write SetModel;
    property LabelsText: TInvoiceFormLabelsText read GetLabelsText;
    property TitleText: string read GetTitleText;
    property GroupBoxInvoiceItemsEnabled: boolean read GetGroupBoxInvoiceItemsEnabled;
    property GroupBoxBalanceEnabled: boolean read GetGroupBoxBalanceEnabled;
    property ButtonPrintInvoiceEnabled: Boolean read GetButtonPrintInvoiceEnabled;
    property AniIndicatorProgressVisible: Boolean read GetAniIndicatorProgressVisible;
    property LabelPrintingVisible: Boolean read GetLabelPrintingVisible;
  end;

function CreateInvoiceViewModelClass: IInvoiceViewModelInterface;
begin
  result:=TInvoiceViewModel.Create;
end;

{ TInvoiceViewModel }

constructor TInvoiceViewModel.Create;
begin
  fInvoiceItemsEnabled:=false;
  fBalanceEnabled:=false;
  fPrintButtonEnabled:=false;
  fAniIndicatorVisible:=false;
  fPrintingLabelVisible:=false;
end;

function TInvoiceViewModel.GetAniIndicatorProgressVisible: Boolean;
begin
  result:=fAniIndicatorVisible;
end;

function TInvoiceViewModel.GetButtonPrintInvoiceEnabled: Boolean;
begin
  result:=fPrintButtonEnabled;
end;

procedure TInvoiceViewModel.GetCustomerList(
  var customers: TObjectList<TCustomer>);
begin
  fModel.GetCustomerList(customers);
end;

function TInvoiceViewModel.GetGroupBoxBalanceEnabled: Boolean;
begin
  result:=fBalanceEnabled;
end;

function TInvoiceViewModel.GetGroupBoxInvoiceItemsEnabled: Boolean;
begin
  Result:=fInvoiceItemsEnabled;
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

function TInvoiceViewModel.GetTitleText: string;
var
  tmpInvoice: TInvoice;
begin
  fModel.GetInvoice(tmpInvoice);
  if Assigned(tmpInvoice) then
    result:=fModel.GetInvoiceFormLabelsText.Title+' #'+IntToStr(tmpInvoice.Number)
  else
    result:=fModel.GetInvoiceFormLabelsText.Title;
end;

procedure TInvoiceViewModel.SetModel(const newModel: IInvoiceModelInterface);
begin
  fModel:=newModel;
end;

end.
