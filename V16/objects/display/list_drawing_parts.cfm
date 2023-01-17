<cfparam name="attributes.is_status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.url_str" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined('attributes.form_submitted')>
	<cfquery name="GET_DPL" datasource="#DSN3#">
		SELECT
			DP.DPL_ID,
			DP.DPL_NO,
			DP.IS_ACTIVE,
			DP.STAGE_ID,
			PTR.STAGE,
			PP.PROJECT_HEAD
		FROM 
			DRAWING_PART DP
			LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = DP.STAGE_ID
			LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = DP.PROJECT_ID
		WHERE	
			1 = 1
			<cfif len(attributes.keyword)> 
				AND DPL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif len(attributes.project_id) and len(attributes.project_head)> 
				AND DP.PROJECT_ID = #attributes.project_id#
			</cfif>
			<cfif attributes.is_status eq 1>AND IS_ACTIVE = 1<cfelseif attributes.is_status eq 0>AND IS_ACTIVE = 0</cfif>
		ORDER BY
			DP.DPL_NO DESC
	</cfquery>
<cfelse>
	<cfset GET_DPL.recordCount = 0>
</cfif>	
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_DPL.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','DPL',32595)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_dpl" method="post" action="#request.self#?fuseaction=objects.popup_list_drawing_parts&#url_str#"> 
		<cf_box_search more="0">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<div class="form-group" id="item-keyword">
				<cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
			</div>
			<div class="form-group" id="item-project_id">
				<div class="input-group">
					<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
					<input type="text" name="project_head"  id="project_head" placeholder="<cfoutput>#getLang('','Proje',57416)#</cfoutput>" value="<cfoutput>#attributes.project_head#</cfoutput>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
					<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_dpl.project_id&project_head=search_dpl.project_head');"></span>
				</div>
			</div>	
			<div class="form-group" id="item-is_status">
				<select name="is_status" id="is_status">
					<option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					<option value="" <cfif attributes.is_status eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
				</select>
			</div>	
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1," required="yes" maxlength="3" onKeyUp="isNumber(this)">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_dpl' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_flat_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='32604.DPL No'></th>
				<th><cf_get_lang dictionary_id='57416.proje'></th>
				<th><cf_get_lang dictionary_id='34963.Sre'></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_DPL.recordcount>
				<cfoutput query="GET_DPL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><a href="javascript://" onClick="add_dpl('#dpl_id#','#dpl_no#');" class="tableyazi">#dpl_no#</a></td>
						<td>#project_head#</td>
						<td>#stage#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td height="20" colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayit Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>

	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.is_status)>
			<cfset url_str = "#url_str#&is_status=#attributes.is_status#">
		</cfif>
		<cfif len(attributes.project_id) and len(attributes.project_head)>
			<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#attributes.project_head#">
		</cfif>
		<cfif isdefined("attributes.call_function") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&call_function=#attributes.call_function#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_list_drawing_parts&form_submitted=1#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
document.getElementById('keyword').focus();
function add_dpl(field_id,field_name)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document.all</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = field_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener.document.all</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = field_name;
	</cfif>
	<cfif isdefined("attributes.call_function")>
		try{<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.call_function#</cfoutput>;}
			catch(e){};
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
