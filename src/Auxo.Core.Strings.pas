unit Auxo.Core.Strings;

interface

type
  Strings = record
  private
    FArray: TArray<string>;
  public
    constructor Create(Value: string; Delimiter: string);
    class operator Implicit(Value: Strings): TArray<string>;
  end;

implementation

uses
  System.StrUtils, System.Types;

{ Strings }

constructor Strings.Create(Value, Delimiter: string);
var
  Arr: TStringDynArray;
  I: Integer;
begin
  Arr := SplitString(Value, Delimiter);
  SetLength(FArray, Length(Arr));
  for I := Low(Arr) to High(Arr) do
    FArray[I] := Arr[I];
end;

class operator Strings.Implicit(Value: Strings): TArray<string>;
begin
  Result := Value.FArray;
end;

end.
