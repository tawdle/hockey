$(function() {
  $("input#player_username_or_email").typeahead(
    [
      {
        name: 'Users',
        remote: '/typeahead/get_users.json?q=%QUERY'
      }
    ]
  );
});
