unit Auxo.Core.Message;

interface

type
  IMessage = interface
    procedure Warning(AMessage: string; ATitle: string = ''); overload;
    procedure Error(AMessage: string; ATitle: string = ''); overload;
    procedure Information(AMessage: string; ATitle: string = ''); overload;
    function Confirm(AMessage: string; ATitle: string = ''): Boolean;
  end;

implementation

end.
