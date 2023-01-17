<cfquery NAME="GET_VISION_TYPE_LIST" datasource="#DSN#">
	SELECT
		VISION_TYPE_ID,
		#dsn#.Get_Dynamic_Language(VISION_TYPE_ID,'#session.ep.language#','SETUP_VISION_TYPE','VISION_TYPE_NAME',NULL,NULL,VISION_TYPE_NAME) AS VISION_TYPE_NAME
	FROM 
		SETUP_VISION_TYPE
</cfquery> 
<table>
	<cfif GET_VISION_TYPE_LIST.RECORDCOUNT>
	<cfoutput query="GET_VISION_TYPE_LIST">
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_vision_type&vision_type_id=#VISION_TYPE_ID#" class="tableyazi">#VISION_TYPE_NAME#</a></td>
		</tr>
	</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
	</cfif> 
</table>
