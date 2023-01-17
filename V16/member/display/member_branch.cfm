<cfquery name="GET_COMPANY_BRANCH_RELATED" datasource="#DSN#">
	SELECT
		RELATED_ID,
		BRANCH_ID,
		OUR_COMPANY_ID
	FROM
		COMPANY_BRANCH_RELATED
	WHERE
		DEPOT_DAK IS NULL AND
	<cfif isdefined("attributes.cpid") and len(attributes.cpid)>
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	<cfelseif isdefined("attributes.cid") and len(attributes.cid)>
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
	</cfif>
	ORDER BY 
		OUR_COMPANY_ID
</cfquery>
<cfif get_company_branch_related.recordcount>
	<cfset list_branches = "">
	<cfset list_company = "">
	<cfoutput query="get_company_branch_related">
		<cfif len(branch_id) and not listfind(list_branches,branch_id)>
			<cfset list_branches=listappend(list_branches,branch_id)>
		</cfif>
		<cfif len(our_company_id) and not listfind(list_company,our_company_id)>
			<cfset list_company=listappend(list_company,our_company_id)>
		</cfif>
	</cfoutput>
	<cfif len(list_branches)>
		<cfquery name="GET_BRANCH_NAME" datasource="#DSN#">
			SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#list_branches#) ORDER BY BRANCH_ID
		</cfquery>
		<cfset list_branches = listsort(listdeleteduplicates(valuelist(get_branch_name.branch_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(list_company)>
		<cfquery name="GET_OUR_COMPANY_NAME" datasource="#DSN#">
			SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY WHERE COMP_ID IN (#list_company#) ORDER BY COMP_ID
		</cfquery>
		<cfset list_company = listsort(listdeleteduplicates(valuelist(get_our_company_name.comp_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
	<tr class="color-header" height="22"> 
		<td class="form-title" width="99%" style="cursor:pointer;" onclick="gizle_goster(related_branch);"><cf_get_lang dictionary_id='57895.Şube İlişkisi'></td>
		<td  width="15">
			<cfif isdefined("attributes.cid") and len(attributes.cid)>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_add_member_branch&cid=#attributes.cid#</cfoutput>','small','popup_add_member_branch');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="absmiddle"></a>
			<cfelseif isdefined("attributes.cpid") and len(attributes.cpid)>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_add_member_branch&cpid=#attributes.cpid#</cfoutput>','small','popup_add_member_branch');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>" align="absmiddle"></a>
			</cfif>
		</td>
	</tr>
	<tr class="color-row" id="related_branch">
		<td colspan="2" height="20"> 
		<table width="100%" cellpadding="0" cellspacing="0">
			<cfif get_company_branch_related.recordcount>
				<cfoutput query="get_company_branch_related">
					<tr>
						<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_upd_member_branch&related_id=#related_id#','small','popup_upd_member_branch');" class="tableyazi">#get_our_company_name.nick_name[listfind(list_company,our_company_id,',')]# - #get_branch_name.branch_name[listfind(list_branches,branch_id,',')]#</a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</table>
		</td>
	</tr>
</table>
