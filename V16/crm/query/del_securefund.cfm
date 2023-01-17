<cfif FileExists("#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#")>
	<!--- <cffile action="delete" file="#upload_folder#member#dir_seperator##attributes.OLDSECUREFUND_FILE#"> --->
	<cf_del_server_file output_file="member/#attributes.OLDSECUREFUND_FILE#" output_server="#attributes.oldsecurefund_file_server_id#">
</cfif>
<cfquery name="del_secure" datasource="#dsn#">
	DELETE 
	FROM  
		COMPANY_SECUREFUND 
	WHERE 
		SECUREFUND_ID = #ATTRIBUTES.SECUREFUND_ID#
</cfquery>
<script type="text/javascript">
	location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=crm.list_company_securefund";
</script>
<!--- <cflocation url="index.cfm?fuseaction=crm.list_company_securefund" addtoken="no"> --->
