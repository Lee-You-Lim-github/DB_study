-- 판매자, 판매계절, 판매 수량 데이터를 관리하는 pivotTest
CREATE TABLE pivotTest
(uName CHAR(3),
 season CHAR(2),
  amount INT);

-- 테이블 확인
DESC pivotTest;

-- 데이터 9건 입력
INSERT INTO pivotTest VALUES
	('김범수', '겨울', 10), ('윤종신', '여름', 15), ('김범수', '가을', 25), 
	('김범수', '봄', 3), ('김범수', '봄',  37), ('윤종신', '겨울', 40), 
	('김범수', '여름', 14), ('김범수', '겨울', 22), ('윤종신', '여름', 64);

-- 데이터 확인 
SELECT * FROM pivotTest;

-- 판매자 별 계절 판매 수량(컬럼으로 표출) 및 총 판매 수량 집계
-- 1) 판매자 별로 그룹으로 해서 총 합계
SELECT uName, SUM(amount)
FROM pivotTest
GROUP BY uName;

-- 계절별로 집계를 추가하기 
SELECT uName,
SUM(IF(season = '봄', amount, 0)) AS "봄",
SUM(IF(season = '여름', amount, 0)) AS "여름",
SUM(IF(season = '가을', amount, 0)) AS "가을",
SUM(IF(season = '겨울', amount, 0)) AS "겨울",
SUM(amount) AS "합계"
FROM pivotTest
GROUP BY uName;

-- 계절별로 사용자 판매 수량 및 합계를 집계
-- 1) 계절별 판매 수량 집계 
SELECT season, SUM(amount)
FROM pivotTest
GROUP BY season;

-- 2) 사용자 판매 수량 집계 추가하기
SELECT season,
SUM(IF(uName = '윤종신', amount, 0)) AS "윤종신",
SUM(IF(uName = '김범수', amount, 0)) AS "김범수",
SUM(amount) AS '합계'
FROM pivotTEST
GROUP BY season;



-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡJOIN ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


-- 구매 테이블에서 회원 정보를 추가해서 보고 싶다. 
-- 회원 정보를 알 수 있는 최소의 단위로만 FK 
-- userID, 회원명, 연락처, 주소, 구매한 상품, 구매 수량

-- 회원 테이블과 구매 테이블이 JOIN
-- 1) 기존 JOIN 쿼리
SELECT * FROM buyTBL
 INNER JOIN userTBL
 ON buyTBL.userID = userTBL.userID;
 
-- 2) userID, 회원명, 연락처, 주소, 구매한 상품, 구매 수량 특정 컬럼만 SELECT
-- userID 중복되기 때문에 테이블 명으로 명시해서 컬럼의 소속을 정리
-- 중복되는 컬럼명 때문에 테이블명.컬럼명 or 테이블별칭.컬럼명
SELECT userTBL.userID, name, CONCAT(mobile1, mobile2), addr, prodName, amount  
FROM buyTBL   -- 기준 테이블
 INNER JOIN userTBL
 ON buyTBL.userID = userTBL.userID -- 조인조건 컬럼
 WHERE name = '조용필';    -- 넣어도 되고 안 넣어도 되고


-- 주소가 서울 사람들의 구매 정보를 검색한다.
SELECT userTBL.userID, name, CONCAT(mobile1, mobile2), addr, prodName, amount  
FROM buyTBL   -- 기준 테이블
 INNER JOIN userTBL
 ON buyTBL.userID = userTBL.userID
 WHERE addr = '서울';    -- 넣어도 되고 안 넣어도 되고

-- 3) 테이블명을 별칭을 주기 각 컬럼의 소속 정보 추가 
-- 함수 및 연산 사용한 컬럼은 다시 별칭 추가
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount  
FROM buyTBL B                                -- 별칭을 주면 어느 테이블에서 데이터를 가져 왔는지 알 수 있음.
 INNER JOIN userTBL U
 ON B.userID = U.userID
 WHERE addr = '서울';


SELECT U.userID AS 'U.userID', B.userID AS 'B.userID', U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount  
FROM buyTBL B    -- 기준 테이블                            -- 별칭을 주면 어느 테이블에서 데이터를 가져 왔는지 알 수 있음.
 INNER JOIN userTBL U
 ON B.userID = U.userID
 WHERE addr = '서울';

-- 조인하게 되면 buyTBL에서 검색할 수 없었던 회원 정보로도 구매 정보를 검색 가능하다.
-- 회원명, 주소, 연락처, 가입일 등 컬럼으로 구매 정 보 검색 가능.
-- * 모든 정렬은 userID의 오름차순으로 정렬한다.

-- 1) 회원명 은지원 구매 정보 검색 (userID, 회원명, 연락처, 주소, 구매한 상품, 구매 수량)
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM buyTBL B  -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID
WHERE U.name = '은지원';

-- 2) 주소 중에 서울과 경기 지역의 회원들의 구매 정보 검색 
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM buyTBL B   -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID
	WHERE U.addr IN ('서울', '경기')
ORDER BY userID;

-- 3) 연락처가 없는 사람의 구매 정보 검색
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM buyTBL B   -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID
WHERE CONCAT(U.mobile1, U.mobile2) IS NULL   
ORDER BY userID;
-- 윤종신도 "mobile"이 null이지만 상품을 구매하지 않았기 때문에 포함X

-- 4) 회원 중에 키가 180 이상인 회원의 구매 정보만 검색
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, U.height, B.prodName, B.amount
FROM buyTBL B  -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID
WHERE U.height >= 180
ORDER BY userID;
-- 이승기와, 임재범도 height가 180 이상이지만 삼품을 구매이력이 없어 포함되지 않음.

-- 5) 회원 중에 모든 회원의 평균 키 보다 작은 회원의 구매 정보만 검색
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, U.height, B.prodName, B.amount
FROM buyTBL B  -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID
WHERE U.height <= (SELECT AVG(height) FROM userTBL)
ORDER BY userID;
-- join문에서는 group by를 하지 않음.

-- !!!실무!!!
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, U.height, B.prodName, B.amount
FROM buyTBL B, userTBL U
WHERE U.userID = B.userID AND U.height <= (SELECT AVG(height) FROM userTBL)
ORDER BY userID;



SELECT * FROM userTBL;
SELECT * FROM buyTBL;


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 중복제거 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
--  6) 구매한 적이 있었던 회원(중복 제거)
SELECT DISTINCT U.userID, U.name, U.addr     -- DISTINCT: 중복제거
FROM buyTBL B  -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID;


SELECT DISTINCT U.userID, U.name, U.addr   
	FROM userTBL U
	WHERE EXISTS (
	SELECT * FROM buyTBL B
	WHERE U.userID = B.userID
	);

-- !!!!!!!!오라클에서는 이렇게 씀(실무)!!!!!! 
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, U.height, B.prodName, B.amount
FROM buyTBL B, userTBL U
WHERE U.userID = B.userID;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ 내부 조인: many-to-many ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- 학생 - 학생_동아리 - 동아리 : many-to-many는 학생과 동아리가 바로 관계 불가능 -> 바로 조인 불가
-- 학생 테이블 (이름, 지역)
-- 동아리 테이블 (동아리명, 동아리방 호수)
-- 학생_동아리 (NO, 학생이름, 동아리명)

-- 각 학생의 이름 , 지역, 가입한 동아리, 동아리 방 정보를 검색
-- 학생 테이블에서 -> 학생_동아리 -> 동아리 테이블 

-- 1) 학생 테이블 생성 stuTBL
CREATE TABLE stuTBL
	(stuName VARCHAR(10) NOT NULL PRIMARY KEY,
	 addr CHAR(4) NOT NULL
);

-- 2) 동아리 테이블 생성 clubTBL
CREATE TABLE clubTBL
	(clubName VARCHAR(10) NOT NULL PRIMARY KEY,
	 roomNo CHAR(4) NOT NULL
); 

-- 3) 학생_동아리 테이블 생성 stuclubTBL
CREATE TABLE stuclubTBL
	(num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	 stuName VARCHAR(10) NOT NULL, 
	 clubName VARCHAR(10) NOT NULL,
FOREIGN KEY(stuName)  REFERENCES stuTBL(stuName),
FOREIGN KEY(clubName)  REFERENCES clubTBL(clubName)
); 

-- 4) 테이블 확인하기
DESC stuTBL;
DESC clubTBL ;
DESC stuclubTBL;

-- 5) 데이터 입력하기 (학생 테이블 -> 동아리 테이블 -> 학생_동아리 테이블 순서로 INSERT)
INSERT INTO stuTBL VALUES ('김범수', '경남'), ('성시경', '서울'), 
									('조용필', '경기'), ('은지원', '경북')
									('바비킴', '서울');

INSERT INTO stuTBL
SELECT DISTINCT U.name, U.addr     -- DISTINCT: 중복제거
FROM buyTBL B  -- 기준 테이블
	INNER JOIN userTBL U
	ON B.userID = U.userID
	ORDER BY U.name;

-- 데이터 확인
SELECT * FROM stuTBL;

-- 5-2) 동아리 테이블 INSERT
INSERT INTO clubTBL VALUES ('수영','101호'), ('바둑','102호'),
									('축구','103호'), ('봉사','104호');


-- 데이터 확인
SELECT * FROM clubTBL;

-- 5-3) 학생_동아리 테이블 INSERT
INSERT INTO stuclubTBL VALUES (NULL, '김범수', '바둑'), (NULL, '김범수', '축구'),
										(NULL, '조용필', '축구'), (NULL, '은지원', '축구'),
										(NULL, '은지원', '봉사'), (NULL, '바비킴', '봉사');

-- 데이터 확인
SELECT * FROM stuclubTBL;


-- !!!!다:다 관계에서 데이터 삭제 순서!!!!
-- 학생_동아리 테이블 삭제 -> 학생 테이블 삭제, 동아리 테이블 (자식을 먼저 삭제 후 부모 삭제)

-- 학생 기준으로 학생 이름, 지역, 가입한 동아리, 동아리방 출력
SELECT S.stuName, S.addr, C.clubName, C.roomNo 
FROM stuTBL S
	INNER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	INNER JOIN clubTBL C
		ON SC.clubName = C.clubName
ORDER BY S.stuName;

-- 동아리 기준으로 동아리 명, 동아리방, 학생 이름, 지역  (동아리 테이블 -> 학생_동아리 테이블 -> 학생 테이블)
SELECT C.clubName, C.roomNo, S.stuName, S.addr
FROM clubTBL C
	INNER JOIN stuclubTBL SC
		ON C.clubName = SC.clubName
	INNER JOIN stuTBL S
		ON SC.stuName = S.stuName
ORDER BY C.clubName;


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ outer join: 데이터 검증식 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

-- outer  join 비주류 데이터를 찾을 때 -> 소속되지 않은 학생, 또는 아무도 가입하지 않은 동아리

-- 회원이 구매 목록을 조인 -> 5명
-- 회원을 기준으로 구매 목록을 검색(구매하지 않은 회원도 포함[5명])

-- 회원이 모두 포함된 목록 (구매한 회원 + 구매 안 한 회원)
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM userTBL U  -- 기준 테이블
	LEFT OUTER JOIN buyTBL B 
	ON U.userID = B.userID
ORDER BY B.amount;

-- 구매하지 않은 회원 목록
SELECT  U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM userTBL U  -- 기준 테이블
	LEFT OUTER JOIN buyTBL B 
	ON B.userID = U.userID
WHERE B.prodName IS NULL -- 구매하지 않은 회원 목록
ORDER BY B.amount;

-- 모든 구매 목록이 나오도록 검색
-- 1) buyTBL을 LEFT OUTER JOIN 기준으로 만든다.
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM  buyTBL B-- 기준 테이블
	LEFT OUTER JOIN userTBL U 
	ON B.userID = U.userID
ORDER BY B.amount;

-- 2) 기존의 userTBL LEFT OUTER JOIN에서 기준만 변경    -- 보통은 left을 많이 씀. 
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM userTBL U  -- 기준 테이블
	RIGHT OUTER JOIN buyTBL B 
	ON U.userID = B.userID
ORDER BY B.amount;


-- 3) 회원과 구매 목록 모두 포함되는 데이터 검색
SELECT U.userID, U.name, CONCAT(U.mobile1, U.mobile2) AS "mobile", U.addr, B.prodName, B.amount
FROM userTBL U  -- 기준 테이블
	FULL OUTER JOIN buyTBL B 
	ON U.userID = B.userID
ORDER BY B.amount;


-- 3개의 테이블을 가지고 outer join

-- 학생 기준으로 학생 이름, 지역, 가입한 동아리, 동아리방 출력
-- 동아리에 가입하지 않은 학생도 포함.

SELECT S.stuName, S.addr, C.clubName, C.roomNo 
FROM stuTBL S
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	LEFT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName
ORDER BY C.clubName;

-- 동아리에 가입하지 않은 학생만 검색
SELECT S.stuName, S.addr, C.clubName, C.roomNo 
FROM stuTBL S  -- 기준 테이블
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	LEFT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName
WHERE C.clubName IS NULL
ORDER BY C.clubName;

-- 아무도 가입하지 않은 동아리 검색
-- 1) 동아리 기준으로 left outer join
SELECT C.clubName, C.roomNo , S.stuName, S.addr
FROM clubTBL C 
	LEFT OUTER JOIN stuclubTBL SC
		ON C.clubName = SC.clubName
	LEFT OUTER JOIN stuTBL S 
		ON SC.stuName = S.stuName
WHERE S.stuName IS NULL
ORDER BY C.clubName;

-- 2) right outer join으로 변경
SELECT C.clubName, C.roomNo , S.stuName, S.addr
FROM stuTBL S
	RIGHT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	RIGHT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName
WHERE S.stuName IS NULL
ORDER BY C.clubName;


SELECT C.clubName, C.roomNo , S.stuName, S.addr
FROM stuTBL S
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	RIGHT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName
WHERE S.stuName IS NULL
ORDER BY C.clubName;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ full outer join -> union을 사용해서 쿼리로 통합시키기 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 동아리에 가입 안 한 학생(1), 동아리에 가입한 학생(6), 한명도 가입하지 않은 동아리(1) -> 8 row 예상


SELECT S.stuName, S.addr, C.clubName, C.roomNo 
FROM stuTBL S
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	LEFT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName
UNION
SELECT S.stuName, S.addr, C.clubName, C.roomNo
FROM stuTBL S
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	RIGHT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName;

-- 컬럼의 수를 맞추기, 컬럼의 데이터 타임을 맞추기
-- 컬럼의 수를 맞추지 못할 경우엔 NULL로 처리해서 합치기 가능
SELECT S.stuName, S.addr, C.clubName, C.roomNo 
FROM stuTBL S
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	LEFT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName
UNION
SELECT S.stuName, S.addr, C.clubName, NULL -- or 0
FROM stuTBL S
	LEFT OUTER JOIN stuclubTBL SC
		ON S.stuName = SC.stuName
	RIGHT OUTER JOIN clubTBL C
		ON SC.clubName = C.clubName;

-- UNION(중복 제거한 후 합침)
SELECT stuName, addr FROM stuTBL
UNION 
SELECT clubName, roomNO FROM clubTBL;

-- UNION ALL (중복 제거 하지 않고 합침 -> 속도가 빠름)
SELECT stuName, addr FROM stuTBL
UNION ALL
SELECT clubName, roomNO FROM clubTBL;

-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ cross join ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- cross join -> 조인 조건이 없음. 테이블 * 테이블의 수가 검색(더미 데이터 만들 때 사용 많이 함.)
-- 의미 있는 데이터 조건은 아님
-- 조인할 때 조인 조건 확인 필수!!! ON 또는 WHERE 절에 조인 조건 확인.
SELECT * FROM buyTBL
	CROSS JOIN userTBL;  -- 12 * 10

SELECT * FROM buyTBL, userTBL, stuTBL;  -- where을 빼먹은 경우 



-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ self join ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
-- 1) empTBL을 생성
CREATE TABLE empTBL (emp CHAR(3), manager CHAR (3), empTel VARCHAR(8));

-- 2) 데이터 INSERT 
INSERT INTO empTBL VALUES('나사장',NULL,'0000');
INSERT INTO empTBL VALUES('김재무','나사장','2222');
INSERT INTO empTBL VALUES('김부장','김재무','2222-1');
INSERT INTO empTBL VALUES('이부장','김재무','2222-2');
INSERT INTO empTBL VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTBL VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTBL VALUES('이영업','나사장','1111');
INSERT INTO empTBL VALUES('한과장','이영업','1111-1');
INSERT INTO empTBL VALUES('최정보','나사장','3333');
INSERT INTO empTBL VALUES('윤차장','최정보','3333-1');
INSERT INTO empTBL VALUES('이주임','윤차장','3333-1-1');

-- 3) 데이터 확인
SELECT * FROM empTBL;

-- 김부장님의 직속 상관 명과 연락처를 검색

-- 1) 김부장님 검색
SELECT * FROM empTBL WHERE emp = '김부장';

-- 2) 직속 상관 서브 쿼리로 해결
SELECT emp, empTel FROM empTBL
WHERE emp = (SELECT manager FROM empTBL WHERE emp = '김부장');

-- 부하직원명, 지속상관명, 직속상관 연락처
-- SELF JOIN 정보를 검색 -> 연결할 수 있는 컬럼 emp -> manger
SELECT A.emp AS "부하직원", A.manager AS "직속상관", B.empTel AS "직속상광 번호" 
FROM empTBL A
	INNER JOIN empTBL B
	ON A.manager = B.emp;
-- WHERE A.emp = '김부장';

-- 사장님도 포함해서 정보 추출
SELECT A.emp AS "부하직원", A.manager AS "직속상관", B.empTel AS "직속상광 번호" 
FROM empTBL A
	LEFT OUTER JOIN empTBL B
	ON A.manager = B.emp;

-- 직속상관이 없는 직원만 검색
SELECT A.emp AS "부하직원", A.manager AS "직속상관", B.empTel AS "직속상광 번호" 
FROM empTBL A
	LEFT OUTER JOIN empTBL B
	ON A.manager = B.emp
WHERE A.manager IS NULL;


-- ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡproc

-- IF ELSE END IF 사용해서 프로시저를 등록, 호출
-- employees DB의 employees 테이블에 입사일(hire_date)이 얼마나 됐는지 출력하는 프로시저를 생성 호출

-- 1) 입사일 계산하는 쿼리부터 생성
-- 오늘 날짜에서 입사일(hire_date)의 차이 계산.
DESC employees.employees;  -- 데이터 확인

SELECT emp_no, DATEDIFF(CURRENT_DATE(),hire_date) AS "근무일수",
		 TRUNCATE (DATEDIFF(CURRENT_DATE(),hire_date) / 365, 0) AS "근무년수"
 FROM employees.employees;

-- 2) 입사일이 35년 이상 넘은 사람만 출력하도록 조건을 줘서 실행하는 프로시저 등록
DROP PROCEDURE IF EXISTS checkHiredateProc;
DELIMITER $$
CREATE PROCEDURE checkHiredateProc(IN empno INT)
BEGIN
	DECLARE hireDATE DATE; -- 입사일
	DECLARE curDATE DATE;  -- 오늘 날짜
	DECLARE days INT;      -- 근무일수
	
	SELECT hire_date INTO hireDATE -- hire_date 컬럼의 데이터를 hireDATE  변수에 담기
		FROM employees.employees
		WHERE emp_no = empno;
		
	SET curDATE = CURRENT_DATE();
	SET days = DATEDIFF(CURRENT_DATE(), hireDATE);
	
	IF (days/365) >= 35 THEN  -- 35년이 지났으면
					SELECT CONCAT('근무년수 ', TRUNCATE(days/365,0),  ' 입사한지 ', days, '일이 지났습니다. 축하합니다!') AS result;
	ELSE
					SELECT CONCAT('근무년수 ', TRUNCATE(days/365,0), ' 입사한지 ', days, '일이 지났습니다. 열심히 일하세요.') AS result;

	END IF;
	
END $$ 
DELIMITER ;

CALL
 checkHiredateProc(10008);



