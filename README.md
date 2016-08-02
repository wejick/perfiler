# Perfiler
## Simple profiler for perl

Package to do profiling in perl, it takes how long a scope takes time to execute.

##Requirement
This module needs JSON , which is not part of standard perl distribution however already commonly used.

## How To use (This is from test.pl)
```perl
#create the profiler instance here
use Perfiler;
use strict;

  my $profiler = new Perfiler;
  
sub test {
  my $me = $profiler->start_scope("test 1");
  {
    my $you = $profiler->start_scope("test 2");
    {
      my $bro = $profiler->start_scope("test 3");
      my $a = 'a';
    }
    {
      my $store = $profiler->start_scope("test 4");
      my $a = 'a';
    }
    {
      my $store = $profiler->start_scope("test 5");
      my $a = 'a';
    }
  }
  my $a = 'a';
}

sub main {
  test;

  print $profiler->get_json;
}
```
output :
```javascript
[{"name":"test 3","level":2,"started_at":[1469812392,528541],"elapse_ms":0.008},{"elapse_ms":0.005,"level":2,"started_at":[1469812392,528573],"name":"test 4"},{"name":"test 5","level":2,"started_at":[1469812392,528592],"elapse_ms":0.005},{"level":1,"started_at":[1469812392,528534],"elapse_ms":0.073,"name":"test 2"},{"name":"test 1","started_at":[1469812392,528522],"level":0,"elapse_ms":0.094}]
```
## TODO :
1. Output to json - Done
2. Create visualizer
3. Create easier to use class wrapper (interface) - Done

## Caveat :
I found interesting here that when the scope is empty (except the profiler), the perl global destroying order was messy and it messed up the profiling result.
