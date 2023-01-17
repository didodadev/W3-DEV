<cfquery name="query_holistic_menu" datasource="#dsn#">
    SELECT EVENT_STRUCTURE, EVENT_TITLE 
    FROM WRK_EVENTS 
    WHERE EVENT_FUSEACTION = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.fuseaction#'> 
    AND EVENT_TYPE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#attributes.event?:'list'#'>
</cfquery>

<div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze">
    <span class="pageCaption font-green-sharp bold"><cfoutput>#query_holistic_menu.EVENT_TITLE#</cfoutput></span>
    <div id="pageTab" class="pull-right text-right">
        <nav class="detailHeadButton" id="tabMenu">
            <ul>

            </ul>
        </nav>
    </div>
</div>
