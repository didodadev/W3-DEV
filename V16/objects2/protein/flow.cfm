<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset GET_OPPORTUNITY_PLUSES = opportunitiesCFC.GET_OPPORTUNITY_PLUSES(opp_id : attributes.opp_id)>
<cfoutput query="get_opportunity_pluses">     
    <div class="row" style="overflow:hidden">
        <div class="col-12 flow-list">
            <span>#plus_content#</span>
            <ul class="pl-sm-2">
                <li class="li-img">  
                    <cfif len(update_par) or len(record_par)>
                        <cfset GET_EMP_LIST_ = opportunitiesCFC.GET_PARTNER(userid : iif(len(update_par),'update_par','record_par'))>     
                    <cfelse>
                        <cfset GET_EMP_LIST_ = opportunitiesCFC.GET_EMP_LIST(int_emp_list : iif(len(update_emp),'update_emp','record_emp'))>     
                    </cfif>      
                    <cfif len(GET_EMP_LIST_.photo)>
                        <svg height="50" width="50" class="rounded-circle">
                            <image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#' />
                        </svg>
                    <cfelse>                
                        <div class="rounded-circle tab-circle mt-sm-1" title="#GET_EMP_LIST_.name# #GET_EMP_LIST_.surname#"><cfoutput>#Left(GET_EMP_LIST_.name, 1)##Left(GET_EMP_LIST_.surname, 1)#</cfoutput></div>
                    </cfif>                                          
                </li>
                <cfif len(mail_sender)>
                    <li class="li-icon">
                        <i class="fa fa-angle-right"></i>
                    </li>
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
                            <div class="rounded-circle tab-circle mt-sm-1" title="#GET_EMP_LIST_.name# #GET_EMP_LIST_.surname#"><cfoutput>#Left(GET_EMP_LIST_.name, 1)##Left(GET_EMP_LIST_.surname, 1)#</cfoutput></div>
                        </cfif>
                    </li>
                    <li class="li-txt">
                        <p>#mail_sender#</p>
                    </li>
                    <li class="li-txt">
                        <i class="far fa-clock mr-1 project-color-g"></i>  
                        <span class="float-right"><cfif len(plus_date)>#dateformat(plus_date,'dd/mm/yyyy')#</cfif></span>                          
                    </li>                  
                <cfelse>
                    <cfif not (len(update_par) or len(record_par))>
                        <li class="li-txt">
                            <p>
                                <cfif len(record_par)>
                                    <cfset record = opportunitiesCFC.GET_PARTNER(userid : record_par)>
                                    #record.name# #record.surname#
                                <cfelse>
                                    #get_emp_info(record_emp,0,0)#
                                </cfif>
                            </p>
                        </li>
                    </cfif>
                    <li class="li-txt">
                        <i class="far fa-clock mr-1 project-color-g"></i>  
                        <span class="float-right"><cfif len(plus_date)>#dateformat(plus_date,'dd/mm/yyyy')#</cfif></span>                          
                    </li>  
                </cfif>                      
            </ul>            
        </div>
    </div>
    <hr class="top-border" />
</cfoutput>