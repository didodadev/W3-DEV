<!--- Personel Talep Formunun Red Asamasina Eklenir, Talep Reddedildiginde IS_FINISHED = 0 set edilir. --->
<cfquery name="Upd_Per_Finished" datasource="#attributes.data_source#">
	UPDATE #caller.dsn_alias#.PERSONEL_REQUIREMENT_FORM SET IS_FINISHED = 0 WHERE PERSONEL_REQUIREMENT_ID = #attributes.action_id#
</cfquery>
