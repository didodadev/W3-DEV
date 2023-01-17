<cfquery name="get_service_appcat_all" datasource="#dsn#">
	SELECT SERVICECAT_ID, SERVICECAT FROM G_SERVICE_APPCAT
</cfquery>		
<table>
	<cfif get_service_appcat_all.recordcount>
		<cfoutput query="get_service_appcat_all">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_g_service_app_cat&servicecat_id=#servicecat_id#" class="tableyazi">#servicecat#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>


