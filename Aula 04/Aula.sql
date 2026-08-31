CREATE TABLE Clientes(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    data_nascimento DATE
);

INSERT INTO Clientes(nome, email, data_nascimento)
VALUES
('Zé das Couves', 'zecouves@.com', '1982-01-15'),
('Zé da Manga', 'zemanga@.com', '1985-04-10'),
('Zé do Milho', 'zemilho@.com', '1990-06-25'),
('Zé do Picolé', 'zepicole@.com', '1975-09-05'),
('Zé da Padaria', 'zepadaria@.com', '1981-12-30');

SELECT nome, email
FROM Clientes
WHERE data_nascimento < '1990-01-01'


CREATE TABLE Contas(
    id
)
-- SELECT * FROM public.clientes;

-- SELECT AVG(id) as Media

-- Filtros e Fuções de Agregação
-- SELECT COUNT(*), AVG(preco)
-- FROM Produtos
-- WHERE categoria = 'Eletrônicos';


-- create table estoque(
--	id SERIAL primary key,
--	produto VARCHAR(50) not null unique,
--	quantidade INT not null check(quantidade > 0),
--	data_insert data not null
--);

