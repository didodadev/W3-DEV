<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="stock.detail_multi_packetship">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.document_number" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list><cfset attributes.start_date=''><cfelse><cfset attributes.start_date=wrk_get_today()></cfif>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list><cfset attributes.finish_date=''><cfelse><cfset attributes.finish_date = date_add('d',1,now())></cfif>
</cfif>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfparam name="attributes.error_case_type" default="">
<cfparam name="attributes.problem_case_type" default="">
<cfparam name="attributes.problem_type" default="">
<cfparam name="attributes.team_code" default="">
<cfparam name="attributes.planning_date" default="#dateFormat(now(),dateformat_style)#">
<cf_date tarih="attributes.planning_date">
<cfquery name="get_planning_info" datasource="#dsn3#">
	SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
</cfquery>
<cfquery name="get_packetship_stage" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_packetship%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_error_case" datasource="#dsn#">
	SELECT ERROR_CASE_ID, ERROR_CASE_NAME FROM PACKETSHIP_ERROR_CASE ORDER BY ERROR_CASE_NAME
</cfquery>
<cfquery name="get_problem_case" datasource="#dsn#">
	SELECT PROBLEM_CASE_ID,#dsn#.Get_Dynamic_Language(PROBLEM_CASE_ID,'#session.ep.language#','PACKETSHIP_PROBLEM_CASE','PROBLEM_CASE_NAME',NULL,NULL,PROBLEM_CASE_NAME) AS PROBLEM_CASE_NAME FROM PACKETSHIP_PROBLEM_CASE ORDER BY PROBLEM_CASE_NAME
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_packetship_result" datasource="#dsn2#">
		SELECT 
			(SELECT O.COMPANY_ID FROM #dsn3_alias#.ORDERS O WHERE O.ORDER_ID = ORR.ORDER_ID) COMPANY_ID,
			(SELECT O.CONSUMER_ID FROM #dsn3_alias#.ORDERS O WHERE O.ORDER_ID = ORR.ORDER_ID) CONSUMER_ID,
			ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) DELIVER_DATE,
			ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) DEPARTMENT_ID,
			ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) LOCATION_ID,
			O.ORDER_NUMBER,
			O.FRM_BRANCH_ID,
			ORR.PRODUCT_NAME,
			ORR.SPECT_VAR_NAME,
			SRR.SHIP_RESULT_ID,
			SRR.WRK_ROW_ID
		FROM
			SHIP_RESULT_ROW SRR,
			#dsn3_alias#.ORDERS O,
			#dsn3_alias#.ORDER_ROW ORR
		WHERE 
			O.ORDER_ID = ORR.ORDER_ID AND
			SRR.WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND
			((ISNULL(SRR.INVOICE_ID,SRR.SHIP_ID) IS NOT NULL AND SRR.IS_PROBLEM = 0) OR (ISNULL(SRR.INVOICE_ID,SRR.SHIP_ID) IS NULL AND SRR.IS_PROBLEM = 1)) AND
			(
				(ORR.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM SHIP_ROW WHERE WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND WRK_ROW_RELATION_ID IS NOT NULL)) OR
				(ORR.WRK_ROW_ID IN (SELECT WRK_ROW_RELATION_ID FROM INVOICE_ROW WHERE WRK_ROW_RELATION_ID = ORR.WRK_ROW_ID AND WRK_ROW_RELATION_ID IS NOT NULL))
			) AND
			SRR.SHIP_RESULT_ID IN 	(	SELECT
											SR.SHIP_RESULT_ID
										FROM
											SHIP_RESULT SR
										WHERE
											SR.IS_ORDER_TERMS = 1 AND
											SR.MAIN_SHIP_FIS_NO IS NOT NULL AND
											SR.SHIP_METHOD_TYPE IS NOT NULL
											<cfif Len(attributes.planning_date)>
												AND SR.OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
											</cfif>
											<cfif Len(attributes.team_code)>
												AND SR.EQUIPMENT_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_code#">
											</cfif>
											<cfif len(attributes.keyword)>
												AND (SR.SHIP_FIS_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR SR.REFERENCE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
											</cfif>
											<cfif len(attributes.process_stage_type)>
												AND SR.SHIP_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage_type#">
											</cfif>
											
											<cfif len(attributes.start_date)>
												AND SR.OUT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
											</cfif>
											<cfif len(attributes.finish_date)>
												AND SR.OUT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
											</cfif>
									)
			<cfif Len(attributes.error_case_type) or Len(attributes.problem_case_type) or Len(attributes.problem_type)>
				AND SRR.WRK_ROW_ID IN	(	SELECT
												WRK_ROW_RELATION_ID
											FROM
												SHIP_RESULT_ROW_COMPLETE
											WHERE
												1 = 1
												<cfif Len(attributes.error_case_type)>
													AND ERROR_CASE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.error_case_type#">
												</cfif>
												<cfif Len(attributes.problem_case_type)>
													AND PROBLEM_CASE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.problem_case_type#">
												</cfif>
												<cfif Len(attributes.problem_type) and ListFind("0,1",attributes.problem_type,',')>
													AND PROBLEM_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.problem_type#">
												<cfelseif Len(attributes.problem_type) and not ListFind("0,1",attributes.problem_type,',')>
													AND PROBLEM_RESULT_ID IS NULL
												</cfif>
										)
			</cfif>
			<cfif len(attributes.document_number)>
				AND O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.document_number#%">
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.company)>
				AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfelseif len(attributes.consumer_id) and len(attributes.company)>
				AND O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.location_id) and len(attributes.department_id) and len(attributes.department_name)>
				AND ISNULL(ORR.DELIVER_LOCATION,O.LOCATION_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
				AND ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			</cfif>
		ORDER BY
			RECORD_DATE
	</cfquery>
<cfelse>
	<cfset get_packetship_result.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_packetship_result.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form_complete" method="post" action="#request.self#?fuseaction=stock.list_multi_packetship_complete">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<input type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50" style="width:60px;">
					</div>
					<div class="form-group">
						<cfsavecontent variable="header_"><cfif x_equipment_planning_info eq 0><cf_get_lang dictionary_id='58138.Irsaliye No'><cfelse><cf_get_lang dictionary_id='58211.Sipariş No'></cfif></cfsavecontent>
						<input type="text" name="document_number" id="document_number" placeholder="<cfif x_equipment_planning_info eq 0><cf_get_lang dictionary_id='58138.Irsaliye No'><cfelse><cf_get_lang dictionary_id='58211.Sipariş No'></cfif>" value="#attributes.document_number#" maxlength="50" style="width:60px;">
					</div>
					<div class="form-group">
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57482.Aşama'></cfsavecontent>
						<select name="process_stage_type" id="process_stage_type" style="width:90px;">
							<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
							<cfloop query="get_packetship_stage">
								<option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)>selected</cfif>>#stage#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4" search_function="kontrol()">
					</div>
				</cfoutput>
			</cf_box_search>
			<cf_box_search_detail>
				<cfoutput>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<cfif x_equipment_planning_info eq 1>
						<div class="form-group" id="item-planning_date">
							<label class="col col-12"><cf_get_lang dictionary_id='58881.Plan Tarihi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58881.Plan Tarihi'></cfsavecontent>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='45784.Lütfen Ekip Tarihi Değerini Kontrol Ediniz'> !</cfsavecontent>
									<cfinput name="planning_date" value="#dateformat(attributes.planning_date,dateformat_style)#" type="text" onChange="depot_date_change();" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="planning_date"></span>
								</div>
							</div>
						</div>
						<script type="text/javascript">
							function depot_date_change()
							{
								var get_planning_info_js =  wrk_safe_query('stk_get_planning_info','dsn3',0,js_date(document.form_complete.planning_date.value));
								for(j=<cfoutput>#get_planning_info.recordcount#</cfoutput>;j>=0;j--)
									document.form_complete.team_code.options[j] = null;
								
								document.form_complete.team_code.options[0]= new Option('Ekip - Araç','');
								if(get_planning_info_js.recordcount)
									for(var jj=0;jj < get_planning_info_js.recordcount;jj++)
										document.form_complete.team_code.options[jj+1]=new Option(get_planning_info_js.TEAM_CODE[jj],get_planning_info_js.PLANNING_ID[jj]);
							}
						</script>
						<div class="form-group" id="item-team_code">
							<label class="col col-12"><cf_get_lang dictionary_id='58870.Ekip - Araç'></label>
							<div class="col col-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='58870.Ekip - Araç'></cfsavecontent>
								<select name="team_code" id="team_code" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='58870.Ekip - Araç'></option>
									<cfloop query="get_planning_info">
										<option value="#planning_id#" <cfif planning_id eq attributes.team_code>selected</cfif>>#team_code#</option>
									</cfloop>
								</select>
							</div>
						</div>
						</cfif>
						<div class="form-group" id="item-company">
							<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57519.Cari Hesap'></cfsavecontent>
									<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
									<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
									<input type="text" name="company" id="company" value="#attributes.company#" style="width:130px;" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=form.company_id&field_comp_name=form.company&field_consumer=form.consumer_id&field_member_name=form.company&select_list=2,3','list','popup_list_all_pars');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-location_id">
							<label class="col col-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'></label>
							<div class="col col-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29428.Çıkış Depo'></cfsavecontent>
								<!---<input type="hidden" name="location_id" id="location_id" value="#attributes.location_id#">
									<input type="hidden" name="department_id" id="department_id" value="#attributes.department_id#">
									<input type="text" style="width:100px;" name="department_name" id="department_name" value="#attributes.department_name#">
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=packetship_complete&field_name=department_name&field_id=department_id&field_location_id=location_id&is_no_sale=1&dsp_service_loc=1','list')" ><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> --->
									<cf_wrkdepartmentlocation 
										returnInputValue="location_id,department_name,department_id"
										returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
										fieldName="department_name"
										fieldid="location_id"
										department_fldId="department_id"
										department_id="#attributes.department_id#"
										location_name="#attributes.department_name#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										width="100">
								</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="header_">#getlang(330,'Tarih',57742)#</cfsavecontent>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
									<cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" name="start_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									<span class="input-group-addon no-bg"></span>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
									<cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" name="finish_date" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-problem_type">
							<label class="col col-12">#getlang(611,'Problem tipi',45790)#</label>
							<div class="col col-12">
								<cfsavecontent variable="header_">#getlang(611,'Problem tipi',45790)#</cfsavecontent>
								<select name="problem_type" id="problem_type" style="width:90px;">
									<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
									<option value="1" <cfif attributes.problem_type eq 1>selected</cfif>><cf_get_lang dictionary_id='45327.Sorunlu'></option>
									<option value="0" <cfif attributes.problem_type eq 0>selected</cfif>><cf_get_lang dictionary_id='45328.Sorunsuz'></option>
									<option value="-1" <cfif attributes.problem_type eq -1>selected</cfif>><cf_get_lang dictionary_id='45329.İşlenmeyenler'></option>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-error_case_name">
							<label class="col col-12"><cf_get_lang dictionary_id='45331.Hata Kimde'></label>
							<div class="col col-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45331.Hata Kimde'></cfsavecontent>
								<cf_wrk_combo
									name="error_case_type"
									option_text="#header_#"
									option_name="error_case_name"
									option_value="error_case_id"
									query_name="get_packetship_error_case"
									width=""
									value="#attributes.error_case_type#">
							</div>
						</div>
						<div class="form-group" id="item-problem_case_type">
							<label class="col col-12"><cf_get_lang dictionary_id='45334.Sorunlu Durum'></label>
							<div class="col col-12">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='45334.Sorunlu Durum'></cfsavecontent>
								<select name="problem_case_type" id="problem_case_type" style="width:100px;">
									<option value=""><cf_get_lang dictionary_id='45334.Sorunlu Durum'></option>
									<cfloop query="get_problem_case">
										<option value="#problem_case_id#" <cfif attributes.problem_case_type eq problem_case_id>selected</cfif>>#problem_case_name#</option>
									</cfloop>
								</select>
							</div>
						</div>
					</div>
				</cfoutput>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(575,'Sevkiyat Sonuçları',45754)#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
					<th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
					<th><cf_get_lang dictionary_id='58211.Sipariş No'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='29428.Çıkış Depo'></th>
					<th><cf_get_lang dictionary_id='57452.Stok'></th>
					<th><cf_get_lang dictionary_id="57647.Spec"></th>
					<th><cf_get_lang dictionary_id='57684.Sonuç'></th>
					<th><cf_get_lang dictionary_id='45331.Hata Kimde'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='45334.Sorunlu Durum'></th>
					<th><cfoutput>#getLang(164,'Servis Verildi',45341)#</cfoutput></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_packetship_result.recordcount>
				<cfset Company_List = "">
				<cfset Consumer_List = "">
				<cfset Branch_List = "">
				<cfset Department_List = "">
				<cfset Location_List = "">
				<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif Len(company_id) and not ListFind(Company_List,company_id,',')>
						<cfset Company_List = ListAppend(Company_List,company_id,',')>
					<cfelseif Len(consumer_id) and not ListFind(Consumer_List,consumer_id,',')>
						<cfset Consumer_List = ListAppend(Consumer_List,consumer_id,',')>
					</cfif>
					<cfif Len(frm_branch_id) and not ListFind(Branch_List,frm_branch_id,',')>
						<cfset Branch_List = ListAppend(Branch_List,frm_branch_id,',')>
					</cfif>
					<cfif Len(department_id) and not ListFind(Department_List,department_id,',')>
						<cfset Department_List = ListAppend(Department_List,department_id,',')>
					</cfif>
					<cfif Len(location_id) and not ListFind(Location_List,location_id,',')>
						<cfset Location_List = ListAppend(Location_List,location_id,',')>
					</cfif>
				</cfoutput>
				<cfif ListLen(Company_List)>
					<cfquery name="Get_Company_Info" datasource="#dsn#">
						SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#Company_List#) ORDER BY COMPANY_ID
					</cfquery>
					<cfset Company_List = ListSort(ListDeleteDuplicates(ValueList(Get_Company_Info.Company_Id,',')),'numeric','asc',',')>
				</cfif>
				<cfif ListLen(Consumer_List)>
					<cfquery name="Get_Consumer_Info" datasource="#dsn#">
						SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#Consumer_List#) ORDER BY CONSUMER_ID
					</cfquery>
					<cfset Consumer_List = ListSort(ListDeleteDuplicates(ValueList(Get_Consumer_Info.Consumer_Id,',')),'numeric','asc',',')>
				</cfif>
				<cfif ListLen(Branch_List)>
					<cfquery name="Get_Branch_Info" datasource="#dsn#">
						SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#Branch_List#) ORDER BY BRANCH_ID
					</cfquery>
					<cfset Branch_List = ListSort(ListDeleteDuplicates(ValueList(Get_Branch_Info.Branch_Id,',')),'numeric','asc',',')>
				</cfif>
				<cfif ListLen(Location_List) and ListLen(Department_List)>
					<cfquery name="Get_Location_Info" datasource="#dsn#">
						SELECT
							L.LOCATION_ID,
							DEPARTMENT_HEAD + ' - ' + L.COMMENT DEP_LOC_NAME
						FROM
							DEPARTMENT D,
							STOCKS_LOCATION L
						WHERE
							L.STATUS = 1 AND
							D.DEPARTMENT_STATUS = 1 AND
							D.DEPARTMENT_ID = L.DEPARTMENT_ID AND
							D.DEPARTMENT_ID IN (#Department_List#) AND
							L.LOCATION_ID IN (#Location_List#)
						ORDER BY
							L.LOCATION_ID
					</cfquery>
					<cfset Location_List = ListSort(ListDeleteDuplicates(ValueList(Get_Location_Info.Location_Id,',')),'numeric','asc',',')>
				</cfif>
				<cfform name="packetship_complete" method="post" action="">
					<cfoutput>
						<input type="hidden" name="row_recordcount" id="row_recordcount" value="#get_packetship_result.recordcount#" />
						<input type="hidden" name="team_code_" id="team_code_" value="#attributes.team_code#" />
						<input type="hidden" name="planning_date_" id="planning_date_" value="#DateFormat(attributes.planning_date,dateformat_style)#" />
					</cfoutput>
					<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfquery name="Get_Ship_Complete" datasource="#dsn2#">
							SELECT TOP 1 * FROM SHIP_RESULT_ROW_COMPLETE WHERE WRK_ROW_RELATION_ID = '#wrk_row_id#' ORDER BY RECORD_DATE DESC
						</cfquery>
						<tr>
							<input type="hidden" name="ship_result_id_#currentrow#" id="ship_result_id_#currentrow#" value="#ship_result_id#"/>
							<input type="hidden" name="ship_result_wrk_row_id_#currentrow#" id="ship_result_wrk_row_id_#currentrow#" value="#wrk_row_id#"/>
							<td align="center">#currentrow#</td>
							<td><cfif Len(company_id)>#Get_Company_Info.Fullname[ListFind(Company_List,company_id,',')]#<cfelseif Len(consumer_id)>#Get_Consumer_Info.Fullname[ListFind(Consumer_List,consumer_id,',')]#</cfif></td>
							<td align="center">#DateFormat(deliver_date,dateformat_style)#</td>
							<td align="center">#order_number#</td>
							<td><cfif Len(frm_branch_id)>#Get_Branch_Info.Branch_Name[ListFind(Branch_List,frm_branch_id,',')]#</cfif></td>
							<td><cfif Len(location_id)>#Get_Location_Info.Dep_Loc_Name[ListFind(Location_List,location_id,',')]#</cfif></td>
							<td>#product_name#</td>
							<td>#spect_var_name#</td>
							<td align="center">
								<select name="row_problem_type_#currentrow#" id="row_problem_type_#currentrow#" style="width:90px;" onchange="if(this.value == 1){document.all.row_error_case_type_#currentrow#.disabled= false;document.all.row_problem_case_type_#currentrow#.disabled= false;}else{document.all.row_error_case_type_#currentrow#.disabled= true;document.all.row_problem_case_type_#currentrow#.disabled= true;}">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif Get_Ship_Complete.Problem_Result_Id eq 1>selected</cfif>><cf_get_lang dictionary_id='45327.Sorunlu'></option>
									<option value="0" <cfif Get_Ship_Complete.Problem_Result_Id eq 0>selected</cfif>><cf_get_lang dictionary_id='45328.Sorunsuz'></option>
								</select>
							</td>
							<td align="center">
								<select name="row_error_case_type_#currentrow#" id="row_error_case_type_#currentrow#" style="width:90px;" <cfif Get_Ship_Complete.Problem_Result_Id neq 1>disabled</cfif>>
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_error_case">
										<option value="#error_case_id#" <cfif Get_Ship_Complete.Error_Case_Id eq get_error_case.error_case_id>selected</cfif>>#error_case_name#</option>
									</cfloop>
								</select>
							</td>
							<td><input type="text" name="row_problem_detail_#currentrow#" id="row_problem_detail_#currentrow#" maxlength="500" value="<cfif Len(Get_Ship_Complete.Problem_Detail)>#Get_Ship_Complete.Problem_Detail#</cfif>" style="width:140px;"></td>
							<td align="center">
								<select name="row_problem_case_type_#currentrow#" id="row_problem_case_type_#currentrow#" style="width:100px;" <cfif Get_Ship_Complete.Problem_Result_Id neq 1>disabled</cfif>>
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_problem_case">
										<option value="#problem_case_id#" <cfif Get_Ship_Complete.Problem_Case_Id eq get_problem_case.problem_case_id>selected</cfif>>#problem_case_name#</option>
									</cfloop>
								</select>
							</td>
							<td align="center"><input type="checkbox" name="is_give_service_#currentrow#" id="is_give_service_#currentrow#" value="1" <cfif Get_Ship_Complete.Is_Give_Service eq 1>checked</cfif>></td>
						</tr>
					</cfoutput>
					<tr class="color-list" height="25">
						<td align="right" colspan="13">
							<input type="button" name="all_complete" id="all_complete" value="<cf_get_lang dictionary_id='45335.Hepsi Sorunsuz'>" onclick="check_all_complete();">
							<cfsavecontent variable="plan_result"><cf_get_lang dictionary_id='57461.Kaydet'>/<cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
							<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#plan_result#' add_function='control_result()'>
						</td>
					</tr>
				</cfform>
				<cfelse>
					<tr>
						<td colspan="16"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str="stock.list_multi_packetship_complete&attributes.form_submitted=1">
			<cfif isDefined("attributes.planning_date") and Len(attributes.planning_date)>
				<cfset url_str = "#url_str#&planning_date=#dateformat(attributes.planning_date,dateformat_style)#">
			</cfif>
			<cfif isDefined("attributes.team_code") and Len(attributes.team_code)>
				<cfset url_str = "#url_str#&team_code=#attributes.team_code#">
			</cfif>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.document_number)>
				<cfset url_str = "#url_str#&document_number=#attributes.document_number#">
			</cfif>
			<cfif len(attributes.start_date)>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_date)>
				<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.company_id) and len(attributes.company)>
				<cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.consumer_id) and len(attributes.company)>
				<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
			</cfif>
			<cfif len(attributes.department_id) and len(attributes.department_name)>
				<cfset url_str = "#url_str#&department_id=#attributes.department_id#&department_name=#attributes.department_name#">
			</cfif>
			<cfif len(attributes.process_stage_type)>
				<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
			</cfif>
			<cfif len(attributes.error_case_type)>
				<cfset url_str = "#url_str#&error_case_type=#attributes.error_case_type#">
			</cfif>
			<cfif len(attributes.problem_case_type)>
				<cfset url_str = "#url_str#&problem_case_type=#attributes.problem_case_type#">
			</cfif>
			<cfif len(attributes.problem_type)>
				<cfset url_str = "#url_str#&problem_type=#attributes.problem_type#">
			</cfif>
			<cf_paging page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#url_str#&form_submitted=1"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
	{
		if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!") )	
			return false;
		else
			return true;
	}
	function control_form()
	{
		if(document.form_complete.team_code.value == '')
		{
			alert("<cf_get_lang dictionary_id='45337.Ekip Seçmelisiniz'> !");
			return false;
		}
		return true;
	}
	
	function check_all_complete()
	{
		<cfif get_packetship_result.recordcount>
		<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.packetship_complete.row_problem_type_#currentrow#.value != 1)
				document.packetship_complete.row_problem_type_#currentrow#.value = 0; //Sorunsuz Degeri = 0
		</cfoutput>
		</cfif>
	}
	function problem_control()
	{
		<cfif get_packetship_result.recordcount>
		<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.packetship_complete.row_problem_type_#currentrow#.value != 1)
			{
				if(document.packetship_complete.row_error_case_type_#currentrow#.value != '')
				{
					alert("<cf_get_lang dictionary_id='45338.Sorunlu Olmayan Durumlar İçin Hata Giremezsiniz'> !");
					return false;
				}
				if(document.packetship_complete.row_problem_case_type_#currentrow#.value != '')
				{
					alert("<cf_get_lang dictionary_id='45339.Sorunlu Olmayan Durumlar İçin Sorunlu Durum Giremezsiniz'> !");
					return false;
				}
			}
		</cfoutput>
		</cfif>
	}
	function control_result()
	{
		<cfif get_packetship_result.recordcount>
		<cfoutput query="get_packetship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			if(document.packetship_complete.row_problem_type_#currentrow#.value == 1)
			{
				if(document.packetship_complete.row_error_case_type_#currentrow#.value == '')
				{
					alert("<cf_get_lang dictionary_id='61108.Sorunlu Olan Durumlar İçin Hata Girmelisiniz'> ! <cf_get_lang dictionary_id='58508.Satır'>:"+#currentrow#);
					return false;
				}
				if(document.packetship_complete.row_problem_detail_#currentrow#.value == '')
				{
					alert("<cf_get_lang dictionary_id='61109.Sorunlu Olan Durumlar İçin Açıklama Girmelisiniz'> ! <cf_get_lang dictionary_id='58508.Satır'>:"+#currentrow#);
					return false;
				}
				if(document.packetship_complete.row_problem_case_type_#currentrow#.value == '')
				{
					alert("<cf_get_lang dictionary_id='61110.Sorunlu Olan Durumlar İçin Sorunlu Durum Girmelisiniz'> ! <cf_get_lang dictionary_id='58508.Satır'>:"+#currentrow#);
					return false;
				}
			}
		</cfoutput>
		</cfif>
		document.packetship_complete.action='<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_multi_packetship_complete';
		document.packetship_complete.submit();
		return false;
	}
</script>