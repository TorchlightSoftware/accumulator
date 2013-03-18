module.exports = (done) ->
  counter = 0
  error = null
  results = []

  ->
    counter++

    (err, result) ->
      return if error
      if err
        error = err
        return done err, results

      results.push result
      if --counter is 0
        done null, results
