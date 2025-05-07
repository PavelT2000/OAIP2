program Testing;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  windows;

begin
  WinExec('cmd.exe /c MainUpozn.exe < test.txt > output.txt', SW_HIDE);

end.
