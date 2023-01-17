<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfparam name="attributes.start_date" default="">
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfparam name="attributes.finish_date" default="">
</cfif>
<cfif isdefined("attributes.start_date_1") and len(attributes.start_date_1)>
	<cf_date tarih = "attributes.start_date_1">
<cfelse>
	<cfparam name="attributes.start_date_1" default="">
</cfif>

<cfif isdefined("attributes.finish_date_1") and len(attributes.finish_date_1)>
	<cf_date tarih = "attributes.finish_date_1">
<cfelse>
	<cfparam name="attributes.finish_date_1" default="">
</cfif>

<cfif isdefined("attributes.n_start_date") and len(attributes.n_start_date)>
	<cf_date tarih = "attributes.n_start_date">
<cfelse>
	<cfparam name="attributes.n_start_date" default="">
</cfif>

<cfif isdefined("attributes.n_finish_date") and len(attributes.n_finish_date)>
	<cf_date tarih = "attributes.n_finish_date">
<cfelse>
	<cfparam name="attributes.n_finish_date" default="">
</cfif>

<cfif isdefined("attributes.n_start_date_1") and len(attributes.n_start_date_1)>
	<cf_date tarih = "attributes.n_start_date_1">
<cfelse>
	<cfparam name="attributes.n_start_date_1" default="">
</cfif>

<cfif isdefined("attributes.n_finish_date_1") and len(attributes.n_finish_date_1)>
	<cf_date tarih = "attributes.n_finish_date_1">
<cfelse>
	<cfparam name="attributes.n_finish_date_1" default="">
</cfif>

<cfparam name="attributes.account_id" default="">
<cfparam name="attributes.status" default="1">


<cf_report_list_search id="report_ship" title="#getLang('','Kredi Kartı Raporu',61863)#">
    <cf_report_list_search_area>
        <cfform name="report" id="report" method="post" action="#request.self#?fuseaction=retail.credit_card_payment_report">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-3 col-md-6 col-xs-12">
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'></label>
									<div class="col col-12 col-xs-12">
                                        <select name="status">
                                            <option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                            <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'></label>
									<div class="col col-12 col-xs-12">
                                        <cfquery name="get_banks" datasource="#dsn3#">
                                            SELECT DISTINCT
                                                A.ACCOUNT_NAME,
                                                BB.BANK_BRANCH_NAME,
                                                A.ACCOUNT_ID
                                            FROM
                                                ACCOUNTS A INNER JOIN
                                                BANK_BRANCH BB ON BB.BANK_BRANCH_ID = A.ACCOUNT_BRANCH_ID
                                            WHERE
                                                A.ACCOUNT_ID IN (
                                                    SELECT 
                                                        CC.ACCOUNT_ID 
                                                    FROM 
                                                        CREDIT_CARD CC 
                                                    WHERE 
                                                        CC.ACCOUNT_ID IS NOT NULL
                                                        <cfif attributes.status eq 1>
                                                            AND CC.IS_ACTIVE = 1
                                                        </cfif>
                                                        <cfif attributes.status eq 0>
                                                            AND CC.IS_ACTIVE = 0
                                                        </cfif>
                                                        )
                                            ORDER BY
                                                A.ACCOUNT_NAME,
                                                BB.BANK_BRANCH_NAME,
                                                A.ACCOUNT_ID
                                        </cfquery>
                                        <select name="account_id">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfoutput query="get_banks">
                                                <option value="#ACCOUNT_ID#" <cfif attributes.account_id eq ACCOUNT_ID>selected</cfif>>#ACCOUNT_NAME# #BANK_BRANCH_NAME#</option>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62339.Hesap Kesim Tarihi Başlangıcı'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62340.Hesap Kesim Tarihi Bitişi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="finish_date" id="finish_date"  maxlength="10" value="#dateformat(attributes.finish_date,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">  <cf_wrk_date_image date_field="finish_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62343.Ödeme Tarihi Başlangıcı'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="start_date_1" id="start_date_1"  maxlength="10" value="#dateformat(attributes.start_date_1,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">   <cf_wrk_date_image date_field="start_date_1"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62342.Ödeme Tarihi Bitişi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="finish_date_1" id="finish_date_1"  maxlength="10" value="#dateformat(attributes.finish_date_1,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">  <cf_wrk_date_image date_field="finish_date_1"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62344.Sonraki Hesap Kesim Tarihi Başlangıcı'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="n_start_date" id="n_start_date" maxlength="10" value="#dateformat(attributes.n_start_date,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">   <cf_wrk_date_image date_field="n_start_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62345.Sonraki Hesap Kesim Tarihi Bitişi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="n_finish_date" id="n_finish_date"  maxlength="10" value="#dateformat(attributes.n_finish_date,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">  <cf_wrk_date_image date_field="n_finish_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62346.Sonraki Ödeme Tarihi Başlangıcı'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="n_start_date_1" id="n_start_date_1"  maxlength="10" value="#dateformat(attributes.n_start_date_1,'dd/mm/yyyy')#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">   <cf_wrk_date_image date_field="n_start_date_1"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='62347.Sonraki Ödeme Tarihi Bitişi'></label>
									<div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfinput type="text" name="n_finish_date_1" id="n_finish_date_1"  maxlength="10" value="#dateformat(attributes.n_finish_date_1,"dd/mm/yyyy")#" style="width:65px;" validate="eurodate">
                                            <span class="input-group-addon">  <cf_wrk_date_image date_field="n_finish_date_1"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<cf_wrk_search_button is_excel="1" button_type="1">
						</div>
					</div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>

<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_cards_all" datasource="#dsn3#">
    SELECT
        *
    FROM
    (
        SELECT
            CC.CREDITCARD_NUMBER,
            CC.CREDITCARD_ID,
            CC.CLOSE_DATE,
            CC.PAYMENT_DATE,
            CC.NEXT_CLOSE_DATE,
            CC.NEXT_PAYMENT_DATE,
            ISNULL(CC.MINIMUM_PAYMENT,0) AS MINIMUM_PAYMENT,
            ISNULL(CC.EXTRE_VALUE,0) AS EXTRE_VALUE,
            (SELECT
                A.ACCOUNT_NAME+' - '+BB.BANK_BRANCH_NAME 
            FROM
                ACCOUNTS A INNER JOIN
                BANK_BRANCH BB ON BB.BANK_BRANCH_ID = A.ACCOUNT_BRANCH_ID
            WHERE
                A.ACCOUNT_ID = CC.ACCOUNT_ID
            ) BANKA_HESAP,
            CC.CARD_LIMIT,
            CC.CLOSE_ACC_DAY,
            CASE WHEN CLOSE_ACC_DAY < DAY(GETDATE()) THEN MONTH(GETDATE())+1 ELSE MONTH(GETDATE()) END MONTH_2,
            CC.PAYMENT_DAY,
            ISNULL(
            	(
                	SELECT 
                    	SUM(CREDIT_CARD_BANK_EXPENSE_RELATIONS.CLOSED_AMOUNT) 
                    FROM 
                    	CREDIT_CARD_BANK_EXPENSE_RELATIONS,
                        CREDIT_CARD_BANK_EXPENSE_ROWS,
                        CREDIT_CARD_BANK_EXPENSE
                    WHERE 
                    	CREDIT_CARD_BANK_EXPENSE.CREDITCARD_ID = CC.CREDITCARD_ID AND
                        CREDIT_CARD_BANK_EXPENSE_ROWS.CREDITCARD_EXPENSE_ID = CREDIT_CARD_BANK_EXPENSE.CREDITCARD_EXPENSE_ID AND
                        CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID
                ),0) ACTION_VALUE,
            --(SELECT SUM(ACTION_VALUE)  FROM #dsn2_alias#.BANK_ACTIONS WHERE CREDITCARD_ID = CC.CREDITCARD_ID) ACTION_VALUE,
            CC.ACCOUNT_ID
        FROM
            CREDIT_CARD CC
        WHERE
        	CC.CREDITCARD_NUMBER IS NOT NULL 
            <cfif attributes.status eq 1>
            	AND CC.IS_ACTIVE = 1
            </cfif>
            <cfif attributes.status eq 0>
            	AND CC.IS_ACTIVE = 0
            </cfif>
            <cfif len(attributes.account_id)>
            	AND CC.ACCOUNT_ID = #attributes.account_id#
            </cfif> 
     ) B
     WHERE
        1=1
    ORDER BY
        BANKA_HESAP ASC
    </cfquery>
<cfset year_ = year(now())>
<cfset month_ = month(now())>

    <cfoutput query="get_cards_all">
    	<cfset date_1 = createdate(year_,month_,CLOSE_ACC_DAY)>
		<cfset date_2 = dateadd('d',PAYMENT_DAY,date_1)>
        <cfif datediff('d',now(),date_2) lt 0>
            <cfset date_1 = dateadd('m',1,date_1)>
            <cfset date_2 = dateadd('d',PAYMENT_DAY,date_1)>
        </cfif>
        
        <cfif not len(CLOSE_DATE)>
			<cfset aa = querysetcell(get_cards_all,'CLOSE_DATE',CREATEODBCDATETIME(date_1),currentrow)>
        </cfif>
        <cfif not len(PAYMENT_DATE)>
        	<cfset bb = querysetcell(get_cards_all,'PAYMENT_DATE',CREATEODBCDATETIME(date_2),currentrow)>
        </cfif>
        
        <cfif not len(NEXT_CLOSE_DATE)>
			<cfset cc = querysetcell(get_cards_all,'NEXT_CLOSE_DATE',dateadd('m',1,CREATEODBCDATETIME(date_1)),currentrow)>
        </cfif>
        <cfif not len(NEXT_PAYMENT_DATE)>
        	<cfset dd = querysetcell(get_cards_all,'NEXT_PAYMENT_DATE',dateadd('m',1,CREATEODBCDATETIME(date_2)),currentrow)>
        </cfif>
    </cfoutput>
    
    <cfquery name="get_cards" dbtype="query">
    	SELECT
        	*
        FROM
        	get_cards_all
        WHERE
        	1=1
			<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                AND	CLOSE_DATE >= #attributes.start_date# 
            </cfif>
            <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                AND CLOSE_DATE <= #attributes.finish_date# 
            </cfif>
            <cfif isdefined('attributes.start_date_1') and len(attributes.start_date_1)>
                AND PAYMENT_DATE >= #attributes.start_date_1#  
            </cfif>
            <cfif isdefined('attributes.finish_date_1') and len(attributes.finish_date_1)>
                AND PAYMENT_DATE <= #attributes.finish_date_1#
            </cfif>
            <cfif isdefined('attributes.n_start_date') and len(attributes.n_start_date)>
                AND	NEXT_CLOSE_DATE >= #attributes.n_start_date# 
            </cfif>
            <cfif isdefined('attributes.n_finish_date') and len(attributes.n_finish_date)>
                AND NEXT_CLOSE_DATE <= #attributes.n_finish_date# 
            </cfif>
            <cfif isdefined('attributes.n_start_date_1') and len(attributes.n_start_date_1)>
                AND NEXT_PAYMENT_DATE >= #attributes.n_start_date_1#  
            </cfif>
            <cfif isdefined('attributes.n_finish_date_1') and len(attributes.n_finish_date_1)>
                AND NEXT_PAYMENT_DATE <= #attributes.n_finish_date_1#
            </cfif>
    </cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>    
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='30233.Kart No'></th>
                        <th><cf_get_lang dictionary_id='57652.Hesap'></th>
                        <th><cf_get_lang dictionary_id='62348.Kart Limiti'></th>
                        <th><cf_get_lang dictionary_id='62349.Hesap Kesim Tarihi'></th>
                        <th><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></th>
                        <th><cf_get_lang dictionary_id='62350.Sonraki Hesap Kesim'></th>
                        <th><cf_get_lang dictionary_id='62351.Sonraki Ödeme Tarihi'></th>
                        <th><cf_get_lang dictionary_id='51536.Harcanan Tutar'></th>
                        <th><cf_get_lang dictionary_id='62352.Ödenen Borç'></th>
                        <th><cf_get_lang dictionary_id='62353.Kalan Borç'></th>
                        <!---<th>Extre Tutar</th> --->
                        <th><cf_get_lang dictionary_id='62354.Dönem İçi Harcama'></th>
                        <th><cf_get_lang dictionary_id='57878.Kullanılabilir Limit'></th>
                        <th><cf_get_lang dictionary_id='62355.Kalan Taksit Adedi'></th>
                        <th><cf_get_lang dictionary_id='62356.Kalan Taksit Tutarı'></th>
                        <th><cf_get_lang dictionary_id='62357.Extre Tutar'></th>
                        <th><cf_get_lang dictionary_id='62358.Minimum Ödeme Tutarı'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfset odeme_toplam = 0>
                    <cfset ekstre_toplam = 0>
                    <cfset limit_toplam = 0>
                    <cfset h_toplam = 0>
                    <cfset o_toplam = 0>
                    <cfset kb_toplam = 0>
                    <cfset d_toplam = 0>
                    <cfset kl_toplam = 0>
                    <cfset kt_toplam = 0>
                    <cfset ktt_toplam = 0>
                    <cfif get_cards.recordcount>
                        <cfoutput query="get_cards">
                            <cfif len(CREDITCARD_NUMBER)>
                                <cfset key_type = '#session.ep.company_id#'>

                                    <cfset content = '#Decrypt(CREDITCARD_NUMBER,key_type,"CFMX_COMPAT","Hex")#'>
                            <cfelse>
                                <cfset content = ''>
                            </cfif>
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                            <cfset credit_card_info = ACCOUNT_ID&';TL;'&CREDITCARD_ID>
                            <a class="tableyazi" href="javascript://" onclick="windowopen('index.cfm?fuseaction=bank.list_credit_card_expense&credit_card_info=#credit_card_info#&form_submitted=1','list');">
                                #content#
                            </a>
                            </td>
                            <td>#BANKA_HESAP#</td>
                            <td>#tlformat(CARD_LIMIT)#<cfset limit_toplam = limit_toplam + CARD_LIMIT></td>
                            <td>#dateformat(close_date,'dd/mm/yyyy')#</td>
                            <td align="right">#dateformat(payment_date,'dd/mm/yyyy')#</td>
                            <td>#dateformat(next_close_date,'dd/mm/yyyy')#</td>
                            <td align="right">#dateformat(next_payment_date,'dd/mm/yyyy')#</td>
                            <cfset date_1 = createodbcdatetime(close_date)>
                            <cfset date_later = createodbcdatetime(next_close_date)>
                            <cfquery name="GET_HARCAMA" datasource="#DSN3#">
                                SELECT 
                                    SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT 
                                FROM 
                                    CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                                WHERE 
                                    CCE.CREDITCARD_ID = #CREDITCARD_ID# 
                                    --AND CCE.ACC_ACTION_DATE <= #date_1# 
                            </cfquery> 
                            
                            <cfif isdefined('GET_HARCAMA.INSTALLMENT_AMOUNT') and len(GET_HARCAMA.INSTALLMENT_AMOUNT)>
                                <cfset  harcama = GET_HARCAMA.INSTALLMENT_AMOUNT>
                            <cfelse>
                                <cfset  harcama = 0>
                            </cfif>
                            <cfquery name="GET_HARCAMA_IC" datasource="#DSN3#">
                                SELECT 
                                    SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT 
                                FROM 
                                    CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                                WHERE 
                                    CCE.CREDITCARD_ID = #CREDITCARD_ID# AND 
                                    CCE.ACC_ACTION_DATE > #date_1# AND 
                                    CCE.ACC_ACTION_DATE < #dateadd('d',1,date_later)# 
                            </cfquery>
                                            
                            <cfif isdefined('GET_HARCAMA_IC.INSTALLMENT_AMOUNT') and len(GET_HARCAMA_IC.INSTALLMENT_AMOUNT)>
                                <cfset  donem_ici = GET_HARCAMA_IC.INSTALLMENT_AMOUNT>
                            <cfelse>
                                <cfset  donem_ici = 0>
                            </cfif>
                            
                            <cfif isdefined('ACTION_VALUE') and len(ACTION_VALUE)>
                                <cfset  ödeme = ACTION_VALUE>
                            <cfelse>
                                <cfset  ödeme = 0>
                            </cfif>
                            
                            <cfquery name="GET_TAKSIT" datasource="#DSN3#">
                                SELECT 
                                    SUM(INSTALLMENT_AMOUNT) INSTALLMENT_AMOUNT,
                                    COUNT(CREDITCARD_ID) ISTALLMENT_COUNT
                                FROM 
                                    CREDIT_CARD_BANK_EXPENSE_ROWS CCE 
                                WHERE 
                                    CCE.CREDITCARD_ID = #CREDITCARD_ID# AND 
                                    CCE.ACC_ACTION_DATE > #date_later# 
                            </cfquery>
                            <cfif isdefined('GET_TAKSIT.INSTALLMENT_AMOUNT') and len(GET_TAKSIT.INSTALLMENT_AMOUNT)>
                                <cfset gelecek_taksitler = GET_TAKSIT.INSTALLMENT_AMOUNT>
                            <cfelse>
                                <cfset gelecek_taksitler = 0>
                            </cfif>
                            
                            <cfset  extre_ = harcama - (ödeme + gelecek_taksitler + donem_ici)>
                                        
                            <td style="text-align:right">#tlformat(harcama)#</td>
                            <td style="text-align:right">#tlformat(ödeme)#</td>
                            <td style="text-align:right">#tlformat(harcama - ödeme)#</td>
                            <td style="text-align:right">#tlformat(donem_ici)#</td>
                            <td style="text-align:right">
                                #tlformat(CARD_LIMIT - (harcama - ödeme))#
                            </td>
                            <cfset h_toplam = h_toplam + harcama>
                            <cfset o_toplam = o_toplam + ödeme>
                            <cfset kb_toplam = kb_toplam + (harcama - ödeme)>
                            <cfset d_toplam = d_toplam + donem_ici>
                            <cfset kl_toplam = kl_toplam + (CARD_LIMIT - (harcama - ödeme))>

                            <cfif GET_TAKSIT.recordcount and len(GET_TAKSIT.INSTALLMENT_AMOUNT)>
                                <td style="text-align:right">#GET_TAKSIT.ISTALLMENT_COUNT#</td>
                                <td style="text-align:right">#tlformat(GET_TAKSIT.INSTALLMENT_AMOUNT)#</td>
                                <cfset kt_toplam = kt_toplam + GET_TAKSIT.ISTALLMENT_COUNT>
                                <cfset ktt_toplam = ktt_toplam + GET_TAKSIT.INSTALLMENT_AMOUNT>
                            <cfelse>
                                <td align="right"></td>
                                <td align="right"></td>
                            </cfif>
                            <td style="text-align:right">#tlformat(extre_value)#</td>
                            <td style="text-align:right">#tlformat(minimum_payment)#</td>
                        </tr>
                        <cfset odeme_toplam = odeme_toplam + minimum_payment>
                        <cfset ekstre_toplam = ekstre_toplam + extre_value>
                        </cfoutput>
                    </cfif>
                </tbody>
                <cfoutput>
                    <tfoot>
                        <tr>
                            <td colspan="3"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <td style="text-align:right;">#tlformat(limit_toplam)#</td>
                            <td colspan="4">&nbsp;</td>
                            <td style="text-align:right;">#tlformat(h_toplam)#</td>
                            <td style="text-align:right;">#tlformat(o_toplam)#</td>
                            <td style="text-align:right;">#tlformat(kb_toplam)#</td>
                            <td style="text-align:right;">#tlformat(d_toplam)#</td>
                            <td style="text-align:right;">#tlformat(kl_toplam)#</td>
                            <td style="text-align:right;">#tlformat(kt_toplam,0)#</td>
                            <td style="text-align:right;">#tlformat(ktt_toplam)#</td>
                            <td style="text-align:right;">#tlformat(ekstre_toplam)#</td>
                            <td style="text-align:right;">#tlformat(odeme_toplam)#</td>
                        </tr>
                    </tfoot>
                </cfoutput>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>