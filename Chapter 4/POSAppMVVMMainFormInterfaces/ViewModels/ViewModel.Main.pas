unit ViewModel.Main;

interface

uses Model.Main, Model.Declarations;

type
  TMainViewModel = class
  private
    fModel: TMainModel;
    fLabelsText: TMainFormLabelsText;
    fTotalSalesValue: Currency;
    procedure SetModel (const newModel: TMainModel);
    function GetLabelsText: TMainFormLabelsText;
  public
    property Model: TMainModel read fModel write SetModel;
    property LabelsText: TMainFormLabelsText read GetlabelsText;
    function GetTotalSalesValue: string;
  end;
implementation

uses
  System.SysUtils;

{ TMainViewModel }

function TMainViewModel.GetLabelsText: TMainFormLabelsText;
begin
  fLabelsText:=fModel.GetMainFormLabelsText;
  result:=fLabelsText;
end;

function TMainViewModel.GetTotalSalesValue: string;
begin
  fTotalSalesValue:=fModel.GetTotalSales;
  result:=Format('%10.2f',[fTotalSalesValue]);
end;


procedure TMainViewModel.SetModel(const newModel: TMainModel);
begin
  fModel:=newModel;
end;

end.
