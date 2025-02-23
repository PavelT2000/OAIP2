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

function SearchAllDiapos(const mas: TMAS; index: Integer; Start,myEnd: Integer): TOut;

implementation
function SearchAll(const mas: TMAS; index: Integer; target: Integer): TOut;
var
  flagL, flagH, counter: Integer;
begin
  flagL := 0;
  flagH := 0;
  counter := 1;
  while (flagL = 0) or (flagH = 0) do
  begin
    if  (index - counter>0)  and (target <> mas[index - counter].num) and (flagL = 0) then
      flagL := index - counter + 1;
    if (index + counter<High(mas)) and  (target <> mas[index + counter].num) and (flagH = 0) then
      flagH := index + counter - 1;
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

function SearchAllDiapos(const mas: TMAS; index: Integer; Start,myEnd: Integer): TOut;
var
  flagL, flagH, counter: Integer;
begin
  flagL := 0;
  flagH := 0;
  counter := 1;
  while (flagL = 0) or (flagH = 0) do
  begin
    if (index - counter>0)  and (Start > mas[index - counter].num) and (flagL = 0) then
      flagL := index - counter + 1;
    if (index + counter<High(mas)) and (myEnd < mas[index + counter].num) and (flagH = 0) then
      flagH := index + counter - 1;
    Inc(counter);
  end;
  SetLength(Result, flagH - flagL + 1);
  for var i := flagL to flagH do
  begin
    Result[i - flagL].index := i;
    Result[i - flagL].num := mas[i].num;
    Result[i - flagL].str := mas[i].str;
  end;

end;
end.
