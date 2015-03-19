window.onload = function() {

function drawCharts() {
            $.ajax({
                url: '/api/chart_data',
                type: "GET",
                success: function(response) {
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
                        chart.draw(data, options);
                    }
                }
            });
        };
        setTimeout(function(){google.load('visualization', '1', {'callback':drawCharts, 'packages':['corechart']})}, 1000);
}
