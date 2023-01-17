<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT DISTINCT
		B.BRANCH_ID, 
		B.BRANCH_NAME 
	FROM 
		BRANCH B,
        DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        D.BRANCH_ID = B.BRANCH_ID 
        <cfif not session.ep.admin and not session.ep.ehesap>
        AND
        D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
        </cfif>
	ORDER BY 
		B.BRANCH_NAME
</cfquery>

<cfinclude template="../query/get_pos_equipment.cfm">

<cfparam name="attributes.mode" default='4'>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_box_elements>
            <div class="col col-6 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <cfoutput query="GET_BRANCH">
                    <cfif currentrow eq 1 or currentrow mod attributes.mode eq 1><ul class="ui-list"></cfif>
                        <li>
                            <a href="javascript:void(0)">
                                <div class="ui-list-left">
                                    #branch_name#
                                </div>
                                <div class="ui-list-right">
                                    <i class="fa fa-chevron-down"></i>
                                    <i class="fa fa-plus" onClick="openBoxDraggable('#request.self#?fuseaction=retail.list_pos_equipment&event=add&branch_id=#BRANCH_ID#');"></i>
                                </div>
                            </a>
                            <br /><br />
                            <cfquery name="get_kasalar" dbtype="query">
                                SELECT * FROM GET_POS_EQUIPMENT WHERE BRANCH_ID = #BRANCH_ID#
                            </cfquery>
                            <ul>
                                <cfif get_kasalar.recordcount>
                                    <cfloop query="get_kasalar">
                                        <li>
                                            <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=retail.list_pos_equipment&event=upd&pos_id=#pos_id#');">#EQUIPMENT# (#EQUIPMENT_CODE#)</a>
                                        </li>
                                    </cfloop>
                                <cfelse>
                                    <li><cf_get_lang dictionary_id='62578.Kasa Kaydı Yok'>!</li>
                                </cfif>
                            </ul>
                            <br /><br />
                        </li>
                    <cfif currentrow eq GET_BRANCH.recordcount and currentrow mod attributes.mode eq 0></ul></cfif>
                </cfoutput>
            </div>
        </cf_box_elements>
    </cf_box>
</div>