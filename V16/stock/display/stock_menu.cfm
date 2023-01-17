<cfsavecontent variable="m_dil_1"><cf_get_lang_main no='40.Stok'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang_main no='754.stoklar'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang_main no='2267.Stok hareketleri'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang_main no='116.emirler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang no='273.Stok İşlemleri'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang no='274.Seri ve Lot İşlemleri'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang_main no='1445.Sevkiyat İşlemleri'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang no='197.Stok Maliyet'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang_main no='225.serino'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang no='165.kalite islemleri'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang no='11.Alan Yönetimi'></cfsavecontent>
<!--- Şirket Akış Parametrelerine Bagli Olarak Linkleri Getirir --->
<cfquery name="get_our_comp_info" datasource="#dsn#">
	SELECT IS_SUBSCRIPTION_CONTRACT,IS_GUARANTY_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfif  session.ep.our_company_info.guaranty_followup>
	<cfset add_add_ = "stock.list_serial_operations*0*0*#m_dil_6#">
<cfelse>
	<cfset add_add_ = "">
</cfif>
<cfif (session.ep.admin eq 1 or get_module_power_user(57) ) >
	<cfset add_add1_ = "stock.list_departments*0*0*#m_dil_11#">
<cfelse>
	<cfset add_add1_ = "">
</cfif>
<cfif get_our_comp_info.recordcount and  get_our_comp_info.is_guaranty_followup eq 1>
	<cfset add_add2_ = "objects.serial_no&event=det*1*wide*#m_dil_9#">
<cfelse>
	<cfset add_add2_ = "">
</cfif>
<cfset f_n_action_list = "stock.list_purchase*0*0*#m_dil_1#,stock.list_stock*0*0*#m_dil_2#,stock.list_purchase*0*0*#m_dil_3#,stock.list_command*0*0*#m_dil_4#,stock.list_purchase*2*menu_stock_islem*#m_dil_5#,#add_add_#,stock.list_purchase*2*menu_packetship_islem*#m_dil_7#,stock.list_stock_cost*0*0*#m_dil_8#,#add_add2_#,stock.list_quality_controls*0*0*#m_dil_10#,#add_add1_#">
<cfsavecontent variable="menu_stock_islem_div">
	<div id="menu_stock_islem" class="menus2_show" style="position:absolute; margin-left:-3px; width:125px; line-height:12px; z-index:10; visibility:hidden;" onmouseover="workcube_showHideLayers('menu_stock_islem','','show');" onmouseout="workcube_showHideLayers('menu_stock_islem','','hide');">
	<cfoutput>
	<table border="0" cellspacing="2" cellpadding="2"  width="100%" onmouseover="workcube_showHideLayers('menu_stock_islem','','show');">
	  <cfif not listfindnocase(denied_pages,'stock.form_add_sale')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.form_add_sale';">
			<td><cf_get_lang no='129.Satış İrsaliyesi Ekle'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.form_add_purchase')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.form_add_purchase';">
			<td style="line-height:18px;"><cf_get_lang no='121.Alış İrsaliyesi Ekle'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.add_ship_dispatch')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.add_ship_dispatch';">
			<td style="line-height:18px;"><cf_get_lang no='200.Depolararası Sevk'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.add_stock_in_from_customs')>		
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.add_stock_in_from_customs';">
			<td><cf_get_lang_main no='1791.İthal Mal Girişi'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.form_add_ship_open_fis')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.form_add_ship_open_fis';">
			<td><cf_get_lang no='132.Stok Acilis Fisi Ekle'></td>
		</tr>		
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.add_marketplace_ship') and (SESSION.EP.OUR_COMPANY_INFO.WORKCUBE_SECTOR eq "per")>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.add_marketplace_ship';">
			<td><cf_get_lang_main no='1785.Hal İrsaliyesi'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.form_add_fis')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.form_add_fis';">
			<td><cf_get_lang no='93.Stok Fisi Ekle'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.add_dispatch_internaldemand')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.add_dispatch_internaldemand';">
			<td><cf_get_lang_main no='2268.Sevk Talebi Ekle'></td>
		</tr>		
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.list_group_ships')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.list_group_ships';">
			<td style="line-height:18px;"><cf_get_lang_main no='2272.Grup İçi İrsaliyeler'></td>
		</tr>		
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.list_stock_count')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.list_stock_count';">
			<td><cf_get_lang no='88.Sayımlar'></td>
		</tr>		
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.form_add_stock_exchange')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.form_add_stock_exchange';">
			<td style="line-height:18px;"><cf_get_lang_main no='1412.Stok Virman'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.form_add_spec_exchange')>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.form_add_spec_exchange';">
			<td><cf_get_lang no='375.Spec Virman'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.add_invent_return') and  get_our_comp_info.recordcount and get_our_comp_info.is_subscription_contract eq 1>
		<tr height="18"  style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.add_invent_return';">
			<td><cf_get_lang no='610.Iadeler'></td>
		</tr>
	  </cfif>
	</table>
	</cfoutput>
	</div>
</cfsavecontent>
<cfsavecontent variable="menu_packetship_islem_div">
	<div id="menu_packetship_islem" class="menus2_show" style="position:absolute; width:125px; margin-left:-4px; z-index:10; visibility: hidden;" onmouseover="workcube_showHideLayers('menu_packetship_islem','','show');" onmouseout="workcube_showHideLayers('menu_packetship_islem','','hide');">
	<cfoutput>
	<table border="0" cellspacing="2" cellpadding="2"  width="100%" onmouseover="workcube_showHideLayers('menu_packetship_islem','','show');">
	  <cfif not listfindnocase(denied_pages,'stock.list_packetship')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.list_packetship';">
			<td><cf_get_lang no='313.Sevkiyatlar'></td>
		</tr>
	  </cfif>
	  <cfif not listfindnocase(denied_pages,'stock.list_dispatch_team_planning')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.list_dispatch_team_planning';">
			<td><cf_get_lang no='573.Ekip Planı'></td>
		</tr>
	  </cfif>
	 <cfif not listfindnocase(denied_pages,'stock.list_multi_packetship')>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.list_multi_packetship';">
			<td><cf_get_lang_main no='645.Toplu'> <cf_get_lang no='313.Sevkiyatlar'></td>
		</tr>
	  </cfif>
	  <!--- FBS 20120905 xml customtagden aldigimiz zaman tum stok modulunde bu xml gorundugunden bu sekilde alindi, sevkiyat bilgileri planlama bazinda gorundugunde gelecek sadece  --->
	  <cfquery name="get_multi_packetship_xml" datasource="#dsn#">
	  	SELECT PROPERTY_VALUE FROM FUSEACTION_PROPERTY WHERE PROPERTY_NAME = 'x_equipment_planning_info' AND FUSEACTION_NAME = 'stock.list_command'
	  </cfquery>
	  <cfif not listfindnocase(denied_pages,'stock.list_multi_packetship_complete') and get_multi_packetship_xml.recordcount and get_multi_packetship_xml.property_value eq 1>
		<tr height="18" style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=stock.list_multi_packetship_complete';">
			<td><cf_get_lang no='575.Sevkiyat Sonuçları'></td>
		</tr>
	  </cfif>
	</table>
	</cfoutput>
	</div>
</cfsavecontent>
<cfset menu_module_layer = "stock">
<cfinclude template="../../design/module_menu.cfm">
