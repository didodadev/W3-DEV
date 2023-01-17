<!--- Talepler Tarihce --->
<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
<cfset get_demand_history = cmp.getDemandHistory(demand_id: attributes.demand_id) />
<table width="100%" height="100%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-list">
		<td class="headbold" height="35"><cf_get_lang_main no='61.Tarihçe'></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
        <table border="0" align="left">
   			<cfif get_demand_history.recordcount>
				<cfoutput query="get_demand_history">
					<tr>
						<td colspan="4"><strong><cf_get_lang no="88.Talep">: #demand_head#</strong></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="246.Üye"></td>
						<td>#company_name#</td>
						<td class="txtboldblue"><cf_get_lang_main no="166.Yetkili"></td>
						<td>#partner_name#</td>
					</tr>
					<tr>
						<td class="txtboldblue" width="15%"><cf_get_lang no="81.Talep Türü"></td>
						<td width="30%"><cfif demand_type eq 1><cf_get_lang no="13.Alış Talebi"><cfelse><cf_get_lang no="16.Satış Talebi"></cfif></td>
						<td class="txtboldblue"><cf_get_lang no="6.Yetkilendirme"></td>
						<td width="30%"><cfif order_member_type eq 1><cf_get_lang no="9.Herkese Açık"><cfelse><cf_get_lang no="10.Üyelerime Açık"></cfif></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="70.Aşama"></td>
						<td>#process_stage#</td>
						<td class="txtboldblue"><cf_get_lang_main no="344.Durum"></td>
						<td><cfif is_status eq 1><cf_get_lang_main no="81.Aktif"><cfelse><cf_get_lang_main no="82.Aktif"></cfif></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang no="11.Anahtar Kelime"></td>
						<td>#demand_keyword#</td>
						<td class="txtboldblue"><cf_get_lang no="84.Yayın Tarihi"></td>
						<td>#dateformat(start_date,dateformat_style)#-#dateformat(start_date,dateformat_style)#</td>
					</tr>
					<tr>
						<td class="txtboldblue" valign="top"><cf_get_lang_main no="217.Açıklama"></td>
						<td colspan="3">#detail#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="487.Kaydeden"></td>
						<td colspan="2">
							<cfif len(record_name)>#record_name#-<cfelse>#nickname# - #partner_name#-</cfif>
							<cfset temp_update=date_add('h',session.ep.time_zone,get_demand_history.record_date)>
							#dateformat(temp_update,dateformat_style)# (#timeformat(temp_update,timeformat_style)#)
						</td>
					</tr>
					<tr>
						<td colspan="4"><hr></td>
					</tr>	
				</cfoutput>
				<cfelse>
				   &nbsp;<cf_get_lang_main no ='72.Kayıt Yok'>!
				</cfif>
        </table>
		</td>
	</tr>
 </table>
