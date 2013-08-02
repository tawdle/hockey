$(function() {
  $("input#team_membership_username_or_email").typeahead(
    [
      {
        name: 'Users',
        remote: '/typeahead/get_users.json?q=%QUERY'
      }
    ]
  );
});
