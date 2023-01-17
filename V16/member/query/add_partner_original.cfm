<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfif isdefined('form.password') and len(form.password)>
	<cf_cryptedpassword	password='#form.password#' output='PASS' mod=1>
</cfif>
<!--- pdks no kontrol --->
<cfif len(attributes.pdks_number)>
	<cfquery name="get_par_pdks_number" datasource="#DSN#">
		SELECT
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE
			PDKS_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pdks_number#"> AND
			COMPANY_PARTNER_STATUS = 1
	</cfquery>
	<cfif get_par_pdks_number.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#get_par_pdks_number.COMPANY_PARTNER_NAME# #get_par_pdks_number.COMPANY_PARTNER_SURNAME# Adlı Çalışan Aynı PDKS Numarası İle Kayıtlı</cfoutput>! Lütfen Düzeltiniz!');
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<!--- pdks no kontrol --->

<cfif len(attributes.username) and len(attributes.password)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND 
			COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="'#pass#'">
	</cfquery>
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang_main no='139.kullanıcı adı'>/<cf_get_lang_main no='140.şifre'><cf_get_lang_main no='781.tekrarı'>");
			window.history.go(-1);
		</script>
	  <cfabort>
	</cfif>
</cfif>
<cfset list="\n,#Chr(13)#,#Chr(10)#"> <!--- Newline karakterlerinin database e yazılmaması için eklenmiştir. --->
<cfset list2=" , , ">
<cfset attributes.adres=replacelist(attributes.adres,list,list2)>


<cfif isDefined("form.photo") and len(form.photo)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" filefield="photo" nameconflict="MAKEUNIQUE"
			destination="#upload_folder#member#dir_seperator#" accept="image/*">
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#"
			destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">		
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !'>");
				window.history.go(-1);
			</script>
			<cfabort>
		</cfcatch>
	</cftry>	
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PARTNER" datasource="#DSN#" result="my_result">
			INSERT INTO 
				COMPANY_PARTNER 
			(
				COMPANY_ID,
				COMPANY_PARTNER_USERNAME,
				<cfif len(attributes.password)>COMPANY_PARTNER_PASSWORD,</cfif>
				TC_IDENTITY,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				TITLE,
				SEX,
				DEPARTMENT,
				COMPANY_PARTNER_EMAIL,
				IMCAT_ID,
				IM,
				IMCAT2_ID,
				IM2,
				MOBIL_CODE,
				MOBILTEL,
				COMPANY_PARTNER_TELCODE,
				COMPANY_PARTNER_TEL,
				COMPANY_PARTNER_TEL_EXT,
				COMPANY_PARTNER_FAX,
				HOMEPAGE,
				MISSION,
				LANGUAGE_ID,
				COMPBRANCH_ID,
				IS_SEND_FINANCE_MAIL,
				PHOTO,
				PHOTO_SERVER_ID,
				COMPANY_PARTNER_ADDRESS,
				COMPANY_PARTNER_POSTCODE,
				COUNTY,
				CITY,
				COUNTRY,		
				SEMT,
				DISTRICT_ID,
				START_DATE,
				HIERARCHY_PARTNER_ID,
				RELATED_CONSUMER_ID,
				MEMBER_TYPE,
				PDKS_NUMBER,
				PDKS_TYPE_ID,
				BIRTHDATE,
				RECORD_DATE,				
				RECORD_MEMBER,
				RECORD_IP
			)
			VALUES
			(
				#attributes.company_id#,
				<cfif len(attributes.username)>'#attributes.username#'<cfelse>NULL</cfif>,
				<cfif len(attributes.password)>'#PASS#',</cfif>
				<cfif len(attributes.tc_identity)>#attributes.tc_identity#<cfelse>NULL</cfif>,   
				'#attributes.name#',
				'#attributes.soyad#',
				<cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				#attributes.sex#,
				<cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.email") and len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.imcat_id") and attributes.imcat_id neq 0>#attributes.imcat_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.im") and len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.imcat2_id") and attributes.imcat2_id neq 0>#attributes.imcat2_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.im2") and len(attributes.im2)>'#attributes.im2#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.telcod") and len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.tel") and len(attributes.tel)>'#attributes.tel#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.tel_local") and len(attributes.tel_local)>'#attributes.tel_local#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.fax") and len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.homepage") and len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
				'#attributes.language_id#',
				#listfirst(attributes.compbranch_id,';')#,
				<cfif isdefined('attributes.send_finance_mail')>1<cfelse>0</cfif>,
				<cfif isDefined("attributes.photo") and len(attributes.photo)>'#file_name#.#cffile.serverfileext#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.photo") and len(attributes.photo)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				'#attributes.adres#',
				'#attributes.postcod#',
				<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.semt") and len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.district_id") and Len(attributes.district_id)>#attributes.district_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.start_date)>#attributes.start_date#,<cfelse>NULL,</cfif>
				<cfif len(attributes.hier_partner_id)>#attributes.hier_partner_id#,<cfelse>NULL,</cfif>
				<cfif isDefined("attributes.related_consumer_id") and Len(attributes.related_consumer_id)>#attributes.related_consumer_id#<cfelse>NULL</cfif>,
				1,
				<cfif len(attributes.pdks_number)>'#attributes.pdks_number#'<cfelse>NULL</cfif>,
				<cfif len(attributes.pdks_type_id)>#attributes.pdks_type_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.birthdate") and len(attributes.birthdate)>#attributes.birthdate#<cfelse>NULL</cfif>,
				#now()#,				
				#session.ep.userid#,			
				'#cgi.remote_addr#'
			)				
		</cfquery>
		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
		</cfquery>

		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				MEMBER_CODE = 'CP#get_max_partner.max_part#'
			WHERE
				PARTNER_ID = #get_max_partner.max_part#
		</cfquery>
		
		<cfquery name="get_company_name" datasource="#DSN#">
			SELECT TOP 1 CSR.SECTOR_ID,C.FULLNAME FROM COMPANY_SECTOR_RELATION CSR,COMPANY C WHERE C.COMPANY_ID = CSR.COMPANY_ID AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfquery>
		<!--- Adres Defteri --->
		<cf_addressbook
			design		= "1"
			type		= "2"
			type_id		= "#get_max_partner.max_part#"
			active		= "1"
			name		= "#attributes.name#"
			surname		= "#attributes.soyad#"
			sector_id	= "#ListFirst(get_company_name.SECTOR_ID)#"
			company_name= "#get_company_name.fullname#"
			title		= "#attributes.title#"
			email		= "#attributes.email#"
			telcode		= "#attributes.telcod#"
			telno		= "#attributes.tel#"
			faxno		= "#attributes.fax#"
			mobilcode	= "#attributes.mobilcat_id#"
			mobilno		= "#attributes.mobiltel#"
			web			= "#attributes.homepage#"
			postcode	= "#attributes.postcod#"
			address		= "#wrk_eval('attributes.adres')#"
			semt		= "#attributes.semt#"
			county_id	= "#attributes.county_id#"
			city_id		= "#attributes.city_id#"
			country_id	= "#attributes.country#">
		
		<cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
			INSERT INTO 
				MY_SETTINGS_P 
			(
				PARTNER_ID,
				TIME_ZONE,
				LANGUAGE_ID,
				MAXROWS,
				TIMEOUT_LIMIT
			) 
			VALUES 
			(
				#get_max_partner.max_part#,
				2,
				'#attributes.language_id#',
				20,
				15
			)
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_DETAIL
			(
				PARTNER_ID
			)
			VALUES
			(
				#get_max_partner.max_part#
			)
		</cfquery>
	</cftransaction>
</cflock>
<!---Ek Bilgiler--->
<cfset attributes.info_id = my_result.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -3>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->

<cfif isdefined("attributes.is_popup")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_list_company&event=upd&cpid=#form.company_id#" addtoken="no">
</cfif>
