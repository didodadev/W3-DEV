function auto_grow(element) {
    element.style.height = "auto";
    element.style.height = (element.scrollHeight)+"px";
}

function goBottom(id)
{
    var element = document.getElementById(id);
    element.scrollTop = element.scrollHeight - element.clientHeight;
}

function convert(message)
{
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    var text1=message.replace(exp, "<a style='color:blue;' target='_blank' href='$1'>$1</a>");
    var exp2 =/(^|[^\/])(www\.[\S]+(\b|$))/gim;
    return text1.replace(exp2, '$1<a style="color:blue;" href="http://$2" target="_blank">$2</a>');
}

function sendButtonManagement(){

    var messageText = $.trim($("#text_area").val())

    if( messageText != "" || window.messageFiles.length > 0 ){

        $(".send_btn").attr('disabled',false);
        $(".send_btn").css('background-color','#89ba73');
        
        if( messageText != "" ){
            $("#text_area").keypress(function (e) {
                
                if(e.which == 13 && !e.shiftKey) {     
                    sender( '' );
                    e.preventDefault();
                    return false;
                }
            });
        } 

        if( window.messageFiles.length > 0 ) $("#messages-body").css({ "height" : "calc(100% - (110px))" });
        else $("#messages-body").css({ "height" : "calc(100% - (60px))" });

    }else{
        
        $(".send_btn").attr('disabled',true); 
        $(".send_btn").css('background-color','#b3d0a6');

    }

}

function sender( messageText = "" ) {
    sendMessage( messageText, document.getElementById('enc_key').value );
}

$(function(){
    setTimeout(() => { goBottom('all_messages'); }, 1);
});