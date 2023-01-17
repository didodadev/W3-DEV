
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
<cfset id_list = "1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072">
<cfset id_name_list = "Ödeme Türü tanımlanmış,Tek Tuşla ödeme mümkün,Avans olarak verilebilir,Döviz,Sembol rakam önüne yazılacak,Para çekmecesi açılır,İade yapılabilir,Para çekmecesinin içeriğine dahil,Kredi kartı,Para üstü olarak verilebilir,Numara gerekli,Kredi Kartı Banknot Seri Numarası,Çek,Diğer,Taksit Sor,Kredi Kartı Numarası Loglama,Ödeme Detayı Sor,Taksit Tutarı Kontrol Et">

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=retail.emptypopup_add_pos_pay_method" method="post" name="add_">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-pay_selects">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='35702.Ödeme Seçenekleri'></label>
                    </div>
                    <cfloop from="1" to="#listlen(id_name_list)#" index="ccc">
                        <cfoutput>
                            <div class="form-group" id="item-pay_selects1">
                                <label class="col col-4 col-sm-12"></label>
                                <div class="col col-8 col-sm-12">
                                    <input type="checkbox" name="pay_selects" value="#listgetat(id_list,ccc)#"/> #listgetat(id_name_list,ccc)#
                                </div>
                            </div>
                        </cfoutput>
                    </cfloop>
                </div>
                <div class="col col-6 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-code">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58585.Kod'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="code" maxlength="50" required="yes" message="Kod Girmelisiniz!" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-description">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="header" maxlength="250" required="yes" message="Açıklama Girmelisiniz!" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-symbol">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='42242.Sembol'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="symbol" maxlength="5" required="yes" message="Sembol Girmelisiniz!" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-pay_limit">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61667.Ödeme Sınırı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="pay_limit" maxlength="50" required="yes" value="#tlformat(0,2)#" message="Ödeme Sınırı Girmelisiniz!" style="width:175px;" onkeyup="return(FormatCurrency(this,event,2));">
                        </div>
                    </div>
                    <div class="form-group" id="item-decimal_count">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61668.Ondalık'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="decimal_count" maxlength="50" validate="integer" readonly="yes" value="2" required="yes" message="Ondalık Girmelisiniz!" onkeyup="return(FormatCurrency(this,event,0));" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-daily_rate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61669.Günlük Kur'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="daily_rate" maxlength="50" required="yes" value="#tlformat(0,5)#" message="Günlük Kur Girmelisiniz!" onkeyup="return(FormatCurrency(this,event,5));" style="width:175px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-PROVISITION">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61670.Provizyon'></label>
                        <div class="col col-8 col-sm-12">
                            <cfselect name="PROVISITION" style="width:175px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1"><cf_get_lang dictionary_id='61671.Genius Puan'></option>
                            </cfselect>
                        </div>
                    </div>
                    <div class="form-group" id="item-wrk_pos_id">
                        <label class="col col-4 col-sm-12">WRK <cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="wrk_pos_id" id="wrk_pos_id" style="width:200px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_POS_DETAIL">
                                    <option value="#PAYMENT_TYPE_ID#">#ACCOUNT_NAME# / #CARD_NO#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
