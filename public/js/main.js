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
            success: function(response) {
              response = JSON.parse(response)
              console.log(response);     
              console.log(response.result);     
              if (response.result == "fail") {
                $("div.error").html("<b>"+response.error+"</b>");       
	      } else {
                $("div.error").html("<b>Your key is "+response.key+"</b>");
	      }
            }
          });      
        }

  });
}
