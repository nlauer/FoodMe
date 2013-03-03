$('#signin_form').submit(function() {
// TODO validate
  monster.set('user_creds', {
    email: $('#signin_email').val(),
    password: $('#signin_password').val()
  });
  return false // do not continue!
});
