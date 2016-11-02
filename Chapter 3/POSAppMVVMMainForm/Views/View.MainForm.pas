unit View.MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, ViewModel.Main, Model.Main;

type
  TMainForm = class(TForm)
    LabelTitle: TLabel;
    ButtonInvoice: TButton;
    LabelTotalSalesText: TLabel;
    LabelTotalSalesFigure: TLabel;
    procedure FormDestroy(Sender: TObject);
  private
    fViewModel: TMainViewModel;
    procedure SetViewModel (const newViewModel: TMainViewModel);
    procedure UpdateLabels;
    procedure UpdateTotalSalesFigure;
  public
    property ViewModel: TMainViewModel read fViewModel write SetViewModel;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}


{ TMainForm }

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fViewModel.Model.Free;
  fViewModel.Free;
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

procedure TMainForm.SetViewModel(const newViewModel: TMainViewModel);
begin
  fViewModel:=newViewModel;
  if not Assigned(fViewModel) then
    raise Exception.Create('Main View Model is required');
  UpdateLabels;
  UpdateTotalSalesFigure;
end;

end.
