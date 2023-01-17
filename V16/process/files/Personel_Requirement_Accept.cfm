<!--- Personel Talep Formunun Onay Asamasina Eklenir, Talep Onaylandiginda IS_FINISHED = 1 set edilir, atamada gorunebilmesi icin --->
<cfquery name="Upd_Per_Finished" datasource="#attributes.data_source#">
	UPDATE #caller.dsn_alias#.PERSONEL_REQUIREMENT_FORM SET IS_FINISHED = 1 WHERE PERSONEL_REQUIREMENT_ID = #attributes.action_id#
</cfquery>
