<!--- stok analiz raporu içinde include edilen bir dosyadır.Stok hareketlerinin bağlı olduğu belge bilgileriyle dökümünü sağlar.
Değişiklik yapıldığında stok analiz raporu da kontrol edilmelidir. OZDEN20070223 --->
<cfif isdate(attributes.date)>
	<cf_date tarih = 'attributes.date'>
</cfif>
<cfif isdate(attributes.date2)>
	<cf_date tarih = 'attributes.date2'>
</cfif>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
    SELECT
        DEPARTMENT_ID,
        DEPARTMENT_HEAD
    FROM
        BRANCH B,
        DEPARTMENT D 
    WHERE
        B.COMPANY_ID = #session.ep.company_id# AND
        B.BRANCH_ID = D.BRANCH_ID AND
        D.IS_STORE <> 2 AND
        D.DEPARTMENT_STATUS = 1 AND
        B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
</cfquery>
<cfset branch_dep_list=valuelist(get_department.department_id,',')><!--- Eğer depo seçilmeden çalıştırılırsa yine arka tarafta yetkili olduklarına bakacak --->
<cfquery name="GET_ALL_STOCK_ACTION" datasource="#dsn2#">
	SELECT
		S.STOCK_CODE,
		GSD.STOCK_ID,
		GSD.PRODUCT_ID,
		(S.PRODUCT_NAME +' '+ S.PROPERTY) AS PRODUCT_NAME,
		GSD.GIRIS,
		GSD.CIKIS, 
		GSD.UPD_ID,
		GSD.PROCESS_TYPE,
		GSD.PROCESS_DATE,  
		GSD.ACTION_NUMBER,
		D.DEPARTMENT_HEAD,
		SL.COMMENT
	FROM 
		GET_ALL_STOCK_ACTION_DETAIL AS GSD,
		#dsn3_alias#.STOCKS S,
		#dsn_alias#.DEPARTMENT D,
		#dsn_alias#.STOCKS_LOCATION SL
	WHERE
		GSD.STORE = SL.DEPARTMENT_ID
        AND S.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT_BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM  #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
		AND GSD.STORE_LOCATION = SL.LOCATION_ID
		AND SL.DEPARTMENT_ID=D.DEPARTMENT_ID
		AND GSD.STOCK_ID= S.STOCK_ID
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
				(GSD.STORE = #listfirst(dept_i,'-')# AND GSD.STORE_LOCATION = #listlast(dept_i,'-')#)
				<cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
				</cfloop>  
				)
        <cfelse>
            AND	GSD.STORE IN (#branch_dep_list#)
		</cfif>
		ORDER BY PROCESS_DATE
</cfquery>
<cfif isdate(attributes.date)>
	<cfset attributes.date = dateformat(attributes.date, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
<cfparam name="attributes.totalrecords" default=#GET_ALL_STOCK_ACTION.recordcount#>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" width="98%" align="center">
	<tr class="color-list" height="25"><!--- Filtre seçeneklerini gösteren display bloğu --->
		<td colspan="18">
			<table>
			<tr>
				<td class="txtbold" valign="top"><cf_get_lang_main no='388.İşlem Tipi'></td>
				<td valign="top">
					<cfif len(attributes.process_type) and listfind(attributes.process_type,2)>Alış ve Alış İadeler<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,3)>Satış ve Satış İadeler<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,4)>Üretimden Giriş<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,5)>Sarf ve Fireler<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,6)>Dönem içi Giden Konsinye<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,7)>Dönem İçi İade Gelen Konsinye<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,8)>Teknik Servisten Giren<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,9)>Teknik Servisten Çıkan<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,10)>RMA Çıkış<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,11)>RMA Giriş<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,12)>Sayım Sonuçları<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,13)>Dönem İçi Demontaja Giden<br/></cfif>
					<cfif len(attributes.process_type) and listfind(attributes.process_type,14)>Dönem İçi Demontajdan Giriş<br/></cfif>
				</td>
				<td class="txtbold" valign="top"><cf_get_lang no='159.Depo'></td>
				<td valign="top">
				<cfif len(attributes.department_id)>
					<cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
						<cfquery name="GET_LOCATION" dbtype="query">
							SELECT 
                            	* 
                            FROM 
                            	GET_ALL_LOCATION 
                            WHERE 
                            	DEPARTMENT_ID = #listfirst(dept_i,'-')# AND LOCATION_ID = #listlast(dept_i,'-')#
						</cfquery>
						<cfoutput>#get_location.comment#<br/></cfoutput>			
					</cfloop> 					  
				</cfif>
				</td>
				<cfoutput>
				<td width="15"></td>
				<td valign="top"><cf_get_lang no='155.Rapor Tipi'>:
					<cfif attributes.report_type eq 1>Stok Bazında
					<cfelseif attributes.report_type eq 2>Ürün Bazında
					<cfelseif attributes.report_type eq 3>Kategori Bazında
					<cfelseif attributes.report_type eq 4>Sorumlu Bazında
					<cfelseif attributes.report_type eq 5>Marka Bazında
					<cfelseif attributes.report_type eq 6>Tedarikci Bazında
					<cfelseif attributes.report_type eq 7>Belge Bazında
					</cfif><hr>
					<!--- <cf_get_lang_main no='74.Kategori'>:#attributes.product_cat#<hr>
					Ürün:#attributes.product_name#<hr>
					Tedarikçi:#attributes.sup_company#
				</td>--->
				<td wid th="15"></td>
				<td valign="top">
					<cf_get_lang_main no='330.Tarih'>:#attributes.date#-#attributes.date2#<hr>
					Durum:
					<cfif attributes.product_status eq 0>Pasif
					<cfelseif attributes.product_status eq 1>Aktif
					<cfelse>Tümü
					</cfif>
				</td>
				<td width="15"></td>
				<td class="txtbold" valign="top">Liste Seçenekleri</td>
				<td valign="top">
					<cfif isdefined("attributes.display_cost")>Maliyet Göster<br/></cfif>
					<cfif isdefined("attributes.from_invoice_actions")>Satış Faturası Miktarı-Tutarı<br/></cfif>
					<cfif isdefined("attributes.is_envantory")>Envantere Dahil<br/></cfif>
					<cfif isdefined("attributes.stock_age")>Stok Yaşı<br/></cfif>
					<cfif isdefined("attributes.positive_stock")>Pozitif Stok<br/></cfif>
					<cfif isdefined("attributes.negatif_stock")>Negatif Stok<br/></cfif>
					<cfif isdefined("attributes.is_stock_action")>Hareket Görmeyen Ürünleri Getirme<br/></cfif>
					<cfif isdefined("attributes.is_belognto_institution")>3. Parti Kurumlara Ait Lokasyonlardaki Hareketleri Getir<br/></cfif>
					<cfif isdefined("attributes.display_ds_prod_cost")>Dönem Sonu Birim Maliyet<br/></cfif>
				</td>
				</cfoutput>
			</tr>
		  </table>	
		</td>
	</tr>
	<tr class="color-header" height="20">
		<td class="form-title" align="center" width="120">Stok Kodu</td>
		<td class="form-title" align="center" width="200">Ürün</td>
		<td class="form-title" align="center">Tarih</td>
		<td class="form-title" align="center">Belge No</td>
		<td class="form-title" align="center">İşlem Tipi</td>
		<td class="form-title" align="center">Giriş</td>
		<td class="form-title" align="center">Çıkış</td>
	</tr>
<cfif GET_ALL_STOCK_ACTION.recordcount>
	<cfoutput query="GET_ALL_STOCK_ACTION" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<tr class="color-list">
		<td width="120">#stock_code#</td>
		<td width="200" nowrap="nowrap">#product_name#</td>
		<td>#dateformat(process_date,dateformat_style)#</td>
		<td>
			<cfif listfind('110,111,112,113,114,115,119',process_type)>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_form_upd_fis&upd_id=#upd_id#','medium');" class="tableyazi">#action_number#</a>
			<cfelse>
				#action_number#
			</cfif>
		</td>
		<td>#get_process_name(process_type)#</td>
		<td style="text-align:right;">#giris#</td>
		<td style="text-align:right;">#cikis#</td>
	</tr>
	  </cfoutput>
	 <cfelse>
          <tr class="color-row" height="20">
            <td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
 </cfif>
</table>
