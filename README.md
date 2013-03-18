# Accumulator

Wait to call the final callback until all subtasks have returned.

Yep, that's it.  As of this writing this 'library' is 17 lines of code.  You can initialize it on a target callback, and then you can create subtasks of that one.  When all the subtasks have completed it will call the target callback.

It supports the node convention of (err, data).  If any of your subtasks return results they will be accumulated in an array.  If any return an error, the target will be called immediately with the error, and the results of all further subtasks will be ignored.

## Usage

```coffee-script
should = require 'should'
accumulator = require '../lib/accumulator'

describe 'accumulator', ->
  it 'should wait for all collectors to return', (done) ->
    collector = accumulator done

    setTimeout collector(), 1
    setTimeout collector(), 2
    setTimeout collector(), 3

  it 'should return all results', (done) ->
    collector = accumulator (err, results) ->
      should.not.exist err
      results.should.eql [0, 1]
      done()

    i = 0
    doStuff = (cb) ->
      -> cb null, i++

    setTimeout doStuff(collector()), 1
    setTimeout doStuff(collector()), 2
```

## Why'd you write it?

I use Async for some stuff.  Async is complex.  I've seen promises, but they look a little bit too low level.  This is like promises, but a very special case.  This happens to be the case that I find myself needing about 80% of the time, and I wanted something very simple to use, very simple to think about and maintain.

## LICENSE

(MIT License)

Copyright (c) 2013 Torchlight Software <info@torchlightsoftware.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
