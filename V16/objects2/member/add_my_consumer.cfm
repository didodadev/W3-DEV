<!--- uye Giris Bolumu --->
<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_language.cfm">
<cfinclude template="../query/get_mobilcat.cfm">

<cfinclude template="../query/get_company_size_cats.cfm">
<cfinclude template="../query/get_sector_cats.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfinclude template="../query/get_vocation_type.cfm">
<cfif not isdefined("attributes.is_detail_adres")>
	<cfset attributes.is_detail_adres = 0>
</cfif>
<cfif not isdefined("attributes.is_residence_select")>
	<cfset attributes.is_residence_select = 0>
</cfif>

<!--- Sadece aktif kategorilerin gelmesi için --->
<cfset attributes.is_active_consumer_cat = 1>
<cfinclude template="../query/get_consumer_cat.cfm">

<cfparam name="attributes.is_tc_number" default="1">

<cfform action="#request.self#?fuseaction=objects2.emptypopup_add_my_consumer" method="post" name="form_add_company">
	<cfif isdefined('attributes.consumer_contract_id') and len(attributes.consumer_contract_id)>
		<input type="hidden" name="consumer_contract_id"  id="consumer_contract_id" value="<cfoutput>#attributes.consumer_contract_id#</cfoutput>">
	</cfif>

	<div class="card border-0 shadow mt-5">
		<div class="card-body">
			<h6 class="mb-3 header-color"><cf_get_lang dictionary_id='34518.Kişisel Bilgiler'></h6>
			<div class="row mx-auto mt-3">
				<div class="col-md-4">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57631.Ad'> *</label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57631.Ad girmelisiniz'></cfsavecontent>
						<cfinput class="form-control" type="text" name="CONSUMER_name" id="CONSUMER_name" required="Yes" message="#message#!" maxlength="30">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58726.Soyad'> *</label>
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='34558.Soyadınızı Girmelisiniz'></cfsavecontent>
						<cfinput class="form-control" type="text" name="CONSUMER_surname" id="CONSUMER_surname" required="Yes" message="#alert#" maxlength="30">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58025.TC Kimlik No'><cfif isdefined("attributes.is_tc_number") and attributes.is_tc_number eq 1> *</cfif></label>
						<cf_wrkTcNumber class="form-control" fieldId="tc_identity_no" tc_identity_required="#attributes.is_tc_number#">
					</div>
				</div>
				<div class="col-md-4">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
						<select class="form-control" name="sex" id="sex">
							<option value="1"><cf_get_lang dictionary_id='58959.Erkek'></option>
							<option value="2"><cf_get_lang dictionary_id='58958.Kadin'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57428.E-mail'> <cfif isdefined('attributes.is_email') and attributes.is_email eq 1>*</cfif></label>
						<cfif isdefined('attributes.is_email') and attributes.is_email eq 1>
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id='58484.Geçerli Bir Mail Girmelisiniz'> !</cfsavecontent>
							<cfinput class="form-control" type="text" name="CONSUMER_EMAIL" id="CONSUMER_EMAIL" maxlength="40" required="yes" message="#alert#">
						<cfelse>
							<cfinput class="form-control" type="text" name="CONSUMER_EMAIL" id="CONSUMER_EMAIL" maxlength="40" validate="email">
						</cfif>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58609.Üye Kategorisi'>*</label>
						<select class="form-control" name="consumer_cat_id" id="consumer_cat_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_consumer_cat">
								<option value="#conscat_id#">#conscat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<h6 class="mb-3 header-color"><cf_get_lang dictionary_id='35939.İş Bilgileri'></h6>
			<div class="row mx-auto mt-3">
				<div class="col-md-4">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<cfinput class="form-control" type="text" name="company" id="company">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57571.Ünvan'></label>
						<cfinput class="form-control" type="text" name="title" id="title">
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57572.Departman'></label>
						<select class="form-control" name="department" id="department">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_departments">
								<option value="#partner_department_id#">#partner_department#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='34533.Meslek'></label>
						<select class="form-control" name="vocation_type" id="vocation_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_vocation_type">
								<option value="#vocation_type_id#">#vocation_type#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="col-md-4">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57573.Görev'></label>
						<select class="form-control" name="mission" id="mission">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_partner_positions">
								<option value="#partner_position_id#">#partner_position#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57579.Sektör'></label>
						<select class="form-control" name="sector_cat_id" id="sector_cat_id">
							<cfoutput query="get_sector_cats">
								<option value="#sector_cat_id#">#sector_cat#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='34337.Şirket Büyüklük'></label>
						<select class="form-control" name="company_size_cat_id" id="company_size_cat_id">
							<cfoutput query="get_company_size_cats">
								<option value="#company_size_cat_id#">#company_size_cat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<h6 class="mb-3 header-color"><cf_get_lang dictionary_id='34556.İletişim Bilgisi'></h6>
			<div class="row mx-auto mt-3">
				<div class="col-md-4">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<select class="form-control" name="country" id="country" onChange="LoadCity(this.value,'city_id','county_id',0<cfif attributes.is_residence_select eq 1>,'work_district_id'</cfif>)">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_country">
								<option value="#get_country.country_id#" <cfif is_default eq 1>selected</cfif>>#get_country.country_name#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<select class="form-control" name="city_id" id="city_id" onChange="LoadCounty(this.value,'county_id','CONSUMER_WORKTELCODE'<cfif attributes.is_residence_select eq 1>,'work_district_id'</cfif>)">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<select class="form-control" name="county_id" id="county_id" <cfif attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'work_district_id');"</cfif>>
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						</select>
					</div>
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='58132.Semt'></label>
						<input class="form-control" type="text" name="semt" id="semt" value="" maxlength="30" tabindex="13">
					</div>
					<cfif attributes.is_detail_adres eq 1>
						<div class="form-group">
							<label class="font-weight-bold"><cf_get_lang dictionary_id='35949.Adres Detay'></label>
							<textarea class="form-control" name="work_door_no" id="work_door_no" maxlength="200"></textarea>
						</div>
					</cfif>
					<div class="form-group mb-3">
						<cfif attributes.is_detail_adres eq 0>
							<label class="font-weight-bold"><cf_get_lang dictionary_id='58723.Adres'></label>
							<textarea class="form-control" name="WORKADDRESS" id="WORKADDRESS"></textarea>
						<cfelseif attributes.is_detail_adres eq 1>
							<label class="font-weight-bold"><cf_get_lang dictionary_id='58735.Mahalle'></label>
							<cfif attributes.is_residence_select eq 0>
								<input class="form-control" type="text" name="work_district" id="work_district" value="">
							<cfelse>
								<select class="form-control" name="work_district_id" id="work_district_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								</select>
							</cfif>
						</cfif>
					</div>
					<cfif isdefined('attributes.consumer_contract_id') and len(attributes.consumer_contract_id)>
						<cfquery name="GET_CONTENT_ORDER" datasource="#DSN#">
							SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_contract_id#">
						</cfquery>
						<div class="form-group mb-3">
							<a href="javascript://" class="tableyazi" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_content_notice&content_id=#attributes.consumer_contract_id#</cfoutput>','list');"><cfoutput>#get_content_order.cont_head#</cfoutput></a><br />
						</div>
						<div class="form-group mb-3">
							<input class="form-control" type="checkbox" name="contract_rules" id="contract_rules" class="radio_frame" value="1" />Temsilci Sözleşmesini Kabul Ediyorum.*
						</div>
					</cfif>
				</div>
				<div class="col-md-4">
					<div class="form-group mb-3">
						<label class="font-weight-bold"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<input class="form-control" type="text" name="work_postcode" id="work_postcode" maxlength="5" onKeyUp="isNumber(this);">
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58585.Kod'>/<cf_get_lang dictionary_id='57499.Telefon'> *</label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<cfsavecontent variable="message_kod"><cf_get_lang dictionary_id='34342.Geçerli Telefon Kodu Girmelisiniz'></cfsavecontent>
							<cfinput class="form-control" type="text" name="CONSUMER_WORKTELCODE" id="CONSUMER_WORKTELCODE" validate="integer" required="yes" message="#message_kod#!" maxlength="5" onKeyUp="isNumber(this);">
						</div>
						<div class="form-group mb-3 col-md-9">
							<cfsavecontent variable="message_tel"><cf_get_lang dictionary_id='34343.Geçerli Telefon No Girmelisiniz'></cfsavecontent>
							<cfinput class="form-control" type="text" name="CONSUMER_WORKTEL" id="CONSUMER_WORKTEL" validate="integer" required="yes" message="#message_tel#!" onKeyUp="isNumber(this);" maxlength="9">
						</div>
					</div>
					<label class="font-weight-bold"><cf_get_lang dictionary_id='58482.Mobil Tel'></label>
					<div class="form-row">
						<div class="form-group mb-3 col-md-3">
							<select class="form-control" name="mobilcat_id" id="mobilcat_id">
								<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'>
								<cfoutput query="get_mobilcat">
									<option value="#mobilcat#">#mobilcat#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group mb-3 col-md-9">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='34340.Geçerli GSM No Girmelisiniz'></cfsavecontent>
							<cfinput class="form-control" type="text" name="mobiltel" id="mobiltel" maxlength="9" validate="integer" message="#message#" onKeyUp="isNumber(this);">
						</div>
					</div>
					<cfif attributes.is_detail_adres eq 1>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id ='35656.Cadde'></label>
							<input class="form-control" type="text" name="work_main_street" id="work_main_street" maxlength="50">
						</div>
						<div class="form-group mb-3">
							<label class="font-weight-bold"><cf_get_lang dictionary_id ='35655.Sokak'></label>
							<input class="form-control" type="text" name="work_street" id="work_street" maxlength="50">
						</div>
					</cfif>
				</div>
			</div>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</div>
	</div>
</cfform>
<script type="text/javascript">
	<cfif isdefined("attributes.is_tc_number")>
		var is_tc_number = '<cfoutput>#attributes.is_tc_number#</cfoutput>';
	<cfelse>
		var is_tc_number = 0;
	</cfif>
	var work_country_ = document.getElementById('country').value;
	if(work_country_.length)
		LoadCity(work_country_,'city_id','county_id',0);
	function kontrol()
	{
		if(is_tc_number== 1)
		{
			if(!isTCNUMBER(document.getElementById('tc_identity_no'))) return false;
		}

		if(document.getElementById('tc_identity_no').value != "")
		{
			var consumer_control = wrk_safe_query("obj2_consumer_control_2",'dsn',0,document.getElementById('tc_identity_no').value);
			if(consumer_control.recordcount > 0)
			{
				alert("<cf_get_lang dictionary_id ='35404.Aynı TC Kimlik Numarası İle Kayıtlı Üye Var Lütfen Bilgilerinizi Kontrol Ediniz'> !");
				return false;
			}
		}
		<cfif isdefined('xml_check_cell_phone') and xml_check_cell_phone eq 1>
			if(document.getElementById('mobilcat_id').value != "" && document.getElementById('mobiltel').value != "")
			{
				
				var listParam = document.getElementById('mobilcat_id').value + "*" + document.getElementById('mobiltel').value;
				var get_results = wrk_safe_query('mr_add_cell_phone',"dsn",0,listParam);
				if(get_results.recordcount>0)
				{
					  alert("Girdiginiz Cep Telefonuna Kayitli Baska Temsilci Bulunmaktadir!");
					  document.getElementById('mobiltel').focus();
					  return false;
				}              
			}
		</cfif>
				
		<cfif isdefined('attributes.consumer_contract_id') and len(attributes.consumer_contract_id)>
			if(document.getElementById('contract_rules').checked!=true)
			{
				alert ("Temsilci Sözleşmesini Kabul Ediyorum Seçeneğini Seçmelisiniz!");
				return false;
			}
		</cfif>

		return true;
	}
</script>
