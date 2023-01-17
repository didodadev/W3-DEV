<cfsetting showdebugoutput="no">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">

<cfset url_str = ''>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#attributes.start_date#">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
</cfif> 

<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

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
            AND (<cfoutput query="get_refl_acc">
					(  ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_acc.CLAIM_ACCOUNT_CODE#' AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_acc.DEBT_ACCOUNT_CODE#' )
							<cfif get_refl_acc.currentrow neq get_refl_acc.recordcount>OR</cfif>
				</cfoutput>)
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
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
		
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
			AND (<cfoutput query="get_refl_acc">
                    (  ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_acc.CLAIM_ACCOUNT_CODE#' AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_acc.DEBT_ACCOUNT_CODE#' )
                        <cfif get_refl_acc.currentrow neq get_refl_acc.recordcount>OR</cfif>
                </cfoutput>)
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
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
		
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
            AND (<cfoutput query="get_refl_acc">
					(  ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_acc.CLAIM_ACCOUNT_CODE#' AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_acc.DEBT_ACCOUNT_CODE#' )
							<cfif get_refl_acc.currentrow neq get_refl_acc.recordcount>OR</cfif>
				</cfoutput>)
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
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
		
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
			AND (<cfoutput query="get_refl_acc">
					(  ACCOUNT_PLAN.ACCOUNT_CODE >= '#get_refl_acc.CLAIM_ACCOUNT_CODE#' AND ACCOUNT_PLAN.ACCOUNT_CODE <= '#get_refl_acc.DEBT_ACCOUNT_CODE#' )
							<cfif get_refl_acc.currentrow neq get_refl_acc.recordcount>OR</cfif>
				</cfoutput>)
			AND (ACCOUNT_PLAN.ACCOUNT_CODE = ACCOUNT_ACCOUNT_REMAINDER.ACCOUNT_ID)
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND ACCOUNT_ACCOUNT_REMAINDER.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
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

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="search_list" method="post" action="#request.self#?fuseaction=account.form_add_reflecting_account">
        <cf_box>
            <cf_box_search more="0">
                <div class="form-group">
                    <div class="input-group">
                        <input type="text" name="start_date" maxlength="10" id="start_date" placeholder="<cfoutput>#getLang(641,'Başlangıç Tarihi',58053)#</cfoutput>" value="<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="text" name="finish_date" maxlength="10" id="finish_date" placeholder="<cfoutput>#getLang(288,'Bitiş Tarihi',57700)#</cfoutput>" value="<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57650.Dök'></cfsavecontent>
                    <cf_wrk_search_button button_name="#message#" button_type="4">
                </div>
            </cf_box_search>
        </cf_box>
        
        <input type="hidden" name="form_is_submitted" id="form_is_submitted" value="1" />
        <input type="hidden" name="totalrecords_closed" id="totalrecords_closed" value="<cfoutput>#get_refl_sub_acc_closed.recordcount#</cfoutput>"/>
        <input type="hidden" name="totalrecords_income_closed" id="totalrecords_income_closed" value="<cfoutput>#get_income_refl_sub_acc.recordcount#</cfoutput>"/>
            <cfif isdefined("attributes.form_is_submitted")>
                <div class="ui-row">
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                        <cf_box title="#getLang(384,'Gider Hesaplarının Yansıtmaları',48255)#" uidrop="1" hide_table_column="1">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th><cfoutput>#getLang(1165,'Sıra',58577)#</cfoutput></th>
                                        <th><cfoutput>#getLang(6,'Alacaklı Hesaplar (Yansıtma Hesapları)',49721)#</cfoutput></th>
                                        <th><cfoutput>#getLang(261,'Tutar',57673)#</cfoutput></th>
                                        <th><cf_get_lang dictionary_id='60718.Borçlu Hesaplar'></th>
                                        <th><cfoutput>#getLang(261,'Tutar',57673)#</cfoutput></th>
                                    </tr>
                                </thead>
                                <tbody id="Table_Debt">
                                    <cfset new_counter = 0>
                                    <cfif get_refl_sub_acc.recordcount>
                                        <cfoutput query="deneme11">
                                            <cfset sayac = 0>
                                            <cfif (deneme11.alacak_hesap neq 0 or deneme11.alacak_hesap lt 0) and deneme11.bakiye gt 0>
                                                <cfset sayac = sayac+1>
                                                <cfset new_counter = new_counter+1>
                                                <tr>
                                                    <td>#currentrow#</td>
                                                    <td>
                                                        <input type="text" name="claim_acc_code_refl_#currentrow#" id="claim_acc_code_refl_#currentrow#"  value="#deneme11.CLAIM_ACCOUNT_CODE#" required style="width:98%;" readonly="readonly">
                                                    </td>
                                                    <td>
                                                        <input type="text" name="amount_claim_refl_#currentrow#"  id="amount_claim_refl_#currentrow#" value="#tlFormat(abs(bakiye))#" required style="width:98%;text-align:right;" readonly="readonly">
                                                    </td>
                                                    <td>
                                                        <input type="text" name="debt_acc_code_refl_#currentrow#" id="debt_acc_code_refl_#currentrow#" style="width:98%;" value="#deneme11.DEBT_ACCOUNT_CODE#" required readonly="readonly">
                                                    </td>
                                                    <td>
                                                        <input type="text" name="amount_debt_refl_#currentrow#"  id="amount_debt_refl_#currentrow#" value="#tlFormat(abs(bakiye))#" required style="width:98%;text-align:right;" readonly="readonly">
                                                    </td>
                                                </tr>
                                            </cfif>
                                        </cfoutput>
                                        <cfif sayac eq 0>
                                            <tr>
                                                <script type="text/javascript">
                                                    document.getElementById("totalrecords_refl").value=0;
                                                </script>
                                                <td class="no-search" colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                            </tr>
                                        </cfif>
                                    <cfelse>
                                        <tr>
                                            <td class="no-search" colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                        </tr>
                                    </cfif>
                                    <input type="hidden" name="totalrecords_refl" id="totalrecords_refl" value="<cfoutput>#new_counter#</cfoutput>"/>
                                </tbody>
                            </cf_grid_list>
                        </cf_box>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                        <cf_box title="#getLang(7,'Yansıtmaların Kapanması İşlemi',49722)#" uidrop="1" hide_table_column="1">
                            <cf_grid_list >
                                <thead>
                                    <tr>
                                        <th><cfoutput>#getLang(1165,'Sıra',58577)#</cfoutput></th>
                                        <th><cfoutput>#getLang('','Alacaklı Hesaplar',59069)#</cfoutput></th>
                                        <th><cfoutput>#getLang(261,'Tutar',57673)#</cfoutput></th>
                                        <th><cf_get_lang dictionary_id='60718.Borçlu Hesaplar'></th>
                                        <th><cfoutput>#getLang(261,'Tutar',57673)#</cfoutput></th>
                                    </tr>
                                </thead>
                                <tbody id="Table_Claim">
                                    <cfif get_refl_sub_acc_closed.recordcount>
                                        <cfoutput query="get_refl_sub_acc_closed">
                                            <tr>
                                                <td>#get_refl_sub_acc_closed.currentrow#</td>
                                                <td>
                                                    <input type="text" name="claim_acc_code_closed_#currentrow#" id="claim_acc_code_closed_#currentrow#"  value="#get_refl_sub_acc_closed.CLAIM_ACCOUNT_CODE#" required style="width:98%;" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="text" name="amount_claim_closed_#currentrow#"  id="amount_claim_closed_#currentrow#" value="#tlFormat(abs(bakiye))#" required style="width:98%;text-align:right;" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="text" name="debt_acc_code_closed_#currentrow#" id="debt_acc_code_closed_#currentrow#" style="width:98%;" value="#get_refl_sub_acc_closed.DEBT_ACCOUNT_CODE#" required readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="text" name="amount_debt_closed_#currentrow#"  id="amount_debt_closed_#currentrow#" value="#tlFormat(abs(bakiye))#" required style="width:98%;text-align:right;" readonly="readonly">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                        </tr>
                                    </cfif>
                                </tbody>
                            </cf_grid_list>
                        </cf_box>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                        <cf_box title="#getLang(8,'Gelir Tablosu Hesaplarının Kapanması İşlemi',49723)#" uidrop="1" hide_table_column="1">
                            <cf_grid_list>
                                <thead>
                                    <tr>
                                        <th><cfoutput>#getLang(1165,'Sıra',58577)#</cfoutput></th>
                                        <th><cfoutput>#getLang('','Alacaklı Hesaplar',59069)#</cfoutput></th>
                                        <th><cfoutput>#getLang(261,'Tutar',57673)#</cfoutput></th>
                                        <th><cf_get_lang dictionary_id='60718.Borçlu Hesaplar'></th>
                                        <th><cfoutput>#getLang(261,'Tutar',57673)#</cfoutput></th>
                                    </tr>
                                </thead>
                                <tbody id="Table_Claim">
                                    <cfif get_income_refl_sub_acc.recordcount>
                                        <cfoutput query="get_income_refl_sub_acc">
                                            <tr>
                                                <td>#get_income_refl_sub_acc.currentrow#</td>
                                                <td>
                                                    <input type="text" name="claim_income_acc_code_closed_#currentrow#" id="claim_income_acc_code_closed_#currentrow#"  value="#get_income_refl_sub_acc.CLAIM_ACCOUNT_CODE#" required style="width:98%;" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="text" name="amount_income_claim_closed_#currentrow#"  id="amount_income_claim_closed_#currentrow#" value="#tlFormat(abs(bakiye))#" required style="width:98%;text-align:right;" readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="text" name="debt_income_acc_code_closed_#currentrow#" id="debt_income_acc_code_closed_#currentrow#" style="width:98%;" value="#get_income_refl_sub_acc.DEBT_ACCOUNT_CODE#" required readonly="readonly">
                                                </td>
                                                <td>
                                                    <input type="text" name="amount_income_debt_closed_#currentrow#"  id="amount_income_debt_closed_#currentrow#" value="#tlFormat(abs(bakiye))#" required style="width:98%;text-align:right;" readonly="readonly">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    <cfelse>
                                        <tr>
                                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                        </tr>
                                    </cfif>
                                </tbody>
                            </cf_grid_list>
                        </cf_box>
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box>
                            <div class="ui-info-bottom flex-end">
                                <cf_box_elements>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label class="col col-6 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='47348.Fiş Türü'></label>
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                                <div class="form-group" >
                                                    <select name="card_type" id="card_type">
                                                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                                        <option value="13"><cfoutput>#getlang(1040,'Mahsup Fişi',58452)#</cfoutput></option>
                                                        <option value="19"><cfoutput>#getlang(1746,'Kapanış Fişi',29543)#</cfoutput></option>
                                                    </select>
                                                </div>
                                        </div>
                                    </div>

                                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                            <div class="form-group" >
                                                <div class="input-group">
                                                    <input type="text" name="process_date" maxlength="10" id="process_date"  style="width:65px;" value="<cfif isdefined("attributes.process_date") and len(attributes.process_date)></cfif>">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                   
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <div class="form-group">
                                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" style="margin: 12px 0 0 5px">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent>
                                                <cf_workcube_buttons type_format="0" is_upd="0" insert_info='#message#' is_cancel='0' add_function="control()">
                                            </div>
                                        </div>
                                    </div>
                                   
                                  
                                </cf_box_elements>
                            </div>
                        </cf_box>
                    </div> 
                </div>
            <cfelse>
                <div class="row"> 
                    <div class="col col-12 uniqueRow"> 		
                        <div class="row formContent">
                            <div class="row">
                                <div class="col col-12">
                                    <cf_get_lang dictionary_id='57701.Filtre Ediniz '> !
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </cfif>
    </cfform>
</div>
<script type="text/javascript">
	function control()
	{
		if(document.getElementById('process_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='59298.Lütfen işlem tarihi giriniz'>");		
			return false;
		}
		if(document.getElementById('card_type').value == '')
		{
			alert("<cf_get_lang dictionary_id='59299.Lütfen fiş türü seçiniz'>!");
			return false;
		}
		document.getElementById('search_list').action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_add_refl_acc<cfoutput>#url_str#</cfoutput>';
	}
</script>
