<cfparam name="attributes.cutactual_id" default="">
<cfparam name="attributes.marker_name" default="">
<cfparam name="attributes.viewmode" default="">

<cfif attributes.viewmode eq "lotfind">
    <cfobject name="product_lots" component="WBP.Fashion.files.cfc.product_lots">
    <cfset GetPageContext().getCFOutput().clear()>
    <cfset result = product_lots.GetStretchRoll(attributes.product_id, attributes.lot, attributes.st_id)>
    [
        <cfoutput query="result">{ 
        "product_id": "#PRODUCT_ID#",
        "lot_no": "#LOT_NO#",
        "color_lot": "#COLOR_LOT#",
        "envanter": "#ENVANTER#"
     },</cfoutput>
     {}]
    <cfabort>
</cfif>

<cfobject name="cutstretch" component="WBP.Fashion.files.cfc.cutstretch">
<cfset query_cutstretch = cutstretch.get_cutstretch( attributes.cutactual_id, attributes.marker_name )>
<cfset query_cutstretch_row = cutstretch.get_cutstretch_row( iif( query_cutstretch.recordcount, "query_cutstretch.cutstretch_id", "0" ) )>
<div style="margin-top: 20px;"></div>
<cfset pageHead = "Serim Formu">
<cf_catalystHeader>
    <div style="clear: both"></div>
    <cf_box>
<cfform name="stretch_form" method="post">
    <input type="hidden" name="cutstretch_id" value="<cfoutput>#iif(query_cutstretch.recordcount, "query_cutstretch.CUTSTRETCH_ID", de(""))#</cfoutput>">
    <input type="hidden" name="project_id" value="<cfoutput>#iif(query_cutstretch.recordcount, "query_cutstretch.PROJECT_ID", "attributes.project_id")#</cfoutput>">
    <input type="hidden" name="cutactual_id" value="<cfoutput>#iif(query_cutstretch.recordcount, "query_cutstretch.CUTACTUAL_ID", "attributes.cutactual_id")#</cfoutput>">
    <input type="hidden" name="marker_height" value="<cfoutput>#iif(query_cutstretch.recordcount, "query_cutstretch.MARKER_HEIGHT", "attributes.marker_height")#</cfoutput>">
    <input type="hidden" name="st_id" value="<cfoutput>#iif( query_cutstretch.recordcount, "query_cutstretch.STRETCHING_TEST_ID", "attributes.st_id" )#</cfoutput>">
    <input type="hidden" name="rowcount" data-bind="value: rolllist().length">
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12">Kesim Adı</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="marker_name" id="marker_name" value="<cfoutput>#iif(query_cutstretch.recordcount, "query_cutstretch.MARKER_NAME", "attributes.marker_name")#</cfoutput>" readonly>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12">Proje</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="project_head" id="project_head" value="<cfoutput>#iif(query_cutstretch.recordcount, "query_cutstretch.PROJECT_HEAD", "attributes.project_head")#</cfoutput>" readonly>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="item-product_id">
                        <label class="col col-4 col-xs-12">Ürün:</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="stock_id" id="stock_id">
                                <input type="hidden" name="product_id" id="product_id">
                                <input type="text" name="product_name" id="product_name" placeholder="Ürün Seçiniz!">
                                <span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="windowopen('index.cfm?fuseaction=objects.popup_product_names&amp;stock_and_spect=0&amp;field_id=stretch_form.stock_id&amp;product_id=stretch_form.product_id&amp;field_name=stretch_form.product_name&amp;keyword='+encodeURIComponent(document.stretch_form.product_name.value),'list');"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="item-topno">
                        <label class="col col-4 col-xs-12">Top No:</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="topno" id="topno" data-bind="event: { keypress: addTopno }" placeholder="Top No Seçiniz!">
                        </div>
                    </div>
                </div>
                <div class="col col-12" type="column" index="5">
                    <div class="form-group" id="item-">
                        <div class="col col-12" style="text-align: right;">
                            <button type="button" class="btn green-haze" data-bind="click: addTopnoRow">Ekle</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="height: 345px; overflow: scroll; width: 100%;">
    <table class="form_list" style="width: 100%;">
        <thead>
            <tr>
                <th>Top No</th>
                <th>Renk Lotu</th>
                <th>Pastal</th>
                <th colspan="2">Serim Sayısı</th>
                <th>Boy Vermeyen Dökülan Mr</th>
                <th>Defolu Metraj</th>
                <th>Ek Metraj</th>
                <th>Tasnif Metrajı</th>
                <th>Top Eksiği</th>
                <th>Toplam</th>
                <th>İrsaliye Metraj</th>
                <th>Serim Metraj</th>
                <th>Fark</th>
                <th style="width: 16px;">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            <!-- ko foreach: rolllist -->
            <tr>
                <td><input type="text" style="width: 100%;text-align: center" data-bind="value: rollno, attr: { name: 'rollno_' + $index() }"></td>
                <td><input type="text" style="width: 100%;text-align: center" data-bind="value: color, attr: { name: 'color_' + $index() }" readonly></td>
                <td><input type="text" style="width: 100%;text-align: center" data-bind="value: marker, attr: { name: 'marker_' + $index() }" readonly></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: stretch_amount1, attr: { name: 'stretch_amount1_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: stretch_amount2, attr: { name: 'stretch_amount2_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: undemand_spill_meter, attr: { name: 'undemand_spill_meter_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: flaw_meter, attr: { name: 'flaw_meter_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: additional_meter, attr: { name: 'additional_meter_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: classification_meter, attr: { name: 'classification_meter_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: missing_roll, attr: { name: 'missing_roll_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: total, attr: { name: 'total_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: waybill_meter, attr: { name: 'waybill_meter_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: stretch_meter, attr: { name: 'stretch_meter_' + $index() }"></td>
                <td><input type="number" style="width: 100%;text-align: center" data-bind="value: diff, attr: { name: 'diff_' + $index() }"></td>
                <td style="text-align: center;"><i class="fa fa-minus" data-bind="click: function() { self.deleteRow($data); }"></i></td>
            </tr>
            <!-- /ko -->
            <tr>
                <td colspan="4" style="text-align: right">Toplam:</td>
                <td style="text-align: center"><span data-bind="text: sumOf_stretch_amount2().toFixed()"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_undemand_spill_meter().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_flaw_meter().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_additional_meter().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_classification_meter().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_missing_roll().toFixed()"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_total().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_waybill_meter().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_stretch_meter().toFixed(2)"></span></td>
                <td style="text-align: center"><span data-bind="text: sumOf_diff().toFixed(2)"></span></td>
                <td>&nbsp;</td>
            </tr>
        </tbody>
    </table>
    </div>
    <div style="clear: both; margin-top: 10px;"></div>
    <div style="text-align: right">
        <cf_workcube_buttons is_upd='0' type_format="1">
    </div>
</cfform>
</cf_box>
<script type="text/javascript" src="/WBP/Fashion/files/js/knockout.js"></script>
<script type="text/javascript">
    cutstretchApp = function () {
        var self = this;
        
        self.rolllist = ko.observableArray([]);

        self.createRoll = function( item ) {
            var data = {
                rollno: ko.observable( item == null ? '' : item.rollno ),
                color: ko.observable( item == null ? '' : item.color ),
                marker: ko.observable( item == null ? '' : item.marker ),
                stretch_amount1: ko.observable( item == null ? '' : item.stretch_amount1 ),
                stretch_amount2: ko.observable( item == null ? '' : item.stretch_amount2 ),
                undemand_spill_meter: ko.observable( item == null ? '' : item.undemand_spill_meter ),
                flaw_meter: ko.observable( item == null ? '' : item.flaw_meter ),
                additional_meter: ko.observable( item == null ? '' : item.additional_meter ),
                classification_meter: ko.observable( item == null ? '' : item.classification_meter ),
                missing_roll: ko.observable( item == null ? '' : item.missing_roll ),
                waybill_meter: ko.observable( item == null ? '' : item.waybill_meter ),
                stretch_factor: ko.observable( item == null ? '' : item.stretch_factor )
            };
            data.total = ko.computed(function () {
                var tots = 0;
                if (data.undemand_spill_meter() != '' && !isNaN( data.undemand_spill_meter() )) tots += parseFloat( data.undemand_spill_meter() );
                if (data.flaw_meter() != '' && !isNaN( data.flaw_meter() )) tots += parseFloat( data.flaw_meter() );
                if (data.additional_meter() != '' && !isNaN( data.additional_meter() )) tots += parseFloat( data.additional_meter() );
                if (data.classification_meter() != '' && !isNaN( data.classification_meter() )) tots += parseFloat( data.classification_meter() );
                return tots;
            });
            data.stretch_meter = ko.computed(function() {
                var tots = 0;
                if ( data.stretch_amount1() != '' && !isNaN( data.stretch_amount1() ) && data.stretch_amount2() != '' && !isNaN( data.stretch_amount2() ) && data.stretch_factor() != '' && !isNaN( data.stretch_factor() ) ) {
                    tots = ( parseInt( data.stretch_amount2() ) - parseInt( data.stretch_amount1() ) + 1 ) * parseFloat( data.stretch_factor() );
                }
                return tots;
            });
            data.diff = ko.computed( function() {
                if ( data.waybill_meter() != '' && !isNaN( data.waybill_meter() ) ) {
                    return parseFloat( data.waybill_meter() ) - data.stretch_meter();
                } else {
                    return 0;
                }
            });
            return data;
        }

        self.sumOf_stretch_amount2 = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.stretch_amount2() != '' && !isNaN( val.stretch_amount2() ) ) {
                    acc += parseInt( val.stretch_amount2() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_undemand_spill_meter = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.undemand_spill_meter() != '' && !isNaN( val.undemand_spill_meter() ) ) {
                    acc += parseFloat( val.undemand_spill_meter() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_flaw_meter = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.flaw_meter() != '' && !isNaN( val.flaw_meter() ) ) {
                    acc += parseFloat( val.flaw_meter() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_additional_meter = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.additional_meter() != '' && !isNaN( val.additional_meter() ) ) {
                    acc += parseFloat( val.additional_meter() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_classification_meter = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.classification_meter() != '' && !isNaN( val.classification_meter() ) ) {
                    acc += parseFloat( val.classification_meter() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_total = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.total() != '' && !isNaN( val.total() ) ) {
                    acc += parseInt( val.total() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_missing_roll = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.missing_roll() != '' && !isNaN( val.missing_roll() ) ) {
                    acc += parseInt( val.missing_roll() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_waybill_meter = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.waybill_meter() != '' && !isNaN( val.waybill_meter() ) ) {
                    acc += parseFloat( val.waybill_meter() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_stretch_meter = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.stretch_meter() != '' && !isNaN( val.stretch_meter() ) ) {
                    acc += parseFloat( val.stretch_meter() );
                }
                return acc;
            }, 0);
            return result;
        });
        self.sumOf_diff = ko.computed( function () {
            var result = self.rolllist().reduce( function(acc, val) {
                if ( val.diff() != '' && !isNaN( val.diff() ) ) {
                    acc += parseFloat( val.diff() );
                }
                return acc;
            }, 0);
            return result;
        });

        self.createRow = function() {
            self.rolllist.push( self.createRoll(null) );
        };

        self.deleteRow = function(data) {
            if (confirm( "Bu kaydı silmek istediğinizden emin misiniz?" )) {
                self.rolllist.remove(data);
            }
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
                data: { product_id: product_id, lot: lot, st_id: <cfoutput>#iif( query_cutstretch.recordcount, "query_cutstretch.STRETCHING_TEST_ID", "attributes.st_id" )#</cfoutput>, viewmode: "lotfind", isajax: "1" }
            }).done(function( response ) {
                var jresponse = JSON.parse(response);
                var result = parseInt( jresponse.length );
                if (result > 2) {
                    alert("Girdiğiniz kod ile ilgili birden fazla ürün kaydı bulundu. Lütfen bir ürün seçin!");
                } else if ( result < 2 ) {
                    alert("Girdiğiniz kod kayıtlarda bulunamadı!");
                } else if (jresponse[0].product_id == "-1" || jresponse[0].product_id == undefined || jresponse[0].product_id == null || jresponse.product_id == '') {
                    alert("Girdiğiniz kod numarasına ait top kaydı bulunamadı!");
                } else {
                    jresponse = jresponse[0];
                    var row = {
                        rollno: jresponse.lot_no,
                        color: jresponse.color_lot,
                        marker: '<cfoutput>#iif( query_cutstretch.recordcount, "query_cutstretch.MARKER_NAME", "attributes.marker_name")#</cfoutput>',
                        stretch_amount1: '',
                        stretch_amount2: '',
                        undemand_spill_meter: '',
                        flaw_meter: '',
                        additional_meter: '',
                        classification_meter: '',
                        missing_roll: '',
                        waybill_meter: jresponse.envanter,
                        stretch_factor: <cfoutput>#iif( query_cutstretch.recordcount, "query_cutstretch.MARKER_HEIGHT", "attributes.marker_height" )#</cfoutput>
                    };
                    self.rolllist.push( self.createRoll(row) );
                    document.getElementById("topno").value = "";
                }
            });
        };

        self.initial = function () {
            <cfoutput query="query_cutstretch_row">
                var row = {
                    rollno: '#ROLL_NO#',
                    color: '#COLOR#',
                    marker: '#MARKER#',
                    stretch_amount1: '#STRETCH_AMOUNT1#',
                    stretch_amount2: '#STRETCH_AMOUNT2#',
                    undemand_spill_meter: '#UNDEMAND_SPILL_METER#',
                    flaw_meter: '#FLAW_METER#',
                    additional_meter: '#ADDITIONAL_METER#',
                    classification_meter: '#CLASSIFICATION_METER#',
                    missing_roll: '#MISSING_ROLL#',
                    waybill_meter: '#WAYBILL_METER#',
                    stretch_factor: '#query_cutstretch.MARKER_HEIGHT#'
                };
                self.rolllist.push( self.createRoll(row) );
            </cfoutput>
        }

        return {
            init: function(target) {
                self.initial();
                ko.applyBindings( self, document.getElementById( target ) );
            }
        }
    }();

    cutstretchApp.init('stretch_form');
</script>