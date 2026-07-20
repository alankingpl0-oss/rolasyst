program RolAsyst;

(* gospo.pas
 * Glowny (i jedyny) plik programu.
 *)

uses
  FreeCrt,
  SysUtils;

const
  wer = '2.00-beta3';
  kompilacja = 'b3';

label
  poczatek,
  ZaDuzo,
  dalej,
  koniec,
  licz,
  miary,
  kalendarz,
  przeglady,
  kalkulator,
  debug;


var
  pole     : Real;
  zuzycie  : Real;
  wyn_pal  : Real;
  wyn_czas : Real;
  wydaj    : Real;
  plyk     : Text;
  nazwa_pl : String;
  wybor    : Integer; (* Zmienna do obslugi menu ciagnikow *)
  wybo2    : Char;
  cena_paliwa : Real;
  wyn_koszt: Real;
  wybor_prac:Integer;
  debug_wybor:Integer;
  pra_st   : Real;
  wyn_prac : Real;
  wyn_sur  : Real;
  wyn_ost  : Real;
  menu     : Integer;
  miary_wyb: Integer;
  hektar   : Real;
  metr_kw  : Real;
  kal_wyb  : Integer;


  g_godz, g_min : Integer;

  (* Zmienne pomocnicze do obsługi kalendarza *)
  kal_plik : Text;
  kal_linia: String;
  kal_data : String;
  kal_wpis : String;

  (* Zmienne pomocnicze do obsługi przegladów *)
  prz_plik : Text;
  prz_linia: String;
  prz_data : String;
  prz_wpis : String;
  prz_wyb  : Integer;
  prz_mth  : Real  ;

  {zmienne do przelicznika mile - km}
  mile     : Real;
  kilometr : Real;

  {zmienne do przelicznika akry - hektary}

  akry     : Real;



begin
{ Wykradamy od uzytkownika cenne dane }

poczatek:

ClrScr;
writeln('RolAsyst v', wer); writeln;

{ Właściwe menu główne }

writeln('1. Przelicznik miar');
writeln('2. Kalendarz');
writeln('3. Hitoria przegladow');
writeln('4. Kalkulator (wkrotce)');
writeln('0. Zacznij obliczenia');

readln(menu);
if menu = 1 then goto miary;
if menu = 2 then goto kalendarz;
if menu = 3 then goto przeglady;
if menu = 0 then goto licz;

licz:

write('Podaj powierzchnie swojego pola w hektarach: ');
readln(pole);
if pole = 2012 then
  begin
    ClrScr;
    goto debug
  end;
if pole > 9500 then
  begin
    writeln('')
  end;
if pole < 0.04 then writeln('A wiec to tylko przydomowy ogrodek?');
if pole < 0.00001 then
  begin
    writeln('Nie. Tym razem zwaliles to koncertowo.'); {Jasno potwirdzamy, że wszystko zostało zwalone.}
    readln;
    goto poczatek;
  end;
{else continue}

if pole = 2008 then
  begin
    writeln('Nie.');
    goto koniec;
  end;


write('Czy wynajmujesz pracownika? Jezeli tak, wpisz stawke za godzine. (jesli nie, wpisz 0) ');
readln(pra_st); (* Pra_st to skrót od "PRAcownik STawka".*)
if pra_st = 0 then writeln('Czyli klasyka');
 { begin
    writeln('Czyli robisz klasycznie.');
    
  end;
}

if pra_st >= 250 then
  begin
    writeln('Nie. Nie, lepiej znajdz innego pracownika.');
    writeln('Nie wolisz wydac tych pieniedzy na cos lepszego?');
    readln;
    goto poczatek;
  end;

if pra_st > 140 then
  begin
    writeln('Troche duzo... Nie szkoda Ci tych pieniedzy?');
    readln;
  end;

if pra_st < 30 then
  begin
    writeln('TO SIE NAPRAWDE OPLACA!');
    readln;
  end


else if pra_st < 70 then
  begin
    writeln('To sie oplaca.');
  end

else if pra_st = 0 then writeln('Czyli klasyka');
 { begin
    writeln('Czyli robisz klasycznie.');
    
  end;
}



write('Podaj aktualna cene paliwa za litr (PLN): ');
readln(cena_paliwa);
if cena_paliwa > 20 then
  begin
    writeln('Troche za duzo. Lepiej znajdz inna stacje paliw.');
    goto poczatek
  end;
if cena_paliwa < 3 then
  begin
    writeln('Podejrzane. Skad bierzesz to paliwo?');
  end;
{else continue}

dalej:
writeln;
writeln('=== WYBOR CIAGNIKA ===');
writeln('1. Ursus C-330');
writeln('2. Ursus C-360');
writeln('3. Zetor 7211');
writeln('4. Claas Axion Terra Trac');
writeln('5. Zetor Crystal 160');
writeln('6. Mercedes MB-Trac 800');
writeln('7. Fendt 512 Vario');
writeln('0. Inny (wpisz dane recznie)');
writeln;
write('Wybierz ciagnik (1-7, 0): ');
readln(wybor);

if wybor = 2008 then
  begin
    writeln('Chyba masz na mysli 2012?');
    readln;
    goto poczatek
  end;
  

{ Wybory }

case wybor of
  1: begin
       writeln('=== WYBOR PRACY DLA URSUSA C-330 ===');
       writeln('1. Lekka kultywacja / Bronowanie');
       writeln('2. Koszenie kosiarka rotacyjna');
       writeln('3. Orka lekka (plug 2-skibowy)');
       write('Wybierz rodzaj pracy (1-3): ');
       readln(wybor_prac);
       {Wybory prac}
       case wybor_prac of
         1: begin zuzycie := 5.0; wydaj := 0.9; end;
         2: begin zuzycie := 6.5; wydaj := 0.7; end;
         3: begin zuzycie := 8.5; wydaj := 0.4; end;
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 6.5; wydaj := 0.7;
           end;
       end;
     end;
  2: begin
       writeln('=== WYBOR PRACY DLA URSUSA C-360 ===');
       writeln('1. Bronowanie / Siew');
       writeln('2. Praca z prasa zwijajaca');
       writeln('3. Orka (plug 3-skibowy)');
       write('Wybierz rodzaj pracy (1-3): ');
       readln(wybor_prac);
       
       case wybor_prac of
         1: begin zuzycie := 7.0; wydaj := 1.4; end;
         2: begin zuzycie := 9.5; wydaj := 1.0; end;
         3: begin zuzycie := 12.5; wydaj := 0.6; end;
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 9.5; wydaj := 1.0;
           end;
       end;
     end;
  3: begin
       writeln('=== WYBOR PRACY DLA ZETORA 7211 ===');
       writeln('1. Siewnik / Lekka uprawa');
       writeln('2. Prace transportowe');
       writeln('3. Orka gleboka');
       write('Wybierz rodzaj pracy (1-3): ');
       readln(wybor_prac);
       
       case wybor_prac of
         1: begin zuzycie := 8.5; wydaj := 1.6; end;
         2: begin zuzycie := 10.0; wydaj := 1.5; end;
         3: begin zuzycie := 14.0; wydaj := 0.8; end;
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 11.0; wydaj := 1.2;
           end;
       end;
     end;
       (* Klasyczna sciezka - reczne wpisywanie *)

    4: begin
       writeln('=== Praca dla Claas Axion 9 Terra Trac (448 KM) ===');
       writeln('1. Lekka orka (5 metrow)');
       writeln('2. Ciezka orka (13 metrow)');
       writeln('3. Siew (agregat 3 m)');
       writeln('4. Siew (agregat 8 m)');
       writeln('5. Koszenie trawy 6 m');
       write('Wybierz rodzaj pracy (1-5): ');
       readln(wybor_prac);
       
       case wybor_prac of
         1: begin zuzycie := 22.2; wydaj := 5.5; end;
         2: begin zuzycie := 34.7; wydaj := 8.3; end;
         3: begin zuzycie := 9.1; wydaj := 2.5; end;
         4: begin zuzycie := 14.4; wydaj := 5.1; end;
         5: begin zuzycie := 7; wydaj := 9.6; end;
         
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 12.1; wydaj := 3.0;
           end;
       end;
     end;

  41: begin
       writeln('Wersja ', wer, 'kompilacja ', kompilacja);
       end;

  5:  begin
       writeln('=== Praca dla Crystal 160 ===');
       writeln('1. Lekka orka (5 metrow)');
       writeln('2. Nawozenie');
       writeln('3. Siew (agregat 3 m)');
       writeln('4. Koszenie trawy 6 m');
       write('Wybierz rodzaj pracy (1-4): ');
       readln(wybor_prac);
       
       case wybor_prac of
         1: begin zuzycie := 4.85  ; wydaj := 2.72; end;
         2: begin zuzycie := 7.01  ; wydaj := 2.43; end;
         3: begin zuzycie := 14.65 ; wydaj := 1.42; end;
         4: begin zuzycie := 2.22  ; wydaj := 9.43; end;
         
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 12.1; wydaj := 3.0;
           end;
       end;
     end;

  6:  begin
       writeln('=== Praca dla MB-Trac 800 ===');
       writeln('1. Wciaganie drzewa 600 kg');
       writeln('2. Wciganie drzewa 900 kg');
       writeln('3. Siew (agregat 3 m)');
       writeln('4. Gleboka orka 5 m');
       write('Wybierz rodzaj pracy (1-4): ');
       readln(wybor_prac);
       
       case wybor_prac of
         1: begin zuzycie := 20.83 ; wydaj := 0.32  ; end;
         2: begin zuzycie := 22.65 ; wydaj := 0.31  ; end;
         3: begin zuzycie :=  2.65 ; wydaj := 5.42  ; end;
         4: begin zuzycie := 11.33 ; wydaj := 2.07  ; end;
         
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 12.1; wydaj := 3.0;
           end;
       end;
     end;
{Fendt 512 Vario}
  7:  begin
       writeln('=== Praca dla Fendt 512 Vario ===');
       writeln('1. Lekka orka (agregat 5 m)');
       writeln('2. Gleboka orka (agregat 9 m)');
       writeln('3. Siew (agregat 3 m)');
       writeln('4. Siew (agregat 6 m)');
       write('Wybierz rodzaj pracy (1-4): ');
       readln(wybor_prac);
       
       case wybor_prac of
         1: begin zuzycie := 7.30  ; wydaj := 3.14  ; end;
         2: begin zuzycie := 36.41 ; wydaj := 4.86  ; end;
         3: begin zuzycie := 28.10 ; wydaj := 5.02  ; end;
         4: begin zuzycie := 40.90 ; wydaj := 8.13  ; end;
         
         else
           begin
             writeln('Nieznana praca! Ustawiam srednie parametry.');
             zuzycie := 12.1; wydaj := 3.0;
           end;
       end;
     end;



  0: begin
       (* Klasyczna sciezka - reczne wpisywanie *)
       writeln('Wybrano konfiguracje reczna.');
       write('Podaj zuzycie paliwa ciagnika (litry na hektar): ');
       readln(zuzycie);
       write('Podaj wydajnosc pracy (hektary na godzine): ');
       readln(wydaj);
     end;
  else
    begin
      writeln('Nieznany wybor! Ustawiam domyslne parametry jak dla C-360.');
      zuzycie := 9.5;
      wydaj := 1.0;
    end;
end;

{ Obliczenia }

{ Obliczenia }

wyn_pal := pole * zuzycie;
wyn_czas := pole / wydaj;
wyn_koszt := wyn_pal * cena_paliwa;
wyn_prac := pra_st * wyn_czas;
wyn_sur := wyn_prac + wyn_koszt;
wyn_ost := wyn_sur * 1.10;

{ Wyczekiwany przez nas raport }
  writeln;
  write('Nacisnij Enter, aby wygenerowac raport...');
  readln;

  g_godz := Trunc(wyn_czas);
  g_min := Round((wyn_czas - g_godz) * 60);

  if g_min = 60 then
  begin
    g_min := 0;
    g_godz := g_godz + 1;
  end;

  ClrScr;

{ Wyczekiwany przez nas raport }
{ Wyczekiwany przez nas raport }
{ Wyczekiwany przez nas raport }

  writeln('=== RAPORT ===');
  writeln('Potrzebne paliwo: .............................. ', wyn_pal:0:2, ' litrow');
  writeln('Potrzebny czas: ................................ ', Format('%d:%.2d', [g_godz, g_min]), ' godzin');
  writeln('Koszt paliwa: .................................. ', wyn_koszt:0:2, ' przy cenie za litr PLN ', cena_paliwa:0:2);
  writeln('Pracownik: ..................................... ', wyn_prac:0:2 , ' zl');
  writeln('Ostateczny koszt (w tym ukryte koszty): ........ ', wyn_ost:0:2 , ' zl');
  writeln;


write('Do jakiego pliku zapisac? (lub ''n'' aby nie zapisywac) ');
readln(nazwa_pl); (* Zmieniono na readln, zeby nie bylo problemow z buforem *)
if nazwa_pl = '' then nazwa_pl := 'RAPORT.TXT';
if nazwa_pl = 'n' then goto koniec;
if nazwa_pl = 'microsoft.txt' then
  begin
    writeln('Nie. Po prostu nie.');
    writeln('Ten blad trzeba skorygowac.');
    nazwa_pl := 'TylkoLinux!!.txt';
  end;

if nazwa_pl = 'raport_2008.txt' then
  begin
    writeln('Pomidor.');
    nazwa_pl := 'raport_2012.txt';
  end;

if nazwa_pl = '2008.txt' then
  begin
    writeln('Skorygowano blad.');
    nazwa_pl := '2012.txt';
  end;


assign(plyk, nazwa_pl);
rewrite(plyk);
writeln(plyk, '=== RAPORT ===');
writeln(plyk, 'Potrzebne paliwo: ........................ ', wyn_pal:0:2, ' litrow');
writeln(plyk, 'Potrzebny czas: .......................... ', Format('%d:%.2d', [g_godz, g_min]), ' godzin');
writeln(plyk, 'Koszt paliwa: ............................ ', wyn_koszt:0:2 , 'przy cenie za litr PLN', cena_paliwa:0:2);
writeln(plyk, 'Pracownik: ............................... ', wyn_prac:0:2 , ' zl');
writeln(plyk, 'Ostateczny koszt (w tym ukryte koszty): .. ', wyn_ost:0:2 , ' zl');



(* W Pascalu kazda linia tekstu powinna byc osobnym wywolaniem writeln *)
writeln(plyk, 'Dane te sa wyliczony do typowych prac polowych,');
writeln(plyk, 'jednak przy ciezkiej orce czy gliniastej');
writeln(plyk, 'glebie zuzycie i wydajnosc moze ulec zmianie');

writeln(plyk); (* Jesli pusty wiersz mial byc w pliku, musimy przekazac zmienna plikowa *)
close(plyk);


writeln('Raport zapisany do pliku ', nazwa_pl);
writeln('Czy chcesz wyjsc z programu (t/n)');
readln(wybo2);
if wybo2 = 't' then
  goto koniec
else
  begin
    goto poczatek
  end;


(* else goto koniec *)


ZaDuzo:
writeln('To niemozliwe.');
readln;
goto poczatek;

{ MENU DEBUG }

debug:
  writeln('=== MENU DEBUG ===');
  writeln('v', wer, ' kompil', kompilacja);
  writeln('1. Iinformacje o wersji');
  writeln('0. Powrot');
  readln(debug_wybor);
  if debug_wybor = 0 then goto poczatek;
  if debug_wybor = 1 then
    begin
      ClrScr;
      writeln('Wersja ', wer, ', kompilacja ', kompilacja, '.');
      readln;
      ClrScr;
      goto debug;
    end;
  
    if debug_wybor = 2 then
      begin
        ClrScr;
        writeln('Tu cos bedzie');
      end;
  
    (* Na razie tyle w menu debug. Lepiej zostawić tą opcję
     * 41 w menu wyboru ciągników,
     * żeby nic nie zwalić koncertowo... *)
  readln;

{ PRZELICZNIK MIAR }

miary:
ClrScr;
writeln('1. Hektar > Metr kwadratowy');
writeln('2. Metr kw. > Hektar');
writeln('3. Mila > kilometr');
writeln('4. Kilometr > mila');
writeln('5. Hektar > akr');
writeln('6. Akr > hektar');
writeln('0. Powrot');
readln(miary_wyb);

if miary_wyb = 0 then goto poczatek;

{ Hektar na metry }
if miary_wyb = 1 then
  begin
    ClrScr;
    write('Wpisz liczbe hektarow');
    readln(hektar);

    metr_kw := hektar * 10000;
    write(hektar:0:2, ' hektar(/ow) to ', metr_kw:0:2, ' metrow kwadratowych');
    readln;
    goto miary;
  end;


{ Metry na hektar }

if miary_wyb = 2 then
  begin
    ClrScr;
    writeln('Podaj liczbe metrow kw.');
    readln(metr_kw);

    hektar := metr_kw / 10000;
    write(metr_kw:0:2, ' metrow kw. to ', hektar:0:2, ' hektarow');
    readln;
    goto miary;
  end;

{Kilometr na milę}

if miary_wyb = 3 then
  begin
    ClrScr;
    write('Podaj mile ');
    readln(mile);

    kilometr :=  mile * 1.609;
    write(mile:0:1, ' mil to ', kilometr:0:3, ' kiloemtr(/ow)');
    readln;
    goto miary
  end;

if miary_wyb = 4 then
  begin
    ClrScr;
    write('Podaj kilometry ');
    readln(kilometr);

    mile := kilometr / 1.609;
    write(kilometr:0:3, ' kilometrow to ', mile:0:1, ' mil(i)');
    readln;
    goto miary;
  end;

{na akry}
if miary_wyb = 5 then
  begin
    ClrScr;
    write('Podaj ilosc hektarow ');
    readln(hektar);
    
    akry := hektar / 0.405;
    write(hektar:0:1, ' hektar(/ow) to ', akry:0:3, ' akrow');
    readln;
    goto miary
  end;

{na hektary}
if miary_wyb = 6 then
  begin
    ClrScr;
    write('Podaj ilosc akrow ');
    readln(akry);

    hektar := akry * 0.405;
    write(akry:0:3, ' akrow to ', hektar:0:1, ' hektarow');
    readln;
    goto miary
  end;

kalendarz:

{ Menu kalendarza }
{ KALENDARZ }

{kalendarz:}
ClrScr;
writeln('=== KALENDARZ PRAC POLOWYCH ===');
writeln('1. Zobacz aktualny kalendarz');
writeln('2. Dodaj do kalendarza');
writeln('0. Powrot');
write('Wybierz opcje: ');
readln(kal_wyb);

if kal_wyb = 0 then goto poczatek;

{ 1. Wyswietlanie kalendarza }
if kal_wyb = 1 then
  begin
    ClrScr;
    writeln('=== TWOJE PLANOWANE PRACE ===');
    writeln;
    
    (* Sprawdzamy czy plik w ogóle istnieje *)
    if FileExists('kalendarz.txt') then
      begin
        assign(kal_plik, 'kalendarz.txt');
        reset(kal_plik);
        
        (* Czytamy plik linijka po linijce dopóki nie osiągniemy końca *)
        while not eof(kal_plik) do
          begin
            readln(kal_plik, kal_linia);
            writeln(kal_linia);
          end;
          
        close(kal_plik);
      end
    else
      begin
        writeln('Tworzenie nowego (pustego) kalendarza...');
        (* Tworzymy pusty plik, jeśli jeszcze go nie ma *)
        assign(kal_plik, 'kalendarz.txt');
        rewrite(kal_plik);
        close(kal_plik);
        writeln('Brak zaplanowanych prac na ten moment.');
      end;
      
    writeln;
    writeln('Nacisnij Enter, aby powrocic...');
    readln;
    goto kalendarz;
  end;

{ 2. Dodawanie nowego wpisu }
if kal_wyb = 2 then
  begin
    ClrScr;
    writeln('=== DODAJ WPIS DO KALENDARZA ===');
    write('Podaj date (np. 21.12.2012): ');
    readln(kal_data);
    if kal_data = '0' then
      begin
        writeln('Ech...');
        writeln('Ustawiam koniec swiata');
        kal_data := '21.12.2012';
      end;
    write('Podaj opis pracy (np. Koszenie C-360): ');
    readln(kal_wpis);
    
    (* Otwieramy plik w trybie Append - dopisywanie na koncu *)
    assign(kal_plik, 'kalendarz.txt');
    if FileExists('kalendarz.txt') then
      append(kal_plik)
    else
      rewrite(kal_plik);
      
    writeln(kal_plik, '[', kal_data, '] - ', kal_wpis);
    close(kal_plik);
    
    writeln('Wpis zapisany pomyslnie!');
    readln;
    goto kalendarz;
  end;

goto kalendarz; (* Zabezpieczenie przed wyjściem w pustą przestrzeń *)

przeglady:

{ Menu przeglądów™ }
{ PRZEGLADY }

{kalendarz:}
ClrScr;
writeln('=== DZIENNIK PRZEGLADOW ===');
writeln('1. Zobacz historie przegladow');
writeln('2. Dodaj do przegladow');
writeln('0. Powrot');
write('Wybierz opcje: ');
readln(prz_wyb);

if prz_wyb = 0 then goto poczatek;

{ 1. Wyswietlanie kalendarza }
if prz_wyb = 1 then
  begin
    ClrScr;
    writeln('=== TWOJE PRZEGLADY ===');
    writeln;
    
    (* Sprawdzamy czy plik w ogóle istnieje *)
    if FileExists('przegl.txt') then
      begin
        assign(prz_plik, 'przegl.txt');
        reset(prz_plik);
        
        (* Czytamy plik linijka po linijce dopóki nie osiągniemy końca *)
        while not eof(prz_plik) do
          begin
            readln(prz_plik, prz_linia);
            writeln(prz_linia);
          end;
          
        close(prz_plik);
      end
    else
      begin
        writeln('Tworzenie nowego (pustego) dziennika...');
        (* Tworzymy pusty plik, jeśli jeszcze go nie ma *)
        assign(prz_plik, 'przegl.txt');
        rewrite(prz_plik);
        close(prz_plik);
        writeln('Brak zaplanowanych prac na ten moment.');
      end;
      
    writeln;
    writeln('Nacisnij Enter, aby powrocic...');
    readln;
    goto przeglady;
  end;

{ 2. Dodawanie nowego wpisu }
if prz_wyb = 2 then
  begin
    ClrScr;
    writeln('=== DODAJ WPIS DO DZIENNIKA ===');
    write('Podaj date (np. 21.12.2012): ');
    readln(prz_data);
    if prz_data = '0' then
      begin
        writeln('"0" to nie data. Jeszcze raz.');
        writeln('Ustawiam date 21.12.2012');
        prz_data := '21.12.2012';
      end;
    write('Podaj nazwe maszyny: ');
    readln(prz_wpis);

    write('Podaj aktualna liczbe mth');
    readln(prz_mth);
    
    (* Otwieramy plik w trybie Append - dopisywanie na koncu *)
    assign(prz_plik, 'przegl.txt');
    if FileExists('przegl.txt') then
      append(prz_plik)
    else
      rewrite(prz_plik);
      
    writeln(prz_plik, '[', prz_data, '] - ', prz_wpis, prz_mth:0:1, ' mth');
    close(prz_plik);
    
    writeln('Wpis zapisany pomyslnie!');
    readln;
    goto przeglady;
  end;

goto przeglady; (* Zabezpieczenie przed wyjściem w pustą przestrzeń *)

kalkulator:
{W przygotowaniu}
ClrScr;
  writeln('W przygotowaniu');
  readln;

koniec:
writeln('Dziekujemy za skorzystanie z programu RolAsyst w wersji ', wer)

end.