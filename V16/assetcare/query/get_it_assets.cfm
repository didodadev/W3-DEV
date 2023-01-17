<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_it")>
<cfset login_act.dsn = dsn />
<cfset get_asset_it = login_act.GET_ASSETP_IT_FNC( 	
							keyword : attributes.keyword,
							it_assept:'#iif(isdefined("attributes.it_assept") and len(attributes.it_assept) and attributes.it_assept eq 1,"attributes.it_assept",DE("0"))#',
							is_active : attributes.is_active,
							is_collective_usage : '#iif(isdefined("attributes.is_collective_usage") and len(attributes.is_collective_usage),"attributes.is_collective_usage",DE(""))#',
							assetp_status : '#iif(isdefined("attributes.assetp_status") and len(attributes.assetp_status),"attributes.assetp_status",DE(""))#',
							assetp_catid : attributes.assetp_catid,
							assetp_sub_catid : '#iif(isdefined("attributes.assetp_sub_catid") and len(attributes.assetp_sub_catid),"attributes.assetp_sub_catid",DE(""))#',
							brand_name : attributes.brand_name,
							brand_type_cat_id : attributes.brand_type_cat_id,
							emp_id : attributes.emp_id,
							employee_name : attributes.employee_name,
							make_year : attributes.make_year,
							property : '#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
							branch : attributes.branch,
							branch_id : attributes.branch_id,
							department : attributes.department,
							department_id : attributes.department_id,
							sup_company_id : attributes.sup_company_id,
							sup_partner_id : attributes.sup_partner_id,
							sup_consumer_id : attributes.sup_consumer_id,
							company_id : attributes.company_id,
							asset_p_space_id:'#iif(isdefined("attributes.asset_p_space_id") and len(attributes.asset_p_space_id),"attributes.asset_p_space_id",DE(""))#',
							asset_p_space_name:'#iif(isdefined("attributes.asset_p_space_name") and len(attributes.asset_p_space_name),"attributes.asset_p_space_name",DE(""))#',
							serial_number : attributes.serial_number                                
							)>