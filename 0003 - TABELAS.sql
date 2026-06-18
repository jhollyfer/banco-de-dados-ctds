-- Uma "tabela" é onde os dados ficam de fato, organizados em
-- colunas (tipos de informação) e linhas (cada registro).
-- Aqui criamos a tabela "aluno" com estas colunas:
--   id        -> número único de cada aluno, gerado sozinho (AUTO_INCREMENT)
--   nome      -> texto obrigatório (NOT NULL = não pode ficar vazio)
--   email     -> texto obrigatório e único (UNIQUE = não pode repetir)
--   matricula -> número obrigatório
-- Modelo: CREATE TABLE IF NOT EXISTS nome_da_tabela(coluna1 tipo, coluna2 tipo, ...);
CREATE TABLE IF NOT EXISTS aluno(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    matricula INT NOT NULL
);

-- Troca o nome da tabela de "aluno" para "estudantes".
-- Modelo: RENAME TABLE nome_atual TO nome_novo;
RENAME TABLE aluno TO estudantes;

-- Mesma ideia, mas usando ALTER TABLE: renomeia "estudantes" para "alunos".
-- Existem dois jeitos de fazer a mesma coisa; ambos funcionam.
-- Modelo: ALTER TABLE nome_atual RENAME TO nome_novo;
ALTER TABLE estudantes
    RENAME TO alunos;

-- Apaga todos os registros de dentro da tabela, mas mantém a tabela.
-- Ela fica vazia, como se fosse nova. Cuidado: os dados não voltam.
-- Modelo: TRUNCATE TABLE nome_da_tabela;
TRUNCATE TABLE alunos;

-- Apaga a tabela inteira (estrutura + dados). Não tem volta.
-- Modelo: DROP TABLE IF EXISTS nome_da_tabela;
DROP TABLE IF EXISTS alunos;

-- Lista todas as tabelas que existem no banco atual.
-- Modelo: SHOW TABLES;
SHOW TABLES;
