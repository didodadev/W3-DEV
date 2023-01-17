<cfquery name="get_departments" datasource="#dsn#">
	SELECT
		BRANCH_ID,
        DEPARTMENT_HEAD,
		DEPARTMENT_ID,
		DEPARTMENT_STATUS,
		IS_PRODUCTION,
		IS_STORE,	
		IS_ORGANIZATION	
	FROM
		DEPARTMENT
	WHERE 
		BRANCH_ID=#attributes.branches_1#
</cfquery>
<cfoutput query="get_departments">
	<cfquery name="add_department" datasource="#dsn#">
		INSERT INTO DEPARTMENT
		(
			DEPARTMENT_HEAD,	
			BRANCH_ID,
			DEPARTMENT_STATUS,
			IS_PRODUCTION,
		    IS_STORE,
		    IS_ORGANIZATION,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#DEPARTMENT_HEAD#">,		
			 #attributes.branches_2#,
			 <cfif len(DEPARTMENT_STATUS)>#DEPARTMENT_STATUS#<cfelse>0</cfif>,
		     <cfif len(IS_PRODUCTION)>#IS_PRODUCTION#<cfelse>0</cfif>,
			 <cfif len(IS_STORE)>#IS_STORE#<cfelse>0</cfif>,
			 <cfif len(IS_ORGANIZATION)>#IS_ORGANIZATION#<cfelse>0</cfif>,
			 #NOW()#,
			 #SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
		)
	</cfquery>
</cfoutput>
<script type="text/javascript">
	alert('Departman Aktarımı Başarıyla Tamamlandı !');
	window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.department_copy";
</script>

