(function($) {
  function Client(accessToken) {
    this.accessToken = accessToken;
  }

  Client.prototype.outgoing = function(message, callback) {
    message.Authorization = 'Bearer ' + this.accessToken;
    callback(message);
  };

  Client.prototype.incoming = function(message, callback) {
    if (message.error != 'Authentication failed.') {
      callback(message);
    }
  };

  Client.publish = function (url, channel, data, accessToken, callback) {
    message = {channel: channel, data: data, Authorization: 'Bearer ' + accessToken};
    return $.ajax({
      url: url,
      method: 'POST',
      success: callback
    });
  };
  
  window.FayeJwt = {
    Client: Client
  };
})(jQuery);
