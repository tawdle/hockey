App.Marker.GoalPlayerSelector = Backbone.View.extend({
  initialize: function() {
    this.role = this.options.role;
    this.teamId = this.options.teamId;
    this.template = _.template($("#goal-player-radio").html());
    this.parent = this.options.parent;
    this.clearButton = this.$(".clear");
    this.editButton = this.$(".edit");
  },

  initializeForm: function(playerId, open) {
    this.createRadios();
    this.playerId(playerId);
    this.updatePlayerLabel();
    this.editButton.toggle(!open);
    this.$("div").toggle(open);
    this.$el.toggle(open || playerId !== undefined);
  },

  events: {
    "click legend" : "openForEditing",
    "click .clear" : "clearSelection",
    "change input[type=radio]" : "playerChanged"
  },

  playerId: function(id) {
    return id === undefined ?
      this.$("input:checked").val() :
      this.$("input[value='" + id + "']").prop("checked", true);
  },

  updatePlayerLabel: function() {
    var player = App.players.get(this.playerId());
    if (player) {
      this.$("span.name").html(": " + App.players.get(this.playerId()).get("name_and_number"));
      this.clearButton.toggle(true);
    } else {
      this.$("span.name").empty();
      this.clearButton.toggle(false);
    }
  },

  openForEditing: function() {
    var self = this;

    if (this.$el.is(":visible")) {
      this.$("div").slideDown("fast");
    } else {
      this.$("div").toggle(true);
      this.$el.slideDown("fast");
    }

    this.editButton.toggle(false);

    _.each(_.without(self.parent.selectors, self), function(other) {
      other.closeForEditing();
    });
  },

  closeForEditing: function() {
    var prev = this.prev();
    if (this.playerId() || (prev && prev.playerId())) {
      this.$("div").slideUp("fast");
    } else {
      this.$el.slideUp("fast");
    }
    this.editButton.toggle(true);
  },

  next: function() {
    var index = this.parent.selectors.indexOf(this);
    return index >= 0 ? this.parent.selectors[index + 1] : null;
  },

  prev: function() {
    var index = this.parent.selectors.indexOf(this);
    return index > 0 ? this.parent.selectors[index - 1] : null;
  },

  playerChanged: function(e) {
    var next= this.next();
    this.updatePlayerLabel();
    if (next && next.playerId() === undefined) {
      next.openForEditing();
    } else {
      this.closeForEditing();
    }
  },

  clearSelection: function(e) {
    e.preventDefault();
    this.$("input").prop("checked", false);
    this.updatePlayerLabel();
    this.openForEditing();
    this.parent.updateSaveButton();
  },

  createRadios: function() {
    var self = this;
    var radios = App.players.where({team_id: self.teamId}).map(function(player) {
      return self.template(_.extend(player.toJSON(), { role: self.role}));
    });
    this.$("div").html(radios.join(""));
  }
});


