# Projeto Pedido de Venda - Delphi 12

Este projeto é uma aplicação de Pedido de Venda desenvolvida em Delphi 12 VCL, utilizando arquitetura MVC/Service/Repository e banco de dados Firebird com FireDAC.

## 1. Como Criar o Banco de Dados

1.  Certifique-se de ter o **Firebird (versão 3.0 ou superior)** instalado em sua máquina.
2.  Crie uma pasta chamada `database` na raiz do projeto.
3.  Crie um novo banco de dados Firebird chamado `BANCO.FDB` dentro desta pasta (ex: utilizando o ISQL ou ferramenta como IBExpert/DBeaver).
4.  Execute o script SQL contido no arquivo `database.sql` para criar as tabelas, generators, triggers, índices e realizar a carga inicial de dados (Clientes e Produtos).

## 2. Como Configurar o INI

O arquivo `config.ini` deve estar localizado na mesma pasta do executável (ou na raiz do projeto durante o desenvolvimento). Ele deve seguir o seguinte formato:

```ini
[Database]
Database=C:\Caminho\Para\Seu\Projeto\database\BANCO.FDB
Username=SYSDBA
Password=masterkey
Server=localhost
Port=3050
ClientLibrary=C:\Caminho\Para\fbclient.dll
```

> **Nota:** Certifique-se de que o caminho da `ClientLibrary` aponta para a DLL correta do Firebird (geralmente encontrada na pasta de instalação do Firebird).

## 3. Como Executar o Projeto

1.  Abra o Delphi 12.
2.  Abra o arquivo de projeto [PedidoVenda.dpr](file:///c:/Projetos/AIprojects/PedidoDeVenda/Pedidos/PedidoVenda.dpr).
3.  Compile o projeto (Build - Ctrl+F9).
4.  Execute a aplicação (F9).

## 4. Roteiro de Testes Manuais (Passo a Passo)

### Passo 1: Identificação do Cliente
- No campo **Cód. Cliente**, informe um código de 1 a 10 e pressione **TAB** ou clique fora do campo.
- Verifique se o Nome, Cidade e UF foram preenchidos corretamente (somente leitura).
- Teste com um código inexistente e verifique se a mensagem "Cliente não encontrado!" é exibida.

### Passo 2: Inserção de Itens (Produtos)
- No campo **Cód. Produto**, informe um código de 1 a 12 e pressione **TAB**.
- Verifique se a Descrição e o Valor Unitário foram carregados.
- Informe a **Quantidade** (ex: 2) e, se desejar, altere o **Valor Unitário**.
- Clique no botão **Inserir Item**. O item deve aparecer no grid e o **Total do Pedido** no rodapé deve ser atualizado.

### Passo 3: Edição de Itens
- Com o foco no Grid, selecione um item e pressione **ENTER**.
- Os dados do item devem retornar para os campos de edição acima.
- Altere a quantidade e clique em **Atualizar Item**. Verifique se o grid e o total foram atualizados.

### Passo 4: Exclusão de Itens
- Selecione um item no Grid e pressione a tecla **DEL**.
- Confirme a exclusão na mensagem que aparecerá.
- Verifique se o item sumiu do grid e se o **Total do Pedido** foi recalculado imediatamente.

### Passo 5: Gravação do Pedido
- Adicione uma **Observação** no campo localizado no rodapé (opcional).
- Clique no botão **Gravar Pedido**.
- Uma mensagem de sucesso deve exibir o número do pedido gerado pelo banco.
- A tela será limpa automaticamente para o próximo pedido.
