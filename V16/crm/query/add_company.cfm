<!--- TC Kimlik No ve Vergi Numarasi Kontrolu --->
<!--- sirket tipi gercek olan ve Musteri Tipi Eczane,Ozel Durum Eczane,Market,Parfumeri olanlar--->
<cfif attributes.company_work_type eq 1 and listfind('4,5,6,64',attributes.companycat_id)>
	<cfquery name="CONTROL_VERGINO" datasource="#DSN#">
		SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '#attributes.tax_num#'
	</cfquery>
	<cfquery name="CONTROL_TCIDENTITY" datasource="#DSN#">
		SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE TC_IDENTITY = '#attributes.tax_num#'
	</cfquery>
	<cfif control_vergino.recordcount or control_tcidentity.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='984.Aynı Vergi Numarası veya TC Kimlik No İle Eczane Var Kaydınızı Kontrol Ediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfif len(attributes.carihesapkod)>
	<cfquery name="GET_CARI" datasource="#DSN#">
		SELECT RELATED_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CARIHESAPKOD = '#attributes.carihesapkod#' AND BRANCH_ID = #attributes.branch_id#
	</cfquery>
	<cfif get_cari.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='983.Aynı Cari Hesap Kodu İle Kayıtlı Müşteriniz Var  Bu Cari Hesap Kodu İle Kayıt Yapamazsınız'> !");
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
		alert("<cf_get_lang no ='982.Müşteri Eklemek İstediğiniz Depo Boyut İle Uyumlu Bir Depo Değil'> !");
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
		<cfif len(attributes.marriagedate)><cf_date tarih='attributes.marriagedate'></cfif>
		<cfif len(attributes.open_date)><cf_date tarih='attributes.open_date'></cfif>
		<cfquery name="ADD_COMPANY" datasource="#DSN#">
			INSERT INTO 
				COMPANY
			(	
				IS_BUYER,
				IS_SELLER,
				COMPANY_STATUS,
				ISPOTANTIAL,
				COMPANYCAT_ID,
				FULLNAME,
				NICKNAME,
				TAXOFFICE,
				TAXNO,
				CITY,
				COMPANY_TELCODE,
				COMPANY_TEL1,
				IMS_CODE_ID,
				COUNTY,
				COMPANY_TEL2,
				SEMT,
				COMPANY_TEL3,
				DISTRICT,
				COMPANY_FAX_CODE,
				COMPANY_FAX,
				MAIN_STREET,
				COMPANY_EMAIL,
				STREET,
				HOMEPAGE,
				DUKKAN_NO,
				COMPANY_ADDRESS,
				COUNTRY,
				COMPANY_POSTCODE,
				CON_OPEN_DATE,
				COMPANY_WORK_TYPE,
				GLNCODE,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP			
			)
			VALUES
			(
				1,
				0,
				1,
				0,
				#attributes.companycat_id#,
				'#attributes.fullname#',
				'#attributes.fullname#',
				<cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tax_num)>'#attributes.tax_num#'<cfelse>NULL</cfif>,
				<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tel1)>'#attributes.tel1#'<cfelse>NULL</cfif>,
				#attributes.ims_code_id#,
				<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.tel2)>'#attributes.tel2#'<cfelse>NULL</cfif>,
				<cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				<cfif len(attributes.tel3)>'#attributes.tel3#'<cfelse>NULL</cfif>,
				<cfif len(attributes.district)>'#attributes.district#'<cfelse>NULL</cfif>,
				<cfif len(attributes.faxcode)>'#attributes.faxcode#'<cfelse>NULL</cfif>,
				<cfif len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
				<cfif len(attributes.main_street)>'#attributes.main_street#'<cfelse>NULL</cfif>,
				<cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				<cfif len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
				<cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				<cfif len(attributes.dukkan_no)>'#attributes.dukkan_no#'<cfelse>NULL</cfif>,
				<cfif len(attributes.district) or len(attributes.main_street) or len(attributes.street) or len(attributes.dukkan_no)>'#attributes.district# #attributes.main_street# #attributes.street# #attributes.dukkan_no#'<cfelse>NULL</cfif>,
				<cfif len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.post_code)>'#attributes.post_code#'<cfelse>NULL</cfif>,
				#now()#,
				#attributes.company_work_type#,
				<cfif isdefined("attributes.glncode") and Len(attributes.glncode)>'#attributes.glncode#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'			
			)
		</cfquery>
		<cfquery name="GET_MAXID" datasource="#DSN#">
			SELECT MAX(COMPANY_ID) AS COMPANY_ID FROM COMPANY
		</cfquery>
		<cfquery name="UPDATE_COMPANY_INFO" datasource="#DSN#">
			UPDATE COMPANY SET MEMBER_CODE = '#get_maxid.company_id#' WHERE COMPANY_ID = #get_maxid.company_id#			
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				COMPANY_PARTNER
			(
				TITLE,
				COMPANY_ID,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				IS_SMS,
				SEX,
				MAIL,
				MOBIL_CODE,
				MOBILTEL,
				HOMEPAGE,
				TC_IDENTITY,
				RECORD_DATE,
				RECORD_MEMBER,
				RECORD_IP
			)
			VALUES
			(
				<cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				#get_maxid.company_id#,
				'#attributes.company_partner_name#',
				'#attributes.company_partner_surname#',
				<cfif isdefined("attributes.is_sms")>1<cfelse>0</cfif>,
				<cfif len(attributes.sexuality)>#attributes.sexuality#<cfelse>NULL</cfif>,
				<cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				<cfif len(attributes.gsm_code)>'#attributes.gsm_code#'<cfelse>NULL</cfif>,
				<cfif len(attributes.gsm_tel)>'#attributes.gsm_tel#'<cfelse>NULL</cfif>,
				<cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				<cfif attributes.company_work_type eq 1>'#attributes.tax_num#'<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_DETAIL
			(
				PARTNER_ID,
				BIRTHDATE,
				BIRTHPLACE,
				MARRIED_DATE,
				MARRIED,
				FACULTY,
				CHILD,
				EDU1_FINISH, 
				EDU1
			)
			VALUES
			(
				#MAX_ID.IDENTITYCOL#,
				<cfif len(attributes.birthday)>#attributes.birthday#<cfelse>NULL</cfif>,
				'#attributes.birth_place#',
				<cfif len(attributes.marriagedate)>#attributes.marriagedate#<cfelse>NULL</cfif>,
				<cfif len(attributes.marital_status)>#attributes.marital_status#<cfelse>NULL</cfif>,
				<cfif len(attributes.faculty)>#listfirst(attributes.faculty, ',')#<cfelse>NULL</cfif>,
				<cfif len(attributes.child_number)>#attributes.child_number#<cfelse>NULL</cfif>,
				<cfif len(attributes.graduate_year)>#attributes.graduate_year#<cfelse>NULL</cfif>,
				<cfif len(attributes.faculty)>'#listlast(attributes.faculty, ',')#'<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfquery name="UPDATE_COMPANY_INFO" datasource="#DSN#">
			UPDATE COMPANY SET MANAGER_PARTNER_ID = #MAX_ID.IDENTITYCOL# WHERE COMPANY_ID = #get_maxid.company_id#
		</cfquery>
		<cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
			SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfquery name="INSERT_COMPANY_BRANCH_RELATED" datasource="#DSN#">
			INSERT INTO
				COMPANY_BRANCH_RELATED
			(
				OUR_COMPANY_ID,
				COMPANY_ID,
				BRANCH_ID,
				IS_SELECT,
				SALES_DIRECTOR,
				TEL_SALE_PREID,
				PLASIYER_ID,
				DEPO_STATUS,
				COMP_STATUS,
				RELATION_START,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OPEN_DATE,
				CEP_SIRA,
				CARIHESAPKOD,
				DEPOT_KM,
				DEPOT_DAK,
				PUAN,
				BOLGE_KODU,
				ALTBOLGE_KODU,
				CALISMA_SEKLI,
				MUHASEBEKOD,
				ITRIYAT_GOREVLI,
				TAHSILATCI,
				BOYUT_TAHSILAT,
				BOYUT_ITRIYAT,
				BOYUT_TELEFON,
				BOYUT_PLASIYER,
				BOYUT_BSM,
				MUSTERIDURUM,
				AVERAGE_DUE_DATE,
				OPENING_PERIOD,
				MF_DAY,	
				IS_CONTRACT_REQUIRED
			)
			VALUES
			(
				#get_our_company.company_id#,
				#get_maxid.company_id#,
				#attributes.branch_id#,
				0,
				<cfif len(attributes.satis_muduru_id) and len(attributes.satis_muduru)>#attributes.satis_muduru_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.telefon_satis_id) and len(attributes.telefon_satis)>#attributes.telefon_satis_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.plasiyer_id) and len(attributes.plasiyer)>#attributes.plasiyer_id#<cfelse>NULL</cfif>,
				#attributes.process_stage#,
				<cfif len(attributes.status)>'#attributes.status#'<cfelse>NULL</cfif>,
				<cfif len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#',
				<cfif len(attributes.open_date)>#attributes.open_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.cep_sira_no)>'#attributes.cep_sira_no#'<cfelse>NULL</cfif>,
				<cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#'<cfelse>NULL</cfif>,
				<cfif len(attributes.depot_km)>#attributes.depot_km#<cfelse>NULL</cfif>,
				<cfif len(attributes.depot_dak)>#attributes.depot_dak#<cfelse>NULL</cfif>,
				<cfif len(attributes.puan)>#attributes.puan#<cfelse>NULL</cfif>,
				<cfif len(attributes.bolge_kodu)>'#attributes.bolge_kodu#'<cfelse>NULL</cfif>,
				<cfif len(attributes.altbolge_kodu)>'#attributes.altbolge_kodu#'<cfelse>NULL</cfif>,
				<cfif len(attributes.calisma_sekli)>'#attributes.calisma_sekli#'<cfelse>NULL</cfif>,
				<cfif len(attributes.muhasebekod)>'#attributes.muhasebekod#'<cfelse>NULL</cfif>,
				<cfif len(attributes.itriyat_id)>#attributes.itriyat_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.tahsilatci_id)>#attributes.tahsilatci_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#'<cfelse>NULL</cfif>,
				<cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#'<cfelse>NULL</cfif>,
				<cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#'<cfelse>NULL</cfif>,
				<cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#'<cfelse>NULL</cfif>,
				<cfif len(attributes.boyut_satis)>'#attributes.boyut_satis#'<cfelse>NULL</cfif>,
				3,
				<cfif len(attributes.average_due_date)>#attributes.average_due_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.opening_period)>#attributes.opening_period#<cfelse>NULL</cfif>,
				<cfif len(attributes.mf_day)>#attributes.mf_day#<cfelse>NULL</cfif>,				
				0				
			)
		</cfquery>
		<cfquery name="GET_MAXRELATED" datasource="#DSN#">
			SELECT MAX(RELATED_ID) AS RELATED_ID FROM COMPANY_BRANCH_RELATED
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_STORES_RELATED" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_STORES_RELATED
			(
				COMPANY_ID,
				OUR_COMPANY_ID
			)
			VALUES
			(
				#get_maxid.company_id#,
				#get_our_company.company_id#
			)
		</cfquery>
		<cfquery name="ADD_COMPANY_SERVICE_INFO" datasource="#DSN#">
			INSERT INTO
				COMPANY_SERVICE_INFO
			(
				COMPANY_ID,
				OUR_COMPANY_ID,
				PC_NUMBER,
				NET_CONNECTION,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#get_maxid.company_id#,
				#get_our_company.company_id#,
				<cfif len(attributes.pc_number)>#attributes.pc_number#<cfelse>NULL</cfif>,
				<cfif len(attributes.net_connection)>#attributes.net_connection#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
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
						#MAX_ID.IDENTITYCOL#,
						#get_maxid.company_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isDefined("attributes.customer_position") and len(attributes.customer_position)>
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
						#get_maxid.company_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery name="ADD_CREDIT" datasource="#DSN#">
			INSERT INTO
				COMPANY_CREDIT
			(
				OUR_COMPANY_ID,
				COMPANY_ID,
				TOTAL_RISK_LIMIT,
				MONEY,
				BRANCH_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#get_our_company.company_id#,
				#get_maxid.company_id#,
				<cfif len(attributes.risk_limit)>#attributes.risk_limit#<cfelse>NULL</cfif>,
				'#attributes.money_type#',
				#get_maxrelated.related_id#,			
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'			
			)
		</cfquery>
		<cfset attributes.is_record = true>
  	</cftransaction>
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang no ='979.Müşteri Eklenirken Bir Problem Oluştu Lütfen Sistem Yöneticisine Başvurun'>1!");
			history.go(-1);
		</script>
		<cfabort>
	</cfcatch>
</cftry>

<cfif attributes.is_record>
	<cftry>
		<!--- Sube Aktarım Listesinden gelmis ise 20081108 --->
		<cfif isdefined("attributes.transfer_branch_id")>
			<cfquery name="UPD_TRANSFER" datasource="mushizgun">
				UPDATE 
					#attributes.table_name# 
				SET 
					IS_TRANSFER = 1, 
					COMPANY_ID = #get_maxid.company_id#, 
					RELATED_ID = NULL,
					RECORD_DATE = #now()#,
					RECORD_EMP = #session.ep.userid#,
					RECORD_IP = '#cgi.remote_addr#'
				WHERE 
					KAYITNO = #attributes.id#
			</cfquery>
		</cfif>	
		<cfset max_branch_id = get_maxrelated.related_id>
		<cfset cpid = get_maxid.company_id>
		<cfset is_insert_type = 1>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.form_upd_company&cpid=#get_maxid.company_id#' 
			action_id='#get_maxid.company_id#'
			warning_description = 'Müşteri : #attributes.fullname#'>
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang no ='981.Müşteri Eklemede Süreç Aşamasında Problem Oluştu Lütfen Sistem Yöneticisine Başvurun'> 2!");
			history.go(-1);
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfquery name="GET_COMP_POTANTIAL" datasource="#DSN#">
	SELECT IS_SELECT FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #get_maxid.company_id#
</cfquery>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='47470.İşlem tamamlandı'>");
	<cfif get_comp_potantial.is_select eq 1>
		window.location.href="<cfoutput>#request.self#?fuseaction=crm.detail_company&cpid=#get_maxid.company_id#&is_search=1</cfoutput>";
	<cfelseif isdefined("attributes.transfer_branch_id")>
		window.location.href="<cfoutput>#request.self#?fuseaction=crm.list_branch_transfer&form_submitted=1&branch_state=#attributes.transfer_branch_id#,#attributes.table_name#&caritip=#attributes.caritip#&keyword=#attributes.keyword#</cfoutput>";
	<cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=crm.form_upd_company&cpid=#get_maxid.company_id#&is_search=1</cfoutput>";	
	</cfif>
</script>