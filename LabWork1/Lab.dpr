﻿program Lab;

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
  writeln('_____________________________________________________');
  writeln('Index of elem    Field 1            Field 2');
  for var i := Low(mas) to High(mas) do
  begin
    writeln(i:7, mas[i].num:17, mas[i].str:20);
  end;
  writeln('_____________________________________________________');
end;

procedure PrintSearch(var mas: TOut; apealCount: Integer;searchName:string);
begin
  Writeln;
  writeln('Result of ',searchName);
  writeln('_____________________________________________________');
  writeln('Index of elem    Field 1            Field 2');
  for var i := Low(mas) to High(mas) do
  begin
    writeln(mas[i].index:7, mas[i].num:17, mas[i].str:20);
  end;
  writeln('_____________________________________________________');
  writeln('Count of apeal to mas: ', apealCount);
  Readln;
end;


var
  mas: TMAS;
  outmas: TOut;
  inputStr: string;
  inputInt,inputInt2, apealCount: Integer;
begin

  FillMas(mas);
  PrintMas(mas);
  MasSort(mas, 2);
  PrintMas(mas);
  writeln('Enter InputStr');
  Readln(inputStr);
  outmas := BlockSearch(mas, inputStr, apealCount);
  PrintSearch(outmas, apealCount,'Block Search');
  outmas := BinSearch(mas, inputStr, apealCount);
  PrintSearch(outmas, apealCount,'Binary Search');

  MasSort(mas, 1);
  PrintMas(mas);
  writeln('Enter inputInt');
  Readln(inputInt);
  outmas := BlockSearch(mas, inputInt, apealCount);
  PrintSearch(outmas, apealCount,'Block Search');
  outmas := BinSearch(mas, inputInt, apealCount);
  PrintSearch(outmas, apealCount,'Binary Search');
   writeln('Enter inputIntx2');
  Readln(inputInt);
  Readln(inputInt2);
  outmas :=BlockSearch(mas, inputInt,inputInt2, apealCount);
  PrintSearch(outmas, apealCount,'Block Search');
  outmas :=BinSearch(mas, inputInt,inputInt2, apealCount);
  PrintSearch(outmas, apealCount,'Binary Search');
  Readln;
 end.
