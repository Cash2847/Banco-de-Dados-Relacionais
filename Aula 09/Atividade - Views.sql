CREATE TABLE Produto (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	categoria VARCHAR(20) NOT NULL,
	preco INT (100, 2) NOT NULL
);

CREATE TABLE Venda (
	id SERIAL PRIMARY KEY,
	id_produto REFERENCES Produto(id),
	quantidade INT NOT NULL
);

