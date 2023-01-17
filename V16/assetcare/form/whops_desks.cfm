<style>
    .scrollbarProject{
        margin-left: 34px;
        margin-right: 34px;
    }
</style>
<cfquery name="GET_SPACES" datasource="#DSN#">
	SELECT
        ASSET_P_DESKS_GROUP_ID,
        BRANCH.BRANCH_NAME,
        ASSET_P_SPACE.SPACE_NAME
	FROM
        #DSN3#.POS_EQUIPMENT,
        BRANCH,
        DEPARTMENT,
        ASSET_P_DESKS_GROUP,
        ASSET_P_SPACE
	WHERE
        DEPARTMENT.BRANCH_ID=POS_EQUIPMENT.BRANCH_ID AND
        DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
        DEPARTMENT.DEPARTMENT_ID=ASSET_P_DESKS_GROUP.DEPARTMENT_ID AND
        ASSET_P_SPACE.ASSET_P_SPACE_ID=ASSET_P_DESKS_GROUP.ASSET_P_SPACE_ID AND
        EQUIPMENT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SESSION.WP.WHOPS.EQUIPMENT_CODE#">
</cfquery>


<div class="step_container">
    <div class="navbar-collapse collapse">
        <ul class="navbar-nav ml-auto d-flex align-items-center">
            <li class="nav-item kasa_css" style="margin-left:10px;"><cf_get_lang dictionary_id="53982.Şube"> <cfoutput>#GET_SPACES.BRANCH_NAME#</cfoutput></li>
        </ul>
    </div>
</div>
<cfset ids=ValueList(GET_SPACES.ASSET_P_DESKS_GROUP_ID)>
<cfset names=ValueList(GET_SPACES.SPACE_NAME,';')>
<cf_tab defaultOpen="1" divId="#ids#" divLang="#names#">
    <cfoutput query="GET_SPACES">
    <cfquery name="GET_DESKS" datasource="#DSN#">
        SELECT 
            DESK_NO,
            (SELECT DISTINCT SPACE_NAME FROM ASSET_P_SPACE WHERE ASSET_P_SPACE_ID=ASSET_P.RELATION_DESKS_ASSETP_ID) SPACE_NAME
        FROM 
            ASSET_P
        WHERE 
            RELATION_DESKS_ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ASSET_P_DESKS_GROUP_ID#"> 
            AND DESK_NO IS NOT NULL
    </cfquery>
    <div id = "unique_#ASSET_P_DESKS_GROUP_ID#" class="ui-info-text uniqueBox">
        <div class="step_container">
            <div class="step_item">
                <div class="step_body step_body-type3" >
                    <div class="category">
                        <cfloop query="GET_DESKS">
                            <div class="cl-6 cl-md-3 cl-sm-6 cl-xs-6">
                                <a href="javascript://" class="category_list_item" style="background:##60C060; border-radius:0; width:122px;">
                                    <div class="category_list_item_text">
                                        <div class="name" style="color:white !important;">#DESK_NO#</div>
                                    </div>
                                </a>
                            </div>
                        </cfloop>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
</cf_tab>
