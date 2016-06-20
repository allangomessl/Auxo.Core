unit Auxo.Core.DependencyInjection;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  TServiceLife = (Singleton, Transient);

  IContainer = interface
  end;

  TContainer<T: IInterface> = class(TInterfacedObject, IContainer)
  private
    FContext: TServiceLife;
    Ctor: TFunc<T>;
    Obj: T;
  public
    constructor Create(ACtor: TFunc<T>; AContext: TServiceLife);
    function Invoke: T;
  end;

  TAuxoServices = class
  strict private
    class var Factories: TDictionary<Pointer, IContainer>;
  public
    class procedure AddSingleton<I: IInterface>(Factory: TFunc<I>);
    class procedure AddTransient<I: IInterface>(Factory: TFunc<I>);
    class function GetService<I: IInterface>: I;
    class constructor Create;
    class destructor Destroy;
  end;

implementation

uses
  System.Rtti;

{ TAuxoServices }

class procedure TAuxoServices.AddSingleton<I>(Factory: TFunc<I>);
var
  container: IContainer;
begin
  container := TContainer<I>.Create(Factory, Singleton);
  Factories.Add(TypeInfo(I), container);
end;

class procedure TAuxoServices.AddTransient<I>(Factory: TFunc<I>);
var
  container: IContainer;
begin
  container := TContainer<I>.Create(Factory, Transient);
  Factories.Add(TypeInfo(I), container);
end;

class constructor TAuxoServices.Create;
begin
  Factories := TDictionary<Pointer, IContainer>.Create;
end;

class destructor TAuxoServices.Destroy;
begin
  Factories.Free;
end;

class function TAuxoServices.GetService<I>: I;
var
  Container: IContainer;
begin
  if Factories.TryGetValue(typeinfo(I), Container) then
    Result := (Container as TContainer<I>).Invoke
end;

{ TContainer<T> }

constructor TContainer<T>.Create(ACtor: TFunc<T>; AContext: TServiceLife);
begin
  Ctor := ACtor;
  FContext := AContext;
end;

function TContainer<T>.Invoke: T;
begin
  if (FContext = Singleton) then
  begin
    if not Assigned(Obj) then
      Obj := Ctor;
    Exit(Obj);
  end
  else
    Exit(Ctor);
end;

end.
