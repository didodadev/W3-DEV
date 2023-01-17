<cfif len(BIRTH_DATE)>
	<CF_DATE tarih="BIRTH_DATE">
</cfif>

<cfif len(ARRANGEMENT_DATE)>
	<CF_DATE tarih="ARRANGEMENT_DATE">
</cfif>
<cfquery name="get_in_out" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID = #attributes.in_out_id#
</cfquery>

<cfquery name="ADD_EMP_REL" datasource="#DSN#" result="maxID">
  INSERT INTO
    EMPLOYEES_RELATIVE_HEALTY
   (
    EMP_ID,
	ILL_NAME,
	ILL_SURNAME,
	ILL_BIRTHDATE,
	ILL_BIRTHPLACE,
	TC_IDENTY_NO,
	ILL_RELATIVE,
	ILL_SEX,
	ARRANGEMENT_DATE,
	BRANCH_ID,
	RECORD_DATE,
	RECORD_EMP,
	IN_OUT_ID,
	DOCUMENT_NO,
	DETAIL
   )
   VALUES
   (
    #attributes.EMPLOYEE_ID#,
	'#ill_name#',
	'#ill_surname#',
	 <cfif len(attributes.BIRTH_DATE)>#BIRTH_DATE#,<cfelse>NULL,</cfif>
	'#BIRTH_PLACE#',
	'#TC_IDENTY_NO#',
	'#ill_relative#',
	#attributes.ill_sex#,
	 <cfif len(attributes.ARRANGEMENT_DATE)>#ARRANGEMENT_DATE#,<cfelse>NULL,</cfif>
	 #get_in_out.BRANCH_ID#,
	 #NOW()#,
	 #SESSION.EP.USERID#,
	 #attributes.in_out_id#,
	 <cfif len(attributes.document_no)>#attributes.document_no#,<cfelse>NULL,</cfif> 
	 <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif> 
   )
</cfquery>

 <script type="text/javascript">
   window.location.href = '<cfoutput>#request.self#?fuseaction=hr.list_emp_rel_healty&event=upd&doc_id=#maxID.identityCol#</cfoutput>'; 
 </script>
