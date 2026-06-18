-- Depois de criar uma tabela, podemos mudar sua estrutura.
-- Aqui adicionamos a coluna "nascimento" (uma data) na tabela "aluno".
-- Modelo: ALTER TABLE nome_da_tabela ADD nome_da_coluna tipo;
ALTER TABLE aluno
ADD nascimento DATE NOT NULL;

-- Adiciona a coluna "avatar" (texto), que pode ficar vazia.
ALTER TABLE aluno
ADD avatar VARCHAR(255);

-- Dá para adicionar mais de uma coluna no mesmo comando:
--   biografia -> texto longo, obrigatório
--   ativo     -> verdadeiro/falso, começa como TRUE (ligado) por padrão
-- Modelo: ALTER TABLE nome_da_tabela ADD coluna1 tipo, ADD coluna2 tipo;
ALTER TABLE aluno
ADD biografia TEXT NOT NULL,
  ADD ativo BOOLEAN DEFAULT TRUE;

-- "MODIFY" muda o tipo de uma coluna que já existe.
-- Aqui "biografia" deixa de ser texto longo e vira texto de até 255 caracteres.
-- Modelo: ALTER TABLE nome_da_tabela MODIFY nome_da_coluna novo_tipo;
ALTER TABLE aluno
MODIFY biografia VARCHAR(255) NOT NULL;

-- Muda o valor padrão de "ativo" para 0 (que significa falso/desligado).
ALTER TABLE aluno
MODIFY ativo BOOLEAN DEFAULT 0;

-- "RENAME COLUMN" troca só o nome da coluna, mantendo o mesmo tipo.
-- Aqui "avatar" passa a se chamar "foto_perfil".
-- Modelo: ALTER TABLE nome_da_tabela RENAME COLUMN nome_atual TO nome_novo;
ALTER TABLE aluno
  RENAME COLUMN avatar TO foto_perfil;

-- Renomeia a coluna "ativo" para "status".
ALTER TABLE aluno
  RENAME COLUMN ativo to status;

-- "CHANGE" troca o nome E o tipo da coluna ao mesmo tempo.
-- Aqui "foto_perfil" vira "avatar_alt" e passa a aceitar até 25 caracteres.
-- Modelo: ALTER TABLE nome_da_tabela CHANGE nome_atual nome_novo novo_tipo;
ALTER TABLE aluno CHANGE foto_perfil avatar_alt VARCHAR(25);

-- Remove uma coluna da tabela. Os dados daquela coluna se perdem.
-- Modelo: ALTER TABLE nome_da_tabela DROP COLUMN nome_da_coluna;
ALTER TABLE aluno DROP COLUMN status;
ALTER TABLE aluno DROP COLUMN avatar_alt;

-- Mostra as colunas da tabela e os detalhes de cada uma
-- (nome, tipo, se aceita vazio, etc.).
-- Modelo: DESCRIBE nome_da_tabela;
DESCRIBE aluno;

-- Outra forma de ver as mesmas informações das colunas.
-- Modelo: SHOW COLUMNS FROM nome_da_tabela;
SHOW COLUMNS
FROM aluno;
