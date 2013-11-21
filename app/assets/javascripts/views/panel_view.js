App.Scoreboard.PanelView = Backbone.View.extend({
  initialize: function(options) {
    this.canvas = this.el;
    this.$canvas = this.$el;
    $(window).on("resize", _.bind(this.resize, this));
    this.resize();
  },

  idealWidth: 1080,
  idealHeight: 1920,
  idealRatio: this.idealHeight / this.idealWidth,

  getContext: function() {
    var context = this.canvas.getContext("2d"),
        width = this.$canvas.attr("width"),
        rx = width / this.idealWidth;
    context.setTransform(rx, 0, 0, rx, 0, 0);
    console.log("set scale to " + rx);
    return context;
  },

  resize: function() {
    this.$canvas.attr("width", Math.floor(window.innerWidth / 3)).attr("height", window.innerHeight);
    this.render();
  }
});
