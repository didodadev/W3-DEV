<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset ProjectCmp =createObject("component", "V16/project/cfc/projectData")>
<cfset get_project = ProjectCmp.get_projects()>
<cfset proIdList = valueList(get_project.project_id)>
<cfif isDefined("attributes.is_submit")>
  <cfset get_works = getComponent.DET_WORK(
    project_id : isdefined("attributes.project_id") ? attributes.project_id : "",
    pro_work_cat: isdefined("attributes.pro_work_cat") ? attributes.pro_work_cat : "",
    process_stage:isdefined("attributes.process_stage") ? attributes.process_stage :"",
    keyword:isdefined("attributes.keyword") ? attributes.keyword : "" ,
    work_status:isdefined("attributes.work_status") ? attributes.work_status : "",
    work_my:isdefined("attributes.work_my") ? attributes.work_my : "",
    proIdList : len("proIdList") ? proIdList : ""
    )>
<cfelse>
  <cfset get_works = getComponent.DET_WORK(work_status:1,work_my:1,proIdList : len("proIdList") ? proIdList : "")>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#get_works.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div id="search-results">     
<div class="table-responsive">
  <table class="table table-hover">
      <thead class="main-bg-color">
        <tr>                          
            <th class="text-uppercase"><cf_get_lang dictionary_id='58445.İş'></th>
            <th class="text-uppercase"><cf_get_lang dictionary_id='57416.Proje'></th>
            <th class="text-uppercase"><cf_get_lang dictionary_id='57569.Görevli'></th>
            <th class="text-uppercase"><cf_get_lang dictionary_id='57482.Aşama'></th>
            <th class="text-uppercase"><cf_get_lang dictionary_id='29513.Süre'></th>
            <th class="text-uppercase" colspan="2"><cf_get_lang dictionary_id='36798.Termin'></th>                 
        </tr>
      </thead>
      <tbody>
        <cfif get_works.recordcount>
          <cfoutput query="get_works" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>                       
              <td scope="row"><a href="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:work_id,accountKey:"wrk")#" class="none-decoration"> #work_head#</a></td>
              <td>
                <cfif len(project_id)>#get_project_name(project_id)#</cfif>
              </td>
              <td><cfif len(project_emp_id)>#get_emp_info(project_emp_id,0,0)#<cfelseif len(outsrc_partner_id)>#get_par_info(outsrc_partner_id,0,0,0)#</cfif></td>
              <td>
                <cfset get_work_currency = getComponent.GET_PROCESS(work_currency_id:work_currency_id)>
                <span class="process span-color-<cfif get_work_currency.stage.len() lt 8>#get_work_currency.stage.len()#<cfelse>7</cfif>">#get_work_currency.stage#</span>
              </td>                        
              <td>
                <cfif len(harcanan_dakika)>
                    <cfset harcanan_ = HARCANAN_DAKIKA>
                    <cfset liste=harcanan_/60>
                    <cfset saat=listfirst(liste,'.')>
                    <cfset dak=harcanan_-saat*60>
                    <label>#saat# s #dak# dk</label>
                <cfelse>
                    <label> 0 s 0 dk </label>                 	
                </cfif>
              </td>
              <td>
                <cfif len(terminate_date)>
                    <cfset fdate_plan=dateAdd("h",session_base.time_zone,terminate_date)>
                <cfelse>
                    <cfset fdate_plan=''>
                </cfif>
                <cfif isdefined('fdate_plan') and len(fdate_plan)>
                    #dateformat(fdate_plan,dateformat_style)# #timeformat(fdate_plan,timeformat_style)#
                </cfif>
              </td>                        
              <td><a href="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:work_id,accountKey:"wrk")#" class="none-decoration"><i class="fas fa-pencil-alt"></i></a></td>
            </tr>
          </cfoutput>
        <cfelse>
          <tr><td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
        </cfif>                     
      </tbody>
    </table>
    <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
      <cfset url_string = '/tasks&is_submit=1'>
      <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
      </cfif>
      <cfif  isdefined("attributes.work_status") and len(attributes.work_status)>
        <cfset url_string = '#url_string#&work_status=#attributes.work_status#'>
      </cfif>
      <cfif  isdefined("attributes.work_my") and len(attributes.work_my)>
        <cfset url_string = '#url_string#&work_my=#attributes.work_my#'>
      </cfif>
      <cfif  isdefined("attributes.process_stage") and len(attributes.process_stage)>
        <cfset url_string = '#url_string#&process_stage=#attributes.process_stage#'>
      </cfif>
      <cfif  isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfset url_string = '#url_string#&project_id=#attributes.project_id#'>
      </cfif>
      <cfif  isdefined("attributes.pro_work_cat") and len(attributes.pro_work_cat)>
        <cfset url_string = '#url_string#&pro_work_cat=#attributes.pro_work_cat#'>
      </cfif>      
      <table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
          <td>
            <cf_pages page="#attributes.page#"
              maxrows="#attributes.maxrows#"
              totalrecords="#attributes.totalrecords#"
              startrow="#attributes.startrow#"
              adres="#url_string#">
          </td>
          <td style="text-align:right"><cfoutput><b><cf_get_lang dictionary_id='57540.Total Record'>:</b>#attributes.totalrecords#&nbsp;-&nbsp;<b><cf_get_lang dictionary_id='57581.Page'>:</b>#attributes.page#/#lastpage#</cfoutput> </td>
        </tr>
      </table>
    </cfif>
</div> 
</div>
<script>  
  $('.portHeadLightMenu ul li a').css("display", "none");
  
    $('#<cfoutput>protein_widget_#widget.id#</cfoutput> .portHeadLightMenu ul').append(  
      $('<li>').addClass('btn btn-color-5').attr({
        onclick :"openBoxDraggable('widgetloader?widget_load=addWork&isbox=1&style=maxi&title=<cfoutput>#getLang('','',52657)#</cfoutput>')",
        title   :'<cf_get_lang dictionary_id='52657.Görev Ekle'>'}).text(" <cf_get_lang dictionary_id='52657.Görev Ekle'>").prepend($('<i>').addClass('far fa-plus-square'))
        ); 
  </script>