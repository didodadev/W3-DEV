<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="get_row" datasource="#dsn_dev#">
	SELECT * FROM POS_USERS WHERE ROW_ID = #attributes.row_id#
</cfquery>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='996.Yazar Kasa Kullanıcı Güncelle'></cfsavecontent>
<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=retail.emptypopup_upd_pos">		
		<cfinput type="hidden" id="row_id" name="row_id" value="#attributes.row_id#">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57756.Durum'></label>
					<div class="col col-8 col-sm-12">
						<input type="checkbox" name="employee_status" value="1" <cfif get_row.employee_status eq 1>checked="checked"</cfif>/> <cf_get_lang dictionary_id='57493.Aktif'>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang_main no='41.Şube'> *</label>
					<div class="col col-8 col-sm-12">
						<cfselect name="branch_id" id="branch_id" style="width:200px;" required="yes" message="Şube Seçiniz!">
						<option value=""><cf_get_lang_main no='322.Seciniz'></option>
						<cfoutput query="branches">
							<option value="#branch_id#" <cfif get_row.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
						</cfoutput>
						</cfselect>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
					<div class="col col-8 col-sm-12">
						<cfinput type="hidden" id="employee_id" name="employee_id" value="#get_row.employee_id#">
						<cfinput type="text" name="employee_name" value="#get_emp_info(get_row.employee_id,0,0)#" id="employee_name" style="width:200px;" autocomplete="off" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_NAME,MEMBER_ID,MEMBER_ID','employee_name,employee_id,username','emp_puantaj','3','300');">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58522.Kullanıcı Kodu'></label>
					<div class="col col-8 col-sm-12"><cfinput type="text" value="#get_row.username#" name="username" maxlength="50" style="width:200px;" readonly="yes"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57552.Şifre'> *</label>
					<div class="col col-8 col-sm-12"><cfinput type="text" value="#get_row.password#" name="password" maxlength="50" style="width:200px;"></div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='38925.Kullanıcı Tipi'></label>
					<div class="col col-8 col-sm-12">
						<cfselect name="pos_type" id="pos_type" style="width:200px;">
							<option value="1" <cfif get_row.pos_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29511.Yönetici'></option>
							<option value="2" <cfif get_row.pos_type eq 2>selected</cfif>><cf_get_lang dictionary_id='61713.Standart Kullanıcı'></option>
						</cfselect>
					</div>
				</div>
			</div>		
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_row">
			<cf_workcube_buttons is_upd='1' add_function="kontrol()" del_action= 'wbp.retail.files.cfc.get_user:DEL:row_id=#attributes.row_id#'
			 delete_page_url="#request.self#?fuseaction=retail.emptypopup_del_pos_user&row_id=#attributes.row_id#">	
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
