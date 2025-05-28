# fsm-pd

in general (and inside mathematica), the command to run is

```
racket -tm side.rkt
```

with -tm and no further specification, racket will evaluate the function `main defined inside the file side.rkt

```
raco test -s five main.rkt 
```

## To do

| To do         | Date          | By    | Note |
| ------------- |:-------------:| ----- |:----:|
| spin off from fsm-bar      | 3 jan 16 | chi | |
| revise !!! added mutation and deltas  | |||
 

🧠 Mục tiêu và Nội dung Dự Án

Repository fsm-pd là một nhánh phát triển từ dự án fsm-bar, tập trung vào mô phỏng các máy trạng thái hữu hạn (finite state machines - FSM) trong bối cảnh trò chơi lặp lại (repeated games), có thể là biến thể của trò chơi tù nhân (prisoner's dilemma).  Dự án được triển khai bằng ngôn ngữ Racket, một ngôn ngữ thuộc họ Lisp, và có tích hợp với Mathematica để xử lý và trực quan hóa dữ liệu. 


---

📁 Cấu Trúc Dự Án

Dự án bao gồm nhiều tệp mã nguồn .rkt và một số tệp hỗ trợ khác: 

automata.rkt: Xử lý logic của các máy trạng thái hữu hạn.

population.rkt: Quản lý quần thể các FSM, bao gồm các thao tác như tiến hóa và đột biến.

side.rkt: Chứa hàm main để khởi chạy mô phỏng.

deltas.rkt: Xử lý các thay đổi trạng thái hoặc đột biến.

csv.rkt và inout.rkt: Xử lý nhập/xuất dữ liệu, có thể để ghi lại kết quả mô phỏng.

test.rkt: Chứa các bài kiểm tra để đảm bảo tính đúng đắn của mã nguồn.

auto-code.nb và run-in-matha.nb: Tệp notebook của Mathematica, có thể dùng để phân tích và trực quan hóa dữ liệu.

mean100.png và mean2.png: Hình ảnh biểu diễn kết quả mô phỏng. 


# Acknowledgment

This is a customised version built upon the base code of Matthias Felleisen [here](https://github.com/mfelleisen/sample-fsm)

The initial code of this project received a lot of critical contribution by Hoang Minh Thang. At the early stage, it is from [this paper](http://www.pnas.org/content/109/25/9929.abstract) that we got inspiration for the simulation workflow.

Along the way of the development of this project, the code benefits tremendously from discussions on racket mailing list [here](https://groups.google.com/forum/?hl=en-GB#!topic/racket-users/4o1goSwrLHA), IRC #racket [here](http://pastebin.com/sxrCnwRV) and StackExchange.

The file "csv.rkt" has external copyright condition which can be found in its own file.

