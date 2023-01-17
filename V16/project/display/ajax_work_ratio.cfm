<cfsetting showdebugoutput="no">
<cfquery name="upd_work_complate" datasource="#dsn#">
	UPDATE 
		PRO_WORKS
	SET
		TO_COMPLETE = <cfif len(deger)>#deger#<cfelse>NULL</cfif>
	WHERE
		PRO_WORKS.WORK_ID=#attributes.WORK_ID#
</cfquery>
