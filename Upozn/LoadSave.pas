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
  GetInput('���������');
  readln;
end;

procedure Load;
begin
  clrscr;
  if Storage.ReadCategories then
    Writeln('��������� ���������');

  if Storage.ReadDishes then
    Writeln('����� ����������');

  Writeln('����������');
  readln;

end;

end.
