-- testTBL 생성
CREATE TABLE testTBL1(id int, userName char(3), age int);

-- 구조 확인
DESC testTBL1;

-- INSERT 1, 홍길동, 25세
INSERT INTO testTBL1 VALUES(1, '홍길동', 25);

-- INSERT 2, 설현 (데이터가 부족하게 홨을 경우) 
-- 1) 없는 데이터에 NULL을 넣어준다.   -> 명시적으로 NULL 처리
INSERT INTO testTBL1 VALUES(2, '설현', NULL);  

-- 2) 암묵적으로 NULL 처리
INSERT INTO testTBL1(id, userName) VALUES(2, '설현'); 

SELECT * FROM testTBL1;

-- INSERT 초아, 26세, 3 (순서대로가 아님)
INSERT INTO testTBL1(userName, age, id) VALUES('초아', 26, 3); 


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ AUTO_INCREMENT를 적용한 테이블 생성 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ  
CREATE TABLE testTBL2
(	id int AUTO_INCREMENT PRIMARY KEY, 
	userName char(3), 
	age int
);

-- INSERT 지민 25세, 유나 22세, 유경 21세
INSERT INTO testTBL2 VALUES (NULL, '지민', 25);
INSERT INTO testTBL2 VALUES (NULL, '유나', 22);
INSERT INTO testTBL2 VALUES (NULL, '유경', 21);

SELECT * FROM testTBL2;

-- id를 자동으로 100번 부터 다시 발급

ALTER TABLE testTBL2 AUTO_INCREMENT = 100;  		  -- !!!!!!!!!insert를 하기 전!!!!!!!!!!에 설정.
INSERT INTO testTBL2 VALUES (NULL, '찬미', 23);   -- 찬미는 100으로 나옴.

-- AUTO_INCREMENT의 초기 값은 1000으로 하고,  3씩 증가해서 id 발급
CREATE TABLE testTBL3
(	id int AUTO_INCREMENT PRIMARY KEY, 
	userName char(3), 
	age int
);

ALTER TABLE testTBL3 AUTO_INCREMENT = 1000;  
-- 증가값을 지정하는 서버 변수(기본으로 1로 설정되어 있음.)
SET @@auto_increment_increment = 3;

INSERT INTO testTBL3 VALUES (NULL, '나연', 20);
INSERT INTO testTBL3 VALUES (NULL, '정연', 18);
INSERT INTO testTBL3 VALUES (NULL, '모모', 19);


SELECT * FROM testTBL3;

-- 마지막 id번호가 뭐냐?
SELECT LAST_INSERT_ID();

-- 테이블을 생성하고, 그 후에 INSERT INTO SELECT를 통해 대량의 데이터 삽입
CREATE TABLE testTBL4
(	id int AUTO_INCREMENT PRIMARY KEY, 
	Fname varchar(50), 
	Lname varchar(50)
);

ALTER TABLE testTBL4 AUTO_INCREMENT = 1000;
SET @@auto_increment_increment = 1;

-- INSERT INTO SELECT를 통해 대량의 데이터 삽입
INSERT INTO testTBL4
	SELECT NULL, first_name, last_name FROM employees.employees;

-- 데이터 확인
SELECT * FROM testTBL4;


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ update ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 정보수정 UPDATE - Fname이 Kyoichi인 사람의 Lname을 없음으로 변경
-- 1) Kyoichi 정보 검색  -> 502건   -- 숫자 확인 중요!!! 
SELECT * FROM testTBL4 WHERE Fname = 'Kyoichi';

-- 2) 정보 수정
UPDATE testTBL4 
	SET Lname = '없음'
WHERE Fname = 'Kyoichi';

-- buyTBL 상품 가격을 인상 1.5배 (전체)
-- 1) 변경될 데이터 확인 -> 12건
SELECT price, price * 1.5 FROM buyTBL;

-- 2) 정보 수정 
UPDATE buyTBL 
	SET price = price * 1.5;

SELECT * FROM buyTBL;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ DELETE: 데이터 삭제 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- testTBL4 테이블에서 Fname이 Aamer인 사람 삭제
-- 1) Aamer 정보 조회 -> 456건 삭제 예정
SELECT * FROM testTBL4 WHERE Fname = 'Aamer';

-- 2) 데이터 삭제
DELETE FROM testTBL4 WHERE Fname = 'Aamer';

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 회원별로 총 구매액을 집계하고 가장 높은 구매액 순으로 정렬
SELECT userID, SUM(price * amount)
FROM buyTBL
GROUP BY userID
ORDER BY 2 DESC;

-- CTE 형태로 변경
WITH cte_buyTBL(userID, total)
AS 
(
SELECT userID, SUM(price * amount)
FROM buyTBL
GROUP BY userID
) -- 임시테이블에 넣겠다.
SELECT * FROM cte_buyTBL
ORDER BY total DESC;


-- buyTBL 총합
WITH cte_buyTBL(userID, total)
AS 
(
SELECT userID, SUM(price * amount)
FROM buyTBL
GROUP BY userID
) -- 임시테이블에 넣겠다.
SELECT SUM(total) FROM cte_buyTBL
ORDER BY total DESC;


-- 회원 테이블에서 각 지역별로 가장 큰 키를 한 명씩 뽑은 후 
-- 그 사람들의 평균키를 집계하라.
-- 1) 지역별로 가장 키 큰 사람과 작은 사람  집계
SELECT addr, MAX(height), MIN(height)
FROM userTBL
GROUP BY addr;

-- 2) CTE로 만들어서 결과를 받은 후에 키 큰 사람 기준으로 평균, 키 작은 사람을 기준으로 평균을 낸다. 
WITH cte_userTBL(addr, maxHeight, minHeight)
AS
(
SELECT addr, MAX(height), MIN(height)
FROM userTBL
GROUP BY addr
)
SELECT AVG(maxHeight) AS ' 키 큰 사람 기준 평균', AVG(minHeight) AS ' 키 작은  사람 기준 평균'
FROM cte_userTBL;

   
-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 변수 활용 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 변수를 선언해서 쿼리를 실행
SET @myVal5 = 5;
SET @myVal2 = 2;
SET @myVal = '서적';

-- 5개 이하 검색
SELECT * FROM buyTBL
WHERE amount <= @myVal5;

-- 2개 이하 검색
SELECT * FROM buyTBL
WHERE amount <= @myVal2;

-- 분류에서 서적만 검색
SELECT * FROM buyTBL
WHERE groupName = @myVal;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ형 변환 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 평균 구매개수를 정수로 표현
SELECT AVG(amount) FROM buyTBL;   -- 2.916

-- 명시적 형변환 
-- 정수형 CAST(컬럼 AS 형식), CONVERT(컬럼, 형식) 형변환 방법
SELECT CAST(AVG(amount) AS SIGNED INTEGER) FROM buyTBL;
SELECT CONVERT(AVG(amount), SIGNED INTEGER) FROM buyTBL;

-- 문자형 -> 날짜형으로 변환
SELECT CAST('2022$12$12' AS DATE);
SELECT CAST('2022@12@12' AS DATE);
SELECT CAST('2022@13@12' AS DATE);    -- 형변환 할 수 없는 경우엔 NULL로 리턴 
 
-- 암묵적 형변환     -- 추천X: 안 될 수도 있음.
SELECT '100' + '200';   -- 300   --> 문자열을 더해도 정수형을 더한 것으로 알아서 해줌.
SELECT CONCAT('100', '200');


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 내장 함수 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- IF(수식(연산, 비교), TRUE 출력, FALSE 출력)
SELECT IF(100 > 200, '참', '거짓');

SELECT IF(100 > 200, 100 / 200, 100 * 200);

-- IFNULL(컬럼, 널이면 실행))
SELECT IFNULL (NULL, '널이네요');
SELECT userID, prodName, IFNULL (groupName, '아직 미정') AS '분류' FROM buyTBL;

-- NULLIF(수식1, 수식2) 비교한 다음에 같으면 NULL하고, 다르면 수식1을 반환
SELECT IFNULL(NULLIF(100, 100), '널'), NULLIF(200, 100);


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ ㅡㅡㅡㅡㅡㅡ case ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 다중분류 CASE THEN ELSE END : 연산자
SELECT CASE amount
		 WHEN 1 THEN '일'   -- amount * 10  -> 연산도 가능!
		 WHEN 5 THEN '오'
		 WHEN 10 THEN '십'
		 ELSE '모름'
	END
FROM buyTBL;


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 문자열 내장 함수 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 문자열 내장함수
-- 1) LENGTH(문자열) : 문자열의 길이를 반환
SELECT LENGTH('가나다');  -- 9가 나옴.   -> 한글은 3byte 
SELECT LENGTH('가나다'), LENGTH('abc'), CHAR_LENGTH('가나다'), CHAR_LENGTH('abc');   -- 한글은 char_length를 해야함. 


-- 2) CONCAT('문자열', '문자열') 문자열 연결시켜주는 함수
SELECT '가나다' + '마바사';    -- 0
SELECT CONCAT(userID, '님 반갑습니다.')
FROM userTBL;

SELECT CONCAT_WS(',', userID, name)
FROM userTBL;

SELECT FORMAT(price * amount, 4) FROM buyTBL;   -- 4자리 마다 소수점('.')을 붙여줌

-- 3) INSERT(문자열, 위치, 길이, 바꿀 문자): 문자열에 문자를 삽입해주는 함수   ㅡ> 데이터 마킹 (이*림)
-- 은지원 -> 은*원 마킹
SELECT userID, name, INSERT (name,2,1,'*')
FROM userTBL;

-- 예제: 회원의 아이디, 핸드폰 번호(한번에 출력) 가은데 4자리를 ****로 마킹해서 출력
-- BBK, 010****0000 출력
SELECT userID, INSERT(CONCAT(mobile1, mobile2),4,4,'****') -- 바꿀 문자의 수 만큼 넣어야 함!!!!!!!!
FROM userTBL;

SELECT userID, CONCAT(mobile1, INSERT(mobile2 ,1,4,'****'))
FROM userTBL;

-- 4) INSRT(문자열, 찾을 문자)특정 문자의 위치를 찾는 함수
SELECT INSTR('042) 9000-0000', ')');   -- 4: 워치가 나옴.

-- 5) UPPER() 대문자로 변경, LOWER() 소문자로 변경
-- !!!!아이디 중복 확인할 대 사용!!!!
-- userN로 가입하려고 하는데 usern  -> UPPER('userN') = UPPER('uern')
SELECT UPPER('userN'), UPPER('uern'), LOWER('userN'), LOWER('uern');

-- 6) TRIM(컬럼명) 앞 뒤 공백만 제거
SELECT TRIM('       안녕..........        ');

-- 7) REPLACE(문자열, 검색(원래) 단어, 변경할 단어)
SELECT REPLACE('이것이 MariaDB', '이것이', 'This is');

-- 경기 지역만 경기도로 변경해서 출력
SELECT REPLACE (addr, '경기', '경기도')
FROM userTBL;

-- 8) SUBSTRING(문자열, 시작위치, 길이) 문자열을 잘라주는 함수
-- 대한민국만세 -> 민국만 추출 하고 싶다.
SELECT SUBSTRING('대한민국만세', 3, 2);

SELECT SUBSTRING('대한민국만세', -3, 2);   -- 국만

SELECT SUBSTRING('대한민국만세', -1, 2);   -- 세  -> 0번째가 없어서?

SELECT SUBSTRING('042)000-0000', 1, INSTR('042)000-0000', ')')-1);


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 수학 함수 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- CEILING(숫자): 올림, FLOOR(숫자): 내림, ROUND(숫자): 반올림
-- 소수점 표현하고 싶은 경우 ROUND() 반올림의 소수점 기준을 줄 수 있음.
SELECT CEILING(4.7), FLOOR(4.7,2), ROUND(4.7);  -- 5, 4, 5
SELECT ROUND(4.75), ROUND(4.75,2), ROUND(4.75, 5);  -- 5, 4.75, 4.75000
-- 지정된 소수점 이하 버림
SELECT TRUNCATE(4.759, 2);


-- MOD(숫자1, 숫자2) 숫자1과 2를 나눈 나머지 값을 리턴
-- 나머지가 0과 1을 비교해서 홀수, 짝수
SELECT MOD(10,2);   -- 0


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 날짜 함수 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 1) ADDDATE(날짜, 차이),  SUBDATE(날짜, 차이)
-- 날짜 기준으로 차이를 빼거나 더하기
SELECT ADDDATE('2021-11-19', INTERVAL 1 MONTH),
		 SUBDATE('2021-11-19', INTERVAL 1 MONTH);

-- 현재 날짜와 시간을 제공해 주는 함수
-- CURDATE(): 현재 날짜, CURTIME(): 현재 시간 
-- NOW(): 현재 날짜 + 시간, SYSDATE(): 현재 날짜 + 시간

SELECT CURDATE(), CURTIME(), NOW(), SYSDATE();
SELECT DATE(SYSDATE());  -- 형 변환으로 인해 날짜만 나옴.
SELECT TIME(SYSDATE());  -- 형 변환으로 인해 시간만 나옴.

-- 지금으로 부터 2021-12-31일까지 얼마나 남았는지 궁금해요.
SELECT DATEDIFF(SYSDATE(), '2021-12-31');

-- LAST_DAY() 마지막 날을 반환해 주는 함수 31 or 30
SELECT LAST_DAY('2028-02-01');


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ rank: 순위함수 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 회원 중에 키가 큰 순으로 순위를 정하고 싶다: ROW_NUMBER()
-- 1) 키큰 순으로 정렬
SELECT height, name, addr FROM userTBL
ORDER BY height DESC;

-- 2) ROW_NUMBER() 순위를 부여
SELECT ROW_NUMBER() OVER(ORDER BY height DESC, name ASC) 
								AS "키큰 순위", name, height, addr 
FROM userTBL;

-- 3) 동률일 때 공정하게 순위를 부여하는 방식
SELECT DENSE_RANK() OVER(ORDER BY height DESC) AS "키큰 순위", name, height, addr -- 9위까지만
FROM userTBL;

-- 4) 동률일 때 같은 순위를 주고 (올림픽 기준) 부여하는 방식
SELECT RANK() OVER(ORDER BY height DESC) "키큰 순위", name, height, addr   -- 10위가 나옴
FROM userTBL;

-- 5) 전체 순위 말고 지역별로 순위를 주고 싶은 경우
SELECT ROW_NUMBER() OVER(PARTITION BY addr ORDER BY height DESC, name ASC) 
								 "키큰 순위", name, height, addr 
FROM userTBL;

-- 6) 가장 키큰 사람의 키와 비교해서 차이를 확인하기
SELECT addr, name, height, 
		 height - (FIRST_VALUE(height) OVER(ORDER BY height DESC)) "키 차이"
FROM userTBL;

-- 7) 지역별로 가장 키큰 사람의 키와 비교해서 차이를 확인하기
SELECT addr, name, height, 
		 height - (FIRST_VALUE(height) OVER(PARTITION BY addr ORDER BY height DESC)) "키 차이"
FROM userTBL;


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡJSONㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 공통의 데이터 포맷으로 JSON 형태로 쿼리 결과를 변경 (key = 컬럼명, value = 값)
SELECT JSON_OBJECT('addr', addr, 'name', name, 'height', height,
						 'distance', (height - (FIRST_VALUE(height) OVER(ORDER BY height DESC)))
						) "JSON VALUE" 
FROM userTBL;


