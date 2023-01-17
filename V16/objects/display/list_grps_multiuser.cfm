<!--- 
açan penceredeki istenen alana seçilenleri kaydeder
	field_name : istenen tablo hücresine de değerler yazılabilir ama hücreye id tanımlaması yapılmalıdır
	field_id : id listesinin
--->
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submit")>
	<cfinclude template="../query/get_groups.cfm">
	<cfparam name="attributes.totalrecords" default="#get_groups.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>	
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submit")>
	<script type="text/javascript">
	function add_user(id,name)
	{
		<cfif isdefined("attributes.field_name")>
			opener.<cfoutput>#field_name#</cfoutput>.value = name;
		</cfif>
		<cfif isdefined("attributes.field_grp_id")>
			opener.<cfoutput>#field_grp_id#</cfoutput>.value =  id;
		</cfif>
		window.close();
	}
	</script>
</cfif>
<cfif not isdefined("select_list")>
	<cfset select_list = "1,2,3,4,5,6">
</cfif>
<cfscript>
	url_string = "";
	if (isdefined("attributes.function_row_name")) url_string = "#url_string#&function_row_name=#function_row_name#";
	if (isdefined("attributes.field_name")) url_string = "#url_string#&field_name=#field_name#";
	if (isdefined('attributes.to_title')) url_string = '#url_string#&to_title=#to_title#';
	if (isdefined('attributes.field_emp_id')) url_string = '#url_string#&field_emp_id=#field_emp_id#';
	if (isdefined('attributes.field_pos_id')) url_string = '#url_string#&field_pos_id=#field_pos_id#';
	if (isdefined('attributes.field_pos_code')) url_string = '#url_string#&field_pos_code=#field_pos_code#';
	if (isdefined('attributes.field_par_id')) url_string = '#url_string#&field_par_id=#field_par_id#';
	if (isdefined("attributes.field_comp_id")) url_string = "#url_string#&field_comp_id=#field_comp_id#";
	if (isdefined('attributes.field_partner_id')) url_string = '#url_string#&field_partner_id=#field_partner_id#';
	if (isdefined('attributes.field_company_id')) url_string = '#url_string#&field_company_id=#field_company_id#';
	if (isdefined('attributes.field_consumer_id')) url_string = '#url_string#&field_consumer_id=#field_consumer_id#';	
	if (isdefined('attributes.field_position_id')) url_string = '#url_string#&field_position_id=#field_position_id#';	
	if (isdefined('attributes.field_employee_id')) url_string = '#url_string#&field_employee_id=#field_employee_id#';
	if (isdefined('attributes.field_cons_id')) url_string = '#url_string#&field_cons_id=#field_cons_id#';
	if (isdefined('attributes.field_grp_id')) url_string = '#url_string#&field_grp_id=#field_grp_id#';	
	if (isdefined("attributes.field_wgrp_id")) url_string = "#url_string#&field_wgrp_id=#field_wgrp_id#";	
	if (isdefined("attributes.table_name")) url_string = "#url_string#&table_name=#table_name#";
	if (isdefined("attributes.table_row_name")) url_string = "#url_string#&table_row_name=#table_row_name#";
	if (isdefined("attributes.row_count")) url_string = "#url_string#&row_count=#row_count#";
	if (isdefined('attributes.action_name')) url_string = '#url_string#&action_name=#action_name#';
	if (isdefined('attributes.action_id')) url_string = '#url_string#&action_id=#action_id#';
	if (isdefined('attributes.sub_url')) url_string = '#url_string#&sub_url=#sub_url#';
	if (isdefined('attributes.sub_url_id')) url_string = '#url_string#&sub_url_id=#sub_url_id#';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#field_id#';
	if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#field_type#';
	if (isdefined('attributes.field_emp_mail')) url_string = '#url_string#&field_emp_mail=#field_emp_mail#';
	if (isdefined('attributes.field_pos_name')) url_string = '#url_string#&field_pos_name=#field_pos_name#';
	if (isdefined('attributes.field_code')) url_string = '#url_string#&field_code=#field_code#';
	if (isdefined('attributes.field_branch_name')) url_string = '#url_string#&field_branch_name=#field_branch_name#';
	if (isdefined('attributes.field_dep_name')) url_string = '#url_string#&field_dep_name=#field_dep_name#';
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined("attributes.url_direction")) url_string = "#url_string#&url_direction=#url_direction#";
	if (isdefined("attributes.url_params")) url_string = "#url_string#&url_params=#attributes.url_params#";
	if (isdefined("attributes.sett")) url_string = "#url_string#&sett=#sett#";
	if (isdefined("attributes.field_comp_name")) url_string = "#url_string#&field_comp_name=#field_comp_name#";
	if (isdefined('attributes.field_comp_id')) url_string = '#url_string#&field_comp_id=#field_comp_id#';
	if (isdefined("attributes.startdate")) url_string = "#url_string#&startdate=#startdate#";
	if (isdefined("attributes.finishdate")) url_string = "#url_string#&finishdate=#finishdate#";
	if (isdefined('attributes.select_list')) url_string = '#url_string#&select_list=#select_list#';
	if (isdefined("attributes.is_branch_control")) url_string = "#url_string#&is_branch_control=1";
</cfscript>
<cfsavecontent variable="head_">
	<cfoutput>
		<div class="ui-form-list flex-list">
			<div class="form-group">
				<select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
					<cfif listcontainsnocase(select_list,1)>
						<option value="#request.self#?fuseaction=objects.popup_list_positions_multiuser#url_string#"><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,2)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_pars_multiuser#url_string#">C.<cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,3)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_cons_multiuser#url_string#">C.<cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,4)>
						<option value="#request.self#?fuseaction=objects.popup_list_grps#url_string#" selected><cf_get_lang dictionary_id='32716.Gruplar'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,5)>
						<option value="#request.self#?fuseaction=objects.popup_list_pot_cons#url_string#"><cf_get_lang dictionary_id='32963.P Bireysel Üyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,6)>
						<option value="#request.self#?fuseaction=objects.popup_list_pot_pars#url_string#"><cf_get_lang dictionary_id='32964.P Kurumsal Üyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,7)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_pars_multiuser#url_string#"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
					</cfif>
					<cfif listcontainsnocase(select_list,8)>
						<option value="#request.self#?fuseaction=objects.popup_list_all_cons_multiuser#url_string#"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
					</cfif>
				</select>
			</div>
		</div>
	</cfoutput>
</cfsavecontent>

<cf_box title="#getLang('','Gruplar',32716)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_grp" action="#request.self#?fuseaction=objects.popup_list_grps_multiuser#url_string#" method="post">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<cf_box_search more="0">
			<div class="form-group">
				<cfinput type="Text" maxlength="50" value="#attributes.keyword#" name="keyword" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_grp' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cfif isdefined("attributes.keyword")>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
	</cfif>
	<tbody><cfoutput>#head_#</cfoutput></tbody>
	<cf_flat_list>
		<thead>
			<tr>
				<th colspan="2"><cf_get_lang dictionary_id='32715.Grup'></th>
			</tr>
		</thead>
		<tbody>
			<cfif isdefined("attributes.form_submit")>
				<cfif get_groups.recordcount>
					<cfoutput query="get_groups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#GROUP_NAME#</td>
						</tr>
					</cfoutput>
					<cfelse>
					<tr>
						<td height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
				<cfelse>
					<tr>
						<td height="20"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
					</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.#fusebox.fuseaction##url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#"> 
	</cfif>
</cf_box>