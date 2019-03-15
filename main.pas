Uses sysutils, DynamicList;
{
	TITLE: PROGRAMMING II LABS
	SUBTITLE: Practical 1
	AUTHOR 1: Carlos Torres Paz LOGIN 1: carlos.torres@udc.es
	AUTHOR 2: Daniel Sergio Vega Rodriguez LOGIN 2: d.s.vega@udc.es
	GROUP: 5.4
	DATE: 22/02/2019
}

procedure Pnew(partyOrVoters:string; var List:tList);
(*
Goal: Creates a new political party on the list
Input: The name of the new party and the list of parties
Output: The list with the new party added
Precondition : The list has to be initialized
Postcondition: If the party already exists, the list remains unchanged and an error message is printed out to the console
*)
var d:tItem;  (*This variable is used to store the name and votes before the insertion*)
begin
   d.partyname := partyOrVoters;
   d.numvotes := 0;
   if (findItem(partyOrVoters,List) = NULL) and insertItem(d,NULL,List) then writeln('* New: party ',partyOrVoters)
   else writeln('+ Error: New not possible');
end;

(**********************************************************)

procedure Vote(partyOrVoters: string; var totalvotes: tNumVotes;var List: tList);
(*
Goal: Adds an specified amount of votes to the given political party
Inputs: The name of the party and the list of parties
Output: The list with the added vote to the party
Precondition : The list has to be initialized
Postcondition: If the especified party does not exist on the list, the list remains unchanged and an error message is printed out to the console
*)
var
pos: tPosL;       (*Used to store the pos of the party (or null)*)
nvotes:tNumVotes; (*Used to hold the new value of votes before update*)
begin
   totalvotes:= totalvotes+1;
   pos := findItem(partyOrVoters,List);
   if pos=NULL then begin
      writeln('+ Error: Vote not possible. Party ',partyOrVoters,' not found. NULLVOTE');
      pos:= findItem(NULLVOTE,List);
      nvotes := getItem(pos,List).numvotes +1;
      updateVotes(nvotes,pos,List);
      end
   else begin
      nvotes := getItem(pos,List).numvotes;
      nvotes:= nvotes+1;
      updateVotes(nvotes,pos,List);
      writeln('* Vote: party ',partyOrVoters,' numvotes ',nvotes);
   end;
end;

(**********************************************************)

procedure Stats(partyOrVoters:string; var totalvotes:tNumVotes; var List:tList);
(*
Goal: Outputs statistics of the votes. Shows a count of blank votes, null votes, votes for each party and participation in %
Inputs: Total number of voters in the electoral list, and the List with Parties and number of votes
Output: Does not modify anything, just writes the statistics to the console
Precondition: The list must be initialized and parties BLANKVOTE (B) and NULLVOTE (N) must exist
Postcondition: If totalvotes is higher than total census, returns an error
*)
var
pos: tPosL;
item: tItem; (*Both used to iterate around the list*)
totalvalidvotes: tNumVotes; (*Keeps the number of votes that are not null*)
begin
   if totalvotes > strToInt(partyOrVoters) then writeln('+ Error: Stats not possible') (*Checks if the total number of voters is higher than the total census, which would give a participacion higher than 100%, and outputs an error message*)
   else begin
      totalvalidvotes:= 0;

      totalvalidvotes := totalvotes - getItem(findItem(NULLVOTE,List),List).numvotes; (*The conjugated function call returns the number of votes that belong to NULL*)

      pos:= first(List);
      item := getItem(pos,List);
      if totalvalidvotes=0 then totalvalidvotes:=1; (*This is to avoid dividing by zero in the next line. The division returns 0 because item.numvotes = 0 for all parties*)
      writeln('Party ',item.partyname, ' numvotes ', item.numvotes:0, ' (', (item.numvotes*100/totalvalidvotes):2:2, '%)'); (*Prints BLANKVOTE*)

      pos:= next(pos,List);
      item := getItem(pos,List);

      writeln('Party ',item.partyname, ' numvotes ', item.numvotes:0);(*Prints NULLVOTE*)

      pos:= next(pos,List);

      while pos<>NULL do begin
         item:= getItem(pos,List);
         writeln('Party ',item.partyname, ' numvotes ', item.numvotes:0, ' (', (item.numvotes*100/totalvalidvotes):2:2, '%)'); (*Prints all parties on the list*)
         pos:= next(pos,List);
      end;
      writeln('Participation: ', totalvotes:0, ' votes from ',partyOrVoters, ' voters (', (totalvotes*100/StrToInt(partyOrVoters)):2:2 ,'%)')
   end;
end;

(**********************************************************)
procedure illegalize(partyOrVoters : string; var List : tList);
(*
 Goal: Deletes the party from the list both designated as parameters;
 Inputs: The name of the party needed to be deleted and the list where it belongs.
 Outputs: The previous list without the illegalized party.
 Precondition: The list must be initialized
 Poscondition: If the party is not in the list or the list is empty or the input is not a valid party illegalize will not
 modify the list. In this case it prints an error message.
 *)
var
   pos : tPosL;   (*Used to store the position of the input party*)
   pnull: tPosL;  (*Used to store the position of NULLVOTE*)
   votesNull : tNumVotes;  (*Used to store values between operations 115:117*)
begin
   pos := findItem(partyOrVoters,List);
   if (partyOrVoters = NULLVOTE) or (partyOrVoters = BLANKVOTE) or (pos = NULL) then writeln('+ Error: Illegalize not possible') (*Checks if the party is avaliable to delete*)
   else begin
      pNull := findItem(NULLVOTE,List);
      votesNull := getItem(pNull,List).numvotes;
      votesNull := votesNull + getItem(findItem(partyOrVoters,List),List).numvotes;  (*Sums nullvotes and the votes of the party *)
      updateVotes(votesNull, pNull ,List); (*Updates null votes with the previous sum*)
      deleteAtPosition(pos, List);
      writeln('* Illegalize: party ',partyOrVoters);
   end;
end;

(**********************************************************)

procedure disposeAll(var list : tList);
(*
 Goal: Clears the data stored in a list making it empty;
 Input: The list to be cleared;
 Output: The previous list with no elements;
 *)
begin
   while not(isEmptyList(list)) do (*This loop deletes all elements from the first*)
         deleteAtPosition(first(list),list);
end;

(**********************************************************)

procedure readTasks(filename:string);

VAR
   usersFile: TEXT;
   code 	     :string;
   line          : string;
   task          : string;
   partyOrVoters : string;

   List: tList; (*A list that holds all the data (names of parties and their number of votes)*)
   totalvotes: tNumVotes; (*A variable that holds the total number of votes*)
 

BEGIN
   {process the operation file named filename}

   {$i-} { Deactivate checkout of input/output errors}
   Assign(usersFile, filename);
   Reset(usersFile);
   {$i+} { Activate checkout of input/output errors}
   IF (IoResult <> 0) THEN BEGIN
      writeln('**** Error reading '+filename);
      halt(1)
   END;

   createEmptyList(List);
   totalvotes:= 0;
   
   WHILE NOT EOF(usersFile) DO
   BEGIN
      { Read a line in the file and save it in different variables}
      ReadLn(usersFile, line);
      code := trim(copy(line,1,2));
      task:= line[4];
      partyOrVoters := trim(copy(line,5,8));  { trim removes blank spaces of the string}
                                          { copy(s, i, j) copies j characters of string s }
                                          { from position i } 
      
      {Show the task --> Change by the adequate operation}

      writeln('********************');  {Order Separator}
      
      case task[1] of   (* Order selector, every option does: print the order to be executed, new line, call order's sub-routine *)
         'N': begin
               writeln(code, ' ',task, ': party ', partyOrVoters);
               writeln;
               Pnew(partyOrVoters,List);
               end;

         'V': begin
               writeln(code, ' ',task, ': party ', partyOrVoters);
               writeln;
               Vote(partyOrVoters,totalvotes,List);
               end;
         'S': begin
               writeln(code, ' ',task, ': totalvoters ', partyOrVoters);
               writeln;
               Stats(partyOrVoters,totalvotes,List);
               end;
         'I': begin
               writeln(code, ' ',task, ': party ', partyOrVoters);
               writeln;
               Illegalize(partyOrVoters,List);

               end;
         otherwise
      end;
   
  END;
   
   Close(usersFile);
   
   disposeAll(List); (* Memory clear *)
END;

(**********************************************************)

{Main program}
BEGIN
	if (paramCount>0) then
		readTasks(ParamStr(1))
	else
	   readTasks('new.txt');

END.
