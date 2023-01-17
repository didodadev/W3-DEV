<!--- 24012021 / Botan Kayğan
      Sözleşme Widget
--->
<cfset cmp = createObject("component","V16.myhome.cfc.my_team")>
<cfset MyDepartmentTeam = cmp.get_position_department(position_code : session.ep.position_code) />
<cfset employee_ids = valuelist(MyDepartmentTeam.employee_id)>
<cfset employee_ids = listAppend(employee_ids,session.ep.userid) />

<!--- Aktif Sözleşmeler --->
<cfset GET_ACTIVE_SECUREFUND = cmp.GET_ACTIVE_SECUREFUND(employee_ids : employee_ids)>

<cfif GET_ACTIVE_SECUREFUND.recordcount>
    <cfquery name="active_securefund_total" dbtype="query">
        SELECT COUNT(SECUREFUND_ID) AS TOTAL_RECORD, SUM(ACTION_VALUE) AS TOTAL1, SUM(ACTION_VALUE2) AS TOTAL2 FROM get_active_securefund
    </cfquery>
</cfif>

<div class="ui-dashboard">
    <div class="ui-dashboard-item ui-dashboard-item__type2">
        <table class="ui-table-list ui-form">
            <tbody>
                <cfoutput>
                    <tr>
                        <td><cf_get_lang dictionary_id='33043.Alınan Teminatlar'></td>
                        <td style="text-align:right"><cfif GET_ACTIVE_SECUREFUND.recordcount>#active_securefund_total.TOTAL_RECORD#<cfelse>0</cfif> <cf_get_lang dictionary_id='58082.Adet'></td>
                        <td style="text-align:right"><cfif GET_ACTIVE_SECUREFUND.recordcount>#TLFormat(active_securefund_total.TOTAL1)#<cfelse>#TLFormat(0)#</cfif> #session.ep.money#</td>
                        <td style="text-align:right"><cfif GET_ACTIVE_SECUREFUND.recordcount>#TLFormat(active_securefund_total.TOTAL2)#<cfelse>#TLFormat(0)#</cfif> #session.ep.money2#</td>
                    </tr>
                </cfoutput>
            </tbody>    
        </table>
    </div>        
</div>