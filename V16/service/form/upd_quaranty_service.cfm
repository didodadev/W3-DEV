<cfsavecontent variable="text"><cf_get_lang no='18.Garanti Bilgisi'></cfsavecontent>
<cf_box id="get_guaranty_info" title="#text#" closable="0">	
<cfoutput>
<cf_ajax_list>
	<tbody>
		<tr>
			<td class="txtbold">#get_pro_guaranty.product_name#</td>
		</tr>
		<tr>
			<td><b><cf_get_lang_main no='330.Tarih'> :</b> #dateformat(get_pro_guaranty.sale_start_date,dateformat_style)# - #dateformat(get_pro_guaranty.sale_finish_date,dateformat_style)#</td>
		</tr> 
		<cfif len(get_pro_guaranty.sale_finish_date)>
			<tr>
				<td><b><cf_get_lang no='272.Kalan Süre'> :</b> <cfset kalan_sure = datediff("d",now(),get_pro_guaranty.sale_finish_date)>
				<cfif kalan_sure gt 0>#kalan_sure# gün<cfelse>#garanti_bilgisi#</cfif>
				</td>
			</tr> 
		</cfif>
		<tr>
			<td><b><cf_get_lang_main no='1321.Alıcı'> :</b>
			<cfif len(get_pro_guaranty.sale_consumer_id)>#get_cons_info(get_pro_guaranty.sale_consumer_id,1,1)#
			<cfelseif len(get_pro_guaranty.sale_company_id)>#get_par_info(get_pro_guaranty.sale_company_id,1,1,1)#</cfif></td>
		</tr>
	</tbody>
</cf_ajax_list>
</cfoutput>
</cf_box>
