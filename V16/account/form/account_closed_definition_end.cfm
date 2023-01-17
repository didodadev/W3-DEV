<cfset url_str = ''>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
</cfif> 
<cfinclude template="../query/account_closed_definition_end.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="search_list" method="post" action="#request.self#?fuseaction=account.account_closed_definition_end">
            <cf_box>
                <cf_box_search more="0">
                    <div class="form-group">
                        <label class="col col-3 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
                        <div class="input-group">
                            <input type="text" name="start_date" maxlength="10" id="start_date" style="width:65px;" value="<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-2 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
                        <div class="input-group">
                            <input type="text" name="finish_date" maxlength="10" id="finish_date" style="width:65px;" value="<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57650	.Dök'></cfsavecontent>
                        <cf_wrk_search_button button_type="4" button_name="#message#">
                    </div>
                </cf_box_search>
            </cf_box>
                
            <input type="hidden" name="form_is_submitted" id="form_is_submitted" value="1" />
            <input type="hidden" name="totalrecords_debt" id="totalrecords_debt" value="<cfoutput>#GET_SUB_ACCOUNT_DEBT.recordcount#</cfoutput>"/>
            <input type="hidden" name="totalrecords_claim" id="totalrecords_claim" value="<cfoutput>#GET_SUB_ACCOUNT_CLAIM.recordcount#</cfoutput>"/>
            <input type="hidden" name="save_record" id="save_record" value="0" />
            <cfif isdefined("attributes.form_is_submitted")>
                <div class="ui-row">
                    <div class="col col-6 col-md-12 col-sm-12 col-xs-12">
                        <cfsavecontent variable="title"><cf_get_lang dictionary_id='61019.Borçlu Hesap Grubu'></cfsavecontent>
                        <cf_box title="#title#" uidrop="1" hide_table_column="1">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                        <th><cf_get_lang dictionary_id='61019.Borçlu Hesap Grubu'></th>
                                        <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                                        <th><cf_get_lang dictionary_id='59067.Kapatılacak Gelir Tablosu Hesabı'></th>
                                        <th><cf_get_lang dictionary_id='59297.Kapatılacak Tutar'></th>
                                    </tr>
                                </thead>
                                <tbody id="Table_Debt">
                                    <cfif GET_SUB_ACCOUNT_DEBT.recordcount>
                                        <cfquery name="GET_ACCOUNT_CLOSED_DEBT_BAKIYE" dbtype="query">
                                            SELECT * FROM GET_SUB_ACCOUNT_DEBT
                                        </cfquery>
                                    <cfelse>
                                        <cfset GET_ACCOUNT_CLOSED_DEBT_BAKIYE.recordcount = 0>    
                                    </cfif>
                                    <cfif GET_ACCOUNT_CLOSED_DEBT_BAKIYE.recordcount>
                                        <cfoutput query="GET_ACCOUNT_CLOSED_DEBT_BAKIYE">
                                            <tr>
                                            <td>#GET_ACCOUNT_CLOSED_DEBT_BAKIYE.currentrow#</td>
                                                <td>
                                                    <input type="hidden" name="type_debt#currentrow#" id="type_debt#currentrow#" value="1">
                                                    <input type="hidden" name="account_closed_id_debt#currentrow#" id="account_closed_id_debt#currentrow#" value="#GET_ACCOUNT_CLOSED_DEBT.ACCOUNT_CLOSED_ID#">
                                                    <input type="text" name="DEBT_ACCOUNT_ID#currentrow#" id="DEBT_ACCOUNT_ID#currentrow#"  value="#GET_ACCOUNT_CLOSED_DEBT_BAKIYE.ACCOUNT_CODE#" required="yes" style="width:98%;" autocomplete="on" onFocus="AutoComplete_Create('DEBT_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
                                                </td>
                                                <td>
                                                    <input type="text" name="AMOUNT_DEBT#currentrow#"  id="AMOUNT_DEBT#currentrow#" value="#tlFormat(abs(BORC-ALACAK))#" required="yes" style="width:98%;text-align:right;">
                                                </td>
                                                <td>
                                                    <input type="text" name="DEBT_CLOSED_ACCOUNT_ID#currentrow#" id="DEBT_CLOSED_ACCOUNT_ID#currentrow#" style="width:98%;" value="#GET_ACCOUNT_CLOSED_DEBT_BAKIYE.DEBT_ACCOUNT_CODE_CLOSED_#" required="yes" autocomplete="on" onFocus="AutoComplete_Create('DEBT_CLOSED_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
                                                </td>
                                                <td>
                                                    <input type="text" name="AMOUNT_DEBT_CLOSED#currentrow#"  id="AMOUNT_DEBT_CLOSED#currentrow#" value="#tlFormat(abs(BORC-ALACAK))#" required="yes" style="width:98%;text-align:right;">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                                        </tr>    
                                    </cfif>    
                                </tbody>
                            </cf_grid_list>
                        </cf_box>
                    </div>
                    <div class="col col-6 col-md-12 col-sm-12 col-xs-12">
                        <cfsavecontent variable="title2"><cf_get_lang dictionary_id='61020.Alacaklı Hesap Grubu'></cfsavecontent>
                        <cf_box title="#title2#" uidrop="1" hide_table_column="1">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                                        <th><cf_get_lang dictionary_id='59069.Alacaklı Hesaplar'></th>
                                        <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                                        <th><cf_get_lang dictionary_id='59067.Kapatılacak Gelir Tablosu Hesabı'></th>
                                        <th><cf_get_lang dictionary_id='59297.Kapatılacak Tutar'></th>
                                    </tr>
                                </thead>
                                <tbody id="Table_Claim">
                                    <cfif GET_SUB_ACCOUNT_CLAIM.recordcount>
                                        <cfquery name="GET_ACCOUNT_CLOSED_CLAIM_BAKIYE" dbtype="query">
                                            SELECT * FROM GET_SUB_ACCOUNT_CLAIM
                                        </cfquery>
                                    <cfelse>
                                        <cfset GET_ACCOUNT_CLOSED_CLAIM_BAKIYE.recordcount = 0>    
                                    </cfif>
                                    <cfif GET_ACCOUNT_CLOSED_CLAIM_BAKIYE.recordcount>
                                        <cfoutput query="GET_ACCOUNT_CLOSED_CLAIM_BAKIYE">
                                            <tr>
                                                <td>#GET_ACCOUNT_CLOSED_CLAIM_BAKIYE.currentrow#</td>
                                                <td>
                                                    <input type="hidden" name="type_claim#currentrow#" id="type_claim#currentrow#" value="1">
                                                    <input type="hidden" name="account_closed_id_claim#currentrow#" id="account_closed_id_claim#currentrow#" value="#GET_ACCOUNT_CLOSED_CLAIM.ACCOUNT_CLOSED_ID#">
                                                    <input type="text" name="CLAIM_ACCOUNT_ID#currentrow#" id="CLAIM_ACCOUNT_ID#currentrow#" value="#GET_ACCOUNT_CLOSED_CLAIM_BAKIYE.ACCOUNT_CODE#"  required="yes"  style="width:98%;" autocomplete="on" onFocus="AutoComplete_Create('CLAIM_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','1','','','','3','225');">
                                                </td>
                                                <td>
                                                    <input type="text" name="AMOUNT_CLAIM#currentrow#"  id="AMOUNT_CLAIM#currentrow#" value="#tlFormat(abs(BORC-ALACAK))#" required="yes" style="width:98%;">
                                                </td>
                                                <td>
                                                    <input type="text" name="CLAIM_CLOSED_ACCOUNT_ID#currentrow#" id="CLAIM_CLOSED_ACCOUNT_ID#currentrow#" style="width:98%;" required="yes" value="#GET_ACCOUNT_CLOSED_CLAIM_BAKIYE.CLAIM_ACCOUNT_CODE_CLOSED_#" autocomplete="on" onFocus="AutoComplete_Create('CLAIM_CLOSED_ACCOUNT_ID#currentrow#','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');">
                                                </td>
                                                <td>
                                                    <input type="text" name="AMOUNT_CLAIM_CLOSED#currentrow#"  id="AMOUNT_CLAIM_CLOSED#currentrow#" value="#tlFormat(abs(BORC-ALACAK))#" required="yes" style="width:98%;">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
                                        </tr>    
                                    </cfif>
                                </tbody>
                            </cf_grid_list>
                        </cf_box>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box>
                            <div class="ui-info-bottom flex-end">
                                <cf_box_elements>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label class="col col-6 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='47348.Fiş Türü'></label>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <div class="form-group" >
                                                    <select name="card_type" id="card_type">
                                                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                        <option value="13"><cfoutput>#getlang(1040,'Mahsup Fişi',58452)#</cfoutput></option>
                                                        <option value="19"><cfoutput>#getlang(1746,'Kapanış Fişi',29543)#</cfoutput></option>
                                                    </select>
                                                </div>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                            <div class="form-group" >
                                                <div class="input-group">
                                                    <input type="text" name="process_date" maxlength="10" id="process_date"  style="width:65px;" value="<cfif isdefined("attributes.process_date") and len(attributes.process_date)></cfif>">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <div class="form-group">
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="margin: 12px 0 0 5px">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent>
                                                <cf_workcube_buttons type_format="0" is_upd="0" insert_info='#message#' is_cancel='0' add_function="control()">
                                            </div>
                                        </div>
                                    </div>
                                </cf_box_elements>
                            </div>
                        </cf_box>
                    </div>
                </div>
            <cfelse>
                <div class="row"> 
                    <div class="col col-12 uniqueRow"> 		
                        <div class="row formContent">
                            <div class="row">
                                <div class="col col-12">
                                    <cf_get_lang dictionary_id='57701.Filtre Ediniz '> !
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfif>
        </cfform>

<script type="text/javascript">
	function control()
	{
		if(document.getElementById('process_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='59298.Lütfen işlem tarihi giriniz'>");		
			return false;
		}
		if(document.getElementById('card_type').value == '')
		{
			alert("<cf_get_lang dictionary_id='59299.Lütfen fiş türü seçiniz'>");
			return false;
		}
		document.getElementById('save_record').value = 1;
		<!--- document.getElementById('search_list').action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_account_closed_end&save_record<cfoutput>#url_str#</cfoutput>'; --->

	}
</script>




