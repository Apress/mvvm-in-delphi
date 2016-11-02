program POSApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  InvoiceForm in 'InvoiceForm.pas' {SalesInvoiceForm},
  Declarations in 'Declarations.pas',
  Database in 'Database.pas',
  MainScreenForm in 'MainScreenForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
