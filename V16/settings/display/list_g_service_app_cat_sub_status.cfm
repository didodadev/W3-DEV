<cfquery name="GET_SERVICE_APPCAT_SUB_STATUS_ALL" datasource="#DSN#">
	SELECT 
		SSS.SERVICE_SUB_STATUS_ID,
		SSS.SERVICE_SUB_CAT_ID,  
		SSS.SERVICE_SUB_STATUS SERVICE_SUB_STATUS,
		SAS.SERVICE_SUB_CAT SERVICE_SUB_CAT,
		SA.SERVICECAT SERVICECAT
	FROM
		G_SERVICE_APPCAT_SUB_STATUS SSS, 
		G_SERVICE_APPCAT_SUB SAS,
		G_SERVICE_APPCAT SA
	WHERE 
		SAS.SERVICE_SUB_CAT_ID = SSS.SERVICE_SUB_CAT_ID AND
		SA.SERVICECAT_ID = SAS.SERVICECAT_ID
	UNION ALL
	SELECT 
		SSS.SERVICE_SUB_STATUS_ID,
		SSS.SERVICE_SUB_CAT_ID,  
		SSS.SERVICE_SUB_STATUS,
		'' SERVICE_SUB_CAT,
		'' SERVICECAT 
	FROM
		G_SERVICE_APPCAT_SUB_STATUS SSS
	WHERE 
		SSS.SERVICE_SUB_CAT_ID IS NULL
	ORDER BY
		SERVICECAT,
		SERVICE_SUB_CAT,
		SERVICE_SUB_STATUS
</cfquery>
<table>
	<cfif get_service_appcat_sub_status_all.recordcount>
		<cfoutput query="get_service_appcat_sub_status_all">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_g_service_app_cat_sub_status&service_sub_status_id=#service_sub_status_id#" class="tableyazi">#servicecat# - #service_sub_cat# - #service_sub_status#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
