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
<cfparam name="attributes.search_date" default="#dateformat(now(),'dd/mm/yyyy')#">
<cfparam name="attributes.search_start_date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.table_code_type" default="0">
<cfparam name="attributes.is_submitted" default="0">
<cfparam name="attributes.acc_card_type" default="">
<cfif isdate(attributes.search_date)>
	<cf_date tarih = "attributes.search_date">
</cfif>
<cfif isdate(attributes.search_start_date)>
	<cf_date tarih = "attributes.search_start_date">
</cfif>
<cfif attributes.is_submitted eq 1>
	<cfquery name="GET_INCOME_DEF" datasource="#dsn2#">
	SELECT
		DEF_SELECTED_ROWS,
		INVERSE_REMAINDER
	FROM
		ACCOUNT_DEFINITIONS
	WHERE
		DEF_TYPE_ID=7
		AND DEF_SELECTED_ROWS IS NOT NULL
		AND DEF_SELECTED_ROWS <> ''
</cfquery>
<cfif GET_INCOME_DEF.RECORDCOUNT>
	<cfset selected_list=get_income_def.DEF_SELECTED_ROWS>
	<cfset inv_rem=get_income_def.INVERSE_REMAINDER>
	<cfquery name="GET_INCOME_TABLE" datasource="#dsn2#">
		SELECT
			INCOME_ID,CODE,NAME,NAME_LANG_NO,
			<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
				IFRS_CODE AS ACCOUNT_CODE,
			<cfelse>
				ACCOUNT_CODE,
			</cfif>
			SIGN,BA,VIEW_AMOUNT_TYPE
		FROM
			INCOME_TABLE
		WHERE
			INCOME_ID IN (#SELECTED_LIST#) OR
			<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
				IFRS_CODE IS NULL
			<cfelse>
				ACCOUNT_CODE IS NULL
			</cfif>
		ORDER BY 
			INCOME_TABLE.CODE 
	</cfquery>
	<cfset view_amount_type=get_income_table.VIEW_AMOUNT_TYPE>
<cfelse>
	<cfset selected_list = ''>
	<cfset inv_rem = ''>
	<cfquery name="GET_INCOME_TABLE" datasource="#dsn2#">
		SELECT
			INCOME_ID,CODE,NAME,NAME_LANG_NO,
			<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
			IFRS_CODE AS ACCOUNT_CODE,
			<cfelse>
			ACCOUNT_CODE,
			</cfif>
			SIGN,BA,VIEW_AMOUNT_TYPE
		FROM
			INCOME_TABLE
		ORDER BY 
			INCOME_TABLE.CODE 
	</cfquery>
</cfif>
<cfelse>
	<cfset GET_INCOME_DEF.recordcount=0>
	<cfset get_income_table.recordcount=0>
</cfif>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfif attributes.is_submitted eq 1>
	<cfif GET_INCOME_DEF.RECORDCOUNT>
	<cfset acc_list_=listdeleteduplicates(Valuelist(get_income_table.account_code))>
	<cfquery name="GET_BAKIYE_ALL" DATASOURCE="#DSN2#" >
		SELECT 
			SUM(BAKIYE) AS BAKIYE,
			SUM(BORC) AS BORC,
			SUM(ALACAK) AS ALACAK,
			<cfif isdefined('attributes.is_system_money_2') and attributes.is_system_money_2 eq 1>
				SUM(BAKIYE_2) BAKIYE_2,
				SUM(BORC_2) BORC_2,
				SUM(ALACAK_2) ALACAK_2,
			</cfif>
			<cfif attributes.table_code_type eq 0>
				ACCOUNT_CODE
			<cfelse>
				IFRS_CODE AS ACCOUNT_CODE
			</cfif>
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
		)t1
		WHERE
		<cfif len(acc_list_)>
			ACCOUNT_CODE IN (#ListQualify(acc_list_,"'",",")#)
		<cfelse>
			ACCOUNT_CODE IS NULL
		</cfif>
		<cfif len(attributes.search_date)>
			 AND ACTION_DATE <= #attributes.search_date#
		</cfif>	
		<cfif len(attributes.search_start_date)>
			AND ACTION_DATE >= #attributes.search_start_date#
		</cfif>	
		GROUP BY
			<cfif attributes.table_code_type eq 0>
				ACCOUNT_CODE
			<cfelse>
				IFRS_CODE
			</cfif>
	</cfquery>
	<cfquery name="GET_INCOME_TABLE_ALL" datasource="#dsn2#">
		SELECT  
			ACCOUNT_CODE,
			CODE,
			INCOME_ID
		FROM INCOME_TABLE
	</cfquery>
    </cfif>	
</cfif>	
<script type="text/javascript">
	function save_income_table()
	{
		if((document.getElementById("search_start_date").value=='') || (document.getElementById("search_date").value==''))
		{
			alert("<cf_get_lang no ='197.Önce Tarihleri Seçiniz'>!");
			return false;
		}
		date1 = document.getElementById("search_start_date").value;
		date2 = document.getElementById("search_date").value;
		fintab_type_ = document.getElementById("fintab_type").value;
		windowopen('<cfoutput>#request.self#?fuseaction=account.list_income_table&event=add&module=#fusebox.circuit#&faction=#fusebox.fuseaction#</cfoutput>&fintab_type='+fintab_type_+'&date1='+date1+'&date2='+date2,'small');
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
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_income_table';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/income_table_last.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.list_income_table';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/add_financial_table.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_save_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_income_table';
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'account.list_income_table';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'account/display/detail_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'account/display/detail_fintab.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'account.list_income_table';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'id=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.id##';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'incomeTable';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SAVE_ACCOUNT_TABLES';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-2']"; 
</cfscript>

