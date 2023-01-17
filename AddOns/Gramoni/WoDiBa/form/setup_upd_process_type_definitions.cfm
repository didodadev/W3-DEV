<cfif isdefined("attributes.is_submit")>
    <cfquery datasource="#dsn#">
        UPDATE
            WODIBA_BANK_TRANSACTION_TYPES
        SET
            TRANSACTION_CODE    = <cfif len(attributes.selectTCode1)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value = "#attributes.selectTCode1#"><cfelse>NULL</cfif>,
            TRANSACTION_CODE2   = <cfif len(attributes.selectTCode2)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.selectTCode2#"><cfelse>NULL</cfif>,
            PROCESS_TYPE        = <cfif len(attributes.selectPType)><cfqueryparam CFSQLType="CF_SQL_INTEGER" value =#attributes.selectPType#><cfelse>NULL</cfif>,
            DESCRIPTION_1       = <cfif len(attributes.inputd1)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.inputd1#"><cfelse>NULL</cfif>,
            DESCRIPTION_2       = <cfif len(attributes.inputd2)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.inputd2#"><cfelse>NULL</cfif>,
            IN_OUT              = <cfif len(attributes.selectIO)><cfqueryparam CFSQLType="CF_SQL_NVARCHAR" value ="#attributes.selectIO#"><cfelse>NULL</cfif>,
            UPD_USER            = #session.ep.userid#,
            UPD_DATE            = #Now()#,
            UPD_IP              = '#CGI.REMOTE_ADDR#'
        WHERE
            TRANSACTION_UID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#" />
    </cfquery>
    <cfscript>
        location("#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions","false");
    </cfscript>
</cfif>

<cfquery name="get_wbtt" datasource="#dsn#">
    Select * from WODIBA_BANK_TRANSACTION_TYPES where TRANSACTION_UID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#" />
</cfquery>

<cfif get_wbtt.recordCount>
    <cfquery name="get_bank" datasource="#dsn#">
        SELECT BANK_NAME FROM SETUP_BANK_TYPES WHERE BANK_CODE = #get_wbtt.BANK_CODE#
    </cfquery>
    <cfset bank_name    = get_bank.BANK_NAME />
<cfelse>
    <cfset bank_name    = '' />
</cfif>

<cfset module_name = 'main' />

<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='48844.WoDiBa Banka İşlem Tipi Tanımları'><cfoutput>#bank_name# #get_wbtt.TRANSACTION_CODE#</cfoutput></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />


<cf_box title="#getLang('main','',48844,'WoDiBa Banka İşlem Tipi Tanımları')#: #bank_name# - #get_wbtt.TRANSACTION_CODE#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform action="#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions&event=upd&id=#attributes.id#" method="post">
<input type="hidden" name="is_submit" id="is_submit" value="1" />
<div class="row">
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="form-group">
                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='48886'></label>
                    <input type="text" name="selectTCode1" id="selectTCode1" style="width:250px;" value="<cfoutput>#get_wbtt.TRANSACTION_CODE#</cfoutput>" />
                </div>
                <div class="form-group">
                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='48886'>2</label>
                    <input type="text" name="selectTCode2" id="selectTCode2" style="width:250px;" value="<cfoutput>#get_wbtt.TRANSACTION_CODE2#</cfoutput>" />
                </div>
                <div class="form-group">
                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='57800'></label>
                    <select name="selectPType" id="selectPType">
                        <option value=""><cf_get_lang dictionary_id='57692.İşlem'></option>
                        <option value="1044" <cfif get_wbtt.process_type is 1044>selected</cfif>>Çek İşlemi Ödeme Bankadan (1044)</option>
                        <option value="1043" <cfif get_wbtt.process_type is 1043>selected</cfif>>Çek İşlemi Tahsil Bankaya (1043)</option>
                        <option value="2501" <cfif get_wbtt.process_type is 2501>selected</cfif>>Çek/Senet Banka Ödeme (2501)</option>
                        <option value="23" <cfif get_wbtt.process_type is 23>selected</cfif>><cf_get_lang_main no='2401.Döviz Alış Satış Virman İşlemi'> (23)</option>
                        <option value="24" <cfif get_wbtt.process_type is 24>selected</cfif>>Gelen Havale (24)</option>
                        <option value="121" <cfif get_wbtt.process_type is 121>selected</cfif>>Gelir Fişi (121)</option>
                        <option value="25" <cfif get_wbtt.process_type is 25>selected</cfif>>Giden Havale (25)</option>
                        <option value="120" <cfif get_wbtt.process_type is 120>selected</cfif>>Harcama Fişi (120)</option>
                        <option value="22" <cfif get_wbtt.process_type is 22>selected</cfif>>İşlem (Para Çekme) (22)</option>
                        <option value="21" <cfif get_wbtt.process_type is 21>selected</cfif>>İşlem (Para Yatırma) (21)</option>
                        <option value="244" <cfif get_wbtt.process_type is 244>selected</cfif>>Kredi Kartı Borcu Ödeme (244)</option>
                        <option value="248" <cfif get_wbtt.process_type is 248>selected</cfif>>Kredi Kartı Borcu Ödeme İptal (248)</option>
                        <option value="243" <cfif get_wbtt.process_type is 243>selected</cfif>>Kredi Kartı Hesaba Geçiş (243)</option>
                        <option value="247" <cfif get_wbtt.process_type is 247>selected</cfif>>Kredi Kartı Hesaba Geçiş İptal (247)</option>
                        <option value="291" <cfif get_wbtt.process_type is 291>selected</cfif>>Kredi Ödemesi (291)</option>
                        <option value="292" <cfif get_wbtt.process_type is 292>selected</cfif>>Kredi Tahsilatı (292)</option>
                        <option value="1051" <cfif get_wbtt.process_type is 1051>selected</cfif>>Senet İşlemi Ödeme Bankadan (1051)</option>
                        <option value="1053" <cfif get_wbtt.process_type is 1053>selected</cfif>>Senet İşlemi Tahsil Bankaya (1053)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='54291'></label>
                    <input type="text" name="inputd1" id="inputd1" style="width:250px;" value="<cfoutput>#get_wbtt.DESCRIPTION_1#</cfoutput>" />
                </div>
                <div class="form-group">
                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang dictionary_id='54291'> 2</label>
                    <input type="text" name="inputd2" id="inputd2" style="width:250px;" value="<cfoutput>#get_wbtt.DESCRIPTION_2#</cfoutput>" />
                </div>
                <div class="form-group">
                    <label class="col col-12 col-md-12 col-xs-12"><cf_get_lang_main no='142.Giriş'>/ <cf_get_lang_main no='19.Çıkış'></label>
                    <select name="selectIO" id="selectIO">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <option value="IN"<cfif get_wbtt.IN_OUT Eq 'IN'> selected</cfif>><cf_get_lang_main no='142.Giriş'></option>
                        <option value="OUT"<cfif get_wbtt.IN_OUT Eq 'OUT'> selected</cfif>><cf_get_lang_main no='19.Çıkış'></option>
                    </select>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <input type="submit" value="<cf_get_lang_main no='52.Güncelle'>" />
                </div>
             </div>
        </div>
    </div>
</div>
</cfform>
</cf_box>
<cfif isdefined("attributes.is_submit")>
<script>alert('<cf_get_lang_main no='1927.Güncellendi'>');</script>
</cfif>

<script type="text/javascript">
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>