window.onload=function(){

  $('#registerBtn').on('click', function () {
      var email = $('#inputEmail').val()
      var username = $('#inputUsername').val()
      var password = $('#inputPassword').val()
      var password2 = $('#confirmPassword').val()
      if (password != password2) {
        $("div.error").html('<div class="alert alert-warning">Passwords do not match</div>');
      } else {
        var formData = {username:username, email:email, password:password};
        $.ajax({
          url: '/register/submit',
	    type: "POST",
	    data : formData,
            success: function(response) {
              response = JSON.parse(response)
              if (response.result == "fail") {
                $("div.error").html('<div class="alert alert-danger">'+response.error+"</div>");       
	      } else {
                $("div.error").html('<div class="alert alert-success">Registration successful.  Here is your API key '+response.key+'</div>');
	      }
            }
          });      
        }

  });

  $('#loginBtn').on('click', function () {
    var username = $('#inputUsername').val()
    var password = $('#inputPassword').val()
    var formData = {username:username, password:password};    
    $.ajax({
          url: '/login/submit',
            type: "POST",
            data : formData,
            success: function(response) {
              response = JSON.parse(response)
              if (response.result == "fail") {
                $("div.error").html('<div class="alert alert-danger">'+response.error+"</div>");
              } 
            }
    });

  });

}
