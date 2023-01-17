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

<table border="0" cellpadding="0" cellspacing="0" style="width:190mm;">
    <tr>
        <td style="width:10mm;" rowspan="30">&nbsp;</td>
        <td style="height:8mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td valign="top">
        <table border="1" cellpadding="0" cellspacing="0" width="100%">
        	<cfoutput>
            <tr>
            	<td colspan="6" align="center" class="formbold" style="height:10mm;">#member_name# - #getContractWorks.CONTRACT_NO# NOLU - 
					<cfif getContractWorks.CONTRACT_TYPE eq 1><cf_get_lang_main no='764.Alış'></cfif>
                    <cfif getContractWorks.CONTRACT_TYPE eq 2><cf_get_lang_main no='36.Satış'></cfif> <cf_get_lang_main no='1725.SÖZLEŞMESİ'>
            	</td>
			</tr>
            <tr>
            	<td style="height:6mm; width:25mm;" class="txtbold"><cf_get_lang_main no='68.Konu'></td>
                <td style="width:40mm;">#getContractWorks.CONTRACT_HEAD#</td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='74.Kategori'></td>
                <td style="width:25mm;"><cfif len(getContractWorks.CONTRACT_CAT_ID)>#get_category.CONTRACT_CAT#<cfelse>&nbsp;</cfif></td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='1725.Sözleşme'> <cf_get_lang_main no='75.No'></td>
                <td style="width:15mm;">#getContractWorks.CONTRACT_NO#</td>
            </tr>
            <tr>
            	<td style="height:6mm; width:25mm;" class="txtbold"><cf_get_lang_main no='107.Cari Hesap'></td>
                <td style="width:40mm;">#member_name#</td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
                <td style="width:25mm;"><cfif len(getContractWorks.stage_id)>#get_process_type.stage#<cfelse>&nbsp;</cfif></td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang no="967.Sözleşme Tipi"></td>
                <td style="width:15mm;">
					<cfif getContractWorks.CONTRACT_TYPE eq 1><cf_get_lang_main no='764.Alış'></cfif>
                    <cfif getContractWorks.CONTRACT_TYPE eq 2><cf_get_lang_main no='36.Satış'></cfif>
                </td>
            </tr>
            <tr>
            	<td style="height:6mm; width:25mm;" class="txtbold"><cf_get_lang_main no='4.Proje'> <cf_get_lang_main no="75.No"> <cf_get_lang_main no='577.ve'> <cf_get_lang_main no='485.Adı'></td>
                <td style="width:40mm;"><cfif len(getContractWorks.PROJECT_ID)>#GET_PROJECT_NAME(getContractWorks.PROJECT_ID)#<cfelse>&nbsp;</cfif></td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='1277.Teminat'> <cf_get_lang_main no='261.Tutar'>/<cf_get_lang_main no='1044.Oran'></td>
                <td style="width:25mm;">
					<cfif len(getContractWorks.TEMINAT_TUTAR)>#TLFormat(getContractWorks.TEMINAT_TUTAR)#<cfelse>&nbsp;</cfif> 
					<cfif len(getContractWorks.TEMINAT_ORAN)>/ #TLFormat(getContractWorks.TEMINAT_ORAN)#<cfelse>&nbsp;</cfif>
                </td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang no="964.Hesaplama Yöntemi"></td>
                <td style="width:15mm;">
					<cfif getContractWorks.HESAPLAMA_YONTEM eq 1>%<cfelse>&nbsp;</cfif>
                    <cfif getContractWorks.HESAPLAMA_YONTEM eq 2><cf_get_lang_main no='1716.Süre'><cfelse>&nbsp;</cfif>
                    <cfif getContractWorks.HESAPLAMA_YONTEM eq 3><cf_get_lang_main no='223.Miktar'><cfelse>&nbsp;</cfif>
                </td>
            </tr>
            <tr>
            	<td style="height:6mm; width:25mm;" class="txtbold"><cf_get_lang_main no='1725.Sözleşme'> <cf_get_lang_main no='261.T'> / <cf_get_lang_main no='227.KDV'></td>
                <td style="width:40mm;">#TLFormat(getContractWorks.SOZLESME_TUTAR)# &nbsp;/ #getContractWorks.SOZLESME#</td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='792.Avans'> <cf_get_lang_main no='261.Tutar'>/<cf_get_lang_main no='1044.Oran'></td>
                <td style="width:25mm;">
					<cfif len(getContractWorks.AVANS_TUTAR)>#TLFormat(getContractWorks.AVANS_TUTAR)#<cfelse>&nbsp;</cfif>
					<cfif len(getContractWorks.AVANS_ORAN)> / #TLFormat(getContractWorks.AVANS_ORAN)#<cfelse>&nbsp;</cfif>
                </td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='243.Başlama Tarihi'></td>
                <td style="width:15mm;"><cfif len(getContractWorks.STARTDATE)>#DateFormat(getContractWorks.STARTDATE,dateformat_style)#<cfelse>&nbsp;</cfif></td>
            </tr>
            <tr>
            	<td style="height:6mm; width:25mm;" class="txtbold"><cf_get_lang_main no='1304.KDV li'> <cf_get_lang_main no='261.Tutar'></td>
                <td style="width:40mm;">
					<cfif len(getContractWorks.KDVLI_TUTAR)>#TLFormat(getContractWorks.KDVLI_TUTAR)# &nbsp;#getContractWorks.CONTRACT_MONEY#<!--- #get_moneys.MONEY# ---><cfelse>&nbsp;</cfif>
                </td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='610.Tevkifat'></td>
                <td style="width:25mm;"><cfif len(getContractWorks.TEVKIFAT)>#getContractWorks.TEVKIFAT#<cfelse>&nbsp;</cfif></td>
                <td style="width:31mm;" class="txtbold"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
                <td style="width:15mm;"><cfif len(getContractWorks.FINISHDATE)>#DateFormat(getContractWorks.FINISHDATE,dateformat_style)#<cfelse>&nbsp;</cfif></td>
            </tr>
            <tr>
            <td style="width:31mm;" class="txtbold"><cf_get_lang dictionary_id='41439.Damga Vergisi'> <cf_get_lang_main no='261.Tutar'>/<cf_get_lang_main no='1044.Oran'></td>
            <td style="width:25mm;">
                <cfif len(getContractWorks.DAMGA_VERGISI_TUTAR)>#TLFormat(getContractWorks.DAMGA_VERGISI_TUTAR)#<cfelse>&nbsp;</cfif>
                <cfif len(getContractWorks.DAMGA_VERGISI_ORAN)> / #TLFormat(getContractWorks.DAMGA_VERGISI_ORAN)#<cfelse>&nbsp;</cfif>
            </td>
            <td style="width:31mm;" class="txtbold"><cf_get_lang dictionary_id='39010.Kopya'> <cf_get_lang dictionary_id='39852.Sayısı'></td>
            <td style="width:25mm;"><cfif len(getContractWorks.KOPYA_SAYISI)>#getContractWorks.KOPYA_SAYISI#<cfelse>&nbsp;</cfif></td>
            <td></td>
            <td></td>
            </tr>
			</cfoutput>
        </table>
        </td>
    </tr>
    <tr><td colspan="6" style="height:8mm;">&nbsp;<!--- ara bosluk ---></td></tr>
    <tr>
        <td colspan="6">
        <table border="1" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td colspan="5" align="center" class="formbold" style="height:10mm;"><cf_get_lang_main no='608.İŞLER'></td>
            </tr>
            <tr>
                <td class="formbold" style="height:8mm;"><cf_get_lang_main no='1033.İş'> <cf_get_lang_main no='75.No'></td>
                <td class="formbold"><cf_get_lang_main no='68.Konu'></td>
                <td colspan="2" class="formbold" align="center"><cf_get_lang_main no="1457.Planlanan">
                	<table border="0" cellpadding="0" cellspacing="0" width="100%">
                    	<tr>
                        	<td style="width:25mm; height:6mm;" class="txtbold"><cf_get_lang_main no='243.Başlama Tarihi'></td>
                            <td class="txtbold" align="center"><cf_get_lang_main no='288.Bitiş Tarihi'></td>
                        </tr>
                    </table>
                </td>
                <td class="formbold" align="center"><cf_get_lang_main no='261.Tutar'></td>
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
			</cfoutput>
        </table>
        </td>
    </tr>
</table>
