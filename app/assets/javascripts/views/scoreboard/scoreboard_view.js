App.Scoreboard.ScoreboardView = Backbone.View.extend({
  initialize: function() {
    this.left = this.$(".left");
    this.center = $(".center");
    this.right = $(".right");

    this.home = new App.Scoreboard.TeamPanelView({side: "home_team", el: this.left});
    this.center = new App.Scoreboard.CenterPanelView({el: this.center});
    this.visiting = new App.Scoreboard.TeamPanelView({side: "visiting_team", el: this.right});
  }
});

