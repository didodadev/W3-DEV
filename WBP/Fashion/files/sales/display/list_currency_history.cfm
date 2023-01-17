<cf_get_lang_set module_name="finance">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfparam name="attributes.valid_date1" default="">
<cfparam name="attributes.valid_date2" default="">
<cfparam name="attributes.money" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_currency_info.cfm">
<cfelse>
	<cfset get_currency.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_currency.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" method="post" action="#request.self#?fuseaction=textile.currencies">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="#getLang('main',262)#"> 
    <cf_big_list_search_area>
    	<div class="row">
        	<div class="col col-12 form-inline">
            	<div class="form-group">
                	<div class="input-group">
                		<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50">
                    </div>
                </div>
                <div class="form-group">
                	<label><cfoutput><cf_get_lang_main no='77.Para Br'></cfoutput></label>
                	<div class="input-group">
						<cfset attributes.ses_id=1>
                        <cfinclude template="../query/get_money.cfm">
                        <select name="money" id="money">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfif get_money.recordcount >
                                <cfoutput query="get_money">
                                    <option value="#money#" <cfif isdefined('attributes.money')and attributes.money eq '#money#'> selected</cfif>>#money#</option>
                                </cfoutput>
                            </cfif>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                	<label><cfoutput><cf_get_lang_main no='1212.Geçerlilik Tarihi'></cfoutput></label>
                    <div class="input-group x-25">
                        <cfsavecontent variable="message"><cf_get_lang no='402.Lütfen İşlem Başlangıç Tarihini Giriniz'></cfsavecontent>
                        <cfinput value="#dateformat(attributes.valid_date1,dateformat_style)#" message="#message#" maxlength="10" type="text" name="valid_date1" style="width:65px;" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="valid_date1"></span>
                        <span class="input-group-addon no-bg"></span>
                        <cfsavecontent variable="message"><cf_get_lang no='403.Lütfen İşlem Bitiş Tarihini Giriniz'></cfsavecontent>
                        <cfinput value="#dateformat(attributes.valid_date2,dateformat_style)#" message="#message#" maxlength="10" type="text" name="valid_date2" style="width:65px;" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="valid_date2"></span>
                    </div>
                </div>
                <div class="form-group">
                	<label><cfoutput><cf_get_lang_main no='215.Kayıt Tarihi'></cfoutput></label>
                    <div class="input-group x-25">
                        <cfsavecontent variable="message"><cf_get_lang no='402.Lütfen İşlem Başlangıç Tarihini Giriniz'></cfsavecontent>
                        <cfinput value="#dateformat(attributes.date1,dateformat_style)#" message="#message#" maxlength="10" type="text" name="date1" style="width:65px;" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date1"></span>
                        <span class="input-group-addon no-bg"></span>
                        <cfsavecontent variable="message"><cf_get_lang no='403.Lütfen İşlem Bitiş Tarihini Giriniz'></cfsavecontent>
                        <cfinput value="#dateformat(attributes.date2,dateformat_style)#" maxlength="10" message="#message#" type="text" name="date2" style="width:65px;" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date2"></span>
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                	<div class="input-group">
						<cf_wrk_search_button search_function="kontrol()">
                    </div>
                </div>
            </div>
        </div>
    </cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
<thead>
    <tr>
    	<th width="35"><cf_get_lang_main no="1165.Sıra"></th>
        <th><cf_get_lang no='93.Para'></th>
        <th width="75"><cf_get_lang_main no='2231.Alış Kuru'></th>
        <th width="90"><cf_get_lang_main no='2217.Satış Kuru'></th>
        <th width="90"><cf_get_lang_main no='1533.Efektif'><cf_get_lang_main no='2231.Alış Kuru'></th>
        <th width="75"><cf_get_lang_main no='1533.Efektif'><cf_get_lang_main no='2217.Satış Kuru'></th>
        <th style="text-align:right;"><cf_get_lang no='408.Partner Alış'></th>
        <th style="text-align:right;"><cf_get_lang no='410.Partner Satış'></th>
        <th style="text-align:right;"><cf_get_lang no='412.Public Alış'></th>
        <th style="text-align:right;"><cf_get_lang no='414.Public Satış'></th>
        <th><cf_get_lang_main no='1212.Geçerlilik Tarihi'></th>
        <th><cf_get_lang_main no='215.Kayıt Tarihi'></th>
        <th><cf_get_lang_main no='71.Kayıt'></th>
       <!-- sil -->
        <th class="header_icn_none" nowrap="nowrap"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.currencies&event=addCurrencies','medium','popup_add_currency');"> <img src="/images/plus_list.gif" alt="<cf_get_lang no='80.günlük kur Ekle'>" title="<cf_get_lang no='80.günlük kur Ekle'>"></a>
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=textile.currencies&event=addCurrenciesHistory','medium','popup_add_currency_hist');"> <img src="/images/plus_list.gif" alt="İleri/Geri Tarihli Kur Bilgisi Ekle" title="<cf_get_lang no="511.İleri/Geri Tarihli Kur Bilgisi Ekle">"></a></th>
  		<!-- sil -->
    </tr>
</thead>
<tbody>
    <cfif get_currency.recordcount gt 0>
      <cfoutput query="get_currency" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <tr>
        	<td>#currentrow#</td>
            <td>#money#</td>
            <td style="text-align:right;">#TLFormat(rate3,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(effective_pur,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(effective_sale,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(ratepp3,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(ratepp2,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(rateww3,session.ep.our_company_info.rate_round_num)#</td>
            <td style="text-align:right;">#TLFormat(rateww2,session.ep.our_company_info.rate_round_num)#</td>
            <td>#dateformat(validate_date,dateformat_style)#&nbsp;&nbsp;<cfif len(validate_hour)>#RepeatString(0,2-len(validate_hour))##validate_hour#:00</cfif></td>
            <td><cfif len(record_date)>#dateformat(date_add('h', session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h', session.ep.time_zone,record_date),timeformat_style)#</cfif></td>
            <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">#employee_name#&nbsp;#employee_surname#</a></td>
            <!-- sil --><td></td><!-- sil -->
        </tr>
    </cfoutput>
  <cfelse>
        <tr>
            <td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main  no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
        </tr>
  </cfif>
</tbody>
</cf_big_list>
<cfset adres="finance.list_currencies">
<cfif len(attributes.keyword)>
	<cfset adres="#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cfset adres="#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.date2") and len(attributes.date2)>
	<cfset adres="#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.valid_date1") and len(attributes.valid_date1)>
	<cfset adres="#adres#&valid_date1=#dateformat(attributes.valid_date1,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.valid_date2") and len(attributes.valid_date2)>
	<cfset adres="#adres#&valid_date2=#dateformat(attributes.valid_date2,dateformat_style)#">
</cfif>
<cfif len(attributes.money)>
	<cfset adres="#adres#&money=#attributes.money#">
</cfif>
<cfif isdefined ("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset adres="#adres#&form_submitted=#attributes.form_submitted#">
</cfif>
<cf_paging
	page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if(($('#valid_date1').val().length && $('#valid_date2').val().length) && ($('#valid_date1').val() >= $('#valid_date2').val())){
				alertObject({message:"<cfoutput><cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> - #getLang('objects',1647)#</cfoutput>"})
				return false;
			}
			
			if(($('#date1').val().length && $('#date2').val().length) && ($('#date1').val() >= $('#date2').val())){
				alertObject({message:"<cfoutput><cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> - #getLang('objects',1647)#</cfoutput>"})
				return false;
			}
			return true;
		}
</script>
