<CF_DATE tarih="attributes.aktif_gun">

<cfquery name="get_protest" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT_PROTESTS WHERE EMPLOYEE_ID = #attributes.employee_id# AND ACTION_DATE = #attributes.aktif_gun#
</cfquery>

<cfif get_protest.recordcount>
	<cfquery name="upd_note" datasource="#dsn#">
		UPDATE
			EMPLOYEE_DAILY_IN_OUT_PROTESTS
		SET
			PROTEST_DETAIL = '#attributes.detail#',
			PROTEST_DATE = 	#now()#
		WHERE
			PROTEST_ID = #get_protest.PROTEST_ID#
	</cfquery>
<cfelse>
	<cfquery name="upd_note" datasource="#dsn#">
		INSERT INTO
			EMPLOYEE_DAILY_IN_OUT_PROTESTS
			(
			EMPLOYEE_ID,
			ACTION_DATE,
			PROTEST_DATE,
			PROTEST_DETAIL
			)
			VALUES
			(
			#attributes.employee_id#,
			#attributes.aktif_gun#,
			#now()#,
			'#attributes.detail#'
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	opener.location.href='<cfoutput>#request.self#?fuseaction=myhome.list_my_pdks</cfoutput>';
	window.close();
</script>
