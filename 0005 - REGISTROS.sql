-- Aqui paramos de mexer na ESTRUTURA (tabelas e colunas) e passamos a mexer
-- nos DADOS de dentro da tabela "aluno". São três verbos:
--   INSERT -> coloca registros novos
--   UPDATE -> altera registros que já existem
--   DELETE -> remove registros
-- A tabela "aluno" tem: id (gerado sozinho), nome, email e matricula.

-- ============================================================
-- INSERT - colocar registros
-- ============================================================

-- Forma básica: insere uma linha. Listamos as colunas e seus valores.
-- O "id" não aparece: ele se preenche sozinho (AUTO_INCREMENT).
-- Modelo: INSERT INTO nome_da_tabela (coluna1, coluna2) VALUES (valor1, valor2);
INSERT INTO aluno (nome, email, matricula)
VALUES ('Ana Souza', 'ana@escola.com', 1001);

-- Várias linhas de uma vez. Mais rápido que escrever um INSERT para cada uma.
-- Modelo: INSERT INTO nome_da_tabela (colunas) VALUES (...), (...), (...);
INSERT INTO aluno (nome, email, matricula) VALUES
    ('Bruno Lima', 'bruno@escola.com', 1002),
    ('Carla Dias', 'carla@escola.com', 1003),
    ('Diego Alves', 'diego@escola.com', 1004);

-- Dá para inserir sem listar as colunas, mas é arriscado: você precisa dar um
-- valor para TODA coluna, na ordem exata da tabela. Aqui o primeiro valor é o
-- "id"; usamos NULL para deixar o AUTO_INCREMENT cuidar dele.
-- Modelo: INSERT INTO nome_da_tabela VALUES (valor1, valor2, ...);
INSERT INTO aluno VALUES (NULL, 'Elis Rocha', 'elis@escola.com', 1005);

-- ============================================================
-- UPDATE - alterar registros
-- ============================================================

-- Forma básica: troca o valor de uma coluna numa linha específica.
-- O WHERE diz QUAL linha mudar (aqui, a de id = 1).
-- Modelo: UPDATE nome_da_tabela SET coluna = valor WHERE condicao;
UPDATE aluno
SET matricula = 2001
WHERE id = 1;

-- Alterar várias colunas ao mesmo tempo, separadas por vírgula.
-- Modelo: UPDATE nome_da_tabela SET col1 = v1, col2 = v2 WHERE condicao;
UPDATE aluno
SET nome = 'Ana Paula Souza', email = 'anapaula@escola.com'
WHERE id = 1;

-- ATENÇÃO: sem WHERE, o UPDATE altera TODAS as linhas da tabela.
-- O comando abaixo colocaria a mesma matricula em todo mundo. Quase nunca é o
-- que você quer. Está aqui só como aviso:
-- UPDATE aluno SET matricula = 9999;

-- ============================================================
-- DELETE - remover registros
-- ============================================================

-- Forma básica: apaga a linha que bate com a condição.
-- Modelo: DELETE FROM nome_da_tabela WHERE condicao;
DELETE FROM aluno
WHERE id = 5;

-- Apagar usando outra condição (aqui, pela matricula).
DELETE FROM aluno
WHERE matricula = 1004;

-- ATENÇÃO: sem WHERE, o DELETE apaga TODAS as linhas da tabela.
-- Quando a ideia é mesmo esvaziar a tabela inteira, prefira o TRUNCATE
-- (visto no arquivo de tabelas), que faz isso de forma mais direta.
-- DELETE FROM aluno;

-- ============================================================
-- Ver o resultado
-- ============================================================

-- Mostra todos os registros que sobraram na tabela.
-- Modelo: SELECT * FROM nome_da_tabela;
SELECT * FROM aluno;
