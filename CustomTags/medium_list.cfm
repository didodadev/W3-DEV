<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="medium_list_#round(rand()*10000000)#">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.is_sort" default="">
<cfoutput>
<cfif thisTag.executionMode eq "start">
    <cfif attributes.is_sort eq 1><script type="text/javascript" src="/JS/temp/tablesorter/jquery.tablesorter.js"></script>
   
    </cfif>
	<cfif isdefined("caller.collapsed_medium_list") and not caller.fusebox.fuseaction contains 'popup'>
        <!-- sil -->
    </cfif>
    <div class="ListContent">
		<table class="workDevList" style="#attributes.style#" id="#attributes.id#" cellspacing="0" align="center"><!--- cellspacing ve align'i silmeyiniz. Yerlerini degistirmeyiniz. Replace islemi icin bu ifadelere bakiliyor. EY 20130620 --->
<cfelse>
    	</table>
    </div>
    <cfif attributes.is_sort eq 1>
		<script type="text/javascript">
            $("###attributes.id#").tablesorter({cssAsc:"sortup",cssDesc:"sortdown",dateFormat : "uk",textExtraction: getTextExtractor()});<!--- listede is_sort parametresine bağlı olarak sıralama yapar.OSİ 20130515--->
			$( ".medium_list thead th" ).each(function( index ) {
                if($(this).hasClass('header_icn_none'))
                {
                    $(this).unbind('click');
                }
                else if ($(this).hasClass('header_icn_text')) 
                {
                    $(this).unbind('click');		
                }
            });	
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
        </script>
    </cfif>
	<cfif isdefined("caller.collapsed_medium_list")>
        <!-- sil -->
    </cfif>
</cfif>
</cfoutput>
