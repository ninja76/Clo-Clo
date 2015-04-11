window.onload = function() {

  $('#tabs').tab();
  var current_timerange = 86400;

  $('#btn-update').on('click', function () {
    var name = $('#stream_name').val()
    var desc = $('#stream_desc').val()
    var stream_id = $('#streamID').val()
    var formData = {name:name, desc:desc};
    var fieldData = ''
    for (i=1; i<6; i++)
    {
      var thisField= $('#field'+i+'_name').val()+','+$('#field'+i+'_uom').val()+','+$('#field'+i+'_alias').val();
      fieldData = fieldData + ':' + thisField
    }
    var formData = {name:name, desc:desc, field:fieldData};
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
    console.log("delete");
    $.ajax({
          url: '/dashboard/delete/'+stream_id,
            type: "DELETE",
            success: function(response) {
	      window.location.replace("/dashboard");
            }
    });
  });

  $('#day').on('click', function () {
    current_timerange = 86400;
    drawCharts(current_timerange);
  });
  $('#week').on('click', function () {
    current_timerange = 86400*7;
    drawCharts(current_timerange);
  });
  $('#month').on('click', function () {
    current_timerange = 604800 *4;
    drawCharts(current_timerange);
  });


  
function drawCharts(timerange) {
            $.ajax({
                url: '/chart_data?timeframe='+timerange+'&stream_id='+$('#streamID').val(),
                type: "GET",
                success: function(response) {
                     $('#streams').html("");
                    if (response.result == "error")
                    {
                      $('#streams').append("<div style='text-align:center;'><h2>No data found</h2>");
                      return;
                    }
                    //response = JSON.parse(response);
                    for (i = 3; i < response.length; i++) {
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
                        data.addColumn('number', response[1][i-3]);
                        for (ii = 0; ii < response[0].length; ii++) {
                            data.addRow([
                                (new Date(response[0][ii]*1000)), parseFloat(response[i][ii])
                            ]);
                        }
                        // Set chart options
                        var options = {
                            'title': response[1][i-3]+" / Last value: "+response[i][response[0].length-1],
                            'height': 200,
                            'legend': 'none',
                            vAxis: {
                              title:  response[2][i-3],
                              slantedText:true,
                              slantedTextAngle:90
                            },
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
        setTimeout(function(){google.load('visualization', '1', {'callback':drawCharts, 'packages':['corechart']})}, 1000);
   $(window).resize(function(){
        drawCharts(current_timerange);
    });
}
