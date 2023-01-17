<script type="text/javascript">

/**
 * Services
 */
var appSessionService = function() {

    var self = this;

    <cfobject name="flatter" component="WDO.catalogs.objectPropertyFlatter">
    <cfset flatArray = flatter.flatten(session, arrayNew(1), "session")>
    
    self.sessionVars = <cfoutput>#replace( serializeJson(flatArray), "//", "" )#</cfoutput>;

    return {
        getSessionList:  function () {
            return self.sessionVars.map( function(elm) { return { label: elm } } );
        }
    }

}();

/**
 * Helpers
 */
function isFunction(functionToCheck) {
    return functionToCheck && {}.toString.call(functionToCheck) === '[object Function]';
}

function arraymove(arr, fromIndex, toIndex) {
    var element = isFunction( arr ) ? arr()[fromIndex] : arr[fromIndex];
    arr.splice(fromIndex, 1);
    arr.splice(toIndex, 0, element);
}

/**
 * App Mapper
 */
var appMapper = function( ko, jq ) {

    var self = this;

    /**
     * Extends
     */
    self.distincateLabel = function( v,i,s ) {
        return s.indexOf( s.find( function( e ) { return ( isFunction(e.label) ? e.label() : e.label ) === ( isFunction( s[i].label ) ? s[i].label() : s[i].label ) } ) ) === i;
    };

    /**
     * Variables
     */
    self.sourceModel = ko.observableArray( [] );
    self.targetModel = ko.observableArray( [] );
    self.mappingModel = ko.observableArray( [] );
    self.sourceFuseaction = ko.observable( "settings.ncetkinlik" );
    self.sourceStructs = ko.observableArray( [] );
    self.sourceStruct = ko.observableArray( "" );
    self.targetFuseaction = ko.observable( "cube.local" );
    self.targetStructs = ko.observableArray( [] );
    self.targetStruct = ko.observableArray( "" );

    /**
     * Computed vars
     */
    self.mappedList = ko.computed( function () {
        return [ ...self.sourceModel().filter(self.distincateLabel).map(function( elm ) { var neo = Object.assign({}, elm); neo.label = self.sourceStruct() + "." + elm.label; return neo; }), ...self.mappingModel().filter(self.distincateLabel).map(function(elm) { return { label: 'map.' + elm.label() }; }) ];
    });

    self.sourceList = ko.computed( function() {
        return [ ...self.mappedList().filter(self.distincateLabel), ...appSessionService.getSessionList().filter(self.distincateLabel) ];
    });


    /**
     * Maps
     */
    self.createMap = function (mapdata) {
        var mapping = {
            conditions: ko.observableArray( mapdata == null ? [] : mapdata.conditions.map( function(elm) { return self.createCondition( elm ); } ) ),
            label: ko.observable( mapdata == null ? 'unnamed_field' : mapdata.label ),
            converter: ko.observable( mapdata == null ? '' : mapdata.converter )
        }
        return mapping;
    };
    self.addMap = function() {
        self.mappingModel.push(self.createMap(null));
    };
    self.mapUpOne = function(data) {
        if (self.mappingModel().indexOf(data) > 0) {
            currentIndex = self.mappingModel().indexOf(data);
            arraymove(self.mappingModel, currentIndex, currentIndex-1);
        }
    };
    self.mapDownOne = function (data) {
        if (self.mappingModel().indexOf(data) < self.mappingModel().length-1) {
            currentIndex = self.mappingModel().indexOf(data);
            arraymove(self.mappingModel, currentIndex, currentIndex+1);
        }
    };
    self.mapRemove = function (data) {
        if (confirm( "Are you sure?" ))
            self.mappingModel.remove(data);
    }
    
    
    /**
     * Sources
     */
    self.createSource = function(source) {
        var source = {
            label: ko.observable( source == null ? '' : source.label )
        };
        return source;
    };
    self.addSource = function(container) {
        container.sources.push( self.createSource( null ) );
    };
    self.removeSource = function(container, item) {
        container.sources.remove(item);
    };

    /**
     * Conditions
     */
    self.createCondition = function(condition) {
        var condition = {
            type: ko.observable( condition == null ? 'exp' : condition.type ),
            left: ko.observable( condition == null ? '' : condition.left ),
            equality: ko.observable( condition == null ? '' : condition.equality ),
            right: ko.observable( condition == null ? '' : condition.right ),
            join: ko.observable( condition == null ? 'and' : condition.join )
        };
        return condition;
    };
    self.addCondition = function (container) {
        container.conditions.push( self.createCondition(null) );
    };
    self.removeCondition = function (container, item) {
        container.conditions.remove( item );
    };

    /**
     * Constructors
     */
    self.getStructList = function(fuse, type) {
        $.ajax({
            url: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=map&fuseact="+ fuse +"&ajax=1&ajax_box_page=1&isAjax=1&mode=structlist"
        }).done(function( data ) {
            jdata = JSON.parse(data);
            if (type == "source") {
                self.sourceStructs( jdata );
            } else if (type == "target") {
                self.targetStructs( jdata );
            }
        });
    };
    self.getStruct = function(fuse, name, type) {
        $.ajax({
            url: "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_system&type=map&fuseact="+ fuse +"&ajax=1&ajax_box_page=1&isAjax=1&mode=structdet&struct="+name
        }).done(function (data) {
            jdata = JSON.parse(data);
            if (type == "source") {
                self.sourceModel( jdata );
            } else if (type == "target") {
                self.targetModel( jdata );
            }
        });
    };

    /**
     * Initilize app
     */
    return {
        init: function (id) {
            ko.applyBindings(self, document.getElementById(id));
        },
        getFieldList: function() {
            return self.sourceList();
        }
    };

}(ko, jQuery);

appMapper.init('appMapper');

function setFieldValue( val ) {
    app.setValue( val );
}
function getFieldValue( types ) {
    windowopen( '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_systemPopup' + (types !== undefined ? "&types=" + types : ""), 'wide' );
}

function getFieldList() {
    return ko.toJS(appMapper.getFieldList());
}

</script>