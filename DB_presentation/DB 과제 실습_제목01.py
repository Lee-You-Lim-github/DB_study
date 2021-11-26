import pymysql
from tkinter import *
from tkinter import messagebox

window = Tk()
window.geometry("1300x1000")
window.title("NETFLIX TOP10")
window.configure(background = "black")

def click_TVpro_btn_select():
    messagebox.showinfo("버튼 클릭", "버튼을 클릭했습니다.")


# 제목 라벨 선언
nexflix_first_titile = Label(window, text = "NEFLIX", bg="black", font=("System", 40), fg = "red")
nexflix_second_titile = Label(window, text="TOP10", bg="black", font=("System", 30), fg="white")
nexflix_first_titile.pack()
nexflix_second_titile.pack()

# 버튼 설정
btn_TVpro = Button(window, text="요기 눌러요", fg="red", bg="yellow", command=click_TVpro_btn_select)
btn_TVpro.pack(side = LEFT, padx = 300, pady = 300)



























































window.mainloop()