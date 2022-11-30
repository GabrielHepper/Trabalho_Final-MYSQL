Gabriel Hepper

CREATE DATABASE DOTA2; /* Criação da database/schema para o trabalho.*/
USE DOTA2; /*Usando a database/schema.*/

/*Criação da tabela PARTIDA; O "id_da_partida" é a chave primária, "id_do_time_anfitriao" e "id_do_time_visitante" são os "id_do_time" da tabela times,
o "dia_da_partida" é o dia/mês/ano.*/
CREATE TABLE partida (
id_da_partida INT PRIMARY KEY NOT NULL,
id_do_time_anfitriao INT NOT NULL,
id_do_time_visitante INT NOT NULL,
dia_da_partida VARCHAR(30) NOT NULL);

/*Criação da tabela TIMES; O "id_do_time" é a chave primária, "nome_do_time" é o nome dos times, "id_do_patrocinador" é o ID do patrocinador do time,
o CHECK é para ver se o "id_do_patrocinador" dessa tabela corresponde ao "id_do_patrocinador" da tabela PATROCINADORES.*/
CREATE TABLE times (
id_do_time INT PRIMARY KEY NOT NULL,
nome_do_time VARCHAR(20) NOT NULL,
id_do_patrocinador INT NOT NULL,
CHECK (id_do_patrocinador = patrocinadores.id_do_patrocinador));

/*Criação da table JOGADORES; O "id_do_jogador" é a chave primária, "nome_do_jogador" é o nome dos jogadores, "id_do_heroi" é o ID do herói que o jogador usará,
"id_do_time" é o time que o jogador faz parte, o 1° CHECK é para ver se o "id_do_heroi" dessa tabela corresponde ao "id_do_heroi" da tabela HEROIS, o 2 CHECK é
para ver se o "id_do_time" dessa tabela corresponde ao "id_do_time" da tabela TIMES.*/
CREATE TABLE jogadores (
id_do_jogador INT PRIMARY KEY NOT NULL,
nome_do_jogador VARCHAR(30) NOT NULL,
id_do_heroi INT NOT NULL,
id_do_time INT NOT NULL,
CHECK (id_do_heroi = herois.id_do_heroi),
CHECK (id_do_time = times.id_do_time));

/*Criação da table HEROIS; O "id_do_heroi" é a chave primária, "nome_do_heroi" é o nome dos herois, "id_do_item" é o ID do item que o herói usará, o CHECK é
para ver se o "id_do_item" dessa tabela corresponde ao "id_do_item" da tabela ITENS.*/
CREATE TABLE herois (
id_do_heroi INT PRIMARY KEY NOT NULL,
nome_do_heroi VARCHAR(20) NOT NULL,
id_do_iten INT NOT NULL,
CHECK (id_do_iten = itens.id_do_iten));

/*criação da tabela ITENS; O "id_do_item" é a chave primária, "nome_do_item" é o nome dos itens, "preco" é o preco dos itens.*/
CREATE TABLE itens (
id_do_iten INT PRIMARY KEY NOT NULL,
nome_do_iten VARCHAR(40) NOT NULL,
preco INT NOT NULL);

/*Criação da tabela VENCEDOR; O "id_do_vencedor" é a chave primária, "nome_do_time" é o nome do time vencedor, "premio" é a recompensa do vencedor, "id_da_partida"
é o ID da partida que aconteceu, o 1° CHECK é para ver se o "id_da_partida" dessa tabela corresponde ao "id_da_partida" da tabela PARTIDA, o 2° CHECK é para ver se
o "nome_do_time" dessa tabela corresponde ao "nome_do_time" da tabela TIMES.*/
CREATE TABLE vencedor (
id_do_vencedor INT PRIMARY KEY NOT NULL,
nome_do_time VARCHAR(20) NOT NULL,
premio VARCHAR(30) NOT NULL,
id_da_partida INT NOT NULL,
CHECK (id_da_partida = partida.id_da_partida),
CHECK (nome_do_time = times.nome_do_time));

/*Criação da tabela Patrocinadores; O "id_do_patrocinador" é a chave primária, "nome_do_patrocinador" é o nome dos patrocinadores, "R$" é o R$, "patrocinio" é 
o quanto as marcas pagam para ser divulgadas.*/
CREATE TABLE patrocinadores (
id_do_patrocinador INT PRIMARY KEY NOT NULL,
nome_do_patrocinador VARCHAR(15) NOT NULL,
R$ VARCHAR(10) NOT NULL,
patrocinio REAL NOT NULL);

/*Uma restirção na tabela partida na coluna "id_do_time_anfitriao" fazendo referencia a tabela times na coluna "id_do_time".*/
ALTER TABLE partida ADD CONSTRAINT FK_PARTIDA_TIMES
FOREIGN KEY (id_do_time_anfitriao) REFERENCES times(id_do_time) ON DELETE RESTRICT;

/*Uma restirção na tabela partida na coluna "id_do_time_visitante" fazendo referencia a tabela times na coluna "id_do_time".*/
ALTER TABLE partida ADD CONSTRAINT FK_PARTIDA_TIMES_VISITANTE
FOREIGN KEY (id_do_time_visitante) REFERENCES times(id_do_time) ON DELETE RESTRICT;

/*Uma restrição na tabela times na coluna */
ALTER TABLE times ADD CONSTRAINT FK_TIMES_PATROCINADORES FOREIGN KEY
(id_do_patrocinador) REFERENCES patrocinadores(id_do_patrocinador) ON DELETE CASCADE;

/**/
ALTER TABLE jogadores ADD CONSTRAINT FK_JOGADORES_HEROIS FOREIGN KEY
(id_do_heroi) REFERENCES herois(id_do_heroi) ON DELETE CASCADE;

/**/
ALTER TABLE jogadores ADD CONSTRAINT FK_JOGADORES_TIMES FOREIGN KEY
(id_do_time) REFERENCES times(id_do_time) ON DELETE CASCADE;

/**/
ALTER TABLE herois ADD CONSTRAINT FK_HEROIS_ITENS FOREIGN KEY
(id_do_iten) REFERENCES itens(id_do_iten) ON DELETE RESTRICT;

/**/
ALTER TABLE vencedor ADD CONSTRAINT FK_VENCEDOR_PARTIDA FOREIGN KEY
(id_da_partida) REFERENCES partida(id_da_partida) ON DELETE CASCADE;

/**/
SELECT id_da_partida, nome_do_time FROM partida RIGHT OUTER JOIN times 
ON times.id_do_time = partida.id_do_time_anfitriao WHERE times.id_do_time LIKE '2%'
GROUP BY nome_do_time ORDER BY id_da_partida DESC;
/**/
SELECT nome_do_jogador FROM jogadores INNER JOIN herois ON 
jogadores.id_do_jogador = herois.id_do_heroi WHERE herois.id_do_heroi 
BETWEEN '67' AND '74' GROUP BY nome_do_jogador ORDER BY id_do_jogador DESC; 
/**/
SELECT COUNT(DISTINCT(id_do_jogador)), nome_do_heroi FROM jogadores RIGHT OUTER JOIN herois 
ON herois.id_do_heroi = jogadores.id_do_jogador WHERE herois.nome_do_heroi LIKE 'L%'
GROUP BY nome_do_heroi ORDER BY nome_do_jogador ASC;
/**/
SELECT id_do_heroi AS usuario_do_iten, nome_do_iten FROM herois INNER JOIN itens 
ON itens.id_do_iten = herois.id_do_heroi WHERE itens.id_do_iten > '70' 
AND itens.id_do_iten < '80' GROUP BY nome_do_heroi ORDER BY preco ASC;
/**/
SELECT patrocinadores.id_do_patrocinador, nome_do_time, nome_do_patrocinador, patrocinio FROM
patrocinadores RIGHT OUTER JOIN times ON times.id_do_time = patrocinadores.id_do_patrocinador WHERE
patrocinadores.patrocinio > 'R$ 40.000,00' AND patrocinadores.patrocinio < 'R$ 90.000,00' GROUP BY
nome_do_patrocinador ORDER BY patrocinio, nome_do_time DESC;
/**/
SELECT id_do_vencedor, vencedor.nome_do_time, premio, dia_da_partida FROM vencedor INNER JOIN times
ON times.nome_do_time = vencedor.nome_do_time INNER JOIN partida ON partida.id_da_partida = 
vencedor.id_da_partida ORDER BY dia_da_partida ASC ;
/**/
SELECT nome_do_heroi, nome_do_iten, preco FROM herois INNER JOIN itens 
ON itens.id_do_iten = herois.id_do_heroi ORDER BY preco ASC;
/**/
SELECT nome_do_jogador, nome_do_heroi FROM jogadores RIGHT OUTER JOIN herois ON 
jogadores.id_do_jogador = herois.id_do_heroi WHERE jogadores.nome_do_jogador LIKE '%a'
ORDER BY nome_do_jogador, nome_do_heroi ASC;

/**/
SELECT SUM(patrocinio/2) AS SD FROM patrocinadores WHERE id_do_patrocinador > '24';
/**/
SELECT MIN(patrocinio) AS subtracao22_23 FROM patrocinadores WHERE id_do_patrocinador BETWEEN 
'22' AND '23';
/**/
SELECT AVG(patrocinio) AS media FROM patrocinadores;
/**/
SELECT MAX(patrocinio) AS careiro FROM patrocinadores;
/**/
SELECT SUM(preco) AS custo FROM itens WHERE preco > '2.000';
/**/
SELECT MIN(preco) AS Mcusto FROM itens;
/**/
SELECT AVG(preco) AS media FROM itens;

/**/
CREATE VIEW primeiro_dia AS SELECT * FROM partida WHERE dia_da_partida = '10/04/2022';
SELECT * FROM primeiro_dia;
/**/
CREATE VIEW item_mais_caro AS SELECT * FROM itens WHERE preco > '2000';
SELECT * FROM item_mais_caro;
/**/
CREATE VIEW patrocinio_mais_caro AS SELECT MAX(patrocinio) FROM patrocinadores;
SELECT * FROM patrocinio_mais_caro;
/**/
CREATE VIEW id_do_ganhador AS SELECT id_do_vencedor FROM vencedor WHERE premio >= 'R$ 25.000,00';
SELECT * FROM id_do_ganhador;	
/**/
CREATE VIEW campeoes AS SELECT nome_do_heroi FROM herois WHERE herois.nome_do_heroi LIKE '%a';
SELECT * FROM campeoes;

/**/
START TRANSACTION;
INSERT INTO itens VALUES
('75', 'cajador ilulu', '1780'),
('76', 'teto preto', '1444'),
('77', 'chão branco', '13'),
('78', 'corato', '3445');
SAVEPOINT itens1;
ROLLBACK TO itens1;
/**/
INSERT INTO itens VALUES
('79', 'kokelube', '10'),
('80', 'bango mango', '1234');
SAVEPOINT itens2;
ROLLBACK TO itens2;
/**/
INSERT INTO itens VALUES
('81', 'placa de muro', '1123'),
('82', 'tijolo cinza', '3442'),
('83', 'mascote', '6657');
SAVEPOINT itens3;
ROLLBACK TO itens3;
/**/
INSERT INTO itens VALUES
('84', 'luz do éther', '3765');
SAVEPOINT itens4;
ROLLBACK TO itens4;
/**/
INSERT INTO itens VALUES
('85', 'aurora de sangue', '5000'),
('86', 'celeste preto', '4334'),
('87', 'pá de corte', '99'),
('88', 'bolachinha', '234'),
('89', 'gelato', '467');
SAVEPOINT itens5;
ROLLBACK TO itens5;

/**/
CREATE USER amaral@localhost;
CREATE USER gilberto@localhost IDENTIFIED BY '7227422';
CREATE USER jordana@localhost IDENTIFIED BY 'tuctuc';

ALTER USER amaral@localhost IDENTIFIED BY 'balalal';
ALTER USER jordana@localhost PASSWORD EXPIRE;

USE mysql;
SELECT * FROM USER;
SELECT * FROM mysql.user WHERE user LIKE 'amaral@localhost';

/**/
DROP USER amaral@localhost;
DROP USER gilberto@localhost;
DROP USER jordana@localhost;

/**/
GRANT ALL ON DOTA2.primeiro_dia TO amaral@localhost;
GRANT ALL ON DOTA2.item_mais_caro TO amaral@localhost;
GRANT ALL ON DOTA2.patrocinio_mais_caro TO amaral@localhost;
GRANT ALL ON DOTA2.id_do_ganhador TO amaral@localhost;
GRANT ALL ON DOTA2.campeoes TO amaral@localhost;
/**/
GRANT INSERT ON DOTA2.partida TO gilberto@localhost;
GRANT INSERT ON DOTA2.herois TO gilberto@localhost;
GRANT INSERT ON DOTA2.itens TO gilberto@localhost;
GRANT INSERT ON DOTA2.jogadores TO gilberto@localhost;
GRANT INSERT ON DOTA2.patrocinadores TO gilberto@localhost;
GRANT INSERT ON DOTA2.times TO gilberto@localhost;
GRANT INSERT ON DOTA2.vencedor TO gilberto@localhost;
/**/
GRANT SELECT ON DOTA2.partida TO jordana@localhost;
GRANT SELECT ON DOTA2.herois TO jordana@localhost;
GRANT SELECT ON DOTA2.itens TO jordana@localhost;
GRANT SELECT ON DOTA2.jogadores TO jordana@localhost;
GRANT SELECT ON DOTA2.patrocinadores TO jordana@localhost;
GRANT SELECT ON DOTA2.times TO jordana@localhost;
GRANT SELECT ON DOTA2.vencedor TO jordana@localhost;


USE mysql;
SHOW TABLES;

SELECT * FROM USER;
DESCRIBE USER;

USE mysql;
SELECT * FROM USER;

SELECT * FROM partida;
SELECT * FROM times;
SELECT * FROM jogadores;
SELECT * FROM herois;
SELECT * FROM itens;
SELECT * FROM vencedor;
SELECT * FROM patrocinadores;
