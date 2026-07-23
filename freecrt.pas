unit FreeCrt;

interface

procedure ClrScr;

implementation

procedure ClrScr;
begin
  {$IFDEF MSDOS}
    (* Dla 16-bitowego DOS-a: czysty BIOS bez szukania modułu Crt *)
    asm
      mov ah, 06h     (* Funkcja: przewijanie okna *)
      mov al, 00h     (* 0 = wyczyść całe okno *)
      mov bh, 07h     (* Atrybut: biały tekst na czarnym tle *)
      mov cx, 0000h   (* Lewy górny róg: 0,0 *)
      mov dx, 184Fh   (* Prawy dolny róg: 24,79 *)
      int 10h         (* Wywołanie BIOS wideo *)
      
      (* Ustawienie kursora na lewy górny róg (0,0) *)
      mov ah, 02h
      mov bh, 00h
      mov dx, 0000h
      int 10h
    end;
  {$ELSE}
    (* Dla nowoczesnych systemów: kody ANSI *)
    write(#27'[2J'#27'[H');
  {$ENDIF}
end;

end.