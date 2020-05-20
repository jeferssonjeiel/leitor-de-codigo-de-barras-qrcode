program LeitorTokyoVersion;

uses
  System.StartUpCopy,
  FMX.Forms,
  untFormPrincipal in 'untFormPrincipal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
