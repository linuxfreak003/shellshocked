#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

typedef struct pair pair;
struct pair {
	char * first;
	char * second;
};

struct pair aliases[2] = {
	{"ls", "ls --color=auto"},
	{"ll", "ls -la"}
};

int num_aliases() {
	return sizeof(aliases) / sizeof(char *);
}

char * jsh_read_line() {
	char *line = NULL;
	ssize_t bufsize = 0;
	getline(&line, &bufsize, stdin);
	return line;
}

int jsh_launch(char **args) {
	pid_t pid, wpid;
	int status;

	pid = fork();

	if (pid == 0) {
		// Is child process
		/*
		for (int i = 0; i < num_aliases(); i++) {
			if (strcmp(args[0], aliases[i].first) == 0) {
				args[0] = aliases[i].second;
				if (execvp(args[0], args) == -1) {
					perror("jsh");
				}
				exit(EXIT_FAILURE);
			}
		}
		*/
		if (execvp(args[0], args) == -1) {
			perror("jsh");
		}
		exit(EXIT_FAILURE);
	} else if (pid < 0) {
		// Forking error
		perror("jsh");
	} else {
		// Is parent process
		do {
			wpid = waitpid(pid, &status, WUNTRACED);
		} while (!WIFEXITED(status) && !WIFSIGNALED(status));
	}

	return 1;
}

int jsh_cd(char **args);
int jsh_exit(char **args);

char *builtin_str[] = {
	"cd",
	"exit"
};

int (*builtin_func[]) (char **) = {
	&jsh_cd,
	&jsh_exit
};

int jsh_num_builtins() {
	return sizeof(builtin_str) / sizeof(char *);
}

int jsh_cd(char **args) {
	if (args[1] == NULL) {
		fprintf(stderr, "lsh: expected argument to \"cd\"\n");
	} else {
		if (chdir(args[1]) != 0) {
			perror("lsh");
		}
	}

	return 1;
}

int jsh_exit(char **args) {
	return 0;
}

int jsh_execute(char** args) {
	int i;

	if (args[0] == NULL) {
		// Empty command
		return 1;
	}

	for (i = 0; i < jsh_num_builtins(); i++) {
		if (strcmp(args[0], builtin_str[i]) == 0) {
			return (*builtin_func[i])(args);
		}
	}

	return jsh_launch(args);
}

#define JSH_TOK_BUFSIZE 64
#define JSH_TOK_DELIM " \t\r\n\a"
char ** jsh_split_line(char * line) {
	int bufsize = JSH_TOK_BUFSIZE, position = 0;
	char **tokens = malloc(bufsize * sizeof(char*));
	char * token;
	if (!tokens) {
		fprintf(stderr, "jsh: allocation error\n");
		exit(EXIT_FAILURE);
	}

	token = strtok(line, JSH_TOK_DELIM);
	while (token != NULL) {
		tokens[position] = token;
		position++;

		if (position >= bufsize) {
			bufsize += JSH_TOK_BUFSIZE;
			tokens = realloc(tokens, bufsize * sizeof(char*));
			if (!tokens) {
				fprintf(stderr, "jsh: allocation error\n");
				exit(EXIT_FAILURE);
			}
		}

		token = strtok(NULL, JSH_TOK_DELIM);
	}
	tokens[position] = NULL;
	return tokens;
}

void jsh_loop(void) {
	char *line;
	char ** args;
	int status;
	char cwd[1024];

	do {
		getcwd(cwd, sizeof(cwd));
		printf("%s%s$ %s", KCYN, cwd, KNRM);
		line = jsh_read_line();
		//printf("%s", line);
		if (strcmp(line, "exit\n") == 0) {
			status = 0;
		} else {
			status = 1;
		}
		args = jsh_split_line(line);
		status = jsh_execute(args);

		free(line);
		free(args);
	} while (status);
}

int main(int argc, char **argv) {
	// Load any config files (if you're into that)
  printf("Starting shell.\n");

	// Run Command Loop
	jsh_loop();

	// Cleanup
  printf("Exiting shell.\n");

	return EXIT_SUCCESS;
}
