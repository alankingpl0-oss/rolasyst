unit FreeCrt; (* Program ten to po prostu taka bilioteka *)

interface

procedure ClrScr;

implementation

procedure ClrScr;

begin
write(#27'[2J'#27'[H');
end;
end.
