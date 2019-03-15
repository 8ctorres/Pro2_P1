unit DynamicList;

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
		NULL = nil;
        BLANKVOTE = 'B';
        NULLVOTE = 'N';
	
	type
        tPosL = ^tNode;
        tList = tPosL;

	tPartyName = string;
        tNumVotes = integer;

        tItem = record
		    partyname: tPartyName;
                    numvotes: tNumVotes;
      		end;

        tNode = record
                    item: tItem;
                    nxt: tPosL;
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
	Entrada: El newnode número de votos, la posición del partido que se quiere modificar, y la lista
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

	procedure createEmptyList(var L: tList);
	begin
		L := NULL;
	end;
	
	function isEmptyList (L: tList):boolean;
	begin
		isEmptyList := (L = NULL);   
	end;

	function first(L: tList): tPosL;
	begin
		first := L;    
	end;
	
	function last(L: tList):tPosL;
	var p:tPosL;
	begin
		p:=L;
		while (p^.nxt <> NULL) do (*Itera sobre la lista hasta que el siguiente puntero a p apunte a NULL*)
			p:= p^.nxt;
	   last:=p;  (*p sale del bucle siendo el puntero que apunta al último nodo*)
	end;
	
	function previous (p: tPosL; L: tList): tPosL;
	var
	   q : tPosL;
	begin
		if p=L then previous:=NULL   (*Ya es el primero*)
		else
		begin
		        q := L;
		        while (q^.nxt <> p) do (*El bucle se detiene cuando el siguiente puntero es p*)
				q:= q^.nxt;
			previous:= q;
		end;
	end;

	function next(p: tPosL; L:tList):tPosL;
	begin
	   next := p^.nxt
	end;
	
	procedure createnode(var newnode: tPosL; d:tItem); (*Funcion auxiliar de insertItem*)
	begin
		newnode := NULL;
		new(newnode);  (*Crea el nuevo nodo y le asigna los datos en caso haber sido inizializado*)
		if newnode <> NULL then begin 
			newnode^.item := d;
			newnode^.nxt := NULL;
		end
	end;
	
	function insertItem(d: tItem; p: tPosL; var L: tList): boolean;
		var newnode,q: tPosL;
		begin
			createnode(newnode, d);
			if newnode = NULL then insertItem:=FALSE
			else
			begin
				if L = NULL then
                    L:= newnode
				else 
            if p = NULL then  (*Posición no especificada*)  
				        begin
				        	q:= L;
				        	while q^.nxt <> NULL do (*Itera hasta encontrar la última posición y inserta el nuevo nodo*)
				        		q:= q^.nxt;
				        	  q^.nxt := newnode
				        end
				    else  (*Intercambio de información entre nodos para mantener el orden solicitado
					      (>pre>old(pos)>nex> a >pre>old(new info)>new(old info)>nex>)
					   *)
				        begin
				        	newnode^.item := p^.item;
				        	p^.item := d;
				        	newnode^.nxt := p^.nxt;
				        	p^.nxt := newnode;
				        end;
				    insertItem:= TRUE;
			end;    
		end;
		
    procedure deleteAtPosition(p:tPosL; var L:tList);
    	var q:tPosL;
    	begin
    		if p = first(L) then (*Recorta el primer elemento*)
    			L:=L^.nxt
    		else if p^.nxt = NULL then (*Recorta el último elemento*)
                begin                      
    			        q:= previous(p,L);
    			        q^.nxt := NULL;
                end
            else
          begin (* Proceso de eliminación del nodo en una posición intermedia *)
    				q:= p^.nxt;  (*q = nodo siguiente a p*)
    				p^.item := q^.item;  (* Se almacena la informacion de q en p *)
             p^.nxt := q^.nxt; (*Se enlaza p.nxt al siguiente de q*)
    				p := q; (*P ahora apunta al nodo que va a desaparecer*)
    			end;
    		dispose(p); (*Desbloquea la memoria reservada*)
    	end;
		
	function getitem(p: tPosL; L: tList):tItem;
	begin
		getitem := p^.item;
	end;
	
		(*Se pasa el argumento var L: tList para mantener la interfaz con la implementación estática*)
	
    procedure updateVotes(d:tNumVotes; p:tPosL; var L:tList);
		begin
			p^.item.numvotes := d;
		end;
		
		(*Se pasa el argumento var L: tList para mantener la interfaz con la implementación estática*)
	
	function findItem(d: tPartyName; L:tList):tPosL;
	begin
		while (L <> NULL) and (L^.item.partyname <> d) do
			L:= L^.nxt;
		findItem:=L;
	end;
	
	procedure deleteList(var L:tList);
	begin
		while (L<> NULL) do  (*Borra de primero a último*)
		begin
			deleteAtPosition(first(L) ,L);
		end;
	end;
end.
