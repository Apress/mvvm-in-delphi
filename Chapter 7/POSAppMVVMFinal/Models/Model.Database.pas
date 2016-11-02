unit Model.Database;

interface

uses Model.Declarations, System.Generics.Collections, Model.Interfaces;

function CreateDatabaseClass: IDatabaseInterface;

implementation

uses
  System.IniFiles, System.SysUtils, System.IOUtils;

type
  TDatabase = class (TInterfacedObject, IDatabaseInterface)
  private
  const
    SalesSection = 'Sales';
    SalesTotal = 'Total Sales';
  var
    fCustomers: TObjectList<TCustomer>;
    fItems: TObjectList<TItem>;
    fFullFileName: string;
  public
    constructor Create;
    function GetCustomerList: TObjectList<TCustomer>;
    function GetCustomerFromName(const nameStr: string): TCustomer;
    function GetItems: TObjectList<TItem>;
    function GetItemFromDescription(const desc: string): TItem;
    function GetItemFromID(const id: Integer): TItem;
    function GetTotalSales: Currency;
    procedure SaveCurrentSales(const currentSales: Currency);
    destructor Destroy; override;
  end;

function CreateDatabaseClass: IDatabaseInterface;
begin
  result:=TDatabase.Create;
end;
{ TDatabase }

constructor TDatabase.Create;
var
  tmpCustomer: TCustomer;
  tmpItem: TItem;
begin
  inherited;
  fFullFileName:=TPath.Combine(ExtractFilePath(ParamStr(0)), 'POSApp.data');
  fCustomers:=TObjectList<TCustomer>.Create;

  //Create mock customers
  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=1;
  tmpCustomer.Name:='John';
  tmpCustomer.DiscountRate:=12.50;
  tmpCustomer.Balance:=-Random(5000);
  fCustomers.Add(tmpCustomer);

  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=2;
  tmpCustomer.Name:='Alex';
  tmpCustomer.DiscountRate:=23.00;
  tmpCustomer.Balance:=-Random(2780);
  fCustomers.Add(tmpCustomer);

  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=3;
  tmpCustomer.Name:='Peter';
  tmpCustomer.DiscountRate:=0.0;
  tmpCustomer.Balance:=-Random(9000);
  fCustomers.Add(tmpCustomer);

  tmpCustomer:=TCustomer.Create;
  tmpCustomer.ID:=4;
  tmpCustomer.Name:='Retail Customer';
  tmpCustomer.DiscountRate:=0.0;
  tmpCustomer.Balance:=0.0;
  fCustomers.Add(tmpCustomer);


  fItems:=TObjectList<TItem>.Create;
  //Create mock items to sell
  tmpItem:=TItem.Create;
  tmpItem.ID:=100;
  tmpItem.Description:='T-shirt';
  tmpItem.Price:=13.55;
  fItems.Add(tmpItem);

  tmpItem:=TItem.Create;
  tmpItem.ID:=200;
  tmpItem.Description:='Trousers';
  tmpItem.Price:=23.45;
  fItems.Add(tmpItem);

  tmpItem:=TItem.Create;
  tmpItem.ID:=300;
  tmpItem.Description:='Coat';
  tmpItem.Price:=64.00;
  fItems.Add(tmpItem);

  tmpItem:=TItem.Create;
  tmpItem.ID:=400;
  tmpItem.Description:='Shirt';
  tmpItem.Price:=28.00;
  fItems.Add(tmpItem);

end;

destructor TDatabase.Destroy;
begin
  fCustomers.Free;
  fItems.Free;
  inherited;
end;

function TDatabase.GetCustomerFromName(const nameStr: string): TCustomer;
var
  tmpCustomer: TCustomer;
begin
  if not Assigned(fCustomers) then Exit;
  result:=nil;
  for tmpCustomer in fCustomers do
  begin
    if tmpCustomer.Name=nameStr then
    begin
      result:=tmpCustomer;
      exit;
    end;
  end;
end;

function TDatabase.GetCustomerList: TObjectList<TCustomer>;
begin
  result:=fCustomers;
end;

function TDatabase.GetItemFromDescription(const desc: string): TItem;
var
  tmpItem: TItem;
begin
  result:=nil;
  if not Assigned(fItems) then Exit;
  for tmpItem in fItems do
  begin
    if tmpItem.Description=desc then
    begin
      result:=tmpItem;
      exit;
    end;
  end;
end;


function TDatabase.GetItemFromID(const id: Integer): TItem;
var
  tmpItem: TItem;
begin
  result:=nil;
  if not Assigned(fItems) then Exit;
  for tmpItem in fItems do
  begin
    if tmpItem.ID=id then
    begin
      result:=tmpItem;
      exit;
    end;
  end;
end;


function TDatabase.GetItems: TObjectList<TItem>;
begin
  result:=fItems;
end;

function TDatabase.GetTotalSales: Currency;
var
  tmpINIFile: TIniFile;
  amount: Currency;
begin
  amount:=0.00;
  tmpINIFile:=TIniFile.Create(fFullFileName);
  try
    amount:=tmpINIFile.ReadFloat(SalesSection,SalesTotal,0.00);
  finally
    tmpINIFile.Free;
    result:=amount;
  end;

end;


procedure TDatabase.SaveCurrentSales(const currentSales: Currency);
var
  tmpINIFile: TIniFile;
begin
  tmpINIFile:=TIniFile.Create(fFullFileName);
  try
    tmpINIFile.WriteFloat(SalesSection,SalesTotal, GetTotalSales+currentSales);
  finally
    tmpINIFile.Free;
  end;
end;

end.
