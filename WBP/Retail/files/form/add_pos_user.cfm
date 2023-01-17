<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='995.Yazar Kasa Kullanıcı Ekle'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_pos" id="add_pos" method="post" action="">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-employee_status">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57756.Durum'></label>
					<div class="col col-8 col-sm-12">
						<label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="employee_status" value="1" checked="checked"/></label>
					</div>
				</div>
				<div class="form-group" id="item-branch_id">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
					<div class="col col-8 col-sm-12">
						<cfsavecontent  variable="message"><cf_get_lang dictionary_id='30126.Şube Seçiniz'>!</cfsavecontent>
						<cfselect name="branch_id" id="branch_id" style="width:200px;" required="yes" message="#message#">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="branches">
								<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
							</cfoutput>
						</cfselect>
					</div>
				</div>
				<div class="form-group" id="item-employee_name">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30368.Çalışan'> *</label>
					<div class="col col-8 col-sm-12">
						<div class="input-group">
							<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined('attributes.employee_id') and len(attributes.employee_name)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
							<input type="text" name="employee_name" value=""  id="employee_name" style="width:200px;" autocomplete="off" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_NAME,MEMBER_ID,MEMBER_ID','employee_name,employee_id,username','emp_puantaj','3','300');">
							<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_emps&is_period_kontrol=0&field_location=service&field_emp_id=add_pos.employee_id&field_name=add_pos.employee_name&field_id=add_pos.username&select_list=1</cfoutput>');"></span> 
						</div>								
					</div>
				</div>
				<div class="form-group" id="item-username">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58522.Kullanıcı Kodu'></label>
					<div class="col col-8 col-sm-12">
						<cfinput type="text" value="" name="username" maxlength="50" style="width:200px;" readonly="yes">
					</div>
				</div>
				<div class="form-group" id="item-password">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57552.Şifre'> *</label>
					<div class="col col-8 col-sm-12">
						<cfinput type="text" value="" name="password" maxlength="50" style="width:200px;">
					</div>
				</div>
				<div class="form-group" id="item-pos_type">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='38925.Kullanıcı Tipi'></label>
					<div class="col col-8 col-sm-12">
						<cfselect name="pos_type" id="pos_type" style="width:200px;">
							<option value="1"><cf_get_lang dictionary_id='29511.Yönetici'></option>
							<option value="2"><cf_get_lang dictionary_id='61713.Standart Kullanıcı'></option>
						</cfselect>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="kontrol()">
		</cf_box_footer>
	</cfform>
</cf_box>

<script>
function kontrol()
{
	if(document.getElementById('branch_id').value == '')
	{
		alert('Şube Seçiniz');
		return false;	
	}
	
	if(document.getElementById('employee_id').value == '')
	{
		alert('Çalışan Seçiniz');
		return false;	
	}
	
	if(document.getElementById('password').value == '')
	{
		alert('Şifre Giriniz');
		return false;	
	}
	return true;
}
</script>
