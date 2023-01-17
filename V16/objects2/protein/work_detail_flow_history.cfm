<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset get_work_history=getComponent.GET_WORK_HISTORY(is_notPrority : 1,wid:attributes.wid)>
<cfoutput query="get_work_history">      
    <div class="row">
        <div class="col-12 flow-list">
            <cfset get_work_currency = getComponent.GET_PROCESS(work_currency_id:get_work_history.work_currency_id)>
            <span class="label rounded px-3 py-2 span-color-<cfif get_work_currency.stage.len() lt 8>#get_work_currency.stage.len()#<cfelse>7</cfif> small">#get_work_currency.stage#</span>
            <p class="mt-2">
                <cfset work_detail_ = replace(work_detail,'<form','<fform','all')>
                <cfset work_detail_ = replace(work_detail_,'</form','</fform','all')>    
                #work_detail_#
            </p>
            <ul>
                <li class="li-img">
                    <cfif len(company_partner_id) or len(update_par)>
                        <cfset GET_EMP_LIST_ = getComponent.PARTNER_PHOTO(partner_id : iif(len(company_partner_id),company_partner_id,update_par))>
                    <cfelseif len(update_author)>                                
                        <cfset GET_EMP_LIST_ = getComponent.GET_EMP_LIST(int_emp_list : update_author)>
                    </cfif>
                    <cfif len(GET_EMP_LIST_.photo)>
                        <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#"><svg height="50" width="50" class="rounded-circle"><image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' /></svg></a>
                    <cfelse>                            
                        <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#" class="rounded-circle color-#Left(GET_EMP_LIST_.NAME, 1)#" style="font-size:larger;display:flex;justify-content: center;align-items: center;width:50px;height:50px;">
                            #Left(GET_EMP_LIST_.NAME, 1)##Left(GET_EMP_LIST_.SURNAME, 1)#
                        </a>
                    </cfif>
                </li>
                <li class="li-icon">
                    <i class="fa fa-angle-right"></i>
                </li>
                <li class="li-img">
                    <cfif len(project_emp_id)>
                        <cfset GET_EMP_LIST_ = getComponent.GET_EMP_LIST(int_emp_list : project_emp_id)>
                    <cfelseif len(outsrc_partner_id)>
                        <cfset GET_EMP_LIST_ = getComponent.PARTNER_PHOTO(partner_id : outsrc_partner_id)>
                    </cfif>
                    <cfif len(GET_EMP_LIST_.photo)>
                        <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#"><svg height="50" width="50" class="rounded-circle"><image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' /></svg></a>
                    <cfelse>                            
                        <a title="#GET_EMP_LIST_.NAME# #GET_EMP_LIST_.SURNAME#" class="rounded-circle color-#Left(GET_EMP_LIST_.NAME, 1)#" style="font-size:larger;display:flex;justify-content: center;align-items: center;width:50px;height:50px;">
                            #Left(GET_EMP_LIST_.NAME, 1)##Left(GET_EMP_LIST_.SURNAME, 1)#
                        </a>
                    </cfif>
                </li>
                <!--- <li class="li-txt">
                    <p>Marcus Antonius</p>
                </li> --->
                <li class="li-txt">
                    <i class="far fa-clock mr-1 project-color-g"></i>  
                    <cfset upd_date = date_add('h',session_base.time_zone,update_date)>
                    <span style="float:right">#Dateformat(upd_date,dateformat_style)# #Timeformat(upd_date,timeformat_style)# </span>                          
                </li>                        
            </ul>                
        </div>
    </div>  
<hr class="top-border"/>   
 </cfoutput>