<cfif len(attributes.BIRTH_DATE)>
	<cf_date tarih = "attributes.BIRTH_DATE">
</cfif>
<cfif len(attributes.ARRANGEMENT_DATE)>
	<cf_date tarih = "attributes.ARRANGEMENT_DATE">
</cfif>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>

<cfquery name="UPD_HEALTY" datasource="#DSN#">
	UPDATE EMPLOYEES_RELATIVE_HEALTY
	SET
		EMP_ID = #attributes.employee_id#,
		IN_OUT_ID = #attributes.in_out_id#,
		ILL_NAME = '#attributes.ILL_NAME#',
		ILL_SURNAME = '#attributes.ILL_SURNAME#',
		ILL_RELATIVE = '#attributes.ILL_RELATIVE#',
		ILL_BIRTHPLACE = '#attributes.BIRTH_PLACE#',
		ILL_SEX = #attributes.ill_sex#,
		TC_IDENTY_NO = '#attributes.TC_IDENTY_NO#',
		BRANCH_ID = #get_in_out.BRANCH_ID#,
		ILL_BIRTHDATE = <cfif len(attributes.BIRTH_DATE)>#attributes.BIRTH_DATE#,<cfelse>NULL,</cfif>
		ARRANGEMENT_DATE = #attributes.ARRANGEMENT_DATE#,
        DOCUMENT_NO = <cfif len(attributes.document_no)>#attributes.document_no#,<cfelse>NULL,</cfif> 
        DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>
	WHERE
		DOC_ID = #ATTRIBUTES.DOC_ID#
</cfquery>
 
<script type="text/javascript">
   window.location.href = '<cfoutput>#request.self#?fuseaction=hr.list_emp_rel_healty&event=upd&doc_id=#attributes.DOC_ID#</cfoutput>'; 
</script>
