<script type="text/javascript">
    function tabManager () {
        this.tabs = {
            template: 0,
            pages: 1,
            system: 2,
            model: 3
        };
        this.activeTab = ko.observable( this.tabs.template );
        this.activateTab = function ( tab ) {
            this.activeTab( tab );
        };
        this.visibleTab = function( tab ) {
            return this.activeTab() == tab;
        };
    }
</script>

<script type="text/javascript">
    var printApp = function(ko, jq) {
        var self = this;

        /**
         * Tab manager for side tabs
         */
        self.tabManager = new tabManager();

        /**
         * Constants
         */
        self.consts = {
            documentsize: {
                A4: { name: "A4", width: 595, height: 842 },
                A5: { name: "A5", width: 420, height: 595 },
                A3: { name: "A3", width: 842, height: 1191 }
            },
            measures: {
                Millimeter: { symbol: "mm", factor: 595/210 },
                Inch: { symbol: "in", factor: 595/8.3 },
                Pixel: { symbol: "px", factor: 1 }
            },
            eventTypes: {
                update: 0,
                list: 1,
                dash: 2
            }
        };

        /**
         * Lists
         */
        self.lists = {
            sizes: (() => Object.values(self.consts.documentsize).map(m => m.name))(),
            measures: (() => Object.keys(self.consts.measures).map(m => { return { text: m, id: self.consts.measures[m].symbol }} ))()
        };

        /**
         * Document settings
         */
        self.settings = {
            templateName: ko.observable( "" ),
            size: ko.observable( self.consts.documentsize.A4.name ),
            measure: ko.observable( self.consts.measures.Millimeter ),
            width: ko.observable( self.consts.documentsize.A4.width ),
            height: ko.observable( self.consts.documentsize.A4.height ),
            eventType: ko.observable( self.consts.eventTypes.list ),
            topMargin: ko.observable( 0 ),
            bottomMargin: ko.observable( 0 ),
            headerHeight: ko.observable( 0 ),
            footerHeight: ko.observable( 0 ),
            notes: ko.observable("")
        };

        /**
         * Subscription for re-calculation
         */
        self.settings.size.subscribe( function( newValue ) {
            var selectedSize = Object.values(self.consts.documentsize).filter( f => f.name == newValue )[0];
            self.settings.width( selectedSize.width );
            self.settings.height( selectedSize.height );
        });

        /**
         * Pages
         */
        self.pages = ko.observableArray([]);


        return {
            init: function() {
                ko.applyBindings(self, document.getElementById("printLayout"));
            }
        }
    }(ko, jQuery);
</script>
<script type="text/javascript">
    jQuery(document).ready(function() {
        printApp.init();
    });
</script>