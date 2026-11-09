-- Criando SCHEMA

CREATE SCHEMA Vendas;

CREATE TABLE vendas.vendedor (
    id_vendedor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE vendas.produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10, 2) NOT NULL
);

CREATE TABLE vendas.venda (
    id_venda SERIAL PRIMARY KEY,
    id_vendedor INT REFERENCES vendas.vendedor(id_vendedor),
    id_produto INT REFERENCES vendas.produto(id_produto),
    quantidade INT NOT NULL
);
-- 1) ROLES DE GRUPO

CREATE ROLE operacao NOLOGIN;
CREATE ROLE gerencia NOLOGIN;

-- 2) USUÁRIOS (LOGIN) E ASSOCIAÇÃO AOS GRUPOS

CREATE ROLE joao  LOGIN PASSWORD 'trocar_senha_joao';
CREATE ROLE maria LOGIN PASSWORD 'trocar_senha_maria';

GRANT operacao TO joao;
GRANT gerencia TO maria;

-- 3) ACESSO AO SCHEMA

GRANT USAGE ON SCHEMA vendas TO operacao;
GRANT ALL   ON SCHEMA vendas TO gerencia;  

-- 4) PRIVILÉGIOS NAS TABELAS EXISTENTES

GRANT SELECT ON ALL TABLES IN SCHEMA vendas TO operacao;
GRANT INSERT ON vendas.venda TO operacao;

GRANT ALL ON ALL TABLES IN SCHEMA vendas TO gerencia;

-- 5) SEQUENCES (colunas SERIAL)

GRANT USAGE ON ALL SEQUENCES IN SCHEMA vendas TO operacao;
GRANT ALL   ON ALL SEQUENCES IN SCHEMA vendas TO gerencia;

-- 6) PADRÃO PARA OBJETOS FUTUROS

ALTER DEFAULT PRIVILEGES IN SCHEMA vendas
    GRANT SELECT ON TABLES TO operacao;

ALTER DEFAULT PRIVILEGES IN SCHEMA vendas
    GRANT ALL ON TABLES TO gerencia;

ALTER DEFAULT PRIVILEGES IN SCHEMA vendas
    GRANT ALL ON SEQUENCES TO gerencia;


-- 7) VERIFICAÇÃO (deve retornar o valor esperado na última coluna)

SELECT has_table_privilege('joao',  'vendas.venda',   'INSERT'); 
SELECT has_table_privilege('joao',  'vendas.produto', 'INSERT');
SELECT has_table_privilege('joao',  'vendas.produto', 'SELECT'); 
SELECT has_table_privilege('joao',  'vendas.venda',   'DELETE'); 
SELECT has_table_privilege('maria', 'vendas.produto', 'DELETE');
SELECT has_schema_privilege('joao', 'vendas', 'USAGE');           