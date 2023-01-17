<!---<cfdump var="#attributes#"><cfabort>--->
<cfset attributes.assetp = Replace(attributes.assetp,".","","all")>
<cfset attributes.assetp = UCase(Replace(attributes.assetp," ","","all"))>
<cfif not isdefined("attributes.is_submitted")>
	<cfquery name="GET_ASSETP_CONTROL1" datasource="#dsn#">
		SELECT
			ASSETP,
			SUP_COMPANY_DATE,
			EXIT_DATE
		FROM
			ASSET_P
		WHERE
			ASSETP = '#trim(attributes.assetp)#'
	</cfquery>
<cfelse>
	<cfset get_assetp_control1.recordCount = 0>
</cfif>
<cfif (get_assetp_control1.recordcount) and (not isdefined("attributes.is_submitted"))>
		<script type="text/javascript">
			alert("<cf_get_lang no ='756.Bu Plaka Sistemde Kayıtlıdır'> !");
			//history.back();
			location.reload();
		</script>
	<cfabort>
<cfelse>
	<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
	<cfif len(attributes.first_date_km)><cf_date tarih='attributes.first_date_km'></cfif>
	<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_start_date'></cfif>
	<cfif len(attributes.rent_finish_date)><cf_date tarih='attributes.rent_finish_date'></cfif>
	<cflock timeout="60">
		<cftransaction>
			<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_vehicle1")>
		<cfset login_act.dsn = dsn />
		<cfset addAssetpVehicle_init = login_act.addAssetpVehicleFnc(
					property : '#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
					inventory_number : attributes.inventory_number,
					assetp : attributes.assetp,
					sup_company_id : attributes.sup_company_id,
					sup_partner_id : attributes.sup_partner_id,
					sup_consumer_id : attributes.sup_consumer_id,
					assetp_catid : attributes.assetp_catid,
					assetp_sub_catid : '#iif(isdefined("attributes.assetp_sub_catid") and len(attributes.assetp_sub_catid),"attributes.assetp_sub_catid",DE(""))#',
					department_id : attributes.department_id,
					department_id2 : attributes.department_id2,
					emp_id : '#iif(isdefined("attributes.emp_id") and len(attributes.emp_id),"attributes.emp_id",DE(""))#',					
					position_code : attributes.position_code,
					member_type : '#iif(isdefined("attributes.member_type") and len(attributes.member_type),"attributes.member_type",DE(""))#',					
					position_code2 : attributes.position_code2,
					member_type_2 : attributes.member_type_2,
					start_date : attributes.start_date,
					first_date_km : attributes.first_date_km,
					first_km : attributes.first_km,
					fuel_type : attributes.fuel_type,
					status : attributes.status,
					usage_purpose_id : attributes.usage_purpose_id,
					assetp_group : attributes.assetp_group,
					brand_id : attributes.brand_id,
					brand_type_id : attributes.brand_type_id,
					brand_type_cat_id : attributes.brand_type_cat_id,									
					make_year : attributes.make_year,
					assetp_detail : attributes.assetp_detail,					
					is_collective_usage : '#iif(isdefined("attributes.is_collective_usage") and len(attributes.is_collective_usage),"attributes.is_collective_usage",DE(""))#',
					assetp_other_money : attributes.assetp_other_money,
					assetp_other_money_value : attributes.assetp_other_money_value,
					asset_vehicle_width : '#iif(isdefined("attributes.asset_vehicle_width") and len(attributes.asset_vehicle_width),"attributes.asset_vehicle_width",DE(""))#',
					asset_vehicle_size : '#iif(isdefined("attributes.asset_vehicle_size") and len(attributes.asset_vehicle_size),"attributes.asset_vehicle_size",DE(""))#',
					asset_vehicle_height : '#iif(isdefined("attributes.asset_vehicle_height") and len(attributes.asset_vehicle_height),"attributes.asset_vehicle_height",DE(""))#',
					process_stage : attributes.process_stage,					
                    relation_asset_id : attributes.relation_asset_id,
					rent_amount : attributes.rent_amount, 
					rent_amount_currency : attributes.rent_amount_currency,
					rent_payment_period : attributes.rent_payment_period,
					rent_start_date : attributes.rent_start_date,
					rent_finish_date : attributes.rent_finish_date,
					is_fuel_added : attributes.is_fuel_added,
					fuel_amount : attributes.fuel_amount,
					fuel_amount_currency : attributes.fuel_amount_currency,															
					is_care_added : attributes.is_care_added,
					care_amount : attributes.care_amount,
					care_amount_currency : attributes.care_amount_currency,
					contract_head : '#iif(isdefined("attributes.contract_head") and len(attributes.contract_head),"attributes.contract_head",DE(""))#',
					company_id : '#iif(isdefined("attributes.company_id") and len(attributes.company_id),"attributes.company_id",DE(""))#',
					support_company_id : '#iif(isdefined("attributes.support_company_id") and len(attributes.support_company_id),"attributes.support_company_id",DE(""))#',
					authorized_id : '#iif(isdefined("attributes.authorized_id") and len(attributes.authorized_id),"attributes.authorized_id",DE(""))#',
					support_authorized_id : '#iif(isdefined("attributes.support_authorized_id") and len(attributes.support_authorized_id),"attributes.support_authorized_id",DE(""))#',
					support_position_id : '#iif(isdefined("attributes.support_position_id") and len(attributes.support_position_id),"attributes.support_position_id",DE(""))#',
					support_position_name : '#iif(isdefined("attributes.support_position_name") and len(attributes.support_position_name),"attributes.support_position_name",DE(""))#',
					support_start_date : '#iif(isdefined("attributes.support_start_date") and len(attributes.support_start_date),"attributes.support_start_date",DE(""))#',
					support_finish_date : '#iif(isdefined("attributes.support_finish_date") and len(attributes.support_finish_date),"attributes.support_finish_date",DE(""))#',
					project_id : '#iif(isdefined("attributes.project_id") and len(attributes.project_id),"attributes.project_id",DE(""))#',
					project_head : '#iif(isdefined("attributes.project_head") and len(attributes.project_head),"attributes.project_head",DE(""))#',
					support_cat : '#iif(isdefined("attributes.support_cat") and len(attributes.support_cat),"attributes.support_cat",DE(""))#',
					detail : '#iif(isdefined("attributes.detail") and len(attributes.detail),"attributes.detail",DE(""))#'
					
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
			<cf_workcube_process 
				is_upd='1' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='ASSET_P'
				action_column='ASSETP_ID'
				action_id='#addAssetpVehicle_init#'
				action_page='#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#addAssetpVehicle_init#'
				warning_description='Varlık : #attributes.assetp#'>	
		</cftransaction>
	</cflock>
	<script>
		window.location.href="<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#addAssetpVehicle_init#</cfoutput>";
	</script>
</cfif>

