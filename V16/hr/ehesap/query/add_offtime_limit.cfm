<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">

<cfset finishdate_ = date_add("h",23,attributes.finishdate)>
<cfset finishdate_ = date_add("n",59,finishdate_)>
<cfset finishdate_ = date_add("s",59,finishdate_)>

<cfquery name="get_olds" datasource="#dsn#">
	SELECT 
		LIMIT_ID 
	FROM 
		SETUP_OFFTIME_LIMIT 
	WHERE 
		STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
		FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		<cfif isdefined('attributes.group_id') and len(attributes.group_id)>
		(
			<cfloop list="#attributes.group_id#" index="i">
				','+PUANTAJ_GROUP_IDS+',' LIKE '%,#i#,%' <cfif i neq listlast(attributes.group_id,',')>OR</cfif>
			</cfloop>)
		<cfelse>
			PUANTAJ_GROUP_IDS IS NULL
		</cfif>
</cfquery>
<cfif get_olds.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1223.Aynı Tarihler Arasına 2 İzin Limiti Giremezsiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset list = ''>
 <cfif isDefined("min_limit") and len(min_limit)>
     <cfset list = listappend(list,min_limit,",")>
  <cfelse>
     <cfset list = listappend(list,0,",")>
  </cfif>
  <cfif isDefined("max_limit") and len(max_limit)>
     <cfset list = listappend(list,max_limit,",")>
  <cfelse>
     <cfset list = listappend(list,9999,",")>
  </cfif>
  <cfif isDefined("days_limit") and len(days_limit)>
     <cfset list = listappend(list,days_limit,",")>
  <cfelse>
     <cfset list = listappend(list,20,",")>
  </cfif>
	<cfquery name="add_offtime_limit" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			SETUP_OFFTIME_LIMIT
		(
			STARTDATE,
			FINISHDATE,
			LIMIT_1,
			LIMIT_1_DAYS,
			LIMIT_2,
			LIMIT_2_DAYS,
			LIMIT_3,
			LIMIT_3_DAYS,
			LIMIT_4,
			LIMIT_4_DAYS,
			LIMIT_5,
			LIMIT_5_DAYS,
		    MIN_YEARS,
		    MAX_YEARS,
		    MIN_MAX_DAYS,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP,
			SATURDAY_ON,
            SUNDAY_ON,
            PUBLIC_HOLIDAY_ON,
			DAY_CONTROL,
			DAY_CONTROL_AFTERNOON,
			DEFINITION_TYPE,
			PUANTAJ_GROUP_IDS
		)
		VALUES
		(
			#attributes.startdate#,
			#finishdate_#,
			<cfif isdefined("limit_1") and len(limit_1)>#limit_1#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_1_days") and len(limit_1_days)>#limit_1_days#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_2") and len(limit_2)>#limit_2#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_2_days") and len(limit_2_days)>#limit_2_days#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_3") and len(limit_3)>#limit_3#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_3_days") and len(limit_3_days)>#limit_3_days#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_4") and len(limit_4)>#limit_4#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_4_days") and LEN(limit_4_days)>#limit_4_days#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_5") and len(limit_5)>#limit_5#<cfelse>NULL</cfif>,
			<cfif isdefined("limit_5_days") and len(limit_5_days)>#limit_5_days#<cfelse>NULL</cfif>,
			<cfif isdefined("min_years") and len(min_years)>#min_years#<cfelse>NULL</cfif>,
			<cfif isdefined("max_years") and len(max_years)>#max_years#<cfelse>NULL</cfif>,
			<cfif isdefined("min_max_days") and len(min_max_days)>#min_max_days#<cfelse>NULL</cfif>,
			#now()#,
			'#cgi.remote_addr#',
			#session.ep.userid#,
			<cfif isDefined("attributes.saturday_on") and attributes.saturday_on eq 1>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.sunday_on") and attributes.sunday_on eq 1>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.public_holiday_on") and attributes.public_holiday_on eq 1>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.day_control") and len(attributes.day_control)>#attributes.day_control#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.day_control_afternoon") and len(attributes.day_control_afternoon)>#attributes.day_control_afternoon#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.definition_type") and len(attributes.definition_type)>#attributes.definition_type#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.group_id") and len(attributes.group_id)>'#attributes.group_id#'<cfelse>NULL</cfif>
		)
	</cfquery>
	<cfset attributes.limit_id=MAX_ID.IDENTITYCOL>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_offtime_limit&event=upd&limit_id=#attributes.limit_id#</cfoutput>';
</script>
