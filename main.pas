Uses sysutils, StaticList;



procedure Pnew(partyOrVoters:string; var List:tList);
var d:tItem;
begin
   d.partyname := partyOrVoters;
   d.numvotes := 0;
   if (findItem(partyOrVoters,List) = NULL) and insertItem(d,NULL,List) then writeln('* New: party ',partyOrVoters)
   else writeln('+ Error: New not possible'); 
end;

(**********************************************************)

procedure Vote(partyOrVoters: string ;var List: tList);
var
pos: tPosL;
nvotes:tNumVotes;
begin
   pos := findItem(partyOrVoters,List);
   if pos=NULL then begin 
      writeln('+ Error: Vote not possible. Party ',partyOrVoters,' not found. NULLVOTE');
      Vote(NULLVOTE,List);
      end
   else begin
      nvotes := getItem(pos,List).numvotes;
      nvotes:= nvotes+1;
      updateVotes(nvotes,pos,List);
      if partyOrVoters<>NULLVOTE then writeln('* Vote: party ',partyOrVoters,' numvotes ',nvotes); (*Without this if statement, the recursive call to vote when adding a NULL vote, would print an unnecesary line to the console.*)
   end;
end;

(**********************************************************)

procedure Stats(partyOrVoters:string; var List:tList);
var
pos: tPosL;
item: tItem;
totalvotes,totalvalidvotes: tNumVotes;
begin
   totalvotes:= 0;
   totalvalidvotes:= 0;
   pos:= first(List);

   while pos<>NULL do begin (*Iterates around the list adding together all votes stored in every item*)
      totalvotes:= totalvotes + getItem(pos,List).numvotes;
      pos:= next(pos, List);
   end;

   totalvalidvotes := totalvotes - getItem(findItem(NULLVOTE,List),List).numvotes; (*The conjugated function call returns the number of votes that belong to NULL*)

   pos:= first(List);
   item := getItem(pos,List);
   if totalvalidvotes=0 then totalvalidvotes:=1; (*This is to avoid dividing by zero in the next line. The division returns 0 because item.numvotes = 0 for all parties*)
   writeln('Party ',item.partyname, ' numvotes ', item.numvotes:0, ' (', (item.numvotes*100/totalvalidvotes):2:2, '%)'); (*Prints BLANKVOTES*)

   pos:= next(pos,List);
   item := getItem(pos,List);

   writeln('Party ',item.partyname, ' numvotes ', item.numvotes:0);(*Prints NULLVOTES*)

   pos:= next(pos,List); 

   while pos<>NULL do begin
      item:= getItem(pos,List);
      writeln('Party ',item.partyname, ' numvotes ', item.numvotes:0, ' (', (item.numvotes*100/totalvalidvotes):2:2, '%)'); (*Prints all parties on the list*)
      pos:= next(pos,List);
   end;
   writeln('Participation: ', totalvotes:0, ' votes from ',partyOrVoters, ' voters (', (totalvotes*100/StrToInt(partyOrVoters)):2:2 ,'%)')
end;

(**********************************************************)

procedure readTasks(filename:string);
	
VAR
   usersFile: TEXT;
   code 	     :string;
   line          : string;
   task          : string;
   partyOrVoters : string;

   List: tList; (*Lista para almacenar todos los datos*)

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
      
      case task[1] of
         'N': begin 
               writeln(code, ' ',task, ': party ', partyOrVoters);
               Pnew(partyOrVoters,List);
               end;

         'V': begin
               writeln(code, ' ',task, ': party ', partyOrVoters);
               Vote(partyOrVoters,List);
               end;
         'S': begin
               writeln(code, ' ',task, ': totalvoters ', partyOrVoters);
               Stats(partyOrVoters,List);
               end;
         otherwise
      end;
   
  END;
   Close(usersFile);

END;

(**********************************************************)

{Main program}
BEGIN
	if (paramCount>0) then
		readTasks(ParamStr(1))
	else
		readTasks('new.txt');
END.
