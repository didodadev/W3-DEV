<cfquery name="SALES_ADD_OPTIONS" datasource="#DSN3#">
	SELECT 
	    SALES_ADD_OPTION_ID, 
        SALES_ADD_OPTION_NAME, 
        IS_INTERNET, 
        DETAIL, 
        RECORD_IP,
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_SALES_ADD_OPTIONS
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='43077.Satış Özel Tanım'></td>
	</tr>
	<cfif sales_add_options.recordcount>
        <cfoutput query="sales_add_options">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><a href="#request.self#?fuseaction=settings.upd_sales_add_option&sale_option_id=#sales_add_option_id#" class="tableyazi">#sales_add_option_name#</a></td>
        </tr>
      </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

