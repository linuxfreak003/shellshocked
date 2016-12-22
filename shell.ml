open Core.Std;;

(* Basic color codes *)
let code_RED = "\x1B[31m";;
let code_GRN = "\x1B[32m";;
let code_YEL = "\x1B[33m";;
let code_BLU = "\x1B[34m";;
let code_MAG = "\x1B[35m";;
let code_CYN = "\x1B[36m";;
let code_WHT = "\x1B[37m";;
let code_RESET = "\x1B[0m";;

(* Just changing fold and map to the format I'm used to *)
let map fn = List.map ~f:fn;;
let foldl fn acc xs = List.fold ~init:acc ~f:fn xs;;

(* List of aliases *)
let aliases_list = ref [
    ("ls",["ls";"--color=auto"]);
    ("ll",["ls";"-l"]);
    ("la",["ls";"-a"])
];;

(* Takes a command and a list of aliases
 * Switching command for any aliases *)
let rec aliases cmd lst = match (cmd,lst) with
    | ([], _) -> []
    | (cm::args, [])-> cmd
    | (cm::args, (x,y)::xs) -> if x=cm then y@args else aliases cmd xs
;;

(* Removes empty strings from a list *)
let de_empty lst = foldl (fun acc x -> if x="" then acc else x::acc) [] lst |> List.rev;;

let tokenize s = String.split_on_chars ~on:[' ';'\t';'\n';'\r'] s |> de_empty;;

(* Executes a command, using build in functions for cd and exit *)
let execute = function
    | [] -> printf ""
    | "exit"::_ -> exit 0
    | "cd"::d::_ -> Sys.chdir d
    | "cd"::[] -> Sys.chdir (match Sys.getenv "HOME" with Some x -> x | None -> "/")
    | (x::xs) as command ->
        let pid = Unix.fork_exec ~prog:x ~args:command ~use_path:true () in
        Unix.waitpid pid |> ignore
;;

let getCommand () = 
    try read_line () with
    | End_of_file -> printf "\n"; exit 0
    | Sys.Break -> printf "\n"; ""
;;

let printPrompt () =
    printf "%s[%s%s@" code_CYN code_RESET (Unix.getlogin ());
    printf "%s%s%s]-" code_RED (Unix.gethostname ()) code_CYN;
    printf "[%s%s%s%s]╼$ %s" code_RESET code_BLU (Sys.getcwd ()) code_CYN code_RESET;
;;

let rec shell_loop () =
    printPrompt ();
    let s = getCommand () in
    let tokens = tokenize s in
    let cmdlst = aliases tokens !aliases_list in
    execute cmdlst;
    shell_loop ();
;;

let () =
    Sys.catch_break true;
    print_string "Welcome to JSH (Jared SHell)\n";
    shell_loop ();
;;
