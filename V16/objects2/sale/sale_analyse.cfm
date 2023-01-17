<br/>
<!--- 
attributes.report_type 1 : Kategori Bazında
attributes.report_type 2 : Ürün Bazında
attributes.report_type 9 : Marka Bazında
 --->
<cfinclude template="../login/send_login.cfm">
<cfflush interval="3000">
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.report_sort" default="1">
<cfparam name="attributes.is_kdv" default="0"><!--- 0 net kdv siz --->
<cfparam name="attributes.date1" default="#now()#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.is_prom" default="0"><!--- 0 gosterme 1 goster --->
<cfparam name="attributes.is_other_money" default="0"><!--- 0 gosterme 1 goster --->
<cfparam name="attributes.is_money2" default="0"><!--- 0 gosterme 1 goster --->
<cfparam name="attributes.is_discount" default="0"><!--- iskontolar goster : 0 gosterme, 1 goster --->
<cfif attributes.is_other_money eq 1 and attributes.is_money2 eq 1>
	<cfset attributes.is_money2 = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdate(attributes.date1)>
		<cf_date tarih = "attributes.date1">
	</cfif>
	<cfif isdate(attributes.date2)>
		<cf_date tarih = "attributes.date2">
	</cfif>
	<cfquery name="get_total_purchase_1" datasource="#dsn2#">
		SELECT
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			<cfif attributes.is_kdv eq 0>
				SUM( IR.AMOUNT*IR.PRICE ) GROSSTOTAL,
				SUM( IR.AMOUNT*IR.PRICE / IM.RATE2 ) GROSSTOTAL_DOVIZ,
				SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS PRICE,
				SUM( ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) / IM.RATE2) AS PRICE_DOVIZ,
			<cfelse>
				SUM( IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 ) GROSSTOTAL,
				SUM( IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 / IM.RATE2  ) GROSSTOTAL_DOVIZ,
				SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.GROSSTOTAL ) AS PRICE,
				SUM( ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.GROSSTOTAL ) / IM.RATE2) AS PRICE_DOVIZ,
			</cfif>
			SUM( ( IR.AMOUNT*IR.COST_PRICE ) / IM.RATE2) AS TOTAL_COST_DOVIZ,
			<cfif attributes.is_other_money eq 1>
				IR.OTHER_MONEY,
			</cfif>
		<cfelse>
			<cfif attributes.is_kdv eq 0>
				SUM( IR.AMOUNT*IR.PRICE ) GROSSTOTAL,
				SUM( IR.AMOUNT*IR.PRICE ) GROSSTOTAL_DOVIZ,
				SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) AS PRICE,
			<cfelse>
				SUM( IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 ) GROSSTOTAL,
				SUM( IR.AMOUNT*IR.PRICE*(100+IR.TAX)/100 ) GROSSTOTAL_DOVIZ,
				SUM( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.GROSSTOTAL ) AS PRICE,
			</cfif>
		</cfif>
			SUM( IR.AMOUNT*IR.COST_PRICE ) AS TOTAL_COST,
		<cfif attributes.report_type eq 1 >
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			IR.UNIT AS BIRIM,
			SUM(IR.AMOUNT) AS PRODUCT_STOCK
		<cfelseif attributes.report_type eq 2 >
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.BARCOD,
			SUM(IR.AMOUNT) AS PRODUCT_STOCK,
			IR.UNIT AS BIRIM
		<cfelseif attributes.report_type eq 9 >
			PB.BRAND_NAME,
			P.BRAND_ID,
			SUM(IR.AMOUNT) AS PRODUCT_STOCK
		</cfif>
		FROM
			INVOICE I,
			INVOICE_ROW IR,
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
			INVOICE_MONEY IM,
		</cfif>
			#dsn3_alias#.STOCKS S,
		<cfif listfind('1,2',attributes.report_type)>
			#dsn3_alias#.PRODUCT_CAT PC,
		<cfelseif attributes.report_type eq 9>
			#dsn3_alias#.PRODUCT_BRANDS PB,
		</cfif>
			#dsn3_alias#.PRODUCT P
		WHERE
			I.PURCHASE_SALES = 1 AND
			I.IS_IPTAL = 0 AND
			I.NETTOTAL > 0 AND
		<cfif attributes.is_prom eq 0><!--- promosyon (sadece bedava urun) olarak eklenen satirlar (hem genelden hem satirdan) gelmesin--->
			IR.IS_PROMOTION <> 1 AND
		</cfif>
		<cfif attributes.is_other_money eq 1>
			IM.ACTION_ID = I.INVOICE_ID AND
			IM.MONEY_TYPE = IR.OTHER_MONEY AND
		<cfelseif attributes.is_money2 eq 1>
			IM.ACTION_ID = I.INVOICE_ID AND
			IM.MONEY_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.money2#"> AND
		</cfif>
			I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
			I.INVOICE_CAT  IN (52,53) AND
			I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#"> AND
			I.INVOICE_ID = IR.INVOICE_ID AND
		<cfif listfind('1,2',attributes.report_type)>
			PC.PRODUCT_CATID = P.PRODUCT_CATID AND
		<cfelseif attributes.report_type eq 9>
			P.BRAND_ID = PB.BRAND_ID AND
		</cfif>
			S.PRODUCT_ID = P.PRODUCT_ID AND
			IR.STOCK_ID = S.STOCK_ID
		GROUP BY
		<cfif attributes.is_other_money eq 1>
			IR.OTHER_MONEY,
		</cfif>	
		<cfif attributes.report_type eq 1 >
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			IR.UNIT
		<cfelseif attributes.report_type eq 2 >
			PC.PRODUCT_CAT,
			PC.HIERARCHY,
			PC.PRODUCT_CATID,
			S.PRODUCT_ID,
			P.PRODUCT_NAME,
			P.PRODUCT_CODE,
			P.BARCOD,
			IR.UNIT
		<cfelseif attributes.report_type eq 9 >
			PB.BRAND_NAME,
			P.BRAND_ID
		</cfif>
	</cfquery>
	<cfif isdefined("get_total_purchase_1")>
		<cfquery name="get_total_purchase_3"  dbtype="query" >
			<cfif isdefined("get_total_purchase_1")>
				SELECT * FROM get_total_purchase_1
					<cfif attributes.report_type eq 2 or attributes.report_type eq 3>
						WHERE PRODUCT_STOCK > 0
					</cfif>
			</cfif>
		</cfquery>
	<cfelse>
		<cfset get_total_purchase_3.recordcount=0>
	</cfif>
	<cfif get_total_purchase_3.recordcount>
		<cfquery name="get_total_purchase" dbtype="query">
			SELECT 
				SUM(GROSSTOTAL) GROSSTOTAL,
				SUM(GROSSTOTAL_DOVIZ) GROSSTOTAL_DOVIZ,
				SUM(PRICE) AS PRICE,
				SUM(TOTAL_COST) AS TOTAL_COST,
			<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				SUM(PRICE_DOVIZ) AS PRICE_DOVIZ,
				SUM(TOTAL_COST_DOVIZ) AS TOTAL_COST_DOVIZ,
			</cfif>
			<cfif attributes.report_type eq 1>
				PRODUCT_CAT,
				HIERARCHY,
				BIRIM,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_ID,
				PRODUCT_NAME,
				BARCOD,
				PRODUCT_CODE,
				BIRIM,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			<cfelseif attributes.report_type eq 9 >
				BRAND_NAME,
				BRAND_ID,
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK
			</cfif>		
			FROM 
				get_total_purchase_3
			GROUP BY
			<cfif attributes.is_other_money eq 1>
				OTHER_MONEY,
			</cfif>
			<cfif attributes.report_type eq 1>
				PRODUCT_CAT,
				HIERARCHY,
				BIRIM
			<cfelseif attributes.report_type eq 2>
				PRODUCT_CAT,
				HIERARCHY,
				PRODUCT_ID,
				PRODUCT_NAME,
				PRODUCT_CODE,
				BARCOD,
				BIRIM
			<cfelseif attributes.report_type eq 9 >
				BRAND_NAME,
				BRAND_ID
			</cfif>	
			<cfif attributes.report_sort eq 1>
			ORDER BY 
				PRICE DESC
			<cfelse>
				<cfif attributes.report_type neq 1>
			ORDER BY 
					PRODUCT_STOCK DESC
				</cfif>
			</cfif>
		</cfquery>
		<cfquery name="get_all_total" dbtype="query">
			SELECT SUM(PRICE) AS PRICE FROM get_total_purchase
		</cfquery>
		<cfquery name="get_all_total_2" dbtype="query">
			SELECT SUM(PRODUCT_STOCK) AS PRODUCT_STOCK FROM get_total_purchase
		</cfquery>
		<cfif len(get_all_total_2.PRODUCT_STOCK) >
			<cfset butun_miktar = get_all_total_2.PRODUCT_STOCK >
		<cfelse>
			<cfset butun_miktar = 1 >
		</cfif>
		<cfif len(get_all_total.PRICE) >
			<cfset butun_toplam = get_all_total.PRICE >
		<cfelse>
			<cfset butun_toplam = 1 >
		</cfif>
	<cfelse>
		<cfset get_total_purchase.recordcount=0>
		<cfset butun_toplam = 1 >
	</cfif>
</cfif>
<cfset toplam_satis = 0 >
<cfset toplam_miktar = 0 >
<cfset toplam_brut_doviz = 0 >
<cfset toplam_brut = 0 >
<cfset toplam_doviz= 0 >
<cfset toplam_isk_doviz = 0 >
<cfset toplam_isk_tutar = 0 >
<cfif isdate(attributes.date1)>
	<cfset attributes.date1 = dateformat(attributes.date1, "dd/mm/yyyy")>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, "dd/mm/yyyy")>
</cfif>
<!-- sil -->
<table width="100%" border="0" cellpadding="2" cellspacing="1" align="center" class="color-border">
 <tr>
	<td class="color-row" height="100" valign="top">			
		<table>
		<cfform name="rapor" action="#request.self#?fuseaction=objects2.sale_analyse" method="post">
		<tr>
			<input type="hidden" name="form_submitted" id="form_submitted" value="">
			<td class="txtbold" width="100"><cf_get_lang_main no='162.Şirket'></td>
			<td width="235"><cfoutput>#session.pp.company#</cfoutput></td>
			<td>
				<input type="radio" name="report_sort" id="report_sort" value="1"  <cfif attributes.report_sort eq 1>checked</cfif>><cf_get_lang no='442.Ciro ya Göre'>
				<input type="radio" name="report_sort" id="report_sort" value="2"  <cfif attributes.report_sort eq 2>checked</cfif>><cf_get_lang no='443.Miktar a Göre'>
			</td>
			<td><input name="is_prom" id="is_prom" value="1" type="checkbox" <cfif attributes.is_prom eq 1 >checked</cfif>><cf_get_lang no='448.Bedava Promosyonları Say'> </td>
		</tr>
		<tr>
		  <td class="txtbold"><cf_get_lang_main no='1278.Tarih Aralığı'></td>
		  <td>
				<input value="<cfoutput>#attributes.date1#</cfoutput>" type="text" name="date1" id="date1" style="width:65px;">
				<cf_wrk_date_image date_field="date1"> /
				<input value="<cfoutput>#attributes.date2#</cfoutput>"  type="text" name="date2" id="date2" style="width:65px;" >
				<cf_wrk_date_image date_field="date2">
		  </td>
			<td colspan="2">
				<input name="is_kdv" id="is_kdv" value="1" type="checkbox" <cfif attributes.is_kdv eq 1 >checked</cfif>><cf_get_lang no='142.KDV Dahil'>
				<input name="is_other_money" id="is_other_money" value="1" type="checkbox" <cfif attributes.is_other_money eq 1 >checked</cfif>><cf_get_lang no='444.İşlem Dovizli'> 
				<input name="is_money2" id="is_money2" value="1" type="checkbox" <cfif attributes.is_money2 eq 1 >checked</cfif>><cfoutput>#session.pp.money2#</cfoutput> Göster
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='1548.Rapor Tipi'></td>
			<td>
				<select name="report_type" id="report_type" style="width:180px;">
					<option value="1" <cfif attributes.report_type eq 1>selected</cfif>> <cf_get_lang no='440.Kategori Bazında'></option>
					<option value="2" <cfif attributes.report_type eq 2>selected</cfif>> <cf_get_lang no='441.Ürün Bazında'></option>
					<option value="9" <cfif attributes.report_type eq 9>selected</cfif>> <cf_get_lang no='188.Marka Bazında'></option>
				</select>
			</td>
			<td><input name="is_discount" id="is_discount" value="1" type="checkbox" <cfif attributes.is_discount eq 1>checked</cfif>><cf_get_lang no='445.İskonto Göster'>
				<select name="graph_type" id="graph_type" style="width:100px;">
					<option value="0" selected><cf_get_lang no='438.Grafik Tipi'></option>
					<option value="pie"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'pie'>selected</cfif>>Pasta</option>
					<option value="line"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'line'>selected</cfif>>Eğri</option>
					<option value="bar"<cfif isdefined("attributes.graph_type") and attributes.graph_type is 'bar'>selected</cfif>>Bar</option>
				</select>
			</td>
			<td><cfinput name="maxrows" style="width:30px;" value="#attributes.maxrows#" range="1,250" message="Kayıt Sayısı Hatalı"> <cf_get_lang no='446.Görüntüleme Sayısı'></td>
		</tr>
		<tr>
			<td colspan="4"></td>
			<td><cf_wrk_search_button button_type='1'></td>
		</tr>
		</cfform>
	  </table>
	</td>
 </tr>	
</table>	
<br/>
<cfif isdefined("attributes.form_submitted")>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#get_total_purchase.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<cfif isdefined("attributes.graph_type") and attributes.graph_type neq 0>
<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
	  <cfif attributes.report_type eq 1>
		<tr>
			<td bordercolor="#3399CC"><font color="3366CC"><b><cf_get_lang no='447.Ürün Miktarına Göre'></font></b>
				<cfif get_total_purchase.recordcount>
					<cfif isdefined("form.graph_type") and len(form.graph_type)>
						<cfset graph_type = form.graph_type>
					<cfelse>
						<cfset graph_type = "pie">
					</cfif>
					<cfchart show3d="yes" labelformat="percent" pieslicestyle="solid" format="jpg" chartheight="430" chartwidth="430"> 
					<cfchartseries type="#graph_type#" paintstyle="light"> 
					<cfoutput query="get_total_purchase">
						<cfchartdata item="#Left(PRODUCT_CAT,20)#...(%#wrk_round((PRODUCT_STOCK*100)/butun_miktar)#)" value="#((PRODUCT_STOCK*100)/butun_miktar)/100#">
					</cfoutput> 
					</cfchartseries>
					</cfchart>
				</cfif>
			</td>
			<td bordercolor="#3399CC"><font color="3366CC"><b>Tutara Göre</font></b>
				<cfif get_total_purchase.recordcount>
					<cfif isdefined("form.graph_type") and len(form.graph_type)>
						<cfset graph_type = form.graph_type>
					<cfelse>
						<cfset graph_type = "pie">
					</cfif>
					<cfchart show3d="yes" labelformat="percent" pieslicestyle="solid" format="jpg" chartheight="500" chartwidth="430"> 
					<cfchartseries type="#graph_type#" paintstyle="light"> 
					<cfoutput query="get_total_purchase">
						<cfchartdata item="#left(PRODUCT_CAT,20)#...(%#wrk_round((PRICE*100)/butun_toplam)#)" value="#((PRICE*100)/butun_toplam)/100#">
					</cfoutput> 
					</cfchartseries>
					</cfchart>
				</cfif>
			</td>
		</tr>
	 </cfif>
	 <cfif attributes.report_type eq 2>
		<tr>
			<td bordercolor="#3399CC"><font color="3366CC"><b><cf_get_lang no='447.Ürün Miktarına Göre'></font></b>
				<cfif get_total_purchase.recordcount>
					<cfif isdefined("form.graph_type") and len(form.graph_type)>
						<cfset graph_type = form.graph_type>
					<cfelse>
						<cfset graph_type = "pie">
					</cfif>
					<cfchart show3d="yes" labelformat="percent" pieslicestyle="solid" format="jpg" chartheight="500" chartwidth="430"> 
					<cfchartseries type="#graph_type#" paintstyle="light"> 
					<cfoutput query="get_total_purchase">
						<cfchartdata item="#Left(PRODUCT_NAME,20)#...(%#wrk_round((PRODUCT_STOCK*100)/butun_miktar)#)" value="#((PRODUCT_STOCK*100)/butun_miktar)/100#">
					</cfoutput> 
					</cfchartseries>
					</cfchart>
				</cfif>
			</td>
			<td bordercolor="#3399CC"><font color="3366CC"><b>Tutara Göre</font></b>
				<cfif get_total_purchase.recordcount>
					<cfif isdefined("form.graph_type") and len(form.graph_type)>
						<cfset graph_type = form.graph_type>
					<cfelse>
						<cfset graph_type = "pie">
					</cfif>
					<cfchart show3d="yes" labelformat="percent" pieslicestyle="solid" format="jpg" chartheight="500" chartwidth="430"> 
					<cfchartseries type="#graph_type#" paintstyle="light"> 
					<cfoutput query="get_total_purchase">
						<cfchartdata item="#Left(PRODUCT_NAME,20)#...(%#wrk_round((PRICE*100)/butun_toplam)#)" value="#((PRICE*100)/butun_toplam)/100#">
					</cfoutput> 
					</cfchartseries>
					</cfchart>
				</cfif>
			</td>
		</tr>
	</cfif>
	<cfif attributes.report_type eq 9>
	  <tr>
		<td bordercolor="#3399CC"><font color="3366CC"><b><cf_get_lang no='447.Ürün Miktarına Göre'></font></b>
			<cfif get_total_purchase.recordcount>
				<cfif isdefined("form.graph_type") and len(form.graph_type)>
					<cfset graph_type = form.graph_type>
				<cfelse>
					<cfset graph_type = "pie">
				</cfif>
				<cfchart show3d="yes" labelformat="percent" pieslicestyle="solid" format="jpg" chartheight="500" chartwidth="430"> 
				<cfchartseries type="#graph_type#" paintstyle="light"> 
				<cfoutput query="get_total_purchase">
					<cfchartdata item="#left(BRAND_NAME,20)#...(%#wrk_round((PRODUCT_STOCK*100)/butun_miktar)#)" value="#((PRODUCT_STOCK*100)/butun_miktar)/100#">
				</cfoutput> 
				</cfchartseries>
				</cfchart>
			</cfif>
	    </td>
		<td bordercolor="#3399CC"><font color="3366CC"><b>Tutara Göre</font></b>
			<cfif get_total_purchase.recordcount>
				<cfif isdefined("form.graph_type") and len(form.graph_type)>
						<cfset graph_type = form.graph_type>
				<cfelse>
					<cfset graph_type = "pie">
				</cfif>
				<cfchart show3d="yes" labelformat="percent" pieslicestyle="solid" format="jpg" chartheight="500" chartwidth="430"> 
				<cfchartseries type="#graph_type#" paintstyle="light"> 
				<cfoutput query="get_total_purchase">
					<cfchartdata item="#left(BRAND_NAME,20)#...(%#wrk_round((PRICE*100)/butun_toplam)#)" value="#((PRICE*100)/butun_toplam)/100#">
				</cfoutput> 
				</cfchartseries>
				</cfchart>
			</cfif>
	  </td>	
	 </tr>
	</cfif>
</table><br/>
</cfif>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr class="color-border">
	<td>
		<table width="100%" border="0" cellpadding="0" cellspacing="1" align="center">
		<cfif attributes.page neq 1>
			<cfoutput query="get_total_purchase" startrow="1" maxrows="#attributes.startrow-1#">
				<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>  
				<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>  
				<cfif isdefined("GROSSTOTAL_DOVIZ") and  len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz=GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> 
				<cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> 
				<cfif isdefined("PRICE_DOVIZ") and len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif> 
				<cfif isdefined("GROSSTOTAL_DOVIZ") and  len(GROSSTOTAL_DOVIZ) and isdefined("PRICE_DOVIZ") and len (PRICE_DOVIZ)><cfset toplam_isk_doviz=GROSSTOTAL_DOVIZ-PRICE_DOVIZ+toplam_isk_doviz></cfif> 
				<cfif len(GROSSTOTAL) and len (PRICE)><cfset toplam_isk_tutar=GROSSTOTAL-PRICE+toplam_isk_tutar></cfif> 
			</cfoutput>				  
		</cfif>
		<cfif get_total_purchase.recordcount and attributes.report_type eq 1>
			<tr class="color-header">
				<td class="txtbold">Kategori Kod</td>
				<td class="txtbold" height="22">Kategori</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Miktar</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk. Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Tutar</td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk. Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#HIERARCHY#</td>
				<td>#PRODUCT_CAT#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)# #BIRIM#<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>  </td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif><cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz=GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> </td>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif><cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif> </td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif>
						<cfif len(GROSSTOTAL_DOVIZ) and len (PRICE_DOVIZ)><cfset toplam_isk_doviz=GROSSTOTAL_DOVIZ-PRICE_DOVIZ+toplam_isk_doviz></cfif> 
						</td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.pp.MONEY#<cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> </td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.pp.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#<cfif len(GROSSTOTAL) and len (PRICE)><cfset toplam_isk_tutar=GROSSTOTAL-PRICE+toplam_isk_tutar></cfif> </td>
				</cfif>
				<td align="right" style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		<cfelseif get_total_purchase.recordcount and attributes.report_type eq 2>
			<tr class="color-header" height="22">
				<td class="txtbold">Kategori Kod</td>
				<td class="txtbold">Kategori</td>
				<td class="txtbold">Ürün Kod</td>
				<td class="txtbold">Barkod</td>
				<td class="txtbold">Ürün </td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Miktar</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk. Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Tutar</td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk. Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#HIERARCHY#</td>
				<td>#PRODUCT_CAT#</td>
				<cfif attributes.report_type eq 2>
					<td>#PRODUCT_CODE#</td><td>#BARCOD#</td><td>#PRODUCT_NAME#</td>
				<cfelseif attributes.report_type eq 3>
					<td>#PRODUCT_CODE#</td><td>#BARCOD#</td><td> #PRODUCT_NAME# #PROPERTY#</td>
				</cfif>
				</td>
				<td align="right" style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)# #BIRIM#<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>  </td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif><cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz=GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> </td>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif><cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif> </td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif>
						<cfif len(GROSSTOTAL_DOVIZ) and len (PRICE_DOVIZ)><cfset toplam_isk_doviz=GROSSTOTAL_DOVIZ-PRICE_DOVIZ+toplam_isk_doviz></cfif> 
						</td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.PP.MONEY#<cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> </td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.PP.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#<cfif len(GROSSTOTAL) and len (PRICE)><cfset toplam_isk_tutar=GROSSTOTAL-PRICE+toplam_isk_tutar></cfif> 
				</cfif>
				<td align="right" style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		<cfelseif get_total_purchase.recordcount and attributes.report_type eq 9>
			<tr class="color-header" height="22" >
				<td class="txtbold"><cf_get_lang_main no='1435.Marka'></td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Miktar</td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Brüt Doviz</td>
					<td width="75" align="right" class="txtbold" style="text-align:right;">Doviz</td>
					<cfif attributes.is_discount eq 1>
						<td width="75" align="right" class="txtbold" style="text-align:right;">İsk. Doviz</td>
					</cfif>
				</cfif>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Brüt Tutar</td>
				<td width="100" align="right" class="txtbold" style="text-align:right;">Tutar</td>
				<cfif attributes.is_discount eq 1>
					<td width="75" align="right" class="txtbold" style="text-align:right;">İsk. Tutar</td>
				</cfif>
				<td width="35" align="right" class="txtbold" style="text-align:right;">%</td>
			</tr>  
			<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#BRAND_NAME#</td>
				<td align="right" style="text-align:right;">#TLFormat(PRODUCT_STOCK,4)#<cfif len(PRODUCT_STOCK)><cfset toplam_miktar=PRODUCT_STOCK+toplam_miktar></cfif>  </td>
				<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif><cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz=GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif> </td>
					<td align="right" style="text-align:right;">#TLFormat(PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif><cfif len(PRICE_DOVIZ)><cfset toplam_doviz=PRICE_DOVIZ+toplam_doviz></cfif> </td>
					<cfif attributes.is_discount eq 1>
						<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL_DOVIZ-PRICE_DOVIZ)# <cfif attributes.is_other_money eq 1>#OTHER_MONEY#</cfif>
						<cfif len(GROSSTOTAL_DOVIZ) and len (PRICE_DOVIZ)><cfset toplam_isk_doviz=GROSSTOTAL_DOVIZ-PRICE_DOVIZ+toplam_isk_doviz></cfif> 
						</td>
					</cfif>
				</cfif>
				<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL)# #SESSION.PP.MONEY#<cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif> </td>
				<td align="right" style="text-align:right;">#TLFormat(PRICE)# #SESSION.PP.MONEY#<cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif></td>
				<cfif attributes.is_discount eq 1>
					<td align="right" style="text-align:right;">#TLFormat(GROSSTOTAL-PRICE)# #SESSION.PP.MONEY#<cfif len(GROSSTOTAL) and len (PRICE)><cfset toplam_isk_tutar=GROSSTOTAL-PRICE+toplam_isk_tutar></cfif></td>
				</cfif>
				<td align="right" style="text-align:right;"><cfif butun_toplam neq 0>#Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",",")#</cfif></td>
			</tr>
			</cfoutput>
		</cfif>
			<cfoutput>
			<tr height="20" class="color-list">
				<td colspan="<cfif attributes.report_type eq 1>2<cfelseif attributes.report_type eq 2>5<cfelseif attributes.report_type eq 9>1</cfif>
				" class="txtbold">Toplam</td>
				<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_miktar)#</td>
				<cfif attributes.is_other_money eq 0 and attributes.is_money2 eq 1>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_brut_doviz)# #session.pp.money2#</td>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_doviz)# #session.pp.money2#</td>
				<cfelseif attributes.is_other_money eq 1>
					<td></td><td></td>
				</cfif>
				<cfif attributes.is_discount eq 1> 
					<cfif attributes.is_other_money eq 1>
						<td></td>
					<cfelseif attributes.is_money2 eq 1>
						<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_isk_doviz)# #session.pp.money2#</td>
					</cfif>	
				</cfif>
				<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_brut)# #session.pp.money#</td>
				<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_satis)# #session.pp.money#</td>
				<cfif attributes.is_discount eq 1>
					<td align="right" class="txtbold" style="text-align:right;">#TLFormat(toplam_isk_tutar)# #session.pp.money#</td>
				</cfif>
				<td align="right" class="txtbold" style="text-align:right;"><cfif butun_toplam neq 0>#TLFormat(toplam_satis*100/butun_toplam)#</cfif></td>
			</tr>
			</cfoutput>
		</table>
	</td>
	</tr>
</table>
</cfif>

<cfset adres = "">
<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "objects2.sale_analyse&form_submitted=1">	
	<cfif isDefined("attributes.report_sort") and len(attributes.report_sort)>
		<cfset adres = "#adres#&report_sort=#attributes.report_sort#">
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
	</cfif> 
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cfset adres = "#adres#&company_id=#attributes.company_id#">
	</cfif>
	<cfif isDefined("attributes.company") and len(attributes.company)>
		<cfset adres = "#adres#&company=#attributes.company#">
	</cfif>
	<cfif isDefined("attributes.date1") and len(attributes.date1)>
		<cfset adres = "#adres#&date1=#attributes.date1#">
	</cfif>
	<cfif isDefined("attributes.date2") and len(attributes.date2)>
		<cfset adres = "#adres#&date2=#attributes.date2#">
	</cfif>
	<cfif isDefined("attributes.report_type") and len(attributes.report_type)>
		<cfset adres = "#adres#&report_type=#attributes.report_type#">
	</cfif>
	<cfif isDefined("attributes.is_kdv") and len(attributes.is_kdv)>
		<cfset adres = "#adres#&is_kdv=#attributes.is_kdv#">
	</cfif>
	<cfif isDefined("attributes.is_prom") and len(attributes.is_prom)>
		<cfset adres = "#adres#&is_prom=#attributes.is_prom#">
	</cfif>
	<cfif isDefined("attributes.is_other_money") and len(attributes.is_other_money)>
		<cfset adres = "#adres#&is_other_money=#attributes.is_other_money#">
	</cfif>
	<cfif isDefined("attributes.is_money2") and len(attributes.is_money2)>
		<cfset adres = "#adres#&is_money2=#attributes.is_money2#">
	</cfif>
	<cfif isDefined("attributes.is_grafik") and len(attributes.is_grafik)>
		<cfset adres = "#adres#&is_grafik=#attributes.is_grafik#">
	</cfif>
	<cfif isDefined("attributes.graph_type") and len(attributes.graph_type)>
		<cfset adres = "#adres#&graph_type=#attributes.graph_type#">
	</cfif>
	<cfif isDefined("attributes.is_discount") and len(attributes.is_discount)>
		<cfset adres = "#adres#&is_discount=#attributes.is_discount#">
	</cfif>

	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr>
		<td><cf_pages page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"></td>
		<!-- sil -->
		<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<br/>
<script type="text/javascript">
	function set_the_report()
	{
		rapor.report_type.checked = false;
	}
</script>
