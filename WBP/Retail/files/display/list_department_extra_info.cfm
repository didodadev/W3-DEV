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

<cfoutput query="GET_BRANCH">
	<cfquery name="get_" datasource="#dsn_dev#">
    	SELECT * FROM BRANCH_EXTRA_INFO WHERE BRANCH_ID = #BRANCH_ID#
    </cfquery>
    <cfif not get_.recordcount>
    	<cfquery name="add_" datasource="#dsn_dev#">
        	INSERT INTO BRANCH_EXTRA_INFO (BRANCH_ID) VALUES (#BRANCH_ID#)
        </cfquery>
    </cfif>
</cfoutput>

<cfparam name="attributes.mode" default='4'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61650.Şube Ek Tanımları'></cfsavecontent>
    <cf_box title="#message#">
        <cfform action="#request.self#?fuseaction=retail.emptypopup_add_dept_extra_info" method="post" name="add_depts">
            <cfinput type="hidden" name="branch_id_list" value="#valuelist(GET_BRANCH.BRANCH_ID)#">
            <cf_box_elements>
                <cfoutput query="GET_BRANCH">
                    <cfif currentrow eq 1 or currentrow mod attributes.mode eq 1><tr></cfif>
                        <cfquery name="get_" datasource="#dsn_dev#">
                            SELECT * FROM BRANCH_EXTRA_INFO WHERE BRANCH_ID = #BRANCH_ID#
                        </cfquery>
                        <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                            <div class="form-group">
                                <div class="input-group">
                                    <span class="headbold">#branch_name#</span>
                                    <cfsavecontent  variable="message">Local Folder </cfsavecontent>
                                    <cfinput type="text" name="LOCAL_FOLDER_#BRANCH_ID#" style="width:150px;" value="#get_.LOCAL_FOLDER#" placeholder="#message#">
                                </div>
                            </div>
                        </div>
                    <cfif currentrow eq GET_BRANCH.recordcount and currentrow mod attributes.mode eq 0></tr></cfif>
                    </cfoutput>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>