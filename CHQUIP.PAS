unit Chquip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls;

type
  TFrmMain = class(TForm)
    StrGrd1: TStringGrid;
    LblEdtT: TLabeledEdit;
    LblEdtPo: TLabeledEdit;
    LblEdtPn: TLabeledEdit;
    BtnUpdate: TButton;
    BtnSolve: TButton;
    Memo1: TMemo;
    procedure Update_d(Sender: TObject);
    procedure GetStrGrd1(Sender: TObject);
    procedure GetSolve(Sender: TObject);
    procedure LoadDate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}
const
 tmax=8;
type
 TSolve=(save, change);
 TSSolve=set of TSolve;
 costs=array [0..tmax] of word;
 TMstate=array[0..tmax, 0..tmax] of TSSolve;  {матрица управлений планом}
 TS=array[0..tmax, 0..tmax] of integer;     {оптимальные показатели эффективности}
 Tnode=array[0..tmax-1] of TSSolve;
 TNsolve=array[0..tmax-1] of TSolve;
 TNyear=array[0..tmax] of byte;      {вектор возраста оборуд}

var
 f:textFile;
 Tp,Pn,Po:byte;      {Tp - количество лет плана}
 Pr,Rp:costs;        {производ и ремонт}
 i:0..tmax;
 Mstate:TMstate;
 S:TS;
 Nsolve:TNsolve;  //вектор решени€
 node:Tnode;      //вектор узлов дерева соответственно
 Nyear:TNyear;      {вектор возраста оборуд}

procedure TFrmMain.Update_d(Sender: TObject);  //ќбновление начальных данных
var
 i:0..tmax;
begin
 Tp:=strtoint(trim(LblEdtT.Text));
 Pn:=strtoint(trim(LblEdtPn.Text));
 Po:=strtoint(trim(LblEdtPo.Text));
 StrGrd1.ColCount:=Tp+1;
 for i:=0 to Tp-1 do
  begin
   Pr[i]:=strtoint(trim(StrGrd1.cells[i+1,1]));
   StrGrd1.cells[i+1,0]:=inttostr(i);
  end;
 for i:=0 to Tp-1 do
  begin
   Rp[i]:=strtoint(trim(StrGrd1.cells[i+1,2]));
  end;
end;

procedure TFrmMain.GetStrGrd1(Sender: TObject); //»зменение размере таблицы
begin
 Tp:=strtoint(trim(LblEdtT.Text));
 StrGrd1.ColCount:=Tp+1;
end;

{============================================================================}
{                     √лавна€ процедура                                      }
{============================================================================}

procedure GetMatrixState(Const _Tp,_Pn,_Po:word; Const _Pr,_Rp:costs;
                                       Var _Mstate:TMstate; Var _S:TS);
var
 t,y:byte;                                 {год, возраст оборудовани€}
 I_s,I_ch,I_s_next,I_ch_next:integer;
begin
 {Ётап поп€тного движени€ (заполнение матрицы Mstate)}
  for t:=_Tp-1 downto 0 do       //1
   for y:=0 to t do             //2
     begin
      if (y=0) and (t<>0) then continue;
      if t<>_Tp-1 then
         begin
          I_s_next:=_S[t+1,y+1];
          I_ch_next:=_S[t+1,1];
         end
        else
         begin
          I_s_next:=0;
          I_ch_next:=0;
         end;
      I_s:=_Pr[y]-_Rp[y]+I_s_next;
      I_ch:=_Pr[0]-_Rp[0]-_Pn+_Po+I_ch_next;
      case I_s>I_ch of
        true:  begin
                _Mstate[t,y]:=[save];
                _S[t,y]:=I_s;
               end;
        false: begin
                _Mstate[t,y]:=[change];
                _S[t,y]:=I_ch;
               end;
      end;
      if I_s=I_ch then _Mstate[t,y]:=[save, change];
   end;  //2,1
end;

procedure GetNsolve(Const _Mstate:TMstate;
                     Var Nsolve:TNsolve; Var Nyear:TNyear; Var node:Tnode);
var
 t,y:byte;
// Nyear:array[0..tmax] of byte;      {вектор возраста оборуд.}
function last_node(Const _node:Tnode):byte;
var
 t:byte;
begin
 for t:=Tp-1 downto 0 do
   if not(_node[t]=[]) then
    begin
     result:=t;
     exit;
    end;
 result:=0;
end;

begin
 y:=0;
 Nyear[0]:=0;
 for t:=last_node(node) to Tp-1 do
   begin
    if [save]=_Mstate[t,y] then
          begin
           Nsolve[t]:=save;
           y:=y+1;
           Nyear[t+1]:=y;
          end
        else
          if [change]=_Mstate[t,y] then
                begin
                 NSolve[t]:=change;
                 y:=1;
                 Nyear[t+1]:=y;
                end
              else
               if ([save, change]=_Mstate[t,y]) and (node[t]=[]) then
                      begin
                       Nsolve[t]:=save;
                       node[t]:=[change];
                       y:=y+1;
                       Nyear[t+1]:=y;
                      end
                    else
                      begin
                       Nsolve[t]:=change;
                       node[t]:=[];
                       y:=1;
                       Nyear[t+1]:=y;
                      end;
   end; {for}
end;


procedure TFrmMain.GetSolve(Sender: TObject);
var
 i,t:byte;
function out_node(Const _node:Tnode):boolean;
var
 t:byte;
begin
 for t:=0 to Tp-1 do
  if not(_node[t]=[]) then
   begin
    result:=false;
    exit;
   end;
  result:=true;
end;

function str_u(Const u:Tsolve):shortstring;
begin
 case u of
  save: result:='save';
  change: result:='change';
 end;
end;


begin
 GetMatrixState(Tp,Pn,Po,Pr,Rp,Mstate,S);
 i:=1;
 repeat
  GetNsolve(Mstate,Nsolve,Nyear,node);
  memo1.Lines.Add('–ешение є '+inttostr(i));
  i:=i+1;
  for t:=0 to Tp-1 do
   memo1.Lines.Add('y['+inttostr(t)+']='+inttostr(Nyear[t])+'    U['+inttostr(t)+']='+str_u(Nsolve[t])+';');
  memo1.Lines.Add('y['+inttostr(Tp)+']='+inttostr(Nyear[Tp])+';');
  memo1.Lines.Add('');
 until out_node(node);
 memo1.Lines.Add('=====================================================');
 memo1.Lines.Add('I='+inttostr(S[0,0]));
end;

procedure TFrmMain.LoadDate(Sender: TObject); //«агрузка начальных данных
var
 i:0..tmax;
begin
 AssignFile(f,'.\Date.txt');
 {I-}
 Reset(f);
 If IOResult>0 then
   Rewrite(f);
 {I+}
 readln(f,Tp);
 readln(f,Pn);
 readln(f,Po);
 FrmMain.LblEdtT.Text:=inttostr(Tp);
 FrmMain.LblEdtPn.Text:=inttostr(Pn);
 FrmMain.LblEdtPo.Text:=inttostr(Po);
 FrmMain.StrGrd1.ColCount:=Tp+1;
 FrmMain.StrGrd1.cells[0,1]:='Pr';
 FrmMain.StrGrd1.cells[0,2]:='Rp';
 for i:=0 to Tp-1 do
  begin
   read(f,Pr[i]);
   FrmMain.StrGrd1.cells[i+1,1]:=inttostr(Pr[i]);
   FrmMain.StrGrd1.cells[i+1,0]:=inttostr(i);
  end;
 readln(f);
 for i:=0 to Tp-1 do
  begin
   read(f,Rp[i]);
   FrmMain.StrGrd1.cells[i+1,2]:=inttostr(Rp[i]);
  end;
 CloseFile(f);

end;

end.
