<cfset login_act = createObject("component", "V16.assetcare.cfc.failure")>
<cfset login_act.dsn = dsn />
<cfset get_asset_failure_list = login_act.GET_FAILURE_FNC( 
								official_emp_id : attributes.official_emp_id,    
                                official_emp : attributes.official_emp, 
                               service_code :  '#iif(isdefined("attributes.service_code") and len(attributes.service_code),"attributes.service_code",DE(""))#',
                                service_code_id : '#iif(isdefined("attributes.service_code_id") and len(attributes.service_code_id),"attributes.service_code_id",DE(""))#',
                                assetp_id : '#iif(isdefined("attributes.assetp_id") and len(attributes.assetp_id),"attributes.assetp_id",DE(""))#',
                                keyword : attributes.keyword, 
								branch_id : attributes.branch_id, 
                                station_id : attributes.station_id,
                                start_date : '#iif(isdefined("attributes.start_date") and len(attributes.start_date),"attributes.start_date",DE(""))#',
								finish_date : '#iif(isdefined("attributes.finish_date") and len(attributes.finish_date),"attributes.finish_date",DE(""))#',
								fuseaction : '#iif(isdefined("attributes.fuseaction") and len(attributes.fuseaction),"attributes.fuseaction",DE(""))#',
								asset_id : '#iif(isdefined("attributes.asset_id") and len(attributes.asset_id),"attributes.asset_id",DE(""))#',
								station_name : '#iif(isdefined("attributes.station_name") and len(attributes.station_name),"attributes.station_name",DE(""))#',
								asset_name : '#iif(isdefined("attributes.asset_name") and len(attributes.asset_name),"attributes.asset_name",DE(""))#',
                                process_stage : '#iif(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#'
								)>
