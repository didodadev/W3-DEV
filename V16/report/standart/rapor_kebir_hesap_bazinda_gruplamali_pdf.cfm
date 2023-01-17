<cfsetting showdebugoutput="no" requesttimeout="7200">
<cfset filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#">
<cfprocessingdirective suppresswhitespace="yes">
<cfset pdf_page_row = 75>
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
		AC.RECORD_DATE, 
		AC.CARD_DETAIL AS DETAIL,
		AC.ACTION_DATE, 
		SUM(ACR.AMOUNT) AS AMOUNT,
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
			AND ACR.ACCOUNT_ID <= '#attributes.code2#'<!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
		</cfif>	
	</cfif>
	<cfif isdefined("attributes.date1") and len(attributes.date1)>
		AND AC.ACTION_DATE >= #attributes.date1#
	</cfif>
	<cfif isdefined("attributes.date2") and len(attributes.date2)>
		AND AC.ACTION_DATE <= #attributes.date2#
	</cfif>
	GROUP BY
		ACR.ACCOUNT_ID,
		AC.ACTION_DATE,
		AC.BILL_NO, 
		AC.CARD_TYPE, 
		AC.CARD_TYPE_NO, 
		AC.RECORD_DATE, 
		AC.CARD_DETAIL,
		<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
			ACC_P.IFRS_CODE,			
		</cfif>
		ACR.BA
	ORDER BY 
		ACR.ACCOUNT_ID,
		AC.ACTION_DATE,
		AC.BILL_NO
</cfquery>
<cfset acc_list = 0>
<cfoutput query="get_account_id">
	<cfquery name="get_" dbtype="query">
		SELECT ACCOUNT_ID FROM GET_ACCOUNT_CARD_ROWS_ALL WHERE ACCOUNT_ID LIKE '#get_account_id.account_code#.%'
	</cfquery>
	<cfif get_.recordcount>
		<cfset acc_list = acc_list + 1>
	</cfif>
</cfoutput>

<cfset zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip">
<cfset file_name_list = ''>
<!--- Daha Once Kullanilan ve Isi Biten Klasorler Temizleniyor --->
<cfif not DirectoryExists("#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#")>
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#">
</cfif>
<cfif not DirectoryExists("#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip")>
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip">
<cfelse>
	<cfdirectory  action="delete" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip" recurse="yes">
	<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder##dir_seperator#account#dir_seperator#fintab#dir_seperator##session.ep.userid#_zip">
</cfif>
<!--- //Daha Once Kullanilan ve Isi Biten Klasorler Temizleniyor --->
<cfset pdf_sayisi=ceiling((get_account_card_rows_all.recordcount+(acc_list*2))/pdf_row_count)-1>
<cfloop from="0" to="#pdf_sayisi#" index="k">
	<cfset temp_pdf_row = (k+1)*pdf_row_count>
	<cfset row_count = 1>
	<cfset filename = "#k+1#_#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#">
	<cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" fontembed="yes" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="1" marginright="0">
	<cfoutput><style type="text/css">.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
	<cfset start_row = (k*pdf_row_count) + 1>
	<table cellpadding="2" cellspacing="1" border="0" width="98%">
	<tr class="tr">
		<td colspan="9" align="center"><big><big><strong><cf_get_lang dictionary_id='47283.DEFTER-İ KEBİR'></strong></big></big></td>
	</tr>	
	<cfoutput query="get_account_card_rows_all" startrow="#start_row#" maxrows="#pdf_row_count#">
		<cfif (isDefined("attributes.no_process") and get_account_card_rows_all.recordcount) or not isDefined("attributes.no_process")>
		<cfif currentrow eq 1 or (currentrow neq 1 and (listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.') neq listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')))>
			<cfif (currentrow neq 1 and (listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.') neq listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')))>
				<!--- hareket olmayan hesapların gelmesi icin duzenledi --->
				<cfquery name="get_ara_hesaplar" dbtype="query">
					SELECT 
						* 
					FROM 
						GET_ACCOUNT_ID 
					WHERE 
						ACCOUNT_CODE > '#listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')#' AND
						ACCOUNT_CODE < '#listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.')#'
				</cfquery>
				<cfquery name="get_sub" dbtype="query"><!--- Ana hesaba bagli alt hesaplar var mi --->
					SELECT * FROM GET_ACCOUNT_CARD_ROWS_ALL WHERE ACCOUNT_ID LIKE '#get_ara_hesaplar.ACCOUNT_CODE#.%'
				</cfquery>
				<cfif get_ara_hesaplar.recordcount>
					<cfloop query="get_ara_hesaplar">						
						<cfset account_count=account_count+1>
						<cfset alacak_bakiye = 0>
						<cfset borc_bakiye = 0>
						<cfset bakiye = 0>
						<cfif (isDefined("attributes.no_process") and get_sub.recordcount) or not isDefined("attributes.no_process")>
							<!--- Hareketi Olmayan Hesaplar Gelmesin --->
							<tr class="tr">
							<cfset row_count=row_count+1>
								<td colspan="9">
									<strong><cf_get_lang dictionary_id='39371.Ana Hesap Kodu'> :  </strong>#get_ara_hesaplar.account_code#&nbsp;&nbsp;
									<strong><cf_get_lang dictionary_id='39372.Ana Hesap Adı'> :</strong> 
									<cfquery name="GET_ACCOUNT_NAME" dbtype="query">
										SELECT * FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#get_ara_hesaplar.ACCOUNT_CODE#'
									</cfquery>	
									#left(get_ara_hesaplar.account_name,character_account_code)#
								</td>
							</tr>
							<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
								</table>
								<cfdocumentitem type="pagebreak"/>
								<table cellpadding="2" cellspacing="1" border="0" width="98%">
							</cfif>
							<tr class="tr">
								<cfset row_count=row_count+1>
								<td><cf_get_lang dictionary_id='57742.Tarih'></td>
								<td><cf_get_lang dictionary_id='57946.Fiş No'></td>
								<td><cf_get_lang dictionary_id='39373.Yev No'></td>
								<td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></td>
								<td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></td>
								<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
								<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
								<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
								<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></td>
							</tr>
							<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
								</table>
								<cfdocumentitem type="pagebreak"/>
								<table cellpadding="2" cellspacing="1" border="0" width="98%">
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfset alacak_bakiye = 0>
			<cfset borc_bakiye = 0>
			<cfset bakiye = 0>		
			<tr class="tr">
				<cfset row_count=row_count+1>
				<td colspan="9">
					<strong><cf_get_lang dictionary_id='39371.Ana Hesap Kodu'> :  </strong>#listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.')#&nbsp;&nbsp;<strong>
					<cf_get_lang dictionary_id='39372.Ana Hesap Adı'> :</strong> 
					<cfquery name="GET_ACCOUNT_NAME" dbtype="query">
						SELECT * FROM GET_ACCOUNT_NAME_ALL WHERE ACCOUNT_CODE = '#listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.')#'
					</cfquery>	
					#left(get_account_name.account_name,character_account_code)#
				</td>
			</tr>
			<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
				</table>
				<cfdocumentitem type="pagebreak"/>
				<table cellpadding="2" cellspacing="1" border="0" width="98%">
			</cfif>
			<tr class="tr">
				<cfset row_count=row_count+1>
				<td><cf_get_lang dictionary_id='57742.Tarih'></td>
				<td><cf_get_lang dictionary_id='57946.Fiş No'></td>
				<td><cf_get_lang dictionary_id='39373.Yev No'></td>
				<td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></td>
				<td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></td>
				<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
				<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
				<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
				<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></td>
			</tr>
		</cfif>
		<tr class="tr">
			<cfset row_count=row_count+1>
			<td>#dateformat(get_account_card_rows_all.action_date,dateformat_style)#</td>
			<td>#card_type_no#</td>
			<td>#bill_no#</td>
			<td>#account_id#</td>
			<td nowrap>
			<cfif listfind(acc_code_list,ACCOUNT_ID,'█')>
				#left(listgetat(acc_hesap_list,listfind(acc_code_list,ACCOUNT_ID,'█'),'█'),character_account_code)#
			<cfelse>
				<font color="FF0000">!!<cf_get_lang dictionary_id='39375.Hesap Yok'> !!</font>
			</cfif>
			</td>
			<td nowrap>#left(detail,character_detail)#</td>
			<cfif BA> <!--- eq 1 : alacak --->
				<cfset alacak_bakiye = alacak_bakiye + AMOUNT>
				<td align="right" style="text-align:right;">&nbsp;</td>
				<td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</td>
			<cfelse> <!--- borc --->
				<cfset borc_bakiye = borc_bakiye + AMOUNT>
				<td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</td>
				<td align="right" style="text-align:right;">&nbsp;</td>
			</cfif>
			<td align="right" style="text-align:right;">
				<cfif borc_bakiye gt alacak_bakiye>
					<cfset bakiye = borc_bakiye - alacak_bakiye>
					#TlFormat(bakiye)#(B)
				<cfelse>
					<cfset bakiye = alacak_bakiye - borc_bakiye>
					#TlFormat(bakiye)#(A)
				</cfif>
			</td>
		</tr>
		<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and row_count neq 0 and (row_count mod attributes.pdf_page_row) eq 0>
			</table>
			<cfdocumentitem type="pagebreak"/>
			<table cellpadding="2" cellspacing="1" border="0" width="98%">
			<cfif listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow],'.') eq listfirst(get_account_card_rows_all.ACCOUNT_ID[currentrow-1],'.')>
				<tr class="tr">
					<cfset row_count=row_count+1>
					<td nowrap><cf_get_lang dictionary_id='57742.Tarih'></td>
					<td nowrap><cf_get_lang dictionary_id='57946.Fiş No'></td>
					<td nowrap><cf_get_lang dictionary_id='39373.Yev No'></td>
					<td nowrap><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></td>
					<td nowrap><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></td>
					<td nowrap><cf_get_lang dictionary_id='57629.Açıklama'></td>
					<td align="right" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
					<td align="right" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
					<td align="right" nowrap style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></td>
				</tr>
			</cfif>
		</cfif>
		</cfif>
</cfoutput>
</table>
</cfdocument>
<cfset file_name_list = listappend(file_name_list,'#filename#.pdf')>
</cfloop>

<cfif GET_ACCOUNT_NAME_ALL.recordcount gt 0 and GET_ACCOUNT_CARD_ROWS_ALL.recordcount gt 0>
	<cfscript>ZipFileNew(zipPath:expandPath("/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#"),toZip:expandPath("/documents/account/fintab/#session.ep.userid#"),relativeFrom:'#upload_folder#');</cfscript>
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
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>..");
	</script>
</cfif>
</cfprocessingdirective>
