App.Scoreboard.TeamPanelView = App.Scoreboard.PanelView.extend({
  initialize: function(options) {
    this.teamLogo = new Image();
    $(this.teamLogo).on("load", _.bind(this.render, this));
    this.teamLogo.src = App[this.options.side].logo.url;
    this.listenTo(App.game, "change", this.render);
    App.Scoreboard.PanelView.prototype.initialize.apply(this, arguments);
  },

  renderTeamLogo: function() {
    var context = this.getContext();
    context.drawImage(this.teamLogo, 350, 250, 400, 400);
  },

  render: function() {
    var context = this.getContext();
    context.fillStyle = "black";
    context.fillRect(0, 0, 1079, 1919);

    context.font = "150pt Arial";
    context.fillStyle = "red";
    context.textAlign = "center";
    context.fillText(App.game.get(this.options.side).score.toString(), 540, 200);

    context.font = "100pt Arial";
    context.fillText(App[this.options.side].city || "", 540, 800);
    context.fillText(App[this.options.side].full_name || "", 540, 1000);
    this.renderTeamLogo();
  }
});
