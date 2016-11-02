unit View.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, ViewModel.Main, Model.Main, Model.ProSu.Interfaces,
  Model.Interfaces;

type
  TMainForm = class(TForm)
    LabelTitle: TLabel;
    ButtonInvoice: TButton;
    LabelTotalSalesText: TLabel;
    LabelTotalSalesFigure: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonInvoiceClick(Sender: TObject);
  private
    fViewModel: IMainViewModelInterface;
    fSubscriber: ISubscriberInterface;
    procedure SetViewModel (const newViewModel: IMainViewModelInterface);
    procedure NotificationFromProvider (const notifyClass: INotificationClass);
    procedure UpdateLabels;
    procedure UpdateTotalSalesFigure;
  public
    property ViewModel: IMainViewModelInterface read fViewModel write SetViewModel;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Model.ProSu.Subscriber, Model.Declarations,
  Model.ProSu.InterfaceActions, View.InvoiceForm,
  Model.Invoice, ViewModel.Invoice;

{$R *.fmx}

{ TMainForm }

procedure TMainForm.ButtonInvoiceClick(Sender: TObject);
var
  tmpInvoiceForm: TSalesInvoiceForm;
  invoiceModel: IInvoiceModelInterface;
  invoiceViewModel: IInvoiceViewModelInterface;
begin
  invoiceModel:=CreateInvoiceModelClass;
  invoiceViewModel:=CreateInvoiceViewModelClass;
  invoiceViewModel.Model:=invoiceModel;

  tmpInvoiceForm:=TSalesInvoiceForm.Create(self);
  tmpInvoiceForm.ViewModel:=invoiceViewModel;
  tmpInvoiceForm.Provider.Subscribe(fSubscriber);
  try
    tmpInvoiceForm.ShowModal;
  finally
    tmpInvoiceForm.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fSubscriber:=CreateProSuSubscriberClass;
  fSubscriber.SetUpdateSubscriberMethod(NotificationFromProvider);
end;

procedure TMainForm.NotificationFromProvider(
  const notifyClass: INotificationClass);
var
  tmpNotifClass: TNotificationClass;
begin
  if notifyClass is TNotificationClass then
  begin
    tmpNotifClass:=notifyClass as TNotificationClass;
    if actUpdateTotalSalesFigure in tmpNotifClass.Actions then
      LabelTotalSalesFigure.Text:=fViewModel.GetTotalSalesValue;
  end;
end;

procedure TMainForm.UpdateLabels;
begin
  LabelTitle.Text := fViewModel.LabelsText.Title;
  LabelTotalSalesText.Text := fViewModel.LabelsText.TotalSalesText;
  LabelTotalSalesFigure.Text := fViewModel.GetTotalSalesValue;
end;

procedure TMainForm.UpdateTotalSalesFigure;
begin
  ButtonInvoice.Text := fViewModel.LabelsText.IssueButtonCaption;
end;

procedure TMainForm.SetViewModel(const newViewModel: IMainViewModelInterface);
begin
  fViewModel:=newViewModel;
  UpdateLabels;
  UpdateTotalSalesFigure;
end;

end.
