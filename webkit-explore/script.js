function injectedMethod(inputInfo, successFunc, errorFunc) {
    var promise = window.webkit.messageHandlers.gbMessageHandlerWithReply.postMessage(inputInfo);
    
    promise.then(
      function(result) {
        successFunc( result )
      },
      function(err) {
        errorFunc( err )
      });
}
