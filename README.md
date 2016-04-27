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
 
# Acknowledgment

This is a customised version built upon the base code of Matthias Felleisen [here](https://github.com/mfelleisen/sample-fsm)

The initial code of this project received a lot of critical contribution by Hoang Minh Thang. At the early stage, it is from [this paper](http://www.pnas.org/content/109/25/9929.abstract) that we got inspiration for the simulation workflow.

Along the way of the development of this project, the code benefits tremendously from discussions on racket mailing list [here](https://groups.google.com/forum/?hl=en-GB#!topic/racket-users/4o1goSwrLHA), IRC #racket [here](http://pastebin.com/sxrCnwRV) and StackExchange.

The file "csv.rkt" has external copyright condition which can be found in its own file.

