<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_activeid" default="1">
<cfparam name="attributes.bank_name" default="">
<cfquery name="GET_BANK_BRANCH" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		ACCOUNTS.ACCOUNT_ID
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND 
		<cfif session.ep.period_year lt 2009>
		(ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL')
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY)
		</cfif>
	ORDER BY
		ACCOUNTS.ACCOUNT_ID
</cfquery>
<cfif isdefined('attributes.is_submitted')>
	<cfquery name="GET_CREDITCARD_EXPENSE" datasource="#DSN3#">
		SELECT 
			* 
		FROM 
			CREDITCARD_PAYMENT_TYPE 
		WHERE	
			PAYMENT_TYPE_ID IS NOT NULL
			<cfif len(attributes.keyword)>
			AND CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			<cfif attributes.is_activeid eq 1>
				AND IS_ACTIVE = 1
			<cfelseif attributes.is_activeid eq 2>
				AND IS_ACTIVE = 0
			</cfif>
			 <cfif len(attributes.bank_name)>
				AND BANK_ACCOUNT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_name#">
			</cfif>
		ORDER BY CARD_NO
	</cfquery>
<cfelse>
	<cfset get_creditcard_expense.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_creditcard_expense.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.is_active") and len(attributes.is_active)>
  <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
</cfif>
<cfif isdefined("attributes.is_activeid") and len(attributes.is_activeid)>
  <cfset url_str = "#url_str#&is_activeid=#attributes.is_activeid#">
</cfif>
<cfif isdefined("attributes.bank_name") and len(attributes.bank_name)>
  <cfset url_str = "#url_str#&bank_name=#attributes.bank_name#">
</cfif>
<cfif isdefined("attributes.is_submitted")>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=finance.list_credit_payment_types" method="post" name="get_">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getlang('main','Filtre',57460)#" maxlength="50">     
                </div>
                <div class="form-group">
                    <select name="bank_name" id="bank_name">
                        <option value="" ><cf_get_lang dictionary_id='58940.Banka Seçiniz'></option>
                        <cfloop query="get_bank_branch">
                            <cfoutput><option value="#get_bank_branch.account_id#"  <cfif attributes.bank_name eq get_bank_branch.account_id>selected</cfif>>#account_name#-#account_currency_id#</option></cfoutput>
                        </cfloop>	
                    </select>    
                </div>
                <div class="form-group">
                    <select name="is_activeid" id="is_activeid">
                        <option value="0" <cfif attributes.is_activeid eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.is_activeid eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="2" <cfif attributes.is_activeid eq 2>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <!---<cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayi_Hatasi_Mesaj'></cfsavecontent>--->
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" required="yes">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('finance','Kredi Kartı Ödeme/Tahsil Yöntemleri',54814)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='29449.Banka Hesabı'></th>
                    <th><cf_get_lang dictionary_id='54816.Taksit Sayısı'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=finance.list_credit_payment_types&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_creditcard_expense.recordcount>
                    <cfset bank_account_list = ''>
                    <cfoutput query="get_creditcard_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(bank_account) and not listfind(bank_account_list,bank_account)>
                            <cfset bank_account_list = listappend(bank_account_list,bank_account,',')>
                        </cfif>
                    </cfoutput>
                    <cfif len(bank_account_list)>
                        <cfset bank_account_list = listsort(bank_account_list,"numeric","ASC",',')>
                        <cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
                            SELECT
                                ACCOUNTS.ACCOUNT_NAME,
                                ACCOUNTS.ACCOUNT_ID
                            FROM
                                ACCOUNTS,
                                BANK_BRANCH
                            WHERE
                                ACCOUNTS.ACCOUNT_BRANCH_ID=BANK_BRANCH.BANK_BRANCH_ID AND 
                                <cfif session.ep.period_year lt 2009>
                                    (ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
                                <cfelse>
                                    ACCOUNTS.ACCOUNT_CURRENCY_ID IN (SELECT MONEY FROM #dsn2_alias#.SETUP_MONEY) AND
                                </cfif>
                                ACCOUNTS.ACCOUNT_ID IN (#bank_account_list#)
                            ORDER BY
                                ACCOUNTS.ACCOUNT_ID
                        </cfquery>
                        <cfset main_bank_account_list = listsort(listdeleteduplicates(valuelist(GET_ACCOUNTS.ACCOUNT_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfoutput query="get_creditcard_expense" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=finance.list_credit_payment_types&event=upd&id=#payment_type_id#">#card_no#</a></td>
                            <td><cfif len(BANK_ACCOUNT)>#get_accounts.account_name[listfind(main_bank_account_list,bank_account,',')]#</cfif></td>
                            <td><cfif len(number_of_instalment)>#number_of_instalment#</cfif></td>
                            <td><cfif get_creditcard_expense.is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                            <!-- sil --><td><a href="#request.self#?fuseaction=finance.list_credit_payment_types&event=upd&id=#payment_type_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6"><cfif isdefined('attributes.is_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_str = "finance.list_credit_payment_types">
        <cfif isdefined('attributes.is_submitted')>
            <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
        </cfif>
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
