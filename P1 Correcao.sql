-- Prova P1 Bancos de Dados Relacional

-- Questão 1 = Normalização (1FN, 2FN. 3FN)

-- A)

-- 1FN: Coluna 'Telefone_Cliente' guarda mais de um valor 
-- na mesma célula, e não possui atomicidade dos dados, não cumprindo com
-- a 1NF.


-- 2FN: A tabela possui depêndencias diretas entre os dados apresentados. Se um novo cliente for cadastrado, uma nova 
-- OS será obrigatoriamente gerada,violando a 2FN.

-- 3FN: mesmo separando as tabelas, elas mostram dependências entre elas, o que viola a 3NF. 

-- B) Dependência Funcional Identificada: 
-- nome_cliente -> cpf_cliente -> placa_veiculo -> Num_OS

-- C) e Questão 2 = Criação do Esquema Físico

CREATE TABLE Clientes(
	id_cliente SERIAL PRIMARY KEY,
	nome_cliente VARCHAR(100) NOT NULL,
	cpf_cliente VARCHAR(14) NOT NULL UNIQUE,
	telefone_cliente VARCHAR(20) NOT NULL
);

CREATE TABLE Veiculo(
	placa_veiculo VARCHAR(8) PRIMARY KEY,
	modelo_veiculo VARCHAR(15) NOT NULL,
	ano_veiculo INT NOT NULL CHECK (ano_veiculo BETWEEN 1990 AND 2026),
	id_cliente INT REFERENCES Clientes(id_cliente)
);

CREATE TABLE Ordem_Servico(
	id_os SERIAL PRIMARY KEY,
	data_abertura DATE NOT NULL DEFAULT CURRENT_DATE,
	status VARCHAR(10) NOT NULL DEFAULT 'ABERTO',
	valor_total NUMERIC(100, 2) NOT NULL DEFAULT 0,
	placa_veiculo VARCHAR REFERENCES Veiculo(placa_veiculo)
);

-- Questão 03 = Carga Inicial de Dados (INSERT)

INSERT INTO Clientes(nome_cliente, cpf_cliente, telefone_cliente) VALUES
('Lucas Neves', '111.222.333-44', '(11) 11111-1111'),
('Matheus Cabral', '222222222-22', '(22) 22222-2222');

INSERT INTO Clientes(nome_cliente, cpf_cliente, telefone_cliente) VALUES
('Gabriel Martins', '333333333-33', '(33) 33333-3333');


INSERT INTO Veiculo(placa_veiculo, modelo_veiculo, ano_veiculo, id_cliente) VALUES
('ABC-1234', 'Fiat Argo', 2021, 1),
('XYZ-9K87', 'VW Polo',	2019, 2);


INSERT INTO Ordem_Servico(data_abertura, status, valor_total, placa_veiculo) VALUES
('10-05-2024', 'ABERTA', 526.26, 'ABC-1234'),
('11-11-2011', 'CONCLUIDA', 200.00, 'XYZ-9K87');

-- Questão 4 (0,5 ponto) — Atualização de Dados (UPDATE)

UPDATE Clientes
SET telefone_cliente = '(11) 99999-0000'
WHERE cpf_cliente = '111.222.333-44';

UPDATE Ordem_Servico
SET status = 'CONCLUIDA'
WHERE data_abertura = '10-05-2024';

SELECT * FROM Veiculo;
WHERE status = 'ABERTA';

-- Questão 5 (0,75 ponto) — Exclusão Segura e Integridade 
-- Referencial (DELETE)

-- A)

DELETE FROM Ordem_Servico WHERE status = 'CANCELADA' AND data_abertura < '2023-01-01';

-- B) Os veículos e as ordens de serviços vinculadas seriam deletadas juntamente do cliente.
-- Para resolver esse problema, aplicar 'ON DELETE RESTRICT' seria necessário para que os dados dependentes não sejam apagados.


-- Questão 6 (2,0 pontos) — Consultas com Junção de 
-- Tabelas (JOIN)

-- A)

SELECT cliente.nome_cliente, veiculo.placa_veiculo, OS.status
FROM Ordem_Servico OS
	INNER JOIN Veiculo veiculo ON veiculo.placa_veiculo = OS.placa_veiculo
	INNER JOIN Clientes cliente ON cliente.id_cliente = veiculo.id_cliente
WHERE status = 'ABERTA';

-- B)  (0,5) Uma consulta que liste todos os clientes cadastrados e seus respectivos veículos (placa e modelo), 
--			 incluindo clientes que ainda não possuem veículo registrado — nesse caso, 
--           use LEFT JOIN (os campos do veículo devem aparecer como NULL).


SELECT cliente.nome_cliente, veiculo.placa_veiculo, veiculo.modelo_veiculo
FROM Clientes cliente
LEFT JOIN Veiculo veiculo ON cliente.id_cliente = veiculo.id_cliente;

-- C)

SELECT veiculo.placa_veiculo, COUNT(*)
FROM Ordem_Servico OS
JOIN Veiculo veiculo ON veiculo.placa_veiculo = OS.placa_veiculo
GROUP BY (veiculo.placa_veiculo);

-- D)

SELECT OS.status, SUM(valor_total)
FROM Ordem_Servico OS
GROUP BY OS.status;

