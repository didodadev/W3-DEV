<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.is_active" default="1">
<cfif isdefined("widget.id")>
  <cfparam name="attributes.widget_id" default="#widget.id#">
<cfelse>
  <cfparam name="attributes.widget_id" default="">
</cfif>

<cfset getComponent = createObject('component','V16.project.cfc.projectData')>
<cfif isdefined("param_2") and param_2 eq 'wid'>
  <cfset getComponent_Work = createObject('component','V16.project.cfc.get_work')>
  <cfset get_works = getComponent_Work.DET_WORK(work_id:attributes.id,work_status:1
  )>
  <cfset attributes.id = get_works.project_id>
</cfif>
<cfset getComponent_call = createObject('component','V16.callcenter.cfc.call_center')>
<cfset GET_PRO_WORK = (
    ( attributes.param_1 eq "callDet" ) 
    ? getComponent.GET_PRO_WORK(g_service_id :attributes.id,keyword: attributes.keyword,work_status: attributes.is_active) 
    : getComponent.GET_PRO_WORK(project_id :attributes.id,keyword: attributes.keyword,work_status: attributes.is_active)
    )>
<cfset get_process_types = getComponent_call.get_process_types(faction: 'project.works')>


<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.totalrecords" default="#GET_PRO_WORK.recordcount#">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div id="search_work">
  <cfform id="search" name="search" method="post" style="margin:0" action="#REQUEST.self#?id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.id,accountKey:'wrk')#">    
    <input type="hidden" name="is_submitted" id="is_submitted" value="1" />                    
    <div class="in_filter_item"> 
      <div class="form-group col-md-6 col-lg-3 col-xl-2">
        <cfinput id="keyword" name="keyword" type="text" value="#attributes.keyword#" class="form-control" placeholder="#getLang('','Keyword','32828')#">
      </div> 
      <div class="form-group col-md-6 col-lg-3 col-xl-2">
        <select class="form-control" id="process_stage" name="process_stage">
          <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
          <cfoutput query="get_process_types">
              <option value="#process_row_id#" <cfif process_row_id eq attributes.process_stage>selected</cfif>>#stage#</option>
          </cfoutput>
        </select>
      </div> 
      <div class="form-group col-md-6 col-lg-3 col-xl-2">
        <select class="form-control" id="is_active" name="is_active">
          <option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
          <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option> 
          <option value="-1" <cfif attributes.is_active eq -1>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option> 
        </select>
      </div> 
      <div class="form-group">
        <select class="form-control" id="maxrows" name="maxrows" style="width:68px;">
          <option value="25" <cfif attributes.maxrows eq 25>selected</cfif>>10</option>
          <option value="25" <cfif attributes.maxrows eq 25>selected</cfif>>25</option>
          <option value="50" <cfif attributes.maxrows eq 50>selected</cfif>>50</option> 
          <option value="100" <cfif attributes.maxrows eq 100>selected</cfif>>100</option> 
        </select>
      </div> 
      <div class="form-group col-md-6 col-lg-3 col-xl-2">
        <button type="submit" class="btn font-weight-bold text-uppercase btn-color-7"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
      </div>
    </div>
  </cfform>
</div>
<div class="table-responsive">
  <table class="table table-hover">
      <thead class="main-bg-color">
        <tr>                          
            <th>M</th>
            <th><cf_get_lang dictionary_id='55773.Job'></th>
            <th><cf_get_lang dictionary_id='57569.Staff'></th>
            <th><cf_get_lang dictionary_id='57482.Stage'></th>
            <th scope="col">%</th>
            <th colspan="2"><cf_get_lang dictionary_id='36798.Termin'></th>                  
        </tr>
      </thead>
          <tbody>
            <cfif GET_PRO_WORK.recordcount>
              <cfoutput query="GET_PRO_WORK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>                       
                  <td>
                    <cfif type eq 0>
                      <div class="circle_word">M</div>
                    <cfelse>
                        <cfif isdefined("attributes.milestone_work_id") and len(milestone_work_id) and attributes.work_milestones neq 0>&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
                    </cfif>
                  </td>
                  <td>#work_head#</td>
                  <td>#employee#</td>
                  <td><span class="badge pl-3 pr-3 py-2 span-color-<cfif stage.len() lt 8>#stage.len()#<cfelse>7</cfif>">#stage#</span></td>                        
                  <td>#TO_COMPLETE#%</td>
                  <cfif isdefined('TERMINATE_DATE') and len(TERMINATE_DATE)>
                      <cfset tdate=dateadd("h",session.pp.time_zone,TERMINATE_DATE)>
                  <cfelse>
                      <cfset tdate = ''>
                  </cfif>
                  <td>#dateformat(tdate,'dd/mm/yyyy')#</td>                        
                  <td>
                    <a href="#site_language_path#/taskdetail?wid=#contentEncryptingandDecodingAES(isEncode:1,content:work_id,accountKey:"wrk")#" class="none-decoration" target="_blank"><i class="fas fa-pencil-alt"></i></a></td>
                    <!--- <a href="javascript://" onclick='openBoxDraggable("widgetloader?widget_load=updWork&isbox=1&work_id=#work_id#")' class="none-decoration"> --->
                </tr>
              </cfoutput>
            <cfelse>
              <tr><td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
            </cfif>                       
          </tbody>
    </table>
    <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
      <cfset url_string = 'widgetloader?widget_load=isler&id=#contentEncryptingandDecodingAES(isEncode:1,content:attributes.id,accountKey:'wrk')#&is_submitted=1&'>
      <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
      </cfif>
      <cfif  isdefined("attributes.process_stage") and len(attributes.process_stage)>
        <cfset url_string = '#url_string#&process_stage=#attributes.process_stage#'>
      </cfif>
      <cfif  isdefined("attributes.is_active") and len(attributes.is_active)>
        <cfset url_string = '#url_string#&is_active=#attributes.is_active#'>
      </cfif>
      <cfif  isdefined("attributes.widget_id") and len(attributes.widget_id)>
        <cfset url_string = '#url_string#&widget_id=#attributes.widget_id#'>
      </cfif>
      <table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
          <td>
            <cf_pages page="#attributes.page#"
              maxrows="#attributes.maxrows#"
              totalrecords="#attributes.totalrecords#"
              startrow="#attributes.startrow#"
              target="body_#attributes.widget_id#"
              isAjax="true"
              adres="#url_string#">
          </td>
          <td style="text-align:right"><cfoutput><cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Page'>:#attributes.page#/#lastpage#</cfoutput> </td>
        </tr>
      </table>
    </cfif>
</div>
<script>
  $('#<cfoutput>protein_widget_#attributes.widget_id#</cfoutput> .portHeadLightMenu ul').append(
    $('<li>').addClass('btn btn-color-5')
      .attr({
      onclick :"openBoxDraggable('widgetloader?widget_load=addWork&isbox=1&style=maxi&<cfoutput>title=#getLang('','',55773)#&#iif(attributes.param_1 eq 'callDet',DE('g_service_id'),DE('project_id'))#=#attributes.id#</cfoutput>')",
      title   :'<cf_get_lang dictionary_id='52657.Görev Ekle'>',
      style   :"font-size:.8rem"})           
      .text(" <cf_get_lang dictionary_id='52657.Görev Ekle'>")
      .prepend($('<i>').addClass('far fa-plus-square')) 
    );
</script>
 