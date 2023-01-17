<cfinclude template="../query/get_location.cfm">
<cfset toplam=0>
<cfloop query="get_location">
  <cfif len(width) and len(height) and len(depth)>
    <cfset alan=width*height*depth>
    <cfset toplam = toplam+alan>
  </cfif>
</cfloop>
<cfinclude template="../query/get_department_head.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#get_location.recordCount#'>
<cfparam name="attributes.totalrecords" default="#get_location.recordCount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
  <cfif not fuseaction contains "popup">
	<td valign="top" width="135"><cfinclude template="../display/dsp_definitions_left_menu">
   	</td>
  </cfif>
  	<td valign="top">
	<table width="98%" align="center" cellpadding="0" cellspacing="0">
	  <tr>
		<td height="35" class="headbold"><cf_get_lang no='44.lokasyon'>: <cfoutput query="get_department_head">#get_department_head.department_head#</cfoutput></td>
        <td align="right" class="formbold" style="text-align:right;"><cf_get_lang no='45.Toplam Alan'>: <cfoutput>#NumberFormat(toplam)#</cfoutput> m3</td>
   	  <cfif fuseaction contains "popup">
     	<td align="right" style="text-align:right;"><a href="javascript://" onclick="self.close();"><img src="/images/close.gif" title="<cf_get_lang_main no='141.Kapat'>" name="A" border="0" align="absmiddle"></a></td>
      </cfif>
	  </tr>
	</table>
    <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
	  <tr class="color-border">
		<td>
		<table cellpadding="2" cellspacing="1" border="0" width="100%">
		  <tr class=color-header height="22">
			<td class="form-title" width="100"><cf_get_lang no='43.Lokasyon Kodu'></td>
			<td class="form-title">Lokasyon</td>
			<td class="form-title" width="302"><cf_get_lang no='46.Lokasyon Alani'></td>
			<td class="form-title" width="50"><cf_get_lang_main no='344.Durum'></td>
			<td width="10"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=stock.popup_add_stock_location&department_id=#url.department#</cfoutput>','medium');"><img src="/images/plus_square.gif" title="Ekle" border="0" align="absmiddle"></a></td>
		  </tr>
		<cfif get_location.recordcount>
		<cfoutput query="get_location" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(width) and len(height) and len(depth)>
		  <cfset alan_=width*height*depth>
		<cfelse>
		  <cfset alan_=0>
		</cfif>
		  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.popup_upd_stock_location&id=#get_location.department_location#','medium');" class="tableyazi">#get_location.department_location#</a></td>
			<td>#get_location.comment#</td>
			<td>#alan_# m3</td>
			<td><cfif status><cf_get_lang_main no='81.Aktif'><cfelse><cf_get_lang_main no='82.Pasif'></cfif></td>
			<td width="10"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.popup_upd_stock_location&id=#get_location.department_location#','medium');"><img src="/images/update_list.gif" border="0" align="absmiddle" title="Güncelle"></a></td>
		  </tr>
		</cfoutput>
		<cfelse>
		  <tr>
			<td height="20" class="color-row" colspan="6"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
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
