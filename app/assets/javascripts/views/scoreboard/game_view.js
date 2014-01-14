App.Scoreboard.GameView = Backbone.View.extend({
  name: "GameView",

  initialize: function(options) {
    this.homeView = new App.Scoreboard.TeamView({
      model: this.model, 
      el: ".home-team",
      teamId: this.model.get("home_team").id,
      side: "home_team"
    });

    this.visitingView = new App.Scoreboard.TeamView({
      model: this.model,
      el: ".visiting-team",
      teamId: this.model.get("visiting_team").id,
      side: "visiting_team"
    });

    this.clock = new App.TimerView({
      el: ".clock",
      model: this.model.get("clock"),
      showTimeRemaining: true
    });

    setInterval(function() { App.dispatcher.trigger("clockTick"); }.bind(this), 500);

    this.listenTo(this.model, "change", this.render);
    this.render();
  },

  render: function() {
    this.$(".period").html(this.model.get("period_text"));
  }
});

