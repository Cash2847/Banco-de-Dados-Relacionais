CREATE TABLE Clientes (
	ClienteID SERIAL PRIMARY KEY,
	ClienteNome VARCHAR(255),
	ClienteTelefone VARCHAR(20)
);

CREATE TABLE Produtos (
	ProdutoID SERIAL Primary Key,
	ProdutoNome VARCHAR(255),
	ProdutoPreco DECIMAL(10, 2)
);

CREATE TABLE Pedidos (
	PedidoID SERIAL PRIMARY KEY,
	ClienteID INT REFERENCES Clientes(ClienteID),
	ProdutoID INT REFERENCES Produtos(ProdutoID),
	Quantidade INT
);

INSERT INTO Clientes (ClienteNome, ClienteTelefone)
VALUES ('Zé das Coves', '123456789'),
       ('Zé da Manga', '987654321');

INSERT INTO Produtos (ProdutoNome, ProdutoPreco)
VALUES ('Notebook', 3000),
       ('Smartphone',2000),
	   ('Impressora', 800);

INSERT INTO Pedidos (ClienteID, ProdutoID, Quantidade)
VALUES (1, 1, 1),
       (2, 2, 2),
	   (1, 3, 1);

SELECT
	Pedidos.PedidoID,
	Clientes.ClienteNome,
	Clientes.ClienteTelefone,
	Produtos.ProdutoNome,
	Produtos.ProdutoPreco,
	Pedidos.Quantidade
FROM
	Pedidos
JOIN
	Clientes ON Pedidos.ClienteID = Clientes.ClienteID
JOIN
	Produtos ON Pedidos.ProdutoID = Produtos.ProdutoID
ORDER BY
	Pedidos.PedidoID;









