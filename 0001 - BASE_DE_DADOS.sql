-- Um "banco de dados" é como um grande armário onde guardamos
-- informações organizadas. Aqui criamos um chamado "escola".
-- O "IF NOT EXISTS" evita erro: só cria se ainda não existir.
-- Modelo: CREATE DATABASE IF NOT EXISTS nome_do_banco;
CREATE DATABASE IF NOT EXISTS escola;

-- Antes de trabalhar, precisamos "entrar" no banco que queremos usar.
-- A partir daqui, todos os comandos valem para o banco "escola".
-- Modelo: USE nome_do_banco;
USE escola;

-- Mostra qual banco está selecionado agora.
-- Útil para confirmar que você está no lugar certo.
-- Modelo: SELECT DATABASE();
SELECT DATABASE();

-- Apaga o banco inteiro e tudo que há dentro (tabelas, dados...).
-- Cuidado: isso NÃO tem volta! Use com muita atenção.
-- O "IF EXISTS" evita erro caso o banco já tenha sido apagado antes.
-- Modelo: DROP DATABASE IF EXISTS nome_do_banco;
DROP DATABASE IF EXISTS escola;

-- Lista todos os bancos de dados que existem no servidor.
-- Modelo: SHOW DATABASES;
SHOW DATABASES;
