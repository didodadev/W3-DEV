<cfparam name="attributes.opp_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.st_id" default="">
<cfparam name="attributes.purchasing_id" default="">

<cfset auth_kumasdepo = 62>
<cfset auth_cekme = 9>
<cfset auth_modelhane = 7>
<cfset auth_all = 1>

<cfset MODULE_NAME = ""><!--- for test --->

<style>
input, select{
border:none;
display: inline-block;
}
</style>

<cfobject name="fabric" component="WBP.Fashion.files.cfc.fabric">
<cfset lof_fabric = fabric.list_fabric(project_id: attributes.project_id, stretching_test_id: attributes.st_id,purchasing_id:attributes.purchasing_id)>
<div id="appStrech">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="5" sort="true">
                        <div class="form-group" id="item-product_id">
                            <div class="col col-6 col-xs-12">
                                <div class="row">
                                    <div class="col col-6 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="stock_id" id="stock_id">
                                            <input type="hidden" name="product_id" id="product_id">
                                            <input type="text" name="product_name" id="product_name" placeholder="Ürün Seçiniz!">
                                            <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('index.cfm?fuseaction=objects.popup_product_names&amp;stock_and_spect=0&amp;field_id=stretching_test.stock_id&amp;product_id=stretching_test.product_id&amp;field_name=stretching_test.product_name&amp;keyword='+encodeURIComponent(document.stretching_test.product_name.value),'list');"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-xs-12">
                                        <input type="text" name="topno" id="topno" data-bind="event: { keypress: addTopno }" placeholder="Top No Seçiniz!">
                                    </div>
                                </div>
                            </div>
                            <div class="col col-2 col-xs-12">
                                <button type="button" class="btn green-haze" data-bind="click: addTopnoRow">Ekle</button>
                            </div>
                            <div class="col col-2 col-xs-12">
                                <button type="button" class="btn green-haze" onclick="document.location.href='/index.cfm?fuseaction=textile.stretching_test&event=sarf&st_id=<cfoutput>#attributes.st_id#</cfoutput>'">Sarf Kaydet</button>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
    <style>
        .form_list tbody tr td, .form_list tbody tr:hover td {
            background-color: transparent !important;
        }
    </style>

<cf_grid_list>
        <thead>
            <tr>
                <th style="text-align: center; border-bottom: 1px solid #aaa">&nbsp;</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa" colspan="3" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>">Kumaş Depo</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa">&nbsp;</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa" colspan="3" data-auth="<cfoutput>#auth_cekme#</cfoutput>">Çekme Testi Departmanı</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa">Renk Lotu</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa" data-auth="<cfoutput>#auth_modelhane#</cfoutput>">Modelhane Sorumlusu</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa" colspan="2">Herkes</th>
                <th style="text-align: center; border-bottom: 1px solid #aaa">&nbsp;</th>
            </tr>
            <tr>
                <th style="text-align: center;">S.No</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>">Ürün/Top No</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>">Kumaş Top Metrajı</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>">Test Metrajı</th>
                <th style="text-align: center;">Kumaş En</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_cekme#</cfoutput>">Boy Cekme</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_cekme#</cfoutput>">En Cekme</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_cekme#</cfoutput>">Egalize</th>
                <th style="text-align: center;">Renk Lotu</th>
                <th style="text-align: center;" data-auth="<cfoutput>#auth_modelhane#</cfoutput>">Renk</th>
                <th style="text-align: center;">Açıklama 1</th>
                <th style="text-align: center;">Açıklama 2</th>
                <th style="text-align: center;">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            <input type="hidden" name="row_count" data-bind="value: cekmelist().length">
            <!-- ko foreach: self.cekmelist -->
            <tr data-bind="colorline: color">
                <td style="text-align: right;">
                    <span data-bind="text: $index()+1">
                </td>
                <td style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>"><input type="hidden" data-bind="attr: { name: 'rollnr' + $index() }, value: rollnr"><input type="hidden" data-bind="attr: { name: 'product_id' + $index() }, value: product_id"><span data-bind="text: rollnr()"></span></td>
                <td style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>"><input type="hidden" data-bind="attr: { name: 'metering' + $index() }, value: metering"><span data-bind="text: metering"></span></td>
                <td data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>"><input type="number" style="text-align: center;" data-bind="value: test_metering, attr: { name: 'test_metering' + $index(), id: 'test_metering' + $index() }" style="width: 100%;" data-rule="numeric"></td>
                <td><input type="number" style="text-align: center;" data-bind="value: fabric_width, attr: { name: 'fabric_width' + $index(), id: 'fabric_width' + $index() }" style="width: 100%;" data-rule="numeric"></td>
                <td data-auth="<cfoutput>#auth_cekme#</cfoutput>"><input type="number" style="text-align: center;" data-bind="value: height_shrinkage, attr: { name: 'height_shrinkage' + $index(), id: 'height_shrinkage' + $index() }" style="width: 100%;" data-rule="numeric"></td>
                <td data-auth="<cfoutput>#auth_cekme#</cfoutput>"><input type="number" style="text-align: center;" data-bind="value: width_shrinkage, attr: { name: 'width_shrinkage' + $index(), id: 'width_shrinkage' + $index() }" style="width: 100%;" data-rule="numeric"></td>
                <td data-auth="<cfoutput>#auth_cekme#</cfoutput>"><input type="number" style="text-align: center;" data-bind="value: smooth, attr: { name: 'smooth' + $index(), id: 'smooth' + $index() }" style="width: 100%;" data-rule="numeric"></td>
                <td>
                    <select data-bind="value: colorlot, attr: { name: 'colorlot' + $index(), id: 'colorlot' + $index() }" style="width: 100%;">
                        <option value="">Seçiniz</option>
                        <option>A</option>
                        <option>B</option>
                        <option>C</option>
                        <option>D</option>
                        <option>E</option>
                        <option>F</option>
                        <option>G</option>
                        <option>H</option>
                        <option>I</option>
                        <option>J</option>
                        <option>K</option>
                        <option>L</option>
                    </select>
                </td>
                <td data-auth="<cfoutput>#auth_modelhane#</cfoutput>">
                    <select data-bind="value: color, attr: { name: 'color' + $index(), id: 'color' + $index() }, event: { change: function() { self.colorChanged(); } }" style="width: 100%;" data-rule="">
                        <option value="">SECINIZ</option>
                        <option>SARI</option>
                        <option>KIRMIZI</option>
                        <option>MAVI</option>
                        <option>MOR</option>
                        <option>TURUNCU</option>
                        <option>YESIL</option>
                    </select>
                </td>
                <td><input type="text" style="text-align: center;" data-bind="value: descone, attr: { name: 'descone' + $index(), id: 'descone' + $index() }"></td>
                <td><input type="text" style="text-align: center;" data-bind="value: desctwo, attr: { name: 'desctwo' + $index(), id: 'desctwo' + $index() }"></td>
                <td style="text-align: center;"><i class="fa fa-minus" data-bind="click: function() { $root.removeRow( $data ); }"></i></td>
            </tr>
            <!-- /ko -->
        </tbody>
        <tfoot>
            <tr>
                <td colspan="2">Kumaş Metraj Toplamı</td>
                <td style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>"><span data-bind="text: $root.sumOfMetering().toFixed(2)"></span></td>
                <td style="text-align: center;" data-auth="<cfoutput>#auth_kumasdepo#</cfoutput>"><span data-bind="text: $root.sumOfTestMetering().toFixed(2)"></span></td>
                <td colspan="9"><cf_workcube_buttons is_upd='0' type_format="1" add_function="list_stretching_fabric_kontrol()"></td>
            </tr>
        </tfoot>
</cf_grid_list>
    <div class="row">        
        <div class="col col-4 uniqueRow">
            <div class="row formContent">
                <cf_grid_list>
                    <thead>
                        <tr>
                            <th width="150" style="text-align: center;">Çekme Rengi Lotu</th>
							<th width="100" style="text-align: center;">Boy</th>
                            <th width="100" style="text-align: center;">En</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: self.colorlots">
                        <tr data-bind="colorline: $data">
                            <td><input type="hidden" name="colorgroup" data-bind="value: $data"><span data-bind="text: $data"></span></td>
							<td><input type="text" data-bind="attr: { name: 'colorheight_' + $data, id: 'colorheight_' + $data }"></td>
                            <td><input type="text" data-bind="attr: { name: 'colorwidth_'  + $data, id: 'colorwidth_'  + $data }"></td>
                        </tr>
                    </tbody>
                </cf_grid_list>
            </div>
        </div>
    </div>

</div>
<script type="text/javascript" src="/WBP/Fashion/files/js/knockout.js"></script>
<script type="text/javascript">

    function arr_unique(arr) {
        return arr.filter(function (value, index, self) { 
            return self.indexOf(value) === index;
        });
    }

    function arr_diff(arr, a) {
        return arr.filter(function(i) {return a.indexOf(i) < 0;});
    }
 
    ko.bindingHandlers.colorline = {
        update: function( element, valueAccessor, allBindings, viewModel, bindingContext ) {
            var value = ko.unwrap( valueAccessor() );
            switch (value) {
                case 'SARI':
                    element.style.backgroundColor = 'yellow';
                    break;
                case 'KIRMIZI':
                    element.style.backgroundColor = '#FFB5C5';
                    break;
                case 'MAVI':
                    element.style.backgroundColor = '#C6E2FF';
                    break;
                case 'MOR':
                    element.style.backgroundColor = '#DDA0DD';
                    break;
                case 'TURUNCU':
                    element.style.backgroundColor = '#FFA07A';
                    break;
                case 'YESIL':
                    element.style.backgroundColor = '#C1FFC1';
                    break;
                default:
                    element.style.backgroundColor = 'initial';
                    break;
            }
        }
    };

    var appStrech = function () {
        var self = this;
        
        self.cekmelist = ko.observableArray([]);
        self.kumastops = ko.observableArray([]);
        self.colorlots = ko.observableArray([]);

        self.createItem = function( element ) {
            return {
                product_id: ko.observable( element == null ? '' : element.product_id ),
                rollnr: ko.observable( element == null ? '' : element.rollnr ),
                metering: ko.observable( element == null ? '0' : element.metering ),
                test_metering: ko.observable( element == null ? '0' : element.test_metering ),
                fabric_width: ko.observable( element == null ? '0' : element.fabric_width ),
                height_shrinkage: ko.observable( element == null ? '0' : element.height_shrinkage ),
                width_shrinkage: ko.observable( element == null ? '0' : element.width_shrinkage ),
                smooth: ko.observable( element == null ? '0' : element.smooth ),
                colorlot: ko.observable( element == null ? '' : element.colorlot ),
                color: ko.observable( element == null ? '' : element.color ),
                descone: ko.observable( element == null ? '' : element.descone ),
                desctwo: ko.observable( element == null ? '' : element.desctwo )
            };
        }

        self.addRow = function () {
            self.cekmelist.push( self.createItem(null) );
        }

        self.removeRow = function( row ) {
            if ( confirm( 'Bu satiri silmek istediginizden emin misiniz?' ) ) {
                self.cekmelist.remove(row);
                self.colorChanged();
            }
        }

        self.sumOfMetering = ko.computed(function () {
            return cekmelist().reduce(function( acc, val ) {
                if ( val.metering() !== '' && !isNaN( val.metering().toString().replace(',', '.') ) ) {
                    acc += parseFloat( val.metering().toString().replace(',', '.') );
                }
                return acc;
            }, 0);
        });

        self.sumOfTestMetering = ko.computed(function () {
            return cekmelist().reduce(function ( acc, val ) {
                if ( val.test_metering() !== '' && !isNaN( val.test_metering().toString().replace(',', '.') ) ) {
                    acc += parseFloat( val.test_metering().toString().replace(',', '.') );
                }
                return acc;
            }, 0);
        });

        self.colorChanged = function () {
            var uniqcolors = arr_unique( cekmelist().map( function (elm) {
                return elm.color();
            }))
            .filter(function( elm ) {
                return elm != "";
            })
            ;
            self.colorlots.push( ... arr_diff( uniqcolors, self.colorlots() ) );
            oldcolors = arr_diff( self.colorlots(), uniqcolors );
            self.colorlots.remove(function( elm ) {
                return oldcolors.indexOf( elm ) >= 0;
            });
        };

        self.addTopno = function (data, event) {
            if ( event.keyCode == 13 ) {
                event.preventDefault();
                self.addTopnoRow();
            }
            return true;
        };

        self.addTopnoRow = function () {
            var product_id = document.getElementById("product_id").value;
            var lot = document.getElementById("topno").value;
            if (lot == "") {
                alert("Lütfen top numarası giriniz!");
                return;
            }
            $.ajax({
                url: location.href,
                method: 'post',
                data: { product_id: product_id, lot: lot, viewmode: "lotfind", isajax: "1" }
            }).done(function( response ) {
                var jresponse = JSON.parse(response);
                var result = parseInt( jresponse.count );
                if (result > 1) {
                    alert("Girdiğiniz kod ile ilgili birden fazla ürün kaydı bulundu. Lütfen bir ürün seçin!");
                } else if ( result < 1 ) {
                    alert("Girdiğiniz kod kayıtlarda bulunamadı!");
                } else if (jresponse.product_id == "-1" || jresponse.product_id == undefined || jresponse.product_id == null || jresponse.product_id == '') {
                    alert("Girdiğiniz kod numarasına ait top kaydı bulunamadı!");
                } else {
                    var row = {
                        product_id: jresponse.product_id,
                        rollnr: lot,
                        metering: jresponse.envanter,
                        test_metering: '0',
                        fabric_width: '0',
                        height_shrinkage: '0',
                        width_shrinkage: '0',
                        smooth: '0',
                        colorlot: '',
                        color: '',
                        descone: '',
                        desctwo: ''
                    };
                    self.cekmelist.push( self.createItem(row) );
                    document.getElementById("topno").value = "";
                }
            });
        };

        self.initialize = function () {
            <cfif isDefined("query_stretching_test_rows")>
                <cfoutput query="query_stretching_test_rows">
                    var current_row = {
                        product_id: "#PRODUCT_ID#",
                        rollnr: "#ROLL_ID#",
                        metering: "#len(ROLL_METER)?ROLL_METER:0#",
                        test_metering: "#len(ROLL_TEST_METER)?ROLL_TEST_METER:0#",
                        fabric_width: "#len(FABRIC_WIDTH)?FABRIC_WIDTH:0#",
                        height_shrinkage: "#len(HEIGHT_SHRINKAGE)?HEIGHT_SHRINKAGE:0#",
                        width_shrinkage: "#len(WIDTH_SHRINKAGE)?WIDTH_SHRINKAGE:0#",
                        smooth: "#len(SMOOTH)?SMOOTH:0#",
                        colorlot: "#COLOR_LOT#",
                        color: "#COLOR_NAME#",
                        descone: "#DESC_ONE#",
                        desctwo: "#DESC_TWO#"
                    };
                    self.cekmelist.push(self.createItem(current_row));
                </cfoutput>
                self.colorChanged();
                <cfoutput query="query_stretching_test_groups">
                    if (document.getElementById("colorwidth_#GROUP_NAME#") !== undefined) {
                        document.getElementById("colorwidth_#GROUP_NAME#").value = '#WIDTH#';
                        document.getElementById("colorheight_#GROUP_NAME#").value = '#HEIGHT#';
                    }
                </cfoutput>
            </cfif>
        }

        return {
            init:  function() {
                ko.applyBindings( self, document.getElementById('appStrech') );
                self.initialize();
            }
        }

    }();

    appStrech.init();

</script>
<script type="text/javascript">

    function list_stretching_fabric_kontrol() {
        var list_stretching_fabric_numerics = document.querySelectorAll('#list_stretching_fabric [data-rule*="numeric"]');
        list_stretching_fabric_numerics.forEach(element => {
            if ( isNaN( element.value.toString().replace(',', '.') ) ) {
                var idx = [].slice.call(element.closest("tr").children).indexOf(element.parentElement);
                var elms = document.querySelector('#list_stretching_fabric thead tr').children;
                alert(elms[idx].innerText + " sayısal değer içermelidir!");
                element.focus();
                return false;
            }
        });
        list_stretching_fabric_requireds = document.querySelectorAll('#list_stretching_fabric [data-rule*="required"]');
        list_stretching_fabric_requireds.forEach(element => {
            if ( element.value == "" ) {
                var idx = [].slice.call(element.closest("tr").children).indexOf(element.parentElement);
                var elms = document.querySelector('#list_stretching_fabric thead tr').children;
                alert(elms[idx].innerText + " boş olamaz!");
                element.focus;
                return false;
            }
        });
        return true;
    }
    <cfquery name="query_auth" datasource="#dsn#">
            SELECT DEPARTMENT_ID
            FROM EMPLOYEE_POSITIONS
            WHERE EMPLOYEE_ID = #session.ep.userid#
    </cfquery>
    <cfset auths = valueList( query_auth.DEPARTMENT_ID )>
    <cfset allauths = [ auth_cekme, auth_kumasdepo, auth_modelhane ]>
    <cfloop list="#auths#" item="a">
        <cfif a eq auth_all>
            <cfset allauths = []>
        <cfelse>
            <cfset arrayDelete( allauths, a )>
            <cfset arrayDelete( allauths, a )>
            <cfset arrayDelete( allauths, a )>
        </cfif>
    </cfloop>
    <cfloop array="#allauths#" item="al">
    $("[data-auth='<cfoutput>#al#</cfoutput>']").hide();
    </cfloop>
    
</script>
