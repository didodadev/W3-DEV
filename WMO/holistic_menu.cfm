<!---
    File :          holistic_menu
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          25.09.2019
    Description :   Holistic menü dinamik oluşturucusu
    Notes :         
--->
<cfquery name="query_holistic_menu" datasource="#dsn#">
    SELECT EVENT_STRUCTURE, EVENT_TITLE 
    FROM WRK_EVENTS 
    WHERE EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseaction#'> 
    AND EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.event?:'list'#'>
</cfquery>

<cfif query_holistic_menu.recordCount>
    <cfset layout = deserializeJSON( query_holistic_menu.EVENT_STRUCTURE )>
    <cfscript>
        lofWidget = arrayReduce( layout.lofRows, function(rcc, row) {
            rcc = structKeyExists(arguments, "rcc")?arguments.rcc:[];
            arrayAppend( rcc, arrayReduce( row.listOfCols, function(ccc, col) {
                ccc = structKeyExists(arguments, "ccc")?arguments.ccc:[];
                arrayAppend( ccc, col.listOfWidgets, 1 );
                return ccc;
            }, []), 1);
            return rcc;
        }, []);
        iofWidget = arrayFind( lofWidget, function( wdg ) {
            return wdg.uniqid eq layout.masterWidget;
        });
        
        if (iofWidget gt 0) {
            sourceEvent = lofWidget[iofWidget].event?:'';
        }
        
    </cfscript>
</cfif>

<cfsavecontent variable="holistic_tabmenu_content">
    <cfif query_holistic_menu.recordCount>
        <cfif isDefined( "layout.lofTabs" ) and arrayLen( layout.lofTabs )>
            <cfset tabs = arrayFilter(layout.lofTabs, function( elm ){ return elm.place eq 'top' or elm.place eq 'all' }) />
            <cfset tabcount = 1>
            <cfloop array="#tabs#" index="tab">
                <cfif tabcount eq 8>
                    <li class="dropdown">
                        <a class="otherPageBarMenu" href="javascript:void(0)"><cf_get_lang dictionary_id="58156"><i class="fa fa-angle-down fa-lg"></i></a>
                        <ul class="dropdown-menu scrollContent scrollContentDropDown">
                </cfif>
                <cfoutput>
                    <li class="dropdown"><cfoutput>#menuItemFactory(tab, attributes.fuseaction, sourceEvent?:'', 'top')#</cfoutput></li>
                </cfoutput>
                <cfif tabcount eq arrayLen( tabs ) and tabcount gt 8>
                        </ul>
                    </li>
                </cfif>
                <cfset tabcount++>
            </cfloop>
        </cfif>
    </cfif>

    <cfif isDefined("attributes.event") and ( attributes.event eq "add" or attributes.event eq "upd" )>
        <cfoutput><li class="dropdown"><a href="#request.self#?fuseaction=#attributes.fuseaction#" title="Liste"><i class="icon-list-ul"></i></a></li></cfoutput>
        <cfif attributes.event eq "upd">
            <cfoutput><li class="dropdown"><a href="#request.self#?fuseaction=#attributes.fuseaction#&event=add" title="Ekle"><i class="icon-add"></i></a></li></cfoutput>
        </cfif>
    <cfelse>
        <cfoutput><li class="dropdown"><a href="#request.self#?fuseaction=#attributes.fuseaction#&event=add" title="Ekle"><i class="icon-add"></i></a></li></cfoutput>
    </cfif>
</cfsavecontent>

<cfsavecontent variable="holistic_left_menu_content">
    <cfif query_holistic_menu.recordCount>
        <cfif isDefined( "layout.lofTabs" ) and arrayLen( layout.lofTabs )>
            <cfset tabs = arrayFilter(layout.lofTabs, function( elm ){ return elm.place eq 'left' or elm.place eq 'all' }) />
            <cfloop array="#tabs#" index="tab">
                <cfoutput>
                    <li class="list-group-item"><cfoutput>#menuItemFactory(tab, attributes.fuseaction, sourceEvent?:'', 'left')#</cfoutput></li>
                </cfoutput>
            </cfloop>
        </cfif>
    </cfif>
</cfsavecontent>

<script type="text/javascript">
    var holistic_tabmenu_content_js = <cfoutput>#replace( replace( serializeJSON(holistic_tabmenu_content), "//", "" ), "\r\n", "", "all" )#</cfoutput>;
    $("#tabMenu > ul").html(holistic_tabmenu_content_js);
    <cfif len( holistic_left_menu_content )>
        var holistic_leftmenu_content_js = <cfoutput>#replace( replace( serializeJSON(holistic_left_menu_content), "//", "" ), "\r\n", "", "all" )#</cfoutput>;
        $("#holisticLeftMenu ul.ui-list").html(holistic_leftmenu_content_js);
    <cfelse>
        $("#holisticLeftMenu").remove();
        $("#holisticBody").removeClass('col-10').addClass('col-12');
    </cfif>
</script>

<!--- functions --->
<cffunction name="menuItemFactory">
    <cfargument name="tab">
    <cfargument name="fact">
    <cfargument name="event" default="">
    <cfargument name="place" default="top">

    <cfswitch expression="#arguments.tab.type#">
        <cfcase value="popup">
            <cfreturn menuPopupBuilder(arguments.tab, arguments.fact, arguments.event, arguments.place)>
        </cfcase>
        <cfdefaultcase>
            <cfreturn menuLinkBuilder(arguments.tab, arguments.fact, arguments.event, arguments.place)>
        </cfdefaultcase>
    </cfswitch>
</cffunction>

<cffunction name="menuLinkBuilder">
    <cfargument name="tab">
    <cfargument name="fact">
    <cfargument name="event" default="">
    <cfargument name="place" default="top">
    
    <cfquery name="query_widget_depends" datasource="#dsn#">
        SELECT WIDGET_DEPENDS FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fact#'> AND WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.event#'>
    </cfquery>
    <cfset widget_depends_struct = deserializeJSON( len(query_widget_depends.WIDGET_DEPENDS) ? query_widget_depends.WIDGET_DEPENDS : "[]" )>
    <cfsavecontent variable="link">
        <cfset qvalues = "" />
        <cfif isDefined("tab.parameter") and len(tab.parameter)>
            <cfscript>
                qparams = listToArray( tab.parameter, "&" );
                for (i = 1; i <= arrayLen(qparams); i++) {
                    qparam = qparams[i];
                    qparams[i] = listFirst(qparam, "=") & "=";
                    if ( listFirst(listLast(qparam, "="), ".") eq "model" ) 
                    {
                        qparams[i] = qparams[i] & evaluate( widget_depends_struct[1].DEPENDSTRUCT & "_query." & listLast( listLast(qparam, "="), "." ) );
                    } 
                    else if ( listFirst(listLast(qparam, "="), ".") eq "attributes" ) 
                    {
                        qparams[i] = qparams[i] & evaluate( "attributes." & listLast( listLast(qparam, "="), "." ) );
                    }
                }
                qvalues = arrayToList(qparams, "&");
            </cfscript>
        </cfif>
        <cfoutput>
            <cfif structKeyExists(tab, 'iconCss') and len(tab.iconCss)>
                <cfif arguments.place eq 'left'>
                    <a href="#request.self#?fuseaction=#tab.fuseaction#&event=#tab.event#&#qvalues#" #tab.type eq "blank" ? 'target="_blank"' : ""#>
                        <div class="ui-list-left">
                            <i class="#tab.iconCss#"></i>
                            <cf_get_lang dictionary_id="#tab.label#">
                        </div>
                    </a>
                <cfelse>
                    <a href="#request.self#?fuseaction=#tab.fuseaction#&event=#tab.event#&#qvalues#" #tab.type eq "blank" ? 'target="_blank"' : ""# title="<cf_get_lang dictionary_id="#tab.label#">"><i class="#tab.iconCss#"></i></a>
                </cfif>
            <cfelse>
                <a href="#request.self#?fuseaction=#tab.fuseaction#&event=#tab.event#&#qvalues#" #tab.type eq "blank" ? 'target="_blank"' : ""#><cf_get_lang dictionary_id="#tab.label#"></a>
            </cfif>
        </cfoutput>
    </cfsavecontent>
    <cfreturn link>
</cffunction>

<cffunction name="menuPopupBuilder">
    <cfargument name="tab">
    <cfargument name="fact">
    <cfargument name="event" default="">
    <cfargument name="place" default="top">

    <cfquery name="query_widget_depends" datasource="#dsn#">
        SELECT WIDGET_DEPENDS FROM WRK_WIDGET WHERE WIDGET_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.fact#'> AND WIDGET_EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.event#'>
    </cfquery>
    <cfset widget_depends_struct = deserializeJSON( query_widget_depends.WIDGET_DEPENDS )>
    <cfsavecontent variable="link">
        <cfset qvalues = "" />
        <cfif isDefined("tab.parameter") and len(tab.parameter)>
            <cfscript>
                qparams = listToArray( tab.parameter, "&" );
                for (i = 1; i <= arrayLen(qparams); i++) {
                    qparam = qparams[i];
                    qparams[i] = listFirst(qparam, "=") & "=";
                    if ( listFirst(listLast(qparam, "="), ".") eq "model" ) 
                    {
                        qparams[i] = qparams[i] & evaluate( widget_depends_struct[1].DEPENDSTRUCT & "_query." & listLast( listLast(qparam, "="), "." ) );
                    } 
                    else if ( listFirst(listLast(qparam, "="), ".") eq "attributes" ) 
                    {
                        qparams[i] = qparams[i] & evaluate( "attributes." & listLast( listLast(qparam, "="), "." ) );
                    }
                }
                qvalues = arrayToList(qparams, "&");
            </cfscript>
        </cfif>
        <cfoutput>
            <cfif structKeyExists(tab, 'iconCss') and len(tab.iconCss)>
                <cfif arguments.place eq 'left'>
                    <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=#tab.fuseaction#&event=#tab.event#&#qvalues#', '#tab.popup#')">
                        <div class="ui-list-left">
                            <i class="#tab.iconCss#"></i>
                            <cf_get_lang dictionary_id="#tab.label#">
                        </div>
                    </a>
                <cfelse>
                    <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=#tab.fuseaction#&event=#tab.event#&#qvalues#', '#tab.popup#')" title="<cf_get_lang dictionary_id="#tab.label#">"><i class="#tab.iconCss#"></i></a>
                </cfif>
            <cfelse>
                <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=#tab.fuseaction#&event=#tab.event#&#qvalues#', '#tab.popup#')"><cf_get_lang dictionary_id="#tab.label#"></a>
            </cfif>
        </cfoutput>
    </cfsavecontent>
    <cfreturn link>
</cffunction>
