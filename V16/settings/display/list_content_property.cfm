<cfquery name="CONTENT_PROPERTY" datasource="#dsn#">
	SELECT 
    	CONTENT_PROPERTY_ID, 
        #dsn#.Get_Dynamic_Language(CONTENT_PROPERTY_ID,'#session.ep.language#','CONTENT_PROPERTY','NAME',NULL,NULL,NAME) AS NAME,
        DESCRIPTION, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    CONTENT_PROPERTY 
    ORDER BY 
    	NAME
</cfquery>
<table>
	<cfif content_property.recordcount>
		<cfoutput query="content_property">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_content_property&content_property_id=#content_property_id#" class="tableyazi">#name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>

        </tr>
    </cfif>
</table>
