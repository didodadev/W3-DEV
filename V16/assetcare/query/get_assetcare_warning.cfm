<cfquery name="GET_KM_SUM" datasource="#DSN#">
		SELECT 
			SUM(KM_FINISH - KM_START) AS TOTAL_KM
		FROM 
			ASSET_P_KM_CONTROL
		WHERE
			KM_FINISH IS NOT NULL 
			AND ASSETP_ID = #attributes.assetp_id#
		GROUP BY
			ASSETP_ID
</cfquery>
<cfquery name="GET_DAYS_SUM" datasource="#DSN#" maxrows="1">
		SELECT 
			ASSET_P_KM_CONTROL.ASSETP_ID,
			ASSET_P_KM_CONTROL.FINISH_DATE,
			ASSET_P.SUP_COMPANY_DATE,
			ASSET_P.ASSETP_ID,
			ASSET_P.MAKE_YEAR,
			ASSET_P.BRAND_TYPE_ID,
			ASSET_P.CARE_WARNING_DAY
		FROM
			ASSET_P_KM_CONTROL,
			ASSET_P
		WHERE 
			ASSET_P_KM_CONTROL.KM_FINISH IS NOT NULL
			AND ASSET_P.ASSETP_ID = ASSET_P_KM_CONTROL.ASSETP_ID
			AND ASSET_P_KM_CONTROL.ASSETP_ID = #attributes.assetp_id#
		ORDER BY
			ASSET_P_KM_CONTROL.FINISH_DATE DESC
</cfquery>
<cfquery name="GET_MAX_KM" datasource="#DSN#">
		SELECT 
			MAX(KM_FINISH) AS MAX_KM
		FROM 
			ASSET_P_KM_CONTROL
		WHERE 
			ASSETP_ID = #attributes.assetp_id#
</cfquery>
<cfset mean_km = (get_km_sum.total_km) / (dateDiff("d",get_days_sum.finish_date,get_days_sum.sup_company_date) + 1)>
<cfquery name="GET_CARE_TYPES" datasource="#DSN#">
		SELECT 
			CARE_STATE_ID
		FROM 
			CARE_STATES
		WHERE 
			ASSET_ID = #attributes.assetp_id#  
</cfquery>
<cfset care_state_id_list = ''>
	<cfoutput query="get_care_types"> 
		<cfif len(care_state_id) and not ListFind(care_state_id_list,CARE_STATE_ID)>
			<cfset care_state_id_list = ListAppend(care_state_id_list,CARE_STATE_ID)>
		</cfif>
	</cfoutput>
<cfif ListLen(care_state_id_list)>
	<cfquery name="GET_LAST_CARE_KM" datasource="#DSN#">
			SELECT 
				MAX(CARE_KM) AS MAX_CARE_KM, 
				CARE_TYPE
			FROM 
				ASSET_CARE_REPORT
			WHERE 
				ASSET_ID = #attributes.assetp_id#
				AND CARE_TYPE IN (#care_state_id_list#)
			GROUP BY
				CARE_TYPE
	</cfquery>
	<cfquery name="GET_PERIOD_KM" datasource="#DSN#">
			SELECT
				PERIOD_KM,
				CARE_TYPE_ID
			FROM 
				ASSET_P_CARE_REFERENCE
			WHERE 
				BRAND_TYPE_ID = #get_days_sum.brand_type_id#
				AND MAKE_YEAR = #get_days_sum.make_year#
				AND CARE_TYPE_ID IN (#care_state_id_list#)
				AND START_KM < #get_max_km.max_km#
				AND FINISH_KM >= #get_max_km.max_km#
			ORDER BY 
				CARE_TYPE_ID
	</cfquery>
	<cfquery name="GET_CARE_STATES" datasource="#DSN#">
			SELECT 
				MAX(PERIOD_TIME) AS LAST_PERIOD_TIME, 
				CARE_STATE_ID
			FROM 
				CARE_STATES
			WHERE 
				ASSET_ID = #attributes.assetp_id# 
				AND CARE_STATE_ID IN (#care_state_id_list#)	
			GROUP BY 
				CARE_STATE_ID 
	</cfquery>
	<cfloop index="i" from="1" to="#ListLen(care_state_id_list)#">
		<cfquery name="GET_PERIOD_KMS" dbtype="query">
			SELECT PERIOD_KM FROM get_period_km WHERE CARE_TYPE_ID = #ListGetAt(care_state_id_list,i)# 
		</cfquery>
		<cfquery name="GET_LAST_CARE_KMS" dbtype="query">
			SELECT MAX_CARE_KM FROM get_last_care_km WHERE CARE_TYPE = #ListGetAt(care_state_id_list,i)#
		</cfquery>
		<cfquery name="GET_CARE_STATESS" dbtype="query">
			SELECT LAST_PERIOD_TIME FROM get_care_states WHERE CARE_STATE_ID = #ListGetAt(care_state_id_list,i)#
		</cfquery>
		<cfif len(get_period_kms.period_km)>
		<cfscript>
			last_period_time = get_care_statess.last_period_time;
			period_km = get_period_kms.period_km;
			if(len(get_last_care_kms.max_care_km)){
			last_care_km = get_last_care_kms.max_care_km;
			}
			else {
			last_care_km = 0;
			}
			if(len(get_days_sum.care_warning_day)){
			care_warning_day = get_days_sum.care_warning_day;
			}
			else {
			care_warning_day = 0;
			}
			have_a_care_km = period_km + last_care_km;
			next_care_date_from_now = round((have_a_care_km - get_max_km.max_km) / mean_km);
		</cfscript>
		<cfif next_care_date_from_now lt care_warning_day>
			<cfquery name="ADD_CARE_STATES" datasource="#DSN#">
				INSERT INTO
				CARE_STATES
					(
						CARE_TYPE_ID,
						CARE_STATE_ID,
						ASSET_ID,
						PERIOD_TIME,
						PERIOD_ID,
					)
				VALUES
					(
						2,
						#ListGetAt(care_state_id_list,i)#,
						#attributes.assetp_id#,
						#date_add('d',next_care_date_from_now,now())#,
						1
					)	
			</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
