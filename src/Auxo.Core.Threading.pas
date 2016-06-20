unit Auxo.Core.Threading;

interface

uses
  System.Classes, System.SysUtils;

type
  TThreadContext = class(TThread)
  private
    FProc: TProc;
    FContext: IInterface;
  protected
    procedure Execute; override;
  public
    constructor Create(const AProc: TProc; AContext: IInterface);
    class function Run(Context: IInterface; AProc: TProc): TThreadContext;
  end;

implementation

{ TThreadContext }

constructor TThreadContext.Create(const AProc: TProc; AContext: IInterface);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FProc := AProc;
  FContext := AContext;
end;

procedure TThreadContext.Execute;
begin
  inherited;
  FProc();
end;

class function TThreadContext.Run(Context: IInterface; AProc: TProc): TThreadContext;
begin
  Result := TThreadContext.Create(AProc, Context);
  Result.Start;
end;

end.
