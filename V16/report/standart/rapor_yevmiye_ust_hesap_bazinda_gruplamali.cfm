<cfsetting showdebugoutput="no"> 
<cfprocessingdirective suppresswhitespace="yes" >
<cfflush interval="3000">
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cf_date tarih="attributes.date1">
<cf_date tarih="attributes.date2">
<cfset date1 = dateformat(attributes.date1,dateformat_style)>
<cfset date2 = dateformat(attributes.date2,dateformat_style)>
<cfset zip_filename = "#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#.zip">
<cfquery name="GET_CARD_ID" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		SUM(AMOUNT) AS AMOUNT,
	<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- UFRS bazında --->
		TOP_ACCOUNT_IFRS_NAME AS ACCOUNT_NAME,
		TOP_ACCOUNT_IFRS_CODE AS ACCOUNT_ID,
	<cfelse>
		TOP_ACCOUNT_NAME AS ACCOUNT_NAME,
		TOP_ACCOUNT_CODE AS ACCOUNT_ID,
	</cfif>
		CARD_DETAIL AS DETAIL,
		BA,
		ACTION_DATE,
		BILL_NO,
		CARD_TYPE,
		CARD_TYPE_NO,
		CARD_ID,	
		PAPER_NO,
		ACTION_TYPE
	FROM
		GET_ACCOUNT_CARD_GROUP
	WHERE 
		CARD_ID IS NOT NULL 
	<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
		AND ACTION_DATE <= #attributes.date2# 
		AND ACTION_DATE>=#attributes.date1#
	</cfif>
	<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
		AND (
		<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
			(CARD_TYPE = #listfirst(type_ii,'-')# AND CARD_CAT_ID = #listlast(type_ii,'-')#)
			<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
		</cfloop>  
			)
	</cfif>				
	GROUP BY
		CARD_ID,
		BILL_NO,
	<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- UFRS bazında --->
		TOP_ACCOUNT_IFRS_NAME,
		TOP_ACCOUNT_IFRS_CODE,
	<cfelse>
		TOP_ACCOUNT_NAME,
		TOP_ACCOUNT_CODE,
	</cfif>
		BA,
		ACTION_DATE,
		CARD_TYPE,
		CARD_TYPE_NO,	
		PAPER_NO,
		ACTION_TYPE,
		CARD_DETAIL
	ORDER BY
		ACTION_DATE,
		BILL_NO
</cfquery>
<cfif GET_CARD_ID.recordcount>
	<cfset pdf_sayisi=ceiling(GET_CARD_ID.recordcount/pdf_row_count)-1> 
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
	<cfloop from="0" to="#pdf_sayisi#" index="k">
		<cfset pdf_total_rows=0>
		<cfset satir_sayisi = 3>
		<cfset filename = "#k#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
		<cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" mimetype="text/plain" orientation="portrait" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="0" marginright="0" margintop="0" marginbottom="0">
		<cfoutput><style type="text/css">.table{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
		<table cellpadding="2" cellspacing="1" width="98%" border="0" class="table">
		<tr>
			<td align="center" colspan="6"><strong><big><cf_get_lang dictionary_id='47363.YEVMİYE DEFTERİ'></big></strong></td>
		</tr>
		<tr>
		  <td nowrap>&nbsp;</td>
		  <td width="55"><cf_get_lang dictionary_id='47299.Hesap Kodu'></td>
		  <td width="170"><cf_get_lang dictionary_id='55271.Hesap Adı'></td>
		  <td width="180"><cf_get_lang dictionary_id='57629.Açıklama'></td>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
		  <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
		</tr>
			<cfset satir_sayisi = satir_sayisi + 1>
			<cfset A_toplam=0>
			<cfset B_toplam=0>
			<cfset start_row = (k*pdf_row_count) + 1>
			<cfoutput query="GET_CARD_ID" startrow="#start_row#" maxrows="#pdf_row_count#">
				<cfset pdf_total_rows=pdf_total_rows+1>
				<cfswitch expression="#CARD_TYPE#">
					<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
					<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
					<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
					<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
					<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
				</cfswitch>
				<cfif currentrow eq 1 or GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1]>
					<cfset satir_sayisi = satir_sayisi + 2>	
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='39373.YEVMİYE NO'>: #GET_CARD_ID.BILL_NO#</td>
						<td colspan="3"></td>
					</tr>
					<tr>
						<td colspan="3">#TYPE# FİŞ NO: #GET_CARD_ID.CARD_TYPE_NO#</td>
						<td colspan="3">____________________________________#dateformat(GET_CARD_ID.ACTION_DATE,dateformat_style)#____________________________________</td>
					</tr>
                    <cfif satir_sayisi mod pdf_page_row eq 2>
						<tr>
							<td>&nbsp;</td>
							<td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#tlformat(yevmiye_borc)#</td>
							<td align="right" style="text-align:right;">#tlformat(yevmiye_alacak)#</td>
						</tr>
						<cfset satir_sayisi = satir_sayisi + 1>
					</table>
					<cfdocumentitem type="pagebreak"/>
					<table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">                    
                    </cfif>
				</cfif>
				<cfif (currentrow neq start_row) or ( currentrow eq start_row and GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow-1])> 
					<cfif ((satir_sayisi mod pdf_page_row) eq 1)>				
						<tr >
							<td>&nbsp;</td>
							<td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
							<td align="right" style="text-align:right;">#tlformat(yevmiye_borc)#</td>
							<td align="right" style="text-align:right;">#tlformat(yevmiye_alacak)#</td>
						</tr>
						<cfset satir_sayisi = satir_sayisi + 1>
					</table>
					<cfdocumentitem type="pagebreak"/>
					<table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
					</cfif>
				</cfif>
				<tr>
				<cfset satir_sayisi = satir_sayisi + 1> <!--- fis satırı yazılacak,satır_sayisi arttırılıyor --->
					<td nowrap>&nbsp;</td>
					<td width="55">#ACCOUNT_ID#</td>
					<td width="170">#left(ACCOUNT_NAME,attributes.character_account_code)#</td>
					<td width="180">#left(DETAIL,attributes.character_detail)#</td>
					<td align="right" style="text-align:right;">&nbsp;
					<cfif BA eq 0>
						#TLFormat(AMOUNT)#
						<cfset yevmiye_borc=yevmiye_borc+AMOUNT>
						<cfset A_toplam = A_toplam + amount >
					</cfif>
					</td>
					<td align="right" style="text-align:right;">&nbsp;
					<cfif BA eq 1>
						#TLFormat(AMOUNT)#
						<cfset yevmiye_alacak = yevmiye_alacak + AMOUNT>
						<cfset B_toplam = B_toplam + amount >
					</cfif>
					</td>
			  </tr>
			<cfif (satir_sayisi mod pdf_page_row eq 1)>
				<tr>
				<td>&nbsp;</td>
				<td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#</td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#</td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
			</cfif>
			<cfif GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow+1]>
			<cfset satir_sayisi = satir_sayisi + 1>
				<tr >
					<td colspan="6" align="center">#GET_CARD_ID.CARD_TYPE_NO# NOLU #TYPE# FİŞİNDEN</td>
				</tr>
			</cfif>
			<cfif (satir_sayisi mod pdf_page_row eq 1)>
				<tr >
				<td>&nbsp;</td>
				<td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#</td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#</td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
			</cfif>
			<cfif GET_CARD_ID.CARD_ID[currentrow] neq GET_CARD_ID.CARD_ID[currentrow+1]>
				<cfset satir_sayisi = satir_sayisi + 1>
				<tr >
				  <td colspan="4"><cf_get_lang dictionary_id='57492.Toplam'>:</td>
				  <td align="right" style="text-align:right;">#TLFormat(A_toplam)#</td>
				  <td align="right" style="text-align:right;">#TLFormat(B_toplam)#</td>
				</tr>
				<cfset A_toplam =0>
				<cfset B_toplam =0> <!--- bu toplam satırından sonra yeni fise gecilecegi icin borc ve alacak sıfırlanıyor --->
			</cfif>
			<cfif ((satir_sayisi mod pdf_page_row eq 1) or (GET_CARD_ID.currentrow eq GET_CARD_ID.recordcount))>
				<tr>
				<td>&nbsp;</td>
				<td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_borc)#</td>
				<td align="right" style="text-align:right;">#TLFormat(yevmiye_alacak)#</td>
				</tr>
				<cfset satir_sayisi = satir_sayisi + 1>                
				</table>                
				<cfif GET_CARD_ID.currentrow neq GET_CARD_ID.recordcount>
					<cfdocumentitem type="pagebreak"/> 
					<table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
				</cfif>
			</cfif>
		</cfoutput>
	
		<cfif pdf_total_rows eq (k*pdf_row_count)>
			<cfset new_start_row =  (k*pdf_row_count) + 1>
			<cfif GET_CARD_ID.CARD_ID[new_start_row] neq GET_CARD_ID.CARD_ID[currentrow]> <!--- yeni pdf te yeni fis baslıyorsa --->
					<tr >
						<td>&nbsp;</td>
						<td colspan="3"><cf_get_lang dictionary_id='60797.Küm. Toplam'></td>
						<td align="right" style="text-align:right;">#tlformat(yevmiye_borc)#</td>
						<td align="right" style="text-align:right;">#tlformat(yevmiye_alacak)#</td>
					</tr>
			</cfif>
		</cfif>
		</table>
		</cfdocument>
		<cfset file_name_list = listappend(file_name_list,'#filename#.pdf')>
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
<cfsetting enablecfoutputonly="no">
</cfprocessingdirective>

