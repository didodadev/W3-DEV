<!--- Arıza Bildirimi --->

<cfquery name="GET_ASSET_FAILURE" datasource="#dsn#">
	SELECT 
		AFN.DOCUMENT_NO BELGE_NO,
		AFN.DETAIL ACIKLAMA,
        AFN.STATION_ID,
        AFN.PROJECT_ID,
        AFN.FAILURE_DATE,
        AFN.RECORD_DATE,
        AFN.FAILURE_EMP_ID,
		AFN.SEND_TO_ID,
        AFN.FAILURE_STAGE,
        A.ASSETP_ID,
        A.ASSETP
	FROM
		ASSET_FAILURE_NOTICE AFN,
        ASSET_P A
	WHERE
		AFN.FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
        A.ASSETP_ID = AFN.ASSETP_ID
</cfquery>
<!--- asama --->
<cfif len(GET_ASSET_FAILURE.FAILURE_STAGE)>
    <cfquery name="get_stage" datasource="#dsn#">
		SELECT
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			PTR.PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_ASSET_FAILURE.FAILURE_STAGE#">
    </cfquery>
</cfif>
<!--- arıza kodu --->
<cfquery name="get_failure_using_code" datasource="#dsn3#">
	SELECT
		SSC.SERVICE_CODE_ID,
		SSC.SERVICE_CODE
	FROM 
		#dsn_alias#.FAILURE_CODE_ROWS FCR,
		SETUP_SERVICE_CODE SSC
	WHERE 
		FCR.FAILURE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
		FCR.FAILURE_CODE_ID = SSC.SERVICE_CODE_ID
</cfquery>
<cfset ariza_kodu = valuelist(get_failure_using_code.SERVICE_CODE)>

<!--- istasyon --->
<cfif len(get_asset_failure.station_id)>
	<cfset new_dsn3 = "#dsn#_#session.ep.company_id#">
    <cfquery name="GET_STATION" datasource="#new_dsn3#">
        SELECT STATION_ID,STATION_NAME FROM WORKSTATIONS WHERE STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.station_id#">
    </cfquery>
</cfif>

<cfif len(get_asset_failure.project_id)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_asset_failure.project_id#">
	</cfquery>
</cfif>

<cf_woc_header>
	<cf_woc_elements style="width:150mm">
			<cf_wuxi id="doc_no" data="#get_asset_failure.BELGE_NO#" label="57880" type="cell">
			<cf_wuxi id="date_now" data="#dateformat(now(),dateformat_style)#" label="57742" type="cell">
		<cfif isdefined('GET_STATION.station_name') and len(GET_STATION.station_name)>
			<cf_wuxi id="sta_name" data="#get_station.STATION_NAME#" label="58834" type="cell">
		</cfif>
		<cfif len(get_asset_failure.ASSETP)>
			<cf_wuxi id="asset" data="#get_asset_failure.ASSETP#" label="29452" type="cell">
		</cfif>
			<cf_wuxi id="fail_code" data="#ariza_kodu#" label="58934" type="cell">
		<cfif len(get_asset_failure.project_id)>
			<cf_wuxi id="pro_name" data="#get_project.project_head#" label="49344" type="cell">
		</cfif>
			<cf_wuxi id="fail_date" data="#dateformat(get_asset_failure.failure_date,dateformat_style)#" label="47879" type="cell">
			<cf_wuxi id="rec_date" data="#dateformat(get_asset_failure.record_date,dateformat_style)#" label="51068" type="cell">
		<cfif len(get_asset_failure.failure_stage)>
			<cf_wuxi id="stage" data="#get_stage.stage#" label="58859" type="cell">
		</cfif>
			<cf_wuxi id="fail_exp" data="#get_asset_failure.ACIKLAMA#" label="57629" type="cell">
	</cf_woc_elements>

	<tr>
		<td width="10" height="20" class="bold"><cf_get_lang dictionary_id='48088.Bildirimi Yapan'></td>
		<td class="bold"><cf_get_lang dictionary_id='48104.Bildirimi Yapılan'></td>
	</tr>		
	<tr>
		<td height="20"><cfif len(get_asset_failure.failure_emp_id)>
				<cfoutput>#get_emp_info(get_asset_failure.failure_emp_id,0,0)#</cfoutput>
			</cfif>
		</td>
		<td><cfif len(get_asset_failure.send_to_id)>
				<cfoutput>#get_emp_info(get_asset_failure.send_to_id,0,0)#</cfoutput>
			</cfif>
		</td>
	</tr>
	<tr>
		<td height="100"></td>
		<td></td>
	</tr>
<cf_woc_footer>

