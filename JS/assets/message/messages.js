/*
    İlker Altındal 04092019
    Dsp_message.cfm içerisinde kullanılıyor, chat ile ilgili fonksiyonlar burada tutulur.

*/
$(function(){
    $("#all_messages div.bubble").each(function(){
        var message = $(this).find("span").text();
        $(this).find("span").html(convert(message));
    });

    $(window).resize(function(){
        var RightPanelHeight = $("#get_all_right_message").height();
        if($(this).width() >= 769) $(".person-list").show();    
        //$(".person-list").height(RightPanelHeight);
    });

    $(".send_btn").attr('disabled',true);
   
    $("#mainborder").delegate("#mbl_online_users","click",function(){      
        var RightPanelHeight = $("#get_all_right_message").height();     
        $(".person-list").show().css({"z-index" : "22"}); //show();
       // $(".person-list").height(RightPanelHeight);
    });

    $("#CloseConnect").click(function(){
        var RightPanelHeight = $("#get_all_right_message").height();
        $(".person-list").css("z-index","-1");    
      //  $(".person-list").height(RightPanelHeight);
    });
});

function ScrollBottom(){
    scrollHeight = document.getElementById('message-body').scrollHeight;
       $('#message-body').animate({
        scrollTop: $('#message-body').height() + scrollHeight
      }, 200);
}
function removeAllMessage(sender_id, receiver_id){
    
    $.ajax({
        type : 'POST',
        url : 'V16/objects/cfc/messages.cfc?method=DEL_MESSAGES',
        data : 'sender_id='+sender_id+'&receiver_id='+receiver_id,
        beforeSend : function(){
            $('.all_messages').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" class="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');
        },
        success: function(result){
            $("#all_messages").html("");
        },
        complete : function(){
            $('.tableLoading').remove(); 
        }
    });

}
function goBottom(id){
    var element = document.getElementById(id);
    element.scrollTop = element.scrollHeight - element.clientHeight;
}
function countm(id){
    var Msg = parseInt($("span#countm_badge"+id).text());
    var HeadMsg = parseInt($("span#pm_badge").text());
    $("pm_badge").text(HeadMsg - Msg);
    $("span#countm_badge"+id).hide();
}
$("#message_area").on("keyup keydown","#text_area",function(event){ //Textarea Kutucugunda Eventleri Yakalayıp Mesajı Gönderiyoruz
    var x = document.getElementById("text_area");
    var b = $.trim(x.value);
    if(b == ""){
       $(".send_btn").attr('disabled',true); 
       $(".send_btn").css('background-color','#b3d0a6'); 
    }
    else{
        $("#text_area").keypress(function (e) {
            if(e.which == 13 && !e.shiftKey) {        
                sendMessage();
                e.preventDefault();
                return false;
            }
        });
       $(".send_btn").attr('disabled',false);
       $(".send_btn").css('background-color','#89ba73'); 
    }
});