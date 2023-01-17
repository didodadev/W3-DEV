<cfif attributes.upd_id eq 1>
	<cfquery name="DENY_PR" datasource="#DSN#">
		UPDATE
			SALARYPARAM_GET_REQUESTS
		SET
			IN_OUT_ID = #ATTRIBUTES.employee_in_out_id#,
			IS_VALID=#upd_id#,
			VALID_EMP=#SESSION.EP.USERID#,
			VALID_DATE=#NOW()#
		WHERE
			SPGR_ID=#attributes.request_id#		
	</cfquery>
	<cfquery name="GET_REQUEST" datasource="#dsn#">
		SELECT 
    	    SPGR_ID, 
            COMMENT_GET, 
            PERIOD_GET, 
            METHOD_GET, 
            AMOUNT_GET, 
            SHOW, 
            START_SAL_MON, 
            EMPLOYEE_ID, 
            TERM, 
            CALC_DAYS, 
            FROM_SALARY, 
            IN_OUT_ID, 
            DETAIL, 
            ODKES_ID,
            TAKSIT_NUMBER, 
            VALIDATOR_POSITION_CODE, 
            VALID_EMP, 
            VALID_DATE, 
            IS_VALID, 
            RECORD_DATE,
            RECORD_IP, 
            RECORD_EMP, 
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP, 
            VALID_1, 
            VALIDATOR_POSITION_CODE_1, 
            VALID_2, 
            VALIDATOR_POSITION_CODE_2, 
            VALID_EMPLOYEE_ID_2 
        FROM 
	        SALARYPARAM_GET_REQUESTS 
        WHERE 
        	SPGR_ID = #attributes.request_id#	
	</cfquery>
	<cfscript>
		kayit_sayisi = get_request.taksit_number-1;
		ay_sayisi= get_request.start_sal_mon + get_request.taksit_number;
		sonraki_yil = session.ep.period_year+1;
		taksit = get_request.amount_get / get_request.taksit_number;
		ilk_ay = get_request.start_sal_mon;
		yil = get_request.term;
		ay=0;
		artim=0;
	</cfscript>
<cfloop from="0" to="#kayit_sayisi#" index="i">
	<cfset ay = ilk_ay + artim>
	<cfif ay gt 12>
		<cfset ay = 1>
		<cfset ilk_ay = 1>
		<cfset artim = 0>
		<cfset yil = yil + 1>
	</cfif>
	<cfquery name="add_row" datasource="#dsn#">
		INSERT INTO SALARYPARAM_GET
			(
			COMMENT_GET,
			AMOUNT_GET,
			SHOW,
			METHOD_GET,
			PERIOD_GET, 
			START_SAL_MON,
			END_SAL_MON,
			EMPLOYEE_ID,
			TERM,
			CALC_DAYS,
			FROM_SALARY,
			IN_OUT_ID,
			IS_INST_AVANS,
			DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
			)
		VALUES
			(
			'#get_request.comment_get#',
			#taksit#,
			#get_request.show#,
			#get_request.method_get#,
			#get_request.period_get#,
			#ay#,
			#ay#,
			#get_request.employee_id#,
			#yil#,
			#get_request.calc_days#,
			#get_request.FROM_SALARY#,
			#attributes.employee_in_out_id#,
			1,
			'#get_request.detail#',
			#NOW()#,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
	<cfset artim=artim+1>
</cfloop>
<cfelseif attributes.upd_id eq 0>
	<cfquery name="DENY_PR" datasource="#DSN#">
		UPDATE
			SALARYPARAM_GET_REQUESTS
		SET
			IS_VALID=#upd_id#,
			VALID_EMP=#SESSION.EP.USERID#,
			VALID_DATE=#NOW()#
		WHERE
			SPGR_ID=#attributes.request_id#		
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

