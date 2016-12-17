open Core.Std;;

let code_RED = "\x1B[31m";;
let code_GRN = "\x1B[32m";;
let code_YEL = "\x1B[33m";;
let code_BLU = "\x1B[34m";;
let code_MAG = "\x1B[35m";;
let code_CYN = "\x1B[36m";;
let code_WHT = "\x1B[37m";;
let code_RESET = "\x1B[0m";;

let map fn = List.map ~f:fn;;
let foldl fn acc xs = List.fold ~init:acc ~f:fn xs;;

let aliases = function
    | "ls"::xs -> "ls --color=auto"::xs
    | "exit"::xs -> exit 0
    | xs -> xs
;;

let de_empty lst = foldl (fun acc x -> if x="" then acc else x::acc) [] lst |> List.rev;;

let tokenize s = String.split_on_chars ~on:[' ';'\t';'\n';'\r'] s |> de_empty;;

let execute = function
    | "cd"::d::[] -> Sys.chdir d
    | xs ->
        let cmd = foldl (fun acc x -> acc^" "^x) "" xs in
        printf "%s\n" cmd;
        Sys.command cmd |> ignore
;;

let rec shell_loop () =
    printf "%s%s%s-$ %s" code_BLU (Sys.getcwd ()) code_RED code_RESET;
    let s = read_line () in
    let tokens = tokenize s in
    let cmdlst = aliases tokens in
    execute cmdlst;
    shell_loop ();
;;

let () =
    print_string "Welcome to JSH (Jared SHell)\n";
    shell_loop ();
;;
