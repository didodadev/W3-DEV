<cfquery name="get_all_headquarters" datasource="#dsn#"><!--- Gruplar (Org Semasinda Gosterilecekler) --->
	SELECT HEADQUARTERS_ID,NAME FROM SETUP_HEADQUARTERS WHERE IS_ORGANIZATION = 1 AND UPPER_HEADQUARTERS_ID IS NULL ORDER BY NAME
</cfquery>
<cfquery name="get_all_headquarters_alt" datasource="#dsn#"><!--- Alt Gruplar (Org Semasinda Gosterilecekler) --->
	SELECT HEADQUARTERS_ID,NAME,UPPER_HEADQUARTERS_ID FROM SETUP_HEADQUARTERS WHERE IS_ORGANIZATION = 1 AND UPPER_HEADQUARTERS_ID IS NOT NULL ORDER BY NAME
</cfquery>
<cfquery name="get_all_comps" datasource="#dsn#"><!--- Sirketler (Org Semasinda Gosterilecekler) --->
	SELECT NICK_NAME,COMP_ID,HEADQUARTERS_ID FROM OUR_COMPANY WHERE IS_ORGANIZATION = 1
</cfquery>
<cfquery name="get_all_branches" datasource="#dsn#"><!--- Subeler (Org Semasinda Gosterilecekler) --->
	SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE IS_ORGANIZATION = 1
</cfquery>
<cfquery name="get_all_department" datasource="#dsn#"><!--- Departmanlar (Org Semasinda Gosterilecekler) --->
	SELECT CAST(DEPARTMENT_ID AS NVARCHAR(10)) AS DEPARTMENT_ID2,DEPARTMENT_ID,BRANCH_ID,DEPARTMENT_HEAD,HIERARCHY_DEP_ID FROM DEPARTMENT WHERE IS_ORGANIZATION = 1
</cfquery>
<cfsetting showdebugoutput="no">
    <ul class="ui-list">
        <cfoutput query="get_all_headquarters">
            <cfquery name="get_head_comp" dbtype="query">
                SELECT * FROM get_all_comps WHERE HEADQUARTERS_ID = #get_all_headquarters.headquarters_id#
            </cfquery>
            <cfquery name="get_head_alts" dbtype="query">
                SELECT * FROM get_all_headquarters_alt WHERE UPPER_HEADQUARTERS_ID = #get_all_headquarters.headquarters_id#
            </cfquery>

        
        <li>
            <a href="javascript:void(0)">
                <div class="ui-list-left">
                    <span class="ui-list-icon ctl-profits"></span>
                    #left(name,40)#
                </div>
                <div class="ui-list-right">
                    <i class="fa fa-chevron-down"></i>
                </div>
            </a>
            <cfif get_head_comp.recordcount or get_head_alts.recordcount>
                <cfif get_head_alts.recordcount>
                <ul>
                    <cfloop query="get_head_alts">
                        <li>
                        <cfquery name="get_head_alt_comp" dbtype="query">
                            SELECT * FROM get_all_comps WHERE HEADQUARTERS_ID = #HEADQUARTERS_ID#
                        </cfquery>
                        <a href="javascript:void(0)">
                            <div class="ui-list-left">
                                <span class="ui-list-icon ctl-flats"></span>
                                #name#
                            </div>
                            <div class="ui-list-right">
                                <i class="fa fa-chevron-down"></i>
                            </div>
                        </a>
                        <cfif get_head_alt_comp.recordcount>
                            <ul>
                            <cfloop query="get_head_alt_comp">
                                <li>
                                <cfquery name="get_comp_branches" dbtype="query">
                                    SELECT * FROM get_all_branches WHERE COMPANY_ID = #get_head_alt_comp.comp_id#
                                </cfquery>
                                <a href="javascript:void(0)">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-shopping-store"></span>
                                        #get_head_alt_comp.NICK_NAME#
                                    </div>
                                    <div class="ui-list-right">
                                        <i class="fa fa-chevron-down"></i>
                                    </div>
                                </a>
                                <cfif get_comp_branches.recordCount>
                                <ul>
                                <cfloop query="get_comp_branches">
                                    <li>
                                    <cfquery name="get_branch_departments_ilk" dbtype="query">
                                        SELECT * FROM get_all_department WHERE BRANCH_ID = #get_comp_branches.BRANCH_ID# AND HIERARCHY_DEP_ID = DEPARTMENT_ID2 ORDER BY DEPARTMENT_HEAD
                                    </cfquery>
                                  <a href="javascript:void(0)"  onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#get_comp_branches.BRANCH_ID#','medium');" title="<cf_get_lang dictionary_id ='57453.Şube'>">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-online-shop-4"></span>
                                        #get_comp_branches.branch_name# 
                                    </div>
                                    <div class="ui-list-right">
                                        <i class="fa fa-chevron-down"></i>
                                    </div>
                                    </a>
                                    <cfif get_branch_departments_ilk.recordcount>
                                    <ul>
                                    
                                    <cfloop query="get_branch_departments_ilk">
                                        <li>
                                    <cfquery name="get_branch_departments" dbtype="query">
                                    SELECT * FROM get_all_department WHERE BRANCH_ID = #get_branch_departments_ilk.BRANCH_ID# AND HIERARCHY_DEP_ID IS NOT NULL AND HIERARCHY_DEP_ID LIKE '#get_branch_departments_ilk.DEPARTMENT_ID#.%'  ORDER BY HIERARCHY_DEP_ID
                                    </cfquery>
                                    <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#DEPARTMENT_ID#&is_organization=1','list');" title="<cf_get_lang dictionary_id ='57572.Departman'>">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-018-monitor"></span>
                                            #department_head#
                                        </div>
                                        <div class="ui-list-right">
                                            <i class="fa fa-chevron-down"></i>
                                        </div>
                                        </a>
                                        <cfif get_branch_departments.recordCount>
                                        <ul>
                                        <cfloop query="get_branch_departments">
                                            <li>
                                            <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#get_branch_departments.DEPARTMENT_ID#&is_organization=1','list');" title="<cf_get_lang dictionary_id ='57572.Departman'>">
                                                <div class="ui-list-left">
                                                    <span class="ui-list-icon ctl-018-monitor"></span>
                                                    #get_branch_departments.department_head#
                                                </div>
                                                <div class="ui-list-right">
                                                    <i class="fa fa-chevron-down"></i>
                                                </div>
                                                </a>
                                            </li>
                                        </cfloop>
                                    </ul>
                                    </cfif>
                                </li>
                                    </cfloop>
                                </ul>
                                </cfif>
                                    </li>
                                </cfloop>
                            </ul>
                        </cfif>
                            </li>
                            </cfloop>
                        </ul>
                        </cfif>
                    </li>
                    </cfloop>
                </ul>
                </cfif>

                <cfif get_head_comp.recordcount>
                    <ul>
                    <cfloop query="get_head_comp">
                        <li>
                    <cfquery name="get_comp_branches" dbtype="query">
                        SELECT * FROM get_all_branches WHERE COMPANY_ID = #get_head_comp.comp_id#
                    </cfquery>
                    <a href="javascript:void(0)" title="<cf_get_lang dictionary_id ='57574.Şirket'>">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-flats"></span>
                            #get_head_comp.NICK_NAME#
                        </div>
                        <div class="ui-list-right">
                            <cfif get_comp_branches.recordCount> <i class="fa fa-chevron-down"></i></cfif>
                        </div>
                    </a>
                        <cfif get_comp_branches.recordcount>
                        <ul>
                        <cfloop query="get_comp_branches">
                        <li>
                        <cfquery name="get_branch_departments_ilk" dbtype="query">
                        SELECT * FROM get_all_department WHERE BRANCH_ID = #get_comp_branches.BRANCH_ID# AND HIERARCHY_DEP_ID = DEPARTMENT_ID2 ORDER BY DEPARTMENT_HEAD <!--- IS NULL --->
                        </cfquery>
                         <a href="javascript:void(0)">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-shopping-store"  onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#get_comp_branches.BRANCH_ID#','medium');"  title="<cf_get_lang dictionary_id ='57453.Şube'>"></span>
                            #get_comp_branches.branch_name#
                        </div>
                        <div class="ui-list-right">
                            <cfif get_branch_departments_ilk.recordCount> <i class="fa fa-chevron-down"></i></cfif>
                        </div>
                        </a>
                        <cfif get_branch_departments_ilk.recordCount>
                        <ul>
                            <cfloop query="get_branch_departments_ilk">
                                <li>
                                <cfquery name="get_branch_departments" dbtype="query">
                                    SELECT * FROM get_all_department WHERE BRANCH_ID = #get_branch_departments_ilk.BRANCH_ID# AND HIERARCHY_DEP_ID IS NOT NULL AND HIERARCHY_DEP_ID LIKE '#get_branch_departments_ilk.DEPARTMENT_ID#.%' ORDER BY HIERARCHY_DEP_ID
                                </cfquery>
                                <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#DEPARTMENT_ID#&is_organization=1','list');"  title="<cf_get_lang dictionary_id ='57572.Departman'>">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-online-shop-4"></span>
                                        #department_head#
                                    </div>
                                    <div class="ui-list-right">
                                        <cfif get_branch_departments.recordCount><i class="fa fa-chevron-down"></i></cfif>
                                    </div>
                                </a>
                                <cfif get_branch_departments.recordCount>
                                <ul>
                                <cfloop query="get_branch_departments">
                                <li>
                                    <a href="javascript:void(0)" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#get_branch_departments.DEPARTMENT_ID#&is_organization=1','list');"  title="<cf_get_lang dictionary_id ='57572.Departman'>">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-018-monitor"></span>
                                            #get_branch_departments.department_head#
                                        </div>
                                    </a> 
                                </li>
                                </cfloop> 
                                </ul> 
                                </cfif>
                            </li>
                            </cfloop>  
                        </ul>
                        </cfif>
                    </li>
                    </cfloop>
                    </ul>
                    </cfif>
                    </li>
                    </cfloop>
                    </ul>
                    </cfif>
            </cfif>
        </li>
    </cfoutput>
    </ul>
<script>
    $('.ui-list li a i.fa-chevron-down').click(function(){
        $(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
        $(this).closest('li').find("> ul").fadeToggle();
    });
</script>