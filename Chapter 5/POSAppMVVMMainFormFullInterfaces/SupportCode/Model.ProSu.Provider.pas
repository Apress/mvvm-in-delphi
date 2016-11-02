unit Model.ProSu.Provider;

interface

uses Model.ProSu.Interfaces, System.Generics.Collections;

function CreateProSuProviderClass: IProviderInterface;

implementation

type
 TProSuProvider = class (TInterfacedObject, IProviderInterface)
  private
    fSubscriberList: TList<ISubscriberInterface>;
  public
    procedure Subscribe(const tmpSubscriber: ISubscriberInterface);
    procedure Unsubscribe(const tmpSubscriber: ISubscriberInterface);
    procedure NotifySubscribers (const notifyClass: INotificationClass);

    constructor Create;
    destructor Destroy; override;
  end;

{ TProSuProvider }

constructor TProSuProvider.Create;
begin
  inherited;
  fSubscriberList:=TList<ISubscriberInterface>.Create;
end;

destructor TProSuProvider.Destroy;
var
  iTemp: ISubscriberInterface;
begin
  for itemp in fSubscriberList do
      Unsubscribe(iTemp);
  fSubscriberList.Free;
  inherited;
end;

procedure TProSuProvider.NotifySubscribers(const notifyClass: INotificationClass);
var
  tmpSubscriber: ISubscriberInterface;
begin
  for tmpSubscriber in fSubscriberList  do
    tmpSubscriber.UpdateSubscriber(notifyClass);
end;

procedure TProSuProvider.Subscribe(const tmpSubscriber: ISubscriberInterface);
begin
  fSubscriberList.Add(tmpSubscriber);
end;

procedure TProSuProvider.Unsubscribe(const tmpSubscriber: ISubscriberInterface);
begin
  fSubscriberList.Remove(tmpSubscriber);
end;

function CreateProSuProviderClass: IProviderInterface;
begin
  result:=TProSuProvider.Create;
end;

end.
