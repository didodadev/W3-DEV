
<cfset closable=0>
<cfif isdefined("attributes.fuseaction") and attributes.fuseaction eq 'process.qpic-r'>
    <cf_get_lang_set_main>
    <cfparam name="caller.lang_array_main" default="">
    <cfset closable=1>
</cfif>
<cfset getComponent = createObject('component','V16.process.cfc.get_design')>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.pp.maxrows>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="action_section" default="PROJECT">
<cfparam name="relative_id" default="#url.id#">
<cfset record_count_cf = 0>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset adres = "projectDetail?id=20">
<cfset get_list = getComponent.GET_LIST(
    startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
    maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
    keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
    start_date : '#iif(isdefined("attributes.start_date"),"attributes.start_date",DE(""))#',
    finish_date : '#iif(isdefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
    action_section : '#iif(len("action_section"),"action_section",DE(""))#',
    relative_id : '#iif(len("relative_id"),"relative_id",DE(""))#'
)>
            
        <div class="table-responsive">
            <table class="table">
                <thead class="main-bg-color">
                    <tr>                          
                      <td class="text-uppercase"><cf_get_lang dictionary_id='61923.Workflow Adı'></td>
                      <td class="text-uppercase"><cf_get_lang dictionary_id='61924.Tasarımcı'></td>
                      <td class="text-uppercase" colspan="2"><cf_get_lang dictionary_id='38628.Kayıt T.'></td>                 
                    </tr>
                </thead>
                <tbody>
                    <cfif get_list.recordcount>
                      <cfset record_count_cf = get_list.recordcount>
                      <cfoutput query="get_list">
                          <tbody>
                              <tr>          
                                  <td><a href="#request.self#?fuseaction=process.designer&event=concept&id=#PROCESS_ID#" target = "_blank">#FILE_NAME#</a></td> 
                                  <td>#get_emp_info(RECORD_EMP,0,1)#</td>         
                                  <td>#dateFormat(record_date,'dd/mm/yyyy')#</td> 
                                  <td>
                                      <input type="hidden" name="relative_id#currentrow#" id="relative_id#currentrow#" value="#get_list.relative_id#">
                                      <!--- <a href="" class="none-decoration"><i class="fas fa-pencil-alt"></i></a> --->
                                      <a href="javascript://" onclick="sil_designer(#currentrow#,#process_id#);">
                                      <i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
                                  </td>     
                              </tr>
                          </tbody>
                      </cfoutput>
                  <cfelse>
                      <tbody>
                          <tr>
                              <td colspan="5"><cf_get_lang dictionary_id ="57484.kayıt yok"></td>   
                          </tr>
                      </tbody>
                  </cfif>                       
                </tbody>
            </table>
        </div>
    
<script>
    $('#<cfoutput>protein_widget_#widget.id#</cfoutput> .portHeadLightMenu ul')
    .append(
            $('<li>')
                .addClass('btn btn-color-5 float-right far fa-plus-square')
                .attr({
                onclick :"",
                title		:'<cf_get_lang dictionary_id='61925.Workflow Ekle'>'})           
                .text(" <cf_get_lang dictionary_id='61925.Workflow Ekle'>") );       
</script>