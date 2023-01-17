<cfquery name="PACKAGES" datasource="#dsn#">
	SELECT 
    	PACKAGE_TYPE_ID, 
        #dsn#.Get_Dynamic_Language(PACKAGE_TYPE_ID,'#session.ep.language#','SETUP_PACKAGE_TYPE','PACKAGE_TYPE',NULL,NULL,PACKAGE_TYPE) AS PACKAGE_TYPE,
        CALCULATE_TYPE_ID, 
        DETAIL, 
        DIMENTION, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_PACKAGE_TYPE
</cfquery>
<table>
	<cfif PACKAGES.RecordCount>
		<cfoutput query="PACKAGES">
            <tr>
				<td width="20" class="text-right"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_package_type&type_id=#PACKAGE_TYPE_ID#" class="tableyazi">#PACKAGE_TYPE#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" class="text-right"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
    </cfif>
</table>
