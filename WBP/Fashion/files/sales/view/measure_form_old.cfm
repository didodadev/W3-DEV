
<cfobject name="measure" component="WBP.Fashion.files.cfc.measure">
<cfset measure_sizes = measure.get_stock_property(attributes.pid)>
<cfset measure_rows = measure.get_measure_rows(attributes.req_id)>
<cfoutput>
    <script type="text/javascript">
    window.measure_sizes = #replace(serializeJSON(measure_sizes), "//", "")#;
    window.measure_rows = #replace(serializeJSON(measure_rows), "//", "")#;
    </script>
</cfoutput>

<cfset pageHead = "Ölçme Formu">
<cf_catalystHeader>
<cfform name="frm_measure_sizes" method="post">
    <input type="hidden" name="sizeOfDetails" data-bind="value: self.details().length">
    <cfinput type="hidden" name="req_id" value="#attributes.req_id#">
	<cfinput type="hidden" name="pid" value="#attributes.pid#">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                        <div class="form-group" id="item-sizes">
                            <label class="col col-4 col-sx-12">Beden Seçiniz</label>
                            <div class="col col-8 col-xs-12">
                                <select name="sizes" id="sizes" class="form-control" data-bind="options: sizes, optionsValue: 'id', optionsText: 'text', optionsCaption: 'Seçiniz', value: actualSize">
								<!---
										<option value="">Seçiniz</option>
									<cfoutput query="measure_sizes">
										<option value="#stock_id#">#renk_# #boy_# #beden_#</option>
									</cfoutput>
								--->
								</select>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12">
                        <div class="form-group" id="item-lists">
                            <div class="col col-12">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>DETAYLAR</th>
                                            <th>DETAYLAR(ENG)</th>
                                            <th>HEDEF</th>
                                            <th>&nbsp;</th>
                                            <th>YÖH</th>
                                            <th>YÖG</th>
                                            <th>SAPMA</th>
                                            <th>&nbsp;</th>
                                            <th>ÜÖH</th>
                                            <th>ÜÖG</th>
                                            <th>SAPMA</th>
                                            <th>&nbsp;</th>
                                            <th>ÜSH</th>
                                            <th>ÜSG</th>
                                            <th>SAPMA</th>
                                            <th><a href="javascript:void()" data-bind="click: function() { self.createDetail(self.actualSize()); }"><i class="fa fa-plus"></i></a></th>
                                        </tr>
                                    </thead>
                                    <tbody data-bind="foreach: details">
                                        <tr data-bind="visible: self.actualSize() == size()">
                                            <td><input type="text" data-bind="value: detail, attr: { name: 'detail' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: detailen, attr: { name: 'detailen' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: target, attr: { name: 'target' + ($index()+1).toString() }"></td>
                                            <td>&nbsp;</td>
                                            <td><input type="text" data-bind="value: yoh, event: { change: function() { self.yo_change($data); } }, attr: { name: 'yoh' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: yog, event: { change: function() { self.yo_change($data); } }, attr: { name: 'yog' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: yod, style: { backgroundColor: yod() < 0 ? 'red' : ( yod() > 0 ? 'yellow' : 'inherit' ) }, attr: { name: 'yod' + ($index()+1).toString() }"></td>
                                            <td>&nbsp;</td>
                                            <td><input type="text" data-bind="value: uoh, event: { change: function() { self.uo_change($data); } }, attr: { name: 'uoh' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: uog, event: { change: function() { self.uo_change($data); } }, attr: { name: 'uog' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: uod, style: { backgroundColor: uod() < 0 ? 'red' : ( uod() > 0 ? 'yellow' : 'inherit' ) }, attr: { name: 'uod' + ($index()+1).toString() }"></td>
                                            <td>&nbsp;</td>
                                            <td><input type="text" data-bind="value: ush, event: { change: function() { self.us_change($data); } }, attr: { name: 'ush' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: usg, event: { change: function() { self.us_change($data); } }, attr: { name: 'usg' + ($index()+1).toString() }"></td>
                                            <td><input type="text" data-bind="value: usd, style: { backgroundColor: usd() < 0 ? 'red' : ( usd() > 0 ? 'yellow' : 'inherit' ) }, attr: { name: 'usd' + ($index()+1).toString() }"></td>
                                            <td>
                                                <a href="javascript:void()" data-bind="click: function() { self.removeDetail($data); }"><i class="fa fa-minus"></i></a>
                                                <input type="hidden" data-bind="value: size, attr: { name: 'size' + ($index()+1).toString() }">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0'>
                        <button type="button" class="btn btn-primary" data-bind="click: function() { self.printform(); }">Yazdır</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
<script type="text/javascript" src="/WBP/Fashion/files/js/knockout.js"></script>
<script type="text/javascript" src="/WBP/Fashion/files/js/app.measure_form.js"></script>