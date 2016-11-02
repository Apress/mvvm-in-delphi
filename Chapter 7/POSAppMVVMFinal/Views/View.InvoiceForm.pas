unit View.InvoiceForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls, System.Rtti, FMX.Grid,
  FMX.Layouts, FMX.Objects, FMX.Edit, FMX.ListBox,
  System.Generics.Collections, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Menus, Model.Interfaces,
  Model.ProSu.Interfaces, Model.ProSu.Subscriber, Model.Declarations;

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
    procedure PopupBoxCustomerChange(Sender: TObject);
    procedure ButtonAddItemClick(Sender: TObject);
    procedure MenuItemDeleteItemClick(Sender: TObject);
    procedure CheckBoxDiscountChange(Sender: TObject);
    procedure ButtonPrintInvoiceClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    fViewModel: IInvoiceViewModelInterface;
    fSubscriber: ISubscriberInterface;
    fCustomerDetailsText: TCustomerDetailsText;
    fInvoiceItemsText: TInvoiceItemsText;
    fProvider: IProviderInterface;
    procedure SetViewModel (const newViewModel: IInvoiceViewModelInterface);
    procedure UpdateLabels;
    procedure SetupGUI;
    procedure UpdateGroups;
    procedure UpdatePrintingStatus;
    procedure UpdateCustomerDetails;
    procedure UpdateInvoiceGrid;
    procedure UpdateBalances;
    procedure NotificationFromProvider (const notifyClass: INotificationClass);
    procedure UpdateMainBalance;
  public
    property ViewModel: IInvoiceViewModelInterface read fViewModel write SetViewModel;
    property Provider: IProviderInterface read fProvider;
  end;

implementation

{$R *.fmx}

uses
  Model.ProSu.InterfaceActions, Model.ProSu.Provider;

{ TSalesInvoiceForm }

procedure TSalesInvoiceForm.ButtonAddItemClick(Sender: TObject);
begin
  fViewModel.ValidateItem(PopupBoxItems.Text);
  fViewModel.ValidateQuantity(EditQuantity.Text);
end;

procedure TSalesInvoiceForm.ButtonCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TSalesInvoiceForm.ButtonPrintInvoiceClick(Sender: TObject);
begin
  fViewModel.PrintInvoice;
end;

procedure TSalesInvoiceForm.CheckBoxDiscountChange(Sender: TObject);
begin
  fViewModel.DiscountApplied:=CheckBoxDiscount.IsChecked;
  fInvoiceItemsText:=fViewModel.InvoiceItemsText;
  UpdateBalances;
end;


procedure TSalesInvoiceForm.MenuItemDeleteItemClick(Sender: TObject);
begin
  if (StringGridItems.Selected>=0) and
      (StringGridItems.Selected<=StringGridItems.RowCount-1) then
    fViewModel.DeleteInvoiceItem(StringGridItems.Cells[4, StringGridItems.Selected]);
end;

procedure TSalesInvoiceForm.NotificationFromProvider(
  const notifyClass: INotificationClass);
var
  tmpNotifClass: TNotificationClass;
  tmpErrorNotifClass: TErrorNotificationClass;
begin
  if notifyClass is TNotificationClass then
  begin
    tmpNotifClass:=notifyClass as TNotificationClass;
    if actInvoiceItemsChanges in tmpNotifClass.Actions then
      UpdateInvoiceGrid;
    if actPrintingStart in tmpNotifClass.Actions then
    begin
      AniIndicatorProgress.Visible:=fViewModel.AniIndicatorProgressVisible;
      LabelPrinting.Visible:=fViewModel.LabelPrintingVisible;
    end;
    if actPrintingFinish in tmpNotifClass.Actions then
    begin
      ShowMessage('Invoice Printed');
      AniIndicatorProgress.Visible:=fViewModel.AniIndicatorProgressVisible;
      LabelPrinting.Visible:=fViewModel.LabelPrintingVisible;
      UpdateMainBalance;
      self.Close;
    end;
  end;
  if notifyClass is TErrorNotificationClass then
  begin
    tmpErrorNotifClass:=notifyClass as TErrorNotificationClass;
    if errInvoiceItemEmpty in tmpErrorNotifClass.Actions then
    begin
      ShowMessage(tmpErrorNotifClass.ActionMessage);
      PopupBoxItems.SetFocus;
      Exit;
    end
    else
    if errInvoiceItemQuantityEmpty in tmpErrorNotifClass.Actions then
    begin
      ShowMessage(tmpErrorNotifClass.ActionMessage);
      EditQuantity.SetFocus;
      Exit;
    end
    else
    if (errInvoiceItemQuantityNonPositive in tmpErrorNotifClass.Actions)
      or (errInvoiceItemQuantityNotNumber in tmpErrorNotifClass.Actions) then
    begin
      ShowMessage(tmpErrorNotifClass.ActionMessage);
      EditQuantity.SelectAll;
      EditQuantity.SetFocus;
      Exit;
    end
    else
    begin
      fViewModel.AddInvoiceItem(PopupBoxItems.Text, EditQuantity.text.ToInteger);
    end;
  end;

end;

procedure TSalesInvoiceForm.PopupBoxCustomerChange(Sender: TObject);
begin
  fViewModel.GetCustomerDetails(PopupBoxCustomer.Text,fCustomerDetailsText);
  fViewModel.DeleteAllInvoiceItems;
  PopupBoxItems.ItemIndex:=-1;
  UpdateCustomerDetails;
end;

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

  fViewModel.GetCustomerDetails('', fCustomerDetailsText);
  UpdateCustomerDetails;
  UpdateInvoiceGrid;
  UpdateGroups;
end;

procedure TSalesInvoiceForm.SetViewModel(
  const newViewModel: IInvoiceViewModelInterface);
begin
  fViewModel:=newViewModel;
  if not Assigned(fViewModel) then
    raise Exception.Create('Sales Invoice View Model is required');
  fSubscriber:=CreateProSuSubscriberClass;
  fSubscriber.SetUpdateSubscriberMethod(NotificationFromProvider);
  fViewModel.Provider.Subscribe(fSubscriber);
  UpdateLabels;
  SetupGUI;
  UpdateGroups;
  UpdatePrintingStatus;
  fInvoiceItemsText:=fViewModel.InvoiceItemsText;
  UpdateBalances;
  fProvider:=CreateProSuProviderClass;
end;

procedure TSalesInvoiceForm.UpdateBalances;
begin
  LabelRunningBalance.Text:=fInvoiceItemsText.InvoiceRunningBalance;
  LabelDiscount.Text:=fInvoiceItemsText.InvoiceDiscountFigure;
  LabelInvoiceBalance.Text:=fInvoiceItemsText.InvoiceTotalBalance;
  LabelTotalBalance.Text:=fInvoiceItemsText.InvoiceTotalBalance;
  CheckBoxDiscount.IsChecked:=fViewModel.DiscountApplied;
end;

procedure TSalesInvoiceForm.UpdateCustomerDetails;
begin
  LabelDiscountRateFigure.Text:=fCustomerDetailsText.DiscountRate;
  LabelTotalBalanceBig.Text:=fCustomerDetailsText.OutstandingBalance;

  UpdateInvoiceGrid;
  UpdateGroups;
end;

procedure TSalesInvoiceForm.UpdateGroups;
begin
  GroupBoxInvoiceItems.Enabled:=fViewModel.GroupBoxInvoiceItemsEnabled;
  GroupBoxBalance.Enabled:=fViewModel.GroupBoxBalanceEnabled;
  ButtonPrintInvoice.Enabled:=fViewModel.ButtonPrintInvoiceEnabled;
end;

procedure TSalesInvoiceForm.UpdateInvoiceGrid;
var
  i: Integer;
begin
  StringGridItems.RowCount:=0;
  fInvoiceItemsText:=fViewModel.InvoiceItemsText;
  for i := 0 to Length(fInvoiceItemsText.DescriptionText)-1 do
  begin
    StringGridItems.RowCount:=StringGridItems.RowCount+1;
    StringGridItems.Cells[0,StringGridItems.RowCount-1]:=fInvoiceItemsText.DescriptionText[i];
    StringGridItems.Cells[1, StringGridItems.RowCount-1]:=fInvoiceItemsText.QuantityText[i];
    StringGridItems.Cells[2, StringGridItems.RowCount-1]:=fInvoiceItemsText.UnitPriceText[i];
    StringGridItems.Cells[3, StringGridItems.RowCount-1]:=fInvoiceItemsText.PriceText[i];
    StringGridItems.Cells[4, StringGridItems.RowCount-1]:=fInvoiceItemsText.IDText[i];
  end;
  UpdateBalances;
  UpdateGroups;
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

procedure TSalesInvoiceForm.UpdateMainBalance;
var
  tmpNotificationClass: TNotificationClass;
begin
  tmpNotificationClass:=TNotificationClass.Create;
  tmpNotificationClass.Actions:=[actUpdateTotalSalesFigure];
  if Assigned(fProvider) then
   fProvider.NotifySubscribers(tmpNotificationClass);
  tmpNotificationClass.Free;
end;

procedure TSalesInvoiceForm.UpdatePrintingStatus;
begin
  AniIndicatorProgress.Visible:=fViewModel.AniIndicatorProgressVisible;
  LabelPrinting.Visible:=fViewModel.LabelPrintingVisible;
end;

end.
