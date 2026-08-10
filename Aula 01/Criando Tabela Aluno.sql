-- Tabela Aluno(id, nome, curso)
CREATE TABLE aluno(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100),
	curso VARCHAR(3)
);

SELECT * FROM aluno;
