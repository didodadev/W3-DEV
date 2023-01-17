<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('m',-1,attributes.finish_date)>
</cfif>

<cfscript>
	this_year = session.ep.period_year;
	last_year = session.ep.period_year-1;
	next_year = session.ep.period_year+1;
	if (database_type is 'MSSQL') 
		{
		last_year_dsn2 = '#dsn#_#this_year-1#_#session.ep.company_id#';
		next_year_dsn2 = '#dsn#_#this_year+1#_#session.ep.company_id#';
		}
	else if (database_type is 'DB2')
		{
		last_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year-1#';
		next_year_dsn2 = '#dsn#_#session.ep.company_id#_#this_year+1#';
		}	
</cfscript>
<cfquery name="GET_PERIODS" datasource="#DSN#">
	SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="CONTROL_LAST_YEAR" dbtype="query" maxrows="1">
	SELECT PERIOD_YEAR FROM GET_PERIODS WHERE PERIOD_YEAR = #last_year#
</cfquery>
<cfquery name="CONTROL_NEXT_YEAR" dbtype="query">
	SELECT PERIOD_YEAR FROM GET_PERIODS WHERE PERIOD_YEAR = #next_year#
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SERVICE" datasource="#DSN3#">
		SELECT
			SERVICE.SERVICE_ID,
			SERVICE.SERVICE_NO,
			SERVICE.APPLY_DATE,
			SERVICE.SERVICE_HEAD,
			SERVICE.SERVICE_COMPANY_ID,
			SERVICE.SERVICE_EMPLOYEE_ID,
			SERVICE.SERVICE_CONSUMER_ID,
			SERVICE.APPLICATOR_NAME,
			SERVICE.APPLICATOR_COMP_NAME,
			SERVICE.SERVICE_PRODUCT_ID,
			SERVICE.PRODUCT_NAME,
			SERVICE.PRO_SERIAL_NO,
			SERVICE.RECORD_MEMBER,
			SERVICE.RECORD_PAR,
			SERVICE.SERVICE_BRANCH_ID,
			SERVICE_APPCAT.SERVICECAT,
			SP.PRIORITY,
			SP.COLOR,
			PROCESS_TYPE_ROWS.STAGE
		FROM
			SERVICE,
			SERVICE_APPCAT,
			#dsn_alias#.SETUP_PRIORITY AS SP,
			#dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS
		WHERE 		
			(
			(
			SERVICE.SERVICE_ID IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
			AND
			SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
			)
			<cfif control_last_year.recordcount or control_next_year.recordcount>OR</cfif>
			<cfif control_last_year.recordcount>
				(
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
				AND
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
				AND
				SERVICE.SERVICE_ID IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
				AND
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
				)
				<cfif control_next_year.recordcount>OR</cfif>
			</cfif>
			<cfif control_next_year.recordcount>
				(
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
				AND
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #dsn2_alias#.SHIP_ROW SR,#dsn2_alias#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
				AND
				<cfif control_last_year.recordcount>
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
				AND
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #last_year_dsn2#.SHIP_ROW SR,#last_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
				AND
				</cfif>
				SERVICE.SERVICE_ID IN (SELECT SR.SERVICE_ID FROM #next_year_dsn2#.SHIP_ROW SR,#next_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 140 AND SR.SERVICE_ID IS NOT NULL)
				AND
				SERVICE.SERVICE_ID NOT IN (SELECT SR.SERVICE_ID FROM #next_year_dsn2#.SHIP_ROW SR,#next_year_dsn2#.SHIP S WHERE SR.SHIP_ID = S.SHIP_ID AND S.SHIP_TYPE = 141 AND SR.SERVICE_ID IS NOT NULL)
				)
			</cfif>
			) 
			AND
			SERVICE.SERVICECAT_ID=SERVICE_APPCAT.SERVICECAT_ID
			AND SP.PRIORITY_ID = SERVICE.PRIORITY_ID
			AND SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				AND SERVICE.APPLY_DATE >= #attributes.start_date#
			</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
				AND SERVICE.APPLY_DATE < #DATEADD("d",1,attributes.finish_date)#
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND (
					SERVICE.SERVICE_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					SERVICE.SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR
					SERVICE.SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
					)
			</cfif>
			<cfif not isdefined("attributes.service_status")>
				AND SERVICE.SERVICE_ACTIVE = 1
			</cfif>
			<cfif isdefined("attributes.service_status") and attributes.service_status eq "0">
				AND SERVICE.SERVICE_ACTIVE = 0
			<cfelseif isdefined("attributes.service_status") and attributes.service_status eq "1">				
				AND SERVICE.SERVICE_ACTIVE = 1
			</cfif>
			<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
				AND SERVICE.SERVICE_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
			</cfif>
			<cfif isdefined("attributes.related_company_id") and len(attributes.related_company_id) and isdefined("attributes.related_member_name") and len(attributes.related_member_name)> 
				AND SERVICE.RELATED_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.related_company_id#">
			</cfif>
			<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.member_name") and len(attributes.member_name)> 
				AND SERVICE.SERVICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.member_name") and len(attributes.member_name)> 
				AND SERVICE.SERVICE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif isdefined("attributes.department") and len(attributes.department_id) and len(attributes.location_id) and len(attributes.department)>
				AND SERVICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
				AND SERVICE.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">	
			</cfif>
		ORDER BY
			SERVICE.RECORD_DATE DESC
	</cfquery>
<cfelse>
  	<cfset get_service.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_service.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=service.service_ship">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#place#"  maxlength="50" value="#attributes.keyword#" style="width:75px;">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
						<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
							<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
						<cfelse>
							<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="" style="width:65px;" validate="#validate_style#" message="#message#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
						<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
							<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#">
						<cfelse>
							<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="" style="width:65px;" validate="#validate_style#" message="#message#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="service_status" id="service_status" style="width:50px;">
						<option value="1" <cfif isdefined("attributes.service_status") and attributes.service_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif isdefined("attributes.service_status") and attributes.service_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="2" <cfif isdefined("attributes.service_status") and attributes.service_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>        			
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_stage">
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12">
							<select name="process_stage" id="process_stage">
								<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
								<cfoutput query="get_process_stage">
									<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="col col-12"> 
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">	
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input type="text" name="member_name" id="member_name" style="width:100px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
								<cfset str_linke_ait="&field_consumer=form1.consumer_id&field_comp_id=form1.company_id&field_member_name=form1.member_name&field_type=form1.member_type">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.form1.member_name.value),'list');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-location">
						<label class="col col-12"><cf_get_lang dictionary_id ='30031.Lokasyon'></label>
						<div class="col col-12">
							<cfif isdefined("attributes.location_id") and Len(attributes.location_id)>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department,department_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
									fieldName="department"
									fieldId="location_id"
									department_fldId="department_id"
									department_id="#attributes.department_id#"
									location_id="#attributes.location_id#"
									location_name="#attributes.department#"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									is_delivery="1"
									width="140">
							<cfelse>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department,department_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
									fieldName="department"
									fieldId="location_id"
									department_fldId="department_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									is_delivery="1"
									width="140">
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-related_member_name">
						<label class="col col-12"><cf_get_lang dictionary_id='41664.İş Ortağı'></label>
						<div class="col col-12"> 
							<div class="input-group">
								<input type="hidden" name="related_company_id" id="related_company_id" value="<cfif isdefined("attributes.related_company_id")><cfoutput>#attributes.related_company_id#</cfoutput></cfif>">
								<input type="text" name="related_member_name" id="related_member_name" style="width:100px;" onFocus="AutoComplete_Create('related_member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','1','COMPANY_ID,PARTNER_ID','related_company_id,related_partner_id','','3','250');" value="<cfif isdefined("attributes.related_member_name") and len(attributes.related_member_name)><cfoutput>#attributes.related_member_name#</cfoutput></cfif>" autocomplete="off">
								<input type="hidden" name="related_partner_id" id="related_partner_id" value="<cfif isdefined("attributes.related_partner_id")><cfoutput>#attributes.related_partner_id#</cfoutput></cfif>">  
								<cfset str_linke_ait="&field_id=form1.related_partner_id&field_comp_id=form1.related_company_id&field_member_name=form1.related_member_name">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7&keyword='+encodeURIComponent(document.form1.related_member_name.value),'list');"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>

	<cfsavecontent variable="head"><cf_get_lang dictionary_id='41948.Servis İrsaliyesi'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<form action="<cfoutput>#request.self#?fuseaction=service.service_ship&event=add</cfoutput>" name="send_form_" id="send_form_" method="post">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th style="width:200px;"><cf_get_lang dictionary_id='29514.Başvuru Sahibi'></th>
						<th><cf_get_lang dictionary_id='57480.Konu'></th>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<th><cf_get_lang dictionary_id='57637.Seri No'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='57482.Aşama'></th> 
						<th><cf_get_lang dictionary_id='57742.Tarih'></th>          
						<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.service_ship&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					</tr>
				</thead>
					<cfif get_service.recordcount>
						<cfoutput>
							<input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
							<input type="hidden" name="department" id="department" value="#attributes.department#">
							<input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
							<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
							<input type="hidden" name="related_company_id" id="related_company_id" value="#attributes.related_company_id#">
							<input type="hidden" name="related_partner_id" id="related_partner_id" value="#attributes.related_partner_id#">
							<input type="hidden" name="related_member_name" id="related_member_name" value="#attributes.related_member_name#">
							<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
							<input type="hidden" name="member_name" id="member_name" value="#attributes.member_name#">				
							<input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
						</cfoutput>
						<cfset branch_id_list = "">
						<cfset record_list = ""> 
						<cfset record_par_list = "">
						<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(service_branch_id) and not listfind(branch_id_list,service_branch_id)>
								<cfset branch_id_list=listappend(branch_id_list,service_branch_id)>
							</cfif>
							<cfif len(record_member) and not listfind(record_list,record_member)>
								<cfset record_list=listappend(record_list,record_member)>
							</cfif>
							<cfif len(record_par) and not listfind(record_par_list,record_par)>
								<cfset record_par_list=listappend(record_par_list,record_par)>
							</cfif>
						</cfoutput>
						<cfif len(branch_id_list)>
							<cfset branch_id_list=listsort(branch_id_list,"numeric","ASC",",")>
							<cfinclude template="../query/get_branch.cfm">
							<cfset branch_id_list = valuelist(get_branch.branch_id,',')>
						</cfif>
						<tbody>
							<cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
								<tr>
									<td width="35">#currentrow#</td>
									<td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#" class="tableyazi">#get_service.service_no#</a></td>
									<td>
										<cfif len(applicator_comp_name)>
											<cfif len(service_company_id) and (service_company_id neq 0)>
												<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#service_company_id#','medium');" class="tableyazi">#applicator_comp_name#</a> -
											<cfelse>
												#applicator_comp_name# - 
											</cfif>
										</cfif>
										<cfif len(service_consumer_id) and (service_consumer_id neq 0)>
											<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#service_consumer_id#','medium');" class="tableyazi">#applicator_name#</a>
										<cfelseif len(service_employee_id) and (service_employee_id neq 0)>
											<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#service_employee_id#','medium');" class="tableyazi">#applicator_name#</a>
										<cfelse>
											#applicator_name#
										</cfif>
									</td>		
									<td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#" class="tableyazi"> #service_head#</a></td>
									<td>#servicecat#</td>
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_product&pid=#get_service.service_product_id#','medium');" class="tableyazi">#get_service.product_name#</a></td>
									<td>#pro_serial_no#</td>
									<td><cfif len(service_branch_id)>#get_branch.branch_name[listfind(branch_id_list,service_branch_id,',')]#</cfif></td>
									<td><font color="#color#">#stage#</font></td>
									<td>#dateformat(apply_date,dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,apply_date),timeformat_style)#</td>              
									<cfset COL=COLOR>
									<td width="15"><input type="checkbox" name="service_ids" id="service_ids" value="#service_id#"></td>
								</tr>
							</cfoutput>
						</tbody> 
						<tfoot>
							<tr>
								<td colspan="11">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='41933.İrsaliye Düzenle'></cfsavecontent>
									<cf_workcube_buttons type_format='1' insert_info='#message#' is_cancel='0' insert_alert='' add_function='irsaliye_gonder()'>
									<cfif isdefined("attributes.department") and len(attributes.department_id) and len(attributes.location_id) and len(attributes.department)>
										<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='41945.Depolararası Sevk Düzenle'></cfsavecontent>
										<cf_workcube_buttons insert_info='#message1#' is_cancel='0' insert_alert='' add_function='depolararasi_gonder()'>
									</cfif>
								</td>
							</tr>
						</tfoot>
					
					<cfelse>
						<tbody>
							<tr>
								<td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> !</td>
							</tr>
						</tbody>
					</cfif>
			</cf_grid_list>
		</form>
		<cfset url_str = "">
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = url_str & "&form_submitted=1">
		</cfif>
		<cfif isdefined("attributes.keyword")>
			<cfset url_str = url_str & "&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.process_stage")>
			<cfset url_str = url_str & "&process_stage=#attributes.process_stage#">
		</cfif>
		<cfif isdefined("attributes.service_status")>
			<cfset url_str = url_str & "&service_status=#attributes.service_status#">
		</cfif>
		<cfif isdefined("attributes.department_id")>
			<cfset url_str = url_str & "&department_id=#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.location_id")>
			<cfset url_str = url_str & "&location_id=#attributes.location_id#">
		</cfif>
		<cfif isdefined("attributes.department")>
			<cfset url_str = url_str & "&department=#attributes.department#">
		</cfif>
		<cfif isdefined("attributes.related_company_id")>
			<cfset url_str = url_str & "&related_company_id=#attributes.related_company_id#">
		</cfif>
		<cfif isdefined("attributes.related_partner_id")>
			<cfset url_str = url_str & "&related_partner_id=#attributes.related_partner_id#">
		</cfif>
		<cfif isdefined("attributes.related_member_name")>
			<cfset url_str = url_str & "&related_member_name=#attributes.related_member_name#">
		</cfif>
		<cfif isdefined("attributes.member_name")>
			<cfset url_str = url_str & "&member_name=#attributes.member_name#">
		</cfif>
		<cfif isdefined("attributes.member_type")>
			<cfset url_str = url_str & "&member_type=#attributes.member_type#">
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfset url_str = url_str & "&company_id=#attributes.company_id#">
		</cfif>
		<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction##url_str#">
	</cf_box>
</div>
	<script type="text/javascript">
		document.getElementById('keyword').focus();
		function kontrol()
		{
			member_name_ = document.getElementById('member_name').value;
			member_type_ = document.getElementById('member_type').value;
			related_com_ = document.getElementById('related_company_id').value;
			related_member_ = document.getElementById('related_member_name').value;
			department_ = document.getElementById('department').value;
			department_id_ = document.getElementById('department_id').value;
			if((member_name_== "" & member_type_ == "") & (related_member_=="" & related_com_=="") & (department_=="" & department_id_=="")) 	
			{
				alert("<cf_get_lang dictionary_id ='41946.Cari Hesap,İş Ortağı veya Depo Seçmelisiniz'>!");
				return false;
			}
			return true;
		}
		function depolararasi_gonder()
		{
			document.getElementById('send_form_').action = '<cfoutput>#request.self#?fuseaction=service.add_ship_dispatch</cfoutput>';
			document.getElementById('send_form_').submit();
		}
		function irsaliye_gonder()
		{
			document.getElementById('send_form_').submit();
		}
		function kontrol()
		{
			if( !date_check(document.all.form1.start_date, document.all.form1.finish_date, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
				return false;
			else
				return true;
		}
		$(function(){
			$(".grey-cascade").hide();
		});
	</script>
