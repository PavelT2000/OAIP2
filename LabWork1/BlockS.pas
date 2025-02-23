unit BlockS;

interface

uses SAll;

function BlockSearch(var mas: TMAS; target: string; var counter: Integer)
  : TOut; overload;
function BlockSearch(const mas: TMAS; target: Integer; var counter: Integer)
  : TOut; overload;
function BlockSearch(const mas: TMAS; start, myEnd: Integer;
  var counter: Integer): TOut; overload;

implementation

function BlockSearch(var mas: TMAS; target: string; var counter: Integer)
  : TOut; overload;
var
  blockNum, blockLen, i: Integer;
  flag: boolean;

begin
  counter := 0;
  blockNum := 0;
  i := 1;
  blockLen := Trunc(sqrt(Length(mas)));
  while blockNum = 0 do
  begin
    Inc(counter);
    if mas[i * blockLen + 1].str >= target then
    begin
      blockNum := i;
    end;
    Inc(i);
  end;
  i := (blockNum - 1) * blockLen + 1;
  flag := true;
  while (i <= (blockNum) * blockLen + 1) and flag do
  begin
    Inc(counter);
    if mas[i].str = target then
    begin
      SetLength(Result, 1);
      Result[0].index := i;
      Result[0].num := mas[i].num;
      Result[0].str := mas[i].str;
      flag := false
    end;
    Inc(i);
  end;

end;

function BlockSearch(const mas: TMAS; target: Integer; var counter: Integer)
  : TOut; overload;
var
  blockNum, blockLen, i: Integer;
  flag: boolean;
begin
  counter := 0;
  blockNum := 0;
  i := 1;
  blockLen := Trunc(sqrt(Length(mas)));
  while blockNum = 0 do
  begin
    Inc(counter);
    if mas[i * blockLen + 1].num >= target then
    begin
      blockNum := i;
    end;
    Inc(i);
  end;
  i := (blockNum - 1) * blockLen + 1;
  flag := true;
  while (i <= (blockNum) * blockLen + 1) and flag do
  begin
    Inc(counter);
    if mas[i].num = target then
    begin
      Result := SearchAll(mas, i, target);
      flag := false
    end;
    Inc(i);
  end;
end;

function BlockSearch(const mas: TMAS; start, myEnd: Integer;
  var counter: Integer): TOut; overload;
var
  blockNum, blockLen, i: Integer;
  flag: boolean;
begin
  counter := 0;
  blockNum := 0;
  i := 1;
  blockLen := Trunc(sqrt(Length(mas)));
  while blockNum = 0 do
  begin
    Inc(counter);
    if mas[i * blockLen + 1].num >= start then
    begin
      blockNum := i;
    end;
    Inc(i);
  end;
  i := (blockNum - 1) * blockLen + 1;
  flag := true;
  while (i <= (blockNum) * blockLen + 1) and flag do
  begin
    Inc(counter);
    if (mas[i].num >= start) and (mas[i].num <= myEnd) then
    begin
      Result := SearchAllDiapos(mas, i, start, myEnd);
      flag := false
    end;
    Inc(i);
  end;
end;

end.
