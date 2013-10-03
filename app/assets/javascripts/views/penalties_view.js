App.PenaltiesView = Backbone.View.extend({
  initialize: function(options, other) {
    this.teamId = options.teamId;
    this.listenTo(App.penalties, 'add', this.addOne);
    this.listenTo(App.penalties, 'reset', this.reset);
    this.listenTo(App.penalties, 'remove', this.showHideTable);
    this.addAll();
  },

  events: {
  },


  addOne: function(penalty) {
    if (penalty.teamId() == this.teamId) {
      var view = new App.PenaltyView({model: penalty});
      this.$el.append(view.render().el);
      this.showHideTable();
    }
  },

  addAll: function() {
    App.penalties.each(this.addOne, this);
    this.showHideTable();
  },

  reset: function() {
    this.$el.empty();
    this.addAll();
  },

  showHideTable: function() {
    //var penalties = App.penalties.filter(function(penalty) { return (penalty.teamId() == this.teamId); }, this);
    //var show = _.any(penalties, function(penalty) { return penalty.get("state") != "completed"; });
    //this.$el.parent().toggle(show);
  },

  render: function() {
  }
});


