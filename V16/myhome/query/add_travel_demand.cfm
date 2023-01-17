<cfif isdefined('attributes.city') and len(attributes.city)>
	<cfset sehir = attributes.city>
<cfelseif isdefined('attributes.city_') and len(attributes.city_)>
	<cfset sehir = attributes.city_>
<cfelse>
	<cfset sehir= "" >
</cfif>
<cfif len(attributes.departure_date)>
    <cf_date tarih="attributes.departure_date">
</cfif>
<cfif len(attributes.departure_of_date)>
	<cf_date tarih="attributes.departure_of_date">
</cfif>
<cfif len(attributes.activity_start_date)>
	<cf_date tarih="attributes.activity_start_date">
</cfif>
<cfif len(attributes.activity_finish_date)>
	<cf_date tarih="attributes.activity_finish_date">		
</cfif>
<cfif len(attributes.flight_departure_date)>	
	<cf_date tarih="attributes.flight_departure_date">
</cfif>
<cfif len(attributes.flight_departure_of_date)>
	<cf_date tarih="attributes.flight_departure_of_date">
</cfif>
<cfscript>
	get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
	add_travel_demands = get_demands.add_travel_demand
					(
						paper_number : attributes.paper_number,
						emp_position_id : attributes.position_code,
						employee_id : attributes.employee_id,
						emp_department_id : attributes.emp_department_id,
						place : attributes.place,
						city : sehir,
						is_country:IIf(IsDefined("attributes.is_country"),'val(attributes.is_country)',DE(0)),
						travel_type : attributes.travel_type,
						project_id : attributes.project_id,
						is_top_title_limit:'#IIf(IsDefined("attributes.is_top_title_limit"),"attributes.is_top_title_limit",DE(0))#',
						top_title_id : attributes.top_title_id,
						task_causes : attributes.task_causes,
						departure_date : attributes.departure_date,
						departure_of_date : attributes.departure_of_date,
						fare : IIf(IsDefined("attributes.fare"),"attributes.fare",DE('')),
						fare_type : IIf(IsDefined("attributes.fare_type"),"attributes.fare_type",DE('')),
						task_detail : attributes.task_detail,
						activity_start_date : attributes.activity_start_date,
						activity_finish_date : attributes.activity_finish_date,
						activity_fare : IIf(IsDefined("attributes.activity_fare"),"attributes.activity_fare",DE('')),
						activity_fare_money_type : IIf(IsDefined("attributes.activity_fare_money_type"),"attributes.activity_fare_money_type",DE('')),
						activity_detail : attributes.activity_detail,
						flight_departure_date : attributes.flight_departure_date,
						flight_departure_of_date : attributes.flight_departure_of_date,
						airfare : IIf(IsDefined("attributes.airfare"),"attributes.airfare",DE('')),
						airfare_money_type :IIf(IsDefined("attributes.airfare_money_type"),"attributes.airfare_money_type",DE('')),
						flight_detail : attributes.flight_detail,
						travel_vehicle : attributes.travel_vehicle,
						activity_address : attributes.activity_address,
						activity_website : attributes.activity_website,
						is_vehicle_demand:'#IIf(IsDefined("attributes.is_vehicle_demand"),"attributes.is_vehicle_demand",DE(0))#',
						is_hotel_demand:'#IIf(IsDefined("attributes.is_hotel_demand"),"attributes.is_hotel_demand",DE(0))#',
						hotel_payment : attributes.hotel_payment,
						is_visa_requirement :'#IIf(IsDefined("attributes.is_visa_requirement"),"attributes.is_visa_requirement",DE(0))#',
						flight_class_demand : attributes.flight_class_demand,
						demand_cause : attributes.demand_cause,
						hotel_name : attributes.hotel_name,
						night_fare : IIf(IsDefined("attributes.night_fare"),"attributes.night_fare",DE('')),
						night_fare_money_type : IIf(IsDefined("attributes.night_fare_money_type"),"attributes.night_fare_money_type",DE('')),
						visa_fare : IIf(IsDefined("attributes.visa_fare"),"attributes.visa_fare",DE('')),
						visa_fare_money_type : IIf(IsDefined("attributes.visa_fare_money_type"),"attributes.visa_fare_money_type",DE('')),
						is_travel_advance_demand:'#IIf(IsDefined("attributes.is_travel_advance_demand"),"attributes.is_travel_advance_demand",DE(0))#',
						travel_advance_demand_fare : IIf(IsDefined("attributes.travel_advance_demand_fare"),"attributes.travel_advance_demand_fare",DE('')),
						travel_advance_demand_type : IIf(IsDefined("attributes.travel_advance_demand_type"),"attributes.travel_advance_demand_type",DE('')),
						is_hotel_advance_demand:'#IIf(IsDefined("attributes.is_hotel_advance_demand"),"attributes.is_hotel_advance_demand",DE(0))#',
						hotel_advance_demand_fare : IIf(IsDefined("attributes.hotel_advance_demand_fare"),"attributes.hotel_advance_demand_fare",DE('')),
						hotel_advance_demand_type : IIf(IsDefined("attributes.hotel_advance_demand_type"),"attributes.hotel_advance_demand_type",DE('')),
						is_departure_fee:'#IIf(IsDefined("attributes.is_departure_fee"),"attributes.is_departure_fee",DE(0))#',
						process_stage : attributes.process_stage

					);
</cfscript>
<cfset paper_number = listLast(attributes.paper_number,"-")>
<cfif len(paper_number)>
	<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS
		SET
			TRAVEL_DEMAND_NUMBER = #paper_number#
		WHERE
			TRAVEL_DEMAND_NUMBER IS NOT NULL
	</cfquery>
</cfif>
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
	<cfset attributes.demand_id= contentEncryptingandDecodingAES(isEncode:1,content:add_travel_demands.IDENTITYCOL,accountKey:'wrk')>
<cfelse>
	<cfset attributes.demand_id= add_travel_demands.IDENTITYCOL>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	old_process_stage='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEES_TRAVEL_DEMAND'
	action_column='TRAVEL_DEMAND_ID'
	action_id='#add_travel_demands.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_travel_demands&event=upd&TRAVEL_DEMAND_ID=#attributes.demand_id#' 
	warning_description='Seyahat Talebi: #attributes.demand_id#'>
<script type="text/javascript">
    window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_travel_demands&event=upd&TRAVEL_DEMAND_ID=#attributes.demand_id#</cfoutput>";
</script>
