<cfquery name="GET_CONTENT_RELATION" datasource="#DSN#">
	SELECT 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.USER_FRIENDLY_URL,
		C.CONTENT_PROPERTY_ID
	FROM 
		CONTENT_RELATION CR,
		CONTENT C
	WHERE 
		C.CONTENT_STATUS = 1 AND
		C.STAGE_ID = -2 AND 
		CR.ACTION_TYPE = 'PROJECT_ID' AND
		CR.CONTENT_ID = C.CONTENT_ID AND
		CR.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
</cfquery>
<cfif get_content_relation.recordcount>
	<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
		<cfoutput query="get_content_relation">
			<tr style="height:20px;">
				<td><a href="#url_friendly_request('objects2.detail_content&cid=#content_id#','#user_friendly_url#')#" class="tableyazi">#cont_head#</a></td>
		  	</tr>
		</cfoutput>
	</table>
</cfif>
