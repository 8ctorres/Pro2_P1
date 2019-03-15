program TestUnit;

uses StaticList;
//uses DynamicList;

procedure print_list(L : tList);
{prints a list, iterative version}
var p : tPosL; d:tItem;

begin
   write('(');
   if not isEmptyList(L) then
   begin
      p := first(L);
      while p <> NULL do
      begin
      d:=getItem(p,L);
		write(' ',d.partyName,' numVotes ',d.numVotes);
	 p := next(p, L)
      end;
   end;
   writeln(')');
end; { print_list_i }


var l:tList;
    p:tPosL;
    d,d1: tItem;

begin

	createEmptyList(l);

	print_list(l);

	d1.partyName:='party3';

	insertItem(d1, NULL, l);

	print_list(l);

	d1.partyName:='party1';
	insertItem(d1, first(l), l);

	print_list(l);

	d1.partyName:='party5';
    insertItem(d1, NULL, l);

	print_list(l);

    d1.partyName:='party2';
    insertItem(d1, next(first(l),l), l);

	print_list(l);

    d1.partyName:='party4';
	insertItem(d1, last(l), l);

	print_list(l);

    p := findItem('party33', l);

    if p = NULL then writeln('party33 Not found');

    p := findItem('party3', l);

	d := getItem(p, l);

	writeln(d.partyName);


	d.numVotes := 1;

	updateVotes(d.numVotes, p, l);

	d := getItem(p, l);

	writeln(d.partyName);

	print_list(l);

	deleteAtPosition(next(first(l),l), l);

	print_list(l);

	deleteAtPosition(previous(last(l),l), l);

	print_list(l);

	deleteAtPosition(first(l),l);

	print_list(l);

	deleteAtPosition(last(l),l);

	print_list(l);

	deleteAtPosition(first(l),l);

    print_list(l);
    insertItem(d1, NULL, l);
    print_list(l);

end.
