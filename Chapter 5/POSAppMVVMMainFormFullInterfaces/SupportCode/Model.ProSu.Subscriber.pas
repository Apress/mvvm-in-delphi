unit Model.ProSu.Subscriber;

interface

uses Model.ProSu.Interfaces;

function CreateProSuSubscriberClass: ISubscriberInterface;

implementation

type
  TProSuSubscriber = class (TInterfacedObject, ISubscriberInterface)
  private
    fUpdateMethod: TUpdateSubscriberMethod;
  public
    procedure UpdateSubscriber (const notifyClass: INotificationClass);
    procedure SetUpdateSubscriberMethod (newMethod: TUpdateSubscriberMethod);
  end;

{ TProSuSubscriber }

procedure TProSuSubscriber.SetUpdateSubscriberMethod(
  newMethod: TUpdateSubscriberMethod);
begin
  fUpdateMethod:=newMethod;
end;

procedure TProSuSubscriber.UpdateSubscriber(const notifyClass: INotificationClass);
begin
  if Assigned(fUpdateMethod) then
    fUpdateMethod(notifyClass);
end;

function CreateProSuSubscriberClass: ISubscriberInterface;
begin
  result:=TProSuSubscriber.Create;
end;

end.
