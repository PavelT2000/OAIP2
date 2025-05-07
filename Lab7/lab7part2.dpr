program lab7part2;

uses
  SysUtils;

type
  TNumberSet = set of 1..100;

procedure PrintSet(const SetName: string; const S: TNumberSet);
var
  i: Integer;
begin
  Write(SetName, ': [');
  for i := 1 to 100 do
    if i in S then
      Write(i, ' ');
  Writeln(']');
end;


procedure GenerateRandomSet(var S: TNumberSet);
var
  i, num: Integer;
begin
  S := [];
  Randomize;
  for i := 1 to 10 do
  begin
    repeat
      num := Random(100) + 1;
    until not (num in S);
    S := S + [num];
  end;
end;

var
  X1, X2, X3, Y: TNumberSet;
  i: Integer;
begin

  GenerateRandomSet(X1);
  GenerateRandomSet(X2);
  GenerateRandomSet(X3);


  PrintSet('X1', X1);
  PrintSet('X2', X2);
  PrintSet('X3', X3);


  Y := (X1 - X2) + (X2 * X3);


  PrintSet('Y = (X1 - X2) + (X2 * X3)', Y);

  Readln;
end.
