-- TODO : memberTBL 테이블에서 회원이 삭제되면 다른 백업 테이블로 회원 정보 이전

-- 1) 백업 테이블 만들기 : deletedMemberTBL -> memberTBL의 테이블 구조 반영
CREATE TABLE deletedMemberTBL (
	memberID char(8),
	memberName char(5),
	memberAddress char(20),
	deletedDate date
);

-- 2) 트리거 생성 trg_deletedMenberTBL

DELIMITER //
CREATE TRIGGER trg_deletedMenberTBL   -- 트리거 이름
	AFTER DELETE  -- 삭제 후에 작동하도록 지정
	ON memberTBL  -- 트리거를 부착할 테이블 명
	fOR EACH ROW  -- 각 행마다 적용
BEGIN 
	-- OLD 테이블의 내용을 백업테이블에 삽입(실제 실행쿼리)
	INSERT INTO deletedMemberTBL
		VALUES (OLD.memberID, OLD.memberName, OLD.memberAddress, CURDATE());
END //
DELIMITER ;

-- 3) 백업 테이블 확인 deletedMemberTBL
SELECT * FROM deletedMemberTBL;

-- 4) memberTBL 삭제 전에 확인
SELECT * FROM memberTBL;

-- 5) memberTBL에 memberName이 당탱이인 회원 삭제
DELETE FROM memberTBL WHERE memberName = '당탕이';

