unit SAll;

interface

Type
  noteRecord = record
    num: Integer;
    str: string;
  end;

  outNoteRecord = record
    index: Integer;
    num: Integer;
    str: string;
  end;

  TMAS = array [1 .. 1000] of noteRecord;
  TOut = array of outNoteRecord;
function SearchAll(const mas: TMAS; index: Integer; target: Integer): TOut;

function SearchAllDiapos(const mas: TMAS; index: Integer;
  Start, myEnd: Integer): TOut;

implementation

function SearchAll(const mas: TMAS; index: Integer; target: Integer): TOut;
var
  flagL, flagH, counter: Integer;
begin
  flagL := 0;
  flagH := 0;
  counter := 0;
  while (flagL = 0) or (flagH = 0) do
  begin
    if (flagL = 0) and ((index - counter <= Low(mas)) or
      (mas[index - counter - 1].num <> target)) then
      flagL := index - counter;
    if (flagH = 0) and ((index + counter >= High(mas)) or
      (mas[index + counter + 1].num <> target)) then
      flagH := index + counter;
    Inc(counter);
  end;
  SetLength(Result, flagH - flagL + 1);
  for var i := flagL to flagH do
  begin
    Result[i - flagL].index := i;
    Result[i - flagL].num := target;
    Result[i - flagL].str := mas[i].str;
  end;

end;

function SearchAllDiapos(const mas: TMAS; index: Integer;
  Start, myEnd: Integer): TOut;
var
  flagL, flagH, counter: Integer; // c==========8
  flag: boolean;
begin
  flagL := 0;
  flagH := 0;
  flag := true;

  counter := 0;
  while ((flagL = 0) or (flagH = 0)) do
  begin
    // if (index - counter>0)  and (Start > mas[index - counter].num) and (flagL = 0) then
    if (flagL = 0) and ((index - counter <= Low(mas)) or
      (mas[index - counter - 1].num < Start)) then
      flagL := index - counter;
    // if (index + counter<High(mas)) and (myEnd < mas[index + counter].num) and (flagH = 0) then
    if (flagH = 0) and ((index + counter >= High(mas)) or
      (mas[index + counter + 1].num > myEnd)) then
      flagH := index + counter;
    Inc(counter);
  end;
  // if flagL=0 then
  // flagL:=1;
  // if flagH=0 then

  SetLength(Result, flagH - flagL + 1);
  for var i := flagL to flagH do
  begin
    Result[i - flagL].index := i;
    Result[i - flagL].num := mas[i].num;
    Result[i - flagL].str := mas[i].str;
  end;

end;

end.
