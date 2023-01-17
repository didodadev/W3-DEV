<cf_xml_page_edit fuseact="stock.detail_multi_packetship">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.document_number" default="">
<cfparam name="attributes.ship_method" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date=wrk_get_today()>
	</cfif>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date=''>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',1,now())>
	</cfif>
</cfif>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.ship_method_id" default="">
<cfparam name="attributes.ship_method_name" default="">
<cfparam name="attributes.ship_stage" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.transport_comp_id" default="">
<cfparam name="attributes.transport_comp_name" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.process_stage_type" default="">
<cfif x_equipment_planning_info eq 1>
	<cfparam name="attributes.team_code" default="">
	<cfparam name="attributes.planning_date" default="#dateFormat(now(),dateformat_style)#">
	<cf_date tarih="attributes.planning_date">
	<cfquery name="get_planning_info" datasource="#dsn3#">
		SELECT PLANNING_ID,PLANNING_DATE,TEAM_CODE FROM DISPATCH_TEAM_PLANNING <cfif isdate(attributes.planning_date) and len(attributes.planning_date)>WHERE PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#"></cfif>
	</cfquery>
</cfif>

<cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
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
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
		SELECT 
			SR.MAIN_SHIP_FIS_NO,
			SR.OUT_DATE, 
			SR.DELIVERY_DATE, 
			SR.SHIP_METHOD_TYPE, 
			SR.SHIP_STAGE,
			SR.EQUIPMENT_PLANNING_ID,
			SMT.SHIP_METHOD 	
		FROM 
			#dsn_alias#.SHIP_METHOD SMT,
			SHIP_RESULT SR
		WHERE 
			SR.SHIP_METHOD_TYPE = SMT.SHIP_METHOD_ID AND
			SR.MAIN_SHIP_FIS_NO IS NOT NULL
			<cfif x_equipment_planning_info eq 1>
				AND SR.IS_ORDER_TERMS = 1
				<cfif isdate(attributes.planning_date) and len(attributes.planning_date)>
					AND SR.OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
				</cfif>
				<cfif Len(attributes.team_code)>
					AND SR.EQUIPMENT_PLANNING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.team_code#">
				</cfif>
				<cfif len(attributes.document_number) or (len(attributes.company_id) and len(attributes.company)) or (len(attributes.consumer_id) and len(attributes.company))><!--- Siparis Numarasina Gore Arama --->
					AND SHIP_RESULT_ID IN(	SELECT
												SHIP_RESULT_ID
											FROM
												SHIP_RESULT_ROW SRR,
												#dsn3_alias#.ORDERS O
											WHERE
												SRR.ORDER_ID = O.ORDER_ID
												<cfif len(attributes.document_number)>
													AND O.ORDER_NUMBER LIKE '%#attributes.document_number#%'
												</cfif>
												<cfif len(attributes.company_id) and len(attributes.company)>
													AND O.COMPANY_ID = #attributes.company_id#
												<cfelseif len(attributes.consumer_id) and len(attributes.company)>
													AND O.CONSUMER_ID = #attributes.consumer_id#
												</cfif>
										)
				</cfif>
			<cfelse>
				AND SR.IS_ORDER_TERMS IS NULL
				<cfif len(attributes.document_number)><!---  Irsaliye numarasina gore arama (xml de dikkate alinarak) --->
					AND SHIP_RESULT_ID IN(	SELECT
												SHIP_RESULT_ID
											FROM
												SHIP_RESULT_ROW
											WHERE
												SHIP_ID IN (SELECT SHIP_ID FROM SHIP WHERE SHIP_NUMBER LIKE '%#attributes.document_number#%') OR SHIP_ID IS NULL
										)		  
				</cfif>
				<cfif len(attributes.company_id) and len(attributes.company)>
                    AND SR.COMPANY_ID = #attributes.company_id#
                <cfelseif len(attributes.consumer_id) and len(attributes.company)>
                    AND SR.CONSUMER_ID = #attributes.consumer_id#
                </cfif>
			</cfif>	  
			<cfif len(attributes.keyword)>
				AND (SR.SHIP_FIS_NO LIKE '%#attributes.keyword#%' OR SR.REFERENCE_NO LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif len(attributes.process_stage_type)>
				AND SR.SHIP_STAGE = #attributes.process_stage_type#</cfif>
			<cfif len(attributes.start_date)>
				AND SR.OUT_DATE >= #attributes.start_date#
			</cfif>
			<cfif len(attributes.finish_date)>
				AND SR.OUT_DATE <= #attributes.finish_date#
			</cfif>
			<cfif len(attributes.ship_method_name) and len(attributes.ship_method_id)>
				AND SR.SHIP_METHOD_TYPE = #attributes.ship_method_id#
			</cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id) and isdefined("attributes.department_name") and len(attributes.department_name)>
				AND SR.DEPARTMENT_ID = #attributes.department_id#
			</cfif>
			<cfif len(attributes.transport_comp_id) and len(attributes.transport_comp_name)>
				AND SR.SERVICE_COMPANY_ID = #attributes.transport_comp_id#
			</cfif>
		GROUP BY 
			SR.MAIN_SHIP_FIS_NO,
			SR.OUT_DATE, 
			SR.DELIVERY_DATE, 
			SR.SHIP_METHOD_TYPE, 
			SR.SHIP_STAGE, 
			SR.EQUIPMENT_PLANNING_ID,
			SMT.SHIP_METHOD		
	</cfquery>
<cfelse>
	<cfset get_ship_result.recordCount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_ship_result.recordcount#'>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" method="post" action="#request.self#?fuseaction=stock.list_multi_packetship">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<cfoutput>
					<div class="form-group">
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<input type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50" style="width:60px;">
					</div>
					<div class="form-group">
						<cfsavecontent variable="header_"><cfif x_equipment_planning_info eq 0><cf_get_lang dictionary_id='58138.Irsaliye No'><cfelse><cf_get_lang dictionary_id='58211.Sipariş No'></cfif></cfsavecontent>
						<input type="text" name="document_number" placeholder="<cfif x_equipment_planning_info eq 0><cf_get_lang dictionary_id='58138.Irsaliye No'><cfelse><cf_get_lang dictionary_id='58211.Sipariş No'></cfif>"id="document_number" value="#attributes.document_number#" maxlength="255" style="width:60px;">
					</div>
					<div class="form-group">
						<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57482.Aşama'></cfsavecontent>
						<select name="process_stage_type" id="process_stage_type" style="width:90px;">
							<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
							<cfloop query="get_ship_stage">
								<option value="#process_row_id#" <cfif (attributes.process_stage_type eq process_row_id)>selected</cfif>>#stage#</option>
							</cfloop>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
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
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='1469.Plan Tarihi'></cfsavecontent>
								<label class="col col-12"><cf_get_lang dictionary_id='1469.Plan Tarihi'></label>
								<div class="col col-12">
									<div class="input-group">
										<cfif xml_planning_date eq 1>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='605.Lütfen Ekip Tarihi Değerini Kontrol Ediniz'> !</cfsavecontent>
											<cfinput name="planning_date" id="planning_date" value="#dateformat(attributes.planning_date,dateformat_style)#" type="text" onChange="depot_date_change();" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:65px;">
										<cfelse>
											<input name="planning_date" id="planning_date" value="<cfif isdate(attributes.planning_date) and len(attributes.planning_date)>#dateformat(attributes.planning_date,dateformat_style)#</cfif>" type="text" onChange="depot_date_change();" validate="#validate_style#" maxlength="10" style="width:65px;">
										</cfif>
										<span class="input-group-addon"><cf_wrk_date_image date_field="planning_date"></span>
									</div>
								</div>
							</div>
							<script type="text/javascript">
								function depot_date_change()
								{
									if(document.form.planning_date.value != '')
									{
										var get_planning_info_js = wrk_safe_query('stk_get_planning_info','dsn3',0,js_date(document.form.planning_date.value));
										for(j=#get_planning_info.recordcount#;j>=0;j--)
											document.form.team_code.options[j] = null;
										
										document.form.team_code.options[0]= new Option('Ekip - Araç','');
										if(get_planning_info_js.recordcount)
											for(var jj=0;jj < get_planning_info_js.recordcount;jj++)
												document.form.team_code.options[jj+1]=new Option(get_planning_info_js.TEAM_CODE[jj],get_planning_info_js.PLANNING_ID[jj]);
									}
									return true;
								}
							</script>
							<div class="form-group" id="item-team_code">
								<cfsavecontent variable="header_"><cf_get_lang dictionary_id='1458.Ekip - Araç'></cfsavecontent>
								<label class="col col-12"><cf_get_lang dictionary_id='1469.Plan Tarihi'></label>
								<div class="col col-12">
									<select name="team_code" id="team_code" style="width:150px;">
										<option value=""><cf_get_lang dictionary_id='1458.Ekip - Araç'></option>
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
								<cfif isdefined("attributes.form_submitted")>
										<cfset is_submit = 1>
									<cfelse>
										<cfset is_submit = 0>
									</cfif>
									<cf_wrkdepartmentlocation 
										returnInputValue="department_name,department_id"
										returnQueryValue="LOCATION_NAME,DEPARTMENT_ID"
										fieldName="department_name"
										fieldid="location_id"
										department_fldId="department_id"
										department_id="#attributes.department_id#"
										location_name="#attributes.department_name#"
										user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
										is_submit="#is_submit#"
										width="100">
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-transport_comp_name">
							<label class="col col-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='57716.Taşıyıcı'></cfsavecontent>
									<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="#attributes.transport_comp_id#">
									<input type="text" name="transport_comp_name" id="transport_comp_name" value="#attributes.transport_comp_name#" style="width:130px;" onFocus="AutoComplete_Create('transport_comp_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','transport_comp_id','form','3','250');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form.transport_comp_id&field_comp_name=form.transport_comp_name&select_list=2','list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-ship_method_name">
							<label class="col col-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfsavecontent>
									<input type="hidden" name="ship_method_id" id="ship_method_id" value="#attributes.ship_method_id#">
									<input type="text" name="ship_method_name" id="ship_method_name" value="#attributes.ship_method_name#" style="width:100px;" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','form','3','100');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=form.ship_method_name&field_id=form.ship_method_id','list');"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-start_date">
							<label class="col col-12"><cfoutput>#getlang(330,'Tarih',57742)#</cfoutput></label>
							<div class="col col-12">
								<div class="input-group">
									<cfsavecontent variable="header_"><cfoutput>#getlang(330,'Tarih',57742)#</cfoutput></cfsavecontent>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
									<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									<span class="input-group-addon no-bg"></span>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
									<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">									
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
					</div>
				</cfoutput>                          
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(645,'Toplu',58057)# #getLang(313,'Sevkiyatlar',45490)#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='45458.Sevk No'></th>
					<cfif x_equipment_planning_info eq 1><th class="form-title"><cf_get_lang dictionary_id='58870.Ekip-Araç'></th></cfif>
					<th><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='45463.Depo Çıkış'></th>
					<th><cf_get_lang dictionary_id='45475.Teslim'></th>
					<th><cf_get_lang dictionary_id='57629.Aciklama'></th>
					<!-- sil --><th width="30" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.list_multi_packetship&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_ship_result.recordcount>
					<cfset process_list=''>
					<cfset Equipment_List = "">
					<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(get_ship_result.ship_stage) and not listfind(process_list,get_ship_result.ship_stage)>
							<cfset process_list = listappend(process_list,get_ship_result.ship_stage)>
						</cfif>
						<cfif x_equipment_planning_info eq 1 and Len(equipment_planning_id) and not ListFind(Equipment_List,equipment_planning_id)>
							<cfset Equipment_List = ListAppend(Equipment_List,equipment_planning_id)>
						</cfif>
					</cfoutput>
					<cfif len(process_list)>
						<cfset process_list=listsort(process_list,"numeric","ASC",",")>
						<cfquery name="get_process_type" datasource="#dsn#">
							SELECT STAGE,PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#)
						</cfquery>
						<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
					</cfif> 
					<cfif x_equipment_planning_info eq 1 and Len(Equipment_List)>
						<cfquery name="Get_Team_Zones" datasource="#dsn3#">
							SELECT PLANNING_ID,TEAM_CODE FROM DISPATCH_TEAM_PLANNING WHERE PLANNING_ID IN (#Equipment_List#) ORDER BY PLANNING_ID
						</cfquery>
						<cfset Equipment_List = ListSort(ListDeleteDuplicates(valuelist(Get_Team_Zones.Planning_Id,',')),'Numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="#request.self#?fuseaction=stock.list_multi_packetship&event=upd&main_ship_fis_no=#main_ship_fis_no#" class="tableyazi">#main_ship_fis_no#</a></td>
							<cfif x_equipment_planning_info eq 1><td>#Get_Team_Zones.Team_Code[ListFind(Equipment_List,equipment_planning_id,',')]#</td></cfif>
							<td>#ship_method#</td>
							<td>#get_process_type.stage[listfind(main_process_list,ship_stage,',')]#</td>
							<td>#dateformat(out_date,dateformat_style)#</td>
							<td>#dateformat(delivery_date,dateformat_style)#</td>
								<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#" maxrows="1">
									SELECT NOTE FROM SHIP_RESULT WHERE MAIN_SHIP_FIS_NO = '#main_ship_fis_no#' 
								</cfquery>
							<td><cfif get_ship_result_row.recordcount>#left(get_ship_result_row.note,30)#</cfif></td>
							<!-- sil --><td align="center"><a href="#request.self#?fuseaction=stock.list_multi_packetship&event=upd&main_ship_fis_no=#main_ship_fis_no#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="<cfif x_equipment_planning_info eq 1>9<cfelse>8</cfif>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str="stock.list_multi_packetship">
		<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
		<cfif len(attributes.document_number)><cfset url_str = "#url_str#&document_number=#attributes.document_number#"></cfif>
		<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
		<cfif len(attributes.ship_method)><cfset url_str = "#url_str#&ship_method=#attributes.ship_method#"></cfif>
		<cfif len(attributes.start_date)><cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#"></cfif>
		<cfif len(attributes.finish_date)><cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#"></cfif>
		<cfif isdefined("attributes.planning_date") and isdate(attributes.planning_date) and len(attributes.planning_date)><cfset url_str = "#url_str#&planning_date=#dateformat(attributes.planning_date,dateformat_style)#"></cfif>
		<cfif len(attributes.company_id)><cfset url_str = "#url_str#&company_id=#attributes.company_id#"></cfif>
		<cfif len(attributes.consumer_id)><cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#"></cfif>
		<cfif len(attributes.company)><cfset url_str = "#url_str#&company=#attributes.company#"></cfif>
		<cfif len(attributes.ship_method_id)><cfset url_str = "#url_str#&ship_method_id=#attributes.ship_method_id#"></cfif>
		<cfif len(attributes.ship_method_name)><cfset url_str = "#url_str#&ship_method_name=#attributes.ship_method_name#"></cfif>
		<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)><cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#"></cfif>
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)><cfset url_str = "#url_str#&department_id=#attributes.department_id#"></cfif>
		<cfif isdefined("attributes.department_name") and len(attributes.department_name)><cfset url_str = "#url_str#&department_name=#attributes.department_name#"></cfif>
		<cfif len(attributes.transport_comp_id)><cfset url_str = "#url_str#&transport_comp_id=#attributes.transport_comp_id#"></cfif>
		<cfif len(attributes.transport_comp_name)><cfset url_str = "#url_str#&transport_comp_name=#attributes.transport_comp_name#"></cfif>
		<cfif len(attributes.city_id)><cfset url_str = "#url_str#&city_id=#attributes.city_id#"></cfif>
		<cfif len(attributes.city)><cfset url_str = "#url_str#&city=#attributes.city#"></cfif>
		<cfif len(attributes.county)><cfset url_str = "#url_str#&county=#attributes.county#"></cfif>
		<cfif len(attributes.county_id)><cfset url_str = "#url_str#&county_id=#attributes.county_id#"></cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)><cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#"></cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function pencere_ac()
{
	if((form.city_id.value != "") && (form.city.value != ""))
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=form.county_id&field_name=form.county&city_id=' + document.form.city_id.value,'small');
	else
		alert("<cf_get_lang dictionary_id='45491.Lütfen İl Seçiniz'> !");
}
function kontrol()
	{
		if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!"))
			return false;
		else
			return true;	
	}
</script>
