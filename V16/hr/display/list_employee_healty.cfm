<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.employee_id" default="">
<cfinclude template="../ehesap/query/get_emp_healty.cfm">
<cfparam name="attributes.totalrecords" default="#get_healty.recordcount#">
<cfsavecontent variable="txt">
    <cf_get_lang dictionary_id='56345.İşçi Sağlığı'> : <cfif get_healty.recordcount><cfoutput>#get_healty.EMPLOYEE_NAME# #get_healty.EMPLOYEE_SURNAME#</cfoutput><cfelseif isdefined("attributes.employee_id")><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>
</cfsavecontent>
<cf_box title="#txt#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cf_flat_list>
        <thead>
            <tr>
                <th width="75"><cf_get_lang dictionary_id="57880.Belge No"></th>
                <th><cf_get_lang dictionary_id='56621.Muayene Tarihi'></th>
                <th><cf_get_lang dictionary_id='56620.Şikayet Nedeni'></th>
                <th>&nbsp;</th>
                <!--- <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_add_employee_healty&<cfif isdefined("attributes.employee_id")>employee_id=#attributes.employee_id#</cfif></cfoutput>','medium')"><img src="/images/plus_square.gif" border="0"></a></td> --->
            </tr>
        </thead>
        <tbody>	
            <cfif get_healty.recordcount>
                <cfoutput QUERY="get_healty" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#HEALTY_NO#</td>
                    <td>#dateformat(INSPECTION_DATE,dateformat_style)#</td>
                    <td><cfif len(HEALTH_COMPLAINT)>#LEFT(HEALTH_COMPLAINT,100)#</cfif></td>
                    <td width="15"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.list_employee_healty_all&event=upd&healty_id=#healty_id#&employee_id=#employee_id#','page')"><img src="/images/update_list.gif" border="0" align="absmiddle"></a></td> 
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="4">
                        <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
                    </td>
                </tr>
            </cfif>
        </tbody>
    </cf_flat_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
            <tr>
            <td><cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="hr.popup_list_employee_healty&employee_id=#attributes.EMPLOYEE_ID#"> </td>
                <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
            </tr>
        </table>
    </cfif>
</cf_box>