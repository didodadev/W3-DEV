<cfquery name="GET_CITY" datasource="#dsn#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_CUSTS" datasource="#dsn#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0
</cfquery>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2, '-')#
</cfquery>
<cfquery name="GET_PARTNER_POSITIONS" datasource="#dsn#">
	SELECT 
        PARTNER_POSITION
    FROM 
    	SETUP_PARTNER_POSITION 
    ORDER BY 
    	PARTNER_POSITION
</cfquery>
<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#dsn#">
	SELECT 
        PARTNER_DEPARTMENT
    FROM 
    	SETUP_PARTNER_DEPARTMENT 
    ORDER BY 
    	PARTNER_DEPARTMENT
</cfquery>
<cfquery name="GET_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES 
</cfquery>
<cf_box title="#getLang('','Müşteri Ekle',51630)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company_valid_value">
	<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='52057.Eczane adı'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="fullname" required="yes" message="#getLang('','Lütfen Eczane İsmi Giriniz',30715)#" maxlength="75" value="" tabindex="1">
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
							<option value="#companycat_id#">#companycat#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58192.Müşteri adı'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="company_partner_name" required="yes" message="#getLang('','müsteri Adi Girmelisiniz',51514)#"  maxlength="20" value="" tabindex="3">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='51484.Müşteri Soyadı'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="company_partner_surname" required="yes" message="#getLang('','Müsteri Soyadı Girmelisiniz',51502)#"  maxlength="20" value="" tabindex="3">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfsavecontent variable="message"><cf_get_lang no='351.Vergi No Sayısal Olmalıdır'></cfsavecontent>
					<cfinput type="text" name="tax_num" maxlength="10"  validate="integer" message="#message#" value="" tabindex="6">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairresi'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="tax_office" id="tax_office" maxlength="30" required="yes" message="#getLang('','Lütfen Vergi Dairesi Giriniz',30532)#" value="" tabindex="7">
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
							<option value="#country_id#">#country_name#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id_');">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfif isdefined('attributes.country_') and len(attributes.country_)>
								<cfquery name="get_city" datasource="#dsn#">
									SELECT CITY_ID, CITY_NAME, PHONE_CODE, COUNTRY_ID, PLATE_CODE FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_#"> ORDER BY CITY_NAME 
								</cfquery>
								<cfoutput query="get_city">
									<option value="#city_id#">#city_name#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58638.Ilçe'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<select name="county_id_" id="county_id_">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
							<cfquery name="get_county" datasource="#DSN#">
								SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"> ORDER BY COUNTY_NAME
							</cfquery>
							<cfoutput query="get_county">
								<option value="#county_id#">#county_name#</option>
							</cfoutput>
						</cfif>
					</select>
				</div>
			</div> 
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="district" id="district" value="" required="yes" message="#getLang('','Lütfen Mahalle Giriniz',30622)#" tabindex="17">
				</div>
			</div> 
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59266.Cadde'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="main_street" required="yes" message="#getLang('','Lütfen Cadde Giriniz',31538)#" maxlength="50" value="" tabindex="20">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59267.Sokak'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="street" id="street"  required="yes" message="#getLang('','Lütfen Sokak Giriniz',31652)#" maxlength="50" value="" tabindex="23">
				</div>
			</div> 
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="semt" id="semt" maxlength="30" value="" required="yes" message="#getLang('','Lütfen Semt Giriniz',30537)#" tabindex="14">
				</div>
			</div> 
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="dukkan_no" id="dukkan_no" maxlength="50" required="yes" message="#getLang('','Lütfen İşyeri No Giriniz',31618)#" value="" tabindex="27">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63897.Posta Kodu'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<cfinput type="text" name="post_code" id="post_code" maxlength="5" value="" tabindex="31">
				</div>
			</div>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30174.Kod/ Telefon'>*</label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang no='58.Telefon Kodu Sayısal Olmalıdır'> !</cfsavecontent>
						<cfinput type="text" name="telcod" maxlength="5" readonly="yes" validate="integer" message="#message#" value="">
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="tel1" maxlength="9"  validate="integer" message="#message#" value="" tabindex="9">
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'></label>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="ims_code_id" id="ims_code_id" value="">
						<cfinput type="text" name="ims_code_name" readonly="yes" required="yes" message="#getLang('','IMS Bölge Kodu Giriniz',52468)#" value="">
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
					<input  type="text" name="carihesapkod" id="carihesapkod" value="" maxlength="10">
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
						<cfinput type="text" name="open_date_val" value="#dateformat(now(),dateformat_style)#" required="yes" message="#message#" validate="#validate_style#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="open_date_val"></span>
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
		<cf_workcube_buttons is_upd='0' add_function="kontrol()" insert_info="#getLang('','Onayla',58475)#" insert_alert='#getLang('','Yaptığınız Değişiklikler Boyutu Etkileyecektir Emin misiniz',65210)#'>
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
	x = document.form_add_company.city.selectedIndex;
	if (document.form_add_company.city_id[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='33180.İlk Olarak İl Seçiniz'>!");
	}
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form_add_company.county_id&field_name=form_add_company.county&city_id=' + document.form_add_company.city_id.value);
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
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id&plate_code='+city_plate_code);
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
	if(document.form_add_company.tax_num.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='34829.Lütfen vergi no giriniz!'>!");
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
			alert("<cf_get_lang dictionary_id='31580.Vergi Numarası Sayısal Olmalıdır'>!" );
			return false;
		}
	}
	 x = document.form_add_company.city_id.selectedIndex;
	if (document.form_add_company.city_id[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='31548.Lütfen İl Giriniz'>!");
		return false;
	}
	if(document.form_add_company.county_id_.value.length == "")
	{
		alert("<cf_get_lang dictionary_id='31524.Lütfen İlçe Giriniz'>!");
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
		alert("<cf_get_lang dictionary_id='30539.Lütfen Cari Hesap Kodu Giriniz'>!");
		return false;
	}
	if((document.form_add_company.boyut_itriyat.value.length != "") && (document.form_add_company.boyut_itriyat.value.length != 3))
	{
		alert("<cf_get_lang dictionary_id='31634.Boyut Itriyat Satış Görevlisisi Kodu 3 Haneli Olmalıdır'>!");
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
	
	for (var i = 1; i < form_add_company.carihesapkod.value.length; i++)
	{
		check_carihesapkod = numberformat.indexOf(form_add_company.carihesapkod.value.charAt(i));
		if (check_carihesapkod < 0)
		{
			alert("<cf_get_lang dictionary_id='52037.Cari Hesap Kodu Sayısal Olmalıdır'>!");
			return false;
		}
	}
}
</script>
