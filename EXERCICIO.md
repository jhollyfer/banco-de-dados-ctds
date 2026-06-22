# Lista de Exercícios de SQL
 
## Cenário: Academia "Corpo em Movimento"
 
Você foi contratado para montar o banco de dados de uma academia. Ao longo desta lista, vai criar o banco, construir as tabelas com suas regras, ajustar a estrutura, popular com dados e conferir o resultado.
 
Como funciona:
 
- Cada bloco tem uma explicação curta, o **Modelo** do comando (a forma geral) e o **Exercício** que você precisa resolver.
- O Modelo mostra o formato, mas não a resposta pronta: você adapta para as colunas pedidas no exercício.
- Resolva na ordem, porque cada parte depende da anterior.
- As perguntas de **Pesquisa** pedem para você explicar com suas palavras. Anote a resposta logo abaixo.
Use um banco MySQL (Workbench, DBeaver ou o ambiente indicado pelo professor).
 
---
 
## Parte 1: Comandos de banco de dados
 
O banco de dados é como um grande armário onde guardamos as informações organizadas. Antes de criar tabelas, criamos o banco e entramos nele.
 
**Modelos:**
 
```sql
CREATE DATABASE IF NOT EXISTS nome_do_banco;
USE nome_do_banco;
SELECT DATABASE();
SHOW DATABASES;
DROP DATABASE IF EXISTS nome_do_banco;
```
 
**1.1** Crie um banco chamado `academia`, evitando erro caso ele já exista.
 
**1.2** Entre no banco `academia`.
 
**1.3** Confirme qual banco está selecionado agora.
 
**1.4** Liste todos os bancos existentes no servidor.
 
**Pesquisa 1.5** Para que serve o `IF NOT EXISTS`? O que aconteceria sem ele se o banco já existisse?
> Resposta:
 
---
 
## Parte 2: Criar tabela com restrições
 
As restrições são as regras de cada coluna. Elas ficam coladas na coluna, logo depois do tipo, e você lê da esquerda para a direita: `nome_da_coluna  TIPO  regras`.
 
Restrições que vamos usar:
 
- `PRIMARY KEY`: identificador único da linha.
- `AUTO_INCREMENT`: o banco gera o número sozinho.
- `NOT NULL`: não pode ficar vazio.
- `DEFAULT x`: valor padrão quando você não informa.
- `UNIQUE`: não deixa repetir.
- `CHECK (...)`: valida uma condição (precisa MySQL 8.0.16 ou superior).
- `UNSIGNED`: só aceita números positivos.
- `ENUM(...)`: lista fechada de opções.
**Modelo:**
 
```sql
CREATE TABLE IF NOT EXISTS nome_da_tabela(
    coluna TIPO regras,
    ...
);
```
 
**2.1** Crie a tabela `plano` com as colunas e regras abaixo:
 
| Coluna | Descrição |
|---|---|
| `id` | número, chave da linha, gerado sozinho |
| `nome` | texto de até 100, obrigatório e que não repete |
| `duracao_meses` | número, obrigatório |
| `valor` | dinheiro `DECIMAL(10,2)`, obrigatório, padrão 0, nunca negativo |
| `vagas` | número pequeno, só positivo |
| `modalidade` | lista fechada: `mensal`, `trimestral`, `anual`, padrão `mensal` |
| `ativo` | sim/não, obrigatório, começa como sim |
 
**Pesquisa 2.2** Qual a diferença entre `NOT NULL` e `UNIQUE`? Uma mesma coluna pode ter as duas regras ao mesmo tempo?
> Resposta:
 
**Pesquisa 2.3** O que muda ao usar `SMALLINT UNSIGNED` em vez de só `SMALLINT`? Que tipo de valor o `UNSIGNED` impede?
> Resposta:
 
---
 
## Parte 3: Chave composta e chave estrangeira
 
Duas regras novas:
 
- **Chave composta** (`PRIMARY KEY` com duas colunas): a linha é única pela combinação das duas. Assim o mesmo plano pode ter o horário `A1` e o `B1`, mas nunca dois `A1` no mesmo plano.
- **Chave estrangeira** (`FOREIGN KEY`): liga uma coluna ao `id` de outra tabela. O `ON DELETE CASCADE` faz a linha sumir junto se o registro pai for apagado, para não ficar apontando para algo que não existe mais.
**Modelo:**
 
```sql
CREATE TABLE IF NOT EXISTS nome_da_tabela(
    ...
    PRIMARY KEY (coluna1, coluna2),
    FOREIGN KEY (coluna) REFERENCES outra_tabela(coluna)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```
 
**3.1** Crie a tabela `horario` com:
 
| Coluna | Descrição |
|---|---|
| `plano_id` | número que liga ao plano |
| `codigo` | texto curto de 3 caracteres (ex.: `A1`) |
| `dia` | lista fechada: `seg`, `ter`, `qua`, `qui`, `sex`, `sab` |
| `hora` | horário (tipo `TIME`) |
 
A linha deve ser única pela combinação `plano_id` + `codigo`, e `plano_id` deve apontar para o `id` de `plano`, sumindo junto se o plano for apagado.
 
**Pesquisa 3.2** O que o `ON DELETE CASCADE` faz na prática? Por que ele ajuda a evitar um horário apontando para um plano que não existe mais?
> Resposta:
 
---
 
## Parte 4: Comandos de tabela
 
Aqui mexemos na tabela inteira: renomear, esvaziar, apagar e listar.
 
**Modelos:**
 
```sql
RENAME TABLE nome_atual TO nome_novo;
ALTER TABLE nome_atual RENAME TO nome_novo;
TRUNCATE TABLE nome_da_tabela;
DROP TABLE IF EXISTS nome_da_tabela;
SHOW TABLES;
```
 
**4.1** Crie a tabela `cliente` com: `id` (chave, gerado sozinho), `nome` (texto até 255, obrigatório), `email` (texto até 255, obrigatório e único) e `telefone` (texto até 20).
 
**4.2** Troque o nome da tabela `cliente` para `membro` usando `RENAME TABLE`.
 
**4.3** Volte o nome para `cliente`, agora usando `ALTER TABLE`.
 
**4.4** Liste todas as tabelas do banco atual.
 
**4.5** Esvazie a tabela `cliente` (apaga os dados, mantém a estrutura).
 
**Pesquisa 4.6** Qual a diferença entre `TRUNCATE` e `DROP TABLE`?
> Resposta:
 
---
 
## Parte 5: Alterar a estrutura (ALTER TABLE)
 
Depois de criar uma tabela, podemos mudar a estrutura dela: adicionar, alterar, renomear e remover colunas. Trabalhe sempre na tabela `cliente`.
 
**Modelos:**
 
```sql
ALTER TABLE tabela ADD nome_da_coluna TIPO;
ALTER TABLE tabela ADD coluna1 TIPO, ADD coluna2 TIPO;
ALTER TABLE tabela MODIFY nome_da_coluna NOVO_TIPO;
ALTER TABLE tabela RENAME COLUMN nome_atual TO nome_novo;
ALTER TABLE tabela CHANGE nome_atual nome_novo NOVO_TIPO;
ALTER TABLE tabela DROP COLUMN nome_da_coluna;
DESCRIBE tabela;
SHOW COLUMNS FROM tabela;
```
 
**5.1** Adicione a coluna `nascimento` do tipo `DATE`, obrigatória.
 
**5.2** Adicione duas colunas no mesmo comando: `saldo` (dinheiro `DECIMAL(10,2)`, padrão 0) e `ativo` (sim/não, padrão sim).
 
**5.3** Mude o tipo da coluna `telefone` para texto de até 15 caracteres (`MODIFY`).
 
**5.4** Renomeie a coluna `telefone` para `celular`, mantendo o tipo (`RENAME COLUMN`).
 
**5.5** Em um único comando, mude `celular`: passe a se chamar `whatsapp` e aceite até 20 caracteres (`CHANGE`).
 
**5.6** Remova a coluna `saldo`.
 
**5.7** Mostre a estrutura final da tabela `cliente` com `DESCRIBE` (e depois tente também com `SHOW COLUMNS`).
 
**Pesquisa 5.8** Qual a diferença entre `MODIFY` e `CHANGE`? Quando vale usar cada um?
> Resposta:
 
---
 
## Parte 6: Inserir registros (INSERT)
 
Agora paramos de mexer na estrutura e passamos a mexer nos dados. O `id` não aparece nos `INSERT`: ele se preenche sozinho pelo `AUTO_INCREMENT`. Insira nas colunas `nome`, `email` e `nascimento`.
 
**Modelos:**
 
```sql
INSERT INTO tabela (coluna1, coluna2) VALUES (valor1, valor2);
INSERT INTO tabela (colunas) VALUES (...), (...), (...);
INSERT INTO tabela VALUES (NULL, ...);
```
 
**6.1** Insira um cliente.
 
**6.2** Insira três clientes de uma vez só, em um único comando.
 
**6.3** Insira um cliente sem listar as colunas, dando um valor para cada coluna na ordem da tabela. Use `NULL` no lugar do `id`.
 
**Pesquisa 6.4** Tente inserir dois clientes com o mesmo `email`. O que o banco responde? Por quê?
> Resposta:
 
---
 
## Parte 7: Atualizar registros (UPDATE)
 
O `UPDATE` troca valores de linhas que já existem. O `WHERE` diz qual linha mudar.
 
**Modelos:**
 
```sql
UPDATE tabela SET coluna = valor WHERE condicao;
UPDATE tabela SET col1 = v1, col2 = v2 WHERE condicao;
```
 
**7.1** Altere o nome de um cliente específico (escolha pelo `id`).
 
**7.2** Altere nome e email do cliente de `id = 1` no mesmo comando.
 
**Pesquisa 7.3** O que aconteceria se você rodasse um `UPDATE` sem o `WHERE`? (Explique, não precisa executar.)
> Resposta:
 
---
 
## Parte 8: Remover registros (DELETE)
 
O `DELETE` apaga as linhas que batem com a condição do `WHERE`.
 
**Modelo:**
 
```sql
DELETE FROM tabela WHERE condicao;
```
 
**8.1** Apague o cliente de `id = 2`.
 
**8.2** Apague um cliente usando outra condição (por exemplo, pelo `email`).
 
**Pesquisa 8.3** Por que um `DELETE` sem `WHERE` é perigoso? Quando faz mais sentido usar `TRUNCATE` em vez de `DELETE`?
> Resposta:
 
---
 
## Parte 9: Conferir os dados (SELECT)
 
O `SELECT *` mostra todos os registros e todas as colunas da tabela.
 
**Modelo:**
 
```sql
SELECT * FROM tabela;
```
 
**9.1** Mostre todos os registros da tabela `cliente`.
 
**9.2** Mostre todos os registros da tabela `plano`.
 
**Desafio 9.3** (pesquise) Em vez de todas as colunas, mostre apenas `nome` e `email` da tabela `cliente`. Como se escolhe só algumas colunas no `SELECT`?
> Resposta:
 
---
 
## Entrega
 
Salve um arquivo com todos os seus comandos preenchidos e as respostas de pesquisa anotadas como comentários (usando `--`). Confira se o arquivo roda do começo ao fim sem erros antes de entregar.
