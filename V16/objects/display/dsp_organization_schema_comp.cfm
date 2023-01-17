<cfquery name="get_all_comps" datasource="#dsn#">
	SELECT NICK_NAME,COMP_ID,HEADQUARTERS_ID FROM OUR_COMPANY WHERE IS_ORGANIZATION = 1
</cfquery>
<cfquery name="get_all_branches" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE IS_ORGANIZATION = 1
</cfquery>
<cfquery name="get_all_department" datasource="#dsn#">
	SELECT CAST(DEPARTMENT_ID AS NVARCHAR(10)) AS DEPARTMENT_ID2,DEPARTMENT_ID,BRANCH_ID,DEPARTMENT_HEAD,HIERARCHY_DEP_ID FROM DEPARTMENT WHERE IS_ORGANIZATION = 1
</cfquery>
<cfsetting showdebugoutput="no">
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='29531.Şirketler'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#head#" scroll="1" resize="0" collapsable="0">
        <cfloop query="get_all_comps">
            <cfquery name="get_comp_branches" dbtype="query">
                SELECT * FROM get_all_branches WHERE COMPANY_ID = #get_all_comps.comp_id#
            </cfquery>
                <div class="col col-3 col-md-3 col-sm-4 col-xs-12 ui-info-text"><h1 style="color:#123371;font-weight:500;font-size:14px;margin:0"><img src="css/assets/icons/catalyst-icon-svg/ctl-flats.svg" style="width:5%" class="margin-right-5" title="<cf_get_lang dictionary_id ='57574.Şirket'>"><cfoutput><cfif get_comp_branches.recordcount><span href="javascript://" onclick="gizle_goster(companies_#get_all_comps.comp_id#);" style="cursor:pointer">#left(nick_name,40)#</span><cfelse>#left(nick_name,40)#</cfif></cfoutput></h1>
                    <cfif get_comp_branches.recordcount>
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" cellpadding="0" id="<cfoutput>companies_#get_all_comps.comp_id#</cfoutput>" style="display:none;">
                            <cfloop query="get_comp_branches">
                                <cfquery name="get_branch_departments_ilk" dbtype="query">
                                    SELECT * FROM get_all_department WHERE BRANCH_ID = #get_comp_branches.BRANCH_ID# AND HIERARCHY_DEP_ID = DEPARTMENT_ID2 ORDER BY DEPARTMENT_HEAD
                                </cfquery>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-top-10"> 
                                    <cfoutput><a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_detail_branch&id=#get_comp_branches.BRANCH_ID#','warning_modal');"><img src="css/assets/icons/catalyst-icon-svg/ctl-shopping-store.svg" style="width:5%" title="<cf_get_lang dictionary_id ='57453.Şube'>" border="0"  class="margin-right-5"></a></cfoutput>
                                    <cfoutput><cfif get_branch_departments_ilk.recordcount><a href="javascript://" onclick="gizle_goster(branches_#get_comp_branches.branch_id#);">#get_comp_branches.BRANCH_NAME#</a><cfelse><a href="javascript://">#get_comp_branches.BRANCH_NAME#</a></cfif></cfoutput>
                                    <cfif get_branch_departments_ilk.recordcount>
                                        <div id="<cfoutput>branches_#get_branch_departments_ilk.BRANCH_ID#</cfoutput>" style="display:none;">
                                            <cfoutput query="get_branch_departments_ilk">
                                                <cfquery name="get_branch_departments" dbtype="query">
                                                    SELECT * FROM get_all_department WHERE BRANCH_ID = #get_branch_departments_ilk.BRANCH_ID# AND HIERARCHY_DEP_ID IS NOT NULL AND HIERARCHY_DEP_ID LIKE '#get_branch_departments_ilk.DEPARTMENT_ID#.%'  ORDER BY HIERARCHY_DEP_ID
                                                </cfquery>
                                                <div class="padding-left-10 padding-top-10" >
                                                    <a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#DEPARTMENT_ID#&is_organization=1','warning_modal')"><img src="css/assets/icons/catalyst-icon-svg/ctl-online-shop-4.svg" title="<cf_get_lang dictionary_id ='57572.Departman'>" class="margin-right-5" border="0" style="width:5%">#department_head#</a>
                                                    <cfloop query="get_branch_departments">
                                                        <div class="padding-left-10 padding-top-10" >
                                                            <cfloop from="1" to="#listlen(get_branch_departments.HIERARCHY_DEP_ID,'.')-1#" index="i"></cfloop><a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#get_branch_departments.DEPARTMENT_ID#&is_organization=1','warning_modal');"><img src="css/assets/icons/catalyst-icon-svg/ctl-comfortable.svg"  class="margin-right-5" style="width:5%" title="<cf_get_lang dictionary_id ='57572.Departman'>" border="0"> #get_branch_departments.department_head#</a>
                                                        </div>
                                                    </cfloop>
                                                </div>
                                            </cfoutput>
                                        </div>
                                    </cfif>
                                </div>
                            </cfloop>
                        </div>
                    </cfif> 
                </div>
        </cfloop>
    </cf_box>
</div>
<script type="text/javascript">
    function cfmodal(action, id, option){
	//$('#ui-overlay').show();
	if( option != undefined && option.html != undefined ) $( "#"+id ).html(option.html);
	else AjaxPageLoad(action, id);
}
</script>
<!--- <table align="center" cellpadding="5" cellspacing="5" width="100%">
    <tr>
        <td class="headbold" valign="top">
            <a href="javascript://" onclick="gizle_goster_image('list_address_img3','list_address_img4','sirketler');"><img src="/images/listele.gif" border="0" align="absmiddle" id="list_address_img4" style="display:;cursor:pointer;"></a>
            <a href="javascript://" onclick="gizle_goster_image('list_address_img3','list_address_img4','sirketler');"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="list_address_img3" style="display:none;cursor:pointer;"></a>
            <cf_get_lang dictionary_id='29531.Şirketler'>
        </td>
    </tr>
    <tr id="sirketler" style="display:none;">
        <td valign="top">
            <ul style="list-style:none; padding:0; margin-left:-10px; float:left; vertical-align:top">
                <table width="95%">
                    <thead>
                        <tr>
                            <cfloop query="get_all_comps">
                                <cfquery name="get_comp_branches" dbtype="query">
                                    SELECT * FROM get_all_branches WHERE COMPANY_ID = #get_all_comps.comp_id#
                                </cfquery>
                                <th valign="top" nowrap="nowrap">
                                    <li style="float:left; width:auto; padding:3px; font-weight:bold;">
                                        <div style="width:300px;"><img src="css/assets/icons/catalyst-icon-svg/ctl-profits.svg" style="width:5%" title="<cf_get_lang dictionary_id ='57574.Şirket'>" align="absmiddle"><cfoutput><cfif get_comp_branches.recordcount><a href="javascript://" onclick="gizle_goster(companies_#get_all_comps.comp_id#);">#left(nick_name,40)#</a><cfelse><span style="color:##999;">#left(nick_name,40)#</span></cfif></cfoutput></div>
                                        <cfif get_comp_branches.recordcount>
                                            <table cellpadding="0" cellspacing="0" id="<cfoutput>companies_#get_all_comps.comp_id#</cfoutput>" style="display:none;">
                                                    <cfloop query="get_comp_branches">
                                                    <tr>
                                                    <cfquery name="get_branch_departments_ilk" dbtype="query">
                                                        SELECT * FROM get_all_department WHERE BRANCH_ID = #get_comp_branches.BRANCH_ID# AND HIERARCHY_DEP_ID = DEPARTMENT_ID2 ORDER BY DEPARTMENT_HEAD
                                                    </cfquery>
                                                        <td width="10"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_branch&id=#get_comp_branches.BRANCH_ID#','medium');"><img src="css/assets/icons/catalyst-icon-svg/ctl-flats.svg" title="<cf_get_lang dictionary_id ='57453.Şube'>" border="0"></a></cfoutput></td>
                                                        <td class="formbold" height="25" nowrap><cfoutput><cfif get_branch_departments_ilk.recordcount><a href="javascript://" onclick="gizle_goster(branches_#get_comp_branches.branch_id#);">#get_comp_branches.BRANCH_NAME#</a><cfelse>#get_comp_branches.BRANCH_NAME#</cfif></cfoutput></td>
                                                    </tr>
                                                    <cfif get_branch_departments_ilk.recordcount>
                                                        <tr id="<cfoutput>branches_#get_branch_departments_ilk.BRANCH_ID#</cfoutput>" style="display:none;">
                                                            <td></td>
                                                            <td>
                                                                <table cellpadding="0" cellspacing="0">
                                                                    <cfoutput query="get_branch_departments_ilk">
                                                                        <cfquery name="get_branch_departments" dbtype="query">
                                                                            SELECT * FROM get_all_department WHERE BRANCH_ID = #get_branch_departments_ilk.BRANCH_ID# AND HIERARCHY_DEP_ID IS NOT NULL AND HIERARCHY_DEP_ID LIKE '#get_branch_departments_ilk.DEPARTMENT_ID#.%'  ORDER BY HIERARCHY_DEP_ID
                                                                        </cfquery>
                                                                        <tr>
                                                                            <td height="22" nowrap><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#DEPARTMENT_ID#&is_organization=1','list');"><img src="css/assets/icons/catalyst-icon-svg/ctl-office-material-5.svg" title="<cf_get_lang dictionary_id ='57572.Departman'>" border="0" align="absmiddle" style="width:5%"></a> #department_head#</td>
                                                                        </tr>
                                                                        <cfloop query="get_branch_departments">
                                                                            <tr>
                                                                                <td height="22" nowrap><cfloop from="1" to="#listlen(get_branch_departments.HIERARCHY_DEP_ID,'.')-1#" index="i"></cfloop><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_department_position&DEPARTMENT_ID=#get_branch_departments.DEPARTMENT_ID#&is_organization=1','list');"><img src="css/assets/icons/catalyst-icon-svg/ctl-office-material-5.svg" style="width:5%" title="<cf_get_lang dictionary_id ='57572.Departman'>" border="0" align="absmiddle"></a> #get_branch_departments.department_head#</td>
                                                                            </tr>
                                                                        </cfloop>
                                                                    </cfoutput>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </cfif>
                                                </cfloop>
                                            </table>
                                        </cfif>
                                    </li>
                                </th>
                            </cfloop>         
                        </tr>
                   </thead>     
                </table>
            </ul>
        </td>
    </tr>
</table> --->
