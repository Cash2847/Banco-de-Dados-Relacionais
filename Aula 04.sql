

--- Criação de Tabela
 -- Modelagem banco de dados da Auto Escola

 -- Tabela de Categoria

CREATE TABLE categoria(
	id SERIAL PRIMARY KEY,
	categoria VARCHAR(10) -- ACC, A, B, AB, C, D, E	
);

 -- Tabela de Usuário

CREATE TABLE aluno(
	id serial PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	nasc DATE NOT NULL,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(60) NOT NULL,
	categ_id INT REFERENCES categoria(id)
);

 -- Veículo

CREATE TABLE car(
	id SERIAL PRIMARY KEY,
	placa VARCHAR(8) NOT NULL UNIQUE,
	modelo VARCHAR(15) NOT NULL,
	marca VARCHAR(15) NOT NULL,
	ano DATE NOT NULL,
	categoria VARCHAR(10) NOT NULL
	);



 -- Tabela de Instrutor

CREATE TABLE instructor(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	telefone VARCHAR(20) NOT NULL,
	email VARCHAR(60) NOT NULL,
	categoria VARCHAR(10) NOT NULL
	);

 -- Tabela de Aula

CREATE TABLE aula(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL UNIQUE,
	modalidade VARCHAR(10) NOT NULL,
	id_instructor INT REFERENCES instructor(id),
	id_aluno INT REFERENCES aluno(id)
);

 -- INSERT Categoria
	
insert into categoria(categoria)
values 
	('ACC'),
	('A'),
	('B'),
	('AB'),
	('C'),
	('D'),
	('E');
	
-- Subquery

insert into aluno(nome, cpf, nasc, telefone, email, categ_id)
values
	('Jorge', '1234567890', '2020-12-20', '4126151671251612', 'jorge@email.com', (select id from categoria where categoria  = 'D'));
select * from aluno
