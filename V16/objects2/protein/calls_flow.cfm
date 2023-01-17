<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset get_service_plus = getComponent.get_service_plus(service_id : attributes.id)>
<cfset get_module_temp = getComponent.get_module_temp()>
<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfif get_service_plus.recordcount>
<cfoutput query="get_service_plus">
    <div class="row">
        <div class="col-12 flow-list" style="content-visibility: auto;">
            <p>#plus_content#</p>            
            <ul>
                <li class="li-img">
                    <cfif len(record_par)>
                        <cfset GET_EMP_LIST_ = opportunitiesCFC.GET_PARTNER(userid : record_par)>  
                    <cfelse>
                        <cfset GET_EMP_LIST_ = opportunitiesCFC.GET_EMP_LIST(int_emp_list : record_emp)>  
                    </cfif>    
                    <cfif len(GET_EMP_LIST_.photo)>
                        <svg height="50" width="50" class="rounded-circle">
                            <image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' />
                        </svg>
                    <cfelse>                            
                        <div class="rounded-circle tab-circle mt-sm-1" title="#GET_EMP_LIST_.name# #GET_EMP_LIST_.surname#">#Left(GET_EMP_LIST_.name, 1)##Left(GET_EMP_LIST_.surname, 1)#</div>
                    </cfif>                  
                </li>
               
                <cfif len(partner_id)>
                    <li class="li-icon">
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="li-img">                        
                        <cfset get_part = opportunitiesCFC.GET_PARTNER(userid : partner_id)>
                        <cfif len(get_part.photo)>
                            <svg height="50" width="50" class="rounded-circle">
                                <image height="50px" width="50px" href='../documents/hr/#get_part.PHOTO#' />
                            </svg>
                        <cfelse>                            
                            <div class="rounded-circle tab-circle mt-sm-1" title="#get_part.name# #get_part.surname#">#Left(get_part.name, 1)##Left(get_part.surname, 1)#</div>
                        </cfif>    
                    </li>    
                </cfif> 
                <cfif len(employee_id)>
                    <li class="li-icon">
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="li-img">  
                        <cfset GET_EMP_LIST_ = opportunitiesCFC.GET_EMP_LIST(int_emp_list : employee_id)> 
                        <cfif len(GET_EMP_LIST_.photo)>
                            <svg height="50" width="50" class="rounded-circle">
                                <image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' />
                            </svg>
                        <cfelse>                            
                            <div class="rounded-circle tab-circle mt-sm-1" title="#GET_EMP_LIST_.name# #GET_EMP_LIST_.surname#">#Left(GET_EMP_LIST_.name, 1)##Left(GET_EMP_LIST_.surname, 1)#</div>
                        </cfif>
                    </li>   
                </cfif>    
                <cfif len(consumer_id)>
                    <li class="li-icon">
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="li-img">  
                        <div class="rounded-circle tab-circle mt-sm-1" title="#get_cons_info(consumer_id,0,0)#">#Left(get_cons_info(consumer_id,0,0),1)##Left(ListLast(get_cons_info(consumer_id,0,0), ' '),1)#</div>
                    </li>
                </cfif>      
                   
                <cfif len(mail_sender)>
                    <li class="li-icon">
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="li-txt">
                        <p>#listRemoveDuplicates(mail_sender)#</p>
                    </li>
                    <li class="li-txt">
                        <i class="far fa-clock mr-1 project-color-g"></i>  
                        <span class="float-right"><cfif len(update_date)>#dateformat(update_date,'dd/mm/yyyy')#-#TimeFormat(date_add('h',session_base.time_zone,update_date),'hh:mm')#<cfelseif len(record_date)>#dateformat(record_date,'dd/mm/yyyy')#-#TimeFormat(date_add('h',session_base.time_zone,record_date),'hh:mm')#</cfif></span>                          
                    </li>                                  
                <cfelse>
                    <li class="li-txt">
                        <p>#get_emp_info(record_par,0,0)#</p>
                    </li>
                    <li class="li-txt">
                        <i class="far fa-clock mr-1 project-color-g"></i>  
                        <span class="float-right"><cfif len(update_date)>#dateformat(update_date,'dd/mm/yyyy')#-#TimeFormat(date_add('h',session_base.time_zone,update_date),'hh:mm')#<cfelseif len(record_date)>#dateformat(plus_date,'dd/mm/yyyy')# #TimeFormat(date_add('h',session_base.time_zone,record_date),'hh:mm')#</cfif></span>                          
                    </li>  
                </cfif>                      
            </ul>
        </div>
    </div>
</cfoutput>
<cfelse>
    <div class="row">
        <div class="col-12 flow-list">
            <p><cf_get_lang dictionary_id='57484.No record'>!</p>     
        </div>
    </div>
</cfif>


