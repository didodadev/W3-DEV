<cfprocessingdirective suppresswhitespace="yes">
<cfquery name="GET_ACCOUNT_NAME" datasource="#dsn2#">
	SELECT
	<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		IFRS_CODE AS ACCOUNT_CODE,
		IFRS_NAME AS ACCOUNT_NAME
	<cfelse>
		ACCOUNT_CODE, 
		ACCOUNT_NAME
	</cfif>
	FROM 
	  ACCOUNT_PLAN 
	<cfif (isdefined('attributes.CODE1') and len(attributes.CODE1)) or (isdefined('attributes.CODE2') and len(attributes.CODE2))>
	WHERE 
	</cfif>
	<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		<cfif isdefined('attributes.CODE1') and len(attributes.CODE1)>
			IFRS_CODE >= '#attributes.CODE1#'
		</cfif>
		<cfif isdefined('attributes.CODE1') and len(attributes.CODE1) and isdefined('attributes.CODE2') and len(attributes.CODE2)>
			AND 
		</cfif>
		<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
			IFRS_CODE <= '#attributes.CODE2#' 
		</cfif>
	<cfelse>
		<cfif isdefined('attributes.CODE1') and len(attributes.CODE1)>
			(ACCOUNT_CODE >= '#attributes.CODE1#' OR ACCOUNT_CODE = '#left(attributes.CODE1,3)#')
		</cfif>
		<cfif isdefined('attributes.CODE1') and len(attributes.CODE1) and isdefined('attributes.CODE2') and len(attributes.CODE2)>
			AND 
		</cfif>
		<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
			(ACCOUNT_CODE <= '#attributes.CODE2#' OR ACCOUNT_CODE = '#left(attributes.CODE2,3)#') 
		</cfif>
	</cfif>
  ORDER BY 
	  ACCOUNT_CODE
</cfquery>
<cfset acc_code_list = valuelist(GET_ACCOUNT_NAME.ACCOUNT_CODE,'█')> <!--- ayrac = alt+987 --->
<cfset acc_hesap_list = valuelist(GET_ACCOUNT_NAME.ACCOUNT_NAME,'█')>

<cfquery name="get_account_id" dbtype="query">
  SELECT
	  ACCOUNT_CODE, 
	  ACCOUNT_NAME 
  FROM 
	  GET_ACCOUNT_NAME 
  WHERE 
	  ACCOUNT_CODE NOT LIKE '%.%' 
  ORDER BY 
	  ACCOUNT_CODE
</cfquery>
<cfset satir_sayisi = 0>
<cfset filename = "kebir_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
<cfparam name="attributes.totalrecords" default="#get_account_id.recordcount#">
<cf_wrk_html_table cellpadding="2" cellspacing="1" border="0" width="98%" table_draw_type="1" filename="#filename#" is_auto_page_break="0" is_auto_sheet_break="0" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
	<cf_wrk_html_tr>
		<cf_wrk_html_td colspan="9" align="center" class="headbold"><cf_get_lang dictionary_id ='39163.DEFTER-İ KEBİR'></cf_wrk_html_td>
	</cf_wrk_html_tr>
	<cfloop from="1" to="#attributes.totalrecords#" index="I">
		<cfset row_count = 0><!--- ana hesaplarda yeni sayfaya gecildiginden satır sayısı sıfırlanıyor --->
		<cfquery name="get_account_card_rows" datasource="#dsn2#">
			SELECT 
				AC.BILL_NO, 
				AC.CARD_TYPE, 
				AC.CARD_TYPE_NO, 
				AC.RECORD_DATE, 
				AC.CARD_DETAIL AS DETAIL,
				AC.ACTION_DATE, 
				ACR.AMOUNT ,
				<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
					ACC_P.IFRS_CODE AS ACCOUNT_ID,
				<cfelse>
					ACR.ACCOUNT_ID,
				</cfif>
				ACR.BA
			FROM 
				ACCOUNT_CARD AC, 
				ACCOUNT_CARD_ROWS ACR 
				<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
				,ACCOUNT_PLAN ACC_P
				</cfif>
			WHERE 
				AC.CARD_ID=ACR.CARD_ID
				<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
					AND (
					<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
						(AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
						<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>	
				<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
					AND ACC_P.IFRS_CODE LIKE '#get_account_id.ACCOUNT_CODE[i]#%'
					AND ACR.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
					<cfif isDefined("attributes.CODE2") and len(attributes.CODE2)>
						AND ACC_P.IFRS_CODE <= '#attributes.CODE2#'<!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
					</cfif>
				<cfelse>
					AND ACR.ACCOUNT_ID LIKE '#get_account_id.ACCOUNT_CODE[i]#%'
					<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
						AND ACR.ACCOUNT_ID <= '#attributes.CODE2#' <!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
					</cfif>	
				</cfif>
				<cfif isdefined("attributes.date1") and len(attributes.date1)>
					AND AC.ACTION_DATE >= #attributes.date1#
				</cfif>
				<cfif isdefined("attributes.date2") and len(attributes.date2)>
					AND AC.ACTION_DATE <= #attributes.date2#
				</cfif>
			ORDER BY 
            	ACR.ACCOUNT_ID,
                AC.ACTION_DATE,
                AC.BILL_NO
		</cfquery>
		<cfif (isDefined("attributes.no_process") and get_account_card_rows.recordcount) or not isDefined("attributes.no_process")>
			<!--- Hareketi Olmayan Hesaplar Gelmesin --->
			<cfoutput>
			<cf_wrk_html_tr>
				<cfset row_count = row_count+1>
				<cf_wrk_html_td colspan="9" class="txtbold" align="center"><cf_get_lang dictionary_id ='39371.Ana Hesap Kodu'> :#get_account_id.ACCOUNT_CODE[i]# <cf_get_lang dictionary_id ='39372.Ana Hesap Adı'> : #listgetat(acc_hesap_list,listfind(acc_code_list,get_account_id.ACCOUNT_CODE[i],'█'),'█')#</cf_wrk_html_td>
			</cf_wrk_html_tr>
			</cfoutput>
			<cf_wrk_html_tr>
				<cfset row_count = row_count+1>
				<cf_wrk_html_td width="80"><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
				<cf_wrk_html_td width="50"><cf_get_lang dictionary_id='39373.Yev No'></cf_wrk_html_td>
				<cf_wrk_html_td width="90"><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></cf_wrk_html_td>
				<cf_wrk_html_td width="80"><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></cf_wrk_html_td>
				<cf_wrk_html_td width="190"><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
				<cf_wrk_html_td align="right" style="text-align:right;" width="80"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
				<cf_wrk_html_td align="right" style="text-align:right;" width="80"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
				<cf_wrk_html_td align="right" style="text-align:right;" width="90"><cf_get_lang dictionary_id='38873.Borç Bakiye'></cf_wrk_html_td>
				<cf_wrk_html_td align="right" style="text-align:right;" width="100"><cf_get_lang dictionary_id='38875.Alacak Bakiye'></cf_wrk_html_td>
			</cf_wrk_html_tr>
			<cfset alacak_bakiye = 0>
			<cfset borc_bakiye = 0>
			<cfset bakiye = 0>
			<cfoutput query="get_account_card_rows">
				<cf_wrk_html_tr><!--- style="font:'Courier New', Courier, mono;font-size:15px" --->
					<cfset row_count = row_count+1>
					<cf_wrk_html_td>#dateformat(get_account_card_rows.ACTION_DATE,'dd.mm.yyyy')#</cf_wrk_html_td>
					<cf_wrk_html_td>#BILL_NO#</cf_wrk_html_td>
					<cf_wrk_html_td>#ACCOUNT_ID#</cf_wrk_html_td>
					<cf_wrk_html_td nowrap="nowrap">
					<cfif listfind(acc_code_list,ACCOUNT_ID,'█')>
						#left(listgetat(acc_hesap_list,listfind(acc_code_list,ACCOUNT_ID,'█'),'█'),character_account_code)#
					<cfelse>
						 <font color="FF0000">!! <cf_get_lang dictionary_id ='39375.Hesap Yok'> !!</font>
					</cfif>
					</cf_wrk_html_td>
					<cf_wrk_html_td nowrap="nowrap">#left(detail,character_detail)#</cf_wrk_html_td>
					<cfif BA> <!--- alacak --->
						<cfset alacak_bakiye = alacak_bakiye + AMOUNT>
						<cf_wrk_html_td align="right" style="text-align:right;"></cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</cf_wrk_html_td>
					<cfelse> <!--- borc --->
						<cfset borc_bakiye = borc_bakiye + AMOUNT>
						<cf_wrk_html_td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;"></cf_wrk_html_td>
					</cfif>
					<cf_wrk_html_td align="right" style="text-align:right;">
						<cfif borc_bakiye gt alacak_bakiye>
							<cfset bakiye = borc_bakiye - alacak_bakiye>
							#TlFormat(bakiye)#
						</cfif>
					</cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;">
						<cfif borc_bakiye lte alacak_bakiye>
							<cfset bakiye = alacak_bakiye - borc_bakiye>
							#TlFormat(bakiye)#
						</cfif>
					</cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (row_count neq 1 and ((row_count mod attributes.pdf_page_row) eq 0)) or currentrow eq get_account_card_rows.recordcount> <!--- yeni hesap baslayacaksa veya pdf sayfa satır sayı tamamlanmıssa yeni sayfaya gecilir --->
					<cf_wrk_html_tr>
						<cfset row_count = row_count+1>
						<cf_wrk_html_td colspan="5" align="center" class="txtbold"><cf_get_lang dictionary_id ='39183.Sayfa Toplam'> </cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold">#TLFormat(borc_bakiye)#</cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold">#TLFormat(alacak_bakiye)#</cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold">
							<cfif borc_bakiye gt alacak_bakiye>
								<cfset bakiye = borc_bakiye - alacak_bakiye>
								#TlFormat(bakiye)#
							</cfif>
						</cf_wrk_html_td>
						<cf_wrk_html_td align="right" style="text-align:right;" class="txtbold">
							<cfif borc_bakiye lte alacak_bakiye>
								<cfset bakiye = alacak_bakiye - borc_bakiye>
								#TlFormat(bakiye)#
							</cfif>
						</cf_wrk_html_td>
					</cf_wrk_html_tr>
					<cf_wrk_html_page_break>		
					<cfif (satir_sayisi gte page_count_)>
						<cf_wrk_html_sheet_break>
						<cfset satir_sayisi = satir_sayisi - page_count_>
					</cfif>					
					<cfif currentrow neq get_account_card_rows.recordcount>
						<cf_wrk_html_tr>
							<cfset row_count = row_count+1>
							<cf_wrk_html_td><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
							<cf_wrk_html_td><cf_get_lang dictionary_id='39373.Yev No'></cf_wrk_html_td>
							<cf_wrk_html_td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></cf_wrk_html_td>
							<cf_wrk_html_td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></cf_wrk_html_td>
							<cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='38873.Borç Bakiye'></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='38875.Alacak Bakiye'></cf_wrk_html_td>
						</cf_wrk_html_tr>
						<cf_wrk_html_tr>
							<cf_wrk_html_td colspan="5" align="center" class="txtbold"><cf_get_lang dictionary_id='38876.Önceki Sayfa Toplam'></cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;">#TLFormat(borc_bakiye)#</cf_wrk_html_td>
							<cf_wrk_html_td align="right" style="text-align:right;">#TLFormat(alacak_bakiye)#</cf_wrk_html_td>
						</cf_wrk_html_tr>
					</cfif>
				</cfif>				
			</cfoutput>
		</cfif>
	</cfloop>
	<cfif attributes.totalrecords eq 0>
		<cf_wrk_html_tr>						
			<cf_wrk_html_td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cf_wrk_html_td>
		</cf_wrk_html_tr>
	</cfif>
</cf_wrk_html_table>
</cfprocessingdirective>
