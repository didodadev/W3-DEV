<cfquery name="GET_COMPANY_BRANCH_RELATED" datasource="#DSN#">
	SELECT
		RELATED_ID,
		BRANCH_ID,
		OUR_COMPANY_ID
	FROM
		COMPANY_BRANCH_RELATED
	WHERE
		DEPOT_DAK IS NULL AND
	<cfif isdefined("attributes.action_id") and len(attributes.action_id)>
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	<cfelseif isdefined("attributes.action_id_2") and len(attributes.action_id_2)>
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id_2#">
	</cfif>
	ORDER BY 
		OUR_COMPANY_ID
</cfquery>

<cfif get_company_branch_related.recordcount>
	<cfset list_branches ="">
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

<cf_ajax_list>
    <tbody>
        <cfif get_company_branch_related.recordcount>
            <cfoutput query="get_company_branch_related">
                <tr>
                    <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_upd_member_branch&related_id=#related_id#');" class="tableyazi">#get_our_company_name.nick_name[listfind(list_company,our_company_id,',')]# - #get_branch_name.branch_name[listfind(list_branches,branch_id,',')]#</a></td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
