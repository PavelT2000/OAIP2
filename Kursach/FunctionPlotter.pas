    unit FunctionPlotter;

interface

uses
  SysUtils, Math, Graphics, Classes;


procedure DrawFunctionGraph(Canvas: TCanvas; Width, Height: Integer;
  FuncText: string; scale: Double);

implementation

type
  TTokenType = (ttNumber, ttVariable, ttOperator, ttFunction, ttLeftParen, ttRightParen);
  TAssociativity = (aLeft, aRight);

  TToken = record
    Value: string;
    TokenType: TTokenType;
    Priority: Integer;
    Associativity: TAssociativity;
  end;

const
  Operators = '+-*/^';
  Functions = 'sincostanloglnexpsqrtarcsinarccosarctanabs';

function IsNumber(C: Char): Boolean;
begin
  Result := CharInSet(C, ['0'..'9', '.']);
end;

function IsLetter(C: Char): Boolean;
begin
  Result := CharInSet(C, ['a'..'z', 'A'..'Z']);
end;

function Tokenize(const Expr: string): TArray<TToken>;
var
  I: Integer;
  Token: TToken;
  NumStr: string;
  FuncStr: string;
begin
  SetLength(Result, 0);
  I := 1;

  while I <= Length(Expr) do
  begin
    // Пропускаем пробелы
    if Expr[I] = ' ' then
    begin
      Inc(I);
      Continue;
    end;

    // Числа
    if IsNumber(Expr[I]) then
    begin
      NumStr := '';
      while (I <= Length(Expr)) and IsNumber(Expr[I]) do
      begin
        NumStr := NumStr + Expr[I];
        Inc(I);
      end;

      Token.Value := NumStr;
      Token.TokenType := ttNumber;
      Insert(Token, Result, Length(Result));
      Continue;
    end;

    // Переменные (только x)
    if LowerCase(Expr[I]) = 'x' then
    begin
      Token.Value := 'x';
      Token.TokenType := ttVariable;
      Insert(Token, Result, Length(Result));
      Inc(I);
      Continue;
    end;

    // Функции (sin, cos, tan и т.д.)
    if IsLetter(Expr[I]) then
    begin
      FuncStr := '';
      while (I <= Length(Expr)) and IsLetter(Expr[I]) do
      begin
        FuncStr := FuncStr + LowerCase(Expr[I]);
        Inc(I);
      end;

      if Pos(FuncStr, Functions) > 0 then
      begin
        Token.Value := FuncStr;
        Token.TokenType := ttFunction;
        Insert(Token, Result, Length(Result));
        Continue;
      end
      else
        raise Exception.Create('Unknown function: ' + FuncStr);
    end;

    // Операторы
    if Pos(Expr[I], Operators) > 0 then
    begin
      Token.Value := Expr[I];
      Token.TokenType := ttOperator;

      case Expr[I] of
        '+', '-': Token.Priority := 2;
        '*', '/': Token.Priority := 3;
        '^': begin
               Token.Priority := 4;
               Token.Associativity := aRight;
             end;
      end;

      Insert(Token, Result, Length(Result));
      Inc(I);
      Continue;
    end;

    // Скобки
    if Expr[I] = '(' then
    begin
      Token.Value := '(';
      Token.TokenType := ttLeftParen;
      Insert(Token, Result, Length(Result));
      Inc(I);
      Continue;
    end;

    if Expr[I] = ')' then
    begin
      Token.Value := ')';
      Token.TokenType := ttRightParen;
      Insert(Token, Result, Length(Result));
      Inc(I);
      Continue;
    end;

    raise Exception.CreateFmt('Unknown character: %s', [Expr[I]]);
  end;
end;

function ShuntingYard(Tokens: TArray<TToken>): TArray<TToken>;
var
  Output: TArray<TToken>;
  Stack: TArray<TToken>;
  Token: TToken;
begin
  SetLength(Output, 0);
  SetLength(Stack, 0);

  for Token in Tokens do
  begin
    case Token.TokenType of
      ttNumber, ttVariable:
        Insert(Token, Output, Length(Output));

      ttFunction:
        Insert(Token, Stack, Length(Stack));

      ttOperator:
      begin
        while (Length(Stack) > 0) and
              (Stack[High(Stack)].TokenType = ttOperator) and
              ((Token.Associativity = aLeft) and (Token.Priority <= Stack[High(Stack)].Priority) or
               (Token.Associativity = aRight) and (Token.Priority < Stack[High(Stack)].Priority)) do
        begin
          Insert(Stack[High(Stack)], Output, Length(Output));
          SetLength(Stack, Length(Stack) - 1);
        end;
        Insert(Token, Stack, Length(Stack));
      end;

      ttLeftParen:
        Insert(Token, Stack, Length(Stack));

      ttRightParen:
      begin
        while (Length(Stack) > 0) and (Stack[High(Stack)].TokenType <> ttLeftParen) do
        begin
          Insert(Stack[High(Stack)], Output, Length(Output));
          SetLength(Stack, Length(Stack) - 1);
        end;

        if Length(Stack) = 0 then
          raise Exception.Create('Mismatched parentheses');

        SetLength(Stack, Length(Stack) - 1); // Удаляем '('

        if (Length(Stack) > 0) and (Stack[High(Stack)].TokenType = ttFunction) then
        begin
          Insert(Stack[High(Stack)], Output, Length(Output));
          SetLength(Stack, Length(Stack) - 1);
        end;
      end;
    end;
  end;

  while Length(Stack) > 0 do
  begin
    if Stack[High(Stack)].TokenType in [ttLeftParen, ttRightParen] then
      raise Exception.Create('Mismatched parentheses');

    Insert(Stack[High(Stack)], Output, Length(Output));
    SetLength(Stack, Length(Stack) - 1);
  end;

  Result := Output;
end;

function EvaluateRPN(RPN: TArray<TToken>; X: Double): Double;
var
  Stack: TArray<Double>;
  Token: TToken;
  A, B: Double;
begin
  SetLength(Stack, 0);

  for Token in RPN do
  begin
    case Token.TokenType of
      ttNumber:
      begin
        SetLength(Stack, Length(Stack) + 1);
        Stack[High(Stack)] := StrToFloat(Token.Value);
      end;

      ttVariable:
      begin
        SetLength(Stack, Length(Stack) + 1);
        Stack[High(Stack)] := X;
      end;

      ttOperator:
      begin
        if Length(Stack) < 2 then
          raise Exception.Create('Invalid expression');

        B := Stack[High(Stack)];
        SetLength(Stack, Length(Stack) - 1);
        A := Stack[High(Stack)];
        SetLength(Stack, Length(Stack) - 1);

        case Token.Value[1] of
          '+': A := A + B;
          '-': A := A - B;
          '*': A := A * B;
          '/': A := A / B;
          '^': A := Power(A, B);
        end;

        SetLength(Stack, Length(Stack) + 1);
        Stack[High(Stack)] := A;
      end;

      ttFunction:
      begin
        if Length(Stack) < 1 then
          raise Exception.Create('Invalid expression');

        A := Stack[High(Stack)];
        SetLength(Stack, Length(Stack) - 1);

        if Token.Value = 'sin' then A := Sin(A)
        else if Token.Value = 'cos' then A := Cos(A)
        else if Token.Value = 'tan' then A := Tan(A)
        else if Token.Value = 'log' then A := Log10(A)
        else if Token.Value = 'ln' then A := Ln(A)
        else if Token.Value = 'exp' then A := Exp(A)
        else if Token.Value = 'sqrt' then A := Sqrt(A)
        else if Token.Value = 'arcsin' then A := ArcSin(A)
        else if Token.Value = 'arccos' then A := ArcCos(A)
        else if Token.Value = 'arctan' then A := ArcTan(A)
        else if Token.Value = 'abs' then A := Abs(A);

        SetLength(Stack, Length(Stack) + 1);
        Stack[High(Stack)] := A;
      end;
    end;
  end;

  if Length(Stack) <> 1 then
    raise Exception.Create('Invalid expression');

  Result := Stack[0];
end;

function EvaluateFunction(const Expr: string; X: Double): Double;
var
  Tokens: TArray<TToken>;
  RPN: TArray<TToken>;
begin
  Tokens := Tokenize(Expr);
  RPN := ShuntingYard(Tokens);
  Result := EvaluateRPN(RPN, X);
end;

procedure DrawFunctionGraph(Canvas: TCanvas; Width, Height: Integer;
  FuncText: string; scale: Double);
const
  POINTS_COUNT = 1000;
var
  I: Integer;
  X, Y: Double;
  Px, Py: Integer;
  PrevValid: Boolean;
  XMin, XMax, YMin, YMax: Double;


  function WorldToScreenX(X: Double): Int64;
  begin
    Result := Round((X - XMin) / (XMax - XMin) * Width);
  end;

  function WorldToScreenY(Y: Double): Int64;
  begin
    Result := Round(Height - (Y - YMin) / (YMax - YMin) * Height);
  end;

begin
  XMin:=-(Width/2)/Scale;
  XMax:=-XMin;
  YMin:=-(Height/2)/Scale;
  YMax:=-Ymin;
  // Очищаем область рисования
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(Rect(0, 0, Width, Height));

  // Рисуем оси координат
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Width := 1;

  // Ось X
  Py := WorldToScreenY(0);
  if (Py >= 0) and (Py <= Height) then
  begin
    Canvas.MoveTo(0, Py);
    Canvas.LineTo(Width, Py);
  end;

  // Ось Y
  Px := WorldToScreenX(0);
  if (Px >= 0) and (Px <= Width) then
  begin
    Canvas.MoveTo(Px, 0);
    Canvas.LineTo(Px, Height);
  end;

  // Рисуем график функции
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 2;

  PrevValid := False;

  for I := 0 to POINTS_COUNT do
  begin
    X := XMin + (XMax - XMin) * I / POINTS_COUNT;
    try
      Y := EvaluateFunction(FuncText, X);
      if not IsNaN(Y) and not IsInfinite(Y) then
      begin
        Px := WorldToScreenX(X);
        Py := WorldToScreenY(Y);

        if (Py >= -1000) and (Py <= Height + 1000) then
        begin
          if PrevValid then
            Canvas.LineTo(Px, Py)
          else
            Canvas.MoveTo(Px, Py);
          PrevValid := True;
        end
        else
          PrevValid := False;
      end
      else
        PrevValid := False;
    except
      PrevValid := False;
    end;
  end;
end;

end.
