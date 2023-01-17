<!--- stok analiz raporu içinde include edilen bir dosyadır.Stok hareketlerinin bağlı olduğu belge bilgileriyle dökümünü sağlar.
Değişiklik yapıldığında stok analiz raporu da kontrol edilmelidir. OZDEN20070223 --->
<cfif isdate(attributes.date)>
	<cf_date tarih = 'attributes.date'>
</cfif>
<cfif isdate(attributes.date2)>
	<cf_date tarih = 'attributes.date2'>
</cfif>
<cfif isdefined('attributes.process_type_detail')>
    <cfloop list="#attributes.process_type_detail#" index="ind_process_type">
        <cfset process_cat_list = listappend(process_cat_list,listlast(ind_process_type,'-'))>
     </cfloop>
</cfif> 
<cfset process_cat_list = listdeleteduplicates(process_cat_list,',')>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="GET_ALL_STOCK_ACTION" datasource="#dsn2#">
		SELECT
			S.STOCK_CODE,
			S.PRODUCT_CODE,
			GSD.STOCK_ID,
			GSD.PRODUCT_ID,
			(S.PRODUCT_NAME +' '+ S.PROPERTY) AS PRODUCT_NAME,
			GSD.GIRIS,
			GSD.CIKIS, 
			GSD.UPD_ID,
			GSD.PROCESS_TYPE,
			GSD.PROCESS_DATE,  
			GSD.RECORD_DATE,
			GSD.ACTION_NUMBER,
			D.DEPARTMENT_HEAD,
			SL.COMMENT,
			GSD.PROJECT_ID,
            P.ALL_START_COST,
            ISNULL(P.ALL_START_COST_2,0) ALL_START_COST_2
		FROM 
			GET_ALL_STOCK_ACTION_DETAIL AS GSD 
            <cfif get_cost_type.inventory_calc_type eq 3><!--- Ağırlıklı ortalama ise --->
                OUTER APPLY
                (
                    SELECT TOP 1
                    	<cfif isdefined("attributes.display_cost_money")>
                            (PURCHASE_NET_ALL+PURCHASE_EXTRA_COST) AS ALL_START_COST,
                        <cfelse>
                            (PURCHASE_NET_SYSTEM_ALL+PURCHASE_EXTRA_COST_SYSTEM) AS ALL_START_COST,
                        </cfif>	
                        ISNULL((PURCHASE_NET_SYSTEM_2_ALL+PURCHASE_EXTRA_COST_SYSTEM),0) AS ALL_START_COST_2
                    FROM 
                        #dsn3_alias#.PRODUCT_COST WITH (NOLOCK)
                    WHERE 
                        START_DATE <= GSD.PROCESS_DATE
                        AND PRODUCT_ID = GSD.PRODUCT_ID
                    ORDER BY 
                        START_DATE DESC, 
                        RECORD_DATE DESC,
                        PRODUCT_COST_ID DESC
                ) AS P
            <cfelse><!---Fifo ise --->
                OUTER APPLY
                (
                    SELECT TOP 1
                        LAST_COST_PRICE ALL_START_COST,
                        LAST_COST_PRICE/SM.RATE2 ALL_START_COST_2
                    FROM 
                        #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK),
                        #dsn2_alias#.SETUP_MONEY SM
                    WHERE 
                        PROCESS_DATE_OUT <= GSD.PROCESS_DATE
                        AND SM.MONEY = '#session.ep.money2#'
                        AND PRODUCT_ID = GSD.PRODUCT_ID
                    ORDER BY 
                        PROCESS_DATE_OUT DESC, 
                        STOCKS_ROW_CLOSED.RECORD_DATE DESC,
                        STOCKS_ROW_CLOSED_ID DESC
                ) AS P
            </cfif>
            ,
			#dsn3_alias#.STOCKS S,
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.STOCKS_LOCATION SL
		WHERE
			GSD.STORE = SL.DEPARTMENT_ID
			<!---AND PRODUCT_COST.LOCATION_ID = SL.LOCATION_ID
			AND PRODUCT_COST.DEPARTMENT_ID = D.DEPARTMENT_ID--->
			AND GSD.STORE_LOCATION = SL.LOCATION_ID
			AND SL.DEPARTMENT_ID=D.DEPARTMENT_ID
			AND GSD.STOCK_ID= S.STOCK_ID
			<cfif len(trim(attributes.product_cat)) and len(attributes.product_code)>
				AND S.STOCK_CODE LIKE '#attributes.product_code#%'
			</cfif>
			<cfif len(trim(attributes.product_name)) and len(attributes.product_id)>
				AND GSD.PRODUCT_ID = #attributes.product_id#
			</cfif>
			<cfif len(trim(attributes.sup_company)) and len(attributes.sup_company_id)>
				AND S.COMPANY_ID = #attributes.sup_company_id#
			</cfif>
			<cfif len(trim(attributes.employee_name)) and len(attributes.product_employee_id)>
				AND S.PRODUCT_MANAGER = #attributes.product_employee_id#
			</cfif>
			<cfif len(trim(attributes.brand_name)) and len(attributes.brand_id)>
				AND S.BRAND_ID = #attributes.brand_id# 
			</cfif>
			<cfif len(trim(attributes.project_head)) and len(attributes.project_id)>
				AND GSD.PROJECT_ID = #attributes.project_id#
			</cfif>
			<cfif isdate(attributes.date)>
				AND GSD.PROCESS_DATE >= #attributes.date#
			</cfif>
			<cfif isdate(attributes.date2)>
				AND GSD.PROCESS_DATE <= #attributes.date2#
			</cfif>
			<cfif len(attributes.department_id)>
				AND
					(
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
					(
                    GSD.STORE = #listfirst(dept_i,'-')# 
                    <cfif listlen(dept_i,'-') eq 2>
                    	AND GSD.STORE_LOCATION = #listlast(dept_i,'-')#
                    </cfif>
                    )
					<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
					</cfloop>  
					)
			<cfelse>
				AND	GSD.STORE IN (#branch_dep_list#)
			</cfif>
			<cfif isdefined('attributes.is_envantory')>
				AND S.IS_INVENTORY=1
			</cfif>
            <cfif isdefined('process_cat_list') and len(process_cat_list)>
            	AND GSD.PROCESS_TYPE IN (#process_cat_list#)
			</cfif>
			ORDER BY PROCESS_DATE
	</cfquery>
<cfelse>
	<cfset GET_ALL_STOCK_ACTION.recordcount=0>
</cfif>
<cfif isdate(attributes.date)>
	<cfset attributes.date = dateformat(attributes.date, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
<cfparam name="attributes.totalrecords" default="#GET_ALL_STOCK_ACTION.recordcount#">
	<cfif not isdefined("attributes.is_excel")>	
		<tr class="color-list" height="25"><!--- Filtre seçeneklerini gösteren display bloğu --->
			<td colspan="18">
				<tr>
					<td class="txtbold" valign="top"><cf_get_lang dictionary_id='57800.İşlem Tipi'></td>
					<td valign="top">
						<cfif len(attributes.process_type) and listfind(attributes.process_type,2)><cf_get_lang dictionary_id ='39753.Alış ve Alış İadeler'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,3)><cf_get_lang dictionary_id ='39754.Satış ve Satış İadeler'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,4)><cf_get_lang dictionary_id ='39755.Üretimden Giriş'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,5)><cf_get_lang dictionary_id ='39092.Sarf ve Fireler'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,6)><cf_get_lang dictionary_id ='39752.Dönem içi Giden Konsinye'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,7)><cf_get_lang dictionary_id ='39756.Dönem İçi İade Gelen Konsinye'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,8)><cf_get_lang dictionary_id ='39757.Teknik Servisten Giren'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,9)><cf_get_lang dictionary_id ='39758.Teknik Servisten Çıkan'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,10)><cf_get_lang dictionary_id ='39761.RMA Çıkış'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,11)><cf_get_lang dictionary_id ='39762.RMA Giriş'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,12)><cf_get_lang dictionary_id ='39759.Sayım Sonuçları'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,13)><cf_get_lang dictionary_id ='39760.Dönem İçi Demontaja Giden'><br/></cfif>
						<cfif len(attributes.process_type) and listfind(attributes.process_type,14)><cf_get_lang dictionary_id='58436.Dönem İçi Demontajdan Giriş'><br/></cfif>
					</td>
					<td class="txtbold" valign="top"><cf_get_lang dictionary_id='58763.Depo'></td>
					<td valign="top">
					<cfif len(attributes.department_id)>
						<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
							<cfquery name="GET_LOCATION" dbtype="query">
								SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #listfirst(dept_i,'-')# AND LOCATION_ID = #listlast(dept_i,'-')#
							</cfquery>
							<cfoutput>#get_location.comment#<br/></cfoutput>			
						</cfloop> 					  
					</cfif>
					</td>
					<cfoutput>
					<td width="15"></td>
					<td valign="top"><cf_get_lang dictionary_id='58960.Rapor Tipi'>:
						<cfif attributes.report_type eq 1><cf_get_lang dictionary_id ='39054.Stok Bazında'>
						<cfelseif attributes.report_type eq 2><cf_get_lang dictionary_id ='39053.Ürün Bazında'>
						<cfelseif attributes.report_type eq 3><cf_get_lang dictionary_id ='39052.Kategori Bazında'>
						<cfelseif attributes.report_type eq 4><cf_get_lang dictionary_id ='39094.Sorumlu Bazında'>
						<cfelseif attributes.report_type eq 5><cf_get_lang dictionary_id ='39095.Marka Bazında'>
						<cfelseif attributes.report_type eq 6><cf_get_lang dictionary_id ='39764.Tedarikci Bazında'>
						<cfelseif attributes.report_type eq 7><cf_get_lang dictionary_id ='57660.Belge Bazında'>
						</cfif><hr>
						<cf_get_lang dictionary_id='57486.Kategori'>:#attributes.product_cat#<hr>
						<cf_get_lang dictionary_id='57657.Ürün'>:#attributes.product_name#<hr>
						<cf_get_lang dictionary_id='29533.Tedarikçi'>:#attributes.sup_company#
					</td>
					<td width="15"></td>
					<td valign="top">
						<cf_get_lang dictionary_id='57742.Tarih'>:#attributes.date#-#attributes.date2#<hr>
						<cf_get_lang dictionary_id='58448.Ürün Sorumlu'>:#attributes.employee_name#<hr>
						<cf_get_lang dictionary_id='58847.Marka'>:#attributes.brand_name#<hr>
						<cf_get_lang dictionary_id='57756.Durum'>:
						<cfif attributes.product_status eq 0><cf_get_lang dictionary_id ='57494.Pasif'>
						<cfelseif attributes.product_status eq 1><cf_get_lang dictionary_id ='57493.Aktif'>
						<cfelse><cf_get_lang dictionary_id ='57708.Tümü'>
						</cfif>
					</td>
					<td width="15"></td>
					<td class="txtbold" valign="top"><cf_get_lang dictionary_id ='57912.Liste Seçenekleri'></td>
					<td valign="top">
						<cfif isdefined("attributes.display_cost")><cf_get_lang dictionary_id ='39086.Maliyet Göster'><br/></cfif>
						<cfif isdefined("attributes.from_invoice_actions")><cf_get_lang dictionary_id ='39766.Satış Faturası Miktarı-Tutarı'><br/></cfif>
						<cfif isdefined("attributes.is_envantory")><cf_get_lang dictionary_id ='39441.Envantere Dahil'><br/></cfif>
						<cfif isdefined("attributes.stock_age")><cf_get_lang dictionary_id ='39147.Stok Yaşı'><br/></cfif>
						<cfif isdefined("attributes.positive_stock")><cf_get_lang dictionary_id ='39767.Pozitif Stok'><br/></cfif>
						<cfif isdefined("attributes.negatif_stock")><cf_get_lang dictionary_id ='39768.Negatif Stok'><br/></cfif>
						<cfif isdefined("attributes.is_stock_action")><cf_get_lang dictionary_id ='40166.Hareket Görmeyen Ürünleri Getirme'><br/></cfif>
						<cfif isdefined("attributes.is_belognto_institution")>3.<cf_get_lang dictionary_id ='40167.Parti Kurumlara Ait Lokasyonlardaki Hareketleri Getir'><br/></cfif>
						<cfif isdefined("attributes.display_ds_prod_cost")><cf_get_lang dictionary_id ='40168.Dönem Sonu Birim Maliyet'><br/></cfif>
					</td>
					</cfoutput>
				</tr>
				
			</td>
		</tr>
	</cfif>
	<cfif attributes.report_type eq 7><!--- Belge bazında rapor tipi secilmis ise --->
		<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=GET_ALL_STOCK_ACTION.recordcount>
		</cfif>
		<thead>
		<tr height="20">
			<th class="form-title" align="center" width="120"><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
			<th class="form-title" align="center" width="200"><cf_get_lang dictionary_id ='57657.Ürün'></th>
			<th class="form-title" align="center" width="200"><cf_get_lang dictionary_id ='58800.Ürün Kodu'></th>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></th>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='39046.fiili sevk Tarihi'></th>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='57880.Belge No'></th>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></th>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='57554.Giriş'></th>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='57431.Çıkış'></th>
			<cfif x_show_department_in_out>
				<th class="form-title" align="center"><cf_get_lang dictionary_id ='39412.Giriş Depo'></th>
				<th class="form-title" align="center"><cf_get_lang dictionary_id ='29428.Çıkış Depo'></th>
			</cfif>
			<th class="form-title" align="center"><cf_get_lang dictionary_id ='57416.Proje'></th>
			<cfif isdefined('attributes.display_cost')>
				<th class="form-title" nowrap="nowrap" align="right" colspan="2"><cf_get_lang dictionary_id='58906.Stok Maliyeti'></th>
				<cfif isdefined('attributes.is_system_money_2')>
				<th class="form-title" nowrap="nowrap" align="right" colspan="2"><cfoutput>#session.ep.money2#</cfoutput><cf_get_lang dictionary_id='58258.Maliyet'></th>
				</cfif>
			</cfif>
		</tr>
	</thead>
		<cfset project_id_list = ''>
		<cfoutput query="GET_ALL_STOCK_ACTION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(project_id) and not listfind(project_id_list,project_id)>
				<cfset project_id_list = listappend(project_id_list,project_id)>
			</cfif>
		</cfoutput>
		<cfif len(project_id_list)>
			<cfset project_id_list=listsort(project_id_list,"numeric","ASC",",")>
			<cfquery name="get_pro_name" datasource="#dsn#">
				SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
			</cfquery>
			<cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_pro_name.project_id,',')),'numeric','ASC',',')>
		</cfif> 	
		<cfif GET_ALL_STOCK_ACTION.recordcount>
			<cfoutput query="GET_ALL_STOCK_ACTION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr class="color-list">
					<td width="120">#stock_code#</td>
					<td width="200" nowrap="nowrap">#product_name#</td>
					<td width="120">#product_code#</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
					<td>#dateformat(process_date,dateformat_style)#</td>
					<td>
						<cfif listfind('1,2',attributes.is_excel) and not isdefined('attributes.ajax')>
							#action_number#
						<cfelse>
							<cfif listfind('110,111,112,113,114,115,119',process_type)>
								<cfif not listfind('1,2',attributes.is_excel)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#upd_id#','medium');" >#action_number#</a>
								<cfelse>
									#action_number#
								</cfif>
							<cfelseif listfind('73,74,75,76,77,80,84,86,87',process_type)>
								<cfif not listfind('1,2',attributes.is_excel)>
									<a href="#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=#upd_id#">#action_number#</a>
								<cfelse>
									#action_number#
								</cfif>
							<cfelse>
								<cfswitch expression="#process_type#">
									<cfcase value="761">
										<cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
									</cfcase>
									<cfcase value="82">
										<cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
									</cfcase>
									<cfcase value="81">
										<cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
									</cfcase>
									<cfcase value="811">
										<cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
									</cfcase>
									<cfcase value="83">
										<cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
									</cfcase>
									<cfcase value="118">
										<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
									</cfcase>
									<cfcase value="1182">
										<cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
									</cfcase>
									<cfcase value="116">
										<cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
									</cfcase>
									<cfdefaultcase>
										<cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
									</cfdefaultcase>
								</cfswitch>
								<cfif not listfind('1,2',attributes.is_excel)>
									<a href="#url_param##upd_id#" >#action_number#</a>
								<cfelse>
									#action_number#
								</cfif>
							</cfif>
						</cfif>
					</td>
					<td>#get_process_name(process_type)#</td>
					<td align="right" style="text-align:right;" format="numeric">#tlformat(giris,6)#</td>
					<td align="right" style="text-align:right;" format="numeric">#tlformat(cikis,6)#</td>
					<cfif x_show_department_in_out>
						<td><cfif giris gt 0>#DEPARTMENT_HEAD#-#COMMENT#</cfif></td>
						<td><cfif cikis gt 0>#DEPARTMENT_HEAD#-#COMMENT#</cfif></td>
					</cfif>
					<td><cfif len(project_id_list) and len(project_id)>#get_pro_name.project_head[listfind(project_id_list,project_id,',')]#</cfif></td>
					<cfif isdefined('attributes.display_cost')>
						<td nowrap="nowrap" align="right" colspan="2">
							#TLFORMAT(ALL_START_COST,4)#
						</td>
						<cfif isdefined('attributes.is_system_money_2')>
						<td align="right" colspan="2">
							#TLFORMAT(ALL_START_COST_2,4)#
						</td>
						</cfif>
					</cfif>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row" height="20">
				<td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</cfif>

