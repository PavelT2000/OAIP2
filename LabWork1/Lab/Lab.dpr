program Lab;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  BlockS in 'BlockS.pas',
  BinS in 'BinS.pas',
  SAll in 'SAll.pas';

function Compare(a: noteRecord; b: noteRecord; fieldChoose: Integer): Integer;
begin
  case fieldChoose of
    1:
      begin
        if a.num > b.num then
          Result := 1
        else if a.num = b.num then
          Result := 0
        else
          Result := -1;
      end;
    2:
      begin
        if a.str > b.str then
          Result := 1
        else if a.str = b.str then
          Result := 0
        else
          Result := -1;
      end;

  end;

end;

procedure FillMas(var mas: TMAS);
begin
  for var i := Low(mas) to High(mas) do
  begin
    mas[i].num := Random(325);
    mas[i].str := 'sensor_' + i.ToString;
  end;
end;

procedure MasSort(var mas: TMAS; fieldChoose: Integer);
begin
  var
    left, right, lastSwap, i: Integer;
  var
    temp: noteRecord;
  left := Low(mas);
  right := High(mas);
  lastSwap := 0;
  while (right > left) do
  begin
    for i := left to right - 1 do
    begin
      if (Compare(mas[i], mas[i + 1], fieldChoose) > 0) then
      begin
        temp := mas[i];
        mas[i] := mas[i + 1];
        mas[i + 1] := temp;
        lastSwap := i;
      end;
    end;
    right := lastSwap;

    for i := right downto left + 1 do
    begin
      if (Compare(mas[i], mas[i - 1], fieldChoose) < 0) then
      begin
        temp := mas[i];
        mas[i] := mas[i - 1];
        mas[i - 1] := temp;
        lastSwap := i;
      end;
    end;
    left := lastSwap;

  end;

end;

procedure PrintMas(var mas: TMAS);
begin
  Writeln;
  Writeln('_____________________________________________________');
  Writeln('Index of elem    Field 1            Field 2');
  for var i := Low(mas) to High(mas) do
  begin
    Writeln(i:7, mas[i].num:17, mas[i].str:20);
  end;
  Writeln('_____________________________________________________');
end;

procedure PrintSearch(var mas: TOut; apealCount: Integer; searchName: string);
begin
  Writeln;
  Writeln('Result of ', searchName);
  Writeln('_____________________________________________________');
  Writeln('Index of elem    Field 1            Field 2');
  if Length(mas) = 0 then
    Writeln('List is empty');
  for var i := Low(mas) to High(mas) do
  begin
    Writeln(mas[i].index:7, mas[i].num:17, mas[i].str:20);
  end;
  Writeln('_____________________________________________________');
  Writeln('Count of apeal to mas: ', apealCount);
  Writeln('Press enter...');
  //Readln;
end;

procedure Test1(mas: TMAS);
var
  apealCount, x, y: Integer;
  outMas: TOut;
begin
  // BinSearch 1 field
  MasSort(mas, 1);
  for var i := -1000 to 1000 do
  begin
    Writeln(i);
    outMas := BinSearch(mas, i, apealCount);
    PrintSearch(outMas, apealCount, 'Binary Search');
  end;
  // BlockSearch 1 field
  MasSort(mas, 1);
  for var i := -1000 to 1000 do
  begin
    Writeln(i);
    outMas := BlockSearch(mas, i, apealCount);
    PrintSearch(outMas, apealCount, 'Block Search');
  end;
end;

procedure Test2(mas: TMAS);
var
  apealCount, x, y: Integer;
  outMas: TOut;
begin
  // BlockSearch 2 field
  MasSort(mas, 2);
  for var i := -1000 to 2000 do
  begin
    Writeln;
    Writeln;
    Writeln('sensor_' + i.ToString());
    outMas := BlockSearch(mas, 'sensor_' + i.ToString(), apealCount);
    PrintSearch(outMas, apealCount, 'Block Search');
  end;

  // BinSearch 2 field
  MasSort(mas, 2);
  for var i := -1000 to 2000 do
  begin
    Writeln;
    Writeln;
    Writeln('sensor_' + i.ToString());
    outMas := BinSearch(mas, 'sensor_' + i.ToString(), apealCount);
    PrintSearch(outMas, apealCount, 'Binary Search');
  end;
end;

procedure Test3(mas: TMAS);
var
  apealCount, x, y: Integer;
  outMas: TOut;
begin

  // BlockSearch diapos
  MasSort(mas, 1);
  for x := -10 to 10 do
  begin
    for y := x to 20 do
    begin
      Writeln('x=', x, ' y=', y);
      outMas := BinSearch(mas, x, y, apealCount);
      PrintSearch(outMas, apealCount, 'Block Search');
    end;
  end;
  for x := 300 to 350 do
  begin
    for y := x to 350 do
    begin
      Writeln('x=', x, ' y=', y);
      outMas := BinSearch(mas, x, y, apealCount);
      PrintSearch(outMas, apealCount, 'Block Search');
    end;
  end;
  // BinSearch diapos
  MasSort(mas, 1);
  for x := -10 to 10 do
  begin
    for y := x to 20 do
    begin
      Writeln('x=', x, ' y=', y);
      outMas := BinSearch(mas, x, y, apealCount);
      PrintSearch(outMas, apealCount, 'Binary Search');
    end;
  end;
  for x := 300 to 350 do
  begin
    for y := x to 350 do
    begin
      Writeln('x=', x, ' y=', y);
      outMas := BlockSearch(mas, x, y, apealCount);
      PrintSearch(outMas, apealCount, 'Binary Search');
    end;
  end;
end;

var
  mas: TMAS;
  outMas: TOut;
  inputStr: string;
  inputInt, lowBound, highBound, apealCount: Integer;

begin
  FillMas(mas);

  Test1(mas);
  Test2(mas);
  Test3(mas);
  readln;





//   MasSort(mas, 2);
//   PrintMas(mas);
//   Writeln('Enter Second Field');
//   Readln(inputStr);
//   outmas := BlockSearch(mas, inputStr, apealCount);
//   PrintSearch(outmas, apealCount, 'Block Search');
//   outmas := BinSearch(mas, inputStr, apealCount);
//   MasSort(mas, 1);
//   PrintMas(mas);
//   Writeln('Enter First Field');
//   Readln(inputInt);
//   outmas := BlockSearch(mas, inputInt, apealCount);
//   PrintSearch(outmas, apealCount, 'Block Search');
//   outmas := BinSearch(mas, inputInt, apealCount);
//   PrintSearch(outmas, apealCount, 'Binary Search');
//   Writeln('Enter LowBound of first field');
//   Readln(lowBound);
//   Writeln('Enter HighBound of first field');
//   Readln(highBound);
//   outmas := BlockSearch(mas, lowBound, highBound, apealCount);
//   PrintSearch(outmas, apealCount, 'Block Search');
//   outmas := BinSearch(mas, lowBound, highBound, apealCount);
//   PrintSearch(outmas, apealCount, 'Binary Search');
//   Readln;

end.
