program PedidoVenda;

uses
  Vcl.Forms,
  UFrmPedido in 'src\View\UFrmPedido.pas' {FrmPedido},
  UConnection in 'src\Common\UConnection.pas',
  UCliente.Model in 'src\Model\UCliente.Model.pas',
  UProduto.Model in 'src\Model\UProduto.Model.pas',
  UPedido.Model in 'src\Model\UPedido.Model.pas',
  UPedidoItem.Model in 'src\Model\UPedidoItem.Model.pas',
  UBase.Repository in 'src\Repository\UBase.Repository.pas',
  UCliente.Repository in 'src\Repository\UCliente.Repository.pas',
  UProduto.Repository in 'src\Repository\UProduto.Repository.pas',
  UPedido.Repository in 'src\Repository\UPedido.Repository.pas',
  UPedido.Service in 'src\Service\UPedido.Service.pas',
  UPedido.Controller in 'src\Controller\UPedido.Controller.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPedido, FrmPedido);
  Application.Run;
end.
