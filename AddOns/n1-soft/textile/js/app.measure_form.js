
var appMeasureForm = function(ko, jq) {
    var self = this;
	
    self.sizes          = ko.observableArray( window.measure_sizes.DATA.map(function(e) { return {id: e[7], text: e[0] + ' ' + e[5] + ' ' + e[2]}; }) );
	
    self.actualSize     = ko.observable(null);
    self.details        = ko.observableArray([]);

    //methods
    self.createDetail   = function(size) {
        var item = {
            id          : ko.observable( '' ),
            size        : ko.observable( size ),
            detail      : ko.observable( '' ),
            detailen    : ko.observable( '' ),
            target      : ko.observable( 0 ),
            yoh         : ko.observable( 0 ),
            yog         : ko.observable( 0 ),
            yod         : ko.observable( 0 ),
            uoh         : ko.observable( 0 ),
            uog         : ko.observable( 0 ),
            uod         : ko.observable( 0 ),
            ush         : ko.observable( 0 ),
            usg         : ko.observable( 0 ),
            usd         : ko.observable( 0 ),
        };
        self.details.push(item);
    }
    self.removeDetail   = function($data) {
        self.details.remove($data);
    }
    self.printform      = function() {
        var printWin = window.open("about:blank", "_blank", "");
        printWin.document.writeln('<table width="100%" border="1" cellspacing="0" cellpadding="1">');
        printWin.document.writeln("<tr>");
        printWin.document.writeln("<th>Beden</th><th>Detay</th><th>Detail</th><th>Hedef</th><th>YOH</th><th>YOG</th><th>YOD</th><th>UOH</th><th>UOG</th><th>UOD</th><th>USH</th><th>USG</th><th>USD</th>");
        printWin.document.writeln("</tr>");
        self.details().forEach(function (det) {
            printWin.document.writeln("<tr>");
            printWin.document.write('<td>' + det.size() + '</td>' );
            printWin.document.write('<td>' + det.detail() + "</td>");
            printWin.document.write('<td>' + det.detailen() + "</td>");
            printWin.document.write('<td align="right">' + det.target() + "</td>");
            printWin.document.write('<td align="right">' + det.yoh() + "</td>");
            printWin.document.write('<td align="right">' + det.yog() + "</td>");
            printWin.document.write('<td align="right">' + det.yod() + "</td>");
            printWin.document.write('<td align="right">' + det.uoh() + "</td>");
            printWin.document.write('<td align="right">' + det.uog() + "</td>");
            printWin.document.write('<td align="right">' + det.uod() + "</td>");
            printWin.document.write('<td align="right">' + det.ush() + "</td>");
            printWin.document.write('<td align="right">' + det.usg() + "</td>");
            printWin.document.write('<td align="right">' + det.usd() + "</td>");
            printWin.document.writeln("</tr>");
        });
        printWin.document.writeln("</table>");
        printWin.print();
    }

    //events
    self.yo_change = function($data) {
        $data.yod( (parseFloat( $data.yoh().toString().replace(",",".") ) - parseFloat( $data.yog().toString().replace(",",".") )).toFixed(2) );
    }
    self.uo_change = function($data) {
        $data.uod( (parseFloat( $data.uoh().toString().replace(",",".") ) - parseFloat( $data.uog().toString().replace(",",".") )).toFixed(2) );
    }
    self.us_change = function($data) {
        $data.usd( (parseFloat( $data.ush().toString().replace(",",".") ) - parseFloat( $data.usg().toString().replace(",",".") )).toFixed(2) );
    }

    //init
    if ( window.measure_rows !== undefined && window.measure_rows.DATA.length > 0 ) {
        window.measure_rows.DATA.forEach(function (elm) {
            var item = {
                id          : ko.observable( elm[0] ),
                size        : ko.observable( elm[2] ),
                detail      : ko.observable( elm[3] ),
                detailen    : ko.observable( elm[4] ),
                target      : ko.observable( elm[5] ),
                yoh         : ko.observable( elm[6] ),
                yog         : ko.observable( elm[7] ),
                yod         : ko.observable( elm[8] ),
                uoh         : ko.observable( elm[9] ),
                uog         : ko.observable( elm[10] ),
                uod         : ko.observable( elm[11] ),
                ush         : ko.observable( elm[12] ),
                usg         : ko.observable( elm[13] ),
                usd         : ko.observable( elm[14] ),
            };
            self.details.push(item);
        });
    }

}(ko, jQuery);

ko.applyBindings(appMeasureForm, document.getElementById("frm_measure_sizes"));