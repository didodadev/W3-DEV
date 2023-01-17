<cfset attributes.opp_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.opp_id,accountKey:'wrk')>
<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset getComponent = createObject('component','V16.member.cfc.member_company')>
<cfset get_opportunity = opportunitiesCFC.GET_OPPORTUNITY(opp_id : attributes.opp_id)>
<cfset get_opportunity_type = opportunitiesCFC.GET_OPPORTUNITY_TYPE(OPPORTUNITY_TYPE_ID : get_opportunity.OPPORTUNITY_TYPE_ID)>
<cfset get_probability_rate = opportunitiesCFC.GET_PROBABILITY_RATE(probability_rate_id : get_opportunity.probability )>
<div class="row">
    <div class="col-md-12">
        <cfsavecontent variable="title"><cf_get_lang dictionary_id='57612.Fırsat'></cfsavecontent>
        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>widgetloader?widget_load=updateOpportunity&isbox=1&opp_id=#attributes.opp_id#&title=#title#</cfoutput>&style=maxi')" class="none-decoration">
            <i class="fas fa-pencil-alt float-right"></i>
        </a>
    </div>
</div>
<div class="row">
    <cfoutput query="get_opportunity">
        <div class="col-md-6">
            <h4 class="mb-4">#opp_head#</h4>
            <div class="opportunity-content mb-3">
                #opp_detail#                
            </div>            
            <div class="row d-flex align-items-end">
                <div class="col-lg-6">                        
                    <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='57457.Müşteri'></p>
                    <p class="mb-0">
                        <cfif len(partner_id)>
                            <input type="hidden" name="company_id" id="company_id" value="#company_id#">
                            <input type="hidden" name="member_type" id="member_type" value="partner">
                            <input type="hidden" name="member_id" id="member_id" value="#partner_id#">
                            <input type="hidden" name="old_member_id" id="old_member_id" value="#partner_id#">
                            #get_par_info(company_id,1,0,0)#
                        <cfelseif len(consumer_id)>
                            <input type="hidden" name="company_id" id="company_id" value="#company_id#">
                            <input type="hidden" name="member_type" id="member_type" value="consumer">
                            <input type="hidden" name="member_id" id="member_id"  value="#consumer_id#">
                            <input type="hidden" name="old_member_id" id="old_member_id" value="#consumer_id#">
                            #get_cons_info(consumer_id,1,0)#                      
                        </cfif>
                    </p>                   
                </div>

                <div class="col-lg-6 pr-0">
                    <div class="row">
                        <div class="mr-4">
                            <cfset GET_EMP_LIST_ = getComponent.GET_HIER_PARTNER(cpid : session_base.company_id, GET_PARTNER:1)>
                            <cfif len(sales_emp_id)>
                                <cfquery name="GET_EMP_LIST_" dbType="query">
                                    SELECT * FROM GET_EMP_LIST_ WHERE PARTNER_ID = #sales_emp_id#
                                </cfquery>
                                </cfif>
                            <cfif GET_EMP_LIST_.recordcount>
                                <cfif len(GET_EMP_LIST_.photo)> 
                                    <svg height="50" width="50" class="rounded-circle">
                                        <image height="50px" width="50px" href='../documents/hr/#GET_EMP_LIST_.PHOTO#'/>
                                    </svg>
                                <cfelse>                
                                    <span class="rounded-circle tab-circle">#Left(GET_EMP_LIST_.COMPANY_PARTNER_NAME, 1)##Left(GET_EMP_LIST_.COMPANY_PARTNER_SURNAME, 1)#</span>
                                </cfif>
                            </cfif>                                                                 
                        </div>
                        <div>
                            <p class="font-weight-bold mb-0"><cf_get_lang dictionary_id='61837.Fırsatı Yöneten'></p>
                            <p class="mb-0"><cfif len(sales_emp_id)>#get_emp_info(sales_emp_id,0,0)#</cfif></p>                                           
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6 mt-4">
            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
                </div>
                <div class="col-lg-4"> 
                    <label>
                    <cfloop query="get_opportunity_type">         
                        <cfif get_opportunity_type.opportunity_type_id eq get_opportunity.opportunity_type_id>#OPPORTUNITY_TYPE#</cfif>
                    </cfloop>    
                    </label>                     
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57482.Aşama'></label>
                </div>
                <div class="col-lg-4">
                    <span class="badge pl-3 pr-3 py-2 span-color-3">#stage#</span>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4 pr-0">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='61880.Gelir Potansiyeli'></label>
                </div>
                <div class="col-lg-4">
                    <label>#TLFormat(income,3)# #money#</label>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58652.Olasılık'></label>
                </div>
                <div class="col-lg-4">
                    <label><cfif len(get_probability_rate.probability_name)>#get_probability_rate.probability_name#</cfif></label>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                </div>
                <div class="col-lg-4">
                    <label>#dateformat(record_date,dateformat_style)#</label>
                </div>
            </div>

            <div class="row mb-2 justify-content-center">
                <div class="col-lg-4 pr-0">
                    <label class="font-weight-bold"><cf_get_lang dictionary_id='58050.Son Güncelleme'></label>
                </div>
                <div class="col-lg-4">
                    <label>#dateformat(UPDATE_DATE,dateformat_style)#</label>
                </div>
            </div>
        </div>
    </cfoutput>
</div> 