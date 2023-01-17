<cfparam name="attributes.keyword" default="">
<cfif not isdefined('attributes.is_form_submitted')>
	<cfset arama_yapilmali = 1>
<cfelse>
	<cfset arama_yapilmali = 0>
</cfif>
<cfset url_string = "">
<cfif isdefined("attributes.field_name")>
	<cfset url_string = "#url_string#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.conf_")>
	<cfset url_string = "#url_string#&conf_=#attributes.conf_#">
</cfif>
<cfif isdefined("attributes.is_store_module")>
	<cfset url_string = "#url_string#&is_store_module=#attributes.is_store_module#">
</cfif>
<cfif not isdefined("attributes.show_all")>
	<cfset attributes.show_all = "">
</cfif>
<cfset url_string = "#url_string#&is_form_submitted=1">
<cfif arama_yapilmali>
	<cfset GET_EMPLOYEES1.recordcount = 0>
<cfelse>
	<cfinclude template="../query/get_employees1.cfm">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_employees1.recordcount#>	
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<!--- letters --->	

<cf_box title="#getLang('','Çalışanlar',58875)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_emp" action="#request.self#?fuseaction=objects.popup_list_emps#url_string#" method="post">
		<cf_box_search>
			<div class="form-group" id="item-keyword">
				<cfinput type="text" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" name="keyword">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_emp' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_employees1.recordcount>
			<cfoutput query="get_employees1" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#employee_no#</td>
				<cfquery name="CHK_EMP_POS" datasource="#dsn#">
					SELECT
						POSITION_STATUS,
						POSITION_ID
					FROM
						EMPLOYEE_POSITIONS
					WHERE
						EMPLOYEE_ID=#EMPLOYEE_ID#
				</cfquery>
				
				<cfif chk_emp_pos.recordcount>
					<cfset pos_id=chk_emp_pos.POSITION_ID>
				<cfelse>
					<cfset pos_id=0>
				</cfif>
				
				<cfquery name="GET_POS" datasource="#dsn#">
					SELECT
						*
					FROM
						EMPLOYEE_POSITIONS,
						DEPARTMENT,
						BRANCH
					WHERE
						EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
						AND
						EMPLOYEE_POSITIONS.POSITION_ID=#POS_ID#
						AND
						DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
				</cfquery>
				<td><a href="javascript://"  onclick="send_info('#employee_id#','#employee_name# #employee_surname#','#pos_id#')" class="tableyazi">#employee_name# #employee_surname#</a></td>
			</tr>
			</cfoutput>
			<cfelse>
					<tr>
					<td colspan="5"><cfif arama_yapilmali eq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
			</cfif>
		</tbody>
	</cf_grid_list>

	<cfif len(attributes.show_all)>
		<cfset url_string = "#url_string#&show_all=#attributes.show_all#">
	</cfif>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#&is_form_submitted=1">
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.popup_list_emps#url_string#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
$(document).ready(function(){
    $( "#keyword" ).focus();
});
function send_info(id,name,pos_id)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = id;
		<cfif attributes.field_id is "add_pos.conf_employee_id">
			opener.buton.style.display='';
		</cfif>
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value =name;
	</cfif>

	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
