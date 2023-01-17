<cf_get_lang_set module_name="bank">
<cfif not isDefined('attributes.event') or attributes.event is 'list'>
	<cfif isdefined("attributes.form_submitted")>
        <cfquery name="GET_BRANCHES" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
            SELECT DISTINCT
            	BANK_BRANCH.BANK_BRANCH_CITY,
                BANK_BRANCH.BANK_BRANCH_ID,
                BANK_BRANCH.BANK_BRANCH_NAME,
                BANK_BRANCH.BANK_NAME,
                BANK_BRANCH.BRANCH_CODE,
                BANK_BRANCH.CONTACT_PERSON,
                SETUP_BANK_TYPES.BANK_CODE
            FROM
                BANK_BRANCH,
                #dsn_alias#.SETUP_BANK_TYPES SETUP_BANK_TYPES
            WHERE
                BANK_BRANCH.BANK_ID = SETUP_BANK_TYPES.BANK_ID AND
                BANK_BRANCH.BANK_BRANCH_ID IS NOT NULL
            <cfif isDefined("attributes.bank") and len(attributes.bank)>
                AND BANK_BRANCH.BANK_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank#">
            </cfif>
            <cfif not isdefined("attributes.is_bank_account")>
                <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND
                    (
                        BANK_BRANCH.BANK_BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        BANK_BRANCH.BRANCH_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        BANK_BRANCH.BANK_BRANCH_CITY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        BANK_BRANCH.BANK_BRANCH_ADDRESS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        BANK_BRANCH.CONTACT_PERSON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                    )
                </cfif>
            </cfif>
            ORDER BY
                BANK_BRANCH.BANK_BRANCH_NAME
        </cfquery>
    <cfelse>
        <cfset get_branches.recordcount=0>
    </cfif>
    <cfquery name="GET_BANKS" datasource="#DSN3#">
        SELECT
            DISTINCT(BANK_NAME)
        FROM
            BANK_BRANCH
        ORDER BY
            BANK_NAME
    </cfquery>
    <cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfparam name="attributes.bank" default=''>
	<cfparam name="attributes.keyword" default=''>
	<cfparam name="attributes.totalrecords" default='#get_branches.recordcount#'>
	<cfif fuseaction contains "popup">
		<cfset is_popup=1>
	<cfelse>
		<cfset is_popup=0>
	</cfif>
	<cfset url_str = "#fusebox.circuit#.list_bank_branch">
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.bank") and len(attributes.bank)>
		<cfset url_str = "#url_str#&bank=#attributes.bank#">
	</cfif>
	<cfset url_str = "#url_str#&form_submitted=1">
<cfelseif isDefined('attributes.event') and (attributes.event is 'add' or attributes.event is 'upd')>
	<cfquery name="GET_BANK_TYPES" datasource="#DSN#">
		SELECT 
			BANK_ID,
			BANK_NAME
		FROM 
			SETUP_BANK_TYPES 
		WHERE 
			BANK_ID IS NOT NULL		
	</cfquery>
	<cfif attributes.event is 'upd'>
	    <cfquery name="GET_BRANCH_DETAIL" datasource="#dsn3#">
	        SELECT
	        	BANK_BRANCH_ADDRESS,
	        	BANK_BRANCH_CITY,
	        	BANK_BRANCH_COUNTRY,
	        	BANK_BRANCH_NAME,
	        	BANK_BRANCH_POSTCODE,
	        	BANK_BRANCH_TEL,
	            BANK_ID,
	            BRANCH_CODE,
	            COMPBRANCH_ID,
	            CONTACT_PERSON,
	            RECORD_DATE,
	            RECORD_EMP,
	            SWIFT_CODE,
	            UPDATE_DATE,
	            UPDATE_EMP
	        FROM
	            BANK_BRANCH
	        WHERE
	            BANK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">	
	    </cfquery>
	    <cfif isdefined("get_branch_detail.bank_id")>
			<cfset attributes.bank_id = get_branch_detail.bank_id>
		</cfif>
		<cfif isDefined('attributes.bank_id')>
		    <cfquery name="get_company_info" datasource="#dsn#">
		        SELECT
		            C.FULLNAME,
		            C.COMPANY_ID
		        FROM
		            COMPANY C,
		            SETUP_BANK_TYPES SB
		        WHERE
		            C.COMPANY_ID = SB.COMPANY_ID
		            AND SB.BANK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bank_id#">
		    </cfquery>
			<cfif get_company_info.recordcount>
		        <cfquery name="GET_COMP_BRANCH" datasource="#DSN#">
		            SELECT COMPBRANCH_ID,COMPBRANCH__NAME FROM COMPANY_BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_company_info.company_id#">
		        </cfquery>
		    </cfif>
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and (attributes.event is 'add' or attributes.event is 'upd')>
		function kontrol()
		{
			document.getElementById('bank_name').disabled = false;
			a = document.getElementById('bank_name').options.selectedIndex;
			if (document.getElementById('bank_name').options[a].value =='')
			{	
				alert("<cf_get_lang no ='88.Banka Seçiniz'> !");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isDefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_add_bank_branch';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/add_branch.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/add_branch.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#iif(fusebox.circuit eq "ehesap",DE("ehesap"),DE("finance"))#.list_bank_branch&event=upd';

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'bank.popup_upd_bank_branch';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'bank/form/upd_branch.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'bank/query/upd_branch.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#iif(fusebox.circuit eq "ehesap",DE("ehesap"),DE("finance"))#.list_bank_branch&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_branch_detail.bank_branch_name##';
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.del_bank_branch&id=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'bank/query/del_bank_branch.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'bank/query/del_bank_branch.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#iif(fusebox.circuit eq "ehesap",DE("ehesap"),DE("finance"))#.list_bank_branch';
	}
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.list_bank_branch';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'bank/display/list_branches.cfm';
	
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=finance.list_bank_branch&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'bankBranch';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'BANK_BRANCH';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-bank_name','item-bank_branch_name','item-bank_branch_city']";
</cfscript>
