<cfif len(form.plus_date)><cf_date tarih="form.plus_date"></cfif>
<cfquery name="ADD_ORDER_PLUS" datasource="#DSN3#">
	INSERT INTO 
		SERVICE_PLUS 
        (
            SUBJECT,
            SERVICE_ID,
            PLUS_DATE,
            COMMETHOD_ID,
            PLUS_CONTENT,
            RECORD_DATE,
            RECORD_PAR,
            RECORD_IP,
            UPDATE_DATE,
            UPDATE_PAR,
            UPDATE_IP,			
            SERVICE_ZONE
        )
		VALUES 
        (
			'#form.header#',
			#form.service_id#,
			<cfif len(attributes.plus_date)>#form.plus_date#,<cfelse>null,</cfif>
			<cfif len(form.commethod_id)>#form.commethod_id#,<cfelse>null,</cfif>
			'#form.plus_content#',
			#now()#,
			#session.pp.userid#,
			'#CGI.REMOTE_ADDR#',
			#now()#,
			#session.pp.userid#,
			'#CGI.REMOTE_ADDR#',			
			0
		)
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
