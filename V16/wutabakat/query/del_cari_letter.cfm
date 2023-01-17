<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADDMAIN" datasource="#dsn2#">
			DELETE FROM CARI_LETTER WHERE CARI_LETTER_ID = #attributes.cari_letter_id#
		</cfquery>
		<cfquery name="ADDMAIN" datasource="#dsn2#">
			DELETE FROM CARI_LETTER_ROW WHERE CARI_LETTER_ID = #attributes.cari_letter_id#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="index.cfm?fuseaction=finance.list_cari_letter" addtoken="no">