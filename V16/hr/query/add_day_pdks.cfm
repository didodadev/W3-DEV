<cfif isdefined("attributes.record_num")>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol_#i#") eq 1>
			<cfscript>
				emp_id = evaluate("attributes.employee_id#i#");
				in_out_id = evaluate("attributes.in_out_id#i#");
				rec_startdate = CreateDateTime(year(attributes.startdate_),month(attributes.startdate_),day(attributes.startdate_),9,0,0);
				last_month_1 = CreateDateTime(year(attributes.startdate_),month(attributes.startdate_),day(attributes.startdate_),0,0,0);
				last_month_30 = CreateDateTime(year(attributes.startdate_),month(attributes.startdate_),day(attributes.startdate_),23,59,59);
				worktime_action = createObject("component", "V16.hr.cfc.employees_ext_worktimes");
				worktime_action.dsn = dsn;
				daily_inout_action = createObject("component", "V16.hr.cfc.daily_in_out");
				daily_inout_action.dsn = dsn;
			</cfscript>
			<cfif len(emp_id) and len(in_out_id)>
				<cfquery name="get_offtime" datasource="#dsn#">
					SELECT
						E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_NAME,
						O.STARTDATE,
						O.FINISHDATE
					FROM
						OFFTIME O
						INNER JOIN SETUP_OFFTIME SO ON O.OFFTIMECAT_ID = SO.OFFTIMECAT_ID
						INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = O.EMPLOYEE_ID
					WHERE
						((O.STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">) OR
	                    (O.FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">) OR
	                    (O.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND O.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">)) AND
						SO.IS_PAID = 0 AND
						SO.IS_YEARLY = 0 AND
						O.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
				</cfquery>
				<cfif get_offtime.recordcount>
					<script type="text/javascript">
						alert("<cfoutput>#get_offtime.employee_name# çalışanın #dateformat(get_offtime.startdate,dateformat_style)# - #dateformat(get_offtime.finishdate,dateformat_style)#</cfoutput> tarihleri arasında izni mevcuttur!");
						history.back();
					</script>
					<cfif evaluate("attributes.normal_day#i#") neq 0>
						<cfabort>
					</cfif>
				</cfif>
				<cfquery name="get_pdks" datasource="#dsn#">
					SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#"> AND
					(
						        (
						        	START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
						        	FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
						        )
						        OR
						        (
							        START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
							        FINISH_DATE IS NULL
						        )
						        OR
						        (
							        START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
							        START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
						        )
						        OR
						        (
							        FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
							        FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
						        )
						    ) 
							AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
				</cfquery>
				<cfif evaluate("attributes.normal_day#i#") neq 0 or (evaluate("attributes.normal_day#i#") eq 0 and get_offtime.recordcount)>
					<cfscript>
						tmp_clock = evaluate("attributes.normal_day#i#");
						tmp_sec = tmp_clock * 3600;
						pdks_finishdate = dateAdd("s",tmp_sec,rec_startdate);
					</cfscript>
					<cfif get_pdks.recordcount>
                        <cfoutput query="get_pdks">
							<cfset action_ = 'Pdks Kaydı Silindi(Gün Bazında Pdks)(EMP_ID:#get_pdks.EMPLOYEE_ID# #dateformat(get_pdks.start_date,dateformat_style)# #timeformat(get_pdks.start_date,timeformat_style)# - #dateformat(get_pdks.finish_date,dateformat_style)# #timeformat(get_pdks.finish_date,timeformat_style)# ROW_ID:#get_pdks.row_id#)'>
                            <cf_add_log  log_type="-1" action_id="#get_pdks.row_id#" action_name="#action_#">
                        </cfoutput>
                        <cfquery name="del_pdks" datasource="#dsn#">
							DELETE FROM EMPLOYEE_DAILY_IN_OUT WHERE ROW_ID IN (#valuelist(get_pdks.row_id)#)
						</cfquery>
					</cfif>
						<cfquery name="get_branch" datasource="#dsn#">
							SELECT BRANCH_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
						</cfquery>
						<cfscript>
							add_daily_inout = daily_inout_action.add_daily_in_out(
								employee_id: emp_id,
								in_out_id: in_out_id,
								branch_id: get_branch.branch_id,
								start_date: rec_startdate,
								finish_date: pdks_finishdate);
						</cfscript>
                        <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEE_DAILY_IN_OUT" target_table="EMPLOYEE_DAILY_IN_OUT_HISTORY" record_id= "#add_daily_inout#" record_name="ROW_ID">
				<cfelse>
					<cfif get_pdks.recordcount>
						<cfset action_ = 'Pdks Kaydı Silindi(Gün Bazında Pdks)(EMP_ID:#get_pdks.EMPLOYEE_ID# #dateformat(get_pdks.start_date,dateformat_style)# #timeformat(get_pdks.start_date,timeformat_style)# - #dateformat(get_pdks.finish_date,dateformat_style)# #timeformat(get_pdks.finish_date,timeformat_style)# ROW_ID:#get_pdks.row_id#)'>
                        <cf_add_log  log_type="-1" action_id="#get_pdks.row_id#" action_name="#action_#">
                        <cfquery name="del_pdks" datasource="#dsn#">
							DELETE EMPLOYEE_DAILY_IN_OUT WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pdks.row_id#">
						</cfquery>
					</cfif>
				</cfif>
				<cfquery name="del_ext_worktimes" datasource="#dsn#">
					DELETE EMPLOYEES_EXT_WORKTIMES 
					WHERE 
					((
				        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
				        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
				        )
				        OR
				        (
				        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
				        END_TIME IS NULL
				        )
				        OR
				        (
				        START_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
				        START_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
				        )
				        OR
				        (
				        END_TIME >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND
				        END_TIME <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_30#">
				        )
				    ) AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id#">
				</cfquery>
				<cfset action_ = 'Fazla Mesai Kaydı Silindi(Gün Bazında Pdks Toplu Ekran)(IN_OUT_ID:#in_out_id# Tarih:#last_month_1#'>
                <cf_add_log  log_type="-1" action_id="#in_out_id#" action_name="#action_#">
				<cfif evaluate("attributes.normal_workhour#i#") neq 0>
					<cfscript>
						tmp_ext_clock = evaluate("attributes.normal_workhour#i#");
						tmp_type = 0;
						tmp_ext_sec = tmp_ext_clock * 3600;
						ext_finishdate = dateAdd("s",tmp_ext_sec,rec_startdate);
						add_ext_wrktime = worktime_action.add_worktime(
								is_puantaj_off: 0,
								employee_id: emp_id,
								start_time: rec_startdate,
								end_time: ext_finishdate,
								day_type: tmp_type,
								in_out_id: in_out_id,
								valid: 1,
								validdate: now(),
								valid_employee_id: session.ep.userid);
					</cfscript>
                    <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id= "#add_ext_wrktime#" record_name="EWT_ID">
				</cfif>
				<cfif evaluate("attributes.weekend_work#i#") neq 0>
					<cfscript>
						tmp_ext_clock = evaluate("attributes.weekend_work#i#");
						tmp_type = 1;
						tmp_ext_sec = tmp_ext_clock * 3600;
						ext_finishdate = dateAdd("s",tmp_ext_sec,rec_startdate);
						add_ext_wrktime = worktime_action.add_worktime(
								is_puantaj_off: 0,
								employee_id: emp_id,
								start_time: rec_startdate,
								end_time: ext_finishdate,
								day_type: tmp_type,
								in_out_id: in_out_id,
								valid: 1,
								validdate: now(),
								valid_employee_id: session.ep.userid);
					</cfscript>
                    <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id= "#add_ext_wrktime#" record_name="EWT_ID">
				</cfif>
				<cfif evaluate("attributes.holiday_work#i#") neq 0>
					<cfscript>
						tmp_ext_clock = evaluate("attributes.holiday_work#i#");
						tmp_type = 2;
						tmp_ext_sec = tmp_ext_clock * 3600;
						ext_finishdate = dateAdd("s",tmp_ext_sec,rec_startdate);
						add_ext_wrktime = worktime_action.add_worktime(
								is_puantaj_off: 0,
								employee_id: emp_id,
								start_time: rec_startdate,
								end_time: ext_finishdate,
								day_type: tmp_type,
								in_out_id: in_out_id,
								valid: 1,
								validdate: now(),
								valid_employee_id: session.ep.userid);
					</cfscript>
                    <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id= "#add_ext_wrktime#" record_name="EWT_ID">
				</cfif>
				<cfif evaluate("attributes.offshore#i#") neq 0>
					<cfscript>
						tmp_ext_clock = evaluate("attributes.offshore#i#");
						tmp_type = 3;
						tmp_ext_sec = tmp_ext_clock * 3600;
						ext_finishdate = dateAdd("s",tmp_ext_sec,rec_startdate);
						add_ext_wrktime = worktime_action.add_worktime(
								is_puantaj_off: 0,
								employee_id: emp_id,
								start_time: rec_startdate,
								end_time: ext_finishdate,
								day_type: tmp_type,
								in_out_id: in_out_id,
								valid: 1,
								validdate: now(),
								valid_employee_id: session.ep.userid);
					</cfscript>
                    <cf_wrk_get_history datasource="#dsn#" source_table="EMPLOYEES_EXT_WORKTIMES" target_table="EMPLOYEES_EXT_WORKTIMES_HISTORY" record_id= "#add_ext_wrktime#" record_name="EWT_ID">
				</cfif>
			</cfif>
		<cfelse>
			<cfscript>
				old_emp_id = evaluate("attributes.old_emp_id#i#");
				day_start = CreateDateTime(year(attributes.startdate_),month(attributes.startdate_),day(attributes.startdate_),0,0,0);
				day_end = CreateDateTime(year(attributes.startdate_),month(attributes.startdate_),day(attributes.startdate_),23,59,59);
			</cfscript>
			<cfif len(old_emp_id)>
				<cfif evaluate("attributes.row_id#i#") neq 0>
					<cfset action_ = 'Pdks Kaydı Silindi(Gün Bazında Pdks)(EMP_ID:#old_emp_id# #dateformat(day_start,dateformat_style)# #timeformat(day_start,timeformat_style)# - #dateformat(day_end,dateformat_style)# #timeformat(day_end,timeformat_style)# ROW_ID:#evaluate("attributes.row_id#i#")#)'>
                    <cf_add_log  log_type="-1" action_id="#evaluate('attributes.row_id#i#')#" action_name="#action_#">
                    <cfquery name="del_pdks" datasource="#dsn#">
						DELETE 
							EMPLOYEE_DAILY_IN_OUT 
						WHERE 
							EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#old_emp_id#"> AND
							(
						        (
						        	START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_start#"> AND
						        	FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_end#">
						        )
						        OR
						        (
							        START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_start#"> AND
							        FINISH_DATE IS NULL
						        )
						        OR
						        (
							        START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_start#"> AND
							        START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_end#">
						        )
						        OR
						        (
							        FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_start#"> AND
							        FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#day_end#">
						        )
						    )
					</cfquery>  
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=hr.day_pdks_table&branch_id=#attributes.branch_id#&is_submitted=#attributes.is_submitted#&startdate=#attributes.startdate#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
