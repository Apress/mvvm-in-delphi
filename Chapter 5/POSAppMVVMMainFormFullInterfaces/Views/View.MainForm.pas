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
  Model.ProSu.InterfaceActions;

{$R *.fmx}

{ TMainForm }

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
      LabelTotalSalesFigure.Text:=format('%10.2f',[tmpNotifClass.ActionValue]);
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
  if not Assigned(fViewModel) then
    raise Exception.Create('Main Invoice View Model is required');
  UpdateLabels;
  UpdateTotalSalesFigure;
end;

end.
