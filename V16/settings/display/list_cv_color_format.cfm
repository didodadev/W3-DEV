<cfquery name="get_cv_status" datasource="#dsn#">
	SELECT 
	    STATUS_ID, 
        ICON_NAME, 
        #dsn#.Get_Dynamic_Language(STATUS_ID,'#session.ep.language#','SETUP_CV_STATUS','STATUS',NULL,NULL,STATUS) AS STATUS, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_CV_STATUS
</cfquery>
<table>
    <cfif get_cv_status.recordcount>
		<cfoutput query="get_cv_status">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.upd_del_cv_color_format&file_status_id=#STATUS_ID#" class="tableyazi">#STATUS# <cfif len(detail)> -#DETAIL# </cfif></a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
