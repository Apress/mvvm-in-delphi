unit InvoiceForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ExtCtrls, System.Rtti, FMX.Grid,
  FMX.Layouts, FMX.Objects, FMX.Edit, FMX.ListBox,
  System.Generics.Collections, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Menus;

type
  TSalesInvoiceForm = class(TForm)
    LabelCustomer: TLabel;
    PopupBoxCustomer: TPopupBox;
    GroupBoxCustomerDetails: TGroupBox;
    LabelDiscountRate: TLabel;
    LabelDiscountRateFigure: TLabel;
    LabelTotalBalanceBig: TLabel;
    LabelOutstandingBalance: TLabel;
    LabelInvoiceBalance: TLabel;
    GroupBoxInvoiceItems: TGroupBox;
    PopupBoxItems: TPopupBox;
    LabelItem: TLabel;
    GroupBoxBalance: TGroupBox;
    LabelRunningBalance: TLabel;
    LabelInvBalance: TLabel;
    CheckBoxDiscount: TCheckBox;
    LabelDiscount: TLabel;
    LineHorizontal: TLine;
    LabelTotalBalance: TLabel;
    ButtonCancel: TButton;
    ButtonPrintInvoice: TButton;
    LabelQuantity: TLabel;
    EditQuantity: TEdit;
    ButtonAddItem: TButton;
    StringGridItems: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    LabelTotal: TLabel;
    AniIndicatorProgress: TAniIndicator;
    LabelPrinting: TLabel;
    LabelTitle: TLabel;
    PopupMenuItems: TPopupMenu;
    MenuItemDeleteItem: TMenuItem;
    StringColumn5: TStringColumn;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
