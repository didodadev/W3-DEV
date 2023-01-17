
<CF_DATE TARIH="STARTDATE">
<cfif len(finishdate)>
	<CF_DATE TARIH="FINISHDATE">
</cfif>

<cfquery name="upd_shift" datasource="#dsn#">
	UPDATE
		SETUP_SHIFTS
	SET
		SHIFT_NAME = '#SHIFT_NAME#',
		STARTDATE = #STARTDATE#,
	<cfif len(finishdate)>
		FINISHDATE = #FINISHDATE#,
	<cfelse>
		FINISHDATE = NULL,
	</cfif>
		WEEK_OFFDAY = #attributes.WEEK_OFFDAY#,
		START_HOUR = #START_HOUR#,
		END_HOUR = #END_HOUR#,
		START_MIN = #START_MIN#,
		END_MIN = #END_MIN#,
		STD_START_HOUR = #stday_start_hour#,
		STD_END_HOUR = #stday_end_hour#,
		STD_START_MIN = #stday_start_min#,
		STD_END_MIN = #stday_end_min#,
		FIRST_ADD_TIME_START_HOUR = #FIRST_ADD_TIME_START_HOUR#,
		FIRST_ADD_TIME_END_HOUR = #FIRST_ADD_TIME_END_HOUR#,
		FIRST_ADD_TIME_START_MIN = #FIRST_ADD_TIME_START_MIN#,
		FIRST_ADD_TIME_END_MIN = #FIRST_ADD_TIME_END_MIN#,
		LAST_ADD_TIME_START_HOUR = #LAST_ADD_TIME_START_HOUR#,
		LAST_ADD_TIME_END_HOUR = #LAST_ADD_TIME_END_HOUR#,
		LAST_ADD_TIME_START_MIN = #LAST_ADD_TIME_START_MIN#,
		LAST_ADD_TIME_END_MIN = #LAST_ADD_TIME_END_MIN#,
		FREE_TIME_NAME_1 = '#attributes.FREE_TIME_NAME_1#',
		FREE_TIME_NAME_2 = '#attributes.FREE_TIME_NAME_2#',
		FREE_TIME_NAME_3 = '#attributes.FREE_TIME_NAME_3#',
		FREE_TIME_NAME_4 = '#attributes.FREE_TIME_NAME_4#',
		FREE_TIME_NAME_5 = '#attributes.FREE_TIME_NAME_5#',
		FREE_TIME_START_HOUR_1 = <cfif len(attributes.FREE_TIME_START_HOUR_1)>#attributes.FREE_TIME_START_HOUR_1#<cfelse>NULL</cfif>,
		FREE_TIME_START_MIN_1 = <cfif len(attributes.FREE_TIME_START_MIN_1)>#attributes.FREE_TIME_START_MIN_1#<cfelse>NULL</cfif>,
		FREE_TIME_END_HOUR_1 = <cfif len(attributes.FREE_TIME_END_HOUR_1)>#attributes.FREE_TIME_END_HOUR_1#<cfelse>NULL</cfif>,
		FREE_TIME_END_MIN_1 = <cfif len(attributes.FREE_TIME_END_MIN_1)>#attributes.FREE_TIME_END_MIN_1#<cfelse>NULL</cfif>,
		FREE_TIME_START_HOUR_2 = <cfif len(attributes.FREE_TIME_START_HOUR_2)>#attributes.FREE_TIME_START_HOUR_2#<cfelse>NULL</cfif>,
		FREE_TIME_START_MIN_2 = <cfif len(attributes.FREE_TIME_START_MIN_2)>#attributes.FREE_TIME_START_MIN_2#<cfelse>NULL</cfif>,
		FREE_TIME_END_HOUR_2 = <cfif len(attributes.FREE_TIME_END_HOUR_2)>#attributes.FREE_TIME_END_HOUR_2#<cfelse>NULL</cfif>,
		FREE_TIME_END_MIN_2 = <cfif len(attributes.FREE_TIME_END_MIN_2)>#attributes.FREE_TIME_END_MIN_2#<cfelse>NULL</cfif>,
		FREE_TIME_START_HOUR_3 = <cfif len(attributes.FREE_TIME_START_HOUR_3)>#attributes.FREE_TIME_START_HOUR_3#<cfelse>NULL</cfif>,
		FREE_TIME_START_MIN_3 = <cfif len(attributes.FREE_TIME_START_MIN_3)>#attributes.FREE_TIME_START_MIN_3#<cfelse>NULL</cfif>,
		FREE_TIME_END_HOUR_3 = <cfif len(attributes.FREE_TIME_END_HOUR_3)>#attributes.FREE_TIME_END_HOUR_3#<cfelse>NULL</cfif>,
		FREE_TIME_END_MIN_3 = <cfif len(attributes.FREE_TIME_END_MIN_3)>#attributes.FREE_TIME_END_MIN_3#<cfelse>NULL</cfif>,
		FREE_TIME_START_HOUR_4 = <cfif len(attributes.FREE_TIME_START_HOUR_4)>#attributes.FREE_TIME_START_HOUR_4#<cfelse>NULL</cfif>,
		FREE_TIME_START_MIN_4 = <cfif len(attributes.FREE_TIME_START_MIN_4)>#attributes.FREE_TIME_START_MIN_4#<cfelse>NULL</cfif>,
		FREE_TIME_END_HOUR_4 = <cfif len(attributes.FREE_TIME_END_HOUR_4)>#attributes.FREE_TIME_END_HOUR_4#<cfelse>NULL</cfif>,
		FREE_TIME_END_MIN_4 = <cfif len(attributes.FREE_TIME_END_MIN_4)>#attributes.FREE_TIME_END_MIN_4#<cfelse>NULL</cfif>,			
		FREE_TIME_START_HOUR_5 = <cfif len(attributes.FREE_TIME_START_HOUR_5)>#attributes.FREE_TIME_START_HOUR_5#<cfelse>NULL</cfif>,
		FREE_TIME_START_MIN_5 = <cfif len(attributes.FREE_TIME_START_MIN_5)>#attributes.FREE_TIME_START_MIN_5#<cfelse>NULL</cfif>,
		FREE_TIME_END_HOUR_5 = <cfif len(attributes.FREE_TIME_END_HOUR_5)>#attributes.FREE_TIME_END_HOUR_5#<cfelse>NULL</cfif>,
		FREE_TIME_END_MIN_5 = <cfif len(attributes.FREE_TIME_END_MIN_5)>#attributes.FREE_TIME_END_MIN_5#<cfelse>NULL</cfif>,
		IS_WEEKEND_1 = <cfif isdefined("attributes.IS_WEEKEND_1")>1<cfelse>0</cfif>, 
		IS_WEEKEND_2 = <cfif isdefined("attributes.IS_WEEKEND_2")>1<cfelse>0</cfif>,
		IS_WEEKEND_3 = <cfif isdefined("attributes.IS_WEEKEND_3")>1<cfelse>0</cfif>,
		IS_WEEKEND_4 = <cfif isdefined("attributes.IS_WEEKEND_4")>1<cfelse>0</cfif>,
		IS_WEEKEND_5 = <cfif isdefined("attributes.IS_WEEKEND_5")>1<cfelse>0</cfif>,
		IS_FISRT_ADD_TIME_1 = <cfif isdefined("attributes.IS_FISRT_ADD_TIME_1")>1<cfelse>0</cfif>, 
		IS_FISRT_ADD_TIME_2 = <cfif isdefined("attributes.IS_FISRT_ADD_TIME_2")>1<cfelse>0</cfif>,
		IS_FISRT_ADD_TIME_3 = <cfif isdefined("attributes.IS_FISRT_ADD_TIME_3")>1<cfelse>0</cfif>,
		IS_FISRT_ADD_TIME_4 = <cfif isdefined("attributes.IS_FISRT_ADD_TIME_4")>1<cfelse>0</cfif>,
		IS_FISRT_ADD_TIME_5 = <cfif isdefined("attributes.IS_FISRT_ADD_TIME_5")>1<cfelse>0</cfif>,
		IS_LAST_ADD_TIME_1 = <cfif isdefined("attributes.IS_LAST_ADD_TIME_1")>1<cfelse>0</cfif>, 
		IS_LAST_ADD_TIME_2 = <cfif isdefined("attributes.IS_LAST_ADD_TIME_2")>1<cfelse>0</cfif>,
		IS_LAST_ADD_TIME_3 = <cfif isdefined("attributes.IS_LAST_ADD_TIME_3")>1<cfelse>0</cfif>,
		IS_LAST_ADD_TIME_4 = <cfif isdefined("attributes.IS_LAST_ADD_TIME_4")>1<cfelse>0</cfif>,
		IS_LAST_ADD_TIME_5 = <cfif isdefined("attributes.IS_LAST_ADD_TIME_5")>1<cfelse>0</cfif>,
		IS_NEXT_DAY_CONTROL = <cfif isdefined("attributes.IS_NEXT_DAY_CONTROL")>1<cfelse>0</cfif>,
		LAST_ADD_TIME_TYPE = #attributes.LAST_ADD_TIME_TYPE#,
		FIRST_ADD_TIME_TYPE = #attributes.FIRST_ADD_TIME_TYPE#,
		STD_TYPE = #attributes.STD_TYPE#,
<!--- 		FIRST_ADD_TIME_MULTIPLIER = <cfif len(attributes.FIRST_ADD_TIME_MULTIPLIER)>#attributes.FIRST_ADD_TIME_MULTIPLIER#,<cfelse>NULL,</cfif>
		LAST_ADD_TIME_MULTIPLIER = <cfif len(attributes.LAST_ADD_TIME_MULTIPLIER)>#attributes.LAST_ADD_TIME_MULTIPLIER#,<cfelse>NULL,</cfif>
		STD_MULTIPLIER = <cfif len(attributes.STD_MULTIPLIER)>#attributes.STD_MULTIPLIER#<cfelse>NULL</cfif>, --->
		CONTROL_HOUR_1 = <cfif len(attributes.CONTROL_HOUR_1)>#attributes.CONTROL_HOUR_1#<cfelse>NULL</cfif>,
		CONTROL_HOUR_2 = <cfif len(attributes.CONTROL_HOUR_2)>#attributes.CONTROL_HOUR_2#<cfelse>NULL</cfif>,
		COUNT_OVER = <cfif isdefined('attributes.count_over')>1<cfelse>0</cfif>,
		IS_PRODUCTION = <cfif len(attributes.is_production)>#attributes.is_production#<cfelse>0</cfif>,
		BRANCH_ID = <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		DEPARTMENT_ID = <cfif isdefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>#attributes.DEPARTMENT_ID#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		IS_ARA_MESAI_DUS = <cfif isdefined("attributes.IS_ARA_MESAI_DUS")>1<cfelse>0</cfif>
	WHERE
		SHIFT_ID = #attributes.SHIFT_ID#
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.this_fuseaction") and len(attributes.this_fuseaction)>
		window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.shift&event=upd&shift_id=#attributes.shift_id#</cfoutput>';
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=prod.list_ws_time&event=upd&shift_id=#attributes.shift_id#</cfoutput>';
	</cfif>
</script>

