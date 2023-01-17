<cf_date tarih='attributes.give_date'>
<!--- AND PERIOD_ID = #session.ep.period_id#  --->
<cfquery name="get_money_dolar" datasource="#dsn#">
    SELECT TOP 1 RATE3 FROM MONEY_HISTORY WHERE MONEY = 'USD' AND VALIDATE_DATE <= #attributes.give_date# ORDER BY VALIDATE_DATE DESC
</cfquery>
<cfquery name="get_money_euro" datasource="#dsn#">
    SELECT TOP 1 RATE3 FROM MONEY_HISTORY WHERE MONEY = 'EUR' AND VALIDATE_DATE <= #attributes.give_date# ORDER BY VALIDATE_DATE DESC
</cfquery>
<cfset dolar_carpan = get_money_dolar.RATE3>
<cfset euro_carpan = get_money_euro.RATE3>

<cfif isdefined("attributes.con_id")>
	<cfquery name="get_zno" datasource="#dsn_Dev#">
    	SELECT * FROM POS_CONS WHERE CON_ID = #attributes.CON_ID#
    </cfquery>
    
    <cfquery name="get_ciro_report_cash_odemeler" datasource="#dsn_Dev#">
    	SELECT 
        	*,
            SATIS_TUTAR AS ODEME_TUTAR,
            (SELECT HEADER FROM SETUP_POS_PAYMETHODS SPP WHERE SPP.CODE = ODEME_TURU) AS BASLIK
        FROM 
        	POS_CONS_PAYMENTS 
        WHERE 
        	CON_ID = #attributes.CON_ID#
    </cfquery>
<cfelse>
    <cfquery name="get_ciro_report_cash_odemeler" datasource="#dsn_dev#" result="query_r">
        SELECT
            0 AS KASA_FAZLA_TUTAR,
            0 AS KASA_ACIK_TUTAR,
            SUM(IADE_TUTAR) AS IADE_TUTAR,
            SUM(ODEME_TUTAR) AS ODEME_TUTAR,
            SUM(ODEME_TUTAR_OTHER) AS ODEME_TUTAR_OTHER,
            SUM(ODEME_TUTAR) AS TESLIM_TUTAR,
            T1.ODEME_TURU,
            (SELECT HEADER FROM SETUP_POS_PAYMETHODS SPP WHERE SPP.CODE = T1.ODEME_TURU) AS BASLIK
        FROM
            (
            SELECT
                GAP2.ODEME_TURU,
                0 AS IADE_TUTAR,
                SUM(GAP2.ODEME_TUTAR) AS ODEME_TUTAR,
                SUM(GAP2.ODEME_TUTAR_OTHER) AS ODEME_TUTAR_OTHER
            FROM 
                #dsn_alias#.BRANCH B2,
                GENIUS_ACTIONS GA2,
                GENIUS_ACTIONS_PAYMENTS GAP2,
                #dsn3_alias#.POS_EQUIPMENT PE2
            WHERE 
                GA2.ACTION_ID = GAP2.ACTION_ID AND
                GA2.FIS_IPTAL = 0 AND
                GA2.BELGE_TURU <> '2' AND
                PE2.BRANCH_ID = B2.BRANCH_ID AND
                PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
                YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
                MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
                DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
                ZNO = '#attributes.z_number#' AND
                GA2.KASA_NUMARASI = #attributes.kasa_id#
            GROUP BY
                GAP2.ODEME_TURU
            UNION ALL
                SELECT
                    GAP2.ODEME_TURU,
                    SUM(GAP2.ODEME_TUTAR) AS IADE_TUTAR,
                    0 AS ODEME_TUTAR,
                    0 AS ODEME_TUTAR_OTHER
                FROM 
                    #dsn_alias#.BRANCH B2,
                    GENIUS_ACTIONS GA2,
                    GENIUS_ACTIONS_PAYMENTS GAP2,
                    #dsn3_alias#.POS_EQUIPMENT PE2
                WHERE 
                    GA2.ACTION_ID = GAP2.ACTION_ID AND
                    GA2.FIS_IPTAL = 0 AND
                    GA2.BELGE_TURU = '2' AND
                    PE2.BRANCH_ID = B2.BRANCH_ID AND
                    PE2.EQUIPMENT_CODE = GA2.KASA_NUMARASI AND
                    YEAR(GA2.FIS_TARIHI) = #year(attributes.give_date)# AND
                    MONTH(GA2.FIS_TARIHI) = #month(attributes.give_date)# AND
                    DAY(GA2.FIS_TARIHI) = #day(attributes.give_date)# AND
                    ZNO = '#attributes.z_number#' AND
                    GA2.KASA_NUMARASI = #attributes.kasa_id#
                GROUP BY
                    GAP2.ODEME_TURU
            ) T1
        GROUP BY
            T1.ODEME_TURU
        ORDER BY
            T1.ODEME_TURU
    </cfquery>
</cfif>

<cfquery name="get_paymethods" datasource="#dsn_Dev#">
	SELECT SPP.HEADER,SPP.CODE FROM SETUP_POS_PAYMETHODS SPP ORDER BY SPP.CODE
</cfquery>


<br />
<table class="ajax_list" style="width:200px; float:left; margin-left:5px;" id="basket_list">
	<thead>
    	<tr>
        	<th nowrap><a href="javascript://" onclick="get_extra_rows();"><img src="/images/plus_list.gif" border="0" align="absmiddle"/></a> Ödeme Tipi</th>
            <th nowrap style="text-align:right;">Satış Tutarı</th>
            <th nowrap style="text-align:right;">Teslim Tutarı</th>
            <th nowrap style="text-align:right;">İade Tutarı</th>
            <th nowrap style="text-align:right;">Kasa Açık Tutar</th>
            <th nowrap style="text-align:right;">Kasa Fazla Tutar</th>
            <th nowrap style="text-align:right;">Kur Tutar (USD)</th>
            <th nowrap style="text-align:right;">Kur Tutar (EUR)</th>
        </tr>
    </thead>
    <tbody>
    	<cfoutput query="get_ciro_report_cash_odemeler">
        	<tr>
            	<td nowrap>
                	<input type="hidden" name="odeme_turu_#currentrow#" id="odeme_turu_#currentrow#" value="#ODEME_TURU#" readonly="readonly"/>
                	#BASLIK#
                </td>
                <td style="text-align:right;"><input type="text" name="satis_tutar_#currentrow#" id="satis_tutar_#currentrow#" class="moneybox" value="#tlformat(ODEME_TUTAR)#" readonly="readonly" style="width:75px;"/></td>
                <td style="text-align:right;">
                <cfif not isdefined("attributes.con_id") and ODEME_TURU is '0'>
                <input type="text" name="teslim_tutar_#currentrow#" id="teslim_tutar_#currentrow#" class="moneybox" value="#tlformat(0)#" style="width:75px;" onkeyup="return(formatcurrency(this,event,2));" onblur="hesapla_odeme('#currentrow#');"/>
            	<cfelse>
                <input type="text" name="teslim_tutar_#currentrow#" id="teslim_tutar_#currentrow#" class="moneybox" value="#tlformat(teslim_tutar)#" style="width:75px;" onkeyup="return(formatcurrency(this,event,2));" onblur="hesapla_odeme('#currentrow#');"/>
                </cfif>
                </td>
                <td style="text-align:right;"><input type="text" name="iade_tutar_#currentrow#" id="iade_tutar_#currentrow#" class="moneybox" value="#tlformat(IADE_TUTAR)#" readonly="readonly" style="width:75px;"/></td>
                <td style="text-align:right;"><input type="text" name="kasa_acik_tutar_#currentrow#" id="kasa_acik_tutar_#currentrow#" class="moneybox" value="#tlformat(kasa_acik_tutar)#" readonly="readonly" style="width:75px;"/></td>
                <td style="text-align:right;"><input type="text" name="kasa_fazla_tutar_#currentrow#" id="kasa_fazla_tutar_#currentrow#" class="moneybox" value="#tlformat(kasa_fazla_tutar)#" readonly="readonly" style="width:75px;"/></td>
                <cfif isdefined("attributes.con_id")>
                <td style="text-align:right;"><input type="text" name="kur_tutar_usd_#currentrow#" id="kur_tutar_usd_#currentrow#" class="moneybox" value="#tlformat(DOLAR_TUTAR)#" readonly="readonly" style="width:75px;"/></td>
                <td style="text-align:right;"><input type="text" name="kur_tutar_euro_#currentrow#" id="kur_tutar_euro_#currentrow#" class="moneybox" value="#tlformat(EURO_TUTAR)#" readonly="readonly" style="width:75px;"/></td>
            	<cfelse>
                <td style="text-align:right;">
                	<cfif odeme_tutar_other neq 0 and odeme_tutar neq odeme_tutar_other and odeme_turu is '5'>
                    	<cfset dolar_tutar = odeme_tutar_other>
                    <cfelse>
                    	<cfset dolar_tutar = ODEME_TUTAR / dolar_carpan>
                    </cfif>
                    <input type="text" name="kur_tutar_usd_#currentrow#" id="kur_tutar_usd_#currentrow#" class="moneybox" value="#tlformat(dolar_tutar)#" readonly="readonly" style="width:75px;"/>
                </td>
                <td style="text-align:right;">
                	<cfif odeme_tutar_other neq 0 and odeme_tutar neq odeme_tutar_other and odeme_turu is '6'>
                    	<cfset euro_tutar = odeme_tutar_other>
                    <cfelse>
                    	<cfset euro_tutar = ODEME_TUTAR / euro_carpan>
                    </cfif>
                	<input type="text" name="kur_tutar_euro_#currentrow#" id="kur_tutar_euro_#currentrow#" class="moneybox" value="#tlformat(euro_tutar)#" readonly="readonly" style="width:75px;"/></td>
                </cfif>
            </tr>
        </cfoutput>
        <cfloop from="1" to="5" index="ddd">
        	<cfset currentrow_ = get_ciro_report_cash_odemeler.recordcount + ddd>
        	<cfoutput>
            	<tr id="extra_#ddd#" style="display:none;">
                    <td nowrap>
                        <select name="odeme_turu_#currentrow_#" id="odeme_turu_#currentrow_#">
                        	<cfloop query="get_paymethods">
                            	<option value="#CODE#">#HEADER#</option>
							</cfloop>
                        </select>
                    </td>
                    <td style="text-align:right;"><input type="text" name="satis_tutar_#currentrow_#" id="satis_tutar_#currentrow_#" class="moneybox" value="0" readonly="readonly" style="width:75px;"/></td>
                    <td style="text-align:right;"><input type="text" name="teslim_tutar_#currentrow_#" id="teslim_tutar_#currentrow_#" class="moneybox" value="0" style="width:75px;" onkeyup="return(formatcurrency(this,event,2));" onblur="hesapla_odeme('#currentrow_#');"/></td>
                    <td style="text-align:right;"><input type="text" name="iade_tutar_#currentrow_#" id="iade_tutar_#currentrow_#" class="moneybox" value="0" readonly="readonly" style="width:75px;"/></td>
                    <td style="text-align:right;"><input type="text" name="kasa_acik_tutar_#currentrow_#" id="kasa_acik_tutar_#currentrow_#" class="moneybox" value="#tlformat(0)#" readonly="readonly" style="width:75px;"/></td>
                    <td style="text-align:right;"><input type="text" name="kasa_fazla_tutar_#currentrow_#" id="kasa_fazla_tutar_#currentrow_#" class="moneybox" value="#tlformat(0)#" readonly="readonly" style="width:75px;"/></td>
                    <td style="text-align:right;"><input type="text" name="kur_tutar_usd_#currentrow_#" id="kur_tutar_usd_#currentrow_#" class="moneybox" value="0" readonly="readonly" style="width:75px;"/></td>
                    <td style="text-align:right;"><input type="text" name="kur_tutar_euro_#currentrow_#" id="kur_tutar_euro_#currentrow_#" class="moneybox" value="0" readonly="readonly" style="width:75px;"/></td>
                </tr>
            </cfoutput>
        </cfloop>
        <tr>
        	<td colspan="8">
            <cfif isdefined("attributes.con_id")>
            	<cfquery name="get_z_id" datasource="#dsn_Dev#">
                	SELECT * FROM POS_CONS_ACTIONS WHERE ACTION_TYPE = 69 AND CON_ID = #attributes.con_id#
                </cfquery>
                
				<cfset is_upd_ = 1>
				<cfif get_z_id.recordcount and get_z_id.period_id neq session.ep.period_id>
                	<font color="red">Muhasebe Döneminiz Uygun Değil!</font>
                    <cfset is_upd_ = 0>
                </cfif>
                <cfif get_z_id.recordcount>
                	<cfquery name="GET_BANK_ACTION_INFO" datasource="#DSN2#">
                        SELECT
                            INVOICE.INVOICE_ID
                        FROM
                            INVOICE,
                            INVOICE_CASH_POS,
                            #dsn3_alias#.CREDIT_CARD_BANK_PAYMENTS_ROWS CC
                        WHERE
                            INVOICE.INVOICE_ID = INVOICE_CASH_POS.INVOICE_ID AND
                            INVOICE_CASH_POS.POS_ACTION_ID = CC.CREDITCARD_PAYMENT_ID AND
                            CC.BANK_ACTION_ID IS NOT NULL AND
                            INVOICE.INVOICE_ID = #get_z_id.ACTION_ID#
                    </cfquery>
                    <cfif GET_BANK_ACTION_INFO.recordcount>
                    	<font color="red">Kredi Kartı Tahsilatlarınızın Hesaba Geçişlerini Yaptığınız İçin Hesaba Geçiş İşlemlerinizi Geri Almadan İşlemi Güncelleyemezsiniz !</font>
                    	<cfset is_upd_ = 0>
                    </cfif>
                </cfif>
                <cfif is_upd_ eq 1>
            		<cf_workcube_buttons add_function="kontrol()" is_upd='1' del_function_for_submit="del_kontrol()" delete_page_url="#request.self#?fuseaction=retail.emptypopup_del_genius_give&con_id=#attributes.con_id#">
            	</cfif>
            <cfelse>
            	<cf_workcube_buttons add_function="kontrol()">
            </cfif>
            </td>
        </tr>
    </tbody>
</table>
<input type="hidden" name="odeme_satir" id="odeme_satir" value="<cfoutput>#get_ciro_report_cash_odemeler.recordcount+5#</cfoutput>" readonly="readonly"/>
<input type="hidden" name="dolar_carpan" id="dolar_carpan" value="<cfoutput>#dolar_carpan#</cfoutput>" readonly="readonly"/>
<input type="hidden" name="euro_carpan" id="euro_carpan" value="<cfoutput>#euro_carpan#</cfoutput>" readonly="readonly"/>
<script>
count_ = 0;
function get_extra_rows()
{
	count_ = count_ + 1;
	$('#extra_' + count_).show();
}

function hesapla_odeme(row_id)
{
	dolar_carpan = <cfoutput>#dolar_carpan#</cfoutput>;
	euro_carpan = <cfoutput>#euro_carpan#</cfoutput>;
	
	odeme_turu_ = document.getElementById('odeme_turu_' + row_id).value;
	
	satis_ = parseFloat(filterNum(document.getElementById('satis_tutar_' + row_id).value));
	deger_ = document.getElementById('teslim_tutar_' + row_id).value;
	deger_iade_ = parseFloat(filterNum(document.getElementById('iade_tutar_' + row_id).value));
	if(deger_ == '')
	{
		deger_ = 0;	
		document.getElementById('kur_tutar_usd_' + row_id).value = 0;
		document.getElementById('kur_tutar_euro_' + row_id).value = 0;
		deger_tl_ = 0;
	}
	else
	{
		if(odeme_turu_ == 6)
		{
			deger_ = parseFloat(filterNum(deger_));
			document.getElementById('kur_tutar_usd_' + row_id).value = commaSplit(wrk_round(deger_ * euro_carpan / dolar_carpan));
			document.getElementById('kur_tutar_euro_' + row_id).value = commaSplit(wrk_round(deger_));
			deger_tl_ = wrk_round(deger_ * euro_carpan);	
			
			document.getElementById('teslim_tutar_' + row_id).value = commaSplit(deger_tl_);
		}
		else if(odeme_turu_ == 5)
		{
			deger_ = parseFloat(filterNum(deger_));
			document.getElementById('kur_tutar_euro_' + row_id).value = commaSplit(wrk_round(deger_ * dolar_carpan / euro_carpan));
			document.getElementById('kur_tutar_usd_' + row_id).value = commaSplit(wrk_round(deger_));
			deger_tl_ = wrk_round(deger_ * dolar_carpan);	
			
			document.getElementById('teslim_tutar_' + row_id).value = commaSplit(deger_tl_);
		}
		else
		{
			deger_ = parseFloat(filterNum(deger_));
			document.getElementById('kur_tutar_usd_' + row_id).value = commaSplit(wrk_round(deger_ / dolar_carpan));
			document.getElementById('kur_tutar_euro_' + row_id).value = commaSplit(wrk_round(deger_ / euro_carpan));
			deger_tl_ = deger_;
		}
	}
	
	fark_ = satis_ - deger_tl_ - deger_iade_;
	
	if(fark_ > 0)
	{
		document.getElementById('kasa_acik_tutar_' + row_id).value = commaSplit(-1 * fark_);
		document.getElementById('kasa_fazla_tutar_' + row_id).value = 0;
	}
	else
	{
		document.getElementById('kasa_acik_tutar_' + row_id).value = 0;
		document.getElementById('kasa_fazla_tutar_' + row_id).value = commaSplit(-1 * fark_);	
	}
	
	hesapla_odeme_total();
}

function hesapla_odeme_total()
{
	teslim_tutar_ = 0;
	kasa_acik_tutar_ = 0;
	kasa_fazla_tutar_ = 0;
	iade_tutar_ = 0;
	
	rows_ = <cfoutput>#get_ciro_report_cash_odemeler.recordcount+5#</cfoutput>;
	for(var i=1; i<= rows_; i++)
	{
		deger_ = document.getElementById('teslim_tutar_' + i).value;
		if(deger_ != '')
		{
			deger_ = parseFloat(filterNum(deger_));
			teslim_tutar_ = teslim_tutar_ + deger_;
			
			acik_ = parseFloat(filterNum(document.getElementById('kasa_acik_tutar_' + i).value));
			kasa_acik_tutar_ = kasa_acik_tutar_ + acik_;
			
			fazla_ = parseFloat(filterNum(document.getElementById('kasa_fazla_tutar_' + i).value));
			kasa_fazla_tutar_ = kasa_fazla_tutar_ + fazla_;
			
			iade_ = parseFloat(filterNum(document.getElementById('iade_tutar_' + i).value));
			iade_tutar_ = iade_tutar_ + iade_;
		}
	}
	iade_deger_ = iade_tutar_;
	
	teslim_tutar_ = teslim_tutar_;
	
	document.getElementById('teslimat_toplam').value = commaSplit(teslim_tutar_);
	satis_toplam_ = parseFloat(filterNum(document.getElementById('satis_toplam').value));
	
	if(teslim_tutar_ > satis_toplam_)
	{
		document.getElementById('kasiyer_fazla_toplam').value = commaSplit(teslim_tutar_ - satis_toplam_);
		document.getElementById('kasiyer_acik_toplam').value = 0;
	}
	else
	{
		document.getElementById('kasiyer_acik_toplam').value = commaSplit(teslim_tutar_ - satis_toplam_);
		document.getElementById('kasiyer_fazla_toplam').value = 0;	
	}
}
</script>