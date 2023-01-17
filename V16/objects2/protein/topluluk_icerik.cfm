<cfset getComponent = createObject('component','V16.objects2.protein.data.community_data')>
<cfset get_hr = getComponent.GET_HR(
    keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
    certificate_filter : '#IIf(IsDefined("attributes.certificate_filter"),"attributes.certificate_filter",DE(''))#'    
)>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default='#get_hr.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
    <cfset employee_list = ''>            
<cfoutput query="get_hr" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">    
    <cfset employee_list = listappend(employee_list,get_hr.employee_id,',')>
</cfoutput>
<cfset GET_POSITIONS= getComponent.GetPositions(employee_list:employee_list)>

<cfif get_hr.recordcount>
  <div class="user_list">
    <cfoutput query="get_hr" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <div class="user_list_isotope col-md-4">
            <div class="user_list_item">
                <cfif len(PHOTO)>
                    <div class="user_list_item_img">
                        <img class="rounded-circle" src="/documents/hr/#PHOTO#">
                    </div>
                <cfelseif SEX eq 1>
                    <div class="user_list_item_img">
                        <img class="rounded-circle" src="/images/male.jpg">
                    </div>
                <cfelseif SEX eq 0>
                    <div class="user_list_item_img">
                        <img class="rounded-circle" src="/images/female.JPG">
                    </div>
                </cfif>               
                <div class="user_list_item_text">                                    
                    <a href="#site_language_path#/communityMember?emp_id=#EMPLOYEE_ID#">                      
                      <h3>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</h3>     
                    </a>                    
                    <cfset GET_POSITION = getComponent.GetPosition(employee_id:employee_id)>
                    <cfif get_position.recordcount>
                      <p>#get_position.department_head#, #get_position.position_name#</p>
                    </cfif>
                </div>
            </div>
        </div>  
    </cfoutput>              
  </div>
</cfif>

<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
         <cfset url_str = 'community?&form_submitted=1'>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.certificate_filter)>
            <cfset url_str = "#url_str#&certificate_filter=#attributes.certificate_filter#">
        </cfif>
	<div class="table-responsive">
		<table class="table">
			<tr> 
				<td> 
					<cf_paging page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#url_str#"> 
				</td>
				<td class="text-right"><cfoutput> <cf_get_lang_main no="128.Toplam Kayıt">: #attributes.totalrecords# - <cf_get_lang_main no="169.Sayfa"> : #attributes.page# / #lastpage#</cfoutput></td>
			</tr>
		</table>
	</div>
</cfif>

<script> 
   $( document ).ready(function() {
          $('.user_list').masonry({
              // options
              itemSelector: '.user_list_isotope'
          });
      });   
</script>