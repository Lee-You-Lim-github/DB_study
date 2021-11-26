from tkinter import *
from tkinter import messagebox

# 버튼을 사용하여 알림 창 띄우기
def clickButton():
    messagebox.showinfo("버튼 클릭", "버튼을 클릭했습니다.")  # (messagebox 타이틀, messagebox 내용)
    # 문제 없이 됨(!)


window = Tk()
window.title("버튼 이벤트 연습")
window.geometry("200x200")

button1 = Button(window, text="요기 눌러요", fg="red", bg="yellow", command=clickButton)
button1.pack(expand=1)


window.mainloop()
