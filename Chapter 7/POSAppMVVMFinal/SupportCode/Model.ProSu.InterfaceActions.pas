unit Model.ProSu.InterfaceActions;

interface

type
  TInterfaceAction = (actUpdateTotalSalesFigure, actInvoiceItemsChanges,
                      actPrintingStart, actPrintingFinish);
  TInterfaceError = (errInvoiceItemEmpty, errInvoiceItemQuantityEmpty,
                      errInvoiceItemQuantityNonPositive,
                      errInvoiceItemQuantityNotNumber, errNoError);
  TInterfaceActions = set of TInterfaceAction;
  TInterfaceErrors = set of TInterfaceError;

implementation

end.
