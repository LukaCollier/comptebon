let liste_jeu = [1;2; 3; 4; 5; 6; 7;8; 9; 10; 25; 50; 75; 100];;

let rec init_parti n acc = (*renvoie une liste de valeur aléatoire pour préparer le jeu Complexité O(n) *)
  match n with
  |0 -> acc
  |n -> let k = Random.int 14 in
      init_parti (n-1) ((List.nth liste_jeu k)::acc);;
let objectif () = (Random.int 800) +100 ;; (*initialise une valeur d'objectif O(1) *)

let afficher_jeu l= (*fonction d'affichage O(|l|) *)
  List.iter (fun t -> print_int t ;print_string " " ) l ;;

let rec revl l acc= (*fonction qui retourne la liste O(|l|) *)
  match l with
  |[] -> acc
  |t::q -> revl q (t::acc)

let rec update_liste l n  = (*fonction qui retire un seul élément qui est n O(|l|) *)
  let rec aux l n bool acc =
    match l,bool with
    |[],_ -> acc
    | t::q,true -> aux q n true (t::acc)
    | t::q,false -> if t=n then
                      aux q n true acc
                    else
                      aux q n false (t::acc)
  in
  revl (aux l n false []) []

let rec nb_elta_l a l acc= (*compte le nombre d'élément n dans la liste  O(|l|)*)
  match l with
  |[]-> acc
  |t::q -> if a=t then nb_elta_l a q (acc+1)
           else nb_elta_l a q acc


exception InvalidOperation  ;;
let jouer_coup (str:string) l = (*fonction qui permet de jouer un unique coup complexite : O(|l|+|str|) *)
  let v = String.split_on_char ' ' str in (* décompose la chaine de caractère en une liste de caractère O(|str|)*)
  let v = List.filter (fun s -> s <> "") v in (*retire les chaine de caractère vide dans la liste O(|v|)*)
  try
    match v with
    | [] -> raise InvalidOperation
    | v::op::v1::q ->
        let a = int_of_string v in
        let b = int_of_string v1 in
        if ((List.mem a l && List.mem b l && a<>b)||(a=b && (nb_elta_l a l 1)>2 ) )then (*condition que a et b sont bien présent dans la liste l O(|l|) *)
          (match op with (*applique une opération O(|l|) *)
           | "+" -> 
               let l1 = update_liste l a  in
               let l2 = update_liste l1 b in
               (a + b, (a + b) :: l2)
           | "-" -> 
               let l1 = update_liste l a in
               let l2 = update_liste l1 b  in
               (a - b, (a - b) :: l2)
           | "*" -> 
               let l1 = update_liste l a  in
               let l2 = update_liste l1 b in
               (a * b, (a * b) :: l2)
           | "/" -> if b = 0 then raise InvalidOperation else
                      if a mod b <> 0 then raise InvalidOperation
                      else
                        let l1 = update_liste l a  in
                        let l2 = update_liste l1 b in
                        (a / b, (a / b) :: l2)
           |  _ -> raise InvalidOperation)
        else
          raise InvalidOperation
    | _ -> raise InvalidOperation
  with
  | InvalidOperation -> (min_int, l)
;;


let eval va obj = (*O(1)*)
  va=obj

let jouer () = 
  (*fonction pour lancer le mode jeu classique. Dans ce mode de jeu on a 6 valeur dans la liste,en partant du principe que l'utilisateur ne fait pas de coup illégal on a au plus 6 opération; complexité:O(|l|**2)*)
  let obj = objectif () in (* complexité O(1) *)
  let v = init_parti 6 [] in (* complexité O(1) *)
  let rec manche l obj =
    match l with
    | [] -> print_string "Fin de partie"; print_newline ()
    | [t] -> if eval t obj then 
               begin 
                 print_string "compte est bon";
                 print_newline ();
               end
             else
               begin
                 print_string "Perdu, vous n'avez pas atteint l'objectif.";
                 let ecart = obj-t in
                 print_newline();
                 print_string ("écart avec l'objectif de "^(string_of_int ecart));
                 print_newline ();
               end
    | _ ->
      begin
        afficher_jeu l; (*O(|l|) *)
        print_endline ("Objectif : " ^ string_of_int obj);
        print_string "Entrez une opération respectant le format 'a opérateur b' : ";
        let m = read_line () in
        let (res, nl) = jouer_coup m l  in
        if res = min_int then
          begin
            print_endline "Une erreur s'est produite dans votre opération, réessayez.";
            manche l obj
          end
        else
          if eval res obj then
            begin
              print_string "Compte Bon";
              print_newline ()
            end
          else
            manche nl obj
      end
  in
  print_endline "Lancement de la partie";
  manche v obj
;;
Random.self_init ();;
(*jouer();;*)



(*solveur*)
let vtoop n = (*fonction qui associe une valeur par son opération O(1) *)
  match n with
  |1 -> "+"
  |2 -> "*"
  |3 -> "/"
  |4 -> "-"
  |_ -> " " (*cas inutilisé car si n > 4 impossible dans testcombinaison *)
let pfmd nop a b= (*+ * - / *) (*applique une opération et renvoie : - Some a ou None *)
  match nop with
  |1 -> Some(a+b)
  |4 -> Some(a-b)
  |2 -> Some(a*b)
  |3 -> if b<> 0 && a mod b = 0 then
          Some (a/b)
        else None
  |_ -> None (*cas de prevention *)
let rec testcombinaison l obj ope acc = (*on a  au maximum 5 opération à appliquer (+;-;*;/;ne pas prendre la valeur) complexité sur une liste ainsi O(4**|l|)*)
  match l with
  |[] -> if eval acc obj then (*regarde si l'accumulateur vaut l'objectif *)
           Some acc,ope
         else
           None,[]
  |t::q ->
    let rec aux pdt = (*fonction auxiliaire permettant d'appliquer l'ensemble des opérations pour connaitre une possible combinaison *)
      match pdt with
      |5 -> testcombinaison q obj ope acc
      |_  ->
        let tmp= pfmd pdt acc t in
        match tmp with
        |Some res -> if eval res obj then
                       Some res,((acc,(vtoop pdt),t):: ope)
                     else
                       let re,nop=testcombinaison q obj ((acc,(vtoop pdt),t):: ope) res in
                       (match re with
                          |None -> aux (pdt+1)
                          |Some _ ->re,nop                        )
        | None -> aux (pdt+1)
    in
    aux 0

(*groupe de 2 fonction qui permettent la creation de l'ensemble des permutation *)
let rec inselt x l =
  (*fonction inserrant à chaque position de la liste l'élément x ( int*list -> int list list) *)
  match l with
  |[] ->[[x]]
  |t::q -> (x::l):: (List.map (fun y -> t::y) (inselt x q))

let rec permute l= (* permet de recuperer l'ensemble des permutation de la liste l complexité O(|l|!) *)
  match l with
  | t::q -> List.concat (List.map (inselt t) (permute q))
  |_ -> [l]

let rec rvl l acc= (*oups même fonction que revl *)
  match l with
  |[] ->acc
  |t::q -> rvl q (t::acc)

let affichersolution l obj = (*affichage de la solution O(|l|) *)
  List.iter (fun (a,op,b)->print_int a;print_string op;print_int b;print_newline()) l;
  print_int obj;
  print_newline()


let sdlm l obj  = (*test l'ensemble des permutation pour trouver une solution *)
  (*sdlm: Solveur de la mort*)
  let pl= permute l in
  let rec test pl obj = (*fonction qui l'ensemble des permutation et test chacun via testcombinaison si elle vaut l'objectif complexité O(|l|! *5**|l|) *)
    match pl with
    |[[]] |[] ->[]
    |t::q -> let res,lst = testcombinaison t obj [] 0 in
             match res with
             |None -> test q obj
             |Some _-> lst
  in
  let solus= test pl obj in
  if solus=[] then (*verifie l'existence de la solution *)
    print_string "aucune solution"
  else
    begin
      let solus =rvl solus [] in (*retourne la liste pour obtenir l'ordre des opérations *)
      match solus with
      |[] -> print_string "" (*retire la première opération qui est nécessairement 0 {+,-,*,/} valeur *)
      |t::q -> affichersolution q obj
    end

let rec intliste l = (* transforme une liste de chaine de caractère en liste d'entier complexité O(|l|) *)
  match l with
  |[] -> []
  |t::q -> (int_of_string t)::(intliste q)

exception Nullos;; (*je n'avais pas d'idée  d'exception et elle sert à vérifier que l'utilisateur ne cherche pas un mode inexistant *)
let rec mode n = (*lancement du jeu avec le choix du mode de jeu dans le pire des cas l'utilisateur utilise le mode 1 qui est le solveur et donc complexité O(|l'entrée de la liste|)*)
  try
    match n with (*corriger l'erreur si " " est present dans le choix du mode et de la liste et de l'objectif *)
      |0 -> jouer ()
      |1 -> begin
          print_string "liste des valeurs disponible";
          print_newline();
          let l= read_line() in
          print_newline();
          let l = String.split_on_char ' ' l in
          let l=List.filter (fun t -> t<> " ") l in
          print_string "objectif : ";
          let obj=read_line() in
          let il =intliste l in
          let obj=int_of_string obj in
          sdlm il obj;
        end;
      | 2 -> begin 
          let l=init_parti 6 [] in
          let obj = objectif () in
          print_string "liste des valeurs : ";afficher_jeu l;
          print_newline ();
          print_string "objectif : ";print_int obj;
          print_newline ()
        end;
      |_ -> raise Nullos
  with
  |Nullos -> begin 
      print_string "c'est 0 , 1 ou 2  nullos";print_newline();jeu()
    end;
(*signal que l'utilisateur ne sait pas lire *)
and jeu () = (*lancement du jeu *) (*utilisation de and pour faire référence à jeu et mode *)
  try
    print_string "Choix du mode jeu: \n0 pour jouer avec une liste aléatoire \n1 pour le solveur \n2 pour générer une instance de jeu ";
    print_newline ();
    let n =read_line () in
    print_newline();
    if n>="0" && n<"9" then
      mode (int_of_string n)
    else
      raise Nullos
  with
  |Nullos -> begin
      print_string "c'est 0 , 1 ou 2  nullos";print_newline(); jeu ()
    end;
;;

jeu()
(*NB : liste à plus de 9 valeurs réalise stackoverflow *)
