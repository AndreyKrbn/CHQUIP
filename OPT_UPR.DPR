program Opt_upr;

uses
  Forms,
  Chquip in 'Chquip.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Optimization';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
