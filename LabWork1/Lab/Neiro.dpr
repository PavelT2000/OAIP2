program Neiro;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Generics.Collections,
  Generics.Defaults;

type
  TRecord = record
    Number: Integer;
    Sensor: string;
  end;

var
  Records: TArray<TRecord>;
  i: Integer;
  SearchKey: string;
  SearchNumber: Integer;
  Min, Max: Integer;
  Comparisons: Integer;

procedure GenerateRecords;
var
  i: Integer;
begin
  SetLength(Records, 1000);
  for i := 0 to 999 do
  begin
    Records[i].Number := Random(326);
    Records[i].Sensor := 'sensor_' + IntToStr(i + 1);
  end;
end;

procedure PrintRecords;
var
  i: Integer;
begin
  for i := 0 to 999 do
  begin
    Writeln(Format('Index: %d, Number: %d, Sensor: %s', [i, Records[i].Number, Records[i].Sensor]));
  end;
end;

procedure SortBySensor;
begin
  TArray.Sort<TRecord>(Records, TComparer<TRecord>.Construct(
    function(const Left, Right: TRecord): Integer
    begin
      Result := CompareStr(Left.Sensor, Right.Sensor);
    end));
end;

procedure SortByNumber;
begin
  TArray.Sort<TRecord>(Records, TComparer<TRecord>.Construct(
    function(const Left, Right: TRecord): Integer
    begin
      Result := Left.Number - Right.Number;
    end));
end;

function BinarySearchBySensor(const Key: string; out Comparisons: Integer): Integer;
var
  Low, High, Mid: Integer;
begin
  Low := 0;
  High := Length(Records) - 1;
  Comparisons := 0;
  while Low <= High do
  begin
    Inc(Comparisons);
    Mid := (Low + High) div 2;
    if Records[Mid].Sensor = Key then
      Exit(Mid)
    else if Records[Mid].Sensor < Key then
      Low := Mid + 1
    else
      High := Mid - 1;
  end;
  Result := -1;
end;

procedure SearchByNumber(Number: Integer; out Comparisons: Integer);
var
  i: Integer;
begin
  Comparisons := 0;
  for i := 0 to Length(Records) - 1 do
  begin
    Inc(Comparisons);
    if Records[i].Number = Number then
    begin
      Writeln(Format('Index: %d, Number: %d, Sensor: %s', [i, Records[i].Number, Records[i].Sensor]));
    end;
  end;
end;

procedure SearchByRange(Min, Max: Integer; out Comparisons: Integer);
var
  i: Integer;
begin
  Comparisons := 0;
  for i := 0 to Length(Records) - 1 do
  begin
    Inc(Comparisons);
    if (Records[i].Number >= Min) and (Records[i].Number <= Max) then
    begin
      Writeln(Format('Index: %d, Number: %d, Sensor: %s', [i, Records[i].Number, Records[i].Sensor]));
    end;
  end;
end;

begin
  Randomize;
  GenerateRecords;

  Writeln('Generated Records:');
  PrintRecords;

  SortBySensor;
  Writeln('Sorted by Sensor:');
  PrintRecords;

  Writeln('Enter sensor key to search:');
  Readln(SearchKey);
  i := BinarySearchBySensor(SearchKey, Comparisons);
  if i <> -1 then
  begin
    Writeln(Format('Found record: Index: %d, Number: %d, Sensor: %s', [i, Records[i].Number, Records[i].Sensor]));
    Writeln('Comparisons: ', Comparisons);
  end
  else
  begin
    Writeln('Record not found.');
  end;

  SortByNumber;
  Writeln('Sorted by Number:');
  PrintRecords;

  Writeln('Enter number to search:');
  Readln(SearchNumber);
  SearchByNumber(SearchNumber, Comparisons);
  Writeln('Comparisons: ', Comparisons);

  Writeln('Enter min and max for range search:');
  Readln(Min, Max);
  SearchByRange(Min, Max, Comparisons);
  Writeln('Comparisons: ', Comparisons);

  Readln;
end.
