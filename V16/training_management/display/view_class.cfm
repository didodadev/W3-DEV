<cfinclude template="../query/get_class.cfm">
<cfset attributes.training_id = get_class.training_id>
<cfif LEN(get_class.start_date)>
  <cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
</cfif>
<cfif LEN(get_class.finish_date)>
  <cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
</cfif>

<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
  <tr>
    <td class="headbold"><cf_get_lang_main no='7.Eğitim'>:&nbsp;<cfoutput>#get_class.class_name#</cfoutput></td>
  </tr>
</table>
<table width="650" border="0" align="center">
  <cfif get_class.online eq 1>
    <!--- get_class.INT_OR_EXT eq 1 OR  --->
    <tr>
      <td class="txtbold" width="165"><cf_get_lang no='29.Eğitim Şekli'></td>
      <td width="480">:
        <!--- <cfif get_class.INT_OR_EXT eq 1><cf_get_lang no='168.Dış Eğitim'>,</cfif> --->
        <cfif get_class.online eq 1>
          <cf_get_lang_main no='2218.online'>
        </cfif>
      </td>
    </tr>
  </cfif>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang_main no='74.bölüm'></td>
    <td>:
      <cfset attributes.sec_id = #get_class.training_sec_id#>
      <cfinclude template="../query/get_training_sec_names.cfm">
      <cfoutput>#GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#</cfoutput> </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang_main no='68.konu'></td>
    <td>:
      <cfset attributes.TRAINING_SEC_ID = #get_class.training_sec_id#>
      <cfinclude template="../query/get_trainings.cfm">
      <cfoutput>#GET_TRAININGS.TRAIN_HEAD#</cfoutput> </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang_main no='89.başlama'> - <cf_get_lang_main no='90.bitis'></td>
    <td>:
      <cfif LEN(get_class.finish_date)>
        <cfoutput>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)#</cfoutput>
      </cfif>
      -
      <cfif LEN(get_class.finish_date)>
        <cfoutput> #dateformat(finish_date,dateformat_style)# #timeformat(finish_date,timeformat_style)#</cfoutput>
      </cfif>
    </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='169.Toplam Gün'> - <cf_get_lang_main no='79.Saat'></td>
    <td>: <cfoutput>#get_class.DATE_NO# - #get_class.HOUR_NO#</cfoutput></td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang_main no='7.Eğitim'></td>
    <td>: <cfoutput>#get_class.class_name#</cfoutput> </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='187.Eğitim Yeri'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE#</cfoutput> </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='30.Eğitim Yeri Adresi'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE_ADDRESS#</cfoutput> </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='34.Eğitim Yeri Telefonu'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE_TEL#</cfoutput> </td>
  </tr>
  <tr>
    <td class="txtbold" nowrap><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></td>
    <td>: <cfoutput>#get_class.CLASS_PLACE_MANAGER#</cfoutput> </td>
  </tr>
  <tr>
    <td valign="top" class="txtbold" nowrap><cf_get_lang no='36.Eğitim İçeriği'></td>
    <td>: <cfoutput>#ParagraphFormat(get_class.class_objective)#</cfoutput> </td>
  </tr>
  <tr>
    <td valign="top" class="txtbold"><cf_get_lang_main no='1068.Araç'> - <cf_get_lang no='47.Gereç'></td>
    <td>: <cfoutput>#get_class.class_tools#</cfoutput></td>
  </tr>
</table>

