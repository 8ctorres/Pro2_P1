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
    (*  Objetivo: Comprueba si la lista está vacía
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
	(*	Objetivo: Devuelve la posición en la lista del elemento anterior al indicado
		Entrada: Una lista
		Salida: La posición del elemento anterior
		Precondición: La posición indicada es una posición válida*)
	function insertItem(d:tItem;p:tPosL; var L : tList): boolean;
	(*	Objetivo: Inserta un elemento en la lista antes de la posición indicada, o al final si la posición es NULL
		Entrada: Un elemento a insertar, una posición y una lista
		Salida: La lista con el elemento insertado y un boolean TRUE si se ha insertado correctamente y un FALSE en caso contrario
		Precondición: La posición indicada es una posición válida en la lista, o bien NULL
		Postcondición: Las posiciones de los elementos de la lista posteriores al insertado pueden cambiar de valor*)
	procedure deleteAtPosition(p:tPosL; var L : tList);
	(*	Objetivo: Elimina de la lista el elemento que ocupa la posición indicada
		Entrada: Una lista y una posición
		Salida: El elemento en la posición indicada en esa lista
		Precondición La posición indicada es una posición válida en la lista
		Postcondición: Tanto la posición del elemento eliminado como aquellas de los elementos de la lista a continuación pueden cambiar de valor*)
	function getItem(p:tPosL; L: tList):tItem;
	(*	Objetivo: Devuelve el contenido del elemento de la lista que ocupa la posición indicada
		Entrada: Una posición y una lista
		Salida: El elemento en esa posición de la lista
		Precondición: La posición indicada es una posición válida en la lista*)
	procedure updateVotes(d: tNumVotes; p: tPosL; var L:tList);
	(*	Objetivo: Modifica el número de votos del elemento situado en la posición indicada
		Entrada: El nuevo número de votos, la posición del partido que se quiere modificar, y la lista
		Salida: La lista con los votos actualizados
		Precondición: La posición indicada es una posición válida en la lista
		Postcondición: El orden de los elementos de la lista no se ve modificado*)
	function findItem(d:tPartyName; L:tList):tPosL; 
	(*	Objetivo: Encuentra el primer partido que coincida con el partido buscado y devuelve su posición.
		Entradas: Un partido político y una lista
		Salidas: Una variable de posición
		Precondicion: La lista es no vacía
		Poscondicion: Si el partido no se encuentra en la lista la función devolverá NULL*)
	
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
			if L.fin = MAX then (*Se controla si el array está lleno*)
				insertItem:= FALSE
			else
				begin
					L.fin:= L.fin+1;
					if p=NULL then (*Si p=NULL, se inserta al final*)
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
				for i:= p to L.fin do (*Se mueven todos los elementos siguientes a p una posición hacia atrás*)
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
				if isEmptyList(L) then (*Se controla si la lista está vacía*)
					findItem:= NULL
				else
					i:=1;
					while (i < L.fin) and (L.data[i].partyname <> d) do (*Se recorre la lista buscando el elemento y se sale del bucle cuando se lega al final o se encuentra*)
						i:= i+1;
					if d = L.data[i].partyname then
						findItem:=i (*Si se encuentra, se devuelve la posición*)
					else
						findItem := NULL; (*Si se llega al final de la lista sin encontrarlo, se devuelve NULL*)
		end;
end.