<cfinclude template="../query/get_contact_simple.cfm">
    <cf_flat_list>
        <tbody>
            <tr> 
                <td>
                    <cfif contact_type is "e">
                        <cf_get_lang dictionary_id='57576.Çalışan'> 
                    <cfelseif contact_type is "p">
                        <cfoutput>#get_contact_simple.companycat#</cfoutput> 
                    <cfelseif contact_type is "comp">
                        <cfoutput>#get_contact_simple.companycat#</cfoutput> 
                    <cfelseif contact_type is "c">
                        <cfoutput>#get_contact_simple.conscat#</cfoutput> 
                    </cfif> 
                </td>
            </tr>
            <cfif isdefined("get_contact_simple") and get_contact_simple.recordcount>
                <tr> 
                    <td><cfoutput>
                        <cfif ((contact_type is "p") or (contact_type is "comp")) and len(get_contact_simple.company_name)>
                            <cfif get_module_user(4)>
                                <a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_contact_simple.company_id#" class="tableyazi">#get_contact_simple.company_name#</a>
                            <cfelse>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_contact_simple.company_id#','medium');" class="tableyazi">#get_contact_simple.company_name#</a>
                            </cfif>
                        <cfelseif isdefined("get_contact_simple.company_name") and len(get_contact_simple.company_name)>
                            #get_contact_simple.company_name#
                        <cfelse>
                            <cfif contact_type is "p">
                                <cfif get_module_user(4)>
                                    <a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_contact_simple.company_id#" class="tableyazi">#get_contact_simple.fullname#</a>
                                <cfelse>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_contact_simple.company_id#');" class="tableyazi">#get_contact_simple.fullname#</a>
                                </cfif>				
                            </cfif>
                        </cfif>
                        </cfoutput>
                    </td>
                </tr>
                <tr> 
                    <td><cfoutput>
                            <cfif (contact_type is "p") or (contact_type is "comp")>
                                <cfif get_module_user(4)>
                                    <a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#get_contact_simple.AUTHORITY_ID#" class="tableyazi">#get_contact_simple.name# #get_contact_simple.surname#</a>
                                <cfelse>
                                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_contact_simple.AUTHORITY_ID#','medium');" class="tableyazi">#get_contact_simple.name# #get_contact_simple.surname#</a>
                                </cfif>					
                            <cfelseif contact_type is "e">
                                #get_contact_simple.name# #get_contact_simple.surname#
                            <cfelseif contact_type is "c">
                                <cfif get_module_user(4)>
                                    <a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#contact_id#" class="tableyazi">#get_contact_simple.name#  #get_contact_simple.surname#</a>
                                <cfelse>
                                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#contact_id#','medium');" class="tableyazi">#get_contact_simple.name# #get_contact_simple.surname#</a>
                                </cfif>
                            </cfif> 
                        </cfoutput>
                    </td>
                </tr>
                <cfif len(get_contact_simple.email)>
                    <tr>
                        <td><cfoutput>#get_contact_simple.email#</cfoutput></td>
                    </tr>
                </cfif>
                <cfif len(get_contact_simple.phone)>
                    <tr>
                        <td><cfoutput>#get_contact_simple.phone_code#  #get_contact_simple.phone#</cfoutput></td>
                    </tr>
                </cfif>
                <cfif contact_type  eq 'comp'>
                    <cfif len(get_contact_simple.COUNTY_NAME) or len(get_contact_simple.CITY_NAME)>
                        <tr>
                            <td>
                                <cfoutput>#get_contact_simple.COUNTY_NAME# - #get_contact_simple.CITY_NAME#</cfoutput>
                            </td>
                        </tr>
                    </cfif>
                    <cfif len(get_contact_simple.SZ_NAME)>
                        <tr>
                            <td>
                                <cfoutput>#get_contact_simple.SZ_NAME#</cfoutput>
                            </td>
                        </tr>
                    </cfif>
                </cfif>
            </cfif>
        </tbody>
    </cf_flat_list>
