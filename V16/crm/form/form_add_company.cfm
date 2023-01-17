<cfquery name="GET_NET_CONNECTION" datasource="#DSN#">
	SELECT CONNECTION_ID, CONNECTION_NAME FROM SETUP_NET_CONNECTION ORDER BY CONNECTION_ID
</cfquery>
<cfquery name="GET_PC_NUMBER" datasource="#DSN#">
	SELECT UNIT_ID, UNIT_NAME FROM SETUP_PC_NUMBER ORDER BY UNIT_ID
</cfquery>
<cfquery name="GET_MOBILCAT" datasource="#DSN#">
	SELECT MOBILCAT_ID, MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT
</cfquery>
<cfquery name="GET_UNIVERSTY" datasource="#DSN#">
	SELECT UNIVERSITY_ID, UNIVERSITY_NAME FROM SETUP_UNIVERSITY ORDER BY UNIVERSITY_NAME
</cfquery>
<cfquery name="GET_CUSTS" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0 ORDER BY COMPANYCAT_ID
</cfquery>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT
		SC.CITY_ID,
		SC.CITY_NAME,
		SC.COUNTRY_ID,
		ISNULL(SC.PHONE_CODE,0) PHONE_CODE,
		ISNULL(SC.PLATE_CODE,0) PLATE_CODE,
		SCO.COUNTRY_NAME
	FROM
		SETUP_CITY SC,
		SETUP_COUNTRY SCO 
	WHERE
		SC.COUNTRY_ID = SCO.COUNTRY_ID AND
		SCO.IS_DEFAULT = 1 
	ORDER BY
		SC.CITY_NAME
</cfquery>
<cfquery name="GET_RESOURCE" datasource="#DSN#">
	SELECT RESOURCE_ID,RESOURCE FROM COMPANY_PARTNER_RESOURCE
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
</cfquery>
<!--- Sube Aktarım Listesinden gelen bilgiler icin 20081028 BK --->
<cfif isdefined("attributes.transfer_branch_id") and len(attributes.transfer_branch_id)>
	<cfquery name="GET_BRANCH_TRANSFER" datasource="#DSN#">
		SELECT
			BTD.TABLE_NAME, 
			B.BRANCH_ID,
			B.BRANCH_NAME,
			CBDK.BOYUT_KODU
		FROM 
			BRANCH_TRANSFER_DEFINITION BTD,
			BRANCH B,
			COMPANY_BOYUT_DEPO_KOD CBDK
		WHERE
			BTD.BRANCH_ID = #attributes.transfer_branch_id# AND
			BTD.BRANCH_ID = B.BRANCH_ID AND
			CBDK.W_KODU = B.BRANCH_ID
	</cfquery>
	<cfquery name="GET_PERSONEL_GECIS" datasource="mushizgun">
		SELECT * FROM PERSONEL_GECIS WHERE DEPOKOD = #get_branch_transfer.boyut_kodu# 
	</cfquery>
	<cfif isdefined("attributes.id") and len(attributes.id)>
		<cfquery name="GET_TRANSFER_COMPANY" datasource="mushizgun">
			SELECT
				KAYITNO,ISYERIADI,ADI,SOYADI,TCKIMLIKNO,VERGINO,VERGIDAIRE,IL,ILCE,SEMT,TELEFON,ADRES,FAX,SEMT,POSTAKODU,RISKTOP,
				MUHKOD,HESAPKODU,BSM,TELEFONCU,TAHSILDAR,PLASIYER2,PLASIYER,CEPSIRA,BOLGEKODU,ALTBOLGEKD,CALISSEKLI,ACTAR,CARITIP,IMSKOD101
			FROM
				#get_branch_transfer.table_name#
			WHERE
				KAYITNO = #attributes.id# AND
				IS_TRANSFER = 0
		</cfquery>
	</cfif>	
</cfif>
<cfif isdefined("get_transfer_company") and get_transfer_company.recordcount>
	<cfset fullname_ = ''>
	<cfset company_partner_name_ = ''>
	<cfset company_partner_surname_ = ''>
	<cfset tax_office_ = ''>
	<cfset county_id_ = ''>
	<cfset county_ = ''>
	<cfset city_id_ = ''>
	<cfset telcod_ = ''>
	<cfset country_id_ = ''>
	<cfset country_ = ''>		
	<cfset semt_ = ''>
	<cfset tel1_ = ''>
	<cfset fax_ = ''>
	<cfset post_code_ = ''>
	<cfset carihesapkod_ = ''>
	<cfset muhasebekod_ = ''>
	<cfset cep_sira_no_ = ''>
	<cfset bolge_kodu_ = ''>
	<cfset altbolge_kodu_ = ''>
	<cfset open_date_ = ''>
	<cfset company_work_type_ = ''>
	<cfset tax_num_ = ''>
	<cfset companycat_ =''>
	<cfset depot_km_ = 1>
	<cfset depot_dak_ = 1>
	<cfset average_due_date_ = 0>
	<cfset opening_period_ = 0>
	<cfset mf_day_ = 0>
	<cfset transfer_telephone_ = get_transfer_company.telefon>
	<cfset average_due_date_ = 0>
	<cfset opening_period_ = 0>
	<cfset mf_day_ = 0>
	<cfset ims_code_id_ = ''>
	<cfset ims_code_name_ = ''> 

	<cfset cari_tip_ = trim(get_transfer_company.caritip)>
	<cfif len(get_transfer_company.risktop) or get_transfer_company.risktop gt 0>
		<cfset risk_limit_ = tlformat(get_transfer_company.risktop)>
	<cfelse>
		<cfset risk_limit_ = 1>
	</cfif>
	<cfif len(trim(get_transfer_company.calissekli))>
		<cfset calisma_sekli_ = trim(get_transfer_company.calissekli)>
	<cfelse>
		<cfset calisma_sekli_ = 001>
	</cfif>
	<cfset resource_id_ = 1><!--- Yeni Calisma CRM'de --->
	<cfset fullname_ = trim(get_transfer_company.isyeriadi)>
	<cfset company_partner_name_ = trim(get_transfer_company.adi)>
	<cfif not len(company_partner_name_) and cari_tip_ neq 'E'>
		<cfset company_partner_name_ = '-'>
	</cfif>
	<cfset company_partner_surname_ = trim(get_transfer_company.soyadi)>
	<cfif not len(company_partner_surname_) and cari_tip_ neq 'E'>
		<cfset company_partner_surname_ = '-'>
	</cfif>
	<cfif cari_tip_ eq 'E'>
		<cfset company_work_type_ = 1>
		<cfset companycat_ ='Eczane'>
		<cfset tax_num_ = trim(get_transfer_company.tckimlikno)>
	<cfelse>
		<cfif cari_tip_ eq 'M'>
			<cfset companycat_ ='Market'>
		<cfelseif cari_tip_ eq 'P'>
			<cfset companycat_ ='Parfümeri'>
		</cfif>
		<cfset tax_num_ = trim(get_transfer_company.vergino)>		
	</cfif>
	<cfset tax_office_ = trim(get_transfer_company.vergidaire)>

	<cfif len(trim(get_transfer_company.il))>		
		<cfquery name="GET_CITY_TRANSFER" datasource="#DSN#">
			SELECT 
				SETUP_CITY.CITY_ID,
				SETUP_CITY.CITY_NAME,
				SETUP_CITY.PHONE_CODE,
				SETUP_CITY.COUNTRY_ID,
				SETUP_COUNTRY.COUNTRY_NAME
			FROM 
				SETUP_CITY,
				SETUP_COUNTRY
			WHERE 
				SETUP_CITY.COUNTRY_ID = SETUP_COUNTRY.COUNTRY_ID AND 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CITY_NAME, 'Ğ', 'G'), 'i', 'I'), 'Ş', 'S'), 'Ü', 'U'), 'Ç', 'C'), 'Ö', 'O') LIKE '%#trim(get_transfer_company.il)#%'
		</cfquery>
		<cfif get_city_transfer.recordcount>
			<cfset city_id_ = get_city_transfer.city_id>
			<cfset telcod_ = get_city_transfer.phone_code>
			<cfset country_id_ = get_city_transfer.country_id>
			<cfset country_ = get_city_transfer.country_name>
			<!--- il adi ile semtdeki ifade esit ise merkez ilce kabul edilir --->
			<cfif get_city_transfer.city_name eq trim(get_transfer_company.semt)>
				<cfquery name="GET_COUNTY_TRANSFER" datasource="#DSN#">
					SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = #get_city_transfer.city_id# AND COUNTY_NAME = 'MERKEZ'
				</cfquery>
				<cfif get_county_transfer.recordcount>
					<cfset county_id_ = get_county_transfer.county_id>
					<cfset county_ = get_county_transfer.county_name>
				</cfif>
			<cfelse>
				<cfquery name="GET_COUNTY_TRANSFER" datasource="#DSN#">
					SELECT SC.COUNTY_ID,SC.COUNTY_NAME,SCI.CITY_ID,SCI.PHONE_CODE FROM SETUP_COUNTY SC,SETUP_CITY SCI WHERE SCI.CITY_ID = SC.CITY AND SC.CITY IN(#valuelist(get_city_transfer.city_id)#) AND SC.COUNTY_NAME = '#trim(get_transfer_company.semt)#'
				</cfquery>
				<cfif get_county_transfer.recordcount>
					<cfset city_id_ = get_county_transfer.city_id>
					<cfset telcod_ = get_county_transfer.phone_code>
					<cfset county_id_ = get_county_transfer.county_id>
					<cfset county_ = get_county_transfer.county_name>
				</cfif>
			</cfif>
		</cfif>
		<cfif trim(get_transfer_company.il) neq trim(get_transfer_company.semt)>
			<cfset semt_ = trim(get_transfer_company.semt)>
		</cfif>
	</cfif>

	<cfset adres = trim(get_transfer_company.adres)>
	<cfset tel1_ = right(trim(get_transfer_company.telefon),7)>
	<cfset fax_ = right(trim(get_transfer_company.fax),7)>
	<cfset post_code_ = trim(get_transfer_company.postakodu)>
	<cfset carihesapkod_ = trim(get_transfer_company.hesapkodu)>
	<cfset muhasebekod_ = trim(get_transfer_company.muhkod)>

	<cfset satis_muduru_id_ = ''>
	<cfset satis_muduru_ = ''>
	<cfset boyut_satis_ = trim(get_transfer_company.bsm)>
	<cfif len(boyut_satis_)>
		<cfquery name="GET_BSM" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'BSM' AND BOYUTKOD = '#boyut_satis_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_bsm.recordcount eq 1>
			<cfquery name="GET_BSM_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_bsm.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_bsm_name.recordcount eq 1>
				<cfset satis_muduru_id_ = get_bsm_name.position_code>
				<cfset satis_muduru_ = get_bsm_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfset plasiyer_id_ = ''>
	<cfset plasiyer_ = ''>
	<cfset boyut_plasiyer_ = trim(get_transfer_company.plasiyer)>	
	<cfif len(boyut_plasiyer_)>
		<cfquery name="GET_PLS" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'PLS' AND BOYUTKOD = '#boyut_plasiyer_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_pls.recordcount eq 1>
			<cfquery name="GET_PLS_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_pls.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_pls_name.recordcount eq 1>
				<cfset plasiyer_id_ = get_pls_name.position_code>
				<cfset plasiyer_ = get_pls_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfset tahsilatci_id_ = ''>
	<cfset tahsilatci_ = ''>
	<cfset boyut_tahsilat_ = trim(get_transfer_company.tahsildar)>
	<cfif len(boyut_tahsilat_)>
		<cfquery name="GET_TAH" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'TAH' AND BOYUTKOD = '#boyut_tahsilat_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_tah.recordcount eq 1>
			<cfquery name="GET_TAH_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_tah.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_tah_name.recordcount eq 1>
				<cfset tahsilatci_id_ = get_tah_name.position_code>
				<cfset tahsilatci_ = get_tah_name.name>
			</cfif>
		</cfif>
	</cfif>
	<cfset telefon_satis_id_ = ''>
	<cfset telefon_satis_ = ''>
	<cfset boyut_telefon_ = trim(get_transfer_company.telefoncu)>
	<cfif len(boyut_telefon_)>
		<cfquery name="GET_TEL" dbtype="query">
			SELECT INKAKOD FROM GET_PERSONEL_GECIS WHERE PERTIP = 'TEL' AND BOYUTKOD = '#boyut_telefon_#' AND INKAKOD IS NOT NULL
		</cfquery>
		<cfif get_tel.recordcount eq 1>
			<cfquery name="GET_TEL_NAME" datasource="#DSN#">
				SELECT EMPLOYEE_NAME+' ' +EMPLOYEE_SURNAME NAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #get_tel.inkakod# AND IS_MASTER = 1
			</cfquery>
			<cfif get_tel_name.recordcount eq 1>
				<cfset telefon_satis_id_ = get_tel_name.position_code>
				<cfset telefon_satis_ = get_tel_name.name>
			</cfif>
		</cfif>
	</cfif>

	<cfset boyut_itriyat_ = trim(get_transfer_company.plasiyer2)>
	<cfset cep_sira_no_ = trim(listsort(listdeleteduplicates(get_transfer_company.cepsira),'text','DESC',','))>
	<cfif len(get_transfer_company.bolgekodu)>
		<cfset bolge_kodu_ = trim(get_transfer_company.bolgekodu)>
	<cfelse>
		<cfset bolge_kodu_ = 1>
	</cfif>
	<cfif len(get_transfer_company.altbolgekd)>
		<cfset altbolge_kodu_ = trim(get_transfer_company.altbolgekd)>
	<cfelse>
		<cfset altbolge_kodu_ = 1>
	</cfif>
	<cfset calisma_sekli_ = trim(get_transfer_company.calissekli)>
	<cfif isdate(trim(get_transfer_company.actar))>
		<cfset open_date_ = trim(get_transfer_company.actar)>
	</cfif>
	<cfset status_ = ','>
	<cfset ims_code_ = trim(get_transfer_company.imskod101)>
	<cfif len(ims_code_)>
		<cfquery name="GET_IMS" datasource="#DSN#">
			SELECT IMS_CODE_ID,IMS_CODE,IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE = '#ims_code_#' 
		</cfquery>
		<cfif get_ims.recordcount eq 1>
			<cfset ims_code_id_ = get_ims.ims_code_id>
			<cfset ims_code_name_ = get_ims.ims_code&' '&get_ims.ims_code_name>
		</cfif>
	</cfif>

<cfelse>
	<cfset fullname_ = ''>
	<cfset company_partner_name_ = ''>
	<cfset company_partner_surname_ = ''>
	<cfset tax_office_ = ''>
	<cfset county_id_ = ''>
	<cfset county_ = ''>
	<cfset city_id_ = ''>
	<cfset telcod_ = ''>
	<cfset country_id_ = ''>
	<cfset country_ = ''>		
	<cfset semt_ = ''>
	<cfset tel1_ = ''>
	<cfset fax_ = ''>
	<cfset post_code_ = ''>
	<cfset carihesapkod_ = ''>
	<cfset muhasebekod_ = ''>
	<cfset satis_muduru_id_ = ''>
	<cfset satis_muduru_ = ''>
	<cfset boyut_satis_ = ''>
	<cfset telefon_satis_ = ''>
	<cfset boyut_satis_ = ''>
	<cfset telefon_satis_id_ = ''>
	<cfset telefon_satis_ = ''>
	<cfset boyut_telefon_ = ''>
	<cfset tahsilatci_id_ = ''>
	<cfset tahsilatci_ = ''>
	<cfset boyut_tahsilat_ =''>
	<cfset boyut_itriyat_ = ''>
	<cfset plasiyer_id_ = ''>
	<cfset plasiyer_ = ''>
	<cfset boyut_plasiyer_ = ''>
	<cfset cep_sira_no_ = ''>
	<cfset bolge_kodu_ = ''>
	<cfset altbolge_kodu_ = ''>
	<cfset calisma_sekli_ = ''>
	<cfset open_date_ = ''>
	<cfset company_work_type_ = ''>
	<cfset tax_num_ = ''>
	<cfset companycat_ =''>
	<cfset depot_km_ = ''>
	<cfset depot_dak_ = ''>
	<cfset average_due_date_ = ''>
	<cfset opening_period_ = ''>
	<cfset mf_day_ = ''>
	<cfset risk_limit_ = ''>
	<cfset resource_id_ = ''>
	<cfset transfer_telephone_ = "">
	<cfset status_ = ''>
	<cfset ims_code_id_ = ''>
	<cfset ims_code_name_ = ''> 
</cfif>
<div class= "col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Müşteri Ekle',51630)#" scroll="1" collapsable="1" resize="1">
		<cfform name="form_add_company" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_company">
			<cfif isdefined("attributes.transfer_branch_id")>
				<cfoutput>
				<input type="hidden" name="transfer_branch_id" id="transfer_branch_id" value="#attributes.transfer_branch_id#">
				<input type="hidden" name="id" id="id" value="#attributes.id#">
				<input type="hidden" name="table_name" id="table_name" value="#get_branch_transfer.table_name#">
				<input type="hidden" name="caritip" id="caritip" value="#attributes.caritip#">
				<input type="hidden" name="keyword" id="keyword" value="#attributes.keyword#">
				</cfoutput>
			</cfif>
			<cf_box_elements>
				<cfoutput>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57750.İşyeri Adı'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51481.İş Yeri Adı Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="fullname" id="fullname" value="#fullname_#" required="yes" message="#message#" maxlength="75" onBlur="kontrol_company_prerecords('1');" style="width:540px;" tabindex="1">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="kontrol_company_prerecords('1');"></span>
							</div>
						</div>
					</div>

					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58192.Müşteri Adı'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51514.Müşteri Adı Girmelisiniz'> !</cfsavecontent>
							<cfinput type="text" name="company_partner_name" id="company_partner_name" value="#company_partner_name_#" required="yes" message="#message#"  maxlength="20" tabindex="2"  >
						</div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51484.Müşteri Soyadı'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51502.Müşteri Soyadı Girmelisiniz '> !</cfsavecontent>
							<cfinput type="text" name="company_partner_surname" id="company_partner_surname" value="#company_partner_surname_#" maxlength="20" required="yes" message="#message#" tabindex="3"  >
						</div>
					</div>


					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'>/<cf_get_lang dictionary_id='58025.TC Kimlik No'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<input type="text" name="tax_num" id="tax_num" value="#tax_num_#" onkeyup="isNumber(this);" maxlength="11" onblur="kontrol_company_prerecords('1');" tabindex="5"  >
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="kontrol_company_prerecords('1');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'>*</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="tax_office" id="tax_office" value="#tax_office_#" maxlength="30"   tabindex="6">
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52110.Şirket Tipi'>*</label>
						<div class="col col-8 col-xs-12"> 
							<select name="company_work_type" id="company_work_type"  >
								<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
								<option value="1" <cfif company_work_type_ eq 1> selected</cfif>><cf_get_lang dictionary_id='52111.Gerçek'></option>
								<option value="2"><cf_get_lang dictionary_id='52112.Tüzel'></option>
							</select>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
						<div class="col col-8 col-xs-12"> 
							<select name="companycat_id" id="companycat_id"  >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="get_custs">
									<option value="#companycat_id#" <cfif companycat_ eq companycat> selected</cfif>>#companycat#</option>
								</cfloop>
							</select>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç">*</label>
						<div class="col col-8 col-xs-12"> 
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					
				
				</div>

				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					
					<div class="form-group" id="item-branch">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfquery name="Get_Country_Info" datasource="#dsn#">
								SELECT COUNTRY_ID, COUNTRY_NAME, COUNTRY_PHONE_CODE, IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
							</cfquery>
							<select name="country_id" id="country_id"   onchange="LoadCity(this.value,'city_id','county_id',0)" tabindex="7"> 
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="Get_Country_Info">
									<option value="#Get_Country_Info.Country_Id#" <cfif (Get_Country_Info.Country_Id eq Country_) or (Get_Country_Info.Is_Default eq 1)> selected</cfif>>#Get_Country_Info.Country_Name#</option>
								</cfloop>
							</select>
						</div>
					</div>

					<div class="form-group" id="item-country">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfif len(city_id_)>
								<cfquery name="Get_City_Info" datasource="#dsn#">
									SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
								</cfquery>
								<select name="city_id" id="city_id"   onchange="LoadCounty(this.value,'county_id','telcod')" tabindex="8">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="Get_City_Info">
										<option value="#Get_City_Info.City_Id#" <cfif len(city_id_) and Get_City_Info.City_Id eq city_id_> selected</cfif>>#Get_City_Info.City_Name#</option>
									</cfloop>
								</select>
							<cfelse>
								<select name="city_id" id="city_id"  onchange="LoadCounty(this.value,'county_id','telcod')" tabindex="8">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								</select>
							</cfif>
						</div>
					</div>

					<div class="form-group" id="item-city">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'>*</label>
						<div class="col col-8 col-xs-12"> 
							<select name="county_id" id="county_id"   tabindex="9">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>						
								<cfif len(county_)>
									<cfquery name="Get_County_Info" datasource="#dsn#">
										SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY ORDER BY COUNTY_NAME
									</cfquery>
									<cfoutput query="Get_County_Info">
										<option value="#Get_County_Info.County_Id#" <cfif Get_County_Info.County_Id eq county_id_>selected</cfif>>#Get_County_Info.County_Name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>

					<div class="form-group" id="item-branch">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'>*</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="semt" id="semt" value="#semt_#" maxlength="30" tabindex="10">
						</div>
					</div>


					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'>*</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="district" id="district" value=""   tabindex="12">
						</div>
					</div>

					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59266.Cadde'>*</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="main_street" id="main_street" value=""   maxlength="50" tabindex="13">
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59267.Sokak'>*</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="street" id="street" value=""   maxlength="50" tabindex="14">
						</div>
					</div>

					<div class="form-group" id="item-no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'>*</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="dukkan_no" id="dukkan_no" value="" maxlength="50" tabindex="15"  >
						</div>
					</div>
					<div class="form-group" id="item-postcode">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51799.Posta Kodu Sayısal Olmalıdır !'></cfsavecontent>
							<cfinput type="text" name="post_code" id="post_code" value="#post_code_#" onKeyUp="isNumber(this);" maxlength="5" validate="integer" tabindex="11" message="#message#"  >
						</div>
					</div>
				</div>

				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55484.e-mail'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="email" id="email"   maxlength="50" tabindex="21">
						</div>
					</div>

					<div class="form-group" id="item-plan">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58079.İnternet'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="homepage" id="homepage" value="http://" maxlength="50" tabindex="22"  >
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'> / <cf_get_lang dictionary_id='57499. Telefon'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="col col-6">
								<cfinput  type="text" name="telcod" id="telcod" value="#telcod_#" onKeyUp="isNumber(this);" maxlength="5" validate="integer" message="#message#" >
							</div>
							<div class="col col-6">
								<cfinput  type="text" name="tel1" id="tel1" value="#tel1_#" onKeyUp="isNumber(this);" maxlength="7" validate="integer" message="#message#" tabindex="16" >
							</div>
				
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51802.Telefon Sayısal Olmalıdır '>!</cfsavecontent>
							<cfinput type="text" name="tel2" id="tel2" onKeyUp="isNumber(this);" validate="integer" message="#message#" maxlength="7" tabindex="16" >
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51802.Telefon No Sayısal Olmalıdır '>!</cfsavecontent>
							<cfinput type="text" name="tel3" id="tel3" onKeyUp="isNumber(this);" maxlength="7" validate="integer" message="#message#" tabindex="17" >
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53933.Cep Tel'></label>
						<div class="col col-8 col-xs-12"> 
							<div class="col col-6">
								<select name="gsm_code" id="gsm_code" style="width:50px;" tabindex="19">
									<option value=""><cf_get_lang dictionary_id='58585.Kod'></option>
									<cfloop query="get_mobilcat">
										<option value="#mobilcat_id#">#mobilcat#</option>
									</cfloop>
								</select>
							</div>
							<div class="col col-6">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='51804.cep tel Sayısal Olmalıdır '>!</cfsavecontent>
								<cfinput type="text" name="gsm_tel" id="gsm_tel" onKeyUp="isNumber(this);" maxlength="7" validate="integer"  message="#message#" tabindex="20" style="width:97px;">
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Fax'></label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51802.Telefon Sayısal Olmalıdır '>! </cfsavecontent>
							<div class="col col-6">
								<cfinput type="text" name="faxcode" id="faxcode" value="#telcod_#" onKeyUp="isNumber(this);" readonly="yes" maxlength="5" message="#message#">
							</div>
							<div class="col col-6">
								<cfinput type="text" name="fax" id="fax" value="#fax_#" onKeyUp="isNumber(this);" maxlength="7"  validate="integer"  message="#message#" tabindex="18" style="width:96px;">
							</div>
						</div>
					</div>
					

					<div class="form-group" id="item-sms">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51571.SMS İstiyor mu'> ?</label>
						<div class="col col-8 col-xs-12"> 
							<input type="checkbox" name="is_sms" id="is_sms">
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30725.GLN Kodu'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="glncode" id="glncode" value="" maxlength="13" tabindex="23"   onkeyup="isNumber(this);">
						</div>
					</div>

					<cfif isdefined("get_transfer_company") and get_transfer_company.recordcount>
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="address" id="address" value="#adres#" style="width:532px;">
							</div>
						</div>

						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="transfer_telephone" id="transfer_telephone" value="#transfer_telephone_#"  >
							</div>
						</div>
					</cfif>
				</div>
			</cfoutput>
			</cf_box_elements>
			<cf_seperator title="#getLang('','Şube Çalışma Bilgileri',51938)#" id="personal_info" is_closed="1">

			<cf_box_elements>
				<cfoutput>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58134.Mikro Bolge Kodu'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="ims_code_id" id="ims_code_id" value="#ims_code_id_#">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='52468.IMS Bölge Kodu Giriniz'>!</cfsavecontent>
								<cfinput type="text" name="ims_code_name" id="ims_code_name" value="#ims_code_name_#" readonly  required="yes" message="#message#"  >
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="il_secimi_kontrol();"><img src="/images/plus_thin.gif" border="0" align="absmiddle" tabindex="23"></span>
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51549.Bölge Satış Müdürü'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<cfif not len(boyut_satis_)>
									<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="#session.ep.position_code#">
									<input type="text" name="satis_muduru" id="satis_muduru" value="#get_emp_info(session.ep.position_code,1,0)#" readonly  >
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&employee_list=1&select_list=1&is_form_submitted=1&branch_id=</cfoutput>'+document.form_add_company.branch_id.value);"></span> <a href="javascript://" onclick="del_gorevli('satis_muduru_id','satis_muduru');"><img src="/images/delete_list.gif" border="0" align="absmiddle" tabindex="24"></a>
								<cfelse>
									<input type="hidden" name="satis_muduru_id" id="satis_muduru_id" value="#satis_muduru_id_#">
									<input type="text" name="satis_muduru" id="satis_muduru" value="#satis_muduru_#" readonly  >
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.satis_muduru_id&field_name=form_add_company.satis_muduru&employee_list=1&select_list=1&is_form_submitted=1&branch_id=</cfoutput>'+document.form_add_company.branch_id.value);"></span> <a href="javascript://" onclick="del_gorevli('satis_muduru_id','satis_muduru');"><img src="/images/delete_list.gif" border="0" align="absmiddle" tabindex="24"></a>
								</cfif>
							</div>
						</div>
					</div>


					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51877.Telefonla Satış Görevlisi'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
							<input type="hidden" name="telefon_satis_id" id="telefon_satis_id" value="#telefon_satis_id_#">
							<input type="text" name="telefon_satis" id="telefon_satis" value="#telefon_satis_#" readonly  >
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.telefon_satis_id&field_name=form_add_company.telefon_satis&employee_list=1&select_list=1&is_form_submitted=1&branch_id=</cfoutput>'+document.form_add_company.branch_id.value);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" tabindex="26"></span> <a href="javascript://" onclick="del_gorevli('telefon_satis_id','telefon_satis');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
						</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satıs Gorevlisi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group"> 
							<input type="hidden" name="plasiyer_id" id="plasiyer_id" value="#plasiyer_id_#">
							<input type="text" name="plasiyer" id="plasiyer" value="#plasiyer_#" readonly  >
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.plasiyer_id&field_name=form_add_company.plasiyer&employee_list=1&select_list=1&is_form_submitted=1&branch_id=</cfoutput>'+document.form_add_company.branch_id.value);"></span> <a href="javascript://" onclick="del_gorevli('plasiyer_id','plasiyer');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>				
						</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52093.Itriyat Satış Görevlisi'></label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="itriyat_id" id="itriyat_id" value="">
								<input type="text" name="itriyat" id="itriyat" readonly style="width:150px;">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.itriyat_id&field_name=form_add_company.itriyat&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');return false"></span> <a href="javascript://" onclick="del_gorevli('itriyat_id','itriyat');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51652.Tahsilatçı'> *</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
							<input type="hidden" name="tahsilatci_id" id="tahsilatci_id" value="#tahsilatci_id_#">
							<input type="text" name="tahsilatci" id="tahsilatci" value="#tahsilatci_#" readonly  >
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.tahsilatci_id&field_name=form_add_company .tahsilatci&employee_list=1&select_list=1&is_form_submitted=1</cfoutput>');return false"></span> <a href="javascript://" onclick="del_gorevli('tahsilatci_id','tahsilatci');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
						</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51924.Cep Sıra No'></label>
							<div class="col col-8 col-xs-12"> 
							<input type="text" name="cep_sira_no" id="cep_sira_no" value="#cep_sira_no_#" maxlength="14" tabindex="34"  >
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39355.Ödeme Yontemi'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="calisma_sekli" id="calisma_sekli" value="#calisma_sekli_#" maxlength="25" tabindex="35"   />
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34241.Cari Hesap Kodu'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="carihesapkod" id="carihesapkod" value="#carihesapkod_#" <cfif len(carihesapkod_)> readonly</cfif> maxlength="10" tabindex="37"  >
							</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kod'></label>
						<div class="col col-8 col-xs-12"> 
							<input  type="text" name="muhasebekod" id="muhasebekod" value="#muhasebekod_#" <cfif len(muhasebekod_)> readonly</cfif> maxlength="10" tabindex="38"  >
						</div>
					</div>
				</div>

				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<!--- <label class="col col-4 col-xs-12"><cf_get_lang no='102.Bölge Satış Müdürü'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label> --->

					<div class="form-group" >
						<label class="col col-4 col-xs-12"> <cf_get_lang dictionary_id='58763.Depo'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<cfif isdefined("attributes.transfer_branch_id") and len(attributes.transfer_branch_id)>
									<input type="hidden" name="branch_id" id="branch_id" value="#get_branch_transfer.branch_id#">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='56984.Lütfen Depo Seçiniz '> !</cfsavecontent>
									<cfinput type="text" name="branch_name" id="branch_name" value="#get_branch_transfer.branch_name#" readonly required="yes" message="#message#" tabindex="36"  >
								<cfelse>
									<input type="hidden" name="branch_id" id="branch_id" value="#listgetat(session.ep.user_location, 2, '-')#">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='56984.Lütfen Depo Seçiniz '> !</cfsavecontent>
									<cfinput type="text" name="branch_name" id="branch_name" value="#get_branch.branch_name#" required="yes" message="#message#" tabindex="36"  >
									<span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_name=form_add_company.branch_name&field_branch_id=form_add_company.branch_id&is_special=1</cfoutput>');"></span>
								</cfif>
							</div>
						</div>
					</div>

					<div class="form-group" >
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51549.Bölge Satış Müdürü'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="boyut_satis" id="boyut_satis" value="#boyut_satis_#" onkeyup="isNumber(this);" maxlength="3" tabindex="25" style="width:30px;">
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51877.Telefonla Satış Görevlisi'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="boyut_telefon" id="boyut_telefon" value="#boyut_telefon_#" onkeyup="isNumber(this);" maxlength="3" tabindex="27" style="width:30px;">
						</div>
					</div>

						
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51548.Saha Satıs Gorevlisi'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="boyut_plasiyer" id="boyut_plasiyer" value="#boyut_plasiyer_#" onkeyup="isNumber(this);" maxlength="3" tabindex="29" style="width:30px;">

						</div>
					
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51690.İtriyat Satış Görevlisi'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="boyut_itriyat" id="boyut_itriyat" value="#boyut_itriyat_#" onkeyup="isNumber(this);" maxlength="3" tabindex="31" style="width:30px;">
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51652.Tahsilatçı'> <cf_get_lang dictionary_id='52136.Boyut Kodu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="boyut_tahsilat" id="boyut_tahsilat" value="#boyut_tahsilat_#" onkeyup="isNumber(this);" maxlength="3" tabindex="33" style="width:30px;">
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51679.Depoya Uzaklık (Km)'> *</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='51680.Depoya Uzaklık Sayısal Olmalıdır'> !</cfsavecontent>
							<cfinput name="depot_km" id="depot_km" onKeyUp="isNumber(this);" value="#depot_km_#" validate="float" message="#message1#" tabindex="39" style="width:150;">
						</div>
					</div>
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='715.Dakika'> *</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id='52034.Lütfen Dakika Cinsinden Depoya Uzaklık Giriniz'> !</cfsavecontent>
							<cfinput name="depot_dak" id="depot_dak" value="#depot_dak_#" validate="float" message="#message1#" tabindex="40" style="width:150;">
						</div>
					</div>

					<div class="form-group" >
						
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51567.Müşterinin Genel Konumu'><cfif not isdefined("attributes.transfer_branch_id")></cfif> *</label>
						<div class="col col-8 col-xs-12"> 
							<div class="col col-11">
							<select name="customer_position" id="customer_position" style=" width:150px;height:50px;" multiple></select>
							</div>
							<div class="col col-1">
								<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_member_position_detail&field_name=form_add_company.customer_position</cfoutput>');"><img src="/images/plus_list.gif" border="0" align="top" tabindex="41" /></a><br />
								<a href="javascript://" onclick="remove_field('customer_position');"><img src="/images/delete_list.gif" border="0" alt="<cf_get_lang dictionary_id='57463.Sil'>" style="cursor=hand" align="top"></a>
							</div>
						</div>
					</div>


					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58984.Puan'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="puan" id="puan" value="#tlFormat(0)#" tabindex="42" readonly  >
						</div>
					</div>
				</div>

				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49667.Risk Limiti'>*</label>
						<div class="col col-8 col-xs-12"> 
							<div class="col col-6">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57689.risk'><cf_get_lang dictionary_id='61824.Giriniz'></cfsavecontent>
								<cfinput type="text" name="risk_limit" id="risk_limit" value="#tlformat(risk_limit_)#" validate="float" message="#message#" passthrough = "onKeyup='return(FormatCurrency(this,event));'" class="moneybox" tabindex="43" style="width:100px;">
							</div>
							<div class="col col-6">
								<select name="money_type" id="money_type" style="width:47px;" tabindex="44">
									<cfloop query="get_money">
										<option value="#money#" <cfif money eq session.ep.money> selected</cfif>>#money#</option>
									</cfloop>
								</select>
							</div>
						</div>
					</div>

					<div class="form-group" >
						
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51676.İlişki Tipi'> *</label>
						<div class="col col-8 col-xs-12"> 
							<select name="resource" id="resource"   tabindex="45">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfloop query="get_resource">
									<option value="#resource_id#" <cfif resource_id eq resource_id_> selected</cfif>>#resource#</option>
								</cfloop>
							</select>
						</div>
					</div>

					
					<div class="form-group" >
						
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57057.Bölge Kodu'> *</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="bolge_kodu" id="bolge_kodu" value="#bolge_kodu_#" maxlength="10"  tabindex="46"  >
						</div>
					</div>

					<div class="form-group" >
						
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51921.Alt Bölge Kodu'> *</label>
						<div class="col col-8 col-xs-12"> 
							<input type="text" name="altbolge_kodu" id="altbolge_kodu" value="#altbolge_kodu_#" maxlength="10" tabindex="47"  >
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51683.Şube Açılış Tarihi'> *</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group" >
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='51684.Şube Açılış Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfif not len(open_date_)>
									<cfinput type="text" name="open_date" id="open_date" value="#dateformat(now(),dateformat_style)#" required="yes" message="#message#" validate="#validate_style#" tabindex="48"  >
								<cfelse>
									<cfinput type="text" name="open_date" id="open_date" value="#dateformat(open_date_,dateformat_style)#" required="yes" message="#message#" validate="#validate_style#" tabindex="48"  >
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="open_date"></span>
								</div>
						</div>
					</div>


					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang no='653.Ort Vade - Açılış Sür - MF Gün'></label>
						<div class="col col-8 col-xs-12"> 
							<div class="col col-4">
								<input type="text" name="average_due_date" id="average_due_date" value="#average_due_date_#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="49" style="width:47px;">
							</div>
							<div class="col col-4">
								<input type="text" name="opening_period" id="opening_period" value="#opening_period_#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="2" tabindex="50" style="width:47px;">
							</div>
							<div class="col col-4">
								<input type="text" name="mf_day" id="mf_day" value="#mf_day_#" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="3" tabindex="51" style="width:47px;">
							</div>
						</div>
					</div>

					<div class="form-group" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51685.Satis Statusu Notlar'></label>
						<div class="col col-8 col-xs-12"> 
							<textarea type="text" name="status" id="status" maxlength="100" tabindex="52" style="width:150px;height:52px;">#status_#</textarea>
						</div>
					</div>
				</div>
			</cfoutput>
			</cf_box_elements>

				<cf_seperator title="#getLang('','Kişisel ve Diğer Bilgiler',51844)#" id="personal_info" is_closed="1">

			<cf_box_elements>
				<cfoutput>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group" > 
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='52364.Doğum Tarihi Formatını Doğru Giriniz'></cfsavecontent>
								<cfinput type="text" name="birthday" id="birthday" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:150;" tabindex="53">
								<span class="input-group-addon"><cf_wrk_date_image date_field="birthday"></span>

							</div>
							</div>
						</div>
	
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51527.Cinsiyeti'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="sexuality" id="sexuality" style="width:150;" tabindex="54">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1"><cf_get_lang dictionary_id='51610.Bay'></option>
									<option value="2"><cf_get_lang dictionary_id='51611.Bayan'></option>
								</select>
							</div>
						</div>
	
						
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51522.Evlenme Tarihi'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="input-group" > 
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='52365.Lütfen Evlenme Tarihi Formatını Doğru Giriniz'> !</cfsavecontent>
									<cfinput type="text" name="marriagedate" id="marriagedate" value="" maxlength="10" validate="#validate_style#" message="#message#" tabindex="55" style="width:150;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="marriagedate"></span>
								</div>
							</div>
						</div>
	
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51525.Mez Olduğu Fakülte'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="faculty" id="faculty" style="width:150;" tabindex="56">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_universty">
										<option value="#university_id#,#university_name#">#university_name#</option>
									</cfloop>
									</select>
							</div>
						</div>
	
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
							<div class="col col-8 col-xs-12"> 
								<input  type="text" name="title" id="title"   maxlength="50" value="" tabindex="57">
							</div>
						</div>

					</div>

					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="birth_place" id="birth_place" maxlength="100" tabindex="58" style="width:150;">
							</div>
						</div>
	
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51521.Medeni Hali'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="marital_status" id="marital_status"  tabindex="59">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1"><cf_get_lang dictionary_id='46541.Bekar'></option>
									<option value="2"><cf_get_lang dictionary_id='55743.Evli'></option>
									<option value="3"><cf_get_lang dictionary_id='51555.Dul'></option>
								</select>
							</div>
						</div>
	
						
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56137.Çocuk Sayısı'></label>
							<div class="col col-8 col-xs-12"> 
								<input type="text" name="child_number" id="child_number" onkeyup="isNumber(this);" maxlength="50" tabindex="60" >
							</div>
						</div>
	
						<div class="form-group" >
							
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55845.Mezuniyet Yılı'></label>
							<div class="col col-8 col-xs-12"> 
								<select name="graduate_year" id="graduate_year" tabindex="61">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop from="1920" to="#2022#" index="i">
										<option value="#i#">#i#</option>
									</cfloop>
									</select>
							</div>
						</div>

					</div>

					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51597.Bilgisayar Sayısı'></label>
							<div class="col col-8 col-xs-12">
								<select name="pc_number" id="pc_number" tabindex="62">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_pc_number">
										<option value="#unit_id#">#unit_name#</option>
									</cfloop>
									</select>
							</div>
						</div>

						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51569.İnternet Bağlantısı'></label>
							<div class="col col-8 col-xs-12">
								<select name="net_connection" id="net_connection"   tabindex="63">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_net_connection">
										<option value="#connection_id#">#connection_name#</option>
									</cfloop>
									</select>
							</div>
						</div>

						
						<div class="form-group" >
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56599.Hobileri'></label>
							<div class="col col-8 col-xs-12"> 
								<div class="col col-11">
									<select name="hobby" id="hobby" style=" width:150px;height:45px;" multiple></select>
								</div>
								<div class="col col-1">
									<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_hobby_detail&field_name=form_add_company.hobby</cfoutput>');"><img src="/images/plus_list.gif" border="0" align="top" tabindex="61"></a><br/>
									<a href="javascript://" onclick="remove_field('hobby');"><img src="/images/delete_list.gif" border="0" style="cursor=hand" align="top"></a>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_elements>

			<cf_box_footer>
				<cf_workcube_buttons is_upd="0" add_function="kontrol()">
			</cf_box_footer>

		</cfform>

	</cf_box>

</div>

<script language="JavaScript">

	var country_ = document.all.country_id.value;
	if(country_.length)
		LoadCity(country_,'city_id','county_id',0);

function remove_field(field_option_name)
{
	field_option_name_value = eval('document.form_add_company.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
		{
			field_option_name_value.options.remove(i);
		}	
	}
}


phone_code_list = new Array(<cfoutput>#valuelist(get_city.phone_code)#</cfoutput>);
country_list = new Array(<cfoutput><cfloop query=get_city>"#get_city.country_name#"<cfif not currentrow eq recordcount>,</cfif></cfloop></cfoutput>);
country_ids = new Array(<cfoutput>#valuelist(get_city.country_id)#</cfoutput>);

/* Kullanilmiyorsa kaldirilsin 20120827
function pencere_pos()
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_company_prerecords&company_name='+ document.form_add_company.fullname.value +'&company_partner_name=' + document.form_add_company.company_partner_name.value +'&company_partner_surname='+ document.form_add_company.company_partner_surname.value +'&company_partner_tax_no='+ document.form_add_company.tax_num.value +'&company_partner_tel_code='+ document.form_add_company.telcod.value +'&company_partner_tel=' + document.form_add_company.tel1.value,'wide'); 
}
*/

function il_secimi_kontrol()
{
	if(document.form_add_company.city_id.selectedIndex == '')
	{
		alert("<cf_get_lang dictionary_id='58944.Oncelikli'><cf_get_lang dictionary_id='56490.İl Seçiniz'>");
	}
	else
	{
		s_city_ = parseInt(document.form_add_company.city_id.selectedIndex) - 1;
		plate_code_list = new Array(<cfoutput><cfloop query=get_city>"#get_city.plate_code#"<cfif not currentrow eq recordcount>,</cfif></cfloop></cfoutput>);
		let plate_code_list2= plate_code_list.filter((e)=>e.match(/\d/g))
		if(plate_code_list2.length == 0 )
			city_plate_code = '';
			
		else
			city_plate_code = plate_code_list2[s_city_];
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=form_add_company.ims_code_name&field_id=form_add_company.ims_code_id&plate_code='+city_plate_code+'&bsm_id='+document.form_add_company.satis_muduru_id.value);
	}
}


function select_all(selected_field)
{
	var m = eval("document.form_add_company." + selected_field + ".length");
	for(i=0;i<m;i++)
	{
		eval("document.form_add_company."+selected_field+"["+i+"].selected=true");
	}
}

function del_gorevli(field1,field2)
{
	var deger1 = eval("document.form_add_company." + field1);
	var deger2 = eval("document.form_add_company." + field2);
	deger1.value="";
	deger2.value="";
}

function kontrol()
{
	select_all('hobby');
	select_all('customer_position');
	

	if(document.form_add_company.fullname.value.length == "")
	{
		alert("<cf_get_lang no='34.İş Yeri Adı Girmelisiniz'> !");
		return false;
	}
	if(document.form_add_company.company_partner_name.value.length == "")
	{
		alert("<cf_get_lang no='67.Müşteri Adı Girmelisiniz'> !");
		return false;
	}
	if(document.form_add_company.company_partner_surname.value.length == "")
	{
		alert("<cf_get_lang no='55.Lütfen Müşteri Soyadı Giriniz'> !");
		return false;
	}

	if(document.form_add_company.tax_num.value.length == "")
	{
		alert("<cf_get_lang no='57.Lütfen Vergi Numarası Giriniz'> !");
		return false;
	}	
	
	// Musteri Tipi Olayi
	x = document.form_add_company.company_work_type.selectedIndex;
	if (document.form_add_company.company_work_type[x].value == "")
	{
		alert("<cf_get_lang no ='1031.Şirket Tipi Seçiniz'>  !");
		return false;
	}
	else
	{
		if(document.form_add_company.company_work_type[x].value == 1)
		{
			if(document.form_add_company.tax_num.value.length != 11)
			{
				alert("<cf_get_lang no ='1022.TC Kimlik Numarası 11 Hane Olmalıdır'> !");
				return false;
			}
		}
		else
		{
			if(document.form_add_company.tax_num.value.length != 10)
			{
				alert("<cf_get_lang no ='920.Vergi Numarası 10 Hane Olmalıdır'> !");
				return false;
			}
		}
	}
	y = document.form_add_company.companycat_id.selectedIndex;
	if (document.form_add_company.companycat_id[y].value == "")
	{
		alert("<cf_get_lang no ='325.Lütfen Kategori Seçiniz'> !");
		return false;
	}
	
	//Query sayfasinda yapilan kontroller, geri donuldugunde veriler kayboldugundan on tarafa alindi FBS 20100408
	if(document.form_add_company.company_work_type.value  != '' && document.form_add_company.companycat_id.value != '')
	{
		if (document.form_add_company.company_work_type.value == 1 && list_find('4,5,6,64',document.form_add_company.companycat_id.value))
		{
			get_TaxNumber_Control = wrk_query("SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '" + document.form_add_company.tax_num.value + "'","dsn");
			get_TcIdentity_Control = wrk_query("SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE TC_IDENTITY = '" + document.form_add_company.tax_num.value + "'","dsn");
			if(get_TaxNumber_Control.recordcount || get_TcIdentity_Control.recordcount)
			{
				alert("<cf_get_lang no ='984.Aynı Vergi Numarası veya TC Kimlik No İle Eczane Var Kaydınızı Kontrol Ediniz'> !");
				return false;
			}
		}
	}
	
	if(document.form_add_company.tax_office.value.length == "")
	{
		alert("<cf_get_lang no='56.Lütfen Vergi Dairesi Giriniz'> !");
		return false;
	}
	if(document.form_add_company.main_street.value.length == "")
	{
		alert("<cf_get_lang no='61.Lütfen Cadde Giriniz'> !");
		return false;
	}
	if(document.form_add_company.street.value.length == "")
	{
		alert("<cf_get_lang no='62.Lütfen Sokak Giriniz'> !");
		return false;
	}
	if(document.form_add_company.dukkan_no.value.length == "")
	{
		alert("<cf_get_lang no='502.Lütfen İşyeri No Giriniz'> !");
		return false;
	}
	if(document.form_add_company.telcod.value.length == "")
	{
		alert("<cf_get_lang no='159.Lütfen Telefon Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.tel1.value.length == "")
	{
		alert("<cf_get_lang no='58.Lütfen Telefon No Giriniz'> !");
		return false;
	}
	if(document.form_add_company.district.value.length == "")
	{
		alert("<cf_get_lang no='503.Lütfen Mahalle Giriniz'> !");
		return false;
	}
	if(document.form_add_company.semt.value.length == "")
	{
		alert("<cf_get_lang no='64.Lütfen Semt Giriniz'> !");
		return false;
	}
	if(document.form_add_company.county_id.value.length == "")
	{
		alert("<cf_get_lang no='65.Lütfen İlçe Giriniz'> !");
		return false;
	}
	if (document.form_add_company.city_id.value.length == "")
	{
		alert("<cf_get_lang no='283.Lütfen İl Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.country_id.value.length == "")
	{
		alert("<cf_get_lang no='504.Lütfen Ülke Giriniz'> !");
		return false;
	}
	if(document.form_add_company.branch_id.value.length == "")
	{
		alert("<cf_get_lang no='234.Lütfen Şube Giriniz'> !");
		return false;
	}
	
	<cfif isDefined("xml_glncode_required_membercat") and Len(xml_glncode_required_membercat)>
	var Required_Category_ = list_find('<cfoutput>#xml_glncode_required_membercat#</cfoutput>',document.form_add_company.companycat_id.value);
	if(Required_Category_ != 0 && document.form_add_company.glncode.value == '')
	{
		alert("<cf_get_lang dictionary_id='33602.Lütfen GLN Kod Değeri Giriniz'>!");
		document.form_add_company.glncode.focus();
		return false;
	}
	</cfif>
	if(document.form_add_company.glncode.value != '' && document.form_add_company.glncode.value.length != 13)
	{
		alert("<cf_get_lang dictionary_id='30293.GLN Kod Alanı 13 Hane Olmalıdır'>!");
		document.form_add_company.glncode.focus();
		return false;
	}
	
	if(document.form_add_company.ims_code_id.value.length == "")
	{
		alert("<cf_get_lang no='68.Lütfen IMS Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.open_date.value.length == "")
	{
		alert("<cf_get_lang no='237.Lütfen Şube Açılış Tarihi Giriniz'> !");
		return false;
	}
		
	if(document.form_add_company.satis_muduru.value.length == "")
	{
		alert("<cf_get_lang no='577.Lütfen Satış Müdürü Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_satis.value.length == "")
	{
		alert("<cf_get_lang no='578.Lütfen Satış Müdürü Boyut Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.telefon_satis.value.length == "")
	{
		alert("<cf_get_lang no='579.Lütfen Telefonla Satış Görevlisi Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.tahsilatci.value.length == "")
	{
		alert("<cf_get_lang no='580.Lütfen Tahsilat Görevlisi Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_tahsilat.value.length == "")
	{
		alert("<cf_get_lang no='581.Lütfen Tahsilat Görevlisi Boyut Kodu Giriniz'> !");
		return false;
	}
	if(document.form_add_company.boyut_telefon.value.length == "")
	{
		alert("<cf_get_lang no='582.Lütfen Telefonla Satış Görevlisi Boyut Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.bolge_kodu.value.length == "")
	{
		alert("<cf_get_lang no='583.Lütfen Bölge Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.altbolge_kodu.value.length == "")
	{
		alert("<cf_get_lang no='584.Lütfen Alt Bölge Kodu Seçiniz'> !");
		return false;
	}
	if(document.form_add_company.risk_limit.value.length == "")
	{
		alert("<cf_get_lang no='585.Lütfen Risk Limiti Giriniz'> !");
		return false;
	}
	if(document.form_add_company.depot_km.value.length == "")
	{
		alert("<cf_get_lang no='586.Lütfen Km Cinsinden Depoya Uzaklık Giriniz'> !");
		return false;
	}
	if(document.form_add_company.depot_dak.value.length == "")
	{
		alert("<cf_get_lang no='587.Lütfen Dakika Cinsinden Depoya Uzaklık Giriniz'> !");
		return false;
	}
	<cfif not isdefined("attributes.transfer_branch_id")>
		if(document.form_add_company.customer_position.length == 0)
		{
			alert("<cf_get_lang no='588.Lütfen Müşterinin Genel Konumunu Giriniz'> !");
			return false;
		}
	</cfif>
	if(document.form_add_company.is_sms.checked == true)
	{
		if(document.form_add_company.gsm_tel.value == "")
		{
			alert("<cf_get_lang no='576.Sms İstiyor mu Seçeneğini İşaretlediniz. Lütfen Eczacının Cep Telefonunu Giriniz'> !");
			return false;
		}
		x = document.form_add_company.gsm_code.selectedIndex;
		if (document.form_add_company.gsm_code[x].value == "")
		{ 
			alert ("<cf_get_lang no='594.Sms İstiyor mu Seçeneğini İşaretlediniz. Eczacının Cep Telefonunu Alan Kodunu Giriniz'> !");
			return false;
		}
	}

	// Eğer Cari Hesap Kod Dolu İse
	if(document.form_add_company.carihesapkod.value != "")
	{
		if(document.form_add_company.carihesapkod.value.length != 10)
		{
			alert("<cf_get_lang no='589.Cari Hesap Kodu 10 Hane Olmalıdır'> !");
			return false;
		}
		var numberformat = "1234567890";
		for (var i = 1; i < form_add_company.carihesapkod.value.length; i++)
		{
			check_char = numberformat.indexOf(form_add_company.carihesapkod.value.charAt(i));
			if (check_char < 0)
			{
				alert("<cf_get_lang no='590.Cari Hesap Kodu Sayısal Olmalıdır'> !");
				return false;
			}
		}
	}
	
	//Query sayfasinda yapilan kontroller, geri donuldugunde veriler kayboldugundan on tarafa alindi FBS 20100408
	if(document.form_add_company.carihesapkod.value != '')
	{
		get_CariHesap_Control = wrk_query("SELECT RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CARIHESAPKOD = '" + document.form_add_company.carihesapkod.value + "' AND BRANCH_ID = " + document.form_add_company.branch_id.value,"dsn");
		if(get_CariHesap_Control.recordcount)
		{
			alert("<cf_get_lang no ='983.Aynı Cari Hesap Kodu İle Kayıtlı Müşteriniz Var  Bu Cari Hesap Kodu İle Kayıt Yapamazsınız'> !");
			return false;
		}
	}

	// Eğer Muhasebe Kod Dolu İse
	if(document.form_add_company.muhasebekod.value != "")
	{
		if(document.form_add_company.muhasebekod.value.length != 10)

		{
			alert("<cf_get_lang no='591.Muhasebe Kodu 10 Hane Olmalıdır'> !");
			return false;
		}
		var numberformat = "1234567890";
		for (var i = 1; i < form_add_company.muhasebekod.value.length; i++)
		{
			check_char = numberformat.indexOf(form_add_company.muhasebekod.value.charAt(i));
			if (check_char < 0)
			{
				alert("<cf_get_lang no='592.Muhasebe Kodu Sayısal Olmalıdır'> !");
				return false;
			}
		}
	}
	x = document.form_add_company.resource.selectedIndex;
	if (document.form_add_company.resource[x].value == "")
	{ 
		alert ("<cf_get_lang no='593.İlişki Başlangıcı Giriniz'> !");
		return false;
	}
		
	form_add_company.puan.readonly = false ;
	form_add_company.puan.value = filterNum(form_add_company.puan.value);	
	form_add_company.risk_limit.value = filterNum(form_add_company.risk_limit.value);	
	
	return process_cat_control();
}

function kontrol_company_prerecords(return_id)
{
	if ((form_add_company.satis_muduru.value != "") && (form_add_company.satis_muduru_id.value != ""))
		url_satis_muduru_id = form_add_company.satis_muduru_id.value;
	else
		url_satis_muduru_id = "";
	
	if ((form_add_company.plasiyer.value != "") && (form_add_company.plasiyer_id.value != ""))
		url_plasiyer_id = form_add_company.plasiyer_id.value;
	else
		url_plasiyer_id = "";

	if ((form_add_company.telefon_satis.value != "") && (form_add_company.telefon_satis_id.value != ""))
		url_telefon_satis_id = form_add_company.telefon_satis_id.value;
	else
		url_telefon_satis_id = "";

	form_add_company.risk_limit.value = filterNum(form_add_company.risk_limit.value);
	if(return_id)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_check_company_prerecords&fullname=' + document.form_add_company.fullname.value +'&company_partner_name='+document.form_add_company.company_partner_name.value+'&company_partner_surname='+document.form_add_company.company_partner_surname.value+'&tax_num='+document.form_add_company.tax_num.value+'&tel1='+document.form_add_company.tel1.value+'&telcod='+document.form_add_company.telcod.value+'&branch_id='+document.form_add_company.branch_id.value+'&satis_muduru_id='+url_satis_muduru_id+'&plasiyer_id='+url_plasiyer_id+'&telefon_satis_id='+url_telefon_satis_id+'&risk_limit='+document.form_add_company.risk_limit.value+'&money_type='+document.form_add_company.money_type.value+'&resource='+document.form_add_company.resource.value+'&tahsilatci_id='+document.form_add_company.tahsilatci_id.value+'&itriyat_id='+document.form_add_company.itriyat_id.value+'&status='+document.form_add_company.status.value+'&return_id='+return_id);
	}
	else
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_dsp_check_company_prerecords&fullname=' + document.form_add_company.fullname.value +'&company_partner_name='+document.form_add_company.company_partner_name.value+'&company_partner_surname='+document.form_add_company.company_partner_surname.value+'&tax_num='+document.form_add_company.tax_num.value+'&tel1='+document.form_add_company.tel1.value+'&telcod='+document.form_add_company.telcod.value+'&branch_id='+document.form_add_company.branch_id.value+'&satis_muduru_id='+url_satis_muduru_id+'&plasiyer_id='+url_plasiyer_id+'&telefon_satis_id='+url_telefon_satis_id+'&risk_limit='+document.form_add_company.risk_limit.value+'&money_type='+document.form_add_company.money_type.value+'&resource='+document.form_add_company.resource.value+'&tahsilatci_id='+document.form_add_company.tahsilatci_id.value+'&itriyat_id='+document.form_add_company.itriyat_id.value+'&status='+document.form_add_company.status.value+'&return_id=0');
	}
	return false;
}
</script>
