$(document).on('ready', function() {
  var user_info = monster.get('user_creds');
  if (user_info) {
    // user is logged in
    $('#user_email').html(user_info.email);
    $('#order_email').val(user_info.email);
    $('#order_password').val(user_info.password);
    $('.loggedin_only').show();
    $('.loggedout_only').hide();
  } else {
    $('.loggedout_only').show();
    $('.loggedin_only').hide();
  }
});

$('#signin_form').submit(function() {
  // TODO validate
  // yeah, this is a pretty terrible way to do this. #hackathonlife
  monster.set('user_creds', {
    email: $('#signin_email').val(),
    password: $('#signin_password').val()
  });
});


$('#register_form').submit(function() {
  monster.set('user_creds', {
    email: $('form [name=email]').val(),
    password: $('form [name=password]').val()
  });
});
