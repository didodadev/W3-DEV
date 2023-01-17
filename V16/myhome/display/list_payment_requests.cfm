<cfparam name="attributes.status" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#&status=#attributes.status#">
<cfinclude template="../query/get_payment_lists.cfm">
<cfparam name="attributes.totalrecords" default="#get_requests.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
<cfinclude template="../../objects/display/tree_back.cfm">
<td <cfoutput>#td_back#</cfoutput>>
    </td>
    <td valign="top">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='30826.Avanslar'></td>
          <cfform action="#request.self#?fuseaction=myhome.my_payment_request" method="post"  name="form1">
            <td  style="text-align:right;">
			  <table>
			  <tr>
			  <td>
			  <cf_get_lang dictionary_id='57460.Filtre'> 
				<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255">
				<select name="status" id="status">
                <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>
                <option <cfif attributes.status eq 1 >selected</cfif> value="1"><cf_get_lang dictionary_id='30974.Kabul'></option>
                <option <cfif attributes.status eq 0 >selected</cfif> value="0"><cf_get_lang dictionary_id='29537.Red'></option>
              </select>
			  </td>
			  <td>
			  <cf_wrk_search_button>
			  </td>
			  </tr>
			  </table>
		    </td>
          </cfform>
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
              <tr class="color-header">
                <td height="22" width="60" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='57480.Konu'></td>
                <td width="120"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
				<td class="form-title" width="90"><cf_get_lang dictionary_id='57756.Durum'></td>
                <td class="form-title" width="90"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td width="15">
					<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.form_add_payment_request"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='30827.Avans Talebi Ekle'>"></a>
				</td>
              </tr>
              <cfif get_requests.recordcount>
                <cfif not isdefined("attributes.page")>
                  <cfset attributes.page=1>
                </cfif>
                <cfoutput query="get_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td height="20">#currentrow#</td>
                    <td><a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_payment_request&id=#ID#','small');" >#SUBJECT#</a></td>
                    <td  style="text-align:right;">#TLFormat(AMOUNT)# </td>
					<td><cfif STATUS eq 1><cf_get_lang dictionary_id='58699.Onaylandı'><cfelseif STATUS eq 0><cf_get_lang dictionary_id='29537.Red'><cfelse><cf_get_lang dictionary_id='31112.Bekliyor'></cfif></td>
                    <td>#dateformat(DUEDATE,dateformat_style)#</td>
					<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_payment_request&id=#ID#','small');" ><img src="/images/update_list.gif" border="0"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
	  <table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='31478.Taksitli Avans Taleplerim'></td>
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
              <tr class="color-header">
                <td height="22" width="60" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='57480.Konu'></td>
                <td width="120"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
				 <td class="form-title" width="90"><cf_get_lang dictionary_id='57756.Durum'></td>
                <td class="form-title" width="90"><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td width="15">
					<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.form_add_inst_request"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang dictionary_id='31577.Taksitli Avans Talebi Ekle'>"></a>
				</td>
              </tr>
              <cfif get_other_requests.recordcount>
                <cfoutput query="get_other_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td height="20">#currentrow#</td>
                    <td><a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request&id=#SPGR_ID#','small');" >#DETAIL#</a></td>
                    <td  style="text-align:right;">#TLFormat(AMOUNT_GET)# </td>
					<td><cfif IS_VALID eq 1><cf_get_lang dictionary_id='58699.Onaylandı'><cfelseif IS_VALID eq 0><cf_get_lang dictionary_id='29537.Red'><cfelse><cf_get_lang dictionary_id='31112.Bekliyor'></cfif></td>
                    <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
					<td align="center"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request&id=#SPGR_ID#','small');" ><img src="/images/update_list.gif" border="0"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
		<br/>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='30826.Avans Taleplerim'>:<cf_get_lang dictionary_id='31470.Yedekler'></td>
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
              <tr class="color-header">
                <td height="22" width="60" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='57480.Konu'></td>
                <td width="120"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
				<td class="form-title" width="90"><cf_get_lang dictionary_id='57756.Durum'></td>
                <td class="form-title" width="90"><cf_get_lang dictionary_id='57742.Tarih'></td>
              </tr>
              <cfif get_reserve_requests.recordcount>
                <cfoutput query="get_reserve_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td height="20">#currentrow#</td>
                    <td><a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_payment_request&id=#ID#','small');" >#SUBJECT#</a></td>
                    <td  style="text-align:right;">#TLFormat(AMOUNT)# </td>
					<td><cfif STATUS eq 1><cf_get_lang dictionary_id='58699.Onaylandı'><cfelseif STATUS eq 0><cf_get_lang dictionary_id='29537.Red'><cfelse><cf_get_lang dictionary_id='31112.Bekliyor'></cfif></td>
                    <td>#dateformat(DUEDATE,dateformat_style)#</td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
		<br/>
		<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='31478.Taksitli Avans Taleplerim'>:<cf_get_lang dictionary_id='31470.Yedekler'></td>
        </tr>
      </table>
            <table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
              <tr class="color-header">
                <td height="22" width="60" class="form-title"><cf_get_lang dictionary_id='57487.No'></td>
                <td class="form-title"><cf_get_lang dictionary_id='57480.Konu'></td>
                <td width="120"  class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
				 <td class="form-title" width="90"><cf_get_lang dictionary_id='57756.Durum'></td>
                <td class="form-title" width="90"><cf_get_lang dictionary_id='57742.Tarih'></td>
              </tr>
              <cfif get_reserve_other_requests.recordcount>
                <cfoutput query="get_reserve_other_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td height="20">#currentrow#</td>
                    <td><a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=myhome.popupform_upd_other_payment_request&id=#SPGR_ID#','small');" >#DETAIL#</a></td>
                    <td  style="text-align:right;">#TLFormat(AMOUNT_GET)# </td>
					<td><cfif IS_VALID eq 1><cf_get_lang dictionary_id='58699.Onaylandı'><cfelseif IS_VALID eq 0><cf_get_lang dictionary_id='29537.Red'><cfelse><cf_get_lang dictionary_id='31112.Bekliyor'></cfif></td>
                    <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
		<br/>
    </td>
  </tr>
</table>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
