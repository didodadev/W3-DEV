<cfset filename = "00#attributes.page#_#replace(date1,'/','-','all')#_#replace(date2,'/','-','all')#_#createuuid()#">
<cfprocessingdirective suppresswhitespace="yes">
<cfflush interval='2000'>
<cfquery name="check_table" datasource="#dsn2#">
	IF EXISTS (select * from tempdb.sys.tables where name='####GET_ACCOUNT_ID_#session.ep.userid#' )
	drop table ####GET_ACCOUNT_ID_#session.ep.userid#   
</cfquery>

<cfquery name="GET_ACCOUNT_ID" datasource="#DSN2#">
	SELECT
		ACCOUNT_CODE, 
		ACCOUNT_NAME ,
        ACCOUNT_ID
	INTO ####GET_ACCOUNT_ID_#session.ep.userid#   
    FROM 
		 (
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
         ) AS GET_ACCOUNT_NAME_ALL 
	WHERE 
		ACCOUNT_CODE NOT LIKE '%.%' 
	ORDER BY 
		ACCOUNT_CODE
</cfquery>
<cfquery name="chceck_GET_ACCOUNT_CARD_ROWS_ALL" datasource="#DSN2#">
	IF EXISTS(select * from tempdb.sys.tables where name= '####GET_ACCOUNT_CARD_ROWS_ALL_#session.ep.userid#' )
    	DROP TABLE ####GET_ACCOUNT_CARD_ROWS_ALL_#session.ep.userid#
</cfquery>
<cfquery name="INSERT_GET_ACCOUNT_CARD_ROWS_ALL" datasource="#DSN2#">
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
        ACR.CARD_ROW_ID,
        GET_ACCOUNT_ID.ACCOUNT_NAME,
        GET_ACCOUNT_ID.	ACCOUNT_CODE
    INTO ####GET_ACCOUNT_CARD_ROWS_ALL_#session.ep.userid#
    FROM 
		ACCOUNT_CARD AC, 
		ACCOUNT_CARD_ROWS ACR  LEFT JOIN ####GET_ACCOUNT_ID_#session.ep.userid# AS GET_ACCOUNT_ID   ON 
        (ACR.ACCOUNT_ID  LIKE  GET_ACCOUNT_ID.ACCOUNT_CODE +'.%' OR ACR.ACCOUNT_ID = GET_ACCOUNT_ID.ACCOUNT_CODE)
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
    	LEFT(ACR.ACCOUNT_ID,3),
        AC.ACTION_DATE,
		ACR.ACCOUNT_ID ASC,
		AC.BILL_NO,
        ACR.BA,
        ACR.CARD_ROW_ID
</cfquery>
<cfset satir_sayisi = 0>
<cfif not DirectoryExists("#upload_folder#account/fintab/#session.ep.userid#")>
    <cfdirectory action="create" directory="#upload_folder#account/fintab/#session.ep.userid#">
</cfif>
<cfdocument format="pdf" filename="#upload_folder#account/fintab/#session.ep.userid#/#filename#.pdf" fontembed="yes" orientation="portrait" backgroundvisible="false" pagetype="#ListFirst(attributes.pagetype,';')#" unit="cm" pageheight="#ListGetAt(attributes.pagetype,2,';')#" pagewidth="#ListGetAt(attributes.pagetype,3,';')#" marginleft="0" marginright="0">
	<cfoutput><style type="text/css">.tr{font-size:#attributes.fontsize#;font-family:#attributes.fontfamily#; font-style:normal;}</style></cfoutput>
    <table cellpadding="2" cellspacing="1" border="0" width="98%" style="margin-left:10px;">
        <tr class="tr">
            <td align="center" colspan="9"><strong><cf_get_lang dictionary_id='47283.DEFTER-İ KEBİR'></strong></td>
        </tr>
        <cfset alacak_bakiye = 0>
        <cfset borc_bakiye = 0>
        <cfset bakiye = 0>
        <cfquery name="get_account_card_rows" datasource="#DSN2#">
              WITH CTE1 AS (
                    SELECT 
                        gac.* ,
                         account_plan.ACCOUNT_NAME AS ACCOUNT_NAME_EX
                    FROM 
                        ####GET_ACCOUNT_CARD_ROWS_ALL_#session.ep.userid#  gac
                        JOIN account_plan ON account_plan.ACCOUNT_CODE = GAC.ACCOUNT_ID
                    ),
                        CTE2 AS (
                            SELECT
                                CTE1.*,
                                    ROW_NUMBER() OVER ( ORDER BY 
                                                            LEFT(ACCOUNT_ID,3), ACTION_DATE, ACCOUNT_ID,BILL_NO, BA, CARD_ROW_ID
                    ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                            FROM
                                CTE1
                        )
                        SELECT
                            CTE2.*
                        FROM
                            CTE2
        </cfquery>
        
        <cfif (isDefined("attributes.no_process") and get_account_card_rows.RECORDCOUNT) or not isDefined("attributes.no_process")>
            <!--- Hareketi Olmayan Hesaplar Gelmesin --->
            <cfoutput query="get_account_card_rows">
                <cfif (currentrow eq 1) or( ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow-1])>
                    <tr class="tr">
                        <cfset satir_sayisi=satir_sayisi+1>
                        <td colspan="9">
                            <strong><cf_get_lang dictionary_id='39371.Ana Hesap Kodu'> : </strong>#ACCOUNT_CODE#&nbsp;&nbsp;
                            <strong><cf_get_lang dictionary_id='39372.Ana Hesap Adı'> : </strong> #left(ACCOUNT_NAME,character_account_code)#
                        </td>
                    </tr>
                </cfif>
                <cfif (currentrow eq 1) or( ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow-1])>
                    <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
                     </table>
                        <cfdocumentitem type="pagebreak"/>
                        <table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
                    </cfif>
                </cfif>
                <cfif (currentrow eq 1) or( ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow-1])>
                    <tr class="tr">
                        <cfset satir_sayisi=satir_sayisi+1>
                        <td><cf_get_lang dictionary_id='57742.Tarih'></td>
                        <td width="40"><cf_get_lang dictionary_id='57946.Fiş No'></td>
                        <td nowrap="nowrap"><cf_get_lang dictionary_id='39373.Yev No'></td>
                        <td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38848.UFRS Hesap Kodu'><cfelse><cf_get_lang dictionary_id='38889.Hesap Kodu'></cfif></td>
                        <td><cfif attributes.acc_code_type eq 1><cf_get_lang dictionary_id='38849.UFRS Hesap Adı'><cfelse><cf_get_lang dictionary_id='38890.Hesap Adı'></cfif></td>
                        <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                        <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57587.Borç'></td>
                        <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'></td>
                        <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57589.Bakiye'></td>
                    </tr>
                </cfif>
                <cfif (currentrow eq 1) or( ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow-1])>
                    <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
                        </table>
                        <cfdocumentitem type="pagebreak"/>
                        <table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
                    </cfif>
                </cfif>
                <tr class="tr">
                    <cfset satir_sayisi=satir_sayisi+1>
                    <td>#dateformat(get_account_card_rows.action_date,dateformat_style)#</td>
                    <td>#card_type_no#</td>
                    <td>#bill_no#</td>
                    <td>#account_id#</td>
                    <td nowrap>
                    <cfif LEN(ACCOUNT_NAME_EX)>
                        #left(ACCOUNT_NAME_EX,attributes.character_account_code)#
                    <cfelse>
                        <font color="FF0000">!!<cf_get_lang dictionary_id='39375.Hesap Yok'> !!</font>
                    </cfif>
                    </td>
                    <td nowrap>#left(detail,character_detail)#</td>
                    
                        <cfif isdefined("session.ep.ACCOUNT_CODE_1") and (currentrow eq 1) and (session.ep.ACCOUNT_CODE_1 eq ACCOUNT_CODE)>
                           <cfset bakiye = session.ep.bakiye_1>
                           <cfset borc_bakiye = session.ep.borc_bakiye_1>
                           <cfset alacak_bakiye = session.ep.alacak_bakiye_1>
                        </cfif>
                    
                    <cfif BA><!---alacak --->
                        <cfset alacak_bakiye = alacak_bakiye + AMOUNT>
                        <td align="right" style="text-align:right;">&nbsp;</td>
                        <td align="right" style="text-align:right;">#TLFormat(AMOUNT)#</td>
                    <cfelse><!--- borc --->
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
                    <cfif currentrow eq get_account_card_rows.recordcount>
                        <cfif query_count gt rownum>
                            <cfset session.ep.ACCOUNT_CODE_1 = ACCOUNT_CODE>
                            <cfset session.ep.bakiye_1 = bakiye > 
                            <cfset session.ep.borc_bakiye_1 =borc_bakiye >
                            <cfset session.ep.alacak_bakiye_1=alacak_bakiye > 
                        </cfif>
                    </cfif>
                    
                    <cfif ( ACCOUNT_CODE neq ACCOUNT_CODE[curRentrow+1])>
                        <cfset bakiye = 0 >
                        <cfset borc_bakiye = 0 >
                        <cfset alacak_bakiye = 0 >
                    </cfif>
                    </td>
                </tr>
                <cfif len(attributes.pdf_page_row) and attributes.pdf_page_row neq 0 and (satir_sayisi mod attributes.pdf_page_row) eq 0><!--- satır sayısı belirtilmisse sayfalama yapılıyor --->
                    </table>
                    <cfdocumentitem type="pagebreak"/>
                    <table cellpadding="2" cellspacing="1" border="0" width="98%" class="table">
                </cfif>
                <cfset son_satir = rownum > 
            </cfoutput>
        </cfif>
    </table>
</cfdocument>

<cfif get_account_card_rows.recordcount gt 0>
	<cfif GET_ACCOUNT_CARD_ROWS.query_count eq son_satir>
        <cfif not DirectoryExists("#upload_folder#account/fintab/#session.ep.userid#_zip")>
            <cfdirectory action="create" directory="#upload_folder#account/fintab/#session.ep.userid#_zip">
        </cfif>
		<cfscript>ZipFileNew(zipPath:expandPath("/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#"),toZip:expandPath("/documents/account/fintab/#session.ep.userid#"),relativeFrom:'#upload_folder#');</cfscript>
        <script>
             document.getElementById('page').value = 1 ;
			get_wrk_message_div("<cfoutput>#getLang('main',1931)#</cfoutput>","PDF","<cfoutput>/documents/account/fintab/#session.ep.userid#_zip/#zip_filename#</cfoutput>");
        </script>
    </cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57936.Seçtiğiniz kriterlere uygun kayıt bulunamadı'>");
	</script>
</cfif>
</cfprocessingdirective>
