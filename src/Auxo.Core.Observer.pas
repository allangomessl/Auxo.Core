unit Auxo.Core.Observer;

interface

uses
  System.Generics.Collections;

type
  IObserver = interface;
  ISubject = interface;

  TObserver = class
    Action: TGUID;
    Observer: IObserver;
  end;

  TObservers = class(TList<TObserver>)
  private
    function GetItems(Action: TGUID): TArray<IObserver>; overload;
  public
    property Items[Action: TGUID]: TArray<IObserver> read GetItems; default;
    procedure Register(Observer: IObserver; Actions: array of TGUID);
    procedure Unregister(Observer: IObserver);
    procedure Notify(Subject: ISubject; Action: TGUID); reintroduce;
  end;

  ISubject = interface
    procedure Notify(Action: TGUID);
    procedure RegisterObserver(Observer: IObserver; Actions: array of TGUID);
    procedure UnregisterObserver(Observer: IObserver);
  end;

  IObserver = interface
    procedure Notify(Subject: ISubject; Action: TGUID);
  end;


implementation

{ TObservers }

function TObservers.GetItems(Action: TGUID): TArray<IObserver>;
var
  I: Integer;
  Item: TObserver;
begin
  I := -1;
  SetLength(Result, Count);
  for Item in Self do
  begin
    if Item.Action = Action then
    begin
      Inc(I);
      Result[I] := Item.Observer;
    end;
  end;
  SetLength(Result, I + 1);
end;

procedure TObservers.Notify(Subject: ISubject; Action: TGUID);
var
  Item: IObserver;
begin
  for Item in GetItems(Action) do
    Item.Notify(Subject, Action);
end;

procedure TObservers.Register(Observer: IObserver; Actions: array of TGUID);
var
  Action: TGUID;
  Item: TObserver;
begin
  for Action in Actions do
  begin
    Item := TObserver.Create;
    Item.Action := Action;
    Item.Observer := Observer;
    Add(Item);
  end;
end;

procedure TObservers.Unregister(Observer: IObserver);
var
  I: Integer;
begin
  for I := Count-1 downto 0 do
  begin
    if Items[I].Observer = Observer then
      Delete(I);
  end;
end;

end.
