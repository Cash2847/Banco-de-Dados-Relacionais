-- Prova P1 Bancos de Dados Relacional

-- Questão 1 = Normalização (1FN, 2FN. 3FN)

-- A)

-- 1FN: Coluna 'Telefone_Cliente' guarda mais de um valor 
-- na mesma célula.


-- 2FN: Modelo_Veiculo depende de Placa_Veiculo, 
-- e Data_Abertura depende de Num_OS. 

-- 3FN: mesmo separando as tabelas, Num_OS -> Placa_Veiculo -> Modelo_Veiculo
--      é uma DEPENDÊNCIA TRANSITIVA (atributo não-chave dependendo de
--      outro atributo não-chave) -> viola a 3FN

-- B) Dependência Funcional Identificada: 
-- Num_OS -> Data_Abertura
-- Placa_Veiculo -> Modelo_Veiculo

-- Questão 2 = Criação do Esquema Físico

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

INSERT INTO Veiculo(placa_veiculo, modelo_veiculo, ano_veiculo) VALUES
('ABC-1234', 'Fiat Argo', 2021),
('XYZ-9K87', 'VW Polo',	2019);

INSERT INTO Ordem_Servico(data_abertura, status, valor_total, placa_veiculo) VALUES
('10-05-2024', 'ABERTA', 526.26, 'ABC-1234'),
('11-11-2011', 'CONCLUIDA', 200.00, 'XYZ-9K87');

-- Questão 4 (0,5 ponto) — Atualização de Dados (UPDATE)

UPDATE Clientes
SET telefone_cliente = '(11) 99999-0000'
WHERE cpf_cliente = '111.222.333-44';

UPDATE Ordem_Servico
SET 'CONCLUIDA'
WHERE '10-05-2024';

-- Questão 5 (0,75 ponto) — Exclusão Segura e Integridade 
-- Referencial (DELETE)


-- Questão 6 (2,0 pontos) — Consultas com Junção de 
-- Tabelas (JOIN)

SELECT
