<cfquery name="ADD_POS" datasource="#DSN3#">
	INSERT INTO
		POS_EQUIPMENT
	(
		EQUIPMENT,
        EQUIPMENT_CODE,
        PATH,
        OFFLINE_PATH,
        FILENAME,
		BRANCH_ID,
		ASSETP_ID,
		CASHIER1,
		CASHIER2,
		CASHIER3,
        TYPE,
        SERIAL_NUMBER,
        MALI_NO,
		IS_STATUS,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.equipment#',
        '#attributes.EQUIPMENT_CODE#',
        '#attributes.PATH#',
        '#attributes.OFFLINE_PATH#',
        '#attributes.FILENAME#',
		<cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.assetp_id) and len(attributes.assetp)>#attributes.assetp_id#<CFELSE>NULL</cfif>,
		<cfif len(attributes.pos_code1)>'#attributes.pos_code1#'<cfelse>NULL</cfif>,
		<cfif len(attributes.pos_code2)>'#attributes.pos_code2#'<cfelse>NULL</cfif>,
		<cfif len(attributes.pos_code3)>'#attributes.pos_code3#'<cfelse>NULL</cfif>,
		'#attributes.TYPE#',
        '#attributes.SERIAL_NUMBER#',
        '#attributes.MALI_NO#',
        1,
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
	)
</cfquery>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	<cfelse>
		wrk_opener_reload();
		self.close();
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=finance.list_pos_equipment&event=det</cfoutput>';
</script>