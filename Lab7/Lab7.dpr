program Lab7;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Winapi.Windows,
  System.SysUtils;

Const
  letters = '�������������������������������';
  vowels = '���������';

var
  input, checkedLetters: AnsiString;
  flag: boolean;
  letter: ansiChar;
  answ: string;

begin
  SetConsoleOutputCP(1251);
  SetConsoleCP(1251);

  Writeln('������� 13:', #10, #13,
    '���������� ������� �����, ������� ������ ����� ��� � ���� �����. ������� �������� ������������������ ����.');
  Readln(input);
  answ := '';
  for var i := Low(input) to High(input) do
  begin
    if vowels.Contains(input[i]) and not answ.Contains(input[i]) then
    begin
      letter := input[i];
      flag := true;
      var
        j: integer;
      j := i + 1;
      while (j <= High(input)) and not',. '.Contains(input[j]) do
        Inc(j);
      Inc(j);
      While (j <= High(input)) and flag do
      begin
        if input[j] = letter then
          flag := false;
        Inc(j);
      end;
      if not flag then
        answ := answ + letter;
    end;

  end;
  for var i := Low(vowels) to High(vowels) do
  begin
    if  answ.Contains(vowels[i]) then
      Write(vowels[i]);
  end;
  Writeln;
  Writeln(input);
  Readln;

end.

