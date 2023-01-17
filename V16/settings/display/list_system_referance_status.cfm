<cfquery name="GET_REFERANCE_STATUS" datasource="#dsn3#">
    SELECT 
	    REFERANCE_STATUS_ID, 
        REFERANCE_STATUS
    FROM 
    	SETUP_REFERANCE_STATUS
</cfquery>		
<table>
	<cfif GET_REFERANCE_STATUS.recordcount>
		<cfoutput query="GET_REFERANCE_STATUS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_system_referance&id=#REFERANCE_STATUS_ID#" class="tableyazi">#REFERANCE_STATUS#</a></td>
        	</tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
