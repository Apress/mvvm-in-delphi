unit MainScreenForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, InvoiceForm, Database;

type
  TMainForm = class(TForm)
    LabelTitle: TLabel;
    ButtonInvoice: TButton;
    LabelTotalSalesText: TLabel;
    LabelTotalSalesFigure: TLabel;
    procedure ButtonInvoiceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //   Updates the TotalSalesFigure Label with the figure retrieved from the
    //   database.
    procedure UpdateTotalSales;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.ButtonInvoiceClick(Sender: TObject);
var
  tmpInvoiceForm: TSalesInvoiceForm;
begin
  tmpInvoiceForm:=TSalesInvoiceForm.Create(self);
  tmpInvoiceForm.ShowModal;
  UpdateTotalSales;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  UpdateTotalSales;
end;

procedure TMainForm.UpdateTotalSales;
var
  tmpSales: Currency;
  tmpDatabase: TDatabase;
begin
  tmpSales:=0.00;
  tmpDatabase:=TDatabase.Create;
  tmpSales:=tmpDatabase.GetTotalSales;
  tmpDatabase.Free;
  LabelTotalSalesFigure.Text:=Format('%10.2f',[tmpSales]);
end;

end.


uses Database;
