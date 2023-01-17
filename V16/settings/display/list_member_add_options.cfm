<cfquery name="MEMBER_ADD_OPTIONS" datasource="#DSN#">
	SELECT 
    	MEMBER_ADD_OPTION_ID, 
        MEMBER_ADD_OPTION_NAME, 
        DETAIL, 
        RECORD_IP, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_INTERNET 
    FROM 
	    SETUP_MEMBER_ADD_OPTIONS
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
  	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;Üye Özel Tanım</td>
	</tr>
	<cfif member_add_options.recordcount>
        <cfoutput query="member_add_options">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><a href="#request.self#?fuseaction=settings.upd_member_add_option&member_option_id=#member_add_option_id#" class="tableyazi">#member_add_option_name#</a></td>
        </tr>
      </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
