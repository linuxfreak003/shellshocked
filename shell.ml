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

(* A couple of global variables *)
let history = ref [];;

let aliases_list = ref [
    ("ls",["ls";"--color=auto"]);
    ("la",["ls";"-a"])
];;

(* Show history with numbers
 * might be more efficient 
 * to use a for loop *)
let show_hist lst =
    let rec aux count = function
        | [] -> ()
        | x::xs -> printf "%d %s\n" count x; aux (count + 1) xs
    in aux 1 (List.rev lst)
;;

(* List of aliases *)
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

let parse_alias lst =
    let str = String.strip (String.concat ~sep:" " lst) in
    let stripped = String.strip ~drop:(fun c -> c = '"') str in
    String.split ~on:' ' stripped
;;

(* alias command
 * Adds an alias to the alias_list (if valid) *)
let alias = function
    | [] -> printf ""
    | "alias"::[] -> printf "Invalid alias\n"
    | "alias"::k::"="::v ->
        let value = parse_alias v in
        if value = [""]
        then printf "Invalid alias\n"
        else aliases_list := (k,value)::!aliases_list
    | "alias"::x::xs -> (match String.split ~on:'=' x with
        | [] -> printf "Invalid alias\n"
        | [""] -> printf "Invalid alias\n"
        | y::[] -> printf "Invalid alias\n"
        | y::ys -> aliases_list := (y,parse_alias (ys@xs))::!aliases_list)
    | _ -> printf "Bad command\n"
;;

(* Executes a command, using build in functions for cd and exit *)
let execute = function
    | [] -> printf ""
    | "history"::[] -> show_hist !history
    | ("alias"::_) as cmd -> alias cmd
    | "exit"::_ -> exit 0
    | "cd"::d::_ -> 
            (try Sys.chdir d with
            | Sys_error e -> printf "cd: %s\n" e)
    | "cd"::[] -> Sys.chdir (match Sys.getenv "HOME" with Some x -> x | None -> "/")
    | (x::xs) as command ->
        try 
            let pid = Unix.fork_exec ~prog:x ~args:command ~use_path:true () in
            Unix.waitpid pid |> ignore
        with
        | Unix.Unix_error (uerr, ucommand, dir) -> printf("There was an error: The command you just entered is likely not found\n"); exit 2;
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
    history := s::!history;
    execute cmdlst;
    (*
    (try execute cmdlst () with
    | Unix.Unix_error (uerr, ucommand, dir) -> printf("There was an error\n");)
    *)
    shell_loop ();
;;

let () =
    aliases_list := ("ll",["ls";"-l"])::!aliases_list;
    Sys.catch_break true;
    print_string "Welcome to JSH (Jared SHell)\n";
    shell_loop ();
;;
