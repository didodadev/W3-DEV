<cfset component = createObject("component", "WBO.model.userGroup")>
<cfset component_history = createObject("component", "WBO.model.userGroupHistory")>
<cfset get_user_group_history = component_history.get_user_group_history(user_group_id : url.user_group_id)>
<cfset get_user_group_emp_hist = component_history.get_user_group_emp_hist(user_group_id : url.user_group_id)>
<cfset get_user_group_object_hist = component_history.get_user_group_object_hist(user_group_id : url.user_group_id)>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='57473.Tarihçe'> : <cfoutput>#get_user_group_history.user_group_name#</cfoutput></cfsavecontent>
<cf_box title="#title#">
    <cf_seperator id="history_user_group" header="Yetki Grubu"  is_closed="1">
    <div id="history_user_group">
        <cfif get_user_group_history.recordcount>
            <cfset temp_ = 0>
                <cfoutput query="get_user_group_history">
                    <cfset module_name_list = ''>
                    <cfset module_name = component.GET_MODULES_NAME(module_no : get_user_group_history.user_group_permissions)>
                    <cfloop query="module_name">
                        <cfset module_name_list=listappend(module_name_list,'&nbsp;#MODULE#')>
                    </cfloop>     
                    <cfset gdpr_name_list = ''>
                    <cfset get_module_name = component.GET_GDPR_NAME(sensitivity_id : get_user_group_history.SENSITIVE_USER_LEVEL)>
                    <cfloop query="get_module_name">
                        <cfset gdpr_name_list=listappend(gdpr_name_list,'&nbsp;#SENSITIVITY_LABEL#')>
                    </cfloop>        
                    <cf_ajax_list>
                        <tbody>	
                            <tr style="border-bottom:0px">
                                <td style="width:100px;"><b><cf_get_lang dictionary_id='33110.Modüller'></b></td>
                                <td colspan="4">#module_name_list#</td>
                            </tr>
                            <tr style="border-bottom:0px">
                                <td style="width:100px;"><b><cf_get_lang dictionary_id='46598.GDPR Yetkisi'></b></td>
                                <td colspan="4">#gdpr_name_list#</td>
                            </tr>
                            <tr  style="border-bottom:0px">
                                <td  style="width:100px;"><b><cf_get_lang dictionary_id ='57891.Güncelleyen'></b></td>
                                <td>#get_emp_info(UPDATE_EMP,0,0)#</td>
                            </tr>
                            <tr>
                                <td style="width:100px;"><b><cf_get_lang dictionary_id='40835.Güncelleme Tarihi'></b></td>
                                <td>#DateFormat(update_date,dateformat_style)# - (#timeformat(update_date,'HH:MM')#)</td>
                            </tr>
                        </tbody>   
                    </cf_ajax_list>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
                </tr>
        </cfif> 
    </div>
    <cf_seperator id="history_user_group_emp" header="#getLang('','Yetki Grubu Kullanıcılar',42794)#" is_closed="1">
    <div id="history_user_group_emp">
        <cfif get_user_group_emp_hist.recordcount>
            <cfset temp_ = 0>
                <cfoutput query="get_user_group_emp_hist">
                    <cf_ajax_list id="history_#temp_#_name">
                        <tbody>	
                            <tr   style="border-bottom:0px">
                                <td style="width:75px;"><b><cf_get_lang dictionary_id='58992.Kullanıcılar'></b></td>
                                <td colspan="3">
                                <cfset get_emp_name_hist = component_history.get_emp_name_hist(user_group_id : url.user_group_id,record_date : get_user_group_emp_hist.record_date)>
                                    <cfset emp_name_list = valuelist(get_emp_name_hist.EMPLOYEE_ID,',')>
                                    <cfloop list="#emp_name_list#" index="i">
                                        #get_emp_info(i,0,0)#<cfif listlast(emp_name_list,',') neq i>,</cfif>
                                    </cfloop>
                                </td>
                            </tr>
                            <tr  style="border-bottom:0px">
                                <td  style="width:100px;"><b><cf_get_lang dictionary_id ='57891.Güncelleyen'></b></td>
                                <td>#get_emp_info(UPDATE_EMP,0,0)#</td>
                            </tr>
                            <tr>
                                <td style="width:100px;"><b><cf_get_lang dictionary_id='40835.Güncelleme Tarihi'></b></td>
                                <td>#DateFormat(update_date,dateformat_style)# - (#timeformat(update_date,'HH:MM')#)</td>
                            </tr>
                        </tbody>   
                    </cf_ajax_list>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
                </tr>
        </cfif>
    </div>
    <cf_seperator id="history_user_group_object" header="#getLang('','Yetki Grubu',30350)# #getLang('','Yetki Grubu',47260)#" is_closed="1">
    <div id="history_user_group_object">
        <cfif get_user_group_object_hist.recordcount>
            <cfset temp_ = 0>
                    <cf_ajax_list id="history_#temp_#_name">
                        <thead>
                            <tr>
                                <th width="80"><cf_get_lang dictionary_id ='57891.Güncelleyen'></th>
                                <th width="80"><cf_get_lang dictionary_id='40835.Güncelleme Tarihi'></th>
                                <th width="80"><cf_get_lang dictionary_id='44481.Obje'></th>
                                <th width="50"><cf_get_lang dictionary_id='57509.Liste'></th>
                                <th width="50"><cf_get_lang dictionary_id='44630.Ekle'></th>
                                <th width="50"><cf_get_lang dictionary_id='57464.Güncelle'></th>
                                <th width="50"><cf_get_lang dictionary_id='43300.Silme'></th>
                            </tr>
                        </thead>
                    <cfoutput query="get_user_group_object_hist">
                        <tbody>	
                            <tr>
                                <td>#get_emp_info(record_emp,0,0)#</td>
                                <td>#DateFormat(record_date,dateformat_style)# - (#timeformat(record_date,'HH:MM')#)</td>
                                <td>#object_name#</td>
                                <td><input type="checkbox" value="#list_object#" disabled <cfif list_object eq 1> checked</cfif>></td>
                                <td><input type="checkbox" value="#add_object#" disabled <cfif add_object eq 1> checked</cfif>></td>
                                <td><input type="checkbox" value="#update_object#" disabled <cfif update_object eq 1> checked</cfif>></td>
                                <td><input type="checkbox" value="#delete_object#" disabled <cfif delete_object eq 1> checked</cfif>></td>

                            </tr>
                        </tbody>     
                    </cfoutput>
                    </cf_ajax_list>
                
            <cfelse>
                <tr>
                    <td colspan="13"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td> 
                </tr>
        </cfif>
    </div>
</cf_box>

