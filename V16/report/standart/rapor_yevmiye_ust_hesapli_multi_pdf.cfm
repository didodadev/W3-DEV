<cfsetting showdebugoutput="no"> 
<cfprocessingdirective suppresswhitespace="yes">
	<cfflush interval="3000">
	<cfset yevmiye_borc=0>
	<cfset yevmiye_alacak=0>
	<cfset yevmiye_top_borc = 0>
	<cfset yevmiye_top_alacak = 0>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
	<cfset date1 = dateformat(attributes.date1,dateformat_style)>
	<cfset date2 = dateformat(attributes.date2,dateformat_style)>
	<cfset zip_filename = "#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#.zip">
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
		<cfset pdf_sayisi=ceiling(get_card_id.recordcount/pdf_row_count)-1> 
		<cfloop from="0" to="#pdf_sayisi#" index="k">
			<cfset temp_pdf_row = (k+1)*pdf_row_count>
			<cfset satir_sayisi = 3>
			<cfset filename = "#k#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
		<cfset pagetype_ = ListGetAt(attributes.pagetype,1,';')>
        <cfset pageheight_ = ListGetAt(attributes.pagetype,2,';')>
        <cfset pagewidth_ = ListGetAt(attributes.pagetype,3,';')>
        <cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" orientation="portrait" backgroundvisible="false" pagetype="#pagetype_#" unit="cm" pageheight="#pageheight_#" pagewidth="#pagewidth_#" marginleft="0" marginright="0" margintop="0" marginbottom="0">
			<cfoutput><style type="text/css">.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
			<table cellpadding="2" cellspacing="1" width="98%" border="0">
				<tr class="tr">
					<td colspan="7" align="center"><strong><big><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></big></strong></td>
				</tr>
				<tr class="tr">
				  <td style="width:60px;"><cf_get_lang dictionary_id='39373.Yevmiye No'></td>
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
				<cfset start_row = (k*pdf_row_count) + 1>
				<cfoutput query="get_card_id" startrow="#start_row#" maxrows="#pdf_row_count#"> 
					<cfswitch expression="#CARD_TYPE#">
						<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
						<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
						<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
						<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
						<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
					</cfswitch>
					<cfif currentrow eq 1 or GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1]>
						<cfset new_control = 1>
						<cfset satir_sayisi = satir_sayisi + 2>
						<tr class="tr">
							<td colspan="3">#GET_CARD_ID.BILL_NO#</td>
							<td align="center" colspan="4"></td>
						</tr>
						<tr class="tr">
							<td colspan="3"><cf_get_lang dictionary_id='45271.Fiş Tipi'>:#TYPE#</td>
							<td colspan="4" align="center">____________________________________#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#____________________________________</td>
						</tr>						
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount) or (GET_CARD_ID.currentrow gte temp_pdf_row)>
							<tr class="tr">
								<td colspan="5"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
								</table>                            
							<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
								<cfdocumentitem type="pagebreak"/>
								<table cellpadding="2" cellspacing="1" border="0" width="98%">
								<tr class="tr">
								  <td style="width:60px;"><cf_get_lang dictionary_id='39373.Yevmiye No'></td>
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
									<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
									<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
									<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
								</tr>
								<cfset satir_sayisi = satir_sayisi + 2>
							</cfif> 
						</cfif>
					</cfif>
					<cfif BA eq 0><cfset yevmiye_borc=yevmiye_borc+AMOUNT></cfif>
					<cfif BA eq 1><cfset yevmiye_alacak = yevmiye_alacak + AMOUNT></cfif>
					<cfif TOP_ACCOUNT_CODE[currentrow-1] neq TOP_ACCOUNT_CODE[currentrow] or new_control eq 1>
						<cfquery name="get_sub_account_total" dbtype="query">
							SELECT AMOUNT,BA FROM GET_CARD_ID WHERE BILL_NO = #GET_CARD_ID.BILL_NO# AND ACCOUNT_ID LIKE '#GET_CARD_ID.TOP_ACCOUNT_CODE#.%'
						</cfquery>
						<cfset yevmiye_top_borc = 0>
						<cfset yevmiye_top_alacak = 0>
						<cfloop query="get_sub_account_total">
							<cfif get_sub_account_total.ba eq 1>
								<cfset yevmiye_top_alacak = yevmiye_top_alacak + get_sub_account_total.AMOUNT>
							<cfelse>
								<cfset yevmiye_top_borc = yevmiye_top_borc + get_sub_account_total.AMOUNT>
							</cfif>
						</cfloop>
						<tr class="tr">
							<td style="width:60px;">&nbsp;</td>
							<td>#TOP_ACCOUNT_CODE#</td>
							<td>#left(TOP_ACCOUNT_NAME,attributes.character_account_code)#</td>
							<td>&nbsp;</td>
							<td align="right" style="text-align:right;">&nbsp;</td>
							<td align="right" style="text-align:right;">&nbsp;<cfif BA eq 0>#TLFormat(yevmiye_top_borc)#</cfif></td>
							<td align="right" style="text-align:right;">&nbsp;<cfif BA eq 1>#TLFormat(yevmiye_top_alacak)#</cfif></td>
						</tr>
						<cfset new_control = 0>
						<cfset satir_sayisi = satir_sayisi + 1> <!--- fis satırının üst hesap bilgileri yazıldı satır sayısı arttırılıyor --->
					</cfif>
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount) or (GET_CARD_ID.currentrow gt temp_pdf_row)>
							<tr class="tr">
								<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
						</table>
						<cfif GET_CARD_ID.currentrow lt temp_pdf_row><!--- (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) kaldırıldı son satırsa bile ust hesap bilgisinden sonra hareket goren alt hesabı yazmalı --->
							<cfdocumentitem type="pagebreak"/>
							<table cellpadding="2" cellspacing="1" border="0" width="98%">
							<tr class="tr">
							  <td style="width:60px;"><cf_get_lang dictionary_id='39373.Yevmiye No'></td>
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
								<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
							<cfset satir_sayisi = satir_sayisi + 2>
						</cfif> 
					</cfif>
					<tr class="tr">
						<td style="width:60px;">&nbsp;</td>
						<td>#ACCOUNT_ID#</td>
						<td>#left(ACCOUNT_NAME,attributes.character_account_code)#</td>
						<td>#left(DETAIL,attributes.character_detail)#</td>
						  <cfif isdefined("attributes.is_detail")>
							<td align="right" style="text-align:right;">&nbsp;#TLFormat(AMOUNT)#</td>		  
						  <cfelse>
							<td></td>
						  </cfif>							
						<td align="right" style="text-align:right;">&nbsp;</td>
						<td align="right" style="text-align:right;">&nbsp;</td>
					</tr>
					<cfset satir_sayisi = satir_sayisi + 1><!--- fis satırı yazıldı,satır_sayisi arttırılıyor --->
					<cfif ((satir_sayisi mod pdf_page_row) eq 1) or ((satir_sayisi mod pdf_page_row) eq 2) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount) or (GET_CARD_ID.currentrow gte temp_pdf_row)>
							<tr class="tr">
								<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
						</table>
						<cfif (GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount) and (GET_CARD_ID.currentrow lt temp_pdf_row)>
							<cfdocumentitem type="pagebreak"/>
							<table cellpadding="2" cellspacing="1" border="0" width="98%">
							<tr class="tr">
							  <td style="width:60px;"><cf_get_lang dictionary_id='39373.Yevmiye No'></td>
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
								<td colspan="5"><cf_get_lang dictionary_id='60797.Devreden Küm. Toplam'></td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#&nbsp;</td>
								<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#&nbsp;</td>
							</tr>
							<cfset satir_sayisi = satir_sayisi + 2>
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
