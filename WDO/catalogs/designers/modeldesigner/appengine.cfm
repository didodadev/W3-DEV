<cfset wrkobj = obj_uses( attributes.fuseact )>
<script type="text/javascript"> 
    window.createValue = function () {
        return {
            value: ko.observable( '' ),
            valueName: ko.observable( '' )
        };
    }
    ko.bindingHandlers.arrayvalue = {
        init: function ( element, valueAccessor, allBindingsAccessor, viewModel, bindingContext ) {
            jQuery( element ).change( function () {
                valueAccessor()( jQuery( this ).val().split( ',' ).map( function(elm) { return { value: elm.trim(), valueName: '' }; } ) );
            });
        },
        update: function( element, valueAccessor, allBindings, viewModel, bindingContext ) {
            var value = ko.unwrap( valueAccessor );
            jQuery( element ).val( value()().join() );
        }
    };
    ko.bindingHandlers.arrayobjectvalue = {
        init: function ( element, valueAccessor, allBindingsAccessor, viewModel, bindingContext ) {
            var valueAccess = ko.unwrap( valueAccessor() );
            var dataAccessor = valueAccess.data;
            var prop = valueAccess.prop;
            jQuery( element ).change(function () {
                dataAccessor( jQuery( this ).val().split( ',' ).map( function( elm ) { 
                    var val = window.createValue();
                    val[ prop ]( elm );
                    return val; 
                } ) );
            });
        },
        update: function(element, valueAccessor, allBindings, viewModel, bindingContext) {
            var valueAccess = ko.unwrap( valueAccessor() );
            var dataAccessor = valueAccess.data;
            var prop = valueAccess.prop;
            jQuery( element ).val( dataAccessor().map( function (elm) { return elm[prop](); } ).join() );
        }
    }
    
    ko.validation.rules[ 'methodRequired' ] = {
        validator: function ( val ) {
            return val.value !== "";
        },
        message: "Field required!"
    };
    ko.validation.registerExtenders();

    var app = function( ko, jq ) {
        var self = this;

        //arguments
        <cfoutput>
        self.useProcessCat = #iif( len(wrkobj.USE_PROCESS_CAT), "wrkobj.USE_PROCESS_CAT", de("0") )#;
        self.useSystemNo = #iif( len(wrkobj.USE_SYSTEM_NO), "wrkobj.USE_SYSTEM_NO", de("0") )#;
        self.useWorkflow = #iif( len(wrkobj.USE_WORKFLOW), "wrkobj.USE_WORKFLOW", de("0") )#;
        </cfoutput>

        self.viewMode = ko.observable( "editor" );
        self.jsonEditor = new JSONEditor( document.getElementById( "jsoneditor" ), {
            mode: 'tree',
            modes: ['code', 'form', 'text', 'tree', 'view']
            });

        //structs
        self.structCompositor = ko.observableArray( [] );

        self.createStruct = function( struct ) {
            var elm = {
                name : ko.observable( struct === null ? "" : struct.name ).extend({ required: true, minLength: 3, pattern: { message: "Must begin char and no spacing", params: '^[A-Za-z]+[A-Za-z0-9\._:\"\']*$' } }),
                langNo : ko.observable( struct === null ? "" : struct.langNo ),
                structType : ko.observable( struct === null ? "" : struct.structType ),
                method : ko.observable( struct === null ? { value: "" } : struct.method ),
                relation : ko.observable( struct === null ? "" : struct.relation ),
                template : ko.observable( struct === null ? "Default" : struct.template ),
                listOfElements : ko.observableArray( struct === null || struct.listOfElements.length === 0 ? [] : struct.listOfElements.map(self.createElement) ),
                listOfConditions : ko.observableArray( struct === null || struct.listOfConditions.length === 0 ? [] : struct.listOfConditions.map(self.createCondition) ),
                listOfSummaries : ko.observableArray( struct === null || struct.listOfSummaries.length === 0 ? [] : struct.listOfSummaries.map(self.createSummary) ),
                listOfProperties : ko.observableArray( struct === null || struct.listOfProperties === undefined || struct.listOfProperties.length === 0 ? [] : struct.listOfProperties.map( self.createProperty ) )
            };
            elm.elementsSetAdd = function ( state ) {
                elm.listOfElements().forEach( function( val ) {
                    val.devAdd( state );
                });
                return true;
            };
            elm.elementsAllAdd = ko.computed( function() {
                return elm.listOfElements().reduce( function( acc, val ) {
                    return acc && val.devAdd();
                }, elm.listOfElements().length > 0 );
            });
            elm.elementsSetUpdate = function ( state ) {
                elm.listOfElements().forEach( function ( val ) {
                    val.devUpdate( state );
                });
                return true;
            }
            elm.elementsAllUpdate = ko.computed( function() {
                return elm.listOfElements().reduce( function ( acc, val ) {
                    return acc && val.devUpdate();
                }, elm.listOfElements().length > 0);
            });
            elm.elementsSetList = function ( state ) {
                elm.listOfElements().forEach( function ( val ) {
                    val.devList( state );
                });
                return true;
            }
            elm.elementsAllList = ko.computed( function() {
                return elm.listOfElements().reduce( function ( acc, val ) {
                    return acc && val.devList();
                }, elm.listOfElements().length > 0);
            });
            elm.elementsSetSearch = function ( state ) {
                elm.listOfElements().forEach( function ( val ) {
                    val.devSearch( state );
                });
                return true;
            }
            elm.elementsAllSearch = ko.computed( function() {
                return elm.listOfElements().reduce( function ( acc, val ) {
                    return acc && val.devSearch();
                },  elm.listOfElements().length > 0);
            });
            elm.elementsSetDash = function ( state ) {
                elm.listOfElements().forEach( function ( val ) {
                    val.devDash( state );
                });
                return true;
            }
            elm.elementsAllDash = ko.computed( function() {
                return elm.listOfElements().reduce( function ( acc, val ) {
                    return acc && val.devDash();
                }, elm.listOfElements().length > 0);
            });
            elm.dataTypeChanged = function( obj, event ) {
                if ( event.originalEvent ) {
                    self.setFixedElements( elm );
                }
            }
            elm.aliasList = ko.computed(function() {
                return elm.listOfElements().reduce( function ( acc, val ) {
                    if (val.devDBField().alias !== undefined && val.devDBField().alias() != "" && acc.indexOf(val.devDBField().alias()) < 0) {
                        acc.push(val.devDBField().alias());
                    }
                    return acc;
                }, []
                ).concat(
                    elm.listOfConditions().reduce( function ( acc, val ) {
                        if (val.left().alias !== undefined && val.left().alias() == "db" && acc.indexOf(val.left().alias()) < 0) {
                            acc.push(val.left().alias());
                        }
                        if (val.right().alias !== undefined && val.right().alias() == "db" && acc.indexOf(val.right().alias()) < 0) {
                            acc.push(val.right().alias());
                        }
                        return acc;
                }, []
                ).concat(
                    elm.listOfProperties().reduce( function( acc, val ) {
                        val.listOfConditions().forEach(function(item) {
                            if (item.left().alias !== undefined && item.left().alias() == "db" && acc.indexOf(item.left().alias()) < 0) {
                                acc.push(item.left().alias());
                            }
                        });
                        return acc;
                    }, []
                    )
                )
                );
            });
            elm.aliasTables = ko.computed(function() {
                return elm.listOfElements().reduce( function ( acc, val ) {
                    if (val.devDBField().alias !== undefined && val.devDBField().alias() != "" && acc.filter(function( itm ) { return val.devDBField().alias() == itm.alias }).length == 0) {
                        acc.push({
                            alias: val.devDBField().alias(),
                            table: val.devDBField().table(),
                            scheme: val.devDBField().scheme()
                        });
                    }
                    return acc;
                }, []).concat(
                    elm.listOfConditions().reduce( function ( acc, val ) {
                        if (val.left().alias !== undefined && val.left().alias() != "" && acc.filter(function ( itm ) { return val.left().alias() == itm.alias }).length == 0) {
                            acc.push({
                                alias: val.left().alias(),
                                table: val.left().table(),
                                scheme: val.left().scheme()
                            });
                        }
                        if (val.right().alias !== undefined && val.right().alias() != "" && acc.filter(function ( itm ) { return val.right().alias() == itm.alias }).length == 0) {
                            acc.push({
                                alias: val.right().alias(),
                                table: val.right().table(),
                                scheme: val.right().table()
                            });
                        }
                        return acc;
                    }, [])
                ).concat(
                    elm.listOfProperties().reduce( function( acc, val ) {
                        val.listOfConditions().forEach(function(item) {
                            if (item.left().alias !== undefined && item.left().alias() == "db" && acc.indexOf(item.left().alias()) < 0) {
                                acc.push({
                                    alias: item.left().alias(),
                                    table: item.left().table(),
                                    scheme: item.left().scheme()
                                });
                            }
                        });
                        return acc;
                    }, [])
                );
            });
            return elm;
        };
        self.addStruct = function() {
            self.structCompositor.push( self.createStruct( null ) );
        };
        self.removeStruct = function( struct, event ) {
            if ( confirm( "Are you sure?" ) )
            {
                jq(event.target).parent().parent().parent().parent().addClass( "fadeOutUp" );
                setTimeout( function () {
                    self.structCompositor.remove( struct );
                }, 500);
            }
        }
        self.relations = function ( data ) {
            var items = [""];
            self.structCompositor().forEach( struct => {
                if ( struct.name() !== data.name() ) {
                    struct.listOfElements().forEach( element => {
                        items.push( struct.name() + "." + element.label() );
                    });
                }
            });
            return items;
        };

        //elements
        self.createElement = function( element ) {
            return {
                label : ko.observable( element === null ? "" : element.label ).extend({ required: true, minLength: 2, pattern: { message: "Must begin char", params: '^[A-Za-z]+[A-Za-z0-9\._:\"\']*$' } }),
                langNo : ko.observable( element === null ? "" : element.langNo ),
                fieldType : ko.observable( element === null ? "" : element.fieldType ),
                dataType : ko.observable( element === null ? "" : element.dataType ),
                isKey : ko.observable( element === null ? false : element.isKey ),
                isDefault : ko.observable( element === null ? false : element.isDefault ),
                isRequired : ko.observable( element === null ? false : element.isRequired ),
                minSize : ko.observable( element === null ? "" : element.minSize ),
                maxSize : ko.observable( element === null ? "" : element.maxSize ),
                floatSize : ko.observable( element == null || element.floatSize == undefined ? "" : element.floatSize ),
                devValue : ko.observable( element === null ? { value: "" } : element.devValue ),
                devDBField : ko.observable( element === null ? { value: "", alias: ko.observable("") } : self.createDBField( element.devDBField ) ),
                devMethod : ko.observable( element === null ? { value: "" } : element.devMethod ),
                devIFMethod : ko.observable( element === null ? { value: "" } : element.devIFMethod ),
                devAutocomplete : ko.observable( element === null ? { value: "" } : element.devAutocomplete ),
                devJS : ko.observable( element === null ? { value: "" } : element.devJS ),
                devLink : ko.observable( element === null ? { value: "" } : element.devLink ),
                devCSS : ko.observable( element === null ? { value: "" } : element.devCSS ),
                devAdd : ko.observable( element === null ? false : element.devAdd ),
                devUpdate : ko.observable( element === null ? false : element.devUpdate ),
                devList : ko.observable( element === null ? false : element.devList ),
                devDash : ko.observable( element === null || element.devDash == undefined ? "" : element.devDash ),
                formula : ko.observable( element === null || element.formula == undefined ? "" : element.formula ),
                devSearch : ko.observable( element === null || element.devSearch == undefined ? "" : element.devSearch ),
                listValueIndex: ko.observable( element === null || element.listValueIndex == undefined ? "" : element.listValueIndex ) ,
                listDisplayIndex: ko.observable( element === null || element.listDisplayIndex == undefined ? "" : element.listDisplayIndex ) ,
                listOfPropertyMaps: ko.observableArray( element === null || element.listOfPropertyMaps == undefined || element.listOfPropertyMaps.length == 0 ? [] : element.listOfPropertyMaps.map( self.createElementPropertyMap ) ),
                includeAdd : ko.observable( element === null || element.includeAdd == undefined ? true : element.includeAdd ),
                includeUpdate : ko.observable( element === null || element.includeUpdate == undefined ? true : element.includeUpdate ),
                isFixed: ko.observable( false ),
                filterAsRange: ko.observable( element === null || element.filterAsRange == undefined ? false : element.filterAsRange ),
                dataCompute: ko.observable( element === null || element.dataCompute == undefined ? "" : element.dataCompute ),
                dataComputeFormula: ko.observable( element === null || element.dataComputeFormula == undefined ? "" : element.dataComputeFormula ),
            };
        };
        self.addElement = function( parent ) {
            parent.listOfElements.push( self.createElement( null ) );
        };
        self.removeElement = function( parent, item, event ) {
            if ( confirm( "Are you sure?" ) ){
                jq( event.target ).parent().parent().parent().addClass( "fadeOutLeft" );
                setTimeout( function() {
                    parent.listOfElements.remove( item );
                }, 500);
            }
        };
        self.createElementPropertyMap = function ( propertyMap ) {
            return {
                type: ko.observable( propertyMap === null ? '' : propertyMap.type ),
                propertyName: ko.observable( propertyMap === null ? '' : propertyMap.propertyName )
            };
        }
        self.createDBField = function ( element ) {
            var elm = {
                table: ko.observable( element === null ? "" : element.table ),
                scheme: ko.observable( element === null ? "" : element.scheme ),
                fieldType: ko.observable( element === null ? "" : element.fieldType ),
                field : ko.observable( element === null ? "" : element.field ),
                alias: ko.observable( element === null ? "" : ( element.alias === undefined ? "" : element.alias ) ),
                type: ko.observable( element === null ? "" : element.type )
            };
            elm.value = ko.computed(function() {
                if (elm.type() !== undefined) {
                    return elm.type().toUpperCase() + "=>" + elm.table() + "." + elm.field();
                } else {
                    return "";
                }
            });
            return elm;
        }
        self.addElementPropertyMap = function ( parent, propertyMap ) {
            parent.push( self.createElementPropertyMap( propertyMap ) );
        }
        self.removeElementPropertyMap = function ( parent, propertyMap ) {
            if (confirm("Are you sure?")) {
                jq( event.target ).parent().parent().parent().addClass( "fadeOutLeft" );
                setTimeout( function() {
                    parent.listOfPropertyMaps.remove( propertyMap );
                }, 500);
            }
        }

        //conditions
        self.hasExpression = function ( condition ) {
            return condition.type() === "Expression";
        }

        self.createCondition = function ( condition ) {
            var cond = {
                type : ko.observable( condition === null ? "" : condition.type ),
                oper : ko.observable( condition === null ? "AND" : condition.oper ),
                isAdd : ko.observable( condition === null ? false : condition.isAdd ),
                isUpd : ko.observable( condition === null ? false : condition.isUpd ),
                isList : ko.observable( condition === null ? false : condition.isList ),
                join : ko.observable( condition === null ? false : condition.join ),
            };
            cond.left = ko.observable( condition === null ? self.createDBField(null) : self.createDBField( condition.left ) );
            cond.comparison = ko.observable( condition === null ? "" : condition.comparison );
            cond.right = ko.observable( condition === null ? { value: "" } : ( condition.right.type == "db" ? self.createDBField( condition.right ) : condition.right ) );
            return cond;
        }

        self.addCondition = function ( parent ) {
            parent.listOfConditions.push( self.createCondition( null ) );
        }
        self.removeCondition = function ( parent, condition, event ) {
            if ( confirm( "Are you sure?" ) ) {
                jq( event.target).parent().parent().parent().addClass( "fadeOutLeft" );
                setTimeout( function() {
                    parent.listOfConditions.remove( condition );
                }, 500);
            }
        }

        //summaries
        self.createSummary = function ( summary ) {
            return {
                type : ko.observable( summary === null ? "" : summary.type ),
                field : ko.observable( summary === null ? "" : summary.field ),
                label : ko.observable( summary === null ? "" : summary.label ),
                langNo : ko.observable( summary === null ? "" : summary.langNo ),
                groupby : ko.observable( summary === null ? "" : summary.groupby ),
                DBField : ko.observable( summary === null ? { value: "" } : summary.DBField ),
                dataType : ko.observable( summary === null ? "" : summary.dataType )
            }
        }

        self.addSummary = function ( parent ) {
            parent.listOfSummaries.push( self.createSummary( null ) );
        }
        self.removeSummary = function ( parent, summary, event ) {
            if ( confirm( "Are you sure?" ) )
            {
                jq( event.target ).parent().parent().parent().addClass( "fadeOutLeft" );
                setTimeout(function () {
                    parent.listOfSummaries.remove( summary );
                }, 500);
            }
        }
        self.summaryFieldList = function ( parent ) {
            return [""].concat( parent.listOfElements().map( el => { return el.label; } ) );
        }

        //dynamic properties
        self.createProperty = function( property ) {
            return {
                label : ko.observable( property === null ? "" : property.label ),
                langNo : ko.observable( property === null ? "" : property.langNo ),
                type: ko.observable( property === null ? "" : property.type ),
                value: ko.observableArray( property === null ? [] : property.value.map( function( elm ) { return { value: ko.observable( elm.value ), valueName: ko.observable( elm.valueName ) }; } ) ),
                help: ko.observable( property === null ? "" : property.help ),
                isAdd: ko.observable( property === null ? false : property.isAdd ),
                isUpdate: ko.observable( property === null ? false : property.isUpdate ),
                isList: ko.observable( property === null ? false : property.isList ),
                isSearch: ko.observable( property === null ? false : property.isSearch ),
                listOfConditions: ko.observableArray( property === null || property.listOfConditions.length == 0 ? [] : property.listOfConditions.map( self.createPropertyCondition ) )
            };
        }
        self.createPropertyCondition = function( condition ) {
            var cond = {
                type: ko.observable( condition === null ? "" : condition.type ),
                oper: ko.observable( condition === null ? "" : condition.oper )
            };
            cond.left = ko.observable( condition === null ? self.createDBField(null) : self.createDBField(condition.left) );
            cond.comparison = ko.observable( condition === null ? "" : condition.comparison );
            return cond;
        }
        self.addProperty = function( parent ) {
            parent.listOfProperties.push( self.createProperty( null ) );
        }
        self.removeProperty = function( parent, data ) {
            if ( confirm( "Are you sure?" ) ) {
                jq(event.target).parent().parent().parent().addClass( "fadeOutLeft" );
                setTimeout( function () {
                    parent.listOfProperties.remove( data );
                }, 500);
            }
        }
        self.addPropertyValue = function( parent ) {
            parent.push( window.createValue() );
        }
        self.removePropertyValue = function ( parent, data ) {
            parent.value.remove( data );
        }
        self.addPropertyCondition = function( parent, data ) {
            parent.push( self.createCondition( data ) );
        }
        self.removePropertyCondition = function( parent, data ) {
            if ( confirm( "Are you sure?" ) ) {
                jq( event.target ).parent().parent().parent().addClass( "fadeOutLeft" );
                setTimeout(function () {
                    parent.listOfConditions.remove( data );
                }, 500);         
            }
        }

        //common
        self.moveDown = function ( parent, idx ) {
            if (idx < parent().length - 1)
            {
                var rawParent = parent();
                parent.splice( idx, 2, rawParent[idx + 1], rawParent[idx] );
            } 
        }
        self.moveUp = function ( parent, idx ) {
            if (idx > 0)
            {
                var rawParent = parent();
                parent.splice( idx-1, 2, rawParent[idx], rawParent[idx - 1] );
            }
        }

        self.savedData = function() {
            return <cfif isNull( attributes.model ) || len( attributes.model ) eq 0>[];<cfelse><cfoutput>#attributes.model#</cfoutput>;</cfif>
        }
        self.setLang = function ( module, id, name, langId ) {
            self.activeItem( langId + '.' + name );
            self.activeItem = null;
        }
        
        self.activeItem = null;

        self.aceEditor = null;

        self.setMode = function( mode ) {
            switch ( mode ) {
                case 'editor':
                    data = self.jsonEditor.get();
                    if ( data.length > 0 ) {
                        self.structCompositor.removeAll();
                        data.forEach( element => {
                            self.structCompositor.push( self.createStruct(element) );
                        });
                    }
                    break;
                case 'code':
                    var jdata = ko.toJSON( self.structCompositor() );
                    self.jsonEditor.set( JSON.parse( jdata ) );
                    jq.post( "<cfoutput>#request.self#?#cgi.QUERY_STRING#</cfoutput>&process=preview", {model : jdata, <cfoutput>#trim(listfirst(session.dark_mode,":"))#</cfoutput>: <cfoutput>'#trim(listlast(session.dark_mode,":"))#'</cfoutput>} )
                        .done( function( data ) {
                            self.aceEditor.setValue( data );
                        });
                    break;
                case 'json':
                    self.jsonEditor.set( JSON.parse( ko.toJSON( self.structCompositor() ) ) );
                    break;
                default:
                    break;
            }
            self.viewMode( mode );
            return true;
        }

        self.createProcessCat = function() {
            var elmProcessCat = self.createElement( null );
            elmProcessCat.label( "processCat" );
            elmProcessCat.langNo( "57800.Islem Tipi" );
            elmProcessCat.fieldType( "Process Cat" );
            elmProcessCat.dataType( "Numeric" );
            elmProcessCat.isDefault( true );
            elmProcessCat.isRequired( true );
            elmProcessCat.devAdd( true );
            elmProcessCat.devUpdate( true );
            
            elmProcessCat.isFixed( true );
            return elmProcessCat;
        }

        self.createSystemNo = function () {
            var elmSystemNo = self.createElement( null );
            elmSystemNo.label( "systemNo" );
            elmSystemNo.langNo( "47313.Sistem Fis No" );
            elmSystemNo.fieldType( "Paper No" );
            elmSystemNo.dataType( "Numeric" );
            elmSystemNo.isDefault( true );
            elmSystemNo.isRequired( true );
            elmSystemNo.devAdd( true );
            elmSystemNo.devUpdate( true );
            
            elmSystemNo.isFixed( true );
            return elmSystemNo;
        }

        self.createWorkflow = function() {
            var elmWorkflow = self.createElement( null );
            elmWorkflow.label( "process_stage" );
            elmWorkflow.langNo( "36841.Is Akisi" );
            elmWorkflow.fieldType( "Workflow" );
            elmWorkflow.dataType( "Numeric" );
            elmWorkflow.isDefault( true );
            elmWorkflow.isRequired( true );
            elmWorkflow.devAdd( true );
            elmWorkflow.devUpdate( true );

            elmWorkflow.isFixed( true );
            return elmWorkflow;
        }

        self.setFixedElements = function ( struct ) {
            if ( struct.structType() == "Main" ) {
                if ( self.useProcessCat == 1 ) {
                    if ( struct.listOfElements().filter( function( flelm ) {
                        return flelm.fieldType() == "Process Cat";
                        }).length == 0 ) 
                    {
                        var processCat = self.createProcessCat();
                        struct.listOfElements.push( processCat );
                    }
                }
                if ( self.useSystemNo == 1 ) {
                    if ( struct.listOfElements().filter( function( flelm ) {
                        return flelm.fieldType() == "Paper No";
                    }).length == 0 ) 
                    {
                        var systemNo = self.createSystemNo();
                        struct.listOfElements.push( systemNo );
                    }
                }
                if ( self.useWorkflow == 1 ) {
                    if ( struct.listOfElements().filter( function( flelm ) {
                        return flelm.fieldType() == "Workflow";
                    }).length == 0 )
                    {
                        var workflow = self.createWorkflow();
                        struct.listOfElements.push( workflow );
                    }
                }
            } else {
                var processCat = struct.listOfElements().filter( function( flelm ) {
                    return flelm.fieldType() == "Process Cat";
                });
                if ( processCat.length > 0 ) 
                {
                    struct.listOfElements.remove( processCat[0] );
                }
                var systemNo = struct.listOfElements().filter( function( flelm ) {
                    return flelm.fieldType() == "Paper No";
                });
                if ( systemNo.length > 0 ) 
                {
                    struct.listOfElements.remove( systemNo[0] );
                }
                var workflow = struct.listOfElements().filter( function( flelm ) {
                    return flelm.fieldType() == "Workflow";
                });
                if ( workflow.length > 0 )
                {
                    struct.listOfElements.remove( workflow[0] );
                }
            }
        }

        ko.computed(function () {
            self.structCompositor().forEach( function( struct ) {
                struct.listOfElements().forEach( function( element ) {
                    if (element.devDBField().type !== undefined && element.devDBField().type() == "db" && element.devDBField().alias() == "") {
                        var foundedAliases = struct.aliasTables().filter( function( ai ) {
                            return ai.table == element.devDBField().table() && ai.scheme == element.devDBField().scheme();
                        });
                        if ( foundedAliases.length > 0 ) {
                            element.devDBField().alias( foundedAliases[0].alias );
                        } else {
                            var name = "dt1";
                            var lastmatchindex = "1";
                            struct.aliasList().forEach( function ( alias ) {
                                var alias_matches = alias.match( /dt([0-9]+)/i );
                                if (alias_matches.length > 1) {
                                    var alias_match_index = Math.max( parseInt(alias_matches[1]), parseInt(lastmatchindex)+1 );
                                    name = "dt" + alias_match_index.toString();
                                    lastmatchindex = alias_match_index.toString();
                                }
                            });
                            element.devDBField().alias(name);
                        }
                    }
                });
                struct.listOfConditions().forEach( function( element ) {
                    if (element.left().type !== undefined && element.left().type() == "db" && element.left().alias() == "" ) {
                        var foundedLeftAliases = struct.aliasTables().filter( function( ai ) {
                            return ai.table == element.left().table() && ai.scheme == element.left().scheme();
                        });
                        if ( foundedLeftAliases.length > 0 ) {
                            element.left().alias( foundedLeftAliases[0].alias );
                        } else {
                            var name = "dt1";
                            var lastmatchindex = "1";
                            struct.aliasList().forEach( function ( alias ) {
                                var alias_matches = alias.match( /dt([0-9]+)/i );
                                if (alias_matches.length > 1) {
                                    var alias_match_index = Math.max( parseInt(alias_matches[1]), parseInt(lastmatchindex)+1 );
                                    name = "dt" + alias_match_index.toString();
                                    lastmatchindex = alias_match_index.toString();
                                }
                            });
                            element.left().alias(name);
                        }
                    }
                    if ( typeof element.right().type == 'function' && typeof element.right().type == 'function' && element.right().type() == 'db' && element.right().alias() == "" ) {
                        var foundedRightAliases = struct.aliasTables().filter( function( ai ) {
                            return ai.table == element.right().table() && ai.scheme == element.right().scheme();
                        });
                        if ( foundedRightAliases.length > 0 ) {
                            element.right().alias( foundedRightAliases[0].alias );
                        } else {
                            var name = "dt1";
                            var lastmatchindex = "1";
                            struct.aliasList().forEach( function ( alias ) {
                                var alias_matches = alias.match( /dt([0-9]+)/i );
                                if (alias_matches.length > 1) {
                                    var alias_match_index = Math.max( parseInt(alias_matches[1]), parseInt(lastmatchindex)+1 );
                                    name = "dt" + alias_match_index.toString();
                                    lastmatchindex = alias_match_index.toString();
                                }
                            });
                            element.right().alias(name);
                        }
                    }
                });
                struct.listOfProperties().forEach( function(element) {
                    element.listOfConditions().forEach( function(cond) {
                        if (cond.left().type !== undefined && cond.left().type() == "db" && cond.left().alias() == "") {
                            var foundedLeftAliases = struct.aliasTables().filter( function(ai) {
                                return ai.table == cond.left().table() && ai.scheme == cond.left().scheme();
                            });
                            if ( foundedLeftAliases.length > 0 ) {
                                cond.left().alias( foundedLeftAliases[0].alias );
                            } else  {
                                var name = "dt1";
                                var lastmatchindex = "1";
                                struct.aliasList().forEach( function ( alias ) {
                                    var alias_matches = alias.match( /dt([0-9]+)/i );
                                    if (alias_matches.length > 1) {
                                        var alias_match_index = Math.max( parseInt(alias_matches[1]), parseInt(lastmatchindex)+1 );
                                        name = "dt" + alias_match_index.toString();
                                        lastmatchindex = alias_match_index.toString();
                                    }
                                });
                                cond.left().alias(name);
                            }
                        }
                    });
                });
            });
        });

        return {
            init: function () {
                self.savedData().forEach( element => {
                    self.structCompositor.push( self.createStruct( element ) );
                });
                ko.applyBindings( self, document.getElementById( "appStruct" ) );
                self.aceEditor = ace.edit( "codeeditor" );
                self.aceEditor.setTheme( "ace/theme/sqlserver" );
                self.aceEditor.session.setMode( "ace/mode/coldfusion" );
                self.aceEditor.setFontSize( 14 );
                self.aceEditor.session.setUseWrapMode( true );
            },
            save: function( mode ) {
                if ( app.validate() ) {
                    var jdata = ko.toJSON( self.structCompositor() );
                    jq.post( "<cfoutput>#request.self#?#cgi.QUERY_STRING#</cfoutput>&process=" + mode, {model : jdata, <cfoutput>#trim(listfirst(session.dark_mode,":"))#</cfoutput>: <cfoutput>'#trim(listlast(session.dark_mode,":"))#'</cfoutput>} )
                        .done( function( data ) {
                            alertify.success( data );
                            //jq( "#codegen" ).html( "<pre>" + data + "</pre>" );
                        });
                }
                else 
                {
                    alertify.error( 'Invalid App' );
                }
            },
            structs : function () { 
                return ko.toJSON( self.structCompositor() );
            },
            getsession : function() {
                return self.savedData();
            },
            validate: function() {
                var invalids = 0;
                self.structCompositor().forEach( struct => {
                    var structErrors = ko.validation.group( struct );
                    invalids += structErrors().length;
                    if ( struct.listOfElements().length > 0 ) {
                        struct.listOfElements().forEach( element => {
                            var elementErrors = ko.validation.group( element );
                            invalids += elementErrors().length;
                        });
                    }
                    if ( struct.listOfConditions().length > 0 ) {
                        struct.listOfConditions().forEach( cond => {
                            var condErrors = ko.validation.group( cond );
                            invalids += condErrors().length;
                        });
                    }
                });
                if ( invalids > 0 ) {
                    self.structCompositor().forEach( struct => {
                        var structErrors = ko.validation.group( struct );
                        structErrors.showAllMessages();
                        if ( struct.listOfElements().length > 0 ) {
                            struct.listOfElements().forEach( element => {
                                var elementErrors = ko.validation.group( element );
                                elementErrors.showAllMessages();
                            });
                        }
                        if ( struct.listOfConditions().length > 0 ) {
                            struct.listOfConditions().forEach( cond => {
                                var condErrors = ko.validation.group( cond );
                                condErrors.showAllMessages();
                            });
                        }
                    });
                }
                return invalids === 0;
            },
            setValue : function( val ) {
                if ( self.activeItem !== null ) {
                    if (!!val.type && val.type == "db") {
                        self.activeItem( self.createDBField(val) );
                    } else {
                        self.activeItem( val );
                    }
                }
            },
            load: function ( data ) {
                self.structCompositor.removeAll();
                data.forEach( element => {
                    self.structCompositor.push( self.createStruct(element) );
                });
            }
        };

    }( ko, jQuery );
    app.init();
    
    function setFieldValue( val ) {
        app.setValue( val );
    }
    function getFieldValue( types ) {
        windowopen( '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_systemPopup' + (types !== undefined ? "&types=" + types : ""), 'wide' );
    }
    
</script>