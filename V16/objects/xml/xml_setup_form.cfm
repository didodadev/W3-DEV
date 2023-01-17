﻿<cfparam name="attributes.friendly_url" default="">
<script type="text/javascript" src="../../JS/jquery_1_5.js">
	function dsp_error_(e_id){
		if(e_id == 1)
			alert('<cf_get_lang dictionary_id="57675.Fuseaction Tanımlı Değil">!');
		else if(e_id == 2)
			alert('<cf_get_lang dictionary_id="32771.Bu Sayfa İçin XML Tanımı Yapılmamış Yada Faction List  içindeki LINK_FILE Adı Hatalı">');
		else if(e_id == 3)	
			alert('<cf_get_lang dictionary_id="32942.Belirtilen Adreste İlgili Dosya Bulunamadı">!');
		else if(e_id == 4)
		 alert('<cf_get_lang dictionary_id="32947.Bu Sayfa İçin XML Tanımı Yapılmamış">!');	
		else if(e_id == 5)	
			alert('<cf_get_lang dictionary_id="32949.Belirttiğiniz Modül İçin Faction List Dosyası Oluşturulmamış">!');
		else if(e_id == 6)	
			alert('<cf_get_lang dictionary_id="32951.XML Formatını Değiştirebilmek için Süper Kullanıcı Olmanız Gerekmektedir">!');
		window.close();	
	}
</script>
<style>
    .goog-te-menu-frame{
        z-index:9999999999;
    }
    .skiptranslate{
        z-index:9999999999;
    }
</style>
<cfquery name="GET_OUR_COMP" datasource="#DSN#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY
</cfquery>
<!--- Super kullanıcı kontrolu,kullanıcı browser dan adresi elle yazarak girebilir diye yapilmistir.--->
<cfparam name="xml_setting_file_name" default="">
<cfif isdefined('attributes.fuseact') and ListLen(attributes.fuseact,'.')>
	<cfset _modul_name_ = ListGetAt(attributes.fuseact,1,'.')>
    <cfif _modul_name_ is 'prod'><cfset _modul_name_ = 'production_plan'></cfif>
	<cfif _modul_name_ is 'call'><cfset _modul_name_ = 'callcenter'></cfif>
	<cfif _modul_name_ is 'invent'><cfset _modul_name_ = 'inventory'></cfif>
	<cfif _modul_name_ is 'ehesap'><cfset _modul_name_ = 'hr/ehesap'></cfif>
	<cfif _modul_name_ is 'rule'><cfset _modul_name_ = 'rules'></cfif>
<cfelse>
	<script type="text/javascript">
    	dsp_error_(1);
    </script> 
	<cfabort>   
</cfif>

<cfset f_sayac = 0>
<cfquery name="GET_ACTIVE_MODULE_NAME" datasource="#DSN#" cachedwithin="#CreateTimeSpan(0,24,0,0)#">
	SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.fuseact,1,'.')#">
</cfquery>
<cfif (get_active_module_name.recordcount and not get_module_power_user(get_active_module_name.MODULE_ID)) and not get_module_power_user(47)>
	<script type="text/javascript">
		dsp_error_(6);
    </script>
	<cfabort>	
</cfif>
<cfset folder_name = "#index_folder##_modul_name_##dir_seperator#xml#dir_seperator#">
<cfquery name="GET_FACTION" datasource="#DSN#" maxrows="1">
	SELECT PROCESS_ID, FACTION FROM PROCESS_TYPE WHERE FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.fuseact#%">
</cfquery>
<cf_box id="xmlPage" title="Page Settings" resize="1" closable="1" draggable="1" collapsable="0">
	<div class="row">
		<div class="col col-6 col-md-6">
			<div class="form-group" id="item-our_company_id" style="margin-bottom:5px;">
				<select name="our_company_id" id="our_company_id" onchange="sayfa_getir(this.value);">
					<cfloop query="get_our_comp">
						<cfoutput><option value="#comp_id#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option></cfoutput>
					</cfloop>
				</select>
			</div>
		</div>
		<div align="right">
			<div class="form-group" id="google_translate_element"></div>
			<script type="text/javascript">
				function googleTranslateElementInit() 
				{
					new google.translate.TranslateElement({
						pageLanguage: '<cfoutput>#session.ep.language#</cfoutput>', 
						includedLanguages: 'tr,en,fr,ar,ru,de,es,it,ro',
						layout:google.translate.TranslateElement.InlineLayout.SIMPLE,
						autoDisplay: false
					},'google_translate_element');
				}
			</script>
			<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
		</div>
	</div>
	<div class="row" id="page_settings_content"></div>
</cf_box>

<script type="text/javascript">
function sayfa_getir(comp_id){AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_xml_setup_internal<cfif isdefined("attributes.event")>&event=<cfoutput>#attributes.event#</cfoutput></cfif>&fuseact=<cfoutput>#attributes.fuseact#</cfoutput>&main_fuseact=<cfoutput>#attributes.main_fuseact#</cfoutput>&_modul_name_=<cfoutput>#_modul_name_#&friendly_url=#attributes.friendly_url#</cfoutput>&our_comp_id='+comp_id,'page_settings_content');}

sayfa_getir("<cfoutput>#session.ep.company_id#</cfoutput>");

function fillArray()
{
	window.xmlPage = {};
	$("#SHOW_ROWS").find("input,select,textarea").each(function(index,element){
		window.xmlPage[$(element).attr('name')] = $(element).val();
	});
	window.xmlPage["our_company_id"] = document.xml_setup_form.our_company_id.value;
	window.xmlPage["record_num"] = document.xml_setup_form.record_num.value;
	window.xmlPage["page_fuseaction"] = document.xml_setup_form.page_fuseaction.value;
	window.xmlPage["is_upd"] = document.xml_setup_form.is_upd.value;
	window.xmlPage["friendly_url"] = document.xml_setup_form.friendly_url.value;
	var myJsonString = JSON.stringify(window.xmlPage);
	callURL("<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_xml_setup</cfoutput>&isAjax=1",handlerPost,{ xmlPage: encodeURIComponent(myJsonString) });
	return false;
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
		},
		error: function(xhr, opt, err)
		{
			// If error string is empty, it means page redirected to another url before ajax process done. Skip the process on this situation
			if (err != null && err.toString().length != 0) callback(target, err, opt, xhr); 
		}
	});
}

function handlerPost(target, responseData, status, jqXHR){
	responseData = $.trim(responseData);
	
	if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
	sayfa_getir(document.getElementById('our_company_id').value);
}

</script>