window.App = window.App || {};
window.App.Marker = window.App.Marker || {};
window.App.Scoreboard = window.App.Scoreboard || {};

App.dispatcher = _.clone(Backbone.Events);

App.humanize = function(property) {
  return property.replace(/_/g, ' ').replace(/(\w+)/g, function(match) {
    return match.charAt(0).toUpperCase() + match.slice(1);
  });
};

App.displaySeconds = function(seconds) {
  var hours = Math.floor(seconds / 3600);
  var minutes = Math.floor(seconds / 60) % 60;
  var secs = Math.floor(seconds) % 60;

  var s = (hours > 0 ? hours + ":" : "") + (minutes < 10 ? "0" : "") + minutes + ":" + (secs < 10 ? "0" : "") + secs;
  return s;
};

$(function() {
  $('html, body').on('click', 'a.disabled', function(event) {
    event.preventDefault();
    return false;
  });

  FastClick.attach(document.body);
});


