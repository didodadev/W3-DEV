<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1 = '#dsn#_product'>
	<cfset dsn1_alias= '#dsn1#'>
	<cfset dsn_alias= '#dsn#'>
    
	<cfscript>
		if (isDefined('session.ep.userid') and len(session.ep.language)) lang=ucase(session.ep.language);
		else if (isDefined('session.ww.language') and len(session.ww.language)) lang=ucase(session.ww.language);
		else if (isDefined('session.pp.userid') and len(session.pp.language)) lang=ucase(session.pp.language);
		else if (isDefined('session.pda.userid') and len(session.pda.language)) lang=ucase(session.pda.language);
		else if (isDefined('session.wp') and len(session.wp.language)) lang=ucase(session.wp.language);
	</cfscript>
	
	<!--- ADD COMPANY --->
	<cffunction name="addCompany" access="public" returntype="string">
		<!--- company --->
		<cfargument name="wrk_id" type="string" required="yes">
		<cfargument name="process_stage" type="numeric" required="yes">
		<cfargument name="companycat_id" type="numeric" required="yes">
		<cfargument name="nickname" type="string" required="yes">
		<cfargument name="fullname" type="string" required="yes">
		<cfargument name="vd" type="string" required="no">
		<cfargument name="vno" type="string" required="no">
		<cfargument name="company_email" type="string" required="no">
		<cfargument name="homepage" type="string" required="no">
		<cfargument name="telcod" type="string" required="no">
		<cfargument name="tel1" type="string" required="no">
		<cfargument name="tel2" type="string" required="no">
		<cfargument name="tel3" type="string" required="no">
		<cfargument name="fax" type="string" required="no">
		<cfargument name="mobilcat_id" type="string" required="no">
		<cfargument name="mobiltel" type="string" required="no">
		<cfargument name="postcod" type="string" required="no">
		<cfargument name="adres" type="string" required="no">
		<cfargument name="county_id" type="string" required="no">
		<cfargument name="city_id" type="string" required="no">
		<cfargument name="country" type="string" required="no">
		<cfargument name="semt" type="string" required="no">
		<cfargument name="company_sector" type="string" required="no">
		<cfargument name="firm_type" type="string" required="no">
		<cfargument name="asset1" type="string" required="no">
		<cfargument name="company_detail" type="string" required="no">
        <cfargument name="company_detail_eng" type="string" required="no" default="">
        <cfargument name="company_detail_spa" type="string" required="no" default="">
		<cfargument name="product_category" type="string" required="no">
		<cfargument name="ozel_kod" type="string" required="no" default="">
		<cfargument name="is_potential" type="numeric" required="no" default="0">
		<cfargument name="is_related_company" type="numeric" required="no" default="1">
		<cfargument name="is_status" type="numeric" required="no" default="1">
		<cfargument name="organization_start_date" type="string" required="no">
		<!--- partner --->
		<cfargument name="name" type="string" required="yes">
		<cfargument name="soyad" type="string" required="yes">
		<cfargument name="title" type="string" required="no">
		<cfargument name="sex" type="string" required="no">
		<cfargument name="department" type="string" required="no">
		<cfargument name="company_partner_email" type="string" required="no">
		<cfargument name="password" type="string" required="no">
		<cfargument name="mobilcat_id_partner" type="string" required="no">
		<cfargument name="mobiltel_partner" type="string" required="no">
		<cfargument name="mission" type="string" required="no">
		<cfargument name="tel_local" type="string" required="no">
		<cfargument name="tc_identity" type="string" required="no">
		<cfargument name="want_email" type="numeric" required="no" default="1">
		
		<cfquery name="ADD_COMPANY" datasource="#DSN#">
			INSERT INTO 
				COMPANY
			(
				WRK_ID,
				COMPANY_STATE,
				COMPANY_STATUS,
				COMPANYCAT_ID,
				PERIOD_ID,
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
				COUNTY,
				CITY,
				COUNTRY,
				SEMT,
				ISPOTANTIAL,	
				SECTOR_CAT_ID,
				IS_SELLER,
				IS_BUYER,
				IS_RELATED_COMPANY,
			<cfif len(arguments.asset1)>
				ASSET_FILE_NAME1,
				ASSET_FILE_NAME1_SERVER_ID,
			</cfif>
				FIRM_TYPE,
				COMPANY_DETAIL,
                COMPANY_DETAIL_ENG,
                COMPANY_DETAIL_SPA,
				ORG_START_DATE,
				OZEL_KOD,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">,
				#arguments.process_stage#,
				#arguments.is_status#,
				#arguments.companycat_id#,
				<cfif isdefined('session.ep')>#session.ep.period_id#<cfelse>#session.wp.period_id#</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fullname#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vd#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vno#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.company_email)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.homepage)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.telcod#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel3#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#">,
				<cfif len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postcod#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adres#">,
				<cfif len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#">,
				#arguments.is_potential#,
				<cfif len(arguments.company_sector)>#arguments.company_sector#<cfelse>NULL</cfif>,
				1,
				1,
				#arguments.is_related_company#,
				<cfif len(arguments.asset1)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.asset1#">,
					#fusebox.server_machine#,
				</cfif>
				<cfif len(arguments.firm_type)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.firm_type#,"><cfelse>NULL</cfif>,
				<cfif len(arguments.company_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_detail#"><cfelse>NULL</cfif>,
                <cfif len(arguments.company_detail_eng)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_detail_eng#"><cfelse>NULL</cfif>,
                <cfif len(arguments.company_detail_spa)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_detail_spa#"><cfelse>NULL</cfif>,
				<cfif len(arguments.organization_start_date)>#arguments.organization_start_date#<cfelse>NULL</cfif>,
				<cfif len(arguments.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ozel_kod#"><cfelse>NULL</cfif>,
				<cfif isdefined('session.ep')>#session.ep.userid#<cfelse>NULL</cfif>,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
		<cfquery name="GET_MAX" datasource="#DSN#">
			SELECT MAX(COMPANY_ID) AS MAX_COMPANY FROM COMPANY WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
		</cfquery>
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
				<cfif isdefined('session.ep')>#session.ep.period_id#<cfelse>#session.wp.period_id#</cfif>
			)
		</cfquery>
		
		<cfset member_code_ = 'C#get_max.max_company#'>
		<cfquery name="UPD_MEMBER_CODE" datasource="#DSN#">
			UPDATE 
				COMPANY 
			SET		
				MEMBER_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#member_code_#">
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
		</cfquery>
		
		<cfif len(arguments.product_category)>
			<cfloop list="#arguments.product_category#" index="i">
				<cfquery name="ADD_PRODUTCT_CAT" datasource="#DSN#">
					INSERT INTO 
						WORKNET_RELATION_PRODUCT_CAT
					(
						PRODUCT_CATID,
						COMPANY_ID
					)
					VALUES
					(
						#i#,
						#get_max.max_company#
					)
				</cfquery>
			</cfloop>
		</cfif>
		
		<cfif isdefined('session.ep')>
			<cfset language_ = session.ep.language>
		<cfelse>
			<cfset language_ = session.wp.language>
		</cfif>
		
		<cfset addPartner(
				company_id:get_max.max_company,
				username:arguments.company_partner_email,
				password:arguments.password,
				tc_identity:arguments.tc_identity,
				name:arguments.name,
				soyad:arguments.soyad,
				title:arguments.title,
				sex:arguments.sex,
				department:arguments.department,
				email:arguments.company_partner_email,
				mobilcat_id:arguments.mobilcat_id_partner,
				mobiltel:arguments.mobiltel_partner,
				telcod:arguments.telcod,
				tel:arguments.tel1,
				tel_local:arguments.tel_local,
				fax:arguments.fax,
				homepage:arguments.homepage,
				mission:arguments.mission,
				language_id:language_,
				compbranch_id:0,
				photo:'',
				postcod:arguments.postcod,
				adres:arguments.adres,
				county_id:arguments.county_id,
				city_id:arguments.city_id,
				country:arguments.country,
				semt:arguments.semt,
				birthdate:'',
				want_email:arguments.want_email
			) />
		
		<cfquery name="GET_MAX_PARTNER" datasource="#DSN#">
			SELECT MAX(PARTNER_ID) AS MAX_PART FROM COMPANY_PARTNER
		</cfquery>
		<cfquery name="UPD_MANAGER_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY
			SET
				MANAGER_PARTNER_ID = #get_max_partner.MAX_PART#
				<cfif not isdefined('session.ep')>
					,RECORD_PAR = #get_max_partner.MAX_PART#
				</cfif>
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">
		</cfquery>
		
		<cfif isdefined('session.ep')>
			<cfquery name="GET_BRANCH_CID" datasource="#DSN#"><!--- Subenin company_id si --->
				SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
			</cfquery>
			<cfquery name="ADD_BRANCH_RELATED" datasource="#DSN#">
				INSERT INTO
					COMPANY_BRANCH_RELATED
				(
					COMPANY_ID,
					OUR_COMPANY_ID,
					BRANCH_ID,
					OPEN_DATE,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max.max_company#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#get_branch_cid.company_id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				)
			</cfquery>
		</cfif>
	</cffunction>
	<!--- ADD PARTNER --->
	<cffunction name="addPartner" access="public" returntype="string">
		<cfargument name="company_id" type="string" required="yes">
		<cfargument name="username" type="string" required="no">
		<cfargument name="password" type="string" required="no">
		<cfargument name="tc_identity" type="string" required="no">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="soyad" type="string" required="yes">
		<cfargument name="title" type="string" required="no">
		<cfargument name="sex" type="string" required="no">
		<cfargument name="department" type="string" required="no">
		<cfargument name="email" type="string" required="no">
		<cfargument name="mobilcat_id" type="string" required="no">
		<cfargument name="mobiltel" type="string" required="no">
		<cfargument name="telcod" type="string" required="no">
		<cfargument name="tel" type="string" required="no">
		<cfargument name="tel_local" type="string" required="no">
		<cfargument name="fax" type="string" required="no">
		<cfargument name="homepage" type="string" required="no">
		<cfargument name="mission" type="string" required="no">
		<cfargument name="language_id" type="string" required="no">
		<cfargument name="compbranch_id" type="string" required="no">
		<cfargument name="photo" type="string" required="no">
		<cfargument name="postcod" type="string" required="no">
		<cfargument name="adres" type="string" required="no">
		<cfargument name="county_id" type="string" required="no">
		<cfargument name="city_id" type="string" required="no">
		<cfargument name="country" type="string" required="no">
		<cfargument name="semt" type="string" required="no">
		<cfargument name="birthdate" type="string" required="no">
		<cfargument name="want_email" type="numeric" required="no" default="1">

		<cfquery name="ADD_PARTNER" datasource="#DSN#">
			INSERT INTO 
				COMPANY_PARTNER 
			(
				COMPANY_ID,
				COMPANY_PARTNER_USERNAME,
				<cfif len(arguments.password)>COMPANY_PARTNER_PASSWORD,</cfif>
				TC_IDENTITY,
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME,
				TITLE,
				SEX,
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
				MEMBER_TYPE,
				BIRTHDATE,
				WANT_EMAIL,
				RECORD_DATE,				
				<cfif isdefined('session.ep')>RECORD_MEMBER,<cfelseif isdefined('session.pp')>RECORD_PAR,</cfif>
				RECORD_IP
			)
			VALUES
			(
				#arguments.company_id#,
				<cfif len(arguments.username)>'#arguments.username#'<cfelse>NULL</cfif>,
				<cfif len(arguments.password)>'#arguments.password#',</cfif>
				<cfif len(arguments.tc_identity)>#arguments.tc_identity#<cfelse>NULL</cfif>,
				'#arguments.name#',
				'#arguments.soyad#',
				<cfif len(arguments.title)>'#arguments.title#'<cfelse>NULL</cfif>,
				#arguments.sex#,
				<cfif len(arguments.department)>#arguments.department#<cfelse>NULL</cfif>,
				<cfif len(arguments.email)>'#arguments.email#'<cfelse>NULL</cfif>,
				<cfif len(arguments.mobilcat_id)>'#arguments.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif len(arguments.mobiltel)>'#arguments.mobiltel#'<cfelse>NULL</cfif>,
				<cfif len(arguments.telcod)>'#arguments.telcod#'<cfelse>NULL</cfif>,
				<cfif len(arguments.tel)>'#arguments.tel#'<cfelse>NULL</cfif>,
				<cfif len(arguments.tel_local)>'#arguments.tel_local#'<cfelse>NULL</cfif>,
				<cfif len(arguments.fax)>'#arguments.fax#'<cfelse>NULL</cfif>,
				<cfif len(arguments.homepage)>'#arguments.homepage#'<cfelse>NULL</cfif>,
				<cfif len(arguments.mission)>#arguments.mission#<cfelse>NULL</cfif>,
				'#arguments.language_id#',
				#arguments.compbranch_id#,
				0,
				<cfif len(arguments.photo)>'arguments.photo'<cfelse>NULL</cfif>,
				<cfif len(arguments.photo)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				'#arguments.adres#',
				'#arguments.postcod#',
				<cfif len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
				<cfif len(arguments.semt)>'#arguments.semt#'<cfelse>NULL</cfif>,
				1,
				<cfif len(arguments.birthdate)>#arguments.birthdate#<cfelse>NULL</cfif>,
				#arguments.want_email#,
				#now()#,				
				<cfif isdefined('session.ep')>#session.ep.userid#,<cfelseif isdefined('session.pp')>#session.pp.userid#,</cfif>
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
				<cfif not isdefined('session.ep')>
					,RECORD_PAR = #get_max_partner.MAX_PART#
				</cfif>
			WHERE
				PARTNER_ID = #get_max_partner.max_part#
		</cfquery>
		
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
				'#arguments.language_id#',
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
	</cffunction>
	
	<!--- UPD COMPANY --->
	<cffunction name="updCompany" access="public" returntype="string">
		<cfargument name="process_stage" type="numeric" required="yes">
		<cfargument name="companycat_id" type="numeric" required="yes">
		<cfargument name="nickname" type="string" required="yes">
		<cfargument name="fullname" type="string" required="yes">
		<cfargument name="vd" type="string" required="no">
		<cfargument name="vno" type="string" required="no">
		<cfargument name="company_email" type="string" required="no">
		<cfargument name="homepage" type="string" required="no">
		<cfargument name="telcod" type="string" required="no">
		<cfargument name="tel1" type="string" required="no">
		<cfargument name="tel2" type="string" required="no">
		<cfargument name="tel3" type="string" required="no">
		<cfargument name="fax" type="string" required="no">
		<cfargument name="mobilcat_id" type="string" required="no">
		<cfargument name="mobiltel" type="string" required="no">
		<cfargument name="postcod" type="string" required="no">
		<cfargument name="adres" type="string" required="no">
		<cfargument name="county_id" type="string" required="no">
		<cfargument name="city_id" type="string" required="no">
		<cfargument name="country" type="string" required="no">
		<cfargument name="semt" type="string" required="no">
		<cfargument name="company_sector" type="string" required="no">
		<cfargument name="firm_type" type="string" required="no">
		<cfargument name="annual_customer_value" type="string" required="no">
		<cfargument name="domestic_customer_value" type="string" required="no">
		<cfargument name="export_customer_value" type="string" required="no">
		<cfargument name="company_detail" type="string" required="no">
        <cfargument name="company_detail_eng" type="string" required="no">
        <cfargument name="company_detail_spa" type="string" required="no">
		<cfargument name="manager_partner_id" type="string" required="no">
		<cfargument name="company_size_cat_id" type="string" required="no">
		<cfargument name="coordinate_1" type="string" required="no">
		<cfargument name="coordinate_2" type="string" required="no">
		<cfargument name="organization_start_date" type="string" required="no">
		<cfargument name="req_type" type="string" required="no">
		<cfargument name="product_category" type="string" required="no">
		<cfargument name="is_potential" type="numeric" required="no" default="0">
		<cfargument name="is_status" type="numeric" required="no" default="1">
		<cfargument name="is_related_company" type="numeric" required="no" default="1">
		<cfargument name="is_homepage" type="numeric" required="no" default="0">
		<cfargument name="sort" type="string" required="no" default="">
		
		<!--- history --->
		<cfquery name="hist_cont" datasource="#dsn#">
			SELECT
				C.*
			FROM
				COMPANY C
			WHERE
				C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
<!---		<cfif 	arguments.companycat_id neq hist_cont.companycat_id or
				arguments.fullname neq hist_cont.fullname or arguments.nickname neq hist_cont.nickname or
				arguments.manager_partner_id neq hist_cont.manager_partner_id or
				arguments.vd neq hist_cont.taxoffice or arguments.vno neq hist_cont.taxno or
				arguments.company_email neq hist_cont.company_email or arguments.process_stage neq hist_cont.company_state or
				arguments.telcod neq hist_cont.company_telcode or arguments.tel1 neq hist_cont.company_tel1 or
				arguments.tel2 neq hist_cont.company_tel2 or arguments.tel3 neq hist_cont.company_tel3 or
				arguments.fax neq hist_cont.company_fax or arguments.adres neq hist_cont.company_address or
				arguments.semt neq hist_cont.semt or arguments.county_id neq hist_cont.county or 
				arguments.city_id neq hist_cont.city or arguments.country neq hist_cont.country or
				arguments.postcod neq hist_cont.company_postcode>
				<cfoutput query="hist_cont">
					<cfquery name="ADD_COMPANY_HISTORY" datasource="#DSN#">
						INSERT INTO
							COMPANY_HISTORY
						(
							COMPANY_ID,
							PERIOD_ID,
							COMPANYCAT_ID,
							FULLNAME,
							NICKNAME,
							MEMBER_CODE,
							MANAGER_PARTNER_ID,
							TAXOFFICE,
							TAXNO,
							COMPANY_EMAIL,
							COMPANY_STATE,
							COMPANY_TELCODE,
							COMPANY_TEL1,
							COMPANY_TEL2,
							COMPANY_TEL3,
							COMPANY_FAX,
							COMPANY_ADDRESS,
							SEMT,
							COUNTY,
							CITY,
							COUNTRY,
							COMPANY_POSTCODE,
							COMPANY_STATUS,
							IS_RELATED_COMPANY,
							MEMBER_UPDATE_EMP,
							MEMBER_UPDATE_DATE,
							MEMBER_UPDATE_IP,
							<cfif isdefined('session.ep')>RECORD_EMP<cfelseif isdefined('session.pp')>RECORD_PAR</cfif>,
							RECORD_DATE,
							RECORD_IP
						)
						VALUES
						(
							#company_id#,
							<cfif len(period_id)>#period_id#<cfelse>NULL</cfif>,
							#companycat_id#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fullname#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#nickname#">,
							<cfif len(member_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(member_code)#"><cfelse>NULL</cfif>,
							<cfif len(manager_partner_id)>#manager_partner_id#<cfelse>NULL</cfif>,
							<cfif len(taxoffice)><cfqueryparam cfsqltype="cf_sql_varchar" value="#taxoffice#"><cfelse>NULL</cfif>,
							<cfif len(taxno)><cfqueryparam cfsqltype="cf_sql_varchar" value="#taxno#"><cfelse>NULL</cfif>,
							<cfif len(company_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_email#"><cfelse>NULL</cfif>,
							<cfif len(company_state)>#company_state#<cfelse>NULL</cfif>,
							<cfif len(company_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_telcode#"><cfelse>NULL</cfif>,
							<cfif len(company_tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_tel1#"><cfelse>NULL</cfif>,
							<cfif len(company_tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_tel2#"><cfelse>NULL</cfif>,
							<cfif len(company_tel3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_tel3#"><cfelse>NULL</cfif>,
							<cfif len(company_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_fax#"><cfelse>NULL</cfif>,
							<cfif len(company_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_address#"><cfelse>NULL</cfif>,
							<cfif len(semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#semt#"><cfelse>NULL</cfif>,
							<cfif len(county)>#county#<cfelse>NULL</cfif>,
							<cfif len(city)>#city#<cfelse>NULL</cfif>,
							<cfif len(country)>#country#<cfelse>NULL</cfif>,
							<cfif len(company_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#company_postcode#"><cfelse>NULL</cfif>,
							#company_status#,
							#is_related_company#,
							<cfif len(update_emp)>#update_emp#<cfelse>NULL</cfif>,
							<cfif len(update_date)>#CreateOdbcDateTime(update_date)#<cfelse>NULL</cfif>,
							<cfif len(update_ip)><cfqueryparam cfsqltype="cf_sql_varchar" value="#update_ip#"><cfelse>NULL</cfif>,
							<cfif isdefined('session.ep')>#session.ep.userid#<cfelseif isdefined('session.pp')>#session.pp.userid#</cfif>,
							#now()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
					</cfquery>
				</cfoutput>
		</cfif>--->
		
		<cfquery name="UPD_COMPANY" datasource="#DSN#">
			UPDATE 
				COMPANY 
			SET
				COMPANY_STATUS = #arguments.is_status#,
				ISPOTANTIAL = #arguments.is_potential#,
				IS_RELATED_COMPANY = #arguments.is_related_company#,
				IS_HOMEPAGE = #arguments.is_homepage#,
				COMPANY_STATE = #arguments.process_stage#,
				COMPANYCAT_ID = #arguments.companycat_id#,
				MANAGER_PARTNER_ID = <cfif len(arguments.manager_partner_id)>#arguments.manager_partner_id#,<cfelse>NULL,</cfif>
				FULLNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fullname#">,
				NICKNAME = <cfif len(arguments.nickname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nickname#"><cfelse>NULL</cfif>,
				SECTOR_CAT_ID = <cfif len(arguments.company_sector)>#arguments.company_sector#<cfelse>NULL</cfif>,
				COMPANY_SIZE_CAT_ID = <cfif len(arguments.company_size_cat_id)>#arguments.company_size_cat_id#<cfelse>NULL</cfif>,
				TAXOFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vd#">,
				TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.vno#">,
				COMPANY_EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_email#">,
				HOMEPAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.homepage#">,
				COMPANY_TELCODE = <cfif len(arguments.telcod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.telcod#"><cfelse>NULL</cfif>,
				COMPANY_TEL1 = <cfif len(arguments.tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel1#"><cfelse>NULL</cfif>,
				COMPANY_TEL2 = <cfif len(arguments.tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel2#"><cfelse>NULL</cfif>,
				COMPANY_TEL3 = <cfif len(arguments.tel3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tel3#"><cfelse>NULL</cfif>,
				COMPANY_FAX =  <cfif len(arguments.fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#"><cfelse>NULL</cfif>,
				MOBIL_CODE = <cfif len(arguments.mobilcat_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobilcat_id#"><cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(arguments.mobiltel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobiltel#"><cfelse>NULL</cfif>,
				COMPANY_POSTCODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postcod#">,
				COMPANY_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.adres#">,
				COUNTY = <cfif len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
				CITY = <cfif len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
				COUNTRY = <cfif len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
				ORG_START_DATE = <cfif len(arguments.organization_start_date)>#arguments.organization_start_date#<cfelse>NULL</cfif>,
				SEMT = <cfif len(arguments.semt)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.semt#"><cfelse>NULL</cfif>,
				COORDINATE_1 = <cfif len(arguments.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate_1#"><cfelse>NULL</cfif>,
				COORDINATE_2 = <cfif len(arguments.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.coordinate_2#"><cfelse>NULL</cfif>,
				COMPANY_VALUE_ID = <cfif len(arguments.annual_customer_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.annual_customer_value#"><cfelse>NULL</cfif>,
				DOMESTIC_VALUE_ID = <cfif len(arguments.domestic_customer_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.domestic_customer_value#"><cfelse>NULL</cfif>,
				EXPORT_VALUE_ID = <cfif len(arguments.export_customer_value)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.export_customer_value#"><cfelse>NULL</cfif>,
				FIRM_TYPE = <cfif len(arguments.firm_type)><cfqueryparam cfsqltype="cf_sql_varchar" value=",#arguments.firm_type#,"><cfelse>NULL</cfif>,
				COMPANY_DETAIL = <cfif len(arguments.company_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_detail#"><cfelse>NULL</cfif>,
                COMPANY_DETAIL_ENG = <cfif len(arguments.company_detail_eng)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_detail_eng#"><cfelse>NULL</cfif>,
                COMPANY_DETAIL_SPA = <cfif len(arguments.company_detail_spa)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.company_detail_spa#"><cfelse>NULL</cfif>,
				<cfif isdefined('session.ep')>
					<cfif len(arguments.sort)>SORT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sort#">,<cfelse>SORT = NULL,</cfif>
				</cfif>
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif isdefined('session.ep')>UPDATE_EMP = #session.ep.userid#,<cfelseif isdefined('session.pp')>UPDATE_PAR = #session.pp.userid#,</cfif>
				UPDATE_DATE = #now()#
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
        <cf_wrk_get_history  datasource='#DSN#' source_table= 'COMPANY' target_table= 'COMPANY_HISTORY' record_id= '#attributes.company_id#' record_name='COMPANY_ID'>
        
		<!--- sertifikalar --->
		<cfif len(arguments.req_type)>
			<cfquery name="del_company_partner_req" datasource="#dsn#"> 
				DELETE FROM MEMBER_REQ_TYPE WHERE COMPANY_ID = #arguments.company_id#
			</cfquery>
			<cfloop from="1" to="#Listlen(arguments.req_type)#" index="i"> 
				<cfset liste = ListGetAt(arguments.req_type,i)>
				<cfquery name="add_company_partner_req" datasource="#dsn#"> 
					INSERT INTO 
						MEMBER_REQ_TYPE
						(
							COMPANY_ID,
							REQ_ID
						)
						VALUES
						(
							#arguments.company_id#,
							#liste#
						)
				</cfquery> 
			</cfloop>
		</cfif>
		<!--- member of product categories --->
		
        <cfquery name="del_member_product_cat" datasource="#dsn#"> 
            DELETE FROM WORKNET_RELATION_PRODUCT_CAT WHERE COMPANY_ID = #arguments.company_id#
        </cfquery>
		<cfif len(arguments.product_category)>
        	<cfloop list="#arguments.product_category#" index="i">
				<cfquery name="ADD_PRODUTCT_CAT" datasource="#DSN#">
					INSERT INTO 
						WORKNET_RELATION_PRODUCT_CAT
					(
						PRODUCT_CATID,
						COMPANY_ID
					)
					VALUES
					(
						#i#,
						#arguments.company_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cffunction>
	<!--- UPD PARTNER --->
	<cffunction name="updPartner" access="public" returntype="string">
		<cfargument name="company_id" type="string" required="yes">
		<cfargument name="partner_id" type="string" required="yes">
		<cfargument name="username" type="string" required="no">
		<cfargument name="password" type="string" required="no">
		<cfargument name="tc_identity" type="string" required="no">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="soyad" type="string" required="yes">
		<cfargument name="title" type="string" required="no">
		<cfargument name="sex" type="string" required="no">
		<cfargument name="department" type="string" required="no">
		<cfargument name="email" type="string" required="no">
		<cfargument name="mobilcat_id" type="string" required="no">
		<cfargument name="mobiltel" type="string" required="no">
		<cfargument name="telcod" type="string" required="no">
		<cfargument name="tel" type="string" required="no">
		<cfargument name="tel_local" type="string" required="no">
		<cfargument name="fax" type="string" required="no">
		<cfargument name="homepage" type="string" required="no">
		<cfargument name="mission" type="string" required="no">
		<cfargument name="language_id" type="string" required="no">
		<cfargument name="compbranch_id" type="string" required="no">
		<cfargument name="photo" type="string" required="no">
		<cfargument name="postcod" type="string" required="no">
		<cfargument name="adres" type="string" required="no">
		<cfargument name="county_id" type="string" required="no">
		<cfargument name="city_id" type="string" required="no">
		<cfargument name="country" type="string" required="no">
		<cfargument name="semt" type="string" required="no">
		<cfargument name="birthdate" type="string" required="no">
		<cfargument name="partner_status" type="string" required="no" default="1">
		<cfargument name="want_email" type="string" required="no" default="1">
		<cfargument name="want_sms" type="string" required="no" default="1">
		
		<cfquery name="UPD_PARTNER" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER 
			SET
				COMPANY_PARTNER_USERNAME= <cfif len(arguments.username)>'#arguments.username#'<cfelse>NULL</cfif>,
				<cfif len(arguments.password)>COMPANY_PARTNER_PASSWORD='#arguments.password#',</cfif>
				TC_IDENTITY=<cfif len(arguments.tc_identity)>#arguments.tc_identity#<cfelse>NULL</cfif>,							
				COMPANY_PARTNER_NAME = '#arguments.name#',
				COMPANY_PARTNER_SURNAME = '#arguments.soyad#',
				COMPANY_PARTNER_STATUS = #arguments.partner_status#,
				MISSION = <cfif len(arguments.mission)>#arguments.mission#<cfelse>NULL</cfif>,
				DEPARTMENT= <cfif len(arguments.department)>#arguments.department#<cfelse>NULL</cfif>,
				TITLE = '#arguments.title#',
				COMPANY_PARTNER_EMAIL = <cfif len(arguments.email)>'#arguments.email#'<cfelse>NULL</cfif>,
				SEX = #arguments.sex#,
				MOBIL_CODE = <cfif len(arguments.mobilcat_id)>'#arguments.mobilcat_id#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(arguments.mobiltel)>'#arguments.mobiltel#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_TELCODE = <cfif len(arguments.telcod)>'#arguments.telcod#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_TEL = <cfif len(arguments.tel)>'#arguments.tel#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_TEL_EXT = <cfif len(arguments.tel_local)>'#arguments.tel_local#'<cfelse>NULL</cfif>,
				COMPANY_PARTNER_FAX = <cfif len(arguments.fax)>'#arguments.fax#'<cfelse>NULL</cfif>,
				HOMEPAGE = <cfif len(arguments.homepage)>'#arguments.homepage#'<cfelse>NULL</cfif>,
				LANGUAGE_ID = '#arguments.language_id#',
				COMPBRANCH_ID = #listfirst(arguments.compbranch_id,';')#,
				COMPANY_PARTNER_ADDRESS = '#arguments.adres#',
				COMPANY_PARTNER_POSTCODE = '#arguments.postcod#',
				COUNTY = <cfif len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
				CITY = <cfif len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
				SEMT= <cfif len(arguments.semt)>'#arguments.semt#'<cfelse>NULL</cfif>,
				COUNTRY = <cfif len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
				WANT_EMAIL = #arguments.want_email#,
				WANT_SMS = #arguments.want_sms#,
				BIRTHDATE = <cfif len(arguments.birthdate)>#arguments.birthdate#<cfelse>NULL</cfif>,
				<cfif len(arguments.photo)>PHOTO='#arguments.photo#',</cfif>
				<cfif len(arguments.photo)>PHOTO_SERVER_ID=#fusebox.server_machine#,</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_MEMBER_TYPE = 1,
				<cfif isdefined('session.ep')>
					UPDATE_MEMBER = #session.ep.userid#,
				<cfelse>
					UPDATE_PAR = #session.pp.userid#,
				</cfif>
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
		</cfquery>
				
		<cfquery name="control_" datasource="#dsn#">
			SELECT PARTNER_ID FROM MY_SETTINGS_P WHERE PARTNER_ID = #arguments.partner_id#
		</cfquery>
		<cfif control_.recordcount>
			<cfquery name="UPD_PARTNER_SETTINGS" datasource="#DSN#">
				UPDATE
					MY_SETTINGS_P
				SET
					LANGUAGE_ID = '#arguments.language_id#'
				WHERE
					PARTNER_ID = #arguments.partner_id#
			</cfquery>
		<cfelse>
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
					#arguments.partner_id#,
					2,
					'#arguments.language_id#',
					20,
					15
				)
			</cfquery>
		</cfif>
		
		<cfif isdefined('session.ep')>
			<cfquery name="DEL_WRK_APP" datasource="#DSN#">
				DELETE FROM WRK_SESSION WHERE USERID = #arguments.partner_id# AND USER_TYPE = 1
			</cfquery>
		</cfif>
		
	</cffunction>
	<!--- GET COMPANY --->
	<cffunction name="getCompany" access="public" returntype="query">
		<cfargument name="company_id" type="numeric" default="0">
		<cfargument name="keyword" type="string" default="">
		<cfargument name="sector" type="string" default="">
		<cfargument name="product_cat" type="string" default="">
		<cfargument name="product_catid" type="string" default="">
		<cfargument name="stage_id_list" type="string" required="no" default="">
		<cfargument name="company_status" type="any" default="1">
		<cfargument name="company_stage" type="any" default="">
		<cfargument name="is_potential" type="any" required="no" default="">
		<cfargument name="is_related_company" type="any" required="no" default="">
		<cfargument name="is_homepage" type="any" required="no" default="">
		<cfargument name="companycat_id" type="string" required="no" default="">
		<cfargument name="firm_type" type="string" default="">
		<cfargument name="country" type="string" default="">
		<cfargument name="city" type="string" default="">
		<cfargument name="county" type="string" default="">
		<cfargument name="sortfield" type="string" required="no" default="FULLNAME">
		<cfargument name="sortdir" type="string" required="no" default="asc">
		<cfargument name="recordCount" type="string" required="no" default="">
        <cfargument name="logo_status" type="any" required="no" default="">
        <cfargument name="startrow" default="1">
		<cfargument name="maxrows" default="20">
		
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			WITH CTE1 AS(
            SELECT
				<cfif len(arguments.recordCount)>
					TOP #arguments.recordCount#
				</cfif>
				C.*,
				CASE WHEN (C.SORT IS NOT NULL) THEN C.SORT ELSE 1000 END AS SORT_,
				CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME AS MANAGER_PARTNER,
				#dsn_alias#.Get_Dynamic_Language(SS.SECTOR_CAT_ID,'#lang#','SETUP_SECTOR_CATS','SECTOR_CAT',NULL,NULL,SECTOR_CAT) AS SECTOR_CAT,
				SCOUNTRY.COUNTRY_NAME,
				SCITY.CITY_NAME,
				SCOUNTY.COUNTY_NAME,
				SCZ.COMPANY_SIZE_CAT,
				#dsn_alias#.Get_Dynamic_Language(CCAT.COMPANYCAT_ID,'#lang#','COMPANY_CAT','COMPANYCAT',NULL,NULL,COMPANYCAT) AS COMPANYCAT
			FROM 
				COMPANY C WITH (NOLOCK)
				RIGHT JOIN COMPANY_CAT CCAT ON CCAT.COMPANYCAT_ID = C.COMPANYCAT_ID 
				RIGHT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID 
				LEFT JOIN SETUP_SECTOR_CATS SS ON SS.SECTOR_CAT_ID = C.SECTOR_CAT_ID 
				LEFT JOIN SETUP_COUNTRY SCOUNTRY ON C.COUNTRY = SCOUNTRY.COUNTRY_ID 
				LEFT JOIN SETUP_CITY SCITY ON SCITY.CITY_ID = C.CITY 
				LEFT JOIN SETUP_COUNTY SCOUNTY ON C.COUNTY = SCOUNTY.COUNTY_ID
				LEFT JOIN SETUP_COMPANY_SIZE_CATS SCZ ON SCZ.COMPANY_SIZE_CAT_ID = C.COMPANY_SIZE_CAT_ID
				<cfif len(arguments.product_cat) and len(arguments.product_catid)>
					LEFT JOIN WORKNET_RELATION_PRODUCT_CAT WRPC ON C.COMPANY_ID = WRPC.COMPANY_ID
				</cfif>
			WHERE 
				<cfif isdefined('session.ep')>
					C.PERIOD_ID = #session.ep.period_id#
				<cfelseif isdefined('session.pp')>
					C.PERIOD_ID = #session.pp.period_id#
				<cfelseif isdefined('session.ww')>
					C.PERIOD_ID = #session.ww.period_id#
				<cfelse>
					C.PERIOD_ID = #session.wp.period_id#
				</cfif>
				<cfif len(arguments.stage_id_list)>
					AND C.COMPANY_STATE IN (#arguments.stage_id_list#)
				</cfif>
				<cfif len(arguments.is_potential)>
					AND C.ISPOTANTIAL = #arguments.is_potential#
				</cfif>
				<cfif len(arguments.company_status)>
					AND C.COMPANY_STATUS = #arguments.company_status#
				</cfif>
				<cfif len(arguments.company_stage)>
					AND C.COMPANY_STATE = #arguments.company_stage#
				</cfif>
				<cfif len(arguments.companycat_id)>
					AND C.COMPANYCAT_ID = #arguments.companycat_id#
				</cfif>
				<cfif len(arguments.firm_type)>
					AND C.FIRM_TYPE LIKE '%#arguments.firm_type#%'
				</cfif>
				<cfif len(arguments.company_id) and arguments.company_id gt 0>
					AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
				</cfif>
				<cfif len(arguments.country)>
					AND C.COUNTRY = #arguments.country#
				</cfif>
				<cfif len(arguments.city)>
					AND C.CITY = #arguments.city#
				</cfif>
				<cfif len(arguments.county)>
					AND C.COUNTY = #arguments.county#
				</cfif>
				<cfif len(arguments.keyword)>
					AND 
					(
						C.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
						C.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
					)
				</cfif>
				<cfif len(arguments.sector)>
					AND C.SECTOR_CAT_ID = #arguments.sector#
				</cfif>
				<cfif len(arguments.product_cat) and len(arguments.product_catid)>
					AND WRPC.PRODUCT_CATID IN (#arguments.product_catid#)
				</cfif>
				<cfif len(arguments.is_related_company)>
					AND C.IS_RELATED_COMPANY = #arguments.is_related_company#
				</cfif>
                <cfif arguments.logo_status eq 1>
                 	AND ASSET_FILE_NAME1 IS NOT NULL
                </cfif>
                <cfif arguments.logo_status eq 0>
                    AND ASSET_FILE_NAME1 IS NULL
                </cfif>
             ),
			CTE2 AS 
			(
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (ORDER BY #arguments.sortfield# #arguments.sortdir#) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
		</cfquery>
		<cfreturn GET_COMPANY>
	</cffunction>
    
	<!--- GET PARTNER --->
	<cffunction name="getPartner" access="public" returntype="query">
		<cfargument name="company_id" type="numeric" default="0">
		<cfargument name="partner_id" type="numeric" default="0">
		<cfargument name="partner_status" type="string" default="">
		<cfargument name="keyword" type="string" default="">
        <cfargument name="product_cat" type="string" default="">
		<cfargument name="product_catid" type="string" default="">
        <cfargument name="partner_country" required="no" type="string" default="">
        <cfargument name="partner_city" required="no" type="string" default="">
        <cfargument name="partner_county" required="no" type="string" default="">
        <cfargument name="is_potential" type="any" required="no" default="">
        <cfargument name="firm_type" type="string" default="">
        <cfargument name="company_status" type="any" default="" required="no">
        <cfargument name="logo_status" type="any" required="no" default="">
        <cfargument name="sector" type="string" default="">
        <cfargument name="company_stage" type="any" default="">
        <cfargument name="companycat_id" type="string" required="no" default="">
        <cfargument name="is_related_company" type="any" required="no" default="">
        <cfargument name="is_online" type="any" required="no" default="">
        <cfargument name="position" type="any" required="no" default="">
        
		<cfquery name="GET_PARTNER" datasource="#DSN#">
                SELECT DISTINCT
                    CP.*,
                    C.FULLNAME,
                    C.NICKNAME,
                    C.MANAGER_PARTNER_ID,
                    C.ISPOTANTIAL,
                    C.FIRM_TYPE,
                    C.COMPANY_STATUS,
                    C.ASSET_FILE_NAME1,
                    C.SECTOR_CAT_ID,
                    C.COMPANY_STATE,
                    C.COMPANYCAT_ID,
                    C.IS_RELATED_COMPANY,
                    SCOUNTRY.COUNTRY_NAME,
                    SCITY.CITY_NAME,
                    SCOUNTY.COUNTY_NAME,
                    #dsn_alias#.Get_Dynamic_Language(PARTNER_POSITION_ID,'#lang#','SETUP_PARTNER_POSITION','PARTNER_POSITION',NULL,NULL,PARTNER_POSITION) AS PARTNER_POSITION,
                    #dsn_alias#.Get_Dynamic_Language(PARTNER_DEPARTMENT_ID,'#lang#','SETUP_PARTNER_DEPARTMENT','PARTNER_DEPARTMENT',NULL,NULL,PARTNER_DEPARTMENT) AS PARTNER_DEPARTMENT,
                    B.COMPBRANCH__NAME
                    ,WS.SESSIONID
                    ,WS.WORKCUBE_ID
                    <cfif isdefined('session.pp.userid')>
                        ,MF.FOLLOW_MEMBER_ID
                    </cfif>
                FROM
                    COMPANY_PARTNER CP
                    RIGHT JOIN COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID <cfif isdefined('session.pp.userid') or isdefined('session.wp')>AND C.COMPANY_STATUS = 1 AND C.ISPOTANTIAL = 0</cfif>
                    LEFT JOIN COMPANY_BRANCH B ON CP.COMPBRANCH_ID = B.COMPBRANCH_ID
                    LEFT JOIN SETUP_PARTNER_POSITION SP ON CP.MISSION = SP.PARTNER_POSITION_ID
                    LEFT JOIN SETUP_PARTNER_DEPARTMENT SPD ON CP.DEPARTMENT = SPD.PARTNER_DEPARTMENT_ID
                    
                    LEFT JOIN SETUP_COUNTRY SCOUNTRY ON CP.COUNTRY = SCOUNTRY.COUNTRY_ID 
                    LEFT JOIN SETUP_CITY SCITY ON SCITY.CITY_ID = CP.CITY 
                    LEFT JOIN SETUP_COUNTY SCOUNTY ON CP.COUNTY = SCOUNTY.COUNTY_ID
                    
                    LEFT JOIN WRK_SESSION WS ON WS.USERID = CP.PARTNER_ID AND USER_TYPE = 1
                    <cfif isdefined('session.pp.userid')>
                        LEFT JOIN MEMBER_FOLLOW MF ON MF.FOLLOW_MEMBER_ID = CP.PARTNER_ID AND FOLLOW_TYPE = 1 AND MY_MEMBER_ID = #session.pp.userid#
                    </cfif>
                    <cfif len(arguments.product_cat) and len(arguments.product_catid)>
                        LEFT JOIN WORKNET_RELATION_PRODUCT_CAT WRPC ON CP.COMPANY_ID = WRPC.COMPANY_ID
                    </cfif>
                WHERE 
                    CP.COMPANY_PARTNER_NAME IS NOT NULL
                    <cfif Len(arguments.partner_status)>
                        AND CP.COMPANY_PARTNER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_status#">
                    </cfif>
                    <cfif len(arguments.partner_id) and arguments.partner_id neq 0>
                        AND CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
                    </cfif>
                    <cfif len(arguments.company_id) and arguments.company_id neq 0>
                        AND CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> 
                    </cfif>
                    <cfif len(arguments.keyword)>
                        AND 
                        (
                            CP.COMPANY_PARTNER_NAME +' '+ CP.COMPANY_PARTNER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> 
                            <cfif isdefined('session.ep')>
                                OR CP.COMPANY_PARTNER_EMAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
                            </cfif>
                        )
                    </cfif>
                    <cfif len(arguments.product_cat) and len(arguments.product_catid)>
                        AND WRPC.PRODUCT_CATID IN (#arguments.product_catid#)
                    </cfif>
                    <cfif len(partner_country)>
                        AND CP.COUNTRY = #partner_country#
                    </cfif>
                   <cfif len(partner_city)>
                        AND CP.CITY = #partner_city#
                    </cfif>
                    <cfif len(partner_county)>
                        AND CP.COUNTY = #partner_county#
                    </cfif>
                    <cfif len(arguments.is_potential)>
                        AND C.ISPOTANTIAL = #arguments.is_potential#
                    </cfif>
                    <cfif len(arguments.firm_type)>
                        AND C.FIRM_TYPE LIKE '%#arguments.firm_type#%'
                    </cfif>
                    <cfif len(arguments.company_status)>
                        AND C.COMPANY_STATUS = #arguments.company_status#
                    </cfif>
                    <cfif arguments.logo_status eq 1>
                        AND ASSET_FILE_NAME1 IS NOT NULL
                    </cfif>
                    <cfif arguments.logo_status eq 0>
                        AND ASSET_FILE_NAME1 IS NULL
                    </cfif>
                    <cfif len(arguments.sector)>
                        AND C.SECTOR_CAT_ID = #arguments.sector#
                    </cfif>
                    <cfif len(arguments.company_stage)>
                        AND C.COMPANY_STATE = #arguments.company_stage#
                    </cfif>
                    <cfif len(arguments.companycat_id)>
                        AND C.COMPANYCAT_ID = #arguments.companycat_id#
                    </cfif>
                    <cfif len(arguments.is_related_company)>
                        AND C.IS_RELATED_COMPANY = #arguments.is_related_company#
                    </cfif>
                    <cfif len(arguments.is_online) and arguments.is_online eq 1>
                        AND WS.SESSIONID IS NOT NULL
                    <cfelseif len(arguments.is_online) and arguments.is_online eq 0>
                        AND WS.SESSIONID IS  NULL
                    </cfif>
                    <cfif len (arguments.position)>
                        AND CP.MISSION = #arguments.position#
                    </cfif>
             ORDER BY COMPANY_PARTNER_NAME
				
		</cfquery>
		<cfreturn GET_PARTNER>
	</cffunction>
	
	<!--- GET CONSUMER --->
	<cffunction name="getConsumer" access="public" returntype="query">
		<cfargument name="consumer_id" type="numeric" default="">
		<cfquery name="GET_CONSUMER" datasource="#DSN#">
			SELECT 
				C.CONSUMER_ID,
				C.MEMBER_CODE,
				C.CONSUMER_CAT_ID,
				C.CONSUMER_NAME,
				C.CONSUMER_SURNAME,
				C.CONSUMER_USERNAME,
				C.CONSUMER_EMAIL,
				C.MOBIL_CODE,
				C.MOBILTEL,
				C.CONSUMER_HOMETELCODE,
				C.CONSUMER_HOMETEL,
				C.HOMEPAGE,
				C.BIRTHDATE,
				C.TC_IDENTY_NO,
				C.COMPANY,
				C.DEPARTMENT,
				C.HOME_DISTRICT_ID,
				C.HOME_COUNTRY_ID,
				C.HOME_CITY_ID,
				C.HOME_COUNTY_ID,
				C.HOMEPOSTCODE,
				C.HOMEADDRESS,
				C.TITLE,
				C.COMPANY,
				CI.EDU4_ID,
				CI.EDU4_PART_ID
			FROM 
				CONSUMER C
				LEFT JOIN CONSUMER_EDUCATION_INFO CI ON C.CONSUMER_ID = CI.CONS_ID
			WHERE
				C.CONSUMER_NAME IS NOT NULL
                AND C.CONSUMER_STATUS = 1
				<cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
					AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
				<cfelse>
					AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.wp.userid#">
				</cfif>
			ORDER BY
				C.CONSUMER_NAME
		</cfquery>
		<cfreturn GET_CONSUMER>
	</cffunction>
	
	<!--- ADD BRANCH --->
	<cffunction name="addBranch" access="public" returntype="string">
		<cfargument name="company_id" type="string" required="yes">
		<cfargument name="manager_partner_id" type="string" required="no">
		<cfargument name="status" type="string" required="0">
		<cfargument name="brach_name" type="string" required="yes">
		<cfargument name="detail" type="string" required="yes">
		<cfargument name="email" type="string" required="no">
		<cfargument name="homepage" type="string" required="no">
		<cfargument name="telcod" type="string" required="no">
		<cfargument name="tel1" type="string" required="no">
		<cfargument name="tel2" type="string" required="no">
		<cfargument name="tel3" type="string" required="no">
		<cfargument name="fax" type="string" required="no">
		<cfargument name="mobilcat_id" type="string" required="no">
		<cfargument name="mobiltel" type="string" required="no">
		<cfargument name="postcod" type="string" required="no">
		<cfargument name="adres" type="string" required="no">
		<cfargument name="county_id" type="string" required="no">
		<cfargument name="city_id" type="string" required="no">
		<cfargument name="country" type="string" required="no">
		<cfargument name="semt" type="string" required="no">
		<cfargument name="coordinate_1" type="string" required="no">
		<cfargument name="coordinate_2" type="string" required="no">
		
		<cfquery name="ADD_COMPANY_BRANCH" datasource="#DSN#">
			INSERT INTO
				COMPANY_BRANCH
			(
				COMPBRANCH_STATUS,
				COMPANY_ID,	
				COMPBRANCH__NAME,
				COMPBRANCH__NICKNAME,
				COMPBRANCH_EMAIL,
				COMPBRANCH_TELCODE,
				COMPBRANCH_TEL1,
				COMPBRANCH_TEL2,
				COMPBRANCH_TEL3,
				COMPBRANCH_FAX,
				HOMEPAGE,
				COMPBRANCH_ADDRESS,
				COMPBRANCH_POSTCODE,
				SEMT,
				COUNTY_ID,
				CITY_ID,
				COUNTRY_ID,
				MANAGER_PARTNER_ID,
				COORDINATE_1,
				COORDINATE_2,
				COMPBRANCH_MOBIL_CODE,
				COMPBRANCH_MOBILTEL,
				RECORD_DATE,	
				<cfif isdefined('session.ep')>RECORD_MEMBER<cfelse>RECORD_PAR</cfif>,
				RECORD_IP
			)
				VALUES
			(
				#arguments.status#,
				#arguments.company_id#,
				'#arguments.brach_name#',
				<cfif len(arguments.detail)>'#arguments.detail#'<cfelse>NULL</cfif>,
				<cfif len(arguments.email)>'#arguments.email#'<cfelse>NULL</cfif>,
				'#arguments.telcod#',
				'#arguments.tel1#',
				<cfif len(arguments.tel2)>'#arguments.tel2#'<cfelse>NULL</cfif>,
				<cfif len(arguments.tel3)>'#arguments.tel3#'<cfelse>NULL</cfif>,
				<cfif len(arguments.fax)>'#arguments.fax#'<cfelse>NULL</cfif>,
				<cfif len(arguments.homepage)>'#arguments.homepage#'<cfelse>NULL</cfif>,
				<cfif len(arguments.adres)>'#arguments.adres#'<cfelse>NULL</cfif>,
				<cfif len(arguments.postcod)>'#arguments.postcod#'<cfelse>NULL</cfif>,
				<cfif len(arguments.semt)>'#arguments.semt#'<cfelse>NULL</cfif>,
				<cfif len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
				<cfif len(arguments.manager_partner_id)>#arguments.manager_partner_id#<cfelse>NULL</cfif>,
				<cfif len(arguments.coordinate_1)>'#arguments.coordinate_1#'<cfelse>NULL</cfif>,<!---  --->
				<cfif len(arguments.coordinate_2)>'#arguments.coordinate_2#'<cfelse>NULL</cfif>,
				<cfif len(arguments.mobilcat_id)>'#arguments.mobilcat_id#'<cfelse>NULL</cfif>,
				<cfif len(arguments.mobiltel)>'#arguments.mobiltel#'<cfelse>NULL</cfif>,
				#now()#,
				<cfif isdefined('session.ep')>#session.ep.userid#<cfelse>#session.pp.userid#</cfif>,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cffunction>
	<!--- UPD BRANCH --->
	<cffunction name="updBranch" access="public" returntype="string">
		<cfargument name="branch_id" type="string" required="yes">
		<cfargument name="manager_partner_id" type="string" required="no">
		<cfargument name="status" type="string" required="0">
		<cfargument name="brach_name" type="string" required="yes">
		<cfargument name="detail" type="string" required="yes">
		<cfargument name="email" type="string" required="no">
		<cfargument name="homepage" type="string" required="no">
		<cfargument name="telcod" type="string" required="no">
		<cfargument name="tel1" type="string" required="no">
		<cfargument name="tel2" type="string" required="no">
		<cfargument name="tel3" type="string" required="no">
		<cfargument name="fax" type="string" required="no">
		<cfargument name="mobilcat_id" type="string" required="no">
		<cfargument name="mobiltel" type="string" required="no">
		<cfargument name="postcod" type="string" required="no">
		<cfargument name="adres" type="string" required="no">
		<cfargument name="county_id" type="string" required="no">
		<cfargument name="city_id" type="string" required="no">
		<cfargument name="country" type="string" required="no">
		<cfargument name="semt" type="string" required="no">
		<cfargument name="coordinate_1" type="string" required="no">
		<cfargument name="coordinate_2" type="string" required="no">
		
		<cfquery name="UPD_COMPANY_BRANCH" datasource="#DSN#">
			UPDATE
				COMPANY_BRANCH
			SET
				COMPBRANCH_STATUS = #arguments.status#,
				COMPBRANCH__NAME = '#arguments.brach_name#',		
				COMPBRANCH__NICKNAME = '#arguments.detail#',		
				MANAGER_PARTNER_ID = <cfif len(arguments.manager_partner_id)>#arguments.manager_partner_id#<cfelse>NULL</cfif>,
				COMPBRANCH_EMAIL = '#arguments.email#',
				COMPBRANCH_TELCODE = '#arguments.telcod#',	
				COMPBRANCH_TEL1 = '#arguments.tel1#',	
				COMPBRANCH_TEL2 = '#arguments.tel2#',
				COMPBRANCH_TEL3 = '#arguments.tel3#',
				COMPBRANCH_FAX = '#arguments.fax#',
				HOMEPAGE = '#arguments.homepage#',
				COMPBRANCH_ADDRESS = <cfif len(arguments.adres)>'#arguments.adres#'<cfelse>NULL</cfif>,
				COMPBRANCH_POSTCODE = '#arguments.postcod#',
				SEMT = '#arguments.semt#',
				COUNTY_ID = <cfif len(arguments.county_id)>#arguments.county_id#<cfelse>NULL</cfif>,
				CITY_ID = <cfif len(arguments.city_id)>#arguments.city_id#<cfelse>NULL</cfif>,
				COUNTRY_ID = <cfif len(arguments.country)>#arguments.country#<cfelse>NULL</cfif>,
				COORDINATE_1 = <cfif len(arguments.coordinate_1)>'#arguments.coordinate_1#'<cfelse>NULL</cfif>,
				COORDINATE_2 = <cfif len(arguments.coordinate_2)>'#arguments.coordinate_2#'<cfelse>NULL</cfif>,
				COMPBRANCH_MOBIL_CODE = <cfif len(arguments.mobilcat_id)>'#arguments.mobilcat_id#'<cfelse>NULL</cfif>,
				COMPBRANCH_MOBILTEL = <cfif len(arguments.mobiltel)>'#arguments.mobiltel#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				<cfif isdefined('session.ep')>UPDATE_MEMBER = #session.ep.userid#<cfelse>UPDATE_PAR = #session.pp.userid#</cfif>,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
				COMPBRANCH_ID = #arguments.branch_id#
		</cfquery>
	</cffunction>
	<!--- GET COMPANY BRANCH --->
	<cffunction name="getCompanyBranch" access="public" returntype="query">
		<cfargument name="company_id" type="numeric" default="0">
		<cfargument name="branch_id" type="numeric" default="0">
		<cfargument name="is_active" type="any" default="">
		<cfargument name="partner_id" type="numeric" default="0">
		<cfif len(arguments.company_id) and arguments.company_id neq 0>
			<cfquery name="getCompany_BRANCH" datasource="#DSN#">
				SELECT
					CB.COMPBRANCH_STATUS,
					CB.COMPBRANCH__NICKNAME,
					CB.COMPBRANCH__NAME,
					CB.COMPBRANCH_ID,
					CB.COMPBRANCH_TELCODE,
					CB.COMPBRANCH_TEL1,
					CB.COMPBRANCH_TEL2,
					CB.COMPBRANCH_TEL3,
					CB.COMPBRANCH_FAX,
					CB.COMPBRANCH_MOBIL_CODE,
					CB.COMPBRANCH_MOBILTEL,
					CB.COMPBRANCH_EMAIL,
					CB.COORDINATE_1,
					CB.COORDINATE_2,
					CB.COUNTRY_ID,
					CB.CITY_ID,
					CB.COUNTY_ID,
					CB.MANAGER_PARTNER_ID,
					CB.HOMEPAGE,
					CB.COMPBRANCH_ADDRESS,
					CB.COMPBRANCH_POSTCODE,
					CB.SEMT,
					CB.RECORD_DATE,	
					CB.RECORD_MEMBER,
					CB.RECORD_IP,
					CB.RECORD_PAR,
					CB.UPDATE_DATE,
					CB.UPDATE_MEMBER,
					CB.UPDATE_PAR,
					CB.UPDATE_IP,
					SCOUNTRY.COUNTRY_NAME,
					SCITY.CITY_NAME,
					SCOUNTY.COUNTY_NAME
				FROM
					COMPANY_BRANCH CB
					LEFT JOIN SETUP_COUNTRY SCOUNTRY ON CB.COUNTRY_ID = SCOUNTRY.COUNTRY_ID
					LEFT JOIN SETUP_CITY SCITY ON CB.CITY_ID = SCITY.CITY_ID
					LEFT JOIN SETUP_COUNTY SCOUNTY ON CB.COUNTY_ID = SCOUNTY.COUNTY_ID
				WHERE
					CB.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
					<cfif len(arguments.branch_id) and arguments.branch_id neq 0>
						AND CB.COMPBRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
					</cfif>
					<cfif arguments.is_active neq "">
						AND CB.COMPBRANCH_STATUS = #arguments.is_active#
					</cfif>
				ORDER BY
					CB.COMPBRANCH__NAME
			</cfquery>
		<cfelse>
			<cfquery name="getCompany_BRANCH" datasource="#DSN#">
			SELECT 
				B.COMPBRANCH_ID, 
				B.COMPBRANCH__NAME 
			FROM 
				COMPANY_BRANCH B, 
				COMPANY_PARTNER CP
			WHERE 
				CP.COMPANY_ID = B.COMPANY_ID AND
				CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#">
			ORDER BY
				B.COMPBRANCH__NAME 
		</cfquery>
		</cfif>
		<cfreturn getCompany_BRANCH>
	</cffunction>
	<!--- GET REQ TYPE --->
	<cffunction name="getReqType" access="public" returntype="any">
		<cfargument name="company_id" type="numeric" default="0">
		<cfquery name="get_company_member_req" datasource="#dsn#"> 
			SELECT 
				MRT.REQ_ID,
				#dsn_alias#.Get_Dynamic_Language(SRT.REQ_ID,'#lang#','SETUP_REQ_TYPE','REQ_NAME',NULL,NULL,REQ_NAME) AS REQ_NAME
			FROM 
				MEMBER_REQ_TYPE MRT,
				SETUP_REQ_TYPE SRT
			WHERE 
				MRT.COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
				MRT.REQ_ID = SRT.REQ_ID
		</cfquery>
		<cfset relation_req_list = valuelist(get_company_member_req.req_id)>
		<cfset relation_req_name_list = valuelist(get_company_member_req.req_name)>
		<cfquery name="GET_REQ_TYPE" datasource="#DSN#">
			SELECT 
				REQ_ID,
				#dsn_alias#.Get_Dynamic_Language(REQ_ID,'#lang#','SETUP_REQ_TYPE','REQ_NAME',NULL,NULL,REQ_NAME) AS REQ_NAME
			FROM 
				SETUP_REQ_TYPE
		</cfquery>
		<cfset getReqType_ = StructNew()>
		<cfset getReqType_.liste = relation_req_list>
		<cfset getReqType_.liste_name = relation_req_name_list>
		<cfset getReqType_.query = GET_REQ_TYPE>
		<cfreturn getReqType_>
	</cffunction>
	<!--- GET MOBILCAT 
	<cffunction name="getMobilcat" access="public" returntype="query">
		<cfquery name="GET_MOBILCAT" datasource="#DSN#">
			SELECT MOBILCAT_ID,MOBILCAT FROM SETUP_MOBILCAT ORDER BY MOBILCAT ASC
		</cfquery>
		<cfreturn GET_MOBILCAT>
	</cffunction> --->
	<!--- GET COUNTRY --->
	<cffunction name="getCountry" access="public" returntype="query">
		<cfquery name="GET_COUNTRY" datasource="#DSN#">
			SELECT COUNTRY_ID,COUNTRY_NAME,COUNTRY_PHONE_CODE,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
		</cfquery>
		<cfreturn GET_COUNTRY>
	</cffunction>
	<!--- GET CITY --->
	<cffunction name="getCity" access="public" returntype="query">
		<cfargument name="country" type="string" default="">
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT CITY_ID,CITY_NAME FROM SETUP_CITY <cfif len(arguments.country)>WHERE COUNTRY_ID = #arguments.country#</cfif> ORDER BY CITY_NAME
		</cfquery>
		<cfreturn GET_CITY>
	</cffunction>
	<!--- GET COUNTY --->
	<cffunction name="getCounty" access="public" returntype="query">
		<cfargument name="city" type="string" default="">
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY <cfif len(arguments.city)>WHERE CITY = #arguments.city#</cfif> ORDER BY COUNTY_NAME
		</cfquery>
		<cfreturn GET_COUNTY>
	</cffunction>
	<!--- GET PARTNER POSITIONS --->
	<cffunction name="getPartnerPositions" access="public" returntype="query">
		<cfquery name="GET_PARTNER_POSITIONS" datasource="#DSN#">
			SELECT 
				PARTNER_POSITION_ID,
				#dsn_alias#.Get_Dynamic_Language(PARTNER_POSITION_ID,'#lang#','SETUP_PARTNER_POSITION','PARTNER_POSITION',NULL,NULL,PARTNER_POSITION) AS PARTNER_POSITION
			FROM 
				SETUP_PARTNER_POSITION WITH (NOLOCK) 
			ORDER BY 
				PARTNER_POSITION
		</cfquery>
		<cfreturn GET_PARTNER_POSITIONS>
	</cffunction>
	<!--- GET PARTNER DEPARTMENTS --->
	<cffunction name="getPartnerDepartments" access="public" returntype="query">
		<cfquery name="GET_PARTNER_DEPARTMENTS" datasource="#DSN#">
			SELECT 
				PARTNER_DEPARTMENT_ID,
				#dsn_alias#.Get_Dynamic_Language(PARTNER_DEPARTMENT_ID,'#lang#','SETUP_PARTNER_DEPARTMENT','PARTNER_DEPARTMENT',NULL,NULL,PARTNER_DEPARTMENT) AS PARTNER_DEPARTMENT
			FROM 
				SETUP_PARTNER_DEPARTMENT WITH (NOLOCK) 
			ORDER BY 
				PARTNER_DEPARTMENT 
		</cfquery>
		<cfreturn GET_PARTNER_DEPARTMENTS>
	</cffunction>
	<!--- GET LANGUAGE --->
	<cffunction name="getLanguage" access="public" returntype="query">
		<cfquery name="GET_LANGUAGE" datasource="#DSN#">
			SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
		</cfquery>
		<cfreturn GET_LANGUAGE>
	</cffunction>
	<!--- GET MEMBER PRODUCT CAT --->
	<cffunction name="getProductCat" access="public" returntype="query">
		<cfargument name="company_id" type="numeric" default="0">
		<cfquery name="GET_PRODUCT_CAT" datasource="#DSN#">
			SELECT 
				PC.HIERARCHY,
				#dsn_alias#.Get_Dynamic_Language(PC.PRODUCT_CATID,'#lang#','PRODUCT_CAT','PRODUCT_CAT',NULL,NULL,PRODUCT_CAT) AS PRODUCT_CAT,
				MRP.PRODUCT_CATID
			FROM 
				WORKNET_RELATION_PRODUCT_CAT MRP,
				#dsn1_alias#.PRODUCT_CAT PC
			WHERE
				PC.PRODUCT_CATID = MRP.PRODUCT_CATID AND
				MRP.COMPANY_ID = #arguments.company_id#
		</cfquery>
		<cfreturn GET_PRODUCT_CAT>
	</cffunction>
	<!--- GET SECTOR --->
	<cffunction name="getSector" access="public" returntype="query">
		<cfargument name="sector_cat_id" required="no" type="numeric" default="0">
		<cfargument name="is_internet" required="no" type="numeric" default="-1">
		
		<cfquery name="GET_SECTOR" datasource="#DSN#">
			SELECT 
				SECTOR_CAT_ID,
				#dsn_alias#.Get_Dynamic_Language(SECTOR_CAT_ID,'#lang#','SETUP_SECTOR_CATS','SECTOR_CAT',NULL,NULL,SECTOR_CAT) AS SECTOR_CAT 
			FROM 
				SETUP_SECTOR_CATS 
			WHERE 
				1 = 1
			<cfif len(arguments.sector_cat_id) and arguments.sector_cat_id neq 0>
				AND SECTOR_CAT_ID = #arguments.sector_cat_id#
			</cfif>
			<cfif arguments.is_internet neq -1>
				AND IS_INTERNET = #arguments.is_internet#
			</cfif>
		</cfquery>
		<cfreturn GET_SECTOR>
	</cffunction>
	<!--- GET COMPANY ADDRESS --->
	<cffunction name="getCompanyAddress" access="public" returntype="string">
		<cfargument name="company_id" type="numeric" required="yes">

		<cfquery name="GET_COMPANY_ADDRESS" datasource="#DSN#">
			SELECT 
				C.COMPANY_ADDRESS,
				C.COMPANY_POSTCODE,
				SCOUNTRY.COUNTRY_NAME,
				SCITY.CITY_NAME,
				SCOUNTY.COUNTY_NAME
			FROM 
				COMPANY C 
				LEFT JOIN SETUP_COUNTY SCOUNTY ON C.COUNTY = SCOUNTY.COUNTY_ID 
				LEFT JOIN SETUP_COUNTRY SCOUNTRY ON C.COUNTRY = SCOUNTRY.COUNTRY_ID 
				LEFT JOIN SETUP_CITY SCITY ON SCITY.CITY_ID = C.CITY 
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
		</cfquery>
		
		<cfset address_ = "#GET_COMPANY_ADDRESS.COMPANY_ADDRESS# #GET_COMPANY_ADDRESS.COMPANY_POSTCODE# #GET_COMPANY_ADDRESS.COUNTY_NAME# #GET_COMPANY_ADDRESS.CITY_NAME#/#GET_COMPANY_ADDRESS.COUNTRY_NAME#">
		
		<cfreturn address_>
	</cffunction>
	<!--- GET FIRM TYPE --->
	<cffunction name="getFirmType" access="public" returntype="any">
		<cfargument name="firm_type_id" type="string" default="0">
		
		<cfquery name="GET_FIRM_TYPE" datasource="#DSN#">
			SELECT 
				FIRM_TYPE_ID,
				#dsn_alias#.Get_Dynamic_Language(FIRM_TYPE_ID,'#lang#','SETUP_FIRM_TYPE','FIRM_TYPE',NULL,NULL,FIRM_TYPE) AS FIRM_TYPE 
			FROM 
				SETUP_FIRM_TYPE
			WHERE
				FIRM_TYPE_ID IN (#arguments.firm_type_id#)
		</cfquery>
		
		<cfset firm_type_list = valuelist(GET_FIRM_TYPE.FIRM_TYPE)>
		
		<cfreturn firm_type_list>
	</cffunction>
	<!--- GET SETUP_CUSTOMER_VALUE --->
	<cffunction name="getCustomerValue" access="public" returntype="query">
		<cfargument name="customer_value_id" required="yes">
		<cfargument name="sortfield" required="no" type="string" default="CUSTOMER_SALE_START,CUSTOMER_VALUE">
		<cfargument name="sortdir" required="no" type="string" default="desc">
		
		<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
			SELECT 
				#dsn_alias#.Get_Dynamic_Language(CUSTOMER_VALUE_ID,'#lang#','SETUP_CUSTOMER_VALUE','CUSTOMER_VALUE',NULL,NULL,CUSTOMER_VALUE) AS CUSTOMER_VALUE,
				CUSTOMER_VALUE_ID 
			FROM 
				SETUP_CUSTOMER_VALUE 
			WHERE 
				<cfif len(arguments.customer_value_id)>
					CUSTOMER_VALUE_ID = #arguments.customer_value_id#
				<cfelse>
					CUSTOMER_VALUE_ID = 0
				</cfif>
		</cfquery>
		
		<cfreturn GET_CUSTOMER_VALUE>
	</cffunction>
	<!--- ADD BRAND --->
	<cffunction name="addBrand" access="public" returntype="any">
		<cfargument name="member_id" type="numeric" required="yes">
		<cfargument name="brand_name" type="string" required="no" default="">
		<cfargument name="brand_logo_path" type="string" required="no" default="">
		<cfargument name="brand_detail" type="string" required="no" default="">
		<cfargument name="my_production" type="any" required="no" default="0">
		
		<cfquery name="ADD_BRAND" datasource="#dsn#">
			INSERT INTO
				WORKNET_MEMBER_BRANDS
				(
					BRAND_NAME,
					BRAND_LOGO_PATH,
					BRAND_LOGO_PATH_SERVER_ID,
					BRAND_DETAIL,
					MY_PRODUCTION,
					MEMBER_ID,
					RECORD_DATE,
					RECORD_MEMBER,
					RECORD_MEMBER_TYPE,
					RECORD_IP
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_logo_path#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_detail#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.my_production#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">,
					#now()#,
					<cfif isdefined('session.ep')>
						#session.ep.userid#,
						'EMPLOYEE',
					<cfelseif isdefined('session.pp')>
						#session.pp.userid#,
						'COMPANY',
					</cfif>
					'#cgi.remote_addr#'
				)
		</cfquery>
	</cffunction>
	<!--- UPD BRAND--->
	<cffunction name="updBrand" access="public" returntype="any">
		<cfargument name="brand_id" type="numeric" required="yes">
		<cfargument name="brand_name" type="string" required="no" default="">
		<cfargument name="brand_logo_path" type="string" required="no" default="">
		<cfargument name="brand_detail" type="string" required="no" default="">
		<cfargument name="my_production" type="any" default="">

		<cfquery name="UPD_BRAND" datasource="#dsn#">
			UPDATE 
				WORKNET_MEMBER_BRANDS
			SET
				<cfif len(arguments.brand_logo_path)>
					BRAND_LOGO_PATH = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_logo_path#">,
				</cfif>
				BRAND_LOGO_PATH_SERVER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,
				BRAND_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.brand_detail#">,
				MY_PRODUCTION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.my_production#">,
				<cfif isdefined('session.ep')>
					UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_MEMBER_TYPE = 'EMPLOYEE',
				<cfelse>
					UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">,
					UPDATE_MEMBER_TYPE = 'COMPANY',
				</cfif>
				UPDATE_IP = '#cgi.REMOTE_ADDR#',
				UPDATE_DATE = #now()#
			WHERE
				BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
		</cfquery>
	</cffunction>
	<!--- DEL BRAND--->
	<cffunction name="delBrand" access="public" returntype="any">
		<cfargument name="brand_id" type="numeric" required="yes">
		<cfquery name="DEL_BRAND" datasource="#dsn#">
			 DELETE FROM WORKNET_MEMBER_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#">
		</cfquery>
	</cffunction>
	<!--- GET BRAND --->
	<cffunction name="getBrand" access="public" returntype="query">
		<cfargument name="member_id" type="numeric" default="0">
		<cfargument name="brand_id" type="numeric" default="0">
		<cfargument name="my_production" type="any" default="">
		<cfargument name="recordCount" type="numeric" default="0">
		
		<cfquery name="GET_BRAND" datasource="#dsn#">
			SELECT 
				<cfif arguments.recordCount gt 0>TOP #arguments.recordCount#</cfif>
				*
			FROM
				WORKNET_MEMBER_BRANDS
			WHERE 
				1 = 1
				<cfif len(arguments.member_id) and arguments.member_id neq 0>
					AND MEMBER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#"> 
				</cfif>
				<cfif len(arguments.brand_id) and arguments.brand_id neq 0>
					AND BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.brand_id#"> 
				</cfif>
				<cfif len(arguments.my_production)>
					AND MY_PRODUCTION = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.my_production#"> 
				</cfif>
			ORDER BY 
				BRAND_DETAIL
		</cfquery>
		<cfreturn GET_BRAND>
	</cffunction>
	<!--- GET UNV --->
	<cffunction name="getUnv" access="public" returntype="query">
		<cfquery name="GET_UNV" datasource="#DSN#">
			SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME ASC
		</cfquery>
		<cfreturn GET_UNV>
	</cffunction>
	<!--- GET SCHOOL PART --->
	<cffunction name="getSchoolPart" access="public" returntype="query">
		<cfquery name="get_school_part" datasource="#dsn#">
			SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART ORDER BY PART_NAME
		</cfquery>
		<cfreturn get_school_part>
	</cffunction>
	<cffunction name="getConsumerCat" access="public" returntype="query">	
		<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
			SELECT 
				CONSCAT,
				CONSCAT_ID
			FROM 
				CONSUMER_CAT
			WHERE
				IS_INTERNET = 1	
			ORDER BY 
				CONSCAT
		</cfquery>
		<cfreturn GET_CONSUMER_CAT>
	</cffunction>
</cfcomponent>
