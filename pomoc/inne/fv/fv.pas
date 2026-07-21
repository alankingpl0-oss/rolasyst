program RolAsyst;

uses
  App, Objects, Menus, Views, Dialogs, Drivers, MsgBox, SysUtils;

const
  wer = '1.06.2';
  kompilacja = '2';

  { Commands }
  cmCalculate = 1001;
  cmAbout     = 1002;
  cmDebug     = 1003;

type
  TRolApp = object(TApplication)
    constructor Init;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure DoCalculate;
    procedure DoAbout;
    procedure DoDebug;
    procedure DoSaveReportToFile(wyn_pal: Double; g_godz, g_min: Integer; wyn_koszt, CenaVal, wyn_prac, wyn_ost: Double);
  end;

constructor TRolApp.Init;
begin
  inherited Init;
end;

procedure TRolApp.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~P~lik', hcNoContext, NewMenu(
      NewItem('~N~owe obliczenia...', 'F2', kbF2, cmCalculate, hcNoContext,
      NewItem('O ~p~rogramie...', '', 0, cmAbout, hcNoContext,
      NewItem('Menu ~d~ebugowania...', '', 0, cmDebug, hcNoContext,
      NewLine(
      NewItem('W~y~jście', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)))))),
    nil)
  )));
end;

procedure TRolApp.InitStatusLine;
var
  R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('~F2~ Obliczenia', kbF2, cmCalculate,
      NewStatusKey('~Alt-X~ Wyjście', kbAltX, cmQuit,
      nil)),
    nil)
  ));
end;

procedure TRolApp.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmCalculate: begin
        DoCalculate;
        ClearEvent(Event);
      end;
      cmAbout: begin
        DoAbout;
        ClearEvent(Event);
      end;
      cmDebug: begin
        DoDebug;
        ClearEvent(Event);
      end;
    end;
  end;
end;

function TryGetReal(const S: String; var V: Double): Boolean;
var
  Temp: String;
  Code: Integer;
  DoubleVal: Double;
begin
  Temp := Trim(S);
  while Pos(',', Temp) > 0 do
    Temp[Pos(',', Temp)] := '.';
  Val(Temp, DoubleVal, Code);
  if Code = 0 then
  begin
    V := DoubleVal;
    TryGetReal := True;
  end
  else
    TryGetReal := False;
end;

procedure TRolApp.DoAbout;
begin
  MessageBox('RolAsyst v' + wer + #13 + 'Kompilacja: ' + kompilacja + #13 + 'Free Vision Edition', nil, mfInformation or mfOKButton);
end;

procedure TRolApp.DoDebug;
var
  DebugDlg: PDialog;
  R: TRect;
  RadioDebug: PRadioButtons;
  Sel: Word;
begin
  R.Assign(15, 5, 65, 15);
  DebugDlg := New(PDialog, Init(R, 'MENU DEBUG'));
  
  R.Assign(2, 2, 45, 5);
  RadioDebug := New(PRadioButtons, Init(R,
    NewSItem('1. Informacje o wersji',
    NewSItem('0. Powrot',
    nil))
  ));
  DebugDlg^.Insert(RadioDebug);
  
  R.Assign(15, 6, 27, 8);
  DebugDlg^.Insert(New(PButton, Init(R, 'OK', cmOK, bfDefault)));
  
  Sel := 0;
  RadioDebug^.SetData(Sel);
  
  if Desktop^.ExecView(DebugDlg) = cmOK then
  begin
    RadioDebug^.GetData(Sel);
    Dispose(DebugDlg, Done);
    if Sel = 0 then
    begin
      MessageBox('Wersja ' + wer + ', kompilacja ' + kompilacja + '.', nil, mfInformation or mfOKButton);
      DoDebug;
    end;
  end
  else
    Dispose(DebugDlg, Done);
end;

procedure TRolApp.DoSaveReportToFile(wyn_pal: Double; g_godz, g_min: Integer; wyn_koszt, CenaVal, wyn_prac, wyn_ost: Double);
var
  SaveDlg: PDialog;
  R: TRect;
  InputName: PInputLine;
  FileName: String;
  Plyk: Text;
  ErrCode: Integer;
begin
  R.Assign(15, 5, 65, 13);
  SaveDlg := New(PDialog, Init(R, 'Zapis raportu'));
  
  R.Assign(2, 2, 45, 3);
  SaveDlg^.Insert(New(PStaticText, Init(R, 'Podaj nazwe pliku (domyslnie RAPORT.TXT):')));
  
  R.Assign(2, 4, 45, 5);
  InputName := New(PInputLine, Init(R, 50));
  SaveDlg^.Insert(InputName);
  FileName := 'RAPORT.TXT';
  InputName^.SetData(FileName);
  
  R.Assign(10, 6, 22, 8);
  SaveDlg^.Insert(New(PButton, Init(R, 'Zapisz', cmOK, bfDefault)));
  R.Assign(25, 6, 37, 8);
  SaveDlg^.Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));
  
  if Desktop^.ExecView(SaveDlg) = cmOK then
  begin
    InputName^.GetData(FileName);
    FileName := Trim(FileName);
    
    { Clean null terminator if present }
    if Pos(#0, FileName) > 0 then
      FileName := Copy(FileName, 1, Pos(#0, FileName) - 1);
      
    FileName := Trim(FileName);
    
    if FileName = '' then
      FileName := 'RAPORT.TXT';
      
    if (FileName = 'n') or (FileName = 'N') then
    begin
      Dispose(SaveDlg, Done);
      Exit;
    end;
    
    if LowerCase(FileName) = 'microsoft.txt' then
    begin
      MessageBox('Nie. Po prostu nie.' + #13 + 'Ten blad trzeba skorygowac.', nil, mfWarning or mfOKButton);
      FileName := 'TylkoLinux!!.txt';
    end
    else if LowerCase(FileName) = 'raport_2008.txt' then
    begin
      MessageBox('Pomidor.', nil, mfInformation or mfOKButton);
      FileName := 'raport_2012.txt';
    end
    else if LowerCase(FileName) = '2008.txt' then
    begin
      MessageBox('Skorygowano blad.', nil, mfInformation or mfOKButton);
      FileName := '2012.txt';
    end;
    
    System.Assign(Plyk, FileName);
    {$I-}
    System.Rewrite(Plyk);
    ErrCode := IOResult;
    {$I+}
    if ErrCode <> 0 then
    begin
      MessageBox('Blad podczas zapisu do pliku: ' + FileName + ' (Kod bledu: ' + IntToStr(ErrCode) + ')', nil, mfError or mfOKButton);
    end
    else
    begin
      writeln(Plyk, '=== RAPORT ===');
      writeln(Plyk, 'Potrzebne paliwo: ........................ ', wyn_pal:0:2, ' litrow');
      writeln(Plyk, 'Potrzebny czas: .......................... ', Format('%d:%.2d', [g_godz, g_min]), ' godzin');
      writeln(Plyk, 'Koszt paliwa: ............................ ', wyn_koszt:0:2 , ' przy cenie za litr PLN ', CenaVal:0:2);
      writeln(Plyk, 'Pracownik: ............................... ', wyn_prac:0:2 , ' zl');
      writeln(Plyk, 'Ostateczny koszt (w tym ukryte koszty): .. ', wyn_ost:0:2 , ' zl');
      writeln(Plyk);
      writeln(Plyk, 'Dane te sa wyliczony do typowych prac polowych,');
      writeln(Plyk, 'jednak przy ciezkiej orce czy gliniastej');
      writeln(Plyk, 'glebie zuzycie i wydajnosc moze ulec zmianie');
      writeln(Plyk);
      System.Close(Plyk);
      
      MessageBox('Raport zapisany do pliku: ' + FileName, nil, mfInformation or mfOKButton);
    end;
  end;
  Dispose(SaveDlg, Done);
end;

procedure TRolApp.DoCalculate;
var
  DataDlg: PDialog;
  R: TRect;
  InputPole, InputPraSt, InputCena: PInputLine;
  PoleStr, PraStStr, CenaStr: String;
  PoleVal, PraStVal, CenaVal: Double;
  ValidData: Boolean;
  
  TractorDlg: PDialog;
  RadioTractor: PRadioButtons;
  TractorSel: Word;
  
  JobDlg: PDialog;
  RadioJob: PRadioButtons;
  JobSel: Word;
  
  ManualDlg: PDialog;
  InputZuzycie, InputWydaj: PInputLine;
  ZuzycieStr, WydajStr: String;
  ZuzycieVal, WydajVal: Double;
  
  ReportDlg: PDialog;
  S1, S2, S3, S4, S5: String;
  
  zuzycie, wydaj: Double;
  wyn_pal, wyn_czas, wyn_koszt, wyn_prac, wyn_sur, wyn_ost: Double;
  g_godz, g_min: Integer;
begin
  PoleStr := '0.0';
  PraStStr := '0.0';
  CenaStr := '0.0';
  
  ValidData := False;
  while not ValidData do
  begin
    R.Assign(15, 3, 65, 17);
    DataDlg := New(PDialog, Init(R, 'Dane podstawowe'));
    
    R.Assign(2, 2, 45, 3);
    DataDlg^.Insert(New(PStaticText, Init(R, 'Powierzchnia pola w hektarach:')));
    R.Assign(2, 3, 20, 4);
    InputPole := New(PInputLine, Init(R, 15));
    DataDlg^.Insert(InputPole);
    InputPole^.SetData(PoleStr);
    
    R.Assign(2, 5, 45, 6);
    DataDlg^.Insert(New(PStaticText, Init(R, 'Stawka pracownika za godzine (0 = brak):')));
    R.Assign(2, 6, 20, 7);
    InputPraSt := New(PInputLine, Init(R, 15));
    DataDlg^.Insert(InputPraSt);
    InputPraSt^.SetData(PraStStr);
    
    R.Assign(2, 8, 45, 9);
    DataDlg^.Insert(New(PStaticText, Init(R, 'Cena paliwa za litr (PLN):')));
    R.Assign(2, 9, 20, 10);
    InputCena := New(PInputLine, Init(R, 15));
    DataDlg^.Insert(InputCena);
    InputCena^.SetData(CenaStr);
    
    R.Assign(10, 12, 22, 14);
    DataDlg^.Insert(New(PButton, Init(R, 'Dalej', cmOK, bfDefault)));
    R.Assign(25, 12, 37, 14);
    DataDlg^.Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));
    
    if Desktop^.ExecView(DataDlg) <> cmOK then
    begin
      Dispose(DataDlg, Done);
      Exit;
    end;
    
    InputPole^.GetData(PoleStr);
    InputPraSt^.GetData(PraStStr);
    InputCena^.GetData(CenaStr);
    
    Dispose(DataDlg, Done);
    
    if not TryGetReal(PoleStr, PoleVal) then
    begin
      MessageBox('Nieprawidlowa wartosc powierzchni pola!', nil, mfError or mfOKButton);
      Continue;
    end;
    
    if not TryGetReal(PraStStr, PraStVal) then
    begin
      MessageBox('Nieprawidlowa stawka pracownika!', nil, mfError or mfOKButton);
      Continue;
    end;
    
    if not TryGetReal(CenaStr, CenaVal) then
    begin
      MessageBox('Nieprawidlowa cena paliwa!', nil, mfError or mfOKButton);
      Continue;
    end;
    
    if PoleVal = 2012 then
    begin
      DoDebug;
      Continue;
    end;
    
    if PoleVal = 2008 then
    begin
      MessageBox('Nie.', nil, mfError or mfOKButton);
      Exit;
    end;
    
    if PoleVal < 0.00001 then
    begin
      MessageBox('Nie. Tym razem zwaliles to koncertowo.', nil, mfError or mfOKButton);
      Continue;
    end;
    
    if PoleVal < 0.04 then
    begin
      MessageBox('A wiec to tylko przydomowy ogrodek?', nil, mfInformation or mfOKButton);
    end;
    
    if PraStVal >= 250 then
    begin
      MessageBox('Nie. Nie, lepiej znajdz innego pracownika.' + #13 + 'Nie wolisz wydac tych pieniedzy na cos lepszego?', nil, mfError or mfOKButton);
      Continue;
    end;
    
    if PraStVal > 140 then
    begin
      MessageBox('Troche duzo... Nie szkoda Ci tych pieniedzy?', nil, mfWarning or mfOKButton);
    end
    else if (PraStVal > 0) and (PraStVal < 30) then
    begin
      MessageBox('TO SIE NAPRAWDE OPLACA!', nil, mfInformation or mfOKButton);
    end
    else if (PraStVal >= 30) and (PraStVal < 70) then
    begin
      MessageBox('To sie oplaca.', nil, mfInformation or mfOKButton);
    end;
    
    if CenaVal > 20 then
    begin
      MessageBox('Troche za duzo.', nil, mfError or mfOKButton);
      Continue;
    end;
    
    if (CenaVal > 0) and (CenaVal < 3) then
    begin
      MessageBox('Co tak malo?!' + #13 + 'Naprawde tak tanio Ci dali paliwo?', nil, mfWarning or mfOKButton);
    end;
    
    ValidData := True;
  end;

  R.Assign(15, 3, 65, 17);
  TractorDlg := New(PDialog, Init(R, 'Wybor ciagnika'));
  
  R.Assign(2, 2, 45, 11);
  RadioTractor := New(PRadioButtons, Init(R,
    NewSItem('1. Ursus C-330',
    NewSItem('2. Ursus C-360',
    NewSItem('3. Zetor 7211',
    NewSItem('4. Claas Axion Terra Trac',
    NewSItem('5. Zetor Crystal 160',
    NewSItem('6. Mercedes MB-Trac 800',
    NewSItem('0. Inny (wpisz dane recznie)',
    nil)))))))
  ));
  TractorDlg^.Insert(RadioTractor);
  
  R.Assign(10, 12, 22, 14);
  TractorDlg^.Insert(New(PButton, Init(R, 'Dalej', cmOK, bfDefault)));
  R.Assign(25, 12, 37, 14);
  TractorDlg^.Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));
  
  TractorSel := 0;
  RadioTractor^.SetData(TractorSel);
  
  if Desktop^.ExecView(TractorDlg) <> cmOK then
  begin
    Dispose(TractorDlg, Done);
    Exit;
  end;
  
  RadioTractor^.GetData(TractorSel);
  Dispose(TractorDlg, Done);

  zuzycie := 0.0;
  wydaj := 1.0;

  if TractorSel = 6 then
  begin
    ZuzycieStr := '0.0';
    WydajStr := '1.0';
    
    ValidData := False;
    while not ValidData do
    begin
      R.Assign(15, 5, 65, 15);
      ManualDlg := New(PDialog, Init(R, 'Konfiguracja reczna'));
      
      R.Assign(2, 2, 45, 3);
      ManualDlg^.Insert(New(PStaticText, Init(R, 'Zuzycie paliwa (litry na hektar):')));
      R.Assign(2, 3, 20, 4);
      InputZuzycie := New(PInputLine, Init(R, 15));
      ManualDlg^.Insert(InputZuzycie);
      InputZuzycie^.SetData(ZuzycieStr);
      
      R.Assign(2, 5, 45, 6);
      ManualDlg^.Insert(New(PStaticText, Init(R, 'Wydajnosc pracy (hektary na godzine):')));
      R.Assign(2, 6, 20, 7);
      InputWydaj := New(PInputLine, Init(R, 15));
      ManualDlg^.Insert(InputWydaj);
      InputWydaj^.SetData(WydajStr);
      
      R.Assign(10, 8, 22, 10);
      ManualDlg^.Insert(New(PButton, Init(R, 'OK', cmOK, bfDefault)));
      R.Assign(25, 8, 37, 10);
      ManualDlg^.Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));
      
      if Desktop^.ExecView(ManualDlg) <> cmOK then
      begin
        Dispose(ManualDlg, Done);
        Exit;
      end;
      
      InputZuzycie^.GetData(ZuzycieStr);
      InputWydaj^.GetData(WydajStr);
      Dispose(ManualDlg, Done);
      
      if not TryGetReal(ZuzycieStr, ZuzycieVal) or not TryGetReal(WydajStr, WydajVal) then
      begin
        MessageBox('Nieprawidlowe dane!', nil, mfError or mfOKButton);
        Continue;
      end;
      
      if WydajVal <= 0.0 then
      begin
        MessageBox('Wydajnosc musi byc wieksza od 0!', nil, mfError or mfOKButton);
        Continue;
      end;
      
      ValidData := True;
    end;
    zuzycie := ZuzycieVal;
    wydaj := WydajVal;
  end
  else
  begin
    R.Assign(15, 3, 65, 17);
    JobDlg := New(PDialog, Init(R, 'Wybor pracy'));
    
    case TractorSel of
      0: begin
           R.Assign(2, 2, 45, 7);
           RadioJob := New(PRadioButtons, Init(R,
             NewSItem('1. Lekka kultywacja / Bronowanie',
             NewSItem('2. Koszenie kosiarka rotacyjna',
             NewSItem('3. Orka lekka (plug 2-skibowy)',
             nil)))
           ));
         end;
      1: begin
           R.Assign(2, 2, 45, 7);
           RadioJob := New(PRadioButtons, Init(R,
             NewSItem('1. Bronowanie / Siew',
             NewSItem('2. Praca z prasa zwijajaca',
             NewSItem('3. Orka (plug 3-skibowy)',
             nil)))
           ));
         end;
      2: begin
           R.Assign(2, 2, 45, 7);
           RadioJob := New(PRadioButtons, Init(R,
             NewSItem('1. Siewnik / Lekka uprawa',
             NewSItem('2. Prace transportowe',
             NewSItem('3. Orka gleboka',
             nil)))
           ));
         end;
      3: begin
           R.Assign(2, 2, 45, 9);
           RadioJob := New(PRadioButtons, Init(R,
             NewSItem('1. Lekka orka (5 metrow)',
             NewSItem('2. Ciezka orka (13 metrow)',
             NewSItem('3. Siew (agregat 3 m)',
             NewSItem('4. Siew (agregat 8 m)',
             NewSItem('5. Koszenie trawy 6 m',
             nil)))))
           ));
         end;
      4: begin
           R.Assign(2, 2, 45, 8);
           RadioJob := New(PRadioButtons, Init(R,
             NewSItem('1. Lekka orka (5 metrow)',
             NewSItem('2. Nawozenie',
             NewSItem('3. Siew (agregat 3 m)',
             NewSItem('4. Koszenie trawy 6 m',
             nil))))
           ));
         end;
      5: begin
           R.Assign(2, 2, 45, 8);
           RadioJob := New(PRadioButtons, Init(R,
             NewSItem('1. Wciaganie drzewa 600 kg',
             NewSItem('2. Wciganie drzewa 900 kg',
             NewSItem('3. Siew (agregat 3 m)',
             NewSItem('4. Gleboka orka 5 m',
             nil))))
           ));
         end;
    end;
    
    JobDlg^.Insert(RadioJob);
    
    R.Assign(10, 12, 22, 14);
    JobDlg^.Insert(New(PButton, Init(R, 'Dalej', cmOK, bfDefault)));
    R.Assign(25, 12, 37, 14);
    JobDlg^.Insert(New(PButton, Init(R, 'Anuluj', cmCancel, bfNormal)));
    
    JobSel := 0;
    RadioJob^.SetData(JobSel);
    
    if Desktop^.ExecView(JobDlg) <> cmOK then
    begin
      Dispose(JobDlg, Done);
      Exit;
    end;
    
    RadioJob^.GetData(JobSel);
    Dispose(JobDlg, Done);
    
    case TractorSel of
      0: begin
           case JobSel of
             0: begin zuzycie := 5.0; wydaj := 0.9; end;
             1: begin zuzycie := 6.5; wydaj := 0.7; end;
             2: begin zuzycie := 8.5; wydaj := 0.4; end;
           end;
         end;
      1: begin
           case JobSel of
             0: begin zuzycie := 7.0; wydaj := 1.4; end;
             1: begin zuzycie := 9.5; wydaj := 1.0; end;
             2: begin zuzycie := 12.5; wydaj := 0.6; end;
           end;
         end;
      2: begin
           case JobSel of
             0: begin zuzycie := 8.5; wydaj := 1.6; end;
             1: begin zuzycie := 10.0; wydaj := 1.5; end;
             2: begin zuzycie := 14.0; wydaj := 0.8; end;
           end;
         end;
      3: begin
           case JobSel of
             0: begin zuzycie := 22.2; wydaj := 5.5; end;
             1: begin zuzycie := 34.7; wydaj := 8.3; end;
             2: begin zuzycie := 9.1; wydaj := 2.5; end;
             3: begin zuzycie := 14.4; wydaj := 5.1; end;
             4: begin zuzycie := 7.0; wydaj := 9.6; end;
           end;
         end;
      4: begin
           case JobSel of
             0: begin zuzycie := 4.85; wydaj := 2.72; end;
             1: begin zuzycie := 7.01; wydaj := 2.43; end;
             2: begin zuzycie := 14.65; wydaj := 1.42; end;
             3: begin zuzycie := 2.22; wydaj := 9.43; end;
           end;
         end;
      5: begin
           case JobSel of
             0: begin zuzycie := 20.83; wydaj := 0.32; end;
             1: begin zuzycie := 22.65; wydaj := 0.31; end;
             2: begin zuzycie := 2.65; wydaj := 5.42; end;
             3: begin zuzycie := 11.33; wydaj := 2.07; end;
           end;
         end;
    end;
  end;

  wyn_pal := PoleVal * zuzycie;
  wyn_czas := PoleVal / wydaj;
  wyn_koszt := wyn_pal * CenaVal;
  wyn_prac := PraStVal * wyn_czas;
  wyn_sur := wyn_prac + wyn_koszt;
  wyn_ost := wyn_sur * 1.10;
  
  g_godz := Trunc(wyn_czas);
  g_min := Round((wyn_czas - g_godz) * 60);
  if g_min = 60 then
  begin
    g_min := 0;
    g_godz := g_godz + 1;
  end;

  S1 := Format('Potrzebne paliwo: .............................. %.2f litrow', [wyn_pal]);
  S2 := Format('Potrzebny czas: ................................ %d:%.2d godzin', [g_godz, g_min]);
  S3 := Format('Koszt paliwa: .................................. %.2f (przy cenie PLN %.2f)', [wyn_koszt, CenaVal]);
  S4 := Format('Pracownik: ..................................... %.2f zl', [wyn_prac]);
  S5 := Format('Ostateczny koszt (w tym ukryte koszty): ........ %.2f zl', [wyn_ost]);

  R.Assign(5, 2, 75, 17);
  ReportDlg := New(PDialog, Init(R, 'Raport obliczen'));
  
  R.Assign(2, 2, 68, 3);
  ReportDlg^.Insert(New(PStaticText, Init(R, 'RAPORT')));
  
  R.Assign(2, 4, 68, 5);
  ReportDlg^.Insert(New(PStaticText, Init(R, S1)));
  
  R.Assign(2, 5, 68, 6);
  ReportDlg^.Insert(New(PStaticText, Init(R, S2)));
  
  R.Assign(2, 6, 68, 7);
  ReportDlg^.Insert(New(PStaticText, Init(R, S3)));
  
  R.Assign(2, 7, 68, 8);
  ReportDlg^.Insert(New(PStaticText, Init(R, S4)));
  
  R.Assign(2, 8, 68, 9);
  ReportDlg^.Insert(New(PStaticText, Init(R, S5)));
  
  R.Assign(15, 11, 35, 13);
  ReportDlg^.Insert(New(PButton, Init(R, '~Z~apisz do pliku', cmOK, bfDefault)));
  
  R.Assign(40, 11, 55, 13);
  ReportDlg^.Insert(New(PButton, Init(R, 'Z~a~mknij', cmCancel, bfNormal)));
  
  if Desktop^.ExecView(ReportDlg) = cmOK then
  begin
    Dispose(ReportDlg, Done);
    DoSaveReportToFile(wyn_pal, g_godz, g_min, wyn_koszt, CenaVal, wyn_prac, wyn_ost);
  end
  else
    Dispose(ReportDlg, Done);
end;

var
  MyApp: TRolApp;

begin
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.