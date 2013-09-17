window.App = window.App || {};

App.PenaltyEditor = Backbone.View.extend({
  initialize: function() {
    this.playerSelect = this.$(".penalty-player select");
    this.servingPlayerSelect = this.$(".penalty-serving-player select");
    this.categorySelect = this.$(".penalty-category select");
    this.infractionSelect = this.$(".penalty-infraction select");
    this.penaltyMinutes = this.$("input[type=number]");
    this.teamId = this.options.teamId;
    App.dispatcher.on("penalty:edit", this.editIf, this);
  },

  tagName: "div",

  events: {
    "change .penalty-player select" : "selectServingPlayer",
    "change .penalty-category select" : "setInfractionOptions",
    "submit form" : "saveAndClose",
    "click a.cancel" : "cancel"
  },

  optionPrompt: function(prompt) {
    return '<option selected disabled value="">' + prompt + '</option>';
  },

  optionString: function(value, text) {
    return '<option value="' + value + '">' + text + '</option>';
  },

  setInfractionOptions: function() {
    var category = this.categorySelect.val();
    var infractions = App.infractions[category];
    var self = this;
    var options = _.map(infractions, function(s) { return self.optionString(s, self.humanize(s)); }).join("");
    this.infractionSelect.html(self.optionPrompt("Infraction") + options);
    var minutes = category == "major" ? 10 : 2;
    this.penaltyMinutes.val(minutes);
  },

  setMinutes: function() {
  },

  setPlayerOptions: function() {
    var self = this;
    var options = App.players.where({team_id: this.teamId}).map(function(player) { return self.optionString(player.id, player.get("jersey_number")); }).join("");
    this.playerSelect.html(self.optionPrompt("Player who committed penalty") + options);
    this.servingPlayerSelect.html(self.optionPrompt("Player who will serve penalty") + options);
  },

  selectServingPlayer: function() {
    this.servingPlayerSelect.val(this.playerSelect.val());
  },

  humanize: function(property) {
    return property.replace(/_/g, ' ').replace(/(\w+)/g, function(match) {
        return match.charAt(0).toUpperCase() + match.slice(1);
    });
  },

  initializeForm: function() {
    this.setPlayerOptions();
    this.playerSelect.val(this.model.get("player_id"));
    this.servingPlayerSelect.val(this.model.get("serving_player_id"));
    this.categorySelect.val(this.model.get("category"));
    this.setInfractionOptions();
    this.infractionSelect.val(this.model.get("infraction"));
    this.penaltyMinutes.val(this.model.get("minutes"));
  },

  saveAndClose: function(e) {
    e.preventDefault();
    var self = this;
    var values = {
      player_id: this.playerSelect.val(),
      serving_player_id: this.servingPlayerSelect.val(),
      category: this.categorySelect.val(),
      infraction: this.infractionSelect.val(),
      minutes: this.penaltyMinutes.val()
    };

    this.model.save(values, { 
      success: function() {
        self.$el.slideUp();
        App.penalties.add(self.model); // XXX: until broadcast works
      }
    });
  },

  cancel: function(e) {
    e.preventDefault();
    this.$el.slideUp();
  },

  editIf: function(penalty) {
    if (penalty.teamId() == this.teamId) {
      this.edit(penalty);
    }
    return this;
  },

  edit: function(penalty) {
    this.model = penalty;
    this.initializeForm();
    this.$el.slideDown();
    return this;
  }
});

