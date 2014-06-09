window.onload=function(){

  $('#registerBtn').on('click', function () {
      var email = $('#inputEmail').val()
      var username = $('#inputUsername').val()
      var password = $('#inputPassword').val()
      var confirmpassword = $('#confirmPassword').val()
      if (password != confirmpassword) {
        $("div.error").html('<div class="alert alert-warning">Passwords do not match</div>');
      } else {
        var formData = {username:username, email:email, password:password};
        $.ajax({
          url: '/register/submit',
	    type: "POST",
	    data : formData,
            success: function(response) {
              response = JSON.parse(response)
              console.log(response);     
              console.log(response.result);     
              if (response.result == "fail") {
                $("div.error").html('<div class="alert alert-danger">'+response.error+"</div>");       
	      } else {
                $("div.error").html('<div class="alert alert-success">Registration successful here is your key is '+response.key+'</div>');
	      }
            }
          });      
        }

  });
}
