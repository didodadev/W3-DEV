<cfquery name="DEL_ASSET_INSURANCE" datasource="#DSN#">
	DELETE FROM ASSET_P_INSURANCE WHERE INSURANCE_ID = #attributes.insurance_id#
</cfquery>

<script type="text/javascript">
	location.href = document.referrer;
</script>
