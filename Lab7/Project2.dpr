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


Writeln('Задание 13:',#10,#13,'Напечатать гласные буквы, которые не входят более чем в одно слово. Вывести исходную последовательность слов.');
Readln(input);
end.
