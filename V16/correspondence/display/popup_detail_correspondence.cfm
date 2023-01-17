<cfinclude template="../query/get_det_correspondence.cfm">
<cfset attributes.to_emps=get_det_correspondence.to_emp>
<cfset attributes.to_pars=get_det_correspondence.to_pars>
<cfset attributes.to_cons=get_det_correspondence.to_cons>
<cfset attributes.cc_emps=get_det_correspondence.cc_emp>
<cfset attributes.cc_pars=get_det_correspondence.cc_pars>
<cfset attributes.cc_cons=get_det_correspondence.cc_cons>
<cfif len(get_det_correspondence.cc_emp)>
	<cfinclude template="../query/get_cc_emp.cfm">
</cfif>
<cfif Len(get_det_correspondence.cc_pars)>
	<cfinclude template="../query/get_cc_pars.cfm">
</cfif>
<cfif Len(get_det_correspondence.cc_cons)>
	<cfinclude template="../query/get_cc_cons.cfm">
</cfif> 

<cfif Len(get_det_correspondence.to_emp)>
	<cfinclude template="../query/get_to_emp.cfm">
</cfif>
<cfif Len(get_det_correspondence.to_pars)>
	<cfinclude template="../query/get_to_pars.cfm">
</cfif>
<cfif Len(get_det_correspondence.to_cons)>
	<cfinclude template="../query/get_to_cons.cfm">
</cfif>
<cf_popup_box title="#getLang('correspondence',65)#"><!---Workcube Genel Yazışmalar--->
    <table width="98%">
        <tr>                   
            <td width="100" class="txtbold" valign="baseline" height="22"><cf_get_lang no='66.Kişiler'></td>
            <td  valign="baseline"> 
                <cfoutput>
                <!--- Burada to emp --->
                <cfif Len(get_det_correspondence.to_emp)>
                    <cfloop list="#ListSort(get_to_emp_fullname,'text')#" index="i">
                        #i#,
                    </cfloop>
                </cfif>
                <!--- Burada to pars --->
                <cfif Len(get_det_correspondence.to_pars)>
                    <cfloop list="#ListSort(get_to_pars_fullname,'text')#" index="i">
                        #i#,
                    </cfloop>
                </cfif>
                <!--- Burada to conc --->
                <cfif Len(get_det_correspondence.to_cons)>
                    <cfloop list="#ListSort(get_to_cons_fullname,'text')#" index="i">
                        #i#,
                    </cfloop>
                </cfif>
                <!--- Burada cc emp  --->
                <cfif Len(get_det_correspondence.cc_emp)>
                    <cfloop list="#ListSort(get_cc_emp_fullname,'text')#" index="i">
                        #i#,
                    </cfloop>
                </cfif>
                <!--- Burada cc pars --->
                <cfif Len(get_det_correspondence.cc_pars)>
                    <cfloop list="#ListSort(get_cc_pars_fullname,'text')#" index="i">
                        #i#,
                    </cfloop>
                </cfif>
                <!--- Burada cc cons --->
                <cfif Len(get_det_correspondence.cc_cons)>
                    <cfloop list="#ListSort(get_cc_cons_fullname,'text')#" index="i">
                        #i#,
                    </cfloop>
                </cfif>
                </cfoutput>
            </td>
        </tr>
        <cfif Len(get_det_correspondence.cc_emp) and Len(get_det_correspondence.cc_pars) and Len(get_det_correspondence.cc_cons)>
            <tr> 
                <td width="100" valign="baseline" height="22"><cf_get_lang_main no='144.Bilgi'></td>
                <td  valign="baseline"> 
                    <cfoutput>
                    <!--- burada cc emp --->
                    <cfif Len(get_det_correspondence.cc_emp)>
                        <cfif get_cc_emp.recordcount>
                            <cfloop from="1" to="#get_cc_emp.recordcount#" index="i">
                            <cfif get_cc_emp.recordcount eq i>,</cfif>#get_cc_emp.employee_name#&nbsp;#get_cc_emp.employee_surname#
                            </cfloop> 
                        </cfif>
                    </cfif>
                    <!--- burada cc pars --->
                    <cfif Len(get_det_correspondence.cc_pars)>
                        <cfif get_cc_pars.recordcount>
                            <cfloop from="1" to="#get_cc_pars.recordcount#" index="i">
                                <cfif get_cc_pars.recordcount eq i>,</cfif>#get_cc_pars.company_partner_name#&nbsp;#get_cc_pars.company_partner_surname#
                            </cfloop> 
                        </cfif>
                    </cfif>
                    <!--- burada cc cons --->
                    <cfif Len(get_det_correspondence.cc_cons)>
                        <cfif get_cc_cons.recordcount>
                            <cfloop from="1" to="#get_cc_cons.recordcount#" index="i">
                                <cfif get_cc_cons.recordcount eq i>,</cfif>#get_cc_cons.consumer_name#&nbsp;#get_cc_cons.consumer_surname#
                            </cfloop> 
                        </cfif>
                    </cfif>	
                    </cfoutput>
                </td>
            </tr>
        </cfif>
        <tr> 
            <td class="txtbold" width="100" valign="baseline" height="22"><cf_get_lang_main no='74.Kategori'></td>
            <td  valign="baseline">            
                <cfif get_det_correspondence.category eq 1><cf_get_lang_main no='67.Bilgi Notu'><cfelse><cf_get_lang no='56.Talep'></cfif>
            </td>
        </tr>
        <tr> 
            <td class="txtbold" width="100" valign="baseline" height="22"><cf_get_lang_main no='68.Konu'></td>
            <td valign="baseline"><cfoutput>#get_det_correspondence.subject#</cfoutput></td>
        </tr>
        <tr> 
            <td class="txtbold" width="100" valign="baseline" height="22"><cf_get_lang no='22.Eklenmiş Dosyalar'></td>
            <td valign="baseline">
                <cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#emp_mails/#get_det_correspondence.record_emp#/sendbox/attachments/#get_det_correspondence.attachment_file#','large')">#get_det_correspondence.attachment_file#</a></cfoutput>
                <!---<cfoutput><a href="javascript://" onclick="windowopen('#file_web_path#mails/out/attachments/#GET_DET_CORRESPONDENCE.ATTACHMENT_FILE#','large')">#GET_DET_CORRESPONDENCE.ATTACHMENT_FILE#</a></cfoutput>--->
            </td>
        </tr>				
    </table>                  
    <table width="98%"> 
        <tr> 
            <td  class="txtbold" height="22"><cf_get_lang no='68.Detaylar'></td>
        </tr>
        <tr>
            <td><cfoutput>#get_det_correspondence.message#</cfoutput></td>
        </tr>
    </table>
</cf_popup_box>
