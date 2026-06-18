-- Este é o projeto prático. Aqui junta tudo que os arquivos 0001 a 0005
-- mostraram em pedaços: criar o banco, criar tabelas, pôr restrições, ligar
-- umas tabelas nas outras com chave estrangeira e, no fim, inserir dados.
-- O banco se chama "empresa" e modela uma empresa.
--
-- São três ligações entre as tabelas, e cada uma se resolve de um jeito:
--   1:N  -> um projeto possui muitos artigos; cada artigo é de um projeto só.
--          (a chave estrangeira fica na tabela "filha", o artigo)
--   N:N  -> muitos funcionarios trabalham em muitos projetos.
--          (precisa de uma tabela no meio: projeto_funcionario)
--   1:1  -> um funcionario gerencia um departamento, e um departamento tem um
--          gerente só. (chave estrangeira + UNIQUE no departamento)

-- ============================================================
-- Banco de dados
-- ============================================================

-- Cria o banco "empresa" só se ele ainda não existir.
-- Modelo: CREATE DATABASE IF NOT EXISTS nome_do_banco;
CREATE DATABASE IF NOT EXISTS empresa;

-- Entra no banco. Daqui pra frente os comandos valem pra ele.
-- Modelo: USE nome_do_banco;
USE empresa;

-- ============================================================
-- Limpeza - apaga as tabelas antes de criar de novo
-- ============================================================

-- A ordem aqui importa por causa das chaves estrangeiras. Apagamos primeiro as
-- tabelas que dependem das outras (artigo, projeto_funcionario, departamento) e
-- só depois as que elas apontam (projeto, funcionario). Se fizer ao contrário, o
-- banco recusa: não dá pra apagar uma tabela enquanto outra ainda aponta pra ela.
-- Modelo: DROP TABLE IF EXISTS nome_da_tabela;
DROP TABLE IF EXISTS artigo;
DROP TABLE IF EXISTS projeto_funcionario;
DROP TABLE IF EXISTS departamento;
DROP TABLE IF EXISTS projeto;
DROP TABLE IF EXISTS funcionario;

-- ============================================================
-- Tabela "funcionario" - tabela base
-- ============================================================

-- É uma das tabelas independentes: não aponta pra ninguém. Por isso vem antes,
-- as outras é que vão se ligar nela.
CREATE TABLE IF NOT EXISTS funcionario(
    -- numero, chave da linha, gerado sozinho
    id INT PRIMARY KEY AUTO_INCREMENT,
    -- nome obrigatorio
    nome VARCHAR(50) NOT NULL,
    -- cpf obrigatorio e que nao pode repetir
    cpf VARCHAR(11) UNIQUE NOT NULL,
    -- email obrigatorio e unico
    email VARCHAR(255) UNIQUE NOT NULL,
    -- sim/nao, obrigatorio, comeca como "sim"
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- ============================================================
-- Tabela "departamento" - relacao 1:1 com funcionario
-- ============================================================

-- Aqui está o 1:1. O departamento guarda quem é o gerente em "id_gerente", que
-- aponta pra um funcionario. O UNIQUE é o que torna a relação 1:1 de verdade: um
-- mesmo funcionario não pode aparecer como gerente em dois departamentos.
-- No ON DELETE SET NULL, se o funcionario for apagado, o departamento não some
-- junto; ele só fica sem gerente (id_gerente vira NULL).
-- Modelo: FOREIGN KEY (coluna) REFERENCES outra_tabela(coluna)
--           ON DELETE SET NULL ON UPDATE CASCADE
CREATE TABLE IF NOT EXISTS departamento(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    -- aponta pro funcionario que gerencia; UNIQUE garante um por departamento
    id_gerente INT UNIQUE,
    -- gerente - 1:1
    FOREIGN KEY (id_gerente) REFERENCES funcionario(id) ON DELETE
    SET NULL ON UPDATE CASCADE
);

-- ============================================================
-- Tabela "projeto" - tabela base
-- ============================================================

-- Outra tabela independente. Ela fica no lado "1" das duas relações que vêm a
-- seguir: um projeto tem vários artigos e vários funcionarios.
CREATE TABLE IF NOT EXISTS projeto(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    -- texto longo, pode ficar vazio
    descricao TEXT
);

-- ============================================================
-- Tabela "projeto_funcionario" - relacao N:N
-- ============================================================

-- Esta é a tabela do meio que resolve o N:N. Banco de dados não liga duas
-- tabelas direto num "muitos pra muitos"; a saída é uma terceira tabela que
-- guarda os pares (funcionario, projeto). Cada linha é uma pessoa alocada num
-- projeto. O UNIQUE no par impede registrar a mesma pessoa duas vezes no mesmo
-- projeto. As duas FKs usam ON DELETE CASCADE: se o funcionario ou o projeto
-- some, a linha de alocação some junto, pra não sobrar par apontando pro vazio.
CREATE TABLE IF NOT EXISTS projeto_funcionario(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT,
    id_projeto INT,
    -- unique impede colocar o mesmo funcionario muitas
    -- vezes em um mesmo projeto
    UNIQUE (id_funcionario, id_projeto),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_projeto) REFERENCES projeto(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- Tabela "artigo" - relacao 1:N com projeto
-- ============================================================

-- Aqui está o 1:N. Cada artigo guarda um "id_projeto", então pertence a um
-- projeto só. Do outro lado, o mesmo projeto pode aparecer em vários artigos.
-- A regra "a FK fica na tabela do lado N" se vê bem: o id_projeto está no artigo.
-- ON DELETE CASCADE faz os artigos sumirem junto se o projeto for apagado.
CREATE TABLE IF NOT EXISTS artigo(
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    -- aponta pro projeto dono do artigo
    id_projeto INT,
    FOREIGN KEY (id_projeto) REFERENCES projeto(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- INSERÇÃO DE REGISTROS
-- ============================================================

-- A ordem de inserção também segue as chaves estrangeiras, mas ao contrário do
-- DROP: primeiro as tabelas independentes (funcionario, projeto) e depois as que
-- dependem delas. Não dá pra dizer que o departamento tem o gerente 1 antes de o
-- funcionario 1 existir.

-- Quatro funcionarios. O id não entra: o AUTO_INCREMENT preenche (1 a 4).
INSERT INTO funcionario(nome, cpf, email)
VALUES ('Ana Souza', '11122233301', 'ana@mail.com'),
    ('Bruno Lima', '11122233302', 'bruno@mail.com'),
    ('Carla Dias', '11122233303', 'carla@mail.com'),
    ('Diego Reis', '11122233304', 'diego@mail.com');

-- Dois departamentos, cada um já com seu gerente: Ana (id 1) e Bruno (id 2).
INSERT INTO departamento(nome, id_gerente)
VALUES ('Tecnologia', 1),
    ('Recursos Humanos', 2);

-- Dois projetos (viram id 1 e id 2).
INSERT INTO projeto(nome, descricao)
VALUES ('Sistema X', 'Plataforma interna de gestão'),
    ('App Y', 'Aplicativo mobile do cliente');

-- As alocações N:N. Repare que Ana (1) aparece em dois projetos e o projeto 1
-- tem duas pessoas. É isso que o "muitos pra muitos" permite.
INSERT INTO projeto_funcionario(id_funcionario, id_projeto)
VALUES (1, 1),
    (2, 1),
    (3, 2),
    (1, 2);

-- Os artigos, cada um amarrado a um projeto pelo id_projeto (o lado N do 1:N).
INSERT INTO artigo(titulo, descricao, id_projeto)
VALUES ('Arquitetura SX', 'Visão Geral X', 1),
    ('Testes SX', 'Estratégia X', 1),
    ('Onboarding Y', 'Fluxos de entrada', 2);
