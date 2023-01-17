<cfset filename = "00#attributes.page#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
<cfprocessingdirective suppresswhitespace="yes">
<cfquery name="check_table" datasource="#dsn#">
	IF EXISTS (select * from tempdb.sys.tables where name='####GET_ACCOUNT_ID_#session.ep.userid#' )
	 drop table ####GET_ACCOUNT_ID_#session.ep.userid#   
</cfquery>

<cfquery name="get_account_id" datasource="#dsn2#">
  SELECT
	  ACCOUNT_CODE, 
	  ACCOUNT_NAME 
  INTO ####GET_ACCOUNT_ID_#session.ep.userid#
  FROM 
	  (
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
      ) as GET_ACCOUNT_NAME 
  WHERE 
	  ACCOUNT_CODE NOT LIKE '%.%' 
  ORDER BY 
	  ACCOUNT_CODE
</cfquery>
<cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" fontembed="yes" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="1" marginright="0">
<cfoutput><style type="text/css">.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
<!---<cfparam name="attributes.totalrecords" default="#get_account_id.recordcount#">--->
<table cellpadding="2" cellspacing="1" border="0" width="98%">
	<tr class="tr">
		<td colspan="8" align="center"><strong><cf_get_lang dictionary_id ='39163.DEFTER-İ KEBİR'></strong></td>
	</tr>
	<!---<cfloop from="1" to="#attributes.totalrecords#" index="I">--->
		<cfset row_count = 0><!--- ana hesaplarda yeni sayfaya gecildiginden satır sayısı sıfırlanıyor --->
		<cfif attributes.page eq 1>
        	<cfquery name="CHECK_TABLE" datasource="#dsn2#">
                IF EXISTS(select * from tempdb.sys.tables where name = '####get_account_card_rows_#session.ep.userid#' )
                DROP TABLE ####get_account_card_rows_#session.ep.userid#
            </cfquery>
            <cfquery name="add_get_account_card_rows" datasource="#dsn2#" result="XXX">
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
				ACR.BA,
                GET_ACCOUNT_ID.ACCOUNT_NAME,
                GET_ACCOUNT_ID.	ACCOUNT_CODE
			 INTO ####get_account_card_rows_#session.ep.userid#
            FROM 
				ACCOUNT_CARD AC, 
				ACCOUNT_CARD_ROWS ACR JOIN ####GET_ACCOUNT_ID_#session.ep.userid# as GET_ACCOUNT_ID ON 
                (ACR.ACCOUNT_ID  LIKE  GET_ACCOUNT_ID.ACCOUNT_CODE +'.%' OR ACR.ACCOUNT_ID = GET_ACCOUNT_ID.ACCOUNT_CODE)
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
					AND ACR.ACCOUNT_ID=ACC_P.ACCOUNT_CODE
					<cfif isDefined("attributes.CODE2") and len(attributes.CODE2)>
						AND ACC_P.IFRS_CODE <= '#attributes.CODE2#'<!--- 20051026 tek bir hesabin muavinleri cekilirken hepsi secilmezse sorun olmasin diye --->
					</cfif>
				<cfelse>
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
				AC.BILL_NO,
				ACR.ACCOUNT_ID
            </cfquery>
        </cfif>
        
        <cfquery name="get_account_card_rows" datasource="#dsn2#">
        WITH CTE1 AS (
                            SELECT 
                                GAC.*,
                                 account_plan.ACCOUNT_NAME AS ACCOUNT_NAME_EX
                            FROM 
                                ####get_account_card_rows_#session.ep.userid# GAC JOIN account_plan ON account_plan.ACCOUNT_CODE = GAC.ACCOUNT_ID
                            ),
                                CTE2 AS (
                                    SELECT
                                        CTE1.*,
                                            ROW_NUMBER() OVER ( ORDER BY 
                                                                	ACCOUNT_ID,ACTION_DATE,BILL_NO
                            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                                    FROM
                                        CTE1
                                )
                                SELECT
                                    CTE2.*
                                FROM
                                    CTE2
                                WHERE
                                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
		</cfquery>
		<cfif (isDefined("attributes.no_process") and get_account_card_rows.recordcount) or not isDefined("attributes.no_process")>
			<!--- Hareketi Olmayan Hesaplar Gelmesin --->
			<cfparam  name="alacak_bakiye" default="0">
            <cfparam  name="borc_bakiye" default="0">
            <cfparam  name="bakiye" default="0">
			<cfoutput query="get_account_card_rows">
			<cfif (currentrow eq 1) or( ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow-1])>
                <tr class="tr">
                    <cfset row_count = row_count+1>
                    <td colspan="8"><strong><cf_get_lang dictionary_id ='39371.Ana Hesap Kodu'> :</strong>#ACCOUNT_CODE#&nbsp;&nbsp;&nbsp; <strong><cf_get_lang dictionary_id ='39372.Ana Hesap Adı'> :</strong> #left(ACCOUNT_NAME,character_account_code)#</td>
                </tr>
                <tr class="tr">
                    <cfset row_count = row_count+1>
                    <td><cf_get_lang dictionary_id='57742.Tarih'></td>
                    <td><cf_get_lang dictionary_id='39373.Yev No'></td>
                    <td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></td>
                    <td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></td>
                    <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                    <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
                    <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
                    <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='38873.Borç Bakiye'></td>
                    <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='38875.Alacak Bakiye'></td>
                </tr>
            <cfif page gt 1>
               <cfif session.ep.ACCOUNT_CODE_ eq ACCOUNT_CODE>
				   <cfset bakiye = session.ep.bakiye_>
                   <cfset borc_bakiye = session.ep.borc_bakiye_>
                   <cfset alacak_bakiye = session.ep.alacak_bakiye_>
                <tr class="tr">
                    <td colspan="5" align="center"><strong><cf_get_lang dictionary_id='38876.Önceki Pdf Toplam'></strong></td>
                    <td align="right" style="text-align:right;">#TLFormat(session.ep.borc_bakiye_)#&nbsp;</td>
                    <td align="right" style="text-align:right;">#TLFormat(session.ep.alacak_bakiye_)#&nbsp;</td>
                    <td align="right" style="text-align:right;"><cfif session.ep.borc_bakiye_ gt session.ep.alacak_bakiye_>#TLFormat(session.ep.bakiye_)#&nbsp;</cfif> </td>
                    <td align="right" style="text-align:right;"><cfif session.ep.borc_bakiye_ lt session.ep.alacak_bakiye_>#TLFormat(session.ep.bakiye_)#&nbsp;</cfif></td>
                </tr>
               </cfif> 
            </cfif>      
            </cfif>
				<tr class="tr"><!--- style="font:'Courier New', Courier, mono;font-size:15px" --->
					<cfset row_count = row_count+1>
					<td>#dateformat(get_account_card_rows.ACTION_DATE,'dd.mm.yyyy')#&nbsp;</td>
					<td>#BILL_NO#</td>
					<td>#ACCOUNT_ID#</td>
					<td nowrap>
					<cfif len(ACCOUNT_ID)>
						#left(ACCOUNT_NAME_EX,character_account_code)# 
					<cfelse>
						 <font color="FF0000">!! <cf_get_lang dictionary_id ='39375.Hesap Yok'> !!</font>
					</cfif>
					</td>
					<td nowrap>#left(detail,character_detail)#</td>
					<cfif BA> <!--- alacak --->
						<cfset alacak_bakiye = alacak_bakiye + AMOUNT>
						<td align="right" style="text-align:right;">&nbsp;</td>
						<td align="right" style="text-align:right;">#TLFormat(AMOUNT)#&nbsp;</td>
					<cfelse> <!--- borc --->
						<cfset borc_bakiye = borc_bakiye + AMOUNT>
						<td align="right" style="text-align:right;">#TLFormat(AMOUNT)#&nbsp;</td>
						<td align="right" style="text-align:right;">&nbsp;</td>
					</cfif>
					<td align="right" style="text-align:right;">
						<cfif borc_bakiye gt alacak_bakiye>
							<cfset bakiye = borc_bakiye - alacak_bakiye>
							#TlFormat(bakiye)#
						</cfif>
					</td>
					<td align="right" style="text-align:right;">
						<cfif borc_bakiye lte alacak_bakiye>
							<cfset bakiye = alacak_bakiye - borc_bakiye>
							#TlFormat(bakiye)#
						</cfif>
					</td>
				</tr>
				<cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (row_count neq 1 and ((row_count mod attributes.pdf_page_row) eq 0)) or ((ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow+1]))> <!--- yeni hesap baslayacaksa veya pdf sayfa satır sayı tamamlanmıssa yeni sayfaya gecilir --->
					<tr class="tr">
						<cfset row_count = row_count+1>
						<td colspan="5" align="center"><strong><cf_get_lang dictionary_id ='39183.Sayfa Toplam'> </strong></td>
						<td align="right" style="text-align:right;"><strong>#TLFormat(borc_bakiye)#</strong>&nbsp;</td>
						<td align="right" style="text-align:right;"><strong>#TLFormat(alacak_bakiye)#</strong>&nbsp;</td>
						<td align="right" style="text-align:right;">
							<cfif borc_bakiye gt alacak_bakiye>
								<cfset bakiye = borc_bakiye - alacak_bakiye>
								<strong>#TlFormat(bakiye)#</strong>
							</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif borc_bakiye lte alacak_bakiye>
								<cfset bakiye = alacak_bakiye - borc_bakiye>
								<strong>#TlFormat(bakiye)#</strong>
							</cfif>
						</td>
					</tr>
					</table>
					<cfdocumentitem type="pagebreak"/>
					<table cellpadding="2" cellspacing="1" border="0" width="98%">
					<cfif ( ACCOUNT_CODE eq ACCOUNT_CODE[curRentrow+1])>
						<tr class="tr">
							<cfset row_count = row_count+1>
							<td><cf_get_lang dictionary_id='57742.Tarih'></td>
							<td><cf_get_lang dictionary_id='39373.Yev No'></td>
							<td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></td>
							<td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></td>
							<td><cf_get_lang dictionary_id='57629.Açıklama'></td>
							<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
							<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
							<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='38873.Borç Bakiye'></td>
							<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='38875.Alacak Bakiye'></td>
						</tr>
						<tr class="tr">
							<td colspan="5" align="center"><strong><cf_get_lang dictionary_id='38876.Önceki Sayfa Toplam'></strong></td>
							<td align="right" style="text-align:right;">#TLFormat(borc_bakiye)#&nbsp;</td>
							<td align="right" style="text-align:right;">#TLFormat(alacak_bakiye)#&nbsp;</td>
                            <td><cfif borc_bakiye gt alacak_bakiye>#TLFormat(bakiye)#</cfif> </td>
                            <td><cfif alacak_bakiye gt borc_bakiye>#TLFormat(bakiye)#</cfif> </td>
						</tr>
					</cfif>
				</cfif>
				<cfif currentrow eq get_account_card_rows.recordcount>
                	<cfif query_count gt rownum>
                    	<cfset session.ep.ACCOUNT_CODE_ = ACCOUNT_CODE>
                        <cfset session.ep.alacak_bakiye_ = alacak_bakiye>
                        <cfset session.ep.borc_bakiye_ = borc_bakiye>
                        <cfset session.ep.bakiye_ = bakiye > 
                    </cfif>
                </cfif>
				<cfif (ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow+1])>
                    <cfset alacak_bakiye = 0>
                    <cfset borc_bakiye = 0>
                    <cfset bakiye = 0>
                </cfif>
                <cfset son_satir = rownum > 
			</cfoutput>
			
		</cfif>
<!---	</cfloop>--->
</table>
</cfdocument>
</cfprocessingdirective>

<cfif get_account_card_rows.recordcount gt 0>
	<cfif  GET_ACCOUNT_CARD_ROWS.query_count gt son_satir>
        <cfscript>ZipFileNew(zipPath:expandPath("/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#"),toZip:expandPath("/documents/account/fintab/#session.ep.userid#"),relativeFrom:'#upload_folder#');</cfscript>
        <script>
			 document.getElementById('page').value = 1 ;
			get_wrk_message_div("<cfoutput>#getLang('main',1931)#</cfoutput>","PDF","<cfoutput>/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#</cfoutput>");
		</script>
	
	</cfif>
	<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>..");
	</script>
</cfif>
