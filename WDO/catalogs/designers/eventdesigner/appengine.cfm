<script type="text/javascript">

    ko.bindingHandlers.evSearchWidget = {
        init: function (element, valueAccessor, allBindings, viewModel) {
            var callback = valueAccessor();
            $(element).keyup(function (event) {
                /* var keyCode = (event.which ? event.which : event.keyCode);
                if (keyCode === 13) {
                    callback.call(viewModel);
                    return false;
                } */
                callback.call(viewModel);
                return true;
            });
        }
    };

    var eventApp = function( ko, jq ) {
        var self = this;

        self.eventType = <cfoutput>'#attributes.event_type#';</cfoutput>

        self.activeRow = ko.observable( null );
        self.activeMenu = ko.observable( null );
        self.activeItem = ko.observable( null );
        self.activeEventType = ko.observable( 'value' );
        self.activeEventList = ko.observableArray( [] );
        self.activeWidget = ko.observable( null );
        self.activeWidgetRef = ko.observable( null );
        self.keyword = ko.observable( '' );

        // METHODS
        self.createRow = function( row ) {
            return {
                listOfCols: ko.observableArray( row !== null ? row.listOfCols.map( 
                    function( col ) { 
                        return self.createCol( col ); 
                    } 
                ) : [] 
            )};
        };
        self.createCol = function( col ) {
            return {
                colsize: ko.observable( col !== null ? col.colsize : "4" ),
                listOfWidgets: ko.observableArray( col !== null ? col.listOfWidgets.map( 
                    function( widget ) { 
                        return self.createWidget( widget ); 
                    } 
                ) : []
            )};
        };
        self.createWidgetProps = function ( props ) {
            if ( props == undefined ) return [];
            var affected = 
                props.map( function( elm ) {
                    return {
                        type: elm.type,
                        value: elm.value,
                        valuedata: ko.observable( elm.valuedata != null ? elm.valuedata : '' ),
                        label: elm.label,
                        struct: elm.struct
                    }
                })
            ;
            return affected;
        };
        self.createCustomtag = function ( elm ) {
            return {
                type: ko.observable( elm != null ? elm.type : '' ),
                path: ko.observable( elm != null ? elm.path : '' ),
                tag: ko.observable( elm != null ? elm.tag : '' ),
                formula: ko.observable( elm != null ? elm.formula : '' ),
                value: ko.observable( elm != null ? elm.value : '' ),
                name: ko.observable( elm != null ? elm.name : '' ),
                params: ko.observable( elm != null ? elm.params : {} )
            };
        };
        self.createWidget = function( widget ) {
            return {
                title: widget !== null ? widget.title : '',
                version: widget !== null ? widget.version : '',
                id: widget !== null ? widget.id : '',
                uniqid: widget !== null && widget.uniqid !== undefined ? widget.uniqid : widget.id + "_" + Math.floor(Math.random() * 1000),
                tool: widget !== null && widget.tool !== undefined ? widget.tool : '',
                fuseaction: widget !== null && widget.fuseaction !== undefined ? widget.fuseaction : '',
                event: widget !== null ? widget.event : '',
                data: widget !== null ? widget.data : null,
                props: widget !== null && widget.props !== undefined ? self.createWidgetProps( widget.props ) : [],
                trigger: ko.observable( widget !== null && widget.trigger !== undefined ? widget.trigger : '' ),
                params: ko.observable( widget !== null && widget.params !== undefined ? widget.params : '' ),
                customtag: widget !== null && widget.customtag !== undefined && widget.customtag !== '' ? self.createCustomtag( widget.customtag ) : {}
            };
        };
        self.createModuleWidget = function( elm ) {
         
            return {
                module: { 
                    id: elm.module.id !== null ? elm.module.id : '',
                    title: elm.module.title !== null ? elm.module.title : '',
                    icon: elm.module.icon !== null ? elm.module.icon : ''
                },
                widget: elm.widget !== null ? elm.widget.map( (item) => { return self.createWidget( item ); } ) : ''
            }
            
        };

        // EVENTS

        self.getAllWidget = function() {
            return <cfoutput>#lcase( replace( serializeJSON( get_all_widgets( event: attributes.event_type ) ), "//", "") )#</cfoutput>
            .map( function( elm ){ return self.createModuleWidget( elm ) })
            .filter( function ( item ) {
                var widgetItems = item.widget.reduce((acc, widgetItem) => {
                    if( (new RegExp( self.keyword(), "gi" ).test( widgetItem.title )) || self.keyword() == '' ){
                        acc.push( widgetItem );
                    }
                    return acc;
                }, []);
                item.widget = widgetItems;
                return item;
            } )
            .filter( ( item ) => {
                return item.widget.length > 0;
            } );
        }

        self.getEventWidget = function () {
            return item = self.template.lofRows()
            .reduce( ( acc, rows ) => { return [ ...acc, ...rows.listOfCols() ] }, [] )
            .reduce( ( acc, cols ) => { return [ ...acc, ...cols.listOfWidgets() ] }, []);
        }

        self.lofWidgets = ko.observableArray( <cfoutput>#lcase( replace( serializeJSON( get_widgets( fuseaction: attributes.fuseact, event: attributes.event_type, version: attributes.version ) ), "//", "") )#</cfoutput>.map( function( elm ) { return self.createWidget( elm ); } ) );

        self.lofModuleWidgets = ko.observableArray( self.getAllWidget() );

        self.lofReadyObjects = ko.observableArray( <cfoutput>#lcase( replace( serializeJSON( get_ready_objects() ), "//", "") )#</cfoutput>.map( function( elm ) { return self.createWidget( elm ); } ) );

        self.searchWidget = function() { 
            self.lofModuleWidgets( self.getAllWidget() ); 
            if( self.keyword() != '' ) $(".module-widget .list-main").show();
            else $(".module-widget .list-main").hide();
        }

        self.newRow = function () {
            var row = self.createRow( null );
            self.template.lofRows.push( row );
            self.activeRow( row );
        };
        self.newCol = function () {
            self.activeRow().listOfCols.push( self.createCol(null) );
        };
        self.removeRow = function ( row ) {
            self.template.lofRows.remove( row );
            if ( self.template.lofRows().length > 0 ) {
                self.activeRow( self.template.lofRows()[0] );
            } else {
                self.activeRow( null );
            }
        }
        self.removeColumn = function ( col, parent ) {
            parent.listOfCols.remove(col);
        }
        self.removeWidget = function( widget, parent ) {
            parent.listOfWidgets.remove(widget);
        }
        self.hasRow = ko.computed( function() {
            return self.activeRow() != null;
        });
        self.newMenuElm = function () {
            self.template.lofTabs.push({
                id: Math.random().toString(36).substring(4),
                ismenu: ko.observable( false ),
                label: ko.observable( 'Menu' ),
                iconCss: ko.observable( '' ),
                place: ko.observable( '' ),
                type: ko.observable( '' ),
                popup: ko.observable( '' ),
                fuseaction: ko.observable( '' ),
                event: ko.observable( '' ),
                parameter: ko.observable( '' ) 
            });
        };
        self.createMenuElm = function ( elm ) {
            return {
                id: elm == undefined ? Math.random().toString(36).substring(4) : elm.id,
                ismenu: ko.observable( elm == undefined ? false : elm.ismenu ),
                label: ko.observable( elm == undefined ? 'Menu' : elm.label ),
                iconCss: ko.observable( elm == undefined ? '' : (elm.iconCss || '') ),
                place: ko.observable( elm == undefined ? '' : (elm.place || '') ),
                type: ko.observable( elm == undefined ? '' : elm.type ),
                fuseaction: ko.observable( elm == undefined ? '' : elm.fuseaction ),
                popup: ko.observable( elm == undefined ? '' : elm.popup ),
                event: ko.observable( elm == undefined ? '' : elm.event ),
                parameter: ko.observable( elm == undefined ? '' : elm.parameter )
            };
        };
        self.setActiveWidget = function (ref, parent) {

            self.activeWidgetRef( ref );

            self.activeWidget({
                event: ko.observable( ref.event ),
                id: ko.observable( ref.id ),
                uniqid: ko.observable( ref.uniqid ),
                title: ko.observable( ref.title ),
                version: ko.observable( ref.version ),
                tool: ko.observable( ref.tool ),
                props: ko.observableArray( ref.props ),
                trigger: ko.observable( ref.trigger !== undefined ? ref.trigger : '' ),
                resTrigger: ko.observableArray( [ { id: 0, title: 'Tetikleme Yok' }, ...self.getEventWidget().filter( ( el ) => { return el.id != ref.id } ) ] ),
                params: ko.observable( ref.params !== undefined ? ref.params : '' ),
                customtag: ko.observable( ref.customtag )
            });

        }

        self.commitActiveWidget = function() {
            self.activeWidgetRef().props = self.activeWidget().props();
            self.activeWidgetRef().trigger = self.activeWidget().trigger();
            self.activeWidgetRef().params = self.activeWidget().params();
            self.activeWidgetRef().customtag = self.activeWidget().customtag();
            alert("Widget has been saved successfuly!");
        }

        self.editMenuElm = function (elm) {
            self.activeMenu( Object.assign( {}, elm ) );
            self.activeEventType( 'value' );
        }

        self.commitMenu = function () {
            var tab = self.template.lofTabs().filter( function ( elm ) {
                return elm.id == self.activeMenu().id;
            })[0];
            Object.assign( tab, self.activeMenu() );
            alert("Menu item has been saved successfuly!");
        }

        self.deleteMenu = function() {
            if ( confirm( "Are you sure?" ) ) {
                var tab = self.template.lofTabs().filter( function ( elm ) {
                    return elm.id == self.activeMenu().id;
                })[0];
                self.template.lofTabs.remove(tab);
                self.activeMenu( null );
            }
        }

        self.moveupMenu = function( idx ) {
            if ( idx > 0 ) {
                var rawParent = self.template.lofTabs();
                self.template.lofTabs.splice( idx-1, 2, rawParent[idx], rawParent[idx-1] );
            }
        }

        self.initialize = function () {
            <cfset applayout = get_layout( attributes.id )>
            <cfif not isNull(applayout) && len(applayout)>
            var tmp = <cfoutput>#applayout#</cfoutput>;
            self.template.lofRows( tmp.lofRows.map( function( elm ) { return self.createRow( elm ) } ) );
            self.template.masterWidget( tmp.masterWidget );
            if ( tmp.lofTabs !== undefined ) {
                self.template.lofTabs( tmp.lofTabs.map( function( elm ) { return self.createMenuElm( elm ) } ) );
            }
            </cfif>
        }

        //OBJECTS
        self.viewMode = ko.observable( 'editor' );
        self.jsonEditor = new JSONEditor(document.getElementById("jsoneditor"),
        {
            mode: 'tree',
            modes: ['code', 'form', 'text', 'tree', 'view']
        });

        self.template = {
            masterWidget: ko.observable( '' ),
            lofRows: ko.observableArray( [] ),
            lofTabs: ko.observableArray( [] )
        };
        
        self.masterWidget = ko.observable( '' );
        self.masterWidgetListSource = ko.computed(function () {
            var items = ko.toJS(self.template.lofRows).reduce(function (a, c) {
                return [...a, ...c.listOfCols];
            }, [])
            .reduce(function (a, c) {
                return [...a, ...c.listOfWidgets];
            }, [])
            .filter(function (item) {
                return item.tool != 'readyobject';
            });
            return items;
        });

        self.setLang = function (module,id,name,langId) {
            self.activeItem(langId + '.' + name);
            self.activeItem = null;
        }

        self.iconcss = function (css) {
            self.activeItem(css);
            self.activeItem = null;
        }

        self.self.widgetDropped = function(item, sourceIndex, sourceItems, targetIndex, targetItems) {
            var elm = Object.assign( {}, ko.toJS(item) );
            elm = createWidget( elm );
            elm.uniqid = elm.id + "_" + Math.floor(Math.random() * 1000);
            targetItems.splice( targetIndex, 1, elm );
        }

        // endpoint
        return {
            init: function() {
                self.initialize();
                ko.applyBindings( self, document.getElementById( "appLayout" ) );
            },
            save: function () {
                var mwidget = self.template.masterWidget();
                if( mwidget != undefined && mwidget != null && mwidget != '' ){
                    jq.ajax({
                        url: '<cfoutput>#request.self#?#replace( cgi.QUERY_STRING, "&event=upd", "&mode=setlayout" )#</cfoutput>&isAjax=1',
                        method: 'post',
                        dataType: 'Json',
                        data: { layout: ko.toJSON( self.template ) }
                    }).done( function ( result ) {
                        if( result.status ){
                            alertify.success( result.message );
                            location.reload();
                        }else alertify.error( result.message );
                    })
                }else{
                    alert("Please chooes a master widget!");
                    return false;
                }
            },
            setFact: function(value) {
                self.activeItem.fuseaction(value);
                jq.ajax({
                    url: '<cfoutput>#request.self#?#replace( cgi.QUERY_STRING, "&event=upd", "&mode=listevents" )#</cfoutput>&isAjax=1',
                    method: 'post',
                    data: { fromfuse: value }
                }).done( function( result )
                {
                    var jresult = JSON.parse(result);
                    self.activeEventType( jresult.TYPE ); 
                    if (jresult.TYPE == "list") {
                        self.activeEventList( jresult.RESULTLIST );
                    } else if (jresult.TYPE == "value") {
                        self.activeEventList( [] );
                        self.activeMenu().event("");
                    }
                });
            },
            setValue: function(value) {
                self.activeItem( value );
            },
            getMasterWidgetId: function() {
                var mwidget = self.template.masterWidget();
                if (mwidget != null && mwidget != "") {
                    try {
                        return self.lofWidgets().filter( function(elm) {
                            return mwidget == elm.id;
                        })[0].id;
                    } catch (exc) {
                        console.log(exc);
                        return null;
                    }
                } else {
                    return null;
                }
            },
            showJSON: function() {
                self.viewMode( 'json' );
                self.jsonEditor.set( JSON.parse( ko.toJSON( self.template.lofRows ) ) );
                return true;
            },
            showEditor: function () {
                self.viewMode( 'editor' );
                return true;
            },
            showMenu: function () {
                self.viewMode( 'menu' );
                return true;
            }
        }
    }( ko, jQuery );
    eventApp.init();

    function setFieldValue(val) {
        eventApp.setValue(val);
    }

    function getFieldValue(types, defaultValue = "") {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_systemPopup' + (types !== undefined ? "&types=" + types + "&fromwidget=" + ( eventApp.getMasterWidgetId() != null ? eventApp.getMasterWidgetId() : '' ) : "") + '&defaultValue=' + defaultValue, 'wide');
    }

    function setFact(value = '') {
        eventApp.setFact(value);
    }

    function getFact() {
        openBoxDraggable('index.cfm?fuseaction=process.popup_dsp_faction_list&function=setFact&is_upd=0&choice=1');
    }

    function kontrol() {
        eventApp.save();
        return false;
    }
</script>