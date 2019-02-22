unit StaticList;

{
	TITLE: PROGRAMMING II LABS
	SUBTITLE: Practical 1
	AUTHOR 1: Carlos Torres Paz LOGIN 1: carlos.torres@udc.es
	AUTHOR 2: Daniel Sergio Vega Rodriguez LOGIN 2: d.s.vega@udc.es
	GROUP: 5.4
	DATE: 22/02/2019
}

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
    (*  Objetivo: Crea una lista vacía
        Entradas: La variable donde se va a almacenar la lista
        Salidas: La lista Vacía
        Postcondición: La lista queda inicializada y no contiene elementos  *)
	function isEmptyList(L:tList): boolean;
    (*  Objetivo: Determina si la lista está vacía
        Entrada: Una lista
        Salida: Un boolean TRUE si está vacía y FALSE si no lo está *)
	function first(L:tList):tPosL;
    (*  Objetivo: Devuelve la posición del primer elemento de la lista
        Entrada: Una lista
        Salida: La posición del primer elemento
        Precondición: La lista no está vacía    *)
	function last(L:tList):tPosL;
    (*  Objetivo: Devuelve la posición del último elemento de la lista
        Entrada: Una Lista
        Salida: La posición del último elemento
        Precondición: La lista no está vacía    *)
	function next(p:tPosL; L:tList):tPosL;
    (*  Objetivo: Devuelve la posición en la lista del elemento siguiente al indicado
        Entrada: Una Lista
        Salida: La posición del elemento siguiente
        Precondición: La posición indicada es una posición válida*)
	function previous(p:tPosL; L:tList):tPosL;
	function insertItem(d:tItem;p:tPosL; var L : tList): boolean;
	procedure deleteAtPosition(p:tPosL; var L : tList);
	function getItem(p:tPosL; L: tList):tItem;
	procedure updateVotes(d: tNumVotes; p: tPosL; var L:tList);
	function findItem(d:tPartyName; L:tList):tPosL; 
	(*Objetivo: Encuentra el primer partido politico en una lista que coincida
		con el partido buscado.
	  Entradas: Un partido político y una lista
	  Salidas: Una variable de posicion
	  Precondicion: La lista es no vacia
	  Poscondicion: Si el partido no se encuentra en la lista la funcion devolvera NULL*)
	
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