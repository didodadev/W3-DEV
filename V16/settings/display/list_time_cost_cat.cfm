<cfquery name="time_cost_cat" datasource="#dsn#">
	SELECT
		TIME_COST_CAT_ID, 
		TIME_COST_CAT,
		COLOUR,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP
	FROM 
		TIME_COST_CAT
</cfquery>
<table>
	<cfif time_cost_cat.recordcount>
		<cfoutput query="time_cost_cat">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="170"><a href="#request.self#?fuseaction=settings.form_upd_time_cost_cat&id=#time_cost_cat_id#" class="tableyazi">#time_cost_cat#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
