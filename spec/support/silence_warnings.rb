require 'stringio'

def silence_warnings
  old_stderr, old_verbose = $stderr, $VERBOSE
  $stderr = StringIO.new
  $VERBOSE = false
  yield
ensure
  $stderr = old_stderr
  $VERBOSE = old_verbose
end
