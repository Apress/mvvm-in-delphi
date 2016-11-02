unit View.InvoiceForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls, System.Rtti, FMX.Grid,
  FMX.Layouts, FMX.Objects, FMX.Edit, FMX.ListBox,
  System.Generics.Collections, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Menus, Model.Interfaces;

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
  private
    fViewModel: IInvoiceViewModelInterface;
    procedure SetViewModel (const newViewModel: IInvoiceViewModelInterface);
    procedure UpdateLabels;
    procedure SetupGUI;
    procedure UpdateGroups;
    procedure UpdatePrintingStatus;
  public
    property ViewModel: IInvoiceViewModelInterface read fViewModel write SetViewModel;
  end;

implementation

uses
	Model.Declarations;

{$R *.fmx}

{ TSalesInvoiceForm }

procedure TSalesInvoiceForm.SetupGUI;
var
  tmpCustomerList: TObjectList<TCustomer>;
  tmpCustomer: TCustomer;
  tmpItemsList: TObjectList<TItem>;
  tmpItem: TItem;
begin
  LabelTitle.Text:=fViewModel.TitleText;
  PopupBoxCustomer.Clear;
  PopupBoxItems.Clear;
  StringGridItems.RowCount:=0;
  EditQuantity.Text:='1';

  fViewModel.GetCustomerList(tmpCustomerList);
  if Assigned(tmpCustomerList) then
  begin
    for tmpCustomer in tmpCustomerList  do
      if Assigned(tmpCustomer) then
        PopupBoxCustomer.Items.Add(tmpCustomer.Name);
  end;
  PopupBoxCustomer.ItemIndex:=-1;

  fViewModel.GetItems(tmpItemsList);
  if Assigned(tmpItemsList) then
  begin
    for tmpItem in tmpItemsList do
      if Assigned(tmpItem) then
        PopupBoxItems.Items.Add(tmpItem.Description);
  end;

end;

procedure TSalesInvoiceForm.SetViewModel(
  const newViewModel: IInvoiceViewModelInterface);
begin
  fViewModel:=newViewModel;
  UpdateLabels;
  SetupGUI;
  UpdateGroups;
  UpdatePrintingStatus;
end;

procedure TSalesInvoiceForm.UpdateGroups;
begin
  GroupBoxInvoiceItems.Enabled:=fViewModel.GroupBoxInvoiceItemsEnabled;
  GroupBoxBalance.Enabled:=fViewModel.GroupBoxBalanceEnabled;
  ButtonPrintInvoice.Enabled:=fViewModel.ButtonPrintInvoiceEnabled;
end;

procedure TSalesInvoiceForm.UpdateLabels;
begin
  LabelTitle.Text:=fViewModel.LabelsText.Title;

  GroupBoxCustomerDetails.Text:=fViewModel.LabelsText.CustomerDetailsGroupText;
  LabelCustomer.Text:=fViewModel.LabelsText.CustomerText;
  LabelDiscountRate.Text:=fViewModel.LabelsText.CustomerDiscountRateText;
  LabelOutstandingBalance.Text:=fViewModel.LabelsText.CustomerOutstandingBalanceText;

  GroupBoxInvoiceItems.Text:=fViewModel.LabelsText.InvoiceItemsGroupText;
  LabelItem.Text:=fViewModel.LabelsText.InvoiceItemsText;
  LabelQuantity.Text:=fViewModel.LabelsText.InvoiceItemsQuantityText;
  ButtonAddItem.Text:=fViewModel.LabelsText.InvoiceItemsAddItemButtonText;
  StringColumn1.Header:=fViewModel.LabelsText.InvoiceItemsGridItemText;
  StringColumn2.Header:=fViewModel.LabelsText.InvoiceItemsGridQuantityText;
  StringColumn3.Header:=fViewModel.LabelsText.InvoiceItemsGridUnitPriceText;
  StringColumn4.Header:=fViewModel.LabelsText.InvoiceItemsGridAmountText;

  GroupBoxBalance.Text:=fViewModel.LabelsText.BalanceGroupText;
  LabelInvBalance.Text:=fViewModel.LabelsText.BalanceInvoiceBalanceText;
  CheckBoxDiscount.Text:=fViewModel.LabelsText.BalanceDiscountText;
  LabelTotal.Text:=fViewModel.LabelsText.BalanceTotalText;

  ButtonPrintInvoice.Text:=fViewModel.LabelsText.PrintInvoiceButtonText;
  LabelPrinting.Text:=fViewModel.LabelsText.PrintingText;
  ButtonCancel.Text:=fViewModel.LabelsText.CancelButtonText;

end;

procedure TSalesInvoiceForm.UpdatePrintingStatus;
begin
  AniIndicatorProgress.Visible:=fViewModel.AniIndicatorProgressVisible;
  LabelPrinting.Visible:=fViewModel.LabelPrintingVisible;
end;

end.
