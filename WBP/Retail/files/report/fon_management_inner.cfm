<cfquery name="get_order_date" datasource="#dsn_dev#">
	SELECT ORDER_DAY FROM SEARCH_TABLES_DEFINES
</cfquery>
<cfset order_control_day = -1 * get_order_date.ORDER_DAY>

<cfif not fusebox.fuseaction contains 'emptypopup_'>
	<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
    <link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.sort.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.export.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.export.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/globalization/globalize.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
    <script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/globalization/globalize.culture.tr-TR.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
</cfif>

<cfparam name="attributes.count_type" default="d">
<cfparam name="attributes.startdate" default="#dateadd('d',-15,now())#">
<cfparam name="attributes.finishdate" default="#now()#">

<cfif isdefined("session.ep.userid")>
	<cfset userid_ = session.ep.userid>
<cfelse>
	<cfset userid_ = session.pp.userid>
</cfif>

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">

<style>
	.gelir_blok_header{background-color:#F96;text-align:right;}
	.gelir_blok_header div{color:#00C !important;text-align:right;}
	
	.gelir_blok_row{background-color:#FC9; color:#00C !important;text-align:right;}
	.gelir_blok_row div{color:#00C !important;text-align:right;}
	
	.gelir_blok_row2{background-color:#FCC; color:#F00 !important;text-align:right;}
	.gelir_blok_row2 div{color:#F00 !important;text-align:right;}
	
	.gelir_blok_header_total{background-color:#F96; color:#00C !important;text-align:right; font-weight:bold;}
	.gelir_blok_header_total div{color:#00C !important;text-align:right; font-weight:bold;}
	
	.gelir_blok_row_total{background-color:#FC9; color:#00C !important;text-align:right; font-weight:bold;}
	.gelir_blok_row_total div{color:#00C !important;text-align:right; font-weight:bold;}
	
	.gelir_blok_row2_total{background-color:#FCC; color:#F00 !important;text-align:right; font-weight:bold;}
	.gelir_blok_row2_total div{color:#F00 !important;text-align:right; font-weight:bold;}
	
	.gider_blok_header{background-color:#999; color:#000 !important;text-align:right;}
	.gider_blok_header div{color:#000 !important;text-align:right;}
	
	.gider_blok_row{background-color:#CCC; color:#000  !important;text-align:right;}
	.gider_blok_row div{color:#000  !important;text-align:right;}
	
	.gider_blok_header_total{background-color:#999; color:#000 !important;text-align:right; font-weight:bold;}
	.gider_blok_header_total div{color:#000 !important;text-align:right; font-weight:bold;}
	
	.gider_blok_row_total{background-color:#CCC; color:#000 !important;text-align:right; font-weight:bold;}
	.gider_blok_row_total div{color:#000 !important;text-align:right; font-weight:bold;}
	
	.t_gelir_blok_header{background-color:#099; color:blue;text-align:right;}
	.t_gelir_blok_header div{color:blue;text-align:right;}
	
	.t_gelir_blok_row{background-color:#9FC; color:blue;text-align:right;}
	.t_gelir_blok_row div{color:blue;text-align:right;}
	
	.t_gelir_blok_header_total{background-color:#099; color:blue;text-align:right; font-weight:bold;}
	.t_gelir_blok_header_total div{color:blue;text-align:right; font-weight:bold;}
	
	.t_gelir_blok_row_total{background-color:#9FC; color:blue;text-align:right; font-weight:bold;}
	.t_gelir_blok_row_total div{color:blue;text-align:right; font-weight:bold;}
	
	.dip_blok_row{background-color:#9C6; color:#F00 !important;text-align:right;}
	.dip_blok_row div{color:#F00 !important;text-align:right;}
	
	.dip_blok_row_total{background-color:#9C6; color:#F00 !important;text-align:right; font-weight:bold;}
	.dip_blok_row_total div{color:#F00 !important;text-align:right; font-weight:bold;}
</style>


<cfset hafta_bitis = 1>

<cfset kolon_sayisi = 52>
<cfset kolon_fazla = 0>
<cfif attributes.count_type is 'd'>
	<cfset kolon_sayisi = datediff('d',attributes.startdate,attributes.finishdate) + 1>
    <cfif kolon_sayisi gt 52>
    	<cfset kolon_sayisi = 52>
        <cfset kolon_fazla = 1>
        <cfset attributes.startdate = dateadd('d',-(kolon_sayisi-1),attributes.finishdate)>
    </cfif>
    <cfset type = "Gün">
<cfelseif attributes.count_type is 'w'>
    <cfif dayofweek(attributes.startdate) gt hafta_bitis>
    	<cfset fark = dayofweek(attributes.startdate) - 1>
		<cfset ilk_hafta_baslama_ = dateadd('d',-(fark-1),attributes.startdate)>
    <cfelseif dayofweek(attributes.startdate) eq 1>
		<cfset ilk_hafta_baslama_ = dateadd('d',-6,attributes.startdate)>
    <cfelse>
    	<cfset ilk_hafta_baslama_ = attributes.startdate>
    </cfif>
    
    <cfif dayofweek(attributes.finishdate) gt hafta_bitis>
    	<cfset fark = dayofweek(attributes.finishdate) - 1>
		<cfset son_hafta_baslama_ = dateadd('d',-(fark-1),attributes.finishdate)>
        <cfset son_hafta_bitis_ = attributes.finishdate>
   	<cfelseif dayofweek(attributes.finishdate) eq 1>
		<cfset son_hafta_baslama_ = dateadd('d',-6,attributes.finishdate)>
        <cfset son_hafta_bitis_ = attributes.finishdate>
    </cfif>
    
    <cfset hafta_fark = int(datediff('d',ilk_hafta_baslama_,son_hafta_baslama_) / 7) + 1>
    
    
    <cfloop from="1" to="#hafta_fark#" index="hh">
    	<cfset 'hafta_#hh#' = ''>
    </cfloop>
    
    <cfif hafta_fark eq 1>
    	<cfset gun_fark_ = datediff('d',attributes.startdate,attributes.finishdate) + 1>
        <cfloop from="1" to="#gun_fark_#" index="aaa">
        	<cfset deger_ = aaa - 1>
            <cfset tarih_ = dateadd('d',deger_,attributes.startdate)>
            <cfset hafta_1 = listappend(hafta_1,'#dateformat(tarih_,"dd.mm.yyyy")#')>
        </cfloop>
    <cfelse>
    	<cfloop from="1" to="#hafta_fark#" index="hh">
        	<cfif hh eq 1>
            	<cfset sanal_hafta_start = ilk_hafta_baslama_>
                <cfset sanal_hafta_bitis = dateadd('d',6,sanal_hafta_start)>
            <cfelse>
            	<cfset sanal_hafta_start = dateadd('d',(7 * (hh - 1)),ilk_hafta_baslama_)>
                <cfset sanal_hafta_bitis = dateadd('d',6,sanal_hafta_start)>
            </cfif>
            <cfloop from="1" to="7" index="aaa">
				<cfset deger_ = aaa - 1>
                <cfset tarih_ = dateadd('d',deger_,sanal_hafta_start)>
                <cfif tarih_ gte attributes.startdate and tarih_ lte attributes.finishdate>
					<cfset 'hafta_#hh#' = listappend(evaluate('hafta_#hh#'),'#dateformat(tarih_,"dd.mm.yyyy")#')>
                </cfif>
            </cfloop>
        </cfloop>
    </cfif>
    
	<cfset kolon_sayisi = hafta_fark>
    <cfif kolon_sayisi gt 52>
    	<cfset kolon_sayisi = 52>
        <cfset kolon_fazla = 1>
        <cfset fark = hafta_fark - (kolon_sayisi + 1)>
        
        <cfset ilk_tarih_ = listfirst(evaluate('hafta_#fark#'))>
        <cf_date tarih="ilk_tarih_">
        
        <cfset attributes.startdate = ilk_tarih_>
        <cfset ilk_hafta_baslama_ = attributes.startdate>
        <cfloop from="1" to="52" index="hh">
			<cfset 'hafta_#hh#' = ''>
        </cfloop>
        
        <cfloop from="1" to="#hafta_fark#" index="hh">
        	<cfif hh eq 1>
            	<cfset sanal_hafta_start = ilk_hafta_baslama_>
                <cfset sanal_hafta_bitis = dateadd('d',6,sanal_hafta_start)>
            <cfelse>
            	<cfset sanal_hafta_start = dateadd('d',(7 * (hh - 1)),ilk_hafta_baslama_)>
                <cfset sanal_hafta_bitis = dateadd('d',6,sanal_hafta_start)>
            </cfif>
            <cfloop from="1" to="7" index="aaa">
				<cfset deger_ = aaa - 1>
                <cfset tarih_ = dateadd('d',deger_,sanal_hafta_start)>
                <cfif tarih_ gte attributes.startdate and tarih_ lte attributes.finishdate>
					<cfset 'hafta_#hh#' = listappend(evaluate('hafta_#hh#'),'#dateformat(tarih_,"dd.mm.yyyy")#')>
                </cfif>
            </cfloop>
        </cfloop>
    </cfif>
    <cfset type = "Hafta">
<cfelseif attributes.count_type is 'm'>
    <cfset fark_gun_ = createodbcdatetime(createdate(year(attributes.startdate),month(attributes.startdate),1))>
	<cfset kolon_sayisi = datediff('m',fark_gun_,attributes.finishdate) + 1>
	<cfif kolon_sayisi gt 52>
    	<cfset kolon_sayisi = 52>
        <cfset kolon_fazla = 1>
    </cfif>
    <cfset type = "Ay">
<cfelseif attributes.count_type is 'y'>
	<cfset kolon_sayisi = datediff('yyyy',attributes.startdate,attributes.finishdate) + 1>
    <cfif kolon_sayisi gt 52>
    	<cfset kolon_sayisi = 52>
        <cfset kolon_fazla = 1>
    </cfif>
    <cfset type = "Yıl">
</cfif>

<cfset yillar = "">

<cfset yil_bas = createodbcdatetime(createdate(year(attributes.startdate),1,1))>
<cfset yil_bitis = createodbcdatetime(createdate(year(attributes.finishdate),1,1))>

<cfset yil_sayisi = datediff('yyyy',yil_bas,yil_bitis) + 1>

<cfif yil_sayisi eq 1>
	<cfset yillar = year(attributes.finishdate)>
<cfelse>
	<cfset yillar = year(attributes.startdate)>
    <cfloop from="1" to="#yil_sayisi-1#" index="ccc">
    	<cfset yil_ = dateadd('yyyy',ccc,attributes.startdate)>
        <cfset yillar = listappend(yillar,year(yil_))>
    </cfloop>
</cfif>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR IN (#session.ep.period_year#,#yillar#)
</cfquery>

<cfquery name="get_periods_all" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>


<!--- yazar kasa nakitler --->
<cfquery name="get_kasa" datasource="#dsn#" result="get_kasa_r">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
	   <cfset count = 0>
       <cfloop query="get_periods">
       <cfset count = count + 1>
       <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
           <cfif count neq 1>
            UNION ALL
           </cfif>
                    SELECT
                        CASH_ACTION_VALUE,
                        <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                            CAST(DAY(ACTION_DATE) AS NVARCHAR) + '_' + CAST(MONTH(ACTION_DATE) AS NVARCHAR) + '_' + CAST(YEAR(ACTION_DATE) AS NVARCHAR) BASE_ALAN
                        <cfelseif attributes.count_type is 'm'>
                            CAST(MONTH(ACTION_DATE) AS NVARCHAR) + '_' + CAST(YEAR(ACTION_DATE) AS NVARCHAR) BASE_ALAN
                        <cfelseif attributes.count_type is 'y'>
                            CAST(YEAR(ACTION_DATE) AS NVARCHAR) BASE_ALAN
                        </cfif>
                    FROM
                        #db_#.CASH_ACTIONS CA
                    WHERE
                        ACTION_TYPE_ID = 69 AND
                        ACTION_DATE >= #attributes.startdate# AND
                        ACTION_DATE < #dateadd('d',1,attributes.finishdate)#
                UNION ALL
                    SELECT
                        CASE
                            WHEN GAP2.ODEME_TURU = 26 THEN -1 * ODEME_TUTAR
                            WHEN (GAP2.ODEME_TURU <> 26 AND GA2.BELGE_TURU <> '2') THEN ODEME_TUTAR
                            ELSE -1 * ODEME_TUTAR END AS CASH_ACTION_VALUE,
                        <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                            CAST(DAY(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                        <cfelseif attributes.count_type is 'm'>
                            CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                        <cfelseif attributes.count_type is 'y'>
                            CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                        </cfif>
                    FROM 
                        #dsn_dev_alias#.GENIUS_ACTIONS GA2 WITH (NOLOCK),
                        #dsn_dev_alias#.GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK)
                    WHERE 
                        YEAR(GA2.FIS_TARIHI) = #get_periods.PERIOD_YEAR# AND
                        GA2.FIS_TARIHI < #bugun_# AND
                        GA2.FIS_TARIHI >= #attributes.startdate# AND 
                        GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
                        GA2.ACTION_ID = GAP2.ACTION_ID AND
                        GA2.FIS_IPTAL = 0 AND
                        GAP2.ODEME_TURU IN (#yazar_kasa_nakit_odeme_tipleri#) 
                        AND
                        GA2.ACTION_ID NOT IN 
                        (
                        	SELECT 
                            	GA_IC.ACTION_ID
                            FROM
                            	#dsn_dev_alias#.GENIUS_ACTIONS GA_IC WITH (NOLOCK),
                                #dsn_dev_alias#.POS_CONS PC
                            WHERE
                                GA_IC.ZNO = PC.ZNO AND
                            	GA_IC.KASA_NUMARASI = PC.KASA_NUMARASI AND
                                YEAR(GA2.FIS_TARIHI) = #get_periods.PERIOD_YEAR# AND
                                GA_IC.FIS_TARIHI >= #attributes.startdate# AND 
                       			GA_IC.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                        )
       </cfloop>
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_kasa">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'kasa_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("kasa_#hafta_#")>
        	<cfset 'kasa_#hafta_#' = evaluate("kasa_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'kasa_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- yazar kasa nakitler --->

<!--- yazar kasa pos --->
<cfquery name="get_ccs" datasource="#dsn3#" result="get_ccs_r">
SELECT
    SUM(AMOUNT) AS TOTAL,
   	BASE_ALAN
FROM
	(
    	SELECT
        	CCBPR.AMOUNT,
            <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(CCBP.STORE_REPORT_DATE) AS NVARCHAR) + '_' + CAST(MONTH(CCBP.STORE_REPORT_DATE) AS NVARCHAR) + '_' + CAST(YEAR(CCBP.STORE_REPORT_DATE) AS NVARCHAR) BASE_ALAN
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(CCBP.STORE_REPORT_DATE) AS NVARCHAR) + '_' + CAST(YEAR(CCBP.STORE_REPORT_DATE) AS NVARCHAR) BASE_ALAN
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(CCBP.STORE_REPORT_DATE) AS NVARCHAR) BASE_ALAN
            </cfif>
        FROM
        	CREDIT_CARD_BANK_PAYMENTS_ROWS CCBPR,
            CREDIT_CARD_BANK_PAYMENTS CCBP
        WHERE
        	CCBP.CREDITCARD_PAYMENT_ID = CCBPR.CREDITCARD_PAYMENT_ID AND
            CCBP.ACTION_TYPE_ID = 69 AND
            CCBP.STORE_REPORT_DATE >= #attributes.startdate# AND 
            CCBP.STORE_REPORT_DATE < #dateadd('d',1,attributes.finishdate)#
        UNION ALL
            SELECT
                CASE
                    WHEN GA2.BELGE_TURU <> '2' THEN ODEME_TUTAR
                    ELSE -1 * ODEME_TUTAR END AS AMOUNT,
                <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                    CAST(DAY(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                <cfelseif attributes.count_type is 'm'>
                    CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                <cfelseif attributes.count_type is 'y'>
                    CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                </cfif>
            FROM 
                #dsn_dev_alias#.GENIUS_ACTIONS GA2 WITH (NOLOCK),
                #dsn_dev_alias#.GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK)
            WHERE 
                GA2.FIS_TARIHI < #bugun_# AND
                GA2.FIS_TARIHI >= #attributes.startdate# AND 
                GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
                YEAR(GA2.FIS_TARIHI) = #get_periods.PERIOD_YEAR# AND
                GA2.ACTION_ID = GAP2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GAP2.ODEME_TURU IN (#yazar_kasa_pos_odeme_tipleri#) AND
                GA2.ACTION_ID NOT IN 
                (
                    SELECT 
                        GA_IC.ACTION_ID
                    FROM
                        #dsn_dev_alias#.GENIUS_ACTIONS GA_IC WITH (NOLOCK),
                        #dsn_dev_alias#.POS_CONS PC
                    WHERE
                        GA_IC.ZNO = PC.ZNO AND
                        GA_IC.KASA_NUMARASI = PC.KASA_NUMARASI AND
                        YEAR(GA2.FIS_TARIHI) = #get_periods.PERIOD_YEAR# AND
                        GA_IC.FIS_TARIHI >= #attributes.startdate# AND 
                        GA_IC.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                )
    ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_ccs">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'kasa_pos_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("kasa_pos_#hafta_#")>
        	<cfset 'kasa_pos_#hafta_#' = evaluate("kasa_pos_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'kasa_pos_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- yazar kasa pos --->

<!--- alisveris cekleri --->
<cfquery name="get_ccs" datasource="#dsn_dev#" result="get_css_r">
SELECT
    SUM(AMOUNT) AS TOTAL,
   	BASE_ALAN
FROM
	(
    	SELECT
        	PCP.TESLIM_TUTAR AS AMOUNT,
            <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(PC.CON_DATE) AS NVARCHAR) + '_' + CAST(MONTH(PC.CON_DATE) AS NVARCHAR) + '_' + CAST(YEAR(PC.CON_DATE) AS NVARCHAR) BASE_ALAN
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(PC.CON_DATE) AS NVARCHAR) + '_' + CAST(YEAR(PC.CON_DATE) AS NVARCHAR) BASE_ALAN
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(PC.CON_DATE) AS NVARCHAR) BASE_ALAN
            </cfif>
        FROM
        	POS_CONS_PAYMENTS PCP,
            POS_CONS PC
        WHERE
        	PCP.ODEME_TURU IN (#yazar_kasa_cek_odeme_tipleri#) AND
            PC.CON_ID = PCP.CON_ID AND
            PC.CON_DATE >= #attributes.startdate# AND 
            PC.CON_DATE < #dateadd('d',1,attributes.finishdate)#
        UNION ALL
            SELECT
                CASE
                    WHEN GA2.BELGE_TURU <> '2' THEN ODEME_TUTAR
                    ELSE -1 * ODEME_TUTAR END AS AMOUNT,
                <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                    CAST(DAY(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                <cfelseif attributes.count_type is 'm'>
                    CAST(MONTH(FIS_TARIHI) AS NVARCHAR) + '_' + CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                <cfelseif attributes.count_type is 'y'>
                    CAST(YEAR(FIS_TARIHI) AS NVARCHAR) BASE_ALAN
                </cfif>
            FROM 
                #dsn_dev_alias#.GENIUS_ACTIONS GA2 WITH (NOLOCK),
                #dsn_dev_alias#.GENIUS_ACTIONS_PAYMENTS GAP2 WITH (NOLOCK)
            WHERE 
                GA2.FIS_TARIHI < #bugun_# AND
                GA2.FIS_TARIHI >= #attributes.startdate# AND 
                GA2.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)# AND
                YEAR(GA2.FIS_TARIHI) = #get_periods.PERIOD_YEAR# AND
                GA2.ACTION_ID = GAP2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GAP2.ODEME_TURU IN (#yazar_kasa_cek_odeme_tipleri#) AND
                GA2.ACTION_ID NOT IN 
                (
                    SELECT 
                        GA_IC.ACTION_ID
                    FROM
                        #dsn_dev_alias#.GENIUS_ACTIONS GA_IC WITH (NOLOCK),
                        #dsn_dev_alias#.POS_CONS PC
                    WHERE
                        GA_IC.ZNO = PC.ZNO AND
                        GA_IC.KASA_NUMARASI = PC.KASA_NUMARASI AND
                        YEAR(GA2.FIS_TARIHI) = #get_periods.PERIOD_YEAR# AND
                        GA_IC.FIS_TARIHI >= #attributes.startdate# AND 
                        GA_IC.FIS_TARIHI < #dateadd('d',1,attributes.finishdate)#
                )
    ) T1
GROUP BY
	BASE_ALAN
</cfquery>
<cfoutput query="get_ccs">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'kasa_cek_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("kasa_cek_#hafta_#")>
        	<cfset 'kasa_cek_#hafta_#' = evaluate("kasa_cek_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'kasa_cek_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- alisveris cekleri --->

<!--- Kasa devirler --->
<cfquery name="get_kasa_devir" datasource="#dsn_dev#" result="kasa_devir_sonuc">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
    BASE_ALAN
FROM
	(
		SELECT
            CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET * KUR)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        CASE 
                        	WHEN CASH_ACTION_TO_CASH_ID IS NOT NULL THEN CASH_ACTION_VALUE 
                       		ELSE (-1 * CASH_ACTION_VALUE)
                       END AS CASH_HAREKET,
                       ISNULL((SELECT TOP 1 MH.RATE2 FROM #dsn_alias#.MONEY_HISTORY MH WHERE MH.MONEY = CA.CASH_ACTION_CURRENCY_ID AND MH.RECORD_DATE <= PPD.TARIH ORDER BY MH.RECORD_DATE DESC),1) AS KUR
                    FROM
                        #db_#.CASH_ACTIONS CA
                    WHERE
                    	CA.CASH_ACTION_VALUE > 0 AND
                        ACTION_DATE < PPD.TARIH AND
                        YEAR(ACTION_DATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_kasa_devir">
	<cfif listfind('d',attributes.count_type)>
		<cfset 'kasa_devir_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('m',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset ay_s_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset ay_bas =  "01.#ay_#.#yil_#">
        <cf_date tarih="ay_bas">
        
        <cfif datediff('d',attributes.startdate,ay_bas) lt 0>
        	<cfset ay_bas =  attributes.startdate>
        </cfif>
        
        <cfif '#dateformat(tarih_,"dd.mm.yyyy")#' is '#dateformat(ay_bas,"dd.mm.yyyy")#'>
			<cfset total_ = TOTAL>
            <cfset 'kasa_devir_#ay_s_#_#yil_#' = total_>
        </cfif>
    <cfelseif listfind('y',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset ay_bas =  "01.01.#yil_#">
        <cf_date tarih="ay_bas">
        
        <cfif datediff('d',attributes.startdate,ay_bas) lt 0>
        	<cfset ay_bas =  attributes.startdate>
        </cfif>
        
        <cfif '#dateformat(tarih_,"dd.mm.yyyy")#' is '#dateformat(ay_bas,"dd.mm.yyyy")#'>
			<cfset total_ = TOTAL>
            <cfset 'kasa_devir_#yil_#' = total_>
        </cfif>
	<cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfset hafta_ilk_gun = listgetat(evaluate('hafta_#hafta_#'),1)>
        
        <cfif hafta_ilk_gun is '#dateformat(tarih_,"dd.mm.yyyy")#'>
			<cfset total_ = TOTAL>
            <cfset 'kasa_devir_#hafta_#' = total_>
        </cfif>
    </cfif>
</cfoutput>
<!--- Kasa devirler --->

<!--- banka devirler --->
<cfquery name="get_banka_devir" datasource="#dsn_dev#" result="aaa">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                ISNULL((
                        SELECT
                        	SUM(HESAP_BAKIYE)
                        FROM
                        	(
                           SELECT
                                SUM(CASH_HAREKET * KUR) AS HESAP_BAKIYE,
                                HESAP_NO
                           FROM
                           (
                           <cfset count = 0>
                           <cfloop query="get_periods">
                           <cfset count = count + 1>
                           <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                               <cfif count neq 1>
                                UNION ALL
                               </cfif>
                                SELECT
                                   CASE WHEN CA.ACTION_TO_ACCOUNT_ID IS NOT NULL THEN CA.ACTION_TO_ACCOUNT_ID ELSE CA.ACTION_FROM_ACCOUNT_ID END AS HESAP_NO,
                                   CASE 
                                        WHEN ACTION_TO_ACCOUNT_ID IS NOT NULL THEN ACTION_VALUE 
                                        ELSE (-1 * ACTION_VALUE)
                                   END AS CASH_HAREKET,
                                   ISNULL((SELECT TOP 1 MH.RATE2 FROM #dsn_alias#.MONEY_HISTORY MH WHERE MH.MONEY = CA.ACTION_CURRENCY_ID AND MH.RECORD_DATE <= PPD.TARIH ORDER BY MH.RECORD_DATE DESC),1) AS KUR
                                FROM
                                    #db_#.BANK_ACTIONS CA
                                WHERE
                                    CA.ACTION_VALUE > 0 AND
                                    ACTION_DATE < DATEADD(dd,1,PPD.TARIH) AND
                                    YEAR(ACTION_DATE) = PPD.YIL
                           </cfloop>
                           ) T1
                           GROUP BY
                             HESAP_NO
                          ) T2
                       WHERE
                       	HESAP_BAKIYE > 0
                ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_banka_devir">
	<cfif listfind('d',attributes.count_type)>
		<cfset 'banka_devir_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('m',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset ay_s_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset ay_bas =  "01.#ay_#.#yil_#">
        <cf_date tarih="ay_bas">
        
        <cfif datediff('d',attributes.startdate,ay_bas) lt 0>
        	<cfset ay_bas =  attributes.startdate>
        </cfif>
        
        <cfif '#dateformat(tarih_,"dd.mm.yyyy")#' is '#dateformat(ay_bas,"dd.mm.yyyy")#'>
			<cfset total_ = TOTAL>
            <cfset 'banka_devir_#ay_s_#_#yil_#' = total_>
        </cfif>
    <cfelseif listfind('y',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset ay_bas =  "01.01.#yil_#">
        <cf_date tarih="ay_bas">
        
        <cfif datediff('d',attributes.startdate,ay_bas) lt 0>
        	<cfset ay_bas =  attributes.startdate>
        </cfif>
        
        <cfif '#dateformat(tarih_,"dd.mm.yyyy")#' is '#dateformat(ay_bas,"dd.mm.yyyy")#'>
			<cfset total_ = TOTAL>
            <cfset 'banka_devir_#yil_#' = total_>
        </cfif>
	<cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfset hafta_ilk_gun = listgetat(evaluate('hafta_#hafta_#'),1)>
        
        <cfif hafta_ilk_gun is '#dateformat(tarih_,"dd.mm.yyyy")#'>
			<cfset total_ = TOTAL>
            <cfset 'banka_devir_#hafta_#' = total_>
        </cfif>
    </cfif>
</cfoutput>
<!--- banka devirler --->

<!--- PORTFOY CEKLER --->
<cfquery name="get_p_cek" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        CHEQUE_VALUE CASH_HAREKET
                    FROM
                        #db_#.CHEQUE CA
                    WHERE
                        CHEQUE_STATUS_ID = 1 AND
                        SELF_CHEQUE = 1 AND
                        CHEQUE_DUEDATE = PPD.TARIH AND
                        YEAR(CHEQUE_DUEDATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_p_cek">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'p_cek_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("p_cek_#hafta_#")>
        	<cfset 'p_cek_#hafta_#' = evaluate("p_cek_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'p_cek_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- PORTFOY CEKLER --->

<!--- PORTFOY SENETLER --->
<cfquery name="get_p_senet" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        VOUCHER_VALUE CASH_HAREKET
                    FROM
                        #db_#.VOUCHER CA
                    WHERE
                        VOUCHER_STATUS_ID = 1 AND
                        SELF_VOUCHER = 1 AND
                        VOUCHER_DUEDATE = PPD.TARIH AND
                        YEAR(VOUCHER_DUEDATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_p_senet">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'p_senet_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("p_senet_#hafta_#")>
        	<cfset 'p_senet_#hafta_#' = evaluate("p_cek_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'p_senet_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- PORTFOY SENETLER --->

<!--- banka SENETLER --->
<cfquery name="get_b_senet" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        VOUCHER_VALUE CASH_HAREKET
                    FROM
                        #db_#.VOUCHER CA
                    WHERE
                        VOUCHER_STATUS_ID = 2 AND
                        SELF_VOUCHER = 1 AND
                        VOUCHER_DUEDATE = PPD.TARIH AND
                        YEAR(VOUCHER_DUEDATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_b_senet">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'b_senet_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("p_senet_#hafta_#")>
        	<cfset 'b_senet_#hafta_#' = evaluate("p_cek_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'b_senet_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- banka SENETLER --->

<!--- PORTFOY CEKLER --->
<cfquery name="get_b_cek" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        CHEQUE_VALUE CASH_HAREKET
                    FROM
                        #db_#.CHEQUE CA
                    WHERE
                        CHEQUE_STATUS_ID = 2 AND
                        SELF_CHEQUE = 1 AND
                        CHEQUE_DUEDATE = PPD.TARIH AND
                        YEAR(CHEQUE_DUEDATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_b_cek">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'b_cek_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("b_cek_#hafta_#")>
        	<cfset 'b_cek_#hafta_#' = evaluate("b_cek_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'b_cek_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- PORTFOY CEKLER --->

<!--- ana kasa cikislar --->
<cfquery name="get_kasa_odemeler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                       CASH_ACTION_VALUE AS CASH_HAREKET
                    FROM
                        #db_#.CASH_ACTIONS CA
                    WHERE
                    	CA.CASH_ACTION_FROM_CASH_ID = 1 AND
                        ACTION_DATE = PPD.TARIH AND
                        YEAR(ACTION_DATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>
<cfoutput query="get_kasa_odemeler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'kasa_odemeler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("kasa_odemeler_#hafta_#")>
        	<cfset 'kasa_odemeler_#hafta_#' = evaluate("kasa_odemeler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'kasa_odemeler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- ana kasa cikislar --->

<!--- SUBE kasa cikislar --->
<cfquery name="get_m_kasa_odemeler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                       CASH_ACTION_VALUE AS CASH_HAREKET
                    FROM
                        #db_#.CASH_ACTIONS CA,
                        #db_#.CASH C,
                        #dsn_alias#.DEPARTMENT D
                    WHERE
                    	C.CASH_ID = CA.CASH_ACTION_FROM_CASH_ID AND
                        CA.ACTION_TYPE_ID = 32 AND
                        D.DEPARTMENT_ID IN (#magaza_department_list#) AND
                        D.BRANCH_ID = C.BRANCH_ID AND
                        ACTION_DATE = PPD.TARIH AND
                        YEAR(ACTION_DATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>
<cfoutput query="get_m_kasa_odemeler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'm_kasa_odemeler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("m_kasa_odemeler_#hafta_#")>
        	<cfset 'm_kasa_odemeler_#hafta_#' = evaluate("m_kasa_odemeler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'm_kasa_odemeler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- sube kasa cikislar --->

<!--- odenecek CEKLER --->
<cfquery name="get_o_p_cek" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
    BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        CHEQUE_VALUE CASH_HAREKET
                    FROM
                        #db_#.CHEQUE CA
                    WHERE
                        CHEQUE_ID NOT IN (SELECT FROM_CHEQUE_VOUCHER_ID FROM #dsn_alias#.CHEQUE_VOUCHER_COPY_REF WHERE IS_CHEQUE = 1 AND FROM_PERIOD_ID = #get_periods.PERIOD_ID#) AND
                        CHEQUE_STATUS_ID = 6 AND
                        ISNULL(SELF_CHEQUE,0) = 0 AND
                        CHEQUE_DUEDATE = PPD.TARIH AND
                        YEAR(CHEQUE_DUEDATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>


<cfoutput query="get_o_p_cek">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'o_p_cek_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("o_p_cek_#hafta_#")>
        	<cfset 'o_p_cek_#hafta_#' = evaluate("o_p_cek_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'o_p_cek_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- PORTFOY CEKLER --->

<!--- PORTFOY SENETLER --->
<cfquery name="get_o_p_senet" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   <cfset count = 0>
               <cfloop query="get_periods">
               <cfset count = count + 1>
               <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                   <cfif count neq 1>
                    UNION ALL
                   </cfif>
                    SELECT
                        VOUCHER_VALUE CASH_HAREKET
                    FROM
                        #db_#.VOUCHER CA
                    WHERE
                        VOUCHER_STATUS_ID = 6 AND
                        ISNULL(SELF_VOUCHER,0) = 0 AND
                        VOUCHER_DUEDATE = PPD.TARIH AND
                        YEAR(VOUCHER_DUEDATE) = PPD.YIL
               </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_o_p_senet">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'o_p_senet_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("o_p_senet_#hafta_#")>
        	<cfset 'o_p_senet_#hafta_#' = evaluate("o_p_senet_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'o_p_senet_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- PORTFOY SENETLER --->

<!--- taksitli krediler --->
<cfquery name="get_taksitli_krediler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
                    SELECT
                        CR.TOTAL_PRICE AS CASH_HAREKET
                    FROM
                        #dsn3_alias#.CREDIT_CONTRACT_ROW CR,
                        #dsn3_alias#.CREDIT_CONTRACT CC
                    WHERE
                    	CC.CREDIT_TYPE IN (2,6) AND
                        CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
                        CR.CREDIT_CONTRACT_TYPE = 1 AND
                        CR.IS_PAID = 0 AND
                        ISNULL(CR.IS_PAID_ROW,0) = 0 AND
                       	CR.PROCESS_DATE = PPD.TARIH 
                        --AND CR.PROCESS_DATE >= #bugun_#
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_taksitli_krediler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'taksitli_krediler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("taksitli_krediler_#hafta_#")>
        	<cfset 'taksitli_krediler_#hafta_#' = evaluate("taksitli_krediler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'taksitli_krediler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- taksitli krediler --->

<!--- TASit krediler --->
<cfquery name="get_tasit_krediler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
                    SELECT
                        CR.TOTAL_PRICE AS CASH_HAREKET
                    FROM
                        #dsn3_alias#.CREDIT_CONTRACT_ROW CR,
                        #dsn3_alias#.CREDIT_CONTRACT CC
                    WHERE
                    	CC.CREDIT_TYPE = 3 AND
                        CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
                        CR.CREDIT_CONTRACT_TYPE = 1 AND
                        CR.IS_PAID = 0 AND
                        ISNULL(CR.IS_PAID_ROW,0) = 0 AND
                       	CR.PROCESS_DATE = PPD.TARIH 
                        --AND CR.PROCESS_DATE >= #bugun_#
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_tasit_krediler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'tasit_krediler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("tasit_krediler_#hafta_#")>
        	<cfset 'tasit_krediler_#hafta_#' = evaluate("tasit_krediler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'tasit_krediler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- TASit krediler --->

<!--- rotatif krediler --->
<cfquery name="get_rotatif_krediler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
                    SELECT
                        CR.TOTAL_PRICE AS CASH_HAREKET
                    FROM
                        #dsn3_alias#.CREDIT_CONTRACT_ROW CR,
                        #dsn3_alias#.CREDIT_CONTRACT CC
                    WHERE
                    	CC.CREDIT_TYPE IN (1,5) AND
                        CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
                        CR.CREDIT_CONTRACT_TYPE = 1 AND
                        CR.IS_PAID = 0 AND
                        ISNULL(CR.IS_PAID_ROW,0) = 0 AND
                        CR.PROCESS_DATE = PPD.TARIH
                        --AND CR.PROCESS_DATE >= #bugun_# 
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_rotatif_krediler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'rotatif_krediler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("rotatif_krediler_#hafta_#")>
        	<cfset 'rotatif_krediler_#hafta_#' = evaluate("rotatif_krediler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'rotatif_krediler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- rotatif_krediler_ --->

<!--- kmh krediler --->
<cfquery name="get_kmh_krediler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
                    SELECT
                        CASE WHEN CR.IS_PAID = 0 THEN CR.TOTAL_PRICE ELSE (-1 * CR.TOTAL_PRICE) END AS CASH_HAREKET
                    FROM
                        #dsn3_alias#.CREDIT_CONTRACT_ROW CR,
                        #dsn3_alias#.CREDIT_CONTRACT CC
                    WHERE
                        CC.CREDIT_TYPE = 4 AND
                        CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
                        CR.CREDIT_CONTRACT_TYPE = 1 AND
                        CR.IS_PAID = 0 AND
                        ISNULL(CR.IS_PAID_ROW,0) = 0 AND
                       	CR.PROCESS_DATE = PPD.TARIH 
                        --AND CR.PROCESS_DATE >= #bugun_#
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_kmh_krediler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'kmh_krediler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("kmh_krediler_#hafta_#")>
        	<cfset 'kmh_krediler_#hafta_#' = evaluate("kmh_krediler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'kmh_krediler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- kmh krediler --->

<!--- get_cc_odemeler --->
<cfquery name="get_cc_odemeler" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(HARCAMA-ODEME-GELECEK_TAKSIT)
               FROM
               (
                    SELECT
                        ISNULL(CC.EXTRE_VALUE,0) AS CASH_HAREKET,
                        ISNULL((
                        	SELECT 
                            	SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT 
                           	FROM 
                            	#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                           	WHERE 
                            	CCE.CREDITCARD_ID = CC.CREDITCARD_ID
                            ),0) AS HARCAMA,
                        ISNULL(
                        (
                            SELECT 
                                SUM(CREDIT_CARD_BANK_EXPENSE_RELATIONS.CLOSED_AMOUNT) 
                            FROM 
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS,
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS,
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
                            WHERE 
                                CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID = CC.CREDITCARD_ID AND
                                CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID AND
                                CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID
                        ),0) ODEME,
                        ISNULL(
                        (
                        	SELECT 
                            	SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT 
                            FROM 
                            	#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                            WHERE 
                            	CCE.CREDITCARD_ID = CC.CREDITCARD_ID AND 
                                CCE.ACC_ACTION_DATE > CC.CLOSE_DATE AND 
                                CCE.ACC_ACTION_DATE <= CC.NEXT_CLOSE_DATE
                        ),0) AS DONEM_ICI,
                        ISNULL(
                        (
                        	SELECT 
                                SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT
                            FROM 
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                            WHERE 
                                CCE.CREDITCARD_ID = CC.CREDITCARD_ID AND 
                                CCE.ACC_ACTION_DATE > CC.NEXT_CLOSE_DATE
                        ),0) AS GELECEK_TAKSIT
                    FROM
                        #dsn3_alias#.CREDIT_CARD CC
                    WHERE
                        (
                            CC.PAYMENT_DATE = PPD.TARIH
                        )
                        --AND CC.CREDITCARD_ID = 45
                  UNION
                  SELECT
                        ISNULL(CC.EXTRE_VALUE,0) AS CASH_HAREKET,
                        ISNULL((
                        	SELECT 
                            	SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT 
                           	FROM 
                            	#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                           	WHERE 
                            	CCE.CREDITCARD_ID = CC.CREDITCARD_ID
                            ),0) AS HARCAMA,
                        ISNULL(
                        (
                            SELECT 
                                SUM(CREDIT_CARD_BANK_EXPENSE_RELATIONS.CLOSED_AMOUNT) 
                            FROM 
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS,
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS,
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
                            WHERE 
                                CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID = CC.CREDITCARD_ID AND
                                CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID AND
                                CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID
                        ),0) ODEME,
                        0 AS DONEM_ICI,
                        ISNULL(
                        (
                        	SELECT 
                                SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT
                            FROM 
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                            WHERE 
                                CCE.CREDITCARD_ID = CC.CREDITCARD_ID AND 
                                CCE.ACC_ACTION_DATE > CC.NEXT_CLOSE_DATE
                        ),0) AS GELECEK_TAKSIT
                    FROM
                        #dsn3_alias#.CREDIT_CARD CC
                    WHERE
                        (
                            CC.NEXT_PAYMENT_DATE = PPD.TARIH AND
                            CC.PAYMENT_DATE < #attributes.startdate# AND
                            CC.NEXT_PAYMENT_DATE >= #attributes.startdate#
                        )
                       -- AND CC.CREDITCARD_ID = 45
                  UNION
                  SELECT
                        ISNULL(CC.EXTRE_VALUE,0) AS CASH_HAREKET,
                        ISNULL((
                        	SELECT 
                            	SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT 
                           	FROM 
                            	#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                           	WHERE 
                            	CCE.CREDITCARD_ID = CC.CREDITCARD_ID
                            ),0) AS HARCAMA,
                        ISNULL(
                        (
                            SELECT 
                                SUM(CREDIT_CARD_BANK_EXPENSE_RELATIONS.CLOSED_AMOUNT) 
                            FROM 
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_RELATIONS,
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS,
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE
                            WHERE 
                                CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID = CC.CREDITCARD_ID AND
                                CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID AND
                                CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID
                        ),0) ODEME,
                        0 AS DONEM_ICI,
                        ISNULL(
                        (
                        	SELECT 
                                SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT
                            FROM 
                                #dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                            WHERE 
                                CCE.CREDITCARD_ID = CC.CREDITCARD_ID AND 
                                CCE.ACC_ACTION_DATE > CC.NEXT_CLOSE_DATE
                        ),0) AS GELECEK_TAKSIT
                    FROM
                        #dsn3_alias#.CREDIT_CARD CC
                    WHERE
                        (
                            CC.NEXT_PAYMENT_DATE < PPD.TARIH AND
                            PPD.TARIH = #attributes.startdate# AND
                            CC.PAYMENT_DATE < #attributes.startdate# AND
                            CC.NEXT_PAYMENT_DATE < #attributes.startdate#
                        )
                        --AND CC.CREDITCARD_ID = 45
                  UNION
                  	SELECT
                    	0 AS CASH_HAREKET,
                        SUM(INSTALLMENT_AMOUNT) HARCAMA,
                        0 AS ODEME,
                        0 AS DONEM_ICI,
                        0 AS GELECEK_TAKSIT
                    FROM
                    	#dsn3_alias#.CREDIT_CARD_BANK_EXPENSE_ROWS CCE,
                        #dsn3_alias#.CREDIT_CARD CC
                    WHERE
                    	CCE.CREDITCARD_ID = CC.CREDITCARD_ID AND 
                        CCE.ACC_ACTION_DATE > CC.NEXT_CLOSE_DATE AND
                        CCE.ACC_ACTION_DATE = PPD.TARIH 
                        --AND CC.CREDITCARD_ID = 45                  	
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_cc_odemeler">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'cc_odemeler_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("cc_odemeler_#hafta_#")>
        	<cfset 'cc_odemeler_#hafta_#' = evaluate("cc_odemeler_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'cc_odemeler_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- get_cc_odemeler --->

<!--- SİPARİS --->
<cfquery name="get_siparis" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET - DONUSEN)
               FROM
               (
                    SELECT
                        ROUND((ORR.NETTOTAL * (100 + ORR.TAX) / 100),2) AS CASH_HAREKET,
                        ISNULL((
                                SELECT
                                	SUM(TOTAL)
                                FROM
                                	(
                                	<cfset count = 0>
                                   <cfloop query="get_periods_all">
                                   <cfset count = count + 1>
                                   <cfset db_ = "#dsn#_#get_periods_all.PERIOD_YEAR#_#session.ep.company_id#">
                                   <cfif count neq 1>
                                    UNION ALL
                                   </cfif>
                                    SELECT 
                                    	ROUND(SUM(SR.GROSSTOTAL),2) AS TOTAL
                                    FROM
                                    	#db_#.SHIP S,
                                        #db_#.SHIP_ROW SR,
                                        #dsn3_alias#.ORDERS_SHIP OSS
                                    WHERE
                                    	S.SHIP_ID = SR.SHIP_ID AND
                                        OSS.SHIP_ID = S.SHIP_ID AND
                                        OSS.ORDER_ID = O.ORDER_ID AND
                                        SR.STOCK_ID = ORR.STOCK_ID
                                   </cfloop>
                                   ) T1 
                                ),0)
                          AS DONUSEN
                    FROM
                        #dsn3_alias#.ORDERS O,
                        #dsn3_alias#.ORDER_ROW ORR
                    WHERE
                        O.COMPANY_ID NOT IN (SELECT OWNER_ID FROM #dsn_alias#.INFO_PLUS WHERE PROPERTY3 = 'Hayır' AND INFO_OWNER_TYPE = -1) AND
                        O.ORDER_STAGE = #valid_order_stage_# AND
                        O.ORDER_STATUS = 1 AND
                        O.PURCHASE_SALES = 0 AND	
                        O.ORDER_ID = ORR.ORDER_ID AND
						DATEADD(dd,ISNULL(ORR.DUEDATE,0),O.ORDER_DATE) = PPD.TARIH AND
                        O.ORDER_DATE >= #dateadd('d',order_control_day,bugun_)#
               ) T1
               WHERE
               	ROUND(CASH_HAREKET,2) >= ROUND(DONUSEN,2)
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
            TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>


<cfoutput query="get_siparis">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'siparis_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("siparis_#hafta_#")>
        	<cfset 'siparis_#hafta_#' = evaluate("siparis_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'siparis_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- siparis --->

<!--- irsaliye --->
<cfquery name="get_irsaliye" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
			   	   <cfset count = 0>
                   <cfloop query="get_periods_all">
                   <cfset count = count + 1>
                   <cfset db_ = "#dsn#_#get_periods_all.PERIOD_YEAR#_#session.ep.company_id#">
                       <cfif count neq 1>
                        UNION ALL
                       </cfif>
                       SELECT
                            SUM(ORR.GROSSTOTAL) AS CASH_HAREKET
                        FROM
                            #db_#.SHIP O,
                            #db_#.SHIP_ROW ORR
                        WHERE
                            O.SHIP_STATUS = 1 AND
                            O.SHIP_TYPE = 76 AND
                            O.PURCHASE_SALES = 0 AND
                            O.SHIP_ID = ORR.SHIP_ID AND
                            O.SHIP_ID NOT IN (SELECT ISS.SHIP_ID FROM #db_#.INVOICE_SHIPS ISS) AND
                            O.DUE_DATE = PPD.TARIH
                   </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>
<cfoutput query="get_irsaliye">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'irsaliye_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("irsaliye_#hafta_#")>
        	<cfset 'irsaliye_#hafta_#' = evaluate("irsaliye_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'irsaliye_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- irsaliye --->


<!--- fatura --->
<cfquery name="get_fatura" datasource="#dsn_dev#" result="get_fatura_r">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(ROUND(NETTOTAL,2) - ROUND(DUSULECEK,2))
               FROM
               (
			   	   <cfset count = 0>
                   <cfloop query="get_periods">
                   <cfset count = count + 1>
                   <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                       <cfif count neq 1>
                        UNION ALL
                       </cfif>
                       SELECT
                            NETTOTAL, 
                            ISNULL((
                                    SELECT 
                                        SUM(CRR.RELATED_VALUE) AS DUS 
                                    FROM 
                                        #dsn_dev_alias#.CARI_ROW_RELATIONS CRR 
                                    WHERE 
                                        CRR.IN_CARI_ACTION_ID = CR.CARI_ACTION_ID AND 
                                        CRR.PERIOD_ID = #get_periods.PERIOD_ID#
                                ),0) AS DUSULECEK
                        FROM
                            #db_#.INVOICE O,
                            #db_#.CARI_ROWS CR
                        WHERE
                            CR.ACTION_TABLE = 'INVOICE' AND
                            CR.ACTION_TYPE_ID = 59 AND
                            CR.ACTION_ID = O.INVOICE_ID AND
                            O.COMPANY_ID NOT IN (SELECT OWNER_ID FROM #dsn_alias#.INFO_PLUS WHERE PROPERTY2 = 'Hayır' AND INFO_OWNER_TYPE = -1) AND
                            O.INVOICE_CAT = 59 AND
                            O.IS_IPTAL = 0 AND
                            O.PURCHASE_SALES = 0 AND	
                            ISNULL(O.DUE_DATE,O.INVOICE_DATE) = PPD.TARIH 
                            --AND ISNULL(O.DUE_DATE,O.INVOICE_DATE) >= #bugun_#
                   </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>


<cfoutput query="get_fatura">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'fatura_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("fatura_#hafta_#")>
        	<cfset 'fatura_#hafta_#' = evaluate("fatura_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'fatura_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>


<!--- gider fatura --->
<cfquery name="get_gider_fatura" datasource="#dsn_dev#" result="get_gider_fatura_r">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(ROUND(NETTOTAL,2) - ROUND(DUSULECEK,2))
               FROM
               (
			   	   <cfset count = 0>
                   <cfloop query="get_periods">
                   <cfset count = count + 1>
                   <cfset db_ = "#dsn#_#get_periods.PERIOD_YEAR#_#session.ep.company_id#">
                       <cfif count neq 1>
                        UNION ALL
                       </cfif>
                       SELECT
                            TOTAL_AMOUNT_KDVLI AS NETTOTAL, 
                            ISNULL((
                                    SELECT 
                                        SUM(CRR.RELATED_VALUE) AS DUS 
                                    FROM 
                                        #dsn_dev_alias#.CARI_ROW_RELATIONS CRR 
                                    WHERE 
                                        CRR.IN_CARI_ACTION_ID = CR.CARI_ACTION_ID AND 
                                        CRR.PERIOD_ID = #get_periods.PERIOD_ID#
                                ),0) AS DUSULECEK
                        FROM
                            #db_#.EXPENSE_ITEM_PLANS EIP,
                            #db_#.CARI_ROWS CR
                        WHERE
                            EIP.ACTION_TYPE = 120 AND
                            CR.ACTION_TABLE = 'EXPENSE_ITEM_PLANS' AND
                            CR.ACTION_TYPE_ID = 120 AND
                            CR.ACTION_ID = EIP.EXPENSE_ID AND
                            ISNULL(EIP.DUE_DATE,EIP.EXPENSE_DATE) = PPD.TARIH 
                            --AND ISNULL(EIP.DUE_DATE,EIP.EXPENSE_DATE) >= #bugun_#
                   </cfloop>
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>


<cfoutput query="get_gider_fatura">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'gider_fatura_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("gider_fatura_#hafta_#")>
        	<cfset 'gider_fatura_#hafta_#' = evaluate("gider_fatura_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'gider_fatura_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>

<!--- CEK EKRANI --->
<cfquery name="get_cek_ekran" datasource="#dsn_dev#">
SELECT
	SUM(CASH_ACTION_VALUE) AS TOTAL,
   	BASE_ALAN
FROM
	(
		SELECT
        	<cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'm'>
                CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            <cfelseif attributes.count_type is 'y'>
                CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
            </cfif>
            ISNULL((
               SELECT
               		SUM(CASH_HAREKET)
               FROM
               (
                    SELECT 
                        PTR.BAKIYE AS CASH_HAREKET
                    FROM 
                        PAYMENT_TABLE PT,
                        PAYMENT_TABLE_ROWS PTR
                    WHERE
                        PT.TABLE_ID = PTR.TABLE_ID AND
                        ISNULL(PT.IS_PAID,0) = 0 AND
                      	PTR.ODEME_GUNU_TARIH = PPD.TARIH
               ) T1
            ),0) AS CASH_ACTION_VALUE
        FROM
        	PRODUCT_PRICE_DATES PPD
        WHERE
        	TARIH >= #attributes.startdate# AND
            TARIH < #dateadd('d',1,attributes.finishdate)#
   ) T1
GROUP BY
	BASE_ALAN
</cfquery>

<cfoutput query="get_cek_ekran">
	<cfif listfind('d,m,y',attributes.count_type)>
		<cfset 'cek_ekran_#BASE_ALAN#' = TOTAL>
    <cfelseif listfind('w',attributes.count_type)>
    	<cfset gun_ = listfirst(BASE_ALAN,'_')>
        <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
        <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
        
        <cfif len(gun_) eq 1>
        	<cfset gun_ = '0#gun_#'>
        </cfif>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = '0#ay_#'>
        </cfif>
        <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
        <cf_date tarih="tarih_">
        
        <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
		<cfif isdefined("cek_ekran_#hafta_#")>
        	<cfset 'cek_ekran_#hafta_#' = evaluate("cek_ekran_#hafta_#") + TOTAL>
        <cfelse>
        	<cfset 'cek_ekran_#hafta_#' = TOTAL>
        </cfif>
    </cfif>
</cfoutput>
<!--- cek ekranı --->

<cfloop from="1" to="#kolon_sayisi#" index="dongu">
    <cfif attributes.count_type is 'd'>
        <cfset ek_ = dongu - 1>
        <cfset tarih_ = dateadd("d",ek_,attributes.startdate)>
        <cfset 'base_alan_#dongu#' = day(tarih_) & '_' & month(tarih_) & '_' & year(tarih_)>
    <cfelseif attributes.count_type is 'm'>
        <cfset ek_ = dongu - 1>
        <cfset tarih_ = dateadd("m",ek_,attributes.startdate)>
        <cfset 'base_alan_#dongu#' = month(tarih_) & '_' & year(tarih_)>
    <cfelseif attributes.count_type is 'y'>
        <cfset ek_ = dongu - 1>
        <cfset tarih_ = dateadd("yyyy",ek_,attributes.startdate)>
        <cfset 'base_alan_#dongu#' = year(tarih_)>
    <cfelseif attributes.count_type is 'w'>
        <cfset 'base_alan_#dongu#' = '#dongu#'>
    </cfif>
    
    <cfset 'kolon_gelir_total_#dongu#' = 0>
    <cfset 'kolon_gelir_ara_total_#dongu#' = 0>
    <cfset 'kolon_gider_total_#dongu#' = 0>
</cfloop>
<cfset kolon_gelir_total_dip = 0>
<cfset kolon_gelir_ara_total_dip = 0>
<cfset kolon_gider_total_dip = 0>



<!--- giderler --->
<cfquery name="get_giderler" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY WHERE IS_OUT = 1 AND CODE IS NOT NULL AND ACTIVITY_STATUS = 1
</cfquery>

<cfif get_giderler.recordcount>
<cfloop query="get_giderler">
	<cfset name_ = code>
    <cfset id_ = activity_id>
    <cfquery name="get_gider" datasource="#dsn_dev#">
    SELECT
        SUM(CASH_ACTION_VALUE) AS TOTAL,
        BASE_ALAN
    FROM
        (
            SELECT
                <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                    CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                <cfelseif attributes.count_type is 'm'>
                    CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                <cfelseif attributes.count_type is 'y'>
                    CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                </cfif>
                ISNULL((
                   SELECT
                        SUM(CASH_HAREKET)
                   FROM
                   (
                        SELECT
                            ROW_TOTAL_EXPENSE AS CASH_HAREKET
                        FROM
                            #dsn_alias#.BUDGET_PLAN BP,
                            #dsn_alias#.BUDGET_PLAN_ROW BPR
                        WHERE
                            BPR.ACTIVITY_TYPE_ID = #id_# AND
                            BP.PROCESS_TYPE = 160 AND
                            BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID AND
                            BPR.PLAN_DATE = PPD.TARIH AND
                            BPR.PLAN_DATE >= #bugun_#
                   ) T1
                ),0) AS CASH_ACTION_VALUE
            FROM
                PRODUCT_PRICE_DATES PPD
            WHERE
                TARIH >= #attributes.startdate# AND
                TARIH < #dateadd('d',1,attributes.finishdate)#
       ) T1
    GROUP BY
        BASE_ALAN
    </cfquery>
    <cfoutput query="get_gider">
        <cfif listfind('d,m,y',attributes.count_type)>
            <cfset '#name_#_#BASE_ALAN#' = TOTAL>
        <cfelseif listfind('w',attributes.count_type)>
            <cfset gun_ = listfirst(BASE_ALAN,'_')>
            <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
            <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
            
            <cfif len(gun_) eq 1>
                <cfset gun_ = '0#gun_#'>
            </cfif>
            <cfif len(ay_) eq 1>
                <cfset ay_ = '0#ay_#'>
            </cfif>
            <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
            <cf_date tarih="tarih_">
            
            <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
            <cfif isdefined("#name_#_#hafta_#")>
                <cfset '#name_#_#hafta_#' = evaluate("#name_#_#hafta_#") + TOTAL>
            <cfelse>
                <cfset '#name_#_#hafta_#' = TOTAL>
            </cfif>
        </cfif>
    </cfoutput>
</cfloop>
</cfif>
<!--- giderler --->

<!--- gelirler --->
<cfquery name="get_gelirler" datasource="#dsn#">
	SELECT * FROM SETUP_ACTIVITY WHERE IS_IN = 1 AND CODE IS NOT NULL AND ACTIVITY_STATUS = 1
</cfquery>

<cfif get_gelirler.recordcount>
<cfloop query="get_gelirler">
	<cfset name_ = code>
    <cfset id_ = activity_id>
    <cfquery name="get_gelir" datasource="#dsn_dev#">
    SELECT
        SUM(CASH_ACTION_VALUE) AS TOTAL,
        BASE_ALAN
    FROM
        (
            SELECT
                <cfif attributes.count_type is 'd' or attributes.count_type is 'w'>
                    CAST(DAY(TARIH) AS NVARCHAR) + '_' + CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                <cfelseif attributes.count_type is 'm'>
                    CAST(MONTH(TARIH) AS NVARCHAR) + '_' + CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                <cfelseif attributes.count_type is 'y'>
                    CAST(YEAR(TARIH) AS NVARCHAR) BASE_ALAN,
                </cfif>
                ISNULL((
                   SELECT
                        SUM(CASH_HAREKET)
                   FROM
                   (
                        SELECT
                            ROW_TOTAL_INCOME AS CASH_HAREKET
                        FROM
                            #dsn_alias#.BUDGET_PLAN BP,
                            #dsn_alias#.BUDGET_PLAN_ROW BPR
                        WHERE
                            BPR.ACTIVITY_TYPE_ID = #id_# AND
                            BP.PROCESS_TYPE = 160 AND
                            BP.BUDGET_PLAN_ID = BPR.BUDGET_PLAN_ID AND
                            BPR.PLAN_DATE = PPD.TARIH AND
                            BPR.PLAN_DATE >= #bugun_#
                   ) T1
                ),0) AS CASH_ACTION_VALUE
            FROM
                PRODUCT_PRICE_DATES PPD
            WHERE
                TARIH >= #attributes.startdate# AND
                TARIH < #dateadd('d',1,attributes.finishdate)#
       ) T1
    GROUP BY
        BASE_ALAN
    </cfquery>
    <cfoutput query="get_gelir">
        <cfif listfind('d,m,y',attributes.count_type)>
            <cfset '#name_#_#BASE_ALAN#' = TOTAL>
        <cfelseif listfind('w',attributes.count_type)>
            <cfset gun_ = listfirst(BASE_ALAN,'_')>
            <cfset ay_ = listgetat(BASE_ALAN,2,'_')>
            <cfset yil_ = listgetat(BASE_ALAN,3,'_')>
            
            <cfif len(gun_) eq 1>
                <cfset gun_ = '0#gun_#'>
            </cfif>
            <cfif len(ay_) eq 1>
                <cfset ay_ = '0#ay_#'>
            </cfif>
            <cfset tarih_ = '#gun_#.#ay_#.#yil_#'>
            <cf_date tarih="tarih_">
            
            <cfset hafta_ = int(datediff('d',ilk_hafta_baslama_,tarih_) / 7) + 1>
            <cfif isdefined("#name_#_#hafta_#")>
                <cfset '#name_#_#hafta_#' = evaluate("#name_#_#hafta_#") + TOTAL>
            <cfelse>
                <cfset '#name_#_#hafta_#' = TOTAL>
            </cfif>
        </cfif>
    </cfoutput>
</cfloop>
</cfif>

<!--- get_gelirler --->
<cfset uncheck_fon_rows = 'yunus'>
<cfquery name="get_fon_rows" datasource="#dsn_dev#">
	SELECT * FROM FON_ROWS WHERE KOLON_DEGER = 'false'
</cfquery>
<cfif get_fon_rows.recordcount>
	<cfset uncheck_fon_rows = listappend(uncheck_fon_rows,valuelist(get_fon_rows.kolon_ad))>
</cfif>

<cfset query_count = 0>

<cfset name_list = "is_active">
<cfset deger_list = "varchar">

<cfset name_list = listappend(name_list,'kolon_ad')>
<cfset deger_list = listappend(deger_list,'varchar')>

<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset name_list = listappend(name_list,'alan_#dongu#')>
    <cfset deger_list = listappend(deger_list,'varchar')>
</cfloop>
<cfset name_list = listappend(name_list,'toplam')>
<cfset deger_list = listappend(deger_list,'varchar')>

<cfset name_list = listappend(name_list,'row_type')>
<cfset deger_list = listappend(deger_list,'varchar')>

<cfset name_list = listappend(name_list,'process_type')>
<cfset deger_list = listappend(deger_list,'varchar')>

<cfset myQuery = QueryNew("#name_list#","#deger_list#")>

<!--- basliklar --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","A - Giriş Değerleri",query_count)>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- basliklar --->

<!--- likit deger --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'kasa')>
	<cfset is_active_ = "false">
<cfelse>
	<cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Likit Değerlilik Yapısı O Günkü",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("kasa_#b_#")>
        <cfset alan_ = evaluate("kasa_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","3",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","kasa",query_count)>
<!--- likit deger --->

<!--- kksatis --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'kasa_pos')>
	<cfset is_active_ = "false">
<cfelse>
	<cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Kredi Kartıyla Yapılan Satış",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("kasa_pos_#b_#")>
        <cfset alan_ = evaluate("kasa_pos_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","3",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","kasa_pos",query_count)>
<!--- kksatis --->

<!--- kceksatis --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'kasa_cek')>
	<cfset is_active_ = "false">
<cfelse>
	<cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Alışveriş Çekiyle Satış",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("kasa_cek_#b_#")>
        <cfset alan_ = evaluate("kasa_cek_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","kasa_cek",query_count)>
<!--- kceksatis --->

<cfset giderler2 = "m_kasa_odemeler,kasa_odemeler">
<cfset giderler_name2 = "Nakit Kasadan Ödemeler,Ana Kasadan Ödemeler">
<cfloop from="1" to="#listlen(giderler2)#" index="aa">
	<cfset alan_id_ = listgetat(giderler2,aa)>
    <cfset alan_ad_ = listgetat(giderler_name2,aa)>

	<cfset query_count = query_count + 1>
    <cfset newRow = QueryAddRow(myQuery,1)>
    <cfif listfind(uncheck_fon_rows,'#alan_id_#')>
		<cfset is_active_ = "false">
    <cfelse>
        <cfset is_active_ = "true">
    </cfif>
    <cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"kolon_ad","#alan_ad_#",query_count)>
    <cfset row_last_total = 0>
    <cfloop from="1" to="#kolon_sayisi#" index="dongu">
        <cfset b_ = evaluate('base_alan_#dongu#')>
        <cfif isdefined("#alan_id_#_#b_#")>
            <cfset alan_ = evaluate("#alan_id_#_#b_#")>
        <cfelse>
            <cfset alan_ = 0>
        </cfif>
        <cfset row_last_total = row_last_total + alan_>
        <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
    </cfloop>
    <cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"row_type","-4",query_count)>
    <cfset temp = QuerySetCell(myQuery,"process_type","#alan_id_#",query_count)>
</cfloop>

<!--- aratotal --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Kasa + Kredi Kartı Toplamı",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","1",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- aratotal --->

<!--- onceki gunden --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'kasa_devir')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Önceki Günden Devir",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("kasa_devir_#b_#")>
        <cfset alan_ = evaluate("kasa_devir_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","kasa_devir",query_count)>
<!--- onceki gunden --->

<!--- banka devir --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'banka_devir')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Banka Nakit Değerliliği",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("banka_devir_#b_#")>
        <cfset alan_ = evaluate("banka_devir_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","banka_devir",query_count)>
<!--- banka devir --->

<!--- pcek --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'p_cek')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Portföydeki Çekler",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("p_cek_#b_#")>
        <cfset alan_ = evaluate("p_cek_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","p_cek",query_count)>
<!--- pcek --->

<!--- bps --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'b_senet')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Banka Portföy Senetleri",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("b_senet_#b_#")>
        <cfset alan_ = evaluate("b_senet_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","b_senet",query_count)>
<!--- bps --->

<!--- bpc --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'b_cek')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Banka Portföy Çekleri",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("b_cek_#b_#")>
        <cfset alan_ = evaluate("b_cek_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","b_cek",query_count)>
<!--- bpc --->

<!--- ps --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'p_senet')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Portföydeki Alacak Senetleri",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
	<cfif isdefined("p_senet_#b_#")>
        <cfset alan_ = evaluate("p_senet_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = row_last_total + alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","p_senet",query_count)>
<!--- ps --->

<!--- banka krediler --->
<cfquery name="get_banka_kmh" datasource="#dsn3#">
	SELECT
    	ISNULL(SUM(ACCOUNT_KMH_LIMIT),0) AS KMH_LIMIT,
        ISNULL((
                SELECT
                    SUM(CR.TOTAL_PRICE)
                FROM
                    #dsn3_alias#.CREDIT_CONTRACT_ROW CR,
                    #dsn3_alias#.CREDIT_CONTRACT CC
                WHERE
                    CC.CREDIT_TYPE = 4 AND
                    CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
                    CR.CREDIT_CONTRACT_TYPE = 1 AND
                    CR.IS_PAID = 0 AND
                    ISNULL(CR.IS_PAID_ROW,0) = 0 
                    --AND CR.PROCESS_DATE >= #bugun_#
       ),0) AS KULLANILAN
    FROM
    	ACCOUNTS
    WHERE
    	ISNULL(ACCOUNT_KMH_LIMIT,0) > 0
</cfquery>
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'b_kredi_nakit')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Banka Kredi Nakit Gün İçi Limit",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
    <cfset 'b_kredi_nakit_#b_#' = get_banka_kmh.KMH_LIMIT - get_banka_kmh.KULLANILAN>
	<cfif isdefined("b_kredi_nakit_#b_#")>
        <cfset alan_ = evaluate("b_kredi_nakit_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","b_kredi_nakit",query_count)>


<cfquery name="get_banka_credit" datasource="#dsn3#">
	SELECT
    	ISNULL(SUM(ACCOUNT_CREDIT_LIMIT),0) AS CREDIT_LIMIT,
        ISNULL((
                SELECT
                    SUM(CR.TOTAL_PRICE)
                FROM
                    #dsn3_alias#.CREDIT_CONTRACT_ROW CR,
                    #dsn3_alias#.CREDIT_CONTRACT CC
                WHERE
                    CC.CREDIT_TYPE IN (1,2,5,6) AND
                    CC.CREDIT_CONTRACT_ID = CR.CREDIT_CONTRACT_ID AND
                    CR.CREDIT_CONTRACT_TYPE = 1 AND
                    CR.IS_PAID = 0 AND
                    ISNULL(CR.IS_PAID_ROW,0) = 0 AND
                    CR.PROCESS_DATE >= #bugun_#
       ),0) AS KULLANILAN
    FROM
    	ACCOUNTS
    WHERE
    	ISNULL(ACCOUNT_CREDIT_LIMIT,0) > 0
</cfquery>
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfif listfind(uncheck_fon_rows,'b_kredi_rotatif')>
	<cfset is_active_ = "false">
<cfelse>
    <cfset is_active_ = "true">
</cfif>
<cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Banka Kredi Rotatif / Taksitli Limit",query_count)>
<cfset row_last_total = 0>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
	<cfset b_ = evaluate('base_alan_#dongu#')>
    <cfset 'b_kredi_rotatif_#b_#' = -1 * (get_banka_credit.CREDIT_LIMIT - get_banka_credit.KULLANILAN)>
	<cfif isdefined("b_kredi_rotatif_#b_#")>
        <cfset alan_ = evaluate("b_kredi_rotatif_#b_#")>
    <cfelse>
        <cfset alan_ = 0>
    </cfif>
    <cfset row_last_total = alan_>
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","4",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","b_kredi_rotatif",query_count)>
<!--- banka krediler --->

<!--- atotal --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","A-Toplam",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","5",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- atotal --->
<!--- tahmin gelir baslik --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","C - Diğer Gelirler",query_count)>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","11",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- tahmin gelir baslik --->

<cfif get_gelirler.recordcount>
	<cfoutput query="get_gelirler">
    	<cfset alan_id_ = code>
		<cfset alan_ad_ = ACTIVITY_NAME>
    
        <cfset query_count = query_count + 1>
        <cfset newRow = QueryAddRow(myQuery,1)>
        <cfif listfind(uncheck_fon_rows,'#alan_id_#')>
			<cfset is_active_ = "false">
        <cfelse>
            <cfset is_active_ = "true">
        </cfif>
        <cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"kolon_ad","#alan_ad_#",query_count)>
        <cfset row_last_total = 0>
        <cfloop from="1" to="#kolon_sayisi#" index="dongu">
            <cfset b_ = evaluate('base_alan_#dongu#')>
            <cfif isdefined("#alan_id_#_#b_#")>
                <cfset alan_ = evaluate("#alan_id_#_#b_#")>
            <cfelse>
                <cfset alan_ = 0>
            </cfif>
            <cfset row_last_total = row_last_total + alan_>
            <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
        </cfloop>
        <cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"row_type","12",query_count)>
        <cfset temp = QuerySetCell(myQuery,"process_type","#alan_id_#",query_count)>
    </cfoutput>
</cfif>

<!--- t gelir total --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","C-Toplam",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","13",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- t gelir total --->

<!--- gelir hedef fark --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Giriş Hedeflenen Giriş Toplam (A+C)",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","20",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- gelir hedef fark --->

<!--- basliklar --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","B - Çıkış Değerleri",query_count)>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","6",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- basliklar --->

<cfset giderler = "o_p_cek,o_p_senet,kmh_krediler,tasit_krediler,rotatif_krediler,taksitli_krediler,cc_odemeler,siparis,irsaliye,fatura,gider_fatura,cek_ekran">
<cfset giderler_name = "Çeke Bağlanmış Ödemeler,Senede Bağlanmış Ödemeler,Banka Kredileri Nakit Gün İçi,Banka Kredileri Taşıt,Banka Kredi Rotatif,Banka Kredi Taksitli,Kredi Kart Ödemeleri,Sipariş Ödemeleri,İrsaliye Ödemeleri,Fatura Ödemeleri,Gider Fatura Ödemeleri,Hesaplanan Çekler">

<cfloop from="1" to="#listlen(giderler)#" index="aa">
	<cfset alan_id_ = listgetat(giderler,aa)>
    <cfset alan_ad_ = listgetat(giderler_name,aa)>

	<cfset query_count = query_count + 1>
    <cfset newRow = QueryAddRow(myQuery,1)>
    <cfif listfind(uncheck_fon_rows,'#alan_id_#')>
		<cfset is_active_ = "false">
    <cfelse>
        <cfset is_active_ = "true">
    </cfif>
    <cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"kolon_ad","#alan_ad_#",query_count)>
    <cfset row_last_total = 0>
    <cfloop from="1" to="#kolon_sayisi#" index="dongu">
        <cfset b_ = evaluate('base_alan_#dongu#')>
        <cfif isdefined("#alan_id_#_#b_#")>
            <cfset alan_ = evaluate("#alan_id_#_#b_#")>
        <cfelse>
            <cfset alan_ = 0>
        </cfif>
        <cfset row_last_total = row_last_total + alan_>
        <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
    </cfloop>
    <cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
    <cfset temp = QuerySetCell(myQuery,"row_type","7",query_count)>
    <cfset temp = QuerySetCell(myQuery,"process_type","#alan_id_#",query_count)>
</cfloop>

<!--- btotal --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","B-Toplam",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","8",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- btotal --->

<!--- basliklar --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","D-Tahmini Çıkış Değerleri",query_count)>
<cfloop from="1" to="#kolon_sayisi#" index="dongu">
    <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","",query_count)>
</cfloop>
<cfset temp = QuerySetCell(myQuery,"toplam","",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","6",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- basliklar --->
<cfif get_giderler.recordcount>
	<cfoutput query="get_giderler">
    	<cfset alan_id_ = code>
		<cfset alan_ad_ = ACTIVITY_NAME>
    
        <cfset query_count = query_count + 1>
        <cfset newRow = QueryAddRow(myQuery,1)>
        <cfif listfind(uncheck_fon_rows,'#alan_id_#')>
			<cfset is_active_ = "false">
        <cfelse>
            <cfset is_active_ = "true">
        </cfif>
        <cfset temp = QuerySetCell(myQuery,"is_active","#is_active_#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"kolon_ad","#alan_ad_#",query_count)>
        <cfset row_last_total = 0>
        <cfloop from="1" to="#kolon_sayisi#" index="dongu">
            <cfset b_ = evaluate('base_alan_#dongu#')>
            <cfif isdefined("#alan_id_#_#b_#")>
                <cfset alan_ = evaluate("#alan_id_#_#b_#")>
            <cfelse>
                <cfset alan_ = 0>
            </cfif>
            <cfset row_last_total = row_last_total + alan_>
            <cfset temp = QuerySetCell(myQuery,"alan_#dongu#","#alan_#",query_count)>
        </cfloop>
        <cfset temp = QuerySetCell(myQuery,"toplam","#row_last_total#",query_count)>
        <cfset temp = QuerySetCell(myQuery,"row_type","9",query_count)>
        <cfset temp = QuerySetCell(myQuery,"process_type","#alan_id_#",query_count)>
    </cfoutput>
</cfif>

<!--- gider tahmini toplam --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","D-Tahmini Çıkış Değerleri Toplamları",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","10",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- gider tahmini toplam --->

<!--- gider hedef fark --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Çıkış Hedeflenen Çıkış Toplam (B+D)",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","25",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- gider hedef fark --->

<!--- son --->
<cfset query_count = query_count + 1>
<cfset newRow = QueryAddRow(myQuery,1)>
<cfset temp = QuerySetCell(myQuery,"is_active","true",query_count)>
<cfset temp = QuerySetCell(myQuery,"kolon_ad","Son Durum (A+C) - (B+D)",query_count)>
<cfset row_last_total = 0>
<cfset temp = QuerySetCell(myQuery,"toplam","0",query_count)>
<cfset temp = QuerySetCell(myQuery,"row_type","30",query_count)>
<cfset temp = QuerySetCell(myQuery,"process_type","0",query_count)>
<!--- son --->


<cfset CRLF = Chr(13) & Chr(10)>
<cfset dataset = "">
<cfoutput query="myQuery">
	<cfset row_ = "">
	<cfloop list="#name_list#" index="columns">
    	<cfset deger_ = '"#trim(lcase(columns))#":"#trim(evaluate(columns))#"'>
        <cfset row_ = listappend(row_,'#CRLF##trim(deger_)#')>
    </cfloop>
    <cfset dataset = listappend(dataset,"{#row_##CRLF#}")>
</cfoutput>
<cfif not directoryexists('#upload_folder#retail\xml\')>
    <cfdirectory action="create" directory="#upload_folder#retail#dir_seperator#xml">
</cfif>
<cfset dataset = "[" & dataset & "]">
<cffile action="write" file="#upload_folder#retail\xml\fon_tables_#userid_#.txt" output="#dataset#" charset="utf-8">


<cfif kolon_fazla eq 1>
	<b style="color:red;">En Fazla 52 Kolon Listelenmektedir!</b>
    <br />
</cfif>

<div id="control_h"></div>
<div id='jqxWidget'><div id="jqxgrid"></div></div>

<div id="action_div" style="display:none;"></div>

<script type="text/javascript">
function grid_duzenle()
{
	var position = $('#jqxgrid').jqxGrid('scrollposition');
	$("#jqxgrid").jqxGrid('applyfilters');
	$('#jqxgrid').jqxGrid('scrolloffset',0,300000);
	$('#jqxgrid').jqxGrid('scrolloffset',100000,300000);
}

$(document).ready(function () 
{
	foot_ = parseInt(600);
	head_ = parseInt(50);
	
	jheight = foot_ - head_ - 25;
	jwidth = window.innerWidth - 25;
   
	<cfoutput>var url = "/documents/retail/xml/fon_tables_#userid_#.txt";</cfoutput>	
	var source =
	 {
		dataType: "json",
		dataFields: [
			{ name: 'kolon_ad', type: 'string' },
			{ name: 'is_active', type: 'bool' },
			<cfoutput>
			<cfloop from="1" to="#kolon_sayisi#" index="dongu">
				{ name: 'alan_#dongu#', type: 'float' },
			</cfloop>
			</cfoutput>
			{ name: 'toplam', type: 'float' },
			{ name: 'process_type', type: 'string',hidden:false},
			{ name: 'row_type', type: 'float' }
		],
		id:'id',
		url: url
	 };
	 
	   var dataAdapter = new $.jqx.dataAdapter(source,{
		loadComplete: function () {}
	});
	
	$("#jqxgrid").jqxGrid(
	{
		theme: 'energyblue',
		width:jwidth,
		height: jheight,
		source:dataAdapter,
		sortable: false,
		columnsResize: true,
		columnsReorder: false,
		editable:true,
		localization: getLocalization('de'),
		showfilterrow: true,
		filterable: true,
		filtermode: 'excel',
		showtoolbar: false,
		showaggregates: false,
		showstatusbar: false,
		columnsheight:'<cfif attributes.count_type is 'w'>60px<cfelse>25px</cfif>',
		selectionmode: 'singlerow',
		/*
		groupable: true,
		showgroupmenuitems: false,
		closeablegroups: false,
		groupsexpandedbydefault: true,
		showgroupsheader: false,
		groups: ['kolon_tur'],
		*/
		columns:[
				/*
				{
					text: '', dataField: 'kolon_tur',hidden: true
				},
				*/
				{ 
					text: '', dataField: 'is_active', minWidth: 45, width:45,
					columntype:'checkbox',
					filtertype:'bool',
					cellclassname:function (row, columnfield, value, rowdata)
					{
						satir_tipi = rowdata.row_type;
						satir_adi = rowdata.process_type;
						if(satir_tipi == '3')
							return "gelir_blok_row";
						else if(satir_tipi == '4' && satir_adi == 'kasa_cek')
							return "gelir_blok_row2";
						else if(satir_tipi == '4')
							return "gelir_blok_row";
						else if(satir_tipi == '1' || satir_tipi == '5' || satir_tipi == '0')
							return "gelir_blok_header";
						else if(satir_tipi == '6' || satir_tipi == '8' || satir_tipi == '10')
							return "gider_blok_header";
						else if(satir_tipi == '11' || satir_tipi == '13')
							return "t_gelir_blok_header";
						else if(satir_tipi == '12')
							return "t_gelir_blok_row";
						else if(satir_tipi == '20' || satir_tipi == '25')
							return "dip_blok_row";
						else
							return "gider_blok_row";
					},
					cellendedit:function(row, datafield, columntype, value) 
					{
						deger_ = value;
						alan_ = $('#jqxgrid').jqxGrid('getcellvalue',row,'process_type');
						
						adress_ = 'index.cfm?fuseaction=retail.emptypopup_manage_fon_rows';
						adress_ = adress_ + '&deger=' + deger_;
						adress_ = adress_ + '&alan=' + alan_;
						
						AjaxPageLoad(adress_,'action_div');
					},
					hidden: false,
					pinned:true
				},
				{ 
					text: '', dataField: 'kolon_ad', minWidth: 50, width:220,editable:false,
					cellclassname:function (row, columnfield, value, rowdata)
					{
						satir_tipi = rowdata.row_type;
						satir_adi = rowdata.process_type;
						if(satir_tipi == '3')
							return "gelir_blok_row";
						else if(satir_tipi == '4' && satir_adi == 'kasa_cek')
							return "gelir_blok_row2";
						else if(satir_tipi == '4')
							return "gelir_blok_row";
						else if(satir_tipi == '1' || satir_tipi == '5' || satir_tipi == '0')
							return "gelir_blok_header";
						else if(satir_tipi == '6' || satir_tipi == '8' || satir_tipi == '10')
							return "gider_blok_header";
						else if(satir_tipi == '11' || satir_tipi == '13')
							return "t_gelir_blok_header";
						else if(satir_tipi == '12')
							return "t_gelir_blok_row";
						else if(satir_tipi == '20' || satir_tipi == '25')
							return "dip_blok_row";
						else
							return "gider_blok_row";
					},
					hidden:false,
					pinned:true
				},
				<cfoutput>
					<cfloop from="1" to="#kolon_sayisi#" index="dongu">
						<cfif attributes.count_type is 'd'>
							<cfset title_ = replace(evaluate("base_alan_#dongu#"),'_','/','all')>
							<cfset startdate_ = title_>
							<cfset finishdate_ = title_>
						<cfelseif attributes.count_type is 'm'>
							<cfset deger_ = evaluate("base_alan_#dongu#")>
							<cfset ay_ = listfirst(deger_,'_')>
							<cfset yil_ = listlast(deger_,'_')>          	
							<cfset title_ = "#listgetat(ay_list,ay_)# #yil_#">
							<cfset startdate_ = createodbcdatetime(createdate(yil_,ay_,1))>
							<cfset aydaki_gun_sayisi = DaysInMonth(startdate_)>
							<cfset startdate_ = dateformat(startdate_,'dd/mm/yyyy')>
							<cfset finishdate_ = dateformat(createodbcdatetime(createdate(yil_,ay_,aydaki_gun_sayisi)),'dd/mm/yyyy')>
						<cfelseif attributes.count_type is 'y'>
							<cfset title_ = evaluate("base_alan_#dongu#")>
							<cfset yil_ = evaluate("base_alan_#dongu#")>
							<cfset startdate_ = dateformat(createodbcdatetime(createdate(yil_,1,1)),'dd/mm/yyyy')>
							<cfset finishdate_ = dateformat(createodbcdatetime(createdate(yil_,12,31)),'dd/mm/yyyy')>
						<cfelseif attributes.count_type is 'w'>
							<cfset title_ = "#listfirst(evaluate('hafta_#dongu#'))#<br>#listlast(evaluate('hafta_#dongu#'))#">
							<cfset startdate_ = listfirst(evaluate('hafta_#dongu#'))>
							<cfset finishdate_ = listlast(evaluate('hafta_#dongu#'))>
						</cfif>
						{ 
							text: '<cfif attributes.count_type is "w">Hafta #dongu#<br>#title_#<cfelse>#title_#</cfif>',
							dataField: 'alan_#dongu#', minWidth: 50, width: 80,
							align: 'right', 
                           	cellsalign: 'right',
							columntype:'numberinput',
							cellsformat:'c2',
							editable:false,
							hidden: false,
							filtertype:'number',
							cellclassname:function (row, columnfield, value, rowdata)
							{
								satir_tipi = rowdata.row_type;
								satir_adi = rowdata.process_type;
								if(satir_tipi == '3')
									return "gelir_blok_row";
								else if(satir_tipi == '4' && satir_adi == 'kasa_cek')
									return "gelir_blok_row2";
								else if(satir_tipi == '4')
									return "gelir_blok_row";
								else if(satir_tipi == '1' || satir_tipi == '5' || satir_tipi == '0')
									return "gelir_blok_header";
								else if(satir_tipi == '6' || satir_tipi == '8' || satir_tipi == '10')
									return "gider_blok_header";
								else if(satir_tipi == '11' || satir_tipi == '13')
									return "t_gelir_blok_header";
								else if(satir_tipi == '12')
									return "t_gelir_blok_row";
								else if(satir_tipi == '20' || satir_tipi == '25')
									return "dip_blok_row";
								else
									return "gider_blok_row";
							},
							cellsrenderer: function (row, datafield, value, defaultvalue, column, rowdata) 
							{
							  satir_tipi = rowdata.row_type;
							  satir_process = rowdata.process_type;
							  if(satir_tipi == '1')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if(d_satir_tipi == '3' && (d_check == true || d_check == 'true'))
											total = total + rows[m].alan_#dongu#;
										else if(d_satir_tipi == '-4' && (d_check == true || d_check == 'true'))
											total = total - rows[m].alan_#dongu#;	
									}
							  }
							  else if(satir_tipi == '5')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_satir_process = rows[m].process_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '3' || (d_satir_tipi == '4' && d_satir_process != 'kasa_cek')) && d_check == true)
											total = total + rows[m].alan_#dongu#;
										else if(d_satir_tipi == '-4' && d_check == true)
											total = total - rows[m].alan_#dongu#;
									}
							  }
							  else if(satir_tipi == '20')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '3' || d_satir_tipi == '4') && d_check == true)
											total = total + rows[m].alan_#dongu#;
										else if((d_satir_tipi == '12') && d_check == true)
											total = total + rows[m].alan_#dongu#;
										else if(d_satir_tipi == '-4' && d_check == true)
											total = total - rows[m].alan_#dongu#;
									}
							  }
							  else if(satir_tipi == '8')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '7') && d_check == true)
											total = total + rows[m].alan_#dongu#;	
									}
							  }
							  else if(satir_tipi == '25')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '7') && d_check == true)
											total = total + rows[m].alan_#dongu#;
										else if((d_satir_tipi == '9') && d_check == true)
											total = total + rows[m].alan_#dongu#;	
									}
							  }
							  else if(satir_tipi == '10')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '9') && d_check == true)
											total = total + rows[m].alan_#dongu#;	
									}
							  }
							  else if(satir_tipi == '13')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '12') && d_check == true)
											total = total + rows[m].alan_#dongu#;	
									}
							  }
							  else if(satir_tipi == '30')
							  {
									var total = 0;
									var rows = $('##jqxgrid').jqxGrid('getboundrows');
									var eleman_sayisi = rows.length;
									
									for (var m=0; m < eleman_sayisi; m++)
									{
										d_satir_tipi = rows[m].row_type;
										d_check = rows[m].is_active;
										
										if((d_satir_tipi == '3' || d_satir_tipi == '4' || d_satir_tipi == '12') && d_check == true)
											total = total + rows[m].alan_#dongu#;	
										else if((d_satir_tipi == '7' || d_satir_tipi == '9') && d_check == true)
											total = total - rows[m].alan_#dongu#;	
									}
							  }
							  else
							  {
								 total = value;
							  }
							  
							  var rows = $('##jqxgrid').jqxGrid('getboundrows');
							  rows[row].alan_#dongu# = total;
							  
							  if(satir_process == 'siparis')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=retail.list_order&maxrows=9999&view_type=1&sort_type=5&listing_type=2&order_stage=#valid_order_stage_#&form_varmi=1&irsaliye_fatura=3&start_date=&finish_date=&deliver_start_date=#startdate_#&deliver_finish_date=#finishdate_#' target='siparis_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'o_p_cek')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cheque.list_cheques&maxrows=9999&is_form_submitted=1&start_date=#startdate_#&finish_date=#finishdate_#&status=6&oby=2' target='cek_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'p_cek')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cheque.list_cheques&maxrows=9999&is_form_submitted=1&start_date=#startdate_#&finish_date=#finishdate_#&status=1&oby=2' target='cek_window_p'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'b_cek')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cheque.list_cheques&maxrows=9999&is_form_submitted=1&start_date=#startdate_#&finish_date=#finishdate_#&status=2&oby=2' target='cek_window_b'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'o_p_senet')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cheque.list_vouchers&maxrows=9999&is_form_submitted=1&due_start_date=#startdate_#&due_finish_date=#finishdate_#&status=6&oby=2' target='cek_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'p_senet')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cheque.list_vouchers&maxrows=9999&is_form_submitted=1&due_start_date=#startdate_#&due_finish_date=#finishdate_#&status=1&oby=2' target='cek_window_p'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'b_senet')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cheque.list_vouchers&maxrows=9999&is_form_submitted=1&due_start_date=#startdate_#&due_finish_date=#finishdate_#&status=2&oby=2' target='cek_window_b'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'irsaliye')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=stock.list_purchase&maxrows=9999&is_form_submitted=1&v_date1=#startdate_#&v_date2=#finishdate_#&invoice_action=2&cat=76-0' target='irsaliye_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'fatura')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=invoice.list_bill&maxrows=9999&view_type=1&oby=5&open_type=0&fon_type=1&form_varmi=1&d_start_date=#startdate_#&d_finish_date=#finishdate_#&cat=59' target='invoice_window_n'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'gider_fatura')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=cost.list_expense_income&maxrows=9999&form_submitted=1&record_date1=#startdate_#&record_date2=#finishdate_#&expense_action_type=120&open_type=0&fon_type=1' target='g_invoice_window_n'>" + commaSplit(total) + "</a></div>";
							  else if(satir_tipi == '9' || satir_tipi == '12')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=budget.list_plan_rows&maxrows=9999&form_submitted=1&listing_type=2&search_date1=#startdate_#&search_date2=#finishdate_#&activity_type=" + satir_process + "' target='gider_window_n'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'cc_odemeler')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=retail.credit_card_payment_report&form_submitted=1&start_date_1=#startdate_#&finish_date_1=#finishdate_#' target='cek_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'kmh_krediler')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=retail.credit_payment_report&start_date_1=#startdate_#&finish_date_1=#finishdate_#&credit_type_id=4' target='kredi_r_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'tasit_krediler')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=retail.credit_payment_report&start_date_1=#startdate_#&finish_date_1=#finishdate_#&credit_type_id=3' target='kredi_r_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'rotatif_krediler')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=retail.credit_payment_report&start_date_1=#startdate_#&finish_date_1=#finishdate_#&credit_type_id=1,5' target='kredi_r_window'>" + commaSplit(total) + "</a></div>";
							  else if(satir_process == 'taksitli_krediler')
							  	return "<div style='margin: 4px;' class='jqx-right-align'><a href='#request.self#?fuseaction=retail.credit_payment_report&start_date_1=#startdate_#&finish_date_1=#finishdate_#&credit_type_id=2,6' target='kredi_r_window'>" + commaSplit(total) + "</a></div>";
							  else
							  	return "<div style='margin: 4px;' class='jqx-right-align'>" + commaSplit(total) + "</div>";
							}	
						},
					</cfloop>
				</cfoutput>
				{ 
					text: 'Satır Toplam', dataField: 'toplam', minWidth: 50, width: 100,
					align: 'right', 
					cellsalign: 'right',
					cellsformat:'c2',
					editable:false,
					hidden: false,
					filtertype:'number',
					cellclassname:function (row, columnfield, value, rowdata)
						{
							satir_tipi = rowdata.row_type;
							satir_adi = rowdata.process_type;
							if(satir_tipi == '3')
								return "gelir_blok_row_total";
							else if(satir_tipi == '4' && satir_adi == 'kasa_cek')
								return "gelir_blok_row2_total";
							else if(satir_tipi == '4')
								return "gelir_blok_row_total";
							else if(satir_tipi == '1' || satir_tipi == '5' || satir_tipi == '0')
								return "gelir_blok_header_total";
							else if(satir_tipi == '6' || satir_tipi == '8' || satir_tipi == '10')
								return "gider_blok_header_total";
							else if(satir_tipi == '11' || satir_tipi == '13')
								return "t_gelir_blok_header_total";
							else if(satir_tipi == '12')
								return "t_gelir_blok_row_total";
							else if(satir_tipi == '20' || satir_tipi == '25')
								return "dip_blok_row_total";
							else
								return "gider_blok_row_total";
						},
					cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) 
					{
					  satir_tipi = rowdata.row_type;
					  if(satir_tipi == '1')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if(d_satir_tipi == '3' && d_check == true)
									total = total + rows[m].toplam;
								else if(d_satir_tipi == '-4' && d_check == true)
									total = total - rows[m].toplam;	
							}
					  }
					  else if(satir_tipi == '5')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_satir_process = rows[m].process_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '3' || (d_satir_tipi == '4' && d_satir_process != 'kasa_cek')) && d_check == true)
									total = total + rows[m].toplam;	
								else if(d_satir_tipi == '-4' && d_check == true)
									total = total - rows[m].toplam;
							}
					  }
					  else if(satir_tipi == '20')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '3' || d_satir_tipi == '4') && d_check == true)
									total = total + rows[m].toplam;	
								else if((d_satir_tipi == '12') && d_check == true)
									total = total + rows[m].toplam;
								else if(d_satir_tipi == '-4' && d_check == true)
									total = total - rows[m].toplam;
							}
					  }
					  else if(satir_tipi == '8')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '7') && d_check == true)
									total = total + rows[m].toplam;	
							}
					  }
					  else if(satir_tipi == '25')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '7') && d_check == true)
									total = total + rows[m].toplam;	
								else if((d_satir_tipi == '9') && d_check == true)
									total = total + rows[m].toplam;	
							}
					  }
					  else if(satir_tipi == '10')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '9') && d_check == true)
									total = total + rows[m].toplam;	
							}
					  }
					  else if(satir_tipi == '13')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '12') && d_check == true)
									total = total + rows[m].toplam;	
							}
					  }
					  else if(satir_tipi == '30')
					  {
							var total = 0;
							var rows = $('#jqxgrid').jqxGrid('getboundrows');
							var eleman_sayisi = rows.length;
							
							for (var m=0; m < eleman_sayisi; m++)
							{
								d_satir_tipi = rows[m].row_type;
								d_check = rows[m].is_active;
								
								if((d_satir_tipi == '3' || d_satir_tipi == '4' || d_satir_tipi == '12') && d_check == true)
									total = total + rows[m].toplam;	
								else if((d_satir_tipi == '7' || d_satir_tipi == '9') && d_check == true)
									total = total - rows[m].toplam;	
							}
					  }
					  else
					  {
						 total = value;
					  }
					  //$("#jqxgrid").jqxGrid('setcellvalue', 0, datafield,total);
					  return "<div style='margin: 4px;' class='jqx-right-align'>" + commaSplit(total) + "</div>";
					}
				},
				{ text: 'Satır Tipi', dataField: 'row_type', minWidth: 50, width: 50,hidden: true},
				{ text: 'Satır Türü', dataField: 'process_type', minWidth: 50, width: 50,hidden: true}
		]
	});
});
</script>