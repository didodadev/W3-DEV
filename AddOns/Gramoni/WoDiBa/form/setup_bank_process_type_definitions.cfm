<!---
    File: setup_bank_process_type_definitions.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 22.02.2019
    Controller: WodibaSetupRuleSetsController.cfm
    Description:
		Banka işlem tipleri ve Workcube işlem tiplerinin eşleme bakımının yapıldığı ekran.
--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.bank_type" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.in_out" default="0" />

<cf_get_lang_set module_name="bank">

<cfset attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1>
    <cfif isDefined("attributes.form_submitted")>
        <cfquery name="transaction_detail" datasource="#dsn#">
            SELECT
                WBTT.TRANSACTION_UID,
                WBTT.TRANSACTION_CODE,
                WBTT.TRANSACTION_CODE2,
                WBTT.DESCRIPTION_1,
                WBTT.BANK_CODE,
                WBTT.PROCESS_TYPE,
                SBT.BANK_CODE,
                SBT.BANK_NAME,
                WBTT.IN_OUT
            FROM
                WODIBA_BANK_TRANSACTION_TYPES WBTT 
                INNER JOIN SETUP_BANK_TYPES SBT 
                    ON WBTT.BANK_CODE = SBT.BANK_CODE
                    WHERE 
                        1 = 1
                    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                        AND (WBTT.TRANSACTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR WBTT.TRANSACTION_CODE2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR WBTT.DESCRIPTION_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
                    </cfif>
                    <cfif isdefined("attributes.process_type") and len(attributes.process_type)>
                        AND WBTT.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_type#"></cfif>
                    <cfif isdefined("attributes.bank_type") and len(attributes.bank_type)>
                        AND SBT.BANK_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_type#">
                    </cfif>
                    <cfif attributes.in_out Neq 0>
                        <cfif attributes.in_out Eq 1>
                        AND WBTT.IN_OUT = N'IN'
                        <cfelseif attributes.in_out Eq 2>
                        AND WBTT.IN_OUT = N'OUT'
                    </cfif>
        </cfif>
        </cfquery>
        <cfif transaction_detail.recordcount>
            <cfset attributes.totalrecords = transaction_detail.recordcount>
        <cfelse>
            <cfset attributes.totalrecords = 0>
        </cfif>
        <cfinclude template="../cfc/Functions.cfc" />
    </cfif>
<cfscript>
    url_str = "";
	if (isdefined('attributes.form_submitted') and len(attributes.form_submitted))
		url_str = "#url_str#&form_submitted=#attributes.form_submitted#";
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (len(attributes.process_type))
		url_str = "#url_str#&process_type=#attributes.process_type#";
    if (len(attributes.process_type))
		url_str = "#url_str#&bank_type=#attributes.bank_type#";
    if (len(attributes.in_out))
		url_str = "#url_str#&in_out=#attributes.in_out#";
</cfscript>
<div class="col col-12 col-xs-12">
<cfquery name="get_bank" datasource="#dsn#">
    SELECT BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>

<cfsavecontent variable="head_text"><cf_get_lang dictionary_id='48844.WoDiBa Banka İşlem Tipi Tanımları'></cfsavecontent>
<cfparam name="attributes.totalrecords" default="#transaction_detail.recordcount#">

</div>
    <cf_box>
        <cfform action="#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions" method="post"> 
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="row">      
                    <div class="col col-12 form-inline">                  
                        <cf_box_search>
                        <div class="form-group">
                            <div class="input-group">
                                <cfinput type="text" name="keyword" id="keyword" style="width:80px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#" onclick="select();">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <select name="process_type" id="process_type">
                                    <option value=""><cf_get_lang dictionary_id='57692.İşlem'></option>
                                    <option value="1044" <cfif attributes.process_type is 1044>selected</cfif>>Çek İşlemi Ödeme Bankadan (1044)</option>
                                    <option value="1043" <cfif attributes.process_type is 1043>selected</cfif>>Çek İşlemi Tahsil Bankaya (1043)</option>
                                    <option value="2501" <cfif attributes.process_type is 2501>selected</cfif>>Çek/Senet Banka Ödeme (2501)</option>
                                    <option value="23" <cfif attributes.process_type is 23>selected</cfif>><cf_get_lang_main no='2401.Döviz Alış Satış Virman İşlemi'> (23)</option>
                                    <option value="24" <cfif attributes.process_type is 24>selected</cfif>>Gelen Havale (24)</option>
                                    <option value="121" <cfif attributes.process_type is 121>selected</cfif>>Gelir Fişi (121)</option>
                                    <option value="25" <cfif attributes.process_type is 25>selected</cfif>>Giden Havale (25)</option>
                                    <option value="120" <cfif attributes.process_type is 120>selected</cfif>>Harcama Fişi (120)</option>
                                    <option value="22" <cfif attributes.process_type is 22>selected</cfif>>İşlem (Para Çekme) (22)</option>
                                    <option value="21" <cfif attributes.process_type is 21>selected</cfif>>İşlem (Para Yatırma) (21)</option>
                                    <option value="244" <cfif attributes.process_type is 244>selected</cfif>>Kredi Kartı Borcu Ödeme (244)</option>
                                    <option value="248" <cfif attributes.process_type is 248>selected</cfif>>Kredi Kartı Borcu Ödeme İptal (248)</option>
                                    <option value="243" <cfif attributes.process_type is 243>selected</cfif>>Kredi Kartı Hesaba Geçiş (243)</option>
                                    <option value="247" <cfif attributes.process_type is 247>selected</cfif>>Kredi Kartı Hesaba Geçiş İptal (247)</option>
                                    <option value="291" <cfif attributes.process_type is 291>selected</cfif>>Kredi Ödemesi (291)</option>
                                    <option value="292" <cfif attributes.process_type is 292>selected</cfif>>Kredi Tahsilatı (292)</option>
                                    <option value="1051" <cfif attributes.process_type is 1051>selected</cfif>>Senet İşlemi Ödeme Bankadan (1051)</option>
                                    <option value="1053" <cfif attributes.process_type is 1053>selected</cfif>>Senet İşlemi Tahsil Bankaya (1053)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-group">
                                <select name="bank_type" id="bank_type">
                                    <option value=""><cf_get_lang dictionary_id='57521.bank'></option>
                                    <cfoutput query="get_bank">
                                        <option value="#BANK_CODE#" <cfif attributes.bank_type is #BANK_CODE#>selected</cfif>>#BANK_NAME#</option>
                                 </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <select name="in_out" id="in_out">
                                    <option value="0"><cf_get_lang_main no='142.Giriş'>/<cf_get_lang_main no='19.Çıkış'></option>
                                    <option value="1"<cfif isDefined("attributes.in_out") and (attributes.in_out eq 1)> selected</cfif>><cf_get_lang_main no='142.Giriş'></option>
                                    <option value="2"<cfif isDefined("attributes.in_out") and (attributes.in_out eq 2)> selected</cfif>><cf_get_lang_main no='19.Çıkış'></option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-group x-3_5">
                                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                        </div>
                    </cf_box_search>
                
                    </div>
                
                </div>
        </cfform>
    </cf_box>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='48844.WoDiBa Bank Process Type Definitions'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_hr_id', print_type : 173 }#">
    <cf_grid_list>
    <thead>
        <tr>
            <th style="width:30px; text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
            <th style="width:30px; text-align:center;">ID</th>
            <th><cf_get_lang no='225.İşlem Kodu'></th>
            <th><cf_get_lang no='225.İşlem Kodu'> 2</th>
            <th><cf_get_lang_main no='280.İşlem'></th>
            <th><cf_get_lang_main no='388.İşlem Tipi'></th>
            <th width="75"><cf_get_lang_main dictionary_id='57521.bank'></th>
            <th><cf_get_lang_main no='142.Giriş'>/<cf_get_lang_main no='19.Çıkış'></th>
            <!-- sil -->
            <th width="20" class="header_icn_none"><a href="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.wodiba_bank_process_type_definitions&event=add','','ui-draggable-box-medium')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            <!-- sil -->
        </tr>
    </thead>
    <tbody>
        <cfif transaction_detail.recordcount>
            <cfoutput query="transaction_detail" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td style="text-align:center;">#currentrow#</td>
                    <td style="text-align:center;">#TRANSACTION_UID#</td>
                    <td><a href="javascript:openBoxDraggable('#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions&event=upd&id=#TRANSACTION_UID#','','ui-draggable-box-medium')" class="tableyazi">#TRANSACTION_CODE#</a></td>
                    <td><a href="javascript:windowopen('#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions&event=upd&id=#TRANSACTION_UID#','list','popup_wodiba_process_type_definition')" class="tableyazi">#TRANSACTION_CODE2#</a></td>
                    <td>#DESCRIPTION_1#</td>
                    <cfset get_process_type = GetProcessType(BankCode=BANK_CODE, TransactionCode=TRANSACTION_CODE, InOut=IN_OUT) />
                    <td>#get_process_type.PROCESS_CAT#</td>
                    <td>#BANK_NAME#</td>
                    <td><cfif IN_OUT Eq 'IN'><cf_get_lang_main no='142.Giriş'><cfelseif  IN_OUT Eq 'OUT'><cf_get_lang_main no='19.Çıkış'></cfif></td>
					<!-- sil -->
					<td width="15"><a href="javascript:openBoxDraggable('#request.self#?fuseaction=settings.wodiba_bank_process_type_definitions&event=upd&id=#TRANSACTION_UID#','','ui-draggable-box-medium')" class="tableyazi"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="8"><cfif isdefined('attributes.form_submitted')><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
			</tr>
		</cfif> 
	</tbody>
</cf_grid_list>
<cf_paging page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="settings.wodiba_bank_process_type_definitions#url_str#">
</cf_box>

<script type="text/javascript" language="javascript">
    $('#keyword').select();
</script>