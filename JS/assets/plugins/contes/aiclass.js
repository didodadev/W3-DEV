function navigate(adress){			
    $('body').append('<img src="/css/assets/template/contes/loading.gif" id="contesLoading" style="display:none; margin: auto; width: 100px; position: absolute; left: 0; right: 0; top: 42%; ">')
    $('#contesLoading').show( "fade" );
    $('#pageContainer').hide( "fade" );			
    $.ajax({
        async: true,
        url: '/index.cfm?fuseaction=settings.aiclass&isAjax=1&page='+adress,
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
	});
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
                $(record).find('span[data-button="delete"]').attr("data-button","cancel").html('Vazgeç');
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
                $(record).find('span[data-button="update"]').attr("data-button","upd").removeClass('font-green-haze').addClass('font-yellow-crusta').html('Güncelle');
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
                url: 'V16/settings/cfc/aiclass.cfc?method='+sendAction,
                type: "GET",
                data: sendData,
                success: function (returnData) {
                    if(returnData==1){
                        $(record).removeClass('selectedWarning');
                        alertObject({type: 'success',message: 'Güncelleme yapıldı', closeTime: 5000});
                        record.find('td').each (function() {
                            if($(this).data('upd')){
                                var cellValue = $(this).find('input').val();
                                $(this).empty();
                                $(this).append(cellValue);
                            }
                            $(record).find('span[data-button="update"]').attr("data-button","upd").removeClass('font-green-haze').addClass('font-yellow-crusta').html('Güncelle');
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
                $(newRow).find('span[data-button="delete"]').attr("data-button","quit").html('Vazgeç');
               
            });//
        $('#'+table).find('tbody').append(newRow);
        }//yeni kayıt icin bos satir
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
                url: 'V16/settings/cfc/aiclass.cfc?method='+sendAction,
                type: "GET",
                data: sendData,
                success: function (returnData) {
                    console.log(returnData + '---' + returnData.replace(/"/gi,''));
                    if(returnData.replace(/"/gi,'')>=1){
                        sendData = sendData.replace("undefined",returnData.replace(/"/gi,''));
                        $(record).data('id',sendData);
                        $(record).removeClass('selectedSuccess');
                        $(record).find("[data-key]").text(returnData.replace(/"/gi,''));
                        alertObject({type: 'success',message: 'Yeni kayıt yapıldı...', closeTime: 5000});
                        record.find('td').each (function() {
                            $(record).attr("data-id",returnData);
                            if($(this).data('upd')){
                                var cellValue = $(this).find('input').val();
                                $(this).empty();
                                $(this).append(cellValue);
                            }
                            $(record).find('span[data-button="add_new"]').attr("data-button","upd").removeClass('font-green-haze').addClass('font-yellow-crusta').html('Güncelle');
                            $(record).find('span[data-button="quit"]').attr("data-button","delete").html('Sil');
                        });
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Boş Veri ! Lütfen eksik alan bırakmayınız...', closeTime: 5000});
                    }
                },
                error: function () {
                    /**/
                }
            });
            console.log("yeni kayıt");
        }//yeni kayit kaydetme
        else if($(this).attr('data-button')=='quit'){
            $(this).closest('tr').remove();
            console.log("Kayıt vazgeç");
        }//yen kayit vazgec
        else if($(this).attr('data-button')=='delete'){				
            var record 		= $(this).closest('tr');
            $(record).addClass('selectedDanger');
            $(record).find('span[data-button="delete"]').after(
                '<div class="popover fade top" style="display: block;top:'+(pageY)+'px;left:'+(pageX)+'px;">'+
                    '<div class="arrow"></div>'+
                    '<div class="popover-title">kayıt silinsin mi?</div>'+
                    '<div class="popover-content text-center">'+
                    '<div class="btn-group">'+
                    '<a class="btn btn-small red-pink" data-button="yesDel">Evet</a>'+
                    '<a class="btn btn-small default" data-button="notDel">Hayır</a>'+
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
                console.log("Kayıt sil comfirm");

        }//sil comfirm
        else if($(this).attr('data-button')=='yesDel'){
            var sendAction 	= $(this).closest('table').data('action')+'_delete';
            var sendData 	= '';
            var record 		= $(this).closest('tr');				
            sendData = 'primary='+$(record).data('id');
            console.log('sil');
            $.ajax({                
                url: 'V16/settings/cfc/aiclass.cfc?method='+sendAction,
                type: "GET",
                data: sendData,
                success: function (returnData) {
                    console.log(returnData);
                    if(returnData==1){
                        alertObject({type: 'success',message: 'kayıt silindi..', closeTime: 5000});
                        $(record).remove();							
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Hata kayıt bulunamadı...', closeTime: 5000});
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
            console.log('sil vazgeç');
        }//sil red							
    });//data list data-button click

    /**POSTS ADD UPD DEL LİST**/

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
                    var dval = $(this).data('id');//oto complate lerde data-id alınır
                }else if($(this).attr('type') == 'checkbox'){
                    if($(this).prop('checked')){
                        var dval=1;//checkbox ise 1 alınır. 
                    }else{
                        var dval=0;//checkbox ise 1 alınır. 
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
                        alertObject({type: 'success',message: 'İçerik Güncellendi..', closeTime: 5000});					
                    }else if(returnData==0){
                        alertObject({type: 'danger',message: 'Daha sonra tekrar deneyiniz...', closeTime: 5000});
                    }
                },
                error: function () {
                
                }
            });
        }else{
            alertObject({type: 'danger',message: 'Boş Veri ! Lütfen zorunlu alanları eksik bırakmayınız...', closeTime: 5000});
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
                    var dval = $(this).data('id');//oto complate lerde data-id alınır
                }else if($(this).attr('type') == 'checkbox'){
                    if($(this).prop('checked')){
                        var dval=1;//checkbox ise 1 alınır. 
                    }else{
                        var dval=0;//checkbox ise 1 alınır. 
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
                        alertObject({type: 'success',message: 'İçerik Kaydedildi..', closeTime: 5000});
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
            alertObject({type: 'danger',message: 'Boş Veri ! Lütfen zorunlu alanları eksik bırakmayınız...', closeTime: 5000});
        }
    });//.Post Add Button

    //global data
    searchData 	= '';
    $( document ).on( 'click', '[data-button="searchPost"]', function() { 
        searchData 	= '';// boşalt
        var sendAction 	= $(this).closest('[data-action]').data('action');        
        var fields 		= $(this).closest('[data-action]');
        var invalid = false;// required control
        fields.find('[data-field]').each (function() {											
               var did		= $(this).data('field');
               if($(this).attr('type') == 'checkbox'){
                    if($(this).prop('checked')){
                        var dval=1;//checkbox ise 1 alınır. 
                    }else{
                        var dval=0;//checkbox ise 1 alınır. 
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
                                $('<td colspan="5">').append('Kayıt Bulunamadı...'),                              
                            ).appendTo('#postRows');
                    }
                }			
            });//sayfa numaralarını yenide oluştur.	  
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
                                    $('<td>').append('<td><a href="#newpost&postId='+this[15]+'"><span class="contesTextBtn font-yellow-crusta">Güncelle</span></a><span data-button="delete" class="contesTextBtn font-red-mint">Sil</span></td>')
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
                                    $('<td>').append('<td><a href="#newpost&postId='+this[15]+'"><span class="contesTextBtn font-yellow-crusta">Güncelle</span></a><span data-button="delete" class="contesTextBtn font-red-mint">Sil</span></td>')
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
                    alertObject({type: 'success',message: 'sıralama kaydedildi', closeTime: 5000});                    
                
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

