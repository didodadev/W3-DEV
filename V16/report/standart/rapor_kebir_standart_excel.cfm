<cfprocessingdirective suppresswhitespace="yes">
<cfflush interval='2000'>
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
<cfset acc_code_list = valuelist(GET_ACCOUNT_NAME_ALL.ACCOUNT_CODE,'█')> <!--- ayrac = alt+987 --->
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
<cfquery name="GET_ACCOUNT_CARD_ROWS_ALL" datasource="#DSN2#">
	SELECT 
		AC.BILL_NO, 
		AC.CARD_TYPE, 
		AC.CARD_TYPE_NO, 
		AC.RECORD_DATE, 
		--AC.CARD_DETAIL AS DETAIL,
		ACR.DETAIL AS DETAIL,
		AC.ACTION_DATE, 
		ACR.AMOUNT ,
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			ACC_P.IFRS_CODE AS ACCOUNT_ID,
		<cfelse>
			ACR.ACCOUNT_ID,
		</cfif>
		ACR.BA,
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
  			ACC_P.IFRS_CODE AS ACCOUNT_CODE,
			ACC_P.IFRS_NAME AS ACCOUNT_NAME
		<cfelse>
        ACP.ACCOUNT_NAME,
        ACP.ACCOUNT_CODE
		</cfif>
	FROM 
		ACCOUNT_CARD AC, 
		ACCOUNT_CARD_ROWS ACR 
		 <cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 0>
		LEFT JOIN ACCOUNT_PLAN ACP ON 
		ACP.ACCOUNT_CODE =ACR.ACCOUNT_ID</cfif>
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
		,ACCOUNT_PLAN ACC_P
		</cfif>
	WHERE 
		AC.CARD_ID = ACR.CARD_ID
		<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
			AND (
			<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
				(AC.CARD_TYPE = #listfirst(type_ii,'-')# AND AC.CARD_CAT_ID = #listlast(type_ii,'-')#)
				<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
			</cfloop>  
				)
		</cfif>
		<cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)><!--- ufrs bazında arama yapılacaksa --->
			AND ACR.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
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
				AND ACR.ACCOUNT_ID <= '#attributes.code2#' <!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
			</cfif>	
		</cfif>
		<cfif isdefined("attributes.date1") and len(attributes.date1)>
			AND AC.ACTION_DATE >= #attributes.date1#
		</cfif>
		<cfif isdefined("attributes.date2") and len(attributes.date2)>
			AND AC.ACTION_DATE <= #attributes.date2#
		</cfif>		
	ORDER BY 
		ACR.ACCOUNT_ID ASC,
		AC.BILL_NO
</cfquery>
<cfset satir_sayisi = 0>
<cfset filename = "kebir_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
	<cfparam name="attributes.totalrecords" default="#get_account_id.recordcount#">
    <cf_wrk_html_table cellpadding="2" cellspacing="1" border="0" width="98%" table_draw_type="1" filename="#filename#" is_auto_page_break="0" is_auto_sheet_break="0" font_size_1="#attributes.fontsize#" font_size_2="#attributes.bigfontsize#" font_style_1="#attributes.fontfamily#" font_style_2="#attributes.bigfontfamily#">
        <cf_wrk_html_tr>
            <cfset satir_sayisi=satir_sayisi+1>
            <cf_wrk_html_td align="center" colspan="9" class="headbold"><cf_get_lang dictionary_id='47283.DEFTER-İ KEBİR'></cf_wrk_html_td>
        </cf_wrk_html_tr>
        <cfloop from="1" to="#attributes.totalrecords#" index="I">
            <cfset alacak_bakiye = 0>
            <cfset borc_bakiye = 0>
            <cfset bakiye = 0>
            <cfquery name="GET_ACCOUNT_CARD_ROWS" dbtype="query">
                SELECT 
                    *
                FROM 
                    GET_ACCOUNT_CARD_ROWS_ALL
                WHERE 
                     ACCOUNT_ID LIKE '#get_account_id.account_code[i]#%'
                ORDER BY 
                	ACCOUNT_ID,
                    ACTION_DATE,
                    BILL_NO
            </cfquery>
            <cfif (isDefined("attributes.no_process") and get_account_card_rows.recordcount) or not isDefined("attributes.no_process")>
                <!--- Hareketi Olmayan Hesaplar Gelmesin --->
                <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0>			
                    <cf_wrk_html_page_break>
                    <cfif (satir_sayisi gte page_count_)>
                        <cf_wrk_html_sheet_break>
                        <cfset satir_sayisi = satir_sayisi - page_count_>
                    </cfif>
                </cfif>
                <cfoutput>
                <cf_wrk_html_tr>
                    <cfset satir_sayisi=satir_sayisi+1>
                    <cf_wrk_html_td colspan="9" class="txtbold !important;" align="center">
                        <cf_get_lang dictionary_id='39371.Ana Hesap Kodu'> : #get_account_id.account_code[i]#<cf_get_lang dictionary_id='39372.Ana Hesap Adı'> :<cfquery name="GET_ACCOUNT_NAME" dbtype="query">SELECT ACCOUNT_NAME FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#get_account_id.account_code[i]#'</cfquery> 
						#left(GET_ACCOUNT_NAME.ACCOUNT_NAME,character_account_code)#	
                    </cf_wrk_html_td>
                </cf_wrk_html_tr>
                </cfoutput>
                <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0>			
                    <cf_wrk_html_page_break>
                    <cfif (satir_sayisi gte page_count_)>
                        <cf_wrk_html_sheet_break>
                        <cfset satir_sayisi = satir_sayisi - page_count_>
                    </cfif>
                </cfif>
                <cf_wrk_html_tr>
                    <cfset satir_sayisi=satir_sayisi+1>
                    <cf_wrk_html_td width="105"><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_td>
                    <cf_wrk_html_td width="50"><cf_get_lang dictionary_id='57946.Fiş No'></cf_wrk_html_td>
                    <cf_wrk_html_td width="60"><cf_get_lang dictionary_id='39373.Yev No'></cf_wrk_html_td>
                    <cf_wrk_html_td width="90"><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></cf_wrk_html_td>
                    <cf_wrk_html_td width="80"><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></cf_wrk_html_td>
                    <cf_wrk_html_td width="190"><cf_get_lang dictionary_id='57629.Açıklama'></cf_wrk_html_td>
                    <cf_wrk_html_td align="right" style="text-align:right;" width="80"><cf_get_lang dictionary_id='57587.Borç'></cf_wrk_html_td>
                    <cf_wrk_html_td align="right" style="text-align:right;" width="80"><cf_get_lang dictionary_id='57588.Alacak'></cf_wrk_html_td>
                    <cf_wrk_html_td align="right" style="text-align:right;" width="112"><cf_get_lang dictionary_id='57589.Bakiye'></cf_wrk_html_td>
                </cf_wrk_html_tr>
                <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0>			
                    <cf_wrk_html_page_break>
                    <cfif (satir_sayisi gte page_count_)>
                        <cf_wrk_html_sheet_break>
                        <cfset satir_sayisi = satir_sayisi - page_count_>
                    </cfif>
                </cfif>
                <cfoutput query="get_account_card_rows">
                    <cf_wrk_html_tr>
                        <cfset satir_sayisi=satir_sayisi+1>
                        <cf_wrk_html_td format="date" nowrap="nowrap">#dateformat(get_account_card_rows.action_date,dateformat_style)#</cf_wrk_html_td>
                        <cf_wrk_html_td>#card_type_no#</cf_wrk_html_td>
                        <cf_wrk_html_td>#bill_no#</cf_wrk_html_td>
                        <cf_wrk_html_td>#account_id#</cf_wrk_html_td>
                        <cf_wrk_html_td nowrap="nowrap">
                        <cfif len(ACCOUNT_NAME)>
                            #left(ACCOUNT_NAME,character_account_code)#
                        <cfelse>
                            !!<cf_get_lang dictionary_id='39375.Hesap Yok'> !!
                        </cfif>
                        </cf_wrk_html_td>
                        <cf_wrk_html_td nowrap="nowrap">#left(detail,character_detail)#</cf_wrk_html_td>
                        <cfif BA><!---alacak --->
                            <cfset alacak_bakiye = alacak_bakiye + AMOUNT>
                            <cf_wrk_html_td align="right" style="text-align:right;"></cf_wrk_html_td>
                            <cf_wrk_html_td align="right" style="text-align:right;" format="numeric">#TLFormat(AMOUNT)#</cf_wrk_html_td>
                        <cfelse><!--- borc --->
                            <cfset borc_bakiye = borc_bakiye + AMOUNT>
                            <cf_wrk_html_td align="right" style="text-align:right;" format="numeric">#TLFormat(AMOUNT)#</cf_wrk_html_td>
                            <cf_wrk_html_td align="right" style="text-align:right;"></cf_wrk_html_td>
                        </cfif>
                        <cf_wrk_html_td align="right" style="text-align:right;"><cfif borc_bakiye gt alacak_bakiye><cfset bakiye = borc_bakiye - alacak_bakiye>#TlFormat(bakiye)#(B)<cfelse><cfset bakiye = alacak_bakiye - borc_bakiye>#TlFormat(bakiye)#(A)</cfif></cf_wrk_html_td>
                    </cf_wrk_html_tr>	
                    <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0>			
                        <cf_wrk_html_page_break>
                        <cfif (satir_sayisi gte page_count_)>
                            <cf_wrk_html_sheet_break>
                            <cfset satir_sayisi = satir_sayisi - page_count_>
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
<cfsetting enablecfoutputonly="no">
</cfprocessingdirective>
