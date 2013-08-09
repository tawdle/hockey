window.App = window.App || {};

App.GameView = Backbone.View.extend({
  initialize: function() {
    this.gameStart = $("#game-start");
    this.gamePause = $("#game-pause");
    this.listenTo(this.model, "change", this.render);
    setInterval(function() { this.trigger("clockTick"); }.bind(this), 500);
    var el = $("#game-clock").first();
    this.gameClockView = new App.TimerView({el: el, model: App.game.get("clock"), parent: this });
  },

  render: function() {
    console.log("in GameView render");
    var state = this.model.get("state");
    console.log("state is " + state);
    this.gameStart.toggle(state == "scheduled" || state == "paused");
    this.gamePause.toggle(state == "active");
  }
});
