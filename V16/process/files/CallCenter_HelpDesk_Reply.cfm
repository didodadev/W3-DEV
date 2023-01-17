<!--- Asama Degistirildiginde Etkilesim Otomatik Olarak Cevaplandirildi Yapilir FBS 20090402 --->
<cfquery name="upd_customer_help" datasource="#attributes.data_source#">
	UPDATE #caller.dsn_alias#.CUSTOMER_HELP SET IS_REPLY_MAIL = 1 WHERE CUS_HELP_ID = #attributes.action_id#
</cfquery>

