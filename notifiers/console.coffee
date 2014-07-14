ConsoleNotifier = (config) ->
  notify: (status) -> 
    console.log config['prefix'] + ': ' + status
  
exports.notifier = ConsoleNotifier
