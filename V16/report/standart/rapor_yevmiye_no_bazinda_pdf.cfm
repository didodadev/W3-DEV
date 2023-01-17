<cfsetting showdebugoutput="no" requestTimeout ="200">
<cfprocessingdirective suppresswhitespace="yes">
	<cfflush interval="3000">
	<cfset yevmiye_borc=0>
	<cfset yevmiye_alacak=0>
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
			<cfset satir_sayisi = 2>
			<cfset filename = "#index_pdf#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
			<cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="0" marginright="0" margintop="0" marginbottom="0">
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
				<tr class="tr">
					<td colspan="7" align="center"><strong><big><cf_get_lang dictionary_id='31791.YEVMİYE DEFTERİ'> 1</big></strong></td>
				</tr>
                <tr class="tr">
                    <td nowrap><cf_get_lang dictionary_id='39373.Y. NO'></td>
                    <td><cf_get_lang dictionary_id='57742.TARİH'></td>
                    <td><cf_get_lang dictionary_id='44023.HESAP KODU'></td>
                    <td><cf_get_lang dictionary_id='55271.HESAP ADI'></td>
                    <td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></td>
                    <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.BORÇ'></td>
                    <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.ALACAK'></td>
                </tr>
				<cfif get_devreden.recordcount and len(get_devreden.DEVREDEN_KUMULE) and index_pdf eq 0><!--- sadece ilk pdf de devreden kumule bakiye gelmeli --->
				<tr class="tr">
					<td nowrap><cf_get_lang dictionary_id='39373.Y. NO'></td>
					<td><cf_get_lang dictionary_id='57742.TARİH'></td>
					<td><cf_get_lang dictionary_id='44023.HESAP KODU'></td>
					<td><cf_get_lang dictionary_id='55271.HESAP ADI'></td>
					<td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></td>
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.BORÇ'></td>
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.ALACAK'></td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>
				<tr class="tr">
					<td colspan="5"><strong><cf_get_lang dictionary_id='57189.Devreden Toplam'></strong></td>
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
				</cfif>
				<cfif (yevmiye_borc neq 0 or yevmiye_alacak neq 0) and index_pdf neq 0><!--- ilk pdf haricinde bir onceki pdf in bakiyesini alabilmesi icin --->
					<cfoutput>
					<tr class="tr">
						<td colspan="5"><strong><cf_get_lang dictionary_id='57189.Devreden Toplam'></strong></td>
						<td align="right" style="text-align:right;"><cfif len(yevmiye_borc)>#TLFormat(yevmiye_borc)#</cfif></td>
						<td align="right" style="text-align:right;"><cfif len(yevmiye_alacak)>#TLFormat(yevmiye_alacak)#</cfif></td>
					</tr>
					</cfoutput>
				</cfif>
				<cfset satir_sayisi = satir_sayisi + 2>
				<cfset start_row = (index_pdf*pdf_row_count) + 1>
				<cfoutput query="GET_CARD_ID" startrow="#start_row#" maxrows="#pdf_row_count#"> 
					<cfswitch expression="#CARD_TYPE#">
						<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1></cfcase>
						<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
						<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
						<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
						<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
					</cfswitch>
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2)>
							<tr class="tr">
								<td colspan="5"><strong><cf_get_lang dictionary_id='60797.Küm. Toplam'></strong></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
							<cfset satir_sayisi = satir_sayisi + 1>
						</table>
						<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
							<cfdocumentitem type="pagebreak"/>
							<table cellpadding="2" cellspacing="1" border="0" width="98%">
								<tr class="tr">
									<td nowrap><cf_get_lang dictionary_id='39373.Y. NO'></td>
									<td><cf_get_lang dictionary_id='57742.TARİH'></td>
									<td><cf_get_lang dictionary_id='44023.HESAP KODU'></td>
									<td><cf_get_lang dictionary_id='55271.HESAP ADI'></td>
									<td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></td>
									<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.BORÇ'></td>
									<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.ALACAK'></td>
								</tr>
								<cfset satir_sayisi = satir_sayisi + 1>
								<tr class="tr">
									<td colspan="5"><strong><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></strong></td>
									<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
									<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
								</tr>
						</cfif> 
					</cfif>
					<tr class="tr">
						<td>#GET_CARD_ID.BILL_NO#</td>
						<td>#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#</td>
						<td>#ACCOUNT_ID#</td>
						<td>#left(ACCOUNT_NAME,attributes.character_account_code)#</td>
						<td>#left(DETAIL,attributes.character_detail)#</td>
						<td align="right" style="text-align:right;">&nbsp;<cfif BA eq 0 and len(AMOUNT)><cfset yevmiye_borc=yevmiye_borc+AMOUNT>#TLFormat(AMOUNT)#</cfif></td>
						<td align="right" style="text-align:right;">&nbsp;<cfif BA eq 1 and len(AMOUNT)><cfset yevmiye_alacak = yevmiye_alacak + AMOUNT>#TLFormat(AMOUNT)#</cfif></td>
					</tr>
					<cfset satir_sayisi = satir_sayisi + 1><!--- fis satırı yazıldı,satır_sayisi arttırılıyor --->
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount) or (GET_CARD_ID.currentrow gte temp_pdf_row)>
							<tr class="tr">
								<td colspan="5"><strong><cf_get_lang dictionary_id='60797.Küm. Toplam'></strong></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
							<cfset satir_sayisi = satir_sayisi + 1>
						</table>
						<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
							<cfdocumentitem type="pagebreak"/>
							<table cellpadding="2" cellspacing="1" border="0" width="98%">
								<tr class="tr">
									<td nowrap><cf_get_lang dictionary_id='39373.Y. NO'></td>
									<td><cf_get_lang dictionary_id='57742.TARİH'></td>
									<td><cf_get_lang dictionary_id='44023.HESAP KODU'></td>
									<td><cf_get_lang dictionary_id='55271.HESAP ADI'></td>
									<td><cf_get_lang dictionary_id='57629.AÇIKLAMA'></td>
									<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.BORÇ'></td>
									<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.ALACAK'></td>
								</tr>
								<cfset satir_sayisi = satir_sayisi + 1>
								<tr class="tr">
									<td colspan="5"><strong><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></strong></td>
									<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
									<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
								</tr>
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
			get_wrk_message_div("<cfoutput>#getLang('main',1931)#</cfoutput>","PDF","<cfoutput>/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#</cfoutput>");
		</script>
	<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>");
	</script>
</cfif>
</cfprocessingdirective>
</cfsetting>
