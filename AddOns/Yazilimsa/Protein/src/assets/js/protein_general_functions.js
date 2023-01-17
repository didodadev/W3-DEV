/* Protein Genel Fonksiyonlar  | (c) 2020 by Semih Akartuna */
/* 
    cfmodalx : moda aç kapat cf_box ile kullanılıyor sample : cfmodalx({e:'close',id:'protein_menu_option'});

    serializeObject: form datayı json formatına çevirir id:val
 */

var cfmodalx = function(params){
    if(params.e == 'open'){
        $('#'+params.id).fadeIn();
        $('#unique_'+params.id+'_box').fadeIn();
    }else if(params.e == 'close'){
        $('#'+params.id).fadeOut();
        $('#unique_'+params.id+'_box').fadeOut();
    }
}

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};