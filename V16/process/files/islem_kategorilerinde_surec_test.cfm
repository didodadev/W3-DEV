<cfquery name="UPD_SHIP_1" datasource="#caller.dsn2#">
	UPDATE SHIP SET SHIP_DETAIL='surec dosyası222' WHERE SHIP_ID=#attributes.action_id#
</cfquery>
