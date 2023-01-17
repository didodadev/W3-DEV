<cfset bank_id = listfirst(attributes.bank_name,';')>
<cfset bank_name = listlast(attributes.bank_name,';')>
<cfif fusebox.use_period><cfset dsn_branch = dsn3><cfelse><cfset dsn_branch = dsn></cfif>
<cfquery name="GET_BRANCH" datasource="#dsn_branch#">
	SELECT 
		BANK_BRANCH_ID 
	FROM
		BANK_BRANCH
	WHERE 
		BANK_BRANCH_ID <> #attributes.id# AND
		BANK_NAME = '#bank_name#' AND
		BANK_BRANCH_NAME = '#bank_branch_name#' AND
		BANK_BRANCH_CITY = '#bank_branch_city#'
</cfquery>
<cfif GET_BRANCH.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='77.Aynı İsimli Bir  Şube Var. Lütfen Yeni Bir Şube Adı Giriniz !'>");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="UPD_BRANCH" datasource="#dsn_branch#">
		UPDATE
			BANK_BRANCH
		SET
			BANK_ID = #bank_id#,
			BANK_NAME = '#bank_name#',
			BRANCH_CODE = '#branch_code#',
			SWIFT_CODE = <cfif len(attributes.swift_code)>'#attributes.swift_code#'<cfelse>NULL</cfif>,
			BANK_BRANCH_NAME = '#bank_branch_name#',
			BANK_BRANCH_CITY = '#bank_branch_city#',
			BANK_BRANCH_POSTCODE='#bank_branch_postcode#',
			BANK_BRANCH_ADDRESS='#bank_branch_address#',
			BANK_BRANCH_COUNTRY='#bank_branch_country#',
			CONTACT_PERSON = '#contact_person#',
			BANK_BRANCH_TEL = '#bank_branch_tel#',
			COMPBRANCH_ID = <cfif isdefined("attributes.comp_branch") and len(attributes.comp_branch)>#attributes.comp_branch#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP =	'#cgi.remote_addr#'	
		WHERE
			BANK_BRANCH_ID = #attributes.id#
	</cfquery>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=#moduleShortName#.list_bank_branch&event=upd&id=#attributes.id#</cfoutput>';
</script>
</cfif>
