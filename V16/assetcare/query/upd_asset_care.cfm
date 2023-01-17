
<cf_date tarih='attributes.care_start_date'>
<cfsavecontent variable="control5">
            <cfdump var="#attributes#">
        </cfsavecontent>
        <cffile action="write" file = "c:\attributes.html" output="#control5#"></cffile>
<cfscript>
	if( isDefined("attributes.expense") and len(attributes.expense))
		attributes.expense = filterNum(attributes.expense);
	if( isDefined("attributes.expense_net") and len(attributes.expense_net))
		attributes.expense_net = filterNum(attributes.expense_net);
	if( isDefined("attributes.care_km") and len(attributes.care_km))
		attributes.care_km = filterNum(attributes.care_km);
	if(isDefined ("attributes.start_clock") and len(attributes.start_clock))
		attributes.care_start_date = date_add('h',attributes.start_clock, attributes.care_start_date);
	if( isDefined ("attributes.start_minute") and len(attributes.start_minute))
		attributes.care_start_date = date_add('n',attributes.start_minute, attributes.care_start_date);
</cfscript>
<cfif isdefined("attributes.support_finish_date1") and len(attributes.support_finish_date1)>
<cf_date tarih='attributes.support_finish_date1'>
</cfif>
<cfif isdefined("attributes.care_finish_date") and len(attributes.care_finish_date)>
	<cf_date tarih='attributes.care_finish_date'>
	<cfscript>
		if( isDefined("attributes.finish_clock") and len(attributes.finish_clock))
			attributes.care_finish_date = date_add('h',attributes.finish_clock, attributes.care_finish_date);
		if( isDefined("attributes.finish_minute") and len(attributes.finish_minute))
			attributes.care_finish_date = date_add('n',attributes.finish_minute, attributes.care_finish_date);
	</cfscript>
</cfif>
<cfif isdefined("attributes.calender_date") and len(attributes.calender_date) and isdate(attributes.calender_date)>
	<cf_date tarih='attributes.calender_date'>
</cfif>
<cflock timeout="60">
  	<cftransaction>
<cfset login_act = createObject("component", "V16.assetcare.cfc.assetp_care_calender")>
<cfset login_act.dsn = dsn />
<cfset UPD_ASSET_CARE = login_act.updAssetpCareFnc( 
								care_number : '#iif(isdefined("attributes.care_number") and len(attributes.care_number),"attributes.care_number",DE(""))#', 
								paper_type : '#iif(isdefined("attributes.paper_type") and len(attributes.paper_type),"attributes.paper_type",DE(""))#',
								expense_center_id : '#iif(isdefined("attributes.expense_center_id") and len(attributes.expense_center_id),"attributes.expense_center_id",DE(""))#', 
								exp_item_name :    '#iif(isdefined("attributes.exp_item_name") and len(attributes.exp_item_name),"attributes.exp_item_name",DE(""))#', 
                                process_stage : '#iif(isdefined("attributes.process_stage") and len(attributes.process_stage),"attributes.process_stage",DE(""))#', 
                               asset_id :  '#iif(isdefined("attributes.asset_id") and len(attributes.asset_id),"attributes.asset_id",DE(""))#',
							   support_finish_date : '#iif(isdefined("attributes.support_finish_date1") and len(attributes.support_finish_date1),"attributes.support_finish_date1",DE(""))#', 
                                service_company_id : '#iif(isdefined("attributes.service_company_id") and len(attributes.service_company_id),"attributes.service_company_id",DE(""))#',
                                authorized_id : '#iif(isdefined("attributes.authorized_id") and len(attributes.authorized_id),"attributes.authorized_id",DE(""))#',
                                station_id : '#iif(isdefined("attributes.station_id") and len(attributes.station_id),"attributes.station_id",DE(""))#',
								station_company_id : '#iif(isdefined("attributes.station_company_id") and len(attributes.station_company_id),"attributes.station_company_id",DE(""))#', 
                                employee_id : '#iif(isdefined("attributes.employee_id") and len(attributes.employee_id),"attributes.employee_id",DE(""))#',
                                employee_id2 : '#iif(isdefined("attributes.employee_id2") and len(attributes.employee_id2),"attributes.employee_id2",DE(""))#',
								care_start_date : '#iif(isdefined("attributes.care_start_date") and len(attributes.care_start_date),"attributes.care_start_date",DE(""))#',
								care_finish_date : '#iif(isdefined("attributes.care_finish_date") and len(attributes.care_finish_date),"attributes.care_finish_date",DE(""))#',
								care_type_id : '#iif(isdefined("attributes.care_type_id") and len(attributes.care_type_id),"attributes.care_type_id",DE(""))#',
								is_yasal_islem : '#iif(isdefined("attributes.is_yasal_islem") and len(attributes.is_yasal_islem),"attributes.is_yasal_islem",DE(""))#',
								policy_num : '#iif(isdefined("attributes.policy_num") and len(attributes.policy_num),"attributes.policy_num",DE(""))#',
                                	motorized_vehicle : '#iif(isdefined("attributes.motorized_vehicle") and len(attributes.motorized_vehicle),"attributes.motorized_vehicle",DE(""))#',    
                                care_km : '#iif(isdefined("attributes.care_km") and len(attributes.care_km),"attributes.care_km",DE(""))#', 
                               care_detail :  '#iif(isdefined("attributes.care_detail") and len(attributes.care_detail),"attributes.care_detail",DE(""))#',
                                care_detail2 : '#iif(isdefined("attributes.care_detail2") and len(attributes.care_detail2),"attributes.care_detail2",DE(""))#',
                                bill_id : '#iif(isdefined("attributes.bill_id") and len(attributes.bill_id),"attributes.bill_id",DE(""))#',
                                document_type_id : '#iif(isdefined("attributes.document_type_id") and len(attributes.document_type_id),"attributes.document_type_id",DE(""))#',
								expense : '#iif(isdefined("attributes.expense") and len(attributes.expense),"attributes.expense",DE(""))#', 
                                project_id : '#iif(isdefined("attributes.project_id") and len(attributes.project_id),"attributes.project_id",DE(""))#',
                                failure_id : '#iif(isdefined("attributes.failure_id") and len(attributes.failure_id),"attributes.failure_id",DE(""))#',
								care_id : '#iif(isdefined("attributes.care_id") and len(attributes.care_id),"attributes.care_id",DE(""))#',
								calender_date : '#iif(isdefined("attributes.calender_date") and len(attributes.calender_date),"attributes.calender_date",DE(""))#',
								money_currency : '#iif(isdefined("attributes.money_currency") and len(attributes.money_currency),"attributes.money_currency",DE(""))#',
								care_report_id : '#iif(isdefined("attributes.care_report_id") and len(attributes.care_report_id),"attributes.care_report_id",DE(""))#',
								expense_net : '#iif(isdefined("attributes.expense_net") and len(attributes.expense_net),"attributes.expense_net",DE(""))#',
								is_guaranty : '#iif(isdefined("attributes.is_guaranty") and len(attributes.is_guaranty),"attributes.is_guaranty",DE(""))#'
								)>
		<cfquery name="DEL_CARE_REPORT_ROW" datasource="#DSN#">
			DELETE FROM ASSET_CARE_REPORT_ROW WHERE CARE_REPORT_ID = #attributes.care_report_id#
		</cfquery>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_care_cat_id = evaluate("attributes.care_cat_id#i#");
						form_detail = evaluate("attributes.detail#i#");
						form_quantity = evaluate("attributes.quantity#i#");
						form_unit = evaluate("attributes.unit#i#");
						form_price = evaluate("attributes.price#i#");
						form_money_currency = evaluate("attributes.money_currency#i#");
						form_total_price = evaluate("attributes.total_price#i#");
						form_kdv = evaluate("attributes.kdv#i#");
						form_iskonto = evaluate("attributes.iskonto#i#");
					</cfscript>
					<cfquery name="ADD_CARE_REPORT_ROW" datasource="#dsn#">
						INSERT INTO
							ASSET_CARE_REPORT_ROW
						(
							CARE_REPORT_ID,
							CARE_CAT_ID,
							DETAIL,
							QUANTITY,
							UNIT,
							PRICE,
							TOTAL_PRICE,
							MONEY_CURRENCY,
                            KDV,
                            ISKONTO
						)
						VALUES
						(
							#attributes.care_report_id#,
							#form_care_cat_id#,
							<cfif len(form_detail)>'#form_detail#'<cfelse>NULL</cfif>,
							#form_quantity#,
							#form_unit#,
							<cfif len(form_price)>#form_price#<cfelse>NULL</cfif>,
							<cfif len(form_total_price)>#form_total_price#<cfelse>NULL</cfif>,
							<cfif len(form_money_currency)>'#form_money_currency#'<cfelse>NULL</cfif>,
                            <cfif len(form_kdv)>#form_kdv#<cfelse>NULL</cfif>,
                            <cfif len(form_iskonto)>#form_iskonto#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
          <cfif isdefined('process_stage') and len(process_stage)>
		<cf_workcube_process
			is_upd='1' 
			data_source='#dsn#'
			old_process_line='#attributes.old_process_line#'
			process_stage='#attributes.process_stage#'
			record_member='#session.ep.userid#'
			record_date='#now()#'
			action_table='ASSET_CARE_REPORT'
			action_column='CARE_REPORT_ID'
			action_id='#attributes.care_report_id#'
			action_page='#request.self#?fuseaction=assetcare.list_asset_care&event=upd&care_report_id=#attributes.care_report_id#'
			warning_description='Bakım Sonucu : #attributes.care_report_id#'>
            </cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">	
	window.location.href= <cfif isdefined("attributes.draggable")>document.referrer;<cfelse>'<cfoutput>#request.self#?fuseaction=assetcare.list_asset_care&event=upd&care_report_id=#attributes.care_report_id#</cfoutput>';</cfif>	
</script>



  
