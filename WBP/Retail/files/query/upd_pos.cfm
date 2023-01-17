<cfquery name="UPD_POS" datasource="#DSN3#">
	UPDATE
		POS_EQUIPMENT
	SET
		EQUIPMENT = '#attributes.equipment#',
        EQUIPMENT_CODE = '#attributes.EQUIPMENT_CODE#',
        PATH = '#attributes.PATH#',
        OFFLINE_PATH = '#attributes.OFFLINE_PATH#',
        FILENAME = '#attributes.FILENAME#',
		IS_STATUS = <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>,
		BRANCH_ID = <cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		CASHIER1 = <cfif len(attributes.pos_code1)>'#attributes.pos_code1#'<cfelse>NULL</cfif>,
		CASHIER2 = <cfif len(attributes.pos_code2)>'#attributes.pos_code2#'<cfelse>NULL</cfif>,
		CASHIER3 = <cfif len(attributes.pos_code3)>'#attributes.pos_code3#'<cfelse>NULL</cfif>,
        TYPE = '#attributes.type#',
        SERIAL_NUMBER = '#attributes.SERIAL_NUMBER#',
        MALI_NO = '#attributes.MALI_NO#',
		ASSETP_ID = <cfif len(attributes.assetp_id) and len(attributes.assetp)>#attributes.assetp_id#<CFELSE>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		POS_ID = #attributes.pos_id#
</cfquery>

<script type="text/javascript">
	self.close();
</script>