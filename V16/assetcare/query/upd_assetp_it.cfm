<cfif not isdefined("attributes.status")>
	<cfset attributes.status = 0>
</cfif>
<cfif isDefined('attributes.get_exit_date') and len(attributes.get_exit_date)><cf_date tarih='attributes.get_exit_date'></cfif>
<cf_date tarih='attributes.get_date'>

<cflock name="#createUUID()#" timeout="60">
	<cftransaction>		
		<cf_wrk_get_history datasource= "#dsn#" source_table="ASSET_P"  target_table= "ASSET_P_HISTORY" record_id="#attributes.assetp_id#"  record_name="ASSETP_ID">
		<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_it")>
			<cfset login_act.dsn = dsn />
			<cfset UPD_ASSETP = login_act.updAssetpItFnc( 
								assetp : attributes.assetp,    
                                get_date : attributes.get_date, 
                               	get_exit_date :  attributes.get_exit_date, 
                                assetp_id : attributes.assetp_id, 
                                old_property : attributes.old_property, 
                                employee_name : attributes.employee_name, 
								barcode : attributes.barcode, 
                                assetp_group : attributes.assetp_group,
                                inventory_number : attributes.inventory_number,
								sup_company_id : attributes.sup_company_id, 
								sup_partner_id : attributes.sup_partner_id, 
								sup_consumer_id : attributes.sup_consumer_id,
								assetp_catid : attributes.assetp_catid,
								assetp_sub_catid : '#iif(isdefined("attributes.assetp_sub_catid") and len(attributes.assetp_sub_catid),"attributes.assetp_sub_catid",DE(""))#',
								department_id : attributes.department_id,
								department_id2 : attributes.department_id2,
								position_code : attributes.position_code,
								company_partner_id : attributes.company_partner_id,
								brand_id : attributes.brand_id,
								brand_type_id : attributes.brand_type_id,
								brand_type_cat_id : attributes.brand_type_cat_id,
								assetp_detail : attributes.assetp_detail,
								make_year : attributes.make_year,
								is_collective_usage : '#iif(isdefined("attributes.is_collective_usage") and len(attributes.is_collective_usage),"attributes.is_collective_usage",DE(""))#',
								relation_asset_id : attributes.relation_asset_id,
								serial_number : attributes.serial_number,
								assetp_status : attributes.assetp_status,
								status : attributes.status,
								special_code : attributes.special_code,
								usage_purpose_id : attributes.usage_purpose_id,
								process_stage : attributes.process_stage,
								property : '#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
								position_code2 : attributes.position_code2,
								employee_id : attributes.employee_id,
								assetp_other_money : attributes.assetp_other_money,
								assetp_other_money_value : attributes.assetp_other_money_value,
								position2 : attributes.position2,
								emp_id : attributes.emp_id,
								member_type_2 : attributes.member_type_2,
								relation_asset : attributes.relation_asset,
								rent_amount : attributes.rent_amount,
								rent_payment_period : attributes.rent_payment_period,
								rent_start_date : attributes.rent_start_date,
								rent_finish_date : attributes.rent_finish_date,
								
								
								is_care_added : '#iif(isdefined("attributes.is_care_added") and len(attributes.is_care_added),"attributes.is_care_added",0)#',
								care_amount : attributes.care_amount,
								assetp_space_id:'#iif(isdefined("attributes.assetp_space_id") and len(attributes.assetp_space_id) and isdefined("attributes.assetp_space_name") and len(attributes.assetp_space_name),"attributes.assetp_space_id",DE(""))#',
								rent_amount_currency:attributes.rent_amount_currency,
							
								care_amount_currency:attributes.care_amount_currency)>
		<!---Ek Bilgiler--->
        <cfset attributes.info_id =  attributes.assetp_id>
        <cfset attributes.is_upd = 1>
        <cfset attributes.info_type_id = -19>
        <cfinclude template="../../objects/query/add_info_plus2.cfm">
        <!---Ek Bilgiler--->
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='ASSET_P'
			action_column='ASSETP_ID'
			action_id='#attributes.assetp_id#'
			action_page='#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#attributes.assetp_id#'
			warning_description='Varlık : #attributes.assetp#'>	
	</cftransaction>
</cflock>
<cfset attributes.actionId =attributes.assetp_id>
<script>
window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#attributes.assetp_id#</cfoutput>';
</script>
