window.onload=function(){

  $('#btn-add').on('click', function () {
      var stream_name = $('#stream_name').val()
      var stream_desc = $('#stream_desc').val()
      var formData = {stream_name:stream_name, stream_desc:stream_desc};
        $.ajax({
          url: '/dashboard/create',
            type: "POST",
            data : formData,
            success: function(response) {
              console.log(response)
              if (response.result == "fail") {
                $("#result").html('<div class="alert alert-danger">'+response.message+"</div>");
              } else {
                $("#result").html('<div class="alert alert-success">Stream Created! New Stream ID: '+response.stream_id+'</div>');
              }
            }
          });
  });

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
              console.log("adfasfd " + response);
              if (response.result == "fail") {
                $("div.error").html('<div class="alert alert-danger">'+response.error+"</div>");
              } else {
                window.location.href = "/dashboard";
              }
               
            }
    });

  });

}
