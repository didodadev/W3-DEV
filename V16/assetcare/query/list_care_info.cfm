<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_period")>
<cfset login_act.dsn = dsn />
<cfset GET_WORK_ASSET_CARE = login_act.GET_ASSETP_PERIOD_FNC( 
								assetp_id : '#iif(isdefined("attributes.assetp_id") and len(attributes.assetp_id),"attributes.assetp_id",DE(""))#',
                                keyword : '#iif(isdefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',
								station_name : '#iif(isdefined("attributes.station_name") and len(attributes.station_name),"attributes.station_name",DE(""))#',
								asset_name : '#iif(isdefined("attributes.asset_name") and len(attributes.asset_name),"attributes.asset_name",DE(""))#',
                               asset_cat :  '#iif(isdefined("attributes.asset_cat") and len(attributes.asset_cat),"attributes.asset_cat",DE(""))#',
							    branch : '#iif(isdefined("attributes.branch") and len(attributes.branch),"attributes.branch",DE(""))#',
								department_id : '#iif(isdefined("attributes.department_id") and len(attributes.department_id),"attributes.department_id",DE(""))#',
								place : '#iif(isdefined("attributes.place") and len(attributes.place),"attributes.place",DE(""))#',
                                branch_id : '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
                                asset_id : '#iif(isdefined("attributes.asset_id") and len(attributes.asset_id),"attributes.asset_id",DE(""))#',
                                station_id : '#iif(isdefined("attributes.station_id") and len(attributes.station_id),"attributes.station_id",DE(""))#',
								department : '#iif(isdefined("attributes.department") and len(attributes.department),"attributes.department",DE(""))#',
                                official_emp_id : '#iif(isdefined("attributes.official_emp_id") and len(attributes.official_emp_id),"attributes.official_emp_id",DE(""))#',
                                official_emp : '#iif(isdefined("attributes.official_emp") and len(attributes.official_emp),"attributes.official_emp",DE(""))#',
								start_date : '#iif(isdefined("attributes.start_date") and len(attributes.start_date),"attributes.start_date",DE(""))#',
								finish_date : '#iif(isdefined("attributes.finish_date") and len(attributes.finish_date),"attributes.finish_date",DE(""))#',
								period : '#iif(isdefined("attributes.period") and len(attributes.period),"attributes.period",DE(""))#',
								ord_by : '#iif(isdefined("attributes.ord_by") and len(attributes.ord_by),"attributes.ord_by",DE(""))#'								
								)>
