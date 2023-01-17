<cfquery name="upd_visit" datasource="#dsn#">
	UPDATE
		EMPLOYEES_PUANTAJ_MAILS
	SET
		APPLY_DATE = #now()#
	WHERE
		ROW_ID = #attributes.row_id#
</cfquery>