
<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset work_detail_summary = getComponent.DET_WORK(id : attributes.id)>
<cfset work_detail_first = getComponent.GET_WORK_FIRST_DETAIL(id : attributes.id)>
<cfset GET_VALUE = getComponent.GET_VALUES(id:attributes.id)>
<cfset upload_folder=application.systemParam.systemParam().upload_folder>
<div class="ui-info-text">
    <cfoutput>
        <h1>#URLDecode(work_detail_summary.work_head)#</h1>
        <p>#work_detail_first.work_detail#</p>
        <cfif len(work_detail_summary.milestone_work_id)>
            <cfset work_detail_milestone = getComponent.DET_WORK(id : work_detail_summary.milestone_work_id)>
            <h1><i class="fa fa-sitemap"></i>   <a href="index.cfm?fuseaction=project.works&event=det&id=#work_detail_summary.milestone_work_id#" target="blank_">#work_detail_milestone.work_head#</a></h1>
        </cfif>
        <div class="ui-customTooltip">
            <ul>
                <li>
                    <cfif len(work_detail_first.update_author)>
                        <cfset GET_EMP_LIST = getComponent.GET_EMP_LIST(int_emp_list : work_detail_first.update_author)>
                        <cfif len(GET_EMP_LIST.photo)>
                            <a href="javascript://" title="#get_emp_info(work_detail_first.update_author,0,0)#"><img src='../documents/hr/#GET_EMP_LIST.PHOTO#' /></a>
                        <cfelse>
                            <a href="javascript://" title="#get_emp_info(work_detail_first.update_author,0,0)#" class="color-#Left(GET_EMP_LIST.NAME, 1)#">
                                #Left(GET_EMP_LIST.NAME, 1)##Left(GET_EMP_LIST.SURNAME, 1)#
                            </a>
                        </cfif>
                    </cfif>
                    <cfif len(work_detail_first.update_par)>
                        <cfset PARTNER_PHOTO = getComponent.PARTNER_PHOTO(partner_id : work_detail_first.update_par)>
                        <cfif len(PARTNER_PHOTO.photo)>
                            <a href="javascript://" title="#get_par_info(work_detail_first.update_par,0,0,1)#"><img src='../documents/hr/#PARTNER_PHOTO.PHOTO#' /></a>
                        <cfelse>
                            <a href="javascript://" title="#get_par_info(work_detail_first.update_par,0,0,1)#" class="color-#Left(PARTNER_PHOTO.NAME, 1)#">
                                #Left(PARTNER_PHOTO.NAME, 1)##Left(PARTNER_PHOTO.SURNAME, 1)#
                            </a>
                        </cfif>
                    </cfif>
                        
                </li>
                <li><i class="fa fa-angle-right"></i></li>
                <li>
                    <cfif work_detail_summary.project_emp_id neq 0 and len(work_detail_summary.project_emp_id)>
                        <cfset GET_EMP_LIST = getComponent.GET_EMP_LIST(int_emp_list : work_detail_summary.project_emp_id)>
                        <cfif len(GET_EMP_LIST.photo)>
                            <a href="javascript://" title="#get_emp_info(work_detail_summary.project_emp_id,0,0)#"><img src='../documents/hr/#GET_EMP_LIST.PHOTO#'/></a>
                        <cfelse>
                            <a href="javascript://" title="#get_emp_info(work_detail_summary.project_emp_id,0,0)#" class="color-#Left(GET_EMP_LIST.NAME, 1)#">
                                #Left(GET_EMP_LIST.NAME, 1)##Left(GET_EMP_LIST.SURNAME, 1)#
                            </a>
                        </cfif>
                    <cfelseif work_detail_summary.outsrc_partner_id neq 0 and len(work_detail_summary.outsrc_partner_id)>
                        <cfset PARTNER_PHOTO = getComponent.PARTNER_PHOTO(partner_id : work_detail_summary.outsrc_partner_id)>
                        <cfif len(PARTNER_PHOTO.photo)> 
                            <a href="javascript://" title="#get_par_info(work_detail_summary.outsrc_partner_id,0,0,0)#"><img src='../documents/hr/#PARTNER_PHOTO.PHOTO#' /></a>
                        <cfelse>
                            <a href="javascript://" title="#get_par_info(work_detail_summary.outsrc_partner_id,0,0,0)#" class="color-#Left(PARTNER_PHOTO.NAME, 1)#">
                                #Left(PARTNER_PHOTO.NAME, 1)##Left(PARTNER_PHOTO.SURNAME, 1)#
                            </a>
                        </cfif>
                    </cfif>
                </li>
                 <cfloop query="GET_VALUE">
                    <cfif len(GET_VALUE.CC_EMP)>
                        <cfset int_emp_list = ListSort(ValueList(GET_VALUE.CC_EMP),"numeric","asc")>
                        <cfset GET_EMP_CC_EMP = getComponent.GET_EMP_LIST(int_emp_list : int_emp_list)>
                    <cfelseif len(GET_VALUE.CC_PAR)>
                        <cfset int_emp_list = ListSort(ValueList(GET_VALUE.CC_PAR),"numeric","asc")>
                        <cfset GET_EMP_CC_EMP = getComponent.PARTNER_PHOTO(partner_id : int_emp_list)> 
                    </cfif>
                 </cfloop>
                <cfif isdefined("GET_EMP_CC_EMP") and len(GET_EMP_CC_EMP.recordcount)>
                    <li><i class="fa fa-angle-right"></i></li>
                    <cfloop query = "GET_EMP_CC_EMP">
                        <cfif len(GET_EMP_CC_EMP.photo)>
                            <li><a><img class="img-circle" title="#NAME# #SURNAME#" src='../../documents/hr/#GET_EMP_CC_EMP.PHOTO#'/></a></li>
                        <cfelse>
                            <li><a title="#NAME# #SURNAME#" class="color-#Left(NAME, 1)#">#Left(NAME, 1)##Left(SURNAME, 1)#</a></li>
                        </cfif>
                    </cfloop>
                </cfif>               
            </ul>
        </div>    
    </cfoutput>
</div>

