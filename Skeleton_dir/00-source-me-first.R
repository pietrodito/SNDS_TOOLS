do.call(
  function() {
    file.edit("./R/01-sql-orchestration.R")
    rstudioapi::documentClose()
  }, list())
