App.Marker.MVPEditor = Backbone.View.extend({
  edit: function() {
    this.template = _.template($("#penalty-player-radio").html());
    this.createPlayerRadios();
    this.$el.modal("show");
  },

  events: {
    "click .cancel" : "close",
    "change input" : "playerSelected"
  },

  radiosFor: function(teamId) {
    var self = this;
    var radios = App.players.where({team_id: teamId}).map(function(player) {
      return self.template(_.extend(player.toJSON(), { serving: false}));
    });
    return radios.join("");
  },

  createPlayerRadios: function() {
    var homeTeamId = App.game.get("home_team").id;
    var visitingTeamId = App.game.get("visiting_team").id;

    this.$(".home-players").html(this.radiosFor(homeTeamId));
    this.$(".visiting-players").html(this.radiosFor(visitingTeamId));
  },

  close: function() {
    this.$el.modal("hide");
  },

  playerSelected: function(e) {
    var self = this;
    var input = $(e.target);
    if (input.prop('checked')) {
      var data = { game: { mvp_player_id: $(e.target).val() } };
      $.ajax({
        type: "PUT",
        url: this.model.url() + "/set_mvp.json",
        data: data
      });
    }
  }
});
