<div id="search-results">
  <cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
  <cfset getComponent2 = createObject('component','V16.project.cfc.get_work')>
  <cfset get_emp = getComponent2.GET_POSITIONS(our_cid : session_base.our_company_id)>
  <cfset GET_SERVICE = getComponent.GET_SERVICE(keyword : attributes.keyword, resp_id : attributes.resp_id, process_stage : attributes.process_stage, category : attributes.category, subscription_id : attributes.subscription_id, service_status: 1)>
  <cfset GET_SERVICE_APPCAT = getComponent.GET_SERVICE_APPCAT()>
  <cfset get_process_types = getComponent.get_process_types()>
  <cfparam name="attributes.page" default=1>
  <cfparam name="attributes.totalrecords" default=#GET_SERVICE.recordcount#>
  <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
  <div class="table-responsive">
      <table class="table table-hover">
        <thead class="main-bg-color">
          <tr>                  
            <th><cf_get_lang dictionary_id='58820.Title'></th>
            <th><cf_get_lang dictionary_id='57482.Stage'></th>                
            <th><cf_get_lang dictionary_id='57457.Customer'></th>
            <th><cf_get_lang dictionary_id='57486.Category'></th>
            <th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
            <th colspan="2"><cf_get_lang dictionary_id='57742.Tarih'></th> 
          </tr>
        </thead>
        <tbody>
          <cfif GET_SERVICE.recordcount>
            <cfoutput query="GET_SERVICE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
             
              <cfset partner_id_list = "">
                <cfset consumer_id_list = "">
                <cfset company_id_list = "">
                <cfset service_branch_id_list = "">
                <cfset service_id_list = "">
                <cfset commethod_id_list = "">
                <cfset servicecat_sub_list = "">
                <cfset employee_list = "">
                <cfset record_consumer_id_list = "">
                <cfset record_par_id_list = "">
                <cfif len(service_partner_id) and not listfind(partner_id_list,service_partner_id)>
                  <cfset partner_id_list=listappend(partner_id_list,service_partner_id)>
                </cfif>
                <cfif len(service_company_id) and not listfind(company_id_list,service_company_id)>
                  <cfset company_id_list=listappend(company_id_list,service_company_id)>
                </cfif>
                <cfif len(service_consumer_id) and not listfind(consumer_id_list,service_consumer_id)>
                  <cfset consumer_id_list=listappend(consumer_id_list,service_consumer_id)>
                </cfif>
                <cfif len(service_branch_id) and not listfind(service_branch_id_list,service_branch_id)>
                  <cfset service_branch_id_list=listappend(service_branch_id_list,service_branch_id)>
                </cfif>
                <cfif len(service_id) and not listfind(service_id_list,service_id)>
                  <cfset service_id_list=listappend(service_id_list,service_id)>
                </cfif>
                <cfif len(commethod_id) and not listfind(commethod_id_list,commethod_id)>
                  <cfset commethod_id_list=listappend(commethod_id_list,commethod_id)>
                </cfif>
                <cfif len(service_id) and not listfind(servicecat_sub_list,service_id)>
                  <cfset servicecat_sub_list=listappend(servicecat_sub_list,service_id)>
                </cfif>
                <cfif len(service_employee_id) and not listfind(employee_list,service_employee_id)>
                  <cfset employee_list=listappend(employee_list,service_employee_id)>
                </cfif>
                <cfif len(record_member) and not listfind(employee_list,record_member)>
                  <cfset employee_list=listappend(employee_list,record_member)>
                </cfif>
                <cfif len(record_par) and not listfind(record_par_id_list,record_par)>
                  <cfset record_par_id_list=listappend(record_par_id_list,record_par)>
                </cfif>
                <cfif len(record_cons) and not listfind(record_consumer_id_list,record_cons)>
                  <cfset record_consumer_id_list=listappend(record_consumer_id_list,record_cons)>
                </cfif>
                <cfif len(partner_id_list)>
                  <cfset partner_id_list=ListSort(partner_id_list,"numeric","ASC",",")>
                  <cfset GET_PARTNER_DETAIL = getComponent.GET_PARTNER_DETAIL(partner_id_list : partner_id_list)>
                  <cfset partner_id_list = ListSort(ListDeleteDuplicates(ValueList(get_partner_detail.partner_id,',')),"numeric","asc",",")>
                </cfif>
                <cfif len(company_id_list)>
                  <cfset company_id_list=ListSort(company_id_list,"numeric","ASC",",")>
                  <cfset GET_COMPANY_DETAIL = getComponent.GET_COMPANY_DETAIL(company_id_list : company_id_list)>
                  <cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_detail.company_id,',')),"numeric","asc",",")>
                </cfif>
                <cfif len(consumer_id_list)>
                  <cfset consumer_id_list=ListSort(consumer_id_list,"numeric","ASC",",")>
                  <cfset GET_CONSUMER_DETAIL = getComponent.GET_CONSUMER_DETAIL(consumer_id_list : consumer_id_list)>		
                  <cfset consumer_id_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_detail.consumer_id,',')),"numeric","asc",",")>
                  <cfset company_id_list = ListSort(ListDeleteDuplicates(ValueList(get_company_detail.company_id,',')),"numeric","asc",",")>
                </cfif>
                <cfif len(employee_list)>
                  <cfset employee_list=ListSort(employee_list,"numeric","ASC",",")>
                  <cfset GET_RECORD_EMP = getComponent.GET_RECORD_EMP(employee_list : employee_list)>
                  <cfset employee_list = ListSort(ListDeleteDuplicates(ValueList(GET_RECORD_EMP.EMPLOYEE_ID,',')),"numeric","asc",",")>
                </cfif>
              <tr>               
                <td><a href="#site_language_path#/callDet?id=#contentEncryptingandDecodingAES(isEncode:1,content:service_id,accountKey:"wrk")#" class="none-decoration">#SERVICE_HEAD#</a></td>
                <td><div class="process span-color-<cfif line_number lt 8>#line_number#<cfelse>7</cfif>">#STAGE#</div></td>
                <td>
                  <cfif len(get_service.service_company_id) and (get_service.service_company_id neq 0)> 
                    #get_company_detail.nickname# -                    
                    <cfif len(get_service.service_partner_id) and (get_service.service_partner_id neq 0) and not len(get_service.applicator_name)>
                      #get_partner_detail.company_partner_name[listfind(partner_id_list,service_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,service_partner_id,',')]#
                    <cfelseif len(get_service.applicator_name)>
                      #get_service.applicator_name#
                    </cfif>
                  <cfelseif len(get_service.service_consumer_id) and  (get_service.service_consumer_id neq 0)>                     
                    #get_consumer_detail.CONSUMER_NAME[listfind(consumer_id_list,service_consumer_id,',')]# #get_consumer_detail.CONSUMER_SURNAME[listfind(consumer_id_list,service_consumer_id,',')]#                   
                  <cfelseif len(get_service.service_employee_id) and (get_service.service_employee_id neq 0)>
                    #get_record_emp.EMPLOYEE_NAME[listfind(employee_list,service_employee_id,',')]# #get_record_emp.EMPLOYEE_SURNAME[listfind(employee_list,service_employee_id,',')]#
                  </cfif>
                </td>
                <td>#servicecat#</td>
                <td>                  
                  <cfif len(RESP_EMP_ID)>
                    #get_emp_info(RESP_EMP_ID,0,0)#
                  <cfelseif len(RESP_PAR_ID)>
                    #get_par_info(resp_par_id,0,0,0)#
                  <cfelseif len(RESP_CONS_ID)>
                    #get_cons_info(resp_cons_id,0,0)#
                  </cfif>
                </td>
                <td>
                  <cfif len(apply_date)>
                    <cfset apply_date_ = dateformat(date_add("H",session.pp.time_zone,apply_date),dateformat_style)>
                    #dateformat(apply_date,dateformat_style)#
								  </cfif>
                </td>
                
                <td><a href="#site_language_path#/callDet?id=#contentEncryptingandDecodingAES(isEncode:1,content:service_id,accountKey:"wrk")#" class="none-decoration"><i class="fas fa-pencil-alt"></i></a></td>
              </tr>
            </cfoutput> 
          <cfelse>
            <tr><td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
          </cfif>                         
        </tbody>
      </table>
      <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
				<cfset url_string = '/calls?&is_submitted=1'>
				<cfif len(attributes.keyword)>
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</cfif>
				<cfif len(attributes.process_stage)>
					<cfset url_string = '#url_string#&process_stage=#attributes.process_stage#'>
				</cfif>
				<cfif len(attributes.category)>
					<cfset url_string = '#url_string#&category=#attributes.category#'>
				</cfif>
        <cfif len(attributes.subscription_id)>
					<cfset url_string = '#url_string#&subscription_id=#attributes.subscription_id#'>
				</cfif>
        <cfif len(attributes.resp_id)>
					<cfset url_string = '#url_string#&resp_id=#attributes.resp_id#'>
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
					  <td style="text-align:right"><cfoutput><cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Page'>:#attributes.page#/#lastpage#</cfoutput> </td>
					</tr>
				</table>
      </cfif>
  </div>   
  <script>
   $('.portHeadLightMenu ul li a').css("display", "none");

  $('.portHeadLightMenu ul')
  .append(
    $('<li>').addClass('btn btn-color-5')
      .attr({
      onclick :"openBoxDraggable('widgetloader?widget_load=addCall&isbox=1&style=maxi&title=<cfoutput>#getLang('','',61768)#</cfoutput>')",
      title   :' Çağrı Ekle'})           
      .text(" Çağrı Ekle").css("font-family","'PoppinsR'") 
      .prepend($('<i>').addClass('far fa-plus-square')
        
        )
      );
  </script>
</div>