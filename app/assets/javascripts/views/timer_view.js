window.App = window.App || {};

App.TimerView = Backbone.View.extend({
 initialize: function() {
    this.listenTo(this.model, "change", this.render);
  },

  render: function() {
    var timer = this.model;
    var hms = timer.elapsedTimeHMS();
    var h = hms["hours"] > 0 ? (String(hms["hours"]) + ":") : "";
    var m = (hms["minutes"] < 10 ? "0" : "") + String(hms["minutes"]) + ":";
    var s = (hms["seconds"] < 10 ? "0" : "") + String(hms["seconds"]);
    var result = h + m + s;
    if (timer.get("state") == "running" && Math.floor(timer.get("elapsedTime") * 2.0) % 2)
      result = result.replace(/:/g, " " );
    this.$el.text(result);
    return this;
  }
});

