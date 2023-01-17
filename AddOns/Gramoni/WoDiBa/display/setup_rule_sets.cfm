<!---
    File: setup_rule_sets.cfm
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 29.07.2018
    Controller: WodibaSetupRuleSetsController.cfm
    Description:
		
--->
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions&event=history">
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
    <cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_submit" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1 />
<cfparam name="attributes.startrow" default=1 />
<cfquery name="WODIBA_RULE_SETS" datasource="#dsn#">
    SELECT * FROM WODIBA_RULE_SETS WHERE COMPANY_ID = #session.ep.COMPANY_ID#  
</cfquery>
<cfif isDefined("attributes.is_submit") And Len(attributes.is_submit)>
    <cfset attributes.totalrecords = WODIBA_RULE_SETS.recordCount />
<cfelse>
    <cfset attributes.totalrecords = 0 />
</cfif>
<cfset process_type_name = '' />

<cfform action="#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions" method="post" name="filter_status">
    <input type="hidden" name="is_submit" id="is_submit" value="1">
    <cf_box>
		<cf_box_search>
            <div class="row">
				<div class="col col-12 form-inline">
                    <div class="form-group">
                    	<div class="input-group">
                        	<cfinput type="text" name="keyword" id="keyword" style="width:80px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
                        </div>
		            </div>
                    <div class="form-group">
                    	<div class="input-group x-3_5">
                        	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        	<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
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
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='44024'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1" woc_setting = "#{ checkbox_name : 'print_hr_id', print_type : 173 }#">
		<cf_grid_list>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>İşlem Kategorisi</th>
                    <th>İşlem Tipi</th>
                    <th><cf_get_lang dictionary_id='49901.Kayıt Başlangıç Tarihi'></th>
                    <th style="width:10px;"></th> 
                </tr>
            </thead>
            <tbody>
                    <cfoutput query="WODIBA_RULE_SETS">
                        <tr>
                          <td>#PROCESS_TYPE#</td>  
                          <td>
                                <cfif PROCESS_TYPE eq 21>
                                    <cfset process_type_name = 'İşlem (Para Yatırma)' />
                                <cfelseif PROCESS_TYPE eq 22>
                                    <cfset process_type_name = 'İşlem (Para Çekme)' />
                                <cfelseif PROCESS_TYPE eq 23>
                                    <cfset process_type_name = 'Döviz Alış Satış Virman İşlemi' />
                                <cfelseif PROCESS_TYPE eq 24>
                                    <cfset process_type_name = 'Gelen Havale' />
                                <cfelseif PROCESS_TYPE eq 25>
                                    <cfset process_type_name = 'Giden Havale' />
                                <cfelseif PROCESS_TYPE eq 120>
                                    <cfset process_type_name = 'Harcama Fişi' />
                                <cfelseif PROCESS_TYPE eq 121>
                                    <cfset process_type_name = 'Gelir Fişi' />
                                <cfelseif PROCESS_TYPE eq 243>
                                    <cfset process_type_name = 'Kredi Kartı Hesaba Geçiş' />
                                <cfelseif PROCESS_TYPE eq 244>
                                    <cfset process_type_name = 'Kredi Kartı Borcu Ödeme' />
                                <cfelseif PROCESS_TYPE eq 247>
                                    <cfset process_type_name = 'Kredi Kartı Hesaba Geçiş İptal' />
                                <cfelseif PROCESS_TYPE eq 248>
                                    <cfset process_type_name = 'Kredi Kartı Borcu Ödeme İptal' />
                                <cfelseif PROCESS_TYPE eq 291>
                                    <cfset process_type_name = 'Kredi Ödemesi' />
                                <cfelseif PROCESS_TYPE eq 292>
                                    <cfset process_type_name = 'Kredi Tahsilatı' />
                                <cfelseif PROCESS_TYPE eq 1043>
                                    <cfset process_type_name = 'Çek İşlemi Tahsil Bankaya' />
                                <cfelseif PROCESS_TYPE eq 1044>
                                    <cfset process_type_name = 'Çek İşlemi Ödeme Bankadan' />
                                <cfelseif PROCESS_TYPE eq 1051>
                                    <cfset process_type_name = 'Senet İşlemi Ödeme Bankadan' />
                                <cfelseif PROCESS_TYPE eq 1053>
                                    <cfset process_type_name = 'Senet İşlemi Tahsil Bankaya' />
                                <cfelseif PROCESS_TYPE eq 2501>
                                    <cfset process_type_name = 'Çek/Senet Banka Ödeme' />
                                </cfif>
                                <a class="tableyazi" href="#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=upd&id=#RULE_ID#">#process_type_name#</a>
                          </td>
                          <cfset Process_Cat_Name="" />
                            <cfif len(PROCESS_CAT_ID)>
                                <cfquery name="FOR_PROCESS_CAT_ID" datasource="#dsn3#">
                                    SELECT PROCESS_CAT from SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID=#PROCESS_CAT_ID#
                                </cfquery>
                            <cfset Process_Cat_Name=FOR_PROCESS_CAT_ID.PROCESS_CAT>
                            </cfif>
                            <cfif len(PROCESS_CAT_ID)>
                                <td>#Process_Cat_Name# (#PROCESS_CAT_ID#)</td>
                            <cfelse><td>#Process_Cat_Name#</td>
                            </cfif>
                          <td>#DateFormat(WODIBA_RULE_SETS.PROCESS_START_DATE,"dd/mm/yyyy")#</td>
                          <td><a href="#request.self#?fuseaction=settings.wodiba_bank_rule_set_definitions&event=upd&id=#RULE_ID#"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                        </tr>
                    </cfoutput>
            </tbody>
        </cf_grid_list>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
 