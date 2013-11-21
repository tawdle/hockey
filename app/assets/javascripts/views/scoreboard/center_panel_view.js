App.Scoreboard.CenterPanelView = App.Scoreboard.PanelView.extend({
  render: function() {
    var context = this.getContext();
    context.fillStyle = "black";
    context.fillRect(0, 0, 1079, 1919);

    context.font = "150pt Arial";
    context.fillStyle = "red";
    context.textAlign = "center";
    context.fillText("11:42", 540, 200);
  }
});
