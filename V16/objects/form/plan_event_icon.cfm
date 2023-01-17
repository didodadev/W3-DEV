<!--- <style>
    ul.share-buttons {
  display:flex;
  margin :10px 0px 10px 0px;
justify-content:flex-start!important;
  }
  ul.share-buttons li {
  flex:1 1 auto;
  }
  </style> --->
  <div class="blog_detail_top " >
  <cfoutput>
    
  <ul class="blog_detail_top_icon">
      <li >
    
        <cfif get_plan_row.type eq 1>
            <a href="#request.self#?fuseaction=call.helpdesk&event=add&cus_help_id=#get_plan_row.member_id#&member_name=#get_plan_row.fullname#&partner_id=#get_plan_row.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class="wrk-CRM " alt="<cf_get_lang dictionary_id ='49354.Etkileşim Ekle'>" title="<cf_get_lang dictionary_id ='49354.Etkileşim Ekle'>">&nbsp;<cf_get_lang dictionary_id ='49270.Etkileşim '></i></a>
        <cfelse>
            <a href="#request.self#?fuseaction=call.helpdesk&event=add&cus_help_id=&member_type=consumer&member_id=#attributes.member_id#&event_plan_row_id=#attributes.event_plan_row_id#"  target="_blank"><i class="wrk-CRM " alt="<cf_get_lang dictionary_id ='49354.Etkileşim Ekle'>" title="<cf_get_lang dictionary_id ='49354.Etkileşim Ekle'>">&nbsp;<cf_get_lang dictionary_id ='49270.Etkileşim '></i></a>  
        </cfif>
        &nbsp;&nbsp;
    </li>
 
    <li>
        <cfif get_plan_row.type eq 1>
            <a href="#request.self#?fuseaction=sales.list_opportunity&event=add&cpid=#get_plan_row.member_id#&member_type=partner&member_id=#get_plan_row.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class=" wrk-uF0161"  alt="<cf_get_lang dictionary_id ='58489.Fırsat Ekle'>" title="<cf_get_lang dictionary_id ='58489.Fırsat Ekle'>">&nbsp;<cf_get_lang dictionary_id ='57612.Fırsat '></i></a>
        <cfelse>
            <a href="#request.self#?fuseaction=sales.list_opportunity&event=add&cpid=&member_type=consumer&member_id=#attributes.member_id#&event_plan_row_id=#attributes.event_plan_row_id#"  target="_blank"><i class=" wrk-uF0161 " alt="<cf_get_lang dictionary_id ='58489.Fırsat Ekle'>" title="<cf_get_lang dictionary_id ='58489.Fırsat Ekle'>">&nbsp;<cf_get_lang dictionary_id ='57612.Fırsat '></i></a>  
        </cfif>
        &nbsp;&nbsp;
        

    </li>
    <li>
        <cfif get_plan_row.type eq 1>
            <a href="#request.self#?fuseaction=call.list_service&event=add&cpid=#attributes.member_id#&member_type=partner&member_id=#attributes.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class="wrk-uF0162" alt="<cf_get_lang dictionary_id ='61768.Çağrı Ekle'>" title="<cf_get_lang dictionary_id ='61768.Çağrı Ekle'>">&nbsp;<cf_get_lang dictionary_id ='62263.Çağrı '></i></a>
         <cfelse>
            <a href="#request.self#?fuseaction=call.list_service&event=add&event=add&cpid=&member_type=consumer&member_id=#attributes.member_id#&event_plan_row_id=#attributes.event_plan_row_id#"  target="_blank"><i class="wrk-uF0162" alt="<cf_get_lang dictionary_id ='61768.Çağrı Ekle'>" title="<cf_get_lang dictionary_id ='61768.Çağrı Ekle'>">&nbsp;<cf_get_lang dictionary_id ='62263.Çağrı '></i></a>  
         </cfif>
         &nbsp;&nbsp;
    </li>
    <li>
        <cfif get_plan_row.type eq 1>
             <a href="#request.self#?fuseaction=sales.list_order&event=add&cpid=#attributes.member_id#&member_type=partner&member_id=#attributes.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class="wrk-uF0044" alt="<cf_get_lang dictionary_id ='58989.Sipariş Ekle'>" title="<cf_get_lang dictionary_id ='58989.Sipariş Ekle'>">&nbsp;<cf_get_lang dictionary_id ='57611.Sipariş '></i></a>
        <cfelse>
             <a href="#request.self#?fuseaction=sales.list_order&event=add&event=add&cpid=&member_type=consumer&member_id=#attributes.member_id#&event_plan_row_id=#attributes.event_plan_row_id#"  target="_blank"><i class="wrk-uF0044" alt="<cf_get_lang dictionary_id ='58989.Sipariş Ekle'>" title="<cf_get_lang dictionary_id ='58989.Sipariş Ekle'>">&nbsp;<cf_get_lang dictionary_id ='57611.Sipariş '></i></a>  
        </cfif>
        &nbsp;&nbsp;
    </li>
    <li>
        <cfif get_plan_row.type eq 1>
            <a href="#request.self#?fuseaction=campaign.list_organization&event=add&company_id=#attributes.member_id#&member_name=#attributes.fullname#&partner_id=#attributes.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#"  target="_blank"><i  class="wrk-uF0092" border="0" alt="<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'>"title="<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'>">&nbsp;<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'></i></a>
        <cfelse>
            <a href="#request.self#?fuseaction=campaign.list_organization&event=add&consumer_id=#get_plan_row.member_id#&member_name=#attributes.fullname#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i  class="wrk-uF0092" border="0" alt="<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'>" title="<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'>">&nbsp;<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'></i></a>
        </cfif>
        &nbsp;&nbsp;
    </li>
    <li>
        <cfif get_plan_row.type eq 1>
            <a href="#request.self#?fuseaction=sales.list_offer&event=add&company_id=#get_plan_row.member_id#&member_name=#get_plan_row.fullname#&partner_id=#get_plan_row.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#"  target="_blank"><i  class="wrk-uF0137" border="0" alt="<cf_get_lang dictionary_id ='29465.Etkinlik Ekle'>" title="Teklif Ekle">&nbsp;<cf_get_lang dictionary_id ='57545.teklif '></i></a>
        <cfelse>
            <a href="#request.self#?fuseaction=sales.list_offer&event=add&consumer_id=#get_plan_row.member_id#&member_name=#get_plan_row.fullname#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i  class="wrk-uF0137" border="0" alt="Teklif Ekle" title="Teklif Ekle">&nbsp;<cf_get_lang dictionary_id ='57545.teklif '></i></a>
        </cfif>
        &nbsp;&nbsp;
    </li>
 <li>
        <cfif get_plan_row.type eq 1>
            <a href="#request.self#?fuseaction=service.list_service&event=add&cpid=#attributes.member_id#&member_type=partner&member_id=#attributes.partner_id#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class="wrk-uF0026 " border="0" alt="Servis Ekle" title="<cf_get_lang dictionary_id ='57656.Servis Ekle'><cf_get_lang_main no ='170.Ekle'>">&nbsp;<cf_get_lang dictionary_id ='57656.Servis Ekle'></i></a>
        <cfelse>
            <a href="#request.self#?fuseaction= service.list_service&event=add&consumer_id=#attributes.member_id#&member_name=#attributes.fullname#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class="wrk-uF0026 " border="0" alt="<cf_get_lang dictionary_id ='57656.Servis Ekle'>" title="<cf_get_lang dictionary_id ='57656.Servis '><cf_get_lang_main no ='170.Ekle'>">&nbsp;<cf_get_lang dictionary_id ='57656.Servis Ekle'></i></a>
        </cfif>
        &nbsp;&nbsp;
    </li>  
    
 <cfif get_plan_row.type eq 1>

        <li ><a href="#request.self#?fuseaction=project.works&event=add&work_fuse=project.works&company_id=#attributes.member_id#&about_company=#attributes.fullname#&partner_id=#attributes.partner_id#&about_par_name=#attributes.member_partner_name#&event_plan_row_id=#attributes.event_plan_row_id#" target="_blank"><i class="wrk-uF0006" border="0" alt="İş Ekle" title="İş Ekle">&nbsp;<cf_get_lang dictionary_id ='58445.iş '></i></a> &nbsp;&nbsp; </li>
    </cfif>
   

   
<!---  <cfif get_plan_row.type eq 1>
        
        <cfset temp_member_type = 'member_type=partner&company_id=#attributes.member_id#&partner_id=#attributes.partner_id#'>
        <cfquery name="get_member_analysis" datasource="#dsn#" maxrows="1">
        SELECT OPPORTUNITY_ID,OFFER_ID,PROJECT_ID,ANALYSIS_ID,RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE COMPANY_ID = #get_plan_row.member_id# AND PARTNER_ID = #get_plan_row.partner_id# ORDER BY ISNULL(UPDATE_DATE,RECORD_DATE) DESC
        </cfquery>
        <cfif get_member_analysis.recordcount>
            <cfif len(get_member_analysis.opportunity_id)>
                <cfset temp_action_type='OPPORTUNITY'>
            <cfelseif len(get_member_analysis.offer_id)>
                <cfset temp_action_type='OFFER'>
            <cfelseif len(get_member_analysis.project_id)>
                <cfset temp_action_type='PROJECT'>
            <cfelse>
                <cfset temp_action_type='MEMBER'>
            </cfif>
            <li><a href="#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=#temp_action_type#&analysis_id=#attributes.analysis_id#&result_id=#attributes.result_id#&#temp_member_type#" target="_blank"><img src="../../images/quiz.gif" border="0"></a></li>
        </cfif>
    <cfelse>
       
        <cfset temp_member_type = 'member_type=consumer&consumer_id=#get_plan_row.member_id#'>
        <cfquery name="get_member_analysis" datasource="#dsn#" maxrows="1">
            SELECT OPPORTUNITY_ID,OFFER_ID,PROJECT_ID,ANALYSIS_ID,RESULT_ID FROM MEMBER_ANALYSIS_RESULTS WHERE CONSUMER_ID = #attributes.member_id# ORDER BY ISNULL(UPDATE_DATE,RECORD_DATE) DESC
        </cfquery>
        <cfif get_member_analysis.recordcount>
            <cfif len(get_member_analysis.opportunity_id)>
                <cfset temp_action_type='OPPORTUNITY'>
            <cfelseif len(get_member_analysis.offer_id)>
                <cfset temp_action_type='OFFER'>
            <cfelseif len(get_member_analysis.project_id)>
                <cfset temp_action_type='PROJECT'>
            <cfelse>
                <cfset temp_action_type='MEMBER'>
            </cfif>
            <li><a href="#request.self#?fuseaction=member.list_analysis&event=upd-result&action_type=#temp_action_type#&analysis_id=#attributes.analysis_id#&result_id=#attributes.result_id#&#temp_member_type#"><img src="../../images/quiz.gif" border="0"></a></li>
        </cfif>
    </cfif>  --->
   
    <cfif len(get_plan_row.asset_id)>
        <li>
            <a href="#request.self#?fuseaction=assetcare.form_add_km&assetp_id=#attributes.asset_id#" target="_blank"><i class="catalyst-drawer" alt="<cf_get_lang_main no ='1421.Fiziki Varlık'>"border="0" title="<cf_get_lang_main no ='1421.Fiziki Varlık'>"></i></a>
                &nbsp;&nbsp;
        </li>
        
    </cfif>
   
</ul>

</cfoutput>
</div>
