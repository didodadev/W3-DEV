<cfquery name="get_identity" datasource="#dsn3#">
	SELECT PAROLA FROM EZGI_VTS_IDENTY WHERE VTS_EMP_ID <> #attributes.id# AND PAROLA = '#attributes.pass#'
</cfquery>
<cfif get_identity.recordcount>
	<script type="text/javascript">
		alert("<cfoutput>#getLang('objects2',1444)#</cfoutput>");
		window.history.go(-1);
	</script>
    <cfabort>
</cfif>
<cfquery name="upd_vts_identity" datasource="#dsn3#">
	UPDATE 
    	EZGI_VTS_IDENTY
	SET        	
    	PAROLA = '#attributes.pass#', 
  		EMP_ID = #attributes.employee_id#, 
     	DEFAULT_DEPARTMENT_ID = #attributes.department_id#
  	WHERE 
    	VTS_EMP_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=production.upd_ezgi_vts_identity&id=#attributes.id#" addtoken="No">