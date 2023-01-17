<cfquery name="get_service_appcat_sub_all" datasource="#dsn#">
	SELECT
		SAS.SERVICE_SUB_CAT_ID, 
		SAS.SERVICE_SUB_CAT,
		SAS.SERVICECAT_ID,
        SAS.OUR_COMPANY_ID, 
		'' SERVICECAT 
	FROM 
		G_SERVICE_APPCAT_SUB SAS
	WHERE
		SAS.SERVICECAT_ID IS NULL
	UNION ALL
	SELECT
		SAS.SERVICE_SUB_CAT_ID, 
		SAS.SERVICE_SUB_CAT,
		SAS.SERVICECAT_ID, 
        SAS.OUR_COMPANY_ID,
		SA.SERVICECAT SERVICECAT 
	FROM 
		G_SERVICE_APPCAT_SUB SAS ,
		G_SERVICE_APPCAT SA 
	WHERE
		SA.SERVICECAT_ID = SAS.SERVICECAT_ID
	ORDER BY	
		SERVICECAT,
		SAS.SERVICE_SUB_CAT		
</cfquery>
<table>
	<cfif get_service_appcat_sub_all.recordcount>
		<cfoutput query="get_service_appcat_sub_all">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_g_service_app_cat_sub&service_cat_sub_id=#service_sub_cat_id#" class="tableyazi">#servicecat# - #service_sub_cat#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
