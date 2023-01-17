<!---E-Fatura kullanan sirketlerde gecis asamasinda kontrol amacli kullanilir. BK 20131204--->
<cfquery name="GET_QUERY_1" datasource="#DSN#">
	SELECT 
        OC.COMPANY_NAME,
        OC.COMP_ID,
		OC.TAX_OFFICE,
        OC.TAX_NO,
        OC.T_NO,
        OC.MERSIS_NO,        
        (SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = OC.COUNTRY_ID) COUNTRY_NAME,
        (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = OC.CITY_ID) CITY_NAME,
        (SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = OC.COUNTY_ID) COUNTY_NAME,
        OC.DISTRICT_NAME,
        OC.STREET_NAME,
        OC.CITY_SUBDIVISION_NAME,
        OC.POSTAL_CODE,
        OC.BUILDING_NUMBER,
		<cfif isdefined("session.ep.our_company_info.is_earchive") and session.ep.our_company_info.is_earchive eq 1>OCI.IS_EARCHIVE,</cfif>
        OCI.EINVOICE_TYPE,
        OCI.EINVOICE_TEST_SYSTEM
	FROM 
    	OUR_COMPANY_INFO OCI,
        OUR_COMPANY OC 
   	WHERE 
    	OC.COMP_ID = OCI.COMP_ID AND
        OCI.IS_EFATURA = 1 
   	ORDER BY 
    	OC.COMPANY_NAME
</cfquery>

<cfif isdefined("session.ep.our_company_info.is_earchive") and session.ep.our_company_info.is_earchive eq 1>
    <cfquery name="GET_QUERY_14" datasource="#DSN#">
        SELECT 
        OC.COMPANY_NAME,
        OC.COMP_ID,
		OC.TAX_OFFICE,
        OC.TAX_NO,
        OC.T_NO,
        OC.MERSIS_NO,        
        (SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = OC.COUNTRY_ID) COUNTRY_NAME,
        (SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = OC.CITY_ID) CITY_NAME,
        (SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = OC.COUNTY_ID) COUNTY_NAME,
        OC.DISTRICT_NAME,
        OC.STREET_NAME,
        OC.CITY_SUBDIVISION_NAME,
        OC.POSTAL_CODE,
        OC.BUILDING_NUMBER,
		OCI.IS_EARCHIVE,
        OCI.EINVOICE_TYPE,
        EII.EARCHIVE_INTEGRATION_TYPE,
        EII.EARCHIVE_TEST_SYSTEM
	FROM 
    	OUR_COMPANY_INFO OCI,
        OUR_COMPANY OC,
        EARCHIVE_INTEGRATION_INFO EII 
   	WHERE 
    	OC.COMP_ID = OCI.COMP_ID AND
        OCI.COMP_ID = EII.COMP_ID AND
        OCI.IS_EFATURA = 1 
   	ORDER BY 
    	OC.COMPANY_NAME
    </cfquery>
    
    <!--- E-Arşiv Gönderim Tipi Eksik olan Kurumsal Üye Kayıtları  --->
    <cfquery name="GET_QUERY_15" datasource="#DSN#">
        SELECT DISTINCT
            CITY.CITY_NAME,
            COUNTY.COUNTY_NAME,
            CC.COMPANYCAT,
            C.COMPANY_ID,
            C.TAXNO,
            C.FULLNAME,
            C.COMPANY_STATUS,
            C.MEMBER_CODE
        FROM 
            COMPANY C
                LEFT  JOIN SETUP_CITY CITY ON CITY.CITY_ID = C.CITY
                LEFT  JOIN SETUP_COUNTY COUNTY ON COUNTY.COUNTY_ID = C.COUNTY
                INNER JOIN COMPANY_CAT CC ON CC.COMPANYCAT_ID = C.COMPANYCAT_ID
                INNER JOIN COMPANY_CAT_OUR_COMPANY CCOC ON CCOC.COMPANYCAT_ID = CC.COMPANYCAT_ID AND CCOC.OUR_COMPANY_ID IN (#valuelist(get_query_1.comp_id)#)
                INNER JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID 
        WHERE 
              (C.EARCHIVE_SENDING_TYPE IS NULL) AND
              C.USE_EARCHIVE = 1
    </cfquery>
    
    <!--- E-Arşiv Gönderim Tipi Eksik olan Bireysel Üye Kayıtları --->
    <cfquery name="GET_QUERY_16" datasource="#DSN#">
        SELECT DISTINCT
                CN.CONSUMER_ID, 
                CITY.CITY_NAME,
                COUNTY.COUNTY_NAME,
                CN.USE_EARCHIVE,
                CC.CONSCAT,
                CN.CONSUMER_STATUS,
                CN.CONSUMER_NAME,
                CN.CONSUMER_SURNAME,
                CN.CONSUMER_SURNAME
            FROM 
                CONSUMER CN
                    LEFT  JOIN SETUP_CITY CITY ON CITY.CITY_ID = CN.TAX_CITY_ID
                    LEFT  JOIN SETUP_COUNTY COUNTY ON COUNTY.COUNTY_ID = CN.TAX_COUNTY_ID
                    INNER JOIN CONSUMER_CAT CC ON CC.CONSCAT_ID = CN.CONSUMER_CAT_ID
                    INNER JOIN CONSUMER_CAT_OUR_COMPANY CCOC ON CCOC.CONSCAT_ID = CC.CONSCAT_ID AND CCOC.OUR_COMPANY_ID IN (#valuelist(get_query_1.comp_id)#)
            WHERE 
                    (CN.EARCHIVE_SENDING_TYPE IS NULL) AND
                     CN.USE_EARCHIVE = 1
           ORDER BY 
                CN.CONSUMER_NAME,
                CN.CONSUMER_SURNAME
    </cfquery>
	<!---İnternet Satış İşlem Kategorileri--->
    <cfquery name="GET_QUERY_17" datasource="#DSN#">
        <cfloop query="get_query_14">
            SELECT PROCESS_CAT,PROCESS_CAT_ID,INVOICE_TYPE_CODE,PROFILE_ID,'#get_query_14.company_name#' AS COMPANY_NAME,#get_query_14.comp_id# COMP_ID FROM #dsn#_#get_query_14.comp_id#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(48,50,52,53,56,66,561,58,67,532,62,531,121) AND (IS_PUBLIC = 1  OR IS_PARTNER = 1)
            <cfif get_query_14.currentrow neq get_query_14.recordcount>UNION ALL</cfif>
        </cfloop>
    </cfquery>   
<cfelse>
	<cfset GET_QUERY_14.recordcount = 0>
    <cfset GET_QUERY_15.recordcount = 0>
    <cfset GET_QUERY_16.recordcount = 0>
    <cfset GET_QUERY_17.recordcount = 0>
</cfif>

<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT 
    	SP.PERIOD_ID,
        SP.PERIOD_YEAR,
        OC.COMPANY_NAME,
        OC.COMP_ID 
   	FROM 
    	SETUP_PERIOD SP,
        OUR_COMPANY OC 
   	WHERE 
		OC.COMP_ID = SP.OUR_COMPANY_ID AND 
        SP.OUR_COMPANY_ID IN (#valuelist(get_query_1.comp_id)#)  AND
        SP.PERIOD_YEAR > 2014
  	ORDER BY 
    	SP.OUR_COMPANY_ID,
        SP.PERIOD_YEAR
</cfquery>

<!---Birimler Main--->
<cfquery name="GET_QUERY_2" datasource="#DSN#">
	SELECT UNIT FROM SETUP_UNIT WHERE LEN(UNIT_CODE) < 1 OR UNIT_CODE IS NULL
</cfquery>

<!---KDV Oranı Dönem--->
<cfquery name="GET_QUERY_3" datasource="#DSN#">
	<cfloop query="get_period">
	    SELECT TAX,#get_period.period_year# AS PERIOD_YEAR,'#get_period.company_name#' AS COMPANY_NAME FROM #dsn#_#get_period.period_year#_#get_period.comp_id#.SETUP_TAX WHERE TAX_CODE IS NULL
       	<cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
    </cfloop>
</cfquery>


<cfquery name="GET_QUERY_3_1" dbtype="query">
    SELECT * FROM GET_QUERY_3 ORDER BY COMPANY_NAME
</cfquery>


<!---OTV Oranı Sirket--->
<cfquery name="GET_QUERY_4" datasource="#DSN#">
	<cfloop query="get_query_1">
	    SELECT TAX,'#get_query_1.COMPANY_NAME#' AS COMPANY_NAME FROM #dsn#_#get_query_1.comp_id#.SETUP_OTV WHERE TAX_CODE IS NULL AND PERIOD_ID IN (#get_period.period_id#)
        <cfif get_query_1.currentrow neq get_query_1.recordcount>UNION ALL</cfif>
       	<!--- <cfif get_query_1.currentrow eq 1 and get_query_1.currentrow neq get_query_1.recordcount>UNION</cfif> --->
    </cfloop>
</cfquery>

<!---Tevkifat Oranı sirket --->
<cfquery name="GET_QUERY_5" datasource="#DSN#">
	<cfloop query="get_query_1">
	    SELECT TEVKIFAT_ID,STATEMENT_RATE_NUMERATOR,STATEMENT_RATE_DENOMINATOR,'#get_query_1.COMPANY_NAME#' AS COMPANY_NAME,#get_query_1.comp_id# COMP_ID FROM #dsn#_#get_query_1.comp_id#.SETUP_TEVKIFAT WHERE TEVKIFAT_CODE IS NULL<!--- TAX_CODE IS NULL --->
       	<cfif get_query_1.currentrow neq get_query_1.recordcount>UNION ALL</cfif>
    </cfloop>
</cfquery>

<!--- Stopaj Oranı donem --->
<cfquery name="GET_QUERY_6" datasource="#DSN#">
	<cfloop query="get_period">
	    SELECT STOPPAGE_RATE,#get_period.period_year# AS PERIOD_YEAR FROM #dsn#_#get_period.period_year#_#get_period.comp_id#.SETUP_STOPPAGE_RATES WHERE TAX_CODE IS NULL
       	<cfif get_period.currentrow eq 1 and get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
    </cfloop>
</cfquery>

<!---İslem Kategorileri sirket --->
<cfquery name="GET_QUERY_7" datasource="#DSN#">
	<cfloop query="get_query_1">
	    SELECT PROCESS_CAT,PROCESS_CAT_ID,INVOICE_TYPE_CODE,PROFILE_ID,'#get_query_1.company_name#' AS COMPANY_NAME,#get_query_1.comp_id# COMP_ID FROM #dsn#_#get_query_1.comp_id#.SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(48,50,52,53,56,66,561,58,67,532,62,531,121) AND (INVOICE_TYPE_CODE IS NULL OR PROFILE_ID IS NULL)
       	<cfif get_query_1.currentrow neq get_query_1.recordcount>UNION ALL</cfif>
    </cfloop>
</cfquery>

<cfquery name="GET_QUERY_8" datasource="#DSN#">
    SELECT 
    	DISTINCT 
        C.COMPANY_ID,
        CC.COMPANYCAT,
        C.COMPANY_ID,
        C.TAXNO,
        C.FULLNAME,
        C.COMPANY_STATUS,
        C.MEMBER_CODE,
        CITY.CITY_NAME,
        COUNTY.COUNTY_NAME
 	FROM 
        COMPANY C
            LEFT JOIN SETUP_CITY CITY ON CITY.CITY_ID = C.CITY
            LEFT JOIN SETUP_COUNTY COUNTY ON COUNTY.COUNTY_ID = C.COUNTY
            INNER JOIN COMPANY_CAT CC ON CC.COMPANYCAT_ID = C.COMPANYCAT_ID
            INNER JOIN COMPANY_CAT_OUR_COMPANY CCOC ON CCOC.COMPANYCAT_ID = CC.COMPANYCAT_ID AND CCOC.OUR_COMPANY_ID  IN (#valuelist(get_query_1.comp_id)#)
    WHERE 
        (C.CITY IS NULL OR C.COUNTY IS NULL) AND
        C.USE_EFATURA = 1
    ORDER BY 
        C.FULLNAME
</cfquery>
<cfquery name="ALTER_OUR_COMPANY" datasource="#DSN#">
   	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'COMPANY' AND COLUMN_NAME = 'IS_PERSON'
</cfquery>


<!--- İl İlçe Tanımı Eksik Kurumsal Üye Kayıtları (Şahıs) --->
<cfquery name="GET_QUERY_9" datasource="#DSN#">
	SELECT 
        DISTINCT
        CITY.CITY_NAME,
        COUNTY.COUNTY_NAME,
        CC.COMPANYCAT,
        C.COMPANY_ID,
        C.TAXNO,
        C.FULLNAME,
        C.COMPANY_STATUS,
        C.MEMBER_CODE
    FROM 
        COMPANY C
            LEFT  JOIN SETUP_CITY CITY ON CITY.CITY_ID = C.CITY
            LEFT  JOIN SETUP_COUNTY COUNTY ON COUNTY.COUNTY_ID = C.COUNTY
            INNER JOIN COMPANY_CAT CC ON CC.COMPANYCAT_ID = C.COMPANYCAT_ID
            INNER JOIN COMPANY_CAT_OUR_COMPANY CCOC ON CCOC.COMPANYCAT_ID = CC.COMPANYCAT_ID AND CCOC.OUR_COMPANY_ID IN (#valuelist(get_query_1.comp_id)#)
            INNER JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = C.MANAGER_PARTNER_ID 
    WHERE 
          (C.CITY IS NULL OR C.COUNTY IS NULL) AND
          C.USE_EFATURA = 1 
          <cfif alter_our_company.recordcount>
          AND C.IS_PERSON = 1
          </cfif>
</cfquery>

<!--- İl İlçe Tanımı Eksik Bireysel Üye Kayıtları --->
<cfquery name="GET_QUERY_10" datasource="#DSN#">
	SELECT 
    		DISTINCT
            CN.CONSUMER_ID, 
            CITY.CITY_NAME,
            COUNTY.COUNTY_NAME,
            CN.USE_EFATURA,
            CC.CONSCAT,
            CN.CONSUMER_STATUS,
            CN.CONSUMER_NAME,
            CN.CONSUMER_SURNAME,
            CN.CONSUMER_SURNAME
        FROM 
            CONSUMER CN
                LEFT  JOIN SETUP_CITY CITY ON CITY.CITY_ID = CN.TAX_CITY_ID
                LEFT  JOIN SETUP_COUNTY COUNTY ON COUNTY.COUNTY_ID = CN.TAX_COUNTY_ID
                INNER JOIN CONSUMER_CAT CC ON CC.CONSCAT_ID = CN.CONSUMER_CAT_ID
                INNER JOIN CONSUMER_CAT_OUR_COMPANY CCOC ON CCOC.CONSCAT_ID = CC.CONSCAT_ID AND CCOC.OUR_COMPANY_ID IN (#valuelist(get_query_1.comp_id)#)
		WHERE 
				(CN.TAX_CITY_ID IS NULL OR CN.TAX_COUNTY_ID IS NULL) AND
            	 CN.USE_EFATURA = 1
       ORDER BY 
            CN.CONSUMER_NAME,
            CN.CONSUMER_SURNAME
</cfquery>
<!---Ödeme Yöntemi Eksik Olan Kayıtlar--->
<cfquery name="GET_QUERY_11" datasource="#DSN#">
    SELECT 
    	PAYMETHOD_ID,
    	PAYMETHOD 
    FROM 
    	SETUP_PAYMETHOD 
    WHERE 
    	PAYMENT_MEANS_CODE IS NULL
</cfquery>

<!---Kredi Kartı Ödeme/Tahsil Yöntemi Eksik olan Kayıtlar--->
<cfquery name="GET_PAYMENT_MEANS_CODE" datasource="#DSN3#" >
   	SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CREDITCARD_PAYMENT_TYPE' AND COLUMN_NAME = 'PAYMENT_MEANS_CODE'
</cfquery>

<!---Döviz Kodu Dönem--->
<cfquery name="GET_QUERY_13" datasource="#DSN#">
	<cfloop query="get_period">
    	SELECT MONEY,#get_period.period_year# AS PERIOD_YEAR,'#get_period.company_name#' AS COMPANY_NAME FROM #dsn#_#get_period.period_year#_#get_period.comp_id#.SETUP_MONEY WHERE CURRENCY_CODE IS NULL
        <cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
    </cfloop>
</cfquery>

<cfif get_payment_means_code.recordcount>
    <cfquery name="GET_QUERY_12" datasource="#DSN#">
        <cfloop query="get_query_1">
            SELECT PAYMENT_TYPE_ID,CARD_NO,'#get_query_1.company_name#' AS COMPANY_NAME,#get_query_1.comp_id# COMP_ID FROM #dsn#_#get_query_1.comp_id#.CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_MEANS_CODE IS NULL
            <cfif get_query_1.currentrow neq get_query_1.recordcount>UNION ALL</cfif>
        </cfloop>
    </cfquery>
<cfelse>
	<cfset get_query_12.recordcount = 0>
</cfif>

<cfquery name="get_product_stock" datasource="#dsn1#">
    SELECT
        COUNT(SCS.STOCK_ID) AS STOCK_ID_COUNT,
        SCS.STOCK_ID,
        SCS.COMPANY_ID,
        C.FULLNAME,
        S.STOCK_CODE,
        P.PRODUCT_ID,
        P.PRODUCT_NAME
        
    FROM 
        SETUP_COMPANY_STOCK_CODE SCS,
        #dsn_alias#.COMPANY C,
        STOCKS S,
        PRODUCT P
    WHERE
        C.COMPANY_ID = SCS.COMPANY_ID AND
        P.PRODUCT_ID = S.PRODUCT_ID AND
        S.STOCK_ID = SCS.STOCK_ID
    GROUP BY 
        SCS.STOCK_ID, SCS.COMPANY_ID,C.FULLNAME,S.STOCK_CODE, P.PRODUCT_NAME, P.PRODUCT_ID
    HAVING 
        COUNT(SCS.STOCK_ID) > 1
</cfquery>

<style type="text/css">
	.fontRed td { color:red !important; font-weight:bold !important; }
</style>
<cfif get_query_1.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','E-fatura Kullanan Şirketler',34233)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='58527.ID'></th>
                        <th><cf_get_lang dictionary_id='30371.Entegratör'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th>
                        <th><cf_get_lang dictionary_id='57752.Vergi No'></th>
                        <th><cf_get_lang dictionary_id='55918.Ticaret Sicil No'></th>
                        <th><cf_get_lang dictionary_id='43035.Mersis No'></th>
                        <th><cf_get_lang dictionary_id='58219.Ülke'></th>
                        <th><cf_get_lang dictionary_id='58608.İl'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                        <th><cf_get_lang dictionary_id='58735.Mahalle'></th>
                        <th><cf_get_lang dictionary_id='30372.Cadde - Sokak Adı'></th>
                        <th><cf_get_lang dictionary_id='58132.Semt'></th>
                        <th><cf_get_lang dictionary_id='57472.Posta Kodu'></th>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                    </tr>
                </thead>        
                <cfoutput query="GET_QUERY_1">
                        <tbody>
                            <tr <cfif not len(country_name) or not len(city_name) or not len(county_name)>class="fontRed"</cfif>>
                                <td>#currentrow#</td>
                                <td>#comp_id#</td>
                                <td>
                                    <cfswitch expression="#einvoice_type#">
                                        <cfcase value="1"><cf_get_lang dictionary_id='30373.GIB Portal'></cfcase>
                                        <cfcase value="3"><cf_get_lang dictionary_id='30374.Dijital Planet'></cfcase>
                                        <cfcase value="4"><cf_get_lang dictionary_id='30378.SAP FIT'></cfcase>
                                        <cfcase value="5"><cf_get_lang dictionary_id='48747.ING'></cfcase>
                                        <cfcase value="6"><cf_get_lang dictionary_id='30379.E-Finans'></cfcase>
                                        <cfcase value="7"><cf_get_lang dictionary_id='30383.Medyasoft'></cfcase>
                                        <cfcase value="8"><cf_get_lang dictionary_id='62360.FIT'></cfcase> 
                                        <cfdefaultcase>-</cfdefaultcase>
                                    </cfswitch>
                                </td>
                                    <cfif einvoice_test_system eq 0>
                                        <td style="color:red; font-weight:bold"><cf_get_lang dictionary_id='490.Gerçek'></td>
                                    <cfelseif einvoice_test_system eq 1>
                                        <td><cf_get_lang dictionary_id='58826.Test'></td>
                                    <cfelse>
                                        <td><cf_get_lang dictionary_id='58845.Tanımsız'></td>
                                    </cfif>
                                <td>#company_name#</td>
                                <td>#tax_office#</td>
                                <td>#tax_no#</td>
                                <td>#t_no#</td>
                                <td>#mersis_no#</td>
                                <td>#country_name#</td>
                                <td>#city_name#</td>
                                <td>#county_name#</td>
                                <td>#district_name#</td>
                                <td>#street_name#</td>
                                <td>#city_subdivision_name#</td>
                                <td>#postal_code#</td>
                                <td>#building_number#</td>
                            </tr>
                            
                        </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_14.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','E-Arşiv Kullanan Şirketler',34232)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='58527.ID'></th>
                        <th><cf_get_lang dictionary_id='30371.Entegratör'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th>
                        <th><cf_get_lang dictionary_id='57752.Vergi No'></th>
                        <th><cf_get_lang dictionary_id='55918.Ticaret Sicil No'></th>
                        <th><cf_get_lang dictionary_id='43035.Mersis No'></th>
                        <th><cf_get_lang dictionary_id='58219.Ülke'></th>
                        <th><cf_get_lang dictionary_id='58608.İl'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                        <th><cf_get_lang dictionary_id='58735.Mahalle'></th>
                        <th><cf_get_lang dictionary_id='30372.Cadde - Sokak Adı'></th>
                        <th><cf_get_lang dictionary_id='58132.Semt'></th>
                        <th><cf_get_lang dictionary_id='57472.Posta Kodu'></th>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                    </tr>
                </thead>        
               <cfoutput query="GET_QUERY_14">
                    <tbody>
                        <tr <cfif not len(country_name) or not len(city_name) or not len(county_name)>class="fontRed"</cfif>>
                            <td>#currentrow#</td>
                            <td>#comp_id#</td>
                            <td><cf_get_lang dictionary_id='30374.Dijital Planet'></td>
                            <cfif earchive_test_system eq 0>
                            	<td style="color:red; font-weight:bold"><cf_get_lang dictionary_id='490.Gerçek'></td>
                            <cfelseif earchive_test_system eq 1>
                            	<td><cf_get_lang dictionary_id='58826.Test'></td>
                            <cfelse>
                            	<td><cf_get_lang dictionary_id='58845.Tanımsız'></td>
                            </cfif>
                            <td>#company_name#</td>
                            <td>#tax_office#</td>
                            <td>#tax_no#</td>
                            <td>#t_no#</td>
                            <td>#mersis_no#</td>
                            <td>#country_name#</td>
                            <td>#city_name#</td>
                            <td>#county_name#</td>
                            <td>#district_name#</td>
                            <td>#street_name#</td>
                            <td>#city_subdivision_name#</td>
                            <td>#postal_code#</td>
                            <td>#building_number#</td>
                        </tr>
                    </tbody>
              </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_16.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İl İlçe Tanımı Eksik Bireysel Üye Kayıtları',34231)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th> 
                        <th><cf_get_lang dictionary_id='30388.E-Arşiv Mükellefi'></th>               
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id='57971.Şehir'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                     </tr>
                </thead>          
               <cfoutput query="get_query_16" maxrows="100">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>
                            <td><cf_get_lang dictionary_id='30393.Mükellef'></td>                    
                            <td><cfif get_query_16.consumer_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td> 
                            <td><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#consumer_name# #consumer_surname#</a></td>
                            <td>#conscat#</td>
                            <td>#city_name#</td>
                            <td>#county_name#</td>
                        </tr>
                    </tbody>
              </cfoutput>
            </cf_grid_list>
            <br/><cfoutput><cf_get_lang dictionary_id='30453.E-Arşiv Gönderim Tipi Eksik olan Toplam Bireysel Üye Kayıt Sayısı'> : #get_query_16.recordcount# </cfoutput>
        </cf_box>
        </div>	
</cfif>

<cfif get_query_15.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','E-Arşiv Gönderim Tipi Eksik olan Kurumsal Üye Kayıtları',34230)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='30388.E-Arşiv Mükellefi'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id='57971.Şehir'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_query_15" maxrows="100">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td><cf_get_lang dictionary_id='30393.Mükellef'></td>
                            <td><cfif get_query_9.company_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td> 
                            <td>#member_code#</td>                       
                            <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#company_id#" class="tableyazi">#right(fullname,100)#</a></td>
                            <td>#companycat#</td>
                            <td>#city_name#</td>
                            <td>#county_name#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
            <br/><cfoutput><cf_get_lang dictionary_id='62359.E-Arşiv Gönderim Tipi Eksik olan Toplam Kurumsal Üye Kayıt Sayısı'> : #get_query_15.recordcount# </cfoutput>
        </cf_box>
    </div>
</cfif>


<cfif get_query_2.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Birim Tanımı Eksik Kayıtlar',34229)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='37190.Birim Adı'></th>
                    </tr>
                </thead>         
                <cfoutput query="GET_QUERY_2">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td>#unit#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_13.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Döviz Kodları (İlgili Dönemdeki Para Birimlerini Güncelleyiniz)',34193)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                        <th><cf_get_lang dictionary_id='42484.Dönem Yılı'></th>
                        <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                    </tr>
                </thead>
                <cfoutput query="GET_QUERY_13">
                <tbody>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#company_name#</td>
                        <td>#period_year#</td>
                        <td>#money#</td>
                    </tr>
                </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_3_1.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','KDV Tanımı Eksik Kayıtlar',34192)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th> 
                        <th><cf_get_lang dictionary_id='57574.Şirket'></th>                
                        <th><cf_get_lang dictionary_id='42484.Dönem Yılı'></th>
                        <th><cf_get_lang dictionary_id='57639.KDV'></th>
                    </tr>
                </thead>          
                <cfoutput query="GET_QUERY_3_1">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td> 
                            <td>#company_name#</td>          	
                            <td>#period_year#</td>
                            <td>#tax#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_4.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','ÖTV Tanımı Eksik Kayıtlar',34191)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='44616.OTV (%)'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_query_4">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td>#company_name#</td>
                            <td>#tax#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_5.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Tevkifat Tanımı Eksik Kayıtlar',34189)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='58022.Tevkifat'></th>
                    </tr>
                </thead>         
                <cfoutput query="get_query_5">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    	
                            <td>#company_name#</td>
                            <td><cfif session.ep.company_id eq get_query_5.comp_id><a href="#request.self#?fuseaction=settings.form_upd_tevkifat&id=#tevkifat_id#" class="tableyazi">#statement_rate_numerator#/#statement_rate_denominator#<cfelse>#statement_rate_numerator#/#statement_rate_denominator#</cfif></a></td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_6.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Stopaj Oranı Tanımı Eksik Kayıtlar',34176)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='42484.Dönem Yılı'></th>
                        <th><cf_get_lang dictionary_id='57711.Stopaj'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_query_6">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td>#period_year#</td>
                            <td>#stoppage_rate#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_11.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Ödeme Yöntemi Eksik Kayıtlar',34175)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="100px"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                    </tr>
                </thead>        
                <cfoutput query="GET_QUERY_11">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=settings.form_upd_paymethod&paymethod_id=#paymethod_id#" class="tableyazi">#paymethod#</a></td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_12.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Kredi Kartı Ödeme/Tahsil Yöntemi Eksik olan Kayıtlar',34131)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    </tr>
                </thead>        
                <cfoutput query="GET_QUERY_12">
                    <tbody>
                        <tr>
                            <td width="25">#currentrow#</td>
                            <td>#company_name#</td>
                            <td><cfif session.ep.company_id eq get_query_12.comp_id><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=finance.popup_form_upd_credit_payment&id=#payment_type_id#','large','popup_form_upd_credit_payment');" class="tableyazi">#card_no#</a><cfelse>#card_no#</cfif></td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_7.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İşlem Kategori Tanımı Eksik Kayıtlar',34130)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='42382.İşlem Kategorisi'></th>
                        <th><cf_get_lang dictionary_id='33576.Invoice Type Code'></th>
                        <th><cf_get_lang dictionary_id='30458.Profile ID'></th>                    
                    </tr>
                </thead>          
                <cfoutput query="get_query_7">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td>#company_name#</td>
                            <td><cfif session.ep.company_id eq get_query_7.comp_id><a href="#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#process_cat_id#" target="_blank" class="tableyazi">#process_cat#</a><cfelse>#process_cat#</cfif></td>
                            <td>#invoice_type_code#</td>
                            <td>#profile_id#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_17.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','e-Arşiv İnternet Satış İşlem Kategorileri',34127)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='42382.İşlem Kategorisi'></th>
                        <th><cf_get_lang dictionary_id='33576.Invoice Type Code'></th>
                        <th><cf_get_lang dictionary_id='30458.Profile ID'></th>                    
                    </tr>
                </thead>          
            <cfoutput query="get_query_17">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td>#company_name#</td>
                            <td><cfif session.ep.company_id eq get_query_17.comp_id><a href="#request.self#?fuseaction=settings.list_process_cats&event=upd&process_cat_id=#process_cat_id#" target="_blank" class="tableyazi">#process_cat#</a><cfelse>#process_cat#</cfif></td>
                            <td>#invoice_type_code#</td>
                            <td>#profile_id#</td>
                        </tr>
                    </tbody>
            </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_8.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İl İlçe Tanımı Eksik Kurumsal Üye Kayıtları',34124)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='59034.e-Fatura Mükellefi'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='57752.Vergi No'></th>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id='57971.Şehir'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_query_8">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td><cf_get_lang dictionary_id='30393.Mükellef'></td>
                            <td><cfif get_query_8.company_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td> 
                            <td>#taxno#</td> 
                            <td>#member_code#</td>                       
                            <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#company_id#" class="tableyazi">#right(fullname,100)#</a></td>
                            <td>#companycat#</td>
                            <td>#city_name#</td>
                            <td>#county_name#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
 </cfif>
 
<cfif get_query_9.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İl İlçe Tanımı Eksik Kurumsal Üye Kayıtları(şahıs)',34302)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='59034.e-Fatura Mükellefi'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id='57971.Şehir'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_query_9">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td><cf_get_lang dictionary_id='30393.Mükellef'></td>
                            <td><cfif get_query_9.company_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td> 
                            <td>#member_code#</td>                       
                            <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#company_id#" class="tableyazi">#right(fullname,100)#</a></td>
                            <td>#companycat#</td>
                            <td>#city_name#</td>
                            <td>#county_name#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_query_10.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İl İlçe Tanımı Eksik Bireysel Üye Kayıtları',34231)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th> 
                        <th><cf_get_lang dictionary_id='59034.e-Fatura Mükellefi'></th>               
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th><cf_get_lang dictionary_id='57971.Şehir'></th>
                        <th><cf_get_lang dictionary_id='58638.İlçe'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_query_10">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>
                            <td><cf_get_lang dictionary_id='30393.Mükellef'></td>                    
                            <td><cfif get_query_10.consumer_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td> 
                            <td><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#consumer_name# #consumer_surname#</a></td>
                            <td>#conscat#</td>
                            <td>#city_name#</td>
                            <td>#county_name#</td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>

<cfif get_product_stock.recordcount>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','Ürün Üye Stok Kodu Çoklayan Kayıtlar',34301)#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>                
                        <th><cf_get_lang dictionary_id='58485.Şirket Adı'></th>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                    </tr>
                </thead>          
                <cfoutput query="get_product_stock">
                    <tbody>
                        <tr>
                            <td>#currentrow#</td>                    
                            <td>#get_product_stock.fullname#</td>
                            <td>#get_product_stock.stock_code#</td> 
                            <td><a href="index.cfm?fuseaction=product.list_product&event=det&pid=#get_product_stock.product_id#" class="tableyazi">#get_product_stock.product_name#</a></td>
                        </tr>
                    </tbody>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>	
</cfif>