<cfsetting showdebugoutput="no">
<cfparam name="attributes.module_name" default="">
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT
	  <cfif session.ep.language is "tr">
		MODULE_NAME_TR AS MODULE_NAME_,
	  <cfelse>
		MODULE_NAME AS MODULE_NAME_,
	  </cfif>
		MODULE_SHORT_NAME
	FROM	
		MODULES
	ORDER BY
		MODULE_NAME_ 
</cfquery>
<cfquery name="GET_LANG_ALL" datasource="#DSN#">
	SELECT
    	TR.DICTIONARY_ID,
		TR.ITEM_ID,
		TR.MODULE_ID,
		TR.ITEM TR_ITEM,
		ENG.ITEM ENG_ITEM,
		ARB.ITEM ARB_ITEM,
		DE.ITEM DE_ITEM
	FROM
		SETUP_LANGUAGE_TR AS TR,
		SETUP_LANGUAGE_ENG AS ENG,
		SETUP_LANGUAGE_ARB AS ARB,
		SETUP_LANGUAGE_DE AS DE
	WHERE  
		TR.ITEM_ID = ARB.ITEM_ID AND
		TR.ITEM_ID = ENG.ITEM_ID AND
		TR.ITEM_ID = DE.ITEM_ID AND
		TR.MODULE_ID = ENG.MODULE_ID AND
		TR.MODULE_ID = ARB.MODULE_ID AND
		TR.MODULE_ID = DE.MODULE_ID AND
		TR.MODULE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">
	ORDER BY 
		TR.ITEM_ID,
		ENG.ITEM_ID,
		ARB.ITEM_ID
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold"><cf_get_lang no='51.Sistem Dil Ayarları'></td>
    <!-- sil -->
    <td>
	<table align="right">
	<cfform name="list_settings" method="post" action="#request.self#?fuseaction=settings.new_lang_settings">
	  <tr>
		<td><select name="module_name" id="module_name" style="width:150px;">
				<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				<option value="main" <cfif 'main' is attributes.module_name>selected</cfif>> M A I N</option>
				<cfoutput query="get_modules">
					  <option value="#module_short_name#" <cfif attributes.module_name eq module_short_name>selected</cfif>>#module_name_#</option>
				</cfoutput>
				<option value="home" <cfif 'home' is attributes.module_name>selected</cfif>> Home</option>				
				<option value="myhome" <cfif 'myhome' is attributes.module_name>selected</cfif>> Myhome</option>
				<option value="objects2" <cfif 'objects2' is attributes.module_name>selected</cfif>> Objects2</option>	
				<option value="public" <cfif "public" is attributes.module_name>selected</cfif>> Public</option>						   
			</select>
		</td>
		<td><cf_wrk_search_button></td>
		<td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings','medium');"><img src="/images/abc.gif" border="0" alt="Search Word"></a></td>
	  </tr>
	</cfform>
	</table>
    </td>
    <!-- sil -->
  </tr>
</table>
<cfset lang_1="TR">
<cfset lang_2="ENG">
<cfset lang_3="ARB">
<cfset lang_4="DE">

<cfif len(attributes.module_name)>
	<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	  <tr class="color-row">
		<td>
		<table>
		<cfform name="add_lang_set" method="post" action="#request.self#?fuseaction=settings.new_upd_lang_settings">
		  <tr class="txtbold">
          	<td width="75" nowrap="nowrap">Dictionary Id</td>
		  	<td><cf_get_lang_main no='1165.Sıra'></td>
			<td><cf_get_lang no='52.Türkçe'></td>
			<td><cf_get_lang no='53.İngilizce'></td>
			<td><cf_get_lang no='2624.Arapça'></td>
			<td><cf_get_lang no='3103.Almanca'></td>
			<td>
			 <!---  <a href="javascript://" onClick="add_new_element();"><img border="0"  src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1729.Kelime Ekle'>"></a> --->
			  <input type="hidden" name="module_name" id="module_name" value="<cfoutput>#attributes.module_name#</cfoutput>">
			  <input type="hidden" name="max_item" id="max_item" value="<cfoutput>#GET_LANG_ALL.recordcount#</cfoutput>">
			</td>
		</tr>
	  <cfoutput query="GET_LANG_ALL">
		<tr>	
		  <input type="hidden" name="is_change#currentrow#" id="is_change#currentrow#" value="0">
          <td>
            <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_upd_lang_item&strmodule=#module_id#&item_id=#item_id#&dictionary_id=#dictionary_id#&lang=TR','small');">
                #dictionary_id#
            </a>
        </td>
		  <td>#item_id#&nbsp;&nbsp;</td>
		  <td>#tr_item#</td>
 		  <td><input name="ITEM_#lang_1#_#currentrow#" id="ITEM_#lang_1#_#currentrow#" type="hidden" value="#tr_ITEM#" style="width:200px;"  onChange="change(#currentrow#);"><input name="ITEM_#lang_2#_#currentrow#" id="ITEM_#lang_2#_#currentrow#" type="text" value="#eng_ITEM#" style="width:200px;" onChange="change(#currentrow#);">
		  </td>
		  <td>
		  	<input name="ITEM_#lang_3#_#currentrow#" id="ITEM_#lang_3#_#currentrow#" type="text" value="#arb_ITEM#" style="width:200px;" onChange="change(#currentrow#);">
		  </td>
		  <td>
		  	<input name="ITEM_#lang_4#_#currentrow#" id="ITEM_#lang_4#_#currentrow#" type="text" value="#de_ITEM#" style="width:200px;" onChange="change(#currentrow#);">
		  </td>
		</tr>
	  </cfoutput>
	  <tr class="color-row">
		<td height="35" colspan="3" align="right" style="text-align:right;">
			<cf_workcube_buttons 
			  is_upd='1' is_delete='0'
			  is_cancel='0'>
		</td>
	  </tr>
		</cfform>
		</table>
		</td>
	  </tr>
	</table>
</cfif>
<br/>
<script type="text/javascript">
function change(no)//Bu sayfa üzerinde bir kelime değiştirildiğinde,query sayfasındaki tüm kayıtları yeniden yazmasın diye sadece değişenleri tutmak için kullanılıyor.
{
	eval("document.add_lang_set.is_change"+no).value = 1;
}
function add_new_element()
{
	windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_new_module_item&strmodule=#attributes.module_name#</cfoutput>','small');
}
function sil_sub_elem(intS)
{
	windowopen('<cfoutput>#request.self#?fuseaction=settings.emptypopup_del_module_item&module_id=<cfoutput>#attributes.module_name#</cfoutput>&item_id=' + intS + '&strmodule=#attributes.module_name#</cfoutput>','small');
}
</script>
