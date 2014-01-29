App.Scoreboard.GameView = Backbone.View.extend({
  name: "GameView",

  initialize: function(options) {
    this.board = options.board;
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

    this.listenTo(this, "showing", this.fadeIn);
    this.listenTo(this, "shown", this.shown);
    this.listenTo(this.model, "change", this.render);
    this.render();

    this.listenTo(this.board, "available", this.available);
  },

  shown: function() {
    var opts = { maxFontPixels: 0, widthOnly: true, explicitWidth: 500 };
    this.$(".team.name").textfill(opts);
    this.$(".team.city").textfill(opts);
  },

  fadeIn: function() {
    this.$el.css("opacity", 0).animate({ opacity: 1}, 500);
  },

  render: function() {
    this.$(".period").html(this.model.get("period_text"));
  },

  available: function() {
    var state = this.model.get("state");

    if (["ready", "playing", "paused", "active"].indexOf(state) >= 0) {
      this.board.enqueue(this);
    }
  }
});

