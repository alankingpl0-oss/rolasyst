unit dziennik_r;

interface
procedure obsluga;



implementation
uses FreeCrt, SysUtils, dos;
procedure obsluga;


label dziennik;

var   kal_plik : Text;
  kal_linia: String;
  kal_data : String;
  kal_wpis : String;
  kal_wyb  : Integer;
  {kalendarz: Integer;}
  {przeglady: Integer;}

begin
dziennik:
  ClrScr;
  writeln('1. Wyswietl dziennik');
  writeln('2. Dodaj do dziennika');
  writeln('0. Powrot');
  readln(kal_wyb);
  { 1. Wyswietlanie kalendarza }
if kal_wyb = 1 then
  begin
    ClrScr;
    writeln('=== TWOJ DZIENNIK ===');
    writeln;
    
    (* Sprawdzamy czy plik w ogóle istnieje *)
    if FileExists('dziennik.txt') then
      begin
        assign(kal_plik, 'dziennik.txt');
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
        assign(kal_plik, 'dziennik.txt');
        rewrite(kal_plik);
        close(kal_plik);
        writeln('Brak zaplanowanych prac na ten moment.');
      end;
      
    writeln;
    writeln('Nacisnij Enter, aby powrocic...');
    readln;
    goto dziennik;
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
    goto dziennik;
  end;

goto dziennik; (* Zabezpieczenie przed wyjściem w pustą przestrzeń *)

end;
end.