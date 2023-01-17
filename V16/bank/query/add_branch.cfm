<cfset bank_id = listfirst(attributes.bank_name,';')>
<cfset bank_name = listlast(attributes.bank_name,';')>
<cfif fusebox.use_period><cfset dsn_branch = dsn3><cfelse><cfset dsn_branch = dsn></cfif>
<cfquery name="GET_BRANCH" datasource="#dsn_branch#">
	SELECT 
		BANK_BRANCH_ID
	FROM
		BANK_BRANCH
	WHERE
		BANK_NAME='#attributes.bank_name#' AND
		BANK_BRANCH_NAME='#attributes.bank_branch_name#' AND
		BANK_BRANCH_CITY='#attributes.bank_branch_city#'
</cfquery>
<cfif get_branch.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='77.Aynı İsimli Bir  Şube Var. Lütfen Yeni Bir Şube Adı Giriniz !'>");
		history.back();
	</script>
	<cfabort>
<cfelse>
<cfquery name="ADD_BANK" datasource="#dsn_branch#">
	INSERT INTO
		BANK_BRANCH
	(
		BANK_ID,
		BANK_NAME,
		BANK_BRANCH_NAME,
		BANK_BRANCH_CITY,
		BRANCH_CODE,
		SWIFT_CODE
		<cfif isDefined("attributes.bank_branch_postcode") and len(attributes.bank_branch_postcode)>
		,BANK_BRANCH_POSTCODE
		</cfif>
		<cfif isDefined("attributes.bank_branch_address") and len(attributes.bank_branch_address)>
		,BANK_BRANCH_ADDRESS
		</cfif>
		<cfif isDefined("attributes.bank_branch_country") and len(attributes.bank_branch_country)>
		,BANK_BRANCH_COUNTRY
		</cfif>
		<cfif isDefined("attributes.contact_person") and len(attributes.contact_person)>
		,CONTACT_PERSON
		</cfif>
		<cfif isDefined("attributes.bank_branch_tel") and len(attributes.bank_branch_tel)>
		,BANK_BRANCH_TEL
		</cfif>
		,COMPBRANCH_ID
		,RECORD_DATE
		,RECORD_EMP
		,RECORD_IP
	)
	VALUES
	(
		#bank_id#,
		'#bank_name#',
		'#bank_branch_name#',
		'#bank_branch_city#',
		<cfif len(attributes.branch_code)>'#attributes.branch_code#'<cfelse>NULL</cfif>,
		<cfif len(attributes.swift_code)>'#attributes.swift_code#'<cfelse>NULL</cfif>
		<cfif isDefined("attributes.bank_branch_postcode") and len(attributes.bank_branch_postcode)>
		,'#bank_branch_postcode#'
		</cfif>
		<cfif isDefined("attributes.bank_branch_address") and len(attributes.bank_branch_address)>
		,'#bank_branch_address#'
		</cfif>
		<cfif isDefined("attributes.bank_branch_country") and len(attributes.bank_branch_country)>
		,'#bank_branch_country#'
		</cfif>
		<cfif isDefined("attributes.contact_person") and len(attributes.contact_person)>
		,'#contact_person#'
		</cfif>
		<cfif isDefined("attributes.bank_branch_tel") and len(attributes.bank_branch_tel)>
		,'#bank_branch_tel#'
		</cfif>
		,<cfif isdefined("attributes.comp_branch") and len(attributes.comp_branch)>#attributes.comp_branch#<cfelse>NULL</cfif>
		,#now()#
		,#session.ep.userid#
		,'#cgi.remote_addr#'
	)
</cfquery>
<cfquery name="GET_MAXID" datasource="#dsn_branch#">
	SELECT MAX(BANK_BRANCH_ID) AS MAX_ID FROM BANK_BRANCH
</cfquery>

<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=#moduleShortName#.list_bank_branch&event=upd&id=#GET_MAXID.MAX_ID#</cfoutput>';
</script>
</cfif>
