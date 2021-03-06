#property copyright "Copyright © 2019-2021 Artem Maltsev (Vivazzi)"
#property link      "https://vivazzi.pro"
#property strict


#include <requests/requests.mqh>
#include <unit_test/unit_test.mqh>

#define DEBUG_REQUESTS

class TestRequest: public TestCase {
private:
    string TEST_URL;
    string res;

public:
    TestRequest() {
        TEST_URL = "https://vivazzi.pro/test-request/";
    }
    // ----- TESTS OF README -----

    // --- "Simple usage" section ---
    void test_readme_simple_usage_1(){
        Requests requests;
        Response response = requests.get(TEST_URL, "par_1=foo&par_2=bar");
        res = "Response: " + response.text;
        Print(res);
        assert_equal(res, "Response: OK,GET,query_string par_1=foo&par_2=bar");

        res = "Response parameters: " + response.parameters;
        Print(res);
        assert_equal(res, "Response parameters: par_1=foo&par_2=bar");
    }


    void test_readme_simple_usage_2(){
        Requests requests;
        Response response;

        response = requests.get(TEST_URL, "par_1=foo&par_2=bar");
        assert_equal("Response of GET: " + response.text, "Response of GET: OK,GET,query_string par_1=foo&par_2=bar");

        response = requests.post(TEST_URL, "par_1=foo&par_2=bar");
        assert_equal("Response of POST: " + response.text, "Response of POST: OK,POST,body par_1=foo&par_2=bar");

        // or send() for dynamic define request query
        string method = "POST";
        response = requests.send(method, TEST_URL, "par_1=foo&par_2=bar");
        assert_equal("Response of SEND (POST): " + response.text, "Response of SEND (POST): OK,POST,body par_1=foo&par_2=bar");
    }


    void test_readme_simple_usage_3(){
        Requests requests;

        assert_equal(requests.get(TEST_URL + "?par_1=foo&par_2=bar").parameters, "par_1=foo&par_2=bar");
        assert_equal(requests.get(TEST_URL, "par_1=foo&par_2=bar").parameters, "par_1=foo&par_2=bar");
        assert_equal(requests.get(TEST_URL + "?par_1=foo", "par_2=bar").parameters, "par_1=foo&par_2=bar");
    }


    void test_readme_simple_usage_4(){
        Requests requests;
        Response response;

        string array_data[2][2];
        array_data[0][0] = "par_1"; array_data[0][1] = "foo";
        array_data[1][0] = "par_2"; array_data[1][1] = "bar";

        response = requests.get(TEST_URL, array_data);
        assert_equal(response.text, "OK,GET,query_string par_1=foo&par_2=bar");
    }


    // --- "Usage with RequestData" section ---
    void test_readme_usage_with_request_data_1(){
        RequestData request_data;
        request_data.add("par", "foo");

        Requests requests;
        Response response = requests.get(TEST_URL, request_data);
        assert_equal(response.text, "OK,GET,query_string par=foo");
        assert_equal(response.parameters, "par=foo");
    }


    // --- "API RequestData" section ---
    void test_readme_api_request_data_1(){
        RequestData request_data;
        request_data.add("par_1", "foo");
        request_data.add("par_2", "bar");

        Requests requests;
        Response response = requests.get(TEST_URL, request_data);
        assert_equal(response.text, "OK,GET,query_string par_1=foo&par_2=bar");
        assert_equal(response.parameters, "par_1=foo&par_2=bar");
    }


    void test_readme_api_request_data_2(){
        RequestData request_data;

        request_data.add("par_1", "foo");
        request_data.add("par_2", "bar");
        assert_equal(request_data.to_str(), "par_1=foo&par_2=bar");

        request_data.add("par_2", "super_bar");
        assert_equal(request_data.to_str(), "par_1=foo&par_2=super_bar");
    }


    void test_readme_api_request_data_3(){
        RequestData request_data;

        request_data.add("par_1", "foo");
        request_data.add("par_2", "bar");
        request_data.add("par_3", "baz");
        assert_equal(request_data.to_str(), "par_1=foo&par_2=bar&par_3=baz");

        request_data.remove("par_2");  // removes data pair with specific name
        assert_equal(request_data.to_str(), "par_1=foo&par_3=baz");

        request_data.remove();  // removes all data pairs
        assert_equal(request_data.to_str(), "");
    }


    void test_readme_api_request_data_4(){
        string array_data[2][2];
        array_data[0][0] = "par_1"; array_data[0][1] = "foo";
        array_data[1][0] = "par_2"; array_data[1][1] = "bar";
        assert_equal(RequestData::to_str(array_data), "par_1=foo&par_2=bar");
    }


    // ----- FULL TESTS -----

    // --- GET ---
    void test_get_1(){
        Requests requests;
        Response response = requests.get(TEST_URL, "par=foo");
        assert_equal(response.text, "OK,GET,query_string par=foo");
        assert_equal(response.url, "https://vivazzi.pro/test-request/?par=foo");
    }


    void test_get_2(){
        RequestData request_data;
        request_data.add("par", "foo");

        Requests requests;
        Response response = requests.get(TEST_URL, request_data);
        assert_equal(response.text, "OK,GET,query_string par=foo");
    }


    void test_get_3(){
        string array_data[2][2];
        array_data[0][0] = "par_1"; array_data[0][1] = "foo";
        array_data[1][0] = "par_2"; array_data[1][1] = "bar";

        Requests requests;
        Response response = requests.get(TEST_URL, array_data);
        assert_equal(response.text, "OK,GET,query_string par_1=foo&par_2=bar");
    }


    // --- POST ---
    void test_post_1(){
        string str_data = "par_1=foo&par_2=bar";

        Requests requests;
        Response response = requests.post(TEST_URL, str_data);
        assert_equal(response.text, "OK,POST,body par_1=foo&par_2=bar");
    }


    void test_post_2(){
        RequestData request_data();

        request_data.add("par_1", "foo");
        request_data.add("par_2", "bar");

        Requests requests;
        Response response = requests.post(TEST_URL, request_data);
        assert_equal(response.text, "OK,POST,body par_1=foo&par_2=bar");
    }


    void test_post_3(){
        string array_data[2][2];
        array_data[0][0] = "par_1"; array_data[0][1] = "foo";
        array_data[1][0] = "par_2"; array_data[1][1] = "bar";

        Requests requests;
        Response response = requests.post(TEST_URL, array_data);
        assert_equal(response.text, "OK,POST,body par_1=foo&par_2=bar");
    }

    void test_post_4(){
        string array_data[2][2];
        array_data[0][0] = "par_1"; array_data[0][1] = "foo";
        array_data[1][0] = "par_2"; array_data[1][1] = "bar";

        Requests requests;
        Response response = requests.post(TEST_URL + "?par_3=baz", array_data);
        assert_equal(response.text, "OK,POST,query_string par_3=baz,body par_1=foo&par_2=bar");
    }


    // --- SEND ---
    void test_send_1(){
        Requests requests;
        string str_data = "par_1=foo&par_2=bar";

        Response response = requests.send("POST", TEST_URL, str_data);
        assert_equal(response.text, "OK,POST,body par_1=foo&par_2=bar");
    }


    void test_send_2(){
        RequestData request_data();

        request_data.add("par_1", "foo");
        request_data.add("par_2", "bar");

        Requests requests;
        Response response = requests.send("POST", TEST_URL, request_data);
        assert_equal(response.text, "OK,POST,body par_1=foo&par_2=bar");
    }


    void test_send_3(){
        string array_data[2][2];
        array_data[0][0] = "par_1"; array_data[0][1] = "foo";
        array_data[1][0] = "par_2"; array_data[1][1] = "bar";

        Requests requests;
        Response response = requests.send("POST", TEST_URL, array_data);
        assert_equal(response.text, "OK,POST,body par_1=foo&par_2=bar");
    }

    void declare_tests() {
        // ----- TESTS OF README -----
        test_readme_simple_usage_1();
        test_readme_simple_usage_2();
        test_readme_simple_usage_3();
        test_readme_simple_usage_4();
        test_readme_usage_with_request_data_1();
        test_readme_api_request_data_1();
        test_readme_api_request_data_2();
        test_readme_api_request_data_3();
        test_readme_api_request_data_4();


        // ----- FULL TESTS -----
        // --- GET interfaces ---
        test_get_1();
        test_get_2();
        test_get_3();

        // --- POST interfaces ---
        test_post_1();
        test_post_2();
        test_post_3();
        test_post_4();

        // --- SEND interfaces ---
        test_send_1();
        test_send_2();
        test_send_3();
    }

};

int OnInit(){
    TestRequest test_request;
    test_request.run();

	return(INIT_SUCCEEDED);
}