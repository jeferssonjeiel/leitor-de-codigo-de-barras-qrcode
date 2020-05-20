program Servidor;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uServidor in 'uServidor.pas' {frmServidor},
  uSM in 'uSM.pas' {ServerMethods1: TDSServerModule},
  uSC in 'uSC.pas' {ServerContainer1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmServidor, frmServidor);
  Application.CreateForm(TServerContainer1, ServerContainer1);
  Application.Run;
end.

