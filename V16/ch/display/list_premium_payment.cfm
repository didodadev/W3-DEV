<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_premium_payment" datasource="#dsn2#">
		SELECT
			*
		FROM
			INVOICE_MULTILEVEL_PAYMENT INV,
			#dsn3_alias#.CAMPAIGNS C
		WHERE
			INV.CAMPAIGN_ID = C.CAMP_ID
		<cfif isdefined("attributes.camp_name") and len(attributes.camp_id) and len(attributes.camp_name)>
			AND INV.CAMPAIGN_ID = #attributes.camp_id#
		</cfif>
		<cfif isdefined("attributes.premium_type") and len(attributes.premium_type)>
			AND INV.PREMIUM_TYPE = #attributes.premium_type#
		</cfif>
		ORDER BY
			INV.ACTION_DATE
	</cfquery>
<cfelse>
	<cfset get_premium_payment.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_premium_payment.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="list_premium" method="post" action="#request.self#?fuseaction=ch.list_premium_payment">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<cf_big_list_search title="#getLang('ch',66)#"> 
		<cf_big_list_search_area>
        	<div class="row">
        		<div class="col col-12 form-inline">
                	<div class="form-group">
                    	<label><cf_get_lang_main no='34.Kampanya'></label>
                        <div class="input-group">
                            <input type="hidden" name="camp_id" id="camp_id" value="<cfif isdefined("attributes.camp_id")><cfoutput>#attributes.camp_id#</cfoutput></cfif>">
                            <input type="text" name="camp_name" id="camp_name" readonly value="<cfif isdefined("attributes.camp_name")><cfoutput>#attributes.camp_name#</cfoutput></cfif>" style="width:160px;">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=list_premium.camp_id&field_name=list_premium.camp_name','list');" title="<cf_get_lang_main no='34.Kampanya'>"></span>
                        </div>
                    </div>
                    <div class="form-group">
                    	<label><cf_get_lang no='205.Prim Tipi'></label>
                        <div class="input-group">
                            <select name="premium_type" id="premium_type" style="width:165px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <option value="1" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 1> selected</cfif>><cf_get_lang no="207.Teşvik Primi"></option>
                                <option value="2" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 2> selected</cfif>><cf_get_lang no="208.Seviye Atlama Primi"></option>							
                                <option value="3" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 3> selected</cfif>><cf_get_lang no="209.Nakit Ödül Programı Primi"></option>							
                                <option value="4" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 4> selected</cfif>><cf_get_lang no="210.Direktör Geliştirme Programı Primi"></option>							
                                <option value="5" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 5> selected</cfif>><cf_get_lang no="211.Yıldız Bonus Programı Primi"></option>
                                <option value="6" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 6> selected</cfif>><cf_get_lang no="212.Ünvan Bonus Programı Primi"></option>							
                                <option value="7" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 7> selected</cfif>><cf_get_lang no="213.Direktör Bonus Programı Primi"></option>							
                                <option value="8" <cfif isdefined("attributes.premium_type") and attributes.premium_type eq 8> selected</cfif>><cf_get_lang_main no="744.Diger"> <cf_get_lang no="209.Nakit Ödül Programı Primi"></option>							
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group x-3_5">
                            <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </div>
                    </div>
                    <div class="form-group">
                    	<cf_wrk_search_button>
                    </div>
                    <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
                </div>
        	</div>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="20"><cf_get_lang_main no='1165.Sıra'></th>
			<th nowrap="nowrap"><cf_get_lang_main no ='34.Kampanya'></th>
			<th width="100"><cf_get_lang_main no='467.İşlem Tarihi'></th>
			<th width="100"><cf_get_lang_main no='1439.Ödeme Tarihi'></th>
			<th width="100"><cf_get_lang no='65.Stopaj Tutarı'></th>
			<th width="100"><cf_get_lang no='64.Ödenen Tutar'></th>
			<!-- sil -->
			<th class="header_icn_none" nowrap="nowrap"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ch.list_premium_payment&event=add"><img src="../../images/plus_list.gif" alt="<cf_get_lang_main no="170.Ekle">" title="<cf_get_lang_main no="170.Ekle">"></a></th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_premium_payment.recordcount>
			<cfoutput query="get_premium_payment" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#camp_head#</td>
					<td>#dateformat(action_date,dateformat_style)#</td>
					<td>#dateformat(payment_date,dateformat_style)#</td>
					<td style="text-align:right;">#tlformat(stoppage_amount)# #session.ep.money#</td>
					<td style="text-align:right;">#tlformat(pay_amount)# #session.ep.money#</td>
					<!-- sil -->
					<td align="center"><a href="#request.self#?fuseaction=ch.list_premium_payment&event=upd&inv_payment_id=#inv_payment_id#"><img src="../../images/update_list.gif" alt="<cf_get_lang_main no="52.Güncelle">" title="<cf_get_lang_main no="52.Güncelle">"></a></td>
					<!-- sil -->
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_str = "ch.list_premium_payment">
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id) and len(attributes.camp_name)>
	<cfset url_str = "#url_str#&camp_id=#attributes.camp_id#&camp_name=#attributes.camp_name#">
</cfif>
<cfif isdefined("attributes.premium_type") and len(attributes.premium_type)>
	<cfset url_str = "#url_str#&premium_type=#attributes.premium_type#">
</cfif> 
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url_str#">
<script type="text/javascript">
	document.getElementById('camp_name').focus();
</script>
