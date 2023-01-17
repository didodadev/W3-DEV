
<cfquery name="INSORDERSTATUS" datasource="#dsn#">
	INSERT INTO ORDER_STATUS(ORDERSTATUS) VALUES ('#ORDERSTATUS#')
</cfquery>

