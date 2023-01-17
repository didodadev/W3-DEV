<cfquery name="GET_WORK_PROCESS" datasource="#DSN#" maxrows="1">
    SELECT TOP 1
        PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
        PROCESS_TYPE_ROWS.STAGE,
        PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER,
        PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
    FROM
        PROCESS_TYPE PROCESS_TYPE,
        PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
        PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS
    WHERE
        PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
        PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
        PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		(
			CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.form_add_care_period,%">
			OR 
			CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.list_assetp,%">
		)
</cfquery>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="GET_CARE_CONTROL" datasource="#DSN#">
			SELECT ISNULL(CARE_ID,0) AS CARE_ID FROM CARE_STATES WHERE ASSET_ID = #attributes.asset_id#
		</cfquery>
        <cfset care_id_list = valuelist(GET_CARE_CONTROL.CARE_ID,',')>
		<!---<cfif get_care_control.recordcount>--->
			<cfquery name="DEL_CARE_CONTROL" datasource="#DSN#">
				DELETE FROM CARE_STATES WHERE ASSET_ID = #attributes.asset_id#
			</cfquery>
		<!---</cfif>--->
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfset form_care_date = evaluate("attributes.care_date#i#")>
					<cf_date tarih = 'form_care_date'>
					<cfscript>
						form_care_type = evaluate("attributes.care_type#i#");
						form_aciklama = evaluate("attributes.aciklama#i#");
						form_care_type_period = evaluate("attributes.care_type_period#i#");
						//form_care_date = evaluate("attributes.care_date#i#");
						form_official_emp = evaluate("attributes.official_emp#i#");
						form_official_emp_id = evaluate("attributes.official_emp_id#i#");
						form_gun = evaluate("attributes.gun#i#");
						form_saat = evaluate("attributes.saat#i#");
						form_dakika = evaluate("attributes.dakika#i#");
						if(isdefined("attributes.station_id#i#"))form_station_id=evaluate("attributes.station_id#i#");
						else form_station_id='';
						if(isdefined("attributes.station_company_id#i#"))form_our_company_id=evaluate("attributes.station_company_id#i#");
						else form_our_company_id='';
						if(attributes.is_motorized eq 1) form_km = evaluate("attributes.care_km_period#i#");
						form_care_period_time_new = evaluate("attributes.care_period_time_new#i#");
						form_care_delay_cause = evaluate ("attributes.care_delay_cause#i#");
					</cfscript>
					<cfquery name="ADD_CARE_PERIODS" datasource="#DSN#" result="MAX_ID">
						INSERT INTO
						CARE_STATES
						(
							CARE_TYPE_ID,
							ASSET_ID,
							CARE_STATE_ID,
							PERIOD_ID,
							CARE_DAY,
							CARE_HOUR,
							CARE_MINUTE,
							<cfif attributes.is_motorized eq 1>CARE_KM,</cfif>
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE,
							IS_ACTIVE,
							DETAIL,
							PERIOD_TIME,
							OFFICIAL_EMP_ID,
                            STATION_ID,
                            OUR_COMPANY_ID,
                            PROCESS_STAGE
						)
						VALUES
						(
							2,
							#attributes.asset_id#,
							#form_care_type#,
							<cfif len(form_care_type_period)>#form_care_type_period#<cfelse>NULL</cfif>,
							<cfif len(form_gun)>#form_gun#<cfelse>NULL</cfif>,
							<cfif len(form_saat)>#form_saat#<cfelse>NULL</cfif>,
							<cfif len(form_dakika)>#form_dakika#<cfelse>NULL</cfif>,
							<cfif attributes.is_motorized eq 1><cfif isnumeric(form_km)>#form_km#<cfelse>0</cfif>,</cfif>
							#session.ep.userid#,
							'#cgi.remote_addr#',
							#now()#,
							1,
							<cfif len(form_aciklama)>'#form_aciklama#'<cfelse>NULL</cfif>,
							<cfif len(form_care_date)>#form_care_date#<cfelse>NULL</cfif>,
							<cfif len(form_official_emp) and len(form_official_emp_id)>#form_official_emp_id#<cfelse>NULL</cfif>,
                            <cfif len(form_station_id)>#form_station_id#<cfelse>NULL</cfif>,
                            <cfif len(form_our_company_id)>#form_our_company_id#<cfelse>NULL</cfif>,
                            #GET_WORK_PROCESS.PROCESS_ROW_ID#
						)

					</cfquery>
					<cfquery name="get_max_id" datasource="#dsn#">
						SELECT MAX(CARE_ID) AS CARE_ID FROM CARE_STATES 
					</cfquery>
					<cfquery name="ADD_CARE_DELAY" datasource="#dsn#">
						INSERT INTO
						CARE_DELAY
						(
							CARE_PERIOD_TIME_NEW,
							CARE_DELAY_CAUSE,
							CARE_ID,
							RECORD_EMP,
							RECORD_IP,
							RECORD_DATE
						)
						VALUES
						(
							<cfif len(form_care_period_time_new)><cfqueryparam cfsqltype="cf_sql_date" value="#form_care_period_time_new#"><cfelse>NULL</cfif>,
							<cfif len(form_care_delay_cause)><cfqueryparam cfsqltype="cf_sql_integer" value="#form_care_delay_cause#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_id.CARE_ID#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							
						)
						
					</cfquery>
                    <cfif i neq attributes.record_num>
                        <cfquery name="UPD_ASSETCARE_REPORT" datasource="#dsn#">
                            UPDATE ASSET_CARE_REPORT SET CARE_ID = #MAX_ID.IDENTITYCOL# WHERE CARE_ID = #listGetAt(care_id_list,i,',')#
                        </cfquery>
                    </cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cflocation url="#cgi.http_referer#" addtoken="no">