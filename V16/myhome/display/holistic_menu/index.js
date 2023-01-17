! function(i) {
    i.fn.extend({
        resimatt: function() {
            i(this).each(function() {
                var n = i(this).attr("src"),
                    e = i(this).attr("class"),
                    t = i(this).attr("alt");
                (e = "undefined") && (e = "image"), i(this).before('<div class="resim-att"><div class="resim-att-pre"><div class="resim-thumb"><div class="resim-centered"><img src="' + n + '" alt="' + t + '" class="' + e + '-att" /></div></div></div></div>'), i(this).remove()
            })
        }
    })
}($)

$(function(){
    
    //Function
    $(".resimatt").resimatt();

    //ThinkFlow Height
    var list_box_h = $('.box_card_item').height() - $('.all_btn').height();
    $('.thinkflow').height(list_box_h);
    $('#thinkflow_items').innerHeight($('#thinkflow').innerHeight() - $('#thinkflow_title').innerHeight());

    //Show - Hide
    $('.all_show').bind('click', function(){
        var elem = $(this);
        var parent = $(this).parent().parent().find('.box_hide_icon');
        if(parent.hasClass('open')){
            elem.find('span').text("Tümünü Göster");  
            parent.removeClass('open');
        }
        else{
            elem.find('span').text("Gizle");
            parent.addClass('open');
        }
    })

    /*Random bg-color(ThinkFlow)
    var thinkItems = $('.thinkflow .thinkflow_items');
    thinkItems.each(function(){
        var numberList = [];
        var randomNumber;
        for(var i = 0; numberList.length<3; i++){
            randomNumber = Math.floor(Math.random() * 255) + 1;
            if(numberList.indexOf(randomNumber) == -1){
                numberList.push(randomNumber);
            }
            else{
                i--;
            }
        }
        var convert = 'rgb('+numberList[0]+','+numberList[1]+','+numberList[2]+')';
        $(this).find('.name').css("background-color", convert);
    })*/


})