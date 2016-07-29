# Perfiler
## Simple profiler for perl

Package to do profiling in perl, it takes not how long your function call is. 

## How To use (This is from test.pl)
```perl
use perfiler;

my %perfilerHandler = (
	level => 0,
	data => []
);

{
	my $profiler = new perfiler("Testing",\%perfilerHandler);
	{
		my $profiler = new perfiler("Testing",\%perfilerHandler);
	}
}
print Dumper($perfilerHandler{data});
```
output :
```perl
$VAR1 = [
          {
            'name' => 'Testing',
            'elapse_ms' => '0.019',
            'started_at' => [
                              1469788986,
                              937403
                            ],
            'level' => 0
          },
          {
            'started_at' => [
                              1469788986,
                              937413
                            ],
            'level' => 1,
            'elapse_ms' => '0.031',
            'name' => 'Testing'
          }
        ];
```
## TODO :
1. Output to json
2. Create graphviz based visualizer
3. Create easier to use class wrapper (interface)
