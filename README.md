# fsm-pd

in general (and inside mathematica), the command to run is

```
racket -tm side.rkt
```

with -tm and no further specification, racket will evaluate the function `main defined inside the file side.rkt

### how to run in lab 1 computer:

- change the directory for the output into a dropbox folder
(ie smt like: "/Users/linhchi.nguyen/Dropbox/fsm-bar/run1/mean.png")

```
(require (file "/Users/linhchi.nguyen/Documents/fsm-bar/main.rkt"))

```

### how to run in disa lab computer:
- change directory for output:
"C:/Documents and Settings/linhchi.nguyen/My Documents/Dropbox/fsm-bar/run6/mean"

```
(require (file "R:/fsm-bar/main.rkt"))
```

#### extra

```
raco test -s five main.rkt 
```

## To do

| To do         | Date          | By    | Note |
| ------------- |:-------------:| ----- |:----:|
| spin off from fsm-bar      | 3 jan 16 | chi | |
 
# Acknowledgment

Applied as in [fsm-bar](https://github.com/ayaderaghul/fsm-bar)

