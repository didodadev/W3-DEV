<!---<cfdump var=#attributes#><cfabort>--->
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_start_date'></cfif>
<cfif len(attributes.rent_finish_date)><cf_date tarih='attributes.rent_finish_date'></cfif>
<cfif not isdefined("attributes.status")>
	<cfset attributes.status = 0>
</cfif>
<cf_papers paper_type="FIXTURES">
<cflock timeout="60">
	<cftransaction>
		<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp")>
		<cfset login_act.dsn = dsn />
		<cfset addAssetp_init = login_act.init(
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
			attributes.inventory_number,
			#iif(isdefined("attributes.fixtures_id") and len(attributes.fixtures_id),"attributes.fixtures_id",DE(""))#,
			attributes.employee_id,
			attributes.assetp_other_money,
			attributes.assetp_other_money_value,
			attributes.position2,
			attributes.emp_id,
			attributes.member_type_2,
			attributes.relation_asset)>
		<cfset addAssetp_initAssetp = addAssetp_init.addAssetpFnc(
            attributes.rent_amount,
            attributes.rent_amount_currency,
            attributes.rent_payment_period,
            attributes.rent_finish_date,
            attributes.fuel_amount,
            attributes.fuel_amount_currency,
            attributes.is_fuel_added,
            attributes.is_care_added,
            attributes.care_amount,
            attributes.care_amount_currency,
            attributes.assetp_group,
            attributes.start_date,
			attributes.rent_start_date,
			attributes.assetp_space_id,
			attributes.status,
			'#iif(isdefined("attributes.property") and len(attributes.property),"attributes.property",DE(""))#',
			'#iif(isdefined("attributes.coordinate_1") and len(attributes.coordinate_1),"attributes.coordinate_1",DE(""))#',
			'#iif(isdefined("attributes.coordinate_2") and len(attributes.coordinate_2),"attributes.coordinate_2",DE(""))#'
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

		<cfset attributes.actionid=addAssetp_initAssetp>
		<cf_workcube_process 
			is_upd='1'
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='ASSET_P'
			action_column='ASSETP_ID'
			action_id='#addAssetp_initAssetp#'
			action_page='#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#addAssetp_initAssetp#'
			warning_description='Varlık : #attributes.assetp#'>
	</cftransaction>
</cflock>
<script>
	<cfif not isdefined("attributes.draggable")>window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_assetp&event=upd&assetp_id=#addAssetp_initAssetp#</cfoutput>'; 
	<cfelseif isdefined("attributes.draggable")>
		if($('form[name="upd_assetp"]').length){
			closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>,'list_member_rel');
		}
		else{
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>'); kontrol(1);
	    }
	</cfif>
</script>