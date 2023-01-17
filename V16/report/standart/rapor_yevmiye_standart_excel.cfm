<!--- baslangıc tarihinden onceki donemin devreden bakiye bilgisini içeren, tüm fis satırlarındaki muhasebe hesaplarının üst hesaplar bilgileriyle goruntulendigi  multi pdf oluşturan yevmiye raporu.... OZDEN20070112 --->
<cfsetting showdebugoutput="no" requestTimeout = "2000">
<cfprocessingdirective suppresswhitespace="yes">
<cfflush interval="3000">
<cfparam name="attributes.page" default="1">
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cf_date tarih="attributes.date1">
<cf_date tarih="attributes.date2">
<cfset date1 = dateformat(attributes.date1,dateformat_style)>
<cfset date2 = dateformat(attributes.date2,dateformat_style)>
<cfif isdefined("attributes.page") and attributes.page eq 1><!--- file oluştur ve sil --->
	<cfif not DirectoryExists("#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#")>
			<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#">
	<cfelse>
			<cfdirectory  action="delete" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#" recurse="yes">
			<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#">
	</cfif>
</cfif>
<cfset zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip">
<cfif isdefined("attributes.page") and attributes.page eq 1 >
	<cfif not DirectoryExists("#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip")>
		<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip">
	<cfelse>
		<cfdirectory  action="delete" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip" recurse="yes">
		<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#reserve_files#dir_seperator##session.ep.userid#_zip">
	</cfif>
</cfif>
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
		GET_ACCOUNT_CARD
	WHERE
		CARD_ID IS NOT NULL
	<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
		AND ACTION_DATE <= #attributes.date2# 
		AND ACTION_DATE >= #attributes.date1#
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
<cfif get_card_id.recordcount>
	<cfset excel_sayisi = ceiling(get_card_id.recordcount / pdf_row_count) - 1> 
	<cfloop from="0" to="#excel_sayisi#" index="index">
	<cfset filename = "#createuuid()#">
	<cfsavecontent variable="strExcelData">	
	<cfset satir_sayisi = 4>
	<cfoutput>
		<style type="text/css"><!--- attributes de verilen css özellikte gelsin. --->
			.table{font-size:#attributes.fontsize# !important;font-family:#attributes.fontfamily# !important; font-style:normal !important; border:0px !important;}
			.th{font-size:#attributes.bigfontsize#; font-family:#attributes.bigfontfamily#; font-weight:bold;}
			.tr{font-size:#attributes.fontsize#; font-family:#attributes.fontfamily#; font-style:normal;}
			.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
			padding: 0px !important;
			line-height: 1 !important;
			border-top: 0px  !important;
			}
		</style>
	</cfoutput>
	<table cellpadding="2" cellspacing="1" width="98%" border="0">
		<tr class="tr" valign="top">
			<td colspan="6" align="left" class="txtbold"><cfoutput>#session.ep.company# (#session.ep.period_year#)</cfoutput></td>
		</tr>
		<tr class="headbold">
			<td colspan="6" align="center" class="headbold"><cfoutput>#getLang("account",101)#</cfoutput></td>
		</tr>
		<tr class="tr">
			<td width="40"></td>
			<td><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
			<td><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
			<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td align="right"><cf_get_lang dictionary_id='57587.Borç'></td>
			<td align="right"><cf_get_lang dictionary_id='57588.Alacak'></td>
		</tr>
		<cfset satir_sayisi = satir_sayisi + 1>
		<cfif get_devreden.recordcount and len(get_devreden.DEVREDEN_KUMULE) and index eq 0><!--- sadece ilk pdf de devreden kumule bakiye gelmeli --->
			<tr class="tr">
				<td></td>
				<td colspan="3"><cf_get_lang dictionary_id='38878.Devreden Toplam'></td>					
				<cfoutput query="get_devreden">
					<cfif get_devreden.recordcount neq 1>
						<cfif get_devreden.BA eq 0>
							<td align="right" format="numeric"><cfset yevmiye_borc=yevmiye_borc+get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
						<cfelse>
							<td align="right" format="numeric"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
						</cfif>
					<cfelse>
						<cfif get_devreden.BA eq 0>
							<td align="right" format="numeric"><cfset yevmiye_borc=yevmiye_borc+get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
							<td></td>
						</cfif>
						<cfif get_devreden.BA eq 1>
							<td align="right" format="numeric"><cfset yevmiye_alacak = yevmiye_alacak + get_devreden.DEVREDEN_KUMULE>#TLFormat(get_devreden.DEVREDEN_KUMULE)#</td>
							<td></td>
						</cfif>
					</cfif>
				</cfoutput>
			</tr>
			<cfset satir_sayisi = satir_sayisi + 1>
		</cfif>
		<cfif (yevmiye_borc neq 0 or yevmiye_alacak neq 0) and index neq 0><!--- ilk pdf haricinde bir onceki pdf in bakiyesini alabilmesi icin --->
			<cfoutput>
				<tr class="tr">
					<td colspan="4"><cf_get_lang dictionary_id='38878.Devreden Toplam'></td>
					<td align="right" format="numeric"><cfif len(yevmiye_borc)>#TLFormat(yevmiye_borc)#</cfif></td>
					<td align="right" format="numeric"><cfif len(yevmiye_alacak)>#TLFormat(yevmiye_alacak)#</cfif></td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>
			</cfoutput>
		</cfif>
		<cfset start_row = (index*pdf_row_count) + 1>
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
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='39373.Yevmiye No'>: #GET_CARD_ID.BILL_NO#</td>
					<td colspan="3" align="center"></td>						
				</tr>
				
				<tr class="tr">
					<td colspan="3">#TYPE# <cf_get_lang dictionary_id='57946.Fiş No'>: #TYPE_NO#</td>
					<td colspan="3" align="center">____________________________________#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#____________________________________</td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 2>
				<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
					<cfset satir_sayisi = satir_sayisi + 1>
					<tr class="tr">
						<td></td>
						<td colspan="3"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
						<td align="right" format="numeric">#TLFormat(yevmiye_borc)# </td>
						<td align="right" format="numeric">#TLFormat(yevmiye_alacak)# </td>
					</tr>
					<!--- <cf_wrk_html_page_break> --->		
					<cfif (satir_sayisi gte page_count_)>
						<!--- <cf_wrk_html_sheet_break> --->
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>				
					<tr class="tr">
			            <td width="40"></td>
			            <td><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
			            <td><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
			            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
			            <td align="right"><cf_get_lang dictionary_id='57587.Borç'></td>
			            <td align="right"><cf_get_lang dictionary_id='57588.Alacak'></td>
		            </tr>
						<tr class="tr">
							<td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
							<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_borc)# </td>
							<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_alacak)# </td>
						</tr>
						<cfset satir_sayisi = satir_sayisi + 2>						
				</cfif>
			</cfif>				
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2)>
				<tr class="tr">
					<td width="40"> </td>
					<td colspan="3"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
					<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_borc)# </td>
					<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_alacak)# </td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>
					<!--- <cf_wrk_html_page_break> --->		
					<cfif (satir_sayisi gte page_count_)>
						<!--- <cf_wrk_html_sheet_break> --->
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>
					<tr class="tr">
			            <td width="40"></td>
			            <td><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
			            <td><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
			            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
			            <td align="right"><cf_get_lang dictionary_id='57587.Borç'></td>
			            <td align="right"><cf_get_lang dictionary_id='57588.Alacak'></td>
		            </tr>
					<tr class="tr">
						<td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
						<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_borc)#</td>
						<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_alacak)#</td>
					</tr>
					<cfset satir_sayisi = satir_sayisi + 2>
			</cfif>
			<tr class="tr">
				<td width="40"></td>
				<td>#ACCOUNT_ID#</td>
				<td>#left(ACCOUNT_NAME,attributes.character_account_code)#</td>
				<td>#left(DETAIL,attributes.character_detail)#</td>
				<td align="right" format="numeric"> <cfif BA eq 0 and len(AMOUNT)><cfset yevmiye_borc=yevmiye_borc+AMOUNT>#TLFormat(AMOUNT)#</cfif></td>
				<td align="right" format="numeric"> <cfif BA eq 1 and len(AMOUNT)><cfset yevmiye_alacak = yevmiye_alacak + AMOUNT>#TLFormat(AMOUNT)#</cfif></td>
			</tr>
			<cfset satir_sayisi = satir_sayisi + 1>
			<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount)>
				<tr class="tr">
					<td width="40"> </td>
					<td colspan="3"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
					<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_borc)# </td>
					<td align="right" style="text-align:right;" format="numeric">#TLFormat(yevmiye_alacak)# </td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>
					<!--- <cf_wrk_html_page_break>	 --->	
					<cfif (satir_sayisi gte page_count_)>
						<!--- <cf_wrk_html_sheet_break> --->
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>
					<tr class="tr">
			            <td width="40"></td>
			            <td><cf_get_lang dictionary_id='38889.Hesap Kodu'></td>
			            <td><cf_get_lang dictionary_id='38890.Hesap Adı'></td>
			            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
			            <td align="right"><cf_get_lang dictionary_id='57587.Borç'></td>
			            <td align="right"><cf_get_lang dictionary_id='57588.Alacak'></td>
		            </tr>
					<tr class="tr">
						<td colspan="4"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
						<td align="right" format="numeric">#TLFormat(yevmiye_borc)# </td>
						<td align="right" format="numeric">#TLFormat(yevmiye_alacak)# </td>
					</tr>
					<cfset satir_sayisi = satir_sayisi + 2>
			</cfif>
		</cfoutput>
	</table>
	</cfsavecontent>
	<cfset strFilePath = "#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#/#filename#.xls">
	<cfif not DirectoryExists("#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#")>
		<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#">
	</cfif>
	<cffile
        action="WRITE"
        file="#strFilePath#"
		output="#strExcelData.Trim()#"/>
		<cfset file_name_list = listappend(file_name_list,'#filename#.xls')>
</cfloop>
<cfzip file="#upload_folder#/reserve_files/#session.ep.userid#_zip/#zip_filename#" source="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#">
	<cfloop list="#file_name_list#" index="delete_file">
		<cffile action="delete" file="#upload_folder#/reserve_files/#dateFormat(now(),'yyyymmdd')#/#delete_file#">
	</cfloop>
	 <script type="text/javascript">
			get_wrk_message_div("<cfoutput><cf_get_lang dictionary_id='29728.Dosya İndir'>","<cf_get_lang dictionary_id='29731.Excel'></cfoutput>","<cfoutput>/documents/reserve_files/#session.ep.userid#_zip/#zip_filename#</cfoutput>");
	</script>
	<cfif DirectoryExists("#upload_folder#/reserve_files/#session.ep.userid#_zip/#zip_filename#")>
		<cfdirectory action="delete" directory="#upload_folder#/reserve_files/#session.ep.userid#_zip/#zip_filename#" recurse="yes">
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>");
	</script>
</cfif>
</cfprocessingdirective>