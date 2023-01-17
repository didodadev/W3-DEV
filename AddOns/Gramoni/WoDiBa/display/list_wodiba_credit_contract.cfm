<!---
    File: add_bank_action.cfm
    Author: Gramoni-Cagla <cagla.kara@gramoni.com>
    Date: 29.12.2019
    Controller: CreditController.cfm
    Description:
    Banka İşlemlerinde Kredi Ödemesi ve Kredi Tahsilatı kaydı için gerekli olan Kredi sözleşmesi popup sayfasıdır.
--->

<cfsetting showdebugoutput="yes">
<cfset attributes.name = 1>

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.credit_employee_id" default="">
<cfparam name="attributes.credit_employee" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.credit_limit_id" default="">
<cfparam name="attributes.credit_type_id" default="">
<cfparam name="attributes.is_scenario_control" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset attributes.endrow = attributes.startrow + attributes.maxrows - 1/>
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_credit_contract&event=contract">
<cfif isDefined('attributes.mck_form_input_id')>
	<cfset adres = '#adres#&mck_form_input_id=#attributes.mck_form_input_id#'>
</cfif>
<cfif isDefined('attributes.mck_form_input_name')>
	<cfset adres = '#adres#&mck_form_input_name=#attributes.mck_form_input_name#'>
</cfif>

<script type="text/javascript">
    function add_acc(mck_credit_contract_id,mck_credit_no)
    {  
        window.opener.<cfoutput>#attributes.mck_form_input_id#</cfoutput>.value=mck_credit_contract_id;
        window.opener.<cfoutput>#attributes.mck_form_input_name#</cfoutput>.value=mck_credit_no;
        window.close();
    }
</script>

<cfscript>
	getCredit_ = createobject("component","V16.credit.cfc.credit");
	getCredit_.dsn3 = dsn3;
</cfscript>

<cfif isdefined("attributes.form_submitted")>
	<cfscript>
		get_credit_contracts = getCredit_.getCredit
		(
			listing_type : attributes.listing_type,
			company_id : attributes.company_id,
			company : attributes.company,
			keyword : attributes.keyword,
			credit_employee_id : attributes.credit_employee_id,
			credit_employee:attributes.credit_employee,
			start_date : attributes.start_date,
			finish_date :  attributes.finish_date,
			is_active : attributes.is_active,
			process_type : attributes.process_type,
			credit_limit_id : attributes.credit_limit_id,
			credit_type_id : attributes.credit_type_id,
			is_scenario_control : attributes.is_scenario_control,
			startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows : '#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#'
		);
	</cfscript>
    <cfparam name="attributes.totalrecords" default='#get_credit_contracts.QUERY_COUNT#'>
<cfelse> 
	<cfset get_credit_contracts.recordcount = 0>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif> 

<cfsavecontent variable="head_text">
    <title><cf_get_lang dictionary_id="29652.KREDİ SÖZLEŞMESİ"></title>
    </cfsavecontent>
    <cfhtmlhead text="#head_text#" />

<cfform name="list_credit_contract" method="post" action="#request.self#?fuseaction=credit.list_credit_contract&event=contract&mck_form_input_id=wdb_add_bank_action.mck_credit_contract_id&mck_form_input_name=wdb_add_bank_action.mck_credit_contract">
    <input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_big_list_search title="#getLang('main',1855)#">
        <cf_big_list_search_area>
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class ="form-group">
                        <div class="input-group x-15">
                            <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"  placeHolder="#getLang("main",2667,"Kredi No")#">
                        </div>
                    </div>
                    <div class ="form-group">
                        <div class="input-group">
                            <cf_wrk_search_button cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' search_function="">
                        </div>
                    </div>
                </div>
            </div>	
        </cf_big_list_search_area>
    </cf_big_list_search>
    <cfset colspan=4/>
</cfform>
<cf_big_list >
	<thead>
		<tr>
            <th><cf_get_lang_main no='1165.Sıra'></th>
            <th width="60"><cf_get_lang no='6.Kredi No'></th>
            <th width="75"><cf_get_lang_main no='2247.Sözleşme No'></th>
            <th width="60"><cfoutput>#getLang("main",2661,"Kredi Türü")#</cfoutput></th>
            <cfif attributes.listing_type eq 1>
                <th width="60"><cf_get_lang_main no='330.Tarih'></th>
                <cfset colspan=colspan+1>
            </cfif>
            <cfif attributes.listing_type eq 2>
                <th width="60"><cf_get_lang_main no='467.Tarih'></th>
                <cfset colspan=colspan+1>
            </cfif>
		</tr>
	</thead>
	<tbody>
        <cfif get_credit_contracts.recordcount>
            <cfoutput query="get_credit_contracts">
                <tr>
                    <td>#CurrentRow#</td>
                    <td><a href="javascript:void(0);" onClick="add_acc('#CREDIT_CONTRACT_ID#','#CREDIT_NO#')"><font color="blue">#CREDIT_NO#</font></a></td>
                    <td>#agreement_no#</td>
                    <td>#CREDIT_TYPE#</td>
                    <cfif attributes.listing_type eq 1>
                        <td>#dateformat(credit_date,dateformat_style)#</td>
                    </cfif> 
					<cfif attributes.listing_type eq 2>
						<td>#dateformat(row_process_date,dateformat_style)#</td> 
					</cfif>
                </tr>
            </cfoutput>
        <cfelse>
			<tr>
				<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayit Bulunamadi'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
        </cfif>
	</tbody>
</cf_big_list>
<cfif len(attributes.keyword)>
    <cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.company_id)>
    <cfset adres = "#adres#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.company)>
    <cfset adres ="#adres#&company=#attributes.company#">
</cfif>
<cfif len(attributes.credit_employee_id)>
    <cfset adres = "#adres#&credit_employee_id=#attributes.credit_employee_id#">
</cfif>
<cfif len(attributes.credit_employee)>
    <cfset adres = "#adres#&credit_employee=#attributes.credit_employee#">
</cfif>
<cfif len(attributes.start_date)>
    <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
    <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif len(attributes.is_active)>
    <cfset adres = "#adres#&is_active=#attributes.is_active#">
</cfif>
<cfif len(attributes.process_type)>
    <cfset adres = "#adres#&process_type=#attributes.process_type#">
</cfif>
<cfif len(attributes.listing_type)>
    <cfset adres = "#adres#&listing_type=#attributes.listing_type#">
</cfif>
<cfif len(attributes.credit_limit_id)>
    <cfset adres = "#adres#&credit_limit_id=#attributes.credit_limit_id#">
</cfif>
<cfif len(attributes.credit_type_id)>
    <cfset adres = "#adres#&credit_type_id=#attributes.credit_type_id#">
</cfif>
<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#"
    adres="#adres#">