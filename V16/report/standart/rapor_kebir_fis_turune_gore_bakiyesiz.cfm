<cfsetting showdebugoutput="no" requesttimeout="60000">
<cfset filename = "#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
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
	WHERE
		LEN(ACCOUNT_CODE) > 2 
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			<cfif isdefined('attributes.CODE1') and len(attributes.CODE1)>
				AND IFRS_CODE >= '#attributes.CODE1#'
			</cfif>
			<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
				AND IFRS_CODE <= '#attributes.CODE2#' 
			</cfif>
		<cfelse>
			<cfif isdefined('attributes.CODE1') and len(attributes.CODE1)>
				AND (ACCOUNT_CODE >= '#attributes.CODE1#' OR ACCOUNT_CODE = '#left(attributes.CODE1,3)#')
			</cfif>
			<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
				AND (ACCOUNT_CODE <= '#attributes.CODE2#' OR ACCOUNT_CODE = '#left(attributes.CODE2,3)#') 
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
		AC.CARD_DETAIL AS DETAIL,
		AC.ACTION_DATE, 
		ACR.AMOUNT,
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
<cfdocument format="pdf" filename="#upload_folder#account/fintab/#filename#.pdf" fontembed="yes" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="1" marginright="0">
<cfoutput><style type="text/css">.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
<table cellpadding="2" cellspacing="1" border="0" width="98%">
	<cfoutput>
	<tr class="tr">
		<td colspan="6" align="left"><cfoutput>#session.ep.company# (#session.ep.period_year#)</cfoutput></td>
	</tr>
	</cfoutput>
	<tr class="tr">
		<td colspan="6" align="center"><font size="2"><cf_get_lang dictionary_id ='39163.DEFTER-İ KEBİR'></font></td>
	</tr>

<cfparam name="attributes.totalrecords" default="#get_account_id.recordcount#">
<cfloop from="1" to="#attributes.totalrecords#" index="I">
	<cfset row_count = 0>
	<cfquery name="get_acc_total" datasource="#dsn2#">
		SELECT 
			SUM(AMOUNT_TOTAL) AMOUNT_TOTAL,
			BA
		FROM
			(
			SELECT 
				SUM(AMOUNT) AS AMOUNT_TOTAL,
				BA,
				ACTION_DATE
			FROM
				<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
					ACCOUNT_PLAN ACC_P,
				</cfif>
				GET_ACCOUNT_CARD
			WHERE
				ACTION_DATE < #attributes.date1#
				<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
					AND (
					<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
						(GET_ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND GET_ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
						<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>
				<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
					AND GET_ACCOUNT_CARD.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
					AND ACC_P.IFRS_CODE LIKE '#get_account_id.account_code[i]#%'
					<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
						AND ACC_P.IFRS_CODE <= '#attributes.CODE2#'
					</cfif>
				<cfelse>
					AND ACCOUNT_ID LIKE '#get_account_id.account_code[i]#%'
					<cfif isdefined('attributes.CODE2') and len(attributes.CODE2)>
						AND ACCOUNT_ID <= '#attributes.CODE2#'
					</cfif>
				</cfif>	
			GROUP BY 
				ACTION_DATE,
				BA
			) AA
		GROUP BY BA
	</cfquery>
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
		<cfif get_acc_total.recordcount or get_account_card_rows.recordcount>
		<cfif i neq 1 and (get_account_id.account_code[i] neq get_account_id.account_code[i-1]) and get_acc_total.recordcount>
			</table>
				<cfdocumentitem type="pagebreak"/>
			<table cellpadding="2" cellspacing="1" border="0" width="98%">
		</cfif>
		<cfoutput>
		<tr class="tr">
			<td colspan="6">
				<strong><cf_get_lang dictionary_id ='38889.Hesap Kodu'> : </strong>&nbsp;&nbsp;#get_account_id.account_code[i]#&nbsp;&nbsp;<br/>
				<strong><cf_get_lang dictionary_id ='38890.Hesap Adı'> : </strong>&nbsp;&nbsp;
				<cfquery name="GET_ACCOUNT_NAME" dbtype="query">
					SELECT ACCOUNT_NAME FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#get_account_id.account_code[i]#'
				</cfquery>	
				#left(get_account_name.account_name,character_account_code)#<br/><br/>
			</td>
		</tr>
		</cfoutput>
		<tr class="tr">
			<cfset row_count = row_count+1>
			<td width="70"><cf_get_lang dictionary_id ='57742.Tarih'></td>
			<td width="90"><cf_get_lang dictionary_id ='58651.TÜRÜ'></td>
            <td width="40"><cf_get_lang dictionary_id ='57946.Fiş No'></td>
			<td width="70"><cf_get_lang dictionary_id ='38882.MADDE NO'></td>
			<td width="180"><cf_get_lang dictionary_id='57629.AÇIKLAMA'></td>
			<td align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57587.BORÇ'></td>
			<td align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57588.ALACAK'></td>
		</tr>
		<cfscript>
			alacak_bakiye = 0;
			borc_bakiye = 0;
			bakiye = 0;
			devir_borc = 0;
			devir_alacak =0;
		</cfscript>
		<cfif get_acc_total.recordcount><!--- hesabın, baslangıc tarihinden onceki doneme ait bakiyesi varsa --->
			<tr class="tr">
				<cfset row_count = row_count+1>
				<td colspan="3">&nbsp;</td>
				<td align="left"><strong><cf_get_lang dictionary_id='38878.Devreden Toplam'></strong></td>
				<cfoutput query="get_acc_total">
					<cfif BA eq 0><cfset devir_borc = AMOUNT_TOTAL></cfif>
					<cfif BA eq 1><cfset devir_alacak = AMOUNT_TOTAL></cfif>
				</cfoutput>
				<td align="right" style="text-align:right;"><cfif devir_borc neq 0><cfset borc_bakiye = borc_bakiye + devir_borc><strong><cfoutput>#TLFormat(devir_borc)#</cfoutput></strong><cfelse>&nbsp;</cfif></td>
				<td align="right" style="text-align:right;"><cfif devir_alacak neq 0><cfset alacak_bakiye = alacak_bakiye + devir_alacak><strong><cfoutput>#TLFormat(devir_alacak)#</cfoutput></strong><cfelse>&nbsp;</cfif></td>
			</tr>
		</cfif>
		<cfif get_account_card_rows.recordcount>
		<cfoutput query="get_account_card_rows">
			<tr class="tr">
				<cfset row_count = row_count+1>
				<td>#dateformat(get_account_card_rows.action_date,'dd.mm.yyyy')#&nbsp;</td>
				<td><cfset TYPE_NO=get_account_card_rows.CARD_TYPE_NO>
					<cfswitch expression="#CARD_TYPE#">
						<cfcase value="10"><cfset TYPE = 'AÇILIŞ'><cfset TYPE_NO = 1 ></cfcase>
						<cfcase value="11"><cfset TYPE = 'TAHSİL'></cfcase>
						<cfcase value="12"><cfset TYPE = 'TEDİYE'></cfcase>
						<cfcase value="13,14"><cfset TYPE = 'MAHSUP'></cfcase>
						<cfcase value="19"><cfset TYPE = 'KAPANIS'></cfcase>
					</cfswitch>
					#TYPE#
				</td>
                <td>#card_type_no#</td>
				<td>#bill_no#</td>
				<td nowrap>#left(DETAIL,character_detail)#</td>
				<cfif BA > <!--- eq 1 : alacak --->
					<cfset alacak_bakiye = alacak_bakiye + amount>
					<td align="right" style="text-align:right;">&nbsp;</td>
					<td align="right" style="text-align:right;">#TLFormat(amount)#&nbsp;</td>
				<cfelse> <!--- borc --->
					<cfset borc_bakiye = borc_bakiye + amount>
					<td align="right" style="text-align:right;">#TLFormat(amount)#&nbsp;</td>
					<td align="right" style="text-align:right;">&nbsp;</td>
				</cfif>
			</tr>
			<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (row_count neq 1 and ((row_count mod attributes.pdf_page_row) eq 0)) or currentrow eq get_account_card_rows.recordcount> <!--- yeni hesap baslayacaksa veya pdf sayfa satır sayı tamamlanmıssa yeni sayfaya gecilir --->
				<tr class="tr">
					<td colspan="3">&nbsp;</td>
					<td align="left"><strong><cf_get_lang dictionary_id ='39183.Sayfa Toplam'></strong></td>
					<td align="right" style="text-align:right;">#TLFormat(borc_bakiye)#&nbsp;</td>
					<td align="right" style="text-align:right;">#TLFormat(alacak_bakiye)#&nbsp;</td>
				</tr>
				<cfif currentrow neq get_account_card_rows.recordcount><!--- son hesabın son kaydı degilse yeni sayfaya gecsin --->
					</table>
					<cfdocumentitem type="pagebreak"/>
					<table cellpadding="2" cellspacing="1" border="0" width="98%">
					<tr class="tr">
						<td colspan="6" align="left">#session.ep.company# (#session.ep.period_year#)</td>
					</tr>
					<tr class="tr">
						<td colspan="6" align="center"><font size="2"><cf_get_lang dictionary_id ='39163.DEFTER-İ KEBİR'></font></td>
					</tr>
					<tr class="tr">
						<cfset row_count = row_count+1>
						<td colspan="6">
							<strong><cf_get_lang dictionary_id ='38889.Hesap Kodu'> : </strong>&nbsp;&nbsp;#get_account_id.account_code[i]#&nbsp;&nbsp;<br/>
							<strong><cf_get_lang dictionary_id ='38890.Hesap Adı'> : </strong>&nbsp;&nbsp;
							<cfquery name="GET_ACCOUNT_NAME" dbtype="query">
								SELECT ACCOUNT_NAME FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#get_account_id.account_code[i]#'
							</cfquery>	
							#left(get_account_name.account_name,character_account_code)#<br/><br/>
						</td>
					</tr>
					<tr class="tr">
						<cfset row_count = row_count+1>
						<td width="70"><cf_get_lang dictionary_id ='57742.Tarih'></td>
						<td width="90"><cf_get_lang dictionary_id ='58651.TÜRÜ'></td>
                        <td width="40"><cf_get_lang dictionary_id ='57946.Fiş No'></td>
						<td width="70"><cf_get_lang dictionary_id ='38882.MADDE NO'></td>
						<td width="180"><cf_get_lang dictionary_id ='57629.AÇIKLAMA'></td>
						<td align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57587.BORÇ'></td>
						<td align="right" style="text-align:right;"><cf_get_lang dictionary_id ='57588.ALACAK'></td>
					</tr>
					<tr class="tr">
						<td colspan="3">&nbsp;</td>
						<td align="left"><strong><cf_get_lang dictionary_id='38876.Önceki Sayfa Toplam'></strong></td>
						<td align="right" style="text-align:right;">#TLFormat(borc_bakiye)#&nbsp;</td>
						<td align="right" style="text-align:right;">#TLFormat(alacak_bakiye)#&nbsp;</td>
					</tr>
				</cfif>
			</cfif>
		</cfoutput>
		</cfif>
	</cfif>
	</cfif>
</cfloop>
</table>
</cfdocument>
</cfprocessingdirective>
<script>
	get_wrk_message_div("<cfoutput>#getLang('main',1931)#</cfoutput>","PDF","<cfoutput>/documents/account/fintab/#filename#.pdf</cfoutput>");
</script>
