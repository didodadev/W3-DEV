<cfset attributes.var_type = '1,2,3'>
<cfinclude template="decrypt_finance.cfm">

<cfif isdefined("attributes.period_id") and len(attributes.period_id)>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
	</cfquery>
	<cfif get_period.recordcount>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
<cfelse>
	<cfset db_adres = "#dsn2#">
</cfif>

<cfquery name="GET_EXPENSE" datasource="#db_adres#">
	SELECT 
		ACTION_TYPE,
        PROCESS_CAT,
        EXPENSE_ID,
        EMP_ID,
        PAPER_TYPE,
        DETAIL,
        PAPER_NO,
        CH_COMPANY_ID,
        CH_CONSUMER_ID,
        PAYMETHOD_ID,
        SYSTEM_RELATION,
        EXPENSE_DATE,
        OTHER_MONEY,
        TOTAL_AMOUNT,
        KDV_TOTAL,
        OTHER_MONEY_KDV,
        OTHER_MONEY_AMOUNT,
        OTHER_MONEY_NET_TOTAL,
        TOTAL_AMOUNT_KDVLI
    FROM 
    	EXPENSE_ITEM_PLANS 
    WHERE 
    	EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>

<cfquery name="GET_EXPENSE_MONEY" datasource="#DSN#">
	SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID =<cfif isdefined("session.pp.period_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"><cfelseif isdefined("session.ww.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif> AND MONEY_STATUS=1
</cfquery>
<cfif not get_expense.recordcount>
	<br/><font class="txtbold">Böyle Bir Kayıt Bulunmamaktadır!</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT 
		PROCESS_CAT_ID,
		PROCESS_CAT,
		PROCESS_TYPE 
	FROM 
		SETUP_PROCESS_CAT 
	WHERE 
		PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.action_type#"> AND 
		PROCESS_CAT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.process_cat#">
</cfquery>
<cfquery name="GET_ROWS" datasource="#db_adres#">
	SELECT 
    	KDV_RATE,
        ACTIVITY_TYPE,
        DETAIL,
        AMOUNT,
        AMOUNT_KDV,
        TOTAL_AMOUNT,
        OTHER_MONEY_VALUE,
        OTHER_MONEY_GROSS_TOTAL,
        EXPENSE_CENTER_ID,
        EXPENSE_ITEM_ID,
        MEMBER_TYPE,
        MONEY_CURRENCY_ID,
        COMPANY_PARTNER_ID,
        PYSCHICAL_ASSET_ID,
        PROJECT_ID 
    FROM 
    	EXPENSE_ITEMS_ROWS 
    WHERE 
    	EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.expense_id#">
</cfquery>
<cfif len(get_expense.paper_type)>
	<cfquery name="GET_DOCUMENT_TYPE" datasource="#DSN#">
		SELECT
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
		FROM
			SETUP_DOCUMENT_TYPE,
			SETUP_DOCUMENT_TYPE_ROW
		WHERE
			SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
			SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#fuseaction#%"> AND
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paper_type#">
		ORDER BY
			DOCUMENT_TYPE_NAME
	</cfquery>
</cfif>
<cfif len(get_expense.paymethod_id)>
	<cfquery name="GET_PAYMETHOD" datasource="#DSN#">
		SELECT PAYMETHOD_ID, PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_expense.paymethod_id#">
	</cfquery>
</cfif>
<cfif get_rows.recordcount>
	<cfquery name="GET_EXPENSE_CENTER" datasource="#db_adres#">
		SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER
	</cfquery>
	<cfif isDefined("attributes.is_income")>
        <cfquery name="GET_EXPENSE_ITEM" datasource="#db_adres#">
            SELECT EXPENSE_ITEM_ID,INCOME_EXPENSE, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1
        </cfquery>
	<cfelse>
        <cfquery name="GET_EXPENSE_ITEM" datasource="#db_adres#">
            SELECT EXPENSE_ITEM_ID,IS_EXPENSE, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1
        </cfquery>
	</cfif>
	<cfif len(get_rows.kdv_rate)>
        <cfquery name="GET_TAX"  datasource="#DSN2#">
            SELECT TAX FROM SETUP_TAX 
        </cfquery>
    </cfif>
	<!---<cfif len(get_rows.money_currency_id)>
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfif isdefined("session.pp.period_id")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"><cfelseif isdefined("session.ww.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"></cfif> AND MONEY_STATUS = 1
        </cfquery>
	</cfif>
	<cfif len(get_rows.activity_type)>--->
        <cfquery name="GET_ACTIVITY_TYPES" datasource="#DSN#">
            SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY
        </cfquery>
	<!---</cfif>--->
</cfif>

<cfoutput>
<hgroup class="finance_display">
    <h3>
		<cfif isDefined("attributes.is_income")>
            <cf_get_lang dictionary_id ='58065.Gelir Fişi'>
        <cfelse>
            <cf_get_lang dictionary_id ='58064.Masraf Fişi'>
        </cfif>
    </h3>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='61806.İşlem Tipi'></label>
            <span>: #get_process_cat.process_cat#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57468.Belge'> <cf_get_lang dictionary_id='57487.No'></label>
            <span>: #get_expense.paper_no#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58578.Belge Türü'></label>
            <span>: <cfif len(get_expense.paper_type)>#get_document_type.document_type_name#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58679.Sistem İlişkisi'></label>
            <span>: <cfif len(get_expense.system_relation)>#get_expense.system_relation#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
            <span>: <cfif len(get_expense.paymethod_id)>#get_paymethod.paymethod#</cfif></span>
        </div>
    </div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='57073.Belge Tarihi'></label>
            <span>: #dateformat(get_expense.expense_date,'dd/mm/yyyy')#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57519.Cari Hesap'> </label>
            <span>: 
            	<!---<cfif len(get_expense.ch_company_id)><cfset ch_member_type="partner"><cfelseif len(get_expense.ch_consumer_id)><cfset ch_member_type="consumer"><cfelse><cfset ch_member_type=""></cfif>
              	<cfif ch_member_type eq "partner">#get_par_info(get_expense.ch_company_id,1,1,0)#<cfelseif ch_member_type eq "consumer">#get_cons_info(get_expense.ch_consumer_id,2,0)#</cfif>--->
            </span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57578.Yetkili'> </label>
            <span>: <!---<cfif ch_member_type eq "partner">#get_par_info(get_expense.ch_partner_id,0,-1,0)#<cfelseif ch_member_type eq "consumer">#get_cons_info(get_expense.ch_consumer_id,0,0)#</cfif>---></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='51313.Ödeme Yapan '> </label>
            <span>: <cfif len(get_expense.emp_id)>#get_emp_info(get_expense.emp_id,0,0)#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id= '57629.Açıklama'></label>
            <span>: #get_expense.detail#</span>
        </div>
    </div>
    <div class="clear_area"></div>
    <table class="objects2_list">
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id= '57629.Açıklama'></th>
                <th>
                	<cfif isDefined("attributes.is_income")>
                        <cf_get_lang dictionary_id='58172.Gelir Merkezi'>
                    <cfelse>
                        <cf_get_lang dictionary_id ='58460.Masraf Merkezi'>
                    </cfif>
                </th>
                <th>
                	<cfif isDefined("attributes.is_income")>
                        <cf_get_lang dictionary_id='58173.Gelir Kalemi'>
                    <cfelse>
                        <cf_get_lang dictionary_id ='58551.Gider Kalemi'>
                    </cfif>
                </th>
                <th><cf_get_lang dictionary_id= '57673.Tutar'></th>
                <th><cf_get_lang dictionary_id= '57639.KDV%'></th>
                <th><cf_get_lang dictionary_id ='54859.KDV Tutar'></th>
                <th><cf_get_lang dictionary_id= '56975.KDV li Toplam'></th>
                <th><cf_get_lang dictionary_id ='33366.Dövizli Fiyat'></th>
                <th><cf_get_lang dictionary_id ='57489.Para Birimi'></th>
                <th><cf_get_lang dictionary_id ='51319.Aktivite Tipi'></th>                                
                <th>&nbsp;
                    <cfif isDefined("attributes.is_income")>
                        <cf_get_lang dictionary_id ='56987.Satış Yapan'>
                    <cfelse>
                        <cf_get_lang dictionary_id ='51309.Harcama Yapan'>
                    </cfif>
                </th>
                <th><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
                <th><cf_get_lang dictionary_id='57416.Proje'></th>
            </tr>
        </thead>
        <tbody>
			<cfif get_rows.recordcount>
                <cfloop query="get_rows">
                    <tr class="odd">
                        <td>#get_rows.detail#</td>
                        <td>
                            <cfquery name="GET_EXPENSE_CNTR" dbtype="query">
                                SELECT EXPENSE_ID, EXPENSE FROM GET_EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.expense_center_id#">
                            </cfquery>
                            #get_expense_cntr.expense#
                        </td>
                        <td>
							<cfif isDefined("attributes.is_income")>
                                <cfquery name="GET_EXPENSE_ITM" dbtype="query">
                                    SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.expense_item_id#"> AND INCOME_EXPENSE = 1
                                </cfquery>
                            <cfelse>
                                <cfquery name="GET_EXPENSE_ITM" dbtype="query">
                                    SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM GET_EXPENSE_ITEM WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.expense_item_id#"> AND IS_EXPENSE = 1
                                </cfquery>
                            </cfif>
                            #get_expense_itm.expense_item_name#
                        </td>
                        <td><cfif len(get_rows.amount)>#tlformat(get_rows.amount)#</cfif></td>
                        <td>#get_rows.kdv_rate#</td>
                        <td><cfif len(get_rows.amount_kdv)>#tlformat(get_rows.amount_kdv)#</cfif></td>
                        <td><cfif len(get_rows.total_amount)>#tlformat(get_rows.total_amount)#</cfif></td>
                        <td><cfif len(get_rows.other_money_value)>#tlformat(get_rows.other_money_gross_total)#</cfif></td>
                        <td>#get_rows.money_currency_id#</td>
                        <td>
                            <cfif len(get_rows.activity_type)>
                                <cfquery name="ACTIVITY_TYPES" dbtype="query">
                                    SELECT ACTIVITY_ID, ACTIVITY_NAME FROM GET_ACTIVITY_TYPES WHERE ACTIVITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.activity_type#">
                                </cfquery>
                                #activity_types.activity_name#
                            </cfif>
                        </td>
                        <td><cfif get_rows.member_type eq 'partner'>#get_par_info(get_rows.company_partner_id,0,-1,0)#<cfelseif get_rows.member_type eq 'consumer'>#get_cons_info(get_rows.company_partner_id,0,0)#<cfelseif get_rows.member_type eq 'employee'>#get_emp_info(get_rows.company_partner_id,0,0)#<cfelse></cfif></td>
                        <td>
                            <cfif len(get_rows.pyschical_asset_id)>
                                <cfquery name="GET_ASSETP_NAME" datasource="#DSN#">
                                    SELECT ASSETP,ASSETP_ID FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.pyschical_asset_id#">
                                </cfquery>
                                #get_assetp_name.assetp#
                            </cfif>
                        </td>
                        <td>
                            <cfif len(get_rows.project_id)>
                                <cfquery name="GET_PROJECT" datasource="#DSN#">
                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.project_id#">
                                </cfquery>
                                #get_project.project_head#
                            </cfif>
                        </td>
                    </tr>
				</cfloop>
            </cfif>
        </tbody>
    </table>
    <div class="clear_area"></div>
    <div class="area_colmn">
        <cfoutput>
            <cfloop query="get_expense_money">
                <div><cfif get_expense.other_money eq money>#money#&nbsp;#TLFormat(rate1,0)#/#TLFormat(rate2,4)#</cfif></div>
            </cfloop>
        </cfoutput>
    </div>
    <div class="clear_area"></div>	
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57492.Toplam'></label>
            <span>: #TLFormat(get_expense.total_amount)#&nbsp;<cfif isdefined("session.pp.money")>#session.pp.money#<cfelseif isdefined("session.ww.money")>#session.ww.money#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='51317.Toplam KDV'></label>
            <span>: #TLFormat(get_expense.kdv_total)#<cfif isdefined("session.pp.money")>#session.pp.money#<cfelseif isdefined("session.ww.money")>#session.ww.money#</cfif></span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id='57680.Genel Toplam'></label>
            <span>: #TLFormat(get_expense.total_amount_kdvli)#<cfif isdefined("session.pp.money")>#session.pp.money#<cfelseif isdefined("session.ww.money")>#session.ww.money#</cfif></span>
        </div>
    </div>
    <div class="colmn_left">
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='58124.Döviz Toplam'></label>
            <span>: #TLFormat(get_expense.other_money_amount)# #get_expense.other_money#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='51331.Döviz KDV'></label>
            <span>: #TLFormat(get_expense.other_money_kdv)#&nbsp;#get_expense.other_money#</span>
        </div>
        <div class="area_colmn">
            <label><cf_get_lang dictionary_id ='56993.Döviz KDV li Toplam'></label>
            <span>: #TLFormat(get_expense.other_money_net_total)#&nbsp;#get_expense.other_money#</span>
        </div>
    </div>
</hgroup>
</cfoutput>
