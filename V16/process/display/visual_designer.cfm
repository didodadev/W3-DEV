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
    <script type="text/javascript" src="/JS/mxgraph/appproc/js/wrkshapes.js"></script>
    <script type="text/javascript" src="/JS/mxgraph/appproc/js/app.js"></script>
    <form method="POST" id="saveform">
        <input type="hidden" name="savedvalue" id="savedvalue">
        <input type="hidden" name="action" value="save">
    </form>

    <div id="graph" class="base">
        <!-- Graph Here -->
    </div>

    <script type="text/javascript">
        window.process_id = <cfoutput>#attributes.process_id#</cfoutput>;
        $(document).ready(function () {
            createEditor('/JS/mxgraph/appproc/config/workfloweditor.xml');
        });
    </script>

<cfelseif attributes.action eq "open">

    <cfquery name="query_process_stage" datasource="#dsn#">
        SELECT PROCESS_ROW_ID, PROCESS_ID, STAGE, IS_SMS, IS_EMAIL, IS_ONLINE, PROCESS_ROW_ID, LINE_NUMBER,STAGE_CODE, ISNULL(DESIGN_XY_COORD, '70,70;') AS DESIGN_XY_COORD FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> ORDER BY LINE_NUMBER
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
        <cfoutput query="query_process_stage">
            <Shape label="#replace_amp(STAGE)#" href="" title="Stage" kind="mainprocess" id="1#PROCESS_ROW_ID#" serverid="#PROCESS_ROW_ID#">
                <mxCell style="mainprocess" vertex="1" shape="mainprocess" parent="1">
                    <mxGeometry x="#listGetAt(listGetAt((DESIGN_XY_COORD eq '70,70;' ? lastcoords : DESIGN_XY_COORD),1,";"),1,",")#" y="#listGetAt(listGetAt(DESIGN_XY_COORD,1,";"),2,",")#" width="150" height="80" as="geometry"/>
                </mxCell>
            </Shape>
            <cfif currentrow gt 1>
            <Edge label="" description="" id="#currentrow##PROCESS_ROW_ID#">
                <mxCell style="exitX=1;exitY=0.5;entryX=0;entryY=0.5;" edge="1" parent="1" source="1#lastid#" target="1#PROCESS_ROW_ID#">
                    <mxGeometry relative="1" as="geometry"/>
                </mxCell>
            </Edge>
            </cfif>
            <cfset lastid = PROCESS_ROW_ID>
            <cfset calculatedcoords = '#listGetAt(listGetAt(lastcoords,1,";"),1,",") + 160#,70;'>
            <cfset lastcoords = DESIGN_XY_COORD eq '70,70;' ? calculatedcoords : DESIGN_XY_COORD>
        </cfoutput>
	</root>
</mxGraphModel>
<cfabort>

<cfelseif attributes.action eq "save">

    <cfscript>
        docu = deserializeXML(attributes.savedvalue);
        ids = arrayNew(1);
        edges = arrayNew(1);
        shapes = arrayNew(1);
        orderedshapes = arrayNew(1);

        for (shape in docu.mxgraphmodel.root.xmlchildren) {
            if (shape.xmlname is "edge") {
                arrayAppend(edges, shape);
            } else if (shape.xmlname is "shape" and shape.xmlattributes.kind eq "mainprocess") {
                arrayAppend(shapes, shape);
            }
        }

        for (shape in shapes) {
            founded = arrayFind(edges, function(elm) { return shape.xmlattributes.id eq elm.mxcell.xmlattributes.target; });
            if (not founded) firstshape = shape;
        }

        arrayAppend(orderedshapes, firstshape);
        
        while (true) {
            next_edge_index = arrayFind(edges, function(elm) { return firstshape.xmlattributes.id eq elm.mxcell.xmlattributes.source; });
            if (next_edge_index eq 0) break;
            next_edge = edges[next_edge_index];
            next_shape_index = arrayFind(shapes, function(elm) { return elm.xmlattributes.id eq next_edge.mxcell.xmlattributes.target });
            firstshape = shapes[next_shape_index];
            arrayAppend(orderedshapes, firstshape);
        }

    </cfscript>

    <cfloop array="#orderedshapes#" index="i" item="shape">
        <cfif shape.xmlattributes.serverid eq 0>
            <cfquery name="save_object" datasource="#dsn#">	
                INSERT INTO
                PROCESS_TYPE_ROWS
                (
                    PROCESS_ID,
                    IS_WARNING,
                    IS_SMS,
                    IS_EMAIL,
                    IS_ONLINE,
                    STAGE_CODE,
                    STAGE,
                    DETAIL,
                    LINE_NUMBER,
                    ANSWER_HOUR,
                    ANSWER_MINUTE,
                    FILE_NAME,
                    FILE_SERVER_ID,
                    IS_FILE_NAME,
                    DISPLAY_FILE_NAME,
                    DISPLAY_FILE_SERVER_ID,
                    IS_DISPLAY_FILE_NAME,
                    IS_CONFIRM,
                    CONFIRM_REQUEST,
                    IS_ACTION,
                    IS_DISPLAY,
                    IS_CONTINUE,
                    IS_EMPLOYEE,
                    IS_PARTNER,
                    IS_CONSUMER,
                    DESIGN_XY_COORD,
                    RECORD_DATE,
                    RECORD_EMP,
                    RECORD_IP			
                )
                VALUES
                (
                    #attributes.process_id#,
                    0,
                    0,
                    0,
                    0,
                    NULL,
                    '#shape.xmlattributes.label#',
                    NULL,
                    #i#,
                    0,
                    0,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    '#shape.mxcell.mxgeometry.xmlattributes.x#,#shape.mxcell.mxgeometry.xmlattributes.y#;',
                    #now()#,
                    #session.ep.userid#,
                    '#cgi.remote_addr#'			
                )
            </cfquery>
        <cfelse>
            <cfquery name="save_object" datasource="#dsn#">	
                UPDATE PROCESS_TYPE_ROWS SET STAGE = '#shape.xmlattributes.label#', LINE_NUMBER = #i#, DESIGN_XY_COORD = '#shape.mxcell.mxgeometry.xmlattributes.x#,#shape.mxcell.mxgeometry.xmlattributes.y#;' WHERE PROCESS_ROW_ID = #shape.xmlattributes.serverid#
            </cfquery>
        </cfif>
    </cfloop>

    <script>
        document.location.href = document.location.href + '&refreshed=' + Math.random();
    </script>
</cfif>