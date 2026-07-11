program RolAsyst;

(* gospo.pas
 * Glowny (i jedyny) plik programu.
 *)

uses FreeCrt;

const
  wer = '1.01';

label
  poczatek, koniec;

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


begin
{ Wykradamy od uzytkownika cenne dane }

poczatek:

ClrScr;
writeln('RolAsyst v', wer); writeln;
write('Podaj powierzchnie swojego pola w hektarach: ');
readln(pole);

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
       (* Dane techniczne dla Ursusa C-330 *)
       zuzycie := 6.5;  (* srednie spalanie l/ha w lekkiej pracy *)
       wydaj := 0.7;    (* Wydajnoosc ha/h *)
       writeln('Wybrano: Ursus C-330 (Spalanie: 6.5 l/ha, Wydajnosc: 0.7 ha/h)');
     end;
  2: begin
       (* Dane techniczne dla Ursusa C-360 *)
       zuzycie := 9.5;  (* srednie spalanie l/ha *)
       wydaj := 1.0;    (* Wydajnosc ha/h *)
       writeln('Wybrano: Ursus C-360 (Spalanie: 9.5 l/ha, Wydajnosc: 1.0 ha/h)');
     end;
  3: begin
       (* Dane techniczne dla Zetora 7211 *)
       zuzycie := 11.0; (* Wiekszy komfort, to i spalic musi *)
       wydaj := 1.2;    (* Wydajnosc ha/h *)
       writeln('Wybrano: Zetor 7211 (Spalanie: 11.0 l/ha, Wydajnosc: 1.2 ha/h)');
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

wyn_pal := pole * zuzycie;
wyn_czas := pole / wydaj;

{ Wyczekiwany przez nas raport }
writeln;
write('Nacisnij Enter, aby wygenerowac raport...');
readln;

ClrScr;
writeln('=== RAPORT ===');
writeln('Potrzebne paliwo: .... ', wyn_pal:0:2, ' litrow');
writeln('Potrzebny czas: ...... ', wyn_czas:0:2, ' godzin');
writeln;
write('Do jakiego pliku zapisac? (lub ''n'' aby nie zapisywac) ');
readln(nazwa_pl); (* Zmieniono na readln, zeby nie bylo problemow z buforem *)
if nazwa_pl = '' then nazwa_pl := 'RAPORT.TXT';
if nazwa_pl = 'n' then goto koniec;

assign(plyk, nazwa_pl);
rewrite(plyk);
writeln(plyk, '=== RAPORT ===');
writeln(plyk, 'Potrzebne paliwo: .... ', wyn_pal:0:2, ' litrow');
writeln(plyk, 'Potrzebny czas: ...... ', wyn_czas:0:2, ' godzin');

(* W Pascalu kazda linia tekstu powinna byc osobnym wywolaniem writeln *)
writeln(plyk, 'Dane te sa wyliczony do typowych prac polowych,');
writeln(plyk, 'jednak przy ciezkiej orce czy gliniastej');
writeln(plyk, 'glebie zuzycie i wydajnosc moze spasc');

writeln(plyk); (* Jesli pusty wiersz mial byc w pliku, musisz przekazac zmienna plikowa *)
close(plyk);


writeln('Raport zapisany do pliku ', nazwa_pl);
writeln('Czy chcesz wyjsc z programu (t/n)')
readln('n')
else goto koniec

koniec:
writeln('Dziekujemy za skorzystanie z programu RolAsyst w wersji ', 'wer');
end.