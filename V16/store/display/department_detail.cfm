<cfinclude template="../query/get_location.cfm">
<cfset toplam=0>
<cfloop query="get_location">
  <cfif len(width) and len(height) and len(depth)>
	  <cfset alan=width*height*depth>
	  <cfset toplam = toplam+alan> 
  </cfif>
</cfloop>
<cfinclude template="../query/get_department_head.cfm">

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top" width="135"><cfinclude template="../display/dsp_definitions_left_menu">
    </td>
    <td valign="top">
      <table width="97%" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="35" class="headbold"><cfoutput query="get_department_head">#get_department_head.department_head#</cfoutput> <cf_get_lang no='50.Lokasyonları'></td>
          <td class="formbold" style="text-align:right;"> <cf_get_lang no='51.Toplam Alan'>: <cfoutput>#toplam#</cfoutput> m3</td>
        </tr>
        <tr>
      </table>
      <table width="97%" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr class="color-border" >
          <td>
            <table cellpadding="2" cellspacing="1" border="0" width="100%">
              <tr class=color-header height="22">
             <!---    <td class=form-title width="20%">Depo Adı</td> --->
                <td class=form-title width="200"><cf_get_lang no='52.Lokasyon No'></td>
                <td class=form-title><cf_get_lang_main no='217.Açıklama'></td>
                <td class=form-title width="300"><cf_get_lang no='54.Lokasyon Alanı'></td>
				<td align="center" width="15">
				<a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#?fuseaction=store.popup_add_stock_location&department_id=#url.department#</cfoutput>','small');"><img src="/images/plus_square.gif" title="<cf_get_lang no='55.Depo Ekle'>" border="0" align="absmiddle"></a>
				</td>
              </tr>
              <cfif get_location.RecordCount>
                <cfparam name="attributes.page" default=1>
                <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
                <cfparam name="attributes.totalrecords" default="#get_location.RecordCount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfoutput query="get_location" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(width) and len(height) and len(depth)>
						<cfset alan_=width*height*depth>
					<cfelse>
						<cfset alan_=0>
					</cfif>
                  <tr class="color-row" height="20">
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=store.popup_upd_stock_location&id=#get_location.department_location#','small');" class="tableyazi">#get_location.department_location#</a></td>
                    <td>#get_location.comment#</td>
                    <td>#alan_# m3</td>
                   <td align="center">
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=store.popup_upd_stock_location&id=#get_location.department_location#','small');">
					<img src="/images/update_list.gif" title="<cf_get_lang no='56.Depo Güncelle'>" border="0" align="absmiddle">
					</a>
				   </td>
				  </tr>
                </cfoutput>
                <cfelse>
                <tr>
                  <td height="20" class="color-row" colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<br/>
