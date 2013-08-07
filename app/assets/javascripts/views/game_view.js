window.App = window.App || {};

App.GameView = Backbone.View.extend({
  initialize: function() {
    this.gameStart = $("#game-start");
    this.gamePause = $("#game-pause");
    this.listenTo(this.model, "change", this.render);
  },

  render: function() {
    console.log("in GameView render");
    var state = this.model.get("state");
    console.log("state is " + state);
    this.gameStart.toggle(state == "scheduled" || state == "paused");
    this.gamePause.toggle(state == "active");
  }
});
