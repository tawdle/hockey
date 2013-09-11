window.App = window.App || {};

App.GameView = Backbone.View.extend({
  initialize: function() {
    this.gameStart = $("#game-start");
    this.gamePause = $("#game-pause");
    this.homeTeamScore = $("#home-team .score");
    this.visitingTeamScore = $("#visiting-team .score");

    this.listenTo(this.model, "change", this.render);
    setInterval(function() { this.trigger("clockTick"); }.bind(this), 500);
    var el = $("#game-clock").first();
    this.gameClockView = new App.TimerView({el: el, model: App.game.get("clock"), parent: this });
  },

  render: function() {
    var state = this.model.get("state");
    this.gameStart.toggle(state != "playing");
    this.gamePause.toggle(state == "playing");
    this.homeTeamScore.text(this.model.get("home_team_score"));
    this.visitingTeamScore.text(this.model.get("visiting_team_score"));
  }
});
