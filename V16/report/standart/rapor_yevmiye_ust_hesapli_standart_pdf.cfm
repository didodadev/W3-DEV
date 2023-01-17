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
<cfset zip_filename = "#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#.zip">
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
        ACCOUNT_ID,
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
	<cfset new_control = 0>
	<!--- Daha Once Kullanilan ve Isi Biten Klasorler Temizleniyor --->
    <!--- file --->
	<cfif DirectoryExists("#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#")>
    	<cfdirectory action="delete" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#" recurse="yes">
  	</cfif>
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#">
	<!--- zip file --->
	<cfif DirectoryExists("#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip")>
		<cfdirectory  action="delete" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip" recurse="yes">
	</cfif>
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip">
	<!--- //Daha Once Kullanilan ve Isi Biten Klasorler Temizleniyor --->
	<cfset pdf_sayisi=ceiling(GET_CARD_ID.recordcount/pdf_row_count)-1> 
	<cfloop from="0" to="#pdf_sayisi#" index="index_pdf">
		<cfset temp_pdf_row = (index_pdf+1)*pdf_row_count>
		<cfset satir_sayisi = 4>
		<cfset filename = "#index_pdf#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
		<cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="0" marginright="0" margintop="0" marginbottom="0"><!--- pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" #ListFirst(attributes.pagetype,';')# --->
		<cfoutput>
		<style type="text/css">
			.th{font-size:#attributes.fontsize#; font-family:#attributes.fontfamily#; font-weight:bold;}
			.tr{font-size:#attributes.fontsize#; font-family:#attributes.fontfamily#; font-style:normal;}
		</style>
		</cfoutput>
		<table cellpadding="2" cellspacing="1" width="98%" border="0">
		<tr class="tr" valign="top">
			<td colspan="7" align="left"><cfoutput>#session.ep.company# (#session.ep.period_year#)</cfoutput></td>
		</tr>
		<tr class="th">
		  <td colspan="7" align="center"><big><big><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></big></big></td>
		</tr>
		<tr class="tr">
		  <td style="width:20px;">&nbsp;</td>
		  <td><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
		  <td><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
		  <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
		  <cfif isdefined("attributes.is_detail")>
			  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57771.Detay'></td>		  
		  <cfelse>
		  	<td></td>
		  </cfif>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
		</tr>
		<cfset satir_sayisi = satir_sayisi + 1>
		<cfif get_devreden.recordcount and len(get_devreden.DEVREDEN_KUMULE) and index_pdf eq 0><!--- sadece ilk pdf de devreden kumule bakiye gelmeli --->
		<tr class="tr">
			<td>&nbsp;</td>
			<td colspan="4"><cf_get_lang dictionary_id='57189.Devreden Toplam'></td>
			<cfoutput query="get_devreden">
				<cfif get_devreden.recordcount neq 1>
					<cfif get_devreden.BA eq 0>
						<td align="right" style="text-align:right;"><cfset yevmiye_borc=yevmiye_borc+get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
					<cfelse>
						<td align="right" style="text-align:right;"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
					</cfif>
				<cfelse>
					<cfif get_devreden.BA eq 0>
						<td align="right" style="text-align:right;"><cfset yevmiye_borc=yevmiye_borc+get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
						<td>&nbsp;</td>
					</cfif>
					<cfif get_devreden.BA eq 1>
						<td align="right" style="text-align:right;"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
						<td>&nbsp;</td>
					</cfif>
				</cfif>
			</cfoutput>
		</tr>
		<cfset satir_sayisi = satir_sayisi + 1>
		</cfif>
		<cfif (yevmiye_borc neq 0 or yevmiye_alacak neq 0) and index_pdf neq 0><!--- ilk pdf haricinde bir onceki pdf in bakiyesini alabilmesi icin --->
		<cfoutput>
		<tr class="tr">
			<td>&nbsp;</td>
			<td colspan="4"><cf_get_lang dictionary_id='57189.Devreden Toplam'></td>
			<td align="right" style="text-align:right;"><cfif len(yevmiye_borc)>#TLFormat(yevmiye_borc)#</cfif></td>
			<td align="right" style="text-align:right;"><cfif len(yevmiye_alacak)>#TLFormat(yevmiye_alacak)#</cfif></td>
		</tr>
		</cfoutput>
		</cfif>
			<cfset start_row = (index_pdf*pdf_row_count) + 1>
			<cfoutput query="GET_CARD_ID" startrow="#start_row#" maxrows="#pdf_row_count#"> 
				<cfset TYPE_NO=GET_CARD_ID.CARD_TYPE_NO>
				<cfswitch expression="#CARD_TYPE#">
					<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
					<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
					<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
					<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
					<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
				</cfswitch>
				<cfif currentrow eq 1 or GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1]>
					<cfset new_control = 1>
					<tr class="tr">
						<td colspan="3"><cf_get_lang dictionary_id='39373.YEVMİYE NO'>: #GET_CARD_ID.BILL_NO#</td>
						<td align="center" colspan="4"></td>
					</tr>
					<tr class="tr">
						<td colspan="3">#TYPE# <cf_get_lang dictionary_id='57946.Fiş No'>: #TYPE_NO#</td>
						<td colspan="4" align="center">____________________________________#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#____________________________________</td>
					</tr>
					<cfset satir_sayisi = satir_sayisi + 2>
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount) or (GET_CARD_ID.currentrow gte temp_pdf_row)>
						<tr class="tr">
							<td style="width:20px;">&nbsp;</td>
							<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
						</tr>
						<cfset satir_sayisi = satir_sayisi + 1>
						<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
							</table>
							<cfdocumentitem type="pagebreak"/>
							<table cellpadding="2" cellspacing="1" border="0" width="98%">
							<cfif x_show_head_all_page eq 1>
							<tr class="th">
							  <td colspan="6" align="center"><big><big><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></big></big></td>
							</tr>
							</cfif>
							<tr class="tr">
							  <td style="width:20px;">&nbsp;</td>
							  <td><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
							  <td><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
							  <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
							  <cfif isdefined("attributes.is_detail")>
								  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57771.Detay'></td>		  
							  <cfelse>
								<td></td>
							  </cfif>
							  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
							  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
							</tr>
							<tr class="tr">
								<td style="width:20px;">&nbsp;</td>
								<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
							<cfset satir_sayisi = satir_sayisi + 4>
						</cfif> 
					</cfif>
				</cfif>
				<cfif BA eq 0><cfset yevmiye_borc=yevmiye_borc+AMOUNT></cfif>
				<cfif BA eq 1><cfset yevmiye_alacak = yevmiye_alacak + AMOUNT></cfif>
				
				<cfif TOP_ACCOUNT_CODE[currentrow-1] neq TOP_ACCOUNT_CODE[currentrow] or new_control eq 1>
					<cfquery name="get_sub_account_total_borc" dbtype="query">
						SELECT SUM(AMOUNT) AMOUNT FROM GET_CARD_ID WHERE BILL_NO = #GET_CARD_ID.BILL_NO# AND ACCOUNT_ID LIKE '#GET_CARD_ID.TOP_ACCOUNT_CODE#.%' AND BA = 0
					</cfquery>
                    <cfquery name="get_sub_account_total_alacak" dbtype="query">
						SELECT SUM(AMOUNT) AMOUNT FROM GET_CARD_ID WHERE BILL_NO = #GET_CARD_ID.BILL_NO# AND ACCOUNT_ID LIKE '#GET_CARD_ID.TOP_ACCOUNT_CODE#.%' AND BA = 1
					</cfquery>
					<tr class="tr">
						<td style="width:20px;">&nbsp;</td>
						<td>#TOP_ACCOUNT_CODE#</td>
						<td>#left(TOP_ACCOUNT_NAME,attributes.character_account_code)#</td>
						<td align="right" style="text-align:right;">&nbsp;</td>
						<td align="right" style="text-align:right;">&nbsp;</td>
						<td align="right" style="text-align:right;">&nbsp;<cfif get_sub_account_total_borc.recordcount>#TLFormat(get_sub_account_total_borc.AMOUNT)#</cfif></td>
						<td align="right" style="text-align:right;">&nbsp;<cfif get_sub_account_total_alacak.recordcount>#TLFormat(get_sub_account_total_alacak.AMOUNT)#</cfif></td>
					</tr>
					<cfset new_control = 0>
					<cfset satir_sayisi = satir_sayisi + 1> <!--- fis satırının üst hesap bilgileri yazıldı satır sayısı arttırılıyor --->
				</cfif>
				<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2)>
						<tr class="tr">
							<td style="width:20px;">&nbsp;</td>
							<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
						</tr>
					</table>
					<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
						<cfdocumentitem type="pagebreak"/>
						<table cellpadding="2" cellspacing="1" border="0" width="98%">
						<cfif x_show_head_all_page eq 1>
						<tr class="th">
						  <td colspan="6" align="center"><big><big><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></big></big></td>
						</tr>
						</cfif>
						<tr class="tr">
						  <td style="width:20px;">&nbsp;</td>
						  <td><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
						  <td><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
						  <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
						  <cfif isdefined("attributes.is_detail")>
							  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57771.Detay'></td>		  
						  <cfelse>
							<td></td>
						  </cfif>
						  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
						  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
						</tr>
						<tr class="tr">
							<td style="width:20px;">&nbsp;</td>
							<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
						</tr>
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
							<cfset Cari_ = Left(ListFirst(New_Detail,'-'),20)>
							<cfset Fatura_ = Replace(New_Detail,'Fat.','','all')>
							<cfset Fatura_ = ListGetAt(Fatura_,ListLen(Fatura_,'-')-1,'-') & '-' & ListLast(Fatura_,'-')>
							<cfset Tip_ = 'Fat.'>
							<cfset New_Detail = Cari_ & ' ' & Fatura_ & ' ' & Tip_>
						<cfelse>
							<cfset Cari_ = Left(ListFirst(New_Detail,'-'),20)>
							<cfset Fatura_ = Replace(New_Detail,'Fat.','','all')>
							<cfset Fatura_ = ListLast(Fatura_,'-')>
							<cfset Tip_ = 'Fat.'>
							<cfset New_Detail = Cari_ & ' ' & Fatura_ & ' ' & Tip_>
						</cfif>
					<cfelseif ListFind(New_Detail,"No'lu",' ')>
						<cfset Fatura_ = ListFirst(New_Detail,"No'lu")>
						<cfset Cari_ = Replace(Replace(Replace(New_Detail,Fatura_,''),"No'lu",''),'Sat. Fat.','')>
						<cfset Tip_ = 'Sat. Fat.'>
						<cfset Cari_ = Left(Cari_,20)>
						<cfset New_Detail = Cari_ & ' ' & Fatura_ & ' ' & Tip_>
					</cfif>
					<cfset Detail_ = Left(New_Detail,50)>
				<cfelse>
					<cfset Detail_ = Left(Detail,attributes.character_detail)>
				</cfif>
				<tr class="tr">
					<td style="width:20px;">&nbsp;</td>
					<td>#ACCOUNT_ID#</td>
					<td>#left(ACCOUNT_NAME,attributes.character_account_code)#</td>
					<td>#Detail_#</td>
				    <cfif isdefined("attributes.is_detail")>
				  	  <td align="right" style="text-align:right;">&nbsp;#TLFormat(AMOUNT)#<cfif BA eq 0>(B)<cfelse>(A)</cfif></td>		  
				    <cfelse>
					  <td></td>
				    </cfif>					
					<td align="right" style="text-align:right;">&nbsp;</td>
					<td align="right" style="text-align:right;">&nbsp;</td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1><!--- fis satırı yazıldı,satır_sayisi arttırılıyor --->
				<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount) or (GET_CARD_ID.currentrow gte temp_pdf_row)>
						<tr class="tr">
							<td style="width:20px;">&nbsp;</td>
							<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
						</tr>
					</table>
					<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
						<cfdocumentitem type="pagebreak"/>
						<table cellpadding="2" cellspacing="1" border="0" width="98%">
						<cfif x_show_head_all_page eq 1>
						<tr class="th">
						  <td colspan="6" align="center"><big><big><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></big></big></td>
						</tr>
						</cfif>
						<tr class="tr">
						  <td style="width:20px;">&nbsp;</td>
						  <td><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
						  <td><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
						  <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
						  <cfif isdefined("attributes.is_detail")>
						  	<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57771.Detay'></td>		  
					      <cfelse>
						  	<td></td>
						  </cfif>	 
						  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
						  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
						</tr>
						<tr class="tr">
							<td style="width:20px;">&nbsp;</td>
							<td colspan="4"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
						</tr>
						<cfset satir_sayisi = satir_sayisi + 4>
					</cfif> 
				</cfif>
		</cfoutput>
		</table> 
		<cfset file_name_list = listappend(file_name_list,'#filename#.pdf')>
		</cfdocument>
	</cfloop>
	<cfzip file="#upload_folder#account/fintab/#session.ep.userid#_zip/#zip_filename#" source="#upload_folder#account/fintab/#session.ep.userid#">
    <!--- <cfscript>ZipFileNew(zipPath:expandPath("/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#"),toZip:expandPath("/documents/account/fintab/#session.ep.userid#"),relativeFrom:'#upload_folder#');</cfscript> --->
	<!--- Kullanildiktan Sonra Isi Biten Dosyalar Temizleniyor --->
	<cfloop list="#file_name_list#" index="mmm">
		<cffile action="delete" file="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid##dir_seperator##mmm#">
	</cfloop>
	<!--- //Kullanildiktan Sonra Isi Biten Dosyalar Temizleniyor --->
	<br/>
	<script>
		get_wrk_message_div("<cfoutput><cf_get_lang dictionary_id='29728.Dosya İndir'></cfoutput>","<cfoutput><cf_get_lang dictionary_id='29733.PDF'></cfoutput>","<cfoutput>/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#</cfoutput>");
	</script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>");
	</script>
</cfif>
</cfprocessingdirective>
</cfsetting>


