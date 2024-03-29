window.App = window.App || {};

App.TimerView = Backbone.View.extend({
  initialize: function() {
    this.listenTo(App.dispatcher, "clockTick", this.render);
    this.render();
  },

  render: function() {
    var timer = this.model;
    var secs = timer ? (this.options.showTimeRemaining ? timer.getTimeRemaining() : timer.getElapsedTime()) + this.model.get("offset") : 0;
    var hours = Math.floor(secs / 3600);
    var minutes = Math.floor(secs / 60) % 60;
    var seconds = Math.floor(secs % 60);
    var h = hours > 0 ? (String(hours) + ":") : "";
    var m = (minutes < 10 ? "0" : "") + String(minutes) + ":";
    var s = (seconds < 10 ? "0" : "") + String(seconds);
    var result = h + m + s;
    if (timer && timer.get("state") == "running" && Date.now() % 1000 >= 500)
      result = result.replace(/:/g, " " );
    this.$el.text(result);
    return this;
  }
});

