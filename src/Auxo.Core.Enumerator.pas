unit Auxo.Core.Enumerator;

interface

uses
  System.Generics.Collections;

type
  TTypeEnumerator<T> = class(TInterfacedObject, IEnumerator<T>)
  private
    FList : TList<T>;
    FIndex : Integer;
  protected
    constructor Create(Owner : TList<T>); overload;

    function GetCurrent : TObject;
    function GetCurrentT : T;
    function MoveNext : Boolean;
    procedure Reset;


    function IEnumerator<T>.GetCurrent = GetCurrentT;
  end;

implementation

uses
  System.Rtti;

{ TTypeEnumerator<T> }

constructor TTypeEnumerator<T>.Create(Owner: TList<T>);
begin
  FList := Owner;
  FIndex := -1;
end;

function TTypeEnumerator<T>.GetCurrent: TObject;
begin
  Result := TValue.From<T>(FList[FIndex]).AsObject;
end;

function TTypeEnumerator<T>.GetCurrentT: T;
begin
  Result := FList[FIndex];
end;

function TTypeEnumerator<T>.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < FList.Count;
end;

procedure TTypeEnumerator<T>.Reset;
begin
  FIndex := -1;
end;

end.
