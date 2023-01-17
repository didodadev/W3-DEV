<cfsetting showdebugoutput="no">
<cfquery name="gel_all_workgroups" datasource="#dsn#">
	SELECT * FROM WORK_GROUP WHERE HIERARCHY IS NOT NULL AND IS_ORG_VIEW = 1
</cfquery>
<cfquery name="get_head_workgroups" dbtype="query">
	SELECT * FROM gel_all_workgroups WHERE HIERARCHY NOT LIKE '%.%' ORDER BY HIERARCHY
</cfquery>

<ul class="ui-list">
    <cfoutput>
    <cfloop query="get_head_workgroups">
        <cfquery name="get_second_workgroups" dbtype="query">
            SELECT * FROM gel_all_workgroups WHERE HIERARCHY LIKE '#get_head_workgroups.HIERARCHY#.%' ORDER BY HIERARCHY
        </cfquery>
    <li>
        <a href="javascript:void(0)" title="<cf_get_lang dictionary_id='58140.İş Grubu'>" onclick="windowopen('#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#get_head_workgroups.workgroup_id#','list');">
            <div class="ui-list-left">
                <span class="ui-list-icon ctl-profits"></span>
                #get_head_workgroups.WORKGROUP_NAME# (#get_head_workgroups.HIERARCHY#)
            </div>
            <div class="ui-list-right">
                <cfif get_second_workgroups.recordcount><i class="fa fa-chevron-down"></i></cfif>
            </div>
        </a>
            <cfif get_second_workgroups.recordcount>
                <ul>
                <li>
                <cfloop query="get_second_workgroups">
            <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=hr.popup_draw_workgroup&workgroup_id=#get_second_workgroups.workgroup_id#','list');">
                <div class="ui-list-left">
                    <span class="ui-list-icon ctl-profits"></span>
                    #get_second_workgroups.WORKGROUP_NAME# (#get_second_workgroups.HIERARCHY#)
                </div>
                <div class="ui-list-right">
                    <i class="fa fa-chevron-down"></i>
                </div>
            </a>
            </cfloop>
        </li>
        </ul>
        </cfif>
    </li>
</cfloop>
</cfoutput>
</ul>
<script>
    $('.ui-list li a i.fa-chevron-down').click(function(){
        $(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
        $(this).closest('li').find("> ul").fadeToggle();
    });
</script>