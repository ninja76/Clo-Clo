window.onload=function(){

  $('#registerBtn').on('click', function () {
      var email = $('#inputEmail').val()
      var username = $('#inputUsername').val()
      var password = $('#inputPassword').val()
      var confirmpassword = $('#confirmPassword').val()
      if (password != confirmpassword) {
        $("div.error").html("<b>Passwords do not match</b>");
      } else {
        var formData = {username:username, email:email, password:password};
        $.ajax({
          url: '/register/submit',
	    type: "POST",
	    data : formData,
            success: function(result) {
              console.log(result);            
            }
          });      
        }

  });
}
