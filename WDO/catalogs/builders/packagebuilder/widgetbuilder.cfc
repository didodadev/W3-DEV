<!---
    File :          widgetbuilder.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          25.02.2019
    Description :   Widgetlerin publish edilmesi esnasında kod paketlemesi ve yayınlamasını sağlar
    Notes :         
--->
<cfcomponent>

    <cfproperty name="widget" type="any">
    <cfproperty name="dsn" type="any">
    <cfproperty name="identcount" type="numeric">

    <cfset _crlf = "">

    <cffunction name="init">
        <cfargument name="widget" type="any">
        <cfset this.widget = arguments.widget>
        <cfset this.dsn = application.systemParam.systemParam().dsn>
        <cfset this.identcount = 1> 
        <cfreturn this>
    </cffunction>

    <cfset object_resolver = "">
    <cffunction name="getScopedFsoBuilder">
        <cfif not isObject( object_resolver )>
            <cfobject name="object_resolver" type="component" component="WDO.catalogs.objectResolver">
            <cfset object_resolver.init()>
        </cfif>
        <cfset result = object_resolver.resolveByRequest( "WDO.catalogs.packagebuilder.fsobuilder" )>
        <cfreturn result>
    </cffunction>

    <cffunction name="generate">
        <cfset code = "">
        <cfset datacode = "">
        <cfset widget_depend_list = arrayNew(1)>

        <!--- get widget detail for dependencies --->
        <cfquery name="query_widget" datasource="#this.dsn#">
            SELECT * FROM WRK_WIDGET WHERE WIDGETID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#this.widget.id#'>
        </cfquery>
        <cfquery name="query_model" datasource="#this.dsn#">
            SELECT * FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#query_widget.WIDGET_FUSEACTION#'>
        </cfquery>
        <cfset modelData = deserializeJSON( query_model.MODELJSON )>
        <cfif len( query_widget.WIDGET_DEPENDS ) and query_widget.WIDGET_DEPENDS neq '[]'>
            
            <cfset tempDep = deserializeJSON( query_widget.WIDGET_DEPENDS )>
            <cfset arrayAppend( widget_depend_list, { fuseaction: query_widget.WIDGET_FUSEACTION, deps: tempDep }, 1 )>
            <cfset getScopedFsoBuilder().write_depended_component( query_widget.WIDGET_FUSEACTION )>
            <cfset code = code & build_dependencies( widget_depend_list, "action", query_widget.WIDGET_STRUCTURE ) & crlf()>
            <cfset datacode = datacode & build_dependencies( widget_depend_list, "data" ) & crlf()>

            <!--- generate dynamic properties 
            <cfloop array="#this.widget.props#" index="prop">
                <cfset modelStruct = arrayFilter( modelData, function( stck ) { return stck.name eq prop.struct })[1]>
                <cfif arrayLen( arrayFilter( modelStruct.listOfProperties, function( p ) { return arrayLen(p.listOfConditions) eq 0; } ) ) gt 0>
                <cfset code = code & "<c" & 'fif isDefined("' & underscore_fuseaction( query_widget.WIDGET_FUSEACTION ) & '_component.get_dynamic_property_' & prop.struct & '_' & prop.label & '")>' & crlf()>
                <cfset code = code & "<c" & 'fset dynamic_property_' & prop.struct & '_' & prop.label & ' = ' & underscore_fuseaction( query_widget.WIDGET_FUSEACTION ) & '_component.get_dynamic_property_' & prop.struct & '_' & prop.label & '("' & prop.valuedata & '")>' & crlf()>
                <cfset code = code & "</cfif>" & crlf()>
                </cfif>
                
            </cfloop>
            --->
        </cfif>
        <cfif query_widget.WIDGET_EVENT_TYPE eq "add" or query_widget.WIDGET_EVENT_TYPE eq "upd">
            <cfset code = code & crlf() & '<cfset objRequest = GetPageContext().GetRequest() />'>
            <cfset code = code & crlf() & '<cfset strUrl = objRequest.GetRequestUrl().Append( "?" & objRequest.GetQueryString() ).ToString()/>'>
            <cfset code = code & crlf() & '<c' & 'fform method="POST" action="##strUrl##">' & crlf() & ident() & '<' & 'input type="hidden" name="submited" value="1">' & crlf()>
            <cfset code = code & ident( 2 ) & query_widget.WIDGET_CODE & crlf()>
            <cfset code = code & '<' & 'cf_box_footer>' & crlf()>
            <cfset code = code & ident( 1 ) & '<' & 'div class="col col-12">' & crlf()>
            <cfset code = code & ident( 2 ) & '<' & 'cf_workcube_buttons is_upd="0" is_delete="0" add_function="widgetpost(this)" >' & crlf()>
            <cfset code = code & ident( 1 ) & '<' & '/div>' & crlf()>
            <cfset code = code & '<' & '/cf_box_footer>'>
            <cfset code = code & crlf() & '<' & '/cfform>'>
        <cfelse>
            <cfset code = code & query_widget.WIDGET_CODE & crlf()>
        </cfif>
        <cfset getScopedFsoBuilder().write_widget( code, query_widget.WIDGET_EVENT_TYPE, query_widget.WIDGET_VERSION )>
        <cfset getScopedFsoBuilder().write_widget_data( datacode, query_widget.WIDGET_EVENT_TYPE, query_widget.WIDGET_VERSION )>

    </cffunction>

    <cffunction name="build_dependencies">
        <cfargument name="depends" type="array">
        <cfargument name="act_type" type="string" default="action">
        <cfargument name="structure" type="string" default="">

        <cfset depcode = "">
        <!--- looping depend list --->
        <cfloop array="#arguments.depends#" index="depend_main_struct">
            <!--- get the model from wrk_model --->
            <cfquery name="query_model" datasource="#this.dsn#">
                SELECT * FROM WRK_MODEL WHERE MODEL_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#depend_main_struct.fuseaction#'>
            </cfquery>

            <cfset model = deserializeJSON( query_model.MODELJSON )>
            <!--- loop depended fuseaction based object --->
            
            <cfscript>
                // save depended objects
                arrayAppend( arguments.depends, depend_main_struct.fuseaction );
                // generate component code
                depcode = depcode & crlf() & '<c' & 'fobject name="' & underscore_fuseaction( depend_main_struct.fuseaction ) & '_component" component="nocode.' & underscore_fuseaction( depend_main_struct.fuseaction ) & '.' & getScopedFsoBuilder().event_status & '.' & underscore_fuseaction( depend_main_struct.fuseaction ) & '">';
                depcode = depcode & crlf() & '<c' & 'fset ' & underscore_fuseaction( depend_main_struct.fuseaction ) & '_component.init()>';
            </cfscript>
            <cfloop array="#depend_main_struct.deps#" item="depend_inner_struct" index="depi">
                <cfscript>
                    // find current struct object from depended object struct name
                    current_struct = arrayFilter( model, function( elm ) { return elm.name eq depend_inner_struct.dependstruct; } )[1];

                    // generate action code
                    
                    if ( arguments.act_type eq "action" ) {

                        // generate call action
                        
                        if ( depend_inner_struct.dependevent eq "update" ) {
                            depcode = depcode & crlf() & generate_event_action_update( depend_inner_struct, current_struct.name, current_struct.structtype ) & crlf();
                        } else if ( depend_inner_struct.dependevent eq "list" ) {
                            depcode = depcode & crlf() & generate_event_action_list( depend_inner_struct, current_struct.name, current_struct.structtype, arguments.structure ) & crlf();
                        } else if ( depend_inner_struct.dependevent eq "dashboard" ) {
                            depcode = depcode & crlf() & generate_event_action_dash( depend_inner_struct, current_struct.name, current_struct.structtype ) & crlf();
                        }

                    } else if ( arguments.act_type eq "data" ) {
                        
                        //generate call data
                        if ( depend_inner_struct.dependevent eq "update" or depend_inner_struct.dependevent eq "add" ) {
                            depcode = depcode & crlf() & generate_event_data( depend_inner_struct, current_struct.name, current_struct.structtype, depend_inner_struct.dependevent, arrayLen(depend_main_struct.deps) eq depi );
                        }
                    }
                </cfscript>
            </cfloop>
        </cfloop>
        <cfreturn depcode>
    </cffunction>

    <cffunction name="generate_event_action">
        <cfargument name="depend" type="any">
        <cfargument name="struct_name" type="string">
        <cfargument name="struct_type" type="string">
        <cfscript>
            depcode = '<c' & 'fset ' & arguments.depend.dependstruct & "_query = " & underscore_fuseaction( arguments.depend.dependcomponent ) & "_component." & arguments.struct_name & "_";
        </cfscript>
        <cfreturn depcode>
    </cffunction>

    <cffunction name="generate_event_action_update" returntype="string">
        <cfargument name="depend" type="any">
        <cfargument name="struct_name" type="string">
        <cfargument name="struct_type" type="string">
        <cfreturn generate_event_action( arguments.depend, arguments.struct_name, arguments.struct_type ) & 'get(argumentCollection=attributes)>'>
    </cffunction>

    <cffunction name="generate_event_action_dash" returntype="string">
        <cfargument name="depend" type="any">
        <cfargument name="struct_name" type="string">
        <cfargument name="struct_type" type="string">
        <cfreturn generate_event_action( arguments.depend, arguments.struct_name, arguments.struct_type ) & 'dash>'>
    </cffunction>

    <cffunction name="generate_event_action_list">
        <cfargument name="depend" type="any">
        <cfargument name="struct_name" type="string">
        <cfargument name="struct_type" type="string">
        <cfargument name="struct_data" type="string">
        <cfscript>
            depcode = "";

            structure = deserializeJSON(arguments.struct_data);
            if (isDefined("structure.search.keyword") and arrayLen(structure.search.keyword)) {
                depcode = depcode & "<c" & 'fif isDefined("attributes.keyword") and len(attributes.keyword)>' & crlf();
                depcode = depcode & "<c" & 'fset search_criteria = listMap(attributes.keyword, function(itm) { return "*##itm##*"; }, " ")>' & crlf();
                depcode = depcode & "<c" & 'fsearch collection="' & underscore_fuseaction( arguments.depend.dependcomponent ) &  '_collection" name="' & underscore_fuseaction( arguments.depend.dependcomponent ) & '_search" status="' & underscore_fuseaction( arguments.depend.dependcomponent ) & '_collection_status" criteria="##search_criteria##">' & crlf();
                depcode = depcode & '<c' & "fif " & underscore_fuseaction( arguments.depend.dependcomponent ) & "_collection_status.found>" & crlf();
                depcode = depcode & '<c' & "fset attributes.keywordids = valueList(" & underscore_fuseaction( arguments.depend.dependcomponent ) & "_search.key )>" & crlf();
                depcode = depcode & "<c" & 'felse>' & crlf();
                depcode = depcode & "<c" & 'fset attributes.keywordids = "0">' & crlf();
                depcode = depcode & "</cfif>" & crlf();
                depcode = depcode & "</cfif>" & crlf();
            } else {
                depcode = depcode & "<c" & 'fset attributes.searched = 1>' & crlf();
            }

            depcode = depcode & "<c" & 'fif isDefined("attributes.searched")>' & crlf();
            depcode = depcode & generate_event_action( arguments.depend, arguments.struct_name, arguments.struct_type ) & 'list(argumentCollection=attributes)>' & crlf();
            depcode = depcode & "</c" & 'fif>' & crlf();
        </cfscript>

        <cfreturn depcode>
    </cffunction>

    <cffunction name="generate_event_data">
        <cfargument name="depend" type="any">
        <cfargument name="struct_name" type="string">
        <cfargument name="struct_type" type="string">
        <cfargument name="depended_event" type="string">
        <cfargument name="lastdata" type="boolean">
        
        <cfobject name="functionbuilder" component="WDO.catalogs.builders.packagebuilder.functionbuilder">
        <cfscript>
            depcode = "<c" & 'ftry>' & crlf();
            depcode = depcode & functionbuilder.generate( arguments.depend.dependcomponent, arguments.depended_event, arguments.struct_name ) & crlf();
            if (lastdata) {
                depcode = depcode & "<c" & 'fset GetPageContext().getCFOutput().clear()>' & crlf();
                depcode = depcode & '<script type="text/javascript">document.location.href="<cfoutput>##request.self##?fuseaction=##attributes.fuseaction##</cfoutput>"</script>' & crlf();
            }
            depcode = depcode & "<c" & 'fcatch>' & crlf();
            depcode = depcode & "<c" & 'fdump var="##cfcatch##"></cfcatch></cftry>' & crlf();
        </cfscript>
        <cfreturn depcode>
    </cffunction>

    <!--- helpers --->
    <cffunction name="underscore_fuseaction">
        <cfargument name="fuseaction" type="string">
        <cfreturn replace( arguments.fuseaction, ".", "_" )>
    </cffunction>

    <cffunction name="crlf" access="public" returntype="string">
        <cfscript>
            if (len(_crlf) eq 0)
            {
                _crlf = CreateObject("java", "java.lang.System").getProperty("line.separator");
            }
        </cfscript>
        <cfreturn _crlf>
    </cffunction>

    <cffunction name="ident" access="public" returntype="string">
        <cfargument name="count" type="numeric" default="#this.identcount#">
        <cfreturn repeatString("     ", arguments.count)>
    </cffunction>

</cfcomponent>