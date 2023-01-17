<cfquery name="GET_BANK_TYPES" datasource="#dsn#">
	SELECT 
	    BANK_ID, 
        BANK_NAME, 
        DETAIL, 
        COMPANY_ID, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        EXPORT_TYPE,
        BANK_CODE, 
        FTP_SERVER_NAME,
        FTP_FILE_PATH, 
        FTP_USERNAME, 
        FTP_PASSWORD 
    FROM 
    	SETUP_BANK_TYPES
</cfquery>
<style>
    table td{padding:2px 0;}
</style>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <cfif GET_BANK_TYPES.recordcount>
		<cfoutput query="GET_BANK_TYPES">
            <tr>
                <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_bank_type&bank_id=#bank_id#" class="tableyazi">#bank_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
