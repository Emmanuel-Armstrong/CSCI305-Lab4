% CSCI 305, Lab 4
% Emmanuel Armstrong
% Partner: Matthew Rohrlach

% The following is a weighted graph with 9 nodes
% Each edge is given as (i,j,weight), with weight > 0.

:-dynamic
		rpath/2.

edge(1,2,1.6).
edge(1,3,1.5).
edge(1,4,2.2).
edge(1,6,5.2).
edge(2,3,1.4).
edge(2,5,2.1).
edge(2,9,5.1).
edge(3,4,1.4).
edge(3,5,1.3).
edge(4,5,1.3).
edge(4,7,1.2).
edge(4,8,3.0).
edge(5,6,1.6).
edge(5,7,1.7).
edge(6,7,1.8).
edge(6,8,2.2).
edge(6,9,1.7).
edge(7,8,1.6).
edge(8,9,1.8).

% your code will start from here 
 
path(X,Y,Length) :- edge(Y,X,Length).
path(X,Y,Length) :- edge(X,Y,Length).
 
shorterPath([A|Path], Length) :-		       
	rpath([A|B], D), !, Length < D,          % match to the target node [A|_]
	retract(rpath([A|_],_)),
	%writef('%w is closer than %w\n', [[A|Path], [A|B]]),
	assert(rpath([A|Path], Length)).
shorterPath(Path, Length) :-		       % Store a new path if none already stored
	%writef('New path:%w\n', [Path]),
	assert(rpath(Path,Length)).
 
traverse(X, Path, Length) :-		    % traverse all reachable nodes for each unvisited neighbor update shortest path and length then traverse the neighbor
	path(X, B, D),		   
	not(memberchk(B, Path)),	    
	shorterPath([B,X|Path], Length+D), 
	traverse(B,[X|Path],Length+D).	   
 
traverse(X) :-
	retractall(rpath(_,_)),           % Remove solutions and traverse from the origin
	traverse(X,[],0).              
traverse(_).
 
go(X, Y) :-
	traverse(X),                   % Find all distances and if the target was reached print the path and the distance
	rpath([Y|RPath], Length)->         
	  reverse([Y|RPath], Path),      
	  Distance is Length,
	  writef('Shortest path is %w with distance %w = %w\n',
	       [Path, Length, Distance]);
	writef('There is no route from %w to %w\n', [X, Y]).
	
shortest(X, Y, Path, Length) :-
	go(X, Y).