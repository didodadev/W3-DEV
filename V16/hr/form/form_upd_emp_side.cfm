<!--- Fotoğraf --->
<cf_box id="emp_photo" closable="0" collapsable="0">
	<table align="center" width="100%">
		<tr>
			<td style="text-align:center;">
				<cfif len(get_hr.photo)>
					<cf_get_server_file output_file="hr/#get_hr.photo#" output_server="#get_hr.photo_server_id#" output_type="0" image_width="120" image_height="160">
				<cfelse>
					<cfif get_hr.sex eq 1>
						<img src="/images/male.jpg" title="<cf_get_lang dictionary_id='58546.Yok'>" style="width:150px;">
					<cfelse>
						<img src="/images/female.jpg" title="<cf_get_lang dictionary_id='58546.Yok'>" style="width:150px;">
					</cfif>
				</cfif>
			</td>
		</tr>
	</table>
</cf_box>
<!--- Belgeler --->
<cf_get_workcube_asset asset_cat_id="-8" module_id='3' action_section='EMPLOYEE_ID' action_id='#emp_id#'>
<!--- Notlar --->
<cf_get_workcube_note action_section='EMPLOYEE_ID' action_id='#emp_id#' style='0'>
<!--- Banka Hesapları --->
<cf_get_workcube_bank_account action_type='EMPLOYEE' action_id="#attributes.employee_id#">
<!--- İzinler --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='55143.İzinler'></cfsavecontent>
<cfsavecontent variable="izin_listesi"><cf_get_lang dictionary_id ='56371.İzin Listesi'></cfsavecontent>
<cf_box 
	id="emp_offtimes" 
    closable="0" 
    collapsed="1" 
    unload_body="1"
    title="#message#" 
    info_title="#izin_listesi#" 
    info_href="#request.self#?fuseaction=hr.list_offtime&employee_id=#emp_id#" 
    add_href_size="medium" 
    add_href_2="#request.self#?fuseaction=ehesap.offtimes&event=add&employee_id=#emp_id#"
    box_page="#request.self#?fuseaction=hr.form_emp_side_ajax&employee_id=#attributes.employee_id#">
</cf_box>
<!--- Varlıklar --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57420.Varlıklar'></cfsavecontent>
<cf_box 
	id="emp_assetp" 
    closable="0" 
    collapsed="1" 
    unload_body="1"
    title="#message#"
    add_href_size="page" 
    add_href="#request.self#?fuseaction=correspondence.popup_add_assetp_demand"
    box_page="#request.self#?fuseaction=hr.emp_assetp_ajax&employee_id=#attributes.employee_id#">
</cf_box>
<!---Değerlendirme formları --->
<cf_get_workcube_form_generator action_type='8,6,10' related_type='8,6,10' action_type_id='#attributes.employee_id#' design='3'>
<!--- Hedefler --->
<cfif get_position.recordcount>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57964.Hedefler'></cfsavecontent>
	<cf_box 
        id="emp_goals" 
        closable="0" 
        unload_body="1" 
        collapsed="1" 
        title="#message#" 
        add_href="javascript:windowopen('#request.self#?fuseaction=hr.targets&event=add&position_code=#get_position.position_code#','page');"
        box_page="#request.self#?fuseaction=hr.targets_ajax&employee_id=#attributes.employee_id#">
	</cf_box>
</cfif>
<!--- Disiplin işlemleri --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='56370.Disiplin İşlemleri'></cfsavecontent>
<cf_box 
	id="emp_cautions" 
    unload_body="1"
    closable="0" 
    collapsed="1" 
    title="#message#"
    add_href="#request.self#?fuseaction=ehesap.list_caution&event=add"
    box_page="#request.self#?fuseaction=hr.form_discipline_ajax&employee_id=#attributes.employee_id#">
</cf_box>
<!--- Ödüller --->
<cfinclude template="../query/get_employee_prizes.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='55462.Ödüller'></cfsavecontent>
<cf_box
	id="emp_prizes"
    unload_body="1" 
    closable="0" 
    collapsed="1" 
    title="#message#"
    add_href="javascript:openBoxDraggable('#request.self#?fuseaction=ehesap.list_prizes&event=add&prize_to_id=#attributes.employee_id#&prize_to=#ToString(employee)#&from_fuseaction=#attributes.fuseaction#','add_prize_box')"
	box_page="#request.self#?fuseaction=hr.form_awards_ajax&employee_id=#attributes.employee_id#">
</cf_box>
<!--- Yetkinlikler --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58709.Yetkinlikler'></cfsavecontent>
<cf_box
	id="emp_competencies" 
    unload_body="1"
    closable="0" 
    collapsed="1" 
    title="#message#"
    info_href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.form_competencies_ajax&employee_id=#attributes.employee_id#&type=2','competencies_box','ui-draggable-box-medium')"
	box_page="#request.self#?fuseaction=hr.form_competencies_ajax&employee_id=#attributes.employee_id#&type=1">
</cf_box>
<!--- Sözleşmeler --->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='55816.Sözleşmeler'></cfsavecontent>
<cf_box 
	id="emp_contracts" 
    unload_body="1"
    closable="0" 
    collapsed="1" 
    title="#message#"
	box_page="#request.self#?fuseaction=hr.form_contract_ajax&employee_id=#attributes.employee_id#">
</cf_box>
<!--- İlişkili çalışanlar --->
<cfsavecontent variable="text"><cf_get_lang dictionary_id='56347.İlişkili Çalışanlar'></cfsavecontent>
<cfset add_href = "openBoxDraggable('#request.self#?fuseaction=hr.popup_form_upd_worker&employee_id=#attributes.employee_id#')">
<cf_box
	id="related_employees"
	closable="0"
	collapsed="1"
	title="#text#"
    unload_body="1"
    add_href="#add_href#"
    add_href_size="medium"
    box_page="#request.self#?fuseaction=hr.employee_team&employee_id=#attributes.employee_id#">
</cf_box>    
<!---<cfinclude template="../display/employee_team.cfm">--->
