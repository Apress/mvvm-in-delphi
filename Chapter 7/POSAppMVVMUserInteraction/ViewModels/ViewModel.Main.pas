unit ViewModel.Main;

interface

uses Model.Main, Model.Declarations, Model.Interfaces;

function CreateMainViewModelClass: IMainViewModelInterface;

implementation

uses
  System.SysUtils;

type
  TMainViewModel = class(TInterfacedObject, IMainViewModelInterface)
  private
    fModel: IMainModelInterface;
    fLabelsText: TMainFormLabelsText;
    fTotalSalesValue: Currency;
    function GetModel: IMainModelInterface;
    procedure SetModel (const newModel: IMainModelInterface);
    function GetLabelsText: TMainFormLabelsText;
  public
    property Model: IMainModelInterface read fModel write SetModel;
    property LabelsText: TMainFormLabelsText read GetlabelsText;
    function GetTotalSalesValue: string;
  end;


function CreateMainViewModelClass: IMainViewModelInterface;
begin
  result:=TMainViewModel.Create;
end;

{ TMainViewModel }

function TMainViewModel.GetLabelsText: TMainFormLabelsText;
begin
  fLabelsText:=fModel.GetMainFormLabelsText;
  result:=fLabelsText;
end;

function TMainViewModel.GetModel: IMainModelInterface;
begin
  result:=fModel;
end;

function TMainViewModel.GetTotalSalesValue: string;
begin
  fTotalSalesValue:=fModel.GetTotalSales;
  result:=Format('%10.2f',[fTotalSalesValue]);
end;


procedure TMainViewModel.SetModel(const newModel: IMainModelInterface);
begin
  fModel:=newModel;
end;

end.
