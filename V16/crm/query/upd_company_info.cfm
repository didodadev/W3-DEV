<cfif len(attributes.carihesapkod)>
	<cfquery name="GET_CARI" datasource="#DSN#">
		SELECT
			RELATED_ID
		FROM
			COMPANY_BRANCH_RELATED
		WHERE
			MUSTERIDURUM IS NOT NULL AND
			CARIHESAPKOD = '#attributes.carihesapkod#' AND 
			BRANCH_ID = #attributes.branch_id# AND
			RELATED_ID <> #attributes.related_id#
	</cfquery>
	<cfif get_cari.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='983.Aynı Cari Hesap Kodu İle Kayıtlı Müşteriniz Var ! Bu Cari Hesap Kodu İle Kayıt Yapamazsınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="CONTROL_COMPANY" datasource="#DSN#">
	SELECT W_KODU FROM COMPANY_BOYUT_DEPO_KOD WHERE W_KODU = #attributes.branch_id#
</cfquery>
<cfif control_company.recordcount eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no ='982.Müşteri Eklemek İstediğiniz Depo Boyut İle Uyumlu Bir Depo Değil'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.company_partner_name = trim(attributes.company_partner_name);
	attributes.company_partner_surname = trim(attributes.company_partner_surname);
	attributes.tax_num = trim(attributes.tax_num);
	attributes.tel1 = trim(attributes.tel1);
	attributes.telcod = trim(attributes.telcod);
	attributes.is_record = false ;
</cfscript>
<cftry>
	<cftransaction>
		<cfif len(attributes.birthday)><cf_date tarih='attributes.birthday'></cfif>
		<cfif len(attributes.marriage_date)><cf_date tarih='attributes.marriage_date'></cfif>
		<cfif len(attributes.open_date)><cf_date tarih='attributes.open_date'></cfif>
		<cfquery name="ADD_COMPANY" datasource="#DSN#">
			UPDATE
				COMPANY
			SET
				COMPANYCAT_ID = #attributes.companycat_id#,
				FULLNAME = '#attributes.fullname#',
				NICKNAME = '#attributes.fullname#',
				TAXOFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
				TAXNO = <cfif len(attributes.tax_num)>'#attributes.tax_num#'<cfelse>NULL</cfif>,
				CITY = <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
				COMPANY_TELCODE = <cfif len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
				COMPANY_TEL1 = <cfif len(attributes.tel1)>'#attributes.tel1#'<cfelse>NULL</cfif>,
				IMS_CODE_ID = #attributes.ims_code_id#,
				COUNTY = <cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				COMPANY_TEL2 = <cfif len(attributes.tel2)>'#attributes.tel2#'<cfelse>NULL</cfif>,
				SEMT = <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				COMPANY_TEL3 = <cfif len(attributes.tel3)>'#attributes.tel3#'<cfelse>NULL</cfif>,
				DISTRICT = <cfif len(attributes.district)>'#attributes.district#'<cfelse>NULL</cfif>,
				COMPANY_FAX_CODE = <cfif len(attributes.faxcode)>'#attributes.faxcode#'<cfelse>NULL</cfif>,
				COMPANY_FAX = <cfif len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
				MAIN_STREET = <cfif len(attributes.main_street)>'#attributes.main_street#'<cfelse>NULL</cfif>,
				COMPANY_EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				STREET = <cfif len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
				HOMEPAGE = <cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				DUKKAN_NO = <cfif len(attributes.dukkan_no)>'#attributes.dukkan_no#'<cfelse>NULL</cfif>,
				COMPANY_ADDRESS = <cfif len(attributes.district) or len(attributes.main_street) or len(attributes.street) or len(attributes.dukkan_no)>'#attributes.district# #attributes.main_street# #attributes.street# #attributes.dukkan_no#'<cfelse>NULL</cfif>,
				COUNTRY = <cfif len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
				COMPANY_POSTCODE = <cfif len(attributes.post_code)>'#attributes.post_code#'<cfelse>NULL</cfif>,
				CON_OPEN_DATE = #now()#,
				COMPANY_WORK_TYPE = #attributes.company_work_type#,
				GLNCODE = <cfif isdefined("attributes.glncode") and Len(attributes.glncode)>'#attributes.glncode#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'			
			WHERE
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				TITLE = <cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				COMPANY_ID = #attributes.cpid#,
				COMPANY_PARTNER_NAME = '#attributes.company_partner_name#',
				COMPANY_PARTNER_SURNAME = '#attributes.company_partner_surname#',
				IS_SMS = <cfif isdefined("attributes.is_sms")>1<cfelse>0</cfif>,
				SEX = <cfif len(attributes.sexuality)>#attributes.sexuality#<cfelse>NULL</cfif>,
				GRADUATE_YEAR = <cfif len(attributes.graduate_year)>#attributes.graduate_year#<cfelse>NULL</cfif>,
				MAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				MOBIL_CODE = <cfif len(attributes.gsm_code)>'#attributes.gsm_code#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(attributes.gsm_tel)>'#attributes.gsm_tel#'<cfelse>NULL</cfif>,
				HOMEPAGE = <cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				TC_IDENTITY = <cfif attributes.company_work_type eq 1>'#attributes.tax_num#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_MEMBER = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER_DETAIL
			SET
				BIRTHDATE = <cfif len(attributes.birthday)>#attributes.birthday#<cfelse>NULL</cfif>,
				BIRTHPLACE = <cfif len(attributes.birth_place)>'#attributes.birth_place#'<cfelse>NULL</cfif>,
				MARRIED_DATE = <cfif len(attributes.marriage_date)>#attributes.marriage_date#<cfelse>NULL</cfif>,
				MARRIED = <cfif len(attributes.marital_status)>#attributes.marital_status#<cfelse>NULL</cfif>,
				FACULTY = <cfif len(attributes.faculty)>#listfirst(attributes.faculty, ',')#<cfelse>NULL</cfif>,
				CHILD = <cfif len(attributes.child_number)>#attributes.child_number#<cfelse>NULL</cfif>,
				EDU1_FINISH = <cfif len(attributes.graduate_year)>#attributes.graduate_year#<cfelse>NULL</cfif>,
				EDU1 = <cfif len(attributes.faculty)>'#listlast(attributes.faculty, ',')#'<cfelse>NULL</cfif>
			WHERE
				PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
			SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfquery name="UPD_COMPANY_BRANCH_RELATED" datasource="#DSN#">
			UPDATE
				COMPANY_BRANCH_RELATED
			SET
				OUR_COMPANY_ID = #get_our_company.company_id#,
				BRANCH_ID = #attributes.branch_id#,
				<!--- BK 20080105 kapatti 90 gun sonra silinsin IS_SELECT = 0, --->
				SALES_DIRECTOR = <cfif len(attributes.satis_muduru_id) and len(attributes.satis_muduru)>#attributes.satis_muduru_id#<cfelse>NULL</cfif>,
				TEL_SALE_PREID = <cfif len(attributes.telefon_satis_id) and len(attributes.telefon_satis)>#attributes.telefon_satis_id#<cfelse>NULL</cfif>,
				PLASIYER_ID = <cfif len(attributes.plasiyer_id) and len(attributes.plasiyer)>#attributes.plasiyer_id#<cfelse>NULL</cfif>,
				DEPO_STATUS = #attributes.process_stage#,
				COMP_STATUS = <cfif len(attributes.status)>'#attributes.status#'<cfelse>NULL</cfif>,
				RELATION_START = <cfif len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#',
				OPEN_DATE = <cfif len(attributes.open_date)>#attributes.open_date#<cfelse>NULL</cfif>,
				CEP_SIRA = <cfif len(attributes.cep_sira_no)>'#attributes.cep_sira_no#'<cfelse>NULL</cfif>,
				CARIHESAPKOD = <cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#'<cfelse>NULL</cfif>,
				DEPOT_KM = <cfif len(attributes.depot_km)>#attributes.depot_km#<cfelse>NULL</cfif>,
				DEPOT_DAK = <cfif len(attributes.depot_dak)>#attributes.depot_dak#<cfelse>NULL</cfif>,
				PUAN = <cfif len(attributes.puan) and isnumeric(attributes.puan)>#attributes.puan#<cfelse>NULL</cfif>,
				BOLGE_KODU = <cfif len(attributes.bolge_kodu)>'#attributes.bolge_kodu#'<cfelse>NULL</cfif>,
				ALTBOLGE_KODU = <cfif len(attributes.altbolge_kodu)>'#attributes.altbolge_kodu#'<cfelse>NULL</cfif>,
				CALISMA_SEKLI = <cfif len(attributes.calisma_sekli)>'#attributes.calisma_sekli#'<cfelse>NULL</cfif>,
				MUHASEBEKOD = <cfif len(attributes.muhasebekod)>'#attributes.muhasebekod#'<cfelse>NULL</cfif>,
				ITRIYAT_GOREVLI = <cfif len(attributes.itriyat_id)>#attributes.itriyat_id#<cfelse>NULL</cfif>,
				TAHSILATCI = <cfif len(attributes.tahsilatci_id)>#attributes.tahsilatci_id#<cfelse>NULL</cfif>,
				BOYUT_TAHSILAT = <cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#'<cfelse>NULL</cfif>,
				BOYUT_ITRIYAT = <cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#'<cfelse>NULL</cfif>,
				BOYUT_TELEFON = <cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#'<cfelse>NULL</cfif>,
				BOYUT_PLASIYER = <cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#'<cfelse>NULL</cfif>,
				BOYUT_BSM = <cfif len(attributes.boyut_satis)>'#attributes.boyut_satis#'<cfelse>NULL</cfif>,
				MUSTERIDURUM = 3,
				AVERAGE_DUE_DATE = <cfif len(attributes.average_due_date)>#attributes.average_due_date#<cfelse>NULL</cfif>,
				OPENING_PERIOD = <cfif len(attributes.opening_period)>#attributes.opening_period#<cfelse>NULL</cfif>,
				MF_DAY = <cfif len(attributes.mf_day)>#attributes.mf_day#<cfelse>NULL</cfif>
			WHERE
				COMPANY_ID = #attributes.cpid# AND
				RELATED_ID = #attributes.related_id#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_STORES_RELATED" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER_STORES_RELATED
			SET
				OUR_COMPANY_ID = #get_our_company.company_id#
			WHERE
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="ADD_COMPANY_SERVICE_INFO" datasource="#DSN#">
			UPDATE
				COMPANY_SERVICE_INFO
			SET
				OUR_COMPANY_ID = #get_our_company.company_id#,
				PC_NUMBER = <cfif len(attributes.pc_number)>#attributes.pc_number#<cfelse>NULL</cfif>,
				NET_CONNECTION = <cfif len(attributes.net_connection)>#attributes.net_connection#<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="DEL_HOBBY" datasource="#DSN#">
			DELETE FROM
				COMPANY_PARTNER_HOBBY
			WHERE
				COMPANY_ID = #attributes.cpid# AND
				PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<cfif isdefined('attributes.hobby')>
			<cfloop list="#attributes.hobby#" index="i">
				<cfquery name="ADD_HOBBY" datasource="#DSN#">
					INSERT INTO 
						COMPANY_PARTNER_HOBBY
					(
						HOBBY_ID,
						PARTNER_ID,
						COMPANY_ID
					)
					VALUES
					(
						#i#,
						#attributes.partner_id#,
						#attributes.cpid#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery name="DEL_COMP_POSITION" datasource="#DSN#">
			DELETE FROM COMPANY_POSITION WHERE COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfif isDefined('attributes.customer_position')>
			<cfloop list="#attributes.customer_position#" index="i">
				<cfquery name="ADD_POSITION" datasource="#DSN#">
					INSERT INTO 
						COMPANY_POSITION 
					(
						POSITION_ID,
						COMPANY_ID
					)
					VALUES
					(
						#i#,
						#attributes.cpid#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery name="ADD_CREDIT" datasource="#DSN#">
			UPDATE 
				COMPANY_CREDIT
			SET
				TOTAL_RISK_LIMIT = <cfif len(attributes.risk_limit)>#attributes.risk_limit#<cfelse>NULL</cfif>,
				MONEY  = '#attributes.money_type#'
			WHERE
				BRANCH_ID = #attributes.related_id#
		</cfquery>
		<cfset attributes.is_record = true>
	</cftransaction>
<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1013.Müşteri Eklemede Problem Oluştu Lütfen Sistem Yöneticisine Başvurun'> !");
			history.go(-1);
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfif attributes.is_record>
	<cfset max_branch_id = attributes.related_id>
	<cfset cpid = attributes.cpid>
	<cfset is_insert_type = 2>
	<cf_workcube_process 
		is_upd='1' 
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=crm.form_upd_company&cpid=#attributes.cpid#' 
		action_id='#attributes.cpid#'
		old_process_line='#attributes.old_process_line#' 
		warning_description = 'Müşteri : #attributes.fullname#'>
</cfif>
<cfquery name="GET_COMP_POTANTIAL" datasource="#DSN#">
	SELECT IS_SELECT FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid#
</cfquery>
<cfif isdefined("attributes.is_control")>
	<cfif isdefined("attributes.is_active")>
		<cfquery name="UPD_CONTROL" datasource="#DSN#">
			UPDATE
				COMPANY
			SET
				ISPOTANTIAL = 1,
				COMPANY_STATUS = 0
			WHERE
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
		<cfabort>
	</cfif>
<cfelse>
	<cfif get_comp_potantial.is_select eq 1>
		<cflocation url="#request.self#?fuseaction=crm.form_upd_company&cpid=#attributes.cpid#&is_search=1" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=crm.detail_company&cpid=#attributes.cpid#&is_search=1" addtoken="no">
	</cfif>
</cfif>
