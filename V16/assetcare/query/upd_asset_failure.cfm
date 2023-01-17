<cfif isdefined("attributes.failure_date") and len(attributes.failure_date)>
	<cf_date tarih="attributes.failure_date">
	<cfif len(attributes.finish_clock)><cfset attributes.failure_date=date_add("H", attributes.finish_clock, attributes.failure_date)></cfif>
    <cfif len(attributes.finish_minute)><cfset attributes.failure_date=date_add("N",attributes.finish_minute,attributes.failure_date)></cfif>
</cfif>
<cfset login_act = createObject("component", "V16.assetcare.cfc.failure")>
<cfset login_act.dsn = dsn />
<cfset upd_asset_failure1 = login_act.UPD_FAILURE_FNC(
								failure_emp_id : '#iif(isdefined("attributes.failure_emp_id") and len(attributes.failure_emp_id),"attributes.failure_emp_id",DE(""))#',
								process_stage : '#iif(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#',
                                failure_emp : '#iif(isdefined("attributes.failure_emp") and len(attributes.failure_emp),"attributes.failure_emp",DE(""))#', 
                               failure_date :  '#iif(isdefined("attributes.failure_date") and len(attributes.failure_date),"attributes.failure_date",DE(""))#', 
                                care_type_id : '#iif(isdefined("attributes.care_type_id") and len(attributes.care_type_id),"attributes.care_type_id",DE(""))#',
                                care_type : '#iif(isdefined("attributes.care_type") and len(attributes.care_type),"attributes.care_type",DE(""))#', 
                                assetp_id : '#iif(isdefined("attributes.assetp_id") and len(attributes.assetp_id),"attributes.assetp_id",DE(""))#', 							
								station_id : '#iif(isdefined("attributes.station_id") and len(attributes.station_id),"attributes.station_id",DE(""))#',							
								station_name : '#iif(isdefined("attributes.station_name") and len(attributes.station_name),"attributes.station_name",DE(""))#',
                                subject : '#iif(isdefined("attributes.subject") and len(attributes.subject),"attributes.subject",DE(""))#',  
                                send_to_id : '#iif(isdefined("attributes.send_to_id") and len(attributes.send_to_id),"attributes.send_to_id",DE(""))#', 
                               project_id : '#iif(isdefined("attributes.project_id") and len(attributes.project_id),"attributes.project_id",DE(""))#', 
                                project_head : '#iif(isdefined("attributes.project_head") and len(attributes.project_head),"attributes.project_head",DE(""))#', 
                                document_no : '#iif(isdefined("attributes.document_no") and len(attributes.document_no),"attributes.document_no",DE(""))#',
								head : '#iif(isdefined("attributes.failure_head") and len(attributes.failure_head),"attributes.failure_head",DE(""))#',
								failure_id : '#iif(isdefined("attributes.failure_id") and len(attributes.failure_id),"attributes.failure_id",DE(""))#',							
								failure_code : '#iif(isdefined("attributes.failure_code") and len(attributes.failure_code),"attributes.failure_code",DE(""))#'
						 )>
<cf_wrk_get_history datasource= "#dsn#" source_table="ASSET_FAILURE_NOTICE"  target_table= "ASSET_FAILURE_NOTICE_HISTORY" record_id="#attributes.failure_id#" insert_into_column_name="DETAIL,RECORD_EMP,RECORD_IP,RECORD_DATE,FAILURE_STAGE,FAILURE_ID,NOTICE_HEAD" insert_into_column_value="'#attributes.subject#',#session.ep.userid#,#cgi.remote_addr#,#now()#,#attributes.process_stage#,#attributes.failure_id#,'#attributes.failure_head#'" record_name="FAILURE_ID">

<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='ASSET_FAILURE_NOTICE'
	action_column='FAILURE_ID'
	action_id='#attributes.failure_id#' 
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd&failure_id=#attributes.failure_id#'
	warning_description="#getLang('assetcare',4)# : #attributes.failure_id#">
<cfset attributes.actionid=attributes.failure_id>
<script>
        window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_asset_failure&event=upd&failure_id=#attributes.failure_id#</cfoutput>';
</script>
