import pymysql
from tkinter import *
from tkinter import messagebox


# 데이터베이스 연동 함수
def insertDate():
    conn = None
    cur = None

    # 데이터베이스 접속
    conn = pymysql.connect(
        host="127.0.0.1", user="root", password="1234", db="sqlDB", charset="utf8"
    )
    # 커서
    cur = conn.cursor()

    # 회원 정보 insert 구현 가능
    userID, name, birthYear, addr = "", "", "", ""

    # GUI 에서 입력한 데이터 담기
    userID = edt1.get()
    name = edt2.get()
    birthYear = edt3.get()
    addr = edt4.get()

    # sql 쿼리 만들기
    sql = "INSERT INTO userTBL (userID, name, birthYear, addr, mDate) VALUE " \
          "('" + userID + "', '" + name + "', " + birthYear + ", '" + addr + "', CURDATE())"

    print(sql)  #배포할 때는 지워야 함.
    # 쿼리 실행
    try:    # 오류가 발생하면 except 구문으로 들어감.
        cur.execute(sql)
    except:   # 오류가 났을 때 프로그램 강제 종류를 막고 유지하기 위해
        messagebox.showerror("입력 오류", "데이터 입력 오류가 발생 했습니다.")
    else:
        # 쿼리 실행이 완료(오류 없이)
        # 1) 메시지박스로 성공 알림
        messagebox.showinfo("성공", "회원 정보가 등록 되었습니다.")
        # 2) 데이터 커밋(진짜 저장)
        conn.commit()
        # 3) 테이블 조회(새로고침)
        selectDate()
    
    # GUI에 입력한 데이터 삭제,    등록을 한 후 입력한 데이터가 남아 있으므로 다음에 입력할 때 남아 있는 데이터를 지워 줌.
    edt1.delete(0, "end")
    edt2.delete(0, "end")
    edt3.delete(0, "end")
    edt4.delete(0, "end")
    
    # DB 접속 종료
    conn.close()

def selectDate():
    conn = None
    cur = None

    lUserID, lName, lBirthYear, lAddr = [], [], [], []

    # 데이터베이스 접속
    conn = pymysql.connect(host="127.0.0.1", user="root", password="1234", db="sqlDB", charset="utf8")

    # 커서
    cur = conn.cursor()
    # 데이터 초기화
    lUserID.append("회원 ID")
    lUserID.append("-----------")
    
    lName.append("회원명")
    lName.append("-----------")
    
    lBirthYear.append("출생년도")
    lBirthYear.append("-----------")
    
    lAddr.append("회원주소")
    lAddr.append("-----------")

    # select 기능 구현
    sql = "SELECT userID, name, birthYear, addr from userTBL ORDER BY mDate DESC"
    cur.execute(sql)

    while(True):
        row = cur.fetchone()  # db에서 가져온 값

        if row == None:
            break
        # lUserID, lName, lBirthYear, lAddr
        lUserID.append(row[0])       # db에서 가져온 값
        lName.append(row[1])
        lBirthYear.append(row[2])
        lAddr.append(row[3])

    # GUI ListBox에 insert
    # listUserID, listName, listBirthYear, listAddr

    # 1) 리스트 박스 초기화(기존 데이터 삭제)
    listUserID.delete(0, listUserID.size() -1)   #listUserID는 gui
    listName.delete(0, listName.size() - 1)
    listBirthYear.delete(0, listBirthYear.size() - 1)
    listAddr.delete(0, listAddr.size() - 1)

    # 2) select 해온 데이터 insert
    for item1, item2, item3, item4 in zip(lUserID, lName, lBirthYear, lAddr):
        listUserID.insert(END, item1)
        listName.insert(END, item2)
        listBirthYear.insert(END, item3)
        listAddr.insert(END, item4)

    conn.close()

# GUI 화면 구성
window = Tk()
window.geometry("800x400")
window.title("MariaDB 연동 GUI")

editFrame = Frame(window)
editFrame.pack()

listFrame = Frame(window)
listFrame.pack(side = BOTTOM, fill = BOTH, expand = 1)

label1 = Label(editFrame, text = "회원 ID")
label1.pack(side = LEFT, padx = 10, pady = 10)

edt1 = Entry(editFrame, width = 10)
edt1.pack(side = LEFT, padx = 10, pady = 10)

label2 = Label(editFrame, text = "회원명")
label2.pack(side = LEFT, padx = 10, pady = 10)

edt2 = Entry(editFrame, width = 10)
edt2.pack(side = LEFT, padx = 10, pady = 10)

label3 = Label(editFrame, text = "출생년도")
label3.pack(side = LEFT, padx = 10, pady = 10)

edt3 = Entry(editFrame, width = 10)
edt3.pack(side = LEFT, padx = 10, pady = 10)

label4 = Label(editFrame, text = "주소")
label4.pack(side = LEFT, padx = 10, pady = 10)

edt4 = Entry(editFrame, width = 10)
edt4.pack(side = LEFT, padx = 10, pady = 10)

# 버튼
btnInsert = Button(editFrame, text = '입력', command = insertDate)
btnInsert.pack(side = LEFT, padx = 10, pady = 10)

btnInsert = Button(editFrame, text = '조회', command = selectDate)
btnInsert.pack(side = LEFT, padx = 10, pady = 10)


listUserID = Listbox(listFrame)
listUserID.pack(side = LEFT, fill = BOTH, expand = 1)

listName = Listbox(listFrame)
listName.pack(side = LEFT, fill = BOTH, expand = 1)

listBirthYear = Listbox(listFrame)
listBirthYear.pack(side = LEFT, fill = BOTH, expand = 1)

listAddr = Listbox(listFrame)
listAddr.pack(side = LEFT, fill = BOTH, expand = 1)

window.mainloop()






















