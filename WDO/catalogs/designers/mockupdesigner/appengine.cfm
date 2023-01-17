<!---
    File :          mockupdesigner/appengine.cfm
    Author :        Uğur Hamurpet <ugurhamurpet@workcube.com>
    Date :          15.10.2020
    Description :   Mockup designer formu js app engine
    Notes :         WDO/catalogs\designers\widgetdesigner\appengine.cfm dosyasından alınarak uyarlanmıştır!
--->
<script type="text/javascript">
    var appDesign = function (ko, jq) {
        var self = this;
        
        /*mockup info*/
        <cfif attributes.event eq "upd" and len( attributes.id )>
            <cfset get_mockup = model.getById( attributes.id ) />
        <cfelse>
            <cfset get_mockup = { MOCKUP_NAME: "", MOCKUP_AUTHOR_ID: "", EMPLOYEE_NAME: "", EMPLOYEE_SURNAME: "", EMPLOYEE_FULL_NAME: "", WORK_ID: "", QPIC_RS_ID: "" } />
        </cfif>

        self.mockup_name = ko.observable("<cfoutput>#get_mockup.MOCKUP_NAME#</cfoutput>");
        self.mockup_author_id = ko.observable("<cfoutput>#get_mockup.MOCKUP_AUTHOR_ID#</cfoutput>");
        self.mockup_author_name = ko.observable("<cfoutput>#get_mockup.EMPLOYEE_FULL_NAME#</cfoutput>");
        self.work_id = ko.observable("<cfoutput>#isDefined('attributes.work_id') ? attributes.work_id : get_mockup.WORK_ID#</cfoutput>");
        self.qpic_rs_id = ko.observable("<cfoutput>#isDefined('attributes.qpic_rs_id') ? attributes.qpic_rs_id : get_mockup.QPIC_RS_ID#</cfoutput>");
        /*mockup info*/

        self.viewMode = ko.observable("editor");

        self.domainModelCache = [];
        self.domainModel = ko.observableArray([]);
        self.appModels = ko.observableArray([]);
        
        self.createBox = function( box ) {
            return {
                dragdrop        : ko.observable( box == null || box.dragdrop == undefined ? false : box.dragdrop ),
                refresh         : ko.observable( box == null || box.refresh == undefined ? false : box.refresh ),
                collapsable     : ko.observable( box == null || box.collapsable == undefined ? false : box.collapsable ),
                closable        : ko.observable( box == null || box.closable == undefined ? false : box.closable ),
                scroll          : ko.observable( box == null || box.scroll == undefined ? false : box.scroll ),
                title           : ko.observable( box == null || box.title == undefined ? '' : box.title ),
                class           : ko.observable( box == null || box.class == undefined ? '' : box.class ),
                iswidget        : ko.observable( box == null || box.iswidget == undefined ? false : box.iswidget ),
                box_type        : ko.observable( box == null || box.box_type == undefined ? '' : box.box_type ),
                body_height     : ko.observable( box == null || box.body_height == undefined ? '' : box.body_height ),
                style           : ko.observable( box == null || box.style == undefined ? '' : box.style ),
                header_style    : ko.observable( box == null || box.header_style == undefined ? '' : box.header_style  ),
                body_style      : ko.observable( box == null || box.body_style == undefined ? '' : box.body_style ),
                title_style     : ko.observable( box == null || box.body_style == undefined ? '' : box.title_style ),
                unload_body     : ko.observable( box == null || box.unload_body == undefined ? false : box.unload_body ),
                design_type     : ko.observable( box == null || box.design_type == undefined ? false : box.design_type ),
                left_side       : ko.observable( box == null || box.left_side == undefined ? false : box.left_side ),
                uniquebox_height    : ko.observable( box == null || box.uniquebox_height == undefined ? '' : box.uniquebox_height )
            };
        }

        self.appLayout = {
            addLayout : ko.observable({
                box             : self.createBox( null ),
                layout          : ko.observableArray([]) 
            }),
            updLayout : ko.observable({
                box             : self.createBox( null ),
                layout          : ko.observableArray([]) 
            }),
            listLayout : ko.observable({
                box             : self.createBox( null ),
                layout          : ko.observableArray([]),
                search          : ko.observable({
                    box         : self.createBox( null ),
                    layout      : ko.observableArray([]),
                    keyword     : ko.observableArray([])
                })
            }),
            dashLayout : ko.observable({
                box             : self.createBox( null ),
                layout          : ko.observableArray([]) 
            }),
            infoLayout : ko.observable({
                box             : self.createBox( null ),
                layout          : ko.observableArray([]) 
            })
        };

        self.activeItem = null;
        
        self.layoutType = ko.observable("devAdd");
        self.setLayoutType = function(type){ self.layoutType(type); }

        self.structs = ko.computed(function() {
            return self.domainModel().filter(function(struct) {
                return struct.name() != "Toolbox";
            }).map(function(struct) {
                return struct.name();
            })
        });

        self.graphBox = ko.computed( function() {
            return [
                {
                    name: "Pie",
                    colsize: ko.observable( 4 ),
                    listOfAxis: ko.observableArray([]),
                    listOfSummaries: ko.observableArray([]),
                    listOfArguments: ko.observableArray([]),
                    listOfElements: ko.observableArray([]),
                    coltype: "graph",
                    editMode: "table",
                    cachetime: ko.observable(0)
                },
                {
                    name: "Bar",
                    colsize: ko.observable( 4 ),
                    listOfAxis: ko.observableArray([]),
                    listOfSummaries: ko.observableArray([]),
                    listOfArguments: ko.observableArray([]),
                    listOfElements: ko.observableArray([]),
                    coltype: "graph",
                    editMode: "table",
                    cachetime: ko.observable(0)
                },
                {
                    name: "Line",
                    colsize: ko.observable( 4 ),
                    listOfAxis: ko.observableArray([]),
                    listOfSummaries: ko.observableArray([]),
                    listOfArguments: ko.observableArray([]),
                    listOfElements: ko.observableArray([]),
                    coltype: "graph",
                    editMode: "table",
                    cachetime: ko.observable(0)
                }
            ]
        });

        // STATES
        self.activeElementisToolbox = true;
        self.activeInputRef = null;
        self.activeElementParent = null;
        self.activeElementStructRef = null;
        self.activeElementRef = null;
        self.activeElementType = null;
        self.activeElementTemplate = null;
        self.activeElementDomain = ko.observable(null);
        self.activeConditionDomain = ko.observable(null);
        
        // METHODS
        self.setActiveElement = function (ref, parent, type, template) {
            
            self.activeElementParent = parent;
            self.activeInputRef = ref;
            self.activeElementType = type;
            self.activeElementTemplate = template;

            if (ref.struct() == "Toolbox")
            {
                self.activeElementRef = null;
                self.activeElementisToolbox = true;
                self.activeElementDomain({
                    label               : ko.observable( ref.label() ),
                    langNo              : ko.observable( "" ),
                    fieldType           : ko.observable( ref.fieldTypeName() ),
                    dataType            : ko.observable( "Alphanumeric" ),
                    isKey               : ko.observable( false ),
                    isDefault           : ko.observable( false ),
                    isRequired          : ko.observable( false ),
                    minSize             : ko.observable( "" ),
                    maxSize             : ko.observable( "" ),
                    floatSize           : ko.observable( "" ),
                    devValue            : ko.observable( { value: "" } ),
                    devDBField          : ko.observable( { value: "" } ),
                    devMethod           : ko.observable( { value: "" } ),
                    devIFMethod         : ko.observable( { value: "" } ),
                    devAutocomplete     : ko.observable( { value: "" } ),
                    devJS               : ko.observable( { value: "" } ),
                    devLink             : ko.observable( { value: "" } ),
                    devCSS              : ko.observable( { value: "" } ),
                    devAdd              : ko.observable( self.layoutType() == 'devAdd' ? true : ref.devAdd() ),
                    devUpdate           : ko.observable( self.layoutType() == 'devUpdate' ? true : ref.devUpdate() ),
                    devList             : ko.observable( self.layoutType() == 'devList' ? true : ref.devList() ),
                    devDash             : ko.observable( ref.devDash() ),
                    formula             : ko.observable( "" ),
                    devSearch           : ko.observable( self.layoutType() == 'devSearch' ? true : ref.devSearch() ),
                    listValueIndex      : ko.observable( "" ),
                    listDisplayIndex    : ko.observable( "" ),
                    includeAdd          : ko.observable( true ),
                    includeUpdate       : ko.observable( true ),
                    isFixed             : ko.observable( false ),
                    filterAsRange       : ko.observable( false ),
                    dataCompute         : ko.observable( "" ),
                    dataComputeFormula  : ko.observable( "" ),
                    struct              : ko.observable( "" ),
                    structType          : ko.observable( ref.structType() )
                });
            }
            else 
            {
                var struct = self.domainModel().find( function( stck ) {
                    return stck.name() == ref.struct();
                });
                var element = struct.listOfElements().find( function( elm ) {
                    return elm.label() == ref.label();
                });
                self.activeElementStructRef = struct;
                self.activeElementRef = element;
                self.activeElementisToolbox = false;

                self.activeElementDomain({
                    label               : ko.observable( self.clearString( element.label() ) ),
                    langNo              : ko.observable( element.langNo() ),
                    fieldType           : ko.observable( element.fieldType() ),
                    dataType            : ko.observable( element.dataType() ),
                    isKey               : ko.observable( element.isKey() ),
                    isDefault           : ko.observable( element.isDefault() ),
                    isRequired          : ko.observable( element.isRequired() ),
                    minSize             : ko.observable( element.minSize() ),
                    maxSize             : ko.observable( element.maxSize() ),
                    floatSize           : ko.observable( element.floatSize() ),
                    devValue            : ko.observable( element.devValue() ),
                    devDBField          : ko.observable( element.devDBField() ),
                    devMethod           : ko.observable( element.devMethod() ),
                    devIFMethod         : ko.observable( element.devIFMethod() ),
                    devAutocomplete     : ko.observable( element.devAutocomplete() ),
                    devJS               : ko.observable( element.devJS() ),
                    devLink             : ko.observable( element.devLink() ),
                    devCSS              : ko.observable( element.devCSS() ),
                    devAdd              : ko.observable( element.devAdd() ),
                    devUpdate           : ko.observable( element.devUpdate() ),
                    devList             : ko.observable( element.devList() ),
                    devDash             : ko.observable( element.devDash() ),
                    formula             : ko.observable( element.formula() ),
                    devSearch           : ko.observable( element.devSearch() ),
                    listValueIndex      : ko.observable( element.listValueIndex() ),
                    listDisplayIndex    : ko.observable( element.listDisplayIndex() ),
                    includeAdd          : ko.observable( element.includeAdd() ),
                    includeUpdate       : ko.observable( element.includeUpdate() ),
                    isFixed             : ko.observable( element.isFixed() ),
                    filterAsRange       : ko.observable( element.filterAsRange() ),
                    dataCompute         : ko.observable( element.dataCompute() ),
                    dataComputeFormula  : ko.observable( element.dataComputeFormula() ),
                    struct              : ko.observable( self.clearString( ref.struct() ) )
                });
            }
            
        }

        self.clearString = function( str ){
            
            const charMap = {Ç:'c',Ö:'o',Ş:'s',İ:'i',I:'i',Ü:'u',Ğ:'g',ç:'c',ö:'o',ş:'s',ı:'i',ü:'u',ğ:'g'};
            
            strArray = str.split('');
            
            str_arrayfiltered = strArray.map((el) => {
                return (charMap[ el ] || el).replace(/[^a-z0-9_.@çöşüğı-]/gi,"").toLowerCase();
            });
            
            return str_arrayfiltered.join('');

        }

        self.commitActiveElementDomain = function () {

            var activeStruct = null;

            self.activeElementDomain().struct( self.clearString( self.activeElementDomain().struct() ) );

            if ( self.activeElementDomain().struct() == "Toolbox" ) {
                alert( "You cannot add element in Toolbox!\rPlease change struct name." );
                return;
            }else if( self.activeElementDomain().struct() == "" ){
                alert( "Please fill in Struct Name!" );
                return;
            }

            activeStruct = self.domainModel().find( function( stck ) {
                return stck.name() === self.activeElementDomain().struct();
            });

            if ( activeStruct == null ) {
                
                if ( confirm("Struct not found! Do you want a new one?") ) {
                    activeStruct = self.createDomainStruct( self.activeElementDomain().struct() );
                    self.addDomainElementToStruct( activeStruct );       
                }

            } else {

                if ( self.activeElementRef == null ) {

                    self.addDomainElementToStruct( activeStruct );

                } else {
                    
                    self.activeElementDomain().label( self.clearString( self.activeElementDomain().label() ) );
                    self.activeElementRef.label( self.clearString(self.activeElementDomain().label()) );
                    self.activeElementRef.langNo( self.activeElementDomain().langNo() );
                    self.activeElementRef.fieldType( self.activeElementDomain().fieldType() );
                    self.activeElementRef.dataType ( self.activeElementDomain().dataType() );
                    self.activeElementRef.isKey( self.activeElementDomain().isKey() );
                    self.activeElementRef.isDefault( self.activeElementDomain().isDefault() );
                    self.activeElementRef.isRequired( self.activeElementDomain().isRequired() );
                    self.activeElementRef.minSize( self.activeElementDomain().minSize() );
                    self.activeElementRef.maxSize( self.activeElementDomain().maxSize() );
                    self.activeElementRef.floatSize( self.activeElementDomain().floatSize() );
                    self.activeElementRef.devValue( self.activeElementDomain().devValue() );
                    self.activeElementRef.devDBField( self.activeElementDomain().devDBField() );
                    self.activeElementRef.devMethod( self.activeElementDomain().devMethod() );
                    self.activeElementRef.devIFMethod( self.activeElementDomain().devIFMethod() );
                    self.activeElementRef.devAutocomplete( self.activeElementDomain().devAutocomplete() );
                    self.activeElementRef.devJS( self.activeElementDomain().devJS() );
                    self.activeElementRef.devLink( self.activeElementDomain().devLink() );
                    self.activeElementRef.devCSS( self.activeElementDomain().devCSS() );
                    self.activeElementRef.devAdd( self.activeElementDomain().devAdd() );
                    self.activeElementRef.devUpdate( self.activeElementDomain().devUpdate() );
                    self.activeElementRef.devList( self.activeElementDomain().devList() );
                    self.activeElementRef.devDash( self.activeElementDomain().devDash() );
                    self.activeElementRef.formula( self.activeElementDomain().formula() );
                    self.activeElementRef.devSearch( self.activeElementDomain().devSearch() );
                    self.activeElementRef.listValueIndex( self.activeElementDomain().listValueIndex() );
                    self.activeElementRef.listDisplayIndex( self.activeElementDomain().listDisplayIndex() );
                    self.activeElementRef.includeAdd( self.activeElementDomain().includeAdd() );
                    self.activeElementRef.includeUpdate( self.activeElementDomain().includeUpdate() );
                    self.activeElementRef.isFixed( self.activeElementDomain().isFixed() );
                    self.activeElementRef.filterAsRange( self.activeElementDomain().filterAsRange() );
                    self.activeElementRef.dataCompute( self.activeElementDomain().dataCompute() );
                    self.activeElementRef.dataComputeFormula( self.activeElementDomain().dataComputeFormula() );
                    
                }
            }

            alert("Element has been saved successfuly!");

        }

        self.removeActiveElementDomain = function() {

            if( confirm('Are you sure you want to delete this element?') ){
                
                if ( self.activeElementDomain().struct() != "Toolbox" ){

                    if ( self.activeElementStructRef != null ) {

                        if( typeof( self.activeElementParent.layout ) != 'undefined' ) self.activeElementParent.layout.remove( self.activeInputRef );
                        else{
                            //self.activeElementStructRef.listOfElements.remove( self.activeElementRef );
                            self.activeElementParent.listOfElements.remove( self.activeInputRef ); 
                        }
                        self.activeElementDomain(null);

                    }

                }
                
            }

        }

        self.activeRow = ko.observable( null );
        self.hasRow = ko.computed(function () {
            return self.activeRow() !== null;
        });
        self.hasTree = ko.computed(function () {
            return self.layoutType() != 'devList';
        });
        
        self.addDomainElementToStruct = function( struct ) {
            var activeitem = {
                label                   : ko.observable( self.clearString( self.activeElementDomain().label() ) ), 
                langNo                  : ko.observable( self.activeElementDomain().langNo() ), 
                fieldType               : ko.observable( self.activeElementDomain().fieldType() ), 
                dataType                : ko.observable( self.activeElementDomain().dataType() ), 
                isKey                   : ko.observable( self.activeElementDomain().isKey() ), 
                isDefault               : ko.observable( self.activeElementDomain().isDefault() ), 
                isRequired              : ko.observable( self.activeElementDomain().isRequired() ), 
                minSize                 : ko.observable( self.activeElementDomain().minSize() ),
                maxSize                 : ko.observable( self.activeElementDomain().maxSize() ),
                floatSize               : ko.observable( self.activeElementDomain().floatSize() ),
                devValue                : ko.observable( self.activeElementDomain().devValue() ), 
                devDBField              : ko.observable( self.activeElementDomain().devDBField() ), 
                devMethod               : ko.observable( self.activeElementDomain().devMethod() ), 
                devIFMethod             : ko.observable( self.activeElementDomain().devIFMethod() ), 
                devAutocomplete         : ko.observable( self.activeElementDomain().devAutocomplete() ), 
                devJS                   : ko.observable( self.activeElementDomain().devJS() ), 
                devLink                 : ko.observable( self.activeElementDomain().devLink() ), 
                devCSS                  : ko.observable( self.activeElementDomain().devCSS() ), 
                devAdd                  : ko.observable( self.activeElementDomain().devAdd() ),
                devUpdate               : ko.observable( self.activeElementDomain().devUpdate() ), 
                devList                 : ko.observable( self.activeElementDomain().devList() ), 
                devDash                 : ko.observable( self.activeElementDomain().devDash() ),
                formula                 : ko.observable( self.activeElementDomain().formula() ),
                devSearch               : ko.observable( self.activeElementDomain().devSearch() ),
                listValueIndex          : ko.observable( self.activeElementDomain().listValueIndex() ),
                listDisplayIndex        : ko.observable( self.activeElementDomain().listDisplayIndex() ),
                includeAdd              : ko.observable( self.activeElementDomain().includeAdd() ),
                includeUpdate           : ko.observable( self.activeElementDomain().includeUpdate() ),
                isFixed                 : ko.observable( self.activeElementDomain().isFixed() ),
                filterAsRange           : ko.observable( self.activeElementDomain().filterAsRange() ),
                dataCompute             : ko.observable( self.activeElementDomain().dataCompute() ),
                dataComputeFormula      : ko.observable( self.activeElementDomain().dataComputeFormula() ),
                listOfProperties: [],
            };
            struct.listOfElements.push(activeitem);
            
            self.appModels.removeAll();
            self.appModels(
                self.domainModel().map(struct => {
                    return self.createStruct(struct);
                })
            );
            
            var newInput = {
                devAdd: activeitem.devAdd,
                devList: activeitem.devList,
                devUpdate: activeitem.devUpdate,
                fieldType: ko.computed( function() { return self.fieldTypeConverter(activeitem.fieldType(), activeitem.isRequired()) } ),
                fieldTypeName: activeitem.fieldType,
                isDB: ko.computed( function() { return activeitem.devDBField().value != "" } ),
                isMethod: ko.computed( function() { return activeitem.devMethod().value != "" || activeitem.devValue().value != ""} ),
                isRequired: activeitem.isRequired,
                label: activeitem.label,
                struct: ko.observable( struct.name() ),
                langNo: activeitem.langNo
            };

            if (self.activeElementParent == self.appLayout.listLayout()) {
                var indexInput = self.appLayout.listLayout().layout().indexOf( self.activeInputRef );
                self.appLayout.listLayout().layout.splice( indexInput, 1, newInput );
            } else {
                var indexInput = self.activeElementParent.listOfElements().indexOf( self.activeInputRef );
                self.activeElementParent.listOfElements.splice( indexInput, 1, newInput );
            }
        }

        self.addConditionElementToStruct = function ( struct ) {
            var activeitem = {
                autocomplete            : ko.observable( self.activeConditionDomain().autocomplete() ),
                comparison              : ko.observable( "=" ),
                dataType                : ko.observable( self.activeConditionDomain().dataType() ),
                fieldType               : ko.observable( self.activeConditionDomain().fieldType() ),
                isAdd                   : ko.observable( false ),
                isList                  : ko.observable( false ),
                //isSearch                : ko.observable( true ),
                isUpd                   : ko.observable( false ),
                join                    : ko.observable( false ),
                label                   : ko.observable( self.activeConditionDomain().label() ),
                langNo                  : ko.observable( self.activeConditionDomain().langNo() ),
                left                    : ko.observable( self.activeConditionDomain().left() ),
                method                  : ko.observable( self.activeConditionDomain().method() ),
                oper                    : ko.observable( self.activeConditionDomain().oper() ),
                right                   : ko.observable( self.activeConditionDomain().right() ),
                type                    : ko.observable( self.activeConditionDomain().type() )
            };

            struct.listOfConditions.push( activeitem );

            self.appModels.removeAll();
            self.appModels(
                self.domainModel().map( struct => {
                    return self.createStruct(struct);
                })
            );

            var newInput = {
                devAdd                  : ko.observable(false),
                devList                 : ko.observable(false),
                devUpdate               : ko.observable(false),
                fieldType               : ko.computed( function() { return self.fieldTypeConverter( activeitem.fieldType(), false ) } ),
                fieldTypeName           : activeitem.fieldType,
                isDB                    : ko.computed( function() { return activeitem.left().value != "" } ),
                isMethod                : ko.computed( function() { return activeitem.method().value != "" } ),
                isRequired              : ko.observable( false ),
                label                   : activeitem.label,
                struct                  : ko.observable( struct.name() )
            };

            var indexInput = self.activeElementParent.listOfElements().indexOf( self.activeInputRef );
            self.activeElementParent.listOfElements.splice( indexInput, 1, newInput );
        }
        
        self.createDomainStruct = function( name ) {
            var domainStruct = 
                {
                    langNo              : ko.observable(""),
                    listOfConditions    : ko.observableArray([]),
                    listOfElements      : ko.observableArray([]),
                    listOfSummaries     : ko.observableArray([]),
                    listOfProperties    : [],
                    method              : ko.observable({ value: "" }),
                    name                : ko.observable(name),
                    relation            : ko.observable(""),
                    structType          : ko.observable(self.activeElementType),
                    template            : ko.observable(self.activeElementTemplate)
                }
            self.domainModel.push(domainStruct);
            return domainStruct;
        }

        self.createDomainModel = function ( model ) {
            self.domainModel(
                model.map(function(struct) {
                    return {
                        langNo: ko.observable( struct.langNo ),
                        listOfConditions: ko.observableArray(
                            struct.listOfConditions.map(function(cond) {
                                return {
                                    autocomplete    : ko.observable( cond.autocomplete ),
                                    comparison      : ko.observable( cond.comparison ),
                                    dataType        : ko.observable( cond.dataType ),
                                    fieldType       : ko.observable( cond.fieldType ),
                                    isAdd           : ko.observable( cond.isAdd ),
                                    isList          : ko.observable( cond.isList ),
                                    isSearch        : ko.observable( cond.isSearch ),
                                    isUpd           : ko.observable( cond.isUpd ),
                                    join            : ko.observable( cond.join ),
                                    langNo          : ko.observable( cond.langNo ),
                                    left            : ko.observable( cond.left ),
                                    method          : ko.observable( cond.method ),
                                    oper            : ko.observable( cond.oper ),
                                    right           : ko.observable( cond.right ),
                                    type            : ko.observable( cond.type ),
                                    label           : ko.observable( cond.label )
                                }
                            })
                        ),
                        listOfElements: ko.observableArray(
                            struct.listOfElements.map(function (elm) {
                                return {
                                    dataType                : ko.observable( elm.dataType ),
                                    devAdd                  : ko.observable( elm.devAdd ),
                                    devAutocomplete         : ko.observable( elm.devAutocomplete ),
                                    devCSS                  : ko.observable( elm.devCSS ),
                                    devDBField              : ko.observable( elm.devDBField ),
                                    devIFMethod             : ko.observable( elm.devIFMethod ),
                                    devJS                   : ko.observable( elm.devJS ),
                                    devLink                 : ko.observable( elm.devLink ),
                                    devList                 : ko.observable( elm.devList ),
                                    devMethod               : ko.observable( elm.devMethod ),
                                    devUpdate               : ko.observable( elm.devUpdate ),
                                    devValue                : ko.observable( elm.devValue ),
                                    devSearch               : ko.observable( elm.devSearch ),
                                    devDash                 : ko.observable( elm.devDash ),
                                    fieldType               : ko.observable( elm.fieldType ),
                                    formula                 : ko.observable( elm.formula ),
                                    isKey                   : ko.observable( elm.isKey ),
                                    isRequired              : ko.observable( elm.isRequired ),
                                    label                   : ko.observable( elm.label ),
                                    langNo                  : ko.observable( elm.langNo ),
                                    maxSize                 : ko.observable( elm.maxSize ),
                                    minSize                 : ko.observable( elm.minSize ),
                                    floatSize               : ko.observable( elm.floatSize == undefined ? '' : elm.floatSize ),
                                    isDefault               : ko.observable( elm.isDefault ),
                                    listValueIndex          : ko.observable( elm.listValueIndex ),
                                    listDisplayIndex        : ko.observable( elm.listDisplayIndex ),
                                    listOfPropertyMaps      : elm.listOfPropertyMaps !== undefined ? elm.listOfPropertyMaps : [],
                                    includeAdd              : ko.observable( elm.includeAdd ),
                                    includeUpdate           : ko.observable( elm.includeUpdate ),
                                    isFixed                 : ko.observable( elm.isFixed ),
                                    filterAsRange           : ko.observable( elm.filterAsRange ),
                                    dataCompute             : ko.observable( elm.dataCompute ),
                                    dataComputeFormula      : ko.observable( elm.dataComputeFormula )
                                }
                            })
                        ),
                        listOfSummaries: ko.observableArray(
                            struct.listOfSummaries.map(function (smr) {
                                return {
                                    DBField         : ko.observable( smr.DBField ),
                                    dataType        : ko.observable( smr.dataType ),
                                    field           : ko.observable( smr.field ),
                                    groupby         : ko.observable( smr.groupby ),
                                    label           : ko.observable( smr.label ),
                                    langNo          : ko.observable( smr.langNo ),
                                    type            : ko.observable( smr.type )
                                }
                            })
                        ),
                        listOfProperties    : struct.listOfProperties,
                        method              : ko.observable( struct.method ),
                        name                : ko.observable( struct.name ),
                        relation            : ko.observable( struct.relation ),
                        structType          : ko.observable( struct.structType ),
                        template            : ko.observable( struct.template )
                    }
                })
            );
        }

        self.createStruct = function ( struct ) {
            return {
                label: struct.name,
                type: struct.structType,
                template: struct.template,
                listOfElements: ko.computed(function() { 
                    return ko.observableArray( struct.listOfElements().map(element => {
                        return self.createElement(element, struct);
                    }))
                }),
                listOfConditions: ko.computed(function() { 
                    return ko.observableArray( struct.listOfConditions().map(element => {
                        return self.createCondition(element, struct);
                    }))
                })
            }
        }

        self.createElement = function ( element, struct ) {
            return {
                label                   : element.label,
                fieldType               : ko.computed(function() { return self.fieldTypeConverter(element.fieldType(), element.isDefault()) }),
                fieldTypeName           : element.fieldType,
                isRequired              : element.isRequired,
                devAdd                  : element.devAdd,
                devUpdate               : element.devUpdate,
                devList                 : element.devList,
                devSearch               : element.devSearch,
                devDash                 : element.devDash,
                struct                  : ko.observable( struct.name() ),
                structType              : ko.observable( struct.structType() ),
                isShown                 : ko.observable( true ),
                isDB                    : ko.computed( function() { return element.devDBField().value != "" } ),
                isMethod                : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != ""} ),
                langNo                  : element.langNo,
                listValueIndex          : element.listValueIndex,
                listDisplayIndex        : element.listDisplayIndex,
                includeAdd              : element.includeAdd,
                includeUpdate           : element.includeUpdate
            }
        }

        self.createToolbox = function () {
            return [
                {
                    name            : "Toolbox",
                    langNo          : "1",
                    relation        : "",
                    structType      : "Toolbox",
                    template        : "Default",
                    method          : { value: "" },
                    listOfConditions: [],
                    listOfSummaries : [],
                    listOfElements: [
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Input", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Input", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Hidden Input", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Hidden Input", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Select", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Select", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Multi Select", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Multi Select", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Textarea", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Textarea", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Radio Button", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Radio Button", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Checkbox", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Checkbox", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Upload File", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Upload File", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Image", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Image", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Button", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Button", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Alphanumeric", devAdd: true, devAutocompolete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: true, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Text", formula: "", isDefault: false, iskey: false, isRequired: false, label: "Text", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Numeric", devAdd: true, devAutocomplete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: false, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Workflow", formula: "", isDefault: false, iskey: false, isRequired: false,label: "process_stage", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Numeric", devAdd: true, devAutocomplete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: false, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Process Cat", formula: "", isDefault: false, iskey: false, isRequired: false, label: "processCat", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        },
                        {
                            dataType: "Numeric", devAdd: true, devAutocomplete: { value: "" }, devCSS: { value: "" }, devDBField: { value: "" }, devIFMethod: { value: "" }, devJS: { value: "" }, devLink: { value: "" }, devList: false, devMethod: { value: "" }, devUpdate: true, devValue: { value: "" }, fieldType: "Paper No", formula: "", isDefault: false, iskey: false, isRequired: false, label: "paperNo", langNo: "", maxSize: "", minSize: "", floatSize: "", devSearch: false, devDash: false
                        }
                    ]
                }
            ]
        }

        // Create Layouts

        self.createFormLayout = function( layout ) {
            if ( layout != null ) {
                var mappedlayout = 
                    {
                        box : self.createBox( layout.box == undefined ? null : layout.box ),
                        layout : ko.observableArray( layout.layout == undefined ? [] : layout.layout.map( function( row ) {
                            return {
                                rowtitle: ko.observable( row.rowtitle == undefined ? '' : row.rowtitle ),
                                showtitle: ko.observable( row.showtitle == undefined ? false : row.showtitle ),
                                listOfCols: ko.observableArray(
                                    row.listOfCols.map( function( col ) {
                                        return {
                                            editMode: ko.observable( col.editMode ),
                                            colsize: ko.observable( col.colsize ),
                                            coltype: col.coltype,
                                            listOfElements: ko.observableArray(
                                                col.listOfElements.reduce( function( acc, elm ) {
                                                    var struct = self.domainModel().find( function( strck ) {
                                                        return strck.name() == elm.struct;
                                                    });
                                                    var element = struct.listOfElements().find( function( stelm ) {
                                                        return stelm.label() == elm.label;
                                                    });
                                                    if (element !== undefined)
                                                    acc.push({
                                                        devAdd          : element.devAdd,
                                                        isRequired      : element.isRequired,
                                                        fieldType       : ko.computed( function() { return self.fieldTypeConverter( element.fieldType(), element.isDefault() ); } ),
                                                        fieldTypeName   : element.fieldType,
                                                        devList         : element.devList,
                                                        devUpdate       : element.devUpdate,
                                                        isMethod        : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != "" } ),
                                                        label           : element.label,
                                                        isDB            : ko.computed( function() { return element.devDBField().value != "" } ),
                                                        struct          : struct.name,
                                                        devDash         : element.devDash == undefined ? false : element.devDash,
                                                        langNo          : element.langNo
                                                    });
                                                    return acc;
                                                }, [])
                                            )
                                        }
                                    })
                                )
                            }
                        })
                )};
                return mappedlayout;
            }
            return {
                box : self.createBox( null ),
                layout : ko.observableArray([]) 
            };
        }
        self.createSearchLayout = function( layout ) {
            var searchlayout = self.createFormLayout( layout );
            if (layout != null && layout.keyword !== undefined) {
                searchlayout.keyword = ko.observableArray( layout.keyword.reduce( function( acc, elm ) {
                    var struct = self.domainModel().find( function( strck ) {
                        return strck.name() == elm.struct;
                    });
                    var element = struct.listOfElements().find( function( stelm ) {
                        return stelm.label() == elm.label;
                    });
                    if (element !== undefined)
                    acc.push({
                        devAdd          : element.devAdd,
                        isRequired      : element.isRequired,
                        fieldType       : ko.computed( function() { return self.fieldTypeConverter( element.fieldType(), element.isDefault() ); } ),
                        fieldTypeName   : element.fieldType,
                        devList         : element.devList,
                        devUpdate       : element.devUpdate,
                        isMethod        : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != "" } ),
                        label           : element.label,
                        isDB            : ko.computed( function() { return element.devDBField().value != "" } ),
                        struct          : struct.name,
                        langNo          : element.langNo
                    });
                    return acc;
                }, [])
                );
            } else {
                searchlayout.keyword = ko.observableArray([]);
            }
            return searchlayout;
        }
        self.createListLayout = function( layout ) {
            if ( layout != null && layout.layout.lenght !== 0 ) {
                var mappedlayout = {
                    box : self.createBox( layout.box ),
                    layout: ko.observableArray( layout.layout.reduce( function(acc, elm) {
                        var struct = self.domainModel().find( function( strck ) {
                            return strck.name() == elm.struct;
                        });
                        var element = struct.listOfElements().find( function( stelm ) {
                            return stelm.label() == elm.label;
                        });
                        if (element !== undefined)
                        acc.push({
                            devAdd          : element.devAdd,
                            isRequired      : element.isRequired,
                            fieldType       : ko.computed( function() { return self.fieldTypeConverter( element.fieldType(), element.isDefault() ); } ),
                            fieldTypeName   : element.fieldType,
                            devList         : element.devList,
                            devUpdate       : element.devUpdate,
                            isMethod        : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != "" } ),
                            label           : element.label,
                            isDB            : ko.computed( function() { return element.devDBField().value != "" } ),
                            struct          : struct.name,
                            langNo          : element.langNo
                        });
                        return acc;
                    }, []) ),
                    search: ko.observable( self.createSearchLayout( layout.search ) ),
                    
                };
                return mappedlayout;
            };
            return {
                box: self.createBox( null ),
                layout: ko.observableArray([]), 
                search: ko.observable( self.createFormLayout( null ) )
            };
        }
        self.createDashLayout = function( layout ) {
            if ( layout != null ) {
                var mappedlayout =
                    {
                        box : self.createBox( layout.box == undefined ? null : layout.box ),
                        layout : ko.observableArray( layout.layout == undefined ? [] : layout.layout.map( function( row ) {
                            return {
                                rowtitle: ko.observable( row.rowtitle == undefined ? '' : row.rowtitle ),
                                showtitle: ko.observable( row.showtitle == undefined ? false : row.showtitle ),
                                listOfCols: ko.observableArray(
                                    row.listOfCols.map( function( col ) {
                                        return {
                                            editMode: ko.observable( col.editMode ),
                                            colsize: ko.observable( col.colsize ),
                                            coltype: col.coltype,
                                            listOfElements: ko.observableArray([]),
                                            name: col.name,
                                            cachetime: ko.observable( col.cachetime == undefined ? 0 : col.cachetime ),
                                            listOfAxis: ko.observableArray(
                                                col.listOfAxis.reduce( function( acc, elm ) {
                                                    var struct = self.domainModel().find( function( strck ) {
                                                        return strck.name() == elm.struct;
                                                    });
                                                    var element = struct.listOfElements().find( function( stelm ) {
                                                        return stelm.label() == elm.label;
                                                    });
                                                    if (element !== undefined)
                                                    acc.push({
                                                        devAdd          : element.devAdd,
                                                        isRequired      : element.isRequired,
                                                        fieldType       : ko.computed( function() { return self.fieldTypeConverter( element.fieldType(), element.isDefault() ); } ),
                                                        fieldTypeName   : element.fieldType,
                                                        devList         : element.devList,
                                                        devUpdate       : element.devUpdate,
                                                        isMethod        : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != "" } ),
                                                        label           : element.label,
                                                        isDB            : ko.computed( function() { return element.devDBField().value != "" } ),
                                                        struct          : struct.name,
                                                        devDash         : element.devDash == undefined ? false : element.devDash,
                                                        graphMethod     : ko.observable( elm.graphMethod ),
                                                        langNo          : ko.observable( elm.langNo )
                                                    });
                                                    return acc;
                                                }, [])
                                            ),
                                            listOfSummaries: ko.observableArray(
                                                col.listOfSummaries.reduce( function( acc, elm ) {
                                                    var struct = self.domainModel().find( function( strck ) {
                                                        return strck.name() == elm.struct;
                                                    });
                                                    var element = struct.listOfElements().find( function( stelm ) {
                                                        return stelm.label() == elm.label;
                                                    });
                                                    if (element !== undefined)
                                                    acc.push({
                                                        devAdd          : element.devAdd,
                                                        isRequired      : element.isRequired,
                                                        fieldType       : ko.computed( function() { return self.fieldTypeConverter( element.fieldType(), element.isDefault() ); } ),
                                                        fieldTypeName   : element.fieldType,
                                                        devList         : element.devList,
                                                        devUpdate       : element.devUpdate,
                                                        isMethod        : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != "" } ),
                                                        label           : element.label,
                                                        isDB            : ko.computed( function() { return element.devDBField().value != "" } ),
                                                        struct          : struct.name,
                                                        devDash         : element.devDash == undefined ? false : element.devDash,
                                                        graphMethod     : ko.observable( elm.graphMethod ),
                                                        langNo          : ko.observable( elm.langNo )
                                                    });
                                                    return acc;
                                                }, [])
                                            ),
                                            listOfArguments: ko.observableArray( col.listOfArguments == undefined ? [] :
                                                col.listOfArguments.reduce( function( elm ) {
                                                    var struct = self.domainModel().find( function( strck ) {
                                                        return strck.name() == elm.struct;
                                                    });
                                                    var element = struct.listOfElements().find( function ( stelm ) {
                                                        return stelm.label() == elm.label;
                                                    });
                                                    if (element !== undefined)
                                                    acc.push({
                                                        devAdd          : element.devAdd,
                                                        isRequired      : element.isRequired,
                                                        fieldType       : ko.computed( function() { return self.fieldTypeConverter( element.fieldType(), element.isDefault() ); } ),
                                                        fieldTypeName   : element.fieldType,
                                                        devList         : element.devList,
                                                        devUpdate       : element.devUpdate,
                                                        isMethod        : ko.computed( function() { return element.devMethod().value != "" || element.devValue().value != "" } ),
                                                        label           : element.label,
                                                        isDB            : ko.computed( function() { return element.devDBField().value != "" } ),
                                                        struct          : struct.name,
                                                        devDash         : element.devDash == undefined ? false : element.devDash,
                                                        graphMethod     : ko.observable( elm.graphMethod ),
                                                        graphMethodArg  : ko.observable( elm.graphMethodArg ),
                                                        langNo          : ko.observable( elm.langNo )
                                                    });
                                                    return acc;
                                                }, [])
                                            )
                                        }
                                    })
                                )
                            }
                        }) )   
                    }
                return mappedlayout;
            }
            return {
                box : self.createBox( null ),
                layout : ko.observableArray([]) 
            };
        }

        // Create Layouts

        
        // Events

        self.appCreate = function () {

            var concatedModel = self.domainModelCache.concat(
                self.createToolbox()
            );

            self.createDomainModel( concatedModel );
            
            <cfif attributes.event eq 'upd'>

                <cfset eventDesignModel = {
                    add: model.getByEvent(attributes.id,'add'),
                    upd: model.getByEvent(attributes.id,'upd'),
                    list: model.getByEvent(attributes.id,'list'),
                    dashboard: model.getByEvent(attributes.id,'dashboard')
                } />

                self.createDomainModel( <cfoutput>#eventDesignModel.add.model#</cfoutput> );
                self.createDomainModel( <cfoutput>#eventDesignModel.upd.model#</cfoutput> );
                self.createDomainModel( <cfoutput>#eventDesignModel.list.model#</cfoutput> );
                self.createDomainModel( <cfoutput>#eventDesignModel.dashboard.model#</cfoutput> );

                self.appLayout.addLayout( self.createFormLayout( <cfoutput>#eventDesignModel.add.design#</cfoutput> ) );
                self.appLayout.updLayout( self.createFormLayout( <cfoutput>#eventDesignModel.upd.design#</cfoutput> ) );
                self.appLayout.listLayout( self.createListLayout( <cfoutput>#eventDesignModel.list.design#</cfoutput> ) );
                self.appLayout.dashLayout( self.createDashLayout( <cfoutput>#eventDesignModel.dashboard.design#</cfoutput> ) );


            </cfif>

            self.appModels = ko.observableArray(
                self.domainModel().map(struct => {
                    return self.createStruct(struct);
                })
            );

        }

        self.createRow = function() {
            var lt = self.getLayoutByDev(self.layoutType());
            var row = {
                rowtitle: ko.observable( '' ),
                showtitle: ko.observable( false ),
                listOfCols: ko.observableArray([])
            };
            lt.push(row);
            self.activeRow(row);
        }

        self.createCol = function (col) {
            var colmn = {
                colsize: ko.observable("4"),
                listOfElements: ko.observableArray([]),
                coltype: col,
                editMode: ko.observable("table")
            };

            self.activeRow().listOfCols.push(colmn);
        }

        self.removeBlock = function (data, parent, search) {
            if ( search !== undefined && search !== null) {
                parent().search().layout.remove(data);
            } else if ( parent().layout === undefined ) {
                parent.remove(data);
            } else {
                parent().layout.remove(data);
            }
        }

        self.setActivePage = function () {
            var lt = self.getLayoutByDev(self.layoutType());
            if (lt().length > 0) {
                self.activeRow(lt()[0]);
            } else {
                self.activeRow(null);
            }
        }

        // Events

        // Helpers

        self.fieldTypeConverter = function (fieldType, required) {

            var fieldTypeCallback = function(fieldType) {
                switch (fieldType) {
                    case "Hidden Input":
                        return "hidden";
                    case "Select":
                        return "select";
                    case "Multi Select":
                        return "select multi-select";
                    case "Upload File":
                        return "upload";
                    case "Textarea":
                        return "textarea";
                    case "Radio Button":
                        return "radio";
                    case "Checkbox":
                        return "check";
                    case "Image":
                        return "image";
                    case "Button":
                        return "button";
                    case "Text":
                        return "text";
                    case "Workflow":
                        return "workflow";
                    case "Process Cat":
                        return "processcat";
                    case "Paper No":
                        return "paperno";
                    default:
                        return "input";
                }
            }
            var fieldTypeResult = fieldTypeCallback(fieldType);
            if ( required ) fieldTypeResult += " red-border";
            return fieldTypeResult; 
        };

        self.getLayoutByDev = function (dev) {
            switch (dev) {
                case "devAdd":
                    return self.appLayout.addLayout().layout;
                case "devUpdate":
                    return self.appLayout.updLayout().layout;
                case "devList":
                    return self.appLayout.listLayout().layout;
                case "devSearch":
                    return self.appLayout.listLayout().search().layout;
                case "devDash":
                    return self.appLayout.dashLayout().layout;
                case "devInfo":
                    return self.appLayout.infoLayout().layout;
            }
        };

        self.getLayoutByType = function() {
            switch (self.layoutType()) {
                case "devAdd":
                    return self.appLayout.addLayout;
                case "devUpdate":
                    return self.appLayout.updLayout;
                case "devList":
                    return self.appLayout.listLayout;
                case "devSearch":
                    return self.appLayout.listLayout().search().layout;
                case "devDash":
                    return self.appLayout.dashLayout;
                case "devInfo":
                    return self.appLayout.infoLayout;
            }
        };

        self.setLang = function (module,id,name,langId) {
            self.activeItem(langId + '.' + name);
            self.activeItem = null;
        }

        self.graphDroped = function(item, sourceIndex, sourceItems, targetIndex, targetItems) {
            var elm = Object.assign( {}, item );
            elm.graphMethod = ko.observable('');
            targetItems.splice( targetIndex, 0, elm );
        }
        self.graphArgDropped = function(item, sourceIndex, sourceItems, targetIndex, targetItems) {
            if (item.devSearch() === true) {
                var elm = Object.assign( {}, item );
                elm.graphMethod = ko.observable('');
                elm.graphMethodArg = ko.observable('');
                targetItems.splice( targetIndex, 0, elm );
            }
        }
        
        // Helpers
        
        return {
            init: function (id) {
                self.appCreate();
                ko.applyBindings(self, document.getElementById(id));
            },
            status: function () {
                return self.appModels();
            },
            save: function () {
                var jdata = ko.toJSON({ layout: self.appLayout, domain: self.domainModel });
                jq.post("WDO/catalogs/designers/mockupdesigner/model.cfc?method=save", 
                {
                    mockup_id: "<cfoutput>#(attributes.event eq 'upd' and isDefined("attributes.id")) ? attributes.id : ''#</cfoutput>",
                    mockup_name: self.mockup_name(),
                    mockup_design: jdata,
                    mockup_author_id: document.getElementById('employee_id').value,
                    mockup_author_name: document.getElementById('employee_name').value,
                    work_id: self.work_id(),
                    qpic_rs_id: self.qpic_rs_id(),
                    isAjax: 1
                }).done(function (response) {
                    let resp = JSON.parse(response);
                    if( resp.status ){
                        alertify.success( resp.message );
                        <cfif isDefined("attributes.from_work") and attributes.from_work eq 1>
                            window.close();
                        <cfelse>
                            <cfif attributes.event eq 'upd' and isDefined("attributes.id")>
                                location.reload();
                            <cfelse>
                                location.href = '<cfoutput>#request.self#?fuseaction=dev.mockup&event=upd&id=</cfoutput>' + resp.result.identitycol;
                            </cfif>
                        </cfif>
                    }
                    else alertify.error( resp.message );
                });
                
                return false;
            },
            <cfif attributes.event eq 'upd' and isDefined("attributes.id")>
            delete: function() {
                jq.post("WDO/catalogs/designers/mockupdesigner/model.cfc?method=delete", 
                {
                    mockup_id: "<cfoutput>#attributes.id#</cfoutput>"
                }).done(function (response) {
                    let resp = JSON.parse(response);
                    if( resp.status ){
                        alertify.success( resp.message );
                        location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=dev.mockup";
                    }else alertify.error( resp.message );
                });
            },
            </cfif>
            setLayoutType: function ( type ) {
                self.layoutType(type);
                return true;
            },
            setValue : function(val) {
                if (self.activeItem !== null) {
                    self.activeItem(val);
                }
            }
        }

    }(ko, jQuery);

    function setFieldValue(val) {
        appDesign.setValue(val);
    }

    function getFieldValue(types) {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_systemPopup' + (types !== undefined ? "&types=" + types : ""), 'wide');
    }

    appDesign.init('app-mockup_designer');
</script>