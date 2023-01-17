<cf_get_lang_set module_name="account">
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT 
		BRANCH_ID,BRANCH_NAME 
	FROM 
		BRANCH 
	WHERE
		BRANCH_STATUS = 1 
		AND COMPANY_ID = #session.ep.company_id#
	<cfif listgetat(attributes.fuseaction,1,'.') is 'store'>
		AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	</cfif>
	ORDER BY BRANCH_NAME
</cfquery>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.search_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cf_date tarih="attributes.search_date">
<cfif isdefined("is_submitted")>
	<cfquery name="GET_COST_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=9
</cfquery>
<cfset selected_list=get_cost_def.DEF_SELECTED_ROWS>
<cfset inv_rem=get_cost_def.INVERSE_REMAINDER>
<cfquery name="GET_COST_TABLE" datasource="#dsn2#">
	SELECT 
    	COST_ID, 
        CODE, 
        NAME, 
        ACCOUNT_CODE, 
        SIGN, 
        BA, 
        VIEW_AMOUNT_TYPE, 
        ZERO, 
        ADD_, 
        IFRS_CODE, 
        NAME_LANG_NO 
    FROM 
    	COST_TABLE			
</cfquery>
<cfset view_amount_type=get_cost_table.VIEW_AMOUNT_TYPE>
<cfelse>
	<cfset get_cost_def.recordcount=0>
	<cfset GET_COST_TABLE.recordcount=0>
</cfif>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfif isdefined("is_submitted")>
	<cfif get_cost_def.recordcount>
		<cfquery name="GET_BAKIYE_ALL" DATASOURCE="#DSN2#" >
			SELECT
				SUM(BAKIYE) AS BAKIYE,
				SUM(BORC) AS BORC,
				SUM(ALACAK) AS ALACAK,
				ACCOUNT_CODE
			FROM
			(
				SELECT
					SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
					SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
					SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
					SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2 - ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS BAKIYE_2, 
					SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC_2) AS BORC_2,
					SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK_2) AS ALACAK_2, 
					ACCOUNT_PLAN.ACCOUNT_CODE, 
					ACCOUNT_PLAN.ACCOUNT_NAME,
					ACCOUNT_PLAN.ACCOUNT_ID,
					ACCOUNT_PLAN.IFRS_CODE, 
					ACCOUNT_PLAN.IFRS_NAME,
					ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
					ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
					ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID	
				FROM
					ACCOUNT_PLAN,
					(
						SELECT
							0 AS ALACAK,
							0 AS ALACAK_2,
							SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,			
							SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS BORC_2,
							ACCOUNT_CARD_ROWS.ACCOUNT_ID,
							ACCOUNT_CARD.ACTION_DATE,
							ACCOUNT_CARD.CARD_TYPE,
							ACCOUNT_CARD.CARD_CAT_ID
						FROM
							ACCOUNT_CARD_ROWS,ACCOUNT_CARD
						WHERE
							BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
							<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
								AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
							</cfif>
							<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
								AND (
								<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
									(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
									<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
								</cfloop>  
									)
							</cfif>	
						GROUP BY
							ACCOUNT_CARD_ROWS.ACCOUNT_ID,
							ACCOUNT_CARD.ACTION_DATE,
							ACCOUNT_CARD.CARD_TYPE,
							ACCOUNT_CARD.CARD_CAT_ID
						
						UNION
						
						SELECT
							SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK, 
							SUM(ISNULL(ACCOUNT_CARD_ROWS.AMOUNT_2,0)) AS ALACAK_2,
							0 AS BORC,
							0 AS BORC_2,
							ACCOUNT_CARD_ROWS.ACCOUNT_ID,
							ACCOUNT_CARD.ACTION_DATE,
							ACCOUNT_CARD.CARD_TYPE,
							ACCOUNT_CARD.CARD_CAT_ID
						FROM
							ACCOUNT_CARD_ROWS,
							ACCOUNT_CARD
						WHERE
							BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
							<cfif isdefined('attributes.acc_branch_id') and len(attributes.acc_branch_id)>
								AND ACCOUNT_CARD_ROWS.ACC_BRANCH_ID IN(#attributes.acc_branch_id#)
							</cfif>
							<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)><!---muhasebe işlem kategorilerine gore arama --->
								AND (
								<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
									(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
									<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
								</cfloop>  
									)
							</cfif>	
						GROUP BY
							ACCOUNT_CARD_ROWS.ACCOUNT_ID,
							ACCOUNT_CARD.ACTION_DATE,
							ACCOUNT_CARD.CARD_TYPE,
							ACCOUNT_CARD.CARD_CAT_ID
					)ACCOUNT_ACCOUNT_REMAINDER
				WHERE
					(
						(ACCOUNT_PLAN.SUB_ACCOUNT=1 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE +'%')
						OR
						(ACCOUNT_PLAN.SUB_ACCOUNT=0 AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE)
					)
					AND CARD_TYPE <> 19
				GROUP BY
					ACCOUNT_PLAN.ACCOUNT_CODE, 
					ACCOUNT_PLAN.ACCOUNT_NAME,
					ACCOUNT_PLAN.IFRS_CODE, 
					ACCOUNT_PLAN.IFRS_NAME,
					ACCOUNT_PLAN.ACCOUNT_ID, 
					ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE,
					ACCOUNT_ACCOUNT_REMAINDER.CARD_TYPE,
					ACCOUNT_ACCOUNT_REMAINDER.CARD_CAT_ID
			)T1
			<cfif len(attributes.search_date)>
				WHERE ACTION_DATE <= #attributes.search_date#
			</cfif>
			GROUP BY
				ACCOUNT_CODE
		</cfquery>
		<cfquery name="GET_COST_TABLE_ALL" DATASOURCE="#DSN2#">
			SELECT 
				ZERO,
				ACCOUNT_CODE,
				SIGN,
				CODE,
				COST_ID,
				ADD_
			FROM COST_TABLE
		</cfquery>
		<cfquery name="GET_TOTAL_ACCOUNT" DATASOURCE="#DSN2#">
			SELECT 
				ACR.BA,
				ACR.AMOUNT,
				ACR.ACCOUNT_ID
			FROM
				ACCOUNT_CARD AC,
				ACCOUNT_CARD_ROWS ACR
			WHERE 
				AC.CARD_ID=ACR.CARD_ID		
		</cfquery>	
	</cfif>
</cfif>	
<script type="text/javascript">
	function save_cost_table()
	{
		if (document.getElementById("search_date").value=='')
		{
			alert("<cf_get_lang no ='197.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date2 = document.getElementById("search_date").value;
		fintab_type_ = document.getElementById("fintab_type").value;
		windowopen('<cfoutput>#request.self#?fuseaction=account.list_cost_table&event=add&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date2='+date2,'small');
	}
</script>
<cfif IsDefined("attributes.event") and attributes.event eq 'add'>
	<script type="text/javascript">
		function kontrol()
		{
			if(document.getElementById("user_given_name").value == "")
			{
				alert("<cf_get_lang_main no ='782.Zorunlu Alan'>:<cf_get_lang no ='91.Tablo Adi'>");
				return false;
			}
			return true;
		}
		function get_content()
		{
			document.getElementById("cons_last").value = window.opener.document.getElementById("cons_last").value;
		}
		$(document).ready(function(e) {
		   get_content();
		})
	</script>
</cfif>
 <cfif IsDefined("attributes.event") and attributes.event eq 'det'>
	<cfquery name="GET_RECORDS" datasource="#DSN3#">
        SELECT
            TABLE_NAME,
            USER_GIVEN_NAME,
            SOURCE,
            RECORD_DATE
        FROM
            SAVE_ACCOUNT_TABLES
        WHERE
            SAVE_ID=#attributes.id#
    </cfquery>
	<script type="text/javascript">
		$(document).ready(function(e) {
		   $('.footermenus td:first').attr('colspan',2) 
		});
	</script>
</cfif> 
<cfscript>
	// Switch //
	WWOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_cost_table';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_cost_table.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.list_cost_table';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_financial_table.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_save_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_cost_table';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'account.list_cost_table';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'account/display/detail_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'account/display/detail_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'account.list_cost_table';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'costTable';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SAVE_ACCOUNT_TABLES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2']"; 
</cfscript>
