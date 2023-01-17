<cfquery name="GET_ORDER_CURRENCIES" datasource="#dsn3#">
	SELECT
		ORDER_CURRENCY_ID, 
		ORDER_CURRENCY
	FROM
		ORDER_CURRENCY
	ORDER BY
		ORDER_CURRENCY
</cfquery>
<cfset order_currency_list = valuelist(GET_ORDER_CURRENCIES.ORDER_CURRENCY_ID)>
<cfquery name="GET_OFFER_CURRENCIES" datasource="#dsn3#">
	SELECT 
		OFFER_CURRENCY_ID, 
		OFFER_CURRENCY 
	FROM 
		OFFER_CURRENCY
	ORDER BY
		OFFER_CURRENCY
</cfquery>
<cfset offer_currency_list = valuelist(GET_OFFER_CURRENCIES.OFFER_CURRENCY_ID)>
<cfquery name="OUR_COMPANY" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME1,
		ASSET_FILE_NAME1_SERVER_ID
	FROM 
	    OUR_COMPANY 
	WHERE 
	   <cfif isDefined("SESSION.EP.COMPANY_ID")>
		COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = #SESSION.PP.COMPANY#
	</cfif>
</cfquery>
<cfquery name="PROJECT_DETAIL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		PRO_PROJECTS,		
		SETUP_PRIORITY
	WHERE
		PRO_PROJECTS.PROJECT_ID=#attributes.action_id# AND 		
		PRO_PROJECTS.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID 
	ORDER BY 
		PRO_PROJECTS.RECORD_DATE
</cfquery>
<cfquery name="GET_LAST_REC" datasource="#dsn#">
	SELECT
		MAX(HISTORY_ID) AS HIS_ID
	FROM
		PRO_HISTORY
	WHERE
		PROJECT_ID=#attributes.action_id#		
</cfquery>

<cfset hist_id=get_last_rec.HIS_ID>

<cfif LEN(hist_id)>
	<cfquery name="GET_HIST_DETAIL" datasource="#dsn#">
		SELECT
			*
		FROM
			PRO_HISTORY,
			SETUP_PRIORITY
		WHERE
			PRO_HISTORY.PRO_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
			PRO_HISTORY.HISTORY_ID = #HIST_ID#
	</cfquery>
</cfif>
<cfquery name="get_pro_work" datasource="#DSN#">
	SELECT
		*
	FROM
		PRO_WORKS,
		SETUP_PRIORITY
	WHERE
		PRO_WORKS.WORK_PRIORITY_ID=SETUP_PRIORITY.PRIORITY_ID AND
		PRO_WORKS.PROJECT_ID = #ATTRIBUTES.action_id#
	ORDER BY
		PRO_WORKS.TARGET_FINISH ASC	
</cfquery>
<cfif get_pro_work.recordcount>
	<cfquery name="GET_MATERIALS" datasource="#DSN#">
		SELECT
			PRO_MATERIAL_ID,
			WORK_ID,
			NETTOTAL
		FROM
			PRO_MATERIAL
		WHERE
			WORK_ID IN (#valuelist(get_pro_work.work_id)#)
	</cfquery>
</cfif>
<cfquery name="get_content" datasource="#DSN#">
	SELECT  
		PROJECT_ID,
		CONTENT_ID,
		CONT_HEAD,
		CONT_BODY,
		CONT_SUMMARY
	FROM
		 CONTENT
	WHERE 
		PROJECT_ID=#attributes.action_id#
</cfquery>
<!--- <cfquery name="get_relation_content" datasource="#DSN#">
	SELECT  
		CONT_HEAD,
		CONT_BODY
	FROM
		CONTENT,
		PROJECT_CONTENT_RELATION
	WHERE 
		PROJECT_CONTENT_RELATION.PROJECT_ID= #attributes.action_id# AND
		PROJECT_CONTENT_RELATION.CONTENT_ID = CONTENT.CONTENT_ID 
</cfquery> --->
<input type="hidden" name="#notes#" id="#notes#" value="">
<!---ikon ve başlık--->
<table border="0"  cellpadding="1" cellspacing="1" style="width:270mm;" align="center">
	<tr>
		<td height="50" class="headbold"><cf_get_lang no="894.Proje Teklifi"></td>
		<td style="text-align:right;"><cfif len(our_company.asset_file_name1)><cf_get_server_file output_file="settings/#our_company.asset_file_name1#" output_server="#our_company.asset_file_name1_server_id#" output_type="0"></cfif></td>
	</tr>
</table>
<table cellpadding="3" cellspacing="0" border="1" style="width:270mm;" align="center">
	  <td class="txtbold"><cf_get_lang_main no='4.Proje'> </td>
	  <td><cfoutput>#PROJECT_DETAIL.PROJECT_HEAD#</cfoutput></td>
	  <cfif len(PROJECT_DETAIL.AGREEMENT_NO)>
	  <td class="txtbold"><cf_get_lang_main no='1725.SÖZLEŞME NO'></td>
	  <td><cfoutput>#PROJECT_DETAIL.AGREEMENT_NO#</cfoutput></td>
	  </cfif>
	   <td class="txtbold"><cf_get_lang_main no='89.Baslangic'>/<cf_get_lang_main no='288.Bitis Tarihi'>:</td>
	  <td><cfoutput>#dateformat(PROJECT_DETAIL.TARGET_START,dateformat_style)#-#dateformat(PROJECT_DETAIL.TARGET_FINISH,dateformat_style)#</cfoutput></td>
	</tr>
	<tr>
	  <td width="100" class="txtbold" height="20"><cf_get_lang_main no='217.Açıklama'></td>
	  <td colspan="8">
		<cfif len(PROJECT_DETAIL.PROJECT_DETAIL)>
		  <cfoutput>#PROJECT_DETAIL.PROJECT_DETAIL#</cfoutput>
		  <cfelse>
		  &nbsp;
		</cfif>
	  </td>
	</tr>
	 <tr height="20">
	  <td class="txtbold"><cf_get_lang_main no='246.Üye'></td>
	  <td>
		<cfif len(PROJECT_DETAIL.PARTNER_ID)>
			<cfoutput>#GET_PAR_INFO(PROJECT_DETAIL.PARTNER_ID,0,1,0)#</cfoutput>
		<cfelseif len(PROJECT_DETAIL.CONSUMER_ID)>
			<cfoutput>#GET_CONS_INFO(PROJECT_DETAIL.CONSUMER_ID,0,0)#</cfoutput>
		<cfelse>&nbsp;
		</cfif>
	  </td>
		<td class="txtbold"><cf_get_lang no="895.Proje Lideri"></td>
	  <td colspan="3">
		<cfif get_hist_detail.PROJECT_EMP_ID neq 0 and len(get_hist_detail.PROJECT_EMP_ID)>
			<cfoutput>#GET_EMP_INFO(get_hist_detail.PROJECT_EMP_ID,0,0)#</cfoutput>
		</cfif>						
		<cfif (project_detail.OUTSRC_PARTNER_ID NEQ 0) and len(project_detail.OUTSRC_PARTNER_ID)>
			<cfoutput>#GET_PAR_INFO(project_detail.OUTSRC_PARTNER_ID,0,0,0)#</cfoutput>
		</cfif>
	  </td>
</table>
<br/>
	  <!--- İşler --->
<cfset genel_toplam=0>
<cfset sayfa_sayisi=1>
<cfif get_pro_work.recordcount>
<cfoutput query="get_pro_work">
<cfset yerel_toplam=0>
<cfset satir_sayisi=0>
<cfif GET_MATERIALS.recordcount and len(work_id)>
	<cfquery name="GET_MATERIAL" dbtype="query">
		SELECT
			PRO_MATERIAL_ID,
			NETTOTAL
		FROM
			GET_MATERIALS
		WHERE
			WORK_ID IN (#WORK_ID#)
	</cfquery>
	<cfif GET_MATERIAL.recordcount and len(GET_MATERIAL.PRO_MATERIAL_ID)>
		<cfquery name="GET_MATERIAL_ROW" datasource="#DSN#">
			SELECT 
				STOCKS.PRODUCT_ID,
				PRO_MATERIAL_ROW.PRODUCT_NAME,
				STOCKS.PROPERTY,
				PRO_MATERIAL_ROW.AMOUNT,
				PRO_MATERIAL_ROW.UNIT,
				PRO_MATERIAL_ROW.PRICE_OTHER AS PRICE,
				PRO_MATERIAL_ROW.EXTRA_PRICE,
				PRO_MATERIAL_ROW.OTHER_MONEY,
				PRODUCT.PRODUCT_DETAIL2,
				PRODUCT.BRAND_ID
			FROM 	
				PRO_MATERIAL_ROW,
				#dsn3_alias#.STOCKS STOCKS,
				#dsn3_alias#.PRODUCT PRODUCT
			WHERE 
				PRO_MATERIAL_ID IN (#valuelist(GET_MATERIAL.PRO_MATERIAL_ID)#)
				AND STOCKS.STOCK_ID=PRO_MATERIAL_ROW.STOCK_ID
				AND STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
		</cfquery>
		<cfif GET_MATERIAL_ROW.recordcount>
			<cfset brand_list=''>
			<cfloop query="GET_MATERIAL_ROW">
				 <cfif len(brand_id) and not listfind(brand_list,brand_id)>
					 <cfset brand_list=listappend(brand_list,brand_id)>
				 </cfif>
			</cfloop>
			<cfset brand_list=listsort(listdeleteduplicates(brand_list,','),'Numeric','ASC',',')>
			<cfif listlen(brand_list)>
				<cfquery name="GET_BRANDS" datasource="#DSN3#">
					SELECT
						BRAND_NAME,
						BRAND_ID
					FROM 
						PRODUCT_BRANDS
					WHERE
						BRAND_ID IN (#brand_list#)
					ORDER BY
						BRAND_ID
				</cfquery>
			</cfif>
		</cfif>
		<table cellpadding="3" cellspacing="0" border="1" style="width:270mm;" align="center">
			<tr>
				<td nowrap="nowrap" colspan="12" class="txtbold">#currentrow#&nbsp;&nbsp;#WORK_HEAD#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				#dateformat(get_pro_work.TARGET_START,dateformat_style)#-#dateformat(get_pro_work.TARGET_FINISH,dateformat_style)#</td>
			</tr>								
			<tr class="txtbold">
				<td width="20"><cf_get_lang_main no='75.NO'></td>
				<td width="200"><cf_get_lang_main no='245.Ürün'>/<cf_get_lang no="893.Hizmet"></td>
				<td width="200"><cf_get_lang_main no="217.Açıklamalar"></td>
				<td width="100"><cf_get_lang_main no='1435.Marka'></td>
				<td width="100" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></td>
				<td width="120" style="text-align:right;"><cf_get_lang no="889.Malzeme"> <cf_get_lang_main no='226.Birim Fiyat'></td>
				<td width="120" style="text-align:right;"><cf_get_lang no="889.Malzeme"> <cf_get_lang no='1542.Toplam Fiyat'></td>
				<td width="120" style="text-align:right;"><cf_get_lang_main no='372.İşçilik'><cf_get_lang_main no='226.Birim Fiyat'></td>
				<td width="120" style="text-align:right;"><cf_get_lang_main no='372.İşçilik'><cf_get_lang no='1542.Toplam Fiyat'></td>
				<td width="150" style="text-align:right;"><cf_get_lang_main no='226.Birim Fiyat'></td>
				<td width="150" style="text-align:right;"><cf_get_lang no='1542.Toplam Fiyat'></td>
				<td width="150" style="text-align:right;"><cf_get_lang_main no='268.Genel Toplam'></td>
			</tr>
			<tr>
			<cfloop query="GET_MATERIAL_ROW">
				<cfset yerel_toplam=yerel_toplam+(AMOUNT*EXTRA_PRICE+AMOUNT*PRICE)>
					<td>#currentrow#</td>
					<td>#PRODUCT_NAME# #PROPERTY#</td>
					<td><cfif len(product_detail2)>#product_detail2#<cfelse>&nbsp;</cfif></td>
					<td><cfif  listlen(brand_list) and len(GET_BRANDS.BRAND_NAME[listfind(brand_list,brand_id,',')])>#GET_BRANDS.BRAND_NAME[listfind(brand_list,brand_id,',')]#<cfelse>&nbsp;</cfif></td>
					<td style="text-align:right;">#AMOUNT#&nbsp;#UNIT#</td>
					<td style="text-align:right;">#TLFORMAT(PRICE)# #OTHER_MONEY#</td>
					<td style="text-align:right;">#TLFORMAT(AMOUNT*PRICE)# #OTHER_MONEY#</td>
					<td style="text-align:right;">#TLFORMAT(EXTRA_PRICE)# #OTHER_MONEY#</td>
					<td style="text-align:right;">#TLFORMAT(AMOUNT*EXTRA_PRICE)# #OTHER_MONEY#</td>
					<td style="text-align:right;">#TLFORMAT(EXTRA_PRICE+PRICE)# #OTHER_MONEY#</td>
					<td style="text-align:right;">#TLFORMAT(AMOUNT*EXTRA_PRICE+AMOUNT*PRICE)# #OTHER_MONEY#</td>
					<td style="text-align:right;">&nbsp;</td>
				</tr>
				<cfset satir_sayisi=satir_sayisi+1>
				<cfif satir_sayisi eq 15>
					<table style="text-align:right;">
						<tr class="txtbold">
							<td colspan="12" style="text-align:right;"><cf_get_lang_main no='169.Sayfa'>: #sayfa_sayisi#</td>
						</tr>
					</table>
					<cfset sayfa_sayisi=sayfa_sayisi+1>
					</table>
					<br/><br/>
					<div style="page-break-after: always"></div>
					<table cellpadding="3" cellspacing="0" border="1" style="width:270mm;" align="center">
						<tr class="txtbold">
							<td width="20"></td>
							<td width="200"></td>
							<td width="200"></td>
							<td width="100"></td>
							<td width="100" style="text-align:right;"></td>
							<td width="120" style="text-align:right;"></td>
							<td width="120" style="text-align:right;"></td>
							<td width="120" style="text-align:right;"></td>
							<td width="120" style="text-align:right;"></td>
							<td width="150" style="text-align:right;"></td>
							<td width="150" style="text-align:right;"></td>
							<td width="150" style="text-align:right;"></td>
						</tr>
				</cfif>
			</cfloop>
			<tr class="txtbold" >
				<td colspan="11" style="text-align:right;"></td>
				<td style="text-align:right;">#TLFORMAT(yerel_toplam)# #session.ep.money#</td>
			</tr>
			<cfset genel_toplam=genel_toplam+yerel_toplam>
			</cfif>	
			 <cfelse>
				  <cfset GET_MATERIAL.recordcount=0>	
			</cfif>	
		    </tr>
			<cfif GET_MATERIAL.recordcount and len(GET_MATERIAL.PRO_MATERIAL_ID)>
				<cfif currentrow neq recordcount>
					<table style="text-align:right;">
						<tr class="txtbold">
							<td colspan="12" style="text-align:right;"><cf_get_lang_main no='169.Sayfa'>: #sayfa_sayisi#</td>
						</tr>
					</table>
					<cfset sayfa_sayisi=sayfa_sayisi+1>
					</table>
					<br/><br/>
					<div style="page-break-after: always"></div>
				</cfif>
			</cfif>
		</cfoutput>
		<tr class="txtbold">
			<td style="text-align:right;" colspan="10"><cf_get_lang_main no='268.Genel Toplam'>:</td>
			<td style="text-align:right;"><cfoutput>#TLFORMAT(genel_toplam)# #session.ep.money#</cfoutput></td>
		</tr>
		</table>
	</cfif>
<cfoutput>
	<br/><br/>
		<table style="text-align:right;">
			<tr class="txtbold">
				<td colspan="12" style="text-align:right;"><cf_get_lang_main no='169.Sayfa'>: #sayfa_sayisi#</td>
			</tr>
		</table>
	<br/><br/>
</cfoutput>	

