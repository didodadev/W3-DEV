<cfquery name="COMPANYCATS" datasource="#DSN#">
	SELECT 
    	COMPANYCAT_ID, 
		#dsn#.Get_Dynamic_Language(COMPANYCAT_ID,'#session.ep.language#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANYCAT) AS COMPANYCAT,
        DETAIL, 
        IS_ACTIVE, 
        COMPANYCAT_TYPE, 
        IS_VIEW, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    COMPANY_CAT 
    ORDER BY 
    	COMPANYCAT
</cfquery>
<table>
	<cfif companyCats.recordcount>
		<cfoutput query="companyCats">
			<tr>
				<td width="20" class="text-right"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_company_cat&ID=#companyCat_ID#" class="tableyazi">#companyCat#</a></td>
			</tr>
  		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" class="text-right"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
 	</cfif>
</table>
