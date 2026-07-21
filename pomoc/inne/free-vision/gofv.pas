program RolAsystFV;

(* gospo.pas
 * Glowny plik programu z interfejsem FreeVision.
 *)

uses
  App, Objects, Drivers, Views, Menus, Dialogs, MsgBox, SysUtils;

const
  wer = '1.03.3 FV';
  kompilacja = '4';
  cmOblicz = 100;
  cmOProgramie = 101;

type
  (* Dziedziczymy z glownej aplikacji FreeVision *)
  TRolApp = object(TApplication)
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure HandleEvent(var Event: TEvent); virtual;
    procedure Obliczenia;
    procedure PokazOProgramie;
  end;

  (* Rekordy do pobierania danych z pol tekstowych i przyciskow opcji *)
  TDanePoczatkowe = record
    PoleText: string[20];
    CenaText: string[20];
  end;

  TDaneCiagnik = record
    Wybor: Word;
  end;

procedure TRolApp.InitMenuBar;
var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~P~lik', hcNoContext, NewMenu(
      NewItem('~O~blicz zapotrzebowanie', 'F2', kbF2, cmOblicz, hcNoContext,
      NewItem('~W~yjscie', 'Alt-X', kbAltX, cmQuit, hcNoContext, nil))),
    NewSubMenu('~P~omoc', hcNoContext, NewMenu(
      NewItem('~O~ programie', '', kbNoKey, cmOProgramie, hcNoContext, nil)),
    nil))
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
      NewStatusKey('~F2~ Oblicz', kbF2, cmOblicz,
      NewStatusKey('~Alt-X~ Wyjdz', kbAltX, cmQuit,
      nil)),
    nil)
  ));
end;

procedure TRolApp.PokazOProgramie;
begin
  MessageBox('RolAsyst v' + wer + #13 +
             'Kompilacja: ' + kompilacja + #13 +
             'Interfejs: FreeVision' + #13 +
             'Maksoft Korporejszyn',
             nil, mfInformation or mfOKButton);
end;

procedure TRolApp.Obliczenia;
var
  Dialog: PDialog;
  R: TRect;
  Control: PView;
  Dane: TDanePoczatkowe;
  Pole, Cena, Zuzycie, Wydaj, WynPal, WynCzas, WynKoszt: Real;
  Godz, Minut, KodBledu: Integer;
  CiagnikDane: TDaneCiagnik;
  plyk: Text;
  NazwaPliku: string[80];
begin
  (* 1. DIALOG: POBRANIE POLA I CENY *)
  Dane.PoleText := '1.0';
  Dane.CenaText := '6.50';

  R.Assign(20, 5, 60, 13);
  Dialog := New(PDialog, Init(R, 'Parametry poczatkowe'));

  R.Assign(22, 2, 37, 3);
  Control := New(PInputLine, Init(R, 20));
  Dialog^.Insert(Control);
  R.Assign(2, 2, 21, 3);
  Dialog^.Insert(New(PLabel, Init(R, 'Powierzchnia (ha):', Control)));

  R.Assign(22, 4, 37, 5);
  Control := New(PInputLine, Init(R, 20));
  Dialog^.Insert(Control);
  R.Assign(2, 4, 21, 5);
  Dialog^.Insert(New(PLabel, Init(R, 'Cena paliwa (PLN):', Control)));

  R.Assign(8, 6, 18, 8);
  Dialog^.Insert(New(PButton, Init(R, '~D~alej', cmOK, bfDefault)));
  R.Assign(22, 6, 32, 8);
  Dialog^.Insert(New(PButton, Init(R, '~A~nuluj', cmCancel, bfNormal)));

  Dialog^.SetData(Dane);

  if Desktop^.ExecView(Dialog) <> cmOK then
  begin
    Dispose(Dialog, Done);
    Exit;
  end;
  Dialog^.GetData(Dane);
  Dispose(Dialog, Done);

  (* Konwersja i weryfikacja - uzywamy Val(), zeby nie zwalic programu koncertowo w razie literowki *)
  Val(Trim(Dane.PoleText), Pole, KodBledu);
  if KodBledu <> 0 then
  begin
    MessageBox('Powierzchnia to musi byc liczba!', nil, mfError or mfOKButton);
    Exit;
  end;

  Val(Trim(Dane.CenaText), Cena, KodBledu);
  if KodBledu <> 0 then
  begin
    MessageBox('Cena musi byc liczba!', nil, mfError or mfOKButton);
    Exit;
  end;

  if Pole = 2012.0 then
  begin
    MessageBox('Tryb Debug! v' + wer + ' kompil ' + kompilacja, nil, mfInformation or mfOKButton);
    Exit;
  end;

  if Pole < 0.00001 then
  begin
    MessageBox('Nie. Tym razem zwaliles to koncertowo.', nil, mfError or mfOKButton);
    Exit;
  end;

  if Cena > 20.0 then
  begin
    MessageBox('Troche za duzo za to paliwo.', nil, mfError or mfOKButton);
    Exit;
  end;

  (* 2. DIALOG: WYBOR CIAGNIKA *)
  CiagnikDane.Wybor := 1; (* Domyslnie Ursus C-360 *)
  R.Assign(25, 5, 55, 16);
  Dialog := New(PDialog, Init(R, 'Wybierz ciagnik'));

  R.Assign(3, 3, 27, 8);
  Control := New(PRadioButtons, Init(R,
    NewSItem('Ursus C-330',
    NewSItem('Ursus C-360',
    NewSItem('Zetor 7211',
    NewSItem('Zetor Crystal',
    NewSItem('Claas Axion Terra Trac', nil))))
  ));
  Dialog^.Insert(Control);

  R.Assign(2, 2, 20, 3);
  Dialog^.Insert(New(PLabel, Init(R, 'Dostepne maszyny:', Control)));

  R.Assign(5, 9, 15, 11);
  Dialog^.Insert(New(PButton, Init(R, '~O~blicz', cmOK, bfDefault)));
  R.Assign(17, 9, 27, 11);
  Dialog^.Insert(New(PButton, Init(R, '~A~nuluj', cmCancel, bfNormal)));

  Dialog^.SetData(CiagnikDane);
  if Desktop^.ExecView(Dialog) <> cmOK then
  begin
    Dispose(Dialog, Done);
    Exit;
  end;
  Dialog^.GetData(CiagnikDane);
  Dispose(Dialog, Done);

  (* Dla trybu TUI bierzemy domyslne i usrednione parametry zaleznie od maszyny *)
  case CiagnikDane.Wybor of
    0: begin Zuzycie := 6.5; Wydaj := 0.7; end;
    1: begin Zuzycie := 9.5; Wydaj := 1.0; end;
    2: begin Zuzycie := 11.0; Wydaj := 1.2; end;
    3: begin Zuzycie := 13.0l wydaj := 4.0; end
    4: begin Zuzycie := 14.4; Wydaj := 5.1; end;
  else
    begin Zuzycie := 9.5; Wydaj := 1.0; end;
  end;

  (* Obliczenia wlasciwe *)
  WynPal := Pole * Zuzycie;
  WynCzas := Pole / Wydaj;
  WynKoszt := WynPal * Cena;

  Godz := Trunc(WynCzas);
  Minut := Round((WynCzas - Godz) * 60);
  if Minut = 60 then
  begin
    Minut := 0;
    Godz := Godz + 1;
  end;

  (* 3. DIALOG: WYSWIETLENIE RAPORTU I ZAPIS *)
  R.Assign(15, 4, 65, 18);
  Dialog := New(PDialog, Init(R, 'Podsumowanie raportu'));

  R.Assign(2, 2, 48, 3);
  Dialog^.Insert(New(PStaticText, Init(R, 'Paliwo: ' + FloatToStrF(WynPal, ffFixed, 7, 2) + ' litrow')));

  R.Assign(2, 3, 48, 4);
  Dialog^.Insert(New(PStaticText, Init(R, 'Czas: ' + IntToStr(Godz) + ' godz ' + IntToStr(Minut) + ' min')));

  R.Assign(2, 4, 48, 5);
  Dialog^.Insert(New(PStaticText, Init(R, 'Koszt: ' + FloatToStrF(WynKoszt, ffFixed, 7, 2) + ' PLN')));

  R.Assign(20, 6, 45, 7);
  Control := New(PInputLine, Init(R, 80));
  Dialog^.Insert(Control);
  
  R.Assign(2, 6, 19, 7);
  Dialog^.Insert(New(PLabel, Init(R, 'Zapisz do pliku:', Control)));

  R.Assign(10, 9, 22, 11);
  Dialog^.Insert(New(PButton, Init(R, '~Z~apisz', cmOK, bfDefault)));

  R.Assign(26, 9, 38, 11);
  Dialog^.Insert(New(PButton, Init(R, '~N~ie', cmCancel, bfNormal)));

  NazwaPliku := 'RAPORT.TXT';
  Dialog^.SetData(NazwaPliku);

  if Desktop^.ExecView(Dialog) = cmOK then
  begin
    Dialog^.GetData(NazwaPliku);
    Dispose(Dialog, Done);

    if Trim(NazwaPliku) <> '' then
    begin
      Assign(plyk, NazwaPliku);
      {$I-}
      Rewrite(plyk);
      if IOResult = 0 then
      begin
        writeln(plyk, '=== RAPORT ===');
        writeln(plyk, 'Potrzebne paliwo: .... ', WynPal:0:2, ' litrow');
        writeln(plyk, 'Potrzebny czas: ...... ', Godz, ' godz ', Minut, ' min');
        writeln(plyk, 'Koszt paliwa: ........ ', WynKoszt:0:2, ' PLN');
        writeln(plyk, 'Dane te sa wyliczone do typowych prac polowych.');
        Close(plyk);
        MessageBox('Plik ' + NazwaPliku + ' zostal pomyslnie zapisany!', nil, mfInformation or mfOKButton);
      end
      else
      begin
        MessageBox('Blad zapisu pliku!', nil, mfError or mfOKButton);
      end;
      {$I+}
    end;
  end
  else
  begin
    Dispose(Dialog, Done);
  end;
end;

procedure TRolApp.HandleEvent(var Event: TEvent);
begin
  inherited HandleEvent(Event);
  
  (* Sprawdzanie, czy wcisnieto polecenie z menu *)
  if Event.What = evCommand then
  begin
    case Event.Command of
      cmOblicz: Obliczenia;
      cmOProgramie: PokazOProgramie;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

var
  Aplikacja: TRolApp;

begin
  Aplikacja.Init;
  Aplikacja.Run;
  Aplikacja.Done;
end.