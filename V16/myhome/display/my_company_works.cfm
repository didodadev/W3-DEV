<cfsetting showdebugoutput="no">
<cfquery name="GET_WORKS_LIST" datasource="#DSN#">
	SELECT
		PRO_WORKS.WORK_ID,
		PRO_WORKS.WORK_HEAD,
		PRO_WORKS.PROJECT_ID,
		PRO_WORKS.COMPANY_PARTNER_ID,
		PRO_WORKS.WORK_CURRENCY_ID,
		PRO_WORKS.TARGET_FINISH,
		PRO_WORKS.WORK_STATUS
	FROM 
		PRO_WORKS,
		PRO_WORK_CAT,
		SETUP_PRIORITY
	WHERE 
		PRO_WORK_CAT.WORK_CAT_ID = PRO_WORKS.WORK_CAT_ID AND
		PRO_WORKS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> AND
		PRO_WORKS.WORK_PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID
	ORDER BY
		PRO_WORKS.TARGET_FINISH
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_works_list.recordcount#">
<cf_ajax_list>
	<thead>
		 <tr>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			<th><cf_get_lang dictionary_id='57416.Proje'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
		  </tr>
	 </thead>
	  <cfif get_works_list.recordcount>
		<cfset pro_name_list = "">
		<cfset project_stage_list = "">
	  <cfoutput query="get_works_list" startrow="1" maxrows="#attributes.maxrows#">
		<cfif len(project_id) and not listfind(pro_name_list,project_id)>
			<cfset pro_name_list=listappend(pro_name_list,project_id)>
		</cfif>
		<cfif len(work_currency_id) and not listfind(project_stage_list,work_currency_id)>
			<cfset project_stage_list=listappend(project_stage_list,work_currency_id)>
		</cfif>
	  </cfoutput>
	  <cfif len(pro_name_list)>
		<cfquery name="get_pro_name" datasource="#dsn#">
			SELECT
				PROJECT_HEAD,
				PROJECT_ID
			FROM
				PRO_PROJECTS
			WHERE
				PROJECT_ID IN (#pro_name_list#)
			ORDER BY
				PROJECT_ID
		</cfquery>
		<cfset pro_name_list = listsort(listdeleteduplicates(valuelist(get_pro_name.project_id,',')),'numeric','ASC',',')>
	  </cfif>
		<cfif len(project_stage_list)>
			<cfset project_stage_list = listsort(project_stage_list,'numeric','ASC',',')>
			<cfquery name="get_currency_name" datasource="#dsn#">
				SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#project_stage_list#) ORDER BY PROCESS_ROW_ID
			</cfquery>
			<cfset project_stage_list = listsort(listdeleteduplicates(valuelist(get_currency_name.process_row_id,',')),'numeric','ASC',',')>
		</cfif>
	  <cfoutput query="get_works_list" startrow="1" maxrows="#attributes.maxrows#">
	  <tbody>
		  <tr>
			<td width="15">#currentrow#</td>
			<td>#dateformat(target_finish,dateformat_style)#</td>
			<td><a href="#request.self#?fuseaction=project.works&event=det&id=#WORK_ID#" class="tableyazi" >#work_head#</a></td>
			<td><cfif len(PROJECT_ID)>
					#get_pro_name.project_head[listfind(pro_name_list,project_id,',')]#
				<cfelse>
					<cf_get_lang dictionary_id='58459.Projesiz'>
				</cfif>
			</td>
			<td>#get_currency_name.stage[listfind(project_stage_list,work_currency_id,',')]#</td>
			<td><cfif WORK_STATUS eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelseif WORK_STATUS eq 0><cf_get_lang dictionary_id='57494.Pasif'></cfif>
			</td>
		  </tr>
	  </tbody>
	  </cfoutput>
	  <cfelse>
		  <tr>
			<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		  </tr>
	  </cfif>
</cf_ajax_list>
