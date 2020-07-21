--1. Criar um bloco PL/SQL anônimo para imprimir a tabuada abaixo: 8x1 ..8x10
SET SERVEROUT ON
DECLARE 
contador NUMBER;
resultado NUMBER;
BEGIN
    FOR contador IN 1..10 
        LOOP
        resultado := 8 *  contador;
        DBMS_OUTPUT.PUT_LINE('8 X ' ||contador|| ' = '|| resultado);
        END LOOP;
END;

/*
    2. Criar um bloco PL/SQL anônimo para imprimir as tabuadas abaixo:
    5 X 1 = 5
    5 X 2 = 10
    ...
    11 X 9 = 99
    11 X 10 = 1100
*/

SET SERVEROUTPUT ON 
DECLARE 
vcontador1 NUMBER;
vcontador2 NUMBER;
vresultado NUMBER;
BEGIN
    FOR vcontador1 IN 5..11
        LOOP
        DBMS_OUTPUT.PUT_LINE('TABUADA DO '||vcontador1);
        DBMS_OUTPUT.PUT_LINE(' ---- ');
        
            FOR vcontador2 IN 1..10
                LOOP 
                    vresultado := vcontador1 * vcontador2;
                    DBMS_OUTPUT.PUT_LINE(vcontador1 || ' X ' ||vcontador2 ||' = ' ||vresultado);
                END LOOP;
             DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;    
END;


/*
    3. Criar um bloco PL/SQL para apresentar os anos bissextos entre 2040 e 2100.
    Um ano será bissexto quando for possível dividi?lo por 4, 
    mas não por 100 ou quando for possível dividi?lo por 400.
*/

SET SERVEROUTPUT ON
DECLARE
v_contador NUMBER;
v_ano NUMBER;

BEGIN
    FOR v_contador IN 2040 .. 2100
        LOOP
            IF (MOD(v_contador, 4) = 0) AND (MOD(v_contador, 100) != 0) THEN
                DBMS_OUTPUT.PUT_LINE(v_contador ||' é Bisesto');
            ELSIF (MOD(v_contador, 4) != 0) AND (MOD(v_contador, 400) != 0) THEN
                DBMS_OUTPUT.PUT_LINE(v_contador||' não é Bisesto');
            ELSE 
                DBMS_OUTPUT.PUT_LINE(v_contador ||' é Bisesto');
            END IF;                
        END LOOP;
END;


/*
4. Criar um bloco PL/SQL para atualizar a tabela abaixo, conforme segue:
Produtos categoria Amora deverão ser reajustados em 15%
Produtos categoria Beringela deverão ser reajustados em 20%
Produtos categoria Couve-Flor deverão ser reajustados em 30%
PRODUTO
------------------------
CODIGO CATEGORIA VALOR
------------------------
1001 Amora 17.53
1002 Beringela 42.15
1003 Couve-Flor 26.98
*/

SET SERVEROUTPUT ON
DECLARE 
v_categoria TBL_PRODUTO.categoria%TYPE;
v_valor TBL_PRODUTO.valor%TYPE;
v_reajuste NUMBER;

    CURSOR cprodutos IS
        SELECT UPPER(categoria),
        valor
        FROM TBL_PRODUTO
    FOR UPDATE OF valor;
        BEGIN 
            OPEN cprodutos;
            LOOP 
            FETCH cprodutos INTO v_categoria, v_valor;
            EXIT WHEN cprodutos%NOTFOUND;
            IF v_categoria = 'AMORA' THEN
                v_reajuste :=  0.15;
            ELSIF v_categoria = 'BETERRABA' THEN
                v_reajuste := 0.20;
            ELSE 
                v_reajuste := 0.30;
            END IF;
            UPDATE TBL_PRODUTO
            SET valor = valor + (valor * v_reajuste)
            WHERE CURRENT OF cprodutos;
    END LOOP;
    CLOSE cprodutos;
END;     
        
SELECT UPPER(categoria),valor FROM TBL_PRODUTO;


/*
 5. Criar um bloco PL/SQL
para imprimir a sequência de Fibonacci: 1 1 2 3 5 8 13 21 34 55
*/

SET SERVEROUTPUT ON
DECLARE
v_anterior NUMBER := 0;
v_atual NUMBER := 1;
v_proximo NUMBER;
v_situacao BOOLEAN;
BEGIN
    v_situacao := TRUE;
    
    WHILE v_situacao 
    LOOP 
         DBMS_OUTPUT.PUT_LINE(v_atual);
            
        v_proximo := v_anterior + v_atual;
        v_anterior := v_atual;
        v_atual := v_proximo;
        
        EXIT WHEN v_atual > 55;
    END LOOP;
END;

/*
    6. Criar uma procedure que deverá receber o código de um produto e a partir deste dado
imprimir o nome do produto, e seu descritivo. Os dados deverão ser obtidos a partir de uma
tabela chamada PRODUTO com as
seguintes colunas (COD_PRODUTO,NOM_PRODUTO,DES_PRODUTO). Exemplo:
PRODUTO
-----------------------------------------------
COD_PRODUTO NOM_PRODUTO DES_PRODUTO
-----------------------------------------------
40 COLCHOES MARCA DE LUXO PURO MACIO
-----------------------------------------------
*/


CREATE TABLE PRODUTO (
    COD_PRODUTO NUMBER,
    NOM_PRODUTO VARCHAR2(50),
    DES_PRODUTO VARCHAR2(100)
);

INSERT INTO PRODUTO VALUES(
    40,'Colchoes', 'Marca de luxo Puro Macio'
);

CREATE OR REPLACE PROCEDURE USP_CONSULTA_DADOS
(
    P_COD IN OUT NUMBER,
    P_NOME OUT VARCHAR2,
    P_DESC OUT VARCHAR2
)
AS
BEGIN
    SELECT COD_PRODUTO, NOM_PRODUTO, DES_PRODUTO INTO P_COD,P_NOME,P_DESC
    FROM PRODUTO
    WHERE COD_PRODUTO = P_COD;
END;

SET SERVEROUTPUT ON
DECLARE
V_COD NUMBER:= 40;
V_NOME VARCHAR2(50);
V_DESC VARCHAR2(100);
BEGIN
    USP_CONSULTA_DADOS(V_COD, V_NOME, V_DESC);
    DBMS_OUTPUT.PUT_LINE(V_COD ||' -- '||V_NOME|| ' -- '||V_DESC);
END;

/*
7. Criar uma procedure que receberá os dados de alunos com as seguintes informações:
(COD,NOME,N1,N2,N3,N4). A partir destes valores deverá efetuar o cálculo da média somand
o o maior valor entre N1 e N2 às notas N3 e N4 e dividindo o valor obtido por três (achando a
média). Se a média for menor que 6 (seis) o aluno estará REPROVADO e se a média for
igual ou superior a 6 (seis) o aluno estará APROVADO. A procedure deverá inserir os
valores acima numa tabela denominada ALUNO com
as seguintes colunas COD,NOME,N1,N2,N3,N4,MEDIA,RESULTADO. Exemplo:
ALUNO
--------------------------------------------------------
COD NOME N1 N2 N3 N4 MEDIA RESULTADO
--------------------------------------------------------
456 FERNANDO DOS SANTOS 8 5.7 8.3 6.8 9.5 APROVADO
*/

CREATE TABLE TBL_ALUNO (
    COD NUMBER,
    NOME VARCHAR2(50),
    N1 NUMBER, 
    N2 NUMBER,
    N3 NUMBER,
    N4 NUMBER,
    MEDIA NUMBER,
    RESULTADO VARCHAR2(50)
);

DROP TABLE TBL_ALUNO;

CREATE OR REPLACE PROCEDURE USP_CALCULO_MEDIA
(
    P_COD IN OUT NUMBER,
    P_NOME IN OUT VARCHAR2,
    P_N1 IN OUT NUMBER, 
    P_N2 IN OUT NUMBER,
    P_N3 IN OUT NUMBER,
    P_N4 IN OUT NUMBER,
    P_MEDIA OUT NUMBER,
    P_RESULTADO OUT VARCHAR2
)
AS
BEGIN
    IF P_N1 > P_N2 THEN
        P_MEDIA := (P_N1 + P_N3 + P_N4) / 3;
    ELSE 
        P_MEDIA := (P_N2 + P_N3 + P_N4) / 3;
    END IF;
    IF P_MEDIA >= 6 THEN
        P_RESULTADO := 'APROVADO';
    ELSE 
        P_RESULTADO := 'REPROVADO';
    END IF;
    INSERT INTO TBL_ALUNO (
            COD, NOME, N1,N2,N3,N4,MEDIA,RESULTADO
            ) VALUES (P_COD, P_NOME, P_N1,P_N2,P_N3,P_N4,P_MEDIA,P_RESULTADO);
    
END;

SET SERVEROUTPUT ON
DECLARE
    V_COD NUMBER := 459;
    V_NOME VARCHAR2(50) := 'Marcios';
    V_N1 NUMBER := 3.7;
    V_N2 NUMBER := 3.8;
    V_N3 NUMBER := 6.8;
    V_N4 NUMBER := 6.5;
    V_MEDIA NUMBER;
    V_RESULTADO VARCHAR2(50);
BEGIN
    usp_calculo_media(V_COD,V_NOME,V_N1, V_N2, V_N3, V_N4, V_MEDIA, V_RESULTADO);
    
END;
SELECT * FROM TBL_ALUNO;


/*
8. Criar uma procedure que receberá o CÓDIGO de um PRODUTO. A partir deste dado deverá
consultar uma tabela denominada PRODUTO e verificar
a que CATEGORIA o produto pertence. Com base nesta informação deverá informar qual o val
or (em Reais) do IPI consultando para isso uma tabela denominada ALIQUOTA. As tabelas PRO
DUTO e ALIQUOTA estão parcialmente representadas a seguir:
PRODUTO
-----------------------
COD_PRO VALOR COD_CAT
-----------------------
6756 1220.00 INICIAL
6785 1550.00 SUPERIOR
-----------------------
ALIQUOTA
---------------
COD_CAT IPI
---------------
INICIAL 17
SUPERIOR 25
---------------
*/

CREATE TABLE PRODUTO 
(
    cod_produto NUMBER, 
    valor NUMBER,
    cod_cat VARCHAR2(30)
);

CREATE TABLE ALIQUOTA
(
    cod_cat VARCHAR2(30),
    ipi NUMBER
);

INSERT INTO PRODUTO 
VALUES (6756, 1220.00, 'INICIAL');
INSERT INTO PRODUTO 
VALUES(6785, 1550.00, 'SUPERIOR');
INSERT INTO ALIQUOTA 
VALUES('INICIAL', 17);
INSERT INTO ALIQUOTA 
VALUES('SUPERIOR', 25);

CREATE OR REPLACE PROCEDURE SP_CONSULTA_IPI
(
    P_COD_PRODUTO IN NUMBER,
    P_IPI OUT NUMBER,
    P_VALOR OUT NUMBER
)
AS 
BEGIN
    SELECT a.ipi, p.valor INTO P_IPI, P_VALOR
    FROM PRODUTO P 
    JOIN
    ALIQUOTA A 
    ON P.cod_cat = a.cod_cat
    WHERE COD_PRODUTO =  P_COD_PRODUTO;
    P_VALOR := p_valor + (p_valor * p_ipi /100);    
END;

SET SERVEROUTPUT ON
DECLARE 
v_cod NUMBER;
v_ipi NUMBER;
v_valor NUMBER;

BEGIN 
    SP_CONSULTA_IPI(6756,v_ipi, v_valor);
    v_cod := 6756;
    DBMS_OUTPUT.PUT_LINE('Codigo: '||v_cod||' - IPI: '||v_ipi|| ' - Valor com IPI: '||v_valor);
    SP_CONSULTA_IPI(6785,v_ipi, v_valor);
    v_cod := 6785;
    DBMS_OUTPUT.PUT_LINE('Codigo: '||v_cod||' - IPI: '||v_ipi|| ' - Valor com IPI: '||v_valor);
END;

/*
9. Uma empresa oferece um bônus a seus funcionários com base no lucro liquido (tabela
LUCRO) obtido durante o ano e no valor do salário do funcionário (tabela SALARIO). O bônus é
calculado conforme a
seguinte formula: BONUS = LUCRO * 0.01 + SALARIO * 0.05. Crie uma procedure que receba o
ano (tabela LUCRO) e número de matricula do funcionário e devolva (imprima) o valor do seu
respectivo bônus.
LUCRO
-----------------
ANO VALOR
-----------------
2010 1670000
2012 1550000
2013 1420000
-----------------
SALARIO
-----------------
MATRICULA VALOR
-----------------
1010 4600
1102 9200
-----------------
*/

CREATE TABLE TBL_LUCRO 
(
    ANO NUMBER, 
    VALOR NUMBER
);

CREATE TABLE TBL_SALARIO
(
    MATRICULA NUMBER,
    VALOR NUMBER
);

INSERT INTO TBL_LUCRO 
VALUES(2010, 167000);
INSERT INTO TBL_LUCRO
VALUES(2012, 155000);
INSERT INTO TBL_LUCRO
VALUES(2013, 142000);


INSERT INTO TBL_SALARIO
VALUES(1010, 4600);
INSERT INTO TBL_SALARIO
VALUES(1102, 9200);

CREATE OR REPLACE PROCEDURE SP_CALCULA_BONUS
(
    P_ANO IN NUMBER,
    P_MATRICULA IN NUMBER,
    P_LUCRO OUT NUMBER,
    P_SALARIO OUT NUMBER,
    P_BONUS OUT NUMBER
)
AS
BEGIN
    SELECT  VALOR INTO P_LUCRO FROM TBL_LUCRO
    WHERE ANO = P_ANO;
    SELECT VALOR INTO P_SALARIO FROM TBL_SALARIO
    WHERE MATRICULA = P_MATRICULA;
        
    P_BONUS := ((P_LUCRO * 0.01) + (P_SALARIO * 0.05));
    
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Ano ou Matricula não encontrado!');
        
END;

SET SERVEROUTPUT ON
DECLARE
V_BONUS NUMBER;
V_LUCRO NUMBER;
V_SALARIO NUMBER;   
BEGIN
    SP_CALCULA_BONUS(2010, 1102,V_LUCRO, V_SALARIO, V_BONUS);
    DBMS_OUTPUT.PUT_LINE('Bônus: '||V_BONUS);
END;


/*
10. Criar uma função que deverá receber um número inteiro e retornar se o mesmo é primo
ou não. (Lembrete: Números primos são divisíveis somente por eles mesmos e por um).
*/

CREATE OR REPLACE FUNCTION FC_PRIMO(P_PRIMO NUMBER)
RETURN VARCHAR2
IS
P_CONT NUMBER := 0;
P_MSG VARCHAR2(50);
BEGIN
    FOR A IN 1.. P_PRIMO
        LOOP
            IF (MOD(P_PRIMO,A) = 0) THEN
                P_CONT := P_CONT + 1;
            END IF;
        END LOOP;
        IF P_CONT > 2 THEN
            P_MSG := 'não é um número primo';
            RETURN P_MSG;
        ELSE 
            P_MSG := 'é um número primo';
            RETURN P_MSG;
        END IF;
END;

SET SERVEROUTPUT ON
DECLARE
V_MSG VARCHAR(50);
V_NUMERO NUMBER;
BEGIN
    V_NUMERO := 97;
    SELECT FC_PRIMO(V_NUMERO) INTO V_MSG FROM DUAL;
    DBMS_OUTPUT.PUT_LINE(V_NUMERO||' '||V_MSG);
END;

/*
    11. Criar uma função que deverá receber um valor correspondente
    à temperatura em graus Fahrenheit e retornar o equivalente em graus Celsius.
    Fórmula para conversão: C = (F ? 32) / 1.8
*/

CREATE OR REPLACE FUNCTION FC_CONVERTE_TEMP (P_FAH NUMBER)
RETURN NUMBER
IS
P_CELSIUS NUMBER;
BEGIN 
    P_CELSIUS := (P_FAH - 32) / 1.8;
    RETURN P_CELSIUS;
    EXCEPTION   WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Insira um número');
END;

SET SERVEROUTPUT ON
DECLARE
V_TEMP NUMBER;
BEGIN 
    SELECT FC_CONVERTE_TEMP(55) INTO V_TEMP FROM DUAL;
    DBMS_OUTPUT.PUT_LINE(V_TEMP);
END;

/*
12. Criar uma função que deverá receber o número de matrícula de um funcionário
e retornar o seu nome e o nome de seu departamento, conforme as seguintes tabelas:
FUNCIONARIO
-----------------------------
MATRICULA NOME COD_DEPTO
-----------------------------
1560 CARLOS ALELUIA 1
1580 PEDRO SEIXAS 2
1590 SANDRO DIAS 1
-----------------------------
-----------------------------
DEPARTAMENTO
-----------------------------
COD_DEPTO NOME_DEPTO
-----------------------------
1 COMPUTACAO
2 ESTATÍSTICA
-----------------------------
*/

CREATE OR REPLACE FUNCTION FC_ENCONTRA_FUNC(P_MATRICULA NUMBER)
RETURN VARCHAR2
IS
P_NOME VARCHAR2(30);
P_DPTO VARCHAR(30);
P_RETORNO VARCHAR(50);
BEGIN
    SELECT F.NOME, D.NOME_DPTO INTO P_NOME, P_DPTO
    FROM 
    TBL_FUNCIONARIO F
    JOIN
    TBL_DEPARTAMENTO D
    ON F.COD_DPTO = D.COD_DPTO
    WHERE MATRICULA = P_MATRICULA;
    P_RETORNO := CONCAT(CONCAT(P_NOME ,' - '),P_DPTO);
    RETURN P_RETORNO;
    EXCEPTION WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Funcionário não encontrado');
END;

SET SERVEROUTPUT ON
DECLARE
V_RETORNO VARCHAR2(50);
BEGIN
    SELECT FC_ENCONTRA_FUNC(1560) INTO V_RETORNO FROM DUAL;
    DBMS_OUTPUT.PUT_LINE(V_RETORNO);
END;

/*
13. Criar uma trigger para implementar uma restrição para que o salário do funcionário 
(ver tabela a seguir) não possa ser reduzido.
FUNCIONARIO
-----------------------------
MATRICULA NOME SALARIO
-----------------------------
1001 HILTON DOUGLAS 3500
1002 STEPHANIE SANTOS 4800
1003 BRUNO UOSHINTON 7500
-----------------------------
*/

CREATE OR REPLACE TRIGGER TG_ALTERA_SALARIO
BEFORE UPDATE
ON TBL_FUNCIONARIO
FOR EACH ROW
BEGIN 
    IF (:NEW.salario < :OLD.salario) THEN
        RAISE_APPLICATION_ERROR(-20301, 'Salário não pode ser reduzido!');
    END IF;
END;

SELECT * FROM TBL_FUNCIONARIO;

UPDATE tbl_funcionario
SET salario = 3000
WHERE matricula = 1001;


/*
    14. Criar uma trigger para impedir que o salário do funcionário seja 
    reajustado acima de 20%(vinte por cento). 
    Utilize como base a mesma tabela do exercício anterior.

*/

CREATE OR REPLACE TRIGGER TG_ALTERA_SALARIO_20
BEFORE UPDATE
ON TBL_FUNCIONARIO
FOR EACH ROW
DECLARE v_salario NUMBER;
BEGIN
    v_salario := :OLD.salario * 0.20;
    IF (:NEW.salario - :OLD.salario > v_salario) THEN
        RAISE_APPLICATION_ERROR(-20331, 'O Reajuste é muito alto!');
    END IF;
END;

SELECT * FROM TBL_FUNCIONARIO;

UPDATE TBL_FUNCIONARIO
SET SALARIO = 10000
WHERE MATRICULA = 1001;

-- 15

CREATE TABLE TBL_EMPRESA 
(
    Id_empresa NUMBER PRIMARY KEY NOT NULL,
    Des_empresa VARCHAR2(50),
    Des_endereco VARCHAR(50)
);

CREATE TABLE TBL_REGIAO 
(
    Id_regiao NUMBER PRIMARY KEY NOT NULL,
    Des_regiao VARCHAR2(50),
    Des_estado VARCHAR2(50)
);

CREATE TABLE TBL_RECEITA 
(
    Id_receita NUMBER PRIMARY KEY NOT NULL,
    Id_empresa NUMBER,
    Id_regiao NUMBER,
    Val_receita NUMBER,
    CONSTRAINT FK_REGIAO_EMPRESA FOREIGN KEY (id_empresa)
    REFERENCES TBL_EMPRESA(Id_empresa),
    CONSTRAINT FK_RECEITA_REGIAO FOREIGN KEY (Id_regiao)
    REFERENCES TBL_REGIAO(Id_regiao)
);
--15.2
INSERT INTO TBL_EMPRESA
VALUES(1, 'Alimentos S.A', 'Rua da forca');
INSERT INTO TBL_EMPRESA
VALUES(2, 'Sandalias S.A', 'Rua das alcateias');
INSERT INTO TBL_EMPRESA
VALUES(3, 'Fernandes LTDA', 'Rua das acácias');
INSERT INTO TBL_EMPRESA
VALUES(4,'Sousa e Sousa LTDA', 'Rua da flórida');

SELECT * FROM TBL_EMPRESA;

INSERT INTO TBL_REGIAO 
VALUES(1, 'Nordeste', 'Bahia');
INSERT INTO TBL_REGIAO 
VALUES(2, 'Sul', 'Rio Grande do Sul');
INSERT INTO TBL_REGIAO 
VALUES(3, 'Sudoreste', 'São Paulo');

SELECT * FROM TBL_REGIAO;

INSERT INTO TBL_RECEITA
VALUES (1,1,1,1500);
INSERT INTO TBL_RECEITA
VALUES (2,1,1,4500);
INSERT INTO TBL_RECEITA
VALUES (3,4,3,3000);
INSERT INTO TBL_RECEITA
VALUES (4,3,2,7000);
INSERT INTO TBL_RECEITA
VALUES (5,4,1,9000);

SELECT * FROM TBL_RECEITA;

--15.3.1) todas as descrições das empresas da tabela empresa.
SELECT Des_empresa FROM TBL_EMPRESA;
--15.3.2) todas as regiões da tabela região.
SELECT Des_regiao FROM TBL_REGIAO;
--15.3.3) todas os registros da tabela região onde estado=Bahia.
SELECT Id_regiao, Des_regiao, Des_estado
FROM TBL_REGIAO
WHERE Des_estado = 'Bahia';
--15.3.4) todas os registros da tabela Receita onde Receita=3000.
SELECT Id_receita, Id_empresa, Id_regiao, Val_receita
FROM TBL_RECEITA
WHERE Val_receita = 3000;
--15.3.5) todas os registros da tabela Receita onde Receita>3000.
SELECT Id_receita, Id_empresa, Id_regiao, Val_receita
FROM TBL_RECEITA
WHERE Val_receita > 3000;
--15.3.6) todas os registros da tabela Receita onde Receita<3000.
SELECT Id_receita, Id_empresa, Id_regiao, Val_receita
FROM TBL_RECEITA
WHERE Val_receita < 3000;
--15.3.7) Contar todos os registros da tabela Receita onde Receita=3000.
SELECT COUNT(Id_receita)
FROM TBL_RECEITA
WHERE Val_receita = 3000;
 -- 15.3.8) Listar os registros da tabela Regiao
 --apenas as 3 primeiras letras do campo des_regiao.
 SELECT Id_Regiao, Des_regiao, SUBSTR(Des_estado,0,3) FROM TBL_REGIAO;
 --15.3.9) Listar os registros da tabela Receita, 
 --cujo a descrição da empresa contenha a palavra ‘usa’.
 SELECT r.*
 FROM TBL_RECEITA r
 JOIN 
 TBL_EMPRESA e
 ON r.id_empresa = e.Id_empresa
 WHERE e.Des_empresa LIKE '%usa%';
 
 --15.3.10) Listar os registros da tabela região em ordem crescente de des_regiao.
 SELECT * 
 FROM TBL_REGIAO 
 ORDER BY Des_regiao ASC;
 
 --15.3.12) Somar os registros da tabela Receita e agrupar por região.
 SELECT SUM(rc.VAL_RECEITA)
 FROM TBL_RECEITA rc
 JOIN 
 TBL_REGIAO rg
 ON rc.ID_REGIAO = rg.ID_REGIAO
 GROUP BY rg.Des_regiao;
 
 --15.3.13) Fazer a união das tabelas Receita,Região e Empresa
 --e listar as empresas da tabela Empresa, regiões da tabela Região
 --e a receita da tabela Receita.
 
 SELECT Des_empresa
 FROM TBL_EMPRESA
 UNION 
 SELECT Des_regiao
 FROM TBL_REGIAO
 UNION 
 SELECT SUBSTR(Val_receita,0,5)
 FROM TBL_RECEITA
 
 --15.3.14) Alterar o tamanho do campo des_regiao da tabela região de char(10) para char(30).
 ALTER TABLE TBL_REGIAO
 MODIFY DES_REGIAO VARCHAR2(30);
 
 -- 15.3.15) criar um índice para a tabela Receita
 --com os campos ide_receita e val_receita juntos.
CREATE INDEX receita_idx ON TBL_RECEITA(id_receita, val_receita);

SELECT id_receita, val_receita
FROM TBL_RECEITA;

--15.3.16) Criar uma visão da tabela Receita,
--apenas contendo o campo des_empresa, cujo as receitas sejam maiores que 2000.
CREATE OR REPLACE VIEW VW_RECEITA_2000 
AS
SELECT e.Des_empresa, r.val_receita
FROM TBL_RECEITA r
JOIN 
TBL_EMPRESA e
ON
r.Id_empresa = e.id_empresa
WHERE r.VAL_RECEITA > 2000;

SELECT * FROM vw_receita_2000;

-- 15.3.17) Eliminar os registros da tabela Receita ,
--cujo os valores sejam maiores que 9000.
DELETE FROM TBL_RECEITA
WHERE VAL_RECEITA > 9000;

/*15.3.18) liste os campos da tabela Receita que mostrem o seguinte conteúdo na tela.
15.18.1)
Nord ------ Bah ------ 1500
Nord ------ Bah ------ 4500
Nord ------ Bah ------ 9000
*/
SET SERVEROUTPUT ON
DECLARE
v_regiao TBL_REGIAO.des_regiao%TYPE;
v_estado TBL_REGIAO.des_estado%TYPE; 
v_receita TBL_RECEITA.val_receita%TYPE;
CURSOR creceita IS
    SELECT rg.des_regiao, rg.des_estado, r.val_receita
    FROM TBL_RECEITA r
    JOIN 
    TBL_REGIAO rg
    ON r.id_regiao = rg.id_regiao
    WHERE rg.des_regiao = 'Nordeste';
BEGIN
OPEN creceita;
LOOP
    FETCH creceita INTO v_regiao, v_estado, v_receita;
    EXIT WHEN creceita%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(SUBSTR(v_regiao,0,4)||' --- ' ||SUBSTR(v_estado,0,3)|| ' --- ' || v_receita);
END LOOP;
CLOSE creceita;
END;

/*
15.18.2)
Sousa e Sousa LTDA ---- > LTDA
Fernandes LTDA ---- > LTDA
Sousa e Sousa LTDA ---- > LTDA
*/

SET SERVEROUTPUT ON
DECLARE 
v_nome TBL_EMPRESA.des_empresa%TYPE;

CURSOR cempresa IS
    SELECT e.des_empresa
    FROM TBL_RECEITA r
    JOIN 
    TBL_EMPRESA e
    ON r.id_empresa = e.id_empresa
    WHERE e.des_empresa LIKE '%LTDA';

BEGIN
OPEN cempresa;
LOOP 
    FETCH cempresa INTO v_nome;
    EXIT WHEN cempresa%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_nome||' ---> ' ||SUBSTR(v_nome, -4));
END LOOP;
CLOSE cempresa;
END;


