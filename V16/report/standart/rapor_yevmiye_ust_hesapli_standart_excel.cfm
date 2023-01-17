<cfsetting requestTimeout = "2000">
<!--- baslangıc tarihinden onceki donemin devreden bakiye bilgisini içeren, tüm fis satırlarındaki muhasebe hesaplarının üst hesaplar bilgileriyle goruntulendigi  multi pdf oluşturan yevmiye raporu.... OZDEN20070112 --->
<cfprocessingdirective suppresswhitespace="yes">
<cfflush interval="3000">
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cf_date tarih="attributes.date1">
<cf_date tarih="attributes.date2">
<cfset date1 = dateformat(attributes.date1,dateformat_style)>
<cfset date2 = dateformat(attributes.date2,dateformat_style)>
<cfquery name="GET_CARD_ID" datasource="#dsn2#">
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
		BA,
		IS_COMPOUND,
		CARD_ROW_ID
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
		BILL_NO,
		CASE WHEN IS_COMPOUND =1 THEN CARD_ROW_ID ELSE BA END
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
		<cfset satir_sayisi = 4>
		<cfset index_pdf = 0>
		<cfset filename = "yevmiye_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">		
	<cf_wrk_html_table cellpadding="2" cellspacing="1" width="98%" border="0" table_draw_type="1" filename="#filename#" is_auto_page_break="0" is_auto_sheet_break="1" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
		<cf_wrk_html_tr>
			<cf_wrk_html_td colspan="6" align="left" class="txtbold"><cfoutput>#session.ep.company# (#session.ep.period_year#)</cfoutput></cf_wrk_html_td>
		</cf_wrk_html_tr>
		<cf_wrk_html_tr>
		  <cf_wrk_html_td colspan="6" align="center" class="headbold"><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></cf_wrk_html_td>
		</cf_wrk_html_tr>
		<cf_wrk_html_tr>
		  <cf_wrk_html_td style="width:10px;"></cf_wrk_html_td>
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
		<cfif get_devreden.recordcount and len(get_devreden.DEVREDEN_KUMULE) and index_pdf eq 0><!--- sadece ilk pdf de devreden kumule bakiye gelmeli --->
		<cf_wrk_html_tr>
			<cf_wrk_html_td></cf_wrk_html_td>
			<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='57189.Devreden Toplam'></cf_wrk_html_td>
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
						<cf_wrk_html_td> </cf_wrk_html_td>
					</cfif>
					<cfif get_devreden.BA eq 1>
						<cf_wrk_html_td align="right"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</cf_wrk_html_td>
						<cf_wrk_html_td> </cf_wrk_html_td>
					</cfif>
				</cfif>
			</cfoutput>
		</cf_wrk_html_tr>
		<cfset satir_sayisi = satir_sayisi + 1>
		</cfif>
		<cfif (yevmiye_borc neq 0 or yevmiye_alacak neq 0) and index_pdf neq 0><!--- ilk pdf haricinde bir onceki pdf in bakiyesini alabilmesi icin --->
			<cfset index_pdf = 1>
			<cfoutput>
				<cf_wrk_html_tr>
					<cf_wrk_html_td> </cf_wrk_html_td>
					<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='57189.Devreden Toplam'></cf_wrk_html_td>
					<cf_wrk_html_td align="right"><cfif len(yevmiye_borc)>#TLFormat(yevmiye_borc)#</cfif></cf_wrk_html_td>
					<cf_wrk_html_td align="right"><cfif len(yevmiye_alacak)>#TLFormat(yevmiye_alacak)#</cfif></cf_wrk_html_td>
				</cf_wrk_html_tr>
			</cfoutput>
		</cfif>
		<cfoutput query="GET_CARD_ID"> 
			<cfset TYPE_NO=GET_CARD_ID.CARD_TYPE_NO>
			<cfswitch expression="#CARD_TYPE#">
				<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
				<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
				<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
				<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
				<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
			</cfswitch>
			<cfif currentrow eq 1 or GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1]>
					<cf_wrk_html_tr class="tr">
						<cf_wrk_html_td colspan="3"><cf_get_lang dictionary_id='39373.YEVMİYE NO'>: #GET_CARD_ID.BILL_NO#</cf_wrk_html_td>
						<cf_wrk_html_td align="center" colspan="4"></cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cf_wrk_html_tr class="tr">
						<cf_wrk_html_td colspan="3">#TYPE# <cf_get_lang dictionary_id='57946.FİŞ NO'>: #TYPE_NO#</cf_wrk_html_td>
						<cf_wrk_html_td colspan="4" align="center">____________________________________#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#____________________________________</cf_wrk_html_td>
					</cf_wrk_html_tr>
				<cf_wrk_html_tr>
				<cfset satir_sayisi = satir_sayisi + 2>
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
					<cf_wrk_html_tr>
						<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></cf_wrk_html_td>
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
						<cfif x_show_head_all_page eq 1>
						<cf_wrk_html_tr>
						  <cf_wrk_html_td colspan="6" align="center" class="headbold"><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></cf_wrk_html_td>
						</cf_wrk_html_tr>
						</cfif>
						<cf_wrk_html_tr>
						  <cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
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
							<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
							<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
							<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
							<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
						</cf_wrk_html_tr>
						<cfset satir_sayisi = satir_sayisi + 4>
					</cfif> 
				</cfif>
			</cfif>
			<cf_wrk_html_tr>
				<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
				<cf_wrk_html_td>#TOP_ACCOUNT_CODE#</cf_wrk_html_td>
				<cf_wrk_html_td>#left(TOP_ACCOUNT_NAME,attributes.character_account_code)#</cf_wrk_html_td>
				<cf_wrk_html_td align="right"> </cf_wrk_html_td>
				<cf_wrk_html_td align="right"> </cf_wrk_html_td>
				<cf_wrk_html_td align="right"> <cfif BA eq 0 and len(AMOUNT)><cfset yevmiye_borc=yevmiye_borc+AMOUNT>#TLFormat(AMOUNT)#</cfif></cf_wrk_html_td>
				<cf_wrk_html_td align="right"> <cfif BA eq 1 and len(AMOUNT)><cfset yevmiye_alacak = yevmiye_alacak + AMOUNT>#TLFormat(AMOUNT)#</cfif></cf_wrk_html_td>
			</cf_wrk_html_tr>
			<cfset satir_sayisi = satir_sayisi + 1> <!--- fis satırının üst hesap bilgileri yazıldı satır sayısı arttırılıyor --->
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2)>
					<cf_wrk_html_tr class="tr">
						<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
				<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)>
					<cf_wrk_html_page_break>		
					<cfif (satir_sayisi gte page_count_)>
						<cf_wrk_html_sheet_break>
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>	
					<cfif x_show_head_all_page eq 1>
					<cf_wrk_html_tr>
					  <cf_wrk_html_td colspan="6" align="center" class="headbold"><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></cf_wrk_html_td>
					</cf_wrk_html_tr>
					</cfif>
					<cf_wrk_html_tr>
					  <cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
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
						<cf_wrk_html_td style="width:10px;"></cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)#</cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)#</cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfset satir_sayisi = satir_sayisi + 4>
				</cfif> 
			</cfif>
			<cfif x_detail_info_shorting eq 1>
				<cfset New_Detail = Replace(detail,'Tic.','','all')>
				<cfset New_Detail = Replace(New_Detail,'Şti.','','all')>
				<cfset New_Detail = Replace(New_Detail,'Ltd.','','all')>
				<cfset New_Detail = Replace(New_Detail,'Aş.','','all')>
				<cfset New_Detail = Replace(New_Detail,'TOPTAN SATIŞ FATURASI GİRİŞ İŞLEMİ','Sat. Fat.','all')>
				<cfset New_Detail = Replace(New_Detail,'İŞLEMİ','','all')>
				<cfif Right(detail,6) eq 'FATURA'>
					<cfset New_Detail = Replace(New_Detail,'FATURA','Fat.','all')>
					<cfif ListLen(New_Detail,'-') gt 2>
						<cfset Cari_ = Left(ListFirst(New_Detail,'-'),10)>
						<cfset Fatura_ = Replace(New_Detail,'Fat.','','all')>
						<cfset Fatura_ = ListGetAt(Fatura_,ListLen(Fatura_,'-')-1,'-') & '-' & ListLast(Fatura_,'-')>
						<cfset Tip_ = 'Fat.'>
						<cfset New_Detail = Cari_ & ' ' & Fatura_ & ' ' & Tip_>
					<cfelse>
						<cfset Cari_ = Left(ListFirst(New_Detail,'-'),10)>
						<cfset Fatura_ = Replace(New_Detail,'Fat.','','all')>
						<cfset Fatura_ = ListLast(Fatura_,'-')>
						<cfset Tip_ = 'Fat.'>
						<cfset New_Detail = Cari_ & ' ' & Fatura_ & ' ' & Tip_>
					</cfif>
				<cfelseif ListFind(New_Detail,"No'lu",' ')>
					<cfset Fatura_ = ListFirst(New_Detail,"No'lu")>
					<cfset Cari_ = Replace(Replace(Replace(New_Detail,Fatura_,''),"No'lu",''),'Sat. Fat.','')>
					<cfset Tip_ = 'Sat. Fat.'>
					<cfset Cari_ = Left(Cari_,10)>
					<cfset New_Detail = Cari_ & ' ' & Fatura_ & ' ' & Tip_>
				</cfif>
				<cfset Detail_ = Left(New_Detail,30)>
			<cfelse>
				<cfset Detail_ = Left(Detail,attributes.character_detail)>
			</cfif>
			<cf_wrk_html_tr>
				<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
				<cf_wrk_html_td>#ACCOUNT_ID#</cf_wrk_html_td>
				<cf_wrk_html_td>#left(ACCOUNT_NAME,attributes.character_account_code)#</cf_wrk_html_td>
				<cf_wrk_html_td>#Detail_#</cf_wrk_html_td>
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
						<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
				<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount)>
					<cf_wrk_html_page_break>		
					<cfif (satir_sayisi gte page_count_)>
						<cf_wrk_html_sheet_break>
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>	
					<cfif x_show_head_all_page eq 1>
						<cf_wrk_html_tr class="th">
						  <cf_wrk_html_td colspan="6" align="center" class="headbold"><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></cf_wrk_html_td>
						</cf_wrk_html_tr>
					</cfif>
					<cf_wrk_html_tr>
					  <cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
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
						<cf_wrk_html_td style="width:10px;"> </cf_wrk_html_td>
						<cf_wrk_html_td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_borc)# </cf_wrk_html_td>
						<cf_wrk_html_td align="right">#TLFormat(yevmiye_alacak)# </cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cfset satir_sayisi = satir_sayisi + 4>
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

