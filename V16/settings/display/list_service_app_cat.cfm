<cfquery name="SERVICECATS" datasource="#dsn3#">
	SELECT 
	    SERVICECAT_ID, 
        SERVICECAT, 
        IS_INTERNET, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SERVICE_APPCAT
</cfquery>		
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='178.Servis Başvuru Kategorileri'></td>
    </tr>
    <cfif serviceCats.recordcount>
		<cfoutput query="serviceCats">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_service_app_cat&ID=#serviceCat_ID#" class="tableyazi">#serviceCat#</a></td>
            </tr>
		</cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
