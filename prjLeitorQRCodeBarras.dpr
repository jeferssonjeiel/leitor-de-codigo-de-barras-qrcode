program prjLeitorQRCodeBarras;

uses
  System.StartUpCopy,
  FMX.Forms,
  untForm1 in 'untForm1.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
