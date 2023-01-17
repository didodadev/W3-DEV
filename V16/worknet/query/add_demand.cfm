<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)>
	<cf_date tarih="attributes.deliver_date">
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined('attributes.is_status')><cfset attributes.is_status = 1><cfelse><cfset attributes.is_status = 0></cfif>
		
		<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
		<cfset cmp.addDemand(
				is_status:attributes.is_status,
				company_id:attributes.company_id,
				partner_id:attributes.partner_id,
				company_name:attributes.company_name,
				product_category:attributes.product_category,
				demand_stage:attributes.process_stage,
				demand_head:trim(attributes.demand_head),
				demand_keyword:trim(attributes.demand_keyword),
				demand_type:attributes.demand_type,
				order_member_type:attributes.order_member_type,
				demand_detail:attributes.demand_detail,
				start_date:attributes.start_date,
				finish_date:attributes.finish_date,
				sector_cat_id:attributes.sector_cat_id,
				total_amount:attributes.total_amount,
				money:attributes.money,
				deliver_date:attributes.deliver_date,
				deliver_addres:trim(attributes.deliver_addres),
				paymethod:trim(attributes.paymethod),
				ship_method:trim(attributes.ship_method),
				quantity:attributes.quantity,
				colour:attributes.colour,
				demand_kind:attributes.demand_kind,
				project_id:attributes.project_id
			) />
			
		<cfquery name="GET_MAX_DEMAND" datasource="#DSN#">
			SELECT MAX(DEMAND_ID) AS DEMAND_ID FROM WORKNET_DEMAND
		</cfquery>
	</cftransaction>
</cflock>

<cfif isdefined('session.ep')>
	<cfset process_user_id = session.ep.userid>
<cfelseif  isdefined('session.pp')>
	<cfset process_user_id = session.pp.userid>
</cfif>

<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#process_user_id#' 
	record_date='#now()#' 
	action_table='WORKNET_DEMAND'
	action_column='DEMAND_ID'
	action_id='#GET_MAX_DEMAND.DEMAND_ID#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_demand&demand_id=#GET_MAX_DEMAND.DEMAND_ID#' 
	warning_description = 'Talep : #attributes.demand_head#'>

<cfif isdefined('attributes.type_') and attributes.type_ eq 1>
	<cflocation url="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#get_max_demand.demand_id#" addtoken="no">
<cfelse>
	<cflocation url="#request.self#?fuseaction=worknet.detail_demand&demand_id=#get_max_demand.demand_id#" addtoken="no">
</cfif>


