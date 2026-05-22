unit UPedido.Controller;

interface

uses
  UPedido.Service, UPedido.Model, UPedidoItem.Model, UCliente.Model,
  UProduto.Model, System.SysUtils, System.Generics.Collections;

type
  TPedidoController = class
  private
    FService: TPedidoService;
    FPedido: TPedido;
  public
    constructor Create;
    destructor Destroy; override;
    function GetCliente(ACodigo: Integer): TCliente;
    function GetProduto(ACodigo: Integer): TProduto;
    procedure AdicionarOuAtualizarItem(ACodigoProduto: Integer; ADescricao: string;
      AQuantidade, AValorUnitario: Double; AIndex: Integer = -1);
    procedure RemoverItem(AIndex: Integer);
    function SalvarPedido(ACodigoCliente: Integer; AObservacao: string): Integer;
    function GetPedido: TPedido;
    procedure NovoPedido;
    function CalcularTotalPedido: Double;
  end;

implementation

{ TPedidoController }

constructor TPedidoController.Create;
begin
  FService := TPedidoService.Create;
  FPedido  := TPedido.Create;
end;

destructor TPedidoController.Destroy;
begin
  FService.Free;
  FPedido.Free;
  inherited;
end;

function TPedidoController.GetCliente(ACodigo: Integer): TCliente;
begin
  Result := FService.GetCliente(ACodigo);
end;

function TPedidoController.GetProduto(ACodigo: Integer): TProduto;
begin
  Result := FService.GetProduto(ACodigo);
end;

procedure TPedidoController.AdicionarOuAtualizarItem(ACodigoProduto: Integer;
  ADescricao: string; AQuantidade, AValorUnitario: Double; AIndex: Integer);
var
  LItem: TPedidoItem;
begin
  if AIndex >= 0 then
    LItem := FPedido.Itens[AIndex]
  else
  begin
    LItem := TPedidoItem.Create;

    FPedido.Itens.Add(LItem);
  end;

  LItem.CodigoProduto    := ACodigoProduto;
  LItem.DescricaoProduto := ADescricao;
  LItem.Quantidade       := AQuantidade;
  LItem.ValorUnitario    := AValorUnitario;
  LItem.ValorTotal       := AQuantidade * AValorUnitario;

  FPedido.ValorTotal := CalcularTotalPedido;
end;

procedure TPedidoController.RemoverItem(AIndex: Integer);
begin
  if (AIndex >= 0) and (AIndex < FPedido.Itens.Count) then
  begin
    FPedido.Itens.Delete(AIndex);

    FPedido.ValorTotal := CalcularTotalPedido;
  end;
end;

function TPedidoController.SalvarPedido(ACodigoCliente: Integer; AObservacao: string): Integer;
begin
  FPedido.CodigoCliente := ACodigoCliente;
  FPedido.Observacao    := AObservacao;
  FPedido.ValorTotal    := CalcularTotalPedido;

  Result := FService.SalvarPedido(FPedido);
end;

function TPedidoController.GetPedido: TPedido;
begin
  Result := FPedido;
end;

procedure TPedidoController.NovoPedido;
begin
  FPedido.Free;

  FPedido := TPedido.Create;
end;

function TPedidoController.CalcularTotalPedido: Double;
var
  LItem: TPedidoItem;
begin
  Result := 0;
  for LItem in FPedido.Itens do
    Result := Result + LItem.ValorTotal;
end;

end.
