<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.dept_id" default="">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.type") and len(attributes.type)>
<cfquery name="get_comp_id" datasource="#dsn#">
	SELECT COMP_ID FROM DEPARTMENT,BRANCH,OUR_COMPANY WHERE DEPARTMENT.DEPARTMENT_ID=#attributes.dept_id# AND OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID AND DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
</cfquery>
	<cfquery name="get_pos_req_types" datasource="#dsn#">
		SELECT 
				RELATION_SEGMENT.RELATION_ID,
				RELATION_SEGMENT.RELATION_ACTION,
				RELATION_SEGMENT.RELATION_ACTION_ID,
				RELATION_SEGMENT.RELATION_YEAR,
				POSITION_REQ_TYPE.REQ_TYPE,
				POSITION_REQ_TYPE.REQ_TYPE_ID
			FROM 
				RELATION_SEGMENT,
				POSITION_REQ_TYPE
			WHERE
				POSITION_REQ_TYPE.REQ_TYPE_ID=RELATION_SEGMENT.RELATION_FIELD_ID AND
				RELATION_SEGMENT.RELATION_TABLE='POSITION_REQ_TYPE' AND
				RELATION_ACTION=1 AND
				RELATION_SEGMENT.RELATION_ACTION_ID=#get_comp_id.COMP_ID#
				AND (POSITION_REQ_TYPE.IS_GROUP IS NULL OR POSITION_REQ_TYPE.IS_GROUP=0)
	</cfquery>
<cfelse>
	<cfquery name="get_pos_req_types" datasource="#dsn#">
		SELECT 
			POSITION_REQ_TYPE.*
		FROM 
			POSITION_REQ_TYPE
		WHERE
		<cfif isdefined('attributes.is_group') and len(attributes.is_group)>
			IS_GROUP=1
		<cfelse>
			(IS_GROUP IS NULL OR IS_GROUP = 0)
		</cfif>
		<cfif len(attributes.keyword)>
			AND REQ_TYPE LIKE '%#attributes.keyword#%'
		</cfif>
		ORDER BY
			POSITION_REQ_TYPE.REQ_TYPE
	</cfquery>
</cfif>

<cfquery name="GET_REQ_TYPE" datasource="#dsn#">
	SELECT 
		RELATION_FIELD_ID,
		RELATION_YEAR,
		IS_FILL
	FROM 
		RELATION_SEGMENT
	WHERE
		RELATION_TABLE='POSITION_REQ_TYPE' AND
		RELATION_ACTION=<cfif len(attributes.company_id)>1<cfelseif len(attributes.dept_id)>2</cfif> AND
		RELATION_ACTION_ID=<cfif len(attributes.company_id)>#attributes.company_id#<cfelseif len(attributes.dept_id)>#attributes.dept_id#</cfif>
</cfquery>
<cfif GET_REQ_TYPE.RECORDCOUNT>
	<cfset req_type_list=valuelist(GET_REQ_TYPE.RELATION_FIELD_ID,',')>
<cfelse>
	<cfset req_type_list="">
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30940.Yetkinlik Tanımları'></cfsavecontent>
<cf_medium_list_search title="#message#">
<cf_medium_list_search_area>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_pos_req_types.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform action="#request.self#?fuseaction=myhome.popup_add_perfection" method="post" name="search">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
	<input type="hidden" name="dept_id" id="dept_id" value="<cfoutput>#attributes.dept_id#</cfoutput>">
	<cfif isdefined('attributes.is_group') and len(attributes.is_group)>
	<input type="hidden" name="is_group" id="is_group" value="1">
	</cfif>
	<table>			
		<tr>
			<td><cf_get_lang dictionary_id='57460.Filtre'></td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
			</td>
			<td><cf_wrk_search_button></td>
		</tr>
	</table>
</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cfform action="#request.self#?fuseaction=myhome.emptypopup_add_perfection" method="post" name="add_perfection">
	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
	<input type="hidden" name="dept_id" id="dept_id" value="<cfoutput>#attributes.dept_id#</cfoutput>">	
<cf_medium_list>
	<thead>
		<tr>
			<th width="30" height="22"><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
			<!-- sil -->
			<th width="15"><input type="checkbox" name="all_check" id="all_check" value="1" onClick="javascript:hepsi()"></th>
			<!-- sil -->        
		</tr>
	</thead>   
	<tbody>           
		<cfif get_pos_req_types.recordcount>
		<cfoutput query="get_pos_req_types" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif GET_REQ_TYPE.IS_FILL[listfind(req_type_list,REQ_TYPE_ID,',')] neq 1><input type="hidden" value="#REQ_TYPE_ID#" name="all_req_type_ids" id="all_req_type_ids"></cfif>
				<tr>
				  <td>#currentrow#</td>				   
				  <td>#REQ_TYPE#</td>  		  
				  <!-- sil -->
						<td><input type="checkbox" value="#REQ_TYPE_ID#" name="req_type_ids" id="req_type_ids" <cfif listfind(req_type_list,REQ_TYPE_ID,',')>checked</cfif> <cfif GET_REQ_TYPE.IS_FILL[listfind(req_type_list,REQ_TYPE_ID,',')] eq 1>disabled</cfif>></td>
				 <!-- sil -->
				</tr>
			</cfoutput> 
		<cfelse>
			<tr height="20">
			  <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="3">
				<cf_workcube_buttons type_format="1">
			</td>
		</tr>
	</tfoot>
	</cf_medium_list>
</cfform>
 <cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
		<tr> 
			<td>
			<cfset url_str=''>
			<cfif isdefined('attributes.is_group') and len(attributes.is_group)>
			<cfset url_str='&is_group=#attributes.is_group#'>
			</cfif>
				<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="hr.list_position_req_type&keyword=#attributes.keyword#&company_id=#attributes.company_id#&branch_id=#attributes.branch_id#&dept_id=#attributes.dept_id##url_str#"> </td>
				<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#get_pos_req_types.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
	</cfif>
<script type="text/javascript">
function hepsi()
{
	if (document.add_perfection.all_check.checked)
		for(i=0;i<add_perfection.req_type_ids.length;i++) add_perfection.req_type_ids[i].checked = true;
	else
		for(i=0;i<add_perfection.req_type_ids.length;i++) add_perfection.req_type_ids[i].checked = false;
}
document.search.keyword.focus();
</script>
