<cfparam name="attributes.req_id" default="3">
<cfparam name="attributes.mh_id" default="0">
<cfparam name="attributes.opp_id" default="#attributes.req_id#">
<cfobject name="measure" component="WBP.Fashion.files.cfc.measure">
<cfset measure_sizes = measure.get_stock_property(attributes.pid)>
<cfquery dbtype="query" name="measure_sizes_cropped">
    SELECT BEDEN_ FROM measure_sizes ORDER BY BEDEN_ ASC
</cfquery>
<cfset measure_rows = measure.get_measure_items(attributes.req_id, attributes.mh_id)>
<cfset measure_header = measure.get_measure_header(attributes.mh_id)>
<cfif measure_rows.recordcount gt 0>
<cfquery name="query_row_size" dbtype="query">
    SELECT MAX(ROW_INDEX) AS MAXROWINDEX FROM measure_rows
</cfquery>
</cfif>
<cfoutput>
    <script type="text/javascript">
    window.measure_sizes_raw = #replace(serializeJSON(measure_sizes_cropped), "//", "")#;
    window.measure_rows_raw = #replace(serializeJSON(measure_rows), "//", "")#;
    window.measure_row_max = #iif( isDefined("query_row_size.MAXROWINDEX"), "query_row_size.MAXROWINDEX", de("-1") )#;
    </script>
</cfoutput>
<cfset pageHead="&Ouml;L&Ccedil;&Uuml; FORMU">
<cf_catalystHeader>


<!----
<cf_box id="sample_request" closable="0" unload_body = "1"  title="Numune Özet" >	
    <cfinclude template="/V16/sales/query/get_opportunity_type.cfm">
    <cfinclude template="../display/dsp_sample_request.cfm">
</cf_box>
----->



<cfform name="frm_measure_sizes" method="post">
    <cfinput type="hidden" name="req_id" value="#attributes.req_id#">
	<cfinput type="hidden" name="pid" value="#attributes.pid#">
    
    <div class="row" id="apptable">
        <input type="hidden" name="sizeOfDetails" data-bind="value: self.calculateSize()">
        <cfinput type="hidden" name="measure_header_id" value="#attributes.mh_id#">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-12" style="overflow: auto;">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>En/Boy &Ccedil;ekme Oran&iota;</th>
                                    <th><input type="text" data-bind="value: evalue" name="erate" style="width: 50px;"></th>
                                    <th><input type="text" data-bind="value: bvalue" name="brate" style="width: 50px;"></th>
                                    <th><a href="javascript:void()" data-bind="click: function() { self.createRow(); }"><i class="fa fa-plus"></i></a></th>
                                    <!-- ko foreach: window.measure_sizes -->
                                    <th colspan="7" style="border-left: 1px solid #ddd; text-align: center;"><span data-bind="text: $data[0]"></th>
                                    <!-- /ko -->
                                    <th></th>
                                </tr>
                                <tr>
                                    <th>E/B</th>
                                    <th>&Ouml;l&ccedil;&uuml;m Yeri</th>
                                    <th>Seri At&iota;m&iota;</th>
                                    <th>A&ccedil;&iota;klama</th>
                                    <!-- ko foreach: window.measure_sizes -->
                                    <th style="border-left: 1px solid #ddd; text-align: center;">&Iota;stenen</th>
                                    <th style="text-align: center;" title="Y&iota;kama &Ouml;ncesi &Iota;stenen">Y&Ouml;&Iota;</th>
                                    <th style="text-align: center;" title="Y&iota;kama &Ouml;ncesi Gelen">Y&Ouml;G</th>
                                    <th style="text-align: center;" title="Y&iota;kama &Ouml;ncesi Fark">Y&Ouml;F</th>
                                    <th style="text-align: center;" title="&Uuml;t&uuml; &Ouml;ncesi &Iota;stenen">&Uuml;&Ouml;&Iota;</th>
                                    <th style="text-align: center;" title="&Uuml;t&uuml; Sonras&iota; Gelen">&Uuml;SG</th>
                                    <th style="text-align: center;" title="&Uuml;t&uuml; Sonras&iota; Fark">&Uuml;SF</th>
                                    <!-- /ko -->
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- ko foreach: measure_rows -->
                                <tr>
                                    <td>
                                        <select data-bind="value: eb_type">
                                            <option value="">-</option>
                                            <option value="e">E</option>
                                            <option value="b">B</option>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" style="width: 150px;" data-bind="value: measure_point">
                                    </td>
                                    <td>
                                        <input type="text" style="width: 50px;" data-bind="value: serial_inc">
                                    </td>
                                    <td>
                                        <input type="text" style="width: 250px;" data-bind="value: desc">
                                    </td>
                                    <!-- ko foreach: sizes -->
                                    <input type="hidden" data-bind="value: $parent.eb_type(), attr: { name: 'eb_type_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    <input type="hidden" data-bind="value: size()[0], attr: { name: 'size_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    <input type="hidden" data-bind="value: $parent.measure_point(), attr: { name: 'measure_point_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    <input type="hidden" data-bind="value: $parent.serial_inc(), attr: { name: 'serial_inc_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    <input type="hidden" data-bind="value: $parent.desc(), attr: { name: 'desc_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    <input type="hidden" data-bind="value: $parentContext.$index(), attr: { name: 'row_index_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    <td style="text-align: center;">
                                        <input type="text" style="width: 50px;" data-bind="changedValue: target, attr: { name: 'target_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    </td>
                                    <td style="text-align: center;">
                                        <!-- ko if: $parent.eb_type() == '' -->
                                        <input type="text" style="width: 50px;" data-bind="value: yoi, attr: { name: 'yoi_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                        <!-- /ko -->
                                        <!-- ko if: $parent.eb_type() != '' -->
                                        <input type="text" style="width: 50px;" data-bind="value: yoic, attr: { name: 'yoi_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                        <!-- /ko -->
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="text" style="width: 50px;" data-bind="value: yog, attr: { name: 'yog_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="text" style="width: 50px;" data-bind="value: yof, attr: { name: 'yof_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="text" style="width: 50px;" data-bind="value: uog, attr: { name: 'uog_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="text" style="width: 50px;" data-bind="value: usg, attr: { name: 'usg_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="text" style="width: 50px;" data-bind="value: usf, attr: { name: 'usf_' + ( ( window.measure_sizes().length * $parentContext.$index() ) + $index() + 1 ).toString() }">
                                    </td>
                                    <!-- /ko -->
                                    <td><a href="javascript:void(0)" data-bind="click: function() { if ( confirm('Kayit silinsin mi?') ) self.deleteRow($data); }">x</a></td>
                                </tr>
                                <!-- /ko -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0'>
                        <button type="button" class="btn btn-primary" data-bind="click: function() { self.printform(); }">Yazd&iota;r</button>
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
                if ( bindingContext.$index() == 0 && bindingContext.$parent.serial_inc() != '' && ! isNaN( bindingContext.$parent.serial_inc() ) ) {
                    var serial_inc = parseInt( bindingContext.$parent.serial_inc() );
                    var sizes = bindingContext.$parent.sizes();
                    for (let idx = 1; idx < sizes.length; idx++) {
                        const elm = sizes[idx];
                        elm.target( parseInt( viewModel.target() ) + ( serial_inc * idx ) );
                    }
                }
            } );
        },
        update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            $( element ).val( ko.unwrap( valueAccessor() ) );
        }
    };

    var appTable = function () {
        var self = this;

        self.measure_sizes = ko.observableArray( window.measure_sizes_raw.DATA );

        self.measure_rows = ko.observableArray( [] );

        self.evalue = ko.observable( '<cfoutput>#measure_header.ERATE#</cfoutput>' );
        self.bvalue = ko.observable( '<cfoutput>#measure_header.BRATE#</cfoutput>' );

        self.createDetail = function( observer_row, size, parse_row ) {
            var detail = {
                size: ko.observable( parse_row == null ? size : [ parse_row[3] ] ),
                target: ko.observable( parse_row == null ? '' : parse_row[9] ),
                yog: ko.observable( parse_row == null ? '' : parse_row[11] ),
                uog: ko.observable( parse_row == null ? '' : parse_row[13] ),
                usg: ko.observable( parse_row == null ? '' : parse_row[14] ),
                yoi: ko.observable( parse_row == null ? '' : parse_row[10] )
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
        self.createRow = function( row ) {
            var observer_row = {
                eb_type: ko.observable( '' ),
                measure_point: ko.observable( '' ),
                serial_inc: ko.observable( '' ),
                desc: ko.observable( '' ),
                sizes: ko.observableArray( [] )
            };
            observer_row.sizes = ko.observableArray( [] );
            self.measure_sizes().forEach( function ( elm ) {
                observer_row.sizes.push( self.createDetail( observer_row, elm, null ) );
            });
            self.measure_rows.push( observer_row );
        };
        self.parseRow = function() {
            for ( i=0; i<=window.measure_row_max; i++ ) {
                var row = {};
                var founded = window.measure_rows_raw.DATA.filter( function( elm ) {
                    return elm[4] == i;
                });
                founded.forEach( function( elm ) {
                    if ( row.sizes === undefined ) {
                        row.eb_type = ko.observable( elm[5] );
                        row.measure_point = ko.observable( elm[6] );
                        row.serial_inc = ko.observable( elm[7] );
                        row.desc = ko.observable( elm[8] );
                        row.sizes = ko.observableArray( [] );
                    }
                    row.sizes.push( self.createDetail( row, null, elm ) );
                });
                self.measure_rows.push( row );
            }
        }
        self.parseRow();

        self.deleteRow = function ( row ) {
            self.measure_rows.remove( row );
        }

        self.calculateSize = ko.computed( function() {
            return self.measure_rows().reduce( function(acc, itm) {
                return acc + itm.sizes().length;
            }, 0);
        });

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
            }
        }
    }();
    appTable.init();
</script>