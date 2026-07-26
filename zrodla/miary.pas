unit miary;

interface
procedure obsluga;

implementation
uses
  FreeCrt;

var

  miary_wyb: Integer;
  {zmienne do przelicznika mile - km}
  mile     : Real;
  kilometr : Real;

  {zmienne do przelicznika akry - hektary}

  akry     : Real;

  hektar   : Real;
  metr_kw  : Real;

procedure obsluga;
label
  miary;

begin {Ustrojstwa}
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

if miary_wyb = 0 then Exit;

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
end;


end. {Ustrojstwa}