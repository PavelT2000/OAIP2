unit LoadSave;

interface
uses
 Storage,
 ReadUnit;
 procedure Save;
 procedure Load;

implementation
procedure Save;
begin
  Storage.SaveCategories;
  Storage.SaveDishes;
  GetInput('Сохранено');
  readln;
end;

procedure Load;
begin
  clrscr;
  if Storage.ReadCategories then
    Writeln('Категории загружены');

  if Storage.ReadDishes then
    Writeln('Блюда закгружены');

  Writeln('Загруженно');
  readln;

end;

end.
