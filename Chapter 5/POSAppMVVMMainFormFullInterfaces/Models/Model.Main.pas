unit Model.Main;

interface

uses Model.Declarations, Model.Database, Model.Interfaces;

function CreateMainModelClass: IMainModelInterface;

implementation

uses
  System.SysUtils;

type
  TMainModel = class(TInterfacedObject, IMainModelInterface)
  private
    fMainFormLabelsText: TMainFormLabelsText;
    fDatabase: IDatabaseInterface;
  public
    function GetMainFormLabelsText: TMainFormLabelsText;
    function GetTotalSales: Currency;
    constructor Create;
  end;


function CreateMainModelClass: IMainModelInterface;
begin
  result:=TMainModel.Create;
end;

{ TMainModel }

constructor TMainModel.Create;
begin
  fDatabase:=CreateDatabaseClass;
end;


function TMainModel.GetMainFormLabelsText: TMainFormLabelsText;
begin
  fMainFormLabelsText.Title:='Main Screen';
  fMainFormLabelsText.IssueButtonCaption:='Issue Invoice';
  fMainFormLabelsText.TotalSalesText:='Total Sales:';
  result:=fMainFormLabelsText;
end;

function TMainModel.GetTotalSales: Currency;
begin
  result:=fDatabase.GetTotalSales;
end;

end.
