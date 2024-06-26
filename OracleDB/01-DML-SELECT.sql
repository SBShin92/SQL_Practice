--SQL 문장의 주석은 두 개의 하이픈(--)으로 표기
--SQL 문장의 끝은 세미콜론(;)
--키워드들은 대소문자를 구분하지 않는다.(단, 실제 데이터의 경우 대소문자를 구분한다.)
------------------------------------------------------------------

--테이블 구조 확인: DESCRIBE
DESCRIBE employees;

describe departments;

------------------------------------------------------------------

-- SELECT --

-- Alias에 띄어쓰기, 특수문자가 있으면 더블쿼트("")를 써야 한다.
SELECT
    employee_id  "id",
    first_name   AS 성,
    last_name    AS 이름,
    phone_number AS "전화-번호",
    hire_date    AS 입사일,
    salary       AS "급  여",
    salary * 12 AS "연  봉"
FROM
    employees;

------------------------------------------------------------------

-- 단순연산 --

SELECT
    3 + 4
FROM
    dual;

-- select job_id * 12
---- 위 쿼리가 에러가 난 이유? : job_id는 VARCHAR!
-- 연산 시에는 숫자인지 꼭 확인하도록 하자.
------------------------------------------------------------------

-- NULL --

-- 이름, 급여를 출력
SELECT
    first_name,
    salary
FROM
    employees;

SELECT
    first_name                       AS 성,
    salary                           AS 기본급,
    commission_pct                   AS 수당,
    salary + salary * commission_pct AS 월급
FROM
    employees;

-- 월급 값을 NULL이 아닌 값으로 계산하고 싶으면 아래와 같이
SELECT
    first_name                               AS 성,
    salary                                   AS 기본급,
    commission_pct                           AS 수당,
    salary + salary * nvl(commission_pct, 0) AS 월급
FROM
    employees;

-- 연산 전에는 항상 NULL을 생각하자!
------------------------------------------------------------------

-- 문자열 결합 연산 --

SELECT
    'Name is '
    || first_name
    || ' '
    || last_name
    || concat(' and no. is ', employee_id)
FROM
    employees;

-- 응용 1
SELECT
    first_name
    || ' '
    || last_name                             "Full Name",
    salary + salary * nvl(commission_pct, 0) "급여(with 수당)",
    salary * 12 연봉
FROM
    employees;

-- 응용 2
SELECT
    first_name
    || ' '
    || last_name                             이름,
    to_char(hire_date, 'yyyy-mm-dd')         입사일,
    phone_number                             전화번호,
    salary                                   급여,
    salary + salary * nvl(commission_pct, 0) "급여(with 수당)",
    salary * 12 연봉
FROM
    employees;

------------------------------------------------------------

-- WHERE --

SELECT
    first_name,
    last_name,
    job_id,
    salary,
    hire_date
FROM
    employees
WHERE
    salary <= 4000
    AND first_name LIKE 'S%'
    OR salary BETWEEN 15000 AND 25000
    AND hire_date >= TO_DATE('20030101', 'YYYYMMDD');

-- DATE 타입은 TO_DATE로 바꿔서 연산하는 것이 호환상 좋아보인다.

-- HIRE_DATE >= '03/01/01' -- 이건 sql developer에서 먹히더라
-- HIRE_DATE >= '01-jan-03' -- 이건 vscode의 extension에서 먹힘


-- BETWEEN AND
SELECT
    first_name,
    salary
FROM
    employees
WHERE
    salary BETWEEN 14000 AND 17000;

-- IS NULL
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NULL;

-- IS NOT NULL
SELECT
    first_name,
    commission_pct
FROM
    employees
WHERE
    commission_pct IS NOT NULL;

-- OR 노가다
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id = 10
    OR department_id = 20
    OR department_id = 40;

-- IN
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id IN(10, 20, 40);

-- ANY와 비교해보자.
SELECT
    first_name,
    department_id
FROM
    employees
WHERE
    department_id = ANY(10, 20, 40);

-- LIKE
SELECT
    first_name
FROM
    employees
WHERE
    lower(first_name) LIKE '%am%';

SELECT
    first_name
FROM
    employees
WHERE
    lower(first_name) LIKE '_a%';

-- st로 시작하는 이름 찾기, 그러나 ESCAPE용 기호가 t일때?
SELECT
    first_name
FROM
    employees
WHERE
    lower(first_name) LIKE 'stt%'ESCAPE't';

-- 이름이 4글자인 사람 중 두번 째 문자가 a
SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    last_name LIKE '_a__';

-- department_id == 90 && salary >= 20000?
SELECT
    first_name,
    last_name,
    employee_id,
    salary
FROM
    employees
WHERE
    department_id = 90
    AND salary >= 20000;

-- hire_date 07/01/01~07/12/31?
SELECT
    first_name,
    last_name,
    hire_date
FROM
    employees
WHERE
    hire_date >= TO_DATE('110101', 'yymmdd')
    AND hire_date <= TO_DATE('151231', 'yymmdd');

-------------------------------------------------------------

-- manager_id 100, 120, 147 찾기를 할 때
-- 다음과 같이 순서정렬을 해줄 수도 있다.
SELECT
    first_name,
    last_name,
    manager_id
FROM
    employees
WHERE
    manager_id IN (100, 120, 147)
ORDER BY
    manager_id,
    1 DESC,
    2 ASC;

-- sort department_id asc
SELECT
    department_id,
    first_name,
    last_name,
    salary
FROM
    employees
ORDER BY
    department_id;

-- salary >= 10000, sort salary desc
SELECT
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary >= 10000
ORDER BY
    salary DESC;

-- sort department_id asc, salary desc
SELECT
    department_id,
    first_name,
    last_name,
    salary
FROM
    employees
ORDER BY
    1 ASC,
    4 DESC;

-----------------------------------------------------------------

-- 요약하자면

-- SELECT projection_컬럼_목록
-- FROM 테이블목록
-- WHERE 필터링조건
-- ORDER BY 정렬조건;

-----------------------------------------------------------------
-----------------------------------------------------------------

-- 단일행 함수 --


-- 문자열 --
SELECT
    first_name,
    last_name,
    concat(first_name, concat(' ', last_name)),
    first_name
    || ' '
    || last_name
FROM
    employees;

SELECT
    lower(first_name),
    upper(last_name),
    lpad(first_name /*EXPR1*/, 20 /*N*/, '*' /*EXPR2*/ )
FROM
    employees;

SELECT
    '     oracle     ',
    '*****database*****',
    ltrim('     oracle     ')           트림좌,
    rtrim('     oracle     ')           트림우,
    ltrim('*****database*****', '*')    트림좌,
    rtrim('*****database*****', '*')    트림우,
    TRIM('*' FROM '*****database*****') 트림
FROM
    dual;

SELECT
    substr('oracle database', 8, 4)  substr,
    substr('oracle database', -4, 4) "substr-",
    length('oracle database')        length
FROM
    dual;

-----------------------------------------------------------------

-- 숫자 --
SELECT
    3.141592,
    abs(-3.141592),
    ceil(3.141592),
    floor(3.141592),
    round(3.5),
    round(3.141592, 3),
    trunc(3.5),
    trunc(3.141592, 3)
FROM
    dual;

SELECT
    sign(-3.14159),
    mod(7, 3) -- 주석
FROM
    dual;

-----------------------------------------------------------------

-- DATE --

SELECT
    *
FROM
    nls_session_parameters;

SELECT
    value
FROM
    nls_session_parameters
WHERE
    parameter = 'NLS_DATE_FORMAT';

SELECT
    sysdate
FROM
    dual;

SELECT
    sysdate
FROM
    employees;

SELECT
    sysdate,
    add_months(sysdate, 2),
    last_day(sysdate),
 --    months_between(TO_DATE('120924', 'yymmdd'), sysdate),
    next_day(sysdate, 1),
    round(sysdate, 'mon'),
    trunc(sysdate, 'yy')
FROM
    dual;

-- DATE 연산 --
SELECT
    sysdate,
    sysdate + 1,
    sysdate - 1,
    round(sysdate - TO_DATE('20120924', 'yyyymmdd'), 1),
    sysdate + 48 / 24
FROM
    dual;

-----------------------------------------------------------------

-- Convert Format --

-- DATE --
SELECT
    first_name,
    to_char(hire_date, 'yyyy-mm-dd')
FROM
    employees;

SELECT
    sysdate,
    to_char(sysdate, 'yyyy-mm-dd AMhh:hh:ss')
FROM
    dual;

-- 지정 포맷보다 높은 값이면 #####... 으로 나온다.
SELECT
    to_char(30000000, 'L999,999,999.99')
FROM
    dual;

SELECT
    first_name
    || ' '
    || last_name                                                            이름,
    to_char((salary + salary * nvl(commission_pct, 0)) * 12, '$999,999.99') 수당포함연봉
FROM
    employees;

-- 문자열을 DATE로 변환
SELECT
    '2012-09-24 13:48:00',
    TO_DATE('2012-09-24 13시48:00', 'yyyy-mm-dd hh24:mi:ss')
FROM
    dual;

-- NUMBER --
-- 문자열을 NUMBER로 변환
SELECT
    '$57,600',
    to_number('$57,600', '$999,999')
FROM
    dual;

-----------------------------------------------------------------

-- 기타 함수 --

-- NVL --
SELECT
    first_name
    || ' '
    || last_name                    이름,
    salary,
    salary * nvl(commission_pct, 0)
FROM
    employees;

SELECT
    first_name
    || ' '
    || last_name                                     이름,
    salary,
    nvl2(commission_pct, salary * commission_pct, 0)
FROM
    employees;

-----------------------------------------------------------------

-- Conditional Expression --

-- CASE문 --

-- ad는 20%, sa는 10%, it는 8%, 나머지는 5% 보너스 주자.


SELECT
    first_name,
    job_id,
    salary,
    CASE substr(lower(job_id), 1, 2)
        WHEN 'ad' THEN
            0.2 * salary
        WHEN 'sa' THEN
            0.1 * salary
        WHEN 'it' THEN
            0.08 * salary
        ELSE
            0.05 * salary
    END        뽀나스
FROM
    employees;


-- DECODE문 --
select
    FIRST_NAME,
    job_id,
    salary,
    DECODE(SUBSTR(lower(JOB_ID), 1, 2),
           'ad', salary * 0.2,
           'sa', SALARY * 0.1,
           'it', salary * 0.08,
           salary * 0.05) 뽀내기
FROM EMPLOYEES;

-----------------------------------------------------------------

-- ex --
-- [연습] hr.employees
--  직원의 이름, 부서, 팀을 출력하십시오
--  팀은 코드로 결정하며 다음과 같이 그룹 이름을 출력합니다
--  부서 코드가 10 ~ 30이면: 'A-GROUP'
--  부서 코드가 40 ~ 50이면: 'B-GROUP'
--  부서 코드가 60 ~ 100이면 : 'C-GROUP'
--  나머지 부서는 : 'REMAINDER'

SELECT FIRST_NAME || ' ' || LAST_NAME 이름,
    DEPARTMENTS.DEPARTMENT_ID 부서,
    CASE
        WHEN DEPARTMENTS.DEPARTMENT_ID <= 30 THEN 'A-GROUP'
        WHEN DEPARTMENTS.DEPARTMENT_ID <= 60 THEN 'B-GROUP'
        WHEN DEPARTMENTS.DEPARTMENT_ID <= 100 THEN 'C-GROUP'
    ELSE 'REMAINDER' END 팀
FROM EMPLOYEES
JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
ORDER BY 팀, 부서;


SELECT FIRST_NAME || ' ' || LAST_NAME 이름,
    DEPARTMENTS.DEPARTMENT_ID 부서,
    DECODE(
        SIGN(DEPARTMENTS.DEPARTMENT_ID - 30),
        -1, 'A-GROUP',
        0, 'A-GROUP',
        DECODE(
            SIGN(DEPARTMENTS.DEPARTMENT_ID - 60),
            -1, 'B-GROUP',
            0, 'B-GROUP',
            DECODE(
                SIGN(DEPARTMENTS.DEPARTMENT_ID - 100),
                -1, 'C-GROUP',
                0, 'C-GROUP',
                'REMAINDER'
            )
        )
    ) 팀
FROM EMPLOYEES
JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
ORDER BY 팀, 부서;

