<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset GET_SUBSCRIPTIONS = contract_cmp.GET_SUBSCRIPTIONS( dsn3:dsn3,startrow:1,maxrows:100,company_id:session_base.company_id,sales_partner_id_pp:session_base.member_type eq 'partner' ? session_base.userid : '') />

<cfif GET_SUBSCRIPTIONS.recordcount>
    <cfquery name="get_total_subscription_active" dbtype="query">
        SELECT COUNT(SUBSCRIPTION_ID) AS TOTAL FROM GET_SUBSCRIPTIONS WHERE IS_ACTIVE = 1
    </cfquery>
    <cfquery name="get_total_subscription_passive" dbtype="query">
        SELECT COUNT(SUBSCRIPTION_ID) AS TOTAL FROM GET_SUBSCRIPTIONS WHERE IS_ACTIVE = 0 OR IS_ACTIVE IS NULL
    </cfquery>

    <cfset active_subs = len(get_total_subscription_active.TOTAL) ? get_total_subscription_active.TOTAL : 0 />
    <cfset passive_subs = len(get_total_subscription_passive.TOTAL) ? get_total_subscription_passive.TOTAL : 0 />
<cfelse>
    <cfset active_subs = 0 />
    <cfset passive_subs = 0 />
</cfif>

<div class="info_card_item">
    <ul>
        <li>
            <div class="info_card_item_name">
                <cf_get_lang dictionary_id='30003.Subscriptions'>
            </div>
        </li>
          <li>
            <div class="info_card_item_rate">
                <cfoutput>#Replace(Replace(Replace(TLFormat((passive_subs*100)/(active_subs+passive_subs)),'.','*'),',','.','all'),'*',',')#%</cfoutput>
             </div>  
            <i class="fas fa-cog"></i>
        </li>
    </ul>
    <ul>
        <li>
            <div class="info_card_item_num">
                <cfoutput>#Replace(numberFormat(active_subs,','),',','.','all')#</cfoutput>
            </div>
            <div class="info_card_item_info">
                <cf_get_lang dictionary_id='57493.Active'>
            </div>        
        </li>
        <li>
            <div class="info_card_item_num">
                <cfoutput>#Replace(numberFormat(passive_subs,','),',','.','all')#</cfoutput>
            </div>
            <div class="info_card_item_info">
                <cf_get_lang dictionary_id='57494.Passive'>
            </div> 
        </li>
    </ul>      
</div>