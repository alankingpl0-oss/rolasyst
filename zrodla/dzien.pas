unit dziennik_r;

interface
procedure obsluga;

uses FreeCrt, SysUtils, dos;

label dziennik;


implementation
begin
dziennik:
  ClrScr;
  writeln('1. Konfiguracja');
  writeln('2. Dodaj do dziennika');
  readln(wybor);

end.