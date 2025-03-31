program HanoiTower;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

Type
  pDisk = ^disk;

  disk = record
    data: integer;
    next: pDisk;
  end;

  pTower = ^tower;

  tower = record
    plates: array [1 .. 9] of integer;
    next: pTower;
  end;

function CreateTask(N: integer): pTower;
var
  tower: pTower;
  a, b: pTower;
begin
  tower := new(pTower);

  a := new(pTower);
  tower.next := a;

  b := new(pTower);
  tower.next.next := b;

  for var i := 1 to 9 do
  begin
    a^.plates[i] := 0;
    b^.plates[i] := 0;
  end;
  for var i := N downto 1 do
  begin
    tower^.plates[N - i + 1] := i;
  end;
  Result := tower;
end;

procedure PrintTowers(towers: pTower);

var
  tempTower: pTower;
begin

  for var i := High(tempTower^.plates) downto Low(tempTower^.plates) do
  begin
    tempTower := towers;

    repeat
      if (tempTower^.plates[i] = 0) then
        write('         0         ')
      else
      begin
        var
          num: integer;
        num := tempTower^.plates[i];

        write(stringOfChar(' ', 9 - num));
        write(stringOfChar(num.ToString()[1], num * 2 + 1));
        write(stringOfChar(' ', 9 - num));
      end;
      write('          ');

      tempTower := tempTower^.next;
    until (tempTower = nil);
    writeln;

  end;
  writeln;
end;
procedure Move(tower:pTower; from, dest:integer);
var f,d:pTower;
    tempTower:pTower;
begin
tempTower:=tower;
for var i:= 1 to 3 do
begin
  if i=from then
  f:=tempTower;
  if i=dest then
  d:=tempTower;
  tempTower:=tempTower.next;

end;
var i:=9;
var j:=9;

while(f^.plates[i]=0) do
Dec(i);
while (j>0) and (d^.plates[j]=0)  do
Dec(j);
Inc(j);

d^.plates[j]:=f^.plates[i];
f^.plates[i]:=0;
PrintTowers(tower);

end;

procedure HanoiSolve(tower: pTower;N:integer; var Counter:integer);
  procedure HanoiSolve_main(N, start, goal, additional: integer);
  begin
  if n>0 then
  begin
  HanoiSolve_main(n-1,start,additional,goal);
  move(tower,start,goal);
  Inc(Counter);
  HanoiSolve_main(n-1,additional,goal,start);
  end;



  end;
begin
  HanoiSolve_main(N,1,3,2);
end;

procedure Clear(tower:pTower);
var temp:pTower;
begin
  temp:=tower;
  while(tower<>nil) do
  begin
  temp:=tower;
  tower:=tower^.next;
  Dispose(temp);
  end;
end;

var
  towers: pTower;
  counter:integer;
var count:integer;
begin
  readln(count);
  towers := CreateTask(count);
  PrintTowers(towers);
  HanoiSolve(towers,count,counter);
  writeln('������ �� ',counter,' �����');
  Clear(towers);

  readln;

end.
