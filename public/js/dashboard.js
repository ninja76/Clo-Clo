window.onload=function(){

        $.ajax({
          url: '/api/chart_data',
            type: "GET",
            success: function(response) {
              response = JSON.parse(response);

              for (i=2; i < response.length; i++) {
                console.log(response[i]);

                var newCanvas =
                $('<canvas/>',{'class':'chart', 'id': "myChart"+i, 'style':'padding-bottom:100px;'})
                .width(600)
                .height(400);
                $('#streams').append(newCanvas);
                  console.log(response[1][i-2]);
	        var data = {
                   labels: response[0],
 		   datasets: [
   	            {
         	    label: response[1][i-2],
	            fillColor: "rgba(220,220,220,0.2)",
        	    strokeColor: "rgba(220,220,220,1)",
	            pointColor: "rgba(220,220,220,1)",
        	    pointStrokeColor: "#fff",
	            pointHighlightFill: "#fff",
	            pointHighlightStroke: "rgba(220,220,220,1)",
	            data: response[i]
	            }
	            ]
	         }
                var ctx = $("#myChart"+i).get(0).getContext("2d");
                var myLineChart = new Chart(ctx).Bar(data);
              }
            }
          });
};
