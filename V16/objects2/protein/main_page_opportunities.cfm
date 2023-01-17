<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset get_process_type = getComponent.get_process_types(faction:'sales.list_opportunity')>
<cfset get_probability_rate = opportunitiesCFC.GET_PROBABILITY_RATE()>

<cfset processes = "">
<cfset names = "">
<cfset p_process = "">
<cfset sum = 0>
<cfset probs = "">
<cfset probs_names = "">
<cfset p_probs = "">
<cfset probs_sum = 0>
<cfoutput query="get_probability_rate">
    <cfset get_opp = opportunitiesCFC.GET_OPPORTUNITIES(probability:probability_rate_id,sales_member_type:'partner')>
    <cfquery name="get_total" dbtype="query">
        SELECT COUNT(OPP_ID) OPP_COUNT FROM get_opp
    </cfquery>
    <cfset probs = ListAppend(probs,len(get_total.OPP_COUNT) ? get_total.OPP_COUNT : 0)>
    <cfset probs_names = ListAppend(probs_names,len(get_probability_rate.probability_name) ? get_probability_rate.probability_name : DE(''))>
</cfoutput>
<cfoutput query="get_process_type">
    <cfset get_opp = opportunitiesCFC.GET_OPPORTUNITIES(process_stage:process_row_id,sales_member_type:'partner')>
    <cfquery name="get_total" dbtype="query">
        SELECT COUNT(OPP_ID) OPP_COUNT FROM get_opp
    </cfquery>
    <cfset processes = ListAppend(processes,len(get_total.OPP_COUNT) ? get_total.OPP_COUNT : 0)>
    <cfset names = ListAppend(names,len(get_opp.stage) ? get_opp.stage : DE(''))>
</cfoutput>
<cfloop list="#processes#" index="i">
    <cfset sum += i>
</cfloop>
<cfloop list="#processes#" index="i">
    <cfset k  = sum neq 0 ? (i*100)/sum : 0>
    <cfset p_process = ListAppend(p_process,k)>
</cfloop>
<cfloop list="#probs#" index="i">
    <cfset probs_sum += i>
</cfloop>
<cfloop list="#probs#" index="i">
    <cfset k  = probs_sum neq 0 ? (i*100)/probs_sum : 0>
    <cfset p_probs = ListAppend(p_probs,k)>
</cfloop>
<div class="info_card_item">
    <ul>
        <li>
            <div class="info_card_item_name">
                <cf_get_lang dictionary_id='58694.Opportunities'>
            </div>
        </li>
        <li>
            <i class="far fa-gem"></i>
        </li>
    </ul>
    <ul>
        <li>
            <div class="info_card_item_progress">
                <div class="info_card_item_progress_num">
                    <cfoutput>#sum#</cfoutput>&nbsp; &nbsp; 
                </div>
                <div class="info_card_item_progress_num">
                    <cfset get_opp = opportunitiesCFC.GET_OPPORTUNITIES(sales_member_type:'partner',opp_status:1)>
                    <cfquery name="get_total" dbtype="query">
                        SELECT SUM(INCOME) INCOME FROM get_opp
                    </cfquery>
                    <cfoutput><cfif len(get_total.income)>#TLFORMAT(get_total.income)#<cfelse>0</cfif> #session.pp.money#</cfoutput>
                </div>
            </div>
        </li>
        <li class="mt-sm-4">
            <div class="info_card_item_progress">
                <div class="info_card_item_stage">
                    <span><cf_get_lang dictionary_id='42001.Stages'></span>
                    <div class="progress">
                        <cfset x=1>
                        <cfloop list="#p_process#" item="i" index="j">
                            <cfif i neq 0>
                                <div class="progress-bar bg-color-<cfoutput><cfif x lt 8>#x#<cfelse>#Round(x/2)#</cfif></cfoutput>" style="width:<cfoutput>#i#</cfoutput>%" role="progressbar" aria-valuenow="<cfoutput>#i#</cfoutput>" aria-valuemin="0" aria-valuemax="100" title = "<cfoutput>#Replace(ListGetAt(names,j),'"','','all')# %#Round(i)#</cfoutput>"></div>
                                <cfset x +=1>
                            </cfif>                                
                        </cfloop>
                    </div> 
                </div>
                <div class="info_card_item_prob"> 
                    <span><cf_get_lang dictionary_id='58652.Probability'></span>                           
                    <div class="progress">
                        <cfset x=1>
                        <cfloop list="#p_probs#" item="i" index="j">
                            <div class="progress-bar bg-color-<cfoutput><cfif x lt 8>#x#<cfelse>#Round(x/2)#</cfif></cfoutput>"s style="width:<cfoutput>#i#</cfoutput>%" role="progressbar" aria-valuenow="<cfoutput>#i#</cfoutput>" aria-valuemin="0" aria-valuemax="100" title = "<cfoutput>#Replace(ListGetAt(probs_names,j),'"','','all')# %#Round(i)#</cfoutput>"></div>
                            <cfset x +=1>
                        </cfloop>
                    </div>
                </div>
            </div>
        </li>
    </ul> 
</div>