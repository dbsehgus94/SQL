--8�� PL/SQL�� ������ ������� ���� ����

--���
--PL/SQL �ҽ� ���α׷��� �⺻������ ����̶�� �Ѵ�.
--�����(IS(AS)), �����(BEGIN), ���� ó����(EXCEPTION)�� �����ȴ�.
--�̸��� ���� ���(�͸� ���), �̸��� �ִ� ���(�Լ�, ���ν���, ��Ű��)

/*
�̸���
IS(AS)
�����
BEGIN
�����
EXCEPTION
���� ó����
END;
*/

--�̸��� : ����� ��Ī�� ���µ�, ������ ���� �͸����� �ȴ�.

--����� : DECLARE�� ���۵Ǹ�, ����ο� ���� ó���ο��� ����� ���� ����, ���, Ŀ�� ���� �����Ѵ�.
--���� �����̳� ����ο� ���� ó���ο��� ����ϴ� ���� ������ ���� �ݵ�� ;�� �����Ѵ�.
--����� ������ ����� ���ٸ� ����θ� ������ �� �ִ�.

--����� : ���� ���� ó�� �κ�, �� �κп��� ���� ����(�Ϲ�, ����, �ݺ��� ��)�� �� �� �ִ�.
--������ SQL���� �� DDL���� ����� �� ���� DML���� ��밡���ϴ�. ������ ;�� �ٿ��� �Ѵ�.

--���� ó���� : ����ο��� ������ ó���ϴٰ� ������ �߻��ϸ� ó���� ������ ����ϴ� �κ�(���� ����)
--PL/SQL�� ������ �ڵ� ������ ���� ������ ��Ÿ��(�������) ������ ������.
--���� ó���ο����� ������ ��Ÿ�� ������ ���Ѵ�.

--�͸� ���(�̸��� ���� ���)
--DECLARE ������ ����ο��� ����� ������ �����ߴ�.(;�ʼ�)
--vi_num�̶� NUMBER�� ������ �����ߴµ�, PL/SQL���� ���� �Ҵ��� �ٸ� ���α׷��� ���� �޸� ��ȣ(=)�� �ƴ� ':='�̴�.
--Ư�� ������ ':='�� �������� ������ ���� ���ʿ� �Ҵ��Ѵٴ� ���̴�.
--BEGIN���� ���۵Ǵ� ����ο����� vi_num ������ 100�� �Ҵ��ϰ� ����, DBMS_OUTPUT.PUT_LINE�̶� �Լ��� �Ű������� �� ������ �����ߴ�.
--DBMS_OUTPUT�� ������ ��ȣ �ȿ� �ִ� �Ű����� ���� ����ϴ� ����� ���� �ִٰ� �˾Ƶ���.

--�͸� ��� ����
DECLARE
    vi_num NUMBER;
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
    END;
/
--����κ��� �� ���� ���� 100�� ��µǾ��µ�, ���� ���� �α׿� �� SQL PLUS�� �����ϰ� �ٽ� �����Ѵٸ�
--SET SERVEROUTPUT ON�̶� ��ɾ �ٽ� �����ؾ� ��� ����� �� �� �ִ�.
--SQL PLUS �󿡼� PL/SQL ����� �������� �� �� �ҿ�ð��� �˰� �ʹٸ�, SET TIMING ON ��ɾ �����ϸ� �ȴ�.
--SQL PLUS������ �������� /�� �ٿ��� ������ ������ SQL DEVELOPER������ /�� ���� �ʾƵ� �ȴ�.
--���� ����� Ȯ���Ϸ��� [����-DBMS ���] �޴��� �����ϰ� ��� â�� ������ ���λ� +�� Ŭ���Ͽ� ����ϴ� USER�� �����ϸ� �ȴ�.

----�͸� ��� ���� 2
SET SERVEROUTPUT ON
SET TIMING ON
DECLARE
    vi_num NUMBER;
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END;
/

--PL/SQL �������
--����(�ٸ� ���α׷��� ���� ����ϴ� ������ ������ ����.)
--����ο��� ���� ������ �ϰ� ����ο��� ����Ѵ�.
--���� ������ -> ������ ������Ÿ�� := �ʱ갪;
--���� ����� ���ÿ� �ʱ갪�� �Ҵ��� �� �ִµ�, �ʱ갪�� �Ҵ����� ������ ������ Ÿ�Կ� ������� �� ������ �ʱ갪�� NULL�� �ȴ�.
--����ο����� ���� �ϰ� ����ο��� �ʱ갪�� �Ҵ��� ���� �ִ�.

--PL/SQL ������ Ÿ��
--BOOLEAN Ÿ�� : ���� ������ �������� �Ǻ�(TRUE, FALSE, NULL)
--BINARY_INTEGER = PLS_INTEGER
--PLS_INTEGER : NUMBER���� ���� ���������� ���� ������ �� �����Ѵ�.
--PLS_INTEGER ���� Ÿ��
/*
NATURAL              PLS_INTEGER �� ���� ���� (0 ����)
NATURALN            PLS_INTEGER �� ���� �����ε� NULL �Ҵ� �Ұ�, �ݵ�� ���� �� �ʱ�ȭ �ʿ�
POSITIVE              PLS_INTEGER �� ��� (0 ������)
POSITIVEN            PLS _INTEGER �� ������� NULL �Ҵ� �Ұ�, �ݵ�� ���� �� �ʱ�ȭ �ʿ�
SIGNTYPE             PLS_INTEGER �� -1, 0, 1
SIMPLE_INTEGER  PLS_INTEGER �� NULL�� �ƴ� ��� ��, �ݵ�� ���� �� �ʱ�ȭ �ʿ�
*/

--���(������ �޸� �ѹ� ���� �Ҵ��ϸ� ������ �ʴ´�.)
--����� CONSTANT ������Ÿ�� := �����;

--������
/*
** (����������)
+, - (��� ���� �ĺ� ������)
*, / (����, ������)
+, -, || (����, ����, ���ڿ� ���� ������)
=, <, >, <=, >=, <>, !=, ~=, ^=, IS NULL, LIKE, BETWEEN, IN (�� ������)
NOT (�� ������)
AND (�� ������)
OR (�� ������)
*/

--������ ����
DECLARE
    a INTEGER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a= ' || TO_CHAR(a));
END;
/
--�ּ�(--, /*�� */)
--�ּ� ����
DECLARE
    --�� �� �ּ�, ���� ����
    a INTEGER := 2**2*3**2;
BEGIN
    /* �����
        DBMS_OUTPUT�� �̿��� ���� �� ���
    */
    DBMS_OUTPUT.PUT_LINE('a= ' || TO_CHAR(a));
END;
/
--DML��
--PL/SQL ����� �ۼ��ϴ� ������ ������ ���̺� �� �ִ� �����͸� �̸����� �����ؼ� Ư�� ������ ���� ���𰡸� ó���ϴ� ��
--�� ���뿡 ���� �ַ� ���Ǵ� ���� SQL�������� SQL�� �� DDL�� PL/SQL�󿡼� ���� �� �� ����(�ƿ� �ȵǴ� �� �ƴ�) DML���� ��� ����.

--���̺� �ִ� �����͸� ������ ������ �Ҵ��� ���� SELECT ������ INTO���� ����Ѵ�.
--�� �� �����ϴ� �÷��� ���� ������ ����, ����, ������ Ÿ���� �ݵ�� ���� ��� �Ѵ�.

--DML�� ����
DECLARE
    vs_emp_name VARCHAR2(80);    --����� ����
    vs_dep_name VARCHAR2(80);    --�μ��� ����
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a,
              departments b
  WHERE a.department_id = b.department_id
       AND a.employee_id = 100;
       
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dep_name);
END;
/
--%TYPE Ű���带 ���� �ش� ������ �÷� Ÿ���� �ڵ����� �����´�.
--������ ���� Ÿ���� ã�� ���ŷο� �����ϰ� ������ Ÿ���� �߸� ������ ���赵 ���� �� �ִ�.
--DML�� ���� 2
DECLARE
    vs_emp_name employees.emp_name%TYPE;
    vs_dep_name departments.department_name%TYPE;
BEGIN
    SELECT a.emp_name, b.department_name
    INTO vs_emp_name, vs_dep_name
    FROM employees a,
              departments b
  WHERE a.department_id = b.department_id
       AND a.employee_id = 100;
       
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || ' - ' || vs_dep_name);
END;
/
--PRAGMA(�����Ϸ��� ����Ǳ� ���� ó���ϴ� ��ó���� ����)
--PRAGMA�� ����ϸ� �����Ϸ��� ��Ÿ�� ���ʹ� �ٸ� ����� ������ �����Ѵ�.
--������ �Ҷ� ������ ó���϶�� �����Ϸ����� �����ϴ� ������ �ϴµ�, PL/SQL ����� ����ο� ����ؾ� �Ѵ�.
-- 1. PRAGMA AUTONOMOUS_TRANSACTION
--Ʈ����� ó���� ����ϴµ�, ��� ���ο��� �����ͺ��̽��� ������ �����ϻ����� COMMIT�̳� ROLLBACK �϶�� ���ÿ����� �Ѵ�.
-- 2. PRAGMA EXCEPTION_INIT(���ܸ�, ���ܹ�ȣ)
--����� ���� ���� ó���� �Ҷ� ���, Ư�� ���ܹ�ȣ�� ����Ͽ� �����Ϸ��� �� ���ܸ� ����Ѵٴ� ���� �˸��� ����.
-- 3. PRAGMA RESTRICT_REFERECES(���� ���α׷���, �ɼ�)
-- ����Ŭ ��Ű���� ����� �� ������ ������ ��Ű���� ���� ���� ���α׷����� �ɼ� ���� ���� Ư�� ������ ������ �� ����.
-- 4. PRAGNA SERIALLY_RESUABLE
-- ��Ű�� �޸� ������ ���� �� �������� ���Ǹ�, ��Ű���� ����� ������ ���� �� �� ȣ��� �� �޸𸮸� ������Ŵ.
-- �ɼ��� �����ϸ� ��Ű�� ������ ���� �Ҵ��ϴ��� ���� ���� ȣ���� �� �ش� ������ �ʱ�ȭ ���̳� NULL ���� �ȴ�.

--��
--PL/SQL ���α׷� �󿡼� Ư�� �κп� �̸��� �ο�
--<<�󺧸�>> ���·� ���
--GOTO���� �԰� ���Ǿ� �ش� �󺧷� ����� �̵� ����
--GOTO �󺧸�;

--���������� ������ ���̰� �ʹ� ��ϴ�.(byte�� 4000 �ʰ��̱� ������)
CREATE TABLE ch08_varchar2(
    var1 varchar2(5000));
    
 --���̺� ���� ����   
CREATE TABLE ch08_varchar2(
    var1 varchar2(4000));

--�� ���� �� Ŀ��
INSERT INTO ch08_varchar2 (var1)
VALUES ('tQbADHDjqtRCvosYCLwzbyKKrQCdJubDPTHnzqvjRwGxhQJtrVbXsLNlgeeMCemGMYpvfoHUHDxIPTDjleABGoowxlzCVipeVwsMFRNzZYgHfQUSIeOITaCKJpxAWwydApVUlQiKDgJlFIOGPOKoJsoemqNbOLdZOBcQhDcMLXuYjRQZDIpgpmImgiwzcLkSilCmLrSbmFNsKEEpzCHDylMvkYPKPNeuJxLvJiApNCYzrMcflECbxwNTKSxaEwVvCYnTnFfMFgDqxobWcSmMJrNTQIVOeWlPaMTfRHsrlFSukppmljmOojPSgJiSbQcgtWWOwUNNYFGtgCGBsIcTGAiHWBxtYVXecoJgJCAJptIVmVTZSKliRLoPYTIUpksBuQaqFHLhCkosWChoMjbqgLtBIRBynsKjKiLrdeHVvZanNVElDjLWwlCDhbpsAVQMTzjzhoKIJBdthynMBMVjeNmsKAjdAYhPZKmuKOuMloQdkqPjoKbfjDEeATciMrXiMQorMhYmBlMODBbyLLIkbmtZdPcWGSuxFEUwXnWpvnunEgcLelSneRIpgRNTzTkHqgLbpxoHzCYgSWlIAvKljCnmWiPWGGwlUFOudRSdoqUxntyhNYEiVXtMObywEltTImawnElpmeiWwlTjGTFceqyjhNqiDLxwduubykWzDmFSJNvVvDZibrCpAReqQjlQZcxuVqjKGKvoDuEcQPQeDzmdMYSOTIQdPDNfDffCOUWflHSQhvVTiYumBQIoyznWNITGZkefknJpGEutUnhBgLPQTWTBeTYccqlLrxvRjfJpdpfVDqqfKCngemIEDDHNdvBxCqKDTrrJAumXMKgpWLIHctQuACeNaKnffpYXiioLxZDrxpuZPPUGpRsCtoQuBfogkKuusVATkMyajKTPSyTQbfhZepRjNdrhkymqKvsAcThYbMSMnkKcLWFPAMeGysBVKkQtFMPvRBoDszlSZcMYzwxkKQwJnuVnDxShYiHFlzgDWqhZoqeypyFVBNDtHkiVzHkQisYLbsbVneJyHbHdtaIFLVbfTqbkGQTEjFlPiGUddPUIoLWALrbKcLwBizwhJvaXkvOphcGWpdNAhxgehCvjcQFSFhxrBuANKjyWncWAUpKKJcfQCsQlLfpqdMhjWGkAMMWUaDfCrGtmtkiIZOdNapEnvfFKiHAhBhejgKSuyKXFQXyCaLwwvonHsceJKgjtnYVZvBCYYBSqNCqVqCGewootJJsqrCnmiteMZBbyMPnIrdcielnGUYmwiOPmEqKGvxDmDRTDRumnSRcnvgxLbaiQIuzdslEIMquvvwmvgaumqPkduNyfRtXErCPvDYLelhjNNOjbGryRpTtDHxIJebMEtKryUyZRIdADeTEBExwHMRHzAYFizYiesaMhNIsOUzUTmyEMuFQrsUEtjwhUWIvADNlrcxPZwRazPMMvdVZssmXbXuCkRoPYNGLPwUmrWrrIgQoMSGMPvTcbHnbtleyKYmOMgymANQBZDMoqAOzMHrAVunIiykCudFVNObNgXOoyfQRICbFsWygSZXufipvrWWmRnBWYdoKmIRewOObUjiNDdQsxQIXtlbPSSngfQPfeQKOolVASXIuAmeODKtSOPaEaFKcedGzzsbrPlsPnRRuYFeVdhyufpjFVVrTPczSQkmPYXercLMmVEaDmJXKTqEVNSKeOshDCDJwdINFsLhAuKIIfOdjSEndDwumQLvePVjzNoIfUELOANeshoNgwVhFADjtUIjIhQAIyRnzSoxSRSWklITMgdjQZTthwsnBVLWyfSsAdLzOnEqmMCGBlTYGjtqvKbBoATRwkPkOTSbUhZClVzjiLLIFEMuptuodeRKXUaBfUhVTtasFsZdVnKtEfLldJYsxjlrBADRqhEBEmBKxlXKgEhiKcwAdztcETMUteJwadfaZLEBRjwJOGaIMhsfAxtuBQWyQLGXPDlFQmkcMsKsGUlQBEAubDqbuBYqXLZgmhPftLkYaCYGReLCVXssOxzJFJwnxKJzaaYzfVpbHYBtiBeQZRilJZqrrMTrVtYAcwGxAAddwtlxzdZebfZHjzqRmrrBPNbkVHqjCHtVKUjIDPVSrtyEsPRPoyyPOFOSBcgClTzlAIPmPMkdlpFHctzKGpyQMInMwPKojVErCOrHbCsZoEXqyOcHReSybmxwYabyioVnDxPEvskutVHLWQTNudmKICoaoSGKqONrBmvtGNBKAaJxCRKTDOIqrJOsQVOmGxmuIDEddVYvDwILTyushOAiXbkRIKgNLnFJdOagmiOHKRBKIIkxkOUeZWMRNlqpJdFgKjrGhIzrgBtgjVOtZAskKRbqzRVwLUoUAtRpRkoRQNLIrbLmmjZTugXJBNCscnMguKVAFDKpODtCsmdlBvQGALeBGUitYBxLYhJxeVcAnTWmTAvCITzdzqiBfEudEIBmkDAXIFmoOmsTMZDOnhXYrgMDlDbjednYWWJbGhrXFrxMQmQSmRBwoOqWGbGmjZNlJCvSHvmtZUkIScWXVdfSsdvdyQNpGFIOuteXhCMLmmEHrMucEmFbCIOHTJINAuIUOPfAfijIPkZjppGCCSRJNXWNCmliwUgABkHWuelUWeLsyVKVcZWOSeiQBQibCQJQUgGkTrXZxdBLsgjeMIwOyORDBpywuvlrLScRNhvaCYaKKRvOZeqBebUWWFhNnIRJvedFNfFPgWZJgNRaUpyYWFNiXJfAqNjyCEQYwAdFBQKKolwrufmJOfrToJFEsoNjaphcNvfWGIjKrKZSoSJEsbRqNVcoprpcGrnBgcNAnWUFpRldcPJkPfaoLKRCmVyMAWMXmnScodKisCTqllZEWQQSCFETxLNntgdcFEFRsTSIhuewwrHIlOeCcRqkzgQhKnKyHZHdFsMEKvPywLbjaspVxUMEkVzCGcGoTmaBjUMwJuAYdSTaYGDHHWDrvGgMVTtehpzfgofkmqtamffJbCKOzJgPsHNEnFarjADJGyKLwwitCiBXIraUdZtZwNjUtGbWqxksepVYztIBrimByoYQfUQgOndzFmhnuSmhYWvHliWUHgbvBIkYasDElNsjcCLtMvjQEhJjWvlnAscPwOYfelrfgfRAZGBxdFlMNkfYEWLbkfUhbRPHoDZsaAQdoKhAAWzOcHoAkkHPQMNIxgHNJaqEFBqCuMYEtLpMnIiMCWWEPnBYgYrxlXFGYpQWUNFevwcEUvUzDeSZNrdmahAfjeLSAGjHVnqyTzJkiVXjDJXzOiszXQCErQwwDMMqjLxWebJwNAVdrXeyMDRYXmLMDnuWLVaShVGhlgvbjOdOnhCDTNVazYDnzstqxjOuWbLcDaavRumKUOQXBQwKtdFgOzXiQKWFporrIcylIHlTmTKAIpBqNUbkajLTlwAHieCcqPIJYhegwQhWpYZdfxpQXDKtYzsrmnvdiTKgXfXKlIHPHlxQtqXGhMVPOBAKVZJfkrDNEwnQFwgfoHJSqQxTzRswVLrtFgpVzKcLilgznElWUfhERyeUrCcFCuGJddlFHJrXsqRdUjqUwaBmJVNwjRbCFiVMOSFuNctNVzhmhUpoddsMPUFMvNIMsMjHIWYiLjhSajZqpDkMvUOUCbYKfNHGpdUeWGUtDXHDNSCEXqYrhWhvnISnjfoBMCwwptksarPImRZaRxBMjoBdlmRGlIuQZDzCLnxxioATnGVFFTATUpeypOCaCeJAvPLxEXYzlCgXvXirGSZFyZPPSCdOSHxeELRsetFrWgqPNNpwgbgBEYPOSpLWeVdqOxPaQnidyPVMmELzeJPWgNsWBdPJPjhkdGpeAYZfrBNqdbOwzbtLiWMPafjgWQNcWKqmcleWLcMJoGSAEIUyFuzElZKXonHOMDdGMtSKEFUWdfPfnDecKNhIjAKRYmkXgpPAzlKIOpViZPkZdozzAoWwDnXkfDikvkXcQaoBtzKkcRhNpJRYaGTkdnlfotsJZsLqpYaWoK');
COMMIT;

drop table ch08_varchar2;

--PL/SQL���� ����� VARCHAR2 Ÿ���� �ִ� ���̸� ���캸��.
--PL/SQL������ VARCHAR2 Ÿ���� ������ ������ 4000BTYE �̻��� ���� ���� ���� �� �ִ�.
DECLARE
    vs_sql_varchar2     varchar2(4000);
    vs_plsql_varchar2   varchar2(32767);
BEGIN

    --ch08_varchar2 ���̺��� ���� ������ ��´�.
    SELECT VAR1
    INTO vs_sql_varchar2
    FROM ch08_varchar2;
    
    --PL/SQL ������ 4000 BYTE �̻� ũ���� ���� �ִ´�.
    vs_plsql_varchar2 := vs_sql_varchar2 || ' - ' || vs_sql_varchar2 || ' - ' || vs_sql_varchar2;
    
    -- �� ���� ũ�⸦ ����Ѵ�.
    DBMS_OUTPUT.PUT_LINE('SQL VARCHAR2 ���� : ' || LENGTHB(vs_sql_varchar2));
    DBMS_OUTPUT.PUT_LINE('PL/SQL VARCHAR2 ���� : ' || LENGTHB(vs_plsql_varchar2));
END;
/