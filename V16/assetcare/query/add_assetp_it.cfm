<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_start_date'></cfif>
<cfif len(attributes.rent_finish_date)><cf_date tarih='attributes.rent_finish_date'></cfif>
<cflock timeout="60">
	<cftransaction>
			<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_it")>
                        <cfset login_act.dsn = dsn />
                        <cfset addAssetpIt_init = login_act.addAssetpItFnc(
                                   		assetp : attributes.assetp,
										barcode : attributes.barcode,
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
										physical_assets_width : '#iif(isdefined("attributes.physical_assets_width") and len(attributes.physical_assets_width),"attributes.physical_assets_width",DE(""))#',
										physical_assets_height : '#iif(isdefined("attributes.physical_assets_height") and len(attributes.physical_assets_height),"attributes.physical_assets_height",DE(""))#',
										physical_assets_size : '#iif(isdefined("attributes.physical_assets_size") and len(attributes.physical_assets_size),"attributes.physical_assets_size",DE(""))#',
										make_year : attributes.make_year,
										company_relation_id : '#iif(isdefined("attributes.company_relation_id") and len(attributes.company_relation_id),"attributes.company_relation_id",DE(""))#',
										is_collective_usage : '#iif(isdefined("attributes.is_collective_usage") and len(attributes.is_collective_usage),"attributes.is_collective_usage",DE(""))#',
										relation_asset_id : attributes.relation_asset_id,
										serial_number : attributes.serial_number,
										status : '#iif(isdefined("attributes.status") and len(attributes.status),"attributes.status",DE(""))#',
										assetp_status : attributes.assetp_status,
										special_code : attributes.special_code,
										usage_purpose_id : attributes.usage_purpose_id,
										process_stage : attributes.process_stage,
										property : '#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
										position_code2 : attributes.position_code2,
										employee_name : attributes.employee_name,
										
										employee_id : attributes.employee_id,
										assetp_other_money : attributes.assetp_other_money,
										assetp_other_money_value : attributes.assetp_other_money_value,
										position2 : attributes.position2,
										emp_id : attributes.emp_id,
										member_type_2 : attributes.member_type_2,
										relation_asset : attributes.relation_asset,
										rent_amount : attributes.rent_amount, 
										rent_amount_currency : attributes.rent_amount_currency,
										rent_payment_period : attributes.rent_payment_period,
										rent_finish_date : attributes.rent_finish_date,
										
										
										
										is_care_added : '#iif(isdefined("attributes.is_care_added") and len(attributes.is_care_added),"attributes.is_care_added",0)#',
										care_amount : attributes.care_amount,
										care_amount_currency : attributes.care_amount_currency,
										assetp_group : attributes.assetp_group,
										start_date : attributes.start_date,
										rent_start_date : attributes.rent_start_date,
										assetp_space_id:'#iif(isdefined("attributes.assetp_space_id") and len(attributes.assetp_space_id),"attributes.assetp_space_id",DE(""))#'
										
                                    )> 
									<cfset paper_number = listLast(attributes.inventory_number,"-")>
									<cfif len(paper_number)>
										<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN#">
											UPDATE 
														GENERAL_PAPERS_MAIN
													SET
													FIXTURES_NUMBER = #paper_number#
													WHERE
													FIXTURES_NUMBER IS NOT NULL
										</cfquery>
									</cfif>
<!---		<cfquery name="GET_LAST_ASSET_ID" datasource="#DSN#">
			SELECT MAX(ASSETP_ID) AS ASSET_ID FROM ASSET_P
		</cfquery>--->
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='ASSET_P'
			action_column='ASSETP_ID'
			action_id='#addAssetpIt_init#'
			action_page='#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#addAssetpIt_init#'
			warning_description='Varlık : #attributes.assetp#'>	
	</cftransaction>
</cflock>
<cfset attributes.actionId = addAssetpIt_init>
<script>
window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_asset_it&event=upd&assetp_id=#addAssetpIt_init#</cfoutput>';
</script>
