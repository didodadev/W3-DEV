<!---
<cfquery name="check" datasource="#dsn#">
	SELECT
		SB_ID
	FROM
		EMPLOYEE_POSITIONS_STANDBY
	WHERE
		POSITION_CODE = #POSITION_CODE#
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert('Aynı pozisyona birden fazla yedekleme yapılamaz !');
		history.back();
	</script>
	<CFABORT>
</cfif>
--->
<cfquery name="upd_standby" datasource="#dsn#">
	UPDATE
		EMPLOYEE_POSITIONS_STANDBY
	SET
		POSITION_CODE = #POSITION_CODE#,
		<cfif len(chief1_emp)>CHIEF1_CODE = #CHIEF1_CODE#,</cfif>
		<cfif len(chief2_emp) and len(chief2_name) and len(CHIEF2_CODE)>CHIEF2_CODE = #CHIEF2_CODE#,<cfelse>CHIEF2_CODE = NULL,</cfif>
		<cfif len(chief3_emp) and len(chief3_name) and len(CHIEF3_CODE)>CHIEF3_CODE = #CHIEF3_CODE#,<cfelse>CHIEF3_CODE = NULL,</cfif>	
		<cfif len(candidate_pos_1_name) and len(candidate_pos_1_emp)>CANDIDATE_POS_1 = #CANDIDATE_POS_1#,<cfelse>CANDIDATE_POS_1 = NULL,</cfif>
		<cfif len(candidate_pos_2_name) and len(candidate_pos_2_emp)>CANDIDATE_POS_2 = #CANDIDATE_POS_2#,<cfelse>CANDIDATE_POS_2 = NULL,</cfif>
		<cfif len(candidate_pos_3_name) and len(candidate_pos_3_emp)>CANDIDATE_POS_3 = #CANDIDATE_POS_3#,<cfelse>CANDIDATE_POS_3 = NULL,</cfif>
			UPDATE_DATE = #NOW()#,
			UPDATE_KEY = '#SESSION.EP.USERKEY#',
			UPDATE_EMP = #session.ep.userid#,
		<cfif isdefined('valid1') and len(valid1)>
			VALID_1 = #valid1#,
			VALID_1_EMP = #session.ep.userid#,
			VALID_1_DATE = #NOW()#,
		</cfif>
		<cfif isdefined('valid2') and len(valid2)>
			VALID_2 = #valid2#,
			VALID_2_EMP = #session.ep.userid#,
			VALID_2_DATE = #NOW()#,
		</cfif>
			UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		SB_ID = #attributes.SB_ID#
</cfquery>
<cfquery name="upd_1" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_POSITIONS 
	SET 
		UPPER_POSITION_CODE = #CHIEF1_CODE#
		<cfif len(chief2_emp) and len(chief2_name) and len(CHIEF2_CODE)>,UPPER_POSITION_CODE2 = #CHIEF2_CODE#<cfelse>,UPPER_POSITION_CODE2 = NULL</cfif> 
	WHERE 
		POSITION_CODE = #POSITION_CODE#
</cfquery>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_standby&event=upd&sb_id=#sb_id#</cfoutput>";
</script>

