CREATE TABLE TB_TREINAMENTO (   
        "ID" NUMBER(5) NOT NULL,
        "NOME" VARCHAR(10),
        "SEXO" CHAR(1)
    );
    
INSERT INTO tb_treinamento(ID, NOME) VALUES (1, 'GRIMALDO');

ALTER TABLE TB_TREINAMENTO ADD CONSTRAINT CK_TREINA_SEXO CHECK( SEXO in ('M', 'F')) ENABLE;

ALTER TABLE TB_TREINAMENTO ADD CONSTRAINT PK_TREINAMENTO PRIMARY KEY (ID) ENABLE;

ALTER TABLE TB_TREINAMENTO
    RENAME CONSTRAINT SYS_C007047
    TO  PK_TREINAMENTO_CT;

ALTER TABLE TB_TREINAMENTO DROP CONSTRAINT PK_TREINAMENTO_CT;

DROP TABLE TB_TREINAMENTO;

/* ------------------------------------------------- */

ALTER TABLE TB_LIVRO DROP CONSTRAINT FK_LIVRO_EDITORA;

ALTER TABLE TB_LIVRO ADD CONSTRAINT FK_LIVRO_EDITORA FOREIGN KEY ("ID_EDITORA")
REFERENCES "ALUNO"."TB_EDITORA" ENABLE;

SELECT L.TITULO,
        E.DESCRICAO
FROM TB_LIVRO L   INNER JOIN
TB_EDITORA E
ON l.id_editora = e.id_editora

-- AULA 3

SELECT NOME
FROM TB_AUTOR 
WHERE SUBSTR(nome, 1,2) = 'Jo';

SELECT * FROM TB_AUTOR
WHERE EXTRACT(DAY FROM DATA_NASCIMENTO) = 10;

SELECT * FROM TB_AUTOR
WHERE EXTRACT(MONTH FROM DATA_NASCIMENTO) = 05;

SELECT NOME,
       EXTRACT(DAY FROM DATA_NASCIMENTO) AS Dia,
       EXTRACT(MONTH FROM DATA_NASCIMENTO) AS Mês,
       EXTRACT (YEAR FROM DATA_NASCIMENTO) AS Ano
FROM TB_AUTOR
WHERE NOME LIKE '%c%'


SELECT nome, case sexo
                WHEN 'M' THEN 'Masculino'
                WHEN 'F' THEN 'Feminino'
                ELSE 'Sexo Inválido'
            END
FROM TB_AUTOR;


--- AGREGAÇÃO

SELECT COUNT(*) FROM   
TB_LIVRO l
JOIN TB_LIVRO_AUTOR la
ON l.id_livro = la.id_livro
WHERE UPPER(l.titulo) = 'BANCO DE DADOS'

SELECT SUM(l.preco),
TO_CHAR(AVG(l.preco), '9999.99'), 
MIN(l.preco),
MAX(l.preco)
FROM TB_LIVRO l 

SELECT ed.descricao,
       COUNT(*)
FROM TB_LIVRO l
JOIN 
TB_EDITORA ed 
ON l.id_editora = ed.id_editora
GROUP BY ed.descricao

SELECT l.titulo,
count(l.titulo)

FROM TB_LIVRO l
JOIN 
TB_LIVRO_AUTOR la
ON l.id_livro = la.id_livro
GROUP BY l.titulo
HAVING COUNT(*) > 1

-- UNION
SELECT 
    nome,
    sexo
FROM 
    TB_AUTOR
UNION all
SELECT
    nome,
    sexo
FROM
    TB_FUNCIONARIO
    
SELECT nome
    FROM TB_AUTOR
MINUS
SELECT nome
FROM TB_FUNCIONARIO

SELECT nome
    FROM TB_AUTOR
INTERSECT
SELECT nome
FROM TB_FUNCIONARIO


--------- OPERAÇÕES LÓGICAS

SELECT l.titulo,
    l.preco
FROM TB_LIVRO l
    WHERE
        l.preco >= (
            SELECT AVG(preco)
                FROM TB_LIVRO
                )

SELECT a.nome
FROM TB_AUTOR a
WHERE a.id_autor IN
    (
        SELECT la.id_autor
        FROM TB_LIVRO_AUTOR la
            
    );

SELECT a.nome
FROM TB_AUTOR a
WHERE a.id_autor NOT IN
    (
        SELECT la.id_autor
        FROM TB_LIVRO_AUTOR la
        JOIN 
        TB_LIVRO l
        ON la.id_livro = l.id_livro
        WHERE 
        UPPER(l.titulo) = 'BANCO DE DADOS' 
    )
    
    
SELECT a.nome
FROM TB_AUTOR a
WHERE NOT EXISTS(
    SELECT * 
    FROM TB_LIVRO_AUTOR la
    WHERE a.id_autor = la.id_autor

)

-- AUTO RELACIONAMENTO (HIERANQUIZAÇÃO)

SELECT sigla,
       level,
       sys_connect_by_path(sigla,',') caminho
FROM 
TB_LOTACAO 
    START WITH id_lotacao_pai IS NULL
    CONNECT BY NOCYCLE PRIOR id_lotacao = id_lotacao_pai;
    
-- VIEW

CREATE VIEW VW_LIVRO_AUTOR
AS
    SELECT l.titulo,
    a.nome 
    FROM TB_AUTOR a
    JOIN
    TB_LIVRO_AUTOR la
    ON a.id_autor = la.id_autor
    JOIN 
    TB_LIVRO l
    ON l.id_livro = la.id_livro

SELECT * FROM VW_LIVRO_AUTOR    