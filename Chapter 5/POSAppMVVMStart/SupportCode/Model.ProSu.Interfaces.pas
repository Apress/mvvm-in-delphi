unit Model.ProSu.Interfaces;

interface

type
  INotificationClass = interface
    ['{2BB04DBB-6D61-4E4F-8C70-8BCC8E36FDE4}']
  end;

  TUpdateSubscriberMethod = procedure (const notifyClass: INotificationClass) of object;

  ISubscriberInterface = interface
    ['{955BF992-F4FA-4141-9C0F-04600C582C00}']
    procedure UpdateSubscriber (const notifyClass: INotificationClass);
    procedure SetUpdateSubscriberMethod (newMethod: TUpdateSubscriberMethod);
  end;

  IProviderInterface = interface
    ['{DD326AE1-5049-43AA-9215-DF53DB5FC958}']
    procedure Subscribe(const tmpSubscriber: ISubscriberInterface);
    procedure Unsubscribe(const tmpSubscriber: ISubscriberInterface);
    procedure NotifySubscribers (const notifyClass: INotificationClass);
  end;

  IProSuSubscriberInterface = interface
    ['{EAB93732-9319-49A0-B2A9-9F8A3698E09F}']
    procedure UpdateSubscriber (const notifyClass: INotificationClass);
    procedure SetUpdateSubscriberMethod (newMethod: TUpdateSubscriberMethod);
  end;

  IProSuProviderInterface = interface
    ['{1CCA23CC-13D4-4130-BF02-AD12FB3EBADA}']
    procedure Subscribe(const tmpSubscriber: ISubscriberInterface);
    procedure Unsubscribe(const tmpSubscriber: ISubscriberInterface);
    procedure NotifySubscribers (const notifyClass: INotificationClass);
  end;

implementation

end.
