unit untForm1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.Permissions, System.Threading

  ,ZXing.ScanManager, ZXing.BarcodeFormat, ZXing.ReadResult

  {$IFDEF ANDROID}
    ,Androidapi.Jni.Os,
    Androidapi.Jni.Widget,
    Androidapi.Helpers,
    Androidapi.Jni.JavaTypes,
    Androidapi.JniBridge,
    Androidapi.Jni.GraphicsContentViewText,
    FMX.DialogService.Async,
    FMX.Helpers.Android,
    Androidapi.JNI.App, FMX.Objects, FMX.Media, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts
  {$ENDIF}

  ;

type
  TFormPrincipal = class(TForm)
    ToolBar1: TToolBar;
    btnCamera: TSpeedButton;
    Label1: TLabel;
    CameraComponent: TCameraComponent;
    imgCameraView: TImage;
    MemoLog: TMemo;
    procedure btnCameraClick(Sender: TObject);
    procedure TransparentStatusBar;
    procedure Leitura;
    procedure CameraComponentSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure FormCreate(Sender: TObject);
  private
    IsEscaneando : boolean;
    Frame: integer;
  public
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;
  FScanManager, FReadResult: TScanManager;

implementation

{$R *.fmx}

procedure TFormPrincipal.btnCameraClick(Sender: TObject);
  begin
    PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.CAMERA)],
      procedure (const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
        begin
          if (Length(AGrantResults) = 1) and (AGrantResults[0] = TPermissionStatus.Granted) then
            begin
              CameraComponent.Quality := TVideoCaptureQuality.MediumQuality;
              CameraComponent.Kind := TCameraKind.BackCamera;
              CameraComponent.FocusMode := TFocusMode.ContinuousAutoFocus;
              CameraComponent.Active := true;
              //ShowMessage('Acesso a Camera FOI PERMITIDO');
            end
          else
            begin
              ShowMessage('Acesso a Camera NÃO FOI PERMITIDO');
            end;
        end
    );
  end;

procedure TFormPrincipal.CameraComponentSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
  begin
    TThread.Synchronize(TThread.CurrentThread, Leitura);
  end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
  begin
    TransparentStatusBar;
    //FScanManager := TScanManager.Create(TBarcodeFormat.CODE_128, nil);
    FScanManager := TScanManager.Create(TBarcodeFormat.ITF, nil);
  end;

procedure TFormPrincipal.Leitura;
  var scanBitmap: TBitmap;
      ReadResult: TReadResult;
  begin
    CameraComponent.SampleBufferToBitmap(imgCameraView.Bitmap, True);

  if (IsEscaneando) then begin exit; end;

  { This code will take every 4 frame. }
  inc(Frame); if (Frame mod 4 <> 0) then begin exit; end;

  scanBitmap := TBitmap.Create();
  scanBitmap.Assign(imgCameraView.Bitmap);
  ReadResult := nil;

// There is bug in Delphi Berlin 10.1 update 2 which causes the TTask and
// the TThread.Synchronize to cause exceptions.
// See: https://quality.embarcadero.com/browse/RSP-16377?jql=project%20%3D%20RSP%20AND%20issuetype%20%3D%20Bug%20AND%20affectedVersion%20%3D%20%2210.1%20Berlin%20Update%202%22%20AND%20status%20%3D%20Open%20ORDER%20BY%20priority%20DESC

  TTask.Run(procedure begin try IsEscaneando := True; try ReadResult := FScanManager.Scan(scanBitmap); except on E:  Exception do begin TThread.Synchronize(nil, procedure begin label1.Text := E.Message; end); exit; end; end;

        TThread.Synchronize(nil, procedure begin if (length(label1.Text) > 10) then begin label1.Text := '*'; end;

            label1.Text := label1.Text + '*';

			if (ReadResult <> nil) then begin MemoLog.Lines.Insert(0, ReadResult.Text); end;

          end);

      finally
        ReadResult.Free;
        scanBitmap.Free;
        IsEscaneando := false;
      end;

    end);
  end;

procedure TFormPrincipal.TransparentStatusBar;
var activity : JActivity;
    window : JWindow;
  begin
    activity := TAndroidHelper.Activity;
	  window := activity.getWindow;

	 //window.setFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_TRANSLUCENT_STATUS,
	 //TJWindowManager_LayoutParams.JavaClass.FLAG_TRANSLUCENT_STATUS);

    window.setFlags(TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS,
	  TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS);
  end;

end.
