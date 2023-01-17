<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="prod">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.position_code" default="">
<cfparam name="attributes.position_name" default="">
<cfparam name="attributes.stock_fis_status" default="">
<cfparam name="attributes.opplist" default="">

<cfquery name="GET_OPERATION" datasource="#dsn3#">
	select 
		OPERATION_TYPE_ID,
		OPERATION_TYPE
	from OPERATION_TYPES
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
	SELECT * FROM #dsn3_alias#.WORKSTATIONS WHERE ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) ORDER BY STATION_NAME ASC
</cfquery>
<cfif GET_W.recordcount><cfset authority_station_id_list = ValueList(GET_W.STATION_ID,',')><cfelse><cfset authority_station_id_list = 0></cfif>
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date=wrk_get_today() >
	</cfif>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',1,now())>
	</cfif>
</cfif>
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department" default="">
<cfif len(attributes.is_submitted)>
	<cfscript>
		get_prod_order_result_action = createObject("component", "AddOns.N1-Soft.textile.cfc.get_production_order_result");
        get_prod_order_result_action.dsn = dsn;
        get_prod_order_result_action.dsn3 = dsn3;
		get_prod_order_result_action.dsn_alias = dsn_alias;
		get_prod_order_result_action.dsn1_alias = dsn1_alias;
		get_po_det = get_prod_order_result_action.get_po_det_fnc(
			authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			spect_main_id : '#IIf(IsDefined("attributes.spect_main_id"),"attributes.spect_main_id",DE(""))#',
			spect_name : '#IIf(IsDefined("attributes.spect_name"),"attributes.spect_name",DE(""))#',
			process : '#IIf(IsDefined("attributes.process"),"attributes.process",DE(""))#',
			position_code : '#IIf(IsDefined("attributes.position_code"),"attributes.position_code",DE(""))#',
			position_name : '#IIf(IsDefined("attributes.position_name"),"attributes.position_name",DE(""))#',
			station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
			department : '#IIf(IsDefined("attributes.department"),"attributes.department",DE(""))#',
			department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
			product_cat : '#IIf(IsDefined("attributes.product_cat"),"attributes.product_cat",DE(""))#',
			hierarchy : '#IIf(IsDefined("attributes.hierarchy"),"attributes.hierarchy",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			start_date_result : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date_result : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			stock_fis_status : '#IIf(IsDefined("attributes.stock_fis_status"),"attributes.stock_fis_status",DE(""))#',
			opplist:attributes.opplist
		);
	</cfscript>
	<cfparam name="attributes.totalrecords" default='#get_po_det.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default='1'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfoutput>
#wrkUrlStrings('url_str','is_submitted','stock_fis_status','keyword','station_id','location_id','department','product_id','product_name','product_catid','product_cat','hierarchy','start_date','finish_date','position_code','position_name','project_id','project_head')#
</cfoutput>
<cfquery name="get_process" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.add_prod_order_result%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfform name="list_prod_order" action="#request.self#?fuseaction=textile.list_results" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1"/>
    <cf_big_list_search title="Üretim Sonuçları"> 
        <cf_big_list_search_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="30,50">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
                    <cf_object_tr id="form_ul_keyword" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='48.Filtre'></cf_object_td>
                        <cf_object_td>
                            <cfsavecontent variable="key_title"><img src=/images/help_desk_it.gif><br/><cf_get_lang no ='449.Sonuç No'> ,  <cf_get_lang_main no='1677.Emir No'> , <cf_get_lang_main no='799.Siparis No'> <cf_get_lang_main no="577.ve"> <cf_get_lang no ='385.Lot No'> <cf_get_lang no="188.Alanlarında Arama Yapabilirsiniz">!</cfsavecontent>
                            <cfinput type="text" name="keyword" id="keyword" onMouseOver="wrk_help(this.id,'#key_title#',70,200);" value="#attributes.keyword#" maxlength="50" style="width:120px;">
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
				<cf_object_table column_width_list="30">
					<cf_object_tr id="form_ul_op_id" Title="">
                        <cf_object_td>
					 <cf_multiselect_check
                              name="opplist"
                              query_name="get_operation"
                              option_name="OPERATION_TYPE"
                              option_value="OPERATION_TYPE_ID"
                              option_text="Operasyon Seç"
                              value="#attributes.opplist#">
						</cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="30">
                    <cfsavecontent variable="header_"><cf_get_lang no='58.Tüm İstasyonlar'></cfsavecontent>
                    <cf_object_tr id="form_ul_station_id" Title="#header_#">
                        <cf_object_td>
                            <select name="station_id" id="station_id" style="width:170px;">
                                <option value=""><cf_get_lang no='58.Tüm İstasyonlar'></option>
                                <cfoutput query="get_w">
                                	<option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
                                </cfoutput>
                            </select>                        
						</cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="30">
                    <cfsavecontent variable="header_"><cf_get_lang no='552.Stok Fişi'></cfsavecontent>
                    <cf_object_tr id="form_ul_stock_fis_status" Title="#header_#">
                        <cf_object_td>
                            <select name="stock_fis_status" id="stock_fis_status" style="width:105px;">
                                <option value=""><cf_get_lang no='552.Stok Fişi'></option>
                                <option value="1" <cfif attributes.stock_fis_status eq 1>selected</cfif>><cf_get_lang no='327.Oluşturulmuş'></option>
                                <option value="0" <cfif attributes.stock_fis_status eq 0>selected</cfif>><cf_get_lang no='328.Oluşturulmamış'></option>
                            </select>
						</cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="30">
                    <cfsavecontent variable="header_"><cf_get_lang no='552.Stok Fişi'></cfsavecontent>
                    <cf_object_tr id="form_ul_process" Title="#header_#">
                        <cf_object_td>
                            <select name="process" id="process" style="width:120px;">
                                <option value=""><cf_get_lang no ='564.Süreç Seçiniz'></option>
                                <cfoutput query="get_process">
                                    <option value="#PROCESS_ROW_ID#"<cfif isdefined('attributes.process') and attributes.process eq PROCESS_ROW_ID>selected</cfif>>#STAGE#</option>
                                </cfoutput>
                            </select>
						</cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cfsavecontent variable="header_">Başlangıç Tarihi</cfsavecontent>
                    <cf_object_tr id="form_ul_start_date" Title="#header_#">
                        <cf_object_td>
                            <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                <cfinput type="text" name="start_date" id="start_date" maxlength="10" validate="eurodate" style="width:65px;" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#">
                            <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='243.Başlama Tarihi'></cfsavecontent>
                                <cfinput type="text" name="start_date" id="start_date" required="Yes" message="#message#" maxlength="10"  validate="eurodate" style="width:65px;" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#">
                            </cfif>
                        	<cf_wrk_date_image date_field="start_date">
						</cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="100">
                    <cfsavecontent variable="header_">Bitiş Tarihi</cfsavecontent>
                    <cf_object_tr id="form_ul_finish_date" Title="#header_#">
                        <cf_object_td>
							<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#"  validate="eurodate" style="width:65px;">
                            <cfelse>
                                <cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
                                <cfinput type="text" name="finish_date" id="finish_date" required="Yes" message="#message#" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#"  validate="eurodate" style="width:65px;">
                            </cfif>
                        	<cf_wrk_date_image date_field="finish_date">
						</cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="80">
                    <cf_object_tr id="">
                        <cf_object_td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_search_button search_function="kontrol()">
                            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
            </cf_object_main_table>
        </cf_big_list_search_area>
        <cf_big_list_search_detail_area>
            <cf_object_main_table>
                <cf_object_table column_width_list="50,175">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='4.Proje'></cfsavecontent>
                    <cf_object_tr id="form_ul_project_head" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='4.Proje'></cf_object_td>
                        <cf_object_td>
							<cfif isdefined('attributes.project_head') and len(attributes.project_head)>
                                <cfset project_id_ = #attributes.project_id#>
                            <cfelse>
                                <cfset project_id_ = ''>
                            </cfif>
                            <cf_wrkProject
                                project_Id="#project_id_#"
                                width="150"
                                AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
                                boxwidth="600"
                                boxheight="400">
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang_main no='132.Sorumlu'></cfsavecontent>
                    <cf_object_tr id="form_ul_position_name" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='132.Sorumlu'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
                            <input type="text" name="position_name" id="position_name" style="width:150px;" value="<cfif len(attributes.position_code) and len(attributes.position_name)><cfoutput>#attributes.position_name#</cfoutput></cfif>" maxlength="50" onFocus="AutoComplete_Create('position_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','position_code','','3','135');" autocomplete="off">
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_prod_order.position_code&field_name=list_prod_order.position_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.list_prod_order.position_name.value),'list');"><img src="/images/plus_thin.gif" ></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="50,175">
                    <cfsavecontent variable="header_"><cf_get_lang_main no='1351.Depo'></cfsavecontent>
                    <cf_object_tr id="form_ul_department" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='1351.Depo'></cf_object_td>
                        <cf_object_td>
                            <cf_wrkdepartmentlocation 
                                returnInputValue="location_id,department,department_id"
                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                fieldName="department"
                                fieldid="location_id"
                                department_fldId="department_id"
                                department_id="#attributes.department_id#"
                                location_name="#attributes.department#"
                                location_id="#attributes.location_id#"
                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                width="150">
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_"><cf_get_lang_main no='245.Ürün'></cfsavecontent>
                    <cf_object_tr id="form_ul_product_name" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no='245.Ürün'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                            <input name="product_name" type="text"  id="product_name" style="width:150px;"  onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product','0','PRODUCT_ID','product_id','list_prod_order','3','250');" value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" autocomplete="off">
                            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=list_prod_order.product_id&field_name=list_prod_order.product_name&keyword='+encodeURIComponent(document.list_prod_order.product_name.value),'list');"><img src="/images/plus_thin.gif"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
                <cf_object_table column_width_list="50,175">
                    <cfsavecontent variable="header_"><cf_get_lang_main no ='74.Kategori'></cfsavecontent>
                    <cf_object_tr id="form_ul_product_cat" Title="#header_#">
                        <cf_object_td type="text"><cf_get_lang_main no ='74.Kategori'></cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="hierarchy" id="hierarchy" value="<cfoutput>#attributes.hierarchy#</cfoutput>">
                            <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                            <cfinput type="text" name="product_cat" id="product_cat" style="width:150px;" value="#attributes.product_cat#" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,hierarchy','list_prod_order','3','175');">
                            <a href="javascript://"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=list_prod_order.product_catid&is_sub_category=1&field_name=list_prod_order.product_cat&field_hierarchy=list_prod_order.hierarchy','list');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='1684.Kategori Ekle'>"></a>
                        </cf_object_td>
                    </cf_object_tr>
                    <cfsavecontent variable="header_">Spec</cfsavecontent>
                    <cf_object_tr id="form_ul_spect_name" Title="#header_#">
                        <cf_object_td type="text">Spec</cf_object_td>
                        <cf_object_td>
                            <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfif isdefined('attributes.spect_main_id') and len(attributes.spect_main_id)><cfoutput>#attributes.spect_main_id#</cfoutput></cfif>">
                            <input type="text" name="spect_name" id="spect_name" style="width:150px;" value="<cfif isdefined('attributes.spect_name') and len(attributes.spect_name)><cfoutput>#attributes.spect_name#</cfoutput></cfif>">
                            <a href="javascript://" onClick="product_control();"><img src="/images/plus_thin.gif" align="top" border="0"></a>
                        </cf_object_td>
                    </cf_object_tr>
                </cf_object_table>
			</cf_object_main_table>                
        </cf_big_list_search_detail_area>
    </cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<th width="55"><cf_get_lang no ='449.Sonuç No'></th>
			<th width="55">Operasyon No</th>
			<th width="55">Parti Emir No</th>
			<th width="55"><cf_get_lang_main no='799.Siparis No'></th>
			<th width="55">Proje No</th>
			<th width="55"><cf_get_lang no ='385.Lot No'></th>
			<th><cf_get_lang_main no='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='245.Ürün'></th>
			<th width="55" ><cf_get_lang_main no='235.spec'></th>
			<th width="125"><cf_get_lang_main no ='344.Süreç'></th>
			<th width="125"><cf_get_lang_main no='1422.İstasyon'></th>
			<th width="185"><cf_get_lang no ='566.Emir Tarihi'></th>
			<th width="88"><cf_get_lang no ='567.Sonuç Tarihi'></th>
			<th width="50" style="text-align:right;"><cf_get_lang no ='343.Emir'></th>  
			<th width="50" style="text-align:right;"><cf_get_lang_main no ='272.Sonuç'></th>  
			<!-- sil --><th class="header_icn_none"></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif len(attributes.is_submitted)>
			<cfif get_po_det.recordcount>
				<cfset production_order_value_list = ''>
				<cfset station_id_list = ''>
				<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset production_order_value_list = listappend(production_order_value_list,p_order_id,',')>
					<cfif len(station_id) and not listfind(station_id_list,station_id)>
						<cfset station_id_list=listappend(station_id_list,station_id)>
					</cfif>	
				</cfoutput>
				<cfif len(station_id_list)>
					<cfset station_id_list=listsort(station_id_list,"numeric","ASC",",")>
					<cfquery name="get_station" datasource="#DSN3#">
						SELECT
							W.STATION_NAME,
							W.STATION_ID
						FROM 
							WORKSTATIONS W
						WHERE
							W.STATION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#station_id_list#" list="yes">)
						ORDER BY
							W.STATION_ID
					</cfquery>
					<cfset station_id_list = listsort(listdeleteduplicates(valuelist(get_station.STATION_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfquery name="GET_TOTAL" datasource="#dsn3#">
						SELECT SUM(AMOUNT) AS TOPLAM FROM PRODUCTION_ORDER_RESULTS_ROW WHERE TYPE = 1 AND PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pr_order_id#">
					</cfquery>
					<tr>
						<td>#currentrow#</td>
						<td><a href="#request.self#?fuseaction=textile.list_results&event=upd&party_id=#party_id#&pr_order_id=#pr_order_id#" class="tableyazi">#result_no#</a></td>
						<td><a href="#request.self#?fuseaction=textile.order&event=upd&party_id=#party_id#"class="tableyazi">#production_order_no#</a></td>
						<td><a href="#request.self#?fuseaction=textile.order&event=upd&party_id=#party_id#"class="tableyazi">#party_no#</a></td>
						<td>#order_no#</td>
						<td>#project_head#</td>
						<td>#LOT_NO#</td>
						<td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#" class="tableyazi">#STOCK_CODE#</a></td>
						<td><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#PRODUCT_ID#&sid=#STOCK_ID#" class="tableyazi">#get_product_name(stock_id:stock_id)# #property#</a></td>
						<td>#spec_main_id#</td>
						<td>#stage#</td>
						<td>
							<cfif len(station_id) and len(get_station.STATION_NAME[listfind(station_id_list,station_id,',')])>
								#get_station.STATION_NAME[listfind(station_id_list,station_id,',')]#
							</cfif>
						</td>
						<td>#dateformat(start_date,'dd/mm/yyyy')# #timeformat(start_date,'HH:MM')# - #dateformat(finish_date,'dd/mm/yyyy')# #timeformat(finish_date,'HH:MM')#</td>
						<td>#dateformat(result_finish_date,'dd/mm/yyyy')# #timeformat(result_finish_date,'HH:MM')#</td>
						<td style="text-align:right;">#quantity#</td>
						<td style="text-align:right;">#get_total.toplam#</td>
						<!-- sil --><td width="15"><a href="#request.self#?fuseaction=textile.list_results&event=upd&party_id=#party_id#&pr_order_id=#pr_order_id#"><i class="fa fa-edit fa-2x" title="Güncelle"></i></a></td><!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="15"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		<cfelse>
			<tr>
				<td colspan="15"><cf_get_lang_main no ='289.Filtre Ediniz'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="prod.list_results_tex#url_str#">
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
	{
		if(!date_check (document.getElementById('start_date'),document.getElementById('finish_date'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Önce Olamaz'>!"))
			return false;
		else
			return true;	
	}
function product_control(){/*Ürün seçmeden spec seçemesin.*/
	if(document.getElementById('product_id').value=="" || document.getElementById('product_name').value == "" ){
		alert("<cf_get_lang no ='515.Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir'>");
		return false;
	}
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=list_prod_order.spect_main_id&field_name=list_prod_order.spect_name&is_display=1&product_id='+document.getElementById('product_id').value,'list');
}	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->