window.App = window.App || {};

App.GameView = Backbone.View.extend({
  tagName: "div",

  _templateCache: null,

  template: function(params) {
    return (this._templateCache || (this._templateCache = _.template($("#game-template").html())))(params);
  },

  initialize: function() {
    this.listenTo(this.model, "change", this.render);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }
});
