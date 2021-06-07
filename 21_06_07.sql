--8장 PL/SQL의 구조와 구성요소 살펴 보기

--블록
--PL/SQL 소스 프로그램의 기본단위를 블록이라고 한다.
--선언부(IS(AS)), 실행부(BEGIN), 예외 처리부(EXCEPTION)로 구성된다.
--이름이 없는 블록(익명 블록), 이름이 있는 블록(함수, 프로시저, 패키지)

/*
이름부
IS(AS)
선언부
BEGIN
실행부
EXCEPTION
예외 처리부
END;
*/

--이름부 : 블록의 명칭이 오는데, 생략할 때는 익명블록이 된다.

--선언부 : DECLARE로 시작되며, 실행부와 예외 처리부에서 사용할 각종 변수, 상수, 커서 등을 선언한다.
--변수 선언이나 실행부와 예외 처리부에서 사용하는 각종 문장의 끝에 반드시 ;을 찍어야한다.
--사용할 변수나 상수가 없다면 선언부를 생략할 수 있다.

--실행부 : 실제 로직 처리 부분, 이 부분에는 각종 문장(일반, 조건, 반복문 등)이 올 수 있다.
--하지만 SQL문장 중 DDL문은 사용할 수 없고 DML문만 사용가능하다. 끝에는 ;을 붙여야 한다.

--예외 처리부 : 실행부에서 로직을 처리하다가 오류가 발생하면 처리할 내용을 기술하는 부분(생략 가능)
--PL/SQL의 오류는 코드 컴파일 과정 오류와 런타임(실행과정) 오류로 나뉜다.
--예외 처리부에서의 오류는 런타임 오류를 말한다.

--익명 블록(이름이 없는 블록)
--DECLARE 다음에 실행부에서 사용할 변수를 선언했다.(;필수)
--vi_num이란 NUMBER형 변수를 선언했는데, PL/SQL에서 값의 할당은 다른 프로그래밍 언어와 달리 등호(=)가 아닌 ':='이다.
--특정 변수에 ':='를 기준으로 오른쪽 값을 왼쪽에 할당한다는 뜻이다.
--BEGIN으로 시작되는 실행부에서는 vi_num 변수에 100을 할당하고 나서, DBMS_OUTPUT.PUT_LINE이란 함수의 매개변수로 이 변수를 전달했다.
--DBMS_OUTPUT은 당장은 괄호 안에 있는 매개변수 값을 출력하는 기능을 갖고 있다고만 알아두자.

--익명 블록 예시
DECLARE
    vi_num NUMBER;
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
    END;
/
--실행부분의 맨 끝을 보면 100이 출력되었는데, 만약 현재 로그온 한 SQL PLUS를 종료하고 다시 접속한다면
--SET SERVEROUTPUT ON이란 명령어를 다시 실행해야 출력 결과를 볼 수 있다.
--SQL PLUS 상에서 PL/SQL 블록을 실행했을 때 총 소요시간을 알고 싶다면, SET TIMING ON 명령어를 실행하면 된다.
--SQL PLUS에서는 마지막에 /를 붙여야 실행이 되지만 SQL DEVELOPER에서는 /를 넣지 않아도 된다.
--실행 결과를 확인하려면 [보기-DBMS 출력] 메뉴를 선택하고 출력 창이 나오면 연두색 +를 클릭하여 사용하는 USER에 접속하면 된다.

----익명 블록 예시 2
SET SERVEROUTPUT ON
SET TIMING ON
DECLARE
    vi_num NUMBER;
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END;
/

--PL/SQL 구성요소
--변수(다른 프로그래밍 언어에서 사용하는 변수와 개념이 같다.)
--선언부에서 변수 선언을 하고 실행부에서 사용한다.
--변수 선언방식 -> 변수명 데이터타입 := 초깃값;
--변수 선언과 동시에 초깃값을 할당할 수 있는데, 초깃값을 할당하지 않으면 데이터 타입에 상관없이 그 변수의 초깃값은 NULL이 된다.
--선언부에서는 선언만 하고 실행부에서 초깃값을 할당할 수도 있다.

--PL/SQL 데이터 타입
--BOOLEAN 타입 : 값이 참인지 거짓인지 판별(TRUE, FALSE, NULL)
--BINARY_INTEGER = PLS_INTEGER
--PLS_INTEGER : NUMBER형에 비해 내부적으로 저장 공간을 덜 차지한다.
--PLS_INTEGER 하위 타입
/*
NATURAL              PLS_INTEGER 중 음수 제외 (0 포함)
NATURALN            PLS_INTEGER 중 음수 제외인데 NULL 할당 불가, 반드시 선언 시 초기화 필요
POSITIVE              PLS_INTEGER 중 양수 (0 미포함)
POSITIVEN            PLS _INTEGER 중 양수인테 NULL 할당 불가, 반드시 선언 시 초기화 필요
SIGNTYPE             PLS_INTEGER 중 -1, 0, 1
SIMPLE_INTEGER  PLS_INTEGER 중 NULL이 아닌 모든 값, 반드시 선언 시 초기화 필요
*/

--상수(변수와 달리 한번 값을 할당하면 변하지 않는다.)
--상수명 CONSTANT 데이터타입 := 상수값;

--연산자
/*
** (제곱연산자)
+, - (양수 음수 식별 연산자)
*, / (곱셈, 나눗셈)
+, -, || (덧셈, 뺄셈, 문자열 연결 연산자)
=, <, >, <=, >=, <>, !=, ~=, ^=, IS NULL, LIKE, BETWEEN, IN (비교 연산자)
NOT (논리 연산자)
AND (논리 연산자)
OR (논리 연산자)
*/

--연산자 예시
DECLARE
    a INTEGER := 2**2*3**2;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a= ' || TO_CHAR(a));
END;
/
--주석(--, /*와 */)
--주석 예시
DECLARE
    --한 줄 주석, 변수 선언
    a INTEGER := 2**2*3**2;
BEGIN
    /* 실행부
        DBMS_OUTPUT을 이용한 변수 값 출력
    */
    DBMS_OUTPUT.PUT_LINE('a= ' || TO_CHAR(a));
END;
/
--DML문
--PL/SQL 블록을 작성하는 원래의 목적은 테이블 상에 있는 데이터를 이리저리 가공해서 특정 로직에 따라 무언가를 처리하는 것
--위 내용에 따라 주로 사용되는 것은 SQL문이지만 SQL문 중 DDL은 PL/SQL상에서 직접 쓸 수 없고(아예 안되는 건 아님) DML문만 사용 가능.

--테이블에 있는 데이터를 선택해 변수에 할당할 때는 SELECT 문에서 INTO절을 사용한다.
--이 때 선택하는 컬럼에 따라 변수의 순서, 개수, 데이터 타입을 반드시 맞춰 줘야 한다.

--DML문 예시
DECLARE
    vs_emp_name VARCHAR2(80);    --사원명 변수
    vs_dep_name VARCHAR2(80);    --부서명 변수
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
--%TYPE 키워드를 쓰면 해당 변수에 컬럼 타입을 자동으로 가져온다.
--일일히 변수 타입을 찾는 번거로움도 제거하고 데이터 타입을 잘못 선언할 위험도 없앨 수 있다.
--DML문 예시 2
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
--PRAGMA(컴파일러가 실행되기 전에 처리하는 전처리기 역할)
--PRAGMA를 사용하면 컴파일러는 런타임 떄와는 다른 결과를 내도록 동작한다.
--컴파일 할때 뭔가를 처리하라고 컴파일러에게 지시하는 역할을 하는데, PL/SQL 블록의 선언부에 명시해야 한다.
-- 1. PRAGMA AUTONOMOUS_TRANSACTION
--트랜잭션 처리를 담당하는데, 블록 내부에서 데이터베이스에 가해진 변경하사항을 COMMIT이나 ROLLBACK 하라는 지시역할을 한다.
-- 2. PRAGMA EXCEPTION_INIT(예외명, 예외번호)
--사용자 정의 예외 처리를 할때 사용, 특정 예외번호를 명시하여 컴파일러에 이 예외를 사용한다는 것을 알리는 역할.
-- 3. PRAGMA RESTRICT_REFERECES(서브 프로그램명, 옵션)
-- 오라클 패키지를 사용할 때 선언해 놓으면 패키지에 속한 서브 프로그램에서 옵션 값에 따라 특정 동작을 제한할 때 사용됨.
-- 4. PRAGNA SERIALLY_RESUABLE
-- 패키지 메모리 관리를 쉽게 할 목적으로 사용되며, 패키지에 선언된 변수에 대해 한 번 호출된 후 메모리를 해제시킴.
-- 옵션을 설정하면 패키지 변수에 값을 할당하더라도 다음 번에 호출할 때 해당 변수는 초기화 값이나 NULL 값이 된다.

--라벨
--PL/SQL 프로그램 상에서 특정 부분에 이름을 부여
--<<라벨명>> 형태로 사용
--GOTO문과 함계 사용되어 해당 라벨로 제어권 이동 가능
--GOTO 라벨명;

--데이터형에 지정된 길이가 너무 깁니다.(byte가 4000 초과이기 때문에)
CREATE TABLE ch08_varchar2(
    var1 varchar2(5000));
    
 --테이블 생성 성공   
CREATE TABLE ch08_varchar2(
    var1 varchar2(4000));

--행 삽입 후 커밋
INSERT INTO ch08_varchar2 (var1)
VALUES ('tQbADHDjqtRCvosYCLwzbyKKrQCdJubDPTHnzqvjRwGxhQJtrVbXsLNlgeeMCemGMYpvfoHUHDxIPTDjleABGoowxlzCVipeVwsMFRNzZYgHfQUSIeOITaCKJpxAWwydApVUlQiKDgJlFIOGPOKoJsoemqNbOLdZOBcQhDcMLXuYjRQZDIpgpmImgiwzcLkSilCmLrSbmFNsKEEpzCHDylMvkYPKPNeuJxLvJiApNCYzrMcflECbxwNTKSxaEwVvCYnTnFfMFgDqxobWcSmMJrNTQIVOeWlPaMTfRHsrlFSukppmljmOojPSgJiSbQcgtWWOwUNNYFGtgCGBsIcTGAiHWBxtYVXecoJgJCAJptIVmVTZSKliRLoPYTIUpksBuQaqFHLhCkosWChoMjbqgLtBIRBynsKjKiLrdeHVvZanNVElDjLWwlCDhbpsAVQMTzjzhoKIJBdthynMBMVjeNmsKAjdAYhPZKmuKOuMloQdkqPjoKbfjDEeATciMrXiMQorMhYmBlMODBbyLLIkbmtZdPcWGSuxFEUwXnWpvnunEgcLelSneRIpgRNTzTkHqgLbpxoHzCYgSWlIAvKljCnmWiPWGGwlUFOudRSdoqUxntyhNYEiVXtMObywEltTImawnElpmeiWwlTjGTFceqyjhNqiDLxwduubykWzDmFSJNvVvDZibrCpAReqQjlQZcxuVqjKGKvoDuEcQPQeDzmdMYSOTIQdPDNfDffCOUWflHSQhvVTiYumBQIoyznWNITGZkefknJpGEutUnhBgLPQTWTBeTYccqlLrxvRjfJpdpfVDqqfKCngemIEDDHNdvBxCqKDTrrJAumXMKgpWLIHctQuACeNaKnffpYXiioLxZDrxpuZPPUGpRsCtoQuBfogkKuusVATkMyajKTPSyTQbfhZepRjNdrhkymqKvsAcThYbMSMnkKcLWFPAMeGysBVKkQtFMPvRBoDszlSZcMYzwxkKQwJnuVnDxShYiHFlzgDWqhZoqeypyFVBNDtHkiVzHkQisYLbsbVneJyHbHdtaIFLVbfTqbkGQTEjFlPiGUddPUIoLWALrbKcLwBizwhJvaXkvOphcGWpdNAhxgehCvjcQFSFhxrBuANKjyWncWAUpKKJcfQCsQlLfpqdMhjWGkAMMWUaDfCrGtmtkiIZOdNapEnvfFKiHAhBhejgKSuyKXFQXyCaLwwvonHsceJKgjtnYVZvBCYYBSqNCqVqCGewootJJsqrCnmiteMZBbyMPnIrdcielnGUYmwiOPmEqKGvxDmDRTDRumnSRcnvgxLbaiQIuzdslEIMquvvwmvgaumqPkduNyfRtXErCPvDYLelhjNNOjbGryRpTtDHxIJebMEtKryUyZRIdADeTEBExwHMRHzAYFizYiesaMhNIsOUzUTmyEMuFQrsUEtjwhUWIvADNlrcxPZwRazPMMvdVZssmXbXuCkRoPYNGLPwUmrWrrIgQoMSGMPvTcbHnbtleyKYmOMgymANQBZDMoqAOzMHrAVunIiykCudFVNObNgXOoyfQRICbFsWygSZXufipvrWWmRnBWYdoKmIRewOObUjiNDdQsxQIXtlbPSSngfQPfeQKOolVASXIuAmeODKtSOPaEaFKcedGzzsbrPlsPnRRuYFeVdhyufpjFVVrTPczSQkmPYXercLMmVEaDmJXKTqEVNSKeOshDCDJwdINFsLhAuKIIfOdjSEndDwumQLvePVjzNoIfUELOANeshoNgwVhFADjtUIjIhQAIyRnzSoxSRSWklITMgdjQZTthwsnBVLWyfSsAdLzOnEqmMCGBlTYGjtqvKbBoATRwkPkOTSbUhZClVzjiLLIFEMuptuodeRKXUaBfUhVTtasFsZdVnKtEfLldJYsxjlrBADRqhEBEmBKxlXKgEhiKcwAdztcETMUteJwadfaZLEBRjwJOGaIMhsfAxtuBQWyQLGXPDlFQmkcMsKsGUlQBEAubDqbuBYqXLZgmhPftLkYaCYGReLCVXssOxzJFJwnxKJzaaYzfVpbHYBtiBeQZRilJZqrrMTrVtYAcwGxAAddwtlxzdZebfZHjzqRmrrBPNbkVHqjCHtVKUjIDPVSrtyEsPRPoyyPOFOSBcgClTzlAIPmPMkdlpFHctzKGpyQMInMwPKojVErCOrHbCsZoEXqyOcHReSybmxwYabyioVnDxPEvskutVHLWQTNudmKICoaoSGKqONrBmvtGNBKAaJxCRKTDOIqrJOsQVOmGxmuIDEddVYvDwILTyushOAiXbkRIKgNLnFJdOagmiOHKRBKIIkxkOUeZWMRNlqpJdFgKjrGhIzrgBtgjVOtZAskKRbqzRVwLUoUAtRpRkoRQNLIrbLmmjZTugXJBNCscnMguKVAFDKpODtCsmdlBvQGALeBGUitYBxLYhJxeVcAnTWmTAvCITzdzqiBfEudEIBmkDAXIFmoOmsTMZDOnhXYrgMDlDbjednYWWJbGhrXFrxMQmQSmRBwoOqWGbGmjZNlJCvSHvmtZUkIScWXVdfSsdvdyQNpGFIOuteXhCMLmmEHrMucEmFbCIOHTJINAuIUOPfAfijIPkZjppGCCSRJNXWNCmliwUgABkHWuelUWeLsyVKVcZWOSeiQBQibCQJQUgGkTrXZxdBLsgjeMIwOyORDBpywuvlrLScRNhvaCYaKKRvOZeqBebUWWFhNnIRJvedFNfFPgWZJgNRaUpyYWFNiXJfAqNjyCEQYwAdFBQKKolwrufmJOfrToJFEsoNjaphcNvfWGIjKrKZSoSJEsbRqNVcoprpcGrnBgcNAnWUFpRldcPJkPfaoLKRCmVyMAWMXmnScodKisCTqllZEWQQSCFETxLNntgdcFEFRsTSIhuewwrHIlOeCcRqkzgQhKnKyHZHdFsMEKvPywLbjaspVxUMEkVzCGcGoTmaBjUMwJuAYdSTaYGDHHWDrvGgMVTtehpzfgofkmqtamffJbCKOzJgPsHNEnFarjADJGyKLwwitCiBXIraUdZtZwNjUtGbWqxksepVYztIBrimByoYQfUQgOndzFmhnuSmhYWvHliWUHgbvBIkYasDElNsjcCLtMvjQEhJjWvlnAscPwOYfelrfgfRAZGBxdFlMNkfYEWLbkfUhbRPHoDZsaAQdoKhAAWzOcHoAkkHPQMNIxgHNJaqEFBqCuMYEtLpMnIiMCWWEPnBYgYrxlXFGYpQWUNFevwcEUvUzDeSZNrdmahAfjeLSAGjHVnqyTzJkiVXjDJXzOiszXQCErQwwDMMqjLxWebJwNAVdrXeyMDRYXmLMDnuWLVaShVGhlgvbjOdOnhCDTNVazYDnzstqxjOuWbLcDaavRumKUOQXBQwKtdFgOzXiQKWFporrIcylIHlTmTKAIpBqNUbkajLTlwAHieCcqPIJYhegwQhWpYZdfxpQXDKtYzsrmnvdiTKgXfXKlIHPHlxQtqXGhMVPOBAKVZJfkrDNEwnQFwgfoHJSqQxTzRswVLrtFgpVzKcLilgznElWUfhERyeUrCcFCuGJddlFHJrXsqRdUjqUwaBmJVNwjRbCFiVMOSFuNctNVzhmhUpoddsMPUFMvNIMsMjHIWYiLjhSajZqpDkMvUOUCbYKfNHGpdUeWGUtDXHDNSCEXqYrhWhvnISnjfoBMCwwptksarPImRZaRxBMjoBdlmRGlIuQZDzCLnxxioATnGVFFTATUpeypOCaCeJAvPLxEXYzlCgXvXirGSZFyZPPSCdOSHxeELRsetFrWgqPNNpwgbgBEYPOSpLWeVdqOxPaQnidyPVMmELzeJPWgNsWBdPJPjhkdGpeAYZfrBNqdbOwzbtLiWMPafjgWQNcWKqmcleWLcMJoGSAEIUyFuzElZKXonHOMDdGMtSKEFUWdfPfnDecKNhIjAKRYmkXgpPAzlKIOpViZPkZdozzAoWwDnXkfDikvkXcQaoBtzKkcRhNpJRYaGTkdnlfotsJZsLqpYaWoK');
COMMIT;

drop table ch08_varchar2;

--PL/SQL문을 만들어 VARCHAR2 타입의 최대 길이를 살펴보자.
--PL/SQL에서는 VARCHAR2 타입의 변수를 선언해 4000BTYE 이상의 값을 집어 넣을 수 있다.
DECLARE
    vs_sql_varchar2     varchar2(4000);
    vs_plsql_varchar2   varchar2(32767);
BEGIN

    --ch08_varchar2 테이블의 값을 변수에 담는다.
    SELECT VAR1
    INTO vs_sql_varchar2
    FROM ch08_varchar2;
    
    --PL/SQL 변수에 4000 BYTE 이상 크기의 값을 넣는다.
    vs_plsql_varchar2 := vs_sql_varchar2 || ' - ' || vs_sql_varchar2 || ' - ' || vs_sql_varchar2;
    
    -- 각 변수 크기를 출력한다.
    DBMS_OUTPUT.PUT_LINE('SQL VARCHAR2 길이 : ' || LENGTHB(vs_sql_varchar2));
    DBMS_OUTPUT.PUT_LINE('PL/SQL VARCHAR2 길이 : ' || LENGTHB(vs_plsql_varchar2));
END;
/