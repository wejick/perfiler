# Perfiler
## Simple profiler for perl

Package to do profiling in perl, it takes how long a scope takes time to execute.

## How To use (This is from test.pl)
```perl
#create the profiler instance here
my $profiler = new Perfiler;

{
  # this will measure time taken until out of scope
  my $me = $profiler->start_scope("test 1");
  {
    my $you = $profiler->start_scope("test 2");
    {
      my $bro = $profiler->start_scope("test 3");
    }
    {
      my $store = $profiler->start_scope("test 4");
    }
  }
}
print $profiler->get_json;
```
output :
```javascript
[{"level":2,"elapse_ms":0.01,"name":"test 3","started_at":[1469795734,394348]},{"level":1,"elapse_ms":0.048,"name":"test 2","started_at":[1469795734,394341]},{"level":0,"elapse_ms":0.074,"started_at":[1469795734,394328],"name":"test 1"},{"level":2,"elapse_ms":0.029,"started_at":[1469795734,394384],"name":"test 4"}]
```
## TODO :
1. Output to json - Done
2. Create visualizer
3. Create easier to use class wrapper (interface) - Done