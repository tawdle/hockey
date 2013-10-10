window.App = window.App || {};

App.GameView = Backbone.View.extend({
  initialize: function() {
    this.gameStart = this.$("#game-start");
    this.gamePause = this.$("#game-pause");
    this.homeTeamScore = this.$("#home-team .score");
    this.visitingTeamScore = this.$("#visiting-team .score");
    this.gameStatus = this.$("#game-status");
    this.period = this.$("#game-period");

    this.listenTo(this.model, "change", this.render);
    setInterval(function() { App.dispatcher.trigger("clockTick"); }.bind(this), 500);
    var el = $("#game-clock").first();
    this.gameClockView = new App.TimerView({el: el, model: App.game.get("clock"), showTimeRemaining: true});
    this.render();
  },

  events: {
    "ajax:success #new_activity_feed_item" : "clearMessageText"
  },

  clearMessageText: function() {
    this.$("#activity_feed_item_message").val("");
  },

  render: function() {
    var state = this.model.get("state");
    this.gameStart.toggle(state != "playing");
    this.gamePause.toggle(state == "playing");
    $("p[class=" + state + "]", this.gameStatus).toggle(true).siblings().toggle(false);

    this.period.text(this.model.get("period_text"));
    this.gameStatus.removeClass("active playing paused finished").addClass(state);
    this.homeTeamScore.text(this.model.get("home_team_score"));
    this.visitingTeamScore.text(this.model.get("visiting_team_score"));
  }
});
