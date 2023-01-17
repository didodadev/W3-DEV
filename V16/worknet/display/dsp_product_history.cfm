<!--- Talepler Tarihce --->
<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
<cfset get_product_history = cmp.getProductHistory(product_id: attributes.product_id) />
<table width="100%" height="100%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-list">
		<td class="headbold" height="35"><cf_get_lang_main no='61.Tarihçe'></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
        <table border="0" align="left">
   			<cfif get_product_history.recordcount>
				<cfoutput query="get_product_history">
					<tr>
						<td colspan="4"><strong><cf_get_lang_main no="245.Ürün">: #product_name#</strong></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="246.Üye"></td>
						<td>#company_name#</td>
						<td class="txtboldblue"><cf_get_lang_main no="166.Yetkili"></td>
						<td>#partner_name#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="70.Aşama"></td>
						<td>#process_stage#</td>
						<td class="txtboldblue"><cf_get_lang_main no="344.Durum"></td>
						<td><cfif product_status eq 1><cf_get_lang_main no="81.aktif"><cfelse><cf_get_lang_main no="82.Pasif"></cfif></td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="74.Kategori"></td>
						<td>#category#</td>
						<td class="txtboldblue"><cf_get_lang no="11.Anahtar Kelime"></td>
						<td>#product_keyword#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang_main no="487.Kaydeden"></td>
						<td>
							<cfif len(record_name)>#record_name#-<cfelse>#nickname# - #partner_name#-</cfif>
							<cfset temp_update=date_add('h',session.ep.time_zone,get_product_history.record_date)>
							#dateformat(temp_update,dateformat_style)# (#timeformat(temp_update,timeformat_style)#)
						</td>
						<td colspan="2"></td>
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
