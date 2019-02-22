USES sysutils; 


procedure readTasks(filename:string );
	
VAR
   usersFile: TEXT;
   code 	     :string;
   line          : string;
   task          : string;
   partyOrVoters : string;

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
      if (task = 'S') then
		writeln(code, ' ',task, ': totalvoters ', partyOrVoters) 
	  else
		writeln(code, ' ',task, ': party ', partyOrVoters)
  
  END;
   Close(usersFile);

END;

{Main program}
BEGIN
	if (paramCount>0) then
		readTasks(ParamStr(1))
	else
		readTasks('new.txt');

END.
