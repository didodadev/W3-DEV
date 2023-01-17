<cfquery name="SERVICECODES" datasource="#dsn3#">
    SELECT 
	    SERVICE_CODE_ID, 
        #dsn#.Get_Dynamic_Language(SERVICE_CODE_ID,'#session.ep.language#','SETUP_SERVICE_CODE','SERVICE_CODE',NULL,NULL,SERVICE_CODE) AS SERVICE_CODE
    FROM 
    	SETUP_SERVICE_CODE
    ORDER BY
    	SERVICE_CODE
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<cfif SERVICECODES.recordcount>
		<cfoutput query="SERVICECODES">
            <tr>
               <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="180">&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_service_defect_code&SERVICE_CODE_ID=#SERVICE_CODE_ID#" >#SERVICE_CODE#</a></td>
        	</tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
