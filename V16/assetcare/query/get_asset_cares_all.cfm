<cfif isdefined("yearly_report_parameters")>
	<cfset bu_sene=dateformat(now(),'yyyy')>
	<cfif len(attributes.month_id)>
		<cfif isdefined("attributes.yil_src") and len(attributes.yil_src)>
			<cfset attributes.startdate="01/#numberformat(attributes.month_id,'00')#/#attributes.yil_src#">
			<cfset attributes.finishdate="#DaysInMonth(createdate(attributes.yil_src,attributes.month_id,1))#/#numberformat(attributes.month_id,'00')#/#attributes.yil_src#">
		<cfelse>
			<cfset attributes.startdate="01/#numberformat(attributes.month_id,'00')#/#bu_sene#">
			<cfset attributes.finishdate="#DaysInMonth(createdate(bu_sene,attributes.month_id,1))#/#numberformat(attributes.month_id,'00')#/#bu_sene#">
		</cfif>
	<cfelse>
	<cfif isdefined("attributes.yil_src") and len(attributes.yil_src)>
		<cfset attributes.startdate="01/01/#attributes.yil_src#">
		<cfset attributes.finishdate="31/12/#attributes.yil_src#">
	<cfelse>
		<cfset attributes.startdate="01/01/#bu_sene#">
		<cfset attributes.finishdate="31/12/#bu_sene#">
	</cfif>
	</cfif>
	<cf_date tarih='attributes.startdate'>
	<cf_date tarih='attributes.finishdate'>
</cfif>

<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_care_calender")>
<cfset login_act.dsn = dsn />
<cfset get_asset_cares_all = login_act.GET_ASSETP_CARE_FNC(
								temp_tarih : '#iif(isdefined("attributes.temp_tarih") and len(attributes.temp_tarih),"attributes.temp_tarih",DE(""))#',
                                branch_id : '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
								assetpcatid : '#iif(isdefined("attributes.assetpcatid") and len(attributes.assetpcatid),"attributes.assetpcatid",DE(""))#',
								department : '#iif(isdefined("attributes.department") and len(attributes.department),"attributes.department",DE(""))#',
                               	department_id :  '#iif(isdefined("attributes.department_id") and len(attributes.department_id),"attributes.department_id",DE(""))#',
							    official_emp_id : '#iif(isdefined("attributes.official_emp_id") and len(attributes.official_emp_id),"attributes.official_emp_id",DE(""))#',
								official_emp : '#iif(isdefined("attributes.official_emp") and len(attributes.official_emp),"attributes.official_emp",DE(""))#',
                                asset_id : '#iif(isdefined("attributes.asset_id") and len(attributes.asset_id),"attributes.asset_id",DE(""))#',
                                asset_name : '#iif(isdefined("attributes.asset_name") and len(attributes.asset_name),"attributes.asset_name",DE(""))#',
                                asset_cat : '#iif(isdefined("attributes.asset_cat") and len(attributes.asset_cat),"attributes.asset_cat",DE(""))#',
								startdate : '#iif(isdefined("attributes.startdate") and len(attributes.startdate),"attributes.startdate",DE(""))#',
                                finishdate : '#iif(isdefined("attributes.finishdate") and len(attributes.finishdate),"attributes.finishdate",DE(""))#',
								xml_single_asset_care : '#iif(isdefined("attributes.xml_single_asset_care") and len(attributes.xml_single_asset_care),"attributes.xml_single_asset_care",DE(""))#',
                                yearly_report_parameters : '#iif(isdefined("attributes.yearly_report_parameters") and len(attributes.yearly_report_parameters),"attributes.yearly_report_parameters",DE(""))#'								
								)>
