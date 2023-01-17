<script type="text/javascript">

    ko.bindingHandlers.uiResizable = {
        init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            var value = valueAccessor();
            interact(element).resizable({
                edges: {
                    top: false,
                    left: false,
                    bottom: true,
                    right: true
                },
                modifiers: [
                    interact.modifiers.restrictEdges({
                        outer: 'parent',
                        endOnly: true,
                    }),
                ]
            }).on('resizemove', function(event) {
                if (value.dataitem.height !== undefined)
                    if ($(element).children().outerHeight() <= event.rect.height) {
                        value.dataitem.height( parseFloat( event.rect.height ) );
                    }

                if (value.dataitem.width !== undefined)
                    if ($(element).children().outerWidth() <= event.rect.width) {
                        value.dataitem.width( parseFloat( event.rect.width ) );
                        console.log(event.rect.width);
                    }
            });
        },
        update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            var value = valueAccessor();
            if (value.dataitem.height !== undefined)
                $(element).css('height', value.dataitem.height().toFixed() + 'px');
            if (value.dataitem.width !== undefined)
                $(element).css('width', value.dataitem.width().toFixed() + 'px');
        }
    };

    ko.bindingHandlers.uiDragable = {
        init: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            var value = valueAccessor();
            interact(element).draggable({
                listeners: {
                    move: function (event) {
                        if (value.dataitem.top !== undefined)
                            if (value.dataitem.top() + event.dy < 0) {
                                value.dataitem.top(0);
                            } else if (value.dataitem.top() + event.dy + value.dataitem.height() >= $(element).parent().height()) {
                            } else {
                                value.dataitem.top( value.dataitem.top() + event.dy );
                            }
                        if (value.dataitem.left !== undefined)
                            if (value.dataitem.left() + event.dx < 0) {
                                value.dataitem.left(0);
                            } else if (value.dataitem.left() + event.dx + value.dataitem.width() >= $(element).parent().width()) {
                            } else {
                                value.dataitem.left( value.dataitem.left() + event.dx );
                            }
                    }
                }
            });
        },
        update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            var value = valueAccessor();
            if (value.dataitem.top !== undefined)
                $(element).css('top', value.dataitem.top().toFixed() + 'px');
            if (value.dataitem.left !== undefined)
                $(element).css('left', value.dataitem.left().toFixed() + 'px');
        }

    }

    var printApp = function(ko, jq) {
        var self = this;

        self.printermmfactor = 100/72;

        //sizefactors
        self.sizeFactors = {
            mm: 0.352941,
            inc: 0.01395
        };

        //domain model
        self.domainModel = <cfoutput><cfif len( attributes.modeldata )>#attributes.modeldata#<cfelse>'[]'</cfif></cfoutput>;
        
        //app layout
        self.appLayout = {
            reportHeader: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            pageHeader: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            groupHeader: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            header: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            body: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            footer: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            groupFooter: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            pageFooter: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            reportFooter: {
                items: ko.observableArray([]),
                height: ko.observable(20)
            },
            settings: {
                templateName: ko.observable(''),
                sizeMode: ko.observable( 'mm' ),
                paperSize: {
                    width: ko.observable( 210 ),
                    height: ko.observable( 297 ),
                },
                margins: {
                    top: ko.observable( 40 ),
                    right: ko.observable( 40 ),
                    bottom: ko.observable( 40 ),
                    left: ko.observable( 40 )
                },
                background: {
                    image: ko.observable( '' ),
                    visible: ko.observable( false ),
                    size: {
                        width: ko.observable( 210 ),
                        height: ko.observable( 297 )
                    },
                    offset: {
                        x: ko.observable( 0 ),
                        y: ko.observable( 0 )
                    }
                }
                showGrid: ko.observable( false ),
                
            }
        };

        //editor state
        self.state = {
            zoom: ko.observable( 1 ),
            showPropertyBox: ko.observable( true )
        };

        /**
         * Paper infos
         */
        self.papers = {};

        //A4 Portraid
        self.papers.A4 = {
            Portraid: {
                width: 594,
                height: 841
            }
        };

        /**
         * Types
         */

        //object
        self.createObject = function( vars ) {
            return {
                border: ko.observable( vars !== null && vars.border !== undefined ? vars.border : '1px solid #000' ),
                top: ko.observable( vars !== null && vars.top !== undefined ? vars.top : 0 ),
                left: ko.observable( vars !== null && vars.left !== undefined ? vars.left : 0 ),
                width: ko.observable( vars !== null && vars.width !== undefined ? vars.width : 140 ),
                height: ko.observable( vars !== null && vars.height !== undefined ? vars.height : 31 )
            };
        };
        //dataObject
        self.createDataObject = function( vars ) {
            return {
                fieldName: ko.observable( vars.fieldName ),
                structName: ko.observable( vars.structName ),
                format: ko.observable( vars.format )
            };
        };
        //label
        self.createLabel = function( vars ) {
            var object = self.createObject( vars );
            var label = {
                label: ko.observable( vars !== null && vars.label !== undefined ? vars.label : 'untitled' ),
                fontSize: ko.observable( vars !== null && vars.fontSize !== undefined ? vars.fontSize : '12pt' ),
                fontFamily: ko.observable( vars !== null && vars.fontFamily !== undefined ? vars.fontFamily : 'Arial' ),
                fontWeight: ko.observable( vars !== null && vars.fontWeight !== undefined ? vars.fontWeight : 'normal' ),
                textAlign: ko.observable( vars !== null && vars.textAlign !== undefined ? vars.textAlign : 'left' ),
                textDecoration: ko.observable( vars !== null && vars.textDecoration !== undefined ? vars.textDecoration : 'none' ),
                multiline: ko.observable( vars !== null && vars.multiline !== undefined ? vars.multiline : false )
            };
            return Object.assign({}, object, label);
        };
        //dataLabel
        self.createDataLabel = function( vars ) {
            var label = self.createLabel( vars );
            var data = self.createDataObject( vars );
            return Object.assign({}, label, data);
        };

        /**
         * Methods
         */
        
        //page margins
        self.pageMarginTop = ko.computed(function() {
            return (self.appLayout.settings.margins.top() * 10).toFixed() + 'px';
        });
        self.pageMarginRight = ko.computed(function() {
            return (self.appLayout.settings.margins.right() * 10).toFixed() + 'px';
        });
        self.pageMarginBottom = ko.computed(function() {
            return (self.appLayout.settings.margins.bottom() * 10).toFixed() + 'px';
        });
        self.pageMarginLeft = ko.computed(function() {
            return (self.appLayout.settings.margins.left() * 10).toFixed() + 'px';
        });
        
        //page size
        self.pageSizeStyle = ko.computed(function () {
            return {
                width: (self.papers[self.appLayout.settings.paperSize()][self.appLayout.settings.paperOriantation()].width * printermmfactor).toFixed(0) + 'px',
                marginLeft: 'calc(50% - ' + (self.papers[self.appLayout.settings.paperSize()][self.appLayout.settings.paperOriantation()].width * printermmfactor / 2).toFixed(0) + 'px)',
                maxHeight: (self.papers[self.appLayout.settings.paperSize()][self.appLayout.settings.paperOriantation()].height * printermmfactor).toFixed(0) + 'px'
            };
        });

        //rulers
        self.rulerXSize = ko.computed(function() {
            var xwidth = ((self.papers[self.appLayout.settings.paperSize()][self.appLayout.settings.paperOriantation()].width * printermmfactor) - (self.appLayout.settings.margins.right() * 10) - (self.appLayout.settings.margins.left() * 10));
            return {
                width: xwidth.toFixed(0) + 'px',
                x: (self.appLayout.settings.margins.left() * 10).toFixed(0) + 'px'
            }
        });

        /**
         * Events
         */

        //field dropped
        self.fieldDropped = function(item, sourceIndex, sourceItems, targetIndex, targetItems) {
            var elm = self.createDataLabel( {
                fieldName: item.label,
                structName: item.struct,
                format: '',
                label: item.label
            } );
            targetItems.splice( targetIndex, 1, elm );
        }

        self.onDrakeMoves = function (el, source, handle, sibling) { 
            return jq(el).closest(".struct-body").length > 0;
        }


         /**
          * Constructors
          */

        return {
            init: function( element ) {
                ko.applyBindings( self, element );
                
            }
        }

    }(ko, jQuery);

    function printAppFuse() {
        if (window.interact !== undefined) {
            printApp.init( document.getElementById('appDesignBlock') );        
        } else {
            setTimeout(() => {
                printAppFuse();
            }, 500);
        }
    }

    $(document).ready(function() {
        printAppFuse();

        /*
        $(".paper-block").selectable({
            filter: '.ui-resizable',
            selected: function(event, ui) {
                console.log(ui.selected);
                //$(ui.selected).parent().closest(".ui-selected").removeClass("ui-selected");
                $(ui.selected).resizable("enable");
            },
            unselected: function(event, ui) {
                $(ui.unselected).resizable("disable");
            }
        });

        $(".draggable-field-source").draggable({
            helper: "clone",
            revert: true,

        });
        */
        $(".body-block").on("click", ".body-field-container", function(event) {
            
        });
    })
</script>