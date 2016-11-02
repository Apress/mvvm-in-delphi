program POSAppMVVMMainFormTest;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.MainForm in 'Views\View.MainForm.pas' {MainForm},
  ViewModel.Main in 'ViewModels\ViewModel.Main.pas',
  Model.Database in 'Models\Model.Database.pas',
  Model.Main in 'Models\Model.Main.pas',
  Model.ProSu.Interfaces in 'SupportCode\Model.ProSu.Interfaces.pas',
  Model.ProSu.Provider in 'SupportCode\Model.ProSu.Provider.pas',
  Model.ProSu.Subscriber in 'SupportCode\Model.ProSu.Subscriber.pas',
  View.TestPrintInvoice in 'Views\View.TestPrintInvoice.pas' {TestPrintInvoiceForm},
  Model.ProSu.InterfaceActions in 'SupportCode\Model.ProSu.InterfaceActions.pas',
  Model.Declarations in 'Models\Model.Declarations.pas';

{$R *.res}

var
   mainModel: TMainModel;
   mainViewModel: TMainViewModel;

begin
  mainModel:=TMainModel.Create;
  mainViewModel:=TMainViewModel.Create;
  mainViewModel.Model:=mainModel;

  Application.Initialize;

  MainForm:=TMainForm.Create(Application);
  MainForm.ViewModel:=mainViewModel;

  Application.MainForm:=MainForm;
  MainForm.Show;
  Application.CreateForm(TTestPrintInvoiceForm, TestPrintInvoiceForm);
  Application.Run;

end.
