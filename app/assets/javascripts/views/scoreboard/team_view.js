App.Scoreboard.TeamView = Backbone.View.extend({
  initialize: function(options) {
    this.side = options.side;
    this.teamId = options.teamId;
    this.$(".team-name").textfill({ maxFontPixels: 0 });
    this.listenTo(this.model, "change:" + this.side, this.render);
    this.render();
  },

  render: function() {
    var data = this.model.get(this.side);
    this.$(".score").html(data.score);
  }
});


