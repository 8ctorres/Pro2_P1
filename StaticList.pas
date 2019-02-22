unit StaticList;

interface

	const
	
		MAX = 25 ; (*tamaño máximo del array*)
		NULL = 0;
        BLANKVOTE = 'B';
        NULLVOTE = 'N'; 
		
	type

		tPartyName = string; 
        
		tNumVotes = integer;
        
        tItem = record
                    partyname: tPartyName;
                    numvotes: tNumVotes;
                    end;

		tPosL = NULL..MAX;
        
		tList = record
					data: array [1..MAX] of tItem;
					fin: tPosL;
			end;
			
	procedure createEmptyList(var L: tList);
	function isEmptyList(L:tList): boolean;
	function first(L:tList):tPosL;
	function last(L:tList):tPosL;
	function next(p:tPosL; L:tList):tPosL;
	function previous(p:tPosL; L:tList):tPosL;
	function insertItem(d:tItem;p:tPosL; var L : tList): boolean;
	procedure deleteAtPosition(p:tPosL; var L : tList);
	function getItem(p:tPosL; L: tList):tItem;
	procedure updateVotes(d: tNumVotes; p: tPosL; var L:tList);
	function findItem(d:tPartyName; L:tList):tPosL;
	
implementation

	procedure createEmptyList(var L:tList);
		begin
			L.fin:= NULL
		end;
		
	function isEmptyList (L: tList): boolean;
		begin
				isEmptyList := (L.fin = NULL);
		end;

	function first (L:tList): tPosL;
		begin
			first:= 1;
		end;
		
	function last (L:tList): tPosL;
		begin
			last:= L.fin;
		end;
		
	function previous (p: tPosL; L: tList): tPosL;
		begin
			if p=1 then
				previous:= NULL
			else
				previous:= p-1;
		end;
		
	function next (p: tPosL; L: tList): tPosL;
		begin
			if p=L.fin then
				next:=NULL
			else
				next:= p+1;
		end;
	

	function insertItem(d: tItem; p:tPosL; var L:tList):boolean;
		var
			i: tPosL;
		begin
			if L.fin = MAX then
				insertItem:= FALSE
			else
				begin
					L.fin:= L.fin+1;
					if p=NULL then
						L.data[L.fin]:= d
					else
						begin
							for i:=L.fin downto p+1 do L.data[i]:=L.data[i-1];
							L.data[p]:=d;
						end;
					insertItem:=TRUE;
				end;
		end;
		
		procedure deleteAtPosition(p: tPosL; var L:tList);
			var i: tPosL;
			begin
				L.fin := L.fin -1;
				for i:= p to L.fin do
					L.data[i] := L.data[i+1];
			end;
			
		function getItem (p: tPosL; L: tList): tItem;
			begin
				getItem:= L.data[p];
			end;
			
		procedure updateVotes (d: tNumVotes; p : tPosL;var L:tList);
			begin
				L.data[p].numvotes := d;
			end;
			
			
		function findItem (d: tPartyName; L: tList): tPosL;
			var i: tPosL;
			begin
				if isEmptyList(L) then
					findItem:= NULL
				else
					i:=1;
					while (i < L.fin) and (L.data[i].partyname <> d) do
						i:= i+1;
					if d = L.data[i].partyname then
						findItem:=i
					else
						findItem := NULL;
		end;
end.