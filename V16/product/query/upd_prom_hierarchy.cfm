<cfsetting showdebugoutput="no">
<cfquery name="upd_prom" datasource="#dsn3#">
	UPDATE 
		PROMOTIONS
	SET
		PROM_HIERARCHY = <cfif len(deger)>#deger#<cfelse>NULL</cfif>
	WHERE
		PROM_ID=#attributes.PROM_ID#
</cfquery>
