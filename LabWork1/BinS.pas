unit BinS;



interface
uses SAll;



function BinSearch(var mas: TMAS; target: string; var counter: Integer)
  : TOut; overload;
function BinSearch(const mas: TMAS; target: Integer; var counter: Integer)
  : TOut; overload;
function BinSearch(const mas: TMAS; start, myEnd: Integer; var counter: Integer)
  : TOut; overload;

implementation

function BinSearch(var mas: TMAS; target: string; var counter: Integer)
  : TOut; overload;
var
  left, right, mid, count: Integer;
  elem: noteRecord;
begin
  counter := 0;
  left := Low(mas);
  right := High(mas);
  SetLength(Result, 1);

  while left <= right do
  begin
    mid := left + (right - left) div 2;
    elem := mas[mid];
    Inc(counter);
    if (elem.str = target) then
    begin
      SetLength(Result, 1);
      Result[0].index := mid;
      Result[0].num := mas[mid].num;
      Result[0].str := mas[mid].str;
    end;
    if (elem.str < target) then
      left := mid + 1
    else
      right := mid - 1;
  end;
end;

function BinSearch(const mas: TMAS; target: Integer; var counter: Integer)
  : TOut; overload;
begin
  var
    left, right, mid, count: Integer;
  var
    elem: noteRecord;
  counter := 0;

  left := Low(mas);
  right := High(mas);

  while left <= right do
  begin
    mid := left + (right - left) div 2;
    elem := mas[mid];
    Inc(counter);
    if (elem.num = target) then
      Result := SearchAll(mas, mid, mas[mid].num);
    if (elem.num < target) then
      left := mid + 1
    else
      right := mid - 1;
  end;

end;

function BinSearch(const mas: TMAS; start, myEnd: Integer; var counter: Integer)
  : TOut; overload;
begin
  var
    left, right, mid, count: Integer;
  var
    elem: noteRecord;
  counter := 0;

  left := Low(mas);
  right := High(mas);

  while left <= right do
  begin
    mid := left + (right - left) div 2;
    elem := mas[mid];
    Inc(counter);
    if (elem.num >= start) and (elem.num <= myEnd) then
      Result := SearchAllDiapos(mas, mid, start, myEnd);
    if (elem.num < start) then
      left := mid + 1
    else
      right := mid - 1;
  end;

end;

end.
