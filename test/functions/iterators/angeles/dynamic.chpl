// Centralized Splitting iterator similar to dynamic OpenMP. 
// It splits chunks of fixed size among the threads in a centralized way.
// When a thread finishes its assigned chunk, it gets another chunk, until none remain.

// Contributed by Angeles Navarro 
use DynamicIters;
config const nTasks:int=4; // number of cores; should be here.maxTaskPar?
writeln("Working with ", nTasks, " Threads");


// Adding timing
use Time;
config const quiet: bool=true;
config const nIterTimesF, nIterTimesC, nIterTimesT, nIterTimesR:int=1;
config const chunkTimesF, chunkTimesC, chunkTimesT, chunkTimesR:int=1;
var t: stopwatch;

var grainsize:string; // "fine", "coarse", "tri", "ran"
use Random; 

t.start();
forall i in 0..#nTasks do {
  //initialize pool of threads
 }
t.stop();
if !quiet then {
  writeln();
  writeln("Time to initialize pool ", t.elapsed()*1_000_000, " microseconds");
  writeln();
 }


for k in 0..3 {
  select k {
    when 0 do grainsize="fine";  
    when 1 do grainsize="coarse"; 
    when 2 do grainsize="tri"; 
    otherwise grainsize="rand"; // 
    }

  CheckCorrectness(grainsize);
}


proc CheckCorrectness(grainsize:string)
{
 
  use Time;
  var t: stopwatch;
  var delay:uint;
  var n,m, chunk:int;
  var r:range;
 

  select grainsize {
    when "fine" do {
	n=100*nIterTimesF;
	delay=1;
	chunk=10*chunkTimesF;
	r=1..n;   
	var A:[r] int=0;
	var TestA:[r] int=1;
	var checkA:bool=true;

	writeln();
	writeln("Workload: ", grainsize,". Working with dynamic scheduling ");
	writeln();
	t.start();
	forall c in dynamic(r,chunk,nTasks) with (ref A) do {
	  sleep(delay / 1_000_000.0);
	  A[c]=A[c]+1;
	}
	t.stop();
	if !quiet then {
	  writeln();
	  writeln("Total time ", grainsize, " ", t.elapsed()*1_000, " milliseconds");
//	  writeln("Average time per it. ", (t.elapsed()*1_000)/(n), " milliseconds");
	  writeln();}

	for i in r do {
	  if A[i] != TestA[i] then {
	    checkA=false;
	    writeln(" ");
	    writeln("Error in iteration ", i);
	    writeln(" ");
	  }
	}
	if checkA==true then 
	  writeln("Correct");

    } 
    when "coarse" do {
	n=10*nIterTimesC;
	delay=10000;
	chunk=2*chunkTimesC;
	r=1..n;    
	var B:[r] int=0;
	var TestB:[r] int=1;
	var checkB:bool=true;
	writeln();
	writeln("Workload: ", grainsize,". Working with dynamic scheduling ");
	writeln();
	t.start();
	forall c in dynamic(r,chunk,nTasks) with (ref B) do {
	  sleep(delay / 1_000_000.0);
	  B[c]=B[c]+1;
	}
	t.stop();
	if !quiet then {
	  writeln();
	  writeln("Total time ", grainsize, " ", t.elapsed()*1_000, " milliseconds");
//	  writeln("Average time per it. ", (t.elapsed()*1_000)/(n), " milliseconds");
	  writeln();}
	for i in r do {
	  if B[i] != TestB[i] then {
	    checkB=false;
	    writeln(" ");
	    writeln("Error in iteration ", i);
	    writeln(" ");
	  }
	}
	if checkB==true then 
	  writeln("Correct");
    }
      
    when "tri" do {
      n=10*nIterTimesT;
      delay=100;
      chunk=2*chunkTimesT;
      r=1..n;
      m=(n+1)/2;  
      var C:[r,r] int=0;
      var TestC:[r,r] int=1;
      var checkC:bool=true;  
      writeln();
      writeln("Workload: ", grainsize,". Working with dynamic scheduling ");
      writeln();
  
      t.start();
      forall c in dynamic(r,chunk,nTasks) with (ref C) do {
	for j in c..n do{
	  sleep(delay / 1_000_000.0);
	  C[c,j]=C[c,j]+1;
	}
      }
      t.stop();
      if !quiet then {
	writeln();
	writeln("Total time ", grainsize, " ", t.elapsed()*1_000, " milliseconds");
//	writeln("Average time per it. ", (t.elapsed()*1_000)/(n*m), " milliseconds");
	writeln();}
      for i in r do {
	for j in 1..i-1 do{
	  if C[i,j] !=0 then {
	    checkC=false;
	    writeln(" ");
	    writeln("Error in iteration (", i,",",j,")");
	    writeln(" ");
	  }
	}
	for j in i..n do {
	  if C[i,j] != TestC[i,j] then {
	    checkC=false;
	    writeln(" ");
	    writeln("Error in iteration (", i,",",j,")");
	    writeln(" ");
	  }
	}
      }
      if checkC==true then 
	writeln("Correct");
    }

    otherwise {
      n=10*nIterTimesR;
      delay=100000;
      chunk=2*chunkTimesR;
      r=1..n;    
      var ran:[r] real; // for "irregular computation" 
      fillRandom(ran);
      var delayran=(delay*ran):uint;
      var D:[r] int=0;
      var TestD:[r] int=1;
      var checkD:bool=true;

      writeln();
      writeln("Workload: ", grainsize,". Working with dynamic scheduling ");
      writeln();
  
      t.start();
      forall c in dynamic(r,chunk,nTasks) with (ref D) do {
	sleep(delayran(c) / 1_000_000.0);
	D[c]=D[c]+1;
      }
      t.stop();
      if !quiet then {
	writeln();
	writeln("Total time ", grainsize, " ", t.elapsed()*1_000, " milliseconds");
//	writeln("Average time per it. ", (t.elapsed()*1_000)/(n), " milliseconds");
	writeln();}
	for i in r do {
	  if D[i] != TestD[i] then {
	    checkD=false;
	    writeln(" ");
	    writeln("Error in iteration ", i);
	    writeln(" ");
	  }
	}
	if checkD==true then 
	  writeln("Correct");

 }
    }   

}


