<link href="/WBP/Recycle/files/css/fabochart.css" rel="stylesheet" type="text/css">

<div id="control_automation-app">
    <cf_box title="#getLang('','Geri Dönüşüm Kontrol Otomasyonu',62174)#">
        <template v-if = "tankListObject.length">
            <div v-for = "(tankList, tankListIndex) in tankListObject" v-bind:key = "tankListIndex" style="width:2400px;float:left;">
                <div v-for = "(department, departmentIndex) in tankList.department" v-bind:key = "departmentIndex" class="line-chart">
                    <template v-if = "department.block.length">
                        <template v-for = "(block, blockIndex) in department.block" v-bind:key = "blockIndex">
                            <h3 class="text-center text-danger">{{ block.department_head }}</h3>
                            <div :id = "'chart_' + tankListIndex + '_' + departmentIndex + '_' + blockIndex"></div>
                        </template>
                    </template>
                </div>
            </div>
        </template>
    </cf_box>

    <div id = "automation_info" style="display:none;">
        <template v-if = "modalParams.mode == 'transferOrder'">
            <cf_box>
                <cf_box_elements>
                    <div class="col col-12">
                        <form name="transportOrdersForm" id="transportOrdersForm" method="POST">
                            <cfoutput>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang dictionary_id='62090.Emri Veren'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="transport_ordering_employee_id" id="transport_ordering_employee_id" v-model="transferOrderParam.transport_ordering_employee_id">        
                                        <input type="text" name="transport_ordering_name" id="transport_ordering_name" v-model="transferOrderParam.transport_ordering_name" value="#session.ep.name# #session.ep.surname#" style="width:100px;" autocomplete="off" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=transportOrdersForm[1].transport_ordering_employee_id&field_name=transportOrdersForm[1].transport_ordering_name&is_form_submitted=1&select_list=1&call_function=controlAutomation.setPosition()','list');" title="<cf_get_lang dictionary_id='62090.Emri Veren'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left">Operatör</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="operator_employee_id" id="operator_employee_id" v-model="transferOrderParam.operator_employee_id">
                                        <input type="text" name="operator_name" id="operator_name" v-model="transferOrderParam.operator_name" value="" style="width:100px;" autocomplete="off" readonly>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=transportOrdersForm[1].operator_employee_id&field_name=transportOrdersForm[1].operator_name&is_form_submitted=1&select_list=1&call_function=controlAutomation.setOperatorPosition()','list');" title="Operatör"></span>
                                    </div>
                                </div>
                            </div>
                            </cfoutput>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang dictionary_id='62089.Çıkış Tank'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="exit_tank_transfer_location_id" id="exit_tank_transfer_location_id" disabled>
                                        <option :value="transferOrderParam.exit_tank_department_location">{{transferOrderParam.exit_tank_location_comment}}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang dictionary_id='62088.Giriş Tank'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <select name="entry_tank_department_location_id" v-model="transferOrderParam.entry_tank_department_location_id" onchange="controlAutomation.setLocation(this)">
                                        <option value="">Seçiniz</option>
                                        <option v-for="option in exit_tank_transfer_location_items" v-bind:value="option.DEPARTMENT_LOCATION" v-text="option.LACATION_COMMENT"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang_main no ='245.Ürün'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="hidden" name="stock_id"  id="stock_id" v-model="transferOrderParam.stock_id">
                                    <select name="product_id" id="product_id" v-model="transferOrderParam.product_id" onchange="controlAutomation.setProduct(this)">
                                        <option value="">Seçiniz</option>
                                        <option v-for="option in location_product_items" v-bind:value="option.PRODUCT_ID" v-text="option.PRODUCT_NAME"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang dictionary_id='57635.Miktar'> / <cf_get_lang dictionary_id='57636.Birim'></label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="amount" id="amount" v-model="transferOrderParam.amount" onblur="setAmount(this)" onkeyup="return(FormatCurrency(this,event));">
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="hidden" name="unit_product_id"  id="unit_product_id" v-model="transferOrderParam.unit_product_id">
                                    <input type="text" name="unit_product_name" id="unit_product_name" v-model="transferOrderParam.unit_product_name"> 
                                </div>
                            </div>
                        </form>
                    </div>
                </cf_box_elements>
            </cf_box>
        </template>
        <template v-else-if = "modalParams.mode == 'productionOrder'">
            <form name="productionOrdersForm" id="productionOrdersForm" method="POST">
                <cf_box>
                    <cf_box_elements>
                        <div class="col col-12">
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang_main no ='245.Ürün'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="stock_and_spect"  id="stock_and_spect" v-model="productionOrderParam.stock_and_spect">
                                        <input type="hidden" name="spect_main_id"  id="spect_main_id" v-model="productionOrderParam.spect_main_id">
                                        <input type="hidden" name="spect_main_name"  id="spect_main_name" v-model="productionOrderParam.spect_main_name">
                                        <input type="hidden" name="product_id"  id="product_id" v-model="productionOrderParam.product_id">
                                        <input type="hidden" name="stock_id"  id="stock_id" v-model="productionOrderParam.stock_id">
                                        <input type="text" name="product_name" id="product_name" v-model="productionOrderParam.product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','form','3','200');" style="width:100px;">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=productionOrdersForm[1].stock_id&product_id=productionOrdersForm[1].product_id&field_name=productionOrdersForm[1].product_name&field_unit=productionOrdersForm[1].unit_product_id&field_unit_name=productionOrdersForm[1].unit_product_name&field_amount=productionOrdersForm[1].amount&stock_and_spect=productionOrdersForm[1].stock_and_spect&field_spect_main_id=productionOrdersForm[1].spect_main_id&field_spect_main_name=productionOrdersForm[1].spect_main_name&product_cat_code=TYRURN&product_cat=TYRURN - TAYRAŞ ÜRÜNLER&call_function=controlAutomation.setProductPopup','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 text-left"><cf_get_lang dictionary_id='57635.Miktar'> / <cf_get_lang dictionary_id='57636.Birim'></label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <input type="text" name="amount" id="amount" v-model="productionOrderParam.amount" value="" onblur="setAmount(this)" onkeyup="return(FormatCurrency(this,event));">
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <input type="hidden" name="unit_product_id"  id="unit_product_id" v-model="productionOrderParam.unit_product_id">
                                    <input type="text" name="unit_product_name" id="unit_product_name" v-model="productionOrderParam.unit_product_name" value=""> 
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                </cf_box>
                <cf_box>
                    <cf_grid_list id="sub_products">
                        <thead>
                            <th>No</th>
                            <th>Stok Kodu</th>
                            <th>Ürün</th>
                            <th style="width:50px;">Miktar</th>
                            <th style="width:20px;">Birim</th>
                        </thead>
                        <tbody></tbody>
                    </cf_grid_list>
                </cf_box>
            </form>
        </template>
        <template v-else-if = "modalParams.mode == 'sampleAnalyzes'">
            <template v-if = "sampleListObject.length">
                <template v-for = "(sampleList, sampleListIndex) in sampleListObject" v-bind:key = "sampleListIndex">
                    <cf_box>
                        <cf_grid_list id="sample_analysis_info">
                            <thead>
                                <th>Lab Rapor No</th>
                                <th>Kabul Tankı</th>
                                <th>Numuneyi Alan Kişi</th>
                                <th>Numune Alım Tarihi</th>
                                <th>Numune Kabul Tarihi</th>
                                <th>Numune Adı & Tarifi</th>
                                <th>Numune Alınan Yer</th>
                                <th>Numune Alım Noktası</th>
                                <th>Analiz Talep Eden</th>
                                <th>Analiz Başlangıç Tarihi</th>
                                <th>Analiz Bitiş Tarihi</th>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>{{ sampleList.LAB_REPORT_NO }}</td>
                                    <td>{{ sampleList.DEPARTMENT_HEAD }} - {{ sampleList.COMMENT }}</td>
                                    <td>{{ sampleList.SAMPLE_EMPLOYEE_NAME }} {{ sampleList.SAMPLE_EMPLOYEE_SURNAME }}</td>
                                    <td>{{ sampleList.NUMUNE_DATE }}</td>
                                    <td>{{ sampleList.NUMUNE_ACCEPT_DATE }}</td>
                                    <td>{{ sampleList.NUMUNE_NAME }}</td>
                                    <td>{{ sampleList.NUMUNE_PLACE }}</td>
                                    <td>{{ sampleList.SAMPLING_POINTS_NAME }}</td>
                                    <td>{{ sampleList.EMPLOYEE_NAME }} {{ sampleList.EMPLOYEE_SURNAME }}</td>
                                    <td>{{ sampleList.ANALYSE_DATE }}</td>
                                    <td>{{ sampleList.ANALYSE_DATE_EXIT }}</td>
                                </tr>
                            </tbody>
                        <br>
                            <thead>
                                <th>Parametre Adı</th>
                                <th>Alt Limit</th>
                                <th>Üst Limit</th>
                                <th>Seçenekler</th>
                                <th>Sonuç</th>
                                <th>Test Metodu</th>
                                <th>Birim</th>
                            </thead>
                            <tbody>
                                <template v-if = "sampleList.ANALYSE_ROW.length">
                                    <tr v-for = "(sampleListRow, sampleListRowIndex) in sampleList.ANALYSE_ROW" v-bind:key = "sampleListRowIndex">
                                        <td>{{ sampleListRow.PARAMETER_NAME }}</td>
                                        <td>{{ sampleListRow.MIN_LIMIT }}</td>
                                        <td>{{ sampleListRow.MAX_LIMIT }}</td>
                                        <td>{{ sampleListRow.OPTIONS }}</td>
                                        <td>{{ sampleListRow.RESULT_LIMIT }}</td>
                                        <td>{{ sampleListRow.TEST_METHOD_NAME }}</td>
                                        <td>{{ sampleListRow.UNIT_NAME }}</td>
                                    </tr>
                                </template>
                            </tbody>
                        </cf_grid_list>
                    </cf_box>
                </template>
            </template>
        </template>
    </div>
</div>

<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="/JS/assets/plugins/vue.js"></script>
<script src="/WBP/Recycle/files/js/fabochart.js"></script>
<script>

    //Önemli Not: Swal Alert, tasarımı vue uygulamasından kopararak kendi içinde kopya oluşturur.
    //Bu nedenle modal içerisindeki inputlara vue ile erişilemez ve v-model kullanılamaz.

    function createDepartmentLocation( location ) {
        
        var elm = {
            time: 25,
            animate: true,
            straight: true,
            labelTextColor : "#212121",
            data: new createBlockData( location )
        }
        return elm;

    }

    function createBlockData( data ) {
        let response = {};
        data.forEach(el => {
            response[el.LACATION_COMMENT] = {
                val: el.LOCATION_TOTAL_WASTE,
                color: el.LOCATION_COLOR,
                all: [el.DEPARTMENT_ID, "'" + el.DEPARTMENT_LOCATION + "'", "'" + el.LACATION_COMMENT + "'", "'" + el.DEPARTMENT_HEAD + "'"],
                symbols: [
                    { status: true, class: 'fa fa-thermometer-2', title: 'Isı', text: el.TEMPERATURE + ' C' },
                    { status: true, class: 'fa fa-tachometer', title: 'Basınç', text: el.PRESSURE + ' BAR' },
                    { status: true, class: 'fa fa-flask', title: 'Doluluk Oranı', text: '%' + el.LOCATION_TOTAL_WASTE_RATE }
                ],
                icon: [
                    { status: el.TRANSFER_LOCATION.length ? true: false, class: 'fa fa-share-square-o', title: 'Transfer Emri Oluştur', clickEvent: 'setTransfer' },
                    { status: el.PRODUCTION_ORDER, class: 'fa fa-tag', title: 'Üretim Emri ve Sonucu Oluştur', clickEvent: 'setProductionOrder' },
                    { status: el.TRANSFER_LOCATION.length ? true: false, class: 'fa fa-minus', title: 'Numune Analizleri', clickEvent: 'getSampleAnalyzes' },
                ]
            }; 
        });
        return response;
    }

    function setTransfer( department_id, department_location, location_comment, department_head ) {
        controlAutomation.setTransfer( department_id, department_location, location_comment, department_head );
    }
    function setProductionOrder( department_id, department_location, location_comment, department_head ) {
        controlAutomation.setProductionOrder( department_id, department_location, location_comment, department_head );
    }
    function getSampleAnalyzes( department_id, department_location, location_comment ) {
        controlAutomation.getSampleAnalyzes( department_id, department_location, location_comment );
    }

    var jsonArray = [{
        "no" : "###id###",
        "stockCode" : "<div class='form-group'><input type='hidden' name='is_phantom###id###' id='is_phantom###id###'><input type='hidden' name='is_sevk###id###' id='is_sevk###id###'><input type='hidden' name='is_property###id###' id='is_property###id###'><input type='hidden' name='is_free_amount###id###' id='is_free_amount###id###'><input type='hidden' name='fire_amount###id###' id='fire_amount###id###'><input type='hidden' name='fire_rate###id###' id='fire_rate###id###'><input type='hidden' name='line_number###id###' id='line_number###id###'><input type='hidden' name='related_main_spect_id###id###' id='related_main_spect_id###id###'><input type='hidden' name='spect_main_row_id###id###' id='spect_main_row_id###id###'><input type='hidden' name='spect_main_name###id###' id='spect_main_name###id###'><input type='hidden' name='main_line_number###id###' id='main_line_number###id###'><input type='text' name='stock_code###id###' id='stock_code###id###'></div>",
        "product" : "<div class='form-group'><input type='hidden' name='product_id###id###' id='product_id###id###'><input type='hidden' name='stock_id###id###' id='stock_id###id###'><input type='text' name='product_name###id###' id='product_name###id###'></div>",
        "amount" : "<div class='form-group'><input type='text' name='amount###id###' id='amount###id###' onkeyup='return(FormatCurrency(this,event));'></div>",
        "unit" : "<div class='form-group'><input type='hidden' name='unit_id###id###' id='unit_id###id###'><input type='text' name='unit###id###' id='unit###id###'></div>"
    }];

    var controlAutomation = new Vue({
        el : "#control_automation-app",
        inProgress: false,
        errors: [],
        data : {
            tankListObject: [],
            sampleListObject: [],
            exit_tank_transfer_location_items: [],
            location_product_items: [],
            sub_product_count: 0,
            transferOrderParam: {
                transport_ordering_employee_id: '<cfoutput>#session.ep.userid#</cfoutput>',
                transport_ordering_name: '<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>',
                operator_employee_id: '',
                operator_name: '',
                exit_tank_department_location: '',
                exit_tank_location_comment: '',
                entry_tank_transfer_location_id: '',
                product_id: '',
                stock_id: '',
                product_name: '',
                amount: '',
                unit_product_id: '',
                unit_product_name: '',
                isAjax: 1
            },
            productionOrderParam: {
                product_id: '',
                stock_id: '',
                product_name: '',
                amount: '',
                unit_product_id: '',
                unit_product_name: '',
                stock_and_spect: '',
                spect_main_id: '',
                spect_main_name: '',
                sub_products: '',
                isAjax: 1
            },
            sampleAnalyzesParam: {
                our_company_id: '<cfoutput>#session.ep.company_id#</cfoutput>',
                department_location: '',
                isAjax: 1
            },
            modalParams: { mode: '', title: '' }
        },
        created: function () {

            let vueThis = this;

            var data = new FormData();
            data.append("our_company_id", <cfoutput>#session.ep.company_id#</cfoutput>);
            AjaxControlPostDataJson("WBP/Recycle/files/cfc/recycle_objects.cfc?method=getAutomationModel", data, function(response) {
                if( response.panel != undefined ){
                    vueThis.tankListObject = response.panel;
                    
                    response.panel.forEach((panelElement, panelIndex) => {
                        panelElement.department.forEach((departmentElement, departmentIndex) => {
                            if( departmentElement.block.length > 0){
                                departmentElement.block.forEach((blockElement, blockIndex) => {
                                    setTimeout(function() { $("#chart_" + panelIndex + "_" + departmentIndex + "_" + blockIndex + "").faBoChart(new createDepartmentLocation(blockElement.location)); },100);
                                });
                            }
                        });
                    });
                }
            });
        },
        methods: {
            setTransfer: function( department_id, department_location, location_comment, department_head ) {
                this.transferOrderParam.exit_tank_department_location = department_location;
                this.transferOrderParam.exit_tank_location_comment = department_head + ' : ' + location_comment;

                this.location_product_items = [];
                this.tankListObject.forEach((panelElement, panelIndex) => {
                    panelElement.department.forEach((departmentElement, departmentIndex) => {
                        departmentElement.block.forEach((blockElement, blockIndex) => {
                            blockElement.location.forEach(locationElement => {
                                if( locationElement.DEPARTMENT_LOCATION == department_location ){
                                    this.exit_tank_transfer_location_items = locationElement.TRANSFER_LOCATION;
                                    this.location_product_items = locationElement.LOCATION_PRODUCT;
                                }
                            });
                        });
                    });
                });

                this.modalParams.mode = 'transferOrder';
                this.modalParams.title = 'Transfer Emri Oluştur';
                this.moveModal();
            },
            sendTransfer: function() {
                this.inProgress = true;
                axios
                    .get("/WBP/Recycle/files/cfc/recycle_objects.cfc?method=saveTransportOrders", { params: this.transferOrderParam })
                    .then(response => {
                        if(response.data["status"]) alert("Transfer Emri Başarıyla Oluşturuldu!");
                        else alert("Transfer Emri Oluşturulurken Hata Oluştu!");
                    })
                    .catch(error => {
                        this.errors.push(error);
                    })
                    .finally(() => { 
                        this.inProgress = false;
                    });
            },
            setProductionOrder: function( department_id, department_location, location_comment, department_head ) {
                
                this.location_product_items = [];
                this.tankListObject.forEach((panelElement, panelIndex) => {
                    panelElement.department.forEach((departmentElement, departmentIndex) => {
                        departmentElement.block.forEach((blockElement, blockIndex) => {
                            blockElement.location.forEach(locationElement => {
                                if( locationElement.DEPARTMENT_LOCATION == department_location ) this.location_product_items = locationElement.LOCATION_PRODUCT;
                            });
                        });
                    });
                });
                
                $("#sub_products > tbody").html('');
                this.modalParams.mode = 'productionOrder';
                this.modalParams.title = 'Üretim Emri ve Sonucu Oluştur';
                this.moveModal();
            },
            sendProductionOrder: function() {
                this.inProgress = true;

                let subProducts = [];

                for (let index = 0; index < this.sub_product_count; index++) {
                    
                    subProducts[index] = {
                        is_phantom: eval("document.productionOrdersForm[1].is_phantom"+(index + 1)+"").value,
                        is_sevk: eval("document.productionOrdersForm[1].is_sevk"+(index + 1)+"").value,
                        is_property: eval("document.productionOrdersForm[1].is_property"+(index + 1)+"").value,
                        is_free_amount: eval("document.productionOrdersForm[1].is_free_amount"+(index + 1)+"").value,
                        fire_amount: eval("document.productionOrdersForm[1].fire_amount"+(index + 1)+"").value,
                        fire_rate: eval("document.productionOrdersForm[1].fire_rate"+(index + 1)+"").value,
                        line_number: eval("document.productionOrdersForm[1].line_number"+(index + 1)+"").value,
                        related_main_spect_id: eval("document.productionOrdersForm[1].related_main_spect_id"+(index + 1)+"").value,
                        spect_main_row_id: eval("document.productionOrdersForm[1].spect_main_row_id"+(index + 1)+"").value,
                        spect_main_name: eval("document.productionOrdersForm[1].spect_main_name"+(index + 1)+"").value,
                        main_line_number: eval("document.productionOrdersForm[1].main_line_number"+(index + 1)+"").value,
                        stock_code: eval("document.productionOrdersForm[1].stock_code"+(index + 1)+"").value,
                        //Product
                        product_id: eval("document.productionOrdersForm[1].product_id"+(index + 1)+"").value,
                        stock_id: eval("document.productionOrdersForm[1].stock_id"+(index + 1)+"").value,
                        product_name: eval("document.productionOrdersForm[1].product_name"+(index + 1)+"").value,
                        //Amount
                        amount: eval("document.productionOrdersForm[1].amount"+(index + 1)+"").value,
                        //Unit
                        unit_id: eval("document.productionOrdersForm[1].unit_id"+(index + 1)+"").value,
                        unit: eval("document.productionOrdersForm[1].unit"+(index + 1)+"").value
                    }

                }

                this.productionOrderParam.sub_products = JSON.stringify( subProducts );

                axios
                    .get("/WBP/Recycle/files/cfc/recycle_objects.cfc?method=saveProductionOrders", { params: this.productionOrderParam })
                    .then(response => {
                        if(response.data["status"]) alert("Üretim Emri ve Sonucu Başarıyla Oluşturuldu!");
                        else alert("Üretim Emri ve Sonucu Oluşturulurken Hata Oluştu!");
                    })
                    .catch(error => {
                        this.errors.push(error);
                    })
                    .finally(() => { 
                        this.inProgress = false;
                    });
            },
            getSampleAnalyzes: function( department_id, department_location, location_comment, department_head ) {
                this.sampleAnalyzesParam.department_location = department_location;

                axios
                    .get("/WBP/Recycle/files/cfc/recycle_objects.cfc?method=getSampleAnalyzes", { params: this.sampleAnalyzesParam })
                    .then(response => { 
                        this.sampleListObject = response.data;
                        console.log(this.sampleListObject);
                        this.modalParams.mode = 'sampleAnalyzes';
                        this.modalParams.title = 'Numune Analizleri';
                        this.moveModal();
                    })
                    .catch(error => { this.errors.push(error); });
            },
            moveModal: function() {
                setTimeout(() => {
                    Swal.fire({
                        title: this.modalParams.title,
                        html: $("#automation_info").clone().show().html(),
                        showCancelButton: true,
                        confirmButtonColor: '#1fbb39',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: '<cf_get_lang dictionary_id='57461.Kaydet'>',
                        cancelButtonText: '<cf_get_lang dictionary_id='51468.İptal Et'>',
                        closeOnConfirm: false,
                        allowOutsideClick:false
                    }).then((result) => {
                        if (result.value) {
                            if( this.modalParams.mode == 'transferOrder' ) this.sendTransfer();
                            else if( this.modalParams.mode == 'productionOrder' ) this.sendProductionOrder();
                        }
                    })
                }, 1);
            },
            setPosition: function() {
                this.transferOrderParam.transport_ordering_employee_id = document.transportOrdersForm[1].transport_ordering_employee_id.value;
                this.transferOrderParam.transport_ordering_name = document.transportOrdersForm[1].transport_ordering_name.value;
            },
            setLocation: function(element) {
                if( element.value != '' ) this.transferOrderParam.entry_tank_transfer_location_id = element.value;
            },
            setProduct: function (element) {
                var product_id = element.value;
                if( product_id != '' ){
                    if( this.location_product_items.length > 0 ){
                        this.location_product_items.forEach(product => {
                            if( product.PRODUCT_ID == product_id ){
                                if( this.modalParams.mode == 'transferOrder' ){
                                    this.transferOrderParam.product_id = product.PRODUCT_ID;
                                    this.transferOrderParam.product_name = product.PRODUCT_NAME;
                                    this.transferOrderParam.stock_id = document.transportOrdersForm[1].stock_id.value = product.STOCK_ID;
                                    this.transferOrderParam.amount = document.transportOrdersForm[1].amount.value = product.AMOUNT;
                                    this.transferOrderParam.unit_product_id = document.transportOrdersForm[1].unit_product_id.value = product.PRODUCT_UNIT_ID;
                                    this.transferOrderParam.unit_product_name = document.transportOrdersForm[1].unit_product_name.value = product.PRODUCT_UNIT_NAME;
                                }
                            }
                        });
                    }
                }
            },
            setProductPopup: function () {
                if( this.modalParams.mode == 'productionOrder' ){

                    this.productionOrderParam.product_id = document.productionOrdersForm[1].product_id.value;
                    this.productionOrderParam.product_name = document.productionOrdersForm[1].product_name.value;
                    this.productionOrderParam.stock_id = document.productionOrdersForm[1].stock_id.value;
                    this.productionOrderParam.amount = document.productionOrdersForm[1].amount.value;
                    this.productionOrderParam.unit_product_id = document.productionOrdersForm[1].unit_product_id.value;
                    this.productionOrderParam.unit_product_name = document.productionOrdersForm[1].unit_product_name.value;
                    this.productionOrderParam.stock_and_spect = document.productionOrdersForm[1].stock_and_spect.value;
                    this.productionOrderParam.spect_main_id = document.productionOrdersForm[1].spect_main_id.value;
                    this.productionOrderParam.spect_main_name = document.productionOrdersForm[1].spect_main_name.value;

                    axios
                    .get("/WBP/Recycle/files/cfc/recycle_objects.cfc?method=get_sub_product", { params: { stock_id: this.productionOrderParam.stock_id } })
                    .then(response => {

                        this.sub_product_count = response.data.length;

                        if( response.data.length > 0 ){
                            response.data.forEach((element, index) => {
                                jsonArray.filter((a) => {
                                    var template="<tr id='frm_row"+ (index + 1) +"'><td>{no}</td><td>{stockCode}</td><td>{product}</td><td>{amount}</td><td>{unit}</td></tr>";
                                    $("#sub_products > tbody").append(nano( template, a ).replace(/###id###/g,index + 1));
                                });
                                //Stock Code
                                eval("document.productionOrdersForm[1].is_phantom"+(index + 1)+"").value = element.IS_PHANTOM;
                                eval("document.productionOrdersForm[1].is_sevk"+(index + 1)+"").value = element.IS_SEVK;
                                eval("document.productionOrdersForm[1].is_property"+(index + 1)+"").value = element.IS_PROPERTY;
                                eval("document.productionOrdersForm[1].is_free_amount"+(index + 1)+"").value = element.IS_FREE_AMOUNT;
                                eval("document.productionOrdersForm[1].fire_amount"+(index + 1)+"").value = element.FIRE_AMOUNT;
                                eval("document.productionOrdersForm[1].fire_rate"+(index + 1)+"").value = element.FIRE_RATE;
                                eval("document.productionOrdersForm[1].line_number"+(index + 1)+"").value = element.LINE_NUMBER;
                                eval("document.productionOrdersForm[1].related_main_spect_id"+(index + 1)+"").value = element.RELATED_MAIN_SPECT_ID;
                                eval("document.productionOrdersForm[1].spect_main_row_id"+(index + 1)+"").value = element.SPECT_MAIN_ROW_ID;
                                eval("document.productionOrdersForm[1].spect_main_name"+(index + 1)+"").value = element.SPECT_MAIN_NAME;
                                eval("document.productionOrdersForm[1].main_line_number"+(index + 1)+"").value = element.MAIN_LINE_NUMBER;
                                eval("document.productionOrdersForm[1].stock_code"+(index + 1)+"").value = element.STOCK_CODE;
                                //Product
                                eval("document.productionOrdersForm[1].product_id"+(index + 1)+"").value = element.PRODUCT_ID;
                                eval("document.productionOrdersForm[1].stock_id"+(index + 1)+"").value = element.STOCK_ID;
                                eval("document.productionOrdersForm[1].product_name"+(index + 1)+"").value = element.PRODUCT_NAME;
                                //Amount
                                eval("document.productionOrdersForm[1].amount"+(index + 1)+"").value = element.AMOUNT;
                                //Unit
                                eval("document.productionOrdersForm[1].unit_id"+(index + 1)+"").value = element.PRODUCT_UNIT_ID;
                                eval("document.productionOrdersForm[1].unit"+(index + 1)+"").value = element.MAIN_UNIT;
                            });
                        }
                     })
                    .catch(error => { this.errors.push(error); });

                }
            },
            setOperatorPosition: function() {
                this.transferOrderParam.operator_employee_id = document.transportOrdersForm[1].operator_employee_id.value;
                this.transferOrderParam.operator_name = document.transportOrdersForm[1].operator_name.value;
            }
        }
    });

    function setAmount(element) {
        if( element.value != '' ) controlAutomation.transferOrderParam.amount = controlAutomation.productionOrderParam.amount = element.value;
    }

    function kontrol() {
        unformat_fields();
        return true;
    }
    function unformat_fields()
    {
        if(document.transportOrdersForm[1].amount.value != "") document.transportOrdersForm[1].amount.value = filterNum(document.transportOrdersForm[1].amount.value);
    }

</script>