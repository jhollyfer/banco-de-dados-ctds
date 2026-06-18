-- Aqui o assunto são as RESTRIÇÕES (as regras de cada coluna). A regra fica
-- colada na coluna, logo depois do tipo. Você lê da esquerda pra direita:
--   nome_da_coluna   TIPO   regras...
-- Este arquivo só mostra as regras na hora de criar a tabela. Renomear, alterar
-- coluna e inserir dados ficam nos arquivos seguintes.

-- As restrições usadas aqui:
--   PRIMARY KEY     identificador único da linha
--   AUTO_INCREMENT  o banco gera o número sozinho
--   NOT NULL        não pode ficar vazio
--   DEFAULT x       valor padrão quando você não informa
--   UNIQUE          não deixa repetir
--   CHECK (...)     valida uma condição (precisa MySQL 8.0.16+)
--   UNSIGNED        só aceita números positivos
--   FOREIGN KEY     liga a coluna ao id de outra tabela

-- ============================================================
-- Tabela "curso" - uma regra colada em cada coluna
-- ============================================================

-- Repare nas regras logo depois do tipo, uma do lado da outra.
-- Modelo: CREATE TABLE IF NOT EXISTS nome_da_tabela(
--           coluna TIPO regras, ...
--         );
CREATE TABLE IF NOT EXISTS curso(
    -- número, chave da linha, gerado sozinho
    id INT PRIMARY KEY AUTO_INCREMENT,
    -- texto obrigatório e que não pode repetir
    nome VARCHAR(100) NOT NULL UNIQUE,
    -- número obrigatório
    carga_horaria INT NOT NULL,
    -- número pequeno, só positivo (0 em diante)
    vagas SMALLINT UNSIGNED,
    -- dinheiro, obrigatório, padrão 0, nunca negativo
    preco DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (preco >= 0),
    -- lista fechada de opções
    nivel ENUM('basico', 'intermediario', 'avancado') DEFAULT 'basico',
    -- sim/não, obrigatório, começa como "sim"
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- Tabela "turma" - chave composta + FOREIGN KEY
-- ============================================================

-- Duas regras novas, sem complicar:
--
-- - PRIMARY KEY com DUAS colunas (chave composta): a linha é única pela
--   combinação curso_id + codigo. Assim o mesmo curso pode ter a turma 'A' e
--   a turma 'B', mas nunca duas turmas 'A' no mesmo curso.
-- - FOREIGN KEY: liga curso_id ao id da tabela curso. O ON DELETE CASCADE faz
--   a turma sumir junto se o curso for apagado, pra não ficar apontando pra um
--   curso que não existe mais.
-- Modelo: PRIMARY KEY (coluna1, coluna2),
--         FOREIGN KEY (coluna) REFERENCES outra_tabela(coluna)
--           ON DELETE CASCADE ON UPDATE CASCADE
CREATE TABLE IF NOT EXISTS turma(
    -- número que liga ao curso
    curso_id INT,
    -- código curto da turma (ex.: 'A', 'B01')
    codigo CHAR(3),
    -- ano da turma (ex.: 2024)
    ano YEAR NOT NULL,
    -- chave composta: os dois juntos identificam a linha
    PRIMARY KEY (curso_id, codigo),
    -- liga à tabela curso e some junto se o curso for apagado
    FOREIGN KEY (curso_id) REFERENCES curso(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
