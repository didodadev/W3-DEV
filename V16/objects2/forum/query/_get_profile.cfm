<cfif listfirst(attributes.userkey,"-") is "e">
<!--- employee --->
	<cfquery name="PROFILE" datasource="#DSN#">
		SELECT 
			EMPLOYEE_USERNAME, 
			EMPLOYEE_NAME, 
			EMPLOYEE_SURNAME, 
			EMPLOYEE_EMAIL, 
			DIRECT_TELCODE,
			DIRECT_TEL,
			EXTENSION,
			MOBILCODE,
			MOBILTEL
		FROM 
			EMPLOYEES
		WHERE 
			EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
	</cfquery>

	<cfquery name="GET_EMP_LOCATION" datasource="#DSN#">
		SELECT
			ZONE.ZONE_NAME,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD
		FROM
			ZONE,
			BRANCH,
			DEPARTMENT,
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
			AND
			EMPLOYEE_POSITIONS.POSITION_STATUS = 1
			AND
			DEPARTMENT.DEPARTMENT_ID = EMPLOYEE_POSITIONS.DEPARTMENT_ID
			AND
			BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
			AND
			ZONE.ZONE_ID = BRANCH.ZONE_ID
	</cfquery>

<cfelseif isdefined("session.pp.userid")>
<!--- partner --->
	<cfquery name="PROFILE" datasource="#DSN#">
		SELECT
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY_PARTNER.COMPANY_PARTNER_USERNAME,
			COMPANY_PARTNER.COMPANY_PARTNER_EMAIL,
			COMPANY.FULLNAME,
			COMPANY_PARTNER.TITLE,
			COMPANY_PARTNER.MOBIL_CODE,
			COMPANY_PARTNER.MOBILTEL,
			COMPANY_PARTNER.COMPANY_PARTNER_TELCODE,
			COMPANY_PARTNER.COMPANY_PARTNER_TEL,
			COMPANY_PARTNER.COMPANY_PARTNER_TEL_EXT,
			COMPANY_PARTNER.COMPANY_PARTNER_FAX,
			COMPANY_PARTNER.CITY,
			COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS,
			COMPANY_PARTNER.HOMEPAGE,
			COMPANY_CAT.COMPANYCAT
		FROM
			COMPANY_PARTNER,
			COMPANY_CAT,
			COMPANY,
            CATEGORY_SITE_DOMAIN
		WHERE
			COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#">
			AND
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
			AND
			COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
            AND
            COMPANY_CAT.COMPANYCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID 
            AND
			CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#">
            AND
			CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'COMPANY'
	</cfquery>
<cfelseif isdefined("session.ww.userid")>
<!--- consumer --->
	<cfquery name="PROFILE" datasource="#DSN#">
		SELECT
			CONSUMER.CONSUMER_USERNAME,
			CONSUMER.CONSUMER_NAME,
			CONSUMER.CONSUMER_SURNAME,
			CONSUMER.CONSUMER_EMAIL,
			CONSUMER.CONSUMER_WORKTELCODE,
			CONSUMER.CONSUMER_WORKTEL,
			CONSUMER.CONSUMER_TEL_EXT,
			CONSUMER.MOBILTEL,
			CONSUMER.CONSUMER_FAXCODE,
			CONSUMER.CONSUMER_FAX,
			CONSUMER.COMPANY,
			<!---CONSUMER.JOB, --->
			CONSUMER.TITLE,
			CONSUMER.HOMEPAGE,
			CONSUMER_CAT.CONSCAT,
			CONSUMER.MOBIL_CODE
		FROM
			CONSUMER,
			CONSUMER_CAT,
            CATEGORY_SITE_DOMAIN
		WHERE
			CONSUMER.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.userkey,"-")#"> AND
			CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID AND
            CONSUMER_CAT.CONSCAT_ID = CATEGORY_SITE_DOMAIN.CATEGORY_ID AND
            CATEGORY_SITE_DOMAIN.SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#"> AND 
            CATEGORY_SITE_DOMAIN.MEMBER_TYPE = 'CONSUMER'
	</cfquery>
</cfif>
