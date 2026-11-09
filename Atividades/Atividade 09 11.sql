/*

Cenário Escolhido: Biblioteca, porque é um cenário que cobre as requisições pedidas.

Decisão minha VS IA:

	TABLES - A IA sugeriu tabelas grandes que complicavam o entendimento do código, então optei por
diminuir as informações em cada tabela apenas ao necessário. Porém, utilizei o comando CONSTRAINT
na Tabela Emprestimos sugerido pela IA.

	INSERT - IA sugeriu a aplicação dos SELECT setvals para sincronizar os contadores sequênciais.

	Trigger/Function - IA sugeriu um código gigante cobrindo várias váriaveis e comandos
que eram desnecessários para gerar um código com o intuito de ser menor e mais simples.
Porém, adotei a SECURITY DEFINER SET search_path = Biblioteca, pg_temp para garantir
o funcionamento da Trigger.

	View - IA ajudou na aplição dos comandos 'GREATEST' e 'CASE WHEN'.

	GRANT ROLES/USERS - Parte mais simples da aplicação do código na aplicação de permissões. A IA não
foi necessaria na aplicação destes códigos.

	Geral - As TABLES, INSERTS, VIEW, e GRANTS foram feitas por mim, com a IA auxiliando na correção de
erros de sintáxe e digitação, e aplicando métodos e comandos que eu não conhecia para otimizar o
funcionamento do código.


Declaração de Domínio: Eu compreendo a lógica por trás das Tabelas, View, e Grant User/Role, porém, ainda
possuo dificuldades na aplicação de Trigger, além de precisar da ajuda da IA com a adição dos comandos
mencionados anteriormente, por não ter costume com eles. Por causa disso, apesar de ser capaz de explicar
o funcionamento de maioria das linhas, certos elementos ('setval', CONSTRAINT) são partes em que não possuo
completa familiaridade com.
*/

DROP SCHEMA IF EXISTS Biblioteca CASCADE;
DROP USER IF EXISTS Abel, Luiza;
DROP ROLE IF EXISTS Atendente, Gestor;

CREATE SCHEMA Biblioteca;
SET search_path = Biblioteca, pg_temp;

-- Criando Tabelas:

CREATE TABLE Leitor (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	cpf VARCHAR(14) NOT NULL UNIQUE,
	email VARCHAR(100) NOT NULL
);

CREATE TABLE Livros (
	id_livro SERIAL PRIMARY KEY,
	titulo VARCHAR(75) NOT NULL,
	autor VARCHAR(50) NOT NULL,
	copias INT NOT NULL CHECK (copias >= 0)
);

CREATE TABLE Emprestimo (
	id_emprestimo SERIAL PRIMARY KEY,
	id_leitor INT NOT NULL REFERENCES Leitor(id),
	id_livro INT NOT NULL REFERENCES Livros(id_livro),
    multa NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (multa >= 0),
	data_emprestimo DATE NOT NULL DEFAULT current_date,
	data_prevista DATE NOT NULL DEFAULT current_date + 14,
	data_devolucao DATE,
	CONSTRAINT check_prevista CHECK (data_prevista  >= data_emprestimo),
    CONSTRAINT check_devolucao CHECK (data_devolucao IS NULL OR data_devolucao >= data_emprestimo)
);

-- INSERT

INSERT INTO Livros(id_livro, titulo, autor, copias) VALUES
(1, 'Dom Casmurro','Machado de Assis', 5),
(2, 'Memórias Póstumas', 'Machado de Assis', 6),
(3, 'O Cortiço', 'Aluísio Azevedo', 0);

INSERT INTO Leitor(id, nome, cpf, email) VALUES
(1, 'Lorenzo Sampaio de Guadelupe', '111.111.111-11', 'lorenzo@gmail.com'),
(2, 'Ze da Manga', '222.222.222-22', 'zedamanga@gmail.com');

INSERT INTO Emprestimo (id_emprestimo, id_leitor, id_livro, data_emprestimo, data_prevista, data_devolucao, multa) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, current_date - 20, current_date - 6,  NULL, 0.00),     
(2, 2, 2, current_date - 2, current_date + 12, NULL, 0.00),
(3, 1, 3, current_date - 40, current_date - 26, current_date - 24, 3.00);

SELECT setval('Livros_id_livro_seq', COALESCE(MAX(id_livro), 1)) FROM Livros;
SELECT setval('Leitor_id_seq', COALESCE(MAX(id), 1)) FROM Leitor;
SELECT setval('Emprestimo_id_emprestimo_seq', COALESCE(MAX(id_emprestimo), 1)) FROM Emprestimo;

-- Criação de Trigger e Function:
CREATE OR REPLACE FUNCTION gerenciar_estoque_emprestimo() 
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT copias FROM Livros WHERE id_livro = NEW.id_livro) <= 0 THEN
        RAISE EXCEPTION 'Não há cópias disponíveis deste livro para empréstimo.';
    END IF;
    UPDATE Livros SET copias = copias - 1 WHERE id_livro = NEW.id_livro;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = Biblioteca, pg_temp;

CREATE TRIGGER antes_de_emprestimo
BEFORE INSERT ON Emprestimo
FOR EACH ROW EXECUTE FUNCTION gerenciar_estoque_emprestimo();


-- Criação de View:
CREATE VIEW vw_emprestimos_ativos AS 
    SELECT 
        e.id_emprestimo,
        l.titulo,
        le.nome AS membro,
        e.data_emprestimo,
        e.data_prevista,
        GREATEST(current_date - e.data_prevista, 0) AS dias_atraso,
        CASE WHEN current_date > e.data_prevista THEN 'ATRASADO' ELSE 'NO PRAZO' END AS situacao
    FROM Emprestimo e
    JOIN Livros l ON l.id_livro = e.id_livro
    JOIN Leitor le ON le.id = e.id_leitor
    WHERE e.data_devolucao IS NULL;


-- Criação de Roles e Users:
CREATE ROLE Gestor;
CREATE ROLE Atendente;

CREATE USER Luiza WITH PASSWORD 'LU1234';
CREATE USER Abel WITH PASSWORD 'CAIN43220';

GRANT Gestor TO Luiza;
GRANT Atendente TO Abel;

GRANT USAGE ON SCHEMA Biblioteca TO Gestor, Atendente;

GRANT SELECT, INSERT, UPDATE ON Leitor, Livros, Emprestimo TO Gestor;
GRANT SELECT ON vw_emprestimos_ativos TO Gestor;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA Biblioteca TO Gestor;


GRANT SELECT ON vw_emprestimos_ativos TO Atendente;
GRANT INSERT ON Emprestimo TO Atendente;
GRANT USAGE, SELECT ON SEQUENCE Emprestimo_id_emprestimo_seq TO Atendente;

-- Teste 01: Sucesso de validação do Trigger.
INSERT INTO Emprestimo (id_leitor, id_livro) VALUES (2, 1);
SELECT * FROM vw_emprestimos_ativos;
SELECT titulo, copias FROM Livros WHERE id_livro = 1;

-- Teste 02: Erro de validação do Trigger.
INSERT INTO Emprestimo (id_leitor, id_livro) VALUES (1, 3);

-- Teste 03: Acesso disponível para o Atendente.
SET ROLE Atendente;
DELETE FROM biblioteca.Emprestimo WHERE id_emprestimo = 1;
RESET ROLE;