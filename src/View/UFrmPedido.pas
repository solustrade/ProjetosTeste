﻿unit UFrmPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, UPedido.Controller, UCliente.Model,
  UProduto.Model, UPedidoItem.Model;

type
  TFrmPedido = class(TForm)
    pnlClient: TPanel;
    lblCodCliente: TLabel;
    edtCodCliente: TEdit;
    lblNomeCliente: TLabel;
    edtNomeCliente: TEdit;
    lblCidadeCliente: TLabel;
    edtCidadeCliente: TEdit;
    lblUFCliente: TLabel;
    edtUFCliente: TEdit;
    pnlProduct: TPanel;
    lblCodProduto: TLabel;
    edtCodProduto: TEdit;
    lblDescProduto: TLabel;
    edtDescProduto: TEdit;
    lblQtd: TLabel;
    edtQtd: TEdit;
    lblVlrUnit: TLabel;
    edtVlrUnit: TEdit;
    btnAdicionar: TButton;
    dbgItens: TDBGrid;
    pnlFooter: TPanel;
    lblTotalPedido: TLabel;
    lblVlrTotalPedido: TLabel;
    lblObs: TLabel;
    edtObs: TEdit;
    btnGravarPedido: TButton;
    dsItens: TDataSource;
    mtItens: TFDMemTable;
    mtItensCodProduto: TIntegerField;
    mtItensDescricao: TStringField;
    mtItensQuantidade: TFloatField;
    mtItensVlrUnitario: TFloatField;
    mtItensVlrTotal: TFloatField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure dbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
  private
    FController: TPedidoController;
    FEditIndex: Integer;
    procedure LimparCamposProduto;
    procedure AtualizarGrid;
    procedure CarregarItemParaEdicao;
    procedure ExcluirItem;
    procedure AtualizarTotalTela;
  public
  end;

var
  FrmPedido: TFrmPedido;

implementation

{$R *.dfm}

procedure TFrmPedido.FormCreate(Sender: TObject);
begin
  FController := TPedidoController.Create;
  FEditIndex  := -1;

  mtItens.CreateDataSet;
end;

procedure TFrmPedido.FormDestroy(Sender: TObject);
begin
  FController.Free;
end;

procedure TFrmPedido.edtCodClienteExit(Sender: TObject);
var
  LCliente: TCliente;
  LCod: Integer;
begin
  if TryStrToInt(edtCodCliente.Text, LCod) then
  begin
    LCliente := FController.GetCliente(LCod);

    try
      if Assigned(LCliente) then
      begin
        edtNomeCliente.Text   := LCliente.Nome;
        edtCidadeCliente.Text := LCliente.Cidade;
        edtUFCliente.Text     := LCliente.UF;
      end
      else
      begin
        ShowMessage('Cliente não encontrado!');
        edtCodCliente.SetFocus;
      end;
    finally
      LCliente.Free;
    end;
  end;
end;

procedure TFrmPedido.edtCodProdutoExit(Sender: TObject);
var
  LProduto: TProduto;
  LCod: Integer;
begin
  if TryStrToInt(edtCodProduto.Text, LCod) then
  begin
    LProduto := FController.GetProduto(LCod);

    try
      if Assigned(LProduto) then
      begin
        edtDescProduto.Text := LProduto.Descricao;
        edtVlrUnit.Text     := FloatToStr(LProduto.PrecoVenda);
      end
      else
      begin
        ShowMessage('Produto não encontrado!');
        edtCodProduto.SetFocus;
      end;
    finally
      LProduto.Free;
    end;
  end;
end;

procedure TFrmPedido.btnAdicionarClick(Sender: TObject);
var
  LCodProd: Integer;
  LQtd, LVlr: Double;
begin
  if not TryStrToInt(edtCodProduto.Text, LCodProd) then Exit;
  if not TryStrToFloat(edtQtd.Text, LQtd) then Exit;
  if not TryStrToFloat(edtVlrUnit.Text, LVlr) then Exit;

  FController.AdicionarOuAtualizarItem(LCodProd, edtDescProduto.Text, LQtd, LVlr, FEditIndex);

  AtualizarGrid;

  LimparCamposProduto;

  FEditIndex           := -1;
  btnAdicionar.Caption := 'Inserir Item';

  edtCodProduto.SetFocus;
end;

procedure TFrmPedido.LimparCamposProduto;
begin
  edtCodProduto.Clear;
  edtDescProduto.Clear;
  edtQtd.Clear;
  edtVlrUnit.Clear;
end;

procedure TFrmPedido.AtualizarGrid;
var
  LItem: TPedidoItem;
begin
  mtItens.EmptyDataSet;

  for LItem in FController.GetPedido.Itens do
  begin
    mtItens.Append;

    mtItensCodProduto.AsInteger := LItem.CodigoProduto;
    mtItensDescricao.AsString := LItem.DescricaoProduto;
    mtItensQuantidade.AsFloat := LItem.Quantidade;
    mtItensVlrUnitario.AsFloat := LItem.ValorUnitario;
    mtItensVlrTotal.AsFloat := LItem.ValorTotal;

    mtItens.Post;
  end;

  AtualizarTotalTela;
end;

procedure TFrmPedido.AtualizarTotalTela;
begin
  lblVlrTotalPedido.Caption := FormatCurr('R$ #,##0.00', FController.CalcularTotalPedido);
end;

procedure TFrmPedido.dbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    CarregarItemParaEdicao
  else if Key = VK_DELETE then
    ExcluirItem;
end;

procedure TFrmPedido.CarregarItemParaEdicao;
begin
  if not mtItens.IsEmpty then
  begin
    FEditIndex           := mtItens.RecNo - 1;
    edtCodProduto.Text   := mtItensCodProduto.AsString;
    edtDescProduto.Text  := mtItensDescricao.AsString;
    edtQtd.Text          := mtItensQuantidade.AsString;
    edtVlrUnit.Text      := mtItensVlrUnitario.AsString;
    btnAdicionar.Caption := 'Atualizar Item';
    edtQtd.SetFocus;
  end;
end;

procedure TFrmPedido.ExcluirItem;
begin
  if not mtItens.IsEmpty then
  begin
    if MessageDlg('Deseja excluir este item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      FController.RemoverItem(mtItens.RecNo - 1);
      AtualizarGrid;
    end;
  end;
end;

procedure TFrmPedido.btnGravarPedidoClick(Sender: TObject);
var
  LCodCli, LNumPedido: Integer;
begin
  if not TryStrToInt(edtCodCliente.Text, LCodCli) then
  begin
    ShowMessage('Informe um cliente válido.');

    Exit;
  end;

  try
    LNumPedido := FController.SalvarPedido(LCodCli, edtObs.Text);

    ShowMessage('Pedido ' + LNumPedido.ToString + ' gravado com sucesso!');
    
    // Limpar tela para novo pedido
    FController.NovoPedido;
    mtItens.EmptyDataSet;
    edtCodCliente.Clear;
    edtNomeCliente.Clear;
    edtCidadeCliente.Clear;
    edtUFCliente.Clear;
    edtObs.Clear;
    AtualizarTotalTela;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

end.
