<cfset wrk_id = "WRKm#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##user_id_##round(rand()*100)#m">
<cfset attributes.process_stage = 32>
<cfset attributes.companycat_id = 1>
<cfquery name="GET_PERIOD" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #company_id_# AND PERIOD_YEAR = #year(now())#
</cfquery>
<cfset attributes.period_id = GET_PERIOD.period_id>
<cfset attributes.our_company_id = 1>
<cfset attributes.our_company_name = "Atom">


<cfset attributes.uye_ad = uye_ad>
<cfset attributes.taxno = uye_vergi_no>
<cfset attributes.taxoffice = uye_vergi_dairesi>
<cfset attributes.adres = uye_adres>
<cfset attributes.tel1 = uye_tel>
<cfset attributes.uye_partner_ad = uye_partner_ad>

<cfset attributes.name = "#listfirst(uye_partner_ad,' ')#">
<cfset attributes.surname = "#trim(replace(uye_partner_ad,'#attributes.name#','','one'))#">

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>					
		<cfquery name="ADD_COMPANY" datasource="#DSN#" result="my_result">
			INSERT INTO 
				COMPANY
			(
				WRK_ID,
				COMPANY_STATE,
				COMPANY_STATUS,
				COMPANYCAT_ID,
				PERIOD_ID,
				OUR_COMPANY_ID,
				MEMBER_CODE,
				HIERARCHY_ID,
				NICKNAME,
				FULLNAME,
				TAXOFFICE,
				TAXNO,
				COMPANY_EMAIL,
				HOMEPAGE,
				COMPANY_TELCODE,
				COMPANY_TEL1,
				COMPANY_TEL2,
				COMPANY_TEL3,
				COMPANY_FAX,
				MOBIL_CODE,
				MOBILTEL,															
				COMPANY_POSTCODE,
				COMPANY_ADDRESS,
				DISTRICT_ID,
				COUNTY,
				CITY,
				COUNTRY,
				RECORD_EMP,
				RECORD_IP,
				ISPOTANTIAL,	
				COMPANY_SIZE_CAT_ID,
				SALES_COUNTY,
				IS_SELLER,
				IS_BUYER,
				RESOURCE_ID,
				COMPANY_RATE,
				COMPANY_VALUE_ID,
				GLNCODE,
				RECORD_DATE,
				START_DATE,
				ORG_START_DATE,
				IMS_CODE_ID,
				SEMT,
				OZEL_KOD,
				OZEL_KOD_1,
				OZEL_KOD_2,
				IS_RELATED_COMPANY,
				MEMBER_ADD_OPTION_ID,
				COORDINATE_1,
				COORDINATE_2,
				CAMPAIGN_ID,
              	FIRM_TYPE,
                IS_EXPORT,
                VISIT_CAT_ID,
                IS_PERSON,
                PROFILE_ID,
                USE_EARCHIVE
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
				#attributes.process_stage#,
				1,
				#attributes.companycat_id#,
				#attributes.period_id#,
				<cfif isdefined('attributes.our_company_id') and len(attributes.our_company_id) and len(attributes.our_company_name)>#attributes.our_company_id#<cfelse>NULL</cfif>,
				NULL,
				NULL,
				'#uye_ad#',
				<cfif not len(attributes.uye_ad)>'#attributes.uye_partner_ad#'<cfelse>'#attributes.uye_ad#'</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.taxoffice#" null="#not len(attributes.taxoffice)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.taxno#" null="#not len(attributes.taxno)#">,
				'#uye_email#',
				NULL,
				NULL,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tel1#">,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('attributes.adres')#">,
				NULL,
				NULL,
				NULL,
				1,
				#user_id_#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				0,
				NULL,
				NULL,
				0,
				1,
				NULL,
				NULL,
				NULL,
				NULL,
				#now()#,
				NULL,
				NULL,
				2,
				NULL,
				'#uye_kod#',
				NULL,
				NULL,
				0,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
                0,
                NULL,
                1,
                NULL,
                0               
			)
            SELECT SCOPE_IDENTITY() MAX_COMPANY
		</cfquery>
        <cfset get_max.max_company = ADD_COMPANY.MAX_COMPANY>
				
		<cfquery name="ADD_COMP_PERIOD" datasource="#DSN#">
			INSERT INTO
				COMPANY_PERIOD
			(
				COMPANY_ID,
				PERIOD_ID
			)
			VALUES
			(
				#get_max.max_company#,
				#attributes.period_id#
			)
		</cfquery>
		<cfquery name="ADD_PARTNER" datasource="#DSN#">
			INSERT INTO 
				COMPANY_PARTNER 
			(
				COMPANY_ID,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				COMPANY_PARTNER_STATUS,
				TITLE,
				SEX,
				LANGUAGE_ID,
				DEPARTMENT,
				COMPANY_PARTNER_EMAIL,
				MOBIL_CODE,
				MOBILTEL,
				COMPANY_PARTNER_TELCODE,
				COMPANY_PARTNER_TEL,
				COMPANY_PARTNER_TEL_EXT,
				COMPANY_PARTNER_FAX,
				HOMEPAGE,
				MISSION,
				RECORD_DATE,
				MEMBER_TYPE,
				RECORD_MEMBER,
				RECORD_IP,		
				COMPANY_PARTNER_ADDRESS,
				COMPANY_PARTNER_POSTCODE,
				COUNTY,
				CITY,
				COUNTRY,		
				SEMT,
                TC_IDENTITY,
                BIRTHDATE
			)
			VALUES
			(
				#get_max.max_company#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.surname#">,
				1,
				NULL,
				1,
				'TR',
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				#now()#,
				1,
				#user_id_#,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				<cfif isDefined('uye_tck')>#uye_tck#<cfelse>NULL</cfif>,
				NULL
			)
		</cfquery>
		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT
				MAX(PARTNER_ID) MAX_PARTNER_ID
			FROM
				COMPANY_PARTNER
		</cfquery>
		
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="CP#get_max_partner.max_partner_id#">
			WHERE
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_partner.max_partner_id#">
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			INSERT INTO
				COMPANY_PARTNER_DETAIL
			(
				PARTNER_ID
			)
			VALUES
			(
				#get_max_partner.max_partner_id#
			)
		</cfquery>
		<cfquery name="ADD_PART_SETTINGS" datasource="#DSN#">
			INSERT INTO 
				MY_SETTINGS_P 
			(
				PARTNER_ID,
				LANGUAGE_ID,
				TIME_ZONE,
				MAXROWS,
				TIMEOUT_LIMIT
			)
			VALUES 
			(
				#get_max_partner.max_partner_id#,
				'TR',
				2,
				20,
				15
			)
		</cfquery>

		
		<!--- uye no kontrolü 2. kontrol gerekli kaldırmayın FA--->
		<cfset member_code_ = 'C#get_max.max_company#'>
		<cfif isdefined("attributes.company_code") and not len(attributes.company_code)>
			<cfquery name="GET_COMPANY_CODE" datasource="#DSN#">
				SELECT COMPANY_ID FROM COMPANY WHERE MEMBER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(member_code_)#">
			</cfquery>
			<cfif get_company_code.recordcount>
				<cfset member_code_ = 'C#get_max.max_company#-2'>
			</cfif>
		</cfif>
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				COMPANY 
			SET
				MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code_#">
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
		</cfquery>
		<cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY
			SET
				MANAGER_PARTNER_ID = #get_max_partner.max_partner_id#
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
		</cfquery>
		
		<!--- --->
		<cfset ana_kod = '120.01'>
		
		<cfquery name="control_period" datasource="#dsn#">
			SELECT * FROM COMPANY_PERIOD WHERE COMPANY_ID = #get_max.max_company# AND PERIOD_ID = #attributes.period_id#
		</cfquery>
		
		<cfif not len(control_period.account_code)>
		
		<cfquery name="get_last_code" datasource="#dsn#">
			SELECT TOP 1 * FROM #dsn#_#year(now())#_1.ACCOUNT_PLAN WHERE ACCOUNT_CODE LIKE '#ana_kod#.%' ORDER BY ACCOUNT_CODE DESC
		</cfquery>
		<cfset last_code = '#ana_kod#.' & numberformat(val(listlast(get_last_code.account_code,'.'))+1,'000000')>
		
		<cfquery name="upd_comp_period" datasource="#dsn#">
			UPDATE COMPANY_PERIOD SET ACCOUNT_CODE = '#last_code#' WHERE COMPANY_ID = #get_max.max_company# AND PERIOD_ID = #attributes.period_id#
		</cfquery>
		<cfquery name="add_account" datasource="#dsn#">
			INSERT INTO
				#dsn#_#year(now())#_1.ACCOUNT_PLAN
				(
					ACCOUNT_CODE,
					ACCOUNT_NAME,
					SUB_ACCOUNT,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					'#last_code#',
					'#uye_ad#',
					0,
					#user_id_#,
					#now()#,
					'#cgi.remote_addr#'
				)
		</cfquery>
		<cfquery name="UPD_COMPANY" datasource="#DSN#">
			UPDATE COMPANY SET MEMBER_CODE = '#last_code#' WHERE COMPANY_ID = #get_max.max_company#
		</cfquery>
		</cfif>
	</cftransaction>
</cflock>