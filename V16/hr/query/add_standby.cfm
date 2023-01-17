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
			alert("<cf_get_lang no ='1742.Aynı pozisyona birden fazla yedekleme yapılamaz'> !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>

		<cfquery name="add_standby" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_POSITIONS_STANDBY
				(
			<cfif len(chief1_emp)>
				CHIEF1_CODE,
			</cfif>
			<cfif len(chief2_emp)>
				CHIEF2_CODE,
			</cfif>
			<cfif len(chief3_emp)>
				CHIEF3_CODE,
			</cfif>
			POSITION_CODE,	
			<cfif len(candidate_pos_1_name) and len(candidate_pos_1_emp)>
				CANDIDATE_POS_1,
			</cfif>
			<cfif len(candidate_pos_2_name) and len(candidate_pos_2_emp)>
				CANDIDATE_POS_2,
			</cfif>
			<cfif len(candidate_pos_3_name) and len(candidate_pos_3_emp)>
				CANDIDATE_POS_3,
			</cfif>
			<cfif isdefined('valid1') and len(valid1)>
				VALID_1,
				VALID_1_EMP,
				VALID_1_DATE,
			</cfif>
			<cfif isdefined('valid2') and len(valid2)>
				VALID_2,
				VALID_2_EMP,
				VALID_2_DATE,
			</cfif>
				RECORD_EMP,
				RECORD_DATE,
				RECORD_KEY,
				RECORD_IP
				)
				VALUES
				(
			<cfif len(chief1_emp)>
				#CHIEF1_CODE#,
			</cfif>
			<cfif len(chief2_emp)>
				#CHIEF2_CODE#,
			</cfif>
			<cfif len(chief3_emp)>
				#CHIEF3_CODE#,
			</cfif>
				#POSITION_CODE#,
			<cfif len(candidate_pos_1_name) and len(candidate_pos_1_emp)>
				#CANDIDATE_POS_1#,
			</cfif>
			<cfif len(candidate_pos_2_name) and len(candidate_pos_2_emp)>
				#CANDIDATE_POS_2#,
			</cfif>
			<cfif len(candidate_pos_3_name) and len(candidate_pos_3_emp)>
				#CANDIDATE_POS_3#,
			</cfif>
			<cfif isdefined('valid1') and len(valid1)>
				#valid1#,
				#session.ep.userid#,
				#NOW()#,
			</cfif>
			<cfif isdefined('valid2') and len(valid2)>
				#valid2#,
				#session.ep.userid#,
				#NOW()#,
			</cfif>
				#session.ep.userid#,
				#NOW()#,
				'#SESSION.EP.USERKEY#',
				'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfquery name="add_1" datasource="#dsn#">
			UPDATE 
				EMPLOYEE_POSITIONS 
			SET 
				<cfif len(chief1_emp)>UPPER_POSITION_CODE = #CHIEF1_CODE#<cfelse>UPPER_POSITION_CODE = NULL</cfif>,
				<cfif len(CHIEF2_EMP)>UPPER_POSITION_CODE2 = #CHIEF2_CODE#<cfelse>UPPER_POSITION_CODE2 = NULL</cfif> 
			WHERE 
				POSITION_CODE = #POSITION_CODE#
		</cfquery>
		<cfquery name="get_max_sb" datasource="#dsn#">
			SELECT
				MAX(SB_ID) AS MAX_SB_ID
			FROM
				EMPLOYEE_POSITIONS_STANDBY
		</cfquery>

		<cfset MAX_ID = GET_MAX_SB.MAX_SB_ID>

	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_standby&event=upd&sb_id=#max_id#</cfoutput>";
</script>

