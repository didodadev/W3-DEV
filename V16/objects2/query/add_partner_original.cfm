<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.name=replacelist(trim(attributes.name),list,list2)>
<cfset attributes.soyad=replacelist(trim(attributes.soyad),list,list2)>
<cfset a = "">
<cfloop from="1" to="#listlen(attributes.name,' ')#" index="i">
	<cfif len(listgetat(attributes.name,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.name,i,' '),1)) & lcase(right(listgetat(attributes.name,i,' '),len(listgetat(attributes.name,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.name,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.name = trim(a)>
<cfset a = "">
<cfloop from="1" to="#listlen(attributes.soyad,' ')#" index="i">
	<cfif len(listgetat(attributes.soyad,i,' ')) gt 1>
		<cfset b = ucase(left(listgetat(attributes.soyad,i,' '),1)) & lcase(right(listgetat(attributes.soyad,i,' '),len(listgetat(attributes.soyad,i,' '))-1))>
	<cfelse>
		<cfset b = ucase(left(listgetat(attributes.soyad,i,' '),1))>
	</cfif>
	<cfset a = '#a# #b#'>	
</cfloop>
<cfset attributes.soyad = trim(a)>
<cfif len(form.password)>
	<cf_cryptedpassword	password='#form.password#' output='PASS' mod=1>
</cfif>
<cfif len(attributes.username) and len(attributes.password)>
	<cfquery name="CHECK_USERNAME" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_USERNAME 
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_USERNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.username#"> AND 
			COMPANY_PARTNER_PASSWORD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pass#">
	</cfquery>
	<cfif check_username.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='31.Girdiğiniz Kullanıcı adı ve Şifre Kullanılıyor Lütfen Geri Dönüp Kontrol Ediniz'>");
			window.history.go(-1);
		</script>
	  <cfabort>
	</cfif>
</cfif>
<cfif isDefined("form.photo") and len(form.photo)>
	<cftry>
		<cfset file_name = createUUID()>
		<cffile action="UPLOAD" filefield="photo" nameconflict="MAKEUNIQUE"
			destination="#upload_folder#member#dir_seperator#" accept="image/*">
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#"
			destination="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">		
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#member#dir_seperator##file_name#.#cffile.serverfileext#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfcatch>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
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
				COMPANY_PARTNER_PASSWORD,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				<!---PARTNER_CARD_NO,--->
				TITLE,
				SEX,
				DEPARTMENT,
				COMPANY_PARTNER_EMAIL,
				IMCAT_ID,
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
				COMPBRANCH_ID,
				<cfif isDefined("attributes.photo") and len(attributes.photo)>
					PHOTO,
					PHOTO_SERVER_ID,
				</cfif>
				COMPANY_PARTNER_ADDRESS,
				COMPANY_PARTNER_POSTCODE,
				COUNTY,
				CITY,
				COUNTRY,		
				SEMT,
				MEMBER_TYPE,
				RECORD_DATE,				
				RECORD_PAR,
				RECORD_IP
			)
			VALUES
			(
				#attributes.company_id#,
				<cfif len(attributes.username)>'#attributes.username#'<cfelse>NULL</cfif>,
				<cfif len(attributes.password)>'#PASS#',<cfelse>NULL,</cfif>
				'#attributes.name#',
				'#attributes.soyad#',
				<!---<cfif isdefined('attributes.partner_card_no') and len(attributes.partner_card_no)>'#attributes.partner_card_no#'<cfelse>NULL</cfif>,--->
				<cfif isdefined('attributes.title') and len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				#attributes.sex#,
				<cfif isdefined('attributes.department') and len(attributes.department)>#attributes.department#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.email") and len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.imcat_id") and attributes.imcat_id neq 0>#attributes.imcat_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.im") and len(attributes.im)>'#attributes.im#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mobilcat_id") and len(attributes.mobilcat_id)>'#attributes.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.mobiltel") and len(attributes.mobiltel)>'#attributes.mobiltel#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.telcod") and len(attributes.telcod)>'#attributes.telcod#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.tel") and len(attributes.tel)>'#attributes.tel#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.tel_local") and len(attributes.tel_local)>'#attributes.tel_local#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.fax") and len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.homepage") and len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.mission') and len(attributes.mission)>#attributes.mission#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.language_id') and len(attributes.language_id)>'#attributes.language_id#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.compbranch_id") and attributes.compbranch_id neq 0>#attributes.compbranch_id#<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.photo") and len(attributes.photo)>
					'#file_name#.#cffile.serverfileext#',
					#fusebox.server_machine#,
				</cfif>
				'#attributes.adres#',
				<cfif isdefined('attributes.postcod') and len(attributes.postcod)>'#attributes.postcod#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.county_id') and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.city') and len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.country') and len(attributes.country)>#attributes.country#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.semt") and len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
				1,
				#now()#,				
				#session.pp.userid#,
				'#cgi.remote_addr#'
			)				
		</cfquery>
		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
		</cfquery>

		<!--- domain yazılıyor --->
		<cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
			INSERT INTO
				COMPANY_CONSUMER_DOMAINS
			(
				PARTNER_ID,
				<!---SITE_DOMAIN,--->
                MENU_ID,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				#get_max_partner.max_part#,
                #session.pp.menu_id#,
				<!---'#cgi.http_host#',--->
				#NOW()#,
				'#CGI.REMOTE_ADDR#'
			)
		</cfquery>
		<!------------------------->
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				MEMBER_CODE = 'CP#get_max_partner.max_part#'
			WHERE
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_partner.max_part#">
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
			sector_id	= "#ListFirst(get_company_name.sector_id)#"
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
				0,
				'#attributes.language_id#',
				20,
				30
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
<cfif isDefined('attributes.is_popup') and attributes.is_popup eq 1>
	<script type="text/javascript">
		 wrk_opener_reload();
		 window.close();
	</script>
<cfelse>
	<cfif isdefined('attributes.my_type_url') and attributes.my_type_url eq 1>
        <cflocation url="#request.self#?fuseaction=objects2.form_upd_my_company" addtoken="no">
    <cfelse>
        <cflocation url="#request.self#?fuseaction=objects2.upd_my_member&company_id=#attributes.company_id#" addtoken="no">
    </cfif>
</cfif>
