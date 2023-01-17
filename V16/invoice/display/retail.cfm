<cfif not IsDefined("session.wp")>
<link rel="stylesheet" href="/css/assets/template/retail/bootstrap.min.css" type="text/css">
<link rel="stylesheet" href="css/assets/template/retail/whops.css" type="text/css">
<cfset session_base = session.ep />
</cfif>
<cfquery name="GET_CONSUMER_STAGE" datasource="#dsn#" maxrows="1">
    SELECT TOP 1
        PTR.STAGE,
        PTR.PROCESS_ROW_ID,
        PTR.LINE_NUMBER
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_consumer%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_COMPANY_STAGE" datasource="#dsn#" maxrows="1">
    SELECT TOP 1
        PTR.STAGE,
        PTR.PROCESS_ROW_ID,
        PTR.LINE_NUMBER
    FROM
        PROCESS_TYPE_ROWS PTR,
        PROCESS_TYPE_OUR_COMPANY PTO,
        PROCESS_TYPE PT
    WHERE
        PT.IS_ACTIVE = 1 AND
        PT.PROCESS_ID = PTR.PROCESS_ID AND
        PT.PROCESS_ID = PTO.PROCESS_ID AND
        PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
    ORDER BY
        PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_consumer_cat" datasource="#dsn#">
    SELECT CONSCAT_ID FROM CONSUMER_CAT WHERE IS_DEFAULT = 1
</cfquery>

<cfset is_control_risk = 2> <!--- xml değeri geçici olarak atandı. --->

<div id="basket_main_div" style="background:none !important; height:100%">
    <div basket_header style="height:100%">
        <cfparam name="attributes.comp_member_cat" default="">
        <cfparam name="attributes.cons_member_cat" default="">
        <cfparam name="attributes.field_vocation" default="">
        <input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill_retail</cfoutput>">
        <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session_base.period_id#</cfoutput>">
        <cf_papers paper_type="cashregister">
        <cfif isDefined('paper_full')>
            <input type="hidden" maxlength="50" id="invoice_number" name="invoice_number" value="<cfoutput>#paper_full#</cfoutput>">
        <cfelse>
            <input type="hidden" maxlength="50" id="invoice_number" name="invoice_number" value="">
        </cfif>
        <div id="retailApp">
            <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')><cfoutput>#paper_number#</cfoutput></cfif>">
            <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
            <input type="hidden" name="member_account_code" id="member_account_code" value="">
            <input type="hidden" name="cash" id="cash" value="0">
            <input type="hidden" name="is_pos" id="is_pos" value="">
            <input type="hidden" name="consumer_cat_id" id="consumer_cat_id" value="<cfif get_consumer_cat.recordcount><cfoutput>#get_consumer_cat.conscat_id#</cfoutput><cfelse>1</cfif>">
            <input type="hidden" name="company_cat_id" id="company_cat_id" value="1">
            <input type="hidden" name="consumer_stage" id="consumer_stage" value="<cfif GET_CONSUMER_STAGE.recordcount><cfoutput>#GET_CONSUMER_STAGE.PROCESS_ROW_ID#</cfoutput></cfif>">
            <input type="hidden" name="company_stage" id="company_stage" value="<cfif GET_COMPANY_STAGE.recordcount><cfoutput>#GET_COMPANY_STAGE.PROCESS_ROW_ID#</cfoutput></cfif>">
            <input type="hidden" name="empo_id" value="<cfoutput>#session_base.userid#</cfoutput>">
            <input type="hidden" name="partner_nameo" value="<cfoutput>#get_emp_info(session_base.userid,0,0)#</cfoutput>">
            <input type="hidden" name="ship_address_id" id="ship_address_id">
            <input type="hidden" name="from_whops" id="from_whops" value="1">
            <input type="hidden" data-bind="value: basketService.get('cashSettings')[0].POS_ID, attr:{ 'name' : 'pos_eq_id', 'id' : 'pos_eq_id' }">
            <input type="hidden" id="data_action" name="data_action" value="/V16/invoice/datagates/endpoints/invoice_retail_endpoint:add">
            <input type="hidden" id="next_page" name="next_page" value="<cfoutput>#request.self#</cfoutput>?wo=invoice.whops">
            <input type="hidden" data-bind="value: basketService.get('cashSettings')[0].POS_PROCESS_CAT, attr:{ 'name' : 'process_cat', 'id' : 'process_cat' }">
            <input type="hidden" data-bind="value: basketService.get('cashSettings')[0].PRICE_CAT_ID, attr:{ 'name' : 'price_catid', 'id' : 'price_catid' }">
            <input type="hidden" name="invoice_date" id="invoice_date" value="<cfoutput>#dateformat(now(), dateformat_style)#</cfoutput>">
            <!--- geçici olarak manuel verilen değerler --->
            <input type="hidden" name="branch_id" value="1">
            <input type="hidden" name="department_id" value="17">
            <input type="hidden" name="location_id" value="7">           
            <input type="hidden" name="deliver_get" value="">
            <input type="hidden" name="note" value="">
            <!--- geçici olarak manuel verilen değerler --->
            <div class="bootstrap">
                <div class="custom_box cl-12 cl-md-8 cl-sm-6 col-xs-12 border" style="padding:0 !important;">
                    <div class="step_header" style="padding-left:28px;">
                        <div class="col-5 col-md-5 col-sm-11 col-xs-11">
                            <div class="form-group mb-0">
                                <form onsubmit="return false">
                                    <input type="text" autocomplete="off" placeholder="Tel, Üye Kaydı, VKN, TCKN" data-bind="value: $root.keyword, event: { change: $root.findCustomerByKeyword }" style="height:41px;">
                                </form>
                            </div>
                        </div>
                        <div>
                            <label style="margin:0 5px;background:#FFC907;border-radius:10px;" >
                                <img src="../asset/img/search.png" style="width:38px;padding:7px;height:41px;"/>
                            </label>
                        </div>
                        <div class="col-3 col-md-4 col-sm-12 col-xs-12">
                            <div class="form-group mb-0" data-bind="visible: basketService.get('cashSettings')[0].USE_CUSTOMER_RECORD == 1">
                                <button type="submit" class="color-F new_customer_button" data-bind="click: toggleCustomerAddForm">
                                    Yeni Müşteri
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="step_container">
                        <div class="step_search">
                            <div class="step_body">
                                <div class="form-group form-group-type3 col col-4 col-md-6 col-sm-12 col-xs-12">
                                    <button type="submit" data-bind="click: $root.setProductCategory" class="category_button"><span class="fa fa-bars">&nbsp;</span>Kategoriler</button>
                                    
                                </div>
                                <div class="form-group form-group-type3 col col-3 col-md-6 col-sm-12 col-xs-12">
                                    <button type="submit" data-bind="click: $root.setProductSearch" class="product_search_button"><span class="icn-md icon-search">&nbsp;</span>Ürün Ara</button>
                                </div>
                                    <form onsubmit="return false">
                                        <div class="form-group barkod col col-5 col-md-12 col-sm-12 col-xs-12">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" data-bind="click: $root.barcodeChanged"><path d="M 20.5 6 C 12.509634 6 6 12.50964 6 20.5 C 6 28.49036 12.509634 35 20.5 35 C 23.956359 35 27.133709 33.779044 29.628906 31.75 L 39.439453 41.560547 A 1.50015 1.50015 0 1 0 41.560547 39.439453 L 31.75 29.628906 C 33.779044 27.133709 35 23.956357 35 20.5 C 35 12.50964 28.490366 6 20.5 6 z M 20.5 9 C 26.869047 9 32 14.130957 32 20.5 C 32 23.602612 30.776198 26.405717 28.791016 28.470703 A 1.50015 1.50015 0 0 0 28.470703 28.791016 C 26.405717 30.776199 23.602614 32 20.5 32 C 14.130953 32 9 26.869043 9 20.5 C 9 14.130957 14.130953 9 20.5 9 z"></path></svg>
                                            <span style="position: absolute;width: 20%;"><input type="text" id="qrAmount" data-bind="value: commaSplit(1, basketService.priceRoundNumber())" class="moneybox" onClick="this.select();"></span>
                                            <input type="text" id="keyword" data-bind="value: $root.barcode, event: { change: $root.barcodeChanged }" placeholder="Barkod (QR Code)" class="text-center" >
                                        </div>
                                    </form>
                            </div>
                        </div>
                        <div class="step_item" data-bind="visible: $root.productstep() == 'search'">
                            <div class="step_head head_left">
                                <h1>
                                    Ürünler
                                    <!--- <ul>
                                        <li>
                                            <a id="back" href="javascript://" data-bind="click: $root.setProductNone">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M24,44c11.028,0,20-8.972,20-20S35.028,4,24,4S4,12.972,4,24S12.972,44,24,44z M15.439,22.939l6-6 c0.586-0.586,1.535-0.586,2.121,0s0.586,1.535,0,2.121L20.121,22.5H31.5c0.828,0,1.5,0.672,1.5,1.5s-0.672,1.5-1.5,1.5H20.121 l3.439,3.439c0.586,0.586,0.586,1.535,0,2.121C23.268,31.354,22.884,31.5,22.5,31.5s-0.768-0.146-1.061-0.439l-6-6 C14.854,24.475,14.854,23.525,15.439,22.939z"></path></svg>
                                            </a>
                                        </li>
                                    </ul> --->
                                </h1>
                                <p>Filtre ederek arayın</p>
                            </div>
                            <div class="step_body mobile">
                                <div class="detail_form cl-12">
                                    <form onsubmit="return false">
                                        <div class="form-group form-group-type2">
                                            <input type="text" autocomplete="off" data-bind="value: $root.stock_code" placeholder="Stok Kodu">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" autocomplete="off" data-bind="value: $root.product_keyword" placeholder="Ürün Adı (UA - 1)">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" autocomplete="off" data-bind="value: $root.barcode2" placeholder="Barkod (QR Code)">
                                        </div>
                                        <div class="form-group form-group-type2" data-bind="visible: basketService.get('cashSettings')[0].USE_SERIAL_NO == 1">
                                            <input type="text" autocomplete="off" data-bind="value: $root.serial_number" placeholder="Seri No">
                                        </div>
                                        <div class="form-group form-group-type2" data-bind="visible: basketService.get('cashSettings')[0].USE_LOT_NO == 1">
                                            <input type="text" autocomplete="off" data-bind="value: $root.lot_number" placeholder="Lot No">
                                        </div>
                                        <div class="form-group form-group-type3">
                                            <button type="submit" data-bind="click: $root.barcodeChanged" class="nk_button">
                                                Ara
                                            </button>
                                        </div>
                                    </form>
                                </div>   
                            </div>
                        </div>
                        <div class="step_item" data-bind="visible: $root.productstep() == 'category'">
                            <!--- <div class="step_head">
                                <h1>
                                    Kategoriler
                                    <ul>
                                        <li>
                                            <a id="back" href="javascript://" data-bind="click: $root.setProductNone">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M24,44c11.028,0,20-8.972,20-20S35.028,4,24,4S4,12.972,4,24S12.972,44,24,44z M15.439,22.939l6-6 c0.586-0.586,1.535-0.586,2.121,0s0.586,1.535,0,2.121L20.121,22.5H31.5c0.828,0,1.5,0.672,1.5,1.5s-0.672,1.5-1.5,1.5H20.121 l3.439,3.439c0.586,0.586,0.586,1.535,0,2.121C23.268,31.354,22.884,31.5,22.5,31.5s-0.768-0.146-1.061-0.439l-6-6 C14.854,24.475,14.854,23.525,15.439,22.939z"></path></svg>
                                            </a>
                                        </li>
                                    </ul>
                                </h1>
                                <p>Kategori işlemleri için menüleri kullanabilirsiniz.</p>
                            </div> --->
                            <div class="step_body step_body-type3">
                                <div class="category">
                                    <!-- ko foreach: $root.product_categories -->
                                    <div class="cl-6 cl-md-3 cl-sm-6 cl-xs-6">
                                        <a href="javascript://" class="category_list_item" data-bind="click: $root.categoryChanged.bind(this, PRODUCT_CATID, PRODUCT_CAT); ">
                                            <div class="category_list_item_text">
                                                <div class="name" data-bind="text: PRODUCT_CAT"></div>
                                                <!--- <div class="text">
                                                    72 ürün
                                                </div> --->
                                            </div>
                                        </a>
                                    </div>
                                    <!-- /ko -->
                                </div>   
                            </div>
                        </div>
                        <div class="step_item" data-bind="visible: $root.productstep() == 'prodlist'">
                            <div class="step_head head_left">
                                <h1>
                                    <span data-bind="text:$root.category_head"></span>
                                    <!--- <ul>
                                        <li>
                                            <a id="back" href="javascript://" data-bind="click: $root.setProductCategory">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M24,44c11.028,0,20-8.972,20-20S35.028,4,24,4S4,12.972,4,24S12.972,44,24,44z M15.439,22.939l6-6 c0.586-0.586,1.535-0.586,2.121,0s0.586,1.535,0,2.121L20.121,22.5H31.5c0.828,0,1.5,0.672,1.5,1.5s-0.672,1.5-1.5,1.5H20.121 l3.439,3.439c0.586,0.586,0.586,1.535,0,2.121C23.268,31.354,22.884,31.5,22.5,31.5s-0.768-0.146-1.061-0.439l-6-6 C14.854,24.475,14.854,23.525,15.439,22.939z"></path></svg>
                                            </a>
                                        </li>
                                    </ul> --->
                                </h1>
                            </div>
                            <div class="step_body step_body-type3">
                               <!---  <form>
                                    <div class="form-group form-group-type4">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 20.5 6 C 12.509634 6 6 12.50964 6 20.5 C 6 28.49036 12.509634 35 20.5 35 C 23.956359 35 27.133709 33.779044 29.628906 31.75 L 39.439453 41.560547 A 1.50015 1.50015 0 1 0 41.560547 39.439453 L 31.75 29.628906 C 33.779044 27.133709 35 23.956357 35 20.5 C 35 12.50964 28.490366 6 20.5 6 z M 20.5 9 C 26.869047 9 32 14.130957 32 20.5 C 32 23.602612 30.776198 26.405717 28.791016 28.470703 A 1.50015 1.50015 0 0 0 28.470703 28.791016 C 26.405717 30.776199 23.602614 32 20.5 32 C 14.130953 32 9 26.869043 9 20.5 C 9 14.130957 14.130953 9 20.5 9 z"></path></svg>
                                        <input type="text" placeholder="Anahtar Kelime" data-bind="value: $root.Productkeyword, valueUpdate: 'input', findProductByKeyword: findProduct">
                                    </div>
                                </form> --->
                                <div class="category category_detail">
                                    <!-- ko foreach: $root.productsDup -->
                                    <div class="cl-xl-3 cl-md-6 cl-sm-12 cl-xs-12">
                                        <div class="category_list_item">
                                            <div style="width:180px;">
                                                <div class="category_list_item_icon" data-bind="visible: basketService.get('cashSettings')[0].USE_PRODUCT_IMAGE == 1">
                                                    <img data-bind="attr:{src: PATH}">
                                                </div>
                                                <div class="category_list_item_text">
                                                    <div class="name" data-bind="text: NAME_PRODUCT_.substring(0,30)">
                                                    </div>
                                                    <div class="price">
                                                    <span data-bind="text: commaSplit(PRICE_KDV, basketService.priceRoundNumber()) + ' ' + MONEY"></span> <sup>29.99</sup>
                                                    </div>
                                                    <div class="step_foot">
                                                        <ul class="buton_list" id="svg">
                                                            <li>
                                                                <a href="javascript://" style="font-size:15px">
                                                                    <div class="form-group" style="margin:3px 0px">
                                                                        <input type="text" data-bind="value: commaSplit(1, basketService.priceRoundNumber()), attr:{'id': 'amnt'+$index()}" class="moneybox urun_input_css" style="background: rgba(215, 184, 89, 0.4);border-radius: 10px 0px 0px 10px;text-align: center;padding: 7px!important;height: auto;" onClick="this.select();">
                                                                    </div>
                                                                    <svg data-bind="click: function () { $root.add_to_basket(this, document.getElementById('amnt'+$index()).value ) } "  xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 3.5 6 A 1.50015 1.50015 0 1 0 3.5 9 L 6.2558594 9 C 6.9837923 9 7.5905865 9.5029243 7.7285156 10.21875 L 8.0273438 11.78125 L 11.251953 28.716797 C 11.835068 31.772321 14.527135 34 17.638672 34 L 36.361328 34 C 39.472865 34 42.166064 31.773177 42.748047 28.716797 L 45.972656 11.78125 A 1.50015 1.50015 0 0 0 44.5 10 L 32 10 L 32 13 L 42.6875 13 L 39.800781 28.15625 C 39.484764 29.81587 38.051791 31 36.361328 31 L 17.638672 31 C 15.948808 31 14.516781 29.8158 14.199219 28.15625 L 14.199219 28.154297 L 11.3125 13 L 23 13 L 23 10 L 10.740234 10 L 10.675781 9.6582031 C 10.272657 7.5455321 8.4069705 6 6.2558594 6 L 3.5 6 z M 27.476562 6.9785156 A 1.50015 1.50015 0 0 0 26 8.5 L 26 21.878906 L 23.560547 19.439453 A 1.50015 1.50015 0 1 0 21.439453 21.560547 L 26.439453 26.560547 A 1.50015 1.50015 0 0 0 28.560547 26.560547 L 33.560547 21.560547 A 1.50015 1.50015 0 1 0 31.439453 19.439453 L 29 21.878906 L 29 8.5 A 1.50015 1.50015 0 0 0 27.476562 6.9785156 z M 20 36 A 3 3 0 0 0 20 42 A 3 3 0 0 0 20 36 z M 34 36 A 3 3 0 0 0 34 42 A 3 3 0 0 0 34 36 z"></path></svg>
                                                                </a>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /ko -->
                                    <!-- ko if: $root.productsDup().length == 0 -->
                                        <div class="step_head">
                                            <p>Ürün bulunamadı.</p>
                                        </div>
                                    <!-- /ko -->
                                </div>   
                            </div>
                        </div>
                    </div>
                </div>
            
                <div class="custom_box cl-12 cl-md-4 cl-sm-6 col-xs-12 border" style="padding:0 !important;">
                    <div class="step_header col-12 " style="background:#FFF6D8;">
                        <div class="step_head col-4" style="margin-left: 10px;">
                            <div class="col col-3">
                                <i class="fa fa-shopping-basket"></i> 
                            </div>
                            <div class="col col-9">
                                <h1 style="margin:5px 15px;color:#F49300;">SEPET</h1>
                            </div>
                        </div>
                        <div class="step_head col-8">
                            <div class="col col-12 text-right">
                            <!-- ko if: $root.basketItems().length > 0 -->
                                <p class="m-2 text-info">Sepetinizde <span data-bind="text: $root.basketItems().length"></span> ürün var.</p>
                            <!-- /ko -->
                            </div>
                        </div>
                    </div>
                    <div class="step_container">
                        <div class="step_item">
                            <!-- ko if: $root.basketItems().length > 0 -->
                            <div class="step_body">
                                <ul class="product_list">
                                    <!-- ko foreach: $root.basketItems -->
                                    <li>
                                        <div class="right">
                                            <div class="name">
                                                <span data-bind="text: product_name()"></span>
                                                <div class="icon">
                                                    <a href="javascript://" class="delete" data-bind="click: $root.clear_row.bind($index())">
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 24 4 C 20.491685 4 17.570396 6.6214322 17.080078 10 L 10.238281 10 A 1.50015 1.50015 0 0 0 9.9804688 9.9785156 A 1.50015 1.50015 0 0 0 9.7578125 10 L 6.5 10 A 1.50015 1.50015 0 1 0 6.5 13 L 8.6386719 13 L 11.15625 39.029297 C 11.427329 41.835926 13.811782 44 16.630859 44 L 31.367188 44 C 34.186411 44 36.570826 41.836168 36.841797 39.029297 L 39.361328 13 L 41.5 13 A 1.50015 1.50015 0 1 0 41.5 10 L 38.244141 10 A 1.50015 1.50015 0 0 0 37.763672 10 L 30.919922 10 C 30.429604 6.6214322 27.508315 4 24 4 z M 24 7 C 25.879156 7 27.420767 8.2681608 27.861328 10 L 20.138672 10 C 20.579233 8.2681608 22.120844 7 24 7 z M 11.650391 13 L 36.347656 13 L 33.855469 38.740234 C 33.730439 40.035363 32.667963 41 31.367188 41 L 16.630859 41 C 15.331937 41 14.267499 40.033606 14.142578 38.740234 L 11.650391 13 z M 20.476562 17.978516 A 1.50015 1.50015 0 0 0 19 19.5 L 19 34.5 A 1.50015 1.50015 0 1 0 22 34.5 L 22 19.5 A 1.50015 1.50015 0 0 0 20.476562 17.978516 z M 27.476562 17.978516 A 1.50015 1.50015 0 0 0 26 19.5 L 26 34.5 A 1.50015 1.50015 0 1 0 29 34.5 L 29 19.5 A 1.50015 1.50015 0 0 0 27.476562 17.978516 z"></path></svg>
                                                    </a>
                                                    <a href="javascript://" onclick="$(this).parents('li').find('.discount').fadeToggle()">
                                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 24 4 C 12.972066 4 4 12.972074 4 24 C 4 35.027926 12.972066 44 24 44 C 35.027934 44 44 35.027926 44 24 C 44 12.972074 35.027934 4 24 4 z M 24 7 C 33.406615 7 41 14.593391 41 24 C 41 33.406609 33.406615 41 24 41 C 14.593385 41 7 33.406609 7 24 C 7 14.593391 14.593385 7 24 7 z M 24 14 A 2 2 0 0 0 24 18 A 2 2 0 0 0 24 14 z M 23.976562 20.978516 A 1.50015 1.50015 0 0 0 22.5 22.5 L 22.5 33.5 A 1.50015 1.50015 0 1 0 25.5 33.5 L 25.5 22.5 A 1.50015 1.50015 0 0 0 23.976562 20.978516 z"></path></svg>
                                                    </a>
                                                </div>
                                            </div>
                                            <div class="category">
                                                <p data-bind="text: barcod()"></p>
                                            </div>
                                            <div class="slot">
                                                <a href="javascript://" class="minus" data-bind="click: function(){ $root.downAmount( $index() ) }">
                                                    <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="172.000000pt"
                                                        height="172.000000pt" viewBox="0 0 172.000000 172.000000"
                                                        preserveAspectRatio="xMidYMid meet">
                                                        <g transform="translate(0.000000,172.000000) scale(0.100000,-0.100000)"
                                                            fill="#FFFFFF" stroke="none">
                                                            <path d="M195 895 c-30 -29 -31 -35 -4 -69 l20 -26 649 0 649 0 20 26 c27 34
                                                            26 40 -4 69 l-24 25 -641 0 -641 0 -24 -25z" />
                                                        </g>
                                                    </svg>
                                                </a>
                                                <span data-bind="text: amount() +'   '+ unit()"></span>
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                <a href="javascript://" class="plus" data-bind="click: function(){ $root.upAmount( $index() ) } ">
                                                    <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="172.000000pt"
                                                        height="172.000000pt" viewBox="0 0 172.000000 172.000000"
                                                        preserveAspectRatio="xMidYMid meet">
                                                        <g transform="translate(0.000000,172.000000) scale(0.100000,-0.100000)"
                                                            fill="#FFFFFF" stroke="none">
                                                            <path d="M826 1529 l-26 -20 0 -295 0 -294 -290 0 -291 0 -24 -25 c-30 -29
                                                            -31 -35 -4 -69 l20 -26 295 0 294 0 0 -290 0 -291 25 -24 c29 -30 35 -31 69
                                                            -4 l26 20 0 295 0 294 294 0 295 0 20 26 c27 34 26 40 -4 69 l-24 25 -291 0
                                                            -290 0 0 294 0 295 -26 20 c-15 12 -30 21 -34 21 -4 0 -19 -9 -34 -21z" />
                                                        </g>
                                                    </svg>
                                                </a>
                                                <div class="price w-25">
                                                    x <span data-bind="text: commaSplit(price())"></span> <span data-bind="text: other_money()"></span> 
                                                </div>
                                                <div class="tax w-25">
                                                   <span data-bind="text: tax() +'% KDV'"></span>
                                                </div>
                                                <div class="total w-25 text-right">
                                                    <span data-bind="text: commaSplit(row_lasttotal()) +' '+ other_money()"></span>
                                                 </div>
                                            </div>
                                            <div style="display:none;" class="discount">
                                                <span>Vergisiz Toplam <b data-bind="text: commaSplit(row_lasttotal() - row_taxtotal()) +' '+ other_money()" class="float-right"></b></span>
                                                <span>Vergi Toplam <b data-bind="text: commaSplit(row_taxtotal()) +' '+ other_money()" class="float-right"></b></span>
                                                
                                            </div>
                                        </div>
                                    </li>
                                    <!-- /ko -->
                                </ul>
                            </div>
                            <!-- /ko -->
                            <div class="step_foot">
                                <ul class="buton_list" id="fill">
                                    <li>
                                        <a href="javascript://" class="m-0 total_button">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 24 2 C 22.356093 2 21.001828 2.8518022 19.998047 4 L 15.5 4 A 1.50015 1.50015 0 0 0 14.095703 6.0273438 L 16.708984 12.996094 C 13.827319 15.296947 4.6482071 23.518742 5.0605469 34.875 C 5.2455187 39.961724 9.4739826 44 14.556641 44 L 33.443359 44 C 38.526017 44 42.754481 39.961724 42.939453 34.875 C 43.352709 23.5187 34.172899 15.296937 31.291016 12.996094 L 33.904297 6.0273438 A 1.50015 1.50015 0 0 0 32.5 4 L 28.001953 4 C 26.998172 2.8518022 25.643907 2 24 2 z M 24 5 C 24.929268 5 25.709157 5.4989516 26.148438 6.2539062 A 1.50015 1.50015 0 0 0 27.445312 7 L 30.335938 7 L 28.460938 12 L 19.539062 12 L 17.664062 7 L 20.554688 7 A 1.50015 1.50015 0 0 0 21.851562 6.2539062 C 22.290843 5.4989516 23.070732 5 24 5 z M 19.015625 15 L 28.984375 15 C 30.716458 16.361495 40.319252 24.382382 39.941406 34.765625 C 39.814378 38.258901 36.946702 41 33.443359 41 L 14.556641 41 C 11.053298 41 8.185622 38.258901 8.0585938 34.765625 C 7.6815819 24.382337 17.283671 16.361488 19.015625 15 z M 23.976562 17.978516 A 1.50015 1.50015 0 0 0 22.5 19.5 L 22.5 20.226562 C 20.50407 20.796741 19 22.56853 19 24.732422 L 19 24.734375 C 19 27.348199 21.151754 29.5 23.765625 29.5 L 25.234375 29.5 C 26.226504 29.5 27 30.273496 27 31.265625 C 27 32.252155 26.235274 33.021038 25.248047 33.029297 L 23.408203 33.044922 C 22.762885 33.044922 22.242497 32.626351 22.064453 32.060547 A 1.50015 1.50015 0 1 0 19.203125 32.960938 C 19.66952 34.443086 20.979871 35.394155 22.5 35.744141 L 22.5 36.5 A 1.50015 1.50015 0 1 0 25.5 36.5 L 25.5 35.982422 C 27.988983 35.836086 30 33.784959 30 31.265625 C 30 28.651754 27.848246 26.5 25.234375 26.5 L 23.765625 26.5 C 22.773496 26.5 22 25.726504 22 24.734375 L 22 24.732422 C 22 23.750223 22.757851 22.981106 23.740234 22.966797 L 24.564453 22.955078 C 25.213384 22.955078 25.737616 23.378758 25.912109 23.949219 A 1.50015 1.50015 0 1 0 28.78125 23.072266 C 28.325873 21.583534 27.01795 20.628213 25.5 20.267578 L 25.5 19.5 A 1.50015 1.50015 0 0 0 23.976562 17.978516 z"></path></svg>
                                            Toplam : <span data-bind="basketFooterTotalElement: $root.basketFooter.basket_net_total"> 
                                        </a>
                                    </li>
                                </ul>
                                <div class="form-group form-group-type3">
                                    <button type="submit" data-bind="click: function() { $('#pay_modal_panel').fadeIn() } " class="p-0 m-0 nk_button">
                                        N / K
                                    </button>
                                    <button type="submit" data-bind="click: function() { $('#pay_modal_panel').fadeIn() }" class="p-0 credicard_button">
                                        <span class="fa fa-credit-card" style="transform: rotate(-25deg);color:#997878;margin:0 5px;"></span>&nbsp;KREDİ KARTI
                                    </button>
                                    <button type="submit" data-bind="click: function() { $('#pay_modal_panel').fadeIn() }" class="cash_button">
                                        <span class="fa fa-money" style="transform: rotate(-25deg)"></span>&nbsp;NAKİT
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            <!--- </div>
                <div class="bootstrap pt-0"> --->
                <!--- <div class="custom_box cl-12 cl-md-4 cl-sm-6" data-bind="visible: $root.boxstep() == 'addressdetail'">
                    <div class="step_container">
                        <div style="" class="step_item">
                            <div class="step_head">
                                <h1>
                                    Adres
                                    <ul>
                                        <li>
                                            <a id="back" href="javascript://" data-bind="click: $root.setProductNone">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M24,44c11.028,0,20-8.972,20-20S35.028,4,24,4S4,12.972,4,24S12.972,44,24,44z M15.439,22.939l6-6 c0.586-0.586,1.535-0.586,2.121,0s0.586,1.535,0,2.121L20.121,22.5H31.5c0.828,0,1.5,0.672,1.5,1.5s-0.672,1.5-1.5,1.5H20.121 l3.439,3.439c0.586,0.586,0.586,1.535,0,2.121C23.268,31.354,22.884,31.5,22.5,31.5s-0.768-0.146-1.061-0.439l-6-6 C14.854,24.475,14.854,23.525,15.439,22.939z"></path></svg>
                                            </a>
                                        </li>
                                    </ul>
                                </h1>
                                <p>Adres bilgilerinizi seçiniz.</p>
                            </div>
                            <div class="step_body">
                                <form onsubmit="return false">
                                    <div class="form-group">
                                        <b>
                                            <i>Kayıtlı Adresler</i>
                                            <a href="javascript://" class="plus">
                                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 23.976562 4.9785156 A 1.50015 1.50015 0 0 0 22.5 6.5 L 22.5 22.5 L 6.5 22.5 A 1.50015 1.50015 0 1 0 6.5 25.5 L 22.5 25.5 L 22.5 41.5 A 1.50015 1.50015 0 1 0 25.5 41.5 L 25.5 25.5 L 41.5 25.5 A 1.50015 1.50015 0 1 0 41.5 22.5 L 25.5 22.5 L 25.5 6.5 A 1.50015 1.50015 0 0 0 23.976562 4.9785156 z"></path></svg>
                                            </a>
                                        </b>
                                        <label>
                                            <input type="radio" id="adress" name="adress-radio">
                                            Fatura Adresi
                                            <span class="checkmark"></span>
                                        </label>
                                        <label>
                                            <input type="radio" id="adress" name="adress-radio">
                                            Ev Adresi
                                            <span class="checkmark"></span>
                                        </label>
                                    </div>
                                    <div style="" class="adress">
                                        <h6>
                                            <i>Yeni Ekle</i>
                                        </h6>
                                        <div class="form-group">
                                            <label>
                                                <input type="radio" id="corporate" name="corporate">
                                                Kurumsal
                                                <span class="checkmark"></span>
                                            </label>
                                            <label>
                                                <input type="radio" id="single" name="corporate">
                                                Bireysel
                                                <span class="checkmark"></span>
                                            </label>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Firma">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Vergi Dairesi">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Vergi No">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Kimlik No">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Mobil">
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group form-group-type2 cl-6">
                                                <input type="text" placeholder="Ad">
                                            </div>
                                            <div class="form-group form-group-type2 cl-6">
                                                <input type="text" placeholder="Soyad">
                                            </div>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Kimlik No">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Mobil">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="E-Posta">
                                        </div>
                                        <div class="form-group">
                                            <label>
                                                <input type="radio" id="invoice" name="invoice">
                                                Fatura Adresi
                                                <span class="checkmark"></span>
                                            </label>
                                            <label>
                                                <input type="radio" id="delivery" name="invoice">
                                                Teslim Adresi
                                                <span class="checkmark"></span>
                                            </label>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <select>
                                                <option selected>Ülke</option>
                                                <option>Türkiye</option>
                                            </select>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <select>
                                                <option selected>İl</option>
                                                <option>İstanbul</option>
                                            </select>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <select>
                                                <option selected>İlçe</option>
                                                <option>Üsküdar</option>
                                            </select>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <select>
                                                <option selected>Mahalle</option>
                                                <option>Cengiz Topel</option>
                                            </select>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <select>
                                                <option selected>Sokak</option>
                                                <option>BabaEski</option>
                                            </select>
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group form-group-type2 cl-6">
                                                <input type="text" placeholder="Kapı No">
                                            </div>
                                            <div class="form-group form-group-type2 cl-6">
                                                <input type="text" placeholder="İç Kapı No">
                                            </div>
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <input type="text" placeholder="Zip Code / Posta Kodu">
                                        </div>
                                        <div class="form-group form-group-type2">
                                            <textarea rows="5" placeholder="Adres Tarifi"></textarea>
                                        </div>
                                        <div class="form-group form-group-type3">
                                            <button type="submit">
                                                Kaydet
                                            </button>
                                        </div>
                                    </div>
                                </form>    
                            </div>
                            <div class="step_foot">
                                <ul class="buton_list">
                                    <li>
                                        <a href="javascript://" data-bind="click: $root.setPayDetail">
                                            <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="172.000000pt" height="172.000000pt"
                                                viewBox="0 0 172.000000 172.000000" preserveAspectRatio="xMidYMid meet">
                                                <g transform="translate(0.000000,172.000000) scale(0.100000,-0.100000)" fill="#FFF" stroke="none">
                                                    <path d="M753 1511 c-395 -109 -495 -145 -544 -198 l-23 -24 49 23 c50 23 53
                                                    23 563 26 l512 3 0 92 c0 139 -32 187 -125 186 -22 0 -217 -49 -432 -108z" />
                                                    <path d="M287 1267 c-57 -18 -107 -64 -134 -123 l-24 -53 3 -408 c3 -361 5
                                                    -412 20 -439 22 -40 81 -92 116 -101 35 -10 1149 -10 1184 0 35 9 94 61 116
                                                    101 15 27 17 77 20 429 4 462 2 477 -71 544 -32 30 -58 44 -96 52 -74 16
                                                    -1082 14 -1134 -2z m1108 -530 c18 -42 2 -85 -38 -102 -42 -17 -78 -5 -101 35
                                                -19 33 -19 33 0 69 32 60 113 59 139 -2z" />
                                                </g>
                                            </svg>
                                            Ödeme Yap
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div> --->
                <div id="pay_modal_panel" class="ui-cfmodal-panel" style="display:none;">
                    <div class="ui-cfmodal clever" id="pay_modal" <!--- data-bind="visible: $root.boxstep() == 'paydetail'" --->>
                        <cf_box id="pay_modal" title="Ödeme" resize="0" closable="1" call_function="cfmodalx({e:'close',id:'pay_modal_panel'});" close_href="javascript://" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08)!important;padding:20px 30px!important;">
                            <div class="step_container p-0">
                                <div class="step_item" style="padding:0px;">
                                    <div class="step_body overflow">
                                        <div class="col col-6 col-md-12 col-xs-12">
                                            <!--- <div class="form-group">
                                                <b>Ödeme Seçenekleri</b>
                                                <label>
                                                    <input type="radio" id="credit-card" name="credit-card-radio">
                                                    Kredi Kartı
                                                    <span class="checkmark"></span>
                                                    <a href="javascript://" class="plus">
                                                        <svg version="1.0" xmlns="http://www.w3.org/2000/svg" width="172.000000pt"
                                                            height="172.000000pt" viewBox="0 0 172.000000 172.000000"
                                                            preserveAspectRatio="xMidYMid meet">
                                                            <g transform="translate(0.000000,172.000000) scale(0.100000,-0.100000)"
                                                                fill="#FFFFFF" stroke="none">
                                                                <path d="M826 1529 l-26 -20 0 -295 0 -294 -290 0 -291 0 -24 -25 c-30 -29
                                                                -31 -35 -4 -69 l20 -26 295 0 294 0 0 -290 0 -291 25 -24 c29 -30 35 -31 69
                                                                -4 l26 20 0 295 0 294 294 0 295 0 20 26 c27 34 26 40 -4 69 l-24 25 -291 0
                                                                -290 0 0 294 0 295 -26 20 c-15 12 -30 21 -34 21 -4 0 -19 -9 -34 -21z" />
                                                            </g>
                                                        </svg>
                                                    </a>
                                                </label>
                                                <label>
                                                    <input type="radio" id="credit-card" name="credit-card-radio">
                                                    Kapıda Ödeme - Nakit Ödeme
                                                    <span class="checkmark"></span>
                                                </label>
                                            </div>
                                            <div style="" class="form-group">
                                                <b>Kayıtlı Kredi Kartlarınız</b>
                                                <label>
                                                    <input type="radio" id="credit-card2" name="credit-card-radio2">
                                                    Garanti Bankası
                                                    <span class="checkmark"></span>
                                                </label>
                                                <label>
                                                    <input type="radio" id="credit-card2" name="credit-card-radio2">
                                                    Yapı Kredi Bankası
                                                    <span class="checkmark"></span>
                                                </label>
                                            </div>
                                            <div style="" class="credit-card">
                                                <h6>
                                                    <i>Yeni Ekle</i>
                                                </h6>
                                                <div class="form-group form-group-type2">
                                                    <input type="text" placeholder="Kartın Üzerindeki İsim">
                                                </div>
                                                <div class="form-group form-group-type2">
                                                    <input type="text" placeholder="Banka">
                                                </div>
                                                <div class="form-group form-group-type2">
                                                    <input type="text" placeholder="Kart No">
                                                </div>
                                                <div class="form-row">
                                                    <div class="form-group form-group-type2 cl-4">
                                                        <input type="text" placeholder="CVV">
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-4">
                                                        <input type="text" placeholder="Tarih">
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-4">
                                                        <input type="text" placeholder="Pin">
                                                    </div>
                                                </div>
                                                <div class="form-group form-group-type3">
                                                    <button type="submit">
                                                        Kaydet
                                                    </button>
                                                </div>
                                            </div> --->
                                            <div class="form-row">
                                                <div class="form-group form-group-type2">
                                                    <div class="step_head">
                                                        <p>
                                                            <span class="fa fa-money" style="transform: rotate(-25deg);margin-left:3px;"></span>&nbsp;Nakit
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- ko foreach: $root.basketFooter.cash_list -->
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 cl-7 mb-1">
                                                    <input type="hidden" data-bind="value: $data.system_cash_amount, attr:{'id': 'system_cash_amount'+($index()+1), 'name': 'system_cash_amount'+($index()+1)}">
                                                    <input type="hidden" data-bind="value: $data.currency_type ,attr:{'id': 'currency_type'+($index()+1), 'name': 'currency_type'+($index()+1)}">
                                                    <input type="hidden" data-bind="value: $data.cash_action_id, attr:{'id': 'cash_action_id_'+($index()+1), 'name': 'cash_action_id_'+($index()+1)}">
                                                    <input type="text" autocomplete="off" data-bind="tlValue: $data.cash_amount, attr:{'id': 'cash_amount'+($index()+1), 'name': 'cash_amount'+($index()+1)}, click: $root.addCashIndex.bind(this, $index() ) " class="moneybox" onClick="this.select();">
                                                </div>
                                                <div class="form-group form-group-type2 cl-5 mb-1">
                                                    <select style="background-size:unset;text-align:right;" disabled data-bind ="value: $data.kasa, attr:{'id': 'kasa'+($index()+1), 'name': 'kasa'+($index()+1)}, options: $data.items, optionsValue: 'ID', optionsText: 'TEXT'"></select>
                                                </div>
                                            </div>
                                            <!-- /ko -->
                                        </div>
                                        <div class="col col-6 pb-2 col-md-12 col-xs-12">
                                            <div class="form-row">
                                                <div class="form-group form-group-type2">
                                                    <div class="step_head">
                                                        <p class="color-darkCyan"><span class="fa fa-credit-card" style="transform: rotate(-25deg);color:#997878;"></span>&nbsp;Kredi Kartı</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- ko foreach: $root.basketFooter.pos_list -->
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 cl-7 mb-1">
                                                    <input type="hidden" data-bind="attr:{'id': 'pos_action_id_'+($index()+1), 'name': 'pos_action_id_'+($index()+1)}">
                                                    <input type="hidden" data-bind="attr:{'id': 'system_pos_amount_'+($index()+1), 'name': 'system_pos_amount_'+($index()+1)}">
                                                    <input type="text" autocomplete="off" data-bind="tlValue: $data.pos_amount, attr:{'id': 'pos_amount_'+($index()+1), 'name': 'pos_amount_'+($index()+1)}, click: $root.addPosIndex.bind(this, $index() )" onClick="this.select();">
                                                </div>
                                                <div class="form-group form-group-type2 cl-5 mb-1">
                                                    <select data-bind ="value: $data.pos, attr:{'id': 'pos'+($index()+1), 'name': 'pos'+($index()+1)}, options: $data.items, optionsValue: 'ID', optionsText: 'TEXT'"></select>
                                                </div>	
                                            </div>
                                            <!-- /ko -->
                                        </div>
                                        <div class="col col-4 border-top pt-2 col-md-12 col-xs-12">
                                            <div class="form-row" style="justify-content:center;">
                                                <div class="form-group form-row">
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 1)">1</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 2)">2</button>                                      
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 3)">3</button>
                                                </div>
                                            </div>
                                            <div class="form-row" style="justify-content:center;">
                                                <div class="form-group form-row">
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 4)">4</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 5)">5</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 6)">6</button>
                                                </div>
                                            </div>
                                            <div class="form-row" style="justify-content:center;">
                                                <div class="form-group form-row">
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 7)">7</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 8)">8</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 9)">9</button>
                                                </div>
                                            </div>
                                            <div class="form-row" style="justify-content:center;">
                                                <div class="form-group form-row">
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 'x')">Sil</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, 0)">0</button>
                                                    <button type="submit" class="color-X m-1" style="font-weight:normal !important;width:60px;" data-bind="click: $root.chMoney.bind(this, ',')">,</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col col-8 border-top pt-2 col-md-12 col-xs-12">
                                            <!-- ko if: $root.basketFooter.pos_list || $root.basketFooter.cash_list -->
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 mt cl-6 mb-1">
                                                    <b>Alışveriş Toplamı</b>
                                                </div>
                                                <div class="form-group form-group-type2 cl-6 mb-1 ">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.basket_net_total" class="moneybox color-SU" readonly="yes" onClick="this.select();">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 mt cl-6 mb-1">
                                                    <b>Nakit Ödenen</b>
                                                </div>
                                                <div class="form-group form-group-type2 cl-6 mb-1">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.cash_amount" class="moneybox color-PM" readonly="yes" onClick="this.select();">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 mt cl-6 mb-1">
                                                    <b>Kartla Ödenen</b>
                                                </div>
                                                <div class="form-group form-group-type2 cl-6 mb-1">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.card_amount" class="moneybox color-I" readonly="yes" onClick="this.select();">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 mt cl-6 mb-1">
                                                    <b>Toplam Ödenen</b>
                                                </div>
                                                <div class="form-group form-group-type2 cl-6 mb-1">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.total_cash_amount" class="moneybox color-LM" readonly="yes" onClick="this.select();">
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="form-group form-group-type2 mt cl-6 mb-1">
                                                    <b>Fark</b>
                                                </div>
                                                <div class="form-group form-group-type2 cl-6 mb-1">
                                                    <input type="text" data-bind="tlValue: $root.basketFooter.diff_amount" class="moneybox color-Home" readonly="yes" onClick="this.select();">
                                                </div>
                                            </div>
                                            <!-- /ko -->
                                        </div> 
                                    </div>
                                    <div class="step_foot border-top" style="padding:9px 10px;">
                                        <div class="form-group form-group-type3">
                                            <button type="submit" class="cancel_button" style="color:white!important;" data-bind="click: function(){ delamount(); }">
                                                İptal
                                            </button>
                                            <button type="submit" class="complete_button" style="color:white!important;" data-bind="click: function(){kontrol();}">
                                                Alışverişi Tamamla
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </cf_box>
                    </div>
                </div>
                <!--- <div class="custom_box cl-12 cl-md-4 cl-sm-6" data-bind="visible: $root.boxstep() == 'resultdetail'">
                    <div class="step_container">
                        <div style="" class="step_item">
                            <div class="step_head">
                                <h1>Kredi Kartı işlemi yapılıyor...</h1>
                            </div>
                            <div class="step_body">
                                <ul class="result_list">
                                    <li>
                                        <a href="javascript://">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 24 4 C 12.972066 4 4 12.972074 4 24 C 4 35.027926 12.972066 44 24 44 C 35.027934 44 44 35.027926 44 24 C 44 12.972074 35.027934 4 24 4 z M 18 16.5 C 19.381 16.5 20.5 17.619 20.5 19 C 20.5 20.381 19.381 21.5 18 21.5 C 16.619 21.5 15.5 20.381 15.5 19 C 15.5 17.619 16.619 16.5 18 16.5 z M 30 16.5 C 31.381 16.5 32.5 17.619 32.5 19 C 32.5 20.381 31.381 21.5 30 21.5 C 28.619 21.5 27.5 20.381 27.5 19 C 27.5 17.619 28.619 16.5 30 16.5 z M 15.650391 28.003906 C 16.130547 27.969238 16.6175 28.166016 16.9375 28.572266 C 18.6515 30.751266 21.226 32 24 32 C 26.774 32 29.3485 30.750266 31.0625 28.572266 C 31.5745 27.922266 32.514969 27.808266 33.167969 28.322266 C 33.817969 28.833266 33.932922 29.776734 33.419922 30.427734 C 31.133922 33.332734 27.7 35 24 35 C 20.3 35 16.866078 33.333734 14.580078 30.427734 C 14.067078 29.776734 14.182031 28.832313 14.832031 28.320312 C 15.076531 28.127562 15.362297 28.024707 15.650391 28.003906 z"></path></svg>
                                            İşlem Onayı Tamamlandı.
                                        </a>
                                    </li>
                                    <li style="">
                                        <a href="javascript://">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 24 4 C 12.972066 4 4 12.972074 4 24 C 4 35.027926 12.972066 44 24 44 C 35.027934 44 44 35.027926 44 24 C 44 12.972074 35.027934 4 24 4 z M 18 16.5 C 19.381 16.5 20.5 17.619 20.5 19 C 20.5 20.381 19.381 21.5 18 21.5 C 16.619 21.5 15.5 20.381 15.5 19 C 15.5 17.619 16.619 16.5 18 16.5 z M 30 16.5 C 31.381 16.5 32.5 17.619 32.5 19 C 32.5 20.381 31.381 21.5 30 21.5 C 28.619 21.5 27.5 20.381 27.5 19 C 27.5 17.619 28.619 16.5 30 16.5 z M 24 26 C 27.7 26 31.133922 27.666266 33.419922 30.572266 C 33.932922 31.223266 33.817969 32.167687 33.167969 32.679688 C 32.892969 32.896687 32.564234 33 32.240234 33 C 31.796234 33 31.3575 32.803734 31.0625 32.427734 C 29.3485 30.248734 26.774 29 24 29 C 21.226 29 18.6515 30.249734 16.9375 32.427734 C 16.4265 33.077734 15.484031 33.192734 14.832031 32.677734 C 14.182031 32.166734 14.067078 31.223266 14.580078 30.572266 C 16.866078 27.667266 20.3 26 24 26 z"></path></svg>
                                            Üzgünüz İşlem Onayı Alanımadı.
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript://">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M24 25.29L4.02 14.5C4.28 11.42 6.86 9 10 9h28c3.14 0 5.72 2.42 5.98 5.5L24 25.29zM23.76 28.48C22.64 30.4 22 32.62 22 35c0 2.16.53 4.2 1.47 6H10c-3.31 0-6-2.69-6-6V17.89l19.29 10.43C23.44 28.4 23.6 28.46 23.76 28.48zM44 17.89v7.74c-2.04-1.97-4.73-3.28-7.72-3.56L44 17.89zM35 24c-6.075 0-11 4.925-11 11s4.925 11 11 11c6.075 0 11-4.925 11-11S41.075 24 35 24zM40.707 36.707l-5 5C35.512 41.902 35.256 42 35 42s-.512-.098-.707-.293l-5-5c-.391-.391-.391-1.023 0-1.414s1.023-.391 1.414 0L34 38.586V28c0-.552.447-1 1-1s1 .448 1 1v10.586l3.293-3.293c.391-.391 1.023-.391 1.414 0S41.098 36.316 40.707 36.707z"></path></svg>
                                            Faturayı Mail Gönder
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript://">
                                            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48"><path d="M 23.976562 0.93359375 A 1.50015 1.50015 0 0 0 22.5 2.453125 L 22.5 4.953125 L 21 4.953125 C 20.393 4.953125 19.845281 5.3208594 19.613281 5.8808594 C 19.536281 6.0668594 19.5 6.260125 19.5 6.453125 C 19.5 6.844125 19.652453 7.228625 19.939453 7.515625 L 22.939453 10.515625 C 23.525453 11.101625 24.474547 11.101625 25.060547 10.515625 L 28.060547 7.515625 C 28.488547 7.087625 28.619719 6.4428594 28.386719 5.8808594 C 28.154719 5.3208594 27.607 4.953125 27 4.953125 L 25.5 4.953125 L 25.5 2.453125 A 1.50015 1.50015 0 0 0 23.976562 0.93359375 z M 13.476562 5.9785156 A 1.50015 1.50015 0 0 0 12 7.5 L 12 13 L 10.5 13 C 6.916 13 4 15.916 4 19.5 L 4 33.5 C 4 35.981 6.019 38 8.5 38 L 12 38 L 12 40.5 C 12 42.967501 14.032499 45 16.5 45 L 31.5 45 C 33.967501 45 36 42.967501 36 40.5 L 36 38 L 39.5 38 C 41.981 38 44 35.981 44 33.5 L 44 19.5 C 44 15.916 41.084 13 37.5 13 L 36 13 L 36 7.5 A 1.50015 1.50015 0 0 0 34.476562 5.9785156 A 1.50015 1.50015 0 0 0 33 7.5 L 33 13 L 15 13 L 15 7.5 A 1.50015 1.50015 0 0 0 13.476562 5.9785156 z M 16.5 30 L 31.5 30 C 32.346499 30 33 30.653501 33 31.5 L 33 40.5 C 33 41.346499 32.346499 42 31.5 42 L 16.5 42 C 15.653501 42 15 41.346499 15 40.5 L 15 31.5 C 15 30.653501 15.653501 30 16.5 30 z"></path></svg>
                                            Print Et
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript://">
                                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M24,4C12.97,4,4,12.97,4,24c0,3.19,0.77,6.34,2.23,9.17l-2.14,7.66c-0.24,0.87,0.01,1.8,0.64,2.44 C5.21,43.74,5.85,44,6.5,44c0.23,0,0.45-0.03,0.67-0.09l7.66-2.14C17.66,43.23,20.82,44,24,44c11.03,0,20-8.97,20-20 C44,12.97,35.03,4,24,4z M34.36,31.37c-0.44,1.23-2.6,2.42-3.57,2.51c-0.97,0.09-1.88,0.44-6.34-1.32 c-5.38-2.12-8.78-7.63-9.04-7.99c-0.27-0.35-2.16-2.86-2.16-5.47c0-2.6,1.37-3.88,1.85-4.41c0.49-0.53,1.06-0.66,1.41-0.66 c0.36,0,0.71,0,1.02,0.01c0.37,0.02,0.79,0.04,1.19,0.92c0.47,1.04,1.5,3.66,1.63,3.93c0.13,0.26,0.22,0.57,0.04,0.92 c-0.17,0.35-0.26,0.57-0.53,0.88c-0.26,0.31-0.55,0.69-0.79,0.93c-0.26,0.26-0.54,0.55-0.23,1.08c0.31,0.53,1.37,2.26,2.94,3.66 c2.02,1.8,3.72,2.36,4.25,2.63c0.53,0.26,0.84,0.22,1.15-0.14c0.31-0.35,1.32-1.54,1.68-2.07c0.35-0.53,0.7-0.44,1.19-0.26 c0.48,0.17,3.08,1.45,3.61,1.72c0.53,0.26,0.88,0.39,1.01,0.61C34.8,29.07,34.8,30.13,34.36,31.37z"></path></svg>
                                            Whatsappa Gönder
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div> --->
                <div id="customer_modal_panel" class="ui-cfmodal-panel" style="display:none;">
                    <div class="ui-cfmodal clever" id="customer_modal">
                        <cf_box id="customer_modal" title="Müşteri" closable="1" resize="0" call_function="cfmodalx({e:'close',id:'customer_modal_panel'});" close_href="javascript://" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08)!important;padding:20px 30px!important;">
                            <div class="step_container p-0">
                                <div class="step_item" style="padding-left: 0px;padding-right: 0px;">
                                    <div style="flex-direction: row;">
                                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12 form-group">
                                            <form onsubmit="return false">
                                                <svg data-bind="click: $root.findCustomerByKeyword" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 20.5 6 C 12.509634 6 6 12.50964 6 20.5 C 6 28.49036 12.509634 35 20.5 35 C 23.956359 35 27.133709 33.779044 29.628906 31.75 L 39.439453 41.560547 A 1.50015 1.50015 0 1 0 41.560547 39.439453 L 31.75 29.628906 C 33.779044 27.133709 35 23.956357 35 20.5 C 35 12.50964 28.490366 6 20.5 6 z M 20.5 9 C 26.869047 9 32 14.130957 32 20.5 C 32 23.602612 30.776198 26.405717 28.791016 28.470703 A 1.50015 1.50015 0 0 0 28.470703 28.791016 C 26.405717 30.776199 23.602614 32 20.5 32 C 14.130953 32 9 26.869043 9 20.5 C 9 14.130957 14.130953 9 20.5 9 z"></path></svg>
                                                <input type="text" placeholder="Anahtar kelime" data-bind="value: $root.keyword, event: { change: $root.findCustomerByKeyword }" style="height:41px;">
                                            </form>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-6 col-xs-12 form-group" data-bind="visible: basketService.get('cashSettings')[0].USE_CUSTOMER_RECORD == 1">
                                            <button type="submit" data-bind="click: toggleCustomerAddForm" class="color-F customer_new_button">
                                                Yeni Müşteri
                                            </button>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-6 col-xs-12 form-group">
                                            <button type="submit" class="nameless_customer_button" data-bind="click : $root.findCustomerStatic ">
                                                İsimsiz Müşteri
                                            </button>
                                        </div>
                                    </div>
                                    <div class="step_body">
                                        <ul class="buton_list">
                                            <li>
                                                <div class="my-5" data-bind="visible: $root.KResult() == true && !$root.showAddConsumer() ">
                                                    <table class="table">
                                                        <thead class="color-darkCyan">
                                                            <tr>
                                                                <th>Üye No</th>
                                                                <th>Ünvan - Ad Soyad</th>
                                                                <th>Vkn - Tckn</th>
                                                                <th>V.D.</th>
                                                                <th>Telefon</th>  
                                                                <th></th>
                                                            </tr>
                                                        </thead>
                                                        <!-- ko if : $root.keywordResult().length > 0 -->
                                                            <tbody data-bind="foreach: $root.keywordResult">
                                                                <tr>
                                                                    <td><span data-bind="text: member_code"></span></td>
                                                                    <td><span data-bind="text: title, click: $root.setSpeedCustomer"></span></td>
                                                                    <td><span data-bind="text: taxNo"></span></td>
                                                                    <td><span data-bind="text: taxOffice"></span></td>
                                                                    <td><span data-bind="text: telcode"></span> <span data-bind="text: tel"></span></td>
                                                                    <td><img src="../asset/img/pencil.png" data-bind="visible: basketService.get('cashSettings')[0].USE_CUSTOMER_RECORD == 1, click: $root.setCustomer" title="Güncelle " alt="Güncelle " style="width:36px;"/></td>
                                                                </tr>
                                                            </tbody>
                                                        <!-- /ko -->
                                                        <!-- ko if : $root.keywordResult().length == 0 -->
                                                        <tbody>
                                                            <tr>
                                                                <td colspan="4">ARADIĞINIZ KRİTERDE KAYITLI MÜŞTERİ BULAMADIK.</td>
                                                            </tr>
                                                        </tbody>
                                                        <!-- /ko -->
                                                    </table>
                                                </div>
                                            </li>
                                        </ul>
                                        <!--- mevcut üye bilgileri --->
                                        <!-- ko if: $root.getCustomer().CUSTOMER_TYPE() != 'new' && !$root.showAddConsumer() -->
                                        <form>
                                            <div class="col col-6 col-xs-12">
                                                <input type="hidden" name="company_id" id="company_id" data-bind="value: $root.getCustomer().COMPANY_ID">
                                                <input type="hidden" name="partner_id" id="partner_id" data-bind="value: $root.getCustomer().PARTNER_ID">
                                                <input type="hidden" name="consumer_id" id="consumer_id" data-bind="value: $root.getCustomer().CONSUMER_ID">
                                                
                                                <div class="form-group form-group-type2">
                                                    <label>Uye No</label>
                                                    <input type="text" name="member_code" data-bind="value: $root.getCustomer().MEMBER_CODE">
                                                </div>
                                                <div class="form-row" <!--- data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '2'" --->>
                                                    <div class="form-group form-group-type2 cl-6 pl-0">
                                                        <label>Alan Kodu</label>
                                                        <input type="text" name="mobil_code" maxlength="7" data-bind="value: $root.getCustomer().MOBIL_CODE">
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6 pr-0">
                                                        <label>Mobil</label>
                                                        <input type="text" name="mobil_tel" maxlength="10" data-bind="value: $root.getCustomer().MOBILTEL">
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="form-group form-group-type2 cl-6 pl-0" <!--- data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'" --->>
                                                        <label>Alan Kodu</label>
                                                        <input type="text" name="tel_code" maxlength="5" data-bind="value: $root.getCustomer().COMPANY_TELCODE()">
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6 pr-0" <!--- data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'" --->>
                                                        <label>Telefon</label>
                                                        <input type="text" name="tel_number" maxlength="7" data-bind="value: $root.getCustomer().COMPANY_TEL1()">
                                                    </div>
                                                </div>
                                                <div class="form-group form-group-type2" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                    <label>Firma</label>
                                                    <input type="text" name="comp_name" data-bind="value: $root.getCustomer().CUSTOMER_TYPE() == '1' ? $root.getCustomer().FULLNAME() : ''">
                                                </div>
                                                <div class="form-row">
                                                    <div class="form-group form-group-type2 cl-6 pl-0">
                                                        <label>Ad</label>
                                                        <input type="text" name="member_name" maxlength="50" data-bind="value: $root.getCustomer().CUSTOMER_TYPE() == '1' ? $root.getCustomer().COMPANY_PARTNER_NAME() : $root.getCustomer().CONSUMER_NAME()">
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6 pr-0">
                                                        <label>Soyad</label>
                                                        <input type="text" name="member_surname" maxlength="50" data-bind="value: $root.getCustomer().CUSTOMER_TYPE() == '1' ? $root.getCustomer().COMPANY_PARTNER_SURNAME() : $root.getCustomer().CONSUMER_SURNAME()">
                                                    </div>
                                                </div>
                                                <div class="form-group form-group-type2">
                                                    <label>Adres Tarifi</label>
                                                    <textarea name="address" rows="5" data-bind="value: $root.getCustomer().ADDRESS()" style="font-size:20px!important;"></textarea>
                                                </div>
                                            </div>
                                            <div class="col col-6 col-xs-12">
                                                <div class="form-group form-group-type2 cl-12" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '2'">
                                                    <label>Kimlik No</label>
                                                    <input type="text" name="tc_num" maxlength="11" data-bind="value: $root.getCustomer().CUSTOMER_TYPE() == '2' ? $root.getCustomer().TC_IDENTY_NO() : ''">
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>Ülke</label>
                                                    <select name="country" data-bind="value: $root.getCustomer().INVOICE_ADDRESS.COUNTRY_ID(), options: $root.countries, optionsValue: 'COUNTRY_ID', optionsText: 'COUNTRY_NAME', event: { change: $root.countryChanged }"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>İl</label>
                                                    <select name="city" data-bind="attr:{'id': 'city' }, value: $root.getCustomer().INVOICE_ADDRESS.CITY_ID(), optionsCaption: 'Seçiniz', options: $root.cities, optionsValue: 'CITY_ID', optionsText: 'CITY_NAME', event: { change: $root.cityChanged }"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>İlçe</label>
                                                    <select name="county_id" id="county_id" data-bind="attr:{'id': 'county_id' }, value: $root.getCustomer().INVOICE_ADDRESS.COUNTY_ID(), optionsCaption: 'Seçiniz', options: $root.counties, optionsValue: 'COUNTY_ID', optionsText: 'COUNTY_NAME'"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                    <label>Vergi Dairesi</label>
                                                    <input type="text" name="tax_office" maxlength="30" data-bind="value: $root.getCustomer().CUSTOMER_TYPE() == '1' ? $root.getCustomer().TAXOFFICE() : ''">
                                                </div>
                                                <div class="form-group form-group-type2 cl-12" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                    <label>Vergi No</label>
                                                    <input type="text" name="tax_num" maxlength="10" data-bind="value: $root.getCustomer().CUSTOMER_TYPE() == '1' ? $root.getCustomer().TAXNO() : ''">
                                                </div>
                                            </div>
                                            <div class="col col-12">
                                                <div class="form-group form-group-type3">
                                                    <button type="submit" data-bind="click: function() { cfmodalx({e:'close',id:'customer_modal_panel'}); }" class="save_button">
                                                        Kaydet
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                        <!-- /ko -->
                                        <!--- yeni üye ekleme --->
                                        <!-- ko if: $root.showAddConsumer() == true -->
                                        <form onsubmit="return false">
                                            <div class="col col-4 col-xs-12">
                                                <div class="form-group col col-4 col-xs-6">
                                                    <label data-bind="click: $root.setCompany">
                                                        <input type="radio" name="member_type" value="1" data-bind="checked: $root.getCustomer().CUSTOMER_TYPE">
                                                        Kurumsal
                                                        <span class="checkmark"></span>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col col-4 col-xs-12">
                                                <div class="form-group col col-4 col-xs-6">
                                                    <label data-bind="click: $root.setConsumer">
                                                        <input type="radio" name="member_type" value="2" data-bind="checked: $root.getCustomer().CUSTOMER_TYPE">
                                                        Bireysel
                                                        <span class="checkmark"></span>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col col-6 col-md-12 col-xs-12">
                                                <div class="form-row">
                                                    <div class="form-group form-group-type2 cl-6" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                        <label>Uye No</label>
                                                        <input type="text" name="member_code" data-bind="value: $root.getCustomer().MEMBER_CODE">
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                        <label>Ünvan</label>
                                                        <input type="text" name="comp_name" <!--- data-bind="value: $root.getCustomer().FULLNAME" --->>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="form-group form-group-type2 cl-6" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                        <label>Vergi Dairesi</label>
                                                        <input type="text" name="tax_office" maxlength="30" <!--- data-bind="value: $root.getCustomer().TAXOFFICE" --->>
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                        <label>Vergi No</label>
                                                        <input type="text" name="tax_num" maxlength="10"<!--- data-bind="value: $root.getCustomer().TAXNO" --->>
                                                    </div>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '2'">
                                                    <label>Kimlik No</label>
                                                    <input type="text" name="tc_num" maxlength="11"<!--- data-bind="value: $root.getCustomer().TC_IDENTITY_NO" --->>
                                                </div>
                                                <div class="form-row" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '2'">
                                                    <div class="form-group form-group-type2 cl-6">
                                                        <label>Alan Kodu</label>
                                                        <input type="text" name="mobil_code" maxlength="5" <!--- data-bind="value: $root.getCustomer().MOBIL_CODE" --->>
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6">
                                                        <label>Mobil</label>
                                                        <input type="text" name="mobil_tel" maxlength="10" <!--- data-bind="value: $root.getCustomer().MOBILTEL" --->>
                                                    </div>
                                                </div>
                                                <!-- ko if: $root.getCustomer().CUSTOMER_TYPE() != 'new' && $root.addressMode() == 'invoice' -->
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>Ülke</label>
                                                    <select name="country" data-bind="value: $root.getCustomer().INVOICE_ADDRESS.COUNTRY_ID, options: $root.countries, optionsValue: 'COUNTRY_ID', optionsText: 'COUNTRY_NAME', event: { change: $root.countryChanged }"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>İl</label>
                                                    <select name="city" data-bind="attr:{'id': 'city' }, value: $root.getCustomer().INVOICE_ADDRESS.CITY_ID, optionsCaption: 'Seçiniz', options: $root.cities, optionsValue: 'CITY_ID', optionsText: 'CITY_NAME', event: { change: $root.cityChanged }"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>İlçe</label>
                                                    <select name="county_id" data-bind="attr:{'id': 'county' }, value: $root.getCustomer().INVOICE_ADDRESS.COUNTY_ID, optionsCaption: 'Seçiniz', options: $root.counties, optionsValue: 'COUNTY_ID', optionsText: 'COUNTY_NAME'"></select>
                                                </div>
                                                <!-- /ko -->
                                                <!-- ko if: $root.getCustomer().CUSTOMER_TYPE() != 'new' && $root.addressMode() == 'ship' -->
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>Ülke</label>
                                                    <select name="country" data-bind="value: $root.getCustomer().SHIP_ADDRESS.COUNTRY_ID, options: $root.countries, optionsValue: 'COUNTRY_ID', optionsText: 'COUNTRY_NAME', event: { change: $root.countryChanged }"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>İl</label>
                                                    <select name="city" data-bind="attr:{'id': 'city' }, value: $root.getCustomer().SHIP_ADDRESS.CITY_ID, optionsCaption: 'Seçiniz', options: $root.cities, optionsValue: 'CITY_ID', optionsText: 'CITY_NAME', event: { change: $root.cityChanged }"></select>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>İlçe</label>
                                                    <select name="county_id" data-bind="attr:{'id': 'county' }, value: $root.getCustomer().SHIP_ADDRESS.COUNTY_ID"></select>
                                                </div>
                                                <!-- /ko -->
                                            </div>
                                            <div class="col col-6 col-md-12 col-xs-12">
                                                <div class="form-row" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() != 'new'">
                                                    <div class="form-group form-group-type2 cl-6">
                                                        <label>Yetkili Ad</label>
                                                        <input type="text" name="member_name" <!--- data-bind="value: $root.getCustomer().CONSUMER_NAME" --->>
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6">
                                                        <label>Yetkili Soyad</label>
                                                        <input type="text" name="member_surname" <!--- data-bind="value: $root.getCustomer().CONSUMER_SURNAME" --->>
                                                    </div>
                                                </div>
                                                <div class="form-row" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1'">
                                                    <div class="form-group form-group-type2 cl-6">
                                                        <label>Alan Kodu</label>
                                                        <input type="text" name="tel_code" maxlength="5"<!--- data-bind="value: $root.getCustomer().COMPANY_TELCODE" --->>
                                                    </div>
                                                    <div class="form-group form-group-type2 cl-6">
                                                        <label>Telefon</label>
                                                        <input type="text" name="tel_number" maxlength="7"<!--- data-bind="value: $root.getCustomer().COMPANY_TEL1" --->>
                                                    </div>
                                                </div>
                                                <div class="form-group form-group-type2 cl-12" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1' || $root.getCustomer().CUSTOMER_TYPE() == '2' ">
                                                    <label>E-Posta</label>
                                                    <input type="text" name="email" <!--- data-bind="value: $root.getCustomer().COMPANY_EMAIL" --->>
                                                </div>
                                                <!-- ko if: $root.getCustomer().CUSTOMER_TYPE() != 'new' && $root.addressMode() == 'invoice' -->
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>Adres Tarifi</label>
                                                    <textarea name="address" rows="6" <!--- data-bind="value: $root.getCustomer().INVOICE_ADDRESS.ADDRESS" ---> style="font-size:20px!important;"></textarea>
                                                </div>
                                                <!-- /ko -->
                                                <!-- ko if: $root.getCustomer().CUSTOMER_TYPE() != 'new' && $root.addressMode() == 'ship' -->
                                                <div class="form-group form-group-type2 cl-12">
                                                    <label>Adres Tarifi</label>
                                                    <textarea name="address" rows="6" <!--- data-bind="value: $root.getCustomer().SHIP_ADDRESS.ADDRESS" ---> style="font-size:20px!important;"></textarea>
                                                </div>
                                                <!-- /ko -->
                                                <div class="form-group" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() == '1' || $root.getCustomer().CUSTOMER_TYPE() == '2' ">
                                                    <label>
                                                        <input type="checkbox" name="choice_adress" value="1" checked>
                                                        Fatura ve Teslim Adresi Aynı
                                                        <span class="checkmark"></span>
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col col-12 mt-3">
                                                <div class="form-group form-group-type3" data-bind="visible: $root.getCustomer().CUSTOMER_TYPE() != 'new'">
                                                    <button type="submit" data-bind="click: function() { cfmodalx({e:'close',id:'customer_modal_panel'}); }" class="save_button">
                                                        Kaydet
                                                    </button>
                                                </div> 
                                            </div>
                                        </form> 
                                        <!-- /ko -->
                                    </div>
                                </div> 
                            </div>
                        </cf_box>
                    </div>
                </div>
            </div>
            <div class="footer">
                <div class="form-group col col-6 col-md-12 col-xs-12" id="footerElement">
                </div>
            </div>
            <div class="popup">
                <div class="popup_head">
                    <p>Ürün başarılı şekilde sepete eklendi</p>
                    <a href="javascript://">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 3.5 6 A 1.50015 1.50015 0 1 0 3.5 9 L 6.2558594 9 C 6.9837923 9 7.5905865 9.5029243 7.7285156 10.21875 L 8.0273438 11.78125 L 11.251953 28.716797 C 11.835068 31.772321 14.527135 34 17.638672 34 L 36.361328 34 C 39.472865 34 42.166064 31.773177 42.748047 28.716797 L 45.972656 11.78125 A 1.50015 1.50015 0 0 0 44.5 10 L 32 10 L 32 13 L 42.6875 13 L 39.800781 28.15625 C 39.484764 29.81587 38.051791 31 36.361328 31 L 17.638672 31 C 15.948808 31 14.516781 29.8158 14.199219 28.15625 L 14.199219 28.154297 L 11.3125 13 L 23 13 L 23 10 L 10.740234 10 L 10.675781 9.6582031 C 10.272657 7.5455321 8.4069705 6 6.2558594 6 L 3.5 6 z M 27.476562 6.9785156 A 1.50015 1.50015 0 0 0 26 8.5 L 26 21.878906 L 23.560547 19.439453 A 1.50015 1.50015 0 1 0 21.439453 21.560547 L 26.439453 26.560547 A 1.50015 1.50015 0 0 0 28.560547 26.560547 L 33.560547 21.560547 A 1.50015 1.50015 0 1 0 31.439453 19.439453 L 29 21.878906 L 29 8.5 A 1.50015 1.50015 0 0 0 27.476562 6.9785156 z M 20 36 A 3 3 0 0 0 20 42 A 3 3 0 0 0 20 36 z M 34 36 A 3 3 0 0 0 34 42 A 3 3 0 0 0 34 36 z"></path></svg>
                    </a>
                    <a id="basket_close" href="javascript://">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path d="M 39.486328 6.9785156 A 1.50015 1.50015 0 0 0 38.439453 7.4394531 L 24 21.878906 L 9.5605469 7.4394531 A 1.50015 1.50015 0 0 0 8.484375 6.984375 A 1.50015 1.50015 0 0 0 7.4394531 9.5605469 L 21.878906 24 L 7.4394531 38.439453 A 1.50015 1.50015 0 1 0 9.5605469 40.560547 L 24 26.121094 L 38.439453 40.560547 A 1.50015 1.50015 0 1 0 40.560547 38.439453 L 26.121094 24 L 40.560547 9.5605469 A 1.50015 1.50015 0 0 0 39.486328 6.9785156 z"></path></svg>
                    </a>
                </div>
            </div>           
        </div>
    </div>
</div>
    <cfif not IsDefined("session.wp")>
    <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
    <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout-mapping.js"></script>
    <script type="text/javascript" src="/JS/browserStorage.js"></script>
    <cfelse>
    <script type="text/javascript" src="/asset/js/lib/knockout-3.4.2/knockout.js"></script>
    <script type="text/javascript" src="/asset/js/lib/knockout-3.4.2/knockout-mapping.js"></script>
    <script type="text/javascript" src="/asset/js/browserStorage.js"></script>
    </cfif>

    <cfset attributes.basket_id = 18>
    <cfset attributes.form_add = 1>
    <cfset attributes.is_retail=1>
    <cfset attributes.event = "add">
    <cfset cmp_basket = createObject("component", "V16.objects.cfc.basket_retail").init(sessions = session_base) />
    <cfset basket_data = cmp_basket.get_basket(attributes.basket_id)>
    <cfset get_basket = basket_data>
    <cfset sale_product = basket_data.PURCHASE_SALES>
    <!--- tanımlar --->
    <cfset numeric_columns = 'amount,amount2,amount_other,list_price,list_price_discount,tax_price,price,price_other,price_net,price_net_doviz,tax,OTV,duedate,number_of_installment,iskonto_tutar,ek_tutar,ek_tutar_price,ek_tutar_other_total,ek_tutar_cost,ek_tutar_marj,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_nettotal,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,net_maliyet,extra_cost,extra_cost_rate,row_cost_total,marj,dara,darali,promosyon_yuzde,promosyon_maliyet,row_width,row_depth,row_height,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,otv_discount'>
    <cfset selectbox_columns = 'other_money,order_currency,reserve_type,basket_extra_info,select_info_extra,reason_code,unit2,delivery_condition,container_type,delivery_type,row_activity_id,row_tevkifat_id,otv_type'>
    <cfset popup_columns = 'product_name,basket_acc_code,basket_exp_item,lot_no,price,deliver_dept,basket_row_departman,basket_exp_center,row_subscription_name,row_assetp_name,basket_project,basket_work,basket_employee,reserve_date,deliver_date,spec'>
    <cfset non_inputs = 'is_promotion,is_price_total_other_money,is_amount_total,is_paper_discount,basket_cursor,is_member_selected,is_project_not_change,is_use_add_unit,is_member_not_change,is_project_selected,use_project_discount_,check_row_discounts,zero_stock_status,zero_stock_control_date,is_serialno_guaranty,is_risc,is_cash_pos,is_installment,price_total,Kdv,oiv,bsmv,otv_from_tax_price'>
    <cfset hidden_column_list = "">
    <cfif session_base.price_display_valid eq 1>
        <cfset hidden_column_list = "Tax,OTV,tax_price,price_other,price_net,tax_price,price_net_doviz,price_total,other_money,List_price,Price,iskonto_tutar,ek_tutar,ek_tutar_other_total,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,row_total,row_taxtotal,row_nettotal,row_otvtotal,row_lasttotal,other_money_value,other_money_gross_total,marj,genel_indirim_">
    </cfif>
    <cfif session_base.cost_display_valid eq 1>
        <cfset hidden_column_list = listAppend(hidden_column_list, 'net_maliyet,extra_cost')>
    </cfif>
    <cfset price_round_number = basket_data.price_round_number>
    <cfset basket_data_hidden_column = cmp_basket.get_basket_visiblity(basket_data, hidden_column_list, 0)>
    <cfset basket_data_display_column = cmp_basket.get_basket_visiblity(basket_data, hidden_column_list, 1)>
    <cfset hidden_list = valueList(basket_data_hidden_column.title)>
    <cfset display_list = valueList(basket_data_display_column.title)>
    <cfset amount_list = "amount,amount_other">
    <cfif len(basket_data.basket_total_round_number)>
        <cfset basket_total_round_number = basket_data.basket_total_round_number>
    <cfelse>
        <cfset basket_total_round_number = session_base.our_company_info.rate_round_num>
    </cfif>
    <cfif len(basket_data.basket_rate_round_number)>
        <cfset basket_rate_round_number = basket_data.basket_rate_round_number>
    <cfelse>
        <cfset basket_rate_round_number = session_base.our_company_info.rate_round_num>
    </cfif>
    <cfif len(basket_data.amount_round)>
        <cfset amount_round = basket_data.amount_round>
    <cfelse>
        <cfset amount_round = session_base.our_company_info.rate_round_num>
    </cfif>
    <cfif session_base.DISCOUNT_VALID eq 1>
        <cfset basket_read_only_discount_list = "iskonto_tutar,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_,genel_indirim">
    <cfelse>
        <cfset basket_read_only_discount_list = "">
    </cfif>
    <cfset price_columns = "tax,OTV,tax_price,price,list_price_discount,set_row_duedate,price_other,ek_tutar,ek_tutar_price,ek_tutar_cost,ek_tutar_marj,ek_tutar_other_total,row_total,row_taxtotal,row_otvtotal,row_lasttotal,other_money_value,extra_cost_rate,row_cost_total,marj">
    <cfset hesapla_columns = "amount,amount2,amount_other,price,price_other,price_net_doviz,tax,indirim1,indirim2,indirim3,indirim4,indirim5,indirim6,indirim7,indirim8,indirim9,indirim10,iskonto_tutar,other_money,otv,row_otvtotal,row_total,row_taxtotal,other_money_value,duedate,ek_tutar,ek_tutar_price,promosyon_yuzde,row_bsmv_rate,row_bsmv_amount,row_bsmv_currency,row_oiv_rate,row_oiv_amount,row_tevkifat_rate,row_tevkifat_amount,list_price_discount,disc_ount,disc_ount2_,disc_ount3_,disc_ount4_,disc_ount5_,disc_ount6_,disc_ount7_,disc_ount8_,disc_ount9_,disc_ount10_">
    <cfset order_currency_list = "#getLang('main',1305)#,#getLang('main',1948)#,#getLang('main',1949)#,#getLang('main',1950)#,#getLang('main',44)#,#getLang('main',1349)#,#getLang('main',1951)#,#getLang('main',1952)#,#getLang('main',1094)#,#getLang('main',1211)#">
    <cfset reserve_type_list = "#getLang('main',1953)#,#getLang('main',1954)#,#getLang('main',1955)#,#getLang('main',1956)#">
    
    <!--- basket kur ekleme ve moneyArray oluşturması --->
    <cfif not isDefined("session_basket_kur_ekle")>
        <cfinclude template="/V16/objects/functions/get_basket_money_js.cfm">
    </cfif>
    <cfset session_basket_kur_ekle(process_type:0)>

    <!--- basket info list --->
    <cfset basket_info_list = '0;#getLang('main',322)#'>
    <cfquery name="basket_info_" datasource="#dsn3#">
        SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE OPTION_NUMBER IN (1,3) AND ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
    </cfquery>
    <cfloop query="basket_info_">
        <cfset basket_info_list = listappend(basket_info_list,"#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#")>
    </cfloop>

    <!--- bakset info ekstra --->
    <cfquery name="getSelectInfoExtra" datasource="#dsn3#">
        SELECT BASKET_INFO_TYPE_ID,BASKET_INFO_TYPE FROM SETUP_BASKET_INFO_TYPES WHERE OPTION_NUMBER IN (2,3) AND ','+BASKET_ID+',' LIKE ',%#attributes.basket_id#%,' ORDER BY BASKET_INFO_TYPE
    </cfquery>
    <cfset select_info_extra_list = '0;#getLang('main',322)#'>
    <cfloop query="getSelectInfoExtra">
        <cfset select_info_extra_list = listappend(select_info_extra_list,"#BASKET_INFO_TYPE_ID#;#BASKET_INFO_TYPE#")>
    </cfloop>
    <!--- ötv indirim list --->
    <cfset otv_indirim_list = '0;İndirim Yok,1;Tam İndirim'>
    <!--- reason list --->
    <cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
    <cfset dosyam = XmlParse(xmldosyam)>
    <cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
    <cfset d_boyut = ArrayLen(xml_dizi)>
    <cfset reason_code_list = "#getLang('main',322)#">
    <cfloop index="abc" from="1" to="#d_boyut#">    	
        <cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
    </cfloop>

    <!--- İhracat E-Fatura --->
    <cfquery name="delivery_condition" datasource="#dsn#">
        SELECT * FROM DELIVERY_CONDITION
    </cfquery>
    <cfquery name="container_type" datasource="#dsn#">
        SELECT * FROM CONTAINER_TYPE
    </cfquery>
    <cfquery name="delivery_type" datasource="#dsn#">
        SELECT * FROM DELIVERY_TYPE
    </cfquery>
    <cfquery name="tevkifat_rates" datasource="#dsn3#">
        SELECT * FROM SETUP_TEVKIFAT WHERE IS_ACTIVE = 1
    </cfquery>

    <cfif isDefined("attributes.is_retail")>
        <cfset account_status = 1>
        <cfset cash_status = 1>
        <cfinclude template="../../objects/query/get_cashes.cfm">
        <cfinclude template="../../objects/query/get_pos_equipment_bank.cfm">
        <cfinclude template="../../objects/query/cash_reg.cfm">
        <cfset cashList = arrayNew(1)>
        <cfset posList = arrayNew(1)>
        <cfset counter = 1 />
        <cfset counter2 = 1 />
        <cfoutput query="get_money_bskt">
            <cfquery name="get_money_cashes" dbtype="query">
                SELECT
                    CASH_ID, CASH_NAME,
                    CASH_CURRENCY_ID
                FROM 
                    GET_CASHES
                WHERE 
                    CASH_CURRENCY_ID='#money_type#'
            </cfquery>
            <cfif not arrayIsDefined(cashList, counter) and get_money_cashes.recordCount>
                <cfset cashList[counter] = structNew()>
                <cfset cashList[counter] = { currency_type: get_money_bskt.money_type, items: arrayNew(1) } />
            </cfif>
            <cfloop query="get_money_cashes">
                <cfset cashList[counter]["items"][currentRow] = { text: get_money_cashes.CASH_CURRENCY_ID, id: get_money_cashes.CASH_ID } >
            </cfloop>
            <cfif not isdefined("attributes.form_add") and isdefined("url.iid") and isdefined("GET_SALE_DET") and (GET_SALE_DET.IS_CASH eq 1)>
                <cfquery name="control_cashes" datasource="#dsn2#">
                    SELECT 
                        INVOICE_CASH_POS.KASA_ID,
                        CASH_ACTIONS.*
                    FROM
                        INVOICE,
                        INVOICE_CASH_POS,
                        CASH_ACTIONS
                    WHERE
                        CASH_ACTIONS.ACTION_ID=INVOICE_CASH_POS.CASH_ID
                        AND INVOICE_CASH_POS.INVOICE_ID=INVOICE.INVOICE_ID 
                        AND INVOICE.INVOICE_ID = #url.iid#
                        AND CASH_ACTION_CURRENCY_ID = '#get_money_bskt.MONEY_TYPE#'
                    ORDER BY 
                        INVOICE_CASH_POS.KASA_ID DESC
                </cfquery>
                <cfif control_cashes.recordcount>
                    <cfset cashList[counter]["KASA"] = control_cashes.KASA_ID />
                    <cfset cashList[counter]["CASH_AMOUNT"] = control_cashes.CASH_ACTION_VALUE />
                    <cfset cashList[counter]["CASH_ACTION_ID"] = control_cashes.ACTION_ID />
                </cfif>
            </cfif>
            <cfif get_money_cashes.recordCount>
                <cfset counter += 1 />
            </cfif>
        </cfoutput>
        <cfloop from="1" to="3" index="i">
            <cfif not arrayIsDefined(posList, counter2) and GET_POS_DETAIL.recordCount>
                <cfset posList[counter2] = structNew()>
                <cfset posList[counter2] = { items: arrayNew(1) } />
            </cfif>
            <cfset counter3 = 1>
            <cfloop query="GET_POS_DETAIL">
                <cfset posList[counter2]["items"][counter3] = { text: GET_POS_DETAIL.CARD_NO, id: GET_POS_DETAIL.ACCOUNT_ID&";"&GET_POS_DETAIL.ACCOUNT_CURRENCY_ID&";"&GET_POS_DETAIL.PAYMENT_TYPE_ID } >
                <cfif GET_POS_DETAIL.recordCount>
                    <cfset counter3 += 1 />
                </cfif>
            </cfloop>
            <cfif not isdefined("attributes.form_add") and isdefined("url.iid")>
                <cfquery name="CONTROL_POS_PAYMENT" datasource="#dsn2#" maxrows="5">
                    SELECT 
                        INVOICE_CASH_POS.*,
                        CREDIT_CARD_BANK_PAYMENTS.*
                    FROM
                        INVOICE,
                        INVOICE_CASH_POS,
                        #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS CREDIT_CARD_BANK_PAYMENTS
                    WHERE
                        INVOICE.INVOICE_ID=INVOICE_CASH_POS.INVOICE_ID
                        AND INVOICE_CASH_POS.POS_ACTION_ID=CREDIT_CARD_BANK_PAYMENTS.CREDITCARD_PAYMENT_ID
                        AND INVOICE.INVOICE_ID=#url.iid# AND
                        INVOICE_CASH_POS.POS_PERIOD_ID = #session_base.period_id#
                    ORDER BY
                        INVOICE_CASH_POS.POS_ACTION_ID
                </cfquery>
                <cfif CONTROL_POS_PAYMENT.recordcount and len(CONTROL_POS_PAYMENT.SALES_CREDIT[i])>
                    <cfset posList[counter2]["POS"] = '#CONTROL_POS_PAYMENT.ACTION_TO_ACCOUNT_ID[i]#;#CONTROL_POS_PAYMENT.ACTION_CURRENCY_ID[i]#;#CONTROL_POS_PAYMENT.PAYMENT_TYPE_ID[i]#' />
                    <cfset posList[counter2]["POS_AMOUNT"] = CONTROL_POS_PAYMENT.SALES_CREDIT[i] />
                    <cfset posList[counter2]["POS_ACTION_ID"] = CONTROL_POS_PAYMENT.CREDITCARD_PAYMENT_ID[i] />
                </cfif>
            </cfif>
            <cfset counter2++ />
        </cfloop>
    </cfif>

    <cfset sepet.satir = ArrayNew(2) >
    <cfset sepet.kdv_array = ArrayNew(2) >
    <cfset sepet.otv_array = ArrayNew(2) >
    <cfset sepet.total = 0 >
    <cfset sepet.total_other_money = 0 >
    <cfset sepet.total_other_money_tax = 0 >
    <cfset sepet.toplam_indirim = 0 >
    <cfset sepet.total_tax = 0 >
    <cfset sepet.total_otv = 0 >
    <cfset sepet.net_total = 0 >
    <cfset sepet.genel_indirim = 0 >
    <cfset sepet.stopaj = 0 >
    <cfset sepet.stopaj_yuzde = 0 >
    <cfset sepet.stopaj_rate_id = 0 >

    <cfinclude template="/V16/objects/display/basket2variables.cfm">
    <cfset readOnlyInputList = 'stock_code,barcod,special_code,unit,list_price,price_net,price_net_doviz,row_nettotal,other_money_gross_total,row_cost_total'>

    <cfif not isDefined("default_basket_money_")>
        <cfif isDefined("get_standart_process_money") and isQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
            <cfset default_basket_money_ = get_standart_process_money.STANDART_PROCESS_MONEY>
        <cfelseif len(session_base.money2)>
            <cfset default_basket_money_ = session_base.money2>
        <cfelse>
            <cfset default_basket_money_ = session_base.money>
        </cfif>
    </cfif>

    <!--- script verileri --->
    <script type="text/javascript">
        
        var lng_indirim_degeri_hatali = "<cf_get_lang dictionary_id='57727.İndirim Değeri Hatalı'>";
        var lng_miktar_degeri_hatali = "<cf_get_lang dictionary_id='57728.Miktar Değeri Hatalı'>";
        var lng_fiyat_degeri_hatali = "<cf_get_lang dictionary_id='57729.Fiyat Değeri Hatalı'>";
        var lng_once_depo_sec = "<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!";
        var lng_satinalma_indirimi_tarih_bilgisi = "<cf_get_lang dictionary_id='57714.Satınalma İndirimleri için Tarih Bilgisini Ekleyiniz'>!";
        var lng_once_islem_tipi_sec = "<cf_get_lang dictionary_id='57733.Önce İşlem Tipi Seçiniz'>!";
        var lng_once_uye_sec = "<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!";
        var lng_once_proje_sec = "<cf_get_lang dictionary_id='58848.Önce Proje Seçiniz'>!";
        var lng_odeme_yontemi_sec = "<cf_get_lang dictionary_id='58027.Ödeme Yöntemi Seçiniz!'>";
        var lng_cikis_loc_sec = "<cf_get_lang dictionary_id='58782.Çıkış Lokasyonu Seçiniz'>";
        var lng_standart_satis = "<cf_get_lang dictionary_id='58721.Standart Satış'>";
        var lng_standart_alis = "<cf_get_lang dictionary_id='58722.Standart Alış'>";
        var lng_seciniz = "<cf_get_lang dictionary_id='57734.Seçiniz'>";
    </script>
    <cfif not IsDefined("session.wp")>
    <script type="text/javascript" src="/JS/basket/basket.service.js"></script>
    <script type="text/javascript" src="/JS/basket/formulas/default.js"></script>
    <script type="text/javascript" src="/JS/basket/basket.manager.js"></script>
    <script type="text/javascript" src="/JS/basket/basket.config.js"></script>
    <cfelse>
    <script type="text/javascript" src="../asset/js/lib/basket/basket.service.js"></script>
    <script type="text/javascript" src="../asset/js/lib/basket/formulas/default.js"></script>
    <script type="text/javascript" src="../asset/js/lib/basket/basket.manager.js"></script>
    <script type="text/javascript" src="../asset/js/lib/basket/basket.config.js"></script>
    </cfif>

    <script type="text/javascript">
    $(document).ready(function() {
        $(".pageMainLayout ").css({ "height" : "100%" });
    });
        basket = {};
        basket.hidden_values = {};
        basket.hidden_values.today_date = "<cfoutput>#dateadd('h',session_base.time_zone,now())#</cfoutput>";
        basketService.set("price_round_number", <cfoutput>#price_round_number#</cfoutput>);
        basketService.set("basket_total_round_number",<cfoutput>#basket_total_round_number#</cfoutput>);
        basketService.set("otv_calc_type",<cfoutput>#(isDefined("get_basket.OTV_CALC_TYPE") and len(get_basket.OTV_CALC_TYPE))?1:0#</cfoutput>);
        basketService.set("amount_round", <cfoutput>#amount_round#</cfoutput>);
        basketService.set("period_year",<cfoutput>#session_base.period_year#</cfoutput>);
        basketService.set("ep_money",'<cfoutput>#session_base.money#</cfoutput>');
        basketService.set("default_money", '<cfoutput>#default_basket_money_#</cfoutput>');
        basketService.set("base_money", '<cfoutput>#session_base.money#</cfoutput>');
        basketService.set("basket_spect_type", '<cfoutput>#listFindNoCase(display_list,'spec_product_cat_property') != -1 ? 7 : 0#</cfoutput>');
        basketService.set("sale_product", '<cfoutput>#(len(sale_product)) ? sale_product : ''#</cfoutput>');
        basketService.set("line_number",'<cfoutput>#(isdefined("get_basket.line_number") and len(get_basket.line_number) ? get_basket.line_number : 10)#</cfoutput>');
        <cfif isDefined("basket_info_list")>
        <cfscript> 
            function basket_info_converter(elm) 
            {
                return { id: listFirst(elm, ";"), text: listLast(elm, ";") }; 
            }
        </cfscript>
        basketService.set( "basket_info_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(basket_info_list), basket_info_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("select_info_extra_list")>
            <cfscript> 
                function select_info_converter(elm) 
                {
                    return { id: listFirst(elm, ";"), text: listLast(elm, ";") }; 
                }
            </cfscript>
            basketService.set( "select_info_extra_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(select_info_extra_list), select_info_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("otv_indirim_list")>
            <cfscript> 
                
                function otv_disc_converter(elm) 
                {
                    return { id: listFirst(elm, ";"), text: listLast(elm, ";") }; 
                }
            </cfscript>
            basketService.set( "otv_indirim_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(otv_indirim_list), otv_disc_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("reason_code_list")>
        basketService.set( "reason_code_list", <cfoutput>#replace(serializeJSON(listToArray(reason_code_list,"*")), "//", "")#</cfoutput> );
        </cfif>
        <cfif delivery_condition.recordCount>
        <cfscript>
            function delivery_condition_converter(elm, idx) { 
                return { id: elm, text: elm & "-" & delivery_condition["name"][idx] }; 
            }
        </cfscript>
        basketService.set( "delivery_condition", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(delivery_condition, "code"), delivery_condition_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif container_type.recordCount>
        <cfscript>
            function container_type_converter(elm, idx) { 
                return { id: elm, text: elm & "-" & container_type["name"][idx] }; 
            }
        </cfscript>
        basketService.set( "container_type", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(container_type, "code"), container_type_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif delivery_type.recordCount>
        <cfscript>
            function delivery_type_converter(elm, idx) { 
                return { id: elm, text: delivery_type["name"][idx] }; 
            }
        </cfscript>
        basketService.set( "delivery_type", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(delivery_type, "code"), delivery_type_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif tevkifat_rates.recordCount>
        <cfscript>
            function tevkifat_rates_converter(elm, idx) {
                return { id: elm, rate: tevkifat_rates["STATEMENT_RATE"][idx], ratedisp: tevkifat_rates["STATEMENT_RATE_NUMERATOR"][idx] & "/" & tevkifat_rates["STATEMENT_RATE_DENOMINATOR"][idx], code: tevkifat_rates["TEVKIFAT_CODE"][idx], title: tevkifat_rates["TEVKIFAT_CODE_NAME"][idx] };
            }
        </cfscript>
        basketService.set( "tevkifat_rates", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(tevkifat_rates, "TEVKIFAT_ID"), tevkifat_rates_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfset getActivity = createobject("component","workcube.workdata.get_activity_types").getActivity()>
        <cfif getActivity.recordCount>
        <cfscript>
            function activity_converter(elm, idx) { 
                return { id: elm, text: getActivity["ACTIVITY_NAME"][idx] }; 
            }
        </cfscript>
        basketService.set( "activity_types", <cfoutput>#replace(serializeJSON(arrayMap(valueArray(getActivity, "ACTIVITY_ID"), activity_converter )), "//", "" )#</cfoutput> );
        </cfif>
        <cfif isDefined("reserve_type_list")>
        <cfscript>
            function reserve_type_converter(elm, idx) { 
                return { id: idx*-1, text: elm }; 
            }
        </cfscript>
            basketService.set( "reserve_type_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(reserve_type_list), reserve_type_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif isDefined("order_currency_list")>
        <cfscript>
            function order_currency_converter(elm, idx) { 
                return { id: idx*-1, text: elm }; 
            }
        </cfscript>
            basketService.set( "order_currency_list", <cfoutput>#replace(serializeJSON(arrayMap(listToArray(order_currency_list), order_currency_converter)), "//", "")#</cfoutput> );
        </cfif>
        <cfif get_money_bskt.recordCount>
            <cfscript>
                function money_basket_converter(elm, idx) { 
                    return { money_type: elm, rate1: get_money_bskt["rate1"][idx], rate2: get_money_bskt["rate2"][idx], is_selected: get_money_bskt["IS_SELECTED"][idx] }; 
                }
            </cfscript>
            basketService.set( "basket_money_list", ko.mapping.fromJS( <cfoutput>#replace(serializeJSON(arrayMap( valueArray(get_money_bskt, "money_type"), money_basket_converter )), "//", "")#</cfoutput> ) );
        </cfif>
        basketService.set("wmo_fuseaction", '<cfoutput>#attributes.fuseaction#</cfoutput>');
        basketService.set("wmo_module", '<cfoutput>#listFirst(attributes.fuseaction, '.')#</cfoutput>');
        basketService.set("wmo_action", '<cfoutput>#listLast(attributes.fuseaction, '.')#</cfoutput>');
        basketService.set("basket_id", <cfoutput>#attributes.basket_id#</cfoutput>);
        basket.hidden_values.basket_id = <cfoutput>#attributes.basket_id#</cfoutput>;
        basketService.set("dsn2_alias", "<cfoutput>#dsn2_alias#</cfoutput>");
        basketService.set("basket_unique_code", 'window_' + js_create_unique_id());
        basketService.set("is_kontrol_from_update", <cfoutput>#isDefined("kontrol_form_update")?"true":"false"#</cfoutput>);
        basketService.set("kontrol_from_update", <cfoutput>#isDefined("kontrol_from_update")?kontrol_form_update:"0"#</cfoutput>);
        basketService.set("is_retail", <cfoutput>#isDefined("attributes.is_retail")?"true":"false"#</cfoutput>);
        basketService.set("generalTaxArray", []);
        basketService.set("generaltaxArrayTotal", []);
        basketService.set("generalotvArray", []);
        basketService.set("generalotvArrayTotal", []);
        basketService.set("changeable_value", []);
        <cfif isDefined("get_money_bskt")>
        basketService.set("money_bskt_money_types", <cfoutput>#replace(serializeJSON( get_money_bskt["MONEY_TYPE"] ), "//", "")#</cfoutput>);
        </cfif>
        <cfif structKeyExists(sepet, "kdv_array") and isArray(sepet.kdv_array)>
        basketService.set("sepetTaxArray", <cfoutput>#replace(serializeJSON(sepet.kdv_array), "//", "")#</cfoutput>);
        </cfif>
        basketService.set("wmo_event", '<cfoutput>#iif(isDefined("attributes.event"), "attributes.event", de(""))#</cfoutput>');
        basketService.set("xml_delivery_date_calculated", <cfif isDefined("xml_delivery_date_calculated") and xml_delivery_date_calculated neq 1>0<cfelse>1</cfif>);
        basketService.set("basket_read_only_discount_list", <cfoutput>[#listQualify(basket_read_only_discount_list, '"')#]</cfoutput>);
        basketService.set("popup_fact_status", "empty");
        basketService.set("cashSettings", <cfoutput>#CashRegObject#</cfoutput>);
        basketManager.setBasketHeader(JSON.parse(`[
            <cfoutput>
            <cfset currentRow = 0>
            <cfloop query="basket_data">
            <cfset currentRow = currentRow + 1>
            <cfset qrow = queryGetRow(basket_data, currentRow)>
            <cfif listfind(basket_data.TITLE, 'product_name2')><cfset qrow.TITLE = replace(basket_data.TITLE,'product_name2','product_name_other')></cfif>
            <cfset qrow.IS_NUMERIC = (listFindNoCase(numeric_columns, qrow.TITLE) neq 0)>
            <cfset qrow.IS_SELECTED = (listFindNoCase(hidden_list, qrow.TITLE) eq 0 and listFindNoCase(non_inputs, qrow.TITLE) eq 0 ? (listFindNoCase(display_list, qrow.TITLE) eq 0 ? qrow.IS_SELECTED : 1) : 0)>
            <cfset qrow.IS_LV = listFindNoCase(selectbox_columns, qrow.TITLE) neq 0>
            <cfset qrow.IS_POPUP = listFindNoCase(popup_columns, qrow.TITLE) neq 0>
            <cfif session_base.PRICE_VALID eq 1>
            <cfset qrow.IS_READONLY = (listFindNoCase(price_columns, qrow.TITLE) neq 0 or listFindNoCase(non_inputs, qrow.TITLE) neq 0 ? qrow.IS_READONLY : 1)>
            </cfif>
            <cfset qrow.IS_AMOUNT = (listFindNoCase(amount_list, qrow.TITLE) neq 0)>
            <cfset qrow.IS_HESAPLA = (listFindNoCase(hesapla_columns, qrow.TITLE) neq 0)>
            #replace(serializeJSON( qrow ), "//", "")#
            <cfif currentRow lt basket_data.recordcount>
            ,
            </cfif>
            </cfloop>
            </cfoutput>
        ]`));
        basketManager.setBasketItems(
            <cfoutput>#replace(SerializeJSON(sepet.satir), "//", "")#</cfoutput>
        );
        <cfif structKeyExists( sepet, "total" )>
        basketManager.setBasketFooterItem( "basket_gross_total", <cfoutput>#wrk_round( sepet.total, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "total_tax" )>
        basketManager.setBasketFooterItem( "basket_tax_total", <cfoutput>#wrk_round( sepet.total_tax, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "total_otv" )>
        basketManager.setBasketFooterItem( "basket_otv_total", <cfoutput>#wrk_round( sepet.total_otv, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "net_total" )>
        basketManager.setBasketFooterItem( "basket_net_total", <cfoutput>#wrk_round( sepet.net_total, basket_total_round_number )#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "toplam_indirim" )>
        basketManager.setBasketFooterItem( "basket_discount_total", <cfoutput>#wrk_round( sepet.toplam_indirim, basket_total_round_number )#</cfoutput> );
        </cfif>
        
        <cfif isDefined("sepet_rate1")>
        basketManager.setBasketFooterItem( "basket_rate1", <cfoutput>#sepet_rate1#</cfoutput> );
        </cfif>
        <cfif structKeyExists( sepet, "genel_indirim" )>
        basketManager.setBasketFooterItem( "genel_indirim", <cfoutput>#sepet.genel_indirim#</cfoutput> );
        </cfif>
        <cfif isDefined("get_money_bskt") and get_money_bskt.recordcount>
        basketManager.setBasketFooterItem( "kur_say", <cfoutput>#get_money_bskt.recordcount#</cfoutput> );
        </cfif>
        <cfif isDefined("get_money_bskt") and get_money_bskt.recordCount>
        basketManager.setBasketFooterItem( "basket_money", '<cfoutput>#get_money_bskt["MONEY_TYPE"][ arrayFind(get_money_bskt["IS_SELECTED"], "1") ]#</cfoutput>' );
        <cfelseif isDefined("str_money_bskt")>
        basketManager.setBasketFooterItem( "basket_money", '<cfoutput>#str_money_bskt#</cfoutput>' );
        </cfif>
        <cfif structKeyExists(sepet, "tevkifat_box")>
        basketManager.setBasketFooterItem("is_tevkifat", 1);
        basketManager.setBasketFooterItem("tevkifat_oran", <cfoutput>#sepet.tevkifat_oran#</cfoutput>);
        </cfif>
        <cfif (listFirst(attributes.fuseaction, ".") eq "invoice" or (listFind("1,2,3,4,10,14,18,20,21,33,42,43,51,52",attributes.basket_id,","))) >
        basketManager.setBasketFooterItem("free_prom_stock_id", <cfoutput>#iif(isDefined("sepet.free_prom_stock_id"), "sepet.free_prom_stock_id", de("''"))#</cfoutput>);
        basketManager.setBasketFooterItem("free_prom_limit", <cfoutput>#iif(isDefined("sepet.free_prom_limit"), "sepet.free_prom_limit", de(0))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_id", <cfoutput>#iif(isDefined("sepet.general_prom_id"), "sepet.general_prom_id", de("''"))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_limit", <cfoutput>#iif(isDefined("sepet.general_prom_limit"), "sepet.general_prom_limit", de(0))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_discount", <cfoutput>#iif(isDefined("sepet.general_prom_discount"),"sepet.general_prom_discount", de(0))#</cfoutput>);
        basketManager.setBasketFooterItem("general_prom_amount", <cfoutput>#iif(isDefined("sepet.general_prom_amount"),"sepet.general_prom_amount",de(0))#</cfoutput>);
        </cfif>
        <cfif structKeyExists(sepet, "vat_exception_id") and len(sepet.vat_exception_id)>
        basketManager.setBasketFooterItem("exc_id", <cfoutput>#sepet.vat_exception_id#</cfoutput>);
        basketManager.setBasketFooterItem("exc_code", <cfoutput>#vat_exc_code#</cfoutput>);
        basketManager.setBasketFooterItem("exc_article", <cfoutput>#vat_exc_art#</cfoutput>);
        </cfif>
        <cfif structKeyExists(sepet, "stopaj_yuzde")>
        basketManager.setBasketFooterItem("stopaj", <cfoutput>#wrk_round(sepet.stopaj)#</cfoutput>);
        basketManager.setBasketFooterItem("stopaj_rate_id", <cfoutput>#sepet.stopaj_rate_id#</cfoutput>);
        basketManager.setBasketFooterItem("stopaj_yuzde", <cfoutput>#wrk_round(sepet.stopaj_yuzde)#</cfoutput>);
        </cfif>
        basketManager.setBasketFooterItem("sale_product", <cfoutput>#len(sale_product)?1:0#</cfoutput>);
        <cfif isdefined("attributes.is_retail") and isdefined("GET_CASHES") and GET_CASHES.recordcount>
            function mappingCashList(data){
                var elm = {
                    items: data.ITEMS,
                    currency_type: data.CURRENCY_TYPE,
                    kasa: ko.observable( data.KASA != undefined ? data.KASA : '' ),
                    cash_amount: ko.observable( data.CASH_AMOUNT != undefined ? data.CASH_AMOUNT : '' ),
                    cash_action_id: data.CASH_ACTION_ID != undefined ? data.CASH_ACTION_ID : ''
                }
                elm.system_cash_amount = ko.computed(function () {
                    var kasa_money_rate2 = 0, kasa_money_rate1 = 0;
                    moneyArray.forEach((item, index) => {
                        if(item == elm.currency_type){
                            kasa_money_rate2 = rate2Array[index];
                            kasa_money_rate1 = rate1Array[index];
                        }
                    });
                    return filterNum( commaSplit( elm.cash_amount() ) ) * ( kasa_money_rate2 / kasa_money_rate1 );
                });
                return elm;
            }
            basketManager.setBasketFooterItem("cash_list", <cfoutput>#replace(serializeJSON(cashList), "//", "")#</cfoutput>.map((el) => mappingCashList(el)));
        </cfif>
        <cfif isdefined("attributes.is_retail") and isdefined("GET_POS_DETAIL") and GET_POS_DETAIL.recordcount>
            function mappingPosList(data){
                var elm = {
                    items: data.ITEMS,
                    pos: ko.observable( data.POS != undefined ? data.POS : '' ),
                    pos_amount: ko.observable( data.POS_AMOUNT != undefined ? data.POS_AMOUNT : '' ),
                    pos_action_id: data.POS_ACTION_ID != undefined ? data.POS_ACTION_ID : ''
                }
                elm.system_pos_amount = ko.computed(function () {
                    var kasa_money_rate2 = 0, kasa_money_rate1 = 0;
                    var money = elm.items.filter( (el) => { return el.ID == elm.pos() } );
                    if(money.length > 0){
                        var currency_type = money[0].ID.split(';')[1];
                        moneyArray.forEach((item, index) => {
                            if(item == currency_type){
                                kasa_money_rate2 = rate2Array[index];
                                kasa_money_rate1 = rate1Array[index];
                            }
                        });
                        return filterNum( commaSplit( elm.pos_amount() ) ) * ( kasa_money_rate2 / kasa_money_rate1 );
                    }else return 0;
                });
                return elm;
            }
        basketManager.setBasketFooterItem("pos_list", <cfoutput>#replace(serializeJSON(posList), "//", "")#</cfoutput>.map((el) => mappingPosList(el)));   
        </cfif>
        //basketManager.setPaging();
        //basketManager.init();
        function kontrol(){
        
		//if(!paper_control(form_basket.invoice_number,'INVOICE')) return false;
		//if(!chk_process_cat('form_basket')) return false;
		//if(!check_display_files('form_basket')) return false;
		//if(!chk_period(form_basket.invoice_date,"İşlem")) return false;
		//if(!check_product_accounts()) return false;
        
        if( basketManagerObject.getCustomer().CUSTOMER_TYPE() == '1' ){
            if( $("input[name=comp_name]").val() == "" || $("input[name=tax_office]").val() == "" || $("input[name=tax_num]").val() == "" || $("textarea[name=address]").val() == "" ){
		        alert("<cf_get_lang dictionary_id ='57339.Kurumsal Müşteri İçin Firma, Vergi Dairesi, Vergi Numarası ve Adres Bilgilerini Giriniz'>!");
			    return false;
		    }
            if( $("input[name=company_stage]").val() == "" && $("input[name=company_id]").val() == "" ){
		        alert("<cf_get_lang dictionary_id ='57340.Kurumsal Üye Süreçlerinizi Kontrol Ediniz'>!");
			    return false;
		    }
		}else if( basketManagerObject.getCustomer().CUSTOMER_TYPE() == '2' ){
            if( $("input[name=member_name]").val() == "" || $("input[name=member_surname]").val() == "" || $("textarea[name=address]").val() == "" ){
		        alert("<cf_get_lang dictionary_id ='57258.Bireysel Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
			    return false;
		    }
            if( $("input[name=consumer_stage]").val() == "" && $("input[name=consumer_id]").val() == "" ){
		        alert("<cf_get_lang dictionary_id ='57341.Bireysel Üye Süreçlerinizi Kontrol Ediniz'>!");
			    return false;
		    }
        }else if( basketManagerObject.getCustomer().CUSTOMER_TYPE() != '1' || basketManagerObject.getCustomer().CUSTOMER_TYPE() != '2' ){
            alert("<cf_get_lang dictionary_id='34146.Üye Seçin'>");
            return false;
        }
        

	    if( $("input[name=department_id]").val() == "" ){
	        alert("<cf_get_lang dictionary_id='57284.Depo Seçiniz'>!");
		    return false;
	    }

		var kalan_risk_ = 0;
		if( basketManagerObject.getCustomer().CUSTOMER_TYPE() == '1' ){
			var risk_info = wrk_safe_query('inv_risk_info','dsn2',0,document.getElementById('company_id').value);
		}
		else if( basketManagerObject.getCustomer().CUSTOMER_TYPE() == '2'  ){
			var risk_info = wrk_safe_query('inv_risk_info2','dsn2',0,document.getElementById('consumer_id').value);
		}

		if(risk_info != undefined && risk_info.recordcount){
			risk_tutar_ = parseFloat(risk_info.TOTAL_RISK_LIMIT) - parseFloat(risk_info.BAKIYE) - (parseFloat(risk_info.CEK_ODENMEDI) + parseFloat(risk_info.SENET_ODENMEDI) + parseFloat(risk_info.CEK_KARSILIKSIZ) + parseFloat(risk_info.SENET_KARSILIKSIZ));
			kalan_risk_ = parseFloat( risk_tutar_ - wrk_round( basketManagerObject.basketFooter.basket_net_total()) );
		}
		else
			kalan_risk_ = -1;
	
        <cfif is_control_risk eq 1>
            if(kalan_risk_ < 0){
                if( parseFloat( basketManagerObject.basketFooter.total_cash_amount() ) > parseFloat( basketManagerObject.basketFooter.basket_net_total() )){
                    alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
                    return false;
                }
                if(parseFloat( basketManagerObject.basketFooter.total_cash_amount() ) < parseFloat( basketManagerObject.basketFooter.basket_net_total() )){
                    alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
                    return false;
                }   
            }
        <cfelseif is_control_risk eq 2>
            if(parseFloat( basketManagerObject.basketFooter.total_cash_amount() ) > parseFloat( basketManagerObject.basketFooter.basket_net_total() )){
                alert("<cf_get_lang dictionary_id='57259.Tahsilat Fatura Toplamından Fazla'>");
                return false;
            }
            if(parseFloat( basketManagerObject.basketFooter.total_cash_amount() ) < parseFloat( basketManagerObject.basketFooter.basket_net_total() )){
                alert("<cf_get_lang dictionary_id ='57342.Tahsilat Fatura Toplamından Az'>!");
                return false;
            }
        </cfif>
		return (check_cash_pos() && saveFormAll());
		return false;
	}

    function closePrint () {
        document.body.removeChild(this.__container__);
    }

    function setPrint () {
        this.contentWindow.__container__ = this;
        this.contentWindow.onbeforeunload = closePrint;
        this.contentWindow.onafterprint = closePrint;
        this.contentWindow.focus(); // Required for IE
        this.contentWindow.print();
    }
	
    function printInvoice(id) {
        var oHideFrame = document.createElement("iframe");
        oHideFrame.onload = setPrint;
        oHideFrame.style.position = "fixed";
        oHideFrame.style.right = "0";
        oHideFrame.style.bottom = "0";
        oHideFrame.style.width = "0";
        oHideFrame.style.height = "0";
        oHideFrame.style.border = "0";
        oHideFrame.src = '/wex.cfm/findinvoiceretail/print_invoice?id='+id;
        document.body.appendChild(oHideFrame);
 
    }
    
    function sendInvoice(id){        
        $.ajax({ 
            url:'/wex.cfm/findinvoiceretail/send_invoice',
            dataType: "text",
            data: { invoice_id : id },
            cache: false,
            async: false,
            success: function (response) {  
                data = $.parseJSON(response);
                if(data.STATUS){
                    alert(data.MESSAGE);
                    $("label#invoiceSend").hide();
                }else{
                    alert(data.MESSAGE);
                }
            },
            error: function () 
            {
                console.log('CODE:8 please, try again..');
                return false; 
            }
        });
    }


	function check_cash_pos()
	{ //kasa ve pos tutarları formatlanıyor
		//secili kasaLar
			<cfoutput query="get_money_bskt">
				if(eval( $("##kasa#get_money_bskt.currentrow#")) != undefined && eval( $("##cash_amount#get_money_bskt.currentrow#")) != undefined && eval($("##cash_amount#get_money_bskt.currentrow#")).val() != "")
				{
                    $("##cash").val(1);
				}
			</cfoutput>
		//pos tahsilatlari
		for(var a=1; a<=3; a++)
		{
			if( eval( $("#pos_amount_"+a )) != undefined && $("#pos_amount_"+a ).val() != "")
			{
				eval( $("#pos_amount_"+a ) ).val( filterNum( (eval( $("#pos_amount_"+ a ) ).val() ) ) );
				$("#is_pos").val(1);
			}
		}
		return true;
	}
    {setTimeout(function() { document.getElementById("keyword").focus(); }, 500)};
    </script>
    <cfif not IsDefined("session.wp")>
    <script type="text/javascript" src="/JS/basket/apps/retail.js"></script>
    <cfelse>
    <script type="text/javascript" src="../asset/js/lib/basket/apps/retail.js"></script>
    </cfif>