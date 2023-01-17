<cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
	SELECT
		COMPANY_ID,
        PARTNER_ID,
        OPPORTUNITY_TYPE_ID,
        REF_PARTNER_ID,
        REF_CONSUMER_ID,
        REF_EMPLOYEE_ID,
        REF_COMPANY_ID,
        OPP_HEAD,
        OPP_DETAIL,
        OPP_CURRENCY_ID,
        OPP_NO,
        OPP_STAGE,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE 
	FROM
		OPPORTUNITIES
	WHERE
		OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
</cfquery>
<cfif not get_opportunity.recordcount>
	<script type="text/javascript">
		alert('Kayıt bulunamadı !');
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=pda.popup_welcome';
	</script>
	<cfabort>
</cfif>

<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT
		OPPORTUNITY_TYPE_ID,
		OPPORTUNITY_TYPE
	FROM
		SETUP_OPPORTUNITY_TYPE
		<cfif isdefined('session.pda.opportunity_opportunity_type_id') and len(session.pda.opportunity_opportunity_type_id)>
            WHERE 
                OPPORTUNITY_TYPE_ID IN (#session.pda.opportunity_opportunity_type_id#)
        </cfif>
	ORDER BY
		OPPORTUNITY_TYPE
</cfquery>

<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT
		COMPANY_ID,
        FULLNAME
	FROM
		COMPANY 
	WHERE
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_opportunity.company_id#">
</cfquery>
<cfquery name="GET_PARTNER" datasource="#DSN#">
	SELECT 
		PARTNER_ID,
        COMPANY_PARTNER_NAME,
        COMPANY_PARTNER_SURNAME
	FROM 
		COMPANY_PARTNER
	WHERE 
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_opportunity.partner_id#">
</cfquery>
<cfquery name="GET_OPP_CURRENCIES" datasource="#DSN3#">
	SELECT 
		OPP_CURRENCY_ID,
        OPP_CURRENCY 
	FROM 
		OPPORTUNITY_CURRENCY 
		<cfif isdefined('session.pda.opportunity_currency_id') and len(session.pda.opportunity_currency_id)>
            WHERE 
                OPP_CURRENCY_ID IN (#session.pda.opportunity_currency_id#)
        </cfif>
	ORDER BY 
		OPP_CURRENCY
</cfquery>
<cfquery name="GET_RELATED_EVENTS" datasource="#DSN3#">
    SELECT 
        E.EVENT_HEAD, 
        E.EVENT_ID, 
        E.STARTDATE
    FROM
        OPPORTUNITIES O,
        #dsn_alias#.EVENTS_RELATED ER,
        #dsn_alias#.EVENT E
    WHERE
        E.EVENT_ID = ER.EVENT_ID AND
        O.OPP_ID = ER.ACTION_ID AND
        ER.ACTION_SECTION = 'OPPORTUNITY_ID' AND
        O.OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#"> AND
        ER.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#">
</cfquery>
<cfquery name="GET_RELATED_OFFERS" datasource="#DSN3#">
    SELECT 
        OFFER_HEAD,
        OFFER_ID,
        OFFER_DATE
    FROM
        OFFER
    WHERE
        OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
    ORDER BY
        OFFER_DATE DESC
</cfquery>

<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:35px;">
		<td class="headbold"><cf_get_lang_main no='200.Firsat'> : <cfoutput>#get_opportunity.opp_no#</cfoutput></td>
		<td align="right">
			<cfoutput>
				<a href="#request.self#?fuseaction=pda.form_add_event&action_id=#attributes.opp_id#&action_section=OPPORTUNITY_ID"><img src="/images/plus1.gif" border="0" title="Randevu Ekle"></a>	
				<a href="#request.self#?fuseaction=pda.form_add_offer&opp_id=#attributes.opp_id#"><img src="/images/add_1.gif" border="0" title="Teklif Ekle"></a>	
			</cfoutput>
		</td>
	</tr>
</table>

<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
			<cfform name="add_opp" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_opportunity" enctype="multipart/form-data">  
                <table>
                    <input type="hidden" name="opp_id" id="opp_id" value="<cfoutput>#attributes.opp_id#</cfoutput>">
                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_company.company_id#</cfoutput>">
                    <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_partner.partner_id#</cfoutput>">
                    <input type="hidden" name="member_type" id="member_type" value="partner">
                    <input type="hidden" name="process_stage" id="process_stage" value="<cfoutput>#get_opportunity.opp_stage#</cfoutput>">
                    <input type="hidden" name="sales_add_option" id="sales_add_option" value="<cfif isDefined('session.pda.sales_add_option')><cfoutput>#session.pda.sales_add_option#</cfoutput></cfif>">
                    <tr style="height:20px;">
                        <td><cf_get_lang_main no='159.Unvan'></td>
                        <td><cfoutput>#get_company.fullname#</cfoutput></td>
                    </tr>
                    <tr style="height:20px;">
                        <td><cf_get_lang_main no='219.Ad'> Soyad</td>
                        <td><cfoutput>#get_partner.company_partner_name#</cfoutput> <cfoutput>#get_partner.company_partner_surname#</cfoutput></td>
                    </tr>
                    <tr>
                        <td width="80"><cf_get_lang_main no='74.Kategori'>*</td>
                        <td>
                            <select name="opportunity_type_id" id="opportunity_type_id" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_opportunity_type">
                                    <option value="#opportunity_type_id#" <cfif get_opportunity.opportunity_type_id is opportunity_type_id>selected</cfif>>#opportunity_type#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Referans</td>
                        <td>
                            <cfset member_name_ = "">
                            <cfif len(get_opportunity.ref_partner_id)>
                                <cfset member_name_= get_par_info(get_opportunity.ref_partner_id,0,-1,0)>
                            <cfelseif len(get_opportunity.ref_consumer_id)>
                                <cfset member_name_= get_cons_info(get_opportunity.ref_consumer_id,0,0)>
                            <cfelseif len(get_opportunity.ref_employee_id)>
                                <cfset member_name_= get_emp_info(get_opportunity.ref_employee_id,0,0)>
                            </cfif>
                            <input type="hidden" name="ref_company_id" id="ref_company_id" value="<cfoutput>#get_opportunity.ref_company_id#</cfoutput>">
                            <input type="hidden" name="ref_partner_id" id="ref_partner_id" value="<cfoutput>#get_opportunity.ref_partner_id#</cfoutput>">
                            <input type="hidden" name="ref_consumer_id" id="ref_consumer_id" value="<cfoutput>#get_opportunity.ref_consumer_id#</cfoutput>">
                            <input type="hidden" name="ref_employee_id" id="ref_employee_id" value="<cfoutput>#get_opportunity.ref_employee_id#</cfoutput>">                        
                            <input type="hidden" name="ref_member_type" id="ref_member_type" value="<cfif len(get_opportunity.ref_partner_id)>partner<cfelseif len(get_opportunity.ref_consumer_id)>consumer<cfelseif len(get_opportunity.ref_employee_id)>employee</cfif>"><!--- partner,consumer,employee --->
                            <input type="text" name="ref_member_name" id="ref_member_name" value="<cfif len(get_opportunity.ref_company_id)><cfoutput>#get_par_info(get_opportunity.ref_company_id,1,1,0)#</cfoutput> </cfif><cfoutput>#member_name_#</cfoutput>"  style="width:130px;">                       
                            <a href="javascript://" onclick="kontrol_prerecord();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                        </td>
                  </tr>
                    <tr><td colspan="2"><div id="kontrol_prerecord_div"></div></td></tr>
                    <tr>
                        <td><cf_get_lang_main no='68.Başlık'> *</td>
                        <td><cfsavecontent variable="message">Başlık Girmelisiniz !</cfsavecontent>
                            <cfinput type="text" name="opp_head" id="opp_head" value="#get_opportunity.opp_head#" required="yes" message="#message#" style="width:150px;">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;">Açıklama</td>
                        <td><textarea name="opp_detail" id="opp_detail" style="width:150px; height:60px;"><cfoutput>#get_opportunity.opp_detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='70.Asama'></td>
                        <td>
                            <select name="opp_currency_id" id="opp_currency_id" style="width:150px;">
                                <option value="">Seçiniz</option>
                                <cfoutput query="get_opp_currencies">
                                    <option value="#opp_currency_id#" <cfif opp_currency_id eq get_opportunity.opp_currency_id>selected</cfif>>#opp_currency#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr style="height:30px;">
                        <td>&nbsp;</td>
                        <td><cf_workcube_buttons is_upd='0' is_delete='0' add_function="kontrol()"></td>
                    </tr>
                    <tr>
                        <td colspan="2">Kayıt:
                            <cfif len(get_opportunity.record_emp)>
                                <cfoutput>#get_emp_info(get_opportunity.record_emp,0,0)#</cfoutput>
                            </cfif> - <cfoutput>#dateformat(date_add('h',session.pda.time_zone,get_opportunity.record_date),'dd/mm/yyyy')# - #timeformat(date_add('h',session.pda.time_zone,get_opportunity.record_date),'HH:MM')#</cfoutput> </td>
                    </tr>
                    <cfif len(get_opportunity.update_emp)>
                        <tr>
                            <td colspan="2">Güncelleme:
                                <cfoutput>#get_emp_info(get_opportunity.update_emp,0,0)#</cfoutput>
                                - <cfoutput>#dateformat(date_add('h',session.pda.time_zone,get_opportunity.update_date),'dd/mm/yyyy')# - #timeformat(date_add('h',session.pda.time_zone,get_opportunity.update_date),'HH:MM')#</cfoutput> 
                            </td>
                        </tr>
                    </cfif>
                </table>
        	</cfform>
		</td>
	</tr>
</table>
<br/>

<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr style="height:22px;">
		<td class="color-header">
			İlişkili Randevular
		</td>
	</tr>
	<cfif get_related_events.recordcount>
		<cfoutput query="get_related_events">
            <tr class="color-row">
                <td>
                    <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_event&event_id=#event_id#" class="tableyazi">
                    #dateformat(startdate,'dd/mm/yyyy')# - #event_head#
                    </a>
                </td>
            </tr>
        </cfoutput>
	<cfelse>
		<tr class="color-row">
			<td>
			Kayıt yok.
			</td>
		</tr>
	</cfif>
</table>
<br/>

<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-header" style="height:22px;">
			İlişkili Teklifler
		</td>
	</tr>
	<cfif get_related_offers.recordcount>
		<cfoutput query="get_related_offers">
            <tr class="color-row">
                <td>
                    <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_upd_offer&offer_id=#offer_id#" class="tableyazi">
                    #dateformat(offer_date,'dd/mm/yyyy')# - #offer_head#
                    </a>
                </td>
            </tr>
        </cfoutput>
	<cfelse>
		<tr class="color-row">
			<td>
			Kayıt yok.
			</td>
		</tr>
	</cfif>
</table>

<script type="text/javascript">
	function kontrol()
	{
		if (document.add_opp.opportunity_type_id[add_opp.opportunity_type_id.selectedIndex].value == '')
		{
			alert ("Kategori Seçmelisiniz !");
			return false;
		}
		//return process_cat_control();	
		return true;
	}
	function kontrol_prerecord()
	{
		if(document.getElementById('ref_member_name').value.length <= 2)
		{
			alert("Lütfen listelemek için en az 3 karakter giriniz !");
			return false;
		}
		goster(kontrol_prerecord_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_company_div&ref_member_name='+ encodeURI(document.getElementById('ref_member_name').value) +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'add_opp','kontrol_prerecord_div');		
		return false;
	}
	function add_company_div(company_id,member_name,partner_id,member_type)
	{
		document.getElementById('ref_company_id').value = company_id;
		document.getElementById('ref_member_name').value = member_name;
		document.getElementById('ref_partner_id').value = partner_id;
		document.getElementById('ref_member_type').value = member_type;
		gizle(kontrol_prerecord_div);
	}
</script>
<!--- <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">sayfanin en ustunde acilisi var --->

