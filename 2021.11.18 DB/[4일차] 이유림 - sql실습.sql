-- 키가 180 ~ 185 사이의 회원만 검색
SELECT * FROM userTBL;
SELECT * FROM userTBL WHERE height >= 180 AND height <= 185;
SELECT * FROM userTBL WHERE height BETWEEN 180 AND 185;   -- 연속적인 값의 범위인 경우, * 실무X(위의 퀴리가 더 빠름)

-- 키가 166, 172, 182 회원만 검색
SELECT * FROM userTBL 
	WHERE height = 166 OR height = 172 OR height = 182;
SELECT * FROM userTBL
	WHERE height IN(166, 172, 182);

-- IN 연산자: 전남, 경남 지역의 회원만 검색
SELECT * FROM userTBL 
	WHERE addr = '전남' OR addr = '경남';
SELECT * FROM userTBL 
	WHERE addr IN('전남', '경남', '서울');
	
-- like 연산자: 문자열 검색 회원 중 김 씨 성을 가진 회원만 검색
SELECT * FROM userTBL WHERE name = '김';   -- 나오지 않음
SELECT * FROM userTBL WHERE name LIKE '김%';

-- 성을 제외한 이름에 '용' 단어가  들어간  회원을 검색
SELECT * FROM userTBL WHERE name LIKE '%용%';   -- 성이 용씨인 사람도 나옴.
SELECT * FROM userTBL WHERE name LIKE '_용%';   -- 첫 번째 글자를 '와일드 카드(_)'로 제외

-- 성을 제외한 이름에 '원'으로 끝나는 회원을 검색
SELECT * FROM userTBL WHERE name LIKE '__원';   
SELECT * FROM userTBL WHERE name LIKE '%원';  -- 가능

-- 같은 이름을 가진 회원을 검색
SELECT * FROM userTBL WHERE name LIKE '_종신';

-- 서브쿼리: 김경호 회원 보다 키가 큰 회원을 검색(한번에)
-- 1) 김경호 회원의 키를 검색
SELECT userID, name, height FROM userTBL WHERE name = '김경호';

-- 2) 177 보다 키가 큰 회원을 검색
SELECT * FROM userTBL WHERE height > 177; 

-- 3) 서브쿼리로 하나의 쿼리로 생성
SELECT * FROM userTBL 
WHERE height > (SELECT height FROM userTBL WHERE name = '김경호');
WHERE height > (SELECT height FROM userTBL WHERE name = '김경호');  --  비교 값이 같아야 함.

-- 은지원 보다 키가 큰 회원을 검색(174보다 큰 회원 검색됨)
SELECT * FROM userTBL 
WHERE height > (SELECT height FROM userTBL WHERE name = '은지원');

-- 전남에 사는 회원보다 키가 큰 회원을 검색
-- 1) 서울에 사는 회원의 키 검색
SELECT userID, name, addr, height FROM userTBL WHERE addr = '서울';

-- 2) 176보다 큰 사람을 검색
SELECT * FROM userTBL WHERE height > -- 모르겠어...? 176, 182, 186;
 
-- 서브쿼리로 생성   -> ANY를 사용하면 서브쿼리의 제일 작은 값 보다 큰 
-- ANY: 176
SELECT * FROM userTBL
WHERE height > ANY (SELECT height FROM userTBL WHERE addr = '서울');

-- 서울 사람들의 키 조건이 모두 만족 했으면 좋겠다.
-- ALL: 서브 쿼리에서 가장 큰 값 보다> 조건을 만족해야 결과 나옴
-- ALL: 186
SELECT * FROM userTBL
WHERE height > ALL (SELECT height FROM userTBL WHERE addr = '서울');

SELECT * FROM userTBL
WHERE height >= ALL (SELECT height FROM userTBL WHERE addr = '서울');  -- 성시경만 나옴.

-- 서울 사람들의 키와 같은 회원 검색
SELECT * FROM userTBL
WHERE height = ANY (SELECT height FROM userTBL WHERE addr = '서울');   -- 같은 사람이 없어서 서울 사람들만 나옴.

SELECT * FROM userTBL
WHERE height IN (SELECT height FROM userTBL WHERE addr = '서울');      -- '= ANY'은 'IN'과 같은 효과. 

SELECT * FROM userTBL
WHERE height IN(176, 182, 186);

SELECT * FROM userTBL
WHERE height = ALL (SELECT height FROM userTBL WHERE addr = '서울');    -- 나오지 않음.


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ예제ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 경남 사람들 보다  어린 사람들을 검색 (출생년도를 비교)
-- 1) 경남 사람들의 출생년도 검색
SELECT userID, name, birthYear, addr FROM userTBL WHERE addr = '경남';

-- 2) 경남 사람보다 어린 사람 검색
SELECT * FROM userTBL WHERE birthYear > ;   -- 1979, 1969 ???

-- 3) 경남 사람들 보다 어린 사람(조건이 하나 이상 포함 되면 되겠지)
SELECT * FROM userTBL WHERE birthYear >
(SELECT birthYear FROM userTBL WHERE addr = '경남');   -- 결과 값이 여러명이라 !!오류!!남.

-- ANY: 1969년
SELECT * FROM userTBL WHERE birthYear > ANY
(SELECT birthYear FROM userTBL WHERE addr = '경남');

-- 경남 사람 중에 가장 어린 사람 기준으로 비교 해 주세요.
-- ALL: 1979년
SELECT * FROM userTBL WHERE birthYear > ALL
(SELECT birthYear FROM userTBL WHERE addr = '경남');

-- 경남 사람들과 같은 나이의 회원 검색
SELECT * FROM userTBL WHERE birthYear = ANY  -- '= ANY'는 'IN'과 결과가 같음.
(SELECT birthYear FROM userTBL WHERE addr = '경남');   

SELECT * FROM userTBL WHERE birthYear IN
(SELECT birthYear FROM userTBL WHERE addr = '경남');

-- !!!!!(은지원 보다 키가 큰 회원의 휴대폰 번호는?)!!!!
SELECT userID, name, mobile1, mobile2 FROM userTBL WHERE name = '은지원';

SELECT userID, name, mobile1, mobile2 FROM userTBL 
WHERE height > (SELECT height FROM userTBL WHERE name = '은지원');


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡORDER BY: 오름 or 내림차순 정렬  !!!모든 쿼리의 마지막!!!!(WHERE절 다음에)ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- ORDER BY 컬럼명 ASC(기본: 오름차순), DESC(내림차순)
SELECT * FROM buyTBL ORDER BY num DESC;

-- 회원 이름으로 정렬 오름차순
SELECT * FROM userTBL ORDER BY name;

-- 회원 이름으로 정렬 내름차순
SELECT * FROM userTBL ORDER BY name DESC;

-- 지역으로 정렬 오름차순
SELECT * FROM userTBL ORDER BY addr;

SELECT * FROM userTBL ORDER BY addr, name;    -- 같은 지역에서 이름을 오름차순

-- 지역을 내림차순, 이름을 오름차순으로 정렬함.
SELECT * FROM userTBL 
WHERE addr IN('서울', '경남')
ORDER BY addr DESC, name;   -- 콤마(,)를 기준으로 순서대로 작용.


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡDISTINCT: 중복제거ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 회원들의 지역을 검색 (중복 제거)  
SELECT DISTINCT birthYear, name FROM userTBL;

-- employees 데이터베이스에서 employees의 성별을 중복 제거하고 보고 싶다.
SELECT gender FROM employees.employees;

SELECT DISTINCT gender FROM employees.employees;

-- employees 데이터베이스에서 titles 테이블의 직급이 어떻게 구성되어 있는지
SELECT title FROM employees.titles;

SELECT DISTINCT title FROM employees.titles;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡLIMIT: 출력 개수를 제한 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- employees 데이터베이스에서 입사일이 가장 오래된 직원 5명 검색
SELECT emp_no, first_name, hire_date FROM employees.employees 
ORDER BY hire_date ASC
LIMIT 1, 10;  -- 1~10 (총 10개)

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ백업: 주로 테스트할 때ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- buyTBL 테이블과 똑같은 구조, 데이터를 가지 테이블을 생성(백업)
-- !!!!제약조건(PK, FK)는 복사 되지 않음!!!!! 
CREATE TABLE buyTBL3 
(
SELECT * FROM buyTBL
);
SELECT * FROM buyTBL3;

-- buyTBL userID, prodName, price로만 된 테이블 생성(데이터 포함)
-- amount 주문 수가 2개 이상인 상품
CREATE TABLE buyTBL2 
(
SELECT userID, prodName, price FROM buyTBL
WHERE amount >=2
);

SELECT * FROM buyTBL2;

-- buyTBL의 구조만 복사해서 buyTBL4 테이블 생성    -- !!!테이블 구조!!!만 복사하고 싶을 때

SELECT * FROM buyTBL WHERE 1 = 0; -- !!!들어갈 수 있는 데이터가 없음!!!

CREATE TABLE buyTBL4 
(
SELECT * FROM buyTBL WHERE 1 = 0
);


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡGROUP BY: 그룹으로 묶어주는 절 - 중복된 데이털 위조로 (PK, FK X)ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- GROUP BY -> 그룹을 질 수 있는 컬럼을 이해하는 것

-- 회원 중에 구매한 물건의 수를 집계
SELECT * FROM buyTBL
GROUP BY userID;

SELECT userID AS '사용자 아이디', SUM(amount) AS '총 구매 개수' FROM buyTBL
GROUP BY userID;

-- 회원의 총 구매액을 집계
SELECT userID AS '사용자 아이디', SUM(amount*price) AS '총 구매액' FROM buyTBL
GROUP BY userID
ORDER BY 2 DESC;  -- !!!!!!2번재 컬럼(열)을 기준!!!!!으로 because 별칭으로 ORDER BY가 안 되기 때문.


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡSUM: 합, AVG: 평균 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 전체 회원의 구매액 -> 매출 집계
SELECT SUM(amount*price) AS '총 구매액' FROM buyTBL;
SELECT SUM(amount) AS '총 구매 개수' FROM buyTBL;

-- 전체 회원의 평균 구매액
SELECT AVG(amount*price) AS '평균 구매액' FROM buyTBL;
SELECT AVG(amount) AS '평균 구매 개수' FROM buyTBL;

-- 회원 평균 구매액을 따져보자.
SELECT userID ,AVG(amount*price) AS '평균 구매액' FROM buyTBL
GROUP BY userID;

SELECT userID ,AVG(amount) AS '평균 구매 개수' FROM buyTBL
GROUP BY userID;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡMAX, MIN, AVG, COUNTㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 가장 키 큰 사람과 가장 키 작은 사람, 평균 키 검색
SELECT MAX(height), MIN(height), AVG(height) FROM userTBL;  -- 이름을 부를 수 없음, 집계 함수는 이름을 찾을 수 없음.

SELECT name, MAX(height), MIN(height), AVG(height) FROM userTBL
GROUP BY name;   -- 자기 키만 나옴.

-- 키 가장 큰 사람은 누구?
-- 1) 가장 큰 키를 찾는다. 
SELECT MAX(height) FROM userTBL;

-- 2) 서브쿼리에 조건으로 연결
SELECT * FROM userTBL
WHERE height = (SELECT MAX(height) FROM userTBL);

-- 키가 가장 작은 사람

SELECT * FROM userTBL
WHERE height = (SELECT MIN(height) FROM userTBL);

-- 키가 평균 이상인 사람
SELECT * FROM userTBL
WHERE height >= (SELECT AVG(height) FROM userTBL);

-- 키가 가장 큰 사람과 작은 사람을 한 번에 찾고 싶다
SELECT * FROM userTBL
WHERE height = (SELECT MIN(height) FROM userTBL) 
OR
height = (SELECT MAX(height) FROM userTBL);

-- 제일 사용 많이 하는 집계 함수는 COUNT()
SELECT COUNT(*) FROM userTBL;
SELECT userID, COUNT(userID) FROM buyTBL
GROUP BY userID;

-- COUNT() 할 때, NULL은 제외하고 수를 셈
SELECT COUNT(*) - COUNT(mobile1) AS '핸드폰 미등록자 수' FROM userTBL;

-- NULL을 세고 싶다.
SELECT COUNT(*) FROM userTBL;
WHERE mobile1 IS NULL;

-- 검색 조건에 집계함수를 사용하고 싶다.
-- 총 구매액이 1000이상인 사용자에게 사은품을 증정하고 싶다. 

-- 총 구매액이 1000이상인 사람을 검색
SELECT * FROM buyTBL
WHERE SUM(amount*price) > 1000;

-- !!!!! WHERE절에는 집계 함수를 쓰려면, 서브쿼리로만 됨, 자체로는 불가능!!!!!

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ GROUP BY HAVING으로 사용 가능ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

FROM buyTBL
GROUP BY userID 
HAVING SUM(amount*price) > 1000;

-- 1) 사용자별 그룹 정의
SELECT userID
FROM buyTBL
GROUP BY userID;

-- 2) 서브쿼리 사용
SELECT userID, AVG(amount*price), SUM(amount*price), MAX(amount*price), MIN(amount*price)
FROM buyTBL
WHERE userID != 'BBK'  -- "BBK"를 제외하고,      -- 조건 검색(비교연산자) 가능한, 집계 함수 사용 불가
GROUP BY userID
HAVING AVG(amount*price) > 400;

-- 회원 중에 구매액이 평균 이상 구매한 사람만 검색
SELECT userID, AVG(amount*price), SUM(amount*price), MAX(amount*price), MIN(amount*price)
FROM buyTBL
GROUP BY userID
HAVING SUM(amount*price) > (SELECT AVG(amount*price) FROM buyTBL);

-- ㅡㅡㅡㅡㅡㅡㅡㅡ과제: 회원 중에 구매 수가 평균 이하인 사람만 검색ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
SELECT userID, AVG(amount), SUM(amount)
FROM buyTBL
GROUP BY userID
HAVING SUM(amount) <= (SELECT AVG(amount) FROM buyTBL);

SELECT * FROM buyTBL;
SELECT AVG(amount) FROM buyTBL;

-- 1) 구매의 평균 수량은?
SELECT AVG(amount) FROM buyTBL;

-- 2) 회원별로 그룹a 
SELECT userID, AVG(amount), SUM(amount), MAX(amount), MIN(amount)
FROM buyTBL
GROUP BY userID
HAVING SUM(amount) <= (SELECT AVG(amount) FROM buyTBL);

-- 평균 구매 수량보다 많이 구매한 회원 검색
SELECT userID, SUM(amount), AVG(amount), MAX(amount), MIN(amount), COUNT(*)
FROM buyTBL
-- WHERE
GROUP BY userID
HAVING SUM(amount) >= (SELECT AVG(amount) FROM buyTBL);
ORDER BY SUM(amount) DESC; -- 별칭이 있는 경우 SUM(amount) 대신 2를 해야함.

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ집계 함수를 하고 group by를 하는 이유ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
SELECT groupName, prodName, SUM(amount)   -- 집계 함수를 하지 않은(groupName, prodName)를 group by를 하지 않으면 의미가 없어짐(생략됨)
FROM buyTBL
GROUP BY groupName;

SELECT groupName, prodName, SUM(amount)   -- group by를 하여 의미를 부여
FROM buyTBL
GROUP BY groupName, prodName;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡROLLUP: 총합 또는 중계 합계 시ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 중간 합계, 총합까지 집계하자. -> ROLLUP
SELECT * FROM buyTBL;

-- groupName 별로 합계 및 그 총합을 집계
SELECT num, groupName, SUM(amount)   -- group by를 하지 않으면 의미가 없어짐 
FROM buyTBL
GROUP BY groupName, num     -- 무엇을 기준으로 중간 합계를 할 것인지 (맨 앞으로 보내)면 됨.
WITH ROLLUP;

-- userID 별로 합계 및 그 총합을 집계
SELECT num, userID, SUM(amount)   -- group by를 하지 않으면 의미가 없어짐 
FROM buyTBL
GROUP BY userID, num
WITH ROLLUP;


-- 1) 사용자 기준으로, 구매액을 중간 함계를 포함해서 총 합계를 집계
SELECT num AS 'NO', userID AS '사용자', SUM(amount* price) AS '구매액'
FROM buyTBL
GROUP BY userID, num
WITH ROLLUP;

-- 2) 분류를 기준으로, 구매액을 중간 함계를 포함해서 총 합계를 집계
SELECT num AS 'NO', groupName AS '분류', SUM(amount* price) AS '구매액'
FROM buyTBL
GROUP BY groupName, num
WITH ROLLUP;

-- 3) 상품명 기준으로, 구매액을 중간 함계를 포함해서 총 합계를 집계
SELECT num AS 'NO', prodName AS '상품명', SUM(amount* price) AS '구매액'
FROM buyTBL
GROUP BY prodName, num 
WITH ROLLUP;

-- 4) 분류 기준으로, 구매액을 중간 함계를 포함해서 총 합계를 집계
-- (NULL 제외하고 집계)
SELECT num AS 'NO', groupName AS '상품명', SUM(amount* price) AS '구매액'
FROM buyTBL
WHERE groupName IS NOT NULL   -- group by 하기 전에 NULL 제외
GROUP BY groupName, num 
WITH ROLLUP;











