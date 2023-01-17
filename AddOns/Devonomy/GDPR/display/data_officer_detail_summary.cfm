<!---
    File: data_officer_detail.cfm
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

	if(len(attributes.id)){
		gdpr_comp = createObject("component","addons.devonomy.gdpr.cfc.data_officer");
		gdpr_data = gdpr_comp.get_data_officer_byId(data_officer_id :'#attributes.id#');

		attributes.id = gdpr_data.data_officer_id;
		attributes.data_officer_name =   gdpr_data.data_officer_name;  
		attributes.data_officer_description = gdpr_data.data_officer_description;
		attributes.data_officer_kep_address = gdpr_data.data_officer_kep_address;
		attributes.data_officer_address = gdpr_data.data_officer_address;
		attributes.contact_emp_id = gdpr_data.contact_emp_id;
		attributes.contact_name = gdpr_data.contact_name;
		attributes.verbis_user = gdpr_data.verbis_user;
		attributes.verbis_password = gdpr_data.verbis_password;
		attributes.verbis_registration_date = gdpr_data.verbis_registration_date;
		
	}else{
		writeOutput("Hata Oluştu");
		exit;
	}

</cfscript>

<div class="row formContent">
	<div class="row" type="row">
		<div class="col col-6 col-xs-12">
			<div class="form-group" id="item-data_officer">
				<label class="col col-4 col-xs-12 bold" for="data_officer"><cf_get_lang dictionary_id='57570.Ad Soyad'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#attributes.data_officer_name#</cfoutput>
				</div>
			</div>
			<!--- XML e göre
			<div class="form-group" id="item-contact_emp_id">
				<label class="col col-4 col-xs-12" for="contact_emp_id">contact_emp_id</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#get_emp_info(attributes.contact_emp_id,0,0)#</cfoutput>
				</div>
			</div>
		--->
			<div class="form-group" id="item-contact_name">
				<label class="col col-4 col-xs-12 bold" for="contact_name"><cf_get_lang dictionary_id='43654.Bağlantı Adı'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#attributes.contact_name#</cfoutput>
				</div>
			</div>
			<div class="form-group" id="item-verbis_user">
				<label class="col col-4 col-xs-12 bold" for="verbis_user"><cf_get_lang dictionary_id='61752.Verbis Kullanıcısı'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#attributes.verbis_user#</cfoutput>
				</div>
			</div>
			<div class="form-group" id="item-verbis_registration_date">
				<label class="col col-4 col-xs-12 bold" for="verbis_registration_date"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#dateformat(attributes.verbis_registration_date,dateformat_style)#</cfoutput>
				</div>
			</div>
		</div>
		<div class="col col-6 col-xs-12">
			<div class="form-group" id="item-data_officer_address">
				<label class="col col-4 col-xs-12 bold" for="data_officer_address"><cf_get_lang dictionary_id='58723.Adres'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#attributes.data_officer_address#</cfoutput>
				</div>
			</div>
			<div class="form-group" id="item-data_officer_kep_address">
				<label class="col col-4 col-xs-12 bold" for="data_officer_kep_address"><cf_get_lang dictionary_id='59876.KEP Adresi'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#attributes.data_officer_kep_address#</cfoutput>
				</div>
			</div>
			<div class="form-group" id="item-data_officer_description">
				<label class="col col-4 col-xs-12 bold" for="data_officer_description"><cf_get_lang dictionary_id='36199.Açıklama'>:</label>
				<div class="col col-8 col-xs-12">
					<cfoutput>#attributes.data_officer_description#</cfoutput>
				</div>
			</div>
		</div>
	</div>
</div>