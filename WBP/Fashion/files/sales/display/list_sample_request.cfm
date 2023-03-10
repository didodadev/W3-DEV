

<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">
<cf_xml_page_edit fuseact ="sales.list_opportunity" default_value="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_oppno" default="">
<cfparam name="attributes.keyword_detail" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif not isdefined("attributes.opp_status") and not isDefined('attributes.is_filtre')><cfset attributes.opp_status = 1></cfif>
<cfparam name="attributes.ordertype" default="2">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.order_no" default="">
<cfparam name="attributes.model_no" default="">

<cfif not isdefined("attributes.sales_emp_id") and isdefined("attributes.is_filtre") neq 1 and is_show_sales_emp eq 1>
	<cfset attributes.sales_emp_id = "#session.ep.userid#">
<cfelse>
	<cfparam name="attributes.sales_emp_id" default="">
</cfif>
<cfif not isdefined("attributes.sales_emp") and isdefined("attributes.is_filtre") neq 1 and is_show_sales_emp eq 1>
	<cfset attributes.sales_emp = "#session.ep.name# #session.ep.surname#">
<cfelse>
	<cfparam name="attributes.sales_emp" default="">
</cfif>
<cfparam name="attributes.sales_member_id" default="">

<cfparam name="attributes.sales_member_type" default="">
<cfparam name="attributes.sales_member_name" default="">
<cfparam name="attributes.record_employee_id" default="">
<cfparam name="attributes.record_employee" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.opportunity_type_id" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.stock_name" default="">
<cfparam name="attributes.sale_add_option" default="">
<cfparam name="attributes.probability" default="">
<cfparam name="attributes.opp_currency_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<!----<cfinclude template="/V16/sales/query/get_probability_rate.cfm">--->
<cfinclude template="/V16/sales/query/get_opp_currencies.cfm">
<!---<cfinclude template="/V16/sales/query/get_sale_add_option.cfm">--->
<cfif isdefined("attributes.is_filtre")>
  <cfinclude template="../query/get_reqs.cfm">
<cfelse>
  <cfset GET_SAMPLE_REQ.recordcount = 0>
</cfif>
<cfobject name="operation_process" component="WBP.Fashion.files.cfc.operation_process">
<cfset query_oplist = operation_process.getOperationCustomOrder()>
<cfquery name="get_process_color" datasource="#dsn#">
     SELECT * FROM SAMPLE_REQ_PROCESS_COLOR
</cfquery>
<cfset colorlist=valueList(get_process_color.color)>
<cfset colorprocesslist=valueList(get_process_color.process_row_id)>
<cfquery name="get_process_type" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_sample_request%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_SAMPLE_REQ.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif GET_SAMPLE_REQ.recordcount gt 0>
    <cfobject name="operation_process" component="WBP.Fashion.files.cfc.operation_process">
    <cfset operation_process.dsn3 = dsn3>
    <cfset sample_request_ids = arrayToList( arraySlice( valueArray(GET_SAMPLE_REQ, "REQ_ID"), attributes.startrow, min(attributes.maxrows, max(attributes.totalrecords - attributes.startrow, 1) ) ) )>
    <cfset query_opmain = operation_process.getOperationMain( sample_request_ids = iif( len(sample_request_ids), de(sample_request_ids), de(0) ) )>
</cfif>
<cfoutput>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_opportunities" action="#request.self#?fuseaction=textile.list_sample_request" method="post">
            <input type="hidden" name="is_filtre" id="is_filtre" value="1" />
            <cf_box_search plus="0">
                <div class="form-group small">
                    <cfinput type="text" name="keyword_oppno" value="#attributes.keyword_oppno#" placeholder="#getLang('','no','57487')#">
                </div>
                <div class="form-group medium" id="form_ul_process_stage">
                    <cf_multiselect_check
                        name="process_stage"
                        query_name="get_process_type"
                        option_name="stage"
                        option_value="process_row_id"
                        option_text="#getLang('','S??re??','58859')#"
                        value="#attributes.process_stage#">
                </div>
                <div class="form-group" id="form_ul_opp_status">
                    <select name="opp_status" id="opp_status">
                        <option value=""><cf_get_lang dictionary_id='58081.Hepsi'>
                        <option value="1"<cfif isdefined("attributes.opp_status") and attributes.opp_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        <option value="0"<cfif isdefined("attributes.opp_status") and attributes.opp_status eq 0> selected</cfif>><cf_get_lang dictionary_id="57494.Pasif">
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#"  maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray2" href="<cfoutput>#request.self#</cfoutput>?fuseaction=textile.sample_dashboard"><i class="fa fa-bar-chart fa-2x" aria-hidden="true"></i></a>
                </div> 
                <div class="form-group" id="item-submit">    
                    <a href="<cfoutput>#request.self#?fuseaction=textile.list_sample_request&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="form_ul_opportunity_type_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-12">
                            <cf_multiselect_check
                                name="opportunity_type_id"
                                data_source="#DSN3#"
                                option_name="OPPORTUNITY_TYPE"
                                option_value="OPPORTUNITY_TYPE_ID"
                                table_name="SETUP_OPPORTUNITY_TYPE"
                                value="#attributes.opportunity_type_id#">
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_sales_emp">
                        <label class="col col-12"><cf_get_lang dictionary_id ='58795.M????teri Temsilcisi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="sales_emp_id"  id="sales_emp_id" value="<cfif len(attributes.sales_emp) and len(attributes.sales_emp_id)>#attributes.sales_emp_id#</cfif>">
                                <input name="sales_emp" type="text" id="sales_emp" onfocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','135');" value="<cfif len(attributes.sales_emp) and len(attributes.sales_emp_id)>#get_emp_info(attributes.sales_emp_id,0,0)#</cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_opportunities.sales_emp_id&field_name=list_opportunities.sales_emp&select_list=1');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_member_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57457.M????teri'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
                                <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
                                <input type="hidden" name="member_type" id="member_type" value="<cfif len(attributes.member_type)>#attributes.member_type#</cfif>">
                                <input name="member_name" type="text" id="member_name"  style="width:110px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif len(attributes.member_name)>#attributes.member_name#</cfif>" autocomplete="off" />
                                <cfset str_linke_ait="&field_consumer=list_opportunities.consumer_id&field_comp_id=list_opportunities.company_id&field_member_name=list_opportunities.member_name&field_type=list_opportunities.member_type">
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars#str_linke_ait#&is_period_kontrol=0&select_list=7,8&keyword='+encodeURIComponent(document.list_opportunities.member_name.value));"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="form_ul_start_date">
                        <label class="col col-12"><cfoutput>#getLang('','Ba??lang???? tarihi','58053')#</cfoutput></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih De??erini Kontrol Ediniz !'></cfsavecontent>
                                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_finish_date">
                        <label class="col col-12"><cfoutput>#getLang('','','57700')#</cfoutput></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih De??erini Kontrol Ediniz !'></cfsavecontent>
                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_stock_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='57657.??r??n'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_name)>value="#attributes.stock_id#"</cfif>>
                                <input name="stock_name" type="text" id="stock_name" onfocus="AutoComplete_Create('stock_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','list_opportunities','3','200');" value="<cfif len(attributes.stock_id) and len(attributes.stock_name)>#attributes.stock_name#</cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&field_id=list_opportunities.stock_id&field_name=list_opportunities.stock_name');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="form_ul_project_head">
                        <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                <input type="text" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_ordertype">
                        <label class="col col-12"><cfoutput>#getLang('','s??ralama','58924')#</cfoutput></label>
                        <div class="col col-12">
                            <select name="ordertype" id="ordertype">
                                <option value="1" <cfif attributes.ordertype eq 1>selected</cfif>><cf_get_lang dictionary_id='62570.Numune Tarihine G??re Artan'></option>
                                <option value="2" <cfif attributes.ordertype eq 2>selected</cfif>><cf_get_lang dictionary_id='62571.Numune Tarihine G??re Azalan'></option>
                                <option value="3" <cfif attributes.ordertype eq 3>selected</cfif>><cf_get_lang dictionary_id='58050.Son G??ncelleme'></option>
                                <option value="4" <cfif attributes.ordertype eq 4>selected</cfif>><cf_get_lang dictionary_id='34929.Takipler'></option>
                                <option value="5" <cfif attributes.ordertype eq 5>selected</cfif>><cf_get_lang dictionary_id='40918.G??revliye G??re Artan'></option>
                                <option value="6" <cfif attributes.ordertype eq 6>selected</cfif>><cf_get_lang dictionary_id='40920.G??revliye G??re Azalan'></option>
                                <option value="7" <cfif attributes.ordertype eq 7>selected</cfif>><cf_get_lang dictionary_id='40921.Projeye G??re Artan'></option>
                                <option value="8" <cfif attributes.ordertype eq 8>selected</cfif>><cf_get_lang dictionary_id='40925.Projeye G??re Azalan'></option>
                                <option value="9" <cfif attributes.ordertype eq 9>selected</cfif>><cf_get_lang dictionary_id='62572.Numune Numaras??na G??re Artan'></option>
                                <option value="10" <cfif attributes.ordertype eq 10>selected</cfif>><cf_get_lang dictionary_id='62573.Numune Numaras??na G??re Azalan'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="form_ul_product_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='29401.??r??n Kategorisi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
                                <input name="product_cat" type="text" id="product_cat" onfocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" value="<cfif len(attributes.product_cat)>#attributes.product_cat#</cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_opportunities.product_cat_id&field_name=list_opportunities.product_cat');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="form_ul_record_employee">
                            <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="record_employee_id" id="record_employee_id" value="<cfif Len(attributes.record_employee)>#attributes.record_employee_id#</cfif>">
                                    <input type="text" name="record_employee" id="record_employee"  value="<cfif Len(attributes.record_employee)>#attributes.record_employee#</cfif>" style="width:110px;" onfocus="AutoComplete_Create('record_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_employee_id','','3','125');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=list_opportunities.record_employee_id&field_name=list_opportunities.record_employee&select_list=1,9&branch_related')"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="form-order_no">
                            <label class="col col-12"><cf_get_lang dictionary_id='62561.M????teri Order No'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <cfinput type="text" name="order_no" id="order_no" value="#attributes.order_no#" placeholder="#getLang('','Order no','33024')# ">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="form-model_no">
                            <label class="col col-12"><cf_get_lang dictionary_id='62569.M????teri Model No'></label>
                            <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="text" name="model_no" id="model_no" value="#attributes.model_no#" placeholder="#getLang('','M????teri Model No','62569')# ">
                            </div>
                        </div>
                    </div>
                        <div class="form-group" id="form-is_detail_stage">
                            <div class="col col-12">
                                <div class="input-group">
                                    <label class="col col-12"><cf_get_lang dictionary_id='62622.A??ama Renklendir'><input type="checkbox" <cfif isdefined("attributes.is_detail_stage")>checked</cfif> name="is_detail_stage" id="is_detail_stage" value=""></label>
                                </div>
                            </div>
                        </div>
                    </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
</div>
</cfoutput>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='58225.Model'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box uidrop="1" title="#message#">
<cf_grid_list>
    <thead>
        <tr>
            <th width="35"><cf_get_lang dictionary_id='58577.S??ra'></th>
            <th ><a href="javascript://"><i class="fa fa-file-image-o" title="<cf_get_lang dictionary_id ='44564.??n ??zleme'>" alt="<cf_get_lang dictionary_id ='44564.??n ??zleme'>"></i></a></th>
            <th title="<cf_get_lang dictionary_id='57742.Tarih'>"><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th title="<cf_get_lang dictionary_id='57231.Teslim'>"><cf_get_lang dictionary_id='57231.Teslim'></th>
			<th title="<cf_get_lang dictionary_id='57416.Proje'>"><cf_get_lang dictionary_id='57416.Proje'></th>
			<th title="<cf_get_lang dictionary_id='57486.Kategori'>"><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th title="<cf_get_lang dictionary_id='62620.Model No'>"><cf_get_lang dictionary_id='62620.Model No'></th>
			<th title="<cf_get_lang dictionary_id='58847.Marka'>"><cf_get_lang dictionary_id='58847.Marka'></th>
            <th width="120"><cf_get_lang dictionary_id='57457.M????teri'></th>
            <th width="120"><cf_get_lang dictionary_id ='58795.M????teri Temsilcisi'></th>
			<th title="<cf_get_lang dictionary_id='62561.M????teri Order No'>"><cf_get_lang dictionary_id='62561.M????teri Order No'></th>
			<th class="drag-enable" width="120"><cf_get_lang dictionary_id='58859.S??re??'>/<cf_get_lang dictionary_id='57482.A??ama'></th>
            <cfif isdefined("attributes.is_detail_stage")>
                <th title="<cf_get_lang dictionary_id='41259.Kuma?? Fiyat Talepleri'>"><cf_get_lang dictionary_id='41259.Kuma?? Fiyat Talepleri'></th>
                <th title="<cf_get_lang dictionary_id='41260.Aksesuar Fiyat Talepleri'>"><cf_get_lang dictionary_id='41260.Aksesuar Fiyat Talepleri'></th>
                <th title="<cf_get_lang dictionary_id='41269.Modelhane ????lemleri'>"><cf_get_lang dictionary_id='41269.Modelhane ????lemleri'></th>
                <th title="<cf_get_lang dictionary_id='41264.??????ilik Fiyat Talepleri'>"><cf_get_lang dictionary_id='41264.??????ilik Fiyat Talepleri'></th>
                <th title="<cf_get_lang dictionary_id='62694.Y??kama Fiyat Talepleri'>"><cf_get_lang dictionary_id='62694.Y??kama Fiyat Talepleri'></th>
                <th title="<cf_get_lang dictionary_id='62693.Kesim Operasyonu'>"><cf_get_lang dictionary_id='62693.Kesim Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62692.Nak???? Operasyonu'>"><cf_get_lang dictionary_id='62692.Nak???? Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62691.Bask?? Operasyonu'>"><cf_get_lang dictionary_id='62691.Bask?? Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62695.Dikim Operasyonu'>"><cf_get_lang dictionary_id='62695.Dikim Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62696.Y??kama Operasyonu'>"><cf_get_lang dictionary_id='62696.Y??kama Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62697.Numune ??t?? - Paket Operasyonu'>"><cf_get_lang dictionary_id='62697.Numune ??t?? - Paket Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62698.??retim ??t?? - Paket Operasyonu'>"><cf_get_lang dictionary_id='62698.??retim ??t?? - Paket Operasyonu'></th>
                <th title="<cf_get_lang dictionary_id='62699.Sevkiyat Operasyonu'>"><cf_get_lang dictionary_id='62699.Sevkiyat Operasyonu'></th>
            </cfif>
            <th title="<cf_get_lang dictionary_id='58515.Aktif / Pasif'>"><cf_get_lang dictionary_id='30111.Durumu'></th>
            <cfif x_update_date eq 1>
                <th><cf_get_lang dictionary_id='32449.G??ncelleme Tarihi'></th>
            </cfif>
            <th title="<cf_get_lang dictionary_id='38272.Kanban'>"><cf_get_lang dictionary_id='38272.Kanban'></th>
            <th title="<cf_get_lang dictionary_id='42103.??r??n A??ac??'>"><cf_get_lang dictionary_id='42103.??r??n A??ac??'></th>
            <th title="<cf_get_lang dictionary_id='33920.Konfig??rat??r'>"><cf_get_lang dictionary_id='33920.Konfig??rat??r'></th>
            <th title="<cf_get_lang dictionary_id='47241.??retim Sipari??leri'>"><cf_get_lang dictionary_id='47241.??retim Sipari??leri'></th>
            <th title="<cf_get_lang dictionary_id='60068.Kritik'>"><cf_get_lang dictionary_id='60068.Kritik'></th>
            <th title="<cf_get_lang dictionary_id='57582.Ekle'>" ><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=textile.list_sample_request&event=add"><img src="/images/plus_list.gif"></a></th>
        </tr>
    </thead>
    <tbody>
        <cfset url_="">
        <cfset url_ = "#file_web_path#product/">
        <cfset uploadFolder = application.systemParam.systemParam().upload_folder />
        <cfset path = "#upload_folder#product#dir_seperator#">
        <cfif GET_SAMPLE_REQ.recordcount>
            <cfoutput query="GET_SAMPLE_REQ" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
				<!-- sil
                    <td align="center" id="opportunity_plus#currentrow#" class="color-row" onclick="gizle_goster(opportunity_plus_detail#currentrow#);connectAjax('#currentrow#','#company_id#','#project_id#');gizle_goster(opportunity_plus_goster#currentrow#);gizle_goster(opportunity_plus_gizle#currentrow#);">
                            <i id="opportunity_plus_goster#currentrow#" class="fa fa-chevron-circle-right fa-2x" title="G??ster"></i>    
                            <i id="opportunity_plus_gizle#currentrow#" class="fa fa-chevron-circle-down fa-2x" title="Gizle" style="display:none"></i>
                    </td>
                <!-- sil -->
                <td>#currentrow#</td>
                <td align="center">
                    <cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
                        SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> ORDER BY PRODUCT_ID
                    </cfquery>
                    
					<!---Necip MENEK??E 10.07.2019--->
                  
                        <cfif not  len(get_product_images.path)>
                            <i class="fa fa-file-image-o" src="/documents/product/#get_product_images.path#"  class="img-thumbnail" title="<cf_get_lang dictionary_id ='44564.??n ??zleme'>" alt="<cf_get_lang dictionary_id ='44564.??n ??zleme'>"></i>
                        <cfelse>
                            <font Color = "44b6ae"a href="javascript://" class="list_chapter_item_img" onclick="windowopen('/documents/product/#get_product_images.path#','page');" width="500" height="450"  >
                              <!---   <cfloop index="i" from="1" to="5">  ---> 
                                     <i  class="fa fa-file-image-o" src="/documents/product/#get_product_images.path#" width="??100" height="%100"  class="img-thumbnail" title="<cf_get_lang dictionary_id ='44564.??n ??zleme'>" alt="<cf_get_lang dictionary_id ='44564.??n ??zleme'>"></i>
                                <!---  </cfloop> --->
                            </a>
                        </cfif>
                   
					<!---Necip MENEK??E 10.07.2019--->
                </td>
                    <td height="20">
                        <cfif attributes.ordertype eq 4>
                            #dateformat(date_add('h',session.ep.time_zone,plus_date),dateformat_style)#
                        <cfelse>
                            <cfif len(req_date)>
                                #dateformat(date_add('h',session.ep.time_zone,req_date),dateformat_style)#
                            <cfelse>
                                #dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#
                            </cfif>
                        </cfif>
                    </td>
                    <td><cfif len(invoice_date)>#dateformat(date_add('h',session.ep.time_zone,invoice_date),dateformat_style)#</cfif></td>
					<td><cfif isdefined("GET_SAMPLE_REQ.project_id") and len(GET_SAMPLE_REQ.project_id)>
                            <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#project_head#</a>
                        <cfelse>
                            <cf_get_lang dictionary_id='58459.projesiz'>
                        </cfif>
                    </td>
					<td><cfif len(opportunity_type_id)>#OPPORTUNITY_TYPE#</cfif></td>
                    <td><a href="#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#req_id#&opp_no=#req_no#" class="tableyazi">#req_no#</a></td>
					<td>#SHORT_CODE#</td>
                    <td><cfif len(partner_id)>
                            #FULLNAME# - #PARTNER_NAME_SURNAME#
                        <cfelseif len(consumer_id)>
                            #CONSUMER_NAME#
                        </cfif>
                    </td>
                    <td>#EMPLOYEES_NAME#</td>
				   	<td>#COMPANY_ORDER_NO#</td>
					<td><cfif len(req_stage)>#STAGE#</cfif>	</td>
                 <cfif isdefined("attributes.is_detail_stage")>
                    <td style="text-align: center;"><span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; <cfif len(fabric_stage) and fabric_stage gt 0>background-color:#ListGetAt(colorlist,ListFind(colorprocesslist,fabric_stage) or 1)#</cfif>">&nbsp;</span></td>
                    <td style="text-align: center;"><span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; <cfif len(ACCESSORY_STAGE)>background-color:#ListGetAt(colorlist,ListFind(colorprocesslist,ACCESSORY_STAGE) or 1)#</cfif>">&nbsp;</span></td>
                    <td style="text-align: center;"><span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; <cfif len(PATTERN_STAGE)>background-color:#ListGetAt(colorlist,ListFind(colorprocesslist,PATTERN_STAGE) or 1)#</cfif>">&nbsp;</span></td>
                    <td style="text-align: center;"><span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; <cfif len(WORKSHIP_STAGE)>background-color:#ListGetAt(colorlist,ListFind(colorprocesslist,WORKSHIP_STAGE) or 1)#</cfif>">&nbsp;</span></td>
                    <td style="text-align: center;"><span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; <cfif len(WASH_STAGE)>background-color:#ListGetAt(colorlist,ListFind(colorprocesslist,WASH_STAGE) or 1)#</cfif>">&nbsp;</span></td>
                    <cfloop query="query_oplist">
                        <cfquery name="query_filtered_opmain" dbtype="query">
                            SELECT * FROM query_opmain WHERE REQ_ID = #GET_SAMPLE_REQ.req_id# AND OPERATION_TYPE_ID = #query_oplist.OPERATION_TYPE_ID#
                        </cfquery>
                        <td style="text-align: center;">
                            <cfif query_filtered_opmain.recordCount gt 0>
                            <cfset gerceklesen_op_miktar = query_filtered_opmain.amount>
                            <cfset kalan_miktar = query_filtered_opmain.amount - query_filtered_opmain.result_amount>
                            <cfif gerceklesen_op_miktar gt 0 and kalan_miktar lte 0>
                                <span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; background-color: ##80ff00;" title="????lem Bitti">&nbsp;</span>
                            <cfelseif gerceklesen_op_miktar eq 0>
                                <span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; background-color: red;" title="????lem Ba??lamad??">&nbsp;</span> 
                            <cfelseif gerceklesen_op_miktar gt 0 and kalan_miktar gt 0>
                                <span style="display: inline-block; width: 25px; height: 25px; border-radius: 50%; background-color: blue;" title="????lem Devam">&nbsp;</span>
                            </cfif> 
                            </cfif>
                        </td>
                    </cfloop>
                 </cfif>
                    <td><cfif req_status>Aktif<cfelse>Pasif</cfif></td>
                    <cfif x_update_date eq 1>
                        <td>#dateformat(UPDATE_DATE,dateformat_style)#</td>
                    </cfif>
                    <td><a href="javascript://" onclick="window.open('#request.self#?fuseaction=project.projects&event=kanban&id=#project_id#','page');"><i class="fa fa-flag fa-lg" title="Kanban"></i></a></td>
                    <td align="center">
					<cf_authcontent prcid="1310">
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=textile.product_tree&pid=#product_id#&req_id=#req_id#','page')"><i class="fa fa-tree fa-lg"></i></a>
                    </cf_authcontent>
                    </td>
                    <td align="center">
                        <cf_authcontent prcid="1309">
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=textile.list_sample_request&event=config&req_id=#req_id#','page')"><i class="fa wrk-uF0026 fa-lg"></i></a>
                        </cf_authcontent>
                    </td>
                    <td>
                        <cf_authcontent prcid="1312">
                        <form method="post" target="_blank" action="/index.cfm?fuseaction=textile.tracking">
                            <input type="hidden" name="project_id" value="#project_id#">
                            <input type="hidden" name="project_head" value="#project_head#">
                            <input type="hidden" name="durum_siparis" value="">
                            <input type="hidden" name="is_submitted" value="1">
                            <a href="javascript:void(0)" onclick="$(this).closest('form').submit()"><i class="fa fa-cubes fa-2x" aria-hidden="true" title="??retim Sipari??leri Listesi"></i></a>
                        </form>
                        </cf_authcontent>
                    </td>
                    <td align="center">
                        <cf_authcontent prcid="1324">
                        <a href="index.cfm?fuseaction=textile.list_sample_request&event=critics&req_id=#req_id#"><i class="fa fa-comment fa-lg"></i></a>
                        </cf_authcontent>
                    </td>
                    <td align="center"><a href="#request.self#?fuseaction=textile.list_sample_request&event=det&req_id=#req_id#&req_no=#req_no#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.G??ncelle'>"></a></td>
                </tr>
                <tr id="opportunity_plus_detail#currentrow#" class="nohover" style="display:none">
                    <cfquery name="get_opportunity_pluses" datasource="#dsn3#">
                        SELECT OPP_ID,PLUS_CONTENT FROM OPPORTUNITIES_PLUS WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#req_id#"> ORDER BY RECORD_DATE DESC
                    </cfquery>
                    <cfif get_opportunity_pluses.recordcount>
                        <cfset height = 113>
                    <cfelseif get_opportunity_pluses.recordcount and not len(get_opportunity_pluses.plus_content)>
                        <cfset height = 94>
                    <cfelse>
                        <cfset height = 45>
                    </cfif>
                    <td colspan="16">
                        <div align="left" style="height:#height#;overflow:auto;" id="DISPLAY_OPP_PLUS_INFO#currentrow#"></div>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td <cfif x_update_date eq 1>colspan="19"<cfelse>colspan="19"</cfif>><cfif isdefined("attributes.is_filtre")><cf_get_lang dictionary_id='57484.Kay??t Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_grid_list>

<cfset url_str = "&is_filtre=1">
<cfif GET_SAMPLE_REQ.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="3">
				<cfif len(attributes.keyword)>
					<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
				</cfif>
                <cfif len(attributes.keyword_detail)>
					<cfset url_str = "#url_str#&keyword_detail=#attributes.keyword_detail#">
				</cfif>
                <cfif len(attributes.keyword_oppno)>
					<cfset url_str = "#url_str#&keyword_oppno=#attributes.keyword_oppno#">
				</cfif>
				<cfif isdate(attributes.start_date)>
					<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#" >
				</cfif>
				<cfif isdate(attributes.finish_date)>
					<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#" >
				</cfif>
				<cfif isdefined("attributes.opp_status") and Len(attributes.opp_status)>
					<cfset url_str = "#url_str#&opp_status=#attributes.opp_status#">
				</cfif>
				<cfif len(attributes.ordertype)>
					<cfset url_str = "#url_str#&ordertype=#attributes.ordertype#">
				</cfif>
				<cfif len(attributes.member_type) and len(attributes.member_name)>
					<cfset url_str = "#url_str#&member_type=#attributes.member_type#&member_name=#attributes.member_name#">
				<cfif len(attributes.company_id)>
					<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
				<cfelse>
					<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
				</cfif>
				</cfif>
				<cfif len(attributes.sales_emp_id) and len(attributes.sales_emp)>
					<cfset url_str = "#url_str#&sales_emp_id=#attributes.sales_emp_id#&sales_emp=#attributes.sales_emp#">
				</cfif>
				<cfif len(attributes.sales_member_type) and len(attributes.sales_member_name) and len(attributes.sales_member_id)>
					<cfset url_str ="#url_str#&sales_member_type=#attributes.sales_member_type#&sales_member_id=#attributes.sales_member_id#&sales_member_name=#attributes.sales_member_name#">
				</cfif>
				<cfif len(attributes.record_employee_id) and len(attributes.record_employee)>
					<cfset url_str = "#url_str#&record_employee_id=#attributes.record_employee_id#&record_employee=#attributes.record_employee#">
				</cfif>
				<cfif len(attributes.process_stage)>
					<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
				</cfif>
				<cfif len(attributes.opportunity_type_id)>
					<cfset url_str = "#url_str#&opportunity_type_id=#attributes.opportunity_type_id#">
				</cfif>
				<cfif len(attributes.product_cat_id) and len(attributes.product_cat)>
					<cfset url_str = '#url_str#&product_cat_id=#attributes.product_cat_id#&product_cat=#attributes.product_cat#'>
				</cfif>
				<cfif len(attributes.stock_id) and len(attributes.stock_name)>
					<cfset url_str = '#url_str#&stock_id=#attributes.stock_id#&stock_name=#attributes.stock_name#'>
				</cfif>
				<cfif len(attributes.sale_add_option)>
					<cfset url_str = "#url_str#&sale_add_option=#attributes.sale_add_option#">
				</cfif>
				<cfif len(attributes.probability)>
					<cfset url_str = "#url_str#&probability=#attributes.probability#">
				</cfif>
				<cfif len(attributes.opp_currency_id)>
					<cfset url_str = "#url_str#&opp_currency_id=#attributes.opp_currency_id#">
				</cfif>
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
				   <cfset url_str = "#url_str#&project_id=#attributes.project_id#">
				</cfif>
				<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
				   <cfset url_str = "#url_str#&project_head=#attributes.project_head#">
                </cfif>
                <cfif len(attributes.model_no)>
                    <cfset url_str = "#url_str#&model_no=#attributes.model_no#">
                </cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="textile.list_sample_request#url_str#">
			</td>
		</tr>
	</table>
</cfif>
</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function connectAjax(crtrow,company_id,project_id)
{
	/*var load_url_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=textile.emptypopup_critics&req_id='+req_id+'&company_id'+company_id;
    AjaxPageLoad(load_url_,'DISPLAY_OPP_PLUS_INFO'+crtrow,1);*/
    var load_url_ = '<cfoutput>#request.self#?fuseaction=project.emptypopup_ajax_project_works&work_status=0</cfoutput>&project_id='+project_id;
	AjaxPageLoad(load_url_,'DISPLAY_OPP_PLUS_INFO'+crtrow,1);
}
function demand_convert_to_production(type,i)
	{
		var rowcount='<cfoutput>#GET_SAMPLE_REQ.recordcount#</cfoutput>';
		var orderids_="";
		var pids_="";
		var amounts_='';
		var projectid = "";
		var req_id = "";
				
				orderids_=orderids_+document.getElementById('order_id'+i).value+',';
				pids_=pids_+document.getElementById('product_id'+i).value+',';
				projectid = projectid+document.getElementById('project_id'+i).value+',';
				marj=$('#marj_amount'+i).val();
				marj=filterNum(marj);
				amounts_=amounts_+marj+',';
				req_id = document.getElementById('req_id'+i).value;
				
				if(orderids_=='')
				{
					alert("<cf_get_lang dictionary_id='57725.??r??n Se??iniz'>");
					return false;
				}

				window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=textile.tracking&event=material&amounts="+amounts_+"&orderids="+orderids_+"&pids="+pids_+"&projectid="+projectid+"&req_id="+req_id;
			
	}
</script>
