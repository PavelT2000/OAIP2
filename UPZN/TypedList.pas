unit TypedList;

interface
uses SysUtils;

type
  TTypedList = class
  protected
    FItemSize: Integer;
    FItems: array of Pointer;
    FCount: Integer;
    procedure SetCapacity(NewCapacity: Integer);
    function Get(Index: Integer): Pointer;
  public
    constructor Create(ItemSize: Integer);
    destructor Destroy; override;

    procedure Clear;
    procedure Delete(Index: Integer);
    function Add(Item: Pointer): Integer;
    procedure Insert(Index: Integer; Item: Pointer);

    property Count: Integer read FCount;
    property ItemSize: Integer read FItemSize;
  end;

implementation

{ TTypedList }

constructor TTypedList.Create(ItemSize: Integer);
begin
  inherited Create;
  FItemSize := ItemSize;
  FCount := 0;
  SetCapacity(4); // Начальная емкость
end;

destructor TTypedList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TTypedList.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity <> Length(FItems) then
  begin
    if NewCapacity < FCount then
      FCount := NewCapacity;
    SetLength(FItems, NewCapacity);
  end;
end;

function TTypedList.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    raise Exception.Create('Index out of bounds');
  Result := FItems[Index];
end;

procedure TTypedList.Clear;
var
  I: Integer;
begin
  for I := 0 to FCount - 1 do
    FreeMem(FItems[I]);
  FCount := 0;
  SetCapacity(0);
end;

procedure TTypedList.Delete(Index: Integer);
var
  I: Integer;
begin
  if (Index < 0) or (Index >= FCount) then
    raise Exception.Create('Index out of bounds');

  FreeMem(FItems[Index]);

  // Сдвигаем оставшиеся элементы
  for I := Index to FCount - 2 do
    FItems[I] := FItems[I + 1];

  Dec(FCount);

  // Уменьшаем емкость если нужно
  if (FCount > 0) and (FCount = Length(FItems) div 4) then
    SetCapacity(Length(FItems) div 2);
end;

function TTypedList.Add(Item: Pointer): Integer;
begin
  Result := FCount;
  if FCount = Length(FItems) then
    SetCapacity(FCount + FCount div 4 + 4); // Увеличиваем емкость на 25% + 4

  GetMem(FItems[FCount], FItemSize);
  Move(Item^, FItems[FCount]^, FItemSize);
  Inc(FCount);
end;

procedure TTypedList.Insert(Index: Integer; Item: Pointer);
var
  I: Integer;
begin
  if (Index < 0) or (Index > FCount) then
    raise Exception.Create('Index out of bounds');

  if FCount = Length(FItems) then
    SetCapacity(FCount + FCount div 4 + 4);

  // Сдвигаем элементы для вставки
  for I := FCount downto Index + 1 do
    FItems[I] := FItems[I - 1];

  GetMem(FItems[Index], FItemSize);
  Move(Item^, FItems[Index]^, FItemSize);
  Inc(FCount);
end;

end.
