program PkgEditor;

uses
  Windows,
  Forms,
  UFrmPkgEditor in 'UFrmPkgEditor.pas' {FrmPkgEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Falcon C++ Package Editor';
  Application.CreateForm(TFrmPkgEditor, FrmPkgEditor);
  Application.Run;
end.
