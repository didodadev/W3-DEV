<cf_get_lang_set module_name="sales">
<cfparam name="attributes.start_date" default="">
<cfif isdefined('attributes.cpid')>
	<cfparam name="attributes.finish_date" default="">
<cfelse>
	<cfparam name="attributes.finish_date" default="#date_add('d',1,now())#">
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
<cfif isdefined('attributes.cpid')>
	<cfquery name="GET_COMP_INFO" datasource="#DSN#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">
	</cfquery>	
</cfif>

<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%;">
	<tr style="height:35px;">
		<td class="headbold">Fırsatlarım</td>
	</tr>
</table>

<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%;">	
	<tr>
		<td class="color-row">
			<cfform name="add_opp" method="post" action="" enctype="multipart/form-data">  
				<table>
			  		<tr>
                        <td>Müşteri</td>
                        <td><input type="hidden" name="ref_company_id" id="ref_company_id" value="<cfif isdefined('attributes.cpid')><cfoutput>#attributes.cpid#</cfoutput></cfif>">
                            <input type="hidden" name="ref_partner_id" id="ref_partner_id" value="">
                            <input type="hidden" name="ref_consumer_id" id="ref_consumer_id" value="">
                            <input type="hidden" name="ref_employee_id" id="ref_employee_id" value="">
                            <input type="hidden" name="ref_member_type" id="ref_member_type" value="">
                            <input type="text" name="ref_member_name" id="ref_member_name" value="<cfif isdefined('attributes.cpid')><cfoutput>#get_comp_info.fullname#</cfoutput></cfif>"  style="width:130px;">
                            <a href="javascript://" onclick="get_company_all_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
                        </td>
			  		</tr>
					<tr><td colspan="2"><div id="company_all_div"></div></td></tr>
			  		<tr>
                        <td style="width:80px;"><cf_get_lang_main no='74.Kategori'></td>
                        <td>
                            <select name="opportunity_type_id" id="opportunity_type_id" style="width:150px;">
                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                <cfoutput query="get_opportunity_type">
                                    <option value="#opportunity_type_id#">#opportunity_type#</option>
                                </cfoutput>
                            </select>
                        </td>
				  	</tr>
                    <tr>
                        <td><cf_get_lang_main no='70.Asama'></td>
                        <td>
                            <select name="opp_currency_id" id="opp_currency_id" style="width:150px;">
                                <option value="">Seçiniz</option>
                                <cfoutput query="get_opp_currencies">
                                    <option value="#opp_currency_id#" >#opp_currency#</option><!--- <cfif opp_currency_id eq -1>selected</cfif> --->
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Tarih</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='211.Lütfen Geçerli Bir Tarih Giriniz !'></cfsavecontent>
                            <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:73px;">
                             <!--- <cf_wrk_date_image date_field="start_date"> --->
                    
                            <cfsavecontent variable="message"><cf_get_lang no='211.Lütfen Geçerli Bir Tarih Giriniz !'></cfsavecontent>
                            <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:73px;">
                            <!--- <cf_wrk_date_image date_field="finish_date"> --->
                        </td>
                    </tr>
                    <tr style="height:30px;">
                        <td>&nbsp;</td>
                        <td align="right"><input type="button" onclick="kontrol_prerecord();" value="Listele">
                        	<!--- <cf_workcube_buttons is_upd='0' add_function="kontrol_prerecord()"> --->
                       	</td>
                    </tr>            
                    <tr><td colspan="2"><div id="kontrol_prerecord_div"></div></td></tr>
				</table>
			</cfform>
		</td>
	</tr>
</table>
<br/>
<script type="text/javascript">
	function get_company_all_div()
	{
		if(document.getElementById('ref_member_name').value.length <= 2)
		{
			alert("Lütfen listelemek için en az 3 karakter giriniz !");
			return false;
		}
		goster(company_all_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_company_div&ref_member_name='+ encodeURI(document.getElementById('ref_member_name').value) +'&div_name='+'company_all_div' +'&form_id=' + 'add_opp' +'&is_my=1','company_all_div');		
		return false;
	}
	function add_company_div(company_id,member_name,partner_id,member_type)
	{
		document.getElementById('ref_company_id').value = company_id;
		document.getElementById('ref_member_name').value = member_name;
		document.getElementById('ref_partner_id').value = partner_id;
		document.getElementById('ref_member_type').value = member_type;
		gizle(company_all_div);
	}
	function kontrol_prerecord()
	{
		if(document.getElementById('ref_company_id').value == '' && document.add_opp.opportunity_type_id[add_opp.opportunity_type_id.selectedIndex].value == '' && document.add_opp.opp_currency_id[add_opp.opp_currency_id.selectedIndex].value == '')
		{
			alert("Lütfen listelemek için en az bir alanda filtreleme yapınız !");
			return false;
		}
		if(document.getElementById('ref_member_name').value == '')
		{
			document.getElementById('ref_company_id').value = '';
			document.getElementById('ref_partner_id').value = '';
		}
		goster(kontrol_prerecord_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_opportunity_div&ref_company_id='+ document.getElementById('ref_company_id').value + '&ref_partner_id='+ document.getElementById('ref_partner_id').value + '&opportunity_type_id=' + document.add_opp.opportunity_type_id[add_opp.opportunity_type_id.selectedIndex].value  +'&opp_currency_id=' + document.add_opp.opp_currency_id[add_opp.opp_currency_id.selectedIndex].value +'&start_date='+ document.getElementById('start_date').value +'&finish_date=' + document.getElementById('finish_date').value +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'add_opp','kontrol_prerecord_div');		
		return false;
	}
	document.getElementById('ref_member_name').focus();
	
	<cfif isdefined('attributes.cpid')>
		kontrol_prerecord();
	</cfif>
</script>
<cf_get_lang_set module_name="sales"><!--- sayfanin en ustunde acilisi var --->
