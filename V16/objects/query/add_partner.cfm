<cfif len(attributes.password)><cf_cryptedpassword password='#form.password#' output='PASS' mod=1></cfif>

<cfif len(attributes.username) and len(attributes.password)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_USERNAME ='#attributes.username#' AND 
			COMPANY_PARTNER_PASSWORD ='#pass#'
	</cfquery>
	
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("Aynı Kullanıcı Adı ve Şifre ile Kayıtlı Bir Kişi Var Lütfen Kontrol Ediniz. !");
			window.history.go(-1);
		</script>
		<cfabort>
	</cfif>
</cfif>
	
<cfif isDefined("attributes.photo") and len(attributes.photo)>
	<cftry>
		<cfset file_name = createUUID()>
		
		<cffile action="UPLOAD" 
				destination="#upload_folder#member#dir_seperator#" 
				filefield="photo" 
				nameconflict="MAKEUNIQUE" accept="image/*">
				
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
				
		<cfcatch>
			<script type="text/javascript">
				alert("Dosya Upload Edilirken Bir Hata Oluştu Lütfen Kontrol Ediniz!");
				window.history.go(-1);
			</script>
			<cfabort>
		</cfcatch>
	</cftry>	
</cfif>

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PARTNER" datasource="#DSN#">
			INSERT INTO 
				COMPANY_PARTNER 
			(
				COMPANY_ID,
				COMPANY_PARTNER_USERNAME,
				<cfif len(attributes.password)>COMPANY_PARTNER_PASSWORD,</cfif>							
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				TITLE,
				SEX,
				DEPARTMENT,
				COMPANY_PARTNER_EMAIL,
				<cfif isDefined("attributes.imcat_id") and attributes.imcat_id neq 0>IMCAT_ID,</cfif>
				IM,
				MOBIL_CODE,
				MOBILTEL,
				COMPANY_PARTNER_TELCODE,
				COMPANY_PARTNER_TEL,
				COMPANY_PARTNER_TEL_EXT,
				COMPANY_PARTNER_FAX,
				HOMEPAGE,
				MISSION,
				LANGUAGE_ID,
				<cfif isDefined("attributes.compbranch_id") and attributes.compbranch_id neq 0>COMPBRANCH_ID,</cfif>
				<cfif isDefined("attributes.photo") and len(attributes.photo)>PHOTO,</cfif>
				<cfif isDefined("attributes.photo") and len(attributes.photo)>PHOTO_SERVER_ID,</cfif>
				COMPANY_PARTNER_ADDRESS,
				COMPANY_PARTNER_POSTCODE,
				COUNTY,
				CITY,
				COUNTRY,		
				SEMT,				
				MEMBER_TYPE,
				RECORD_DATE,				
				RECORD_MEMBER,
				RECORD_IP
			)
			VALUES
			(
				#attributes.company_id#,
				<cfif len(attributes.username)>'#attributes.username#'<cfelse>NULL</cfif>,
				<cfif len(attributes.password)>'#PASS#',</cfif>
				'#attributes.name#',
				'#attributes.soyad#',
				<cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				#attributes.sex#,
				<cfif len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.email") and len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.imcat_id") and attributes.imcat_id neq 0>#attributes.imcat_id#,</cfif>
				<cfif isDefined("attributes.im") and len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.telcod") and len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.tel") and len(attributes.tel)>'#attributes.tel#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.tel_local") and len(attributes.tel_local)>'#attributes.tel_local#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.fax") and len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.homepage") and len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				<cfif len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
				'#attributes.language_id#',
				<cfif isDefined("attributes.compbranch_id") and attributes.compbranch_id neq 0>#attributes.compbranch_id#,</cfif>
				<cfif isDefined("attributes.photo") and len(attributes.photo)>'#file_name#.#cffile.serverfileext#',</cfif>
				<cfif isDefined("attributes.photo") and len(attributes.photo)>'#fusebox.server_machine#',</cfif>
				'#attributes.adres#',
				'#attributes.postcod#',
				<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				<cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				1,
				#now()#,				
				#session.ep.userid#,					
				'#cgi.remote_addr#'
			)				
		</cfquery>
		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT 
				MAX(PARTNER_ID) AS MAX_PART
			FROM 
				COMPANY_PARTNER
		</cfquery>
	</cftransaction>
</cflock>

<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
	UPDATE 
		COMPANY_PARTNER 
	SET 
		MEMBER_CODE = 'CP#get_max_partner.max_part#'
	WHERE 
		PARTNER_ID = #get_max_partner.max_part#
</cfquery>

<cfquery name="GET_LAST_PARTNER" datasource="#DSN#">
	SELECT MAX(PARTNER_ID) AS PARTNER_ID FROM COMPANY_PARTNER
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

<cfquery name="add_part_settings" datasource="#dsn#">
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
		#GET_MAX_PARTNER.MAX_PART#,
		2,
		'#form.language_id#',
		20,
		30
	)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
