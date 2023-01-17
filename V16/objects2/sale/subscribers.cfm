<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='100'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfset contract_cmp = createObject("component","V16.sales.cfc.subscription_contract")>
<cfset GET_SUBSCRIPTIONS = contract_cmp.GET_SUBSCRIPTIONS(status:1,dsn3:dsn3,startrow:attributes.startrow,maxrows:attributes.maxrows,company_id:session_base.company_id)>
<div class="table-responsive">
    <table class="table table-hover">
        <thead class="main-bg-color">
            <tr>                          
                <th><cf_get_lang dictionary_id='58832.Subscription'></th>
                <th><cf_get_lang dictionary_id='57486.Category'></th>
                <th><cf_get_lang dictionary_id='57892.Domain'></th>
                <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
                <th><cf_get_lang dictionary_id='57578.Contact Person'></th>
                <th><cf_get_lang dictionary_id='58467.Start'></th>
                <th><cf_get_lang dictionary_id='61797.?'>-<cf_get_lang dictionary_id='57502.Finish'></th>
                <th colspan="2"><cf_get_lang dictionary_id='57482.Stage'></th>                 
            </tr>
        </thead>
        <tbody>
            <cfif get_subscriptions.recordcount>
            <cfset consumer_list=''>
            <cfset partner_list=''>
            <cfset employee_list=''>
            <cfset process_list=''>
            <cfoutput query="get_subscriptions">
                <cfif len(get_subscriptions.consumer_id) and not listfind(consumer_list,get_subscriptions.consumer_id)>
                    <cfset consumer_list = listappend(consumer_list,get_subscriptions.consumer_id)>
                </cfif>
                <cfif len(get_subscriptions.partner_id) and not listfind(partner_list,get_subscriptions.partner_id)>
                    <cfset partner_list = listappend(partner_list,get_subscriptions.partner_id)>
                </cfif>
                <cfif len(get_subscriptions.record_emp) and not listfind(employee_list,get_subscriptions.record_emp)>
                    <cfset employee_list = listappend(employee_list,get_subscriptions.record_emp)>
                </cfif>
                <cfif len(get_subscriptions.record_cons) and not listfind(consumer_list,get_subscriptions.record_cons)>
                    <cfset consumer_list = listappend(consumer_list,get_subscriptions.record_cons)>
                </cfif>
                <cfif len(get_subscriptions.sales_emp_id) and not listfind(employee_list,get_subscriptions.sales_emp_id)>
                    <cfset employee_list = listappend(employee_list,get_subscriptions.sales_emp_id)>
                </cfif>
                <cfif len(get_subscriptions.subscription_stage) and not listfind(process_list,get_subscriptions.subscription_stage)>
                    <cfset process_list = listappend(process_list,get_subscriptions.subscription_stage)>
                </cfif>
            </cfoutput>
            <cfif len(partner_list)>
                <cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
                <cfset GET_PARTNER = contract_cmp.GET_PARTNER(partner_list:partner_list)>
                <cfset main_partner_list = listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(consumer_list)>
                <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
                <cfset get_consumer = contract_cmp.GET_CONSUMER(consumer_list:consumer_list)>
                <cfset main_consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(employee_list)>
                <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
                <cfset GET_EMPLOYEE = contract_cmp.GET_EMPLOYEE(employee_list:employee_list)>
                <cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
            </cfif>	
            <cfif len(process_list)>
                <cfset process_list=listsort(process_list,"numeric","ASC",",")>
                <cfset get_process_type = contract_cmp.GET_PROCESS_TYPE(process_list:process_list)>
                <cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
                <cfset line_list = listsort(listdeleteduplicates(valuelist(get_process_type.line_number,',')),'numeric','ASC',',')>
            </cfif> 
            <cfoutput query="GET_SUBSCRIPTIONS">
                <tr>                       
                <td scope="row"><a href="#site_language_path#/subscriberDetail?subscription_id=#contentEncryptingandDecodingAES(isEncode:1,content:subscription_id,accountKey:"wrk")#" class="none-decoration"><i class="fas fa-chevron-right text-color-2"></i>#subscription_no#</a></td>
                <td>#subscription_type#</td>
                <td><cfif listLen(PROPERTY16)><cfloop index = "i" item = "domain" list = "#PROPERTY16#" delimiters = ",">#domain#<br></cfloop></cfif></td>
                <td>
                    <cfif len(GET_SUBSCRIPTIONS.consumer_id)>
                        #get_cons_info(GET_SUBSCRIPTIONS.consumer_id, 2, 0)#
                    <cfelseif len(GET_SUBSCRIPTIONS.company_id)>
                    <cfif len(GET_SUBSCRIPTIONS.partner_id)>
                        #get_par_info(GET_SUBSCRIPTIONS.partner_id, 0, 1, 0)#
                    </cfif></cfif>
                </td>
                <td>
                    <cfif len(get_subscriptions.consumer_id)>
                    <a href="javascript://" class="none-decoration" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_subscriptions.consumer_id#','medium');">#get_consumer.consumer_name[listfind(main_consumer_list,get_subscriptions.consumer_id,',')]#&nbsp;#get_consumer.consumer_surname[listfind(main_consumer_list,get_subscriptions.consumer_id,',')]#</a>
                    <cfelseif len(get_subscriptions.company_id)>
                    <cfif len(get_subscriptions.partner_id)><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_subscriptions.partner_id#','medium');" class="none-decoration">#get_partner.company_partner_name[listfind(main_partner_list,get_subscriptions.partner_id,',')]#&nbsp;#get_partner.company_partner_surname[listfind(main_partner_list,get_subscriptions.partner_id,',')]#</a></cfif>
                    </cfif>
                </td>
                <td>#dateFormat(start_date,'dd/mm/yyyy')#</td>
                <td>#dateFormat(finish_date,'dd/mm/yyyy')#</td>
                <td><span class="badge pl-3 pr-3 py-2 span-color-<cfif get_process_type.STAGE[listfind(main_process_list,get_subscriptions.subscription_stage,',')].len() lt 8>#get_process_type.STAGE[listfind(main_process_list,get_subscriptions.subscription_stage,',')].len()#<cfelse>7</cfif>"><cfif len(get_subscriptions.subscription_stage)>#get_process_type.STAGE[listfind(main_process_list,get_subscriptions.subscription_stage,',')]#</cfif></span></td> 
                <td><a href="#site_language_path#/subscriberDetail?subscription_id=#contentEncryptingandDecodingAES(isEncode:1,content:subscription_id,accountKey:"wrk")#" class="none-decoration"><i class="fas fa-pencil-alt"></i></a></td>
                </tr>
            </cfoutput>
            </cfif>                  
        </tbody>
    </table>
</div>

<script>  
$('.portHeadLightMenu ul li a').css("display", "none");

$('#<cfoutput>protein_widget_#widget.id#</cfoutput> .portHeadLightMenu ul').append(  
    $('<a>').append(
        $('<li>').addClass('btn btn-color-5').attr({
            onclick: "/subscriberDetail",
            title: '<cf_get_lang dictionary_id='49253.Abone Ekle'>'
        }).text(" <cf_get_lang dictionary_id='49253.Abone Ekle'>").prepend($('<i>').addClass('far fa-plus-square')) 
    ).attr({'href':'/subscriberInfo'})
); 
</script>