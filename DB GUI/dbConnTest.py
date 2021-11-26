import pymysql

conn = None
cur = None

# 데이터베이스 접속
conn = pymysql.connect(
    host="127.0.0.1", user="root", password="1234", db="sqlDB", charset="utf8"
)

# 커서
cur = conn.cursor()

# userTBL의 회원 데이터 Insert
sql = ""
# userID, name, birthYear, addr -- not null
# 과제: mobile1, mobile2, height와 함께 올리기

userID = ""
name = ""
birthYear = ""
addr = ""
mobile1 = ""
mobile2 = ""
height = ""

while(True):
    userID = input("사용자 ID ==> ")
    if userID == "" :
        break
    name = input("사용자 이름 ==> ")
    birthYear = input("사용자 출생년도 ==> ")
    addr = input("사용자 주소 ==> ")
    mobile1 = input("사용자 휴대폰 번호 앞자리 ==> ")
    mobile2 = input("사용자 휴대폰 번호 뒷자리 ==> ")
    height = input("사용자 키 ==> ")

    sql = "INSERT INTO userTBL (userID, name, birthYear, addr, mDate, mobile1, mobile2, height) VALUE " \
          "('"+userID+"', '"+name+"', "+birthYear+", '"+addr+"', CURDATE(), '"+mobile1+"', '"+mobile2+"', "+height+")"
    cur.execute(sql)

conn.commit()  # commit을 해야 저장됨.
conn.close()







