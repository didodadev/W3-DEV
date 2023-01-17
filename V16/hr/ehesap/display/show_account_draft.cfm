<!--- 
    File: V16\hr\ehesap\display\show_payroll_draft.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2020-11-13
    Description: Taslak Muhasebe - JSON dan değerler okunur ekrana yazdılır.
        
    History:
        
    To Do:
 --->
<cfset payroll_cmp = createObject("component","V16.hr.ehesap.cfc.payroll_job") />
<cfoutput>
    <cfsavecontent variable = "title">
        <cf_get_lang dictionary_id='61719.Taslak muhasebe'>
    </cfsavecontent>
    <cf_box title="#title#" resize="0" closable="1" draggable="1" id="account_budget">
        <cfset get_account_draft = payroll_cmp.PAYROLL_JOB_DRAFT(attributes.employee_payroll_id)>
        <cfset deserialize_draft = deserializeJSON(get_account_draft.ACCOUNT_DRAFT)>
        <cf_flat_list>
            <tbody>
                <cfloop collection=#deserialize_draft# item="key">    
                    <tr>
                        <td class="bold" width="150">
                            #replace(key,"_"," ","all")#
                        </td>
                        <cfset aa = StructCount(deserialize_draft[key])>
                        <cfloop index="i" from="0" to="#aa-1#" >
                            <td class="text-right">
                                #deserialize_draft[key][i]#
                            </td> 
                        </cfloop>
                    </tr>
                </cfloop> 
            </tbody>
        </cf_flat_list>
    </cf_box>
</cfoutput>

