<cfsetting showdebugoutput="no" requestTimeout ="200">
<cfprocessingdirective suppresswhitespace="yes">
	<cfflush interval="3000">
	<cfset yevmiye_borc=0>
	<cfset yevmiye_alacak=0>
	<cfset page_count_ = 65000>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
	<cfset date1 = dateformat(attributes.date1,dateformat_style)>
	<cfset date2 = dateformat(attributes.date2,dateformat_style)>
	<cfset zip_filename = "#replace(date1,'/','_','all')#_#replace(date2,'/','_','all')#_#dateformat(now(),'YYYYMMDD')#_#timeformat(now(),'HHmmssL')#_#session.ep.userid#_#round(rand()*100)#.zip">
	<cfquery name="GET_CARD_ID" datasource="#dsn2#">
		SELECT 
			ACTION_DATE,
			BILL_NO,
			CARD_TYPE,
			CARD_TYPE_NO,
			CARD_ID,
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- UFRS bazında --->
			ACC_IFRS_CODE AS ACCOUNT_ID,
			IFRS_NAME AS ACCOUNT_NAME,
		<cfelse>
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
	<cfquery name="get_devreden" datasource="#dsn2#">
		SELECT 
			SUM(AMOUNT_TOTAL) AS DEVREDEN_KUMULE,BA
		FROM
			GET_ACCOUNT_CARD_TOTAL_DAILY
		WHERE
			ACTION_DATE < #attributes.date1#
		GROUP BY BA
	</cfquery>
	<cfif GET_CARD_ID.recordcount>
		<cfset index_pdf = 0>
		<cfset satir_sayisi = 0>
		<cfset filename = "yevmiye_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">	
			<cf_wrk_html_table cellpadding="2" cellspacing="1" width="98%" border="0" table_draw_type="1" filename="#filename#" is_auto_page_break="0" is_auto_sheet_break="0" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
				<cf_wrk_html_tr>
					<cf_wrk_html_td colspan="7" align="left" class="txtbold"><cfoutput>#session.ep.company# (#session.ep.period_year#)</cfoutput></cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cf_wrk_html_tr class="tr">
					<cf_wrk_html_td colspan="7" align="center" class="headbold"><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cf_wrk_html_tr>
					<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='39373.YEVMİYE NO'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57742.TARİH'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='44023.HESAP KODU'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='55271.HESAP ADI'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></cf_wrk_html_td>
					<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.BORÇ'></cf_wrk_html_td>
					<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.ALACAK'></cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cfif get_devreden.recordcount and len(get_devreden.DEVREDEN_KUMULE) and index_pdf eq 0><!--- sadece ilk pdf de devreden kumule bakiye gelmeli --->
				<cf_wrk_html_tr>
					<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='39373.YEVMİYE NO'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57742.TARİH'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='44023.HESAP KODU'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='55271.HESAP ADI'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></cf_wrk_html_td>
					<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.BORÇ'></cf_wrk_html_td>
					<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.ALACAK'></cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cfset satir_sayisi = satir_sayisi + 1>
				<cf_wrk_html_tr>
					<cf_wrk_html_td colspan="3"></cf_wrk_html_td>
					<cf_wrk_html_td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57189.Devreden Toplam'></cf_wrk_html_td>
					<cfoutput query="get_devreden">
						<cfif get_devreden.recordcount neq 1>
							<cfif get_devreden.BA eq 0>
								<cf_wrk_html_td align="right"><cfset yevmiye_borc=yevmiye_borc+get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</cf_wrk_html_td>
							<cfelse>
								<cf_wrk_html_td align="right"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</cf_wrk_html_td>
							</cfif>
						<cfelse>
							<cfif get_devreden.BA eq 0>
								<cf_wrk_html_td align="right"><cfset yevmiye_borc=yevmiye_borc+get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</cf_wrk_html_td>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cfif>
							<cfif get_devreden.BA eq 1>
								<cf_wrk_html_td align="right"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</cf_wrk_html_td>
								<cf_wrk_html_td></cf_wrk_html_td>
							</cfif>
						</cfif>
					</cfoutput>
				</cf_wrk_html_tr>
				</cfif>
				<cfif (yevmiye_borc neq 0 or yevmiye_alacak neq 0) and index_pdf neq 0><!--- ilk pdf haricinde bir onceki pdf in bakiyesini alabilmesi icin --->
					<cfset index_pdf = 1>
					<cfoutput>
					<cf_wrk_html_tr>
						<cf_wrk_html_td colspan="3"></cf_wrk_html_td>
						<cf_wrk_html_td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57189.Devreden Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right"><cfif len(yevmiye_borc)>#TLFormat(yevmiye_borc)#</cfif></cf_wrk_html_td>
						<cf_wrk_html_td align="right"><cfif len(yevmiye_alacak)>#TLFormat(yevmiye_alacak)#</cfif></cf_wrk_html_td>
					</cf_wrk_html_tr>
					</cfoutput>
				</cfif>
				<cfset satir_sayisi = satir_sayisi + 2>
				<cfoutput query="GET_CARD_ID"> 
					<cfswitch expression="#CARD_TYPE#">
						<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1></cfcase>
						<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
						<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
						<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
						<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
					</cfswitch>
					<cfif ((satir_sayisi mod pdf_page_row) eq 1)>
							<cf_wrk_html_tr>
								<cf_wrk_html_td colspan="3"></cf_wrk_html_td>
								<cf_wrk_html_td colspan="2" class="txtbold"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)#</cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)#</cf_wrk_html_td>
							</cf_wrk_html_tr>
							<cfset satir_sayisi = satir_sayisi + 1>
						<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)>
							<cf_wrk_html_page_break>		
							<cfif (satir_sayisi gte page_count_)>
								<cf_wrk_html_sheet_break>
								<cfset satir_sayisi = satir_sayisi - page_count_>
							</cfif>	
							<cf_wrk_html_tr>
								<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='39373.YEVMİYE NO'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='57742.TARİH'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='44023.HESAP KODU'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='55271.HESAP ADI'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></cf_wrk_html_td>
								<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.BORÇ'></cf_wrk_html_td>
								<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.ALACAK'></cf_wrk_html_td>
							</cf_wrk_html_tr>
							<cfset satir_sayisi = satir_sayisi + 1>
							<cf_wrk_html_tr>
								<cf_wrk_html_td colspan="3"></cf_wrk_html_td>
								<cf_wrk_html_td colspan="2" class="txtbold"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)#</cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)#</cf_wrk_html_td>
							</cf_wrk_html_tr>
						</cfif> 
					</cfif>
					<cf_wrk_html_tr>
						<cf_wrk_html_td>#GET_CARD_ID.BILL_NO#</cf_wrk_html_td>
						<cf_wrk_html_td>#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#</cf_wrk_html_td>
						<cf_wrk_html_td>#ACCOUNT_ID#</cf_wrk_html_td>
						<cf_wrk_html_td>#left(ACCOUNT_NAME,attributes.character_account_code)# </cf_wrk_html_td>
						<cf_wrk_html_td>#left(DETAIL,attributes.character_detail)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right"><cfif BA eq 0 and len(AMOUNT)><cfset yevmiye_borc=yevmiye_borc+AMOUNT>#TLFormat(AMOUNT)#</cfif></cf_wrk_html_td>
						<cf_wrk_html_td align="right"><cfif BA eq 1 and len(AMOUNT)><cfset yevmiye_alacak = yevmiye_alacak + AMOUNT>#TLFormat(AMOUNT)#</cfif></cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfset satir_sayisi = satir_sayisi + 1><!--- fis satırı yazıldı,satır_sayisi arttırılıyor --->
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
							<cf_wrk_html_tr>
								<cf_wrk_html_td colspan="3"></cf_wrk_html_td>
								<cf_wrk_html_td colspan="2" class="txtbold"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
							</cf_wrk_html_tr>
							<cfset satir_sayisi = satir_sayisi + 1>
						<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)>
							<cf_wrk_html_page_break>		
							<cfif (satir_sayisi gte page_count_)>
								<cf_wrk_html_sheet_break>
								<cfset satir_sayisi = satir_sayisi - page_count_>
							</cfif>	
							<cf_wrk_html_tr>
								<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='39373.YEVMİYE NO'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='57742.TARİH'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='44023.HESAP KODU'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='55271.HESAP ADI'></cf_wrk_html_td>
								<cf_wrk_html_td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></cf_wrk_html_td>
								<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57587.BORÇ'></cf_wrk_html_td>
								<cf_wrk_html_td align="right"><cf_get_lang dictionary_id='57588.ALACAK'></cf_wrk_html_td>
							</cf_wrk_html_tr>
							<cfset satir_sayisi = satir_sayisi + 1>
							<cf_wrk_html_tr class="tr">
								<cf_wrk_html_td colspan="3"> </cf_wrk_html_td>
								<cf_wrk_html_td colspan="2" class="txtbold"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
								<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
							</cf_wrk_html_tr>
						</cfif> 
					</cfif>
				</cfoutput> 
			</cf_wrk_html_table> 
	<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>");
	</script>
</cfif>
</cfprocessingdirective>
</cfsetting>
