<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.member_name=replacelist(attributes.member_name,list,list2)>
<cfset attributes.member_surname=replacelist(attributes.member_surname,list,list2)>
<cfquery name="ADD_CONSUMER" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.CONSUMER
	(
		IS_CARI,
		ISPOTANTIAL,
		CONSUMER_CAT_ID,
		CONSUMER_STAGE,
		<!--- CONSUMER_EMAIL,
		CONSUMER_FAX,
		CONSUMER_FAXCODE, --->
		COMPANY,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_WORKTEL,
		CONSUMER_WORKTELCODE,
		<!--- MOBIL_CODE, 
		MOBILTEL,--->
		TAX_OFFICE,
		TAX_NO,
		TAX_ADRESS,
		TAX_COUNTY_ID,
		TAX_CITY_ID,
		PERIOD_ID,
		CUSTOMER_VALUE_ID,
		RECORD_IP,
		RECORD_PAR,
		RECORD_DATE
	)
		VALUES 	 
	(
		1,
		0,
		1,
		#attributes.consumer_stage#,
		<!--- <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>, 
		<cfif len(attributes.fax_number)>'#attributes.fax_number#'<cfelse>NULL</cfif>,
		<cfif len(attributes.faxcode)>'#attributes.faxcode#'<cfelse>NULL</cfif>,--->
		'#attributes.comp_name#',
		'#attributes.member_name#',
		'#attributes.member_surname#',
		<cfif len(attributes.tel_number)>'#attributes.tel_number#'<cfelse>NULL</cfif>,
		<cfif len(attributes.tel_code)>'#attributes.tel_code#'<cfelse>NULL</cfif>,				
		<!--- <cfif len(attributes.mobil_code)>'#attributes.mobil_code#'<cfelse>NULL</cfif>, 
		<cfif len(attributes.mobil_tel)>'#attributes.mobil_tel#'<cfelse>NULL</cfif>,--->
		<cfif len(attributes.tax_office)>'#attributes.tax_office#'<cfelse>NULL</cfif>,				
		<cfif len(attributes.tax_num)>'#attributes.tax_num#'<cfelse>NULL</cfif>,
		<cfif len(attributes.address)>'#attributes.address#'<cfelse>NULL</cfif>,
		<cfif len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
		#session.pp.period_id#,
		1,
		'#cgi.remote_addr#',
		#session.pp.userid#,
		#now()#
	)
</cfquery>
<cfquery name="GET_MAX_CONS" datasource="#DSN2#">
	SELECT 
		MAX(CONSUMER_ID) AS MAX_CONS 
	FROM 
		#dsn_alias#.CONSUMER
</cfquery>
<cfquery name="UPD_MEMBER_CODE" datasource="#DSN2#">
	UPDATE 
		#dsn_alias#.CONSUMER 
	SET 
		MEMBER_CODE = 'C#get_max_cons.max_cons#'
	WHERE 
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_cons.max_cons#">
</cfquery>
<cfquery name="GET_ACC_INFO" datasource="#DSN#">
	SELECT PUBLIC_ACCOUNT_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
</cfquery>
<cfquery name="ADD_COMP_PERIOD" datasource="#DSN2#">
	INSERT INTO
		#dsn_alias#.CONSUMER_PERIOD
	(
		CONSUMER_ID,
		PERIOD_ID,
		ACCOUNT_CODE
	)
	VALUES
	(
		#get_max_cons.max_cons#,
		#session.pp.period_id#,
		<cfif len(get_acc_info.public_account_code)>'#get_acc_info.public_account_code#'<cfelse>NULL</cfif>
	)
</cfquery>

