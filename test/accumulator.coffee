should = require 'should'
accumulator = require '..'

describe 'accumulator', ->
  it 'should wait for all collectors to return', (done) ->
    collector = accumulator done

    setTimeout collector(), 1
    setTimeout collector(), 2
    setTimeout collector(), 3

  it 'should not trigger if any collectors are not called', (done) ->

    # we should not modify 'trap' if it works correctly
    trap = 'ready'
    trigger = -> trap = 'sprung!'

    collector = accumulator trigger

    collector()

    setTimeout collector(), 1
    setTimeout collector(), 2

    finished = ->
      trap.should.eql 'ready'
      done()

    setTimeout finished 10

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

  it 'should exit on error', (done) ->
    collector = accumulator (err, results) ->
      should.exist err
      should.exist results
      results.should.eql []
      done()

    collector()

    setTimeout collector()('some error', 'some result'), 1

  it 'should ignore duplicate calls', (done) ->
    collector = accumulator (err, results) ->
      should.not.exist err
      results.should.eql ['a', 'c']
      done()

    cb1 = collector()
    cb2 = collector()

    fn1 = -> cb1 null, 'a'
    fn2 = -> cb1 null, 'b'
    fn3 = -> cb2 null, 'c'

    setTimeout fn1, 1
    setTimeout fn2, 1
    setTimeout fn3, 3
