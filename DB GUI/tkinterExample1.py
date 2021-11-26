from tkinter import *

# 문자를 표현할 수 있는 라벨 사용

window = Tk()
window.title("라벨연습")
window.geometry("400x100")  # 넓이 * 높이
# window 고정 시키기 -> 윈도우 사이즈 고정
window.resizable(width=FALSE, height=FALSE)

# 라벨 선언
label1 = Label(window, text="This is MariaDB를")
label2 = Label(window, text="열심히", font=("궁서체", 30), fg="blue")
label3 = Label(window, text="공부 중입니다.", bg="magenta", width=20, height=5, anchor=SE)
# 레이블이 올라갈(부모) 윈도우, 출력될 글, 설정: font, fg=글자색, bg=배경색, anchor=글자의 위치(south East)

# 위젯 적용
label1.pack()
label2.pack()
label3.pack()

window.mainloop()
