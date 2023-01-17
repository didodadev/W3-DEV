<cfif attributes.is_comp eq 1><!--- Kurumsal üye ise --->
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT
			C.COMPANY_ID MEMBER_ID,
			C.FULLNAME + ' - ' + CB.COMPBRANCH__NAME FULLNAME,
			CB.COMPBRANCH_ADDRESS ADDRESS,
			CB.COMPBRANCH_POSTCODE POSTCODE,
			CB.COUNTY_ID COUNTY,
			CB.CITY_ID CITY,
			CB.COUNTRY_ID COUNTRY,
			CB.COMPBRANCH_TELCODE TELCODE,
			CB.COMPBRANCH_TEL1 TEL,
			CB.SEMT SEMT,
			C.MEMBER_CODE,
			CB.COMPBRANCH_ID BRANCH_ID,
			'' ADDRESS_TYPE
		FROM	
			COMPANY_BRANCH CB,
			COMPANY C
		WHERE 
			CB.COMPANY_ID = C.COMPANY_ID AND
			CB.COMPBRANCH_STATUS = 1
			<cfif isDefined("session.pp.userid")>
				AND C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
			</cfif>
		UNION ALL
		SELECT
			COMPANY_ID MEMBER_ID,
			FULLNAME,
			COMPANY_ADDRESS ADDRESS,
			COMPANY_POSTCODE POSTCODE,
			COUNTY COUNTY,
			CITY CITY,
			COUNTRY COUNTRY,
			COMPANY_TELCODE TELCODE,
			COMPANY_TEL1 TEL,	
			SEMT SEMT,
			MEMBER_CODE,
			-1 BRANCH_ID,
			'' ADDRESS_TYPE
		FROM 
			COMPANY
		WHERE
			COMPANY_STATUS = 1 
		<cfif isDefined("session.pp.userid")>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		</cfif>	
		ORDER BY
			FULLNAME
	</cfquery>
<cfelse><!--- Bireysel Uye --->
	<cfquery name="GET_MEMBER" datasource="#DSN#">
		SELECT 
			C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME + ' - ' + CB.CONTACT_NAME FULLNAME,
			C.CONSUMER_ID MEMBER_ID,
			CB.CONTACT_ADDRESS ADDRESS,
			CB.CONTACT_POSTCODE POSTCODE,
			CB.CONTACT_COUNTY_ID COUNTY,
			CB.CONTACT_CITY_ID CITY,
			CB.CONTACT_COUNTRY_ID COUNTRY,
			CB.CONTACT_TELCODE TELCODE,
			CB.CONTACT_TEL1 TEL,
			CB.CONTACT_SEMT SEMT,
			C. MEMBER_CODE,
			CB.CONTACT_ID BRANCH_ID,
			'' ADDRESS_TYPE
		FROM
			CONSUMER C,
			CONSUMER_BRANCH CB
		WHERE
			CB.CONSUMER_ID = C.CONSUMER_ID AND
			CB.STATUS = 1
		<cfif isDefined("session.ww.userid")>
			AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>		
		
		UNION ALL
		
		SELECT
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,
			CONSUMER_ID MEMBER_ID,
			TAX_ADRESS ADDRESS,
			TAX_POSTCODE POSTCODE,
			TAX_COUNTY_ID COUNTY,
			TAX_CITY_ID CITY,
			TAX_COUNTRY_ID COUNTRY,
			'' TELCODE,
			'' TEL,
			TAX_SEMT SEMT,
			MEMBER_CODE,
			-1 BRANCH_ID,
			'Fatura Adresi' ADDRESS_TYPE
		FROM 
			CONSUMER
		WHERE
			CONSUMER_STATUS = 1
		<cfif isDefined("session.ww.userid")>
			AND C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
		
		UNION ALL
		
		SELECT 
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,
			CONSUMER_ID MEMBER_ID,
			HOMEADDRESS ADDRESS,
			HOMEPOSTCODE POSTCODE,
			HOME_COUNTY_ID COUNTY,
			HOME_CITY_ID CITY,
			HOME_COUNTRY_ID COUNTRY,
			CONSUMER_HOMETELCODE TELCODE,
			CONSUMER_HOMETEL TEL,
			HOMESEMT SEMT,
			MEMBER_CODE MEMBER_CODE,
			-1 BRANCH_ID,
			'Ev Adresi' ADDRESS_TYPE
		FROM 
			CONSUMER
		WHERE
			CONSUMER_STATUS = 1
		<cfif isDefined("session.ww.userid")>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>	
		UNION ALL
		
		SELECT 
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME,
			CONSUMER_ID MEMBER_ID,
			WORKADDRESS ADDRESS,
			WORKPOSTCODE POSTCODE,
			WORK_COUNTY_ID COUNTY,
			WORK_CITY_ID CITY,
			WORK_COUNTRY_ID COUNTRY,
			CONSUMER_WORKTELCODE TELCODE,
			CONSUMER_WORKTEL TEL,
			WORKSEMT SEMT,
			MEMBER_CODE MEMBER_CODE,
			-1 BRANCH_ID,
			'Is Adresi' ADDRESS_TYPE
		FROM 
			CONSUMER
		WHERE
			CONSUMER_STATUS = 1
		<cfif isDefined("session.ww.userid")>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
		ORDER BY
			FULLNAME
	</cfquery>
</cfif>
