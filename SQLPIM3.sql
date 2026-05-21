-- Criação do banco de dados do sistema.
CREATE DATABASE PIM3;
GO

-- Seleção do banco utilizado no sistema.
USE PIM3;
GO

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- CRIAÇÃO DAS TABELAS DO SISTEMA
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Tabela responsável pelas categorias dos produtos.
CREATE TABLE Categoria (
    IdCategoria INT PRIMARY KEY IDENTITY(1,1),
    NomeCategoria VARCHAR(50) NOT NULL
);

-- Tabela responsável pelos clientes cadastrados.
CREATE TABLE Cliente (
    IdCliente INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Telefone VARCHAR(20) NOT NULL,
    Senha VARCHAR(100) NOT NULL,
    Rua VARCHAR(100) NOT NULL,
    Numero VARCHAR(10) NOT NULL,
    Bairro VARCHAR(100) NOT NULL,
    Cep VARCHAR(20) NOT NULL,
    PontosFidelidade INT DEFAULT 0
);

-- Tabela responsável pelos produtos do cardápio.
CREATE TABLE Produto (
    IdProduto INT PRIMARY KEY IDENTITY(1,1),
    Nome VARCHAR(100) NOT NULL,
    Preco DECIMAL(10,2) NOT NULL,
    IdCategoria INT NOT NULL,

    FOREIGN KEY (IdCategoria)
    REFERENCES Categoria(IdCategoria)
);

-- Tabela responsável pelas unidades/franquias do restaurante.
CREATE TABLE Franquia (
    IdFranquia INT PRIMARY KEY IDENTITY(1,1),
    NomeUnidade VARCHAR(100) NOT NULL,
    Endereco VARCHAR(200) NOT NULL
);

-- Tabela responsável pelos carrinhos de compra dos clientes.
CREATE TABLE Carrinho (
    IdCarrinho INT PRIMARY KEY IDENTITY(1,1),
    IdCliente INT NOT NULL,
    DataCarrinho DATETIME DEFAULT GETDATE(),
    FormaPagamento VARCHAR(50),
    Total DECIMAL(10,2),

    FOREIGN KEY (IdCliente)
    REFERENCES Cliente(IdCliente)
);

-- Tabela responsável pelos itens presentes em cada carrinho.
CREATE TABLE ItemCarrinho (
    IdItemCarrinho INT PRIMARY KEY IDENTITY(1,1),
    IdCarrinho INT NOT NULL,
    IdProduto INT NOT NULL,
    Quantidade INT NOT NULL,

    FOREIGN KEY (IdCarrinho)
    REFERENCES Carrinho(IdCarrinho),

    FOREIGN KEY (IdProduto)
    REFERENCES Produto(IdProduto)
);

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- INSERÇÃO DOS DADOS BASE DO SISTEMA
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Inserção das categorias do cardápio.
INSERT INTO Categoria (NomeCategoria)
VALUES
('Combo'),
('Burger'),
('Acompanhamento'),
('Bebida'),
('Sobremesa');

-- Inserção dos produtos da categoria Combo.
INSERT INTO Produto (Nome, Preco, IdCategoria)
VALUES
('Combo Classic', 35.90, 1),
('Combo Bacon Supreme', 42.90, 1),
('Combo Duplo', 45.90, 1),
('Combo Kids', 29.90, 1),
('Combo Chicken', 38.90, 1),
('Combo Premium', 49.90, 1);

-- Inserção dos produtos da categoria Burger.
INSERT INTO Produto (Nome, Preco, IdCategoria)
VALUES
('X burguer Clássico', 22.00, 2),
('Bacon Burguer', 26.90, 2),
('Chicken Burguer', 24.90, 2),
('Double Smash Burguer', 32.90, 2),
('BBQ burguer', 28.90, 2),
('veggie burguer', 27.90, 2),
('cheddar bacon burguer', 31.90, 2),
('spicy burguer', 29.90, 2);

-- Inserção dos produtos da categoria Acompanhamento.
INSERT INTO Produto (Nome, Preco, IdCategoria)
VALUES
('Batata Grande', 14.90, 3),
('Onion Rings', 14.90, 3),
('Nuggets', 15.90, 3),
('Frango Empanado', 22.90, 3),
('Batata rústica', 16.90, 3),
('batata cheddar e bacon', 19.90, 3),
('salada caesar', 18.00, 3);

-- Inserção dos produtos da categoria Bebida.
INSERT INTO Produto (Nome, Preco, IdCategoria)
VALUES
('Refrigerante 500ml', 7.00, 4),
('Milkshake', 14.90, 4),
('Suco Natural', 9.50, 4),
('Refrigerante 1L', 11.00, 4),
('água mineral', 5.00, 4),
('chá gelado', 7.50, 4);

-- Inserção dos produtos da categoria Sobremesa.
INSERT INTO Produto (Nome, Preco, IdCategoria)
VALUES
('Torta de Maçã', 11.90, 5),
('Brownie com sorvete', 15.90, 5),
('Casquinha de Sorvete', 4.50, 5),
('Donuts com cobertura', 8.90, 5);

-- Inserção das unidades/franquias.
INSERT INTO Franquia (NomeUnidade, Endereco)
VALUES
('Unidade Centro', 'Av. Principal, 1000 - Centro'),
('Unidade Shopping', 'Praça de Alimentação, Lojas 45/46'),
('Unidade Zona Sul', 'Rua das Flores, 320 - Jardins');

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- INSERÇÃO DE DADOS PARA TESTES
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Inserção dos clientes para testar o sistema
INSERT INTO Cliente
(Nome, Email, Telefone, Senha, Rua, Numero, Bairro, Cep)
VALUES
('Roberto', 'roberto@gmail.com', '(11) 92555-3222', 'abcd1234', 'Rua A', '122', 'Centro', '12345-123'),
('Marina', 'marina@gmail.com', '(11) 91243-1244', 'mari4477', 'Rua B', '116', 'Jardins', '03864-050');

-- Inserção de carrinho vinculado ao cliente.
INSERT INTO Carrinho (IdCliente, FormaPagamento, Total)
VALUES
(1, 'Pix', 78.80);

-- Inserção dos itens adicionados ao carrinho.
INSERT INTO ItemCarrinho (IdCarrinho, IdProduto, Quantidade)
VALUES
(1, 7, 2),
(1, 22, 1);

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- CONSULTAS E TESTES DO SISTEMA
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Consulta de todas as categorias cadastradas.
SELECT * FROM Categoria;

-- Consulta de todos os produtos cadastrados.
SELECT * FROM Produto;

-- Consulta de produtos com suas respectivas categorias.
SELECT
    Produto.Nome,
    Produto.Preco,
    Categoria.NomeCategoria
FROM Produto
INNER JOIN Categoria
ON Produto.IdCategoria =
Categoria.IdCategoria;

-- Consulta completa de clientes, carrinhos e produtos.
SELECT
    Cliente.Nome AS Cliente,
    Produto.Nome AS Produto,
    ItemCarrinho.Quantidade,
    Produto.Preco,
    Carrinho.FormaPagamento
FROM ItemCarrinho

INNER JOIN Carrinho
ON ItemCarrinho.IdCarrinho = Carrinho.IdCarrinho

INNER JOIN Cliente
ON Carrinho.IdCliente = Cliente.IdCliente

INNER JOIN Produto
ON ItemCarrinho.IdProduto = Produto.IdProduto;

-->>>>>>>>>>>>>>>>>>>>>>>>>
-- FIM DO SCRIPT DO SISTEMA
-->>>>>>>>>>>>>>>>>>>>>>>>>
