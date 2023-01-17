<cfsetting showdebugoutput="no">
<cf_date tarih="attributes.startdate">
<cfquery name="get_period" datasource="#dsn#">
    SELECT 
        SP.PERIOD_ID 
    FROM 
        SETUP_PERIOD SP INNER JOIN OUR_COMPANY OC ON SP.OUR_COMPANY_ID = OC.COMP_ID
        INNER JOIN BRANCH B ON OC.COMP_ID = B.COMPANY_ID
    WHERE
        B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
        SP.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(attributes.startdate)#">
</cfquery>
<cfif get_period.recordcount>
	<cfscript>
        cmp = createObject("component","V16.hr.cfc.create_account_period");
        cmp.dsn = dsn;
        get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:attributes.branch_id,department_id:attributes.department_id);
        if(not get_acc_def.recordcount)
        {
            get_acc_def = cmp.get_account_definition(period_id : get_period.period_id,branch_id:attributes.branch_id);
        }	
        if(get_acc_def.recordcount)
        {
            get_account_bill_type = cmp.get_account_definiton_code_row(account_definition_id:get_acc_def.id);
        }
        else
        {
            get_account_bill_type.recordcount = 0;	
        }
    </cfscript>
    <cfif get_account_bill_type.recordcount>
        <input type="hidden" name="account_bill_type_count" id="account_bill_type_count" value="<cfoutput>#get_account_bill_type.recordcount#</cfoutput>">
        <b><cf_get_lang dictionary_id='54117.Muhasebe Kod Grubu'></b><br />
        <cfoutput query="get_account_bill_type">
        <label class="col col-4 col-xs-12"></label>
        <input type="radio" name="account_bill_type" id="account_bill_type" value="#account_bill_type#" <cfif currentrow eq 1> checked="checked"</cfif>> #definition#
        <br />
        </cfoutput>
    <cfelse>
        <input type="hidden" name="account_bill_type_count" id="account_bill_type_count" value="0">
    </cfif>
</cfif>
