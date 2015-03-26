## Clo Clo

* RESTful API provides a structured and simple way to interact with Clo Clo data streams.
* Built on a custom time series storage system the merges the speed of Redis with the scalability of MySQL.
* An easy to use dashboard that allows you to manage your streams.

## Getting Started

1. Register to get your API key

2. Create your first stream: 
curl -X POST -d key=[your_api_key] name=myStream description=myDescription
The call will return something like this: 
{"result": "success", "stream_id": "2", "created_at": 1426190920} Note the stream_id

3. Push data to your stream: 
curl -X PUT -d key=[your_api_key] arg1=val1 arg2=val2 http://www.clo-clo.net/api/update/[stream_id]

4. Pull data from your stream:
curl http://www.clo-clo.net/api/streams/[stream_id]

http://www.clo-clo.net
