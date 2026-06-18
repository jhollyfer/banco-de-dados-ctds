# Atividade: banco de dados de uma empresa

Esta atividade monta, do zero, o banco que está em `BANCO-EMPRESA.sql`.
A ideia é construir passo a passo e, no caminho, entender por que cada tabela ficou
do jeito que ficou. Se você seguir os passos na ordem, chega exatamente no código
daquele arquivo.

O banco se chama `empresa` e guarda os dados de uma empresa: funcionários,
departamentos, projetos e os artigos que saem de cada projeto.

## O que precisa existir

São quatro coisas para guardar e três regras ligando elas:

1. Um projeto possui muitos artigos, e cada artigo pertence a um projeto só.
2. Muitos funcionários trabalham em muitos projetos (e um funcionário pode estar
   em vários projetos ao mesmo tempo).
3. Um funcionário gerencia um departamento, e cada departamento tem um gerente só.

Essas três regras são o coração da atividade. Antes de sair escrevendo, vale olhar
o desenho em `DER_EMPRESA.png`, que mostra as mesmas regras em forma de diagrama.

## Como cada regra vira código

Cada tipo de ligação tem um jeito conhecido de resolver. Decore esses três:

- **Um pra muitos (1:N)**: a chave estrangeira fica na tabela do lado "muitos".
  Como cada artigo é de um projeto só, é o artigo que guarda o `id_projeto`.
- **Muitos pra muitos (N:N)**: não dá pra ligar duas tabelas direto. Cria-se uma
  terceira tabela no meio só pra guardar os pares. É a `projeto_funcionario`.
- **Um pra um (1:1)**: parecido com o 1:N, mas com um `UNIQUE` na chave
  estrangeira pra travar em "só um". É o `id_gerente` do departamento.

## Passo a passo

### 1. Criar o banco e entrar nele

```sql
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;
```

O `IF NOT EXISTS` evita erro se o banco já existir. O `USE` é o que diz "a partir
de agora os comandos são pra cá".

### 2. Pensar na ordem antes de criar

Como as tabelas vão se apontar umas às outras, a ordem importa. Uma tabela só pode
apontar pra outra que já existe. Então criamos primeiro as independentes
(`funcionario` e `projeto`) e depois as que dependem delas.

No começo do arquivo também tem um bloco de `DROP TABLE`, que apaga tudo antes de
recriar. Lá a ordem é a inversa: apaga primeiro as filhas, depois as mães. Se
tentar apagar a mãe enquanto a filha ainda aponta pra ela, o banco recusa.

```sql
DROP TABLE IF EXISTS artigo;
DROP TABLE IF EXISTS projeto_funcionario;
DROP TABLE IF EXISTS departamento;
DROP TABLE IF EXISTS projeto;
DROP TABLE IF EXISTS funcionario;
```

### 3. Tabela `funcionario`

A primeira tabela base. Não aponta pra ninguém; são as outras que vão se ligar
nela. O `cpf` e o `email` são `UNIQUE` porque não podem repetir entre pessoas.

```sql
CREATE TABLE IF NOT EXISTS funcionario(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);
```

### 4. Tabela `departamento` (aqui entra o 1:1)

O departamento guarda quem é o gerente em `id_gerente`, que aponta pra um
funcionário. O `UNIQUE` nessa coluna é o detalhe que faz o 1:1: um mesmo
funcionário não consegue ser gerente de dois departamentos.

O `ON DELETE SET NULL` resolve um problema prático: se o funcionário gerente for
apagado, o departamento não some junto, só fica sem gerente.

```sql
CREATE TABLE IF NOT EXISTS departamento(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    id_gerente INT UNIQUE,
    FOREIGN KEY (id_gerente) REFERENCES funcionario(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
```

### 5. Tabela `projeto`

Outra tabela base. Ela fica no lado "1" das duas relações que vêm a seguir: um
projeto tem vários artigos e vários funcionários.

```sql
CREATE TABLE IF NOT EXISTS projeto(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);
```

### 6. Tabela `projeto_funcionario` (aqui entra o N:N)

Esta é a tabela do meio. Cada linha dela é uma pessoa alocada num projeto. Para
ligar um funcionário a um projeto, basta inserir o par de ids aqui.

O `UNIQUE (id_funcionario, id_projeto)` impede registrar a mesma pessoa duas vezes
no mesmo projeto. As duas chaves estrangeiras usam `ON DELETE CASCADE`: se a
pessoa ou o projeto some, a linha de alocação some junto.

```sql
CREATE TABLE IF NOT EXISTS projeto_funcionario(
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT,
    id_projeto INT,
    UNIQUE (id_funcionario, id_projeto),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_projeto) REFERENCES projeto(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

### 7. Tabela `artigo` (aqui entra o 1:N)

Cada artigo guarda um `id_projeto`, então pertence a um projeto só. Do outro lado,
o mesmo projeto pode aparecer em vários artigos. Repare onde a chave estrangeira
ficou: no artigo, que é o lado "muitos". `ON DELETE CASCADE` faz os artigos
sumirem junto se o projeto for apagado.

```sql
CREATE TABLE IF NOT EXISTS artigo(
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    id_projeto INT,
    FOREIGN KEY (id_projeto) REFERENCES projeto(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

### 8. Inserir os dados

A ordem da inserção segue as chaves estrangeiras: as independentes primeiro. Não dá
pra dizer que o departamento tem o gerente 1 antes de o funcionário 1 existir.

```sql
INSERT INTO funcionario(nome, cpf, email)
VALUES ('Ana Souza', '11122233301', 'ana@mail.com'),
    ('Bruno Lima', '11122233302', 'bruno@mail.com'),
    ('Carla Dias', '11122233303', 'carla@mail.com'),
    ('Diego Reis', '11122233304', 'diego@mail.com');

INSERT INTO departamento(nome, id_gerente)
VALUES ('Tecnologia', 1),
    ('Recursos Humanos', 2);

INSERT INTO projeto(nome, descricao)
VALUES ('Sistema X', 'Plataforma interna de gestão'),
    ('App Y', 'Aplicativo mobile do cliente');

INSERT INTO projeto_funcionario(id_funcionario, id_projeto)
VALUES (1, 1), (2, 1), (3, 2), (1, 2);

INSERT INTO artigo(titulo, descricao, id_projeto)
VALUES ('Arquitetura SX', 'Visão Geral X', 1),
    ('Testes SX', 'Estratégia X', 1),
    ('Onboarding Y', 'Fluxos de entrada', 2);
```

Nos dados da `projeto_funcionario` dá pra ver o N:N funcionando: a Ana (id 1)
aparece em dois projetos, e o projeto 1 tem duas pessoas.

## Como rodar e conferir

Rode o arquivo inteiro de uma vez (ele cria o banco, as tabelas e insere os dados):

```bash
mysql -u SEU_USUARIO -p < "BANCO-EMPRESA.sql"
```

Depois entre no banco e confira:

```sql
USE empresa;
SHOW TABLES;
SELECT * FROM funcionario;
```

## Desafios pra praticar

Tente escrever as consultas abaixo. Elas usam as três relações que você acabou de
montar:

1. Liste os títulos dos artigos do projeto "Sistema X". (relação 1:N)
2. Liste os nomes dos funcionários alocados no projeto "App Y". (relação N:N, vai
   precisar passar pela `projeto_funcionario`)
3. Mostre cada departamento com o nome do seu gerente. (relação 1:1)
4. Conte quantos projetos cada funcionário tem.
5. Apague o projeto "Sistema X" e veja o que acontece com os artigos dele. (é o
   `ON DELETE CASCADE` em ação)
