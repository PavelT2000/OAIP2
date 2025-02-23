program Lab;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

Type
  noteRecord = record
    num: Integer;
    str: string;
  end;

  TMAS = array [1 .. 1000] of noteRecord;

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
  writeln('_____________________________________________________');
  writeln('Index of elem    Field 1            Field 2');
  for var i := Low(mas) to High(mas) do
  begin
    writeln(i:7, mas[i].num:17, mas[i].str:20);
  end;
  writeln('_____________________________________________________');

end;

function BinSearch(var mas: TMAS; target: string; outInfo: boolean): Integer; overload;
begin
  var
    left, right, mid,count: Integer;
  var elem:noteRecord;
  count:=0;

  left := Low(mas);
  right := High(mas);
  Result := -1;

  while left <= right do
  begin
    mid := left + (right - left) div 2;
    elem:=mas[mid];
    Inc(count);
    if (elem.str = target) then
      Result := mid;
    if (elem.str < target) then
      left := mid + 1
    else
      right := mid - 1;
  end;
  if outInfo then
  writeln('Запись была найдена за ',count,' обращений');
end;

function BinSearch(mas: TMAS; target: integer; outInfo: boolean): array of noteRecord; overload;
begin
  var
    left, right, mid,count: Integer;
  var elem:noteRecord;
  count:=0;

  left := Low(mas);
  right := High(mas);
  Result := -1;

  while left <= right do
  begin
    mid := left + (right - left) div 2;
    elem:=mas[mid];
    Inc(count);
    if (elem.num = target) then
      Result.:= mid;
    if (elem.num < target) then
      left := mid + 1
    else
      right := mid - 1;
  end;
  if outInfo then
  writeln('Запись была найдена за ',count,' обращений');
end;

begin
  var
    mas: TMAS;
  var
    inputStr: string;
  var
    inputInt:Integer;
  FillMas(mas);
  PrintMas(mas);
  MasSort(mas,2);
  PrintMas(mas);
  Readln(inputStr);
  BinSearch(mas,inputStr,True);
  MasSort(mas,1);
  PrintMas(mas);
  Readln(inputInt);
  BinSearch(mas,inputInt,True);



  readln;

  end.
