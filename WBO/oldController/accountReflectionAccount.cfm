<cfset url_str = ''>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
</cfif> 
<cfquery name="get_refl_acc" datasource="#dsn2#">
	SELECT
    	CLOSED_ACCOUNT_CODE,
        CLAIM_ACCOUNT_CODE,
        DEBT_ACCOUNT_CODE
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1">   
        AND CLOSED_ACCOUNT_CODE IS NOT NULL
</cfquery>
<cfquery name="get_closed_acc" datasource="#dsn2#">
	SELECT
        CLAIM_ACCOUNT_CODE,
        DEBT_ACCOUNT_CODE
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
		AND CLOSED_ACCOUNT_CODE IS NULL
        AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
</cfquery>
<cfquery name="get_income_closed_acc" datasource="#dsn2#">
	SELECT
        CLAIM_ACCOUNT_CODE,
        DEBT_ACCOUNT_CODE
    FROM
    	ACCOUNT_CLOSED_DEFINITION
    WHERE
    	CLOSED_TYPE = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
		AND CLOSED_ACCOUNT_CODE IS NULL
        AND INCOME = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>
<!--- tablodaki hesapların alt hesapları çekiliyor --->

<cfif get_refl_acc.recordcount>
    <cfquery name="get_refl_sub_acc" datasource="#dsn2#">
        <cfoutput query="get_refl_acc">
            SELECT
                ACCOUNT_CODE AS CLAIM_ACCOUNT_CODE,
                '#get_refl_acc.DEBT_ACCOUNT_CODE#' AS DEBT_ACCOUNT_CODE,
                ISNULL(ACR1.BORC,0) - ISNULL(ACR2.ALACAK,0) AS BAKIYE
            FROM
                ACCOUNT_PLAN AP
                LEFT JOIN (
                    SELECT
                        <cfif not isdefined("attributes.is_other_money")>
                            SUM(AMOUNT) BORC,
                        <cfelse>
                            SUM(OTHER_AMOUNT) BORC,
                        </cfif>
                        ACCOUNT_ID
                    FROM
                        ACCOUNT_CARD_ROWS ACR LEFT JOIN ACCOUNT_CARD AC1 ON AC1.CARD_ID = ACR.CARD_ID
                    WHERE
                        BA = 0
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND AC1.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND AC1.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>                     
                    GROUP BY
                        ACCOUNT_ID) ACR1 ON ACR1.ACCOUNT_ID = AP.ACCOUNT_CODE
                LEFT JOIN (
                    SELECT
                        <cfif not isdefined("attributes.is_other_money")>
                            SUM(AMOUNT) ALACAK,
                        <cfelse>
                            SUM(OTHER_AMOUNT) ALACAK,
                        </cfif>
                        ACCOUNT_ID
                        ACCOUNT_ID
                    FROM
                        ACCOUNT_CARD_ROWS ACR LEFT JOIN ACCOUNT_CARD AC2 ON AC2.CARD_ID = ACR.CARD_ID
                    WHERE
                        BA = 1
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND AC2.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND AC2.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>                     
                    GROUP BY
                        ACCOUNT_ID) ACR2 ON ACR2.ACCOUNT_ID = AP.ACCOUNT_CODE
            WHERE
                (ACCOUNT_CODE = '#CLAIM_ACCOUNT_CODE#' OR ACCOUNT_CODE LIKE '#CLAIM_ACCOUNT_CODE#.%')
                
                AND ISNULL(ACR1.BORC,0) - ISNULL(ACR2.ALACAK,0) <> 0
            <cfif currentrow lt get_refl_acc.recordcount>
            UNION
            </cfif>
        </cfoutput>   
    </cfquery>
<cfelse>
	<cfset get_refl_sub_acc.recordcount = 0>
</cfif>
<cfif get_closed_acc.recordcount>
    <cfquery name="get_refl_sub_acc_closed" datasource="#dsn2#">
        <cfoutput query="get_closed_acc">
            SELECT
                ACCOUNT_CODE AS CLAIM_ACCOUNT_CODE,
                '#get_closed_acc.DEBT_ACCOUNT_CODE#' AS DEBT_ACCOUNT_CODE,
                ISNULL(ACR1.BORC,0) - ISNULL(ACR2.ALACAK,0) AS BAKIYE
            FROM
                ACCOUNT_PLAN AP
                LEFT JOIN (
                    SELECT
                        <cfif not isdefined("attributes.is_other_money")>
                            SUM(AMOUNT) BORC,
                        <cfelse>
                            SUM(OTHER_AMOUNT) BORC,
                        </cfif>
                        ACCOUNT_ID
                        ACCOUNT_ID
                    FROM
                        ACCOUNT_CARD_ROWS ACR LEFT JOIN ACCOUNT_CARD AC1 ON AC1.CARD_ID = ACR.CARD_ID
                    WHERE
                        BA = 0
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND AC1.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND AC1.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>                     
                    GROUP BY
                        ACCOUNT_ID) ACR1 ON ACR1.ACCOUNT_ID = AP.ACCOUNT_CODE
                LEFT JOIN (
                    SELECT
                        <cfif not isdefined("attributes.is_other_money")>
                            SUM(AMOUNT) ALACAK,
                        <cfelse>
                            SUM(OTHER_AMOUNT) ALACAK,
                        </cfif>
                        ACCOUNT_ID
                        ACCOUNT_ID
                    FROM
                        ACCOUNT_CARD_ROWS ACR LEFT JOIN ACCOUNT_CARD AC2 ON AC2.CARD_ID = ACR.CARD_ID
                    WHERE
                        BA = 1
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND AC2.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND AC2.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>                     
                    GROUP BY
                        ACCOUNT_ID) ACR2 ON ACR2.ACCOUNT_ID = AP.ACCOUNT_CODE
            WHERE
                (ACCOUNT_CODE = '#CLAIM_ACCOUNT_CODE#' OR ACCOUNT_CODE LIKE '#CLAIM_ACCOUNT_CODE#.%')
                
                AND ISNULL(ACR1.BORC,0) - ISNULL(ACR2.ALACAK,0) <> 0
            <cfif currentrow lt get_closed_acc.recordcount>
            UNION
            </cfif>
        </cfoutput>       
    </cfquery>
    
<cfelse>
	<cfset get_refl_sub_acc_closed.recordcount = 0>
</cfif> 
<cfif get_income_closed_acc.recordcount>
    <cfquery name="get_income_refl_sub_acc" datasource="#dsn2#">
        <cfoutput query="get_income_closed_acc">
            SELECT
                ACCOUNT_CODE AS CLAIM_ACCOUNT_CODE,
                '#get_income_closed_acc.DEBT_ACCOUNT_CODE#' AS DEBT_ACCOUNT_CODE,
                ISNULL(ACR1.BORC,0) - ISNULL(ACR2.ALACAK,0) AS BAKIYE
            FROM
                ACCOUNT_PLAN AP
                LEFT JOIN (
                    SELECT
                        <cfif not isdefined("attributes.is_other_money")>
                            SUM(AMOUNT) BORC,
                        <cfelse>
                            SUM(OTHER_AMOUNT) BORC,
                        </cfif>
                        ACCOUNT_ID
                    FROM
                        ACCOUNT_CARD_ROWS ACR LEFT JOIN ACCOUNT_CARD AC1 ON AC1.CARD_ID = ACR.CARD_ID
                    WHERE
                        BA = 0
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND AC1.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND AC1.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>                     
                    GROUP BY
                        ACCOUNT_ID) ACR1 ON ACR1.ACCOUNT_ID = AP.ACCOUNT_CODE
                LEFT JOIN (
                    SELECT
                        <cfif not isdefined("attributes.is_other_money")>
                            SUM(AMOUNT) ALACAK,
                        <cfelse>
                            SUM(OTHER_AMOUNT) ALACAK,
                        </cfif>
                        ACCOUNT_ID
                        ACCOUNT_ID
                    FROM
                        ACCOUNT_CARD_ROWS ACR LEFT JOIN ACCOUNT_CARD AC2 ON AC2.CARD_ID = ACR.CARD_ID
                    WHERE
                        BA = 1
                        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND AC2.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
                        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND AC2.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>                     
                    GROUP BY
                        ACCOUNT_ID) ACR2 ON ACR2.ACCOUNT_ID = AP.ACCOUNT_CODE
            WHERE
                (ACCOUNT_CODE = '#CLAIM_ACCOUNT_CODE#' OR ACCOUNT_CODE LIKE '#CLAIM_ACCOUNT_CODE#.%')
               
                AND ISNULL(ACR1.BORC,0) - ISNULL(ACR2.ALACAK,0) <> 0
            <cfif currentrow lt get_income_closed_acc.recordcount>
            UNION
            </cfif>
        </cfoutput>   
    </cfquery>
<cfelse>
	<cfset get_income_refl_sub_acc.recordcount = 0>
</cfif>   
<cfif get_refl_acc.recordcount>
<cfquery name="GET_ACC_REMAINDER" datasource="#dsn2#" >
	SELECT SUM(BAKIYE) AS BAKIYE
	,SUM(BORC) AS BORC
	,SUM(ALACAK) AS ALACAK
	,ACCOUNT_CODE
	,ACCOUNT_NAME
	,ACCOUNT_ID
	,SUB_ACCOUNT
FROM (
	SELECT SUB_ACCOUNT
		,ROUND(SUM(BORC - ALACAK), 2) AS BAKIYE
		,ROUND(SUM(BORC), 2) AS BORC
		,ROUND(SUM(ALACAK), 2) AS ALACAK
		,ACCOUNT_CODE
		,ACCOUNT_NAME
		,ACCOUNT_ID
	FROM (
		SELECT ACCOUNT_PLAN.ACCOUNT_CODE
			,SUB_ACCOUNT
			,BORC
			,ALACAK
			,ACCOUNT_NAME
			,ACCOUNT_PLAN.ACCOUNT_ID
		FROM ACCOUNT_ACCOUNT_REMAINDER AS ACCOUNT_ACCOUNT_REMAINDER
			,ACCOUNT_PLAN
		WHERE 1 = 1
			<cfoutput query="get_refl_acc">AND (
				( 
					1 = 1
					AND ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_sub_acc.CLAIM_ACCOUNT_CODE#'
					AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_sub_acc.DEBT_ACCOUNT_CODE#'
                    
					)
				)</cfoutput>
			AND (
				(
					(
						(
							LEN(ACCOUNT_PLAN.ACCOUNT_CODE) >= 3
							AND CHARINDEX('.', ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID) > 0
							AND ACCOUNT_PLAN.SUB_ACCOUNT = 1
							AND ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID, LEN(ACCOUNT_PLAN.ACCOUNT_CODE))
							AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE + '.%'
							)
						)
					)
				)
		
		UNION ALL
		
		SELECT ACCOUNT_PLAN.ACCOUNT_CODE
			,SUB_ACCOUNT
			,BORC
			,ALACAK
			,ACCOUNT_NAME
			,ACCOUNT_PLAN.ACCOUNT_ID
		FROM ACCOUNT_ACCOUNT_REMAINDER AS ACCOUNT_ACCOUNT_REMAINDER
			,ACCOUNT_PLAN
		WHERE 1 = 1
			<cfoutput query="get_refl_acc">AND (
				(
					1 = 1
					AND ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_sub_acc.CLAIM_ACCOUNT_CODE#'
					AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_sub_acc.DEBT_ACCOUNT_CODE#'
					)
				)</cfoutput>
			AND (
				(
					(
						(
							CHARINDEX('.', ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID) = 0
							AND ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID, LEN(ACCOUNT_PLAN.ACCOUNT_CODE))
							)
						)
					)
				)
			AND (
				SELECT COUNT(ACC.ACCOUNT_ID)
				FROM ACCOUNT_PLAN ACC
				WHERE ACC.ACCOUNT_CODE LIKE ACCOUNT_PLAN.ACCOUNT_CODE + '.%'
				) > 1
		
		UNION ALL
		
		SELECT ACCOUNT_PLAN.ACCOUNT_CODE
			,SUB_ACCOUNT
			,BORC
			,ALACAK
			,ACCOUNT_NAME
			,ACCOUNT_PLAN.ACCOUNT_ID
		FROM ACCOUNT_ACCOUNT_REMAINDER AS ACCOUNT_ACCOUNT_REMAINDER
			,ACCOUNT_PLAN
		WHERE 1 = 1
		<cfoutput query="get_refl_acc">	AND (
				(
					1 = 1
					AND ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_sub_acc.CLAIM_ACCOUNT_CODE#'
					AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_sub_acc.DEBT_ACCOUNT_CODE#'
					)
				)</cfoutput>
			AND (
				(
					(
						(
							LEN(ACCOUNT_PLAN.ACCOUNT_CODE) < 3
							AND ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID LIKE ACCOUNT_PLAN.ACCOUNT_CODE + '.%'
							)
						)
					)
				)
		
		UNION ALL
		
		SELECT ACCOUNT_PLAN.ACCOUNT_CODE
			,SUB_ACCOUNT
			,BORC
			,ALACAK
			,ACCOUNT_NAME
			,ACCOUNT_PLAN.ACCOUNT_ID
		FROM  ACCOUNT_ACCOUNT_REMAINDER AS ACCOUNT_ACCOUNT_REMAINDER
			,ACCOUNT_PLAN
		WHERE 1 = 1
			<cfoutput query="get_refl_acc">AND (
				(
					1 = 1
					AND ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_sub_acc.CLAIM_ACCOUNT_CODE#'
					AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_sub_acc.DEBT_ACCOUNT_CODE#'
					)
				)</cfoutput>
			AND (ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID)
		) AS XXX
	GROUP BY ACCOUNT_CODE
		,ACCOUNT_NAME
		,ACCOUNT_ID
		,SUB_ACCOUNT
	) T1
GROUP BY ACCOUNT_CODE
	,ACCOUNT_NAME
	,ACCOUNT_ID
	,SUB_ACCOUNT
ORDER BY ACCOUNT_CODE
</cfquery>
<cfset deneme =''>
<cfset deneme1 = ''>
<cfoutput query="get_refl_sub_acc">
<cfset deneme = #ListAppend(deneme,get_refl_sub_acc.BAKIYE)# >
</cfoutput>
<cfoutput query="GET_ACC_REMAINDER">
<cfset deneme1 = #ListAppend(deneme1,GET_ACC_REMAINDER.BAKIYE)# >
</cfoutput>
</cfif>
<cfif get_refl_sub_acc.recordcount>

<cfquery name="deneme11" dbtype="query">

	SELECT
    	get_refl_sub_acc.CLAIM_ACCOUNT_CODE AS ACCOUNT_CODE,
        GET_ACC_REMAINDER.ALACAK AS alacak,
        GET_ACC_REMAINDER.BORC AS borc,
        (GET_ACC_REMAINDER.ALACAK - GET_ACC_REMAINDER.BORC) AS alacak_hesap,
        get_refl_sub_acc.BAKIYE AS bakiye,
        GET_ACC_REMAINDER.BAKIYE ,
        (GET_ACC_REMAINDER.BAKIYE - get_refl_sub_acc.BAKIYE) AS RESULT,
        *
    FROM
    get_refl_sub_acc,
    	GET_ACC_REMAINDER
        
    WHERE
        ((GET_ACC_REMAINDER.ALACAK - get_refl_sub_acc.BAKIYE) > 0.01 OR (GET_ACC_REMAINDER.ALACAK - get_refl_sub_acc.BAKIYE) < -0.01) AND
        GET_ACC_REMAINDER.ACCOUNT_CODE = get_refl_sub_acc.CLAIM_ACCOUNT_CODE
         
</cfquery>
<cfif GET_ACC_REMAINDER.ALACAK neq 0>
<cfset deneme11.recordcount=0>
</cfif>
<cfelse>
<cfset deneme11.recordcount=0>
</cfif>

<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.form_add_reflecting_account';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/form_add_reflecting_account.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_reflecting_account.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.form_add_reflecting_account';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountIncomeClosing';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2']"; 

</cfscript>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('process_date').value == '')
		{
			alert('<cf_get_lang dictionary_id="59298.Lütfen işlem tarihi giriniz">!');		
			return false;
		}
		if(document.getElementById('card_type').value == '')
		{
			alert('<cf_get_lang dictionary_id="59299.Lütfen fiş türü seçiniz">!');
			return false;
		}
		return true;
	}
</script>
