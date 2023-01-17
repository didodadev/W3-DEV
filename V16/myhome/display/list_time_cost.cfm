<cfinclude template="../query/get_time_cost.cfm">
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold" height="35"><cf_get_lang dictionary_id='30823.Zaman Yönetimi'></td>
    <td height="35"  class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=myhome.time_cost</cfoutput>"><img src="/images/time.gif" title="<cf_get_lang dictionary_id='31067.Time Cost Ekle'>" border="0"></a> </td>
  </tr>
</table>

      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-header" height="22">
          <td class="form-title" width="30" >&nbsp;<cf_get_lang dictionary_id='57487.No'></td>
          <td class="form-title">&nbsp;<cf_get_lang dictionary_id='57576.Çalışan'></td>
          <td class="form-title">&nbsp;<cf_get_lang dictionary_id='57417.Üyeler'></td>
          <td class="form-title">&nbsp;<cf_get_lang dictionary_id='58445.İş'></td>
          <td class="form-title">&nbsp;CRM</td>
          <td class="form-title"><cf_get_lang dictionary_id='31065.Toplantı'></td>
          <td class="form-title">&nbsp;<cf_get_lang dictionary_id='58235.Masraf Merkezi'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57742.Tarih'></td>
          <td class="form-title"><cf_get_lang dictionary_id='31066.Zaman Aralığı'></td>
        </tr>
        <cfif get_time_cost.recordcount>
          <cfparam name="attributes.page" default=1>
          <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
          <cfparam name="attributes.totalrecords" default="#get_time_cost.RecordCount#">
          <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
          <cfoutput query="get_time_cost" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td height="20">#time_cost_id#</td>
              <td height="20">#EMPLOYEE_NAME#&nbsp;#EMPLOYEE_SURNAME#</td>
              <td>
                <cfif len(employee_id_add)>
                  <cfset attributes.emp_ids = employee_id_add>
                  <cfinclude template="../query/get_employee_name.cfm">
                  <cfif GET_EMPLOYEE_NAME.RECORDCOUNT >
                    <cfloop from="1"  to="#GET_EMPLOYEE_NAME.RECORDCOUNT#" index="i">
                      #GET_EMPLOYEE_NAME.EMPLOYEE_NAME[i]# #GET_EMPLOYEE_NAME.EMPLOYEE_SURNAME[i]#
                      <cfif i neq GET_EMPLOYEE_NAME.RECORDCOUNT>
                        ,
                      </cfif>
                    </cfloop>
                  </cfif>
                </cfif>
                <cfif len(partner_id)>
                  <cfset attributes.comp_par_ids = partner_id>
                  <cfinclude template="../query/get_partner.cfm">
                  #valuelist(get_partner.name)#
                </cfif>
                <cfif len(consumer_id)>
                  <cfset attributes.cons_ids=consumer_id>
                  <cfinclude template="../query/get_consumer.cfm">
                  <cfif get_consumer.RECORDCOUNT>
                    <cfloop from="1" to="#get_consumer.RECORDCOUNT#" index="i">
                      #get_consumer.consumer_name[i]# #get_consumer.consumer_surname[i]#
                      <cfif i neq get_consumer.RECORDCOUNT>
                        ,
                      </cfif>
                    </cfloop>
                  </cfif>
                </cfif>
                <cfif len(group_id)>
                  <cfset attributes.group_ids=group_id>
                  <cfinclude template="../query/get_groups.cfm">
                  #valuelist(get_group.group_name)#
                </cfif>
              </td>
              <td>
                <cfif len(work_id)>
                  <cfinclude template="../query/get_work_name.cfm">
                  #get_work_name.work_head#
                  <cfelse>
                  -
                </cfif>
              </td>
              <td>
                <cfif len(service_id)>
                  <cfinclude template="../query/get_crm_name.cfm">
                  #get_crm_name.service_head#
                  <cfelse>
                  -
                </cfif>
              </td>
              <td>
                <cfif len(event_id)>
                  <cfinclude template="../query/get_event_name.cfm">
                  #get_event_name.event_head#
                  <cfelse>
                  -
                </cfif>
              </td>
              <td>
                <cfif len(expense_id)>
                  <cfinclude template="../query/get_expense_name.cfm">
                  #get_expense_name.expense#
                  <cfelse>
                  -
                </cfif>
              </td>
              <td>#comment#</td>
              <td><cfset tarih=dateformat(event_date,dateformat_style)>
                #tarih#</td>
              <td> #start#:#start_min# / #finish#:#finish_min# </td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr height="20" class="color-row">
            <td colspan="10"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
          </tr>
        </cfif>
      </table>
<cfif attributes.totalrecords gt attributes.maxrows>
<table cellpadding="0" cellspacing="0" border="0" height="25" width="98%" align="center">
  <tr>
	<td width="13%">
	  <cfparam name="attributes.adres" default="myhome.welcome">
	  <cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="myhome.list_time_cost"></td>
	<!-- sil --><td width="87%"  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
  </tr>
</table>
</cfif>
