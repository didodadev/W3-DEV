<!---
    File: list_expense_money.cfm
    Author: Gramoni-Cagla <cagla.kara@gramoni.com>
    Date: 27.12.2019
    Controller: WodibaBankActionsController.cfm
    Description:
        Wodiba banka işlemlerinin kaydı için gerekli olan masraf/gelir tutarı popup sayfasıdır.
--->

<cfsetting showdebugoutput="yes">
<cfset attributes.name = 1>
<cfparam name="attributes.keyword" default="">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset attributes.endrow = attributes.startrow + attributes.maxrows - 1/>
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.wodiba_bank_actions&event=money">
<cfif isDefined('attributes.form_input_id')>
	<cfset adres = '#adres#&form_input_id=#attributes.form_input_id#'>
</cfif>
<cfif isDefined('attributes.form_input_name')>
	<cfset adres = '#adres#&form_input_name=#attributes.form_input_name#'>
</cfif>
<cfif isDefined('attributes.form_input_name1')>
	<cfset adres = '#adres#&form_input_name1=#attributes.form_input_name1#'>
</cfif>

<script type="text/javascript">
    function formatMoney(n) {
        return parseFloat(n).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1.').replace(/\.(\d+)$/,',$1');
    }
    function add_acc(money_id,money,dovizturu)
    {  
           window.opener.<cfoutput>#attributes.form_input_id#</cfoutput>.value=money_id;
           window.opener.<cfoutput>#attributes.form_input_name#</cfoutput>.value=formatMoney(money);
           window.opener.<cfoutput>#attributes.form_input_name1#</cfoutput>.value=dovizturu;
           window.close();
    }
</script>

<cfscript>
    include '../cfc/Functions.cfc';
    wdb_bank_action     = GetBankActionMoney(AccountId=attributes.account_id);
</cfscript>
<cfparam name="attributes.totalrecords" default="#wdb_bank_action.recordcount#">

<cfsavecontent variable="head_text">
    <title><cf_get_lang dictionary_id="58930.MASRAF">/<cf_get_lang dictionary_id="58677.GELİR"></title>
    </cfsavecontent>
    <cfhtmlhead text="#head_text#" />

<div>
    <div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze headerIsPopup">
        <span class="pageCaption font-green-sharp bold"><cf_get_lang dictionary_id="58930.MASRAF">/ <cf_get_lang dictionary_id="58677.GELİR"></span>
        <div id="pageTab" class="pull-right text-right">
            <nav class="detailHeadButton" id="tabMenu"></nav>
        </div>
    </div>
</div>

<cf_big_list >
	<thead>
		<tr>
            <th><cf_get_lang_main no='1165.Sıra'></th>
            <th><cf_get_lang_main no='240.Hesap'></th>
            <th><cf_get_lang_main no='650.Dekont'></th>
            <th><cf_get_lang_main no='330.Tarih'></th>
            <th><cf_get_lang_main no='217.Açıklama'></th>
            <th><cf_get_lang_main no='261.Tutar'></th>
            <th>PB</th>
            <th><cf_get_lang_main no='344.Durum'></th>
		</tr>
	</thead>
	<tbody>
        <cfif wdb_bank_action.recordcount>
            <cfoutput>
                <cfloop query="wdb_bank_action" startrow="#attributes.startrow#" endrow="#attributes.endrow#">		
                   <tr>
                        <td>#CurrentRow#</td>
                        <td nowrap="nowrap">#ACCOUNT_NAME#</td>
                        <td>#DEKONTNO#</td>
                        <td nowrap="nowrap">#dateFormat(TARIH,"dd.mm.YYYY")# #timeFormat(TARIH,"HH:mm")#</td>
                        <td>#Left(ACIKLAMA,60)#</td>
                        <td style="text-align:right;" nowrap="nowrap">
                            <a href="javascript:void(0);" onClick="add_acc('#WDB_ACTION_ID#','#MIKTAR#','<cfif DOVIZTURU Eq 'TRY'>TL<cfelse>#DOVIZTURU#</cfif>')">
                            <font color="blue">#TLFormat(MIKTAR)#</font>
                            </a>
                            <cfif MIKTAR Gt 0>
                                &nbsp;<i class="fa fa-caret-down" style="color:green;font-size:18px;"></i>
                            <cfelse><i class="fa fa-caret-up" style="color:red;font-size:18px;">
                            </cfif>
                        </td>
                        <td><cfif DOVIZTURU Eq 'TRY'>TL<cfelse>#DOVIZTURU#</cfif></td>
                        <td style="text-align:center;"><cfif Len(BANK_ACTION_ID)><img src="images/green_glob.gif" title="Kayıt Başarılı"><cfelse><img src="/images/yellow_glob.gif" title="Kayıt Edilmedi"></cfif></td>
                   </tr>
                </cfloop>
            </cfoutput>
		<cfelse>
            <tr>
                <cfset colspan_info = 8>
				<td colspan="<cfoutput>#colspan_info#</cfoutput>"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#"
    adres="#adres#">