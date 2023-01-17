<cfquery name="get_acc_type" datasource="#dsn#">
	SELECT 
    	*,
        #dsn#.Get_Dynamic_Language(ACC_TYPE_ID,'#session.ep.language#','SETUP_ACC_TYPE','ACC_TYPE_NAME',NULL,NULL,ACC_TYPE_NAME) AS acc_type_name_new
    FROM 
	    SETUP_ACC_TYPE 
    ORDER BY 
    	ACC_TYPE_NAME
</cfquery>
<table>
	<cfif get_acc_type.recordcount>
		<cfoutput query="get_acc_type">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_add_acc_type&acc_type_id=#acc_type_id#" class="tableyazi">#acc_type_name_new#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td colspan="380"><cf_get_lang_main dictionary_id='57484.Kayıt Yok'></td>
        </tr>
    </cfif>
</table>
