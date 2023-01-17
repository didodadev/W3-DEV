<cfparam name="attributes.req_id" default="3">
<cfparam name="attributes.mh_id" default="0">
<cfparam name="attributes.opp_id" default="#attributes.req_id#">
<cfobject name="measure" component="WBP.Fashion.files.cfc.measure">
<cfobject name="stretching_test" component="WBP.Fashion.files.cfc.stretching_test">
<cfset measure_sizes = measure.get_stock_property(attributes.pid)>
<cfquery dbtype="query" name="measure_sizes_boy">
    SELECT DISTINCT BOY_ FROM measure_sizes ORDER BY BOY_ ASC 
</cfquery>
<cfquery dbtype="query" name="measure_sizes_beden">
    SELECT BEDEN_, BOY_ FROM measure_sizes GROUP BY BOY_, BEDEN_ ORDER BY BOY_, BEDEN_ ASC
</cfquery>
<cfset measure_rows = measure.get_measure_items(attributes.req_id, attributes.mh_id)>
<cfset measure_header = measure.get_measure_header(attributes.mh_id)>
<cfif measure_rows.recordcount gt 0>
<cfquery name="query_row_size" dbtype="query">
    SELECT MAX(ROW_INDEX) AS MAXROWINDEX FROM measure_rows
</cfquery>
</cfif>
<cfset stretching_groups = stretching_test.get_stretching_test_groups_by_request(attributes.req_id)>
<cfoutput>
    <script type="text/javascript">
    window.measure_sizes_boy_raw = #replace(serializeJSON(measure_sizes_boy), "//", "")#;
    window.measure_sizes_beden_raw = #replace(serializeJSON(measure_sizes_beden), "//", "")#;
    window.measure_rows_raw = #replace(serializeJSON(measure_rows), "//", "")#;
    window.measure_row_max = #iif( isDefined("query_row_size.MAXROWINDEX"), "query_row_size.MAXROWINDEX", de("-1") )#;
    </script>
</cfoutput>
<cfset pageHead="ÖLÇÜ TABLOSU FORMU">
<cf_catalystHeader>
    <cfinclude template="../../sales/query/get_req.cfm">
<div class="row">
	<div class="col col-12">
		<cf_box id="sample_request" closable="1" unload_body = "1"  title="Numune Özet" >
			<div class="col col-10 col-xs-12 ">
					<cfinclude template="../../common/get_opportunity_type.cfm">
					<cfinclude template="../../sales/display/dsp_sample_request.cfm">
			</div>
			<div class="col col-2 col-xs-2">
			<cfscript>
				CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_sample_request");
				getAsset=CreateCompenent.getAssetRequest(action_id:#attributes.req_id#,action_section:'REQ_ID');
			</cfscript>
				<cfinclude template="../../objects/display/asset_image.cfm">
			</div>
		</cf_box>
	</div>
</div>
<div class="row">
	<div class="col col-12 uniqueRow">
		<cf_box title="Ölçü Formu Bilgileri">
		<div class="row formContent">
			<div class="row" type="row">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					
				
                <cfform action="#request.self#?fuseaction=#attributes.fuseaction#&event=measure_copy">
                    <cfoutput>
                        <input type="hidden" name="target_id" value="#measure_header.HEADER_ID#">
                        <input type="hidden" name="req_id" value="#attributes.req_id#">
                        <input type="hidden" name="pid" value="#attributes.pid#">
                    </cfoutput>
            <div class="form-group">
                <label class="col col-4 col-xs-12">Ölçü Form No</label>
                <div class="col col-4 col-xs-12">
                    <input type="text" name="ot" id="ot" placeholder="OT-...">
                </div>
            </div>
            <div class="form-group">
                <div class="col col-12 col-xs-4">
                    <button type="submit" class="btn green-haze">Kopyala</button>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group">
                <label class="col col-4 col-xs-12">From Yazdır</label>
                <div class="col col-12 col-xs-4">
                    <a href="javascript://"	onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=#req_id#&print_type=500&iiid=#attributes.mh_id#</cfoutput>','page')"><i class="icon-print"></i></a>
                </div>
            </div>
        </div>
            <div class="form-group">
                <div class="col col-12 col-xs-4">
                    <cfif isDefined("attributes.copyerr")>
                        <cfif attributes.copyerr eq "notfound">
                            <span style="color: red;">Kopyalamaya çalıştığınız ölçü tablosu bulunamadı. Lütfen var olan bir tablo belirtiniz.</span>
                        </cfif>
                    </cfif>
                </div>
            </div>
        </cfform>
				
			</div>
			</cf_box>
		</div>
	</div>
</div>

<link rel="stylesheet" type="text/css" href="/css/temp/multiselect_check/jquery.multiselect.css">
<script type="text/javascript" src="/JS/temp/multiselect/jquery.multiselect.js"></script>
<script type="text/javascript" src="/JS/temp/multiselect/jquery.multiselect.filter.js"></script>
<style>
    button.ui-multiselect.ui-widget.ui-state-default.ui-corner-all.no-print {
        width: 100px !important;
    }
</style>

<cfform name="frm_measure_sizes" method="post">
<cfinput type="hidden" name="req_id" value="#attributes.req_id#">
<cfinput type="hidden" name="pid" value="#attributes.pid#">
    
<div class="row">
	<input type="hidden" name="sizeOfDetails" data-bind="value: self.calculateSize()">
	<cfinput type="hidden" name="measure_header_id" value="#attributes.mh_id#">
	<div class="col col-12 uniqueRow">
		<div class="row formContent">
			<div class="row" type="row">
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group">
						<label class="col col-2 col-xs-12">Süreç *</label>
						<div class="col col-6 col-xs-12">
							<cfif len(measure_header.PROCESS_STAGE)>
							<cf_workcube_process is_upd='0' fusepath="textile.measure" select_value='#measure_header.PROCESS_STAGE#' process_cat_width='140' is_detail='1'>
							<cfelse>
							<cf_workcube_process is_upd='0' fusepath="textile.measure" process_cat_width='140' is_detail='0'>
							</cfif>
						</div>
					</div>
				</div>
				</br></br>
				<div>
					<table>
					<tr>
						<th style="width: 150px;">En/Boy Çekme Oranı</th>
						<th style="text-align: center;">BOY</th>
						<th>EN</th>
					</tr>
				</div>
				<div>
					<tr>
						<td style="text-align: center;"><select name="stretching_group" data-bind="options: colorgroup, optionsText: 'group_name', value: selectedcolorgroup, optionsCaption: 'Renk Lotları', optionsValue: 'group_name', event: { change: function() { $root.stretching_group_changed(); } }"></select></td>
						<td><input type="text" data-bind="value: evalue" name="erate"></td>
						<td><input type="text" data-bind="value: bvalue" name="brate"></td>
					</tr>
					</table>
				</div>
                <div>
                    <table class="table">
                        <tr>
                            <td>
                            BOY <select data-bind="options: measure_sizes_boy, value: activeBoy"></select></br>
                            <select multiple="multiple" data-bind="multiselect: { config: { width:100,height:150,checkAllText:'Seç ',uncheckAllText:'Kaldır ',noneSelectedText: 'Beden Seçiniz',selectedText: '# / #Kayıt Seçildi ',open: function () {$('input[type=\'search\']').focus();}}, options: displaysizes, selectedOptions: activesizes }"></select></br>
                            <select multiple="multiple" data-bind="multiselect: { config: { width:100,height:150,checkAllText:'Seç ',uncheckAllText:'Kaldır ',noneSelectedText: 'Beden Seçiniz',selectedText: '# / #Kayıt Seçildi ',open: function () {$('input[type=\'search\']').focus();}}, options: showncols, selectedOptions: activecols }"></select>
                            <a href="javascript:void(0)" data-bind="click: function() { self.createRow(); }"><i class="fa fa-plus"></i></a> Satır Ekle
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
				<div class="col col-12" style="overflow: auto;">
					<cf_grid_list>
					<!---<table class="table">--->
						<thead> 
							<tr>
								<th colspan="4"> 
								</th>
								<!-- ko foreach: self.shownSizes -->
								<th style="border-left: 1px solid #ddd; text-align: center;" data-bind="attr: { colspan: self.activecols().length + 1 }, visible: $root.activesizes().indexOf($data[0]) >= 0"><span data-bind="text: $data[0]"></th>
								<!-- /ko -->
								<th></th>
							</tr>

							<tr>
								<th>E/B</th>
								<th>Ölçüm Yeri</th>
								<th>Seri Atımı</th>
								<th>Açıklama</th>
								<!-- ko foreach: self.shownSizes -->
								<th style="border-left: 1px solid #ddd; text-align: center;" data-bind="visible: $root.activesizes().indexOf($data[0]) >= 0">İstenen</th>
								<th style="text-align: center;" title="Y&iota;kama &Ouml;ncesi &Iota;stenen" data-bind="visible: activecols().indexOf('YÖΙ') >= 0 && $root.activesizes().indexOf($data[0]) >= 0">Y&Ouml;&Iota;</th>
								<th style="text-align: center;" title="Y&iota;kama &Ouml;ncesi Gelen" data-bind="visible: activecols().indexOf('YÖG') >= 0 && $root.activesizes().indexOf($data[0]) >= 0">Y&Ouml;G</th>
								<th style="text-align: center;" title="Y&iota;kama &Ouml;ncesi Fark" data-bind="visible: activecols().indexOf('YÖF') >= 0 && $root.activesizes().indexOf($data[0]) >= 0">Y&Ouml;F</th>
								<th style="text-align: center;" title="&Uuml;t&uuml; &Ouml;ncesi Gelen" data-bind="visible: activecols().indexOf('ÜÖΙ') >= 0 && $root.activesizes().indexOf($data[0]) >= 0">&Uuml;&Ouml;G</th>
								<th style="text-align: center;" title="&Uuml;t&uuml; Sonras&iota; Gelen" data-bind="visible: activecols().indexOf('ÜSG') >= 0 && $root.activesizes().indexOf($data[0]) >= 0">&Uuml;SG</th>
								<th style="text-align: center;" title="&Uuml;t&uuml; Sonras&iota; Fark" data-bind="visible: activecols().indexOf('ÜSF') >= 0 && $root.activesizes().indexOf($data[0]) >= 0">&Uuml;SF</th>
								<!-- /ko -->
								<th></th>
							</tr>
						</thead>
						<tbody>
							<!-- ko foreach: self.measure_rows -->
							<tr data-bind="visible: $data.boy() == self.activeBoy()">
								<td>
									<select data-bind="value: eb_type">
										<option value="">D</option>
										<option value="e">E</option>
										<option value="b">B</option>
									</select>
								</td>
								<td>
									<input type="text" data-bind="value: measure_point">
								</td>
								<td>
									<input type="text" data-bind="changeSerialValue: serial_inc">
								</td>
								<td>
									<input type="text" data-bind="value: desc">
								</td>
								<!-- ko foreach: sizes -->
								<input type="hidden" data-bind="value: $parent.eb_type(), attr: { name: 'eb_type_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<input type="hidden" data-bind="value: size()[1], attr: { name: 'boy_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<input type="hidden" data-bind="value: size()[0], attr: { name: 'size_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<input type="hidden" data-bind="value: $parent.measure_point(), attr: { name: 'measure_point_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<input type="hidden" data-bind="value: $parent.serial_inc(), attr: { name: 'serial_inc_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<input type="hidden" data-bind="value: $parent.desc(), attr: { name: 'desc_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<input type="hidden" data-bind="value: $parentContext.$index(), attr: { name: 'row_index_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								<td style="text-align: center;" data-bind="visible: $root.activesizes().indexOf($data.size()[0]) >= 0">
								<input type="text" style="width: 50px;" data-bind="changedValue: target, attr: { name: 'target_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								</td>
								<td style="text-align: center;" data-bind="visible: activecols().indexOf('YÖΙ') >= 0 && $root.activesizes().indexOf($data.size()[0]) >= 0">
									<!-- ko if: $parent.eb_type() == '' -->
									<input type="text" style="width: 50px;" data-bind="value: yoi, attr: { name: 'yoi_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
									<!-- /ko -->
									<!-- ko if: $parent.eb_type() != '' -->
									<input type="text" style="width: 50px;" data-bind="value: yoic, attr: { name: 'yoi_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
									<!-- /ko -->
								</td>
								<td style="text-align: center;" data-bind="visible: activecols().indexOf('YÖG') >= 0 && $root.activesizes().indexOf($data.size()[0]) >= 0">
									<input type="text" style="width: 50px;" data-bind="value: yog, attr: { name: 'yog_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								</td>
								<td style="text-align: center;" data-bind="visible: activecols().indexOf('YÖF') >= 0 && $root.activesizes().indexOf($data.size()[0]) >= 0">
									<input type="text" style="width: 50px;" data-bind="value: yof, attr: { name: 'yof_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								</td>
								<td style="text-align: center;" data-bind="visible: activecols().indexOf('ÜÖΙ') >= 0 && $root.activesizes().indexOf($data.size()[0]) >= 0">
									<input type="text" style="width: 50px;" data-bind="value: uog, attr: { name: 'uog_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								</td>
								<td style="text-align: center;" data-bind="visible: activecols().indexOf('ÜSG') >= 0 && $root.activesizes().indexOf($data.size()[0]) >= 0">
									<input type="text" style="width: 50px;" data-bind="value: usg, attr: { name: 'usg_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								</td>
								<td style="text-align: center;" data-bind="visible: activecols().indexOf('ÜSF') >= 0 && $root.activesizes().indexOf($data.size()[0]) >= 0">
									<input type="text" style="width: 50px;" data-bind="value: usf, attr: { name: 'usf_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
								</td>
								<!-- /ko -->
								<td><a href="javascript:void(0)" data-bind="click: function() { if ( confirm('Kayit silinsin mi?') ) self.deleteRow($data); }">x</a></td>
							</tr>
							<!-- /ko -->
						</tbody>
					</cf_grid_list>
					<!---</table>--->
				</div>
			</div>
			<div class="row formContentFooter">
				<div class="col col-12">
					<cf_workcube_buttons is_upd='0'>
				</div>
			</div>
		</div>
	</div>
</div>

</cfform>
<script type="text/javascript" src="/WBP/Fashion/files/js/knockout.js"></script>
<script type="text/javascript">

    ko.bindingHandlers.changedValue = {
        init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            var value = valueAccessor();
            $( element ).change( function() {
                value( $( this ).val() );
                if ( bindingContext.$parent.serial_inc().toString() != '' && ! isNaN( bindingContext.$parent.serial_inc().toString().replace( ',', '.' ) ) ) {
                    if ( viewModel.target().toString() != '' && ! isNaN( viewModel.target() ) ) {
                        var serial_inc = parseFloat( bindingContext.$parent.serial_inc().toString().replace( ',', '.' ) );
                        var sizes = bindingContext.$parent.sizes();
                        var currentVal = parseFloat( viewModel.target().toString().replace( ',', '.' ) );
                        if (bindingContext.$index() < sizes.length) {
                            for (let idx = bindingContext.$index()+1; idx < sizes.length; idx++) {
                                currentVal += serial_inc;
                                const elm = sizes[idx];
                                elm.target( currentVal );
                            }
                        }
                    }
                }
            } );
        },
        update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            $( element ).val( ko.unwrap( valueAccessor() ) );
        }
    };

    ko.bindingHandlers.changeSerialValue = {
        init: function ( element, valueAccessor, allBindings, viewModel, bindingContext ) {
            var value = valueAccessor();
            $( element ).change( function() {
                value( $( this ).val() );
                if ( viewModel.serial_inc().toString() != '' && ! isNaN( viewModel.serial_inc().toString().replace( ',', '.' ) ) ) {
                    if ( viewModel.sizes().length > 0 && viewModel.sizes()[0].target().toString() != '' && ! isNaN( viewModel.sizes()[0].target().toString().replace( ',', '.' ) ) ) {
                        var serial_inc = parseFloat( viewModel.serial_inc().toString().replace( ',', '.' ) );
                        var targetfirst = parseFloat( viewModel.sizes()[0].target().toString().replace( ',', '.' ) );
                        for (let idx = 1; idx < viewModel.sizes().length; idx++ ) {
                            viewModel.sizes()[idx].target( targetfirst + ( serial_inc * idx ) );
                        }
                    }
                }
            });
        },
        update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            $( element ).val( ko.unwrap( valueAccessor() ) );
        }
    };

    ko.bindingHandlers.multiselect = {
        init: function (element, valueAccessor, allBindingAccessors) {
            "use strict";

            var options = valueAccessor();

            ko.bindingHandlers.options.update(
                element,
                function() { return options.options; },
                allBindingAccessors
            );

            ko.bindingHandlers.selectedOptions.init(
                element,
                function() { return options.selectedOptions; },
                allBindingAccessors
            );

            ko.bindingHandlers.selectedOptions.update(
                element,
                function() { return options.selectedOptions; },
                allBindingAccessors
            );

            $(element).multiselect(options.config);

            //make view model know about select/deselect changes
            $(element).bind("multiselectcheckall", function () { $(element).trigger("change"); });
            $(element).bind("multiselectuncheckall", function () { $(element).trigger("change"); });
        },
        update: function (element, valueAccessor, allBindingAccessors) {
            "use strict";

            var options = valueAccessor();
            //update html if items set through code
            ko.bindingHandlers.selectedOptions.update(
                element,
                function () { return options.selectedOptions; },
                allBindingAccessors
            );

            $(element).multiselect("refresh");
        }
    };
    

    var appTable = function () {
        var self = this;

        self.measure_sizes = ko.observableArray( window.measure_sizes_beden_raw.DATA );
        self.measure_sizes_boy = ko.observableArray( window.measure_sizes_boy_raw.DATA.map(m => m[0]) );

        self.measure_rows = ko.observableArray( [] );

        self.evalue = ko.observable( '<cfoutput>#measure_header.ERATE#</cfoutput>' );
        self.bvalue = ko.observable( '<cfoutput>#measure_header.BRATE#</cfoutput>' );
        self.activeBoy = ko.observable( '' );
        self.activecols = ko.observableArray(['YÖΙ','YÖG','YÖF','ÜÖΙ','ÜSG','ÜSF']);
        self.activesizes = ko.observableArray([]);

        self.displaysizes = ko.computed(function() {
            var sz = [];
            self.measure_sizes().forEach( function (element) {
                if ( sz.indexOf( element[0] ) < 0 ) sz.push(element[0]);
            });
            return sz;
        });

        self.activesizes( self.displaysizes() );

        self.showncols = ko.observableArray( ['YÖΙ','YÖG','YÖF','ÜÖΙ','ÜSG','ÜSF'] );

        self.createDetail = function( observer_row, size, parse_row ) {
            var detail = {
                size: ko.observable( parse_row == null ? size : [ parse_row[4], parse_row[3] ] ),
                target: ko.observable( parse_row == null ? '' : parse_row[10] ),
                yog: ko.observable( parse_row == null ? '' : parse_row[12] ),
                uog: ko.observable( parse_row == null ? '' : parse_row[14] ),
                usg: ko.observable( parse_row == null ? '' : parse_row[15] ),
                yoi: ko.observable( parse_row == null ? '' : parse_row[11] )
            };
            detail.yoic = ko.computed( function() {
                if ( detail.target() == '' || isNaN( detail.target().toString().replace( ',', '.' ) ) ) return '';
                var target_number = parseFloat( detail.target().toString().replace( ',', '.' ) );
                if ( observer_row.eb_type() == 'e' ) {
                    if ( self.evalue() == '' || isNaN( self.evalue().toString().replace( ',', '.' ) ) ) return detail.target();
                    var evalue_number = parseFloat( self.evalue().toString().replace( ',', '.' ) );
                    return ( target_number + ( target_number * evalue_number / 100 ) ).toFixed( 2 );
                } else if ( observer_row.eb_type() == 'b' ) {
                    if ( self.bvalue() == '' || isNaN( self.bvalue().toString().replace( ',', '.' ) ) ) return detail.target();
                    var bvalue_number = parseFloat( self.bvalue().toString().replace( ',', '.' ) );
                    return ( target_number + ( target_number * bvalue_number / 100 ) ).toFixed( 2 );
                } else {
                    detail.yoi( target_number );
                    return '';
                }
            } );
            detail.yof = ko.computed( function() {
                if ( ( detail.yoic() == '' || isNaN( detail.yoic().toString().replace( ',', '.' ) ) ) && ( detail.yoi() == '' || isNaN( detail.yoi().toString().replace( ',', '.' ) ) ) ) return '';
                if ( detail.yog() == '' || isNaN( detail.yog().toString().replace( ',', '.' ) ) ) return '';
                var yoi_number = 0;
                if ( detail.yoic() != '' && ! isNaN( detail.yoic().toString().replace( ',', '.' ) ) ) {
                    yoi_number = parseFloat( detail.yoic().toString().replace( ',', '.' ) );
                } else {
                    yoi_number = parseFloat( detail.yoi().toString().replace( ',', '.' ) );
                }
                var yog_number = parseFloat( detail.yog().toString().replace( ',', '.' ) );
                return ( yoi_number - yog_number ).toFixed( 2 );
            } );
            detail.usf = ko.computed( function() {
                if ( detail.target() == '' || isNaN( detail.target().toString().replace( ',', '.' ) ) ) return '';
                if ( detail.usg() == '' || isNaN( detail.usg().toString().replace( ',', '.' ) ) ) return '';
                var target_number = parseFloat( detail.target().toString().replace( ',', '.' ) );
                var usg_number = parseFloat( detail.usg().toString().replace( ',', '.' ) );
                return ( target_number - usg_number ).toFixed( 2 );
            } );
            return detail;
        }
        self.createRow = function() {
            var observer_row = {
                eb_type: ko.observable( '' ),
                measure_point: ko.observable( '' ),
                serial_inc: ko.observable( '' ),
                boy: ko.observable( self.activeBoy() ),
                desc: ko.observable( '' )
            };
            observer_row.sizes = ko.observableArray( [] );
            self.shownSizes().forEach( function ( elm ) {
                observer_row.sizes.push( self.createDetail( observer_row, elm, null ) );
            });
            self.measure_rows.push( observer_row );
        };
        self.parseRow = function() {
            for ( i=0; i<=window.measure_row_max; i++ ) {
                var row = {};
                var founded = window.measure_rows_raw.DATA.filter( function( elm ) {
                    return elm[5] == i;
                });
                var actualsize = self.measure_sizes().filter( function (m) { return m[1] == founded[0][3]; } );
                actualsize.forEach( function( sz ) {
                    col = founded.filter( function( elm ) {
                        return elm[4] == sz[0];
                    });
                    if ( col.length > 0 ) {
                        col = col[0];
                        if ( row.sizes === undefined ) {
                            row.eb_type = ko.observable( col[6] );
                            row.measure_point = ko.observable( col[7] );
                            row.serial_inc = ko.observable( col[8] );
                            row.desc = ko.observable( col[9] );
                            row.boy = ko.observable( col[3] );
                            row.sizes = ko.observableArray( [] );
                        }
                        row.sizes.push( self.createDetail( row, null, col ) );
                    } else {
                        row.sizes.push( self.createDetail( row, sz, null ) );
                    }
                });
                self.measure_rows.push( row );
            }
        }

        self.deleteRow = function ( row ) {
            self.measure_rows.remove( row );
        }

        self.calculateSize = ko.computed( function() {
            return self.measure_rows().reduce( function(acc, itm) {
                return acc + itm.sizes().length;
            }, 0) * window.measure_sizes().length;
        });

        self.shownSizes = ko.computed( function() {
            return self.measure_sizes().filter( function (m) { return m[1] == self.activeBoy(); } );
        });

        self.shownRows = ko.computed( function () {
            return self.measure_rows().filter( function (m) { return m.boy() == self.activeBoy(); } );
        } );

        self.colorgroup = ko.observableArray([
            <cfoutput query="stretching_groups">
            {group_name: "#GROUP_NAME#", erate: #len(WIDTH)?WIDTH:0#, brate: #len(HEIGHT)?HEIGHT:0# }<cfif currentrow lt stretching_groups.recordcount>,</cfif>
            </cfoutput>
        ]);
        self.selectedcolorgroup = ko.observable(<cfif len('#measure_header.STRETCHING_GROUP#')><cfoutput>'#measure_header.STRETCHING_GROUP#'</cfoutput><cfelse>''</cfif>);
        self.stretching_group_changed = function () {
            if (self.selectedcolorgroup() !== undefined && self.selectedcolorgroup() !== null) {
                let sg = self.colorgroup().filter(m => m.group_name == self.selectedcolorgroup());
                if (sg.length > 0) {
                    sg = sg[0];
                    self.evalue(sg.erate);
                    self.bvalue(sg.brate);
                }
            }
        }

        self.printform = function() {
            var printWin = window.open( "about:blank", "_blank", "" );
            printWin.document.writeln( '<table width="100%" border="1" cellspacing="0" cellpadding="1">' );
            printWin.document.writeln( '<tr>' );
            printWin.document.writeln( '<th>En/Boy &Ccedil;ekme Oran&iota;</th>' );
            printWin.document.writeln( '<th>' + self.evalue() + '</th>' );
            printWin.document.writeln( '<th>' + self.bvalue() + '</th>' );
            printWin.document.writeln( '<th>&nbsp;</th>' );
            self.measure_sizes().forEach( function ( elm ) {
                printWin.document.writeln( '<th colspan="7" style="border-left: 1px solid #ddd; text-align: center;"><span>' + elm[0] + '</span></th>' );
            });
            printWin.document.writeln( '</tr>' );
            printWin.document.writeln( '<tr>' );
            printWin.document.writeln( '<th>E/B</th>' );
            printWin.document.writeln( '<th>&Ouml;l&ccedil;&uuml;m Yeri</th>' );
            printWin.document.writeln( '<th>Seri At&iota;m&iota;</th>' );
            printWin.document.writeln( '<th>A&ccedil;&iota;klama</th>' );
            self.measure_sizes().forEach( function ( elm ) {
                printWin.document.writeln( '<th>&Iota;stenen</th>' );
                printWin.document.writeln( '<th>Y&Ouml;&Iota;</th>' );
                printWin.document.writeln( '<th>Y&Ouml;G</th>' );
                printWin.document.writeln( '<th>Y&Ouml;F</th>' );
                printWin.document.writeln( '<th>&Uuml;&Ouml;G</th>' );
                printWin.document.writeln( '<th>&Uuml;SG</th>' );
                printWin.document.writeln( '<th>&Uuml;SF</th>' );
            });
            printWin.document.writeln( '</tr>' );
            
            printWin.document.writeln("</tr>");
            self.measure_rows().forEach(function ( det ) {
                printWin.document.writeln("<tr>");
                printWin.document.write('<td>' + ( det.eb_type() == 'e' ? 'En' : 'Boy' ) + '</td>' );
                printWin.document.write('<td>' + det.measure_point() + "</td>");
                printWin.document.write('<td>' + det.serial_inc() + "</td>");
                printWin.document.write('<td>' + det.desc() + "</td>");
                det.sizes().forEach( function ( size ) {
                    printWin.document.write( '<td>' + size.target() + '</td>' );
                    if ( size.yoic() != null && size.yoic() != '' ) {
                        printWin.document.write( '<td>' + size.yoic() + '</td>' );
                    } else {
                        printWin.document.write( '<td>' + size.yoi() + '</td>' );
                    }
                    printWin.document.write( '<td>' + size.yog() + '</td>' );
                    printWin.document.write( '<td>' + size.yof() + '</td>' );
                    printWin.document.write( '<td>' + size.uog() + '</td>' );
                    printWin.document.write( '<td>' + size.usg() + '</td>' );
                    printWin.document.write( '<td>' + size.usf() + '</td>' );
                });
                printWin.document.writeln("</tr>");
            });
            
            
            printWin.document.writeln("</table>");
            printWin.print();
        }
        
        return {
            init: function() {
                ko.applyBindings( self, document.getElementById( 'apptable' ) );
                self.parseRow();
            }
        }
    }();
    appTable.init();

    function v() {
        try{
    $("#ddbody")
       .multiselect({
          minWidth:300,
          height:300,
          //show:['slide', 500],
          checkAllText:"Seç ",
          uncheckAllText:"Kaldır ",
          
            noneSelectedText: 'İşlem Seçiniz',
          
          selectedText: '# / #Kayıt Seçildi '
       });
            
            
    
        //$("#islem1").multiselect().multiselectfilter();
        $("#ddbody").multiselect({
        open: function () {
            $("input[type='search']").focus();                   
        }
    });
    
        //.bind('multiselectclick',goster);  check ya da uncheck de fonksiyon çalıştırıyor
    
    }catch(err){/*console.log(err)*/};
    }
</script>