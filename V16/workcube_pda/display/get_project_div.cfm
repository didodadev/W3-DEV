<cfsetting showdebugoutput="no">
<cfset attributes.project_id = trim(attributes.project_id)>
<cfquery name="GET_PROJECTS" datasource="#DSN#">
	SELECT 
    	P.PROJECT_ID,
		P.PROJECT_HEAD,
        P.PROJECT_NUMBER
	FROM 
		PRO_PROJECTS P
   	<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
		WHERE 
			P.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.project_id#%">
	</cfif>
</cfquery>
<cf_box title="Projeler" body_style="overflow-y:scroll;height:100px;" call_function="gizle(project_div);">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
		<tr class="color-border">
			<td>
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
					<tr class="color-header" style="height:22px;">		
						<td class="form-title" style="width:150px;">Proje Numarası</td>
						<td class="form-title">Proje Adı</td>
					</tr>
					<cfif get_projects.recordcount>
						<cfoutput query="get_projects">		
							<tr class="color-row" style="height:20px;">
								<td>#project_number#</td>
								<td><a href="javascript://" class="tableyazi"  onClick="add_project_div('#project_id#','#project_head#')">#project_head#</a></td>
							</tr>		
						</cfoutput>
					<cfelse>
						<tr class="color-row" style="height:20px;">
							<td colspan="3">Kayıt Bulunamadı !</td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>
	</table>
</cf_box>
