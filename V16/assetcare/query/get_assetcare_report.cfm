<cfif len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_care_calender")>
<cfset login_act.dsn = dsn />
<cfset GET_ASSETCARE_REPORT = login_act.GET_ASSETP_CARE_RESULT_FNC( 
								station_id : '#iif(isdefined("attributes.station_id") and len(attributes.station_id),"attributes.station_id",DE(""))#',   
                                station_name : '#iif(isdefined("attributes.station_name") and len(attributes.station_name),"attributes.station_name",DE(""))#',
                               	asset_id :  '#iif(isdefined("attributes.asset_id") and len(attributes.asset_id),"attributes.asset_id",DE(""))#',
                                asset_name : '#iif(isdefined("attributes.asset_name") and len(attributes.asset_name),"attributes.asset_name",DE(""))#',
                                assetpcatid : '#iif(isdefined("attributes.assetpcatid") and len(attributes.assetpcatid),"attributes.assetpcatid",DE(""))#',
                                branch : '#iif(isdefined("attributes.branch") and len(attributes.branch),"attributes.branch",DE(""))#',
								branch_id : '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
                                keyword : '#iif(isdefined("attributes.keyword") and len(attributes.keyword),"attributes.keyword",DE(""))#',
                                start_date : '#iif(isdefined("attributes.start_date") and len(attributes.start_date),"attributes.start_date",DE(""))#',
								finish_date : '#iif(isdefined("attributes.finish_date") and len(attributes.finish_date),"attributes.finish_date",DE(""))#',
								asset_cat : '#iif(isdefined("attributes.asset_cat") and len(attributes.asset_cat),"attributes.asset_cat",DE(""))#',
								startdate : '#iif(isdefined("attributes.startdate") and len(attributes.startdate),"attributes.startdate",DE(""))#',
								finishdate : '#iif(isdefined("attributes.finishdate") and len(attributes.finishdate),"attributes.finishdate",DE(""))#',
								date_format : '#iif(isdefined("attributes.date_format") and len(attributes.date_format),"attributes.date_format",DE(""))#'
								)>

