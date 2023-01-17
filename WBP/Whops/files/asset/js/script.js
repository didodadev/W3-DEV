// İstenilen url'den içeriği alır ve id'si verilen elementin içine basar.
function AjaxLoader( url, element ){
    new AjaxControl.AjaxRequest().get(url + "&isAjax=1", function( response ) {
        $( element ).html( response );
    });
}
// İstenilen url'ye parametreleri formdata olarak post metoduyla gönderir. callback aracılığıyla response ile işlem yapmanızı sağlar
function AjaxControlPostData( url, data, calback ){
    new AjaxControl.AjaxRequest().postData(url + "&isAjax=1", data, calback) 
}
// İstenilen url'ye parametreleri formdata olarak post metoduyla gönderir. callback aracılığıyla json response ile işlem yapmanızı sağlar
function AjaxControlPostDataJson( url, data, calback, beforeSend ){
    new AjaxControl.AjaxRequest().postDataJson(url + "&isAjax=1", data, calback, function(rsp){console.log(rsp);}, beforeSend) 
}
// İstenilen url'ye parametreleri formdata olarak get metoduyla gönderir. callback aracılığıyla json response ile işlem yapmanızı sağlar
function AjaxControlGetDataJson( url, data, calback ){
    new AjaxControl.AjaxRequest().getDataJson(url + "&isAjax=1", data, calback) 
}

function AjaxFormSubmit(formName, successCallback, onsubmitFunction, beforeSendFunc, completeFunc ) {
    
    function beforeSend() {
        if( beforeSendFunc && typeof beforeSendFunc == 'function' ) beforeSendFunc();
        //$("form[ name = "+formName+"]").find("button[type = submit]").addClass('disabled').html('<i class="fa fa-spin fa-spinner hide show inline" id="spin"></i>');
    }
    function complete() {
        if( completeFunc && typeof completeFunc == 'function' ) completeFunc();
        //$("form[ name = "+formName+"]").find("button[type = submit]").removeClass('disabled').html('Kaydet');
    }
    function onSubmit() {
        if( onsubmitFunction && typeof onsubmitFunction == 'function' ) return onsubmitFunction();
        return true;
    }
    new AjaxControl.AjaxFormSubmit().submitForm( formName, successCallback, onSubmit, null, beforeSend, complete );

}

function logout() {
    AjaxControlPostDataJson("/app/component/login.cfc?method=logout", new FormData(), function (response) {
        if(response.STATUS) location.href = location.origin;
    });
}

var cfmodalx = function(params){
    if(params.e == 'open'){
        $('#'+params.id).fadeIn();
        $('#unique_'+params.id+'_box').fadeIn();
    }else if(params.e == 'close'){
        $('#'+params.id).fadeOut();
        $('#unique_'+params.id+'_box').fadeOut();
    }
}