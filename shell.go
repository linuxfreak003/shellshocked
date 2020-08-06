package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"os/user"
	"strings"

	"github.com/gookit/color"
)

var aliases = map[string][]string{
	"ls": {"ls", "--color=auto"},
	"ll": {"ls", "-la"},
}

func JshReadLine() string {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	return scanner.Text()
}

func JshLaunch(args []string) int {
	for c, a := range aliases {
		if args[0] == c {
			args = append(a, args[1:]...)
		}
	}
	fmt.Printf("Starting command:\n%v", args)
	cmd := exec.Command(args[0], args[1:]...)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	err := cmd.Run()
	if err != nil {
		fmt.Fprintf(os.Stderr, "jsh: error: %v\n", err)
	}
	return 1
}

var builtIn = map[string]func([]string) int{
	"cd":   JshCd,
	"exit": JshExit,
}

func JshCd(args []string) int {
	if len(args) <= 1 {
		fmt.Fprintf(os.Stderr, "jsh: expected argument to \"cd\"\n")
		return 1
	}
	if err := os.Chdir(args[1]); err != nil {
		fmt.Fprintf(os.Stderr, "jsh: could not cd to '%s': %v\n", args[1], err)
	}
	return 1
}

func JshExit([]string) int {
	return 0
}

func JshExecute(args []string) int {
	if len(args) == 0 {
		return 1
	}

	for c, f := range builtIn {
		if c == args[0] {
			return f(args)
		}
	}
	return JshLaunch(args)
}

func JshSplitLine(line string) []string {
	return strings.Fields(line)
}

func JshLoop() {
	for {
		c := color.New(color.FgCyan)
		cwd, _ := os.Getwd()
		host, _ := os.Hostname()
		user, _ := user.Current()
		c.Printf("%s@%s:%s$ ", user.Username, host, cwd)
		line := JshReadLine()

		args := JshSplitLine(line)
		if JshExecute(args) == 0 {
			break
		}
	}
}

func main() {
	fmt.Printf("Starting shell.\n")
	JshLoop()
	fmt.Printf("Exiting shell.\n")
}
