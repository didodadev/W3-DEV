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
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" method="post" action="#request.self#?fuseaction=finance.list_currencies">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getLang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfset attributes.ses_id=1>
                        <cfinclude template="../query/get_money.cfm">
                        <select name="money" id="money">
                            <option value=""><cf_get_lang dictionary_id='57489.Para Br'></option>
                            <cfif get_money.recordcount >
                                <cfoutput query="get_money">
                                    <option value="#money#" <cfif isdefined('attributes.money')and attributes.money eq '#money#'> selected</cfif>>#money#</option>
                                </cfoutput>
                            </cfif>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput value="#dateformat(attributes.valid_date1,dateformat_style)#" placeholder="#getLang("","",47702)#" message="#getLang('','Lütfen İşlem Başlangıç Tarihini Giriniz',54788)#" maxlength="10" type="text" name="valid_date1" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="valid_date1"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput value="#dateformat(attributes.valid_date2,dateformat_style)#" placeholder="#getLang("","",47713)#" message="#getLang('','Lütfen İşlem Bitiş Tarihini Giriniz',54789)#" maxlength="10" type="text" name="valid_date2" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="valid_date2"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput value="#dateformat(attributes.date1,dateformat_style)#" placeholder="#getLang("","",49901)#" message="#getLang('','Lütfen İşlem Başlangıç Tarihini Giriniz',54788)#" maxlength="10" type="text" name="date1" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date1"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput value="#dateformat(attributes.date2,dateformat_style)#" placeholder="#getLang("","",54893)#" maxlength="10" message="#getLang('','Lütfen İşlem Bitiş Tarihini Giriniz',54789)#" type="text" name="date2" validate="#validate_style#">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="date2"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="kontrol()">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(262,'Kur Bilgileri',57674)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id="58577.Sıra"></th>
                    <th><cf_get_lang dictionary_id='54479.Para'></th>
                    <th><cf_get_lang dictionary_id='30028.Alış Kuru'></th>
                    <th><cf_get_lang dictionary_id='30014.Satış Kuru'></th>
                    <th><cf_get_lang dictionary_id='58945.Efektif'><cf_get_lang dictionary_id='30028.Alış Kuru'></th>
                    <th><cf_get_lang dictionary_id='58945.Efektif'><cf_get_lang dictionary_id='30014.Satış Kuru'></th>
                    <th><cf_get_lang dictionary_id='54794.Partner Alış'></th>
                    <th><cf_get_lang dictionary_id='54796.Partner Satış'></th>
                    <th><cf_get_lang dictionary_id='54798.Public Alış'></th>
                    <th><cf_get_lang dictionary_id='54800.Public Satış'></th>
                    <th><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center" nowrap="nowrap"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_currencies&event=add');"> <i class="fa fa-plus" alt="<cf_get_lang dictionary_id='54466.günlük kur Ekle'>" title="<cf_get_lang dictionary_id='54466.günlük kur Ekle'>"></i></a></th>
                    <th width="20" class="header_icn_none text-center" nowrap="nowrap"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_currencies&event=addHistory');"> <i class="fa fa-plus-circle" alt="<cf_get_lang dictionary_id='54897.İleri/Geri Tarihli Kur Bilgisi Ekle'>" title="<cf_get_lang dictionary_id="54897.İleri/Geri Tarihli Kur Bilgisi Ekle">"></i></a></th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_currency.recordcount gt 0>
                <cfoutput query="get_currency" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td>#currentrow#</td>
                        <td>#money#</td>
                        <td class="text-right">#TLFormat(rate3,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(effective_pur,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(effective_sale,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(ratepp3,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(ratepp2,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(rateww3,session.ep.our_company_info.rate_round_num)#</td>
                        <td class="text-right">#TLFormat(rateww2,session.ep.our_company_info.rate_round_num)#</td>
                        <td>#dateformat(validate_date,dateformat_style)#&nbsp;&nbsp;<cfif len(validate_hour)>#RepeatString(0,2-len(validate_hour))##validate_hour#:00</cfif></td>
                        <td>#dateformat(date_add('h', session.ep.time_zone,record_date),dateformat_style)# #timeformat(date_add('h', session.ep.time_zone,record_date),timeformat_style)#</td>
                        <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');">#employee_name#&nbsp;#employee_surname#</a></td>
                        <!-- sil --><td></td><td></td><!-- sil -->
                    </tr>
                </cfoutput>
            <cfelse>
                    <tr>
                        <td colspan="15"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
            </cfif>
            </tbody>
        </cf_grid_list>
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
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function kontrol()
		{
			if(($('#valid_date1').val().length && $('#valid_date2').val().length) && ($('#valid_date1').val() >= $('#valid_date2').val())){
				alertObject({message:"<cfoutput><cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> - #getLang(1647,'Başlangıç Tarihi ve Bitiş Tarihi Aynı Olamaz',34037)#</cfoutput>"})
				return false;
			}
			
			if(($('#date1').val().length && $('#date2').val().length) && ($('#date1').val() >= $('#date2').val())){
				alertObject({message:"<cfoutput><cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> - #getLang(1647,'Başlangıç Tarihi ve Bitiş Tarihi Aynı Olamaz',34037)#</cfoutput>"})
				return false;
			}
			return true;
		}
</script>
