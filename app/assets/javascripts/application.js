// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require backbone
//= require backbone.collectionView
//= require_tree ./models
//= require_tree ./collections
//= require_tree .
//= require jquery.timeago

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/gim,
    evaluate: /\{\{(.+?)\}\}/gim
};

$.timeago.settings.allowFuture = true;
$(function() {
  $("time.timeago").timeago();
});

window.App = window.App || {};
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


