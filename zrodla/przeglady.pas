unit przeglady;

interface
procedure obsluga;



var
  (* Zmienne pomocnicze do obsługi przegladów *)
  prz_plik : Text;
  prz_linia: String;
  prz_data : String;
  prz_wpis : String;
  prz_wyb  : Integer;
  prz_mth  : Real  ;


implementation

uses
  FreeCrt, SysUtils;

procedure obsluga;
label
  przeglady;
begin
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

if prz_wyb = 0 then Exit;
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

    write('Podaj aktualna liczbe mth ');
    readln(prz_mth);
    
    (* Otwieramy plik w trybie Append - dopisywanie na koncu *)
    assign(prz_plik, 'przegl.txt');
    if FileExists('przegl.txt') then
      append(prz_plik)
    else
      rewrite(prz_plik);
      
    writeln(prz_plik, '[', prz_data, '] - ', prz_wpis, ', ', prz_mth:0:1, ' mth');
    close(prz_plik);
    
    writeln('Wpis zapisany pomyslnie!');
    readln;
    goto przeglady;
  end;

goto przeglady; (* Zabezpieczenie przed wyjściem w pustą przestrzeń *)
end;


end.