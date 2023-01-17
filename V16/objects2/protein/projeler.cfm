<cfscript>
	CreateCompenent = createObject("component", "V16/project/cfc/projectData");
	get_projects = CreateCompenent.get_projects();
</cfscript>      
<div class="table-responsive">
  <table class="table table-hover">
    <thead class="main-bg-color">
      <tr>                          
          <th><cf_get_lang dictionary_id='57416.Proje'></th>
          <th><cf_get_lang dictionary_id='57574.Şirket'></th>
          <th><cf_get_lang dictionary_id='33285.Proje Lideri'></th>
          <th><cf_get_lang dictionary_id='57482.Aşama'></th>
          <th><cf_get_lang dictionary_id='58467.Başlama'></th>
          <th><cf_get_lang dictionary_id='57502.Bitiş'></th>       
          <th></th>            
      </tr>
    </thead>
    <tbody>
      <cfif get_projects.recordcount>
        <cfoutput query="get_projects">
          <tr>                       
            <td>
              <a href="#site_language_path#/projectDetail?id=#contentEncryptingandDecodingAES(isEncode:1,content:project_id,accountKey:"wrk")#" class="none-decoration">#project_head#</a>
            </td>
            <td>
              <cfif len(company_id)>#get_par_info(company_id,1,0,0)#<cfelseif len(partner_id)>#get_cons_info(partner_id,1,0)#<cfelseif len(consumer_id)>#get_cons_info(consumer_id,1,0)#</cfif>
            </td>
            <td>
              <cfif len(project_emp_id)>#get_emp_info(project_emp_id,0,0)#<cfelseif len(outsrc_partner_id)>#get_par_info(outsrc_partner_id,0,2,0)#-#get_par_info(outsrc_partner_id,0,1,0)#</cfif>
            </td>
            <td>
              <span class="badge pl-3 pr-3 py-2 span-color-<cfif line_number lt 8>#line_number#<cfelse>7</cfif>">
                #stage#
              </span>
            </td>                        
            <td>
              #dateformat(target_start,"dd/mm/yyyy")#
            </td>
            <td>
              #dateformat(target_finish,"dd/mm/yyyy")#
            </td>                        
            <td>
              <ul class="ui-icon-list">
                <li><a href="#site_language_path#/projectDetail?id=#contentEncryptingandDecodingAES(isEncode:1,content:project_id,accountKey:"wrk")#"><i class="fas fa-pencil-alt"></i></a></li>
              </ul>
            </td>
          </tr>
        </cfoutput> 
      </cfif>                    
    </tbody>
  </table>
</div>

<script>  
  $('.portHeadLightMenu ul li a').css("display", "none");

  $('.portHeadLightMenu ul')
  .append(
    $('<li>').addClass('btn btn-color-5')
      .attr({
      onclick :"openBoxDraggable('widgetloader?widget_load=addProject&style=maxi&isbox=1&title=<cfoutput>#getLang('','',32008)#</cfoutput>')",
      title   :' <cf_get_lang dictionary_id='32008.Proje Ekle'>'})           
      .text(" <cf_get_lang dictionary_id='32008.Proje Ekle'>")
      .prepend($('<i>').addClass('far fa-plus-square')
        
        )
      );
</script>