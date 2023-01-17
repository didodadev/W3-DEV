<cfquery name="get_pay" datasource="#dsn_dev#">
	SELECT * FROM SETUP_POS_PAYMETHODS WHERE ROW_ID = #attributes.row_id#
</cfquery>
<cfquery name="get_pos_detail" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		ACCOUNTS.ACCOUNT_CURRENCY_ID,
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO,
		CPT.PAYMENT_RATE
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) AND
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
		CPT.IS_ACTIVE = 1 AND 
		ACCOUNTS.ACCOUNT_STATUS = 1
	ORDER BY
		CPT.CARD_NO
</cfquery>
<cfform action="#request.self#?fuseaction=retail.emptypopup_upd_pos_pay_method" method="post" name="add_">
<cf_popup_box title="Ödeme Tipi Güncelle">
<cfset id_list = "1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072">
<cfset id_name_list = "Ödeme Türü tanımlanmış,Tek Tuşla ödeme mümkün,Avans olarak verilebilir,Döviz,Sembol rakam önüne yazılacak,Para çekmecesi açılır,İade yapılabilir,Para çekmecesinin içeriğine dahil,Kredi kartı,Para üstü olarak verilebilir,Numara gerekli,Kredi Kartı Banknot Seri Numarası,Çek,Diğer,Taksit Sor,Kredi Kartı Numarası Loglama,Ödeme Detayı Sor,Taksit Tutarı Kontrol Et">
<cfinput type="hidden" value="#get_pay.row_id#" name="row_id">
	<table>
    	<tr>
        	<td valign="top">
                    <table>
                        <tr>
                            <td width="75">Kod</td>
                            <td><cfinput type="text" name="code" maxlength="50" required="yes" message="Kod Girmelisiniz!" value="#get_pay.code#" style="width:175px;"></td>
                        </tr>
                        <tr>
                            <td>Açıklama</td>
                            <td><cfinput type="text" name="header" maxlength="250" required="yes" message="Açıklama Girmelisiniz!" value="#get_pay.header#" style="width:175px;"></td>
                        </tr>
                        <tr>
                            <td>Sembol</td>
                            <td><cfinput type="text" name="symbol" maxlength="5" required="yes" message="Sembol Girmelisiniz!" value="#get_pay.symbol#" style="width:175px;"></td>
                        </tr>
                        <tr>
                            <td>Ödeme Sınırı</td>
                            <td><cfinput type="text" name="pay_limit" maxlength="50" required="yes" message="Ödeme Sınırı Girmelisiniz!" value="#get_pay.pay_limit#" style="width:175px;" onkeyup="return(FormatCurrency(this,event,2));"></td>
                        </tr>
                        <tr>
                            <td>Ondalık</td>
                            <td><cfinput type="text" name="decimal_count" maxlength="50" validate="integer" readonly="yes" required="yes" value="#get_pay.decimal_count#" message="Ondalık Girmelisiniz!" onkeyup="return(FormatCurrency(this,event,0));" style="width:175px;"></td>
                        </tr>
                        <tr>
                            <td>Günlük Kur</td>
                            <td><cfinput type="text" name="daily_rate" maxlength="50" required="yes" value="#get_pay.daily_rate#" message="Günlük Kur Girmelisiniz!" onkeyup="return(FormatCurrency(this,event,5));" style="width:175px;"></td>
                        </tr>
                        <tr>
                            <td>Provizyon</td>
                            <td>
                            	<cfselect name="PROVISITION" style="width:175px;">
                                	<option value="">Seçiniz</option>
                                    <option value="1" <cfif get_pay.PROVISITION eq 1>selected</cfif>>Genius Puan</option>
                                </cfselect>
                            </td>
                        </tr>
                        <tr>
                        	<td>WRK Ödeme Tipi</td>
                            <td>
                            	<select name="wrk_pos_id" id="wrk_pos_id" style="width:200px;">
                                    <option value="">Seçiniz</option>
									<cfoutput query="GET_POS_DETAIL">
                                        <option value="#PAYMENT_TYPE_ID#" <cfif get_pay.WRK_POS_ID eq PAYMENT_TYPE_ID>selected</cfif>>#ACCOUNT_NAME# / #CARD_NO#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                    </table>
            </td>
            <td valign="top">
            	<table>
                <tr>
                	<td colspan="2" class="formbold">Ödeme Seçenekleri</td>
                </tr>
                <cfloop from="1" to="#listlen(id_name_list)#" index="ccc">
                <cfoutput>
                	<tr>
                    	<td>
                        	<input type="checkbox" name="pay_selects" value="#listgetat(id_list,ccc)#" <cfif listfind(get_pay.pay_selects,listgetat(id_list,ccc))>checked</cfif>/> #listgetat(id_name_list,ccc)#
                        </td>
                    </tr>
                </cfoutput>
                </cfloop>
                </table>
            </td>
        </tr>    
    </table>
    <cf_popup_box_footer>
    	<cf_record_info query_name="get_pay">
    	<cf_workcube_buttons is_upd="1" is_delete="1" delete_page_url="#request.self#?fuseaction=retail.emptypopup_del_pos_pay_method&row_id=#attributes.row_id#">
    </cf_popup_box_footer>
</cf_popup_box>
</cfform>