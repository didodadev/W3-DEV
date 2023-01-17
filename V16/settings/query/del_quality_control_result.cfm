<cfquery name="UPD_QUALITY_CONTROL_TYPE" datasource="#dsn3#">
	DELETE FROM
		QUALITY_CONTROL_ROW 		
	WHERE 
		QUALITY_CONTROL_ROW_ID= #attributes.ID#
</cfquery>
<script type="text/javascript">
	location.href = document.referrer;
</script>