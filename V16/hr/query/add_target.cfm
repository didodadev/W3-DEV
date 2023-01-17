<!--- hedef yetkinlik formundan gelen ekleme için--->
<cfif isdefined('attributes.per_id') and len(attributes.per_id)>
	<cfquery name="upd_perform" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE_TARGET
		SET
			FIRST_BOSS_VALID_FORM=NULL,
			FIRST_BOSS_VALID_DATE_FORM=NULL,
			SECOND_BOSS_VALID_FORM=NULL,
			SECOND_BOSS_VALID_DATE_FORM=NULL,
			THIRD_BOSS_VALID_FORM=NULL,
			THIRD_BOSS_VALID_DATE_FORM=NULL,
			FOURTH_BOSS_VALID_FORM=NULL,
			FOURTH_BOSS_VALID_DATE_FORM=NULL,
			FIFTH_BOSS_VALID_FORM=NULL,
			FIFTH_BOSS_VALID_DATE_FORM=NULL,
			UPDATE_EMP = '#SESSION.EP.USERID#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#
		WHERE
			PER_ID = #attributes.per_id#
	</cfquery>
</cfif>
<!--- //hedef yetkinlik formundan gelen ekleme için--->
<cfif isDate(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif isDate(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
<cfif isDate(attributes.other_date1)><cf_date tarih='attributes.other_date1'></cfif>
<cfif isDate(attributes.other_date2)><cf_date tarih='attributes.other_date2'></cfif>
<!--- eger birden cok calisan secilmiş ise: --->
<cfif len(attributes.record_num)>
	<cfloop from="1" to="#record_num#" index="i">
		<cfif isdefined("attributes.row_kontrol#i#") and (evaluate("attributes.row_kontrol#i#") neq 0) and len(evaluate("attributes.emp_id#i#"))>
			<cfquery name="get_pos_code" datasource="#DSN#" >
				SELECT
					POSITION_CODE
				FROM
					EMPLOYEE_POSITIONS
				WHERE
					EMPLOYEE_ID = #evaluate("attributes.emp_id#i#")#
			</cfquery>
			<cfset attributes.position_code = get_pos_code.position_code>
			<cfquery name="ADD_TARGETS" datasource="#dsn#">
				INSERT INTO
					TARGET
					(
						RECORD_EMP,
						RECORD_IP,
						<cfif isdefined('attributes.per_id') and len(attributes.per_id)>PER_ID,</cfif>
						POSITION_CODE,
						EMP_ID,
						TARGETCAT_ID,
						STARTDATE,
						FINISHDATE,
						TARGET_HEAD,
						TARGET_NUMBER,
						<cfif isdefined("attributes.target_detail") and len(attributes.target_detail)>
						TARGET_DETAIL,
						</cfif>
						CALCULATION_TYPE,
						SUGGESTED_BUDGET,
						TARGET_MONEY,
						TARGET_EMP,
						TARGET_HELP,
						TARGET_SHARE,
						TARGET_WEIGHT,
						OTHER_DATE1,
						OTHER_DATE2
					)
					VALUES 
					(
						#attributes.record_emp#,
						'#attributes.record_ip#',
						<cfif isdefined('attributes.per_id') and len(attributes.per_id)>#attributes.per_id#,</cfif>
						#attributes.position_code#,
						#evaluate("attributes.emp_id#i#")#,
						#attributes.targetcat_id#,
						<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
						<cfif isdate(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
						'#attributes.target_head#',
						<cfif len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.target_detail") and len(attributes.target_detail)>'#attributes.target_detail#',</cfif>
						#attributes.calculation_type#,
						<cfif isdefined("attributes.suggested_budget") and len(attributes.suggested_budget)>#attributes.suggested_budget#<cfelse>NULL</cfif>,
						'#attributes.money_type#',
						#attributes.target_emp_id#,
						<cfif isdefined('attributes.target_help') and len(attributes.target_help)>'#attributes.target_help#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.target_share') and len(attributes.target_share)>'#attributes.target_share#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>,
						<cfif isdefined('attributes.other_date1') and len(attributes.other_date1)>#attributes.other_date1#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.other_date2') and len(attributes.other_date2)>#attributes.other_date2#<cfelse>NULL</cfif>
					)
			</cfquery>
	
		</cfif>		
	</cfloop>
<cfelse>
		<cfquery name="ADD_TARGET" datasource="#dsn#">
			INSERT INTO 
				TARGET
				(
					RECORD_EMP,
					RECORD_IP,
					<cfif isdefined('attributes.per_id') and len(attributes.per_id)>PER_ID,</cfif>
					POSITION_CODE,
					EMP_ID,
					TARGETCAT_ID,
					STARTDATE,
					FINISHDATE,
					TARGET_HEAD,
					TARGET_NUMBER,
					TARGET_DETAIL,
					TARGET_EMP,
					TARGET_HELP,
					TARGET_SHARE,
					TARGET_WEIGHT,
					OTHER_DATE1,
					OTHER_DATE2
				)
				VALUES 
				(
					#attributes.record_emp#,
					'#attributes.record_ip#',
					<cfif isdefined('attributes.per_id') and len(attributes.per_id)>#attributes.per_id#,</cfif>
					#attributes.position_code#,
					#attributes.emp_id#,
					#attributes.targetcat_id#,
					#attributes.startdate#,
					#attributes.finishdate#,
					'#attributes.target_head#',
					<cfif len(attributes.target_number)>#attributes.target_number#<cfelse>NULL</cfif>,
					'#attributes.target_detail#',
					#attributes.target_emp_id#,
					<cfif isdefined('attributes.target_help') and len(attributes.target_help)>'#attributes.target_help#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.target_share') and len(attributes.target_share)>'#attributes.target_share#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.target_weight') and len(attributes.target_weight)>'#attributes.target_weight#'<cfelse>0</cfif>,
					<cfif isdefined('attributes.other_date1') and len(attributes.other_date1)>#attributes.other_date1#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.other_date2') and len(attributes.other_date2)>#attributes.other_date2#<cfelse>NULL</cfif>
				)
		</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
