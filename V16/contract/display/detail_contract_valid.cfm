<cfif isdefined("attributes.contract_id")>
  <cfinclude template="../query/get_det_cont.cfm">
  <table width="590" border="0">
    <tr>
      <td style="text-align:right;" colspan="2">
        <cfinclude template="../query/get_rec_emp.cfm">
        <cfset rec_date=dateadd('h',session.ep.TIME_ZONE,get_det_cont.record_date)>
        <cfoutput>#Dateformat(rec_date,dateformat_style)# #Timeformat(rec_date,timeformat_style)#</cfoutput> <STRONG><cf_get_lang_main no='215.Kayıt Tarihli'></STRONG>
        <!--- Anlaşma Kategorisi --->
        <cfinclude template="../query/get_cat_det.cfm">
        <cfinclude template="../query/get_cat.cfm">
        <cfoutput query="get_cat">
          <cfif #contract_cat_id# eq #get_det_cont.contract_cat_id#>
            #contract_cat#
          </cfif>
        </cfoutput> <STRONG><cf_get_lang no='54.Kategorili Anlaşma'></STRONG>
        <!--- Anlaşma Kategorisi --->
      </td>
    </tr>
  </table>
  <table width="590" border="0">
    <tr>
      <td width="100" class="txtbold"><cf_get_lang no='55.Anlaşma Durumu'>
        </td>
      <td>:
        <cfif #get_det_cont.status# eq "3">
          <cf_get_lang no='60.Gündemde'>
          <cfelse>
          <cf_get_lang no='61.Gündemde Değil'>
        </cfif>
      </td>
    </tr>
    <tr>
      <td width="100" class="txtbold"><cf_get_lang no='56.Anlaşma Başlama Tarihi'>
        </td>
      <td>:
        <cfset START=#GET_DET_CONT.STARTDATE#>
        <cfoutput>#dateformat(start,dateformat_style)#</cfoutput> </td>
    </tr>
    <tr>
      <td class="txtbold"><cf_get_lang no='57.Anlaşma Bitiş Tarihi'></td>
      <td>:
        <cfset FINISH=#GET_DET_CONT.FINISHDATE#>
        <cfoutput>#dateformat(finish,dateformat_style)#</cfoutput></td>
    </tr>
    <tr>
      <td valign="top" class="txtbold"><cf_get_lang no='6.Taraflar'></td>
      <td>
        <!--- Taraflar --->
        <cfset attributes.par_ids=#get_det_cont.company_partner#>
        <cfif len(attributes.par_ids)>
          <cfinclude template="../query/get_company_partner.cfm">
          <cfloop list="#ListSort(get_company_partner.FULLNAME,'text')#" index="i">
            <cfoutput>#i#</cfoutput> <br/>
          </cfloop>
        </cfif>
        <cfset attributes.emp=#get_det_cont.employee#>
        <cfif len(attributes.emp)>
          <cfinclude template="../query/get_emp_det.cfm">
          <cfloop list="#ListSort(FULLNAME,'text')#" index="j">
            <cfoutput>#j#</cfoutput> <br/>
          </cfloop>
        </cfif>
        <cfset attributes.cons=#get_det_cont.consumers#>
        <cfif len(attributes.cons)>
          <cfinclude template="../query/get_consumer_det.cfm">
          <cfloop list="#valuelist(get_consumer_det.FULLNAME)#" index="k">
            <cfoutput>#k#</cfoutput><br/>
          </cfloop>
        </cfif>
        <!--- Taraflar --->
      </td>
    </tr>
    <tr>
      <td class="txtbold" colspan="2">
	  <cf_get_lang_main no='71.Kayıt'> : 
      <cfoutput>#get_rec_emp.employee_name# #get_rec_emp.employee_surname#</cfoutput> </td>
    </tr>
    <tr>
      <td class="txtbold"><cf_get_lang no='59.Başlık (Konu)'></td>
      <td>: <cfoutput>#get_det_cont.contract_head#</cfoutput></td>
    </tr>
  </table>
  <table width="590">
    <tr>
      <td class="headbold"><hr>
      </td>
    </tr>
    <tr>
      <td><cfoutput>#get_det_cont.contract_body#</cfoutput></td>
    </tr>
    <tr>
      <td><hr>
      </td>
    </tr>
  </table>
  <cfinclude template="det_sale_valid.cfm">
  <table width="590">
    <tr>
      <td><hr>
      </td>
    </tr>
  </table>
  <cfinclude template="det_purchase_valid.cfm">
</cfif>

