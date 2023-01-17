<!---<cfdump var="#attributes#"><cfabort>--->
<cfif not isdefined("attributes.status")>
	<cfset attributes.status = 0>
</cfif>
<cfset attributes.assetp = Replace(attributes.assetp,".","","all")>
<cfset attributes.assetp = UCase(Replace(attributes.assetp," ","","all"))>
<cfif attributes.old_assetp neq attributes.assetp>
	<cfquery name="get_assetp" datasource="#dsn#">
		SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID <> #attributes.assetp_id# AND ASSETP = '#trim(attributes.assetp)#' 
	</cfquery>
	<cfif get_assetp.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='756.Bu Plaka Sistemde Kayıtlıdır'> !");
			history.back();
		</script>
	<cfabort>
	</cfif>
</cfif>

<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfif len(attributes.get_date)><cf_date tarih='attributes.get_date'></cfif>
		<cfif len(attributes.get_exit_date)><cf_date tarih='attributes.get_exit_date'></cfif>
		<cfif len(attributes.km_date_first)><cf_date tarih='attributes.km_date_first'></cfif>	
		
		<cfif 	(attributes.old_department_id neq attributes.department_id) or 
				(isdefined('attributes.department_id2') and attributes.old_department_id2 neq attributes.department_id2) or 
				(attributes.old_position_code neq attributes.position_code) or 
				(attributes.old_status neq attributes.status) or 
				(attributes.old_assetp neq attributes.assetp) or 
				(attributes.old_property neq attributes.property)>
                <cfquery name="add_asset_p_history" datasource="#dsn#">
					INSERT INTO
						ASSET_P_HISTORY
					(
						ASSETP_ID,
						ASSETP,
						PROPERTY,
						DEPARTMENT_ID,
						DEPARTMENT_ID2,
						POSITION_CODE,
						STATUS,
						IS_SALES,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#attributes.assetp_id#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.assetp)#">,
						#attributes.property#,	
						#attributes.department_id#,
						<cfif isDefined("attributes.department_id2") and len(attributes.department_id2)>#attributes.department_id2#<cfelseif len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.status") and attributes.status eq 1 and len(attributes.position_code)>#attributes.position_code#<cfelse>NULL</cfif>,
						#attributes.status#,
						0,
						#now()#,
						#session.ep.userid#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					)
				</cfquery>
		</cfif>
						<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_vehicle1")>
                        <cfset login_act.dsn = dsn />
                        <cfset update_asset_p = login_act.updAssetpFnc(
                                    property : '#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
                                    inventory_number : attributes.inventory_number,
                                    assetp : attributes.assetp,
                                    sup_company_id : attributes.sup_company_id,
                                    sup_partner_id : attributes.sup_partner_id,
                                    sup_consumer_id : attributes.sup_consumer_id,
									assetp_status : '#iif(isdefined("attributes.assetp_status") and len(attributes.assetp_status),"attributes.assetp_status",DE(""))#',
                                    assetp_catid : attributes.assetp_catid,
                                    assetp_sub_catid : '#iif(isdefined("attributes.assetp_sub_catid") and len(attributes.assetp_sub_catid),"attributes.assetp_sub_catid",DE(""))#',
                                    department_id : attributes.department_id,
                                    department_id2 : attributes.department_id2,
                                    emp_id : '#iif(isdefined("attributes.emp_id") and len(attributes.emp_id),"attributes.emp_id",DE(""))#',					
                                    position_code : attributes.position_code,
                                    member_type : '#iif(isdefined("attributes.member_type") and len(attributes.member_type),"attributes.member_type",DE(""))#',					
                                    position_code2 : attributes.position_code2,
                                    member_type_2 : '#iif(isdefined("attributes.member_type_2") and len(attributes.member_type_2),"attributes.member_type_2",DE(""))#',
									start_date : '#iif(isdefined("attributes.start_date") and len(attributes.start_date),"attributes.start_date",DE(""))#',
                                    first_date_km : '#iif(isdefined("attributes.first_date_km") and len(attributes.first_date_km),"attributes.first_date_km",DE(""))#',
									o_first_km : attributes.o_first_km,
									first_km : attributes.first_km,
                                    fuel_type : attributes.fuel_type,
                                    status : attributes.status,
                                    usage_purpose_id : '#iif(isdefined("attributes.usage_purpose_id") and len(attributes.usage_purpose_id),"attributes.usage_purpose_id",DE(""))#',
                                    assetp_group : '#iif(isdefined("attributes.assetp_group") and len(attributes.assetp_group),"attributes.assetp_group",DE(""))#',
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
									rent_amount : '#iif(isdefined("attributes.rent_amount") and len(attributes.rent_amount),"attributes.rent_amount",DE(""))#',
									rent_amount_currency : '#iif(isdefined("attributes.rent_amount_currency") and len(attributes.rent_amount_currency),"attributes.rent_amount_currency",DE(""))#',
									rent_payment_period : '#iif(isdefined("attributes.rent_payment_period") and len(attributes.rent_payment_period),"attributes.rent_payment_period",DE(""))#',
									rent_start_date : '#iif(isdefined("attributes.rent_start_date") and len(attributes.rent_start_date),"attributes.rent_start_date",DE(""))#',
									rent_finish_date : '#iif(isdefined("attributes.rent_finish_date") and len(attributes.rent_finish_date),"attributes.rent_finish_date",DE(""))#',
									is_fuel_added : '#iif(isdefined("attributes.is_fuel_added") and len(attributes.is_fuel_added),"attributes.is_fuel_added",DE(""))#',
									fuel_amount : '#iif(isdefined("attributes.fuel_amount") and len(attributes.fuel_amount),"attributes.fuel_amount",DE(""))#',
									fuel_amount_currency : '#iif(isdefined("attributes.fuel_amount_currency") and len(attributes.fuel_amount_currency),"attributes.fuel_amount_currency",DE(""))#',															
									is_care_added : '#iif(isdefined("attributes.is_care_added") and len(attributes.is_care_added),"attributes.is_care_added",DE(""))#',
									care_amount : '#iif(isdefined("attributes.care_amount") and len(attributes.care_amount),"attributes.care_amount",DE(""))#',
									care_amount_currency : '#iif(isdefined("attributes.care_amount_currency") and len(attributes.care_amount_currency),"attributes.care_amount_currency",DE(""))#',
									care_warning_day : '#iif(isdefined("attributes.care_warning_day") and len(attributes.care_warning_day),"attributes.care_warning_day",DE(""))#',
									get_date : '#iif(isdefined("attributes.get_date") and len(attributes.get_date),"attributes.get_date",DE(""))#', 
									get_exit_date : '#iif(isdefined("attributes.get_exit_date") and len(attributes.get_exit_date),"attributes.get_exit_date",DE(""))#',
									km_date_first : '#iif(isdefined("attributes.km_date_first") and len(attributes.km_date_first),"attributes.km_date_first",DE(""))#',
									new_assetp_group : '#iif(isdefined("attributes.new_assetp_group") and len(attributes.new_assetp_group),"attributes.new_assetp_group",DE(""))#',
									option_km : '#iif(isdefined("attributes.option_km") and len(attributes.option_km),"attributes.option_km",DE(""))#',
									new_usage_purpose_id : '#iif(isdefined("attributes.new_usage_purpose_id") and len(attributes.new_usage_purpose_id),"attributes.new_usage_purpose_id",DE(""))#',
									ozel_kod : '#iif(isdefined("attributes.ozel_kod") and len(attributes.ozel_kod),"attributes.ozel_kod",DE(""))#',
									old_property : '#iif(isdefined("attributes.old_property") and len(attributes.old_property),"attributes.old_property",DE(""))#',
									assetp_id : '#iif(isdefined("attributes.assetp_id") and len(attributes.assetp_id),"attributes.assetp_id",DE(""))#',
									old_first_km_date : attributes.old_first_km_date,
									position_name2 : attributes.position_name2,
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
				<cf_workcube_process 
			is_upd='1' 
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='ASSET_P'
			action_column='ASSETP_ID'
			action_id='#attributes.assetp_id#'
			action_page='#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#attributes.assetp_id#'
			warning_description='Varlık : #attributes.assetp#'>	
	</cftransaction>
</cflock>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.assetp_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -20>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<script>
window.location.href="<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=upd&assetp_id=#attributes.assetp_id#</cfoutput>";
</script>

