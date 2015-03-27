window.onload = function() {

  $('#btn-update').on('click', function () {
    var name = $('#stream_name').val()
    var desc = $('#stream_desc').val()
    var stream_id = $('#streamID').val()
    var formData = {name:name, desc:desc};
    $.ajax({
          url: '/dashboard/update/'+stream_id,
            type: "POST",
            data : formData,
            success: function(response) {
            }
    });
  });

  $('#btn-delete').on('click', function () {
    var stream_id = $('#streamID').val()
    $.ajax({
          url: '/dashboard/delete/'+stream_id,
            type: "DELETE",
            success: function(response) {
	      window.location.replace("/dashboard");
            }
    });
  });

function drawCharts() {
            $.ajax({
                url: '/api/chart_data?stream_id='+$('#streamID').val(),
                type: "GET",
                success: function(response) {
                    if (response.result == "error")
                    {
                      $('#streams').append("<div style='text-align:center;'><h2>No data found</h2>");
                      return;
                    }
                    response = JSON.parse(response);
                    for (i = 2; i < response.length; i++) {
                        var newCanvas =
                            $('<div/>', {
                                'class': '',
                                'id': "myChart" + i,
                                'style': 'margin-bottom:50px;width:100%;'
                            })
                            .height(200);
                        $('#streams').append(newCanvas);
                        var data = new google.visualization.DataTable();
                        data.addColumn('datetime', 'Time');
                        data.addColumn('number', response[1][i-2]);
                        for (ii = 0; ii < response[0].length; ii++) {
                            data.addRow([
                                (new Date(response[0][ii]*1000)), parseFloat(response[i][ii])
                            ]);
                        }
                        // Set chart options
                        var options = {
                            'title': response[1][i-2],
                            'height': 200
                        };

                        // Instantiate and draw our chart, passing in some options.
                        var chart = new google.visualization.LineChart($("#myChart"+i).get(0));
                        //google.visualization.events.addListener(chart, 'ready', function () {
                        //   console.log(chart.getImageURI);
                        //});
                        chart.draw(data, options);
                    }
                }
            });
        };
        setTimeout(function(){google.load('visualization', '1', {'callback':drawCharts, 'packages':['corechart']})}, 200);
   $(window).resize(function(){
        drawCharts();
    });
}
