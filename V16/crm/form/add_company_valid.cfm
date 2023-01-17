<cfquery name="GET_BRANCH_RELATED" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_ID,
		CARIHESAPKOD
	FROM 
		COMPANY_BRANCH_RELATED,
		BRANCH 
	WHERE 
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND 
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		BRANCH.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
</cfquery>
<cfif get_branch_related.recordcount neq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='30716.Bu Müşteri İle Zaten Deponuzun İlişkisi Var'>!");
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</script>
</cfif>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY.IS_BUYER, 
		COMPANY.IS_SELLER, 
		COMPANY.COMPANY_STATUS, 
		COMPANY.ISPOTANTIAL,
		COMPANY.FULLNAME, 
		COMPANY.MANAGER_PARTNER_ID, 
		COMPANY.COMPANYCAT_ID, 
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO, 
		COMPANY.COMPANY_TELCODE, 
		COMPANY.COMPANY_TEL1, 
		COMPANY.DISTRICT,
		COMPANY.STREET, 
		COMPANY.IMS_CODE_ID, 
		COMPANY.COMPANY_TEL2, 
		COMPANY.MAIN_STREET,
		COMPANY.COMPANY_TEL3, 
		COMPANY.COMPANY_STATUS,
		COMPANY.COMPANY_ADDRESS, 
		COMPANY.COMPANY_FAX_CODE, 
		COMPANY.COMPANY_FAX,
		COMPANY.DUKKAN_NO, 
		COMPANY.COMPANY_EMAIL, 
		COMPANY.COMPANY_POSTCODE, 
		COMPANY.HOMEPAGE,
		COMPANY.SEMT, 
		COMPANY.COUNTY, 
		COMPANY.CITY, 
		COMPANY.COUNTRY, 
		COMPANY.COMPANY_STATE,
		COMPANY_PARTNER.PARTNER_ID, 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME, 
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.MOBIL_CODE, 
		COMPANY_PARTNER.MOBILTEL, 
		COMPANY_PARTNER.IS_SMS,
		COMPANY_PARTNER.SEX,
		COMPANY_PARTNER.TITLE,
		COMPANY_PARTNER.GRADUATE_YEAR, 
		COMPANY_PARTNER_DETAIL.CHILD,	
		COMPANY_PARTNER_DETAIL.BIRTHDATE, 
		COMPANY_PARTNER_DETAIL.BIRTHPLACE, 
		COMPANY_PARTNER_DETAIL.MARRIED,
		COMPANY_PARTNER_DETAIL.MARRIED_DATE, 
		COMPANY_PARTNER_DETAIL.FACULTY 
	FROM 
		COMPANY,
		COMPANY_PARTNER, 
		COMPANY_PARTNER_DETAIL 
	WHERE 
		COMPANY.COMPANY_ID = #attributes.cpid# AND 
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND 
		COMPANY_PARTNER.PARTNER_ID = COMPANY_PARTNER_DETAIL.PARTNER_ID
</cfquery>
<cfquery name="GET_CITY" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_CUSTS" datasource="#dsn#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0
</cfquery>
<cfquery name="GET_COUNTRY" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY ORDER BY COUNTRY_ID
</cfquery>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2, '-')#
</cfquery>
<cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
	SELECT * FROM SETUP_PARTNER_POSITION ORDER BY PARTNER_POSITION
</cfquery>
<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#dsn#">
	SELECT * FROM SETUP_PARTNER_DEPARTMENT ORDER BY PARTNER_DEPARTMENT
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES 
</cfquery>
<cfquery name="GET_SERVICE_INFO" datasource="#dsn#">
	SELECT COMPANY_ID, PC_NUMBER, NET_CONNECTION FROM COMPANY_SERVICE_INFO WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cf_box title="#getLang('','Müşteri',57457)# #get_company.fullname#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_valid_info">
        <cf_box_elements>
			<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#attributes.cpid#</cfoutput>">
            <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_company.partner_id#</cfoutput>">
            <input type="hidden" name="is_control" id="is_control" value="1">
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52057.Eczane adı'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="fullname" required="yes" message="#getLang('','Lütfen Eczane İsmi Giriniz',30715)#" maxlength="75" value="#get_company.fullname#" tabindex="1">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30681.Müşteri Durumu'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="durum" id="durum">
							<cfoutput query="get_status">
								<option value="#tr_id#" <cfif tr_id eq 3>selected</cfif>>#tr_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51482.Müşteri Tipi'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="companycat_id" id="companycat_id" tabindex="5">
							<cfoutput query="get_custs">
								<option value="#companycat_id#" <cfif companycat_id eq get_company.companycat_id>checked</cfif>>#companycat#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58192.Müşteri adı'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="company_partner_name" required="yes" message="#getLang('','müsteri Adi Girmelisiniz',51514)#"  maxlength="20" value="#get_company.company_partner_name#" tabindex="3">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51484.Müşteri Soyadı'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="company_partner_surname" required="yes" message="#getLang('','Müsteri Soyadı Girmelisiniz',51502)#"  maxlength="20" value="#get_company.company_partner_surname#" tabindex="3">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang no='351.Vergi No Sayısal Olmalıdır'></cfsavecontent>
						<cfinput type="text" name="tax_num" maxlength="10"  validate="integer" message="#message#" value="#get_company.taxno#" tabindex="6">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairresi'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="tax_office" id="tax_office" maxlength="30" required="yes" message="#getLang('','Lütfen Vergi Dairesi Giriniz',30532)#" value="#get_company.taxoffice#" tabindex="7">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">										
						<select name="country_" id="country_" onchange="LoadCity(this.value,'city_id','county_id_',0,'','telcod');">
							<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
							<cfquery name="get_country" datasource="#dsn#">
								SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY 
							</cfquery>
							<cfoutput query="get_country">
								<option value="#country_id#" <cfif get_company.country eq country_id>selected</cfif>>#country_name#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id_');">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>							
								<cfquery name="get_city" datasource="#dsn#">
									SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.country#"> ORDER BY CITY_NAME 
								</cfquery>
								<cfoutput query="get_city">
									<option value="#city_id#" <cfif get_company.city eq city_id>selected</cfif>>#city_name#</option>
								</cfoutput>							
							</select>
						</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ilçe'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="county_id_" id="county_id_">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfquery name="get_county" datasource="#DSN#">
									SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company.city#"> ORDER BY COUNTY_NAME
								</cfquery>
								<cfoutput query="get_county">
								<option value="#county_id#" <cfif get_company.county eq county_id>selected</cfif>>#county_name#</option>
									<option value="#county_id#">#county_name#</option>
								</cfoutput>
						</select>					
					</div>
				</div> 
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="district" id="district" value="#get_company.district#" required="yes" message="#getLang('','Lütfen Mahalle Giriniz',30622)#" tabindex="17">
					</div>
				</div> 
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59266.Cadde'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="main_street" required="yes" message="#getLang('','Lütfen Cadde Giriniz',31538)#" maxlength="50" value="#get_company.main_street#" tabindex="20">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59267.Sokak'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="street" id="street"  required="yes" message="#getLang('','Lütfen Sokak Giriniz',31652)#" maxlength="50" value="#get_company.street#" tabindex="23">
					</div>
				</div> 
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="semt" id="semt" maxlength="30" value="#get_company.semt#" required="yes" message="#getLang('','Lütfen Semt Giriniz',30537)#" tabindex="14">
					</div>
				</div> 
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="dukkan_no" id="dukkan_no" maxlength="50" required="yes" message="#getLang('','Lütfen İşyeri No Giriniz',31618)#" value="#get_company.dukkan_no#" tabindex="27">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63897.Posta Kodu'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="post_code" id="post_code" maxlength="5" value="#get_company.COMPANY_POSTCODE#" tabindex="31">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30174.Kod/ Telefon'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang no='58.Telefon Kodu Sayısal Olmalıdır'> !</cfsavecontent>
							<cfinput type="text" name="telcod" maxlength="5" readonly="yes" validate="integer" message="#message#" value="#get_company.company_telcode#">
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="tel1" maxlength="9"  validate="integer" message="#message#" value="#get_company.company_tel1#" tabindex="9">
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfquery name="GET_IMS_CODE" datasource="#dsn#">
								SELECT IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = #get_company.ims_code_id#
							</cfquery>
							<cfinput type="hidden" name="ims_code_id" id="ims_code_id" value="#get_company.ims_code_id#">
							<cfinput type="text" name="ims_code_name" readonly="yes" required="yes" message="#getLang('','IMS Bölge Kodu Giriniz',52468)#" value="#get_ims_code.ims_code# #get_ims_code.ims_code_name#">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="il_secimi_kontrol();"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#listgetat(session.ep.user_location, 2, '-')#</cfoutput>">
							<cfquery name="GET_BRANCH" datasource="#dsn#">
								SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
							</cfquery>
							<cfinput type="text" name="branch_name" required="yes" message="Lütfen Depo Seçiniz !" value="#get_branch.branch_name#">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=form_add_company.branch_name&field_branch_id=form_add_company.branch_id&is_special=1');" tabindex="13"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51549.Bölge Satış Müdürü'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="">
							<input type="text" name="satis_muduru" id="satis_muduru" value="">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&employee_list=1&field_name=form_add_company.satis_muduru&select_list=1&is_form_submitted=1</cfoutput>');" tabindex="16"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52155.bsm'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="boyut_bsm" id="boyut_bsm" maxlength="3" value="">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51673.cari hesap kodu'>*</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput  type="text" name="carihesapkod" id="carihesapkod" value="#GET_BRANCH_RELATED.carihesapkod#" maxlength="10">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satış Görevlisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="">
							<input type="text" name="plasiyer" id="plasiyer" value="">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&employee_list=1&field_name=form_add_company.plasiyer&select_list=1&is_form_submitted=1</cfoutput>');" tabindex="19"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12">Plasiyer</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="boyut_plasiyer" id="boyut_plasiyer" maxlength="3" value="">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63895.adres'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<textarea name="adres" id="adres"></textarea>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51877.Telefonla Satış Görevlisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="">
							<input type="text" name="telefon_satis" id="telefon_satis" value="">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.telefon_satis_id&employee_list=1&field_name=form_add_company.telefon_satis&select_list=1&is_form_submitted=1</cfoutput>');" tabindex="22"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63895.adres'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="boyut_telefon" id="boyut_telefon" maxlength="3" value="">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57845.Tahsilatçı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="">
							<input type="text" name="tahsilatci" id="tahsilatci" style="width:150px;" value="">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.tahsilatci_id&field_name=form_add_company.tahsilatci&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');return false"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57845.Tahsilatçı'> <cf_get_lang dictionary_id='63868.boyut'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="boyut_tahsilat" id="boyut_tahsilat" maxlength="3" value="">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51683.Şube Açılış Tarihi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51684.Şube Açılış Tarihi Girmelisiniz'>!</cfsavecontent>
							<cfinput type="text" name="OPEN_DATE" value="#dateformat(now(),dateformat_style)#" required="yes" message="#message#" validate="#validate_style#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="OPEN_DATE"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52093.Itriyat Satış Görevlisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="itriyat_id" id="itriyat_id" value="">
							<input type="text" name="itriyat" id="itriyat" value="">
							<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.itriyat_id&field_name=form_add_company.itriyat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');return false"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52157.itriyat'> <cf_get_lang dictionary_id='63868.boyut'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="text" name="boyut_itriyat" id="boyut_itriyat" maxlength="3" value="">
					</div>
				</div>
			</div> 
        </cf_box_elements>
        <cf_box_footer>
            <cfif get_company.ispotantial eq 1>
                <cf_workcube_buttons is_upd='0' add_function="kontrol()" insert_info=" Onayla " insert_alert='Yaptığınız Değişiklikler Boyutu Etkileyecektir Emin misiniz!'>
            <cfelse>
                <cf_workcube_buttons is_upd='1' add_function="kontrol()" is_delete='0' insert_info=" Onayla " insert_alert='Yaptığınız Değişiklikler Boyutu Etkileyecektir Emin misiniz!'>
            </cfif>
        </cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
plate_code_list=new Array('<cfoutput>#valuelist(get_city.PLATE_CODE)#</cfoutput>');
phone_code_list = new Array('<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>');
country_list = new Array('<cfoutput><cfloop query=get_country>"#get_country.country_name#"<cfif not currentrow eq recordcount>,</cfif></cfloop></cfoutput>');
country_ids = new Array(<cfoutput>#valuelist(get_city.country_id)#</cfoutput>);

function pencere_ac(no)
{
	x = document.form_add_company.city_id.selectedIndex;
	if (document.form_add_company.city_id[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33180.İlk Olarak İl Seçiniz'>!");
	}
	else
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_company.county_id&field_name=form_add_company.county&city_id=' + document.form_add_company.city_id.value,'small');
	}
}
function il_secimi_kontrol()
{
	if(document.form_add_company.city_id.selectedIndex == '')
	{
		alert("<cf_get_lang dictionary_id='33180.İlk Olarak İl Seçiniz'>!");
	}
	else
	{
		city_plate_code= plate_code_list[document.form_add_company.city_id.selectedIndex-1];
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id&plate_code='+city_plate_code,'list');
	}
}
function kontrol()
{
	
	x = document.form_add_company.durum.selectedIndex;
	if (document.form_add_company.durum[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='30704.Lütfen Müşteri Durumu Giriniz'>!");
	}
	x = document.form_add_company.companycat_id.selectedIndex;
	if (document.form_add_company.companycat_id[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='30657.Lütfen Eczane Tipi Giriniz'>!");
	}
	x = document.form_add_company.city_id.selectedIndex;
	if (document.form_add_company.city_id[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='31548.Lütfen İl Giriniz'>!");
	}
	if(document.form_add_company.main_street.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31538.Lütfen Cadde Giriniz'>!");
		return false;
	}
	if(document.form_add_company.county_id_.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31524.Lütfen İlçe Giriniz'>!");
		return false;
	}
	if(document.form_add_company.street.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31652.Lütfen Sokak Giriniz'>!");
		return false;
	}
	if(document.form_add_company.semt.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='30537.Lütfen Semt Giriniz'>!");
		return false;
	}
	if(document.form_add_company.dukkan_no.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31618.Lütfen İşyeri No Giriniz'>!");
		return false;
	}
	if(document.form_add_company.country_.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31607.Lütfen Ülke Giriniz'>!");
		return false;
	}
	if(document.form_add_company.telcod.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='30534.Lütfen Telefon Kodu Giriniz'>!");
		return false;
	}
	if(document.form_add_company.tel1.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='34343.Lütfen Telefon Numarası Giriniz'>!");
		return false;
	}
	if(document.form_add_company.ims_code_id.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31603.Lütfen IMS Kodu Giriniz'>!");
		return false;
	}
	if(document.form_add_company.branch_id.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>!");
		return false;
	}
	if(document.form_add_company.carihesapkod.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='30539.Lütfen Cari Hesap Kodu Giriniz'>");
		return false;
	}
	if((document.form_add_company.boyut_itriyat.value.length != "") && (document.form_add_company.boyut_itriyat.value.length != 3))
	{
		alert("<cf_get_lang dictionary_id='31634.Boyut Itriyat Satış Görevlisi Kodu 3 Haneli Olmalıdır'>!");
		return false;
	}
	if((document.form_add_company.boyut_bsm.value.length != "") && (document.form_add_company.boyut_bsm.value.length != 3))
	{
		alert("<cf_get_lang dictionary_id='31633.Boyut Bölge Satış Müdürü Kodu 3 Haneli Olmalıdır'>!");
		return false;
	}
	if((document.form_add_company.boyut_plasiyer.value.length != "") && (document.form_add_company.boyut_plasiyer.value.length != 3))
	{
		alert("<cf_get_lang dictionary_id='31586.Boyut Saha Satış Görevlisi Kodu 3 Haneli Olmalıdır'>!");
		return false;
	}
	if((document.form_add_company.boyut_telefon.value.length != "") && (document.form_add_company.boyut_telefon.value.length != 3))
	{
		alert("<cf_get_lang dictionary_id='31585.Boyut Telefonla Satış Görevlisisi Kodu 3 Haneli Olmalıdır'>!");
		return false;
	}
	if((document.form_add_company.boyut_tahsilat.value.length != "") && (document.form_add_company.boyut_tahsilat.value.length != 3))
	{
		alert("<cf_get_lang dictionary_id='31583.Boyut Tahsilat Görevlisisi Kodu 3 Haneli Olmalıdır'>!");
		return false;
	}
	if(document.form_add_company.tax_num.value.length != 10)
	{
		alert("<cf_get_lang dictionary_id='51937.Vergi Numarası 10 Hane Olmalıdır'>!");
		return false;
	}
	var numberformat = "1234567890";
	for (var i = 1; i < form_add_company.tax_num.value.length; i++)
	{
		check_char = numberformat.indexOf(form_add_company.tax_num.value.charAt(i));
		if (check_char < 0)
		{
			alert("<cf_get_lang dictionary_id='31580.Vergi Numarası Sayısal Olmalıdır'>!");
			return false;
		}
	}
	for (var i = 1; i < form_add_company.carihesapkod.value.length; i++)
	{
		check_carihesapkod = numberformat.indexOf(form_add_company.carihesapkod.value.charAt(i));
		if (check_carihesapkod < 0)
		{
			alert("<cf_get_lang dictionary_id='52037.Cari Hesap Kodu Sayısal Olmalıdır'>!");
			return false;
		}
	}
	/*for (var i = 1; i < form_add_company.muhasebekod.value.length; i++)
	{
		check_muhasebekod = numberformat.indexOf(form_add_company.muhasebekod.value.charAt(i));
		if (check_muhasebekod < 0)
		{
			alert("Muhasebe Kodu Sayısal Olmalıdır !");
			return false;
		}
	}*/
}
</script>

