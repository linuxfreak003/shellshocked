import sys, os

KNRM = "\x1B[0m"
KRED = "\x1B[31m"
KGRN = "\x1B[32m"
KYEL = "\x1B[33m"
KBLU = "\x1B[34m"
KMAG = "\x1B[35m"
KCYN = "\x1B[36m"
KWHT = "\x1B[37m"


history = []
aliases = {}

def execute(args):
    if args[0] == "exit":
        return 0
    if args[0] == "cd" and len(args) > 1:
        os.chdir(args[1])
        return 1
    if args[0] == "cd":
        os.chdir(os.getenv("HOME") )
        return 1
    if args[0] == "history":
        for i in range(len(history)):
            print(i,history[i])
        return 1
    n = os.fork()
    if n == 0:
        os.execvp(args[0], args)
        exit(0)
    os.wait()


def shell_loop():
    status = 1
    while(status != 0):
        cwd = os.getcwd()
        command = input("%s%s$ %s" %(KCYN, cwd, KNRM) )
        if command.strip() == "exit":
            status = 0;
        history.append(command)
        args = command.split()
        status = execute(args)

def main():
    # Load Config files

    status = shell_loop()

    #Cleanup, if needed

if __name__ == "__main__":
    main()
