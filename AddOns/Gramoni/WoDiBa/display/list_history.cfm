<!---
    File: list_history.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 09.08.2020
    Controller:
    Description:
		Banka web servis loglarının ve wodiba işlem kayıt loglarının listelendiği ekrandır.
--->
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions&event=history">
<cfif isDefined('attributes.result_type') and len(attributes.result_type)>
    <cfset adres = '#adres#&result_type=#attributes.result_type#'>
</cfif>
<cfif isDefined('attributes.bank_type') and len(attributes.bank_type)>
    <cfset adres = '#adres#&bank_type=#attributes.bank_type#'>
</cfif>
<cfif isDefined('attributes.date1') and len(attributes.date1)>
    <cfset adres = '#adres#&date1=#attributes.date1#'>
</cfif>
<cfif isDefined('attributes.date2') and len(attributes.date2)>
    <cfset adres = '#adres#&date2=#attributes.date2#'>
</cfif>
<cfparam name="attributes.is_submit" default="" />
<cfparam name="attributes.result_type" default="0" />
<cfparam name="attributes.bank_type" default="0" />
<cfparam name="attributes.date1" default="" />
<cfparam name="attributes.date2" default="" />
<cfparam name="attributes.page" default=1 />
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'/>
<cfparam name="attributes.startrow" default=1 />

<cf_get_lang_set module_name="bank">

<cfscript>
    if(Not isDefined('attributes.date1')){
        attributes.date1 = '';
    }
    else{
        attributes.date1 = dateFormat(attributes.date1,dateformat_style);
    }
    if(Not isDefined('attributes.date2')){
        attributes.date2 = '';
    }
    else{
        attributes.date2 = dateFormat(attributes.date2,dateformat_style);
    }
</cfscript>

<cfif isDefined("attributes.is_submit") And Len(attributes.is_submit)>
    <cfscript>
        include '../cfc/WebService.cfc';
        init(our_company_id: session.ep.company_id);
        IslemGecmisi = IslemGecmisi(
            baslangicTarihi: attributes.date1,
            bitisTarihi: attributes.date2,
            bankaKodu: attributes.bank_type,
            durum: attributes.result_type
        );
        attributes.totalrecords = arrayLen(IslemGecmisi);
    </cfscript>
<cfelse>
    <cfset attributes.totalrecords = 0 />
</cfif>

<cfquery name="get_bank_codes" datasource="#dsn#">
    SELECT BANK_CODE FROM SETUP_BANK_TYPES WHERE BANK_CODE IS NULL
</cfquery>

<cfif get_bank_codes.recordCount>
<script>
    alert('Banka kodu girilmemiş olan Banka tanımları mevcut, Lütfen kontrol ediniz!');
    history.back();
</script>
<cfabort>
</cfif>

<cfquery name="get_bank" datasource="#dsn#">
    SELECT BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>

<cfloop query="get_bank">
    <cfset bank_list[#BANK_CODE#] = BANK_NAME />
</cfloop>


<cfform action="#request.self#?fuseaction=bank.wodiba_bank_actions&event=history" method="post">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
    <cf_box>
		<cf_box_search>
            <div class="row">
				<div class="col col-12 form-inline">
                    <div class="form-group">
                    	<div class="input-group">
                        	<select name="result_type" id="result_type">
	                            <option value="0"><cf_get_lang dictionary_id='61103.İşlem Sonucu'></option>
                                <option value="10" <cfif attributes.result_type is 10>selected</cfif>><cf_get_lang dictionary_id='55387.Başarılı'></option>
                                <option value="1" <cfif attributes.result_type is 1>selected</cfif>><cf_get_lang dictionary_id='58197.Başarısız'></option>
	                        </select>
                        </div>
		            </div>
                    <div class="form-group">
                    	<div class="input-group">
                        	<select name="bank_type" id="bank_type">
	                            <option value="0"><cf_get_lang dictionary_id='57521.bank'></option>
                                <cfoutput query="get_bank">
                                    <option value="#BANK_CODE#"<cfif attributes.bank_type is BANK_CODE> selected</cfif>>#BANK_NAME#</option>
                                </cfoutput>
	                        </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerlerini Kontrol ediniz'></cfsavecontent>
                                <cfinput type="text" maxlength="10" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" maxlength="10" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" style="width:65px" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                    	<cf_wrk_search_button>
                    </div>
				</div>
			</div>
        </cf_box_search>
    </cf_box>
</cfform>
    <cfsavecontent variable="head_text">Wodiba <cf_get_lang dictionary_id='61102.İşlem Geçmişi'></cfsavecontent>
        <cf_box title="#head_text#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_hr_id', print_type : 173 }#">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th style="width:30px; text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
                        <th><cf_get_lang_main dictionary_id='57521.bank'></th>
                        <th><cf_get_lang_main dictionary_id='57756.Durum'></th>
                        <th><cf_get_lang_main dictionary_id='57543.Mesaj'></th>
                        <th nowrap="nowrap"><cf_get_lang_main dictionary_id='57879.İşlem Tarihi'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif attributes.totalrecords>
                        <cfloop from="1" to="#attributes.totalrecords#" index="i">
                            <cfoutput><tr>
                                <td style="text-align:center;">#i#</td>
                                <td>#bank_list[Int(IslemGecmisi[i].bankaKodu)]#</td>
                                <td><cfif IslemGecmisi[i].durum is 10><cf_get_lang dictionary_id='55387.Başarılı'><cfelse><cf_get_lang dictionary_id='58197.Başarısız'></cfif></td>
                                <td>#IslemGecmisi[i].mesaj#</td>
                                <td nowrap="nowrap">#dateformat(IslemGecmisi[i].tarih,dateformat_style)# #timeformat(IslemGecmisi[i].tarih,timeformat_style)#</td>
                            </tr></cfoutput>
                        </cfloop>
                    <cfelse>
                        <tr>
                            <td colspan="8"><cfif isdefined('attributes.is_submit')><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
                        </tr>
                    </cfif> 
                </tbody>
            </cf_grid_list>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
        </cf_box>
    