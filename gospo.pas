program RolAsyst;

uses FreeCrt;

const
  wer = 1.00a;

var
  pole     : Real;
  zuzycie  : Real;
  wyn_pal  : Real;
  wyn_czas : Real;
  wydaj    : Real;
  x        : Text;
  plyk     : Text;
  nazwa_pl : String;

begin
{ Wykradamy od u¾ytkownika cenne dane }

ClrScr;
writeln('RolAsyst v', wer'); writeln;
write('Podaj powierzchnie swojego pola w hektarach ');
readln(pole);

write('Podaj zuzycie paliwa ciagnika (litry na hektar) ');
readln(zuzycie);

write('Podaj wydajnosc pracy (hektary na godzin©) ');
readln(wydaj);

{ Obliczenia }

wyn_pal := pole * zuzycie  ;
wyn_czas := pole / wydaj   ;

{ Wyczekiwany przez nas raport }
ClrScr;
writeln;
writeln('=== RAPORT ===');
writeln('Potrzebne paliwo: .... ', wyn_pal:0:2, ' litr¢w') ;
writeln('Potrzebny czas: ...... ', wyn_czas:0:2, ' godzin');
writeln;
write('Do jakiego pliku zapisac?');
read(nazwa_pl); {Nie chodzi tu o hosting Nazwa.pl}

assign(plyk, nazwa_pl);
rewrite(plyk);

writeln(plyk, '=== RAPORT ===');
writeln(plyk, 'Potrzebne paliwo: ....', wyn_pal:0:2, ' litr¢w');
writeln(plyk, 'Potrzebny czas: ......', wyn_czas:0:2, ' godzin');
close(plyk);
end.
