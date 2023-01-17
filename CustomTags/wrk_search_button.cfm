<!--- 
Description : listelerdeki arama butonuna bir kere basilmasini saglar, cfform tagi arasinda her yerde kullanilmalidir.

Parameters :
	search_function = not required
Syntax :
	<cf_wrk_search_button search_function='kontrol()'>
created :
	YO20050502
modified :
	20050523
--->
<cfparam name="attributes.search_function" default="">
<cfparam name="attributes.return_function" default="">
<cfparam name="attributes.button_type" default="0">
<cfparam name="attributes.value" default="">
<cfparam name="attributes.button_name" default="">
<cfparam name="attributes.is_excel" default="1">
<cfparam name="attributes.is_excelbuton" default="1">
<cfparam name="attributes.is_wordbuton" default="1">
<cfparam name="attributes.is_pdfbuton" default="1">
<cfparam name="attributes.is_mailbuton" default="1">
<cfparam name="attributes.is_printbuton" default="1">
<cfparam name="attributes.isAjax" default=false>
<cfparam name="attributes.no_show_process" default=0>
<cfparam name="attributes.float" default="">

<cfif attributes.is_excel eq 1 and not caller.attributes.fuseaction contains 'popup'>
	<cfset caller.attibutes.close_file_action_buttons = 1>
</cfif>
<cfif attributes.button_type eq 0>
	<span class="btn green-haze btn-small wrk_search_button" align="bottom" id="wrk_search_button" name="wrk_search_button"  onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));"><cf_get_lang_main no='153.ARA'></span>
  <input searchButton type="submit" class="searchbuton" align="bottom" hidden="true" id="wrk_search_button" name="wrk_search_button" value="" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));" style="cursor:pointer; vertical-align:bottom;  background-color:transparent;">

<cfelseif attributes.button_type eq 2>	
	<input type="submit" align="absmiddle" value="<cfoutput>#attributes.button_name#</cfoutput>" id="wrk_search_button" name="wrk_search_button" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));" style="cursor:pointer; <cfif len(attributes.float)>float:<cfoutput>#attributes.float#</cfoutput>; margin-right:5px;</cfif> ">
<cfelseif attributes.button_type eq 3>
	<button class="ui-btn ui-btn-green" style="border:none" type="submit"  id="wrk_search_button" name="wrk_search_button"  onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));"><i class="fa fa-search"></i></button>
	<input searchButton type="submit" class="searchbuton" src="/images/ara.gif" align="bottom" hidden="true" id="wrk_search_button" name="wrk_search_button" value="" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));" style="cursor:pointer; vertical-align:bottom;  background-color:transparent;">
<cfelseif attributes.button_type eq 4>
	<a class="ui-btn ui-btn-green" href="javascript://" id="wrk_search_button" name="wrk_search_button"  onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));"><i class="fa fa-search"></i></a>
	  <input searchButton type="submit" class="searchbuton" align="bottom" hidden="true" id="wrk_search_button" name="wrk_search_button" value="" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));" style="cursor:pointer; vertical-align:bottom;  background-color:transparent;">
<cfelseif attributes.button_type eq 5>
	<div>
		<a class="ui-btn ui-btn-success" href="javascript://" id="wrk_search_button" name="wrk_search_button"  onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));"><cfif len(attributes.value)><cfoutput>#attributes.value#</cfoutput><cfelse><cf_get_lang dictionary_id='57565.ARA'></cfif></a>
		<input searchButton type="submit" class="searchbuton" align="bottom" hidden="true" id="wrk_search_button" name="wrk_search_button" value="" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));" style="cursor:pointer; vertical-align:bottom;  background-color:transparent;">
	</div>

<cfelseif attributes.button_type eq "nocode">
	<button type="submit" class="keyword-search" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));"><i class="fa fa-search"></i></button>
	
<cfelse>
	<input type="submit" align="absmiddle" value="<cfoutput>#caller.getLang('main',499)#</cfoutput>" id="wrk_search_button" name="wrk_search_button" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,0));" style="cursor:pointer; ">
</cfif>

<cfif attributes.is_excel eq 1 and not caller.attributes.fuseaction contains 'popup'>
	<div id="buttons" style="display:none;"> 
   		<ul>
			<cfif attributes.is_excelbuton eq 1>
                <li>               		
                    <a href="javascript://" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,1));" title="<cf_get_lang_main no='1940.Excel Üret'>">&nbsp;<i class="fa fa-file-excel-o  fa-2x"></i>&nbsp;</a>
                </li>
            </cfif>
            <cfif attributes.is_wordbuton eq 1>
                <li>                   
                    <a href="javascript://" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,2));" title="<cf_get_lang_main no='1941.Word Üret'>">&nbsp;<i class="fa fa-file-word-o fa-2x"></i>&nbsp;</a>
                </li>
            </cfif>
            <cfif attributes.is_pdfbuton eq 1>
                <li>                   
                    <a href="javascript://"  onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,3));" title="<cf_get_lang_main no='1942.PDF Üret'>">&nbsp;<i class="fa fa-file-pdf-o fa-2x"></i>&nbsp;</a>
                </li>           
            </cfif>
            <cfif attributes.is_mailbuton eq 1>
                <li> 
                    <a href="javascript://" onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,4));" title="<cf_get_lang_main no='63.Mail Gönder'>">&nbsp;<i class="fa fa-envelope-o fa-2x"></i>&nbsp;</a>       
                </li>
            </cfif>
            <cfif attributes.is_printbuton eq 1>
                <!---
				<li>
					<a href="javascript://"onclick="return (<cfif len(attributes.search_function)><cfoutput>#attributes.search_function#</cfoutput>&&</cfif> PROCTest(this,5));" title="<cf_get_lang_main no='1943.Yazıcıya Gönder'>" >&nbsp;<i class="fa fa-print fa-2x"></i>&nbsp;</a>                     
                </li>
				--->
				<li>
                    <a href="javascript://"onclick="printSa();" title="<cf_get_lang_main no='1943.Yazıcıya Gönder'>" >&nbsp;<i class="fa fa-print fa-2x font-blue"></i>&nbsp;</a>
                </li>
            </cfif>
        </ul>  
	</div>
</cfif>
<!-- sil -->

<script>
	action_address_ilk_a = '';
	action_address_run_ = 0;
	function geri_al_working()
	{
		gizle(messageDiv);
		gizle(working_div_main);
		document.getElementById('wrk_search_button').disabled = false;
	}
	
	function open_save_popup(asset_file)
	{
		<cfif isDefined('session.pp.userid')>
			windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_save_asset_file</cfoutput>&asset_file=' + asset_file,'small');
		<cfelse>
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_save_asset_file</cfoutput>&asset_file=' + asset_file,'small');
		</cfif>
	}
	
	function PROCTest(form_,type_id)
	{		
		exForm = form_;
		if(type_id == 0)
		{
			form_ = $("#listIcon").closest('form');	
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
							$("#working_div_main").hide();
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
					 $("table[bigList]").html($("table[bigList]").html().replace(/<!-- del -->/g,''));

                    $("table[bigList]").find('th:hidden').each(function(index,element){

                        $(element).before('<!-- del -->');

                        $(element).after('<!-- del -->');

                        })

                    $("table[bigList]").find('td:hidden').each(function(index,element){

                        $(element).before('<!-- del -->');

                        $(element).after('<!-- del -->');

                        })

                    $("table.big_list").find('input').each(function(index,element){

                            if($(element).attr('type')=='text'){

                                val_ = $(element).val();

                                $(element).after('<span>'+val_+'</span>');

                            }});

                    var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$("table[bigList]").html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));

                    $("table.big_list").find('span').each(function(index,element){

                             $(element).remove();

                        });
					}
				catch(e)
				{
					if($("table.workDevList").html($("table.workDevList").html())){
						try{
							$("table.workDevList").html($("table.workDevList").html().replace(/<!-- del -->/g,''));
							$("table.workDevList").find('th:hidden').each(function(index,element){
								$(element).before('<!-- del -->');
								$(element).after('<!-- del -->');
								})
							$("table.workDevList").find('td:hidden').each(function(index,element){
								$(element).before('<!-- del -->');
								$(element).after('<!-- del -->');
								})
							var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$("table.workDevList").html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));
							}catch(e){
								$("table.basket_list").html($("table.basket_list").html().replace(/<!-- del -->/g,''));
								$("table.basket_list").find('th:hidden').each(function(index,element){
									$(element).before('<!-- del -->');
									$(element).after('<!-- del -->');
									})
								$("table.basket_list").find('td:hidden').each(function(index,element){
									$(element).before('<!-- del -->');
									$(element).after('<!-- del -->');
									})
								var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$("table.basket_list").html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));
							}
					}else{
						$("table.big_list").html($("table.big_list").html().replace(/<!-- del -->/g,''));
						$("table.big_list").find('th:hidden').each(function(index,element){
							$(element).before('<!-- del -->');
							$(element).after('<!-- del -->');
							})
						$("table.big_list").find('td:hidden').each(function(index,element){
							$(element).before('<!-- del -->');
							$(element).after('<!-- del -->');
							})
						var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$("table.big_list").html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));	
					}
				}
				goster(working_div_main);
				dark_mode = '<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>';
				dark_mode = dark_mode.trim();
				dark_mode_value = '<cfoutput>#listlast(session.dark_mode,":")#</cfoutput>';
				dark_mode_value = dark_mode_value.trim();
				callURL("<cfoutput>#request.self#?fuseaction=objects.docExport&ajax=1&ajax_box_page=1&xmlhttp=1&_cf_nodebug=true&action_type=</cfoutput>"+type_id,handlerPost,{ data: $.toJSON(dataAll),"<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>" : dark_mode_value});
			}
			/*else
			{
				console.log($("table[mediumList]").html());
			}*/
		
	}
	
	
	
function callURL(url, callback, data, target, async)
{   
	// Make method POST if data parameter is specified
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

function handlerPost(target, responseData, status, jqXHR){
	responseData = $.trim(responseData);
	
	$('#working_div_main').css("display", "none");
	
	if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
	//console.log(responseData);
	ajax_request_script(responseData);
}
</script>
<!-- sil -->