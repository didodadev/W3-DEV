<!---
    File: add_data_officer_type.cfm
    Author: 
    Date: 
    Controller: 
    Description:
		
--->
<cfscript>

	if(Not isDefined("attributes.id")) attributes.id =  "";
	if(Not isDefined("attributes.data_officer_name")) attributes.data_officer_name =  "";  
	if(Not isDefined("attributes.data_officer_description")) attributes.data_officer_description = '';
	if(Not isDefined("attributes.data_officer_kep_address")) attributes.data_officer_kep_address = '';
	if(Not isDefined("attributes.data_officer_address")) attributes.data_officer_address = '';
	if(Not isDefined("attributes.contact_emp_id")) attributes.contact_emp_id = 0;
	if(Not isDefined("attributes.contact_name")) attributes.contact_name = "";
	if(Not isDefined("attributes.verbis_user")) attributes.verbis_user = '';
	if(Not isDefined("attributes.verbis_password")) attributes.verbis_password = '';
	if(Not isDefined("attributes.verbis_registration_date")) attributes.verbis_registration_date = '';
	if(Not isDefined("attributes.our_company_id")) attributes.our_company_id = '';
	if(Not isDefined("attributes.is_employee")) attributes.is_employee = 0;
	if(Not isDefined("attributes.is_contacts")) attributes.is_contacts = 0;
	if(Not isDefined("attributes.is_accounts")) attributes.is_accounts = 0;
	gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_officer");
	if(attributes.event == "upd"){
		if(len(attributes.id)){
			gdpr_data = gdpr_comp.get_data_officer_byId(data_officer_id :'#attributes.id#');

			attributes.id = gdpr_data.data_officer_id;
			attributes.data_officer_name = gdpr_data.data_officer_name;  
			attributes.data_officer_description = gdpr_data.data_officer_description;
			attributes.data_officer_kep_address = gdpr_data.data_officer_kep_address;
			attributes.data_officer_address = gdpr_data.data_officer_address;
			attributes.contact_emp_id = gdpr_data.contact_emp_id;
			attributes.contact_name = gdpr_data.contact_name;
			attributes.verbis_user = gdpr_data.verbis_user;
			attributes.verbis_password = gdpr_data.verbis_password;
			attributes.verbis_registration_date = gdpr_data.verbis_registration_date;
			attributes.our_company_id = gdpr_data.our_company_id;
			attributes.is_employee = gdpr_data.is_employee;
			attributes.is_contacts = gdpr_data.is_contacts;
			attributes.is_accounts = gdpr_data.is_accounts;
			
		}else{
			writeOutput("<script>alert('Hata Oluştu');history.back();</script>");
			exit;
		}
	}
	get_our_company = gdpr_comp.get_our_company();
	get_data_officer_all = gdpr_comp.get_data_officer_all();
	get_company_id = gdpr_comp.get_company_id(our_company_ids:attributes.our_company_id);
	our_company_list = valueList(get_data_officer_all.our_company_id,',');
</cfscript>
<cfset attributes.list_our_company_ids = '#our_company_list#'> 
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="gdpr_data_officer" id="gdpr_data_officer" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=GDPR.welcome&event=upd&id=<cfoutput>#attributes.id#</cfoutput>">
			<input type="hidden" name="form_submitted" value="1" />
			<input type="hidden" name="id" value="<cfoutput>#attributes.id#</cfoutput>" />
			<cf_box_elements>
				<div class="col col-6 col-xs-12">
					<div class="form-group" id="item-is_contacts">   
						<div class="col col-4 col-xs-12">
							<label class="col-xs-12"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'><input type="checkbox" name="is_contacts" id="is_contacts" value="1" tabindex="1" <cfif attributes.is_contacts is 1>checked</cfif>></label>
						</div>
						<div class="col col-4 col-xs-12">
							<label class="col-xs-12"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'><input type="checkbox" name="is_accounts" id="is_accounts" value="1" tabindex="2" <cfif attributes.is_accounts is 1>checked</cfif>></label>
						</div>
						<div class="col col-4 col-xs-12">
							<label class="col-xs-12"><cf_get_lang dictionary_id='957.Çalışan Adayları'><input type="checkbox" name="is_employee" id="is_employee" value="1" tabindex="3" <cfif attributes.is_employee is 1>checked</cfif>></label>
						</div>
					</div>
					<div class="form-group" id="item-data_officer">
						<label class="col col-4 col-xs-12" for="data_officer"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_officer_name" id="data_officer_name" value="<cfoutput>#attributes.data_officer_name#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-data_officer">
						<label class="col col-4 col-xs-12" for="data_officer"><cf_get_lang dictionary_id='959.Geçerli'><cf_get_lang dictionary_id='29531.Şirketler'></label>
						<div class="col col-8 col-xs-12">
							<div class="multiselect-z2">
								<cf_multiselect_check 
								query_name="get_our_company"  
								name="our_company_id"
								width="140" 
								option_value="COMP_ID"
								option_name="COMPANY_NAME"
								option_text="#getLang('main',322)#"
								value="#attributes.our_company_id#"
							>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-data_officer_description">
						<label class="col col-4 col-xs-12" for="data_officer_description"><cf_get_lang dictionary_id='36199.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_officer_description" id="data_officer_description"><cfoutput>#attributes.data_officer_description#</cfoutput></textarea>
						</div>
					</div>
					<div class="form-group" id="item-data_officer_kep_address">
						<label class="col col-4 col-xs-12" for="data_officer_kep_address"><cf_get_lang dictionary_id='59876.KEP Adresi'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="data_officer_kep_address" id="data_officer_kep_address" value="<cfoutput>#attributes.data_officer_kep_address#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-data_officer_address">
						<label class="col col-4 col-xs-12" for="data_officer_address"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="data_officer_address" id="data_officer_address" maxlength="250"><cfoutput>#attributes.data_officer_address#</cfoutput></textarea>
						</div>
					</div>
					<!--- xml e göre 
					<div class="form-group" id="item-contact_emp_id">
						<label class="col col-4 col-xs-12" for="contact_emp_id">contact_emp_id</label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="contact_name" id="contact_name" value="">
							<input type="text" name="contact_emp_id" id="contact_emp_id" value="<cfoutput>#attributes.contact_emp_id#</cfoutput>">
						</div>
					</div>--->
					<div class="form-group" id="item-contact_emp_id">
						<label class="col col-4 col-xs-12" for="contact_emp_id"><cf_get_lang dictionary_id='43654.Bağlantı Adı'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="contact_name" id="contact_name" value="<cfoutput>#attributes.contact_name#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-verbis_user">
						<label class="col col-4 col-xs-12" for="verbis_user"><cf_get_lang dictionary_id='61752.Verbis Kullanıcısı'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="verbis_user" id="verbis_user" value="<cfoutput>#attributes.verbis_user#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-verbis_password">
						<label class="col col-4 col-xs-12" for="verbis_password"><cf_get_lang dictionary_id='61753.Verbis Şifre'></label>
						<div class="col col-8 col-xs-12">
							<input type="password" name="verbis_password" id="verbis_password" value="<cfoutput>#attributes.verbis_password#</cfoutput>">
						</div>
					</div>
					<div class="form-group" id="item-verbis_registration_date">
						<label class="col col-4 col-xs-12" for="verbis_registration_date"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
							<cfinput type="text" name="verbis_registration_date" id="verbis_registration_date" value="#dateformat(attributes.verbis_registration_date,dateformat_style)#" validate="#validate_style#" required="No">
							<span class="input-group-addon"><cf_wrk_date_image date_field="verbis_registration_date"></span> 
						</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cfif isDefined("gdpr_data") and gdpr_data.RecordCount gt 0>
						<cf_record_info query_name="gdpr_data">
					</cfif>
				</div>
				<div class="col col-6">
					<cfif attributes.event EQ "upd">
						<cf_workcube_buttons is_upd='1' is_delete="0" add_function="controlFormGdpr()"><!---  delete_page_url="#request.self#?fuseaction=gdpr.welcome&event=del&id=#attributes.id#" --->
					<cfelse>
						<cf_workcube_buttons is_upd='0' add_function="controlFormGdpr()">
					</cfif>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
    <cf_box title="Uyarı" closable="0" resize="0">
        <div class="ui-cfmodal-close">×</div>
        <ul class="required_list"></ul>
    </cf_box>
</div>
<script type="text/javascript">
    $('.ui-cfmodal-close').click(function(){
       $('.ui-cfmodal__alert').fadeOut();
   })

</script>
<script type="text/javascript">

    function controlFormGdpr()
    {
		if(!$("#data_officer_name").val().length)
		{
			alert('<cf_get_lang dictionary_id="58194.girilmesi zorunlu alan">');
			$("#data_officer_name").focus();
			return false;
		}
		return true;
    }
	
	$('input[name="multiselect_our_company_id"]').click(function () {
			if($(this).is(':checked')){
				var attr_ = $(this).val();
				var query = "SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID  ="+ attr_;
				get_our_comp_inf = wrk_query(query,'dsn');
				var list_ = '<cfoutput>#attributes.list_our_company_ids#</cfoutput>';
				if(list_find(list_,attr_,','))
					{
						our_company_alert(get_our_comp_inf.COMPANY_NAME[0],attr_);
						return false;
					}
			}
			});
	function our_company_alert(name,id) {
		var query_ = "SELECT DATA_OFFICER_ID FROM GDPR_DATA_OFFICER WHERE OUR_COMPANY_ID LIKE '%"+id+"%'";
		get_officer_id = wrk_query(query_,'dsn');
		$('.ui-cfmodal').css("z-Index", "99999999999");
		$('.ui-cfmodal__alert .required_list li').remove();
		$('.ui-cfmodal__alert .required_list').append('<li>').text(name + ' - Veri Sorumluluğu tanımı yapılmış! ID: '+get_officer_id.DATA_OFFICER_ID[0]+' İlgili belgede düzenleme yapmalısınız');
		$('.ui-cfmodal__alert').fadeIn();
}
</script>-