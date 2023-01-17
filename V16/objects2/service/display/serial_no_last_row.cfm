<cfif get_search_results_.recordcount>
	<cfset query_ = "get_search_results_">
<cfelse>
	<cfset query_ = "get_search_results_free">
</cfif>
<cfif isdefined('session.ww.userid') or isdefined('session.pp.userid')>
	<table>
		<cfoutput query="#query_#">
            <tr>
                <td class="formbold"><cf_get_lang_main no='245.Ürün'> : #product_name#-#guaranty_id#</td>
            </tr>
            <tr>
                <td>
                <b><cf_get_lang_main no='305.Garanti'>:</b>
                <cfif is_sale eq 1>
                    <cf_get_lang_main no ='36.Satış'> <cfset attributes.guarantycat_id = sale_guaranty_catid>
                <cfelse>
                    <cf_get_lang_main no='764.Alış'> <cfset attributes.guarantycat_id = purchase_guaranty_catid>
                </cfif>
                <cf_get_lang no ='1474.Garantisi'> - 
                <cfif isdefined("attributes.guarantycat_id") and len(attributes.guarantycat_id)>
                    <cfquery name="GET_GUARANTY_CAT" datasource="#DSN#">
                        SELECT *,(SELECT GUARANTYCAT_TIME FROM SETUP_GUARANTYCAT_TIME WHERE GUARANTYCAT_TIME_ID = SETUP_GUARANTY.GUARANTYCAT_TIME) GUARANTYCAT_TIME_ FROM  SETUP_GUARANTY WHERE GUARANTYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.guarantycat_id#">
                    </cfquery>
                    #get_guaranty_cat.guarantycat# - #get_guaranty_cat.guarantycat_time_# <cf_get_lang_main no='1312.Ay'>
                </cfif>
                </td>
            </tr>
            <tr>
                <td><b><cf_get_lang no='635.Garanti Tarihi'> :</b> #dateformat(get_search_results_free.sale_start_date,'dd/mm/yyyy')# - #dateformat(get_search_results_free.sale_finish_date,'dd/mm/yyyy')#</td>
            </tr> 
            <tr>
                <td><b><cf_get_lang no='116.Kalan Süre'> :</b> <cfset kalan_sure = datediff("d",now(),get_search_results_free.sale_finish_date)>
                <cfif kalan_sure gt 0>#kalan_sure# <cf_get_lang_main no='78.gün'></cfif>
                </td>
            </tr> 
            <tr>
                <td><b><cf_get_lang_main no='1351.Depo'> :</b> #department_head# - <b><cf_get_lang_main no='157.Görevli'> :</b> #employee_name# #employee_surname# - <b><cf_get_lang_main no='388.İşlem Tipi'> :</b> #get_process_name(process_cat)#</td>
            </tr>
            <tr>
                <td><b><cf_get_lang no='618.İlgili Firma'> / <cf_get_lang_main no='2034.Kişi'> :</b> 
                <cfif len(sale_consumer_id)>#get_cons_info(sale_consumer_id,1,0)#
                <cfelseif len(sale_company_id)>#get_par_info(sale_company_id,1,1,0)#
                <cfelseif len(purchase_company_id)>#get_par_info(purchase_company_id,1,1,0)#
                <cfelseif len(purchase_consumer_id)>#get_cons_info(purchase_consumer_id,1,0)#
                </cfif></td>
            </tr>
            <tr>
                <td><b><cf_get_lang no='620.Son Durum'> : 
                <cfif is_purchase eq 1><cf_get_lang no='628.Alındı'>,</cfif>
                <cfif is_sale eq 1><cf_get_lang no='629.Satıldı'>,</cfif>
                <cfif in_out eq 1><cf_get_lang no='631.Satılabilir'>,</cfif>
                <cfif is_return eq 1><cf_get_lang_main no='1621.İade'>,</cfif>
                <cfif is_rma eq 1><cf_get_lang no='632.Üreticide'>,</cfif>
                <cfif is_service eq 1><cf_get_lang no='633.Serviste'>,</cfif>
                <cfif is_trash eq 1><cf_get_lang_main no='1674.Fire'></cfif>
                </b></td>
            </tr>
		</cfoutput>
	</table>
<cfelse>
	<table>
		<cfoutput query="#query_#">
            <tr>
                <td class="formbold"><cf_get_lang_main no='245.Ürün'> : #product_name#-#guaranty_id#</td>
            </tr>
            <tr>
                <td><b><cf_get_lang no='635.Garanti Tarihi'> :</b> #dateformat(get_search_results_free.sale_start_date,'dd/mm/yyyy')# - #dateformat(get_search_results_free.sale_finish_date,'dd/mm/yyyy')#</td>
            </tr> 
            <tr>
                <td><b><cf_get_lang no='116.Kalan Süre'> :</b> <cfset kalan_sure = datediff("d",now(),get_search_results_free.sale_finish_date)>
                <cfif kalan_sure gt 0>#kalan_sure# <cf_get_lang_main no='78.gün'></cfif>
                </td>
            </tr> 
		</cfoutput>
	</table>
</cfif>
