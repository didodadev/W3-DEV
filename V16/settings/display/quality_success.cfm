<cfquery name="GET_QUALITY_SUCCESS" datasource="#dsn3#">
	SELECT 
			IS_SUCCESS_TYPE,
			#dsn_alias#.Get_Dynamic_Language(SUCCESS_ID,'#session.ep.language#','QUALITY_SUCCESS','SUCCESS',NULL,NULL,SUCCESS) AS SUCCESS,*
	FROM 
		QUALITY_SUCCESS
</cfquery>
<table>
	<cfif GET_QUALITY_SUCCESS.RecordCount>
		<cfoutput query="get_quality_success">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.add_production_quality_success&event=upd&id=#success_id#" class="tableyazi">#success#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
	</tr>
</cfif>
</table>