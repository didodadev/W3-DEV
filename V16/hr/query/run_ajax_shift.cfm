<cfsetting showdebugoutput="no">
<cfinclude template="../../hr/ehesap/query/get_ssk_employees.cfm">
<cfif get_ssk_employees.recordcount>
	<cfquery name="del_" datasource="#dsn#">
		DELETE FROM EMPLOYEE_DAILY_IN_OUT_SHIFT WHERE IN_OUT_ID IN (#valuelist(get_ssk_employees.in_out_id)#) AND SAL_MON = #attributes.SAL_MON# AND SAL_YEAR = #attributes.SAL_YEAR#
	</cfquery>
</cfif>
<cfscript>
	last_month_1 = CreateDateTime(session.ep.period_year, attributes.sal_mon, 1,0,0,0);
	last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon, daysinmonth(last_month_1), 23,59,59);
	aydaki_gun_sayisi = daysinmonth(last_month_1);
</cfscript>
<cfquery name="GET_GENERAL_OFFTIMES" datasource="#dsn#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES
</cfquery>
<cfset offday_list = ''>
<cfoutput query="GET_GENERAL_OFFTIMES">
	<cfscript>
		offday_gun = datediff('d',GET_GENERAL_OFFTIMES.start_date,GET_GENERAL_OFFTIMES.finish_date)+1;
		offday_startdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.start_date); 
		offday_finishdate = date_add("h", session.ep.time_zone, GET_GENERAL_OFFTIMES.finish_date);
		
		for (mck=0; mck lt offday_gun; mck=mck+1)
			{
			temp_izin_gunu = date_add("d",mck,offday_startdate);
			daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
			if(not listfindnocase(offday_list,'#daycode#'))
				offday_list = listappend(offday_list,'#daycode#');
			}
	</cfscript>
</cfoutput>

<cfoutput query="GET_SSK_EMPLOYEES">
	<cfset emp_id_ = employee_id>
	<cfset in_out_id_ = in_out_id>
	<cfset shift_id_ = shift_id>
	<cfset kisi_day_list = ''>
	<cfif len(shift_id_)>
		<cfquery name="get_shift_info" datasource="#dsn#">
			SELECT * FROM SETUP_SHIFTS WHERE SHIFT_ID = #shift_id_#
		</cfquery>
		<cfif len(get_shift_info.start_hour) and len(get_shift_info.end_hour)>
			<cfset start_gn = (get_shift_info.start_hour * 60) + get_shift_info.start_min>
			<cfset finish_gn = (get_shift_info.end_hour * 60) + get_shift_info.end_min>
			<cfset fark_gn = finish_gn - start_gn>
		<cfelse>
			<cfset fark_gn = 510>
		</cfif>
		
		<cfquery name="get_daily_rows" datasource="#dsn#">
			SELECT 
				DATEDIFF("n",START_DATE,FINISH_DATE) AS FARK,
				* 
			FROM 
				EMPLOYEE_DAILY_IN_OUT 
			WHERE 
				IN_OUT_ID = #in_out_id_# AND 
				START_DATE >= #last_month_1# AND 
				START_DATE <= #last_month_30# AND 
				DAY_TYPE IS NULL 
				AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
			ORDER BY 
				START_DATE
		</cfquery>
		<cfif get_daily_rows.recordcount>
			<cfif len(get_shift_info.start_hour) and len(get_shift_info.end_hour)>
				<cfif len(get_shift_info.week_offday)>
					<cfset hafta_tatili_ = get_shift_info.week_offday>
				<cfelse>
					<cfset hafta_tatili_ = 1>
				</cfif>
				<cfif len(get_shift_info.control_hour_1)>
					<cfset max_control_dk_ = get_shift_info.control_hour_1 * 60>
				<cfelse>
					<cfset max_control_dk_ = 450>
				</cfif>
				<cfif len(get_shift_info.control_hour_2)>
					<cfset min_control_dk_ = get_shift_info.control_hour_2 * 60>
				<cfelse>
					<cfset min_control_dk_ = 450>
				</cfif>
				
				<cfloop from="1" to="#get_daily_rows.recordcount#" index="dr">
					<cfset gun_ = dayofweek(get_daily_rows.START_DATE[dr])>
					<cfif gun_ eq 7 and hafta_tatili_ neq 7>
						<cfset start_ = (get_shift_info.STD_START_HOUR * 60) + get_shift_info.STD_START_MIN>
						<cfset finish_ = (get_shift_info.STD_END_HOUR * 60) + get_shift_info.STD_END_MIN>
						<cfset mesai_dk_ = finish_ - start_>
						<cfset saturday_control_ = 1>
						<cfset std_type_ = get_shift_info.STD_TYPE>
					<cfelse>
						<cfset saturday_control_ = 0>
						<cfset start_ = (get_shift_info.start_hour * 60) + get_shift_info.start_min>
						<cfset finish_ = (get_shift_info.end_hour * 60) + get_shift_info.end_min>
						<cfset mesai_dk_ = finish_ - start_>
						<cfset std_type_ = 0>
					</cfif>	
					<!--- bos gecen total zaman hesaplanir --->
					<cfset mesai_dk_dusulecek_ = 0>
					<cfif get_shift_info.IS_ARA_MESAI_DUS eq 1>
						<cfscript>
							m_hour_start = hour(get_daily_rows.START_DATE[dr]);
							m_minute_start = minute(get_daily_rows.START_DATE[dr]);
							m_hour_finish = hour(get_daily_rows.FINISH_DATE[dr]);
							m_minute_finish = minute(get_daily_rows.FINISH_DATE[dr]);
						</cfscript>
						<cfloop from="1" to="5" index="ccm">
							<cfif 
								len(evaluate("get_shift_info.FREE_TIME_START_HOUR_#ccm#")) and 
								len(evaluate("get_shift_info.FREE_TIME_START_MIN_#ccm#")) and 
								len(evaluate("get_shift_info.FREE_TIME_END_HOUR_#ccm#")) and 
								len(evaluate("get_shift_info.FREE_TIME_END_MIN_#ccm#")) and
								((saturday_control_ and evaluate("get_shift_info.IS_WEEKEND_#ccm#") eq 1) or saturday_control_ eq 0) and
								evaluate("get_shift_info.IS_LAST_ADD_TIME_#ccm#") neq 1 and
								evaluate("get_shift_info.IS_FISRT_ADD_TIME_#ccm#") neq 1
								>
								<cfscript>
									f_hour_start = evaluate("get_shift_info.FREE_TIME_START_HOUR_#ccm#");
									f_minute_start = evaluate("get_shift_info.FREE_TIME_START_MIN_#ccm#");
									f_hour_finish = evaluate("get_shift_info.FREE_TIME_END_HOUR_#ccm#");
									f_minute_finish = evaluate("get_shift_info.FREE_TIME_END_MIN_#ccm#");
								</cfscript>
								<cfset mesai_dk_dusulecek_ = mesai_dk_dusulecek_ + (f_hour_finish * 60 + f_minute_finish) - (f_hour_start * 60 + f_minute_start)>
							</cfif>
						</cfloop>					
					</cfif>
					<cfset mesai_dk_ = mesai_dk_ - mesai_dk_dusulecek_>
					<!--- bos gecen total zaman hesaplanir --->								
					<cfif get_shift_info.IS_ARA_MESAI_DUS eq 1>
						<cfset bos_gecen_mesai_ = 0>
						<cfscript>
							m_hour_start = hour(get_daily_rows.START_DATE[dr]);
							m_minute_start = minute(get_daily_rows.START_DATE[dr]);
							m_hour_finish = hour(get_daily_rows.FINISH_DATE[dr]);
							m_minute_finish = minute(get_daily_rows.FINISH_DATE[dr]);
						</cfscript>
						<cfloop from="1" to="5" index="ccm">
							<cfif 
								len(evaluate("get_shift_info.FREE_TIME_START_HOUR_#ccm#")) and 
								len(evaluate("get_shift_info.FREE_TIME_START_MIN_#ccm#")) and 
								len(evaluate("get_shift_info.FREE_TIME_END_HOUR_#ccm#")) and 
								len(evaluate("get_shift_info.FREE_TIME_END_MIN_#ccm#")) and
								((saturday_control_ and evaluate("get_shift_info.IS_WEEKEND_#ccm#") eq 1) or saturday_control_ eq 0) and
								evaluate("get_shift_info.IS_LAST_ADD_TIME_#ccm#") neq 1 and
								evaluate("get_shift_info.IS_FISRT_ADD_TIME_#ccm#") neq 1
								>
								<cfscript>
									mesaiden_dusulecek_fark_ = 0;
									f_hour_start = evaluate("get_shift_info.FREE_TIME_START_HOUR_#ccm#");
									f_minute_start = evaluate("get_shift_info.FREE_TIME_START_MIN_#ccm#");
									f_hour_finish = evaluate("get_shift_info.FREE_TIME_END_HOUR_#ccm#");
									f_minute_finish = evaluate("get_shift_info.FREE_TIME_END_MIN_#ccm#");
								</cfscript>
								<cfif m_hour_start lt f_hour_start and m_hour_finish gt f_hour_finish>
									<cfset mesaiden_dusulecek_fark_ = (f_hour_finish * 60 + f_minute_finish) - (f_hour_start * 60 + f_minute_start)>
									<!--- tam ara yapiyorsa --->
								<cfelseif m_hour_start eq f_hour_start and f_minute_start lte m_minute_start and m_hour_finish gt f_hour_finish>
									<cfset mesaiden_dusulecek_fark_ = (f_hour_finish * 60 + f_minute_finish) - (f_hour_start * 60 + m_minute_start)>
									<!--- tam ara yapiyorsa --->
								<cfelseif m_hour_start eq f_hour_start and f_minute_start gt m_minute_start and m_hour_finish gt f_minute_finish>
									<!--- mesai baslangici dinlenme arasina denk geliyorsa --->
									<cfset mesaiden_dusulecek_fark_ = (f_hour_finish * 60 + f_minute_finish) - (f_hour_start * 60 + m_minute_start)>
								<cfelseif m_hour_start lt f_hour_start and m_hour_finish eq f_minute_finish and m_minute_finish gt m_minute_finish>
									<!--- mesai bitisi dinlenme arasindan sonra --->
									<cfset mesaiden_dusulecek_fark_ = (f_hour_finish * 60 + f_minute_finish) - (f_hour_start * 60 + f_minute_start)>
								<cfelseif m_hour_start lt f_hour_start and m_hour_finish eq f_minute_finish and m_minute_finish lte m_minute_finish>
									<!--- mesai bitisi dinlenme arasina denk geliyorsa --->
									<cfset mesaiden_dusulecek_fark_ = (f_hour_finish * 60 + m_minute_finish) - (f_hour_start * 60 + f_minute_start)>
								<cfelseif m_hour_start eq f_hour_start and m_hour_finish eq f_minute_finish>
									<!--- mesai bitisi dinlenme arasina denk geliyorsa --->
									<cfset mesaiden_dusulecek_fark_ = f_minute_finish - f_minute_start - f_minute_finish - f_minute_start>
								<cfelseif m_hour_start gt f_hour_start and m_hour_start gt f_hour_finish>
									<!--- mesai baslangici dinlenme arasindan sonra ise --->
									<cfset mesaiden_dusulecek_fark_ = 0>
								<cfelseif m_hour_start eq f_hour_start and m_minute_start lt f_minute_start and m_hour_finish eq f_hour_finish and m_minute_finish lt f_minute_finish>
									<!--- dinlenme arasinde gelmiş gitmiş --->
									<cfset mesaiden_dusulecek_fark_ = 0>
								<cfelse>
									<cfset mesaiden_dusulecek_fark_ = 0>
								</cfif>
								<cfif mesaiden_dusulecek_fark_ lt 0>
									<cfset mesaiden_dusulecek_fark_ = 0>
								</cfif>
								<cfset bos_gecen_mesai_ = bos_gecen_mesai_ + mesaiden_dusulecek_fark_>
							</cfif>
						</cfloop>					
					<cfelse>
						<cfset bos_gecen_mesai_ = 0>
					</cfif>
					
					<cfset fark_ = get_daily_rows.fark[dr] - bos_gecen_mesai_>
					
					<cfset to_day_ = day(get_daily_rows.START_DATE[dr])>
					<cfset today_ = dateformat(get_daily_rows.START_DATE[dr],dateformat_style)>			
					
					<cfset yazilacak_ = fark_>
					
					<cfset fazla_mesai_yazilacak_ = 0>
					<cfif listlen(offday_list) and listfindnocase(offday_list,today_) and dayofweek(get_daily_rows.START_DATE[dr]) eq hafta_tatili_>
						<cfset day_type_ = 2>
						<cfset day_or_extra_ = 1>
						<cfif yazilacak_ gt mesai_dk_>
							<cfset fazla_mesai_yazilacak_ = yazilacak_ - mesai_dk_>
							<cfset yazilacak_ = mesai_dk_>
						</cfif>
					<cfelseif listlen(offday_list) and listfindnocase(offday_list,today_)>
						<cfset day_type_ = 1>
						<cfset day_or_extra_ = 1>
						<cfif yazilacak_ gt mesai_dk_>
							<cfset fazla_mesai_yazilacak_ = yazilacak_ - mesai_dk_>
							<cfset yazilacak_ = mesai_dk_>
						</cfif>
					<cfelseif dayofweek(get_daily_rows.START_DATE[dr]) eq hafta_tatili_>
						<cfset day_type_ = 0>
						<cfset day_or_extra_ = 1>
						<cfif yazilacak_ gt mesai_dk_>
							<cfset fazla_mesai_yazilacak_ = yazilacak_ - mesai_dk_>
							<cfset yazilacak_ = mesai_dk_>
						</cfif>
					<cfelse>
						<cfset day_type_ = ''>
						<cfset day_or_extra_ = 0>
						<cfset fazla_mesai_yazilacak_ = 0>
						<cfif saturday_control_ eq 0>
							<cfif fark_ lt min_control_dk_>
								<cfset yazilacak_ = 0>
							<cfelseif fark_ gte max_control_dk_ and fark_ lt mesai_dk_>
								<cfset yazilacak_ = mesai_dk_>
							<cfelseif fark_ gt mesai_dk_>
								<cfset yazilacak_ = mesai_dk_>
								<cfset fazla_mesai_yazilacak_ = fark_ - mesai_dk_>
							<cfelse>
								<cfset yazilacak_ = fark_>
							</cfif>							
						<cfelse>
							<cfif std_type_ eq 0>
								<cfif fark_ gt mesai_dk_>
									<cfset yazilacak_ = mesai_dk_>
									<cfset fazla_mesai_yazilacak_ = fark_ - mesai_dk_>
								<cfelse>
									<cfset yazilacak_ = fark_>
								</cfif>
							<cfelseif std_type_ eq 1>
								<cfset fazla_mesai_yazilacak_ = yazilacak_>
								<cfset yazilacak_ = 0>
							<cfelseif std_type_ eq 2>
								<cfset fazla_mesai_yazilacak_ = yazilacak_>
								<cfset yazilacak_ = 0>
							<cfelse>
								<cfset yazilacak_ = 0>						
							</cfif>							
						</cfif>
					</cfif>
						<cfquery name="add_" datasource="#dsn#">
							INSERT INTO
								EMPLOYEE_DAILY_IN_OUT_SHIFT
									(
									EMPLOYEE_ID,
									IN_OUT_ID,
									SAL_YEAR,
									SAL_MON,
									SAL_DAY,
									DAY_OR_EXTRA_TIME,
									ROW_MINUTE,
									DAY_TYPE,
									RECORD_DATE,									
									RECORD_IP,
									RECORD_EMP
									)
								VALUES
									(
									#emp_id_#,
									#in_out_id_#,
									#attributes.SAL_YEAR#,
									#attributes.SAL_MON#,
									#to_day_#,
									#day_or_extra_#,
									#yazilacak_#,
									<cfif len(day_type_)>#day_type_#<cfelse>NULL</cfif>,
									#now()#,
									'#cgi.REMOTE_ADDR#',
									#session.ep.userid#
									)								
						</cfquery>
						<cfif listfind('0,1,2',day_type_)>
							<cfquery name="add_" datasource="#dsn#">
								INSERT INTO
									EMPLOYEE_DAILY_IN_OUT_SHIFT
										(
										EMPLOYEE_ID,
										IN_OUT_ID,
										SAL_YEAR,
										SAL_MON,
										SAL_DAY,
										DAY_OR_EXTRA_TIME,
										ROW_MINUTE,
										DAY_TYPE,
										RECORD_DATE,									
										RECORD_IP,
										RECORD_EMP
										)
									VALUES
										(
										#emp_id_#,
										#in_out_id_#,
										#attributes.SAL_YEAR#,
										#attributes.SAL_MON#,
										#to_day_#,
										0,
										#fark_gn - mesai_dk_dusulecek_#,
										<cfif len(day_type_)>#day_type_#<cfelse>NULL</cfif>,
										#now()#,
										'#cgi.REMOTE_ADDR#',
										#session.ep.userid#
										)								
							</cfquery>
						</cfif>
						<cfif fazla_mesai_yazilacak_ gt 0>
							<cfif day_type_ eq 2 or day_type_ eq 1>
								<cfset day_type_ = ''>
							</cfif>
							<cfquery name="add_" datasource="#dsn#">
								INSERT INTO
									EMPLOYEE_DAILY_IN_OUT_SHIFT
										(
										EMPLOYEE_ID,
										IN_OUT_ID,
										SAL_YEAR,
										SAL_MON,
										SAL_DAY,
										DAY_OR_EXTRA_TIME,
										ROW_MINUTE,
										DAY_TYPE,
										RECORD_DATE,									
										RECORD_IP,
										RECORD_EMP
										)
									VALUES
										(
										#emp_id_#,
										#in_out_id_#,
										#attributes.SAL_YEAR#,
										#attributes.SAL_MON#,
										#to_day_#,
										1,
										#fazla_mesai_yazilacak_#,
										<cfif len(day_type_)>#day_type_#<cfelse>NULL</cfif>,
										#now()#,
										'#cgi.REMOTE_ADDR#',
										#session.ep.userid#
										)								
							</cfquery>							
						</cfif>
					<cfset kisi_day_list = listappend(kisi_day_list,to_day_)>
				</cfloop>
			</cfif>
		</cfif>
		<cfif listlen(kisi_day_list)>
			<cfset kisi_day_list =  listdeleteduplicates(kisi_day_list)>
		</cfif>
		<cfif listlen(kisi_day_list) lt aydaki_gun_sayisi>
			<cfloop from="1" to="#aydaki_gun_sayisi#" index="ccm">
				<cfif listlen(kisi_day_list) and not listfindnocase(kisi_day_list,ccm)>
					<cfset to_day_ = createdate(attributes.sal_year,attributes.sal_mon,ccm)>
					<cfset today_ = dateformat(to_day_,dateformat_style)>
					
					<cfif listlen(offday_list) and listfindnocase(offday_list,today_) and dayofweek(to_day_) eq hafta_tatili_>
						<cfset day_type_ = 2>
					<cfelseif listlen(offday_list) and listfindnocase(offday_list,today_)>
						<cfset day_type_ = 1>
					<cfelseif dayofweek(to_day_) eq hafta_tatili_>
						<cfset day_type_ = 0>
					<cfelse>
						<cfset day_type_ = ''>						
					</cfif>
					<cfquery name="add_" datasource="#dsn#">
						INSERT INTO
							EMPLOYEE_DAILY_IN_OUT_SHIFT
								(
								EMPLOYEE_ID,
								IN_OUT_ID,
								SAL_YEAR,
								SAL_MON,
								SAL_DAY,
								DAY_OR_EXTRA_TIME,
								ROW_MINUTE,
								DAY_TYPE,
								RECORD_DATE,									
								RECORD_IP,
								RECORD_EMP
								)
							VALUES
								(
								#emp_id_#,
								#in_out_id_#,
								#attributes.SAL_YEAR#,
								#attributes.SAL_MON#,
								#ccm#,
								0,
								#fark_gn - mesai_dk_dusulecek_#,
								<cfif len(day_type_)>#day_type_#<cfelse>NULL</cfif>,
								#now()#,
								'#cgi.REMOTE_ADDR#',
								#session.ep.userid#
								)								
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfoutput>
<script>
	open_form_ajax();
</script>
