unit uServidor;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmServidor = class(TForm)
    Label1: TLabel;
    pnlStatus: TPanel;
    Panel2: TPanel;
    edtPorta: TEdit;
    btnConectar: TButton;
    procedure btnConectarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.dfm}

uses uSC;

procedure TfrmServidor.btnConectarClick(Sender: TObject);
begin
if btnConectar.Caption = 'Conectar' then
     begin
       ServerContainer1.DSTCPServerTransport1.Port := StrToInt(edtPorta.Text);
       ServerContainer1.DSServer1.Start;
       pnlStatus.Color := clGreen;
       pnlStatus.Font.Color := clWindow;
       pnlStatus.Caption := 'CONECTADO ...';
       btnConectar.Caption := 'Desconectar';
     end
  else
     begin
       ServerContainer1.DSServer1.Stop;
       pnlStatus.Color := clRed;
       pnlStatus.Font.Color := clWindow;
       pnlStatus.Caption := 'DESCONECTADO ...';
       btnConectar.Caption := 'Conectar';
     end;
end;

end.

