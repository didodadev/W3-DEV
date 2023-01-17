<cfsetting showdebugoutput="no"> 
<cfprocessingdirective suppresswhitespace="yes">
<cfflush interval="3000">
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cf_date tarih="attributes.date1">
<cf_date tarih="attributes.date2">
<cfset date1 = dateformat(attributes.date1,dateformat_style)>
<cfset date2 = dateformat(attributes.date2,dateformat_style)>
<cfquery name="GET_CARD_ID" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		ACTION_DATE,
		BILL_NO,
		CARD_TYPE,
		CARD_TYPE_NO,
		CARD_ID,
	<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- UFRS bazında --->
		TOP_ACCOUNT_IFRS_CODE AS TOP_ACCOUNT_CODE,
		TOP_ACCOUNT_IFRS_NAME AS TOP_ACCOUNT_NAME,
		ACC_IFRS_CODE AS ACCOUNT_ID,
		IFRS_NAME AS ACCOUNT_NAME,
	<cfelse>
		TOP_ACCOUNT_CODE,
		TOP_ACCOUNT_NAME,
		ACCOUNT_ID,
		ACCOUNT_NAME,
	</cfif>
		AMOUNT,
		DETAIL,
		BA
	FROM
		GET_ACCOUNT_CARD_GROUP
	WHERE
		CARD_ID IS NOT NULL
	<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
		AND ACTION_DATE <= #attributes.date2# 
		AND ACTION_DATE >=#attributes.date1#
	</cfif>
	<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
		AND (
		<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
			(CARD_TYPE = #listfirst(type_ii,'-')# AND CARD_CAT_ID = #listlast(type_ii,'-')#)
			<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
		</cfloop>  
			)
	</cfif>				
	ORDER BY
		ACTION_DATE,
		BILL_NO
</cfquery>
<cfif get_card_id.recordcount>	
	<cfset satir_sayisi = 3>
	<cfset index_pdf = 0>
	<cfset filename = "yevmiye_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">	
	<cf_wrk_html_table cellpadding="2" cellspacing="1" width="98%" border="0" table_draw_type="1" filename="#filename#" is_auto_page_break="0" is_auto_sheet_break="0" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
		<cf_wrk_html_tr>
			<cf_wrk_html_td colspan="7" align="center" class="headbold"><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></cf_wrk_html_td>
		</cf_wrk_html_tr>
		<cf_wrk_html_tr>
		  <cf_wrk_html_td nowrap><cf_get_lang dictionary_id='39373.Yevmiye No'></cf_wrk_html_td>
		  <cf_wrk_html_td><cf_get_lang dictionary_id='47299.Hesap Kodu'></cf_wrk_html_td>
		  <cf_wrk_html_td><cf_get_lang dictionary_id='55271.Hesap Adı'></cf_wrk_html_td>
		  <cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
		  <cfif isdefined("attributes.is_detail")>
			  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57771.Detay'></cf_wrk_html_td>		  
		  <cfelse>
			<cf_wrk_html_td></cf_wrk_html_td>
		  </cfif>		  
		  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
		  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
		</cf_wrk_html_tr>
		<cfset satir_sayisi = satir_sayisi + 1>
		<cfoutput query="get_card_id"> 
			<cfswitch expression="#CARD_TYPE#">
				<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
				<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
				<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
				<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
				<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
			</cfswitch>
			<cfif currentrow eq 1 or GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1]>
				<cfset satir_sayisi = satir_sayisi + 2>
				<cf_wrk_html_tr class="tr">
					<cf_wrk_html_td colspan="3">#GET_CARD_ID.BILL_NO#</cf_wrk_html_td>
					<cf_wrk_html_td align="center" colspan="4"></cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cf_wrk_html_tr class="tr">
					<cf_wrk_html_td colspan="3"><cf_get_lang dictionary_id='45271.Fiş Tipi'>:#TYPE#</cf_wrk_html_td>
					<cf_wrk_html_td colspan="4" align="center">____________________________________#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#____________________________________</cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cf_wrk_html_tr>
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
					<cf_wrk_html_tr>
						<cf_wrk_html_td> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)>
						<cf_wrk_html_page_break>		
						<cfif (satir_sayisi gte page_count_)>
							<cf_wrk_html_sheet_break>
							<cfset satir_sayisi = satir_sayisi - page_count_>
						</cfif>	
						<cf_wrk_html_tr>
						  <cf_wrk_html_td nowrap> </cf_wrk_html_td>
						  <cf_wrk_html_td><cf_get_lang dictionary_id='47299.Hesap Kodu'></cf_wrk_html_td>
						  <cf_wrk_html_td><cf_get_lang dictionary_id='55271.Hesap Adı'></cf_wrk_html_td>
						  <cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
						  <cfif isdefined("attributes.is_detail")>
							  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57771.Detay'></cf_wrk_html_td>		  
						  <cfelse>
							<cf_wrk_html_td></cf_wrk_html_td>
						  </cfif>	
						  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
						  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
						</cf_wrk_html_tr>
						<cf_wrk_html_tr>
							<cf_wrk_html_td colspan="5"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
							<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
							<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
						</cf_wrk_html_tr>
						<cfset satir_sayisi = satir_sayisi + 2>
					</cfif> 
				</cfif>
			</cfif>
			<cf_wrk_html_tr>
				<cf_wrk_html_td> </cf_wrk_html_td>
				<cf_wrk_html_td>#TOP_ACCOUNT_CODE#</cf_wrk_html_td>
				<cf_wrk_html_td>#left(TOP_ACCOUNT_NAME,attributes.character_account_code)#</cf_wrk_html_td>
				<cf_wrk_html_td> </cf_wrk_html_td>
				<cf_wrk_html_td align="right"> </cf_wrk_html_td>
				<cf_wrk_html_td align="right"> <cfif BA eq 0>#TLFormat(AMOUNT)#<cfset yevmiye_borc=yevmiye_borc+AMOUNT></cfif></cf_wrk_html_td>
				<cf_wrk_html_td align="right"> <cfif BA eq 1>#TLFormat(AMOUNT)#<cfset yevmiye_alacak = yevmiye_alacak + AMOUNT></cfif></cf_wrk_html_td>
			</cf_wrk_html_tr>
			<cfset satir_sayisi = satir_sayisi + 1> <!--- fis satırının üst hesap bilgileri yazıldı satır sayısı arttırılıyor --->
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
					<cf_wrk_html_tr>
						<cf_wrk_html_td> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
				<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)><!--- (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) kaldırıldı son satırsa bile ust hesap bilgisinden sonra hareket goren alt hesabı yazmalı --->
					<cf_wrk_html_page_break>		
					<cfif (satir_sayisi gte page_count_)>
						<cf_wrk_html_sheet_break>
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>	
					<cf_wrk_html_tr>
						<cf_wrk_html_td nowrap> </cf_wrk_html_td>
						<cf_wrk_html_td><cf_get_lang dictionary_id='47299.Hesap Kodu'></cf_wrk_html_td>
						<cf_wrk_html_td><cf_get_lang dictionary_id='55271.Hesap Adı'></cf_wrk_html_td>
						<cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
					    <cfif isdefined("attributes.is_detail")>
						 	<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57771.Detay'></cf_wrk_html_td>		  
					    <cfelse>
							<cf_wrk_html_td></cf_wrk_html_td>
					    </cfif>	
						<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
						<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cf_wrk_html_tr>
						<cf_wrk_html_td colspan="5"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfset satir_sayisi = satir_sayisi + 2>
				</cfif> 
			</cfif>
			<cf_wrk_html_tr>
				<cf_wrk_html_td> </cf_wrk_html_td>
				<cf_wrk_html_td>#ACCOUNT_ID#</cf_wrk_html_td>
				<cf_wrk_html_td>#left(ACCOUNT_NAME,attributes.character_account_code)#</cf_wrk_html_td>
				<cf_wrk_html_td>#left(DETAIL,attributes.character_detail)#</cf_wrk_html_td>
				  <cfif isdefined("attributes.is_detail")>
						<cf_wrk_html_td align="right"> #TLFormat(AMOUNT)#</cf_wrk_html_td>	  
				  <cfelse>
					<cf_wrk_html_td></cf_wrk_html_td>
				  </cfif>
				<cf_wrk_html_td align="right"> </cf_wrk_html_td>
				<cf_wrk_html_td align="right"> </cf_wrk_html_td>
			</cf_wrk_html_tr>
			<cfset satir_sayisi = satir_sayisi + 1><!--- fis satırı yazıldı,satır_sayisi arttırılıyor --->
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
					<cf_wrk_html_tr>
						<cf_wrk_html_td> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
				<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)>
					<cf_wrk_html_page_break>		
					<cfif (satir_sayisi gte page_count_)>
						<cf_wrk_html_sheet_break>
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>	
					<cf_wrk_html_tr>
					  <cf_wrk_html_td nowrap> </cf_wrk_html_td>
					  <cf_wrk_html_td><cf_get_lang dictionary_id='47299.Hesap Kodu'></cf_wrk_html_td>
					  <cf_wrk_html_td><cf_get_lang dictionary_id='55271.Hesap Adı'></cf_wrk_html_td>
					  <cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
					  <cfif isdefined("attributes.is_detail")>
						  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57771.Detay'></cf_wrk_html_td>		  
					  <cfelse>
						<cf_wrk_html_td></cf_wrk_html_td>
					  </cfif>	
					  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
					  <cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cf_wrk_html_tr class="tr">
						<cf_wrk_html_td colspan="5"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfset satir_sayisi = satir_sayisi + 2>
				</cfif> 
			</cfif>
		</cfoutput> 
	</cf_wrk_html_table> 
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>");
	</script>
</cfif>
<cfsetting enablecfoutputonly="no">
</cfprocessingdirective>

