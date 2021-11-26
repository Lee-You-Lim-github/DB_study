-- 퀴리 2개를 한 번에 실행하는 myProc()라는 프로시저를 생성

-- 1) 퀴리 2개 준비
SELECT * FROM memberTBL WHERE memberName = '당탕이';
SELECT * FROM productTBL WHERE productName = '냉장고';

-- 2)  myProc()라는 프로시저를 생성
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
	SELECT * FROM memberTBL WHERE memberName = '당탕이';
	SELECT * FROM productTBL WHERE productName = '냉장고';   -- 선택 실행 해야함.
END //
DELIMITER ;

-- 3) myproc() 호출
CALL myProc()