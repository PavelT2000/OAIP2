program Project2;


{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Windows,
  System.SysUtils;

var input:AnsiString;
begin
  SetConsoleOutputCP(1251);
  SetConsoleCP(1251);


Writeln('������� 13:',#10,#13,'���������� ������� �����, ������� �� ������ ����� ��� � ���� �����. ������� �������� ������������������ ����.');
Readln(input);
end.
