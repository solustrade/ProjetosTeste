﻿unit UPedido.Repository;

interface

uses
  UBase.Repository, UPedido.Model, UPedidoItem.Model, FireDAC.Comp.Client,
  System.SysUtils, Data.DB;

type
  TPedidoRepository = class(TBaseRepository)
  public
    function Salvar(APedido: TPedido): Integer;
  end;

implementation

{ TPedidoRepository }

function TPedidoRepository.Salvar(APedido: TPedido): Integer;
var
  LQuery: TFDQuery;
  LItem: TPedidoItem;
begin
  LQuery := CreateQuery;
  try
    // Inserir Cabeçalho
    LQuery.SQL.Text :=
      'INSERT INTO PEDIDO (CODIGO_CLIENTE, DATA_EMISSAO, VALOR_TOTAL, OBSERVACAO) ' +
      'VALUES (:CODIGO_CLIENTE, :DATA_EMISSAO, :VALOR_TOTAL, :OBSERVACAO) ' +
      'RETURNING NUMERO_PEDIDO';

    LQuery.ParamByName('CODIGO_CLIENTE').AsInteger := APedido.CodigoCliente;
    LQuery.ParamByName('DATA_EMISSAO').AsDateTime := APedido.DataEmissao;
    LQuery.ParamByName('VALOR_TOTAL').AsFloat := APedido.ValorTotal;
    LQuery.ParamByName('OBSERVACAO').AsString := APedido.Observacao;
    LQuery.Open;

    Result := LQuery.FieldByName('NUMERO_PEDIDO').AsInteger;

    APedido.NumeroPedido := Result;

    LQuery.Close;

    // Inserir Itens
    LQuery.SQL.Clear;
    LQuery.SQL.Text :=
      'INSERT INTO PEDIDO_ITEM (NUMERO_PEDIDO, CODIGO_PRODUTO, QUANTIDADE, VLR_UNITARIO, VLR_TOTAL) ' +
      'VALUES (:NUMERO_PEDIDO, :CODIGO_PRODUTO, :QUANTIDADE, :VLR_UNITARIO, :VLR_TOTAL)';

    for LItem in APedido.Itens do
    begin
      LQuery.ParamByName('NUMERO_PEDIDO').AsInteger  := Result;
      LQuery.ParamByName('CODIGO_PRODUTO').AsInteger := LItem.CodigoProduto;
      LQuery.ParamByName('QUANTIDADE').AsFloat       := LItem.Quantidade;
      LQuery.ParamByName('VLR_UNITARIO').AsFloat     := LItem.ValorUnitario;
      LQuery.ParamByName('VLR_TOTAL').AsFloat        := LItem.ValorTotal;
      LQuery.ExecSQL;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
