

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

function _ajax_json_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        beforeSend: function(xhrObj){
                xhrObj.setRequestHeader("Content-Type","application/json");
                xhrObj.setRequestHeader("Accept","application/json");
        }, 
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}



jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    },
    put_json: function(url, data, callback, type) {
        return _ajax_json_request(url, data, callback, type, 'PUT');
    },
    post_json: function(url, data, callback, type) {
        return _ajax_json_request(url, data, callback, type, 'POST');
    },
    get_json: function(url, data, callback, type) {
        return _ajax_json_request(url, data, callback, type, 'GET');
    }


});



