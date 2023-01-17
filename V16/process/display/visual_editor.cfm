<cfparam name="attributes.action" default="view">

<cffunction name="replace_amp">
    <cfargument name="data">

    <cfscript>
        founds = ReFind("&[^aA]", arguments.data, 1, "YES", "all");
        for(found in founds) {
            arguments.data = replaceNoCase(arguments.data, found.match[1], "&amp;" & mid(found.match[1], 2, 1));
        }
    </cfscript>

    <cfreturn arguments.data>
</cffunction>

<cfif attributes.action eq "view">

<style type="text/css" media="screen">
    div.base {
        position: absolute;
        overflow: hidden;
        font-family: Arial;
        font-size: 8pt;
    }
    div.base#graph {
        border-style: solid;
        border-color: #F2F2F2;
        border-width: 1px;
        background: url('/JS/mxgraph/images/grid.gif');
    }
</style>
<script type="text/javascript">
    mxBasePath = '/JS/mxgraph/src/';
</script>
<script type="text/javascript" src="/JS/mxgraph/src/js/mxClient.js"></script>
<script type="text/javascript" src="/JS/mxgraph/appprocmain/js/wrkshapes.js"></script>
<script type="text/javascript" src="/JS/mxgraph/appprocmain/js/app.js"></script>
<form method="POST" id="saveform">
    <input type="hidden" name="savedvalue" id="savedvalue">
    <input type="hidden" name="action" value="save">
</form>

<div id="graph" class="base">
    <!-- Graph Here -->
</div>

<script type="text/javascript">
    $(document).ready(function () {
        createEditor('/JS/mxgraph/appprocmain/config/workfloweditor.xml');
    });
</script>

<cfelseif attributes.action eq "open">

    <cfquery name="query_mainstage" datasource="#dsn#">
        SELECT PROCESS_MAIN_ROWS.*, ISNULL(PROCESS_MAIN_ROWS.DESIGN_XY_COORD, '70,70;') AS DESIGN_XY_COORD FROM PROCESS_MAIN_ROWS INNER JOIN PROCESS_TYPE ON PROCESS_MAIN_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID WHERE PROCESS_MAIN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.main_process_id#'> AND PROCESS_TYPE.IS_ACTIVE = 1
    </cfquery>
    <cfset lastcoords = "70,70;">
<cfset GetPageContext().getCFOutput().clear()>
<mxGraphModel>
	<root>
		<Workflow label="MyWorkflow" description="" href="" id="0">
			<mxCell/>
		</Workflow>
		<Layer label="Default Layer" id="1">
			<mxCell parent="0"/>
        </Layer>
        <cfoutput query="query_mainstage">
            <Shape label="#replace_amp(DESIGN_TITLE)#" href="" title="Process" kind="mainprocess" id="1#PROCESS_ID#" serverid="#PROCESS_ID#">
                <mxCell style="mainprocess" vertex="1" shape="mainprocess" parent="1">
                    <mxGeometry x="#listGetAt(listGetAt(DESIGN_XY_COORD,1,";"),1,",")#" y="#listGetAt(listGetAt((DESIGN_XY_COORD eq '70,70;' ? lastcoords : DESIGN_XY_COORD),1,";"),2,",")#" width="150" height="80" as="geometry"/>
                </mxCell>
            </Shape>
            <cfif currentrow gt 1>
            <Edge label="" description="" id="#currentrow##PROCESS_ID#">
                <mxCell style="exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" parent="1" source="1#lastid#" target="1#PROCESS_ID#">
                    <mxGeometry relative="1" as="geometry"/>
                </mxCell>
            </Edge>
            </cfif>
            <cfset lastid = PROCESS_ID>
            <cfset calculatedcoords = '#listGetAt(listGetAt(lastcoords,1,";"),1,",") + 160#,70;'>
            <cfset lastcoords = DESIGN_XY_COORD eq '70,70;' ? calculatedcoords : DESIGN_XY_COORD>
        </cfoutput>
	</root>
</mxGraphModel>
<cfabort>
<cfelseif attributes.action eq "save">

    <cfset docu = deserializeXML(attributes.savedvalue)>
    <cfset ids = arrayNew(1)>
    <cfloop array="#docu.mxgraphmodel.root.xmlchildren#" item="shape">
        <cfif structKeyExists(shape.xmlattributes, "kind")>
            <cfset serverid = shape.xmlattributes.serverid>
            <cfset label = shape.xmlattributes.label>
            <cfset x = shape.xmlchildren[1].xmlchildren[1].xmlattributes.x?:0>
            <cfset y = shape.xmlchildren[1].xmlchildren[1].xmlattributes.y?:0>
            <cfif serverid eq 0>
                
                <cfquery name="ADD_PROCESS" datasource="#DSN#">
                    INSERT INTO
                        PROCESS_TYPE
                    (
                        IS_ACTIVE,
                        PROCESS_NAME,
                        IS_STAGE_BACK,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        1,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#label#">,
                        0,
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
                    );
                    SELECT @@IDENTITY AS MAX_PROCESS_TYPE_ID
                </cfquery>
                <cfquery name="record_main_rows" datasource="#dsn#">
                    INSERT INTO
                        PROCESS_MAIN_ROWS
                        (	
                            PROCESS_MAIN_ID,
                            PROCESS_ID,
                            DISPLAY_HEADER,
                            ACTION_HEADER,
                            DESIGN_OBJECT_TYPE,
                            DESIGN_TITLE,
                            DESIGN_XY_COORD,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                    VALUES
                        (
                            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.main_process_id#'>,
                            #add_process.max_process_type_id#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Display File">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="Action File">,
                            0,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#label#">,
                            <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value="#x&','&y&';'#">,
                            #now()#,
                            #session.ep.userid#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">	
                        )
                </cfquery>
                <cfquery name="ADD_PROCESS_TYPE_HISTORY" datasource="#dsn#">
                    INSERT INTO
                        PROCESS_TYPE_HISTORY
                    (
                        PROCESS_ID,
                        IS_ACTIVE,
                        PROCESS_NAME,
                        FACTION,
                        IS_STAGE_BACK,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #add_process.max_process_type_id#,
                        1,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#label#">,
                        NULL,
                        0,
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">		
                    )
                </cfquery>
                <cfset arrayAppend(ids, add_process.max_process_type_id)>
            <cfelse>
                <cfquery name="query_upd_process_row" datasource="#dsn#">
                    UPDATE PROCESS_MAIN_ROWS SET DESIGN_TITLE = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#label#'>, DESIGN_XY_COORD = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value="#x&','&y&';'#">
                    WHERE PROCESS_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#serverid#'> 
                </cfquery>
                <cfquery name="query_upd_process" datasource="#dsn#">
                    UPDATE PROCESS_TYPE SET PROCESS_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#label#'> WHERE PROCESS_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#serverid#'> 
                </cfquery>
                <cfset arrayAppend(ids, serverid)>
            </cfif>
        </cfif>
    </cfloop>
    <cfquery name="query_passive" datasource="#dsn#">
        UPDATE PROCESS_TYPE SET IS_ACTIVE = 0 WHERE PROCESS_ID NOT IN (#arrayToList(ids)#)
    </cfquery>
    <script>
        document.location.href = document.location.href + '&refreshed=' + Math.random();
    </script>
</cfif>