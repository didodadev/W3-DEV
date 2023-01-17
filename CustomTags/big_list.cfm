<cfparam name="attributes.wrk_tbody" default="0">
<cfparam name="attributes.id" default="">
<cfset listContentid = "catalystBigList#RandRange(1, 999, "SHA1PRNG")#">
<cfoutput>
	<cfif thisTag.executionMode eq "start">
    <!---Tablolardaki sutunlarin sirlanmasi icin kullanılan script--->
    
    <!--- Tablolardaki sutunlarin yerdegisikligi icin kullanilan script--->
    <script type="text/javascript" src="/JS/temp/tablesorter/jquery.columnmanager.js"></script>    
	<script type="text/javascript" src="/JS/temp/tablesorter/draggable.js"></script>
	<script type="text/javascript" src="/JS/temp/tablesorter/jquery.tablesorter.js"></script>
	   <cfif isdefined("caller.collapsed")><!--- bu ifade big_list_search custom tag'inde ataniyor. Bu ozellikten sayfada big_list_search alaninin oldugu anlasiliyor. Boylece yazdirma,excele alma sorunsuz calisiyor...--->
	       <!-- sil -->
       </cfif>
		<div class="list_settings" align="right"><!--- listede bulunan th alanına bağlı tüm satırı gizleyip göstermeye yarar. Herhangi bir parametre taşımaz. Geliştirim için aşağıdaki jquery alanı kullanılmalıdır. OSİ 20130515--->
			<a href="javascript://" id="opener">&nbsp;</a>
			<div id="show_hide_holder" style="display:none;" align="left"></div>
		</div>
		<div class="fsButton" onclick="fs({id:'#listContentid#'});"><span class="catalyst-size-fullscreen bold"></span></div>
       	<div class="ListContent" id="#listContentid#">		
       <cfif caller.attributes.fuseaction contains 'autoexcel'>
		   <table bigList class="big_list" id="#attributes.id#" align="center">
       <cfelse>
		   <table bigList class="big_list" style="display:none;" id="#attributes.id#" align="center">
       </cfif>
    <cfelse>
    	<cfif attributes.wrk_tbody neq 1>
	       </table>
       </cfif>
       </div>
       <cfif isdefined("caller.collapsed")>
			<!-- sil -->
	   </cfif>
		<script type="text/javascript">
		$(document).ready(function() {
		try
		  {
			<cfif isdefined("caller.attributes.js_show_hide_order") and len(caller.attributes.js_show_hide_order)>
				var hide_list = '#caller.attributes.js_show_hide_order#';
			<cfelse>
				var hide_list = '';
			</cfif>
			<cfif isdefined("caller.attributes.js_hidden_list") and len(caller.attributes.js_hidden_list)>
				var hiddenList = '#caller.attributes.js_hidden_list#';
				var mhiddenList = '#caller.attributes.js_mhidden_list#';
			<cfelse>
				var hiddenList = '';
				var mhiddenList = '';
			</cfif>
			var thead_html = $('.big_list').find('thead');
			var tbody_html = $('.big_list').find('tbody');
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
			if($('.big_list').find('tbody tr td').length > 1 && $('.big_list').find('tbody').length < 2)
			{
				if(colspan_control && isDragCompatible())
				{
					$(".big_list").addClass("draggable no-remember-ordering");
				}
				$('.big_list').columnManager({listTargetID:'show_hide_holder', onClass: 'simpleon', offClass: 'simpleoff',<cfif isdefined("caller.attributes.js_show_hide_order") and len(caller.attributes.js_show_hide_order)>colsHidden: [#caller.attributes.js_show_hide_order#],</cfif> onToggle: function(index, state){ 
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
						var tbl = jQuery('.big_list');
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
					  	{
						  return [date[3], date[2], date[1]].join("-");
						}
					  else{ 
						 	text = text.replace(patternLetters, letterTranslator);
							return text;
						  }
					}
				  })();
				}
				
								
				$(".big_list").tablesorter({cssAsc:"headerSortUp",cssDesc:"headerSortDown", locale: 'eu', dateFormat : "uk",textExtraction: getTextExtractor()
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
				$( ".big_list thead th" ).each(function( index , element ) {
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
				$('.big_list').fadeIn(500);
				
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

				if (mhiddenList != '') {
					for (i = 0; i < list_len(mhiddenList, ','); i++) {
						$("table[biglist] thead tr ##th_"+list_getat(mhiddenList,i+1,',')).addClass('hidden-xs');
						indexMain = $( "table[biglist] thead tr th" ).index( $("##th_"+list_getat(mhiddenList,i+1,',')));
						$("table[biglist] tbody tr").each(function(index,element){
							$(element).find("td:eq("+indexMain+")").addClass('hidden-xs');
						});
					}
				}
				
			}
			else
			{
				$('.big_list').fadeIn(500);
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
		catch(err)
		  {
			  $('.big_list').fadeIn(300);
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
				
			$('.big_list th').first()
				.mouseover(function(){
					$('.fsButton').show(200);					
				})
				.mouseout(function() {
					setTimeout("$('.fsButton').hide(200);", 3000);
			});
		});
		</script>
    </cfif>
</cfoutput>