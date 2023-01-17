$(function(){

    ko.bindingHandlers.findProductByKeyword = {
        init: function (element, valueAccessor, allBindings, viewModel) {
            var callback = valueAccessor();
            $(element).keyup(function (event) {
                callback.call(viewModel);
                return true;
            });
        }
    };

    var retailApp = function () {
        if ( window.basketManagerObject === undefined ) 
            window.basketManagerObject = {};
        var self = window.basketManagerObject;

        self.keyword = ko.observable('');
        self.showAddConsumer = ko.observable(false);
        self.keywordResult = ko.observableArray([]);
        self.KResult = ko.observable(false);
        self.customers = null;
        self.selectedCustomer = ko.observable(null);
        self.addressMode = ko.observable('invoice');
        self.countries = ko.observableArray([]);
        self.cities = ko.observableArray([]);
        self.counties = ko.observableArray([]);
        self.productstep = ko.observable('category');
        self.boxstep = ko.observable();
        self.divstep = ko.observable('general');
        self.prodShow = ko.observable('general');
        self.barcode = ko.observable('');
        self.barcode2 = ko.observable('');
        self.serial_number = ko.observable('');
        self.stock_code = ko.observable('');
        self.lot_number = ko.observable('');
        self.product_keyword = ko.observable();
        self.products = ko.observableArray([]);
        self.productsDup = ko.observableArray([]);
        self.product_categories = ko.observableArray([]);
        self.category_head = ko.observable('');
        self.Productkeyword = ko.observable('');
        self.consumer_id = ko.observable(basketService.get('cashSettings')[0].CUSTOMER_ID);
        self.PosIndex = ko.observable(null);
        self.cashIndex = ko.observable(null);

        self.customerFactoryRaw = function () {
            return {
                CUSTOMER_TYPE: "new",
                ADDRESS: "",
                COMPANY: "",
                CONSUMER_ID: "",
                CONSUMER_NAME: "",
                CONSUMER_SURNAME: "",
                MOBILTEL: "",
                MOBIL_CODE: "",
                TC_IDENTY_NO: "",
                COMPANY_ID: "",
                COMPANY_PARTNER_NAME: "",
                COMPANY_PARTNER_SURNAME: "",
                COMPANY_TEL1: "",
                COMPANY_TELCODE: "",
                FULLNAME: "",
                MEMBER_CODE: "",
                TAXNO: "",
                TAXOFFICE: "",
                INVOICE_ADDRESS: {
                    COUNTRY_ID: 225,
                    CITY_ID: 0,
                    COUNTY_ID: 0,
                    DISTRICT: 0,
                    STREET: "",
                    DOOR_NO: "",
                    POST_CODE: "",
                    ADDRESS: ""
                },
                SHIP_ADDRESS: {
                    COUNTRY_ID: 225,
                    CITY_ID: 0,
                    COUNTY_ID: 0,
                    DISTRICT: 0,
                    STREET: "",
                    DOOR_NO: "",
                    POST_CODE: "",
                    ADDRESS: ""
                }
            }
        }
        self.customerFactory = function () {
            return ko.mapping.fromJS(self.customerFactoryRaw());
        }

        self.customerInfo = ko.observable(self.customerFactory());

        self.findCustomerByKeyword = async function() {
            self.showAddConsumer(false);
            self.customerInfo().CUSTOMER_TYPE('new');

            if( self.keyword() == "" ) return;
            let wexresult = await fetch('/wex.cfm/findconsumer/list', {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({keyword: self.keyword()})
            });
            $('#customer_modal_panel').fadeIn();
            var jsresult = await wexresult.json();
            self.customers = jsresult;
            var jslist = jsresult.company.map(e => { return ko.mapping.fromJS({ type: "1", title: e.FULLNAME, id: e.COMPANY_ID, member_code: e.MEMBER_CODE, taxNo: e.TAXNO, taxOffice: e.TAXOFFICE, telcode: e.COMPANY_TELCODE, tel: e.COMPANY_TEL1 });});
            jslist = jslist.concat(jsresult.consumer.map(e => { return ko.mapping.fromJS({ type: "2", title: e.CONSUMER_NAME + " " + e.CONSUMER_SURNAME, id: e.CONSUMER_ID, member_code: e.MEMBER_CODE, taxNo: e.TC_IDENTY_NO, taxOffice: '', telcode: e.MOBILTEL, tel: e.MOBIL_CODE  });}));
            self.KResult(true);
            self.keywordResult.removeAll();
            self.keywordResult(jslist);
        }

        self.findCustomerStatic = async function() {
            self.showAddConsumer(false);
            self.KResult(false);
            self.customerInfo().CUSTOMER_TYPE('new');

            if( self.consumer_id() == "" ) return;
            let wexresult = await fetch('/wex.cfm/findconsumer/list', {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({consumer_id: self.consumer_id()})
            });
            $('#customer_modal_panel').fadeOut();
            var jsresult = await wexresult.json();
            self.customers = jsresult;
            var jslist = jsresult.consumer.map(e => { return ko.mapping.fromJS({ type: "2", title: e.CONSUMER_NAME + " " + e.CONSUMER_SURNAME, id: e.CONSUMER_ID, member_code: e.MEMBER_CODE, taxNo: e.TC_IDENTY_NO, taxOffice: '', telcode: e.MOBILTEL, tel: e.MOBIL_CODE  });})[0];
            self.setCustomer(jslist);
        }

        self.getCountries = async function () {
            let wexresult = await (fetch('/wex.cfm/findconsumer/country', {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: '{}'
            }));
            var jresult = await wexresult.json();
            self.countries.removeAll();
            self.countries(jresult);
        }
        self.countryChanged = async function () {
            let wexresult = await (fetch('/wex.cfm/findconsumer/city', {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ 
                    country: self.addressMode() == 'invoice' ? self.getCustomer().INVOICE_ADDRESS.COUNTRY_ID() : self.getCustomer().SHIP_ADDRESS.COUNTRY_ID()
                })
            }));
            var jresult = await wexresult.json();
            self.cities.removeAll();
            self.cities(jresult);
        }
        self.cityChanged = async function () {
            let wexresult = await (fetch('/wex.cfm/findconsumer/county', {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ 
                    city: self.addressMode() == 'invoice' ? self.getCustomer().INVOICE_ADDRESS.CITY_ID() : self.getCustomer().SHIP_ADDRESS.CITY_ID() 
                })
            }));
            var jresult = await wexresult.json();
            self.counties.removeAll();
            self.counties(jresult);
        }
        self.setCustomer = function (object) {
            self.selectedCustomer(object);
            self.KResult(false);
            self.keywordResult.removeAll();
            self.keyword('');

            if (self.selectedCustomer().type() == "1") {
                let filteredCustomers = self.customers.company.filter(e => e.COMPANY_ID == self.selectedCustomer().id());
                if (filteredCustomers.length > 0) {
                    let customerInfo = filteredCustomers[0];
                    self.getCountries().then((event) => {
                        customerInfo.INVOICE_ADDRESS = { COUNTRY_ID : customerInfo.COUNTRY_ID, CITY_ID : "", COUNTY_ID: "" };
                        customerInfo = Object.assign(self.customerFactoryRaw(), customerInfo);  
                        self.customerInfo(ko.mapping.fromJS(Object.assign(customerInfo, {CUSTOMER_TYPE: "1"} )));
                    }).then((e) => {
                        self.countryChanged().then((e) => {
                            self.customerInfo().INVOICE_ADDRESS.CITY_ID( customerInfo.CITY_ID );
                        }).then((e) => {
                            self.cityChanged().then((e) => {
                                self.customerInfo().INVOICE_ADDRESS.COUNTY_ID( customerInfo.COUNTY_ID ); 
                            })
                        });
                    });
                }
            } else if (self.selectedCustomer().type() == "2") {
                let filteredCustomers = self.customers.consumer.filter(e => e.CONSUMER_ID == self.selectedCustomer().id());
                if (filteredCustomers.length > 0) {
                    let customerInfo = filteredCustomers[0];
                    self.getCountries().then((event) => {
                        customerInfo.INVOICE_ADDRESS = { COUNTRY_ID : customerInfo.COUNTRY_ID, CITY_ID : "", COUNTY_ID: "" };
                        customerInfo = Object.assign(self.customerFactoryRaw(), customerInfo);  
                        self.customerInfo(ko.mapping.fromJS(Object.assign(customerInfo, {CUSTOMER_TYPE: "2"} )));
                    }).then((e) => {
                        self.countryChanged().then((e) => {
                            self.customerInfo().INVOICE_ADDRESS.CITY_ID( customerInfo.CITY_ID );
                        }).then((e) => {
                            self.cityChanged().then((e) => {
                                self.customerInfo().INVOICE_ADDRESS.COUNTY_ID( customerInfo.COUNTY_ID ); 
                            })
                        });
                    });
                }
            }
        }
        self.setSpeedCustomer = function(){
            self.setCustomer(this);
            $('#customer_modal_panel').fadeOut();
        }

        self.getCustomer = function () {
            return self.customerInfo();
        }
        self.toggleCustomerAddForm = function () {
            $('#customer_modal_panel').fadeIn();
            self.showAddConsumer(!self.showAddConsumer());
            if (self.showAddConsumer()) {
                self.selectedCustomer(null);
                self.customerInfo(self.customerFactory());
                if (self.countries().length == 0) {
                    self.getCountries().then(() => {
                        self.countryChanged();
                    });
                }
            }
        }
        self.barcodeChanged = async function () {
            let wexresult = await (fetch('/wex.cfm/findproduct/list', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    "is_sale_product":"1",
                    "is_cost":"false",
                    "update_product_row_id":"0",
                    "sepet_process_type":"-1",
                    "int_basket_id":"18",
                    "is_price":"false",
                    "is_price_other":"false",
                    "paymethod_id":"",
                    "is_submit_form": "1",
                    "barcode": ( self.barcode() != '') ? self.barcode() : self.barcode2(),
                    "serial_number": self.serial_number(),
                    "stock_code": self.stock_code(),
                    "lot_number": self.lot_number(),
                    "product_keyword": self.product_keyword(),
                    "from_price_page": 1,
                    "price_catid": ( document.getElementById('price_catid').value.length ) ? document.getElementById('price_catid').value : -2,
                    "search_process_date": document.getElementById('search_process_date').value
                })
            }));
            var jresult = await wexresult.json();
            if ( self.barcode() != '' ){
                self.add_to_basket(jresult[0], document.getElementById("qrAmount").value );
                document.getElementById("qrAmount").value = commaSplit(1, basketService.priceRoundNumber());
            }else{
                self.products(jresult);
                self.productsDup(jresult);
                self.productstep('prodlist');
                if( jresult.length && self.product_keyword() == "" ) self.category_head(jresult[0]["CATEGORY_NAME"]);
                else self.category_head( self.product_keyword() );
            }

            self.product_keyword('');
            self.lot_number('');
            self.stock_code('');
            self.serial_number('');
            self.barcode('');
            self.barcode2('');
        }
        self.categoryChanged = async function(p_catid, p_cat){
            let wexresult = await (fetch('/wex.cfm/findproduct/list', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    "is_sale_product":"1",
                    "is_cost":"false",
                    "update_product_row_id":"0",
                    "sepet_process_type":"-1",
                    "int_basket_id":"18",
                    "is_price":"false",
                    "is_price_other":"false",
                    "paymethod_id":"",
                    "is_submit_form": "1",
                    "product_catid": p_catid,
                    "from_price_page": 1,
                    "price_catid": ( document.getElementById('price_catid').value.length ) ? document.getElementById('price_catid').value : -2,
                    "search_process_date": document.getElementById('search_process_date').value
                })
            }));
            var jresult = await wexresult.json();
            self.products(jresult);
            self.productsDup(jresult);
            self.productstep('prodlist');
            if( jresult.length ) self.category_head(p_cat);
            else self.category_head('');
        }
        self.add_to_basket = async function (curr_obj, Rowamount) {
            let postdata = {
                is_sale_product: 1
                ,is_cost: false
                ,update_product_row_id: 0
                ,sepet_process_type: -1
                ,int_basket_id: 18
                ,branch_id: undefined
                ,rowcount: 0
                ,is_price: false
                ,is_price_other: false
                ,satir: -1
                ,from_basket: 1
                ,is_chck_dept_based_stock: 0
                ,use_paymethod_for_prod_conditions: 0
                ,use_general_price_cat_exceptions: 1
                ,use_project_discounts: 0
                ,is_basket_zero_stock: 1
                ,is_basket_zero_stock_control_date: 0
                ,search_process_date: ""
                ,from_price_page: 0
                ,department_out: undefined
                ,department_in: ""
                ,location_out: undefined
                ,location_in: ""
                ,update_product_row_id: 0
                ,product_id: curr_obj.PRO_ID
                ,stock_id: curr_obj.STK_ID
                ,stock_code: curr_obj.STOCK_CODE
                ,barcod: curr_obj.BRC_CODE
                ,manufact_code: curr_obj.MAN_CODE
                ,product_name: decodeURIComponent(curr_obj.NAME_PRODUCT_)
                ,product_name_other: ''
                ,row_unique_relation_id: ''
                ,row_catalog_id: ''
                ,toplam_hesap_yap: 1
                ,basket_extra_info: ''
                ,row_service_id: ''
                ,wrk_row_relation_id: ''
                ,related_action_id: ''
                ,related_action_table: ''
                ,row_width: ''
                ,row_depth: ''
                ,row_height: ''
                ,to_shelf_number: ''
                ,row_project_id: ''
                ,row_project_name: ''
                ,row_otv_amount: ''
                ,action_window_name: ''
                ,special_code: ''
                ,basket_employee_id: ''
                ,basket_employee: ''
                ,row_work_id: ''
                ,row_work_name: ''
                ,row_exp_center_id: ''
                ,row_exp_center_name: ''
                ,row_exp_item_id: ''
                ,row_exp_item_name: ''
                ,row_acc_code: ''
                ,select_info_extra: ''
                ,detail_info_extra: ''
                ,row_activity_id: ''
                ,row_subscription_id: ''
                ,row_subscription_name: ''
                ,row_assetp_id: ''
                ,row_assetp_name: ''
                ,row_bsmv_rate: ''
                ,row_bsmv_amount: ''
                ,row_bsmv_currency: ''
                ,row_oiv_rate: ''
                ,row_oiv_amount: ''
                ,row_tevkifat_rate: ''
                ,row_tevkifat_amount: ''
                ,reason_code_info: ''
                ,row_tevkifat_id: ''
                ,bsmv_: curr_obj.BSMV_
                ,oiv_: curr_obj.OIV_
                ,unit_id: curr_obj.ADD_BASKET[0].PRODUCT_UNIT_ID
                ,unit: curr_obj.ADD_BASKET[0].ADD_UNIT
                ,is_inventory: curr_obj.ADD_BASKET[0].IS_INVENTORY
                ,product_code: ""
                ,amount: filterNum(Rowamount)
                ,is_serial_no: 1
                ,unit_multiplier: 1
                ,amount_multiplier: curr_obj.ADD_BASKET[0].AMOUNT_MULTIPLIER
                ,price_cat_amount_multiplier: ""
                ,kur_hesapla: false
                ,is_sale_product: 1
                ,tax: curr_obj.TAX_END
                ,otv: curr_obj.OTV_
                ,flt_price_other_amount: ""
                ,str_money_currency: ""
                ,department_id: ""
                ,due_day_value: ""
                ,department_name: ""
                ,row_promotion_id: ""
                ,promosyon_yuzde: ""
                ,promosyon_maliyet: ""
                ,promosyon_form_info: ""
                ,basket_id: 18
                ,spec_id: ""
                ,is_production: curr_obj.ADD_BASKET[0].IS_PRODUCTION
                ,ek_tutar: ""
                ,unit_other: ""
                ,price_catid: curr_obj.PRICE_CATID
                ,flt_price: curr_obj.PRICE
                ,shelf_number: ""
                ,deliver_date: ""
                ,duedate: ""
                ,number_of_installment: ""
                ,list_price: ""
                ,amount_other: 1.000
                ,catalog_id: ""
                ,lot_no: curr_obj.ADD_BASKET[0].LOT_NO
                ,gtip_number: ""
                ,expense_center_id: curr_obj.ADD_BASKET[0].EXPENSE_CENTER_ID
                ,expense_center_name: curr_obj.ADD_BASKET[0].EXPENSE_CENTER_NAME
                ,expense_item_id: curr_obj.ADD_BASKET[0].EXPENSE_ITEM_ID
                ,expense_item_name: curr_obj.ADD_BASKET[0].EXPENSE_ITEM_NAME
                ,activity_type_id: curr_obj.ADD_BASKET[0].ACTIVITY_TYPE_ID
                ,product_detail2: curr_obj.PRODUCT_DETAIL2
                ,product_cat: curr_obj.CATEGORY_NAME
                ,product_catid: curr_obj.CATEGORY_CATID
            };
            let wexresult = await (fetch('/wex.cfm/findproduct/add_row', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json; charset=UTF-8"
                },
                body: JSON.stringify(postdata)
            }));
            var jresult = await wexresult.json();
            if( jresult.status ){
                row_object( jresult );
                $('.popup').fadeIn();
                setTimeout(function() { $('.popup').fadeOut(); }, 1000);
            }
        }
        // 1 company
        self.setCompany = function () {
            self.customerInfo().CUSTOMER_TYPE("1");
        }
        // 2 consumer
        self.setConsumer = function () {
            self.customerInfo().CUSTOMER_TYPE("2");
        }
        self.setProductNone = function () {
            self.productstep('category');
            self.getProductCategory();
        }
        self.setProductSearch = function () {
            self.productstep('search');
            self.prodShow('none');
        }
        self.setProductCategory = function () {
            self.productstep('category');
            self.getProductCategory();
        }
        self.setProductList = function () {
            self.prodShow('none');
            self.productstep('prodlist');
        }
        self.setProductDetail = function () {
            self.prodShow('none');
            self.productstep('proddet');
        }
        self.setPayDetail = function () {
            self.prodShow('general');
            self.boxstep('paydetail');
            self.divstep('none');
        }
        self.setResultDetail = function () {
            self.boxstep('resultdetail');
        }
        self.getProductCategory = async function() {
            let wexresult = await (fetch('/wex.cfm/findproduct/categories', {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: '{}'
            }));
            var jresult = await wexresult.json();
            self.product_categories(jresult);
        }
        self.findProduct = function() {
            if( self.Productkeyword() != '' ){
                self.productsDup( self.products().filter(function(i) {
                    return i.NAME_PRODUCT_.toLowerCase().indexOf( self.Productkeyword() ) >= 0;
                }) );
            }else{
                self.productsDup( self.products() );
            }
        }
        self.clear_row = function(rowNum){
            basketManagerObject.basketItems.remove(rowNum);
            toplam_hesapla(0);
        }
        self.downAmount = function(rowNum){
            ( basketManagerObject.basketItems()[rowNum].amount() > 0 ) ? basketManagerObject.basketItems()[rowNum].amount( ( basketManagerObject.basketItems()[rowNum].amount() > 1 ) ? basketManagerObject.basketItems()[rowNum].amount() - 1 : basketManagerObject.basketItems()[rowNum].amount() ) : 1;
            satir_hesapla('amount', basketManagerObject.basketItems()[rowNum]);
        }
        self.upAmount = function(rowNum){
            basketManagerObject.basketItems()[rowNum].amount( basketManagerObject.basketItems()[rowNum].amount() + 1 );
            console.log(basketManagerObject.basketItems()[rowNum]);
            satir_hesapla('amount', basketManagerObject.basketItems()[rowNum]);
        }
        self.addPosIndex = async function(param){
            self.PosIndex(param); 
            self.cashIndex(null);
        }
        self.addCashIndex = async function(param){
            self.cashIndex(param);
            self.PosIndex(null); 
        }
        self.chMoney = async function(number){
            if( self.PosIndex() != null ){
                var posAmount = number == 'x' ? 0 : 
                                basketManagerObject.basketFooter.pos_list()[self.PosIndex()].pos_amount() != 0 
                                ? basketManagerObject.basketFooter.pos_list()[self.PosIndex()].pos_amount() + "" + number
                                : number;
                basketManagerObject.basketFooter.pos_list()[self.PosIndex()].pos_amount( posAmount ); 
            }else{
                var cashAmount = number == 'x' ? 0 : 
                                basketManagerObject.basketFooter.cash_list()[self.cashIndex()].cash_amount() != 0 
                                ? basketManagerObject.basketFooter.cash_list()[self.cashIndex()].cash_amount() + "" + number 
                                : number; 
                basketManagerObject.basketFooter.cash_list()[self.cashIndex()].cash_amount( cashAmount );
            }
        }
        self.delamount = function(){
            if( self.basketFooter.cash_list().length > 0 ){
                self.basketFooter.cash_list().forEach((el) => {
                   el.cash_amount('');
                });
            }
    
            if( self.basketFooter.pos_list().length > 0 ){
                self.basketFooter.pos_list().forEach((el) => {
                    el.pos_amount('');
                });
            }
            cfmodalx({e:'close',id:'pay_modal_panel'});
        }

        self.setProductCategory();

    };

    window.retailAppInstance = new retailApp();
    ko.applyBindings(window.basketManagerObject, document.getElementById('retailApp'));

    $('a.info').click(function(){
        $(this).parents('li').find('.discount').fadeToggle();
    })

    
    
});