program MainUpozn;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Storage in 'Storage.pas',
  Windows,
  CreateUnit in 'CreateUnit.pas',
  ReadUnit in 'ReadUnit.pas',
  LoadSave in 'LoadSave.pas',
  UpdateUnit in 'UpdateUnit.pas';

procedure clrscr;
var
  cursor: COORD;
  r: cardinal;
  abs: TDAte;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r,
    cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

procedure GetInput(str: string);
begin
  clrscr;
  Writeln(str);
end;


procedure ShowDishes;
begin
  if Length(dishes) > 0 then
  begin
    GetInput(Storage.GetDishes);
  end
  else
    GetInput('Пусто');

end;



procedure RemoveDish;
var
  input: string;
  choose: integer;
  flag: boolean;
begin
  if (Length(dishes) > 0) then
  begin
    flag := true;
    While flag do
    begin
      ShowDishes;
      Writeln('Введите ID блюда для удаления');
      readln(input);
      if TryStrToInt(input, choose) and (choose >= Low(Storage.dishes)) and
        (choose <= High(Storage.dishes)) then
      begin
        Storage.RemoveDish(choose);
        flag := false;
      end;

    end;
    GetInput('Удаленно');
  end
  else
    GetInput('Вы не добавили ни одного блюда');

end;

procedure RemoveCategory;
var
  input: string;
  choose: integer;
  flag: boolean;
begin
  if (Length(dishes) > 0) then
  begin
    flag := true;
    While flag do
    begin
      Writeln(Storage.GetCategories);
      Writeln('Введите ID категории ');
      readln(input);
      if TryStrToInt(input, choose) and (choose >= Low(Storage.categories)) and
        (choose <= High(Storage.categories)) then
      begin
        Storage.RemoveDish(choose);
        flag := false;
      end;

    end;
    GetInput('Удаленно');
  end
  else
    GetInput('Вы не добавили ни одной категории');

end;

procedure ChangeDish;
var
  id, category, choose: integer;
  cost: Currency;
  name, input: string;
  flag: boolean;
begin
  if (Length(dishes) > 0) then
  begin
    category := -1;
    cost := -1;
    name := '';

    flag := true;
    While flag do
    begin
      ShowDishes;
      Writeln('Введите ID блюда для изменения');
      readln(input);
      if TryStrToInt(input, choose) and (choose >= Low(Storage.dishes)) and
        (choose <= High(Storage.dishes)) then
      begin
        id := choose;
        flag := false;
      end;
    end;
    GetInput('Введите новое имя или нажмите Enter для пропуска');
    readln(name);
    flag := true;
    While flag do
    begin

      GetInput('Выберите новую категорию блюда или напишите -1 для пропуска:' +
        #10 + #13 + Storage.GetCategories);
      readln(input);
      if (TryStrToInt(input, category)) and (category >= -1) and
        (category <= High(categories)) then
      begin
        flag := false;
      end;
    end;
    flag := true;
    While flag do
    begin

      Writeln('Введите новую цену блюда или -1 для пропуска');
      readln(input);
      if (TryStrToCurr(input, cost)) then
      begin
        flag := false;
      end;
    end;
    GetInput('Готово');
  end
  else
    GetInput('Вы не добавили ни одного блюда');

end;

procedure ChangeCategory;
var
  id, category, choose: integer;
  name, input: string;
  flag: boolean;
begin
  if (Length(dishes) > 0) then
  begin
    category := -1;
    id := -1;
    name := '';

    flag := true;
    While flag do
    begin
      Writeln(Storage.GetCategories);
      Writeln('Введите ID категории для изменения');
      readln(input);
      if TryStrToInt(input, choose) and (choose >= Low(Storage.dishes)) and
        (choose <= High(Storage.dishes)) then
      begin
        id := choose;
        flag := false;
      end;
    end;
    GetInput('Введите новое имя или нажмите Enter для пропуска');
    readln(name);
    if name <> '' then
    begin
      Storage.ChangeCategory(id, name);
    end
    else
      Writeln('Отменено');

  end;
end;




procedure Update;
var
  choose: integer;
  input: string;
begin
  GetInput('Изменить:' + #10 + #13 + '1.Заказ' + #10 + #13 + '2.Блюдо' + #10 +
    #13 + '3.Категорию блюда' + #10 + #13);
  readln(input);
  if (TryStrToInt(input, choose)) then
    case choose of
      2:
        begin
          ChangeDish;
          readln;
        end;
      3:
        begin
          ChangeCategory;
          readln;
        end;
    end;
end;

procedure Remove;
var
  choose: integer;
  input: string;
begin
  GetInput('Удалить:' + #10 + #13 + '1.Заказ' + #10 + #13 + '2.Блюдо' + #10 +
    #13 + '3.Категорию блюда' + #10 + #13);
  readln(input);
  if (TryStrToInt(input, choose)) then
  begin

    case choose of
      2:
        begin
          RemoveDish;
          readln;
        end;
      3:
        begin
          RemoveCategory;
          readln;
        end;
    end;
  end;

end;





procedure MainChoose(var flag: boolean);
var
  choose: integer;
  input: string;
begin
  GetInput('1.Добавить' + #10 + #13 + '2.Вывести' + #10 + #13 + '3.Изменить' +
    #10 + #13 + '4.Удалить' + #10 + #13 + '5.Сохранить' + #10 + #13 +
    '6.Загрузить' + #10 + #13 + '0.Выход' + #10 + #13);
  readln(input);
  if (TryStrToInt(input, choose)) then
    case choose of
      1:
        CreateUnit.Create;
      2:
        MyRead;
      3:
        UpdateUnit.Update;
      4:
        Remove;
      5:
        Save;
      6:
        Load;
      0:
        flag := false;

    end;

end;

var
  flag: boolean;
  a:double;

begin
                         ;
  flag := true;
  While flag do
    MainChoose(flag);

end.
