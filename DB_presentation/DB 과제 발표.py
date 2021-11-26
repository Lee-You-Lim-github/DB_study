import pymysql
from tkinter import *
from tkinter import messagebox

# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

def backFrame1():
    MovieFrame.pack_forget()
    TV_progFrame.pack_forget()

def backFrame2():
    MovieFrame.pack_forget()
    TV_progFrame.pack_forget()


# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

def click_TVprog_btn_select():
    conn = None
    cur = None

    TV_progFrame.pack()

    l1Title, l1Episodes, l1Country, \
    l1Genre, l1English, l1Hour_viewed\
        = [], [], [], [], [], []

    # 데이터베이스 접속
    conn = pymysql.connect\
        (host="127.0.0.1",
         user="root",
         password="1234", db="netflix_proj",
         charset="utf8")
    # 커서
    cur = conn.cursor()

    # 데이터 초기화
    l1Title.append("제목")
    l1Title.append("-----------")

    l1Episodes.append("회차")
    l1Episodes.append("-----------")

    l1Country.append("국가")
    l1Country.append("-----------")

    l1Genre.append("장르")
    l1Genre.append("-----------")

    l1English.append("영어를 쓰는가?")
    l1English.append("-----------")

    l1Hour_viewed.append("시청 시간")
    l1Hour_viewed.append("-----------")

    # select 기능 구현
    sql = "SELECT title, IFNULL(episodes, '???'), " \
          "IFNULL(country, '???'), genre, english, " \
          "CONCAT(hour_viewed, '만 시간') " \
          "FROM netflixTV_nonTBL " \
          "ORDER BY hour_viewed DESC"

    print(sql)
    cur.execute(sql)


    while (True):
        row = cur.fetchone()  # db에서 가져온 값
        if row == None:
            break

        l1Title.append(row[0])  # db에서 가져온 값
        l1Episodes.append(row[1])
        l1Country.append(row[2])
        l1Genre.append(row[3])
        l1English.append(row[4])
        l1Hour_viewed.append(row[5])

    # 1) 리스트 박스 초기화(기존 데이터 삭제)
    list1Title.delete(0, list1Title.size() - 1)
    list1Episodes.delete(0, list1Episodes.size() - 1)
    list1Country.delete(0, list1Country.size() - 1)
    list1Genre.delete(0, list1Genre.size() - 1)
    list1English.delete(0, list1English.size() - 1)
    list1Hour_viewed.delete(0, list1Hour_viewed.size() - 1)

    # 2) select 해온 데이터 insert
    for item1, item2, item3, item4, item5, item6 \
            in zip(l1Title, l1Episodes, l1Country,
                   l1Genre, l1English, l1Hour_viewed):
        list1Title.insert(END, item1)
        list1Episodes.insert(END, item2)
        list1Country.insert(END, item3)
        list1Genre.insert(END, item4)
        list1English.insert(END, item5)
        list1Hour_viewed.insert(END, item6)

    conn.close()

def click_movie_btn_select():
    conn = None
    cur = None

    MovieFrame.pack()

    l2Title, l2Country, l2Genre, l2English, l2Hour_viewed \
        = [], [], [], [], []

    # 데이터베이스 접속
    conn = pymysql.connect\
        (host="127.0.0.1", user="root",
         password="1234", db="netflix_proj", charset="utf8")
    # 커서
    cur = conn.cursor()

    # 데이터 초기화
    l2Title.append("제목")
    l2Title.append("-----------")

    l2Country.append("국가")
    l2Country.append("-----------")

    l2Genre.append("장르")
    l2Genre.append("-----------")

    l2English.append("영어를 쓰는가?")
    l2English.append("-----------")

    l2Hour_viewed.append("시청 시간")
    l2Hour_viewed.append("-----------")

    # select 기능 구현
    sql = "SELECT title, " \
          "IFNULL(country, '???'), genre, english, " \
          "CONCAT(hour_viewed, '만 시간') " \
          "FROM netflixMovie_nonTBL " \
          "ORDER BY hour_viewed DESC"

    print(sql)
    cur.execute(sql)


    while (True):
        row = cur.fetchone()  # db에서 가져온 값
        if row == None:
            break

        l2Title.append(row[0])  # db에서 가져온 값
        l2Country.append(row[1])
        l2Genre.append(row[2])
        l2English.append(row[3])
        l2Hour_viewed.append(row[4])

    # 1) 리스트 박스 초기화(기존 데이터 삭제)
    list2Title.delete(0, list2Title.size() - 1)
    list2Country.delete(0, list2Country.size() - 1)
    list2Genre.delete(0, list2Genre.size() - 1)
    list2English.delete(0, list2English.size() - 1)
    list2Hour_viewed.delete(0, list2Hour_viewed.size() - 1)

    # 2) select 해온 데이터 insert
    for item1, item2, item3, item4, item5 \
            in zip(l2Title, l2Country,
                   l2Genre, l2English, l2Hour_viewed):
        list2Title.insert(END, item1)
        list2Country.insert(END, item2)
        list2Genre.insert(END, item3)
        list2English.insert(END, item4)
        list2Hour_viewed.insert(END, item5)

    conn.close()

# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

# GUI 화면 구성
window = Tk()
window.geometry("1300x1000")
window.title("NETFLIX TOP10")
window.configure(background = "black")

# 제목 라벨 선언
nexflix_first_titile = Label(window, text = "NEFLIX", bg="black", font=("System", 60), fg = "red")
nexflix_second_titile = Label(window, text="TOP10", bg="black", font=("System", 45), fg="white")
nexflix_first_titile.pack()
nexflix_second_titile.pack()


TV_progFrame = Frame(window)
TV_progFrame.pack(side = BOTTOM, fill = BOTH, expand = 1)
TV_progFrame.pack_forget()

MovieFrame = Frame(window)
MovieFrame.pack(side = BOTTOM, fill = BOTH, expand = 1)
MovieFrame.pack_forget()

# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

# 버튼 설정
btn_TVpro = Button(window, text="TV 프로그램", font=("System", 20),
                   fg="black", bg="red", command=click_TVprog_btn_select)
btn_TVpro.pack(side = TOP, padx = 10, pady = 10)

# 버튼 설정
btn_Movie = Button(window, text="영화", font=("System", 15),
                   fg="black", bg="red", command=click_movie_btn_select)
btn_Movie.pack(side = TOP, padx = 10, pady = 10)

btn_esc = Button(window, text="종료", font=("System", 15),fg="black", bg="red", command=window.destroy)
btn_esc.pack(side = TOP, padx = 10, pady = 10)

# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
btnBack1 = Button(TV_progFrame, text ='돌아가기', command = backFrame1)
btnBack1.pack(side = BOTTOM, padx = 10, pady = 10)

btnBack2 = Button(MovieFrame, text ='돌아가기', command = backFrame2)
btnBack2.pack(side = BOTTOM, padx = 10, pady = 10)


# list ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

list1Title = Listbox(TV_progFrame, width = 30, height = 20)
list1Title.pack(side = LEFT, fill = BOTH, expand = 1)

list1Episodes = Listbox(TV_progFrame, width = 30, height = 20)
list1Episodes.pack(side = LEFT, fill = BOTH, expand = 1)

list1Country = Listbox(TV_progFrame, width = 30, height = 20)
list1Country.pack(side = LEFT, fill = BOTH, expand = 1)

list1Genre = Listbox(TV_progFrame, width = 30, height = 20)
list1Genre.pack(side = LEFT, fill = BOTH, expand = 1)

list1English = Listbox(TV_progFrame, width = 30, height = 20)
list1English.pack(side = LEFT, fill = BOTH, expand = 1)

list1Hour_viewed = Listbox(TV_progFrame, width = 30, height = 20)
list1Hour_viewed.pack(side = LEFT, fill = BOTH, expand = 1)

# ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
list2Title = Listbox(MovieFrame, width = 30, height = 20)
list2Title.pack(side = LEFT, fill = BOTH, expand = 1)

list2Country = Listbox(MovieFrame, width = 30, height = 20)
list2Country.pack(side = LEFT, fill = BOTH, expand = 1)

list2Genre = Listbox(MovieFrame, width = 30, height = 20)
list2Genre.pack(side = LEFT, fill = BOTH, expand = 1)

list2English = Listbox(MovieFrame, width = 30, height = 20)
list2English.pack(side = LEFT, fill = BOTH, expand = 1)

list2Hour_viewed = Listbox(MovieFrame, width = 30, height = 20)
list2Hour_viewed.pack(side = LEFT, fill = BOTH, expand = 1)



window.mainloop()