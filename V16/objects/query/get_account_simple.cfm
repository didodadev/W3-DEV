<cfif contact_type is "e"> 
	<cfif len(contact_id)>
		<cfquery name="GET_ACCOUNT_SIMPLE" datasource="#DSN#">
			SELECT
				E.MEMBER_CODE,
				E.EMPLOYEE_NAME AS NAME,
				E.EMPLOYEE_SURNAME AS SURNAME,
				E.EMPLOYEE_EMAIL AS EMAIL,
				E.DIRECT_TELCODE AS PHONE_CODE,
				E.DIRECT_TEL AS PHONE,
				E.TAX_NUMBER AS TAX_NO,
				E.TASK AS TAX_OFFICE,
				ST.TITLE
			FROM
				EMPLOYEES E,
				EMPLOYEE_POSITIONS EP,
				SETUP_TITLE ST
			WHERE
				E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact_id#"> AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EP.TITLE_ID = ST.TITLE_ID
		</cfquery>
	</cfif>
<cfelseif contact_type is "p" or  contact_type is "comp">
	<cfif contact_type is "comp">
		<cfquery name="GET_ACCOUNT_SIMPLE" datasource="#DSN#">
			SELECT
				-1 AS PARTNER_ID,
				'' AS NAME,
				'' AS SURNAME,
				'' AS EMAIL,
				'' AS PHONE_CODE,
				'' AS PHONE,
				'' MOBIL_CODE,
				'' AS MOBILE,
				'' AS FAX,
				C.MEMBER_CODE,
				C.NICKNAME AS COMPANY_NAME,
				C.COMPANY_ID,
				C.SECTOR_CAT_ID,
				C.COMPANY_SIZE_CAT_ID,
				C.PARTNER_ID AS AUTHORITY_ID,
				C.TAXNO AS TAX_NO,
				C.TAXOFFICE AS TAX_OFFICE,
				C.ISPOTANTIAL,
				COMPANY_CAT.COMPANYCAT
			FROM
				COMPANY C,
				COMPANY_CAT
			WHERE
				C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact_id#"> AND
				COMPANY_CAT.COMPANYCAT_ID = C.COMPANYCAT_ID
		</cfquery>
	<cfelse>
		<cfquery name="GET_ACCOUNT_SIMPLE" datasource="#DSN#">
			SELECT
				COMPANY_PARTNER.PARTNER_ID,
				COMPANY_PARTNER.COMPANY_PARTNER_NAME AS NAME,
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SURNAME,
				COMPANY_PARTNER.COMPANY_PARTNER_EMAIL AS EMAIL,
				COMPANY_PARTNER.COMPANY_PARTNER_TELCODE AS PHONE_CODE,
				COMPANY_PARTNER.COMPANY_PARTNER_TEL AS PHONE,
				COMPANY_PARTNER.MOBIL_CODE,
				COMPANY_PARTNER.MOBILTEL AS MOBILE,
				COMPANY_PARTNER.COMPANY_PARTNER_FAX AS FAX,
				COMPANY.MEMBER_CODE,
				COMPANY.NICKNAME AS COMPANY_NAME,
				COMPANY.COMPANY_ID,
				COMPANY.SECTOR_CAT_ID,
				COMPANY.COMPANY_SIZE_CAT_ID,
				COMPANY.PARTNER_ID AS AUTHORITY_ID,
				COMPANY.TAXNO AS TAX_NO,
				COMPANY.TAXOFFICE AS TAX_OFFICE,
				COMPANY.ISPOTANTIAL,
				COMPANY_CAT.COMPANYCAT
			FROM
				COMPANY_PARTNER,
				COMPANY,
				COMPANY_CAT
			WHERE
				COMPANY_PARTNER.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact_id#"> AND
				COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
				COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID
		</cfquery>	
	</cfif>	
	<cfif get_account_simple.recordcount>
		<cfquery name="GET_REMAINDER" datasource="#DSN2#" >
			SELECT COMPANY_ID FROM COMPANY_REMAINDER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_simple.company_id#">
		</cfquery>
	<cfelse>
		<script type="text/javascript">
			alert("Şirket Bilgisi Eksik !");
			history.back();
		</script>
		<cfabort>	
	</cfif>
<cfelseif contact_type is "c">
	<cfquery name="GET_ACCOUNT_SIMPLE" datasource="#DSN#">
		SELECT
			C.MEMBER_CODE,
			C.CONSUMER_NAME AS NAME,
			C.CONSUMER_SURNAME AS SURNAME,
			C.CONSUMER_EMAIL AS EMAIL,
			C.CONSUMER_HOMETELCODE AS PHONE_CODE,
			C.CONSUMER_HOMETEL AS PHONE,
			C.MOBIL_CODE,
			C.MOBILTEL AS MOBILE,
			C.CONSUMER_FAXCODE, 
			C.CONSUMER_FAX,
			C.COMPANY AS COMPANY_NAME,
			C.COMPANY_SIZE_CAT_ID,
			C.SECTOR_CAT_ID,
			C.TAX_NO,
			C.TAX_ADRESS AS TAX_OFFICE,
			C.ISPOTANTIAL,
			CC.CONSCAT
		FROM
			CONSUMER C,
			CONSUMER_CAT CC
		WHERE
			C.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact_id#"> AND
			C.CONSUMER_CAT_ID = CC.CONSCAT_ID
	</cfquery>
	<cfquery name="GET_REMAINDER" datasource="#DSN2#">
		SELECT CONSUMER_ID FROM CONSUMER_REMAINDER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact_id#">
	</cfquery>
</cfif>
