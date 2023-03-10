function navigate(adress){			
    $('body').append('<img src="/css/assets/template/contes/loading.gif" id="contesLoading" style="display:none; margin: auto; width: 100px; position: absolute; left: 0; right: 0; top: 42%; ">')
    $('#contesLoading').show( "fade" );
    $('#pageContainer').hide( "fade" );			
    $.ajax({
        async: true,
        url: '/index.cfm?fuseaction=content.contes&isAjax=1&page='+adress,
        type: 'POST',
        success: function(responseData)
        { 
            $('#pageContainer').empty();
            $('#pageContainer').html(responseData);					
            $('#pageContainer').show( "fade" );
            $('#contesLoading').hide( "fade" );
            $('#contesLoading').remove();
        }
    });
}

if(window.location.hash){
		var hash = window.location.hash;			
		var page = hash.replace("#", "");
		navigate(page);
	}else{
		navigate('home');
}

$(function() {

	window.onhashchange = function () { 
		var hash = window.location.hash;			
		var page = hash.replace("#", "");
		console.log(page);  
		navigate(page)    
    }

    $(document).mousemove(function(event){ 
        pageX = event.pageX;
        pageY = event.pageY; 
	}); // DEL Comfirm Positiom

    $( document ).on( "click", "[data-button]", function() {
        if($(this).attr('data-button')=='upd'){
            var record = $(this).closest('tr');
            $(record).addClass('selectedWarning');
            record.find('td').each (function() {
                if($(this).data('upd')){

                    var input =	$('<input>').attr({
                            id:$(this).data('upd'),
                            value:$(this).html(),
                            type:"text",
                            required:"true",
                    }).data('old',$(this).html());

                    $(this).empty();
                    $(this).append(input);
                }
                $(record).find('span[data-button="upd"]').attr("data-button","update").removeClass('font-yellow-crusta').addClass('font-green-haze').html('Kaydet');
                $(record).find('span[data-button="delete"]').attr("data-button","cancel").html('Vazge??');
            });
            console.log('UPDATE Button')
        }//UPDATE Button
        else if($(this).attr('data-button')=='cancel'){
            var record = $(this).closest('tr');
            $(record).removeClass('selectedWarning');
            record.find('td').each (function() {
                if($(this).data('upd')){
                    var cellValue = $(this).find('input').data('old');
                    $(this).empty();
                    $(this).append(cellValue);
                }
                $(record).find('span[data-button="update"]').attr("data-button","upd").removeClass('font-green-haze').addClass('font-yellow-crusta').html('G??ncelle');
                $(record).find('span[data-button="cancel"]').attr("data-button","delete").html('Sil');
            });
            console.log('Cancel')
        }//Update CANCEL Button
        else if($(this).attr('data-button')=='update'){
            var sendAction 	= $(this).closest('table').data('action')+'_'+$(this).attr('data-button');
            var sendData 	= '';
            var record 		= $(this).closest('tr');
            record.find('td').each (function() {
                if($(this).data('upd')){
                    var did		= $(this).find('input').attr('id');
                    var dval	= $(this).find('input').val();
                    sendData = sendData+did+'='+dval+'&';
                }		
            });
            sendData = sendData+'primary='+$(record).data('id');
            $.ajax({                
                url: 'V16/content/display/contes/cfc/components.cfc?method='+sendAction,
                type: "GET",
                data: sendData,
                success: function (returnData) {
                    if(returnData==1){
                        $(record).removeClass('selectedWarning');
                        alertObject({type: 'success',message: 'G??ncelleme yap??ld??', closeTime: 5000});
                        record.find('td').each (function() {
                            if($(this).data('upd')){
                                var cellValue = $(this).find('input').val();
                                $(this).empty();
                                $(this).append(cellValue);
                            }
                            $(record).find('span[data-button="update"]').attr("data-button","upd").removeClass('font-green-haze').addClass('font-yellow-crusta').html('G??ncelle');
                            $(record).find('span[data-button="cancel"]').attr("data-button","delete").html('Sil');
                        });

                    }
                },
                error: function () {
                    /**/
                }
            });
            console.log('update save');
        }// update-SAVE Button
        else if($(this).attr('data-button')=='add'){					
            var table = $(this).data('table');
            var row = $('#'+table).find('tbody').find('tr').html();

            var newRow = $('<tr>').addClass('selectedSuccess').append(row);
            
            newRow.find('td').each (function(index) {
                if(index<=0){$(this).html('#');}
                                    
                if($(this).data('upd')){						
                    var input =	$('<input>').attr({
                            id:$(this).data('upd'),
                            type:"text",
                            required:"true"
                    });
                    $(this).empty();
                    $(this).append(input);
                }
                $(newRow).find('span[data-button="upd"]').attr("data-button","add_new").removeClass('font-yellow-crusta').addClass('font-green-haze').html('Kaydet');
                $(newRow).find('span[data-button="delete"]').attr("data-button","quit").html('Vazge??');
            });//
        $('#'+table).find('tbody').append(newRow);
        }//yeni kay??t icin bos satir
        else if($(this).attr('data-button')=='add_new'){
            var sendAction 	= $(this).closest('table').data('action')+'_'+$(this).attr('data-button');
            var sendData 	= '';
            var record 		= $(this).closest('tr');
            record.find('td').each (function() {
                if($(this).data('upd')){
                    var did		= $(this).find('input').attr('id');
                    var dval	= $(this).find('input').val();
                    sendData = sendData+did+'='+dval+'&';
                }		
            });
            sendData = sendData+'primary='+$(record).data('id');
            $.ajax({                
                url: 'V16/content/display/contes/cfc/components.cfc?method='+sendAction,
                type: "GET",
                data: sendData,
                success: function (returnData) {
                    if(returnData>=1){
                        $(record).removeClass('selectedSuccess');
                        alertObject({type: 'success',message: 'Yeni kay??t yap??ld??...', closeTime: 5000});
                        record.find('td').each (function() {
                            $(record).attr("data-id",returnData);
                            if($(this).data('upd')){
                                var cellValue = $(this).find('input').val();
                                $(this).empty();
                                $(this).append(cellValue);
                            }
                            $(record).find('span[data-button="add_new"]').attr("data-button","upd").removeClass('font-green-haze').addClass('font-yellow-crusta').html('G??ncelle');
                            $(record).find('span[data-button="quit"]').attr("data-button","delete").html('Sil');
                        });
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Bo?? Veri ! L??tfen eksik alan b??rakmay??n??z...', closeTime: 5000});
                    }
                },
                error: function () {
                    /**/
                }
            });
            console.log("yeni kay??t");
        }//yeni kayit kaydetme
        else if($(this).attr('data-button')=='quit'){
            $(this).closest('tr').remove();
            console.log("Kay??t vazge??");
        }//yen kayit vazgec
        else if($(this).attr('data-button')=='delete'){				
            var record 		= $(this).closest('tr');
            $(record).addClass('selectedDanger');
            $(record).find('span[data-button="delete"]').after(
                '<div class="popover fade top" style="display: block;top:'+(pageY)+'px;left:'+(pageX)+'px;">'+
                    '<div class="arrow"></div>'+
                    '<div class="popover-title">kay??t silinsin mi?</div>'+
                    '<div class="popover-content text-center">'+
                    '<div class="btn-group">'+
                    '<a class="btn btn-small red-pink" data-button="yesDel">Evet</a>'+
                    '<a class="btn btn-small default" data-button="notDel">Hay??r</a>'+
                    '</div>'+
                    '</div>'+
                    '</div>'
                );		
                popover = $(record).find('.popover');
                var offset = $(record).find('.popover').offset();
                popover.css({'top':(offset.top-popover.height()-3)+'px','left':(offset.left-popover.width()/2) +'px'});
                popover.addClass('in');

                setTimeout(function(){
                    $(record).find('.popover').remove();
                    $(record).removeClass('selectedDanger');
                }, 5000);
                console.log("Kay??t sil comfirm");

        }//sil comfirm
        else if($(this).attr('data-button')=='yesDel'){
            var sendAction 	= $(this).closest('table').data('action')+'_delete';
            var sendData 	= '';
            var record 		= $(this).closest('tr');				
            sendData = 'primary='+$(record).data('id');
            console.log('sil');
            $.ajax({                
                url: 'V16/content/display/contes/cfc/components.cfc?method='+sendAction,
                type: "GET",
                data: sendData,
                success: function (returnData) {
                    console.log(returnData);
                    if(returnData==1){
                        alertObject({type: 'success',message: 'kay??t silindi..', closeTime: 5000});
                        $(record).remove();							
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Hata kay??t bulunamad??...', closeTime: 5000});
                    }
                },
                error: function () {						
                }
            });
        }//sil onayla
        else if($(this).attr('data-button')=='notDel'){
            var record 		= $(this).closest('tr');
            $(record).removeClass('selectedDanger');
            $(this).closest('.popover').remove();
            console.log('sil vazge??');
        }//sil red							
    });//data list data-button click

    /**POSTS ADD UPD DEL L??ST**/
    $( document ).off('click', '[data-button="updPost"]'); // duplicate function clear
    $( document ).on( 'click', '[data-button="updPost"]', function() { 
        var sendAction 	= $(this).closest('[data-action]').data('action');
        var sendData 	= '';
        var fields 		= $(this).closest('[data-action]');
        var invalid 	= false;
        var key 		= $(this).data('key');
        fields.find('[data-field]').each (function() {											
                var did		= $(this).data('field');
                if($(this).hasClass('autocomplete') && $(this).data('id')){
                    var dval = $(this).data('id');//oto complate lerde data-id al??n??r
                }else if($(this).attr('type') == 'checkbox'){
                    if($(this).prop('checked')){
                        var dval=1;//checkbox ise 1 al??n??r. 
                    }else{
                        var dval=0;//checkbox ise 1 al??n??r. 
                    }
                    console.log('field : '+did+' -> '+ dval);    
                }else{
                    var dval = $(this).val();
                }
                $('[data-field="'+did+'"]').removeClass('invalid');
                
                if($(this).data('rq') && !dval){
                    invalid = true; 
                    $('[data-field="'+did+'"]').addClass('invalid');
                    console.log(did);
                }								
                sendData = sendData+did+'='+encodeURIComponent(dval)+'&';					
        });
        console.log(invalid);
        if(invalid == false){
            sendData = sendData+'postBody='+encodeURIComponent(CKEDITOR.instances.POST_BODY.getData())+'&postId='+key;
            $.ajax({                
                url: 'V16/content/display/contes/cfc/components.cfc?method='+sendAction,
                type: "POST",
                data: sendData,				
                success: function (returnData) {
                    if(returnData>=1){
                        alertObject({type: 'success',message: '????erik G??ncellendi..', closeTime: 5000});					
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Daha sonra tekrar deneyiniz...', closeTime: 5000});
                    }
                },
                error: function () {
                
                }
            });
        }else{
            alertObject({type: 'danger',message: 'Bo?? Veri ! L??tfen zorunlu alanlar?? eksik b??rakmay??n??z...', closeTime: 5000});
        }
    });//Post UPD Button
    $( document ).off('click', '[data-button="newPost"]'); // duplicate function clear
    $( document ).on( 'click', '[data-button="newPost"]', function() { 
        var sendAction 	= $(this).closest('[data-action]').data('action');
        var sendData 	= '';
        var fields 		= $(this).closest('[data-action]');
        var invalid = false;
        fields.find('[data-field]').each (function() {											
                var did		= $(this).data('field');
                if($(this).hasClass('autocomplete') && $(this).data('id')){
                    var dval = $(this).data('id');//oto complate lerde data-id al??n??r
                }else if($(this).attr('type') == 'checkbox'){
                    if($(this).prop('checked')){
                        var dval=1;//checkbox ise 1 al??n??r. 
                    }else{
                        var dval=0;//checkbox ise 1 al??n??r. 
                    }
                    console.log('field : '+did+' -> '+ dval);    
                }else{
                    var dval = $(this).val();
                }
                $('[data-field="'+did+'"]').removeClass('invalid');
                
                if($(this).data('rq') && !dval){
                    invalid = true; 
                    $('[data-field="'+did+'"]').addClass('invalid');
                    console.log(did);
                }								
                sendData = sendData+did+'='+encodeURIComponent(dval)+'&';					
        });
        if(invalid == false){
            sendData = sendData+'postBody='+encodeURIComponent(CKEDITOR.instances.POST_BODY.getData());
            $(this).attr("disabled", true);
            $.ajax({                
                url: 'V16/content/display/contes/cfc/components.cfc?method='+sendAction,
                type: "POST",
                data: sendData,
                success: function (returnData) {
                    if(returnData>=1){
                        alertObject({type: 'success',message: '????erik Kaydedildi..', closeTime: 5000});
                        setTimeout(function(){
                            window.location.hash="#newpost&postId="+returnData;
                        }, 5000);
                    
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Daha sonra tekrar deneyiniz...', closeTime: 5000});
                    }
                },
                error: function () {
                
                }
            });
        }else{
            alertObject({type: 'danger',message: 'Bo?? Veri ! L??tfen zorunlu alanlar?? eksik b??rakmay??n??z...', closeTime: 5000});
        }
    });//.Post Add Button

    //global data
    searchData 	= '';
    $( document ).on( 'click', '[data-button="searchPost"]', function() { 
        searchData 	= '';// bo??alt
        var sendAction 	= $(this).closest('[data-action]').data('action');        
        var fields 		= $(this).closest('[data-action]');
        var invalid = false;// required control
        fields.find('[data-field]').each (function() {											
               var did		= $(this).data('field');
               if($(this).attr('type') == 'checkbox'){
                    if($(this).prop('checked')){
                        var dval=1;//checkbox ise 1 al??n??r. 
                    }else{
                        var dval=0;//checkbox ise 1 al??n??r. 
                    }
                    console.log('field : '+did+' -> '+ dval);    
                }else{
                    var dval = $(this).val();
                }
                $('[data-field="'+did+'"]').removeClass('invalid');
                
                if($(this).data('rq') && !dval){
                    invalid = true; 
                    $('[data-field="'+did+'"]').addClass('invalid');
                    console.log(did);
                }								
                searchData = searchData+did+'='+encodeURIComponent(dval)+'&';					
        });
        if($('#postSorter').prop('checked')){
            contesPostSortList();
            $('li[data-button="sortSave"]').show();
            $('#modalSearchPost').modal('close');
        }else if(invalid == false){
              $.ajax({		
                type: "GET",
                url: "/V16/content/display/contes/cfc/components.cfc?method=GET_POST_JSON&record_count=1",
                data: searchData,
                cache: false,
                success: function(data){		
                    $('#postsPaging').empty(); 			
                    $('#postsPaging').materializePagination({
                        align: 'center',
                        lastPage:  Math.ceil(data/25),
                        firstPage:  1,
                        useUrlParameter: false,
                        onClickCallback: function(requestedPage){			
                        },
                        CallBackContes: function(callBack){
                            if(callBack.status=="next" || callBack.status=="prev"){
                                    $('#postsPaging [data-page="'+callBack.current+'"]').trigger('click');
                            }				
                        },
                    }); 
                    $('#postsPaging [data-page="1"]').trigger('click');
                    $('#modalSearchPost').modal('close');
                    $('li[data-button="sortSave"]').hide();
                    $('#postRows').sortable( "destroy" );
                    if(data <=0){
                        $('#postRows').empty();
                        $('<tr>')
                            .append(
                                $('<td colspan="5">').append('Kay??t Bulunamad??...'),                              
                            ).appendTo('#postRows');
                    }
                }			
            });//sayfa numaralar??n?? yenide olu??tur.	  
        }else{
            alertObject({type: 'danger',message: 'Daha sonra tekrar deneyiniz...', closeTime: 5000});
        }
    });//.Search Button    

    var contesPaging = function(e,p){	
        if ( e.isImmediatePropagationStopped() ) {
            $('#postList').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');					
            if(e){
                var page = '&page='+p;
            }else{
                var page = '&page='+1;
            };
            $.ajax({		
                type: "GET",				
                url: "/V16/content/display/contes/cfc/components.cfc?method=GET_POST_JSON"+page,
                data: searchData,
                cache: false,
                success: function(data){
                    $('#postRows').empty();
                    var jData = JSON.parse(data); 
                    $.each( jData['DATA'], function( index ) {
                            $('<tr>')
                                .data('id',this[15])
                                .append(
                                    $('<td>').append(p*25+index-24),
                                    $('<td>').append(this[2]),
                                    $('<td>').append(this[10]),
                                    $('<td>').append(this[6]),
                                    $('<td>').append('<td><a href="#newpost&postId='+this[15]+'"><span class="contesTextBtn font-yellow-crusta">G??ncelle</span></a><span data-button="delete" class="contesTextBtn font-red-mint">Sil</span></td>')
                                ).appendTo('#postRows');							
                    });
                    $('#tableLoading').remove();                    
                }
            });
        }	
        
    };//Post Paging
    
    var contesPostSortFn= function(e){ 
        
        $("#postRows").sortable({
            connectWith		: 'postRows',
            items			: 'tr',
            cursor			: 'move',
            opacity			: '0.8',
            placeholder		: 'contesSortPlaceholder',
            revert			: 300,
            start: function(e, ui ){ui.placeholder.height(ui.helper.outerHeight());},
            stop: function(e, ui ) {
                $("#postRows").find('tr').each (function(index) {
                    $(this).find('td').first().html(index+1);
                });  
            }//stop
        });	

    };//Post PostSort

    var contesPostSortList= function(){
        $('#postsPaging').empty(); 	
        $('#postList').after('<img src="/css/assets/template/contes/loading.gif" id="tableLoading" style="width: 40px;margin: 25px auto;display: flex;align-items: center;">');	
       
        $.ajax({		
                type: "GET",				
                url: "/V16/content/display/contes/cfc/components.cfc?method=GET_POST_JSON",
                data: searchData,
                cache: false,
                success: function(data){
                    $('#postRows').empty();
                    var jData = JSON.parse(data); 
                    $.each( jData['DATA'], function( index ) {
                            $('<tr>')
                                .data('id',this[15])
                                .append(
                                    $('<td>').append(index+1),
                                    $('<td>').append(this[2]),
                                    $('<td>').append(this[10]),
                                    $('<td>').append(this[6]),
                                    $('<td>').append('<td><a href="#newpost&postId='+this[15]+'"><span class="contesTextBtn font-yellow-crusta">G??ncelle</span></a><span data-button="delete" class="contesTextBtn font-red-mint">Sil</span></td>')
                                ).appendTo('#postRows');							
                    });
                    $('#tableLoading').remove();
                    contesPostSortFn();
                }
            });

    };//Post contesPostSortList
    
    $( document ).on( 'click', '[data-button="sortSave"]', function() {
        sortList = "sortlist=";
        sortListorder = "&sortlistorder=";
        rcount = $("#postRows").find('tr').length;
        $("#postRows").find('tr').each (function(index) {
            if(index+1 < rcount){
                sortList = sortList + $(this).data('id') + ',';
                sortListorder = sortListorder + 'x' + $(this).data('id') + 'x,';
            }else{
                sortList = sortList + $(this).data('id');
                sortListorder = sortListorder + 'x' + $(this).data('id') + 'x';
            }
        });
        $.ajax({                
            url: 'V16/content/display/contes/cfc/components.cfc?method=post_sorter',
            type: "POST",
            data: sortList + sortListorder,
            success: function (returnData) {
                if(returnData>=1){
                    alertObject({type: 'success',message: 's??ralama kaydedildi', closeTime: 5000});                    
                
                }else if(returnData==0){
                    alertObject({type: 'danger',message: 'Daha sonra tekrar deneyiniz...', closeTime: 5000});
                }
            },
            error: function () {
            
            }
        });
        console.log(sortList);
    });//Post contesPostSort Save

    $( document ).on( 'click', '#postsPaging [data-page]', function(event) { 
        event.stopImmediatePropagation();	
        if($(this).data('page')!='prev' && $(this).data('page')!='next' ){	
            $('[data-page]').removeClass('active');
            $(this).addClass('active');
            contesPaging(event,$(this).data('page'));
        }
    });//page button
    
});//READY

