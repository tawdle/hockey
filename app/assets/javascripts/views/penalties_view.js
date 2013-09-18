App.PenaltiesView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = options.teamId;
    this.listenTo(App.penalties, 'add', this.addOne);
    this.listenTo(App.penalties, 'reset', this.reset);
    this.addAll();
  },

  events: {
  },


  addOne: function(penalty) {
    if (penalty.teamId() == this.teamId) {
      var view = new App.PenaltyView({model: penalty});
      this.$el.append(view.render().el);
    }
  },

  addAll: function() {
    App.penalties.each(this.addOne, this);
  },

  reset: function() {
    this.$el.empty();
    this.addAll();
  },

  render: function() {

  }
});

