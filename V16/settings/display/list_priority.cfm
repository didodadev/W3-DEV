<cfquery name="PRIORITIES" datasource="#dsn#">
	SELECT 
	    PRIORITY_ID, 
        #dsn#.Get_Dynamic_Language(PRIORITY_ID,'#session.ep.language#','SETUP_PRIORITY','PRIORITY',NULL,NULL,PRIORITY) AS PRIORITY, 
        COLOR, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_PRIORITY
</cfquery>		
<table width="135" cellpadding="0" cellspacing="0" border="0">
   <cfif priorities.recordcount>
		<cfoutput query="priorities">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380">&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_priority&ID=#priority_ID#" class="tableyazi">#priority#</a></td>
            </tr>
        </cfoutput>
     <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>		