<cfquery name="get_money_bskt" datasource="#dsn#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE COMPANY_ID = #session.ep.company_id# AND PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfoutput query="get_money_bskt">
	<cfset 'money_rate_#money#' = (rate2/rate1)>
</cfoutput>
<cfif not (isdefined('attributes.date1') and isdate(attributes.date1))>
	<cfset attributes.date1 = "01/#month(now())#/#session.ep.period_year#" >
</cfif>
<cfif not (isdefined('attributes.date2') and isdate(attributes.date2))>
	<cfset attributes.date2 = "#daysinmonth(now())#/#month(now())#/#session.ep.period_year#" >
</cfif>
<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cf_date tarih = "attributes.date1" >
	<cf_date tarih = "attributes.date2" >	
</cfif>
<cfparam name="attributes.code1" default="">
<cfparam name="attributes.code2" default="">
<cfparam name="attributes.action_date" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.duty_claim" default="">
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="GET_ACC_REMAINDER" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
        SELECT
            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS BAKIYE, 
            SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC) AS BORC,
            SUM(ACCOUNT_ACCOUNT_REMAINDER.ALACAK) AS ALACAK, 
            SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC - ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK) AS OTHER_BAKIYE, 
            SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_BORC) AS OTHER_BORC,
            SUM(ACCOUNT_ACCOUNT_REMAINDER.OTHER_AMOUNT_ALACAK) AS OTHER_ALACAK, 
            ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY,
            ACCOUNT_PLAN.ACCOUNT_CODE, 
            ACCOUNT_PLAN.ACCOUNT_NAME,
            ACCOUNT_PLAN.ACCOUNT_ID,
            ACCOUNT_PLAN.SUB_ACCOUNT
        FROM
            (
            SELECT
                0 AS ALACAK,
                SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS BORC,
                0 AS OTHER_AMOUNT_ALACAK,
                SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_BORC,
                ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_CURRENCY,
                ACCOUNT_CARD_ROWS.ACCOUNT_ID		
            FROM
                ACCOUNT_CARD_ROWS,ACCOUNT_CARD
            WHERE
                BA = 0 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
            <cfif isDefined("attributes.code1") and len(attributes.code1)>
                AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= '#attributes.code1#'
            </cfif>
            <cfif isDefined("attributes.code2") and len(attributes.code2)>
                AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= '#attributes.code2#'
            </cfif>
            <cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
                AND  (
                    ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#'
                    OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%'
                    )
            </cfif>
            <cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
                AND ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
            </cfif>
                <!--- AND ACTION_DATE > ISNULL(
                                    (SELECT 
                                        MAX(ACTION_DATE) ACTION_DATE
                                    FROM 
                                        ACCOUNT_CARD_ROWS ACR,
                                        ACCOUNT_CARD AC 
                                    WHERE 
                                        AC.CARD_ID=ACR.CARD_ID
                                        AND AC.IS_RATE_DIFF=1
                                        AND ACR.ACCOUNT_ID=ACCOUNT_CARD_ROWS.ACCOUNT_ID),#DATEADD('d',-1,attributes.DATE1)#) --->
            GROUP BY
                ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                ACCOUNT_CARD_ROWS.OTHER_CURRENCY
        UNION
            SELECT
                SUM(ACCOUNT_CARD_ROWS.AMOUNT) AS ALACAK,
                0 AS BORC,
                SUM(ISNULL(ACCOUNT_CARD_ROWS.OTHER_AMOUNT,0)) AS OTHER_AMOUNT_ALACAK,
                0 AS OTHER_AMOUNT_BORC,
                ISNULL(ACCOUNT_CARD_ROWS.OTHER_CURRENCY,'#session.ep.money#') AS OTHER_CURRENCY,
                ACCOUNT_CARD_ROWS.ACCOUNT_ID		
            FROM
                ACCOUNT_CARD_ROWS,ACCOUNT_CARD
            WHERE
                BA = 1 AND ACCOUNT_CARD.CARD_ID=ACCOUNT_CARD_ROWS.CARD_ID
            <cfif isDefined("attributes.code1") and len(attributes.code1)>
                AND ACCOUNT_CARD_ROWS.ACCOUNT_ID >= '#attributes.code1#'
            </cfif>
            <cfif isDefined("attributes.code2") and len(attributes.code2)>
                AND ACCOUNT_CARD_ROWS.ACCOUNT_ID <= '#attributes.code2#'
            </cfif>
            <cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
                AND  (
                    ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#'
                    OR ACCOUNT_CARD_ROWS.ACCOUNT_ID LIKE '#attributes.str_account_code#.%'
                    )
            </cfif>
            <cfif isDefined("attributes.date1") and isdate(attributes.date1) and isDefined("attributes.date2") and isdate(attributes.date2)>
                AND ACTION_DATE BETWEEN #attributes.DATE1# AND #attributes.DATE2#
            </cfif>
                <!--- AND ACTION_DATE > ISNULL(
                                    (SELECT 
                                        MAX(ACTION_DATE) ACTION_DATE
                                    FROM 
                                        ACCOUNT_CARD_ROWS ACR,
                                        ACCOUNT_CARD AC 
                                    WHERE 
                                        AC.CARD_ID=ACR.CARD_ID
                                        AND AC.IS_RATE_DIFF=1
                                        AND ACR.ACCOUNT_ID=ACCOUNT_CARD_ROWS.ACCOUNT_ID),#DATEADD('d',-1,attributes.DATE1)#) --->
            GROUP BY
                ACCOUNT_CARD_ROWS.ACCOUNT_ID,
                ACCOUNT_CARD_ROWS.OTHER_CURRENCY
            )
            AS ACCOUNT_ACCOUNT_REMAINDER,
            ACCOUNT_PLAN
        WHERE
                1=1
            <cfif isDefined("attributes.code1") and len(attributes.code1)>
                AND ACCOUNT_PLAN.ACCOUNT_CODE >= '#attributes.code1#'
            </cfif>
            <cfif isDefined("attributes.code2") and len(attributes.code2)>
                AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#attributes.code2#'
            </cfif>
            <cfif (isDefined("attributes.str_account_code") and len(attributes.str_account_code))>
                AND (
                    ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#'
                    OR ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.str_account_code#.%'
                    )
            </cfif>
            AND (
                    (
                    <cfif database_type is 'MSSQL'>
                        ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,LEN(ACCOUNT_PLAN.ACCOUNT_CODE))
                        AND substring(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,(LEN(ACCOUNT_PLAN.ACCOUNT_CODE)+1),1)='.'
                    <cfelseif database_type is 'DB2'>
                        AND ACCOUNT_PLAN.ACCOUNT_CODE = LEFT(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,LENGTH(ACCOUNT_PLAN.ACCOUNT_CODE))
                        AND substring(ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID,(LENGTH(ACCOUNT_PLAN.ACCOUNT_CODE)+1),1)='.'
                    </cfif>
                    )
                    OR ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID
                )
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                AND
                    (ACCOUNT_PLAN.ACCOUNT_NAME LIKE '#attributes.keyword#%'
                    OR
                    ACCOUNT_PLAN.ACCOUNT_CODE LIKE '#attributes.keyword#%')
            </cfif>
        GROUP BY
            ACCOUNT_PLAN.ACCOUNT_CODE, 
            ACCOUNT_PLAN.ACCOUNT_NAME,
            ACCOUNT_PLAN.ACCOUNT_ID,
            ACCOUNT_PLAN.SUB_ACCOUNT,
            ACCOUNT_ACCOUNT_REMAINDER.OTHER_CURRENCY
        <cfif isdefined('attributes.duty_claim') and attributes.duty_claim eq 1>
            HAVING SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) > 0
        <cfelseif isdefined('attributes.duty_claim') and attributes.duty_claim eq 2>
            HAVING SUM(ACCOUNT_ACCOUNT_REMAINDER.BORC - ACCOUNT_ACCOUNT_REMAINDER.ALACAK) < 0
        </cfif>
        ORDER BY 
            ACCOUNT_PLAN.ACCOUNT_CODE
    </cfquery>
	<cfparam name="attributes.totalrecords" default="#get_acc_remainder.recordcount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfif isdate(attributes.date1) and isdate(attributes.date2)>
	<cfset attributes.date1 = dateformat(attributes.date1,'dd/mm/yyyy')>
	<cfset attributes.date2 = dateformat(attributes.date2,'dd/mm/yyyy')>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
function pencere_ac_muavin(str_alan_1,str_alan_2,str_alan){
	var txt_keyword = eval(str_alan_1 + ".value" );
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id='+str_alan_1+'&field_id2='+str_alan_1+'&keyword='+txt_keyword,'list');
}
function acc_card_process()
{
	if(!CheckEurodate(add_acc_card.action_date.value,'İşlem Tarihi') || !add_acc_card.action_date.value.length) 
	{
		alert("<cf_get_lang_main no ='494.İşlem Tarihi Girmelisiniz'> !");
		return false;
	}
	windowopen('','wide','acc_card');
	add_acc_card.action='<cfoutput>#request.self#</cfoutput>?fuseaction=account.form_add_bill_cash2cash&var_=cash2cash_card';
	add_acc_card.target='acc_card';
	add_acc_card.submit();
	return true;
}
function control_diff_amount()
{	
	var diff_amount=0;				
	<cfoutput query="get_money_bskt">
		rate_#money# = filterNum(eval('add_acc_card.txt_rate2_#get_money_bskt.currentrow#').value,'#session.ep.our_company_info.rate_round_num#')/filterNum(eval('add_acc_card.txt_rate1_#get_money_bskt.currentrow#').value,'#session.ep.our_company_info.rate_round_num#');
	</cfoutput>
	<cfif isdefined('get_acc_remainder')>
	<cfoutput query="get_acc_remainder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif get_acc_remainder.SUB_ACCOUNT eq 0>
			<cfif len(get_acc_remainder.OTHER_BAKIYE) and get_acc_remainder.OTHER_BAKIYE neq 0 and len(get_acc_remainder.OTHER_CURRENCY)>
				<cfif ((OTHER_BORC gt OTHER_ALACAK) and (BORC gt ALACAK)) or ((OTHER_BORC lte OTHER_ALACAK) and (BORC lte ALACAK))>
					diff_amount = wrk_round( ((#abs(get_acc_remainder.OTHER_BAKIYE)#*eval('rate_#get_acc_remainder.OTHER_CURRENCY#') )-(#abs(get_acc_remainder.BAKIYE)#)));
				<cfelse>
					diff_amount = wrk_round( ((#abs(get_acc_remainder.OTHER_BAKIYE)#*eval('rate_#get_acc_remainder.OTHER_CURRENCY#') )+(#abs(get_acc_remainder.BAKIYE)#)));
				</cfif>
			<cfelse>
				diff_amount = #wrk_round(get_acc_remainder.BAKIYE)#;
			</cfif>
			if(diff_amount != 0)
			{
				add_acc_card.acc_diff_amount_#currentrow#.value=commaSplit(diff_amount); /*<!--- kur farkını sadece listede göstermek icin --->*/
				add_acc_card.is_acc_diff_#currentrow#.value=diff_amount; /*<!--- mahsup fisine bu deger gonderiliyor --->*/
				add_acc_card.is_acc_diff_#currentrow#.disabled=false;
				
			}
			else
			{
				add_acc_card.acc_diff_amount_#currentrow#.value=commaSplit(diff_amount); /*<!--- kur farkını sadece listede göstermek icin --->*/
				add_acc_card.is_acc_diff_#currentrow#.value=diff_amount; /*<!--- mahsup fisine bu deger gonderiliyor --->*/
				add_acc_card.is_acc_diff_#currentrow#.disabled=true;
			}
		</cfif> 
	</cfoutput>
	</cfif>
}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
			
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.account_card_rate_valuation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/account_card_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/form/account_card_rate_valuation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.account_card_rate_valuation';
	
	
</cfscript>
