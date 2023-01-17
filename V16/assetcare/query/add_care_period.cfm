<cf_date tarih = 'attributes.care_date'>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
		<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_period")>
<cfset login_act.dsn = dsn />
<cfset ADD_CARE_PERIOD = login_act.addAssetpPeriodFnc( 
								process_stage : '#iif(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#',    
                                assetp_id : '#iif(isdefined("attributes.assetp_id") and len(attributes.assetp_id),"attributes.assetp_id",DE(""))#', 
                               station_company_id :  '#iif(isdefined("attributes.station_company_id") and len(attributes.station_company_id),"attributes.station_company_id",DE(""))#',
                                care_type_id : '#iif(isdefined("attributes.care_type_id") and len(attributes.care_type_id),"attributes.care_type_id",DE(""))#',
                                detail : '#iif(isdefined("attributes.detail") and len(attributes.detail),"attributes.detail",DE(""))#',
								place : '#iif(isdefined("attributes.place") and len(attributes.place),"attributes.place",DE(""))#',
                                care_type_period : '#iif(isdefined("attributes.care_type_period") and len(attributes.care_type_period),"attributes.care_type_period",DE(""))#',
								care_date : '#iif(isdefined("attributes.care_date") and len(attributes.care_date),"attributes.care_date",DE(""))#', 
                                official_emp : '#iif(isdefined("attributes.official_emp") and len(attributes.official_emp),"attributes.official_emp",DE(""))#',
                                official_emp_id : '#iif(isdefined("attributes.official_emp_id") and len(attributes.official_emp_id),"attributes.official_emp_id",DE(""))#',
								gun : '#iif(isdefined("attributes.gun") and len(attributes.gun),"attributes.gun",DE(""))#',
								saat : '#iif(isdefined("attributes.saat") and len(attributes.saat),"attributes.saat",DE(""))#',
								dakika : '#iif(isdefined("attributes.dakika") and len(attributes.dakika),"attributes.dakika",DE(""))#',
								station_id : '#iif(isdefined("attributes.station_id") and len(attributes.station_id),"attributes.station_id",DE(""))#',
								failure_id : '#iif(isdefined("attributes.failure_id") and len(attributes.failure_id),"attributes.failure_id",DE(""))#'
								)>
    
	<!--- Max. care_id'yi buluyoruz.--->
	<cfquery name="GET_MAX_CARE_ID" datasource="#DSN#">
		SELECT MAX(CARE_ID) AS MAX_CARE_ID FROM CARE_STATES
	</cfquery>
	<cfset max_care_id = get_max_care_id.max_care_id>
	<!--- Max. care_id'yi buluyoruz.--->
	<!--- Kazadan gelen bakımların id'lerini ayrı bir table'da tutuyoruz.  --->
	<cfif isDefined("attributes.is_from_accident")>
        <cfquery name="ADD_ACCIDENT_CARE" datasource="#DSN#">
            INSERT INTO
            ASSET_P_ACCIDENT_CARES
            (
                CARE_ID,
                ACCIDENT_ID,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            )
            VALUES
            (
                #get_max_care_id.max_care_id#,
                <cfif isdefined("attributes.accident_id") and len(attributes.accident_id)>#attributes.accident_id#<cfelse>NULL</cfif>,
                '#cgi.remote_addr#',
                #now()#,
                #session.ep.userid#
            ) 
        </cfquery>
	</cfif>
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='0'
		process_stage='#attributes.process_stage#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='CARE_STATES'
		action_column='CARE_ID'
		action_id='#max_care_id#'
		action_page='#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#max_care_id#'
		warning_description='Bakım Planı : #max_care_id#'>
  </cftransaction>
</cflock>
<cfif isdefined("attributes.failure_id") and len(attributes.failure_id)>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&failure_id=#attributes.failure_id#&care_id=#max_care_id#</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#max_care_id#</cfoutput>";
    </script>
</cfif>
