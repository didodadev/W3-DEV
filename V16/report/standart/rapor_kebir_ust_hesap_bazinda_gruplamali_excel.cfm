<cfsetting showdebugoutput="no" requesttimeout="7200">
<cfset filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#">
<cfprocessingdirective suppresswhitespace="yes">
<cfquery name="GET_ACCOUNT_NAME_ALL" datasource="#DSN2#">
	SELECT
	<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		IFRS_CODE AS ACCOUNT_CODE,
		IFRS_NAME AS ACCOUNT_NAME,
	<cfelse>
		ACCOUNT_CODE, 
		ACCOUNT_NAME,
	</cfif>
		ACCOUNT_ID
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
<cfset acc_code_list = valuelist(GET_ACCOUNT_NAME_ALL.ACCOUNT_CODE,'█')><!--- ayrac = alt+987 --->
<cfset acc_hesap_list = valuelist(GET_ACCOUNT_NAME_ALL.ACCOUNT_NAME,'█')>
<cfquery name="GET_ACCOUNT_ID" dbtype="query">
	SELECT
		ACCOUNT_CODE, 
		ACCOUNT_NAME 
	FROM 
		GET_ACCOUNT_NAME_ALL 
	WHERE 
		ACCOUNT_CODE NOT LIKE '%.%' 
	ORDER BY 
		ACCOUNT_CODE
</cfquery>

<cfset account_count=0>
<cfset alacak_bakiye = 0>
<cfset borc_bakiye = 0>
<cfset bakiye = 0>

<cfquery name="GET_ACCOUNT_CARD_ROWS_ALL" datasource="#DSN2#">
	SELECT 
		AC.BILL_NO, 
		AC.CARD_TYPE, 
		AC.CARD_TYPE_NO, 
		<!--- AC.RECORD_DATE, --->
		AC.CARD_DETAIL AS DETAIL,
		AC.ACTION_DATE, 
		SUM(ACR.AMOUNT) AS AMOUNT,
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			AP.IFRS_CODE AS ACCOUNT_ID,
		<cfelse>
			<!--- ACR.ACCOUNT_ID, --->
			AP2.ACCOUNT_CODE ACCOUNT_ID,
		</cfif>
		ACR.BA
	FROM
		ACCOUNT_PLAN AP,
		ACCOUNT_PLAN AP2,
		ACCOUNT_CARD AC, 
		ACCOUNT_CARD_ROWS ACR
		<!--- <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		,ACCOUNT_PLAN ACC_P
		</cfif> --->
	WHERE 
		AC.CARD_ID = ACR.CARD_ID AND
		AP.ACCOUNT_CODE = ACR.ACCOUNT_ID
		AND
		(
			AP2.ACCOUNT_CODE =replace(left(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.','') OR
			(
				AP2.ACCOUNT_CODE =AP.ACCOUNT_CODE AND
				LEN(REPLACE(LEFT(AP.ACCOUNT_CODE,charindex('.',AP.ACCOUNT_CODE)),'.','')) = 0
			)
		)
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>	
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
			AND ACR.ACCOUNT_ID = AP.ACCOUNT_CODE
			<cfif isDefined("attributes.code1") and len(attributes.code1)>
				AND AP.IFRS_CODE >= '#attributes.code1#'
			</cfif>
			<cfif isDefined("attributes.code2") and len(attributes.code2)>
				AND AP.IFRS_CODE <= '#attributes.code2#'
			</cfif>
		<cfelse>
			<cfif isdefined('attributes.code1') and len(attributes.code1)>
				AND ACR.ACCOUNT_ID >= '#attributes.code1#' 
			</cfif>		
			<cfif isdefined('attributes.code2') and len(attributes.code2)>
				AND ACR.ACCOUNT_ID <= '#attributes.code2#'<!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
			</cfif>	
		</cfif>			
		<!--- 
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
			AND ACR.ACCOUNT_ID = ACC_P.ACCOUNT_CODE
			<cfif isDefined("attributes.code1") and len(attributes.code1)>
				AND ACC_P.IFRS_CODE >= '#attributes.code1#'
			</cfif>
			<cfif isDefined("attributes.code2") and len(attributes.code2)>
				AND ACC_P.IFRS_CODE <= '#attributes.code2#'
			</cfif>
		<cfelse>
			<cfif isdefined('attributes.code1') and len(attributes.code1)>
				AND ACR.ACCOUNT_ID >= '#attributes.code1#' 
			</cfif>		
			<cfif isdefined('attributes.code2') and len(attributes.code2)>
				AND ACR.ACCOUNT_ID <= '#attributes.code2#'<!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
			</cfif>	
		</cfif>
		 --->
		<cfif isdefined("attributes.date1") and len(attributes.date1)>
			AND AC.ACTION_DATE >= #attributes.date1#
		</cfif>
		<cfif isdefined("attributes.date2") and len(attributes.date2)>
			AND AC.ACTION_DATE <= #attributes.date2#
		</cfif>
	GROUP BY 
		AP2.ACCOUNT_CODE,
		AC.ACTION_DATE, 
		AC.BILL_NO, 
		AC.CARD_TYPE, 
		AC.CARD_TYPE_NO, 
		<!--- AC.RECORD_DATE, --->
		AC.CARD_DETAIL,
		
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			AP.IFRS_CODE,
			
		</cfif>
		ACR.BA
	ORDER BY 
		<!--- ACR.ACCOUNT_ID, --->
		AP2.ACCOUNT_CODE,
		AC.ACTION_DATE,
		AC.BILL_NO
		<!--- ACR.ACCOUNT_ID ASC,
		AC.BILL_NO --->
</cfquery>
<cfset acc_list = 0>
<cfoutput query="get_account_id">
	<cfquery name="get_" dbtype="query">
		SELECT ACCOUNT_ID FROM GET_ACCOUNT_CARD_ROWS_ALL WHERE ACCOUNT_ID LIKE '#get_account_id.account_code#.%' ORDER BY BILL_NO, ACCOUNT_ID
	</cfquery>
	<cfif get_.recordcount>
		<cfset acc_list = acc_list + 1>
	</cfif>
</cfoutput>

	<cfset row_count = 1>
	<cfset filename = "kebir_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
	<cfoutput><style type="text/css">.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
	<cf_wrk_html_table cellpadding="2" cellspacing="1" border="0" width="98%" table_draw_type="1" filename="#filename#" is_auto_page_break="0" is_auto_sheet_break="0" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
	<cf_wrk_html_tr class="tr">
		<cf_wrk_html_td colspan="9" align="center" class="headbold"><cf_get_lang dictionary_id='47283.DEFTER-İ KEBİR'></cf_wrk_html_td>
	</cf_wrk_html_tr>
	<cfif isdefined("get_account_card_rows_all.recordcount") and get_account_card_rows_all.recordcount gt 0>
		<cfparam name="attributes.totalrecords" default="#get_account_id.recordcount#">	
		<cfoutput query="get_account_card_rows_all" startrow="1">
			<cfif currentrow eq 1 or (currentrow neq 1 and (listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.') neq listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')))>
				<!--- hareket olmayan hesapların gelmesi icin duzenledi --->
				<cfif (currentrow neq 1 and (listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.') neq listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')))>
					<cfquery name="get_ara_hesaplar" dbtype="query">
						SELECT 
							* 
						FROM 
							GET_ACCOUNT_ID 
						WHERE 
							ACCOUNT_CODE > '#listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')#' AND
							ACCOUNT_CODE < '#listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.')#'
					</cfquery>
					<cfif get_ara_hesaplar.recordcount>
						<cfloop query="get_ara_hesaplar">						
							<cfset account_count=account_count+1>
							<cfif not isDefined("attributes.no_process")>
								<!--- Hareketi Olmayan Hesaplar Gelmesin --->
								<cfset alacak_bakiye = 0>
								<cfset borc_bakiye = 0>
								<cfset bakiye = 0>							
								<cf_wrk_html_tr class="tr"><!--- style="font:'Courier New', Courier, mono;font-size:10px" --->
								<cfset row_count=row_count+1>
									<cf_wrk_html_td colspan="9" class="txtbold" align="center"><cf_get_lang dictionary_id='39371.Ana Hesap Kodu'> :  #get_ara_hesaplar.account_code#  <cf_get_lang dictionary_id='39372.Ana Hesap Adı'> : <cfquery name="GET_ACCOUNT_NAME" dbtype="query">SELECT * FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#get_ara_hesaplar.ACCOUNT_CODE#'</cfquery>
									#left(get_ara_hesaplar.account_name,character_account_code)#</cf_wrk_html_td>
								</cf_wrk_html_tr>
								<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
									<cf_wrk_html_page_break>		
									<cfif (row_count gte page_count_)>
										<cf_wrk_html_sheet_break>
										<cfset row_count = row_count - page_count_>
									</cfif>	
								</cfif>
								<cf_wrk_html_tr class="tr">
									<cfset row_count=row_count+1>
									<cf_wrk_html_td><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
									<cf_wrk_html_td><cf_get_lang dictionary_id='57946.Fiş No'></cf_wrk_html_td>
									<cf_wrk_html_td><cf_get_lang dictionary_id='39373.Yev No'></cf_wrk_html_td>
									<cf_wrk_html_td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></cf_wrk_html_td>
									<cf_wrk_html_td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></cf_wrk_html_td>
									<cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
									<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
									<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
									<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></cf_wrk_html_td>
								</cf_wrk_html_tr>
								<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
									<cf_wrk_html_page_break>		
									<cfif (row_count gte page_count_)>
										<cf_wrk_html_sheet_break>
										<cfset row_count = row_count - page_count_>
									</cfif>	
								</cfif>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
				<cfset account_count=account_count+1>			
				<cfset alacak_bakiye = 0>
				<cfset borc_bakiye = 0>
				<cfset bakiye = 0>		
				<cf_wrk_html_tr class="tr">
					<cfset row_count=row_count+1>
					<cf_wrk_html_td colspan="9" class="txtbold" align="center"><cf_get_lang dictionary_id='39371.Ana Hesap Kodu'> :  #get_account_id.account_code[account_count]#  <cf_get_lang dictionary_id='39372.Ana Hesap Adı'> : <cfquery name="GET_ACCOUNT_NAME" dbtype="query">SELECT * FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#get_account_id.account_code[account_count]#'</cfquery>
					#left(get_account_name.account_name,character_account_code)#</cf_wrk_html_td>
				</cf_wrk_html_tr>
				<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
					<cf_wrk_html_page_break>		
					<cfif (row_count gte page_count_)>
						<cf_wrk_html_sheet_break>
						<cfset row_count = row_count - page_count_>
					</cfif>	
				</cfif>
				<cf_wrk_html_tr class="tr">
					<cfset row_count=row_count+1>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57946.Fiş No'></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='39373.Yev No'></cf_wrk_html_td>
					<cf_wrk_html_td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></cf_wrk_html_td>
					<cf_wrk_html_td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></cf_wrk_html_td>
					<cf_wrk_html_td><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></cf_wrk_html_td>
				</cf_wrk_html_tr>
			</cfif>
			<cf_wrk_html_tr class="tr">
				<cfset row_count=row_count+1>
				<cf_wrk_html_td format="date" width="85">#dateformat(get_account_card_rows_all.action_date,dateformat_style)#</cf_wrk_html_td>
				<cf_wrk_html_td>#card_type_no#</cf_wrk_html_td>
				<cf_wrk_html_td>#bill_no#</cf_wrk_html_td>
				<cf_wrk_html_td>#account_id#</cf_wrk_html_td>
				<cf_wrk_html_td nowrap>
				<cfif listfind(acc_code_list,ACCOUNT_ID,'█')>
					#left(listgetat(acc_hesap_list,listfind(acc_code_list,ACCOUNT_ID,'█'),'█'),character_account_code)#
				<cfelse>
					<font color="FF0000">!!<cf_get_lang dictionary_id='39375.Hesap Yok'> !!</font>
				</cfif>
				</cf_wrk_html_td>
				<cf_wrk_html_td nowrap>#left(detail,character_detail)#</cf_wrk_html_td>
				<cfif BA> <!--- eq 1 : alacak --->
					<cfset alacak_bakiye = alacak_bakiye + AMOUNT>
					<cf_wrk_html_td align="right" style="text-align:right;">&nbsp;</cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;" format="numeric" width="80">#TLFormat(AMOUNT)#</cf_wrk_html_td>
				<cfelse> <!--- borc --->
					<cfset borc_bakiye = borc_bakiye + AMOUNT>
					<cf_wrk_html_td align="right" style="text-align:right;" format="numeric" width="80">#TLFormat(AMOUNT)#</cf_wrk_html_td>
					<cf_wrk_html_td align="right" style="text-align:right;">&nbsp;</cf_wrk_html_td>
				</cfif>
				<cf_wrk_html_td align="right" style="text-align:right;">
					<cfif borc_bakiye gt alacak_bakiye><cfset bakiye = borc_bakiye - alacak_bakiye>#TlFormat(bakiye)#(B)<cfelse><cfset bakiye = alacak_bakiye - borc_bakiye>#TlFormat(bakiye)#(A)</cfif>
				</cf_wrk_html_td>
			</cf_wrk_html_tr>
			<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
				<cf_wrk_html_page_break>		
				<cfif (row_count gte page_count_)>
					<cf_wrk_html_sheet_break>
					<cfset row_count = row_count - page_count_>
				</cfif>	
				<cfif listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.') eq listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')>
					<cf_wrk_html_tr class="tr">
						<cfset row_count=row_count+1>
						<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
						<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='57946.Fiş No'></cf_wrk_html_td>
						<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='39373.Yev No'></cf_wrk_html_td>
						<cf_wrk_html_td nowrap><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></cf_wrk_html_td>
						<cf_wrk_html_td nowrap><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></cf_wrk_html_td>
						<cf_wrk_html_td nowrap><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
						<cf_wrk_html_td align="right" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
						<cf_wrk_html_td align="right" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
						<cf_wrk_html_td align="right" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></cf_wrk_html_td>
					</cf_wrk_html_tr>
				</cfif>
			</cfif>
		</cfoutput>
	<cfelse>
		<cf_wrk_html_tr>						
			<cf_wrk_html_td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cf_wrk_html_td>
		</cf_wrk_html_tr>
	</cfif>
</cf_wrk_html_table>
</cfprocessingdirective>

