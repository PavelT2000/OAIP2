unit Storage;

interface

uses SysUtils;

Type
  myStr = string[255];

  Dish = record
    id: integer;
    cost: currency;
    category: integer;
    name: string[255];
  end;

  pDish = ^Dish;

  dishElem = record
    DishID: integer;
    count: integer;
    next: ^dishElem;
  end;

  pDishElement = ^dishElem;

  Order = record
    id: integer;
    DishesList: pDishElement;
    table: integer;
  end;

  pOrder = ^Order;
  pOrderElem=^OrderElem;
  orderElem = record
    data: pOrder;
    prev: pOrderElem;
  end;
 

var
  dishes: array of pDish;
  categories: array of myStr;
  orders:pOrderElem;
  orderID:integer;
procedure LaunchStorage;


procedure ClearDishes;
procedure ClearCategories;

function CheckDishID(id: integer): boolean;
function SelectDish(input: string): string;

procedure AddCategory(name: string);
procedure AddDish(name: string; cost: currency; category: integer);
procedure AddOrder(table: integer; DishesList: pDishElement);

procedure ChangeDish(id: integer; name: string; category: integer;
  cost: currency);
procedure ChangeCategory(id: integer; name: string);

procedure RemoveDish(id: integer);
procedure RemoveCategory(id: integer);

function GetDishes: string;
function GetCategories: string;

function ReadCategories: boolean;
function ReadDishes: boolean;

procedure SaveCategories;
procedure SaveDishes;

implementation

var
  selectedDish: pDish;

procedure LaunchStorage;
begin
  Orders:=nil;
  SetLength(dishes, 0);
  SetLength(categories, 0);
  orderId:=1;
end;

procedure AddCategory(name: string);
begin
  if name <> '' then
  begin
    SetLength(categories, length(categories) + 1);
    categories[High(categories)] := name;
  end;
end;

function GetCategories: string;
var
  res: string;
begin
  res := '';
  for var i := Low(categories) to High(categories) do
  begin
    res := res + IntToStr(i) + ': ' + categories[i] + #10 + #13;
    Result := res;
  end;
end;

function GetDishes: string;
var
  res: string;
begin
  res := '';

  for var i := Low(dishes) to High(dishes) do
  begin
    res := res + 'ID: ' + IntToStr(dishes[i]^.id) + #13 + #10 + '��������: ' +
      dishes[i]^.name + #13 + #10 + '���������: ' + categories
      [dishes[i]^.category] + #13 + #10 + '����: ' + CurrToStrF(dishes[i]^.cost,
      ffCurrency, 2) + #13 + #10 + #13 + #10;
  end;
  Result := res;
end;

procedure AddDish(name: string; cost: currency; category: integer);
var
  pos: integer;
  newDish: pDish;
begin
  new(newDish);
  pos := length(dishes);
  SetLength(dishes, pos + 1);
  newDish^.id := pos;
  newDish^.name := name;
  newDish^.category := category;
  newDish^.cost := cost;
  dishes[pos] := newDish;
end;

procedure AddOrder(table: integer; DishesList: pDishElement);
var
  newOrderElem: pOrderElem;
  newOrder:pOrder;
  
begin
new(newOrderElem);
new(newOrder);
newOrder.id:=orderId;
Inc(orderId);
newOrder.dishesList:=dishesList;
newOrder.table:=table;

newOrderElem.prev:=orders;
newORderElem.data:=newOrder;
orders:=newOrderElem;




end;

procedure RemoveDish(id: integer);
begin
  Dispose(dishes[id]);
  for var i := id to High(dishes) - 1 do
  begin
    dishes[i] := dishes[i + 1];
    dishes[i]^.id := i;
  end;
  SetLength(dishes, length(dishes) - 1);

end;

procedure RemoveCategory(id: integer);
begin
  for var i := id to High(categories) - 1 do
  begin
    categories[i] := categories[i + 1];
  end;
end;

function SelectDish(input: string): string;
var
  id, code: integer;
begin
  Result := '';
  val(input, id, code);
  if code <> 1 then
  begin
    if (id >= Low(dishes)) and (id <= High(dishes)) then
      selectedDish := dishes[id]
    else
      Result := '����� �� �������(����� �� ��������� ������)';
  end;
end;

procedure ChangeDish(id: integer; name: string; category: integer;
  cost: currency);
var
  MyDish: pDish;
begin
  MyDish := dishes[id];
  if name <> '' then
    MyDish.name := name;
  if category <> -1 then
    MyDish.category := category;
  if cost <> -1 then
    MyDish.category := category;
end;

procedure ChangeCategory(id: integer; name: string);
begin
  categories[id] := name;
end;

procedure ClearDishes;
begin
  for var i := Low(dishes) to High(dishes) do
  begin
    Dispose(dishes[i]);
  end;
  SetLength(dishes, 0);
end;

procedure ClearCategories;
begin
  SetLength(categories, 0);
end;

function CheckDishID(id: integer): boolean;
begin
  if (id >= Low(dishes)) and (id <= High(dishes)) then
  begin
    Result := True;
  end
  else
  begin
    Result := false;
  end;
end;

procedure SaveCategories;
var
  myFile: file of string[255];
begin
  assign(myFile, 'categories');
  Rewrite(myFile);
  Seek(myFile, 0);
  for var i := Low(categories) to High(categories) do
  begin
    Write(myFile, categories[i]);
  end;
  CloseFile(myFile);
end;

procedure SaveDishes;
begin
  var
    myFile: file of Dish;
  begin

    assign(myFile, 'dishes');
    Rewrite(myFile);
    Seek(myFile, 0);
    for var i := Low(dishes) to High(dishes) do
    begin
      Write(myFile, dishes[i]^);
    end;

  end;

end;

function ReadDishes: boolean;
var
  Len: integer;
  myFile: file of Dish;
  temp: Dish;
begin
  if FileExists('dishes') then
  begin
    ClearDishes;
    assignFile(myFile, 'dishes');
    Reset(myFile);
    Len := FileSize(myFile);
    Seek(myFile, 0);
    for var i := 1 to Len do
    begin
      Read(myFile, temp);
      AddDish(temp.name, temp.cost, temp.category);
    end;
    CloseFile(myFile);
    Result := True;
  end
  else
    Result := false;

end;

function ReadCategories: boolean;
var
  Len: integer;
  myFile: file of myStr;
  temp: myStr;
begin

  if FileExists('categories') then
  begin
    ClearCategories;
    assignFile(myFile, 'categories');
    Reset(myFile);
    Len := FileSize(myFile);
    Seek(myFile, 0);
    for var i := 1 to Len do
    begin
      Read(myFile, temp);
      AddCategory(temp);
    end;
    CloseFile(myFile);
    Result := True;
  end
  else
    Result := false;

end;

end.
