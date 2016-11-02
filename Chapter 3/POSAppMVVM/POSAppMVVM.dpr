program POSAppMVVM;

uses
  EMemLeaks,
  EResLeaks,
  EDialogWinAPIMSClassic,
  EDialogWinAPIEurekaLogDetailed,
  EDialogWinAPIStepsToReproduce,
  EDebugExports,
  EDebugJCL,
  EFixSafeCallException,
  EMapWin32,
  EAppFMX,
  ExceptionLog7,
  System.StartUpCopy,
  FMX.Forms,
  View.MainForm in 'Views\View.MainForm.pas' {MainForm},
  Model.Database in 'Models\Model.Database.pas',
  Model.Declarations in 'Models\Model.Declarations.pas',
  Model.Main in 'Models\Model.Main.pas',
  ViewModel.Main in 'ViewModels\ViewModel.Main.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
