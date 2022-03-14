# Requests

Requests is a simple HTTP library for mql4, built for human beings.
Requests lib allows you to send HTTP/1.1 requests easily.

## Installing

Download repo and copy `mql_requests/Include/requests.mqh` folder to `<TERMINAL DIR>/MQL(4/5)/Include`

## Simple usage

```mql4
#include <requests/requests.mqh>

int OnInit(){
    ...
    
    Requests requests;
    Response response = requests.get("https://site.com/some/url?par=foo&par_2=bar");
    Print("Response: " + response.text);
    // Response: some_response_of_url

    Print("Response parameters: " + response.parameters);
    // Response query: par=foo&par_2=bar
}
```

You can send GET or POST requests:

```mql4
response = requests.get("https://site.com/some/url?par=foo&par_2=bar");
response = requests.post("https://site.com/some/url", "par=foo&par_2=bar");

// or send() for dynamic define request query
string method = "POST";
response = requests.send(method, "https://site.com/some/url", "par=foo&par_2=bar");
```

Using `requests.get()`, you can use GET-parameter in url and data together. Next examples are equivalent:

```mql4
response = requests.get("https://site.com/some/url?par=foo&par_2=bar");
response = requests.get("https://site.com/some/url", "par=foo&par_2=bar");
response = requests.get("https://site.com/some/url?par=foo", "par_2=bar");
Print("Response parameters: " + response.parameters);
// "Response parameters: par=foo&par_2=bar"
```

You can use array of string for request data:

```mql4
string array_data[2][2];
array_data[0][0] = "par_1"; array_data[0][1] = "foo";
array_data[1][0] = "par_2"; array_data[1][1] = "bar";

response = requests.get(url, array_data);
```

## Usage with RequestData

```mql4
RequestData request_data;
request_data.add("par", "foo");

Requests requests;
Response response = requests.get("https://site.com/some/url", request_data);
Print("Response: " + response.text);
// Response: some_response_of_url

Print("Response parameters: " + response.parameters);
// Response parameters: par=foo
```

## Features

- HTTP connection reuse
- Sending of GET or POST requests

## Detailed information of using Requests

You can define `DEBUG_REQUESTS` for display more detailed information of usage `Requests`:

```mql4
#include "lib/requests.mqh"

#define DEBUG_REQUESTS


int OnInit(){
    Requests requests;
    Response response = requests.get("https://site.com/some/url", "par=foo&par_2=bar");
    Print("Response: " + response.text);
}
```

With `DEBUG_REQUESTS` you will an addition information to journal `Terminal/Experts`.


## API RequestData

`RequestData` is helper class for simple create request data.

USAGE:

```mql4
RequestData request_data;
request_data.add("par_1", "foo");
request_data.add("par_2", "bar");

Requests requests;
Response response = requests.get(url, request_data);
Print("Response: " + response.text);
```

You can replace value of pair using the same name in `request_data.add()`:

```mql4
RequestData request_data;
request_data.add("par_1", "foo");
request_data.add("par_2", "bar");

Print(request_data.to_str());
// "par_1=foo&par_2=bar"

request_data.add("par_2", "super_bar");
Print(request_data.to_str());
// "par_1=foo&par_2=super_bar"
```

Use `request_data.remove()` for clear data and fill `request_data` new data:

```mql4
RequestData request_data;
request_data.add("par_1", "foo");
request_data.add("par_2", "bar");
request_data.add("par_3", "baz");
Print(request_data.to_str());
// "par_1=foo&par_2=bar&par_3=baz"

request_data.remove("par_2");  // removes data pair with specific name
Print(request_data.to_str());
// "par_1=foo&par_3=baz"

request_data.remove();  // removes all data pairs
Print(request_data.to_str());
// ""
```

Use static method `to_str(string& _data[][])` if you have an array of pairs:

```mql4
string array_data[2][2];
array_data[0][0] = "par_1"; array_data[0][1] = "foo";
array_data[1][0] = "par_2"; array_data[1][1] = "bar";
Print(RequestData::to_str(array_data));
// "par_1=foo&par_2=bar&par_3=baz"
```

## Run tests

1. Copy `mql_requests/Experts/TestRequest.mq4` to `<TERMINAL DIR>/MQL(4/5)/Experts`
2. Download [mql_unit_test](https://github.com/vivazzi/mql_unit_test/) and copy `mql_unit_test/Include/unit_test.mqh` folder to `<TERMINAL DIR>/MQL(4/5)/Include`
3. Compile `TestRequest.mq4` and run `TestRequest.ex4` in terminal in a window of any trading pair.
4. Look test result in `<TERMINAL DIR>/Files/TestRequests_unit_test_log.txt`

# CONTRIBUTING

To reporting bugs or suggest improvements, please use the [issue tracker](https://github.com/vivazzi/mql_requests/issues).

Thank you very much, that you would like to contribute to mql_requests. Thanks to the [present, past and future contributors](https://github.com/vivazzi/mql_requests/contributors).

If you think you have discovered a security issue in our code, please do not create issue or raise it in any public forum until we have had a chance to deal with it.
**For security issues use security@vuspace.pro**


# LINKS

- Project's home: https://github.com/vivazzi/mql_requests
- Report bugs and suggest improvements: https://github.com/vivazzi/mql_requests/issues
- Author's site, Artem Maltsev: https://vivazzi.pro

# LICENCE

Copyright © 2022 Artem Maltsev and contributors.

MIT licensed.
