<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfquery name="GET_ACCOUNT_CLOSED_DEBT" datasource="#dsn2#"> 
 	SELECT
    	AC.ACCOUNT_CLOSED_ID,
        AC.DEBT_ACCOUNT_CODE,
        AC.CLOSED_ACCOUNT_CODE
    FROM 
        ACCOUNT_CLOSED_DEFINITION AC
    WHERE 
        AC.DEBT_ACCOUNT_CODE IS NOT NULL AND CLOSED_TYPE = 0
    GROUP BY 
        AC.DEBT_ACCOUNT_CODE,AC.CLOSED_ACCOUNT_CODE,AC.ACCOUNT_CLOSED_ID
</cfquery>
<cfquery name="GET_ACCOUNT_CLOSED_CLAIM" datasource="#dsn2#"> 
 	SELECT
    	AC.ACCOUNT_CLOSED_ID,
        AC.CLAIM_ACCOUNT_CODE,
        AC.CLOSED_ACCOUNT_CODE
    FROM 
        ACCOUNT_CLOSED_DEFINITION AC
    WHERE 
        AC.CLAIM_ACCOUNT_CODE IS NOT NULL  AND CLOSED_TYPE = 0
    GROUP BY 
        AC.CLAIM_ACCOUNT_CODE,AC.CLOSED_ACCOUNT_CODE,AC.ACCOUNT_CLOSED_ID
</cfquery>
<cfif GET_ACCOUNT_CLOSED_DEBT.recordcount>
    <cfquery name="GET_SUB_ACCOUNT_DEBT" datasource="#dsn2#"> 
        SELECT
            SUM(T1.BORC) BORC,
            SUM(T1.ALACAK) ALACAK,
            T1.DEBT_ACCOUNT_CODE_CLOSED_,
            ACCOUNT_CODE
        FROM(
        <cfoutput query="GET_ACCOUNT_CLOSED_DEBT">
            SELECT         
               ACCOUNT_CODE,
               '#GET_ACCOUNT_CLOSED_DEBT.CLOSED_ACCOUNT_CODE#' DEBT_ACCOUNT_CODE_CLOSED_,
               CASE WHEN BA=1 THEN SUM(ACCOUNT_CARD_ROWS.AMOUNT) ELSE 0 END AS ALACAK,
               CASE WHEN BA=0 THEN SUM(ACCOUNT_CARD_ROWS.AMOUNT) ELSE 0 END AS BORC
            FROM
                ACCOUNT_PLAN INNER JOIN ACCOUNT_CARD_ROWS 
                ON ACCOUNT_CARD_ROWS.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE 
            INNER JOIN 
                ACCOUNT_CARD 
            ON 
                ACCOUNT_CARD_ROWS.CARD_ID = ACCOUNT_CARD.CARD_ID
            WHERE
                SUB_ACCOUNT = 0
                    <cfif len(attributes.start_date)>
                        AND ACCOUNT_CARD.ACTION_DATE >=#attributes.start_date# 
                    </cfif>
                    <cfif len(attributes.finish_date)>
                        AND ACCOUNT_CARD.ACTION_DATE<=#attributes.finish_date# 
                    </cfif>
                    <cfif listlen(GET_ACCOUNT_CLOSED_DEBT.DEBT_ACCOUNT_CODE,'.') eq 1>
                        AND ACCOUNT_CODE LIKE '#GET_ACCOUNT_CLOSED_DEBT.DEBT_ACCOUNT_CODE#.%'
                    <cfelse>	
                        AND ACCOUNT_CODE = '#GET_ACCOUNT_CLOSED_DEBT.DEBT_ACCOUNT_CODE#'
                    </cfif>
                        GROUP BY ACCOUNT_CODE,BA
                <cfif GET_ACCOUNT_CLOSED_DEBT.recordcount gt 0 and GET_ACCOUNT_CLOSED_DEBT.currentrow neq GET_ACCOUNT_CLOSED_DEBT.recordcount>UNION</cfif>
        </cfoutput>) AS T1 
                GROUP BY T1.ACCOUNT_CODE,T1.DEBT_ACCOUNT_CODE_CLOSED_
    </cfquery>
<cfelse>
	<cfset GET_SUB_ACCOUNT_DEBT.recordcount = 0>
</cfif>
<cfif GET_ACCOUNT_CLOSED_CLAIM.recordcount>
    <cfquery name="GET_SUB_ACCOUNT_CLAIM" datasource="#dsn2#"> 
        SELECT
            SUM(T2.BORC) BORC,
            SUM(T2.ALACAK) ALACAK,
            T2.CLAIM_ACCOUNT_CODE_CLOSED_,
            ACCOUNT_CODE
        FROM(
        <cfoutput query="GET_ACCOUNT_CLOSED_CLAIM">
            SELECT         
                ACCOUNT_CODE,
                '#GET_ACCOUNT_CLOSED_CLAIM.CLOSED_ACCOUNT_CODE#' CLAIM_ACCOUNT_CODE_CLOSED_,
                CASE WHEN BA=1 THEN SUM(ACCOUNT_CARD_ROWS.AMOUNT) ELSE 0 END AS ALACAK,
                CASE WHEN BA=0 THEN SUM(ACCOUNT_CARD_ROWS.AMOUNT) ELSE 0 END AS BORC
            FROM
                ACCOUNT_PLAN INNER JOIN ACCOUNT_CARD_ROWS 
                ON ACCOUNT_CARD_ROWS.ACCOUNT_ID = ACCOUNT_PLAN.ACCOUNT_CODE 
            INNER JOIN 
                ACCOUNT_CARD 
            ON 
                ACCOUNT_CARD_ROWS.CARD_ID = ACCOUNT_CARD.CARD_ID
            WHERE
                SUB_ACCOUNT = 1
                    <cfif len(attributes.start_date)>
                        AND  ACCOUNT_CARD.ACTION_DATE >=#attributes.start_date# 
                    </cfif>
                    <cfif len(attributes.finish_date)>
                        AND  ACCOUNT_CARD.ACTION_DATE<=#attributes.finish_date# 
                    </cfif>
                    <cfif listlen(GET_ACCOUNT_CLOSED_CLAIM.CLAIM_ACCOUNT_CODE,'.') eq 1>
                        AND ACCOUNT_CODE LIKE '#GET_ACCOUNT_CLOSED_CLAIM.CLAIM_ACCOUNT_CODE#.%'
                    <cfelse>	
                        AND ACCOUNT_CODE = '#GET_ACCOUNT_CLOSED_CLAIM.CLAIM_ACCOUNT_CODE#'
                    </cfif>
                    GROUP BY ACCOUNT_CODE,BA
                    <cfif GET_ACCOUNT_CLOSED_CLAIM.currentrow neq GET_ACCOUNT_CLOSED_CLAIM.recordcount>UNION</cfif>
        </cfoutput>) AS T2 
                GROUP BY T2.ACCOUNT_CODE,T2.CLAIM_ACCOUNT_CODE_CLOSED_
    </cfquery>
<cfelse>
	<cfset GET_SUB_ACCOUNT_CLAIM.recordcount = 0>    
</cfif>
<cfif isdefined("attributes.save_record") and attributes.save_record eq 1>
	<cf_date tarih='attributes.process_date'>
    <cfquery name="get_process_type" datasource="#dsn3#">
        SELECT 
            PROCESS_CAT_ID,
            PROCESS_TYPE,
            IS_CARI,
            IS_ACCOUNT,
            IS_ACCOUNT_GROUP,
            ACTION_FILE_NAME,
            ACTION_FILE_FROM_TEMPLATE
         FROM 
            SETUP_PROCESS_CAT 
        WHERE 
            PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="Mahsup Fişi">
    </cfquery>
    <cfscript>
        process_cat = get_process_type.PROCESS_CAT_ID;
        process_type = get_process_type.PROCESS_TYPE;
    
        debt_accounts_list = '';
        debt_amounts_list = '';
        claim_accounts_list = '';
        claim_amounts_list = '';	
    
        for(i=1 ; i<=attributes.totalrecords_debt ; i++)
        {
            debt_accounts_list = listAppend(debt_accounts_list, attributes['DEBT_ACCOUNT_ID'&i]);	
            debt_amounts_list = listAppend(debt_amounts_list, filterNum(attributes['AMOUNT_DEBT'&i]));	
            claim_accounts_list = listAppend(claim_accounts_list, attributes['DEBT_CLOSED_ACCOUNT_ID'&i]);	
            claim_amounts_list = listAppend(claim_amounts_list, filterNum(attributes['AMOUNT_DEBT_CLOSED'&i]));	
        }
        
        for(j=1 ; j<=attributes.totalrecords_claim ; j++)
        {
            claim_accounts_list = listAppend(claim_accounts_list, attributes['CLAIM_ACCOUNT_ID'&j]);	
            claim_amounts_list = listAppend(claim_amounts_list, filterNum(attributes['AMOUNT_CLAIM'&j]));	
			debt_accounts_list = listAppend(debt_accounts_list, attributes['CLAIM_CLOSED_ACCOUNT_ID'&j]);	
            debt_amounts_list = listAppend(debt_amounts_list, filterNum(attributes['AMOUNT_CLAIM_CLOSED'&j]));	
            		
        }
        
        //yansıtmaların kapatılması
        yev = muhasebeci(
            action_id: 0,
            workcube_process_type: process_type,
            workcube_process_cat: process_cat,
            account_card_type: attributes.card_type,
            islem_tarihi : attributes.process_date,
            fis_satir_detay : 'Gelir Tablosu Form Kapanışları',
            borc_hesaplar : debt_accounts_list,
            borc_tutarlar : debt_amounts_list,
            //other_amount_borc : str_borclu_other_amount_tutar,
            //other_currency_borc : str_borclu_other_currency,
            alacak_hesaplar : claim_accounts_list,
            alacak_tutarlar : claim_amounts_list,
            //other_amount_alacak : str_alacakli_other_amount_tutar,
            //other_currency_alacak : str_alacakli_other_currency,
            fis_detay:'Gelir Tablosu Form Kapanışları'
        );		
    </cfscript>
</cfif>
<script type="text/javascript">
	<cfif isdefined("yev") and yev neq 0>
		if(confirm("<cfoutput>#yev#</cfoutput> yevmiye numaralı fiş oluşturuldu."))
		{
			var str = "<cfoutput>#request.self#?fuseaction=account.account_closed_definition_end&form_is_submitted=1&start_date=#dateformat(attributes.start_date,dateformat_style)#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#</cfoutput>";
			str = str.replace("'","\'");
			window.location.href=str;
		}
	<cfelseif isdefined("yev")>
		if(confirm("Fişler oluşturulamadı."))
		{
			var str = "<cfoutput>#request.self#?fuseaction=account.form_add_reflecting_account&form_is_submitted=1&start_date=#dateformat(attributes.start_date,dateformat_style)#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#</cfoutput>";
			str = str.replace("'","\'");
			window.location.href=str;
		}
	</cfif>
</script>









	










