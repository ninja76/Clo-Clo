window.onload=function(){

        $.ajax({
          url: '/api/chart_data',
            type: "GET",
            success: function(response) {
              response = JSON.parse(response);
              for (i=2; i < response.length; i++) {
                var newCanvas =
                $('<div/>',{'class': 'epoch category20c', 'id': "myChart"+i, 'style':'margin-bottom:200px;'})
                .width(800)
                .height(200);
                $('#streams').append(newCanvas);
                var myData = [ 
                { 
                  label: response[1][i],
                  values: []
                }
                ]; 
                for (ii=0; ii < response[0].length; ii++) {
                  var point = {time: response[0][ii], y: response[i][ii]};
                  myData[0].values[ii] = point; 
                }
                //console.log(myData);
                var myChart = $("#myChart"+i).epoch({ type: 'time.line', data: myData });
              }
            }
          });
};
