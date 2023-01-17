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
			</cfloop>) AND
		<cfelse>
			PUANTAJ_GROUP_IDS IS NULL AND
		</cfif>
		LIMIT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.limit_id#">
</cfquery>

<cfif get_olds.recordcount>
	<script type="text/javascript">
		alert('Aynı Tarihler Arasına 2 İzin Limitileri Giremezsiniz!');
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
	<cfquery name="upd_offtime_limit" datasource="#dsn#">
		UPDATE
			SETUP_OFFTIME_LIMIT
		SET
			LIMIT_1 = <cfif isdefined("limit_1") and len(limit_1)>#limit_1#<cfelse>NULL</cfif>,
			LIMIT_2 = <cfif isdefined("limit_2") and len(limit_2) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_2#<cfelse>NULL</cfif>,
			LIMIT_3 = <cfif isdefined("limit_3") and len(limit_3) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_3#<cfelse>NULL</cfif>,
			LIMIT_4 = <cfif isdefined("limit_4") and len(limit_4) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_4#<cfelse>NULL</cfif>,
			LIMIT_5 = <cfif isdefined("limit_5") and len(limit_5) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_5#<cfelse>NULL</cfif>,
			LIMIT_1_DAYS = <cfif isdefined("limit_1_days") and len(limit_1_days)>#limit_1_days#<cfelse>NULL</cfif>,
			LIMIT_2_DAYS = <cfif isdefined("limit_2_days") and len(limit_2_days) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_2_days#<cfelse>NULL</cfif>,
			LIMIT_3_DAYS = <cfif isdefined("limit_3_days") and len(limit_3_days) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_3_days#<cfelse>NULL</cfif>,
			LIMIT_4_DAYS = <cfif isdefined("limit_4_days") and len(limit_4_days) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_4_days#<cfelse>NULL</cfif>,
			LIMIT_5_DAYS = <cfif isdefined("limit_5_days") and len(limit_5_days) and isdefined("attributes.definition_type") and attributes.definition_type eq 1>#limit_5_days#<cfelse>NULL</cfif>,
			MIN_YEARS = <cfif isdefined("min_years") and len(min_years)>#min_years#<cfelse>NULL</cfif>,
			MAX_YEARS = <cfif isdefined("max_years") and len(max_years)>#max_years#<cfelse>NULL</cfif>,
			MIN_MAX_DAYS = <cfif isdefined("min_max_days") and len(min_max_days)>#min_max_days#<cfelse>NULL</cfif>,
			STARTDATE = #attributes.startdate#,
			FINISHDATE = #finishdate_#,
			SATURDAY_ON = <cfif isDefined("attributes.saturday_on") and attributes.saturday_on eq 1>1<cfelse>0</cfif>,
			SUNDAY_ON = <cfif isDefined("attributes.sunday_on") and attributes.sunday_on eq 1>1<cfelse>0</cfif>,
			PUBLIC_HOLIDAY_ON = <cfif isDefined("attributes.public_holiday_on") and attributes.public_holiday_on eq 1>1<cfelse>0</cfif>,
			DAY_CONTROL = <cfif isdefined("attributes.day_control") and len(attributes.day_control)>#attributes.day_control#<cfelse>NULL</cfif>,
			DAY_CONTROL_AFTERNOON = <cfif isdefined("attributes.day_control_afternoon") and len(attributes.day_control_afternoon)>#attributes.day_control_afternoon#<cfelse>NULL</cfif>,
			DEFINITION_TYPE = <cfif isdefined("attributes.definition_type") and len(attributes.definition_type)>#attributes.definition_type#<cfelse>NULL</cfif>,
			PUANTAJ_GROUP_IDS = <cfif isdefined("attributes.group_id") and len(attributes.group_id)>'#attributes.group_id#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.remote_addr#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			LIMIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.limit_id#">
	</cfquery>
	<!--- <cfquery name="add_offtime_limit" datasource="#dsn#">
		INSERT INTO
			SETUP_OFFTIME_LIMIT
			(
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
			UPDATE_DATE,
			UPDATE_IP,
			UPDATE_EMP
			)
		VALUES
			(
		<cfif isdefined("LIMIT_1") and LEN(LIMIT_1)>
			#LIMIT_1#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_1_DAYS") and LEN(LIMIT_1_DAYS)>
			#LIMIT_1_DAYS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_2") and LEN(LIMIT_2)>
			#LIMIT_2#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_2_DAYS") and LEN(LIMIT_2_DAYS)>
			#LIMIT_2_DAYS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_3") and LEN(LIMIT_3)>
			#LIMIT_3#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_3_DAYS") and LEN(LIMIT_3_DAYS)>
			#LIMIT_3_DAYS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_4") and LEN(LIMIT_4)>
			#LIMIT_4#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_4_DAYS") and LEN(LIMIT_4_DAYS)>
			#LIMIT_4_DAYS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_5") and LEN(LIMIT_5)>
			#LIMIT_5#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("LIMIT_5_DAYS") and LEN(LIMIT_5_DAYS)>
			#LIMIT_5_DAYS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("MIN_YEARS") and LEN(MIN_YEARS)>
		    #MIN_YEARS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("MAX_YEARS") and LEN(MAX_YEARS)>
		    #MAX_YEARS#,
		<cfelse>
			NULL,
		</cfif>
		<cfif isdefined("MIN_MAX_DAYS") and LEN(MIN_MAX_DAYS)>
		    #MIN_MAX_DAYS#,
		<cfelse>
			NULL,
		</cfif>
			#NOW()#,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#
			)
	</cfquery> --->
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_offtime_limit&event=upd&limit_id=#attributes.limit_id#</cfoutput>';
</script>
