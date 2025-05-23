unit MathEpressionEvaluator;

interface

uses
  SysUtils, Classes, Math, Graphics, System.Types;

type
  TMathExpressionEvaluator = class
  private
    FExpression: string;
    FVariables: array of record
      Name: string;
      Value: Double;
    end;
    FError: Boolean;
    FErrorMessage: string;

    function Evaluate(const Expr: string): Double;
    function EvaluateInternal(var Expr: PChar): Double;
    function GetVariable(const Name: string): Double;
    procedure SetVariable(const Name: string; const Value: Double);
    function IsFunction(const Name: string): Boolean;
    function EvaluateFunction(const Name: string; Arg: Double): Double;
  public
    constructor Create;
    function Calculate(const Expr: string): Double;
    procedure PlotFunction(Canvas: TCanvas; Width, Height: Integer;
                          const Expr: string; XMin, XMax: Double;
                          Step: Double = 0.1);

    property Error: Boolean read FError;
    property ErrorMessage: string read FErrorMessage;
  end;

implementation

constructor TMathExpressionEvaluator.Create;
begin
  FError := False;
  FErrorMessage := '';
  SetLength(FVariables, 0);

  // ��������� ����������� ���������
  SetVariable('pi', Pi);
  SetVariable('e', Exp(1));
  SetVariable('rad', 180/Pi); // ��� �������������� �������� � �������
end;

function TMathExpressionEvaluator.Calculate(const Expr: string): Double;
begin
  FExpression := Expr;
  FError := False;
  FErrorMessage := '';

  try
    Result := Evaluate(FExpression);
  except
    on E: Exception do
    begin
      FError := True;
      FErrorMessage := E.Message;
      Result := 0;
    end;
  end;
end;

function TMathExpressionEvaluator.Evaluate(const Expr: string): Double;
var
  P: PChar;
begin
  P := PChar(Expr);
  Result := EvaluateInternal(P);
end;

function TMathExpressionEvaluator.EvaluateInternal(var Expr: PChar): Double;
var
  Value: Double;
  Token: Char;
  Negative: Boolean;
  Name: string;

  procedure GetNextToken;
  begin
    repeat
      Token := Expr^;
      Inc(Expr);
    until (Token <> ' ') or (Expr^ = #0);
  end;

  function GetNumber: Double;
  var
    FoundDot: Boolean;
    Scale: Double;
  begin
    FoundDot := False;
    Scale := 1;
    Result := 0;

    while True do
    begin
      case Token of
        '0'..'9':
          begin
            if FoundDot then
            begin
              Scale := Scale * 0.1;
              Result := Result + (Ord(Token) - Ord('0')) * Scale;
            end
            else
              Result := Result * 10 + (Ord(Token) - Ord('0'));
            GetNextToken;
          end;
        '.':
          begin
            if FoundDot then
              raise Exception.Create('Invalid number format');
            FoundDot := True;
            GetNextToken;
          end;
        else
          Break;
      end;
    end;
  end;

  function GetIdentifier: string;
  begin
    Result := '';
    while Token in ['a'..'z', 'A'..'Z', '0'..'9', '_'] do
    begin
      Result := Result + Token;
      GetNextToken;
    end;
  end;

  function Factor: Double;
  var
    FuncName: string;
    Arg: Double;
  begin
    if Token = '(' then
    begin
      GetNextToken;
      Result := EvaluateInternal(Expr);
      if Token <> ')' then
        raise Exception.Create('Missing closing parenthesis');
      GetNextToken;
    end
    else if Token = '+' then
    begin
      GetNextToken;
      Result := Factor;
    end
    else if Token = '-' then
    begin
      GetNextToken;
      Result := -Factor;
    end
    else if Token in ['0'..'9', '.'] then
    begin
      Result := GetNumber;
    end
    else if Token in ['a'..'z', 'A'..'Z', '_'] then
    begin
      FuncName := GetIdentifier;
      if Token = '(' then // ��� �������
      begin
        GetNextToken;
        Arg := EvaluateInternal(Expr);
        if Token <> ')' then
          raise Exception.Create('Missing closing parenthesis for function argument');
        GetNextToken;
        Result := EvaluateFunction(FuncName, Arg);
      end
      else // ��� ����������
      begin
        Result := GetVariable(FuncName);
      end;
    end
    else
      raise Exception.Create('Unexpected token: ' + Token);
  end;

  function Term: Double;
  var
    Op: Char;
  begin
    Result := Factor;
    while Token in ['*', '/'] do
    begin
      Op := Token;
      GetNextToken;
      case Op of
        '*': Result := Result * Factor;
        '/': Result := Result / Factor;
      end;
    end;
  end;

begin
  GetNextToken;
  Negative := False;

  if Token = '-' then
  begin
    Negative := True;
    GetNextToken;
  end;

  Result := Term;

  if Negative then
    Result := -Result;

  while Token in ['+', '-'] do
  begin
    case Token of
      '+':
        begin
          GetNextToken;
          Result := Result + Term;
        end;
      '-':
        begin
          GetNextToken;
          Result := Result - Term;
        end;
    end;
  end;

  if Token <> #0 then
    raise Exception.Create('Unexpected token: ' + Token);
end;

function TMathExpressionEvaluator.GetVariable(const Name: string): Double;
var
  I: Integer;
begin
  for I := 0 to High(FVariables) do
    if CompareText(FVariables[I].Name, Name) = 0 then
    begin
      Result := FVariables[I].Value;
      Exit;
    end;

  raise Exception.Create('Unknown variable: ' + Name);
end;

procedure TMathExpressionEvaluator.SetVariable(const Name: string; const Value: Double);
var
  I: Integer;
begin
  for I := 0 to High(FVariables) do
    if CompareText(FVariables[I].Name, Name) = 0 then
    begin
      FVariables[I].Value := Value;
      Exit;
    end;

  SetLength(FVariables, Length(FVariables) + 1);
  FVariables[High(FVariables)].Name := Name;
  FVariables[High(FVariables)].Value := Value;
end;

function TMathExpressionEvaluator.IsFunction(const Name: string): Boolean;
begin
  Result := True;
  if CompareText(Name, 'sin') = 0 then Exit;
  if CompareText(Name, 'cos') = 0 then Exit;
  if CompareText(Name, 'tan') = 0 then Exit;
  if CompareText(Name, 'cotan') = 0 then Exit;
  if CompareText(Name, 'arcsin') = 0 then Exit;
  if CompareText(Name, 'arccos') = 0 then Exit;
  if CompareText(Name, 'arctan') = 0 then Exit;
  if CompareText(Name, 'sinh') = 0 then Exit;
  if CompareText(Name, 'cosh') = 0 then Exit;
  if CompareText(Name, 'tanh') = 0 then Exit;
  if CompareText(Name, 'ln') = 0 then Exit;
  if CompareText(Name, 'log') = 0 then Exit;
  if CompareText(Name, 'exp') = 0 then Exit;
  if CompareText(Name, 'sqrt') = 0 then Exit;
  if CompareText(Name, 'abs') = 0 then Exit;
  if CompareText(Name, 'sign') = 0 then Exit;
  if CompareText(Name, 'floor') = 0 then Exit;
  if CompareText(Name, 'ceil') = 0 then Exit;
  if CompareText(Name, 'round') = 0 then Exit;
  if CompareText(Name, 'trunc') = 0 then Exit;
  if CompareText(Name, 'frac') = 0 then Exit;

  Result := False;
end;

function TMathExpressionEvaluator.EvaluateFunction(const Name: string; Arg: Double): Double;
begin
  if CompareText(Name, 'sin') = 0 then Result := Sin(Arg)
  else if CompareText(Name, 'cos') = 0 then Result := Cos(Arg)
  else if CompareText(Name, 'tan') = 0 then Result := Tan(Arg)
  else if CompareText(Name, 'cotan') = 0 then Result := Cotan(Arg)
  else if CompareText(Name, 'arcsin') = 0 then Result := ArcSin(Arg)
  else if CompareText(Name, 'arccos') = 0 then Result := ArcCos(Arg)
  else if CompareText(Name, 'arctan') = 0 then Result := ArcTan(Arg)
  else if CompareText(Name, 'sinh') = 0 then Result := Sinh(Arg)
  else if CompareText(Name, 'cosh') = 0 then Result := Cosh(Arg)
  else if CompareText(Name, 'tanh') = 0 then Result := Tanh(Arg)
  else if CompareText(Name, 'ln') = 0 then Result := Ln(Arg)
  else if CompareText(Name, 'log') = 0 then Result := Log10(Arg)
  else if CompareText(Name, 'exp') = 0 then Result := Exp(Arg)
  else if CompareText(Name, 'sqrt') = 0 then Result := Sqrt(Arg)
  else if CompareText(Name, 'abs') = 0 then Result := Abs(Arg)
  else if CompareText(Name, 'sign') = 0 then Result := Sign(Arg)
  else if CompareText(Name, 'floor') = 0 then Result := Floor(Arg)
  else if CompareText(Name, 'ceil') = 0 then Result := Ceil(Arg)
  else if CompareText(Name, 'round') = 0 then Result := Round(Arg)
  else if CompareText(Name, 'trunc') = 0 then Result := Trunc(Arg)
  else if CompareText(Name, 'frac') = 0 then Result := Frac(Arg)
  else
    raise Exception.Create('Unknown function: ' + Name);
end;

procedure TMathExpressionEvaluator.PlotFunction(Canvas: TCanvas; Width, Height: Integer;
  const Expr: string; XMin, XMax: Double; Step: Double = 0.1);
var
  X, Y: Double;
  PrevX, PrevY: Integer;
  CurrX, CurrY: Integer;
  YMin, YMax: Double;
  ScaleX, ScaleY: Double;
  I: Integer;
  Points: array of TPoint;
  PointCount: Integer;
  TempY: Double;
begin
  // ������� ������ �������� Y
  YMin := MaxDouble;
  YMax := -MaxDouble;
  X := XMin;

  while X <= XMax do
  begin
    try
      SetVariable('x', X);
      Y := Calculate(Expr);

      if not FError then
      begin
        if Y < YMin then YMin := Y;
        if Y > YMax then YMax := Y;
      end;
    except
      // ���������� �����, ��� ������� �� ����������
    end;

    X := X + Step;
  end;

  // ���� ��� Y ����������, ������� �������� ��������
  if Abs(YMax - YMin) < 1E-10 then
  begin
    YMin := YMin - 1;
    YMax := YMax + 1;
  end;

  // ������������ �������
  ScaleX := Width / (XMax - XMin);
  ScaleY := Height / (YMax - YMin);

  // �������� ����� ��� �������
  SetLength(Points, Trunc((XMax - XMin) / Step) + 2);
  PointCount := 0;
  X := XMin;

  while X <= XMax do
  begin
    try
      SetVariable('x', X);
      Y := Calculate(Expr);

      if not FError then
      begin
        CurrX := Round((X - XMin) * ScaleX);
        // ����������� Y, ��� ��� � Canvas Y ������ ������ ����
        CurrY := Height - Round((Y - YMin) * ScaleY);

        if PointCount = 0 then
        begin
          Points[PointCount] := Point(CurrX, CurrY);
          Inc(PointCount);
        end
        else
        begin
          // ��������� �� ������� ������� (���� ������ ������� �������)
          if Abs(CurrY - Points[PointCount-1].Y) < Height * 2 then
          begin
            Points[PointCount] := Point(CurrX, CurrY);
            Inc(PointCount);
          end
          else
          begin
            // ������ ������� ����� �������
            if PointCount > 1 then
//              Canvas.Polyline(Slice(Points`, PointCount));
            PointCount := 0;
          end;
        end;
      end;
    except
      // ���� ������, ������ ������� ����� ������� � �������� �����
      if PointCount > 1 then
//        Canvas.Polyline(Slice(Points, PointCount));
      PointCount := 0;
    end;

    X := X + Step;
  end;

  // ������ ���������� �����
  if PointCount > 1 then
//    Canvas.Polyline(Slice(Points, PointCount));
end;

end.
