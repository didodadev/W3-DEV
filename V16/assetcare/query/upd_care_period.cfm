<cf_date tarih = 'attributes.care_date'>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_period")>
        <cfset login_act.dsn = dsn />
        <cfset upd_care_period = login_act.updAssetpPeriodFnc( 
								process_stage : '#iif(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#',    
                                assetp_id : '#iif(isdefined("attributes.assetp_id") and len(attributes.assetp_id),"attributes.assetp_id",DE(""))#', 
                               	station_company_id :  '#iif(isdefined("attributes.station_company_id") and len(attributes.station_company_id),"attributes.station_company_id",DE(""))#',
                                care_type_id : '#iif(isdefined("attributes.care_type_id") and len(attributes.care_type_id),"attributes.care_type_id",DE(""))#',
                                detail : '#iif(isdefined("attributes.detail") and len(attributes.detail),"attributes.detail",DE(""))#',
                                care_type_period : '#iif(isdefined("attributes.care_type_period") and len(attributes.care_type_period),"attributes.care_type_period",DE(""))#',
								care_date : '#iif(isdefined("attributes.care_date") and len(attributes.care_date),"attributes.care_date",DE(""))#', 
                                official_emp : '#iif(isdefined("attributes.official_emp") and len(attributes.official_emp),"attributes.official_emp",DE(""))#',
                                official_emp_id : '#iif(isdefined("attributes.official_emp_id") and len(attributes.official_emp_id),"attributes.official_emp_id",DE(""))#',
								gun : '#iif(isdefined("attributes.gun") and len(attributes.gun),"attributes.gun",DE(""))#',
								saat : '#iif(isdefined("attributes.saat") and len(attributes.saat),"attributes.saat",DE(""))#',
								dakika : '#iif(isdefined("attributes.dakika") and len(attributes.dakika),"attributes.dakika",DE(""))#',
								station_id : '#iif(isdefined("attributes.station_id") and len(attributes.station_id),"attributes.station_id",DE(""))#',
								station_name : '#iif(isdefined("attributes.station_name") and len(attributes.station_name),"attributes.station_name",DE(""))#',
								care_id : '#iif(isdefined("attributes.care_id") and len(attributes.care_id),"attributes.care_id",DE(""))#',
								failure_id : '#iif(isdefined("attributes.failure_id") and len(attributes.failure_id),"attributes.failure_id",DE(""))#',
								place : '#iif(isdefined("attributes.place") and len(attributes.place),"attributes.place",DE(""))#'

								)>
	<cf_workcube_process
		is_upd='1' 
		data_source='#dsn#'
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#'
		record_member='#session.ep.userid#'
		record_date='#now()#'
		action_table='CARE_STATES'
		action_column='CARE_ID'
		action_id='#attributes.care_id#'
		action_page='#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#attributes.care_id#'
		warning_description='Bakım Planı : #attributes.care_id#'>
  </cftransaction>
</cflock>

<cfif isdefined("attributes.failure_id") and len(attributes.failure_id)>
    <script>
        window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_asset_failure&event=upd&failure_id=#attributes.failure_id#</cfoutput>';
    </script>
<cfelse>
    <script>
        window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_assetp_period&event=upd&care_id=#attributes.care_id#</cfoutput>';
    </script>
</cfif>
