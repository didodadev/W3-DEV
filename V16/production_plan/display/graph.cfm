<!--- 
    Author: Uğur Hamurpet
    Date:   29/09/2020
    Desc:   Üretim çizelgesi gantt chart dhtmlx kütüphanesi kullanılarak yeniden tasarlanmıştır.
            Üretim emrine, ürüne siparişe ve istasyona göre görüntüleme yapılabilir
--->

<cfparam name="attributes.is_form_submitted" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.is_consumer_company" default="">
<cfparam name="attributes.working_period" default="">
<cfparam name="attributes.product_category_id" default="">
<cfparam name="attributes.start_date" default="#dateadd('m',-1,now())#">
<cfparam name="attributes.finish_date" default="#now()#">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.work_station" default="">
<cfparam name="attributes.work_sub_station" default="">
<cfparam name="attributes.view_type" default="">
<cfparam name="attributes.view_period" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.totalrecords" default="0">
<cfparam name="attributes.startrow"  default="#((attributes.page-1)*attributes.maxrows)+1#">

<cfset production_plan_graph = createObject("component", "V16.production_plan.cfc.production_plan_graph") />
<cfset getProductCategoryList = production_plan_graph.getProductCategoryList() />
<cfset getProgramList = production_plan_graph.getProgramList() />
<cfif len( attributes.department_id )>
    <cfset getStationList = production_plan_graph.getStationList(department_id:attributes.department_id) />
    <cfif len( attributes.work_station )>
        <cfset getSubStationList = production_plan_graph.getSubStationList(department_id:attributes.department_id, station_id : attributes.work_station) />
    <cfelse>
        <cfset getSubStationList.recordcount = 0 />
    </cfif>
<cfelse>
    <cfset getStationList.recordcount = 0 />
</cfif>

<cfset get_department = CreateObject("component","cfc/get_department") />
<cfset departments = get_department.getComponentFunction( len( attributes.branch_id ) ? attributes.branch_id : '' ) />
<cfset branches = get_department.getComponentFunction1() />

<cfif attributes.is_form_submitted>

    <cf_date tarih = "attributes.start_date">
    <cf_date tarih = "attributes.finish_date">

    <cfset getProductionOrders = production_plan_graph.getProductionOrders(
        employee_id: attributes.employee_id,
        branch_id: attributes.branch_id,
        department_id: attributes.department_id,
        station_id: len(attributes.work_sub_station) ? attributes.work_sub_station : ( len(attributes.work_station) ? attributes.work_station : '' ) ,
        start_date: attributes.start_date,
        finish_date: attributes.finish_date,
        keyword: attributes.keyword,
        product_category_id: attributes.product_category_id,
        consumer_id: attributes.consumer_id,
        is_consumer_company: attributes.is_consumer_company,
        status: attributes.status,
        startrow: attributes.startrow,
        maxrows: attributes.maxrows,
        view_type: attributes.view_type
    ) />
    <cfset attributes.totalrecords = getProductionOrders.orders.recordcount ? getProductionOrders.orders.QUERY_COUNT : 0 />

</cfif>

<script src="JS/gantt_chart/dhtmlxgantt.js" type="text/javascript" charset="utf-8"></script>
<script src="JS/gantt_chart/ext/dhtmlxgantt_marker.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="JS/gantt_chart/skins/dhtmlxgantt_terrace.css" type="text/css" media="screen" title="no title" charset="utf-8">
<cfif session.ep.language neq 'eng'><script src="JS/gantt_chart/locale/locale_<cfoutput>#session.ep.language#</cfoutput>.js" type="text/javascript" charset="utf-8"></script></cfif>

<style>

    .gantt_task_link.start_to_start .gantt_line_wrapper div {
        background-color: #dd5640;
    }

    .gantt_task_link.start_to_start:hover .gantt_line_wrapper div {
        box-shadow: 0 0 5px 0px #dd5640;
    }

    .gantt_task_link.start_to_start .gantt_link_arrow_right {
        border-left-color: #dd5640;
    }

    .gantt_task_link.finish_to_start .gantt_line_wrapper div {
        background-color: #7576ba;
    }

    .gantt_task_link.finish_to_start:hover .gantt_line_wrapper div {
        box-shadow: 0 0 5px 0px #7576ba;
    }

    .gantt_task_link.finish_to_start .gantt_link_arrow_right {
        border-left-color: #7576ba;
    }

    .gantt_task_link.finish_to_finish .gantt_line_wrapper div {
        background-color: #55d822;
    }

    .gantt_task_link.finish_to_finish:hover .gantt_line_wrapper div {
        box-shadow: 0 0 5px 0px #55d822;
    }

    .gantt_task_link.finish_to_finish .gantt_link_arrow_left {
        border-right-color: #55d822;
    }
    .gantt_layout.gantt_layout_x { height: calc(100% - 16px)!important;}
    .gantt_tree_content a:link{color:#4cc0c1 !important;}
</style>

<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="" method="post">
            <cfinput type="hidden" name="is_form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px;" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="view_type" id="view_type">
                        <option value="1"<cfif attributes.view_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='61222.Üretim Emrine Göre'></option>
                        <option value="2"<cfif attributes.view_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='61223.Siparişe Göre'></option>
                        <option value="3"<cfif attributes.view_type eq 3> selected</cfif>><cf_get_lang dictionary_id ='35986.Ürüne Göre'></option>
                        <option value="4"<cfif attributes.view_type eq 4> selected</cfif>><cf_get_lang dictionary_id ='38119.İstasyona Göre'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="view_period" id="view_period">
                        <option value="0"<cfif attributes.view_period eq 0> selected</cfif>><cf_get_lang dictionary_id ='58457.Günlük'></option>
                        <option value="1"<cfif attributes.view_period eq 1> selected</cfif>><cf_get_lang dictionary_id ='58458.Haftalık'></option>
                        <option value="2"<cfif attributes.view_period eq 2> selected</cfif>><cf_get_lang dictionary_id ='58932.Aylık'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <select name="status" id="status">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1"<cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
                        <option value="0"<cfif attributes.status eq 0> selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-company">
                        <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                                <cfinput type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                                <cfinput type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
                                <cfinput type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
                                <cfinput type="text" name="company" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'#fusebox.circuit is 'store' ? 1 : 0 #\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');"  value="#attributes.company#" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company&field_emp_id=form.employee_id&field_name=form.company&field_type=form.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id" onChange="showDepartment(this)">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="branches">
                                    <option value="#BRANCH_ID#" <cfif attributes.branch_id eq branch_id>selected</cfif>>#BRANCH_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-dept_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12">
                            <div class="col col-12 col-xs-12" id="department_div">
                                <select name="DEPARTMENT_ID" id="DEPARTMENT_ID"> 
                                    <option value=""><cf_get_lang dictionary_id='53200.Departman Seçiniz'></option>
                                    <cfif len(attributes.branch_id)>
                                        <cfoutput query="departments">
                                            <option value="#department_id#" <cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
                                        </cfoutput>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-work_station">
                        <label class="col col-12"><cf_get_lang dictionary_id='58834.İstasyon'></label>
                        <div class="col col-12">
                            <select name="work_station" id="work_station">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif len(attributes.branch_id) and getStationList.recordcount>
                                    <cfoutput query="getStationList">
                                        <option value="#ID#" #attributes.work_station eq ID ? 'selected' : ''#>#NAME#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_sub_station">
                        <label class="col col-12"><cf_get_lang dictionary_id='36522.Alt İstasyonlar'></label>
                        <div class="col col-12">
                            <select name="work_sub_station" id="work_sub_station">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif len(attributes.work_station) and getSubStationList.recordcount>
                                    <cfoutput query="getSubStationList">
                                        <option value="#ID#" #attributes.work_sub_station eq ID ? 'selected' : ''#>#NAME#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-working_period">
                        <label class="col col-12"><cf_get_lang dictionary_id='36795.Çalışma Programı'></label>
                        <div class="col col-12">
                            <select name="working_period" id="working_period">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif getProgramList.recordcount>
                                    <cfoutput query="getProgramList">
                                        <cfset timePeriod = '#timeformat("#STARTHOUR#:#STARTMIN#",timeformat_style)# - #timeformat("#ENDHOUR#:#ENDMIN#",timeformat_style)#' />
                                        <option value="#timePeriod#" <cfif len(attributes.working_period) and attributes.working_period eq timePeriod>selected</cfif>>[#timePeriod#] #NAME#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-product_category_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='29401.Ürün kategorisi'></label>
                        <div class="col col-12">
                            <select name="product_category_id" id="product_category_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfif getProductCategoryList.recordcount>
                                    <cfoutput query="getProductCategoryList">
                                        <option value="#ID#" #attributes.product_category_id eq ID ? 'selected' : ''#>#NAME#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    
    <cfsavecontent variable="title">
        <cfswitch expression="#attributes.view_type#">
            <cfcase value="1"> : <cf_get_lang dictionary_id ='30049.Üretim Emri'></cfcase>
            <cfcase value="2"> : <cf_get_lang dictionary_id ='57611.Sipariş'></cfcase>
            <cfcase value="3"> : <cf_get_lang dictionary_id ='57657.Ürün'></cfcase>
            <cfcase value="4"> : <cf_get_lang dictionary_id ='58834.İstasyon'></cfcase>
        </cfswitch>
    </cfsavecontent>

    <cf_box id="chart" title="GANTT#title#">
        <cfif not attributes.is_form_submitted>
            <cf_get_lang dictionary_id = "57701.Filtre Ediniz">
        <cfelseif attributes.is_form_submitted and not attributes.totalrecords>
            <cf_get_lang dictionary_id = "57484.Kayıt Yok">
        </cfif>
    </cf_box>
    <cfif attributes.is_form_submitted and attributes.totalrecords gt attributes.maxrows>
        <cf_box id="chart_paging">
            <cfset adres = "prod.graph_gant">
            <cfif len(attributes.is_form_submitted)>
                <cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
            </cfif>
            <cfif len(attributes.is_form_submitted)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.company_id)>
                <cfset adres = "#adres#&company_id=#attributes.company_id#">
            </cfif>
            <cfif len(attributes.consumer_id)>
                <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
            </cfif>
            <cfif len(attributes.employee_id)>
                <cfset adres = "#adres#&employee_id=#attributes.employee_id#">
            </cfif>
            <cfif len(attributes.member_type)>
                <cfset adres = "#adres#&member_type=#attributes.member_type#">
            </cfif>
            <cfif len(attributes.company)>
                <cfset adres = "#adres#&company=#attributes.company#">
            </cfif>
            <cfif len(attributes.is_consumer_company)>
                <cfset adres = "#adres#&is_consumer_company=#attributes.is_consumer_company#">
            </cfif>
            <cfif len(attributes.working_period)>
                <cfset adres = "#adres#&working_period=#attributes.working_period#">
            </cfif>
            <cfif len(attributes.product_category_id)>
                <cfset adres = "#adres#&product_category_id=#attributes.product_category_id#">
            </cfif>
            <cfif len(attributes.start_date)>
                <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.finish_date)>
                <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.status)>
                <cfset adres = "#adres#&status=#attributes.status#">
            </cfif>
            <cfif len(attributes.branch_id)>
                <cfset adres = "#adres#&branch_id=#attributes.branch_id#">
            </cfif>
            <cfif len(attributes.department_id)>
                <cfset adres = "#adres#&department_id=#attributes.department_id#">
            </cfif>
            <cfif len(attributes.work_station)>
                <cfset adres = "#adres#&work_station=#attributes.work_station#">
            </cfif>
            <cfif len(attributes.work_sub_station)>
                <cfset adres = "#adres#&work_sub_station=#attributes.work_sub_station#">
            </cfif>
            <cfif len(attributes.view_type)>
                <cfset adres = "#adres#&view_type=#attributes.view_type#">
            </cfif>
            <cfif len(attributes.view_period)>
                <cfset adres = "#adres#&view_period=#attributes.view_period#">
            </cfif>

            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#">
        </cf_box>
    </cfif>
    <div id = "order_info" style="display:none;">
        <cf_box id="box_order_info" title = "#getLang('','','31901')#" closable = "1" collapsable = "0" resize = "0">
            <cf_grid_list id = "table_order_info"></cf_grid_list>
        </cf_box>
    </div>
</div>

<cfset ghantChartHeight = attributes.is_form_submitted ? ((getProductionOrders.orders.recordcount * 30) + 100) : 0 />

<script type="text/javascript">
    
    <cfif attributes.is_form_submitted and attributes.totalrecords>

        let zoom = <cfoutput>#attributes.view_period#</cfoutput>;

        $("#body_chart").height("<cfoutput>#ghantChartHeight#</cfoutput>px"); // Set Gantt Chart Height

        $("#chart .portBoxBodyStandart").css({"padding":"0"}); //Set Gantt Chart box padding

        gantt.config.columns = [
            {name:"description",    label:"<cfoutput>#listLast(title,':')#</cfoutput>",  tree:true, align: "left", width:'*',},
            {name:"text",           label:"Görev Adı", hide:true },
            {name:"start_date",     label:"<cf_get_lang dictionary_id = "58053.Başlangıç Tarihi">", align: "center" },
            {name:"duration",       label:"<cf_get_lang dictionary_id = "29513.Süre">",   align: "center" },
            {name:"add",            label:"", hide:true }
        ];

        gantt.init("body_chart");
        gantt.parse({
            data: [
                <cfif attributes.view_type eq 1><!--- Üretim Emrine Göre --->
                    <cfoutput query="getProductionOrders.orders">
                        <cfset date_diff = wrk_round((datediff('n',STARTDATE,FINISHDATE) + 1) / 1440)>
                        { id:#ID#, description:"<a href = '#request.self#?fuseaction=production.form_add_production_order&upd=#ID#' class='text-info' target='_blank'>#productionNo#</a>", text:"#productionNo#", start_date:"#dateFormat(STARTDATE, dateformat_style)#", duration:#date_diff#, progress:0, open:true }<cfif attributes.totalrecords gt currentRow>,</cfif>
                    </cfoutput>
                <cfelseif attributes.view_type eq 2><!--- Siparişe Göre --->
                    <cfif getProductionOrders.product_orders.recordcount>
                        <cfoutput query="getProductionOrders.product_orders">
                            <cfset date_diff = wrk_round((datediff('n',STARTDATE,FINISHDATE) + 1) / 1440)>
                            { id:#ORDER_ID#, description:"<a href = '#request.self#?fuseaction=prod.tracking&event=det&unit_name=#orderUnit#&order_id=#ORDER_ID#&order_row_id=#orderRowID#' class='text-info' target='_blank'>#ORDER_NUMBER#</a>", text:"#ORDER_NUMBER#", start_date:"#dateFormat(STARTDATE, dateformat_style)#", duration:#date_diff#, progress:0, open:true },
                        </cfoutput>
                        <cfoutput query="getProductionOrders.orders">
                            <cfset date_diff = wrk_round((datediff('n',STARTDATE,FINISHDATE) + 1) / 1440)>
                            { id:#ID#, description:"<a href = '#request.self#?fuseaction=production.form_add_production_order&upd=#ID#' class='text-info' target='_blank'>#productionNo#</a>", text:"#productionNo#", start_date:"#dateFormat(STARTDATE, dateformat_style)#", duration:#date_diff#, progress:0, parent:#orderID# }<cfif getProductionOrders.orders.recordcount gt currentRow>,</cfif>
                        </cfoutput>
                    </cfif>
                <cfelseif attributes.view_type eq 3><!--- Ürüne Göre --->
                    <cfif getProductionOrders.products.recordcount>
                        <cfoutput query="getProductionOrders.products">
                            { id:#STOCK_ID#, description:"<a href = '#request.self#?fuseaction=product.list_product&event=det&pid=#STOCK_ID#' class='text-info' target='_blank'>#PRODUCT_NAME#</a>", text:"#PRODUCT_NAME#", open:true },
                        </cfoutput>
                        <cfoutput query="getProductionOrders.orders">
                            <cfset date_diff = wrk_round((datediff('n',STARTDATE,FINISHDATE) + 1) / 1440)>
                            { id:#ID#, description:"<a href = '#request.self#?fuseaction=production.form_add_production_order&upd=#ID#' class='text-info' target='_blank'>#productionNo#</a>", text:"#productionNo#", start_date:"#dateFormat(STARTDATE, dateformat_style)#", duration:#date_diff#, progress:0, parent:#stockID# }<cfif getProductionOrders.orders.recordcount gt currentRow>,</cfif>
                        </cfoutput>
                    </cfif>
                <cfelseif attributes.view_type eq 4><!--- İstasyona Göre --->
                    <cfif getProductionOrders.workstations.recordcount>
                        <cfoutput query="getProductionOrders.workstations">
                            { id:#STATION_ID#, description:"<a href = '#request.self#?fuseaction=prod.list_workstation&event=upd&station_id=#STATION_ID#' class='text-info' target='_blank'>#STATION_NAME#</a>", text:"#STATION_NAME#", open:true },
                        </cfoutput>
                        <cfoutput query="getProductionOrders.orders">
                            <cfset date_diff = wrk_round((datediff('n',STARTDATE,FINISHDATE) + 1) / 1440)>
                            { id:#ID#, description:"<a href = '#request.self#?fuseaction=production.form_add_production_order&upd=#ID#' class='text-info' target='_blank'>#productionNo#</a>", text:"#productionNo#", start_date:"#dateFormat(STARTDATE, dateformat_style)#", duration:#date_diff#, progress:0, parent:#stationID# }<cfif getProductionOrders.orders.recordcount gt currentRow>,</cfif>
                        </cfoutput>
                    </cfif>
                </cfif>
            ]
        });

        gantt.attachEvent("onTaskClick", function(id, e){

            var selection = this.getTask(id);

            var formData = new FormData();
            formData.append("p_order_id", selection.id);
            AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=getProductionOrderById', formData, function ( response ) {
                
                if( JSON.parse(response).length > 0 ){

                    var data = JSON.parse(response)[0];
                    $("#order_info #table_order_info").html("");
                    $("<tbody>").append(
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "58211.Sipariş No">'), $("<td>").append( $("<a>").attr({"href":"<cfoutput>#request.self#</cfoutput>?fuseaction=prod.tracking&event=det&unit_name=" + data.orderunit + "&order_id=" + data.orderid + "&order_row_id=" + data.orderrowid + "", "target" : "_blank"}).text(data.orderNo))),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "29474.Emir No">'), $("<td>").append( $("<a>").attr({"href":"<cfoutput>#request.self#</cfoutput>?fuseaction=production.form_add_production_order&upd=" + data.id + "", "target" : "_blank"}).text(data.productionno))),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "36353.İş istasyonu">'), $("<td>").text(data.stationname)),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "31027.Proje Adı">'), $("<td>").text(data.projectName)),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "58221.Ürün adı">'), $("<td>").text(data.product)),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "29401.Ürün Kategorisi">'), $("<td>").text(data.productcat)),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "57635.Miktar">'), $("<td>").text(data.quantity)),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "58053.Başlangıç Tarihi">'), $("<td>").text(data.startdate)),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "57700.Bitiş Tarihi">'), $("<td>").text(data.finishdate)),
                        //$("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "31031.Kalan Zaman">'), $("<td>").text( (dataTable.getValue(selection.row, 5) != null) ? dataTable.getValue(selection.row, 5) + '<cf_get_lang dictionary_id = "57490.Gün">' : '')),
                        $("<tr>").append($("<td>").text('<cf_get_lang dictionary_id = "39663.Tamamlanma Oranı">'), $("<td>").text(selection.progress))
                    ).appendTo($("#order_info #table_order_info"));
                    
                    cfmodal('', 'warning_modal', { element_id : 'order_info' });

                }

            });

        });

        gantt.attachEvent("onAfterTaskDrag", function(id, mode, e,task,target){
            
            var selection = this.getTask(id);

            var formData = new FormData();
            formData.append("p_order_id", selection.id);
            formData.append("start_date", selection.start_date);
            formData.append("finish_date", selection.end_date);
            AjaxControlPostData('V16/production_plan/cfc/production_plan_graph.cfc?method=updateProductionOrder', formData, function ( response ) {});

        });

        setScaleConfig(zoom);

        /* Set View Mode - day, week, year */

        function setScaleConfig(level) {
            switch (level) {
                case 0:
                    gantt.config.scale_unit = "day";
                    gantt.config.date_scale = "%F %d";
                    gantt.config.min_column_width = 50;
                    gantt.config.scale_height = 54;
                    gantt.config.subscales = [
                        {unit: "hour", step: 3, date: "%H:%i"}
                    ];
                    break;
                case 1:
                    var weekScaleTemplate = function (date) {
                        var dateToStr = gantt.date.date_to_str("%d %M");
                        var endDate = gantt.date.add(gantt.date.add(date, 1, "week"), -1, "day");
                        return dateToStr(date) + " - " + dateToStr(endDate);
                    };
                    gantt.config.scale_unit = "week";
                    gantt.config.step = 1;
                    gantt.templates.date_scale = weekScaleTemplate;
                    gantt.config.scale_height = 50;
                    gantt.config.subscales = [
                        {unit: "day", step: 1, date: "%D"}
                    ];
                    break;
                case 2:
                    gantt.config.scale_unit = "year";
                    gantt.config.step = 1;
                    gantt.config.date_scale = "%Y";
                    gantt.templates.date_scale = null;
                    gantt.config.min_column_width = 50;
                    gantt.config.scale_height = 50;
                    gantt.config.subscales = [
                        {unit: "month", step: 1, date: "%M"}
                    ];
                    break;
            }

            gantt.render();
        
        }

        /* Set View Mode - day, week, year */

        /* Zoom In - Out */

        function zoomOut(){
            zoom += ( zoom != 2 ) ? 1 : 0;
            setScaleConfig(zoom);
        }
        function zoomIn(){
            zoom -= ( zoom != 0 ) ? 1 : 0;
            setScaleConfig(zoom);
        }

        /* Zoom In - Out */

    </cfif>

    function showDepartment(element){
		if (element.value != "") AjaxPageLoad("<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&show_div=0&branch_id="+element.value,'department_div',1,'İlişkili Departmanlar');
        $("#work_station").html("<option value = ''><cf_get_lang dictionary_id='57734.Seçiniz'></option>");
        $("#work_sub_station").html("<option value = ''><cf_get_lang dictionary_id='57734.Seçiniz'></option>");
    }

    $("#department_div").delegate('#DEPARTMENT_ID',"change",function() {
        var getWorkStations = wrk_safe_query('prdp_get_ws_all_by_department','dsn3',0,$(this).val());
        if( getWorkStations.recordcount > 0 ){
            for( var i = 0; i < getWorkStations.recordcount; i++ ){
                $("<option>").val(getWorkStations.STATION_ID[i]).text(getWorkStations.STATION_NAME[i]).appendTo($("#work_station"));
            }
        }else $("#work_station").html("<option value = ''><cf_get_lang dictionary_id='57734.Seçiniz'></option>");
        $("#work_sub_station").html("<option value = ''><cf_get_lang dictionary_id='57734.Seçiniz'></option>");
    });

    $("#work_station").change(function(){
        var department_id = document.getElementById('DEPARTMENT_ID').value;
        var getSubWorkStations = wrk_safe_query('prdp_get_wss_all_by_department','dsn3',0, department_id + "*" + $(this).val()  );
        if( getSubWorkStations.recordcount > 0 ){
            for( var i = 0; i < getSubWorkStations.recordcount; i++ ){
                $("<option>").val(getSubWorkStations.STATION_ID[i]).text(getSubWorkStations.STATION_NAME[i]).appendTo($("#work_sub_station"));
            }
        }else $("#work_sub_station").html("<option value = ''><cf_get_lang dictionary_id='57734.Seçiniz'></option>");
    });

    $("#header_chart > .portHeadLightMenu > ul").prepend(
        $("<li>").append($("<a>").attr({"href":"javascript://", "title" : "Zoom In", "onclick" : "zoomIn()"}).append($("<i>").addClass("catalyst-magnifier-add"))),
        $("<li>").append($("<a>").attr({"href":"javascript://", "title" : "Zoom Out", "onclick" : "zoomOut()"}).append($("<i>").addClass("catalyst-magnifier-remove")))
    )

</script>