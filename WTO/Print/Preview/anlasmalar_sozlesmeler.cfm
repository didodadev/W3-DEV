<!--- Standart Sozlesmeler --->
<cfset attributes.contract_id = attributes.action_id>
<cfquery name="getContractWorks" datasource="#dsn#">
	SELECT 
		PW.WORK_ID,
		PW.WORK_HEAD,
		PW.WORK_NO,
		PW.ESTIMATED_TIME,
		PW.TO_COMPLETE,
		PW.COMPLETED_AMOUNT TAMAMLANAN_MIKTAR,
		PW.PURCHASE_CONTRACT_AMOUNT BIRIM_FIYAT,
		PW.SALE_CONTRACT_AMOUNT,
        PW.AVERAGE_AMOUNT TAHMINI_MIKTAR,
        PW.TARGET_START,
        PW.TARGET_FINISH,
        RC.CONTRACT_ID,
        RC.CONTRACT_NO,
        RC.CONTRACT_HEAD,
        RC.CONSUMER_ID,
        RC.COMPANY_ID,
        RC.CONTRACT_CAT_ID,
        RC.CONTRACT_TYPE,
        RC.CONTRACT_MONEY,
        RC.PROJECT_ID,
        RC.STAGE_ID,
        RC.CONTRACT_AMOUNT SOZLESME_TUTAR,
        RC.CONTRACT_TAX SOZLESME,
        RC.CONTRACT_CALCULATION HESAPLAMA_YONTEM,
        RC.CONTRACT_BODY ACIKLAMA,
        RC.GUARANTEE_AMOUNT TEMINAT_TUTAR,
        RC.GUARANTEE_RATE TEMINAT_ORAN,
        RC.CONTRACT_TAX_AMOUNT KDVLI_TUTAR,
        RC.ADVANCE_AMOUNT AVANS_TUTAR,
        RC.ADVANCE_RATE AVANS_ORAN,
        RC.CONTRACT_UNIT_PRICE BIRIM_FIYAT,
        RC.TEVKIFAT_RATE TEVKIFAT,
        RC.STAMP_TAX DAMGA_VERGISI_TUTAR,
        RC.STAMP_TAX_RATE DAMGA_VERGISI_ORAN,
        RC.COPY_NUMBER KOPYA_SAYISI,
        RC.STARTDATE,
        RC.FINISHDATE
	FROM 
        #dsn3_alias#.RELATED_CONTRACT RC 
        LEFT JOIN PRO_WORKS PW 
        ON (
                (RC.CONTRACT_TYPE = 1 AND RC.CONTRACT_ID = PW.PURCHASE_CONTRACT_ID) OR
                (RC.CONTRACT_TYPE = 2 AND RC.CONTRACT_ID = PW.SALE_CONTRACT_ID)
            )
	WHERE 
		RC.CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#">
    ORDER BY 
    	PW.TARGET_START
</cfquery>

<cfset work_h_list = ''>
<cfif getContractWorks.recordcount>
	<cfset work_h_list = valuelist(getContractWorks.WORK_ID)>
	<cfquery name="get_harcanan_zaman" datasource="#DSN#">
		SELECT
			SUM((ISNULL(TOTAL_TIME_HOUR,0)*60) + ISNULL(TOTAL_TIME_MINUTE,0)) AS HARCANAN_DAKIKA,
			WORK_ID
		FROM
			PRO_WORKS_HISTORY
		WHERE
			WORK_ID IN ('#work_h_list#')
		GROUP BY
			WORK_ID
	</cfquery>
	<cfset work_h_list = listsort(listdeleteduplicates(valuelist(get_harcanan_zaman.WORK_ID,',')),'numeric','ASC',',')>
	<cfquery name="getToplamAs" dbtype="query">
		SELECT SUM(ESTIMATED_TIME)/60 TOPLAM_AS FROM getContractWorks
	</cfquery>
</cfif>

<cfif len(getContractWorks.Consumer_Id)>
    <cfquery name="get_consumer" datasource="#dsn#">
        SELECT CONSUMER_ID,CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getContractWorks.consumer_id#">
    </cfquery>
    <cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
<cfelseif len(getContractWorks.Company_Id)>
    <cfquery name="get_company" datasource="#dsn#">
        SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getContractWorks.Company_Id#">
    </cfquery>
    <cfset member_name = get_company.fullname>
<cfelse>
    <cfset member_name = ''>
</cfif>

<cfif len(getContractWorks.stage_id)>
    <cfquery name="get_process_type" datasource="#dsn#">
    	SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getContractWorks.stage_id#">
    </cfquery>
</cfif>

<!--- kategori --->
<cfif len(getContractWorks.CONTRACT_CAT_ID)>
    <cfquery name="get_category" datasource="#dsn3#">
        SELECT * FROM CONTRACT_CAT WHERE CONTRACT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getContractWorks.contract_cat_id#">
    </cfquery>
</cfif>
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
      ASSET_FILE_NAME2,
      ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif> 
  </cfquery>

<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT 
		MONEY_ID,MONEY,RATE1,RATE2
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = 1
	ORDER BY MONEY_ID
</cfquery>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css"> 
<cfoutput>
    <cf_woc_header>
        <cf_woc_elements>
            <cf_wuxi id="head" data="#getContractWorks.CONTRACT_HEAD#" label="57480" type="cell">
            <cf_wuxi id="head" data="#iif(len(getContractWorks.CONTRACT_CAT_ID),'get_category.CONTRACT_CAT',DE(''))#" label="57486" type="cell">
            <cf_wuxi id="head" data="#iif(len(getContractWorks.PROJECT_ID),'GET_PROJECT_NAME(getContractWorks.PROJECT_ID)',DE(''))#" label="31027" type="cell">
            <cfsavecontent variable="yontem">
                <cfif getContractWorks.HESAPLAMA_YONTEM eq 1>%</cfif>
                <cfif getContractWorks.HESAPLAMA_YONTEM eq 2>29513</cfif>
                <cfif getContractWorks.HESAPLAMA_YONTEM eq 3>57635</cfif>
            </cfsavecontent>
            <cf_wuxi id="head" data="#yontem#" label="43003" type="cell" data_type="#iif(getContractWorks.HESAPLAMA_YONTEM neq 1,DE("dictionary"),DE(""))#">
            <cf_wuxi id="head" data="#member_name#" label="57519" type="cell">
            <cf_wuxi id="head" data="#iif(len(getContractWorks.KOPYA_SAYISI),'getContractWorks.KOPYA_SAYISI',DE(''))#" label="39010+39852" type="cell">
            <cf_wuxi id="head" data="#getContractWorks.CONTRACT_NO#" label="30044" type="cell">
            <cf_wuxi id="head" data="#iif(len(getContractWorks.TEVKIFAT),'getContractWorks.TEVKIFAT',DE(''))#" label="58022" type="cell">
            <cfsavecontent variable="sozlesme">
                <cfif getContractWorks.CONTRACT_TYPE eq 1>58176</cfif>
                <cfif getContractWorks.CONTRACT_TYPE eq 2>36</cfif>
            </cfsavecontent>
            <cf_wuxi id="" data="#sozlesme#" label="51040" type="cell" data_type="dictionary">
            <cf_wuxi id="head" data="#iif(len(getContractWorks.STARTDATE),'getContractWorks.STARTDATE',DE(''))#" label="57655" type="cell">
            <cf_wuxi id="aciklama" data="#getContractWorks.ACIKLAMA#" label="57629" type="cell">
            <cf_wuxi id="head" data="#iif(len(getContractWorks.FINISHDATE),'getContractWorks.FINISHDATE',DE(''))#" label="57700" type="cell">

                    <!--- <tr>
                        <td><b><cf_get_lang dictionary_id="51040.Sözleşme Tipi"></b></td>
                        <td>
                            <cfif getContractWorks.CONTRACT_TYPE eq 1><cf_get_lang dictionary_id='58176.Alış'></cfif>
                            <cfif getContractWorks.CONTRACT_TYPE eq 2><cf_get_lang dictionary_id='36.Satış'></cfif>
                        </td>
                        <td><b><cf_get_lang dictionary_id='57655.Başlama Tarihi'></b></td>
                            <td>
                            <cfif len(getContractWorks.STARTDATE)>#DateFormat(getContractWorks.STARTDATE,dateformat_style)#<cfelse>&nbsp;</cfif>
                        </td>
                    </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='57629.AÇIKLAMA'></b></td>
                        <td>#getContractWorks.ACIKLAMA#</td>
                        <td><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></b></td>
                        <td>
                            <cfif len(getContractWorks.FINISHDATE)>#DateFormat(getContractWorks.FINISHDATE,dateformat_style)#<cfelse>&nbsp;</cfif>
                        </td>
                    </tr> --->
                    <cf_wuxi id="stage" data="#iif(len(get_process_type.stage),'get_process_type.stage',DE(''))#" label="58859+57482" type="cell" style="background-color:##eee;border-top:1px solid ##c0c0c0;border-bottom:1px solid ##c0c0c0">
            </cf_woc_elements>

        
                <cf_woc_elements>
                    <cf_woc_list>
                        <thead>
                            <tr>
                                <cf_wuxi label="50985" type="cell" is_row="0" id="wuxi_58053"> 
                                <cf_wuxi label="31175" type="cell" is_row="0" id="wuxi_58053"> 
                                <cf_wuxi label="50701+58456" type="cell" is_row="0" id="wuxi_58053"> 
                                <cf_wuxi label="50704+58456" type="cell" is_row="0" id="wuxi_58053"> 
                                <cf_wuxi label="41439+57673+58456" type="cell" is_row="0" id="wuxi_58053"> 
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <cf_wuxi data="#TLFormat(getContractWorks.SOZLESME_TUTAR)# &nbsp;/ #getContractWorks.SOZLESME#" type="cell" is_row="0" style="text-align:right"> 
                                <cf_wuxi data="#TLFormat(getContractWorks.KDVLI_TUTAR)# &nbsp;#getContractWorks.CONTRACT_MONEY#" type="cell" is_row="0" style="text-align:right"> 
                                <cf_wuxi data="#iif(len(getContractWorks.TEMINAT_TUTAR),'getContractWorks.TEMINAT_TUTAR',DE(' '))#/#iif(len(getContractWorks.TEMINAT_ORAN),'getContractWorks.TEMINAT_ORAN',DE(' '))#" type="cell" is_row="0" style="text-align:right"> 
                                <cf_wuxi data="#iif(len(getContractWorks.AVANS_TUTAR),'getContractWorks.AVANS_TUTAR',DE(' '))#/#iif(len(getContractWorks.AVANS_ORAN),'getContractWorks.AVANS_ORAN',DE(' '))#" type="cell" is_row="0" style="text-align:right"> 
                                <cf_wuxi data="#iif(len(getContractWorks.DAMGA_VERGISI_TUTAR),'getContractWorks.DAMGA_VERGISI_TUTAR',DE(' '))#/#iif(len(getContractWorks.DAMGA_VERGISI_ORAN),'getContractWorks.DAMGA_VERGISI_ORAN',DE(' '))#" type="cell" is_row="0" style="text-align:right"> 
                               
                            </tr>
                        </tbody>
                    </cf_woc_list>
                </cf_woc_elements>
        <cf_woc_footer>
                <!---  <tr><td colspan="6" style="height:8mm;">&nbsp;<!--- ara bosluk ---></td></tr>
                <tr>
                    <td colspan="6">
                    <table border="1" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td colspan="5" align="center" class="formbold" style="height:10mm;"><cf_get_lang dictionary_id='58020.İŞLER'></b></td>
                        </tr>
                    <tr>
                        <td><b><cf_get_lang dictionary_id='38472.İş NO'></b></td>
                        <td><b><cf_get_lang dictionary_id='57480.Konu'></b></td>
                        <td><b><cf_get_lang dictionary_id="1457.Planlanan">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td><cf_get_lang dictionary_id='57655.Başlama Tarihi'></b></td>
                                    <td><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></b></td>
                                </tr>
                            </table>
                        </td>
                        <td><b><cf_get_lang dictionary_id='57673.Tutar'></b></td>
                    </tr>
                    <cfoutput query="getContractWorks">
                    <tr>
                        <td style="height:6mm; width:15mm;">&nbsp;#WORK_NO#</td>
                        <td>&nbsp;#WORK_HEAD#</td>
                        <td style="width:25mm;text-align:center;">#dateformat(TARGET_START,dateformat_style)#</td>
                        <td style="width:25mm;text-align:center;">#dateformat(TARGET_FINISH,dateformat_style)#</td>
                        <td style="text-align:right;">&nbsp;
                            <cfif HESAPLAMA_YONTEM eq 1><!--- % --->
                                <cfif len(ESTIMATED_TIME) and ESTIMATED_TIME neq 0>
                                    <cfset adam_saat = ESTIMATED_TIME/60>
                                <cfelse>
                                    <cfset adam_saat = 0>
                                </cfif>
                                <cfif (len(SOZLESME_TUTAR) and SOZLESME_TUTAR neq 0) and (len(adam_saat) and adam_saat neq 0) and (len(getToplamAs.toplam_as) and getToplamAs.toplam_as neq 0)>
                                    <cfset expected_budget_ = (SOZLESME_TUTAR/getToplamAs.toplam_as)*adam_saat>
                                <cfelse>
                                    <cfset expected_budget_ = 0>
                                </cfif>
                                #TLFormat(expected_budget_,2)#
                            </cfif>
                            <cfif HESAPLAMA_YONTEM eq 2><!--- süre --->
                                <cfif isdefined('estimated_time') and len(estimated_time)>
                                    <cfset liste = estimated_time/60>
                                    <cfset saat = listfirst(liste,'.')>
                                    <cfset dak = estimated_time-saat*60>
                                    <cfif contract_type eq 1>
                                        <cfset sure = numberFormat(saat) * numberFormat(BIRIM_FIYAT)>
                                        #TLFormat(sure,0)#
                                    <cfelse>
                                        <cfset sure =  numberFormat(saat) * numberFormat(SALE_CONTRACT_AMOUNT)>
                                        #TLFormat(sure,0)#
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif HESAPLAMA_YONTEM eq 3><!--- miktar --->                            
                                <cfif contract_type eq 1>
                                    <cfif len(TAMAMLANAN_MIKTAR) and TAMAMLANAN_MIKTAR neq 0 and len(BIRIM_FIYAT) and BIRIM_FIYAT neq 0>
                                        <cfset miktar = TAMAMLANAN_MIKTAR * BIRIM_FIYAT>
                                        #miktar#
                                    <cfelse>&nbsp;
                                    </cfif>
                                <cfelse>
                                    <cfif len(TAMAMLANAN_MIKTAR) and TAMAMLANAN_MIKTAR neq 0 and len(SALE_CONTRACT_AMOUNT) and SALE_CONTRACT_AMOUNT neq 0>
                                        <cfset miktar = TAMAMLANAN_MIKTAR * SALE_CONTRACT_AMOUNT>
                                        #miktar#
                                    <cfelse>&nbsp;
                                    </cfif>
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
                    </cfoutput> --->
       
</cfoutput>