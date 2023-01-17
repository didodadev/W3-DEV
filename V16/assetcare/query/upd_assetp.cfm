<cfif not isdefined("attributes.status")>
	<cfset attributes.status = 0>
</cfif>
<cfif len(attributes.get_exit_date)>
	<cf_date tarih='attributes.get_exit_date'>
</cfif>
<cfif len(attributes.transfer_date)>
	<cf_date tarih='attributes.transfer_date'>
</cfif>
<cf_date tarih='attributes.get_date'>
<!--- <cf_papers paper_type="FIXTURES"> --->
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>		
		<cf_wrk_get_history datasource= "#dsn#" source_table="ASSET_P" target_table= "ASSET_P_HISTORY" record_id="#attributes.assetp_id#"  record_name="ASSETP_ID">
		<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp")>
        <cfset login_act.dsn = dsn />
        <cfset updAssetp_init = login_act.init(
			attributes.assetp,
			attributes.barcode, 
			attributes.sup_company_id, 
			attributes.sup_partner_id, 
			attributes.sup_consumer_id,
			attributes.assetp_catid,
			'#iif(isdefined("attributes.assetp_sub_catid") and len(attributes.assetp_sub_catid),"attributes.assetp_sub_catid",DE(""))#',
			attributes.department_id,
			attributes.department_id2,
			attributes.position_code,
			attributes.company_partner_id,
			attributes.brand_id,
			attributes.brand_type_id,
			attributes.brand_type_cat_id,
			attributes.assetp_detail,
			'#iif(isdefined("attributes.physical_assets_width") and len(attributes.physical_assets_width),"attributes.physical_assets_width",DE(""))#',
			'#iif(isdefined("attributes.physical_assets_height") and len(attributes.physical_assets_height),"attributes.physical_assets_height",DE(""))#',
			'#iif(isdefined("attributes.physical_assets_size") and len(attributes.physical_assets_size),"attributes.physical_assets_size",DE(""))#',
			attributes.make_year,
			'#iif(isdefined("attributes.company_relation_id") and len(attributes.company_relation_id),"attributes.company_relation_id",DE(""))#',
			'#iif(isdefined("attributes.is_collective_usage") and len(attributes.is_collective_usage),"attributes.is_collective_usage",DE(""))#',
			attributes.relation_asset_id,
			attributes.serial_number,
			attributes.assetp_status,
			attributes.special_code,
			attributes.usage_purpose_id,
			attributes.process_stage,
			'#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
			attributes.position_code2,
			attributes.fixtures_no,
			attributes.fixtures_id,
			attributes.employee_id,
			attributes.assetp_other_money,
			attributes.assetp_other_money_value,
			attributes.position2,
			attributes.emp_id,
			attributes.member_type_2,
			attributes.relation_asset)>
                                
		<cfset updAssetp_initAssetp = updAssetp_init.updAssetpFnc(
			attributes.assetp_group,
			'#iif(isdefined("attributes.rent_start_date") and len(attributes.rent_start_date),"attributes.rent_start_date",DE(""))#',
			attributes.employee_name,
			attributes.get_date,
			attributes.get_exit_date,
			attributes.transfer_date,
			attributes.assetp_id,
			attributes.old_property,
			attributes.status,
			'#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
			'#iif(isdefined("attributes.rent_amount") and len(attributes.rent_amount),"attributes.rent_amount",DE(""))#',
			'#iif(isdefined("attributes.rent_amount_currency") and len(attributes.rent_amount_currency),"attributes.rent_amount_currency",DE(""))#',
			'#iif(isdefined("attributes.rent_payment_period") and len(attributes.rent_payment_period),"attributes.rent_payment_period",DE(""))#',
			'#iif(isdefined("attributes.rent_finish_date") and len(attributes.rent_finish_date),"attributes.rent_finish_date",DE(""))#',
			'#iif(isdefined("attributes.is_fuel_added") and len(attributes.is_fuel_added),"attributes.is_fuel_added",DE(""))#',
			'#iif(isdefined("attributes.fuel_amount") and len(attributes.fuel_amount),"attributes.fuel_amount",DE(""))#',
			'#iif(isdefined("attributes.fuel_amount_currency") and len(attributes.fuel_amount_currency),"attributes.fuel_amount_currency",DE(""))#',
			'#iif(isdefined("attributes.is_care_added") and len(attributes.is_care_added),"attributes.is_care_added",DE(""))#',
			'#iif(isdefined("attributes.care_amount") and len(attributes.care_amount),"attributes.care_amount",DE(""))#',
			'#iif(isdefined("attributes.assetp_space_id") and len(attributes.assetp_space_id) and isdefined("attributes.assetp_space_name") and len(attributes.assetp_space_name),"attributes.assetp_space_id",DE(""))#',
			'#iif(isdefined("attributes.care_amount_currency") and len(attributes.care_amount_currency),"attributes.care_amount_currency",DE(""))#',
            attributes.coordinate_1,
			attributes.coordinate_2
        )>
        <!---Ek Bilgiler--->
		<cfset attributes.info_id =  attributes.assetp_id>
        <cfset attributes.is_upd = 1>
        <cfset attributes.info_type_id = -13>
        <cfinclude template="../../objects/query/add_info_plus2.cfm">
        <!---Ek Bilgiler--->
	<cfset attributes.actionid=attributes.assetp_id>
		 <cf_workcube_process 
			is_upd='1' 
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='ASSET_P'
			action_column='ASSETP_ID'
			action_id='#attributes.assetp_id#'
			action_page='#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#attributes.assetp_id#'
			warning_description='Varlık : #attributes.assetp#'> 
	</cftransaction>
</cflock>
<cfif not isdefined('attributes._type_')>
	<script>
		window.location.href="<cfoutput>#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#attributes.assetp_id#</cfoutput>";
	</script>
<cfelse>
	<script>
		window.location.href="<cfoutput>#request.self#?fuseaction=call.form_upd_member_assetp&assetp_id=#attributes.assetp_id#</cfoutput>";
	</script>
</cfif>