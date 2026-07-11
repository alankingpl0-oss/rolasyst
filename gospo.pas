program RolAsyst;

(* gospo.pas
 * Glowny (i jedyny) plik programu.
 *)

uses FreeCrt, SysUtils;

const
  wer = '1.03';

label
  poczatek, ZaDuzo, dalej, koniec;

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


  g_godz, g_min : Integer;


begin
{ Wykradamy od uzytkownika cenne dane }

poczatek:

ClrScr;
writeln('RolAsyst v', wer); writeln;
write('Podaj powierzchnie swojego pola w hektarach: ');
readln(pole);
if pole > 9500 then goto ZaDuzo;
{else continue}

write('Podaj aktualna cene paliwa za litr (PLN): ');
readln(cena_paliwa);
if cena_paliwa > 20 then goto ZaDuzo;
{else continue}

dalej:
writeln;
writeln('=== WYBOR CIAGNIKA ===');
writeln('1. Ursus C-330');
writeln('2. Ursus C-360');
writeln('3. Zetor 7211');
writeln('0. Inny (wpisz dane recznie)');
writeln;
write('Wybierz ciagnik (1-3, 0): ');
readln(wybor);

case wybor of
  1: begin
       writeln('=== WYBOR PRACY DLA URSUSA C-330 ===');
       writeln('1. Lekka kultywacja / Bronowanie');
       writeln('2. Koszenie kosiarka rotacyjna');
       writeln('3. Orka lekka (plug 2-skibowy)');
       write('Wybierz rodzaj pracy (1-3): ');
       readln(wybor_prac);
       
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
  writeln('Potrzebne paliwo: .... ', wyn_pal:0:2, ' litrow');
  writeln('Potrzebny czas: ...... ', Format('%d:%.2d', [g_godz, g_min]), ' godzin');
  writeln('Koszt paliwa: ........ ', wyn_koszt:0:2, ' przy cenie za litr PLN ', cena_paliwa:0:2);
  writeln;


write('Do jakiego pliku zapisac? (lub ''n'' aby nie zapisywac) ');
readln(nazwa_pl); (* Zmieniono na readln, zeby nie bylo problemow z buforem *)
if nazwa_pl = '' then nazwa_pl := 'RAPORT.TXT';
if nazwa_pl = 'n' then goto koniec;

assign(plyk, nazwa_pl);
rewrite(plyk);
writeln(plyk, '=== RAPORT ===');
writeln(plyk, 'Potrzebne paliwo: .... ', wyn_pal:0:2, ' litrow');
writeln(plyk, 'Potrzebny czas: ...... ', Format('%d:%.2d', [g_godz, g_min]), ' godzin');
writeln(plyk, 'Koszt paliwa: ........ ', wyn_koszt:0:2 , 'przy cenie za litr PLN', cena_paliwa:0:2);

(* W Pascalu kazda linia tekstu powinna byc osobnym wywolaniem writeln *)
writeln(plyk, 'Dane te sa wyliczony do typowych prac polowych,');
writeln(plyk, 'jednak przy ciezkiej orce czy gliniastej');
writeln(plyk, 'glebie zuzycie i wydajnosc moze spasc');

writeln(plyk); (* Jesli pusty wiersz mial byc w pliku, musisz przekazac zmienna plikowa *)
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

koniec:
writeln('Dziekujemy za skorzystanie z programu RolAsyst w wersji ', wer);

end.