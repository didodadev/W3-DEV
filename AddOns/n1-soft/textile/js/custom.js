var SampleRequestControl=function(formId){
	alert('test');
	data = $("#"+formId).serialize();
		$.ajax({ url :'AddOns/N1-Soft/textile/cfc/product.cfc?method=addProduct', data : {data : data}, async:false,success : function(res){ 
			data = $.parseJSON( res );
			console.log(data);
				if ( data['DATA'].length ) { 
						window.location.href = 'welcome';
					} 
				else
					{ 
						alert('Hatalı giriş');
					}
				} 
			});
}


var loginControl = function(formId){
		data = $("#"+formId).serialize();
		$.ajax({ url :'cfc/ajax.cfc?method=checkLogin', data : {data : data}, async:false,success : function(res){ 
			data = $.parseJSON( res );
			console.log(data);
				if ( data['DATA'].length ) { 
						window.location.href = 'welcome';
					} 
				else
					{ 
						alert('Hatalı giriş');
					}
				} 
			});
	}
	
var logOut = function(){$.ajax({ url :'cfc/ajax.cfc?method=logOut', async:false,success : function(res){ window.location.href = 'welcome';} });}

var searchDetailContentButton = function(e){$(e).closest(".searchInput").next('.searchDetailContent').toggle(200);};

var goTo = function(pageFriendlyUrl,divClass){
	if(pageFriendlyUrl.indexOf('?') != -1)
		str = '&AjaxPage=1';	
	else
		str = '?AjaxPage=1';
	$('.'+divClass).empty();
	$('.'+divClass).html('Yükleniyor..');
	$.ajax({
		url: pageFriendlyUrl+str,
		success: function(Returning) {
		$('.'+divClass).empty();
		$('.'+divClass).html(Returning);
		},
		error: function(jqXHR, textStatus, errorThrown) {
			//error message
		}//error
	});//ajax
	return false;

};//

var fillSelectbox = function(e,method,target,selectedVal){
	standartOption = $("#"+target + ' option:first');
	$("#"+target + ' option').remove();
	standartOption.appendTo($("#"+target));
	if($(e).val())
	{
		$.ajax({
			url: 'cfc/components.cfc?method='+method+'&data='+$(e).val(),
			success: function(Returning) {
				if(Returning.length)
				{
					returnData = $.parseJSON(Returning);
					for(i=0;i<returnData['DATA'].length;i++)
					{
						$("<option>").val(returnData['DATA'][i][0]).text(returnData['DATA'][i][1]).appendTo($("#"+target));
					}
				}
			},
			error: function(jqXHR, textStatus, errorThrown) {
				//error message
			}//error
		});//ajax
	}
	if($("#"+target).attr('onchange'))
		$("#"+target).trigger( "onchange" );
	return false;
	};
	
var saveCallCenter = function(serviceId,user,timeZone){
	$.ajax({
		url: 'cfc/components.cfc?method=INSERTCALLCENTERPLUS&service_id='+serviceId+'&plus_content='+$("#plus_content").val(),
		success: function(Returning) {
			if(Returning.length)
			{
				returnData = $.parseJSON(Returning);
				console.log(returnData);
				
				var date = new Date();
				var day = date.getDate();
				var month = date.getMonth()+1;
				var year = date.getFullYear();
				var hour = date.getHours();
				var minute = date.getMinutes();
				
				$("<li>").attr('class','out').append(
														$("<img>").attr({'class':'avatar','src':'images/noProfile.png'})
													)
													.append
													(
														$("<div>").attr({'class':'message'}).append(
																										$("<span>").attr({'class':'body bold'}).text('<pre>'+returnData['DATA'][0][6]+'</pre>'),
																										$("<a>").attr({'class':'name','href':'javascript://'}).text(user),
																										$("<span>").attr({'class':'datetime'}).text(' '+day+'/'+month+'/'+year+' '+hour+':'+minute)
																									)
													).appendTo($("ul.chats"))
			}
			$("#plus_content").val('');
		},
		error: function(jqXHR, textStatus, errorThrown) {
			return false;
			//error message
		}//error
	});//ajax
	return false;
	};
	
	
$( function() {
    $.datepicker.regional['tr'] = {
        monthNames: ['Ocak', 'Şubat', 'Mart', 'Nisal', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylüş', 'Ekim', 'Kasım', 'Aralık'],
        monthNamesShort: ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylüş', 'Ekim', 'Kasım', 'Aralık'],
        dayNames: ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'],
        dayNamesShort: ['Pz', 'Pzt', 'Sl', 'Cr', 'Pr', 'Cm', 'Cmt'],
        dayNamesMin: ['Pz', 'Pzt', 'Sl', 'Cr', 'Pr', 'Cm', 'Cmt'],
		prevText: "geri",
		nextText: "ileri",
		currentText: "Bugün"
    }

    $.datepicker.setDefaults($.datepicker.regional['tr']);
    $( ".datepicker" ).datepicker({
		changeMonth: true,
		changeYear: true,
		dateFormat : 'dd/mm/yy'
	});
	try{
		Dropzone.autoDiscover = false;
	
		myDropzone = new Dropzone('#file-dropzone', {     
			url: "cfc/components.cfc?method=GET_FILE_UPLOAD",
			method:"post",  
			paramName: "dosya", 
			maxFilesize: 3.0, 
			parallelUploads: 10000,
			uploadMultiple: true,
			autoProcessQueue: false,
			addRemoveLinks: true,
			editFileName: true,
			dictDefaultMessage : 'dosyayı sürükle veya tıkla seç',
			dictRemoveFile:'Sil',
			dictFileTooBig : "büyük dosya boyutu ({{filesize}}MB). Max yükleme boyutu: {{maxFilesize}}MB.",
			init: function() {
				this.on("addedfile", function(file){
					$(uploadBadge).find('span.badge').html(this.files.length);
				 });
				this.on("removedfile", function(file){
					$(uploadBadge).find('span.badge').html(this.files.length);
				 });
			},
			success: function(file,r){
				returningValue = r;     
		   }
		
		});
	}
	catch(err){}
	
    $('#remove-all').on('click', function () {
        myDropzone.removeAllFiles();
		$(uploadBadge).find('span.badge').html(myDropzone.files.length);
    });
	
  });
  
var callPage = function(page,formName){
		$("form[name="+formName+"] input[name=page]").val(page);
		$("form[name="+formName+"]").submit();
	};
	
var controlPaging = function(obj){
	$(obj).closest('form').find('input[name=page]').val(1);
}

var fileUploadModal = function(obj){
	uploadBadge = obj;
	actionId = $(obj).parent('div').parent('div').find('input.noteId').val();
	actionSection = 'note';
	$("#fileUpload").modal('show');
};

var list_getat = function(gelen_,number,delim_)
{
	var gelen_ = gelen_.toString();
	if(!delim_) delim_ = ',';	
	gelen_1=gelen_.split(delim_);

	if((gelen_.length == 0) || (number > gelen_1.length) || (number < 1))
		return '';
	else
		return gelen_1[number-1];
}

var goLocation = function(loc){
	window.location = loc;	
}

function wrkChart(chartName,chartType,chartLabel,chartData)
{
	var chartDatas =[];
	
	function hexToRgb(hex) {
	var bigint = parseInt(hex.slice(1), 16);
	var r = (bigint >> 16) & 255;
	var g = (bigint >> 8) & 255;
	var b = bigint & 255;	
	return [r,g,b];
	}	
			
	if(chartType.toLowerCase() == 'line' || chartType.toLowerCase() == 'bar' || chartType.toLowerCase() == 'hbar' || chartType.toLowerCase() == 'radar'){			

			for ( var i = 0, l = chartData.length; i < l; i++ ) {	
				var newArray=  chartData[i]
				var newData =  newArray[0]	
				if(newArray[1]){
					var newColor = hexToRgb(newArray[1]);						
				}else{
					var newColor = [Math.floor((Math.random()*255) + 1),Math.floor((Math.random()*255) + 1),Math.floor((Math.random()*255) + 1)];							
				}   
				if(chartType.toLowerCase() == 'bar' || chartType.toLowerCase() == 'hbar' || chartType.toLowerCase() == 'radar')
				{
					var fillclr='rgba(' + newColor[0] + ',' + newColor[1] + ',' + newColor[2] + ',' + '0.3)'
					}
				else{
					var fillclr='rgba(' + newColor[0] + ',' + newColor[1] + ',' + newColor[2] + ',' + '0)'
					}
				datas = {						
					label: chartName,
					fillColor : fillclr,
					strokeColor : 'rgba(' + newColor[0] + ',' + newColor[1] + ',' + newColor[2] + ',' + '0.70)',
					pointColor : 'rgba(' + newColor[0] + ',' + newColor[1] + ',' + newColor[2] + ',' + '1)',
					pointStrokeColor : "##fff",
					pointHighlightFill : 'rgba(' + newColor[0] + ',' + newColor[1] + ',' + newColor[2] + ',' + '0.75)',
					pointHighlightStroke : 'rgba(' + newColor[0] + ',' + newColor[1] + ',' + newColor[2] + ',' + '0.55)',
					data : newData.split(',').slice(0),
					}
				chartDatas.push(datas);		   
				}
			
			
			graphData = {
				labels : chartLabel.split(',').slice(0),
				datasets : chartDatas	
			}
			var Graf = document.getElementById(chartName).getContext("2d");
			if(chartType.toLowerCase() == 'line')
			{
				window.myLine = new Chart(Graf).Line(graphData, {
					responsive: true,
				});
			}
			else if(chartType.toLowerCase() == 'hbar')			{
				
				window.myLine = new Chart(Graf).HorizontalBar(graphData, {					
					responsive: true
				});
			}	
			else if(chartType.toLowerCase() == 'bar')
			{
				window.myLine = new Chart(Graf).Bar(graphData, {					
					responsive: true
				});
			}
			
			else if(chartType.toLowerCase() == 'radar')
			{
				window.myLine = new Chart(Graf).Radar(graphData, {
					responsive: true
				});
			}
				
		}//if line bar radar
		else if(chartType.toLowerCase() == 'pie' || chartType.toLowerCase() == 'donut'  || chartType.toLowerCase() == 'polar')
		{
			var pieData = [];
			for ( var i = 0, l = chartData.length; i < l; i++ ) {	
				var newArray=  chartData[i]
				var newData =  newArray[0]	
				if(newArray[1]){
					var renk=newArray[1];					
				}else{
					var renk = ('rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)') ;				
				}
				var newColor = hexToRgb(newArray[1]);
				var newLabel = newArray[2];   
				datas = {
					color : renk,					
					value : newData,
					label: newLabel,
					
					highlight: "rgba(213, 213, 214, 0.52)"
					
					}
				pieData.push(datas);		   
				}
			if(chartType.toLowerCase() == 'pie'){
				var ctx = document.getElementById(chartName).getContext("2d");
				window.myPie = new Chart(ctx).Pie(pieData,{	
				animationSteps : 60,					
				legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend legend-list\"><% for (var i=0; i<segments.length; i++){%><li class=\"chartLegend\"><div style=\"height: 16px;width: 16px;float: left;border-radius: 13px;margin-right: 4px;background-color:<%=segments[i].fillColor%>\"></div><%if(segments[i].label){%><%=segments[i].label%><%}%>:&nbsp; <span><%=segments[i].value%></span></li><%}%></ul>"
				});
				document.querySelector("#"+chartName+"+ #legend").innerHTML = myPie.generateLegend();			
				}
			else if(chartType.toLowerCase() == 'donut'){
				var ctx = document.getElementById(chartName).getContext("2d");
				window.myPie = new Chart(ctx).Doughnut(pieData,{	
				animationSteps : 60,					
				legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend legend-list\"><% for (var i=0; i<segments.length; i++){%><li class=\"chartLegend\"><div style=\"height: 16px;width: 16px;float: left;border-radius: 13px;margin-right: 4px;background-color:<%=segments[i].fillColor%>\"></div><%if(segments[i].label){%><%=segments[i].label%><%}%>:&nbsp; <span><%=segments[i].value%></span></li><%}%></ul>"
				});
				document.querySelector("#"+chartName+"+ #legend").innerHTML = myPie.generateLegend();
				}
			else if(chartType.toLowerCase() == 'polar'){
				var ctx = document.getElementById(chartName).getContext("2d");
				window.myPie = new Chart(ctx).PolarArea(pieData,{						
				animationSteps : 60,					
				legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend legend-list\"><% for (var i=0; i<segments.length; i++){%><li class=\"chartLegend\"><div style=\"height: 16px;width: 16px;float: left;border-radius: 13px;margin-right: 4px;background-color:<%=segments[i].fillColor%>\"></div><%if(segments[i].label){%><%=segments[i].label%><%}%>:&nbsp;<span><%=segments[i].value%></span></li><%}%></ul>"
				});
				document.querySelector("#"+chartName+"+ #legend").innerHTML = myPie.generateLegend();
				}	
				
		}

}//wrkChart SA

var goToModal = function(pageUrl,head){	
	
    var url     = pageUrl; 
            
    var modalId	= 'modal' + Math.floor((Math.random() * 125) + 4)*Math.floor((Math.random() * 125) + 4) ;   
    
    $('<div>')		
        .addClass('modal fade')
        .attr('id',modalId)
        .append(
            $('<div>')
                .addClass('modal-dialog modal-lg')
                .append(
                    $('<div>')
                        .addClass('modal-content')
                        .append(
                            $('<div>')
                                .addClass('modal-header')
                                .append('<button type="button" class="close" data-dismiss="modal" ><span>&times;</span></button><span class="fa fa-print pull-right m-t-3 m-r-10 btnPointer" onclick="$(\'.printable\').printThis({importCss:true,importStyle:true});"></span><h4 class="modal-title" id="myModalLabel">'+head+'</h4>'),									
                            $('<div>')
                                .addClass('modal-body')
                                .attr('id','body-' + modalId)
                                )//modal-content append
                        )//modal-dialog append
                ).appendTo('body');
                
                $.ajax({
                    url: url,
                    success: function(page) {
                        $('#body-' + modalId).append(page);
                    }
                });//ajax
                
                $('#'+modalId ).modal('show')
                $('#'+modalId ).on('hidden.bs.modal', function (e) {
                    $('#'+modalId ).remove();
                })
	};