<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_vehicle1")>
<cfset login_act.dsn = dsn />
<cfset get_vehicles = login_act.GET_ASSETP_FNC(
								assetp_id : attributes.assetp_id,
								assetp:attributes.assetp,
								is_active : attributes.is_active, 
								is_collective_usage : attributes.is_collective_usage, 
								assetp_catid : attributes.assetp_catid, 
								assetp_sub_catid : attributes.assetp_sub_catid,
								brand_name : attributes.brand_name,
								brand_type_id : attributes.brand_type_id,
								emp_id : attributes.emp_id,
								employee_name : attributes.employee_name,
								keyword : attributes.keyword,
								make_year : attributes.make_year,
								property : attributes.property,
								branch : attributes.branch,
								branch_id : attributes.branch_id,
								position_cat_id : attributes.position_cat_id,
								department : attributes.department,
								department_id : attributes.department_id,
								sup_company_id : attributes.sup_company_id,
								sup_partner_id : attributes.sup_partner_id,
								sup_consumer_id : attributes.sup_consumer_id,
								company_id : attributes.company_id
	)>

