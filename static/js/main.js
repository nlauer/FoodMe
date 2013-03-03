$('#signin_form').submit(function() {
  // TODO validate
  // yeah, this is a pretty terrible way to do this. #hackathonlife
  monster.set('user_creds', {
    email: $('#signin_email').val(),
    password: $('#signin_password').val()
  });
});

$(document).on('ready', function() {
  var user_info = monster.get('user_creds');
  if (user_info) {
    // user is logged in
    $('#user_email').html(user_info.email);
    $('#user_logged_in').show();
    $('#signin_form').hide();
  }
});
