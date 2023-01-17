<cfparam name="attributes.wrk_tbody" default="0">
<cfparam name="attributes.height" default="">
<cfset degerim_ = thisTag.GeneratedContent>

<cfparam name="attributes.sort" default="1">
<!--- Google API --->
<cfset getComponent = createObject('component','WEX.google.cfc.google_api')>
<cfset get_google_key = getComponent.get_api_key()>

<cfoutput>
	<cfif thisTag.executionMode eq "start">
		<cfparam name="attributes.id" default="basket_#round(rand()*10000000)#">
		<cfset listContentid = "catalystBigList_#RandRange(1, 999, "SHA1PRNG")#">
        <script src="/JS/temp/fixed_table_thead.js"></script>
		<!---
        <!---Tablolardaki sutunlarin sirlanmasi icin kullanılan script--->
        <script type="text/javascript" src="/JS/temp/tablesorter/jquery.tablesorter.js"></script>
        <!--- Tablolardaki sutunlarin yerdegisikligi icin kullanilan script--->
        <script type="text/javascript" src="/JS/temp/tablesorter/jquery.columnmanager.js"></script>    
        <script type="text/javascript" src="/JS/temp/tablesorter/draggable.js"></script>
		--->
        <cfif isdefined("caller.collapsed")><!--- bu ifade big_list_search custom tag'inde ataniyor. Bu ozellikten sayfada big_list_search alaninin oldugu anlasiliyor. Boylece yazdirma,excele alma sorunsuz calisiyor...--->
			<!-- sil -->
			<style>
				.ui-pagination{
    			flex-basis: 100%;
    			margin:5px!important;
    			background-color: ##fff;
    			padding: 10px;
				border-radius: 4px;
				}
			</style>
		
		</cfif>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
			<div class="boxRow">
				<div id="unique_box_1" class="portBox portBottom" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08)">
					<cfif not isdefined("caller.is_excel")>
						<div class="portHeadLight">
							<div class="portHeadLightTitle">
								<cfif not isdefined("attributes.title")>
								<span><a href="javascript://"><cf_get_lang dictionary_id='57684.Sonuç'></a></span>
								<cfelse>
									<span><a href="javascript://">#attributes.title#</a></span>
								</cfif>
							</div>
							<div class="portHeadLightMenu">
								<!--- <div class="listIcon" id="listIcon"></div> --->
								<!-- sil -->
								<ul>
									<cfif len(attributes.id) and len(get_google_key.GOOGLE_API_KEY)>
										<li>
											<a class="" href="javascript://" onclick="getVoice();" id="play_func"><i class="icn-md catalyst-volume-1" id="play" title="<cf_get_lang dictionary_id='62757.Sesli Oku'>"></i> </i></a>
											<a class="" href="javascript://" onclick="stopVoice();" id="stop_func"><i class="icn-md catalyst-volume-2" id="pause" style="display:none" title="<cf_get_lang dictionary_id='62758.Durdur'>"></i> </i></a>
											<audio controls="" src="data:audio/ogg;base64," style="display:none" id="audio_control"  onended="$('##pause').hide(); $('##play').show()">
											</audio>
										</li> 	
									</cfif>
									<li id="lis">
										<a href="javascript://"><i class="catalyst-share-alt"></i></a>
										<ul>
											<li>               		
												<a href="javascript://" onclick="return (PROCTest(this,1));"><i class="fa fa-file-excel-o fa-2x"></i><cf_get_lang_main no='1940.Excel Üret'></a>
											</li>
											<li>                   
												<a href="javascript://" onclick="return (PROCTest(this,2));"><i class="fa fa-file-word-o fa-2x"></i><cf_get_lang_main no='1941.Word Üret'></a>
											</li>
											<li>                   
												<a href="javascript://"  onclick="return (PROCTest(this,3));"><i class="fa fa-file-pdf-o fa-2x"></i><cf_get_lang_main no='1942.PDF Üret'></a>
											</li>           
											<li> 
												<a href="javascript://" onclick="return (PROCTest(this,4));"><i class="fa fa-envelope-o fa-2x"></i><cf_get_lang_main no='63.Mail Gönder'></a>       
											</li>
											<li>
												<a href="javascript://"onclick="printSa();"><i class="fa fa-print fa-2x "></i><cf_get_lang_main no='1943.Yazıcıya Gönder'></a>
											</li>
										</ul>
									</li>
									<li>
										<a class="table_column_list" href="javascript://"><i class="catalyst-eye"></i></a>
										<ul class="design2" id="table_list_container"></ul>
									</li> 
									
									<li><a title="#caller.getLang('bank',308)#/#caller.getLang('main',141)#" href="javascript://" onclick="javascript:show_hide('unique_box_2')"><i class="catalyst-arrow-down"></i></a></li>
									<li><a href="javascript://" title="Resize" onclick="fs({id:'unique_box_1'});"><i class="icons8-resize-diagonal"></i></a></li>
								</ul>
								<!-- sil -->	
							</div>
						</div>
					</cfif>
					<div class="portBoxBodyStandart scrollContent">
						<div style="width:100%" id="unique_box_2">
							<!--- <div class="list_settings" align="right"></div> ---><!--- listede bulunan th alanına bağlı tüm satırı gizleyip göstermeye yarar. Herhangi bir parametre taşımaz. Geliştirim için aşağıdaki jquery alanı kullanılmalıdır. OSİ 20130515--->
							<a href="javascript://" id="opener">&nbsp;</a>
							<div id="show_hide_holder" style="display:none;" align="left"></div>
							<div class="fsButton" onclick="fs({id:'#listContentid#'});"><span class="catalyst-size-fullscreen bold"></span></div>
							<div class="ui-scroll">
								<div class="ReportContent" id="#listContentid#">		
									<cfif caller.attributes.fuseaction contains 'autoexcel'>
										<table bigList class="ui-table-list ui-form" id="#attributes.id#" align="center">	
									<cfelse>
										<table bigList class="ui-table-list ui-form" id="#attributes.id#" align="center"  <cfif len(attributes.sort) and attributes.sort eq 1>sort="true"</cfif>>		
									</cfif>
    <cfelse>
									<cfif attributes.wrk_tbody neq 1>
										</table>
									</cfif>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<cfif isdefined("caller.collapsed")>
			<!-- sil -->
		</cfif>
	<script type="text/javascript">
		function stopVoice()
		{
			document.getElementById("audio_control").pause(); 
			$("##play").css("display","");
			$("##pause").css("display","none");
			
		}
		function playVoice()
		{
			document.getElementById("audio_control").play(); 
			$("##play").css("display","none");
			$("##pause").css("display","");
		}
		
		//wex
		/* TODO: Şirket akış parametrelerine google api key eklenecek. */
		function getVoice()
		{
			get_all_text = "";
			id_control = "<cfoutput>#attributes.id#</cfoutput>";
			box_id = String.fromCharCode(35)+"<cfoutput>#attributes.id#</cfoutput>"
			if(id_control != "")
			{
				$(box_id+' tr').each(function() {
					var $tds = $(this).find('td');
					if($tds.length != 0) {
						for(i=1 ; i<=$tds.length;i++)
						{
							$currText = $tds.eq(i).text();
							get_all_text =  get_all_text+ " "+ $currText;
						}
							
					}
				});

			}
			data = {
				"input": {
					"text": get_all_text
				}
			};
			$.ajax({
					url :'/wex.cfm/speechtotext/google_control',
					method: 'post',
					contentType: 'application/json; charset=utf-8',
					dataType: "json",
					data : JSON.stringify(data),
					success : function(response){ 
						parse_response = JSON.parse(response);
						document.getElementById("audio_control").src = "data:audio/ogg;base64,"+parse_response.audioContent;
						document.getElementById("audio_control").play(); 
						
						$("##play").css("display","none");
						$("##pause").css("display","");
						$("##play_func").attr("onclick","playVoice()");
					}
			}); 
		}
		
		function PROCTest(form_,type_id){	
		
			/* console.log(form_); */ 
			exForm = form_;

			var table = $(form_).parents('.portBox').find('> .portBoxBodyStandart table');

			/* console.log(table); */

			if(type_id == 0)
			{
				form_ = $("##listIcon").closest('form');	
				if(form_.length == 0)
					form_ = $(exForm).closest('form');
				if(eval('_CF_check'+$(form_).attr('name')+'('+$(form_).attr('name')+')'))
				{
					<cfif isdefined("caller.WOStruct")>
						console.log(validate().check());
						if(validate().check())
						{
							goster(working_div_main);
							$(form_).submit();
							$(form_).find(':input[id="is_excel"]').each(function(){
								if($(this).prop('checked')){
								$("##working_div_main").hide();
								}
							});
						}
						else
						{
							gizle(working_div_main);
							return false;
						}
					<cfelse>
						goster(working_div_main);
						$(form_).submit();
					</cfif>
				}
			}
			else
			{
				try{
						$(table).html($(table).html().replace(/<!-- del -->/g,''));
						
						$(table).find('th:hidden').each(function(index,element){

							$(element).before('<!-- del -->');

							$(element).after('<!-- del -->');

							})

						$(table).find('td:hidden').each(function(index,element){

							$(element).before('<!-- del -->');

							$(element).after('<!-- del -->');

							})

						$(table).find('input').each(function(index,element){

								if($(element).attr('type')=='text'){

									val_ = $(element).val();

									$(element).after('<span>'+val_+'</span>');

								}});
							$(table).find('.gdpr_alert').each(function(){
                                $(this).remove();
                            });


						var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));

						$(table).find('span').each(function(index,element){

								if(!element.hasClass("ui-stage")){
										$(element).remove();
								}
								

							});
						}
				catch(e)
				{
					if($(table).html($(table).html())){
						try{
							$(table).html($(table).html().replace(/<!-- del -->/g,''));
							$(table).find('th:hidden').each(function(index,element){
								$(element).before('<!-- del -->');
								$(element).after('<!-- del -->');
								})
							$(table).find('td:hidden').each(function(index,element){
								$(element).before('<!-- del -->');
								$(element).after('<!-- del -->');
								})
							var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));
							}catch(e){
								$(table).html($(table).html().replace(/<!-- del -->/g,''));
								$(table).find('th:hidden').each(function(index,element){
									$(element).before('<!-- del -->');
									$(element).after('<!-- del -->');
									})
								$(table).find('td:hidden').each(function(index,element){
									$(element).before('<!-- del -->');
									$(element).after('<!-- del -->');
									})
								var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));
							}
					}else{
						$(table).html($(table).html().replace(/<!-- del -->/g,''));
						$(table).find('th:hidden').each(function(index,element){
							$(element).before('<!-- del -->');
							$(element).after('<!-- del -->');
							})
						$(table).find('td:hidden').each(function(index,element){
							$(element).before('<!-- del -->');
							$(element).after('<!-- del -->');
							})
						var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));	
					}
				}
				goster(working_div_main);
				dark_mode = '<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>';
				dark_mode = dark_mode.trim();
				dark_mode_value = '<cfoutput>#listlast(session.dark_mode,":")#</cfoutput>';
				dark_mode_value = dark_mode_value.trim();
				callURL("<cfoutput>#request.self#?fuseaction=objects.docExport&ajax=1&ajax_box_page=1&xmlhttp=1&_cf_nodebug=true&action_type=</cfoutput>"+type_id,handlerPost,{ data: $.toJSON(dataAll),"<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>" : dark_mode_value});
			}
			
		}
		if($('##wrk_search_button').length==0){
			function callURL(url, callback, data, target, async)
			{   
				var method = (data != null) ? "POST": "GET";
				$.ajax({
					async: async != null ? async: true,
					url: url,
					type: method,
					data: data,
					success: function(responseData, status, jqXHR)
					{ 
						callback(target, responseData, status, jqXHR); 
					}
				});
			}
		}


		try{
			<cfif isdefined("caller.attributes.js_show_hide_order") and len(caller.attributes.js_show_hide_order)>
				var hide_list = '#caller.attributes.js_show_hide_order#';
			<cfelse>
				var hide_list = '';
			</cfif>
			<cfif isdefined("caller.attributes.js_hidden_list") and len(caller.attributes.js_hidden_list)>
				var hiddenList = '#caller.attributes.js_hidden_list#';
			<cfelse>
				var hiddenList = '';
			</cfif>
			var thead_html = $('.report_list').find('thead');
			var tbody_html = $('.report_list').find('tbody');
			var tbody_tr = tbody_html.find('tr');
			var tbody_tr_td = tbody_tr.find('td');
			var tr_html = thead_html.find('tr');
			var th_list = tr_html.find('th');
			var colspan_control = true;
		
			/*thead tr th id*/
			for(i = 0;i<th_list.length;i++)
			{
				th_list[i].removeAttribute("width");
				th_list[i].setAttribute("id",'th_'+i);
			}
			for(i = 0;i<tbody_tr_td.length;i++)
			{
				var colspan = tbody_tr_td[i].getAttribute("colspan");
				if(colspan > 1)
				{
					colspan_control = false;
					break; 
				}
			}
			$.moveColumn = function (table, from, to) {
				var rows = $('tr', table);
				var cols;
				rows.each(function() {
					cols = $(this).children('th, td');
					cols.eq(from).detach().insertBefore(cols.eq(to));
				});
			}
			if($('.report_list').find('tbody tr td').length > 1 && $('.report_list').find('tbody').length < 2)
			{
				if(colspan_control && isDragCompatible())
				{
					$(".report_list").addClass("draggable no-remember-ordering");
				}
				$('.report_list').columnManager({listTargetID:'show_hide_holder', onClass: 'simpleon', offClass: 'simpleoff',<cfif isdefined("caller.attributes.js_show_hide_order") and len(caller.attributes.js_show_hide_order)>colsHidden: [#caller.attributes.js_show_hide_order#],</cfif> onToggle: function(index, state){ 
					state = ( state ) ? 'visible' : 'hidden'; 
					if(state == 'visible')
					{
						hide_list = removeValue(hide_list,index,',');
					}
					else if (state == 'hidden')
					{
						hide_list = addValue(hide_list,index,',');
					}
					if(document.getElementById('js_show_hide_order'))
					{
						document.getElementById('js_show_hide_order').value = hide_list;
					}
				}}); 
				<cfif isdefined("caller.attributes.js_column_order") and len(caller.attributes.js_column_order)>
					if(colspan_control && isDragCompatible())
					{
						var column_order = JSON.parse('<cfoutput>#caller.attributes.js_column_order#</cfoutput>');
						var tbl = jQuery('.report_list');
						for (var key in column_order) 
						{
							if(document.getElementById(key).cellIndex != column_order[key])
							{
								$.moveColumn(tbl,document.getElementById(key).cellIndex, column_order[key]);
							}
						}
					}
				</cfif>
				if (!Array.prototype.indexOf) {
					Array.prototype.indexOf = function (elt /*, from*/) {
						var len = this.length >>> 0;
						var from = Number(arguments[1]) || 0;
						from = (from < 0) ? Math.ceil(from) : Math.floor(from);
						if (from < 0) from += len;
				
						for (; from < len; from++) {
							if (from in this && this[from] === elt) return from;
						}
						return -1;
					};
				}		
				function removeValue (list, value, separator) 
				{
					separator = separator || ",";
					var values = list.split(",");
					for(var i = 0 ; i < values.length ; i++) {
						if(values[i] == value) {
							values.splice(i, 1);
							return values.join(",");
						}
					}
					return list;
				}	
				function addValue (list, value, separator) 
				{
					if(list != '')
					{
						var numbers = list.split(',');
					}
					else
					{
						var numbers = new Array();
					}
					if(numbers.indexOf(value)== -1) 
					{
						numbers.push(value);
					}
					listOfNumbers = numbers.join(',');
					return listOfNumbers;
				}
				
				//BigList ve MediumList için türkçe karakter desteği, tarih sıralama düzenlemesi yapıldı. EY20161103
				function getTextExtractor()
				{
					return (function() {
					var patternLetters = /[öäüÖÄÜáàâéèêúùûóòôÁÀÂÉÈÊÚÙÛÓÒÔßÇçİı]/g;
					var patternDateDmy = /^(?:\D+)?(\d{1,2})\.(\d{1,2})\.(\d{2,4})$/;
					var lookupLetters = {
						"ä": "a", "ö": "o", "ü": "u",
						"Ä": "A", "Ö": "O", "Ü": "U",
						"Ç": "C", "ç": "c", "İ":"I","ı":"i",
						"á": "a", "à": "a", "â": "a",
						"é": "e", "è": "e", "ê": "e",
						"ú": "u", "ù": "u", "û": "u",
						"ó": "o", "ò": "o", "ô": "o",
						"Á": "A", "À": "A", "Â": "A",
						"É": "E", "È": "E", "Ê": "E",
						"Ú": "U", "Ù": "U", "Û": "U",
						"Ó": "O", "Ò": "O", "Ô": "O",
						"ß": "s"
					};
					var letterTranslator = function(match) { 
						return lookupLetters[match] || match;
					}
				
					return function(node) {
						var text = $.trim($(node).text());
						var date = text.match(patternDateDmy);
						if (date)
						return [date[3], date[2], date[1]].join("-");
						else
						return text.replace(patternLetters, letterTranslator);
					}
					})();
				}
				
								
				$(".report_list").tablesorter({cssAsc:"headerSortUp",cssDesc:"headerSortDown", locale: 'eu', dateFormat : "uk",textExtraction: getTextExtractor()
					<cfif isdefined("caller.attributes.js_sort_order") and len(caller.attributes.js_sort_order)>
						,sortList : [[<cfoutput>#caller.attributes.js_sort_order#</cfoutput>]]
					</cfif>
				}).bind("sortEnd", function(sorter) {
					$('##show_hide_holder').hide();
					$(document).unbind('click');
					currentSort = sorter.target.config.sortList;
					if(document.getElementById('js_sort_order'))
					document.getElementById('js_sort_order').value = currentSort;
				});
				$( ".report_list thead th" ).each(function( index , element ) {
					if($(this).hasClass('header_icn_none'))
					{
						$(this).unbind('click');
					}
					else if ($(this).hasClass('header_icn_text')) 
					{
						$(this).unbind('click');		
					}
				});  
				$('##show_hide_holder ul li a').each(function() {
					$(this).attr("href",'javascript://');
				});
				$('.report_list').fadeIn(500);
				
				if(hiddenList != '')
				{
					for(i=0;i<list_len(hiddenList,',');i++)
					{
						$("table[biglist] thead tr ##th_"+list_getat(hiddenList,i+1,',')).css('display','none');
						indexMain = $( "table[biglist] thead tr th" ).index( $("##th_"+list_getat(hiddenList,i+1,',')));
						$("table[biglist] tbody tr").each(function(index,element){
								$(element).find("td:eq("+indexMain+")").css('display','none');
							})
					}
				}
			}
			else
			{
				$('.report_list').fadeIn(500);
				$('.list_settings').hide();
			}
			$('##opener').click(function() {
				$('##show_hide_holder').css('display','block');
			});
			$('##show_hide_holder').mouseleave(function() {
				$('##show_hide_holder').hide(400);
			});
			function isDragCompatible()
			{
				if (/MSIE (\d+\.\d+);/.test(navigator.userAgent))
				{ 
					var ieversion=new Number(RegExp.$1)
					if (ieversion < 10)
					{
						return false;
					}
					else
					{
						return true;
					}
				}
				else
				{
					return true;	
				}
			}
			}
		catch(err){
			$('.report_list').fadeIn(300);
			$('.list_settings').hide();
		}
		var thead_html = $('##show_hide_holder').find('li'); 
		for(i=0;i<thead_html.length;i++)
		{
			if(thead_html[i].innerHTML.indexOf('checkbox') != -1)
			{
				thead_html[i].style.display="none";
				thead_html[i].innerHTML = '';
			}
			if(thead_html[i].innerHTML.length == 24) <!--- bos gelen ifadede 24 karakter oluyor --->
			{
				thead_html[i].style.display="none";
				thead_html[i].innerHTML = '';
			}
			if(thead_html[i].innerHTML.innerHTML == 'undefined')
			{
				thead_html[i].style.display="none";
				thead_html[i].innerHTML = '';
			}
			if(thead_html[i].innerHTML.indexOf('input') != -1)
			{
				thead_html[i].style.display="none";
				thead_html[i].innerHTML = '';
			}
		}
		jQuery.browser = {};
		(function () {
			jQuery.browser.msie = false;
			jQuery.browser.version = 0;
			if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
				jQuery.browser.msie = true;
				jQuery.browser.version = RegExp.$1;
			}
		})();
			
		$('.report_list th').first()
			.mouseover(function(){
				$('.fsButton').show(200);					
			})
			.mouseout(function() {
				setTimeout("$('.fsButton').hide(200);", 3000);
		});

		
		/*  <cfif not len(attributes.height)>
				function basket_set_height_#attributes.id#()
				{
					//h1 = AutoComplete_GetTop(document.getElementById('#attributes.id#_upper'));
					var child = $('###listContentid#');
					var h1 = child.position().top;
					h2 = document.body.clientHeight;
					b_special_height = h2 - h1 - 45;
					if(b_special_height < 100)
							b_special_height = 100;
					document.getElementById('#listContentid#').style.height = b_special_height + 'px';
					
				}
				$(window).load(function () 
					{ 
						basket_set_height_#attributes.id#();
					});
				$(window).resize(function()
					{
						basket_set_height_#attributes.id#();
					});
					
					
		</cfif> */

	</script>
	</cfif>
</cfoutput>