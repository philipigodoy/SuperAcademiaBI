/*SEGUNDA PARTE DO TREINAMENTO DE ORACLE -- PL/SQL */

SET SERVEROUTPUT ON 
DECLARE
vsalario NUMBER;
vpercaumento NUMBER;
vtotalsalario NUMBER;

BEGIN
    vsalario := 2500.00;
    vpercaumento := vsalario * 0.30 ;
    vtotalsalario := vsalario + vpercaumento;   
    DBMS_OUTPUT.PUT_line('O novo salário é de :' ||vtotalsalario);

END;


-- EXEMPLO 2

SET SERVEROUTPUT ON 
DECLARE
vsalario number := 4500.00;
vsituacao boolean;
vpercaumento number := vsalario * 0.30;
vtotalsalario number;


BEGIN 
    vsituacao := TRUE;
    IF vsituacao THEN
        vtotalsalario := vsalario + vpercaumento;
        DBMS_OUTPUT.PUT_LINE('O novo salário é de '|| vtotalsalario);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Não houve aumento');
    END IF;
END;


-- EXEMPLO 3

SET SERVEROUTPUT ON
DECLARE

vdata_pgto DATE := '1/07/2020';
vdata_pgto_ajustado DATE; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('A Data de pagamento é '||vdata_pgto);
    
    -- ACRESCENTA 10 DIAS A DATA
    vdata_pgto_ajustado := vdata_pgto + 10;
    DBMS_OUTPUT.PUT_LINE('A Data de pagamento mais 10 dias é '||vdata_pgto_ajustado);
    -- DATA DO SISTEMA
    
    DBMS_OUTPUT.PUT_LINE('A Data do sistema é '||sysdate);

    -- DIFERENÇA ENTRE AS DATAS
    DBMS_OUTPUT.PUT_LINE('A diferença entre as datas é  '|| (sysdate - vdata_pgto));
    
    -- FORMATAR NUMERO RETORNADO    
    DBMS_OUTPUT.PUT_LINE('A diferença entre as datas ajustado é '||floor(sysdate-vdata_pgto));
    
END;


-- EXEMPLO 4 DELIMITADORES DE BLOCO
    
SET SERVEROUTPUT ON
<<EXTERNO>>
DECLARE

vsalario number := 2500.00;
vsituacao boolean;
vpercaumento number := 500;
vtotalsalario number;

BEGIN 
    vsituacao := TRUE;
    IF vsituacao THEN
        vtotalsalario := vsalario + vpercaumento;
        DBMS_OUTPUT.PUT_LINE('O novo salário é de '|| vtotalsalario);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Não houve aumento');
    END IF;

    <<INTERNO>>

DECLARE 
vtotalsalario NUMBER := 5000.00;
BEGIN 

vsituacao := TRUE;
    IF vsituacao THEN
        DBMS_OUTPUT.PUT_LINE('O novo externo salário é de '|| (EXTERNO.vtotalsalario));
        DBMS_OUTPUT.PUT_LINE('O novo salário é de '|| INTERNO.vtotalsalario);
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Não houve aumento');
    END IF;

    END;

END;

-- EXEMPLO IF ELSE 

SET SERVEROUTPUT ON
DECLARE 
vsalario NUMBER := 4500.00;
vpercaumento NUMBER := vsalario * 0.30;
vtotalsalario NUMBER;
vsituacao BOOLEAN;
BEGIN 
    vsituacao := FALSE;
    IF vsituacao THEN
    vtotalsalario := vsalario + vpercaumento;
    DBMS_OUTPUT.PUT_LINE('O Salario com TRUE é de ' ||vtotalsalario);
    ELSE 
        IF vsalario > 4000.00 THEN
        vtotalsalario := vsalario;
        ELSE 
        vsalario := vsalario - 1000;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Salario no ELSE é '||vsalario);
    END IF;
END;

-- SQL E PL SQL

SET SERVEROUTPUT ON

DECLARE
vquantidade NUMBER;

BEGIN 
SELECT SUM(quantidade) INTO vquantidade
FROM TB_ITENS_PEDIDO;

CASE 
    WHEN vquantidade <= 200 THEN
    DBMS_OUTPUT.PUT_LINE ('Estoque está baixo, o saldo é de '||vquantidade);
    WHEN vquantidade <= 300 THEN 
    DBMS_OUTPUT.PUT_LINE('Estoque está normal, o saldo é de '|| vquantidade);
    ELSE 
    DBMS_OUTPUT.PUT_LINE('O estoque está em excesso, o saldo é de '||vquantidade);
END CASE;

END;

--LOOP FOR

SET SERVEROUTPUT ON

DECLARE 
vrepeticao NUMBER := 0;
BEGIN 
    LOOP
    vrepeticao := vrepeticao + 1;
    IF vrepeticao > 5 THEN
        EXIT;
    END IF;
    DBMS_OUTPUT.PUT_LINE('REPETIÇÃO: '||vrepeticao);
    END LOOP;
END;


-- WHILE 

SET SERVEROUTPUT ON 

DECLARE

vrepeticao NUMBER := 0;

BEGIN 
    WHILE vrepeticao < 5 LOOP
        vrepeticao := vrepeticao + 1;
        DBMS_OUTPUT.PUT_LINE('REPETIÇÃO: '||vrepeticao);
    END LOOP;
END;

-- FOR

SET SERVEROUTPUT ON 

DECLARE

vrepeticao NUMBER := 0;

BEGIN
FOR vrepeticao IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE('REPETIÇÃO: '||vrepeticao);
END LOOP;
END;

-- EXEMPLO COM NVL

SET SERVEROUTPUT ON 

DECLARE
vidautor INT;
vidautor2 INT;
vnome VARCHAR(50);
vsexo CHAR(1);

BEGIN 
    vidautor := 1;
    vidautor2 := 23;
    vidautor := nvl(vidautor2, vidautor);
    SELECT 
        nome, sexo INTO vnome, vsexo
    FROM  TB_AUTOR
    WHERE 
    id_autor = vidautor;
    
DBMS_OUTPUT.PUT_LINE('Nome e sexo do autor: '||vnome ||' ----- '||vsexo);
END;


-- CURSORES

SET SERVEROUTPUT ON

DECLARE 

vid_autor TB_AUTOR.id_autor%TYPE;
vnome TB_AUTOR.nome%TYPE;
vsexo TB_AUTOR.sexo%TYPE;

BEGIN
    vid_autor := 1;
    
    SELECT nome,sexo
    INTO vnome,vsexo
    FROM TB_AUTOR
    WHERE id_autor = vid_autor;
    
    DBMS_OUTPUT.PUT_LINE('Nome e Sexo do Autor: '||vnome ||' ---- '||vsexo);

END;


-- ROWTYPE

SET SERVEROUTPUT ON
DECLARE
vreg_autor TB_AUTOR%ROWTYPE;


BEGIN
    vreg_autor.id_autor := 1;
    
    SELECT nome,sexo
    INTO 
    vreg_autor.nome,
    vreg_autor.sexo
    FROM TB_AUTOR
    WHERE id_autor = vreg_autor.id_autor;
    
    DBMS_OUTPUT.PUT_LINE('Nome e Sexo do Autor: '||vreg_autor.nome ||' ---- '||vreg_autor.sexo);

END;

-- ROWID

SET SERVEROUTPUT ON 
DECLARE
vrowid ROWID;

BEGIN
    SELECT ROWID
    INTO vrowid
    FROM 
    TB_EDITORA
    WHERE
    UPPER(descricao) = 'CAMPUS';
    
DBMS_OUTPUT.PUT_LINE('O endereço da editora é: '||vrowid);
    
END;

SET SERVEROUTPUT ON 
BEGIN
UPDATE 
TB_LIVRO 
SET preco = preco * 1.05
WHERE preco >= 10;
IF (SQL%NOTFOUND) THEN
DBMS_OUTPUT.PUT_LINE('Não ouve alteração ');
ELSE 
DBMS_OUTPUT.PUT_LINE('A quantidade de linhas alteradas foi '||SQL%ROWCOUNT);
END IF;
END;

COMMIT;
-- CURSOR COM FOR

SET SERVEROUTPUT ON 

DECLARE

vreglivros TB_LIVRO%ROWTYPE;

CURSOR clivros IS
SELECT l.*
FROM TB_LIVRO l
JOIN
TB_EDITORA e
ON l.id_editora = e.id_editora
WHERE
UPPER(e.descricao) = 'CAMPUS';

BEGIN
FOR vreglivros IN clivros
LOOP
    DBMS_OUTPUT.PUT_LINE('Titulo e preço dos livros: '||vreglivros.titulo||' - '||vreglivros.preco|| ' - ' ||vreglivros.isbn);
END LOOP;
END;
-- FOR COMO CURSOR

SET SERVEROUTPUT ON 
DECLARE
vreglivros TB_LIVRO%ROWTYPE;
BEGIN
FOR vreglivros IN
    (SELECT l.* 
    FROM TB_LIVRO l
    JOIN
    TB_EDITORA e
    ON l.id_editora = e.id_editora
    WHERE UPPER(e.descricao) = 'CAMPUS')
LOOP
DBMS_OUTPUT.PUT_LINE('Titulo e preço dos livros: '||vreglivros.titulo||' - '||vreglivros.preco);
END LOOP;
END;

-- FOR UPDATE OF/ WHERE CURRENT OF 

SET SERVEROUTPUT ON
DECLARE

vpreco TB_LIVRO.preco%TYPE;
vdescricao TB_EDITORA.descricao%TYPE;
vreajuste NUMBER;

CURSOR clivros IS
SELECT 
    l.preco,
    UPPER(e.descricao)
FROM TB_LIVRO l
JOIN 
TB_EDITORA e
ON l.id_editora = e.id_editora
FOR UPDATE OF l.preco; ----
BEGIN 
OPEN clivros;
    LOOP
FETCH clivros INTO vpreco, vdescricao;
EXIT WHEN clivros%NOTFOUND;
    IF vdescricao = 'CAMPUS' THEN
        vreajuste := 5;
    ELSE 
        vreajuste := 10;
    END IF;
UPDATE TB_LIVRO SET preco = preco +(preco * vreajuste/100) 
WHERE CURRENT OF clivros; ----
    END LOOP;
CLOSE clivros;
END;

-- TRATAMENTO DE ERRO EXCEPTION
SET SERVEROUTPUT ON
DECLARE
vvalor1 NUMBER := 100;
vvalor2 NUMBER := 0;

BEGIN 
vvalor1 := vvalor1/ vvalor2;

EXCEPTION 
WHEN ZERO_DIVIDE THEN
DBMS_OUTPUT.PUT_LINE('Não pode divisão por ZERO!');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Um erro desconhecido ocorreu');
END;


-- OUTROS TIPOS DE ERRO
SET SERVEROUTPUT ON
DECLARE
vvalor NUMBER;

BEGIN
SELECT preco INTO vvalor 
FROM TB_LIVRO
WHERE id_livro IN (10);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('A consulta não retornou nenhum registro');
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('A consulta retornou mais de um registro');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Um erro não tratato ocorreu');
END;

-- dois BEGIN
SET SERVEROUTPUT ON 
DECLARE
vnome VARCHAR(50);
vsexo CHAR(1);

BEGIN
    BEGIN
        SELECT nome, sexo INTO vnome,vsexo
        FROM TB_AUTOR 
        WHERE id_autor IN (3,2);
        EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum registro encontrado');
        WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Mais de um registro encontrado');
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Registro não tratato encontrado');
    END;
DBMS_OUTPUT.PUT_LINE('O Nome e o sexo do autor são: '||vnome||' - '||vsexo);
END;

-- TRATAMENTO DE ERRO COM RAISE

SET SERVEROUTPUT ON
DECLARE
vcodigo NUMBER;
verro VARCHAR2(64);
vdata DATE :=  '01/07/2020';
DATA_INVALIDA EXCEPTION;

BEGIN
    vcodigo := 100/0;
    IF vdata < SYSDATE THEN
    RAISE DATA_INVALIDA;
    END IF;
    EXCEPTION 
    WHEN DATA_INVALIDA THEN
    DBMS_OUTPUT.PUT_LINE('Data Inválida');
    WHEN OTHERS THEN
    vcodigo := SQLCODE;
    verro := SUBSTR(SQLERRM,1,64);
    DBMS_OUTPUT.PUT_LINE('Erro: '||vcodigo ||' - '||verro);
END;


-- RAISE APLICATION ERROR

SET SERVEROUTPUT ON
DECLARE
vdata DATE := '01/07;2020';

BEGIN 
    IF vdata < SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20100, 'Data anterior a data do servidor!');
    END IF;
END;
    
-- PROCEDURES
CREATE OR REPLACE PROCEDURE SP_INICIO
(
    pparam1 IN NUMBER,
    pparam2 IN OUT NUMBER,
    pparam3 OUT NUMBER
)
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Valores dentro da procedure(1): '||pparam1||' - '||pparam2|| ' - '||pparam3 );
    pparam2 := pparam1 * 2;
    pparam3 := pparam1 *3;
    DBMS_OUTPUT.PUT_LINE('Valores dentro da procedure(2): '||pparam1||' - '||pparam2|| ' - '||pparam3 );
END;


SET SERVEROUTPUT ON

DECLARE
vparam1 NUMBER := 500;
vparam2 NUMBER := 600;
vparam3 NUMBER := 200;

BEGIN
    SP_INICIO(vparam1,vparam2,vparam3);
    DBMS_OUTPUT.PUT_LINE('Valores fora da procedure: '||vparam1||' - '||vparam2|| ' - '||vparam3);

END;

-- PROCEDURES ANINHADAS

CREATE OR REPLACE PROCEDURE AREA_RETANGULO
(
    pbase IN NUMBER,
    paltura IN NUMBER,
    parea OUT NUMBER
)
AS
BEGIN
parea := pbase * paltura;
END;

CREATE OR REPLACE PROCEDURE SP_CALCULA_AREA
AS
    varea NUMBER;
BEGIN
AREA_RETANGULO(2,4,varea);
DBMS_OUTPUT.PUT_LINE('A Area do retângulo é '||varea);
END;

SET SERVEROUTPUT ON
EXEC SP_CALCULA_AREA;

-- FUNCTIONS
CREATE OR REPLACE FUNCTION FC_CALCULA_AREA_RETANGULO
(
    pbase NUMBER,
    paltura NUMBER DEFAULT 4
)
RETURN NUMBER
AS
varea NUMBER;
BEGIN
    varea := pbase * paltura;
    RETURN varea;
END;

SELECT FC_CALCULA_AREA_RETANGULO(2,5) FROM DUAL;
SELECT FC_CALCULA_AREA_RETANGULO(2) FROM DUAL;


-- PROCEDURE E FUNCAO JUNTOS

CREATE OR REPLACE PROCEDURE SP_CALCULA_AREA2
AS
varea NUMBER;
BEGIN
    varea := FC_CALCULA_AREA_RETANGULO(2,3);
    DBMS_OUTPUT.PUT_LINE('Area da figura é '||varea);
END;

EXEC sp_calcula_area2;

-- FUNCTION MANIPULAR TABELAS DO BANCO

CREATE OR REPLACE FUNCTION FC_ELEVA_PRECO
(
ppreco NUMBER
)
RETURN NUMBER
AS
BEGIN
    RETURN ppreco * ppreco;
END;

SELECT 
    titulo, preco, FC_ELEVA_PRECO(preco)
FROM TB_LIVRO;

-- TRIGGERS

CREATE OR REPLACE TRIGGER TG_AUTOR
BEFORE INSERT OR UPDATE
ON TB_AUTOR
FOR EACH ROW

DECLARE vidade NUMBER;
BEGIN
vidade := EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM :NEW.data_nascimento);
IF (vidade = 16) AND (EXTRACT(MONTH FROM SYSDATE) > EXTRACT(MONTH FROM :NEW.data_nascimento)) THEN
    vidade := vidade -1;
END IF;
IF (vidade < 16) THEN
    RAISE_APPLICATION_ERROR(-20301,'O autor tem menos de 16 anos!');
END IF;
END;

 INSERT INTO TB_AUTOR(id_autor, nome, sexo, data_nascimento) 
 VALUES (sq_autor.nextval, 'Fernando', 'M', '23/10/2005');
 
 -- EXEMPLO TRIGGER 2
 CREATE OR REPLACE TRIGGER TR_LIMITE_PEDIDO
 BEFORE INSERT OR UPDATE 
 ON TB_ITENS_PEDIDO
 FOR EACH ROW
 
 DECLARE vvalor_pedido NUMBER;
 
 BEGIN
 SELECT SUM(preco)
 INTO vvalor_pedido
 FROM TB_ITENS_PEDIDO
 WHERE
id_pedido = :NEW.id_pedido;
vvalor_pedido := vvalor_pedido +:NEW.preco;
IF vvalor_pedido > 600 THEN
    RAISE_APPLICATION_ERROR(-20301, 'Valor limite do pedido excedido!');
END IF;
END;

INSERT INTO TB_ITENS_PEDIDO(id_itens_pedido, id_livro, id_pedido, quantidade, preco)
VALUES(sq_itens_pedido.nextval, 1,1,10,350);

-- EXEMPLO TRIGGER 3

CREATE OR REPLACE TRIGGER TR_BAIXA_ESTOQUE
BEFORE INSERT OR UPDATE
ON TB_ITENS_PEDIDO
FOR EACH ROW

BEGIN
UPDATE TB_LIVRO
SET 
    QTDE_ESTOQUE = QTDE_ESTOQUE - :NEW.quantidade
WHERE id_livro = :NEW.id_livro;
END;

INSERT INTO TB_ITENS_PEDIDO VALUES(sq_itens_pedido.nextval, 1,1,10,50);

-- EXEMPLO TRIGGER 3

CREATE OR REPLACE TRIGGER TR_LIMITE_REAJUSTE
BEFORE UPDATE
ON TB_LIVRO
FOR EACH ROW

BEGIN
IF (:NEW.preco >= :OLD.preco * 1.5) THEN
    RAISE_APPLICATION_ERROR(-20301, 'Reajuste não permitido!');
END IF;
END;

UPDATE TB_LIVRO SET preco = 320
WHERE id_livro = 1;

-- EXEMPLO TRIGGER 4

CREATE OR REPLACE TRIGGER TR_TB_LOG_EDITORA
AFTER DELETE
ON TB_EDITORA
FOR EACH ROW

DECLARE voperacao VARCHAR(100);
BEGIN 
voperacao := 'DELECAO DE EDITORA :'||:OLD.descricao;
INSERT INTO TB_LOG VALUES(sq_log.nextval,user,sysdate,voperacao);
END;

INSERT INTO TB_EDITORA VALUES(sq_editora.nextval, 'MOREIRA', 'RUA DA ESPERA');

DELETE
FROM 
TB_EDITORA
WHERE UPPER(descricao) = 'MOREIRA';

SELECT * FROM TB_LOG;

-- PACOTES
CREATE OR REPLACE PACKAGE TREINAMENTO AS
FUNCTION FC_CALCULA_AREA(pbase NUMBER, paltura NUMBER)
RETURN NUMBER;
END;

CREATE OR REPLACE PACKAGE BODY TREINAMENTO AS
FUNCTION FC_CALCULA_AREA(pbase NUMBER, paltura NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN pbase * paltura;
END;
END;

SET SERVEROUTPUT ON 
DECLARE
varea NUMBER;
BEGIN
    varea := TREINAMENTO.FC_CALCULA_AREA(5,4);
    DBMS_OUTPUT.PUT_LINE('A área do quadrado é '||varea || '!');
END;


-- PACOTES 2

CREATE OR REPLACE PACKAGE TREINAMENTO AS
cpi CONSTANT NUMBER := 3.1416;
FUNCTION FC_CALCULAR_AREA(pbase NUMBER, paltura NUMBER)
RETURN NUMBER;
FUNCTION FC_CALCULAR_AREA(praio NUMBER)
RETURN NUMBER;
END;

CREATE OR REPLACE PACKAGE BODY TREINAMENTO AS
FUNCTION FC_CALCULAR_AREA(pbase NUMBER, paltura NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN pbase * paltura;
END;
FUNCTION FC_CALCULAR_AREA(praio NUMBER)
RETURN NUMBER
IS
BEGIN
    RETURN cpi * praio;
END;
END;

SET SERVEROUTPUT ON 
DECLARE
varea NUMBER;
BEGIN
    varea:= TREINAMENTO.FC_CALCULAR_AREA(3);
    DBMS_OUTPUT.PUT_LINE('A area do raio é '||varea || '!');
    varea := TREINAMENTO.FC_CALCULAR_AREA(5,4);
    DBMS_OUTPUT.PUT_LINE('A area do quadrado é '||varea || '!');
END;

-- PACOTES 3
CREATE OR REPLACE PACKAGE TREINAMENTO AS
cpi CONSTANT NUMBER := 3.1416;
FUNCTION FC_CALCULA_AREA(pbase NUMBER, paltura NUMBER)
RETURN NUMBER;
FUNCTION FC_CALCULA_AREA(praio NUMBER)
RETURN NUMBER;
FUNCTION FC_CALCULA_FIGURA(pmedida1 NUMBER, pmedida2 NUMBER)
RETURN NUMBER;
END;

CREATE OR REPLACE PACKAGE BODY TREINAMENTO AS
FUNCTION FC_CALCULA_AREA(pbase NUMBER, paltura NUMBER)
RETURN NUMBER
IS
BEGIN 
    RETURN pbase * paltura;
END;
FUNCTION FC_CALCULA_AREA(praio NUMBER)
RETURN NUMBER
IS 
BEGIN
    RETURN cpi * praio ** 2;
END;
FUNCTION FC_CALCULA_FIGURA(pmedida1 NUMBER, pmedida2 NUMBER)
RETURN NUMBER
IS 
BEGIN
    IF (pmedida2 IS NOT NULL) THEN
    RETURN FC_CALCULA_AREA(pmedida1, pmedida2);
    ELSE
    RETURN FC_CALCULA_AREA(pmedida1);
    END IF;
END;
END;

SET SERVEROUTPUT ON
DECLARE 
varea NUMBER;
BEGIN
    varea := TREINAMENTO.FC_CALCULA_FIGURA(3,null);
    DBMS_OUTPUT.PUT_LINE('A área do circulo é de '||varea|| '!');
    varea := TREINAMENTO.FC_CALCULA_AREA(5,5);
    DBMS_OUTPUT.PUT_LINE('A área do quadrado é de '||varea|| '!');
END;