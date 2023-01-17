<cfquery name="UPD_QUALITY_CONTROL_TYPE" datasource="#dsn3#">
	DELETE FROM
		QUALITY_CONTROL_TYPE 		
	WHERE 
		TYPE_ID= #attributes.type_id#
</cfquery>
<script type="text/javascript">
location.href = document.referrer;
</script>
