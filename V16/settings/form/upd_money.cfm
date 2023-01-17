<cfquery name="CATEGORY" datasource="#dsn#">
    SELECT 
        MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        ACCOUNT_950, 
        PER_ACCOUNT, 
        RATE3, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        RATEPP2, 
        RATEPP3, 
        RATEWW2, 
        RATEWW3, 
        CURRENCY_CODE, 
        MONEY_NAME, 
        MONEY_SYMBOL ,
        EFFECTIVE_SALE,
        EFFECTIVE_PUR
    FROM 
        SETUP_MONEY 
    WHERE 
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#">
        AND MONEY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Para Birimi','57489')#" add_href="#request.self#?fuseaction=settings.form_add_money" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfinclude template="../display/list_money.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
	        <cfform name="money_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_money_upd" onsubmit="return(unformat_fields());">
                <input type="hidden" name="money_id" id="money_id" value="<cfoutput>#url.id#</cfoutput>">
                <input type="hidden" name="money" id="money" value="<cfoutput>#CATEGORY.MONEY_NAME#,#CATEGORY.MONEY#</cfoutput>">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-money">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <b><cfoutput>#category.money#</cfoutput></b>
                            </div>
                        </div>    
                        <div class="form-group" id="item-rate1">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'> *</label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='59025.Geçerli Bir Tutar Giriniz'></cfsavecontent>
                                <cfinput type="text" name="rate1" id="rate1" size="20" value="#tlformat(category.rate1)#" maxlength="10" class="moneybox" required="yes" message="#message#" validate="integer">
                            </div>
                        </div>
                        <div class="form-group" id="item-money_symbol">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42242.Sembol'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <input type="text" name="money_symbol" id="money_symbol" value="<cfoutput>#category.money_symbol#</cfoutput>">
                            </div>
                        </div>  
                        <div class="form-group" id="item-title">      
                            <div>&nbsp;</div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6"><label><cf_get_lang dictionary_id='57448.Satış'></label></div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6"><label><cf_get_lang dictionary_id='58176.Alış'></label></div>
                            </div>
                        </div>    
                        <div class="form-group" id="item-rate">     
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                        <cfinput type="text" name="rate2" id="rate2" value="#tlformat(category.rate2,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                    </div>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="rate3" id="rate3" value="#tlformat(category.rate3,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-efectiveAlis">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58945.Efektif'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">    
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="efectiveSatis" id="efectiveSatis" value="#tlformat(category.effective_sale,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="efectiveAlis" id="efectiveAlis" value="#tlformat(category.effective_pur,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>
                        </div>    
                        <div class="form-group" id="item-partner">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58885.Partner'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="ratepp2" id="ratepp2" value="#tlformat(category.ratepp2,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="ratepp3" id="ratepp3" value="#tlformat(category.ratepp3,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div>  
                        </div>
                        <div class="form-group" id="item-public">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43232.Public'></label>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="rateww2" id="rateww2" value="#tlformat(category.rateww2,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                                <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                                    <cfinput type="text" name="rateww3" id="rateww3" value="#tlformat(category.rateww3,'#session.ep.our_company_info.rate_round_num#')#" maxlength="10" class="moneybox" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));">
                                </div>
                            </div> 
                        </div>
                    </div>	
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="CATEGORY">
                    <cfquery name="GET_SETUP_PERIOD" datasource="#DSN#">
                        SELECT OUR_COMPANY_ID, PERIOD_YEAR FROM SETUP_PERIOD
                    </cfquery>
                    <cfset kayit_varmi = 0>
                    <cfif fusebox.use_period>
                        <cfloop query="get_setup_period">
                            <cfif kayit_varmi eq 0>
                                <cfquery name="GET_MONEY_ID" datasource="#DSN#" maxrows="1">
                                    SELECT TOP 1 CR.ACTION_CURRENCY_ID
                                    FROM
                                    <cfif database_type eq "MSSQL">
                                        #dsn#_#get_setup_period.period_year#_#get_setup_period.our_company_id#.CARI_ROWS AS CR
                                    <cfelseif database_type eq "DB2">
                                        #dsn#_#get_setup_period.our_company_id#_#right(get_setup_period.period_year,2)#_CARI_ROWS AS CR
                                    </cfif>
                                    WHERE
                                        CR.ACTION_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CATEGORY.MONEY#">
                                </cfquery>
                                <cfif get_money_id.recordcount >
                                    <cfset kayit_varmi = 1 >
                                </cfif>
                            </cfif>
                            <cfif kayit_varmi eq 0 >
                                <cfquery name="GET_MONEY_ID" datasource="#DSN#" maxrows="1">
                                    SELECT TOP 1 PS.MONEY
                                    FROM
                                        #dsn#_#get_setup_period.our_company_id#.PRICE_STANDART AS PS
                                    WHERE
                                        PS.MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CATEGORY.MONEY#">
                                </cfquery>						
                                <cfif get_money_id.recordcount >
                                    <cfset kayit_varmi = 1 >
                                </cfif>
                            </cfif>
                        </cfloop>
                    </cfif>
                    <cfif kayit_varmi eq 0 >
                        <cfquery name="GET_MONEY_ID" datasource="#DSN#" maxrows="1">
                            SELECT TOP 1 MONEY
                            FROM
                                EMPLOYEES_SALARY
                            WHERE
                                MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CATEGORY.MONEY#">
                        </cfquery>						
                    </cfif>
                    <cfif kayit_varmi eq 1>
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='unformat_fields();kontrol()'> 
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_money_del&money_id=#url.id#' add_function='unformat_fields();kontrol()'>
                    </cfif>
                </cf_box_footer> 
            </cfform>
        </div>
    </cf_box>
</div>
<cfoutput>
<script type="text/javascript">
	function popup_account_ac(myflag)
	{
		if(myflag == 2)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=money.account_950&account_code=' + money.account_950.value,'list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=money.per_account&account_code=' + money.per_account.value,'list');
	}
	function kontrol()
	{
		if((document.getElementById('rate1').value == 1) && (document.getElementById('rate2').value == 1))
		{
			alert("<cf_get_lang no='1206.İki Yerel Para Birimi Olamaz!'>");
			return false;
		}
		if(document.getElementById('money').value == '')
		{
			alert("<cf_get_lang no='8.Para Birimi girmelisiniz'>");
			return false;
		}
		return true;
	}
	
		function unformat_fields()
		{
			document.getElementById('rate1').value = filterNum(document.getElementById('rate1').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('rate2').value = filterNum(document.getElementById('rate2').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('rate3').value = filterNum(document.getElementById('rate3').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('ratepp2').value = filterNum(document.getElementById('ratepp2').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('ratepp3').value = filterNum(document.getElementById('ratepp3').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('rateww2').value = filterNum(document.getElementById('rateww2').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('rateww3').value = filterNum(document.getElementById('rateww3').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('efectiveSatis').value = filterNum(document.getElementById('efectiveSatis').value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('efectiveAlis').value = filterNum(document.getElementById('efectiveAlis').value,'#session.ep.our_company_info.rate_round_num#');
            return true;
		}
	
</script>

</cfoutput>
 