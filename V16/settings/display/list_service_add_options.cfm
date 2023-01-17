<cfquery name="SERVICE_ADD_OPTIONS" datasource="#DSN3#">
	SELECT SERVICE_ADD_OPTION_ID,SERVICE_ADD_OPTION_NAME FROM SETUP_SERVICE_ADD_OPTIONS
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1094.Satış Özel Tanım'></td>
	</tr>
<cfif servıce_add_options.recordcount>
	<cfoutput query="servıce_add_options">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><a href="#request.self#?fuseaction=settings.upd_service_add_option&service_option_id=#service_add_option_id#" class="tableyazi">#service_add_option_name#</a></td>
        </tr>
	</cfoutput>
<cfelse>
	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
  	</tr>
</cfif>
</table>

