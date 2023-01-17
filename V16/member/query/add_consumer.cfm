<cf_get_lang_set module_name="member">

<cfif isDefined("attributes.consumer_code") and len(attributes.consumer_code)>
	<cfquery name="get_consumer_member_code" datasource="#dsn#">
		SELECT CONSUMER_ID FROM CONSUMER WHERE MEMBER_CODE = '#trim(attributes.consumer_code)#'
	</cfquery>
	<cfif get_consumer_member_code.recordcount gte 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='30707.Üye Kodu'> <cf_get_lang dictionary_id='58193.Tekrarı'> !");
			 history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif isDefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>
	<cfquery name="get_consumer_tc_kontrol" datasource="#dsn#">
		SELECT CONSUMER_ID, TERMINATE_DATE, CONSUMER_STATUS FROM CONSUMER WHERE TC_IDENTY_NO = '#trim(attributes.tc_identity_no)#'
	</cfquery>
	<cfif get_consumer_tc_kontrol.recordcount gte 1>
		<cfif get_consumer_tc_kontrol.consumer_status eq 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='30308.Girilen TC kimlik No sistemden çıkmış olan bir üyeye ait. Lütfen sistem yöneticisine başvurunuz'>!");
				history.back();
			</script>
            <cfabort>
		</cfif>
	</cfif>
</cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isdefined("attributes.efatura_date") and len(attributes.efatura_date)><cf_date tarih='attributes.efatura_date'></cfif>
<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfif isdefined("attributes.married_date") and len(attributes.married_date)><cf_date tarih='attributes.married_date'></cfif>
<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.consumer_name=replacelist(attributes.consumer_name,list,list2)>
<cfset attributes.consumer_name=trim(attributes.consumer_name)>
<cfset attributes.consumer_surname=replacelist(attributes.consumer_surname,list,list2)>
<cfset attributes.consumer_surname=trim(attributes.consumer_surname)>
<cfif isdefined("attributes.work_door_no")>
	<cfset attributes.work_door_no=replacelist(attributes.work_door_no,list,list2)>
</cfif>

<!--- Bireysel Uye Ad ve Soyad Bilgilerinin Yazim Standardi Xml Uzerinden Belirlenerek Sekillenir FBS20110307 --->
<cfif isDefined("x_name_surname_write_standart") and x_name_surname_write_standart eq 1><!--- Sadece Bas Harfler Buyuk --->
	<cfset a = "">
	<cfloop from="1" to="#listlen(attributes.consumer_name,' ')#" index="i">
		<cfif len(listgetat(attributes.consumer_name,i,' ')) gt 1>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_name,i,' '),1)) & LCASETR(right(listgetat(attributes.consumer_name,i,' '),len(listgetat(attributes.consumer_name,i,' '))-1))>
		<cfelse>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_name,i,' '),1))>
		</cfif>
		<cfset a = '#a# #b#'>	
	</cfloop>
	<cfset attributes.consumer_name = trim(a)>
	
	<cfset a = "">
	<cfloop from="1" to="#listlen(attributes.consumer_surname,' ')#" index="i">
		<cfif len(listgetat(attributes.consumer_surname,i,' ')) gt 1>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_surname,i,' '),1)) & LCASETR(right(listgetat(attributes.consumer_surname,i,' '),len(listgetat(attributes.consumer_surname,i,' '))-1))>
		<cfelse>
			<cfset b = UCASETR(left(listgetat(attributes.consumer_surname,i,' '),1))>
		</cfif>
		<cfset a = '#a# #b#'>	
	</cfloop>
	<cfset attributes.consumer_surname = trim(a)>
<cfelseif isDefined("x_name_surname_write_standart") and x_name_surname_write_standart eq 2><!--- Tamami Buyuk --->
	<cfset attributes.consumer_name = trim(UCASETR(attributes.consumer_name))>
	<cfset attributes.consumer_surname = trim(UCASETR(attributes.consumer_surname))>
<cfelseif isDefined("x_name_surname_write_standart") and x_name_surname_write_standart eq 3><!--- Tamami Kucuk --->
	<cfset attributes.consumer_name = trim(LCASETR(attributes.consumer_name))>
	<cfset attributes.consumer_surname = trim(LCASETR(attributes.consumer_surname))>
</cfif>
<!--- //Bireysel Uye Ad ve Soyad Bilgilerinin Yazim Standardi Xml Uzerinden Belirlenerek Sekillenir --->

<cfif isdefined("attributes.consumer_password") and len(attributes.consumer_password)><cf_cryptedpassword password='#attributes.consumer_password#' output='PASS' mod=1></cfif>
<cfif isdefined("attributes.consumer_username") and len(attributes.consumer_username) and len(attributes.consumer_password)>
	<cfquery name="CHECK_CONSUMER" datasource="#dsn#">
		SELECT
			CONSUMER_USERNAME
		FROM
			CONSUMER
		WHERE 
			CONSUMER_USERNAME = '#attributes.consumer_username#' AND
			CONSUMER_PASSWORD = '#PASS#'
	</cfquery>
	<cfif check_consumer.recordcount>
		<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57425.Uyarı'>:<cf_get_lang dictionary_id='57551.Kullanıcı Adı'>/<cf_get_lang dictionary_id='57552.Şifre'> <cf_get_lang dictionary_id='58193.Tekrarı'>");
		window.history.go(-1);
		</script>	
	<cfabort>
</cfif>
</cfif>
<cfif isdefined("attributes.picture") and len(attributes.picture)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" destination="#upload_folder#member#dir_seperator#consumer#dir_seperator#" filefield="picture" nameconflict="MAKEUNIQUE" accept="image/*"> 
		<cffile action="rename" 
			    source="#upload_folder#member#dir_seperator#consumer#dir_seperator##cffile.serverfile#" 
		   destination="#upload_folder#member#dir_seperator#consumer#dir_seperator##file_name#.#cffile.serverfileext#">
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='44501.Display Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>	
	<cfscript>
		attributes.picture = file_name &"." & cffile.serverfileext;
	</cfscript>	
</cfif>
<cfif not isdefined("attributes.home_address")>
	<cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>
		<cfset home_door_no = '#attributes.home_door_no#'>
	<cfelse>
		<cfset home_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.home_address = '#attributes.home_district# #attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	<cfelseif isdefined("attributes.home_main_street")>
		<cfset attributes.home_address = '#attributes.home_main_street# #attributes.home_street# #home_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.work_address")>
	<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>
		<cfset work_door_no = '#attributes.work_door_no#'>
	<cfelse>
		<cfset work_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.work_address = '#attributes.work_district# #attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	<cfelseif isdefined("attributes.work_main_street")>
		<cfset attributes.work_address = '#attributes.work_main_street# #attributes.work_street# #work_door_no#'>
	</cfif>
</cfif>
<cfif not isdefined("attributes.tax_address")>
	<cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>
		<cfset tax_door_no = '#attributes.tax_door_no#'>
	<cfelse>
		<cfset tax_door_no = ''>
	</cfif>
	<cfif isdefined("attributes.tax_district")>
		<cfset attributes.tax_address = '#attributes.tax_district# #attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
	<cfelseif isdefined("attributes.tax_main_street")>
		<cfset attributes.tax_address = '#attributes.tax_main_street# #attributes.tax_street# #tax_door_no#'>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_tax_address")>
	<cfset attributes.tax_address = attributes.home_address>
	<cfset attributes.tax_postcode = attributes.home_postcode>	
	<cfset attributes.tax_semt = attributes.home_semt>
	<cfset attributes.tax_country = attributes.home_country>
	<cfset attributes.tax_county_id = attributes.home_county_id>
	<cfset attributes.tax_city_id = attributes.home_city_id>
	<cfif isdefined("attributes.home_district")>
		<cfset attributes.tax_district = attributes.home_district>
	</cfif>
	<cfif isdefined("attributes.home_district_id")>
		<cfset attributes.tax_district_id = attributes.home_district_id>
	</cfif>
	<cfif isdefined("attributes.home_main_street")>
		<cfset attributes.tax_main_street = attributes.home_main_street>
		<cfset attributes.tax_street = attributes.home_street>
		<cfset attributes.tax_door_no = attributes.home_door_no>
	</cfif>
<cfelseif isdefined("attributes.is_tax_address_2")>
	<cfset attributes.tax_address = attributes.work_address>
	<cfset attributes.tax_postcode = attributes.work_postcode>	
	<cfset attributes.tax_semt = attributes.work_semt>
	<cfset attributes.tax_country = attributes.work_country>
	<cfset attributes.tax_county_id = attributes.work_county_id>
	<cfset attributes.tax_city_id = attributes.work_city_id>
	<cfif isdefined("attributes.work_district")>
		<cfset attributes.tax_district = attributes.work_district>
	</cfif>
	<cfif isdefined("attributes.work_district_id")>
		<cfset attributes.tax_district_id = attributes.work_district_id>
	</cfif>
	<cfif isdefined("attributes.work_main_street")>
		<cfset attributes.tax_main_street = attributes.work_main_street>
		<cfset attributes.tax_street = attributes.work_street>
		<cfset attributes.tax_door_no = attributes.work_door_no>
	</cfif>
</cfif>
<cfquery name="get_default_cat" datasource="#dsn#">
	SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_DEFAULT = 1
</cfquery>
<cfif get_default_cat.recordcount>
	<cfset default_cons_id = get_default_cat.conscat_id>
<cfelse>
	<cfset default_cons_id = 1>
</cfif>
<cfset source_list ="\,\n,#Chr(13)#,#Chr(10)#"><!--- Newline karakterlerinin database e yazılmaması için eklenmiştir diğer replace ler listeye alınmıştır. --->
<cfset replaced_list = "/, , , "> 
<cfset attributes.home_address=replacelist(attributes.home_address,source_list,replaced_list)>
<cfset attributes.work_address=replacelist(attributes.work_address,source_list,replaced_list)>
<!--- <cfdump var="#attributes.efatura_date#" abort> --->
<cfif isdefined("attributes.tax_address")><cfset attributes.tax_address=replace(attributes.tax_address,'\','/','All')></cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>		
		<cfquery name="ADD_CONSUMER" datasource="#DSN#" result="my_result">
			INSERT INTO
				CONSUMER
			(
				WRK_ID,
				CONSUMER_STAGE,
				CONSUMER_CAT_ID,
				BIRTHDATE,
				BIRTHPLACE,
				CHILD,
				COMPANY,
				COMPANY_SIZE_CAT_ID,
				CONSUMER_EMAIL,
				CONSUMER_KEP_ADDRESS,
				CONSUMER_FAX,
				CONSUMER_FAXCODE,
				CONSUMER_HOMETEL,
				CONSUMER_HOMETELCODE,
				CONSUMER_NAME,
				<cfif isdefined("attributes.consumer_password") and len(attributes.consumer_password)>CONSUMER_PASSWORD,</cfif>
				CONSUMER_SURNAME,
				CONSUMER_TEL_EXT,
				CONSUMER_USERNAME,
				CONSUMER_WORKTEL,
				CONSUMER_WORKTELCODE,
				EDUCATION_ID,
				HOMEADDRESS,
				HOMEPOSTCODE,
				HOMESEMT,
				HOME_COUNTY_ID,
				HOME_CITY_ID,
				HOME_COUNTRY_ID,
				HOME_DISTRICT,
				HOME_DISTRICT_ID,
				HOME_MAIN_STREET,
				HOME_STREET,
				HOME_DOOR_NO,
				HOMEPAGE,
				IDENTYCARD_CAT,
				IDENTYCARD_NO,
				IM,
				IMCAT_ID,
				ISPOTANTIAL,
				DEPARTMENT,
				TITLE,
				MISSION,
				MOBIL_CODE,
				MOBILTEL,
				MOBIL_CODE_2,
				MOBILTEL_2,
				PICTURE,
				PICTURE_SERVER_ID,
				SECTOR_CAT_ID,
				SEX,
				WORKADDRESS,
				WORKPOSTCODE,				  
				WORKSEMT,
				WORK_COUNTY_ID,
				WORK_CITY_ID,
				WORK_COUNTRY_ID,
				WORK_DISTRICT,
				WORK_DISTRICT_ID,
				WORK_MAIN_STREET,
				WORK_STREET,
				WORK_DOOR_NO,
				TAX_OFFICE,
				TAX_NO,
				TAX_ADRESS,
				TAX_POSTCODE,
				TAX_SEMT,
				TAX_COUNTY_ID,
				TAX_CITY_ID,
				TAX_COUNTRY_ID,
				TAX_DISTRICT,
				TAX_DISTRICT_ID,
				TAX_MAIN_STREET,
				TAX_STREET,
				TAX_DOOR_NO,
				IS_CARI,
				MARRIED,
				MARRIED_DATE,
				IS_TAXPAYER,
				SALES_COUNTY,
				HIERARCHY_ID,
				OZEL_KOD,
				CONSUMER_REFERENCE_CODE,
				TC_IDENTY_NO,
				SOCIAL_SOCIETY_ID,							  
				START_DATE,
				IMS_CODE_ID,
				SOCIAL_SECURITY_NO,
				INCOME_LEVEL_ID,
				VOCATION_TYPE_ID,
				NATIONALITY,
				RESOURCE_ID,
				CUSTOMER_VALUE_ID,
				IS_RELATED_CONSUMER,
				BLOOD_TYPE,
				REF_POS_CODE,
				FATHER,
				MOTHER,
				PROPOSER_CONS_ID,
				TAX_ADDRESS_TYPE,
				MEMBER_ADD_OPTION_ID,
				TIMEOUT_LIMIT,
				CAMPAIGN_ID,
				RECORD_IP,
				RECORD_MEMBER,
				COORDINATE_1,
				COORDINATE_2,
				RECORD_DATE,
                USE_EFATURA,
                EFATURA_DATE
			)
				VALUES 	 
			(
				'#wrk_id#',
				#attributes.process_stage#,
				<cfif isdefined("attributes.consumer_cat_id")>#attributes.consumer_cat_id#<cfelse>#default_cons_id#</cfif>,
				<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.birthplace") and len(attributes.birthplace)>'#attributes.birthplace#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.child") and len(attributes.child)>'#attributes.child#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.company") and len(attributes.company)>'#attributes.company#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.company_size_cat_id") and len(attributes.company_size_cat_id)>#attributes.company_size_cat_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.consumer_email") and len(attributes.consumer_email)>'#attributes.consumer_email#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.consumer_kep_address") and len(attributes.consumer_kep_address)>'#attributes.consumer_kep_address#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_fax") and len(attributes.work_fax)>'#attributes.work_fax#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_faxcode") and len(attributes.work_faxcode)>'#attributes.work_faxcode#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_tel") and len(attributes.home_tel)>'#attributes.home_tel#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_telcode") and len(attributes.home_telcode)>'#attributes.home_telcode#'<cfelse>NULL</cfif>,
				#sql_unicode()#'#attributes.consumer_name#',
				<cfif isdefined("attributes.consumer_password") and len(attributes.consumer_password)>'#pass#',</cfif>
				#sql_unicode()#'#attributes.consumer_surname#',
				<cfif isdefined("attributes.work_tel_ext") and len(attributes.work_tel_ext)>'#attributes.work_tel_ext#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.consumer_username") and len(attributes.consumer_username)>'#attributes.consumer_username#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_tel") and len(attributes.work_tel)>'#attributes.work_tel#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_telcode") and len(attributes.work_telcode)>'#attributes.work_telcode#'<cfelse>NULL</cfif>,				
				<cfif isdefined("attributes.education_level") and len(attributes.education_level)>#attributes.education_level#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_address") and len(attributes.home_address)>'#attributes.home_address#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_postcode") and len(attributes.home_postcode)>'#attributes.home_postcode#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_semt") and len(attributes.home_semt)>'#attributes.home_semt#'<cfelse>NULL</cfif>,   
				<cfif isdefined("attributes.home_county_id") and len(attributes.home_county_id)>#attributes.home_county_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_city_id") and len(attributes.home_city_id)>#attributes.home_city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_country") and len(attributes.home_country)>#attributes.home_country#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_district") and len(attributes.home_district)>'#attributes.home_district#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_district_id") and len(attributes.home_district_id)>#attributes.home_district_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_main_street") and len(attributes.home_main_street)>'#attributes.home_main_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_street") and len(attributes.home_street)>'#attributes.home_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.home_door_no") and len(attributes.home_door_no)>'#attributes.home_door_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.homepage") and len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,				
				<cfif isdefined("attributes.identycard_cat") and len(attributes.identycard_cat)>'#attributes.identycard_cat#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.identycard_no") and len(attributes.identycard_no)>'#attributes.identycard_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.im") and len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.imcat_id") and len(attributes.imcat_id)>#attributes.imcat_id#<cfelse>0</cfif>,
				<cfif isDefined("attributes.ispotential")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.department") and len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.title") and len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mission") and len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mobilcat_id_2") and len(attributes.mobilcat_id_2)>'#attributes.mobilcat_id_2#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.mobiltel_2") and len(attributes.mobiltel_2)>'#attributes.mobiltel_2#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.picture") and len(attributes.picture)>'#attributes.picture#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.picture") and len(attributes.picture)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>#attributes.sector_cat_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.sex") and attributes.sex eq 1>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.work_address") and len(attributes.work_address)>'#attributes.work_address#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_postcode") and len(attributes.work_postcode)>'#attributes.work_postcode#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_semt") and len(attributes.work_semt)>'#attributes.work_semt#'<cfelse>NULL</cfif>,				
				<cfif isdefined("attributes.work_county_id") and len(attributes.work_county_id)>#attributes.work_county_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_city_id") and len(attributes.work_city_id)>#attributes.work_city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_country") and len(attributes.work_country)>#attributes.work_country#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_district") and len(attributes.work_district)>'#attributes.work_district#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_district_id") and len(attributes.work_district_id)>#attributes.work_district_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_main_street") and len(attributes.work_main_street)>'#attributes.work_main_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_street") and len(attributes.work_street)>'#attributes.work_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.work_door_no") and len(attributes.work_door_no)>'#wrk_eval("attributes.work_door_no")#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_office") and len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,				
				<cfif isdefined("attributes.tax_no") and len(attributes.tax_no)>'#attributes.tax_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_address") and len(attributes.tax_address)>'#attributes.tax_address#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_postcode") and len(attributes.tax_postcode)>'#attributes.tax_postcode#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_semt") and len(attributes.tax_semt)>'#attributes.tax_semt#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_county_id") and len(attributes.tax_county_id)>#attributes.tax_county_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_city_id") and len(attributes.tax_city_id)>#attributes.tax_city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_country") and len(attributes.tax_country)>#attributes.tax_country#<cfelse>NULL</cfif>,					
				<cfif isdefined("attributes.tax_district") and len(attributes.tax_district)>'#attributes.tax_district#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_district_id") and len(attributes.tax_district_id)>#attributes.tax_district_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_main_street") and len(attributes.tax_main_street)>'#attributes.tax_main_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_street") and len(attributes.tax_street)>'#attributes.tax_street#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.tax_door_no") and len(attributes.tax_door_no)>'#attributes.tax_door_no#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_cari")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.married") and attributes.married eq 1>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.married") and isdefined("attributes.married_date") and len(attributes.married_date)>#attributes.married_date#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_taxpayer")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.sales_county") and len(attributes.sales_county)>#attributes.sales_county#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.hierarchy_id") and len(attributes.hierarchy_id)>#attributes.hierarchy_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.ozel_kod") and len(attributes.ozel_kod)>'#attributes.ozel_kod#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.reference_code") and len(attributes.reference_code)>
					<cfif not listfind(attributes.reference_code,attributes.ref_pos_code,'.')>
						'#attributes.reference_code#.#attributes.ref_pos_code#'
					<cfelse>
						'#attributes.reference_code#'
					</cfif>
				<cfelseif isdefined("attributes.ref_pos_code") and len(attributes.ref_pos_code)>
					'#attributes.ref_pos_code#'
				<cfelse>
					NULL
				</cfif>,
				<cfif isdefined("attributes.tc_identity_no") and len(attributes.tc_identity_no)>'#attributes.tc_identity_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.social_society_id") and len(attributes.social_society_id)>#attributes.social_society_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.startdate") and len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.ims_code_name") and len(attributes.ims_code_name) and len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.social_security_no") and len(attributes.social_security_no)>'#attributes.social_security_no#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.income_level") and len(attributes.income_level)>#attributes.income_level#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.vocation_type") and len(attributes.vocation_type)>#attributes.vocation_type#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.nationality") and len(attributes.nationality)>#attributes.nationality#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.resource") and len(attributes.resource)>#attributes.resource#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.customer_value") and len(attributes.customer_value)>#attributes.customer_value#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.is_related_consumer")>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.blood_type") and len(attributes.blood_type)>#attributes.blood_type#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.ref_pos_code_name") and len(attributes.ref_pos_code_name) and len(attributes.ref_pos_code)>#attributes.ref_pos_code#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.father") and len(attributes.father)>'#attributes.father#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mother") and len(attributes.mother)>'#attributes.mother#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.proposer_cons_id") and len(attributes.proposer_cons_id) and len(attributes.proposer_cons_name)>#attributes.proposer_cons_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_tax_address")>1<cfelseif isdefined("attributes.is_tax_address_2")>2<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.member_add_option_id") and len(attributes.member_add_option_id)>#attributes.member_add_option_id#<cfelse>NULL</cfif>,
				15,
				<cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#session.ep.userid#,
				<cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)>'#attributes.coordinate_1#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)>'#attributes.coordinate_2#'<cfelse>NULL</cfif>,
				#now()#,
				<cfif isdefined("attributes.use_efatura")>1<cfelse>0</cfif>,
                <cfif isDate("attributes.efatura_date") and len(attributes.efatura_date)>#attributes.efatura_date#<cfelse>NULL</cfif>
		)
		</cfquery>
		<cfquery name="GET_MAX_CONS" datasource="#DSN#">
			SELECT MAX(CONSUMER_ID) AS MAX_CONS FROM CONSUMER WHERE WRK_ID = '#wrk_id#'
		</cfquery>
					
		<!--- FB Bireysel uye ekibine temsilci is_master olarak atiliyor --->
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			<cfquery name="add_workgroup_member" datasource="#dsn#">
				INSERT INTO 
					WORKGROUP_EMP_PAR
				(
					CONSUMER_ID,
					OUR_COMPANY_ID,
					POSITION_CODE,
					IS_MASTER,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">,
					1,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery> 
		</cfif> 
	
		<!--- FB Şube sessiondan alinarak iliskilendiriliyor --->
		<cfquery name="get_branch_cid" datasource="#dsn#"><!--- Subenin company_id si --->
			SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
		</cfquery>
		<cfquery name="add_branch_related" datasource="#dsn#">
			INSERT INTO
				COMPANY_BRANCH_RELATED
			(
				CONSUMER_ID,
				OUR_COMPANY_ID,
				BRANCH_ID,
				OPEN_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch_cid.company_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
		<cfif isdefined('attributes.is_cari') and attributes.is_cari eq 1>
			<cfquery name="GET_ACC_INFO" datasource="#dsn#">
				SELECT PUBLIC_ACCOUNT_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
			</cfquery>
			<cfquery name="ADD_CONS_PERIOD" datasource="#DSN#">
				INSERT INTO
					CONSUMER_PERIOD
						(
							CONSUMER_ID,
							PERIOD_ID,
							ACCOUNT_CODE
						)
					VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">,
							#session.ep.period_id#,
							<cfif len(GET_ACC_INFO.PUBLIC_ACCOUNT_CODE)>'#GET_ACC_INFO.PUBLIC_ACCOUNT_CODE#'<cfelse>NULL</cfif>
						)
			</cfquery>
		</cfif>
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				CONSUMER 
			SET		
				PERIOD_ID = #session.ep.period_id#
			WHERE 
				CONSUMER_ID = #get_max_cons.max_cons#
		</cfquery>
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				CONSUMER 
			SET		
			<cfif isdefined("attributes.consumer_code") and len(attributes.consumer_code)>
				MEMBER_CODE='#trim(attributes.consumer_code)#'
			<cfelse>
				MEMBER_CODE = 'B#get_max_cons.max_cons#'
			</cfif>
			WHERE 
				CONSUMER_ID = #get_max_cons.max_cons#
		</cfquery>
		<!--- Sozlesme Ekleme--->
		<cfif isdefined("attributes.xml_consumer_contract_id") and len(attributes.xml_consumer_contract_id)>
			<cfquery name="UPD_CONTRACT" datasource="#DSN#">
				UPDATE 
					CONSUMER 
				SET 
					CONTRACT_DATE = #now()#
				<cfif isdefined("session.ww.userid")>
					,CONTRACT_CONS_ID = #session.ww.userid#
				<cfelseif isdefined("session.ep.userid")>
					,CONTRACT_EMP_ID = #session.ep.userid#
				</cfif>
				WHERE 
					CONSUMER_ID = #get_max_cons.max_cons#
			</cfquery>
		</cfif>

		<cf_workcube_process is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='CONSUMER'
			action_column='CONSUMER_ID'
			action_id='#get_max_cons.max_cons#'
			action_page='#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_max_cons.max_cons#' 
			warning_description='Bireysel Üye : #attributes.consumer_name# #attributes.consumer_surname#'>		
	</cftransaction>
</cflock>
<!--- Adres Defteri --->
<cfif not isDefined("attributes.company")><cfset attributes.company = ""></cfif>
<cfif not isDefined("attributes.title")><cfset attributes.title = ""></cfif>
<cfif not isDefined("attributes.consumer_email")><cfset attributes.consumer_email = ""></cfif>
<cfif not isDefined("attributes.work_telcode")><cfset attributes.work_telcode = ""></cfif>
<cfif not isDefined("attributes.work_tel")><cfset attributes.work_tel = ""></cfif>
<cfif not isDefined("attributes.work_fax")><cfset attributes.work_fax = ""></cfif>
<cfif not isDefined("attributes.homepage")><cfset attributes.homepage = ""></cfif>
<cfif not isDefined("attributes.work_postcode")><cfset attributes.work_postcode = ""></cfif>
<cfif not isDefined("attributes.work_address")><cfset attributes.work_address = ""></cfif>
<cfif not isDefined("attributes.work_semt")><cfset attributes.work_semt = ""></cfif>
<cfif not isDefined("attributes.work_county_id")><cfset attributes.work_county_id = ""></cfif>
<cfif not isDefined("attributes.work_city_id")><cfset attributes.work_city_id = ""></cfif>
<cfif not isDefined("attributes.work_country")><cfset attributes.work_country = ""></cfif>
<cfif not isDefined("attributes.sector_cat_id")><cfset attributes.sector_cat_id = ""></cfif>
<cf_addressbook
	design		= "1"
	type		= "3"
	type_id		= "#get_max_cons.max_cons#"
	active		= "1"
	name		= "#attributes.consumer_name#"
	surname		= "#attributes.consumer_surname#"
	sector_id	= "#attributes.sector_cat_id#"
	company_name= "#attributes.company#"
	title		= "#attributes.title#"
	email		= "#attributes.consumer_email#"
	telcode		= "#attributes.work_telcode#"
	telno		= "#attributes.work_tel#"
	faxno		= "#attributes.work_fax#"
	mobilcode	= "#attributes.mobilcat_id#"
	mobilno		= "#attributes.mobiltel#"
	web			= "#attributes.homepage#"
	postcode	= "#attributes.work_postcode#"
	address		= "#wrk_eval('attributes.work_address')#"
	semt		= "#attributes.work_semt#"
	county_id	= "#attributes.work_county_id#"
	city_id		= "#attributes.work_city_id#"
	country_id	= "#attributes.work_country#">

<!---Ek Bilgiler--->
<cfset attributes.info_id = my_result.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -2>
<cfinclude template="../../objects/query/add_info_plus2.cfm">

<!--- //Bireysel Uye mükellef mi değil mi kontrolü 2015015--->
<cfif session.ep.our_company_info.is_efatura>
	<cfscript>
		ws = createobject("component","V16.member.cfc.CheckCustomerTaxId").CheckCustomerTaxIdMain(Action_Type:"CONSUMER",Action_id:get_max_cons.max_cons,TCKN:attributes.tc_identity_no);
	</cfscript>
</cfif>

<!---Ek Bilgiler--->
<cfif listgetat(attributes.fuseaction,1,'.') is 'objects'>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href = '<cfoutput>#request.self#?fuseaction=member.consumer_list&event=det&cid=#get_max_cons.max_cons#</cfoutput>';
	</script>
</cfif>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
