<cfif session.ep.username is 'admin1' OR session.ep.username is 'fatih'>
<cfset kasa_cikislar = "3,8,9,10,13">
<cfset kasa_cikislar_maliyetsiz = "13">
<cfset fazla_stok = "1">
<cfquery name="get_price_groups_all" datasource="workcube_gulgen_dev">
	SELECT *
    FROM
    	PRICE_TABLE
    WHERE
    	(
            YEAR(STARTDATE) = 2014 AND
            MONTH(STARTDATE) > 7 AND
            MONTH(STARTDATE) < 12
        ) AND
        IS_ACTIVE_S = 1 AND
        STARTDATE IS NOT NULL AND
        FINISHDATE IS NOT NULL AND
        PRICE_TYPE IN (#kasa_cikislar#)
</cfquery>

<cfquery name="get_price_groups" dbtype="query">
	SELECT DISTINCT STARTDATE,FINISHDATE FROM get_price_groups_all ORDER BY STARTDATE ASC,FINISHDATE DESC
</cfquery>

<TABLE cellpadding="2" cellspacing="0" border="1">
<CFOUTPUT query="get_price_groups">
	<cfset gun_ilk_ = STARTDATE>
    <cfset gun_son_ = FINISHDATE>
  <TR><TD colspan="12" bgcolor="##33FFCC">#dateformat(STARTDATE,'dd/mm/yyyy')# #dateformat(FINISHDATE,'dd/mm/yyyy')# tarihli grup :</TD></TR>
  <TR bgcolor="##FFFF33">
                        <TD>tarih</TD>
                        <TD>ürün id</TD>
                        <TD>stok id</TD>
                        <TD>stok</TD>
                        <TD>stok code</TD>
                        <TD>Alış</TD>
                        <TD>Satış miktar</TD>
                        <TD>gün maliyet</TD>
                        <TD>fark</TD>
                     </TR>
    <cfquery name="get_" datasource="#dsn_dev#">
    	SELECT 
        	S.STOCK_ID,
            S.PRODUCT_ID,
            S.STOCK_CODE,
            S.PROPERTY,
            PT.BRUT_ALIS,
            PT.NEW_ALIS,
            PT.DISCOUNT1,
            PT.DISCOUNT2,
            PT.DISCOUNT3,
            PT.DISCOUNT4,
            PT.DISCOUNT5,
            ISNULL(PT.PRICE_TYPE,-1) AS P_TYPE,
            PT.TABLE_CODE,
            PT.ROW_ID,
            P.COMPANY_ID,
            P.PROJECT_ID,
            CAST(P.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(P.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE
       	FROM 
        	PRICE_TABLE PT,
            #DSN1_ALIAS#.STOCKS S,
            #DSN1_ALIAS#.PRODUCT P
        WHERE
            CAST(P.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(P.PROJECT_ID,0) AS NVARCHAR) = '61_3' AND
            PT.PRICE_TYPE IN (#kasa_cikislar#) AND
            PT.PRODUCT_ID = S.PRODUCT_ID AND
            PT.PRODUCT_ID = P.PRODUCT_ID AND
            PT.IS_ACTIVE_S = 1 AND
            PT.STARTDATE = #createodbcdatetime(STARTDATE)# AND
            PT.FINISHDATE = #createodbcdatetime(FINISHDATE)#
        ORDER BY
        	PT.ROW_ID DESC
    </cfquery>
    
    <cfset toplam_gun_ = datediff('d',gun_ilk_,gun_son_)>
    <cfloop from="0" to="#toplam_gun_-1#" index="gun">
        <cfset tarih_ = dateadd('d',gun,gun_ilk_)>
        <cfif month(tarih_) gt 8>
        <cfset p_list = "">
        	
            <cfloop query="get_">
           		<cfif not listfind(p_list,STOCK_ID)>
					<cfset p_list = listappend(p_list,stock_id)>
                    <cfset alis_ = wrk_round(NEW_ALIS,2)>
                    
                    <cfquery name="get_satis" datasource="#dsn2#">
                    SELECT
                    	SUM(SATIS1) AS SATIS
                    FROM
                    	(
                        SELECT
                            SUM(IRP.AMOUNT) AS SATIS1
                        FROM
                            INVOICE_ROW_POS IRP,
                            INVOICE I
                        WHERE
                            IRP.STOCK_ID = #STOCK_ID# AND
                            IRP.INVOICE_ID = I.INVOICE_ID AND
                            MONTH(I.INVOICE_DATE) = #MONTH(tarih_)# AND
                            DAY(I.INVOICE_DATE) = #DAY(tarih_)#
                     UNION ALL
                        SELECT
                            SUM(IRP.AMOUNT) AS SATIS2
                        FROM
                            INVOICE_ROW IRP,
                            INVOICE I
                        WHERE
                            I.INVOICE_CAT = 52 AND
                            IRP.STOCK_ID = #STOCK_ID# AND
                            IRP.INVOICE_ID = I.INVOICE_ID AND
                            MONTH(I.INVOICE_DATE) = #MONTH(tarih_)# AND
                            DAY(I.INVOICE_DATE) = #DAY(tarih_)#
                        ) T2
                    </cfquery>
                    
                    <cfif get_satis.recordcount and len(get_satis.SATIS)>
                    	<cfif listfindnocase(kasa_cikislar_maliyetsiz,p_type)>
							<cfset o_gun_maliyet = wrk_round(get_daily_cost_price(PRODUCT_ID,year(tarih_),MONTH(tarih_),DAY(tarih_)),2)>
                        <cfelse>
							<cfset o_gun_maliyet = wrk_round(get_daily_maliyet(PRODUCT_ID,STOCK_ID,year(tarih_),MONTH(tarih_),DAY(tarih_)),2)>
                        </cfif>
						<cfset fark_ = o_gun_maliyet - alis_>
                        <cfif fark_ gt 0>
                         <TR>
                            <TD>#dateformat(tarih_,'dd/mm/yyyy')#</TD>
                            <TD>#PRODUCT_ID# </TD>
                            <TD>#STOCK_ID# </TD>
                            <TD>#PROPERTY# </TD>
                            <TD>#STOCK_CODE#</TD>
                            <TD>#alis_#</TD>
                            <TD>#get_satis.SATIS#</TD>
                            <TD>#o_gun_maliyet#</TD>
                            <TD>#o_gun_maliyet - alis_#</TD>
                         </TR>
                            <!---
                            <cfquery name="cont_" datasource="workcube_gulgen_dev">
                            	SELECT * FROM 
                                	  INVOICE_FF_ROWS 
                                WHERE
                                	  PRODUCT_ID = #PRODUCT_ID# AND
                                      STOCK_ID = #STOCK_ID# AND
                                      INVOICE_DATE = #tarih_# AND
                                      COMPANY_ID = #COMPANY_ID# AND
                                      <cfif len(PROJECT_ID)>PROJECT_ID = #PROJECT_ID# AND</cfif>
                                      PRICE_TYPE = #P_TYPE# AND
                                      TABLE_ROW_ID = #row_id#
                            </cfquery>
                            
                            <cfif not cont_.recordcount>
                                <cfquery name="add_" datasource="workcube_gulgen_dev">
                                    INSERT INTO
                                        INVOICE_FF_ROWS           
                                        (
                                        PRODUCT_ID,
                                        STOCK_ID,
                                        INVOICE_DATE,
                                        AMOUNT,
                                        FF_GROSS,
                                        FF_BASE,
                                        PERIOD_ID,
                                        COMPANY_ID,
                                        PROJECT_ID,
                                        COMP_CODE,
                                        FF_NET,
                                        FF_PAID,
                                        FF_TYPE,
                                        PRICE_TYPE,
                                        TABLE_ROW_ID,
                                        TABLE_CODE,
                                        FF_DAILY_COST,
                                        CODE
                                        )
                                        VALUES
                                        (
                                        #PRODUCT_ID#,
                                        #STOCK_ID#,
                                        #tarih_#,
                                        #get_satis.SATIS#,
                                        #get_satis.SATIS * alis_#,
                                        #get_satis.SATIS * o_gun_maliyet#,
                                        1,
                                        #COMPANY_ID#,
                                        <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
                                        '#COMP_CODE#',
                                        #fark_ * get_satis.SATIS#,
                                        0,
                                        1,
                                        #P_TYPE#,
                                        #row_id#,
                                        '#TABLE_CODE#',
                                        #o_gun_maliyet#,
                                        'KASIM'
                                        )
                                </cfquery>
                           </cfif>
						   --->
                        </cfif>
                    <cfelse>
                    	<!--- <font color="red">#PROPERTY# satışı yok</font><br /> --->
                    </cfif> 
               </cfif>
            </cfloop>
        </cfif>
    </cfloop>
</CFOUTPUT>
</TABLE>
</cfif>
<cfif session.ep.username is 'admin1'>
<!--- 
    <cfquery name="get_relations" datasource="#dsn2#">
    SELECT
        *
    FROM
        (
        SELECT
            S.SHIP_NUMBER,
            S.SHIP_TYPE,
            S.SHIP_DATE,
            S.SHIP_ID,
            SR.AMOUNT AS IRSALIYE_MIKTAR,
            SR.WRK_ROW_ID,
            SR.UNIT,
            SR.STOCK_ID,
            SR.NAME_PRODUCT,
            SR.SHIP_ROW_ID
        FROM
            SHIP S,
            SHIP_ROW SR
        WHERE
            S.SHIP_ID = SR.SHIP_ID AND
            S.SHIP_TYPE IN (81)
        ) T1
    ORDER BY
        SHIP_DATE ASC
    </cfquery>
    
    <cfif get_relations.recordcount>
        <cfset ship_list = valuelist(get_relations.SHIP_ID)>
        <cfoutput query="get_relations">
            <cfquery name="upd_" datasource="#dsn2#">
                UPDATE
                    SHIP_ROW
                SET
                    AMOUNT = #IRSALIYE_MIKTAR * 1000#
                WHERE
                    SHIP_ROW_ID = #SHIP_ROW_ID#
            </cfquery>
        </cfoutput>
        
        <cfquery name="upd_stocks" datasource="#dsn2#">
            UPDATE
            STOCKS_ROW 
        SET
            STOCK_IN = 
            (
                SELECT 
                    SUM(SR.AMOUNT) AS MIKTAR
                FROM 
                    SHIP_ROW SR,
                    SHIP S 
                WHERE 
                    S.SHIP_ID = SR.SHIP_ID AND 
                    S.SHIP_ID = STOCKS_ROW.UPD_ID AND
                    SR.STOCK_ID = STOCKS_ROW.STOCK_ID
            )
        WHERE 
            PROCESS_TYPE = 81 AND 
            UPD_ID IN (#ship_list#)
        </cfquery>
    </cfif>

    <cfquery name="get_relations" datasource="#dsn2#">
    SELECT
        *
    FROM
        (
        SELECT
            S.SHIP_NUMBER,
            S.SHIP_TYPE,
            S.SHIP_DATE,
            S.SHIP_ID,
            SR.AMOUNT AS IRSALIYE_MIKTAR,
            SR.WRK_ROW_ID,
            SR.UNIT,
            SR.STOCK_ID,
            SR.NAME_PRODUCT,
            SR.SHIP_ROW_ID
        FROM
            SHIP S,
            SHIP_ROW SR
        WHERE
            S.SHIP_ID = SR.SHIP_ID AND
            S.SHIP_TYPE IN (76)
        ) T1
    ORDER BY
        SHIP_DATE ASC
    </cfquery>
    
    <cfif get_relations.recordcount>
        <cfset ship_list = valuelist(get_relations.SHIP_ID)>
        <cfoutput query="get_relations">
            <cfquery name="upd_" datasource="#dsn2#">
                UPDATE
                    SHIP_ROW
                SET
                    AMOUNT = #IRSALIYE_MIKTAR * 1000#
                WHERE
                    SHIP_ROW_ID = #SHIP_ROW_ID#
            </cfquery>
        </cfoutput>
        
        <cfquery name="upd_stocks" datasource="#dsn2#">
            UPDATE
            STOCKS_ROW 
        SET
            STOCK_IN = 
            (
                SELECT 
                    SUM(SR.AMOUNT) AS MIKTAR
                FROM 
                    SHIP_ROW SR,
                    SHIP S 
                WHERE 
                    S.SHIP_ID = SR.SHIP_ID AND 
                    S.SHIP_ID = STOCKS_ROW.UPD_ID AND
                    SR.STOCK_ID = STOCKS_ROW.STOCK_ID
            )
        WHERE 
            PROCESS_TYPE = 76 AND 
            UPD_ID IN (#ship_list#)
        </cfquery>
    </cfif>
 --->  
</cfif>

<!---
<cfset attributes.search_startdate = createodbcdatetime(createdate(year(now()),9,19))>
<cfset attributes.search_finishdate = createodbcdatetime(createdate(year(now()),9,19))>
<cfquery name="get_" datasource="#dsn2#">
	SELECT
    	ISNULL(fnc_get_ortalama_satis_stok(3279,13,#attributes.search_startdate#,#attributes.search_finishdate#),0) AS ROW_ORT_STOK_SATIS_MIKTARI
</cfquery>
<cfdump var="#get_#">


<cfquery name="get1" datasource="#dsn2#">
	SELECT
        PPD.TARIH,
        ISNULL(SUM(SR2.STOCK_IN-SR2.STOCK_OUT),0) AS STOCK2,
        (
        	SELECT
            	SUM(SR.STOCK_OUT)
            FROM
            	STOCKS_ROW SR
            WHERE
            	SR.STOCK_ID = 3279 AND 
                YEAR(SR.PROCESS_DATE) = PPD.YIL AND 
                MONTH(SR.PROCESS_DATE) = PPD.AY AND 
                DAY(SR.PROCESS_DATE) = PPD.GUN AND 
                SR.PROCESS_DATE = '2014-09-19' AND 
                SR.PROCESS_TYPE IN (67) AND
                (
                    SR.STORE <> 13
                 )
        ) 
        STOCK_OUT2
    FROM
        workcube_gulgen_1..PRODUCT_PRICE_DATES PPD 
            LEFT JOIN STOCKS_ROW SR2 ON 
                (
                    SR2.STOCK_ID = 3279 AND
                    SR2.PROCESS_DATE <= PPD.TARIH
                    AND 
                    (
                        SR2.STORE <> 13
                     )
                )
  WHERE
        PPD.TARIH BETWEEN #attributes.search_startdate# AND #attributes.search_finishdate#
        AND PPD.TARIH  >= '2014-09-01'
   GROUP BY
        PPD.TARIH,
        PPD.YIL,
        PPD.AY,
        PPD.GUN
   ORDER BY
   		PPD.TARIH ASC
</cfquery>
<cfdump var="#get1#">

<cfquery name="get_2" dbtype="query">
	SELECT SUM(STOCK_OUT2) FROM get1
</cfquery>
<cfdump var="#get_2#">


<cfquery name="get_" datasource="olimpos">
	SELECT DISTINCT 
    	A.VERGINO,
        B.YETAD,
        B.YETUNV,
        B.YETCEPTEL,
        B.YETFAX,
        B.YETMAIL 
    FROM 
    	MACR0001 A,
        MACR0002 B 
    WHERE 
    	A.MUSNO=B.MUSNO AND 
        A.TALINO=B.TALINO
</cfquery>
<cfdump var="#get_#">

<cfquery name="get_" datasource="olimpos">
	SELECT 
        FIYAT,
        EMTIANO,
        GYIL,
        FIYTIP,
        VADE,
        ISK1,
        ISK2,
        ISK3 
    FROM 
    	MASK0208 
    WHERE 
        EMTIANO = '036499' AND
        FIYTIP IN ('NA') AND
        GYIL IS NOT NULL 
    ORDER BY
    	EMTIANO DESC,
    	GYIL DESC
</cfquery>
<cfdump var="#get_#">


<script>
function aaa()
{
  var ws = new ActiveXObject("WScript.Shell");
  ws.Exec("C:\\Program Files\\WinRAR\\WinRAR.exe");	
}
</script>

<a href="javascript://" onclick="aaa();">Gönder</a>


<cfquery name="get_" datasource="#dsn2#">
	SELECT 
    	fnc_stok_devir_hizi_stok(528,13,{ts '2014-07-03 00:00:00'},{ts '2014-10-03 00:00:00'}) AS ROW_STOK_DEVIR_HIZI,
        fnc_get_ortalama_satis_stok(528,13,{ts '2014-07-03 00:00:00'},{ts '2014-10-03 00:00:00'}) AS ROW_ORT_STOK_SATIS_MIKTARI
</cfquery>
<CFDUMP var="#get_#">


<cfexit method="exittemplate">
<cfexecute 
	name="C:\WORKCUBE_DOSYA\PRODUCTION\documents\copy_command.cmd" 
    outputFile="C:\WORKCUBE_DOSYA\PRODUCTION\documents\output.txt">
</cfexecute>
--->

<!---
<cfquery name="get_data" datasource="olimpos">
	SELECT EMTIAAD,EMTIANO FROM MASK0001
</cfquery>

<cfoutput query="get_data">
	<cfquery name="upd_" datasource="#dsn1#">
    	UPDATE
        	STOCKS
        SET
        	PROPERTY = '#EMTIAAD#'
        WHERE
        	STOCK_CODE_2 = '#EMTIANO#'
    </cfquery>
</cfoutput>
--->

<!---
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = #session.ep.company_id# AND
        PRODUCT_CAT.HIERARCHY LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<CFOUTPUT query="GET_PRODUCT_CAT">
	<cfquery name="get_upper_code" datasource="#dsn1#">
    	SELECT PRODUCT_CAT_TYPE FROM PRODUCT_CAT WHERE HIERARCHY = '#listfirst(HIERARCHY,".")#'
    </cfquery>
    <cfif len(get_upper_code.PRODUCT_CAT_TYPE)>
    	<cfquery name="upd_" datasource="#DSN1#">
        	UPDATE
            	PRODUCT_CAT
            SET
            	PRODUCT_CAT_TYPE = #get_upper_code.PRODUCT_CAT_TYPE#
            WHERE
            	PRODUCT_CATID = #PRODUCT_CATID#
        </cfquery>
    </cfif>
</CFOUTPUT>

--->



<!---
<cfquery name="get_all" datasource="#dsn_Dev#">
	SELECT * FROM SEARCH_TABLES_ROWS WHERE TABLE_CODE = '00000069' AND ATT_NAME LIKE 'PRODUCT_NAME%' ORDER BY ATT_NAME
</cfquery>
<cfset p_list = "">

<cfset l_ = 0>
<cfoutput query="get_all">
	<cfset deger_ = get_all.ATT_NAME>
	<cfset pid_ = replace(deger_,'PRODUCT_NAME_','','all')>
    <cfset l_ = l_ + 1>
    <cfquery name="add_" datasource="#dsn_dev#">
        INSERT INTO
            SEARCH_TABLES_PRODUCTS
            (
            TABLE_ID,
            TABLE_CODE,
            PRODUCT_ID,
            LINE_NUMBER
            )
            VALUES
            (
            #get_all.table_id#,
            '#get_all.table_code#',
            #pid_#,
            #l_#
            )
    </cfquery>
</cfoutput>

<style>
	.colors{background-color:blue;}
</style>
<link rel="stylesheet" type="text/css" href="http://rawgithub.com/akottr/dragtable/master/dragtable.css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
<script type="text/javascript" src="/extra/js/jquery.dragtablea.js"></script>

<cf_basket>
<table id="manage_table" width="100%" border="1" cellpadding="2" cellspacing="0">
	<thead>
    	<tr>
        	<cfoutput><cfloop from="1" to="10" index="hhh"><th data-header="kolon_#hhh#" style="font-weight:bold;">kolon #hhh#</th></cfloop></cfoutput>
        </tr>
    </thead>
    <tbody>
    <cfloop from="1" to="100" index="mmk">
    <cfoutput>
    	<tr id="product_row_#mmk#" rel="product_#mmk#" onclick="get_row_active('#mmk#');" ondblclick="get_row_passive('#mmk#');" class="colors">
        	<cfloop from="1" to="10" index="hhh"><td rel="kolon_#hhh#" <cfif hhh eq 5>style="background-color:red;"</cfif>>kolon #hhh# #mmk#</td></cfloop>
        </tr>
    </cfoutput>
    </cfloop>
    </tbody>
</table>
</cf_basket>
<script>
function get_row_active(prod_id)
{
	document.getElementById('product_row_' + prod_id).style.backgroundColor = 'yellow';
	rel_ = "rel='product_" + prod_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "] td");
	col1.css("background-color","yellow");
}

function get_row_passive(prod_id)
{
	document.getElementById('product_row_' + prod_id).style.backgroundColor = '';
	rel_ = "rel='product_" + prod_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "] td");
	col1.css("background-color","");
}

$(document).ready(
function()
{
	//$('#manage_table').dragtable('order',['kolon_3','kolon_1','kolon_2']);
	//$('#manage_table').dragtable();
	
	//var order = $('#manage_table').dragtable('order');
	//$('#manage_table').dragtable('order',['kolon_4','kolon_3','kolon_1','kolon_2']);
}
);
</script>
--->
<!---
<cfquery name="get_" datasource="#dsn_dev#">
	SELECT
        PC.PRODUCT_ID,
        PC.ROW_ID,
        PC2.ROW_ID,
        PC.TABLE_CODE,
        PC2.TABLE_CODE,
        PC.NEW_PRICE_KDV,
        PC2.NEW_PRICE_KDV,
        PC.NEW_ALIS_KDV,
        PC2.NEW_ALIS_KDV
    FROM
        PRICE_TABLE PC,
        PRICE_TABLE PC2
    WHERE
        PC.ROW_ID <> PC2.ROW_ID AND
        PC.PRODUCT_ID = PC2.PRODUCT_ID AND
        PC.STARTDATE = PC2.STARTDATE AND
        PC.FINISHDATE = PC2.FINISHDATE AND
        PC.P_STARTDATE = PC2.P_STARTDATE AND
        PC.P_FINISHDATE = PC2.P_FINISHDATE AND
        PC.TABLE_ID = PC2.TABLE_ID AND
        PC.NEW_ALIS_KDV = PC2.NEW_ALIS_KDV AND
        PC.NEW_PRICE_KDV = PC2.NEW_PRICE_KDV AND
        PC.PRODUCT_ID IS NOT NULL AND
        ISNULL(PC.IS_IMPORT,0) = 0 AND
        ISNULL(PC2.IS_IMPORT,0) = 0
</cfquery>
<cfset list_ = listdeleteduplicates(valuelist(get_.ROW_ID))>
<BR /><BR />
<CFOUTPUT>#list_#</CFOUTPUT>
<BR /><BR />

<cfquery name="get_2" datasource="#dsn_dev#">
	SELECT
    	*
    FROM
    	PRICE_TABLE
    WHERE
    	ROW_ID IN (#list_#)
</cfquery>

<CFOUTPUT query="GET_2">
	<cfset row_id_ = row_id>
    <cfset pid_ = product_id>
    <cfset table_id_ = TABLE_ID>
    <cfset STARTDATE_ = STARTDATE>
    <cfset FINISHDATE_ = FINISHDATE>
    <cfset P_STARTDATE_ = P_STARTDATE>
    <cfset P_FINISHDATE_ = P_FINISHDATE>
    <cfset TABLE_ID_ = TABLE_ID>
    <cfset NEW_ALIS_KDV_ = NEW_ALIS_KDV>
    <cfset NEW_PRICE_KDV_ = NEW_PRICE_KDV>
    
    #TABLE_CODE# #row_id_# #pid_# #TABLE_ID_# #STARTDATE_# #FINISHDATE_# #P_STARTDATE_# #P_FINISHDATE_# #NEW_ALIS_KDV_# #NEW_PRICE_KDV# <br />
    <cfquery name="get_alts" datasource="#dsn_dev#">
    	SELECT
        	ROW_ID
        FROM
        	PRICE_TABLE
        WHERE
        	ROW_ID <> #row_id_# AND
            ISNULL(IS_IMPORT,0) = 0 AND
            STARTDATE = #CREATEODBCDATETIME(STARTDATE_)# AND
            FINISHDATE = #CREATEODBCDATETIME(FINISHDATE_)# AND
            P_STARTDATE = #CREATEODBCDATETIME(P_STARTDATE_)# AND
            P_FINISHDATE = #CREATEODBCDATETIME(P_FINISHDATE_)# AND
            TABLE_ID = #TABLE_ID_# AND
            NEW_ALIS_KDV = #NEW_ALIS_KDV# AND
            NEW_PRICE_KDV = #NEW_PRICE_KDV# AND
            PRODUCT_ID = #pid_#
    </cfquery>
    	<CFLOOP query="get_alts">
        	#get_alts.ROW_ID#
            <!---
            <cfquery name="del_" datasource="#dsn_dev#">
            	DELETE FROM PRICE_TABLE WHERE ROW_ID = #get_alts.ROW_ID#
            </cfquery>
            --->
			<BR />
        </CFLOOP>
    <hr />
    <hr />
</CFOUTPUT>
--->
