<cfsetting showdebugoutput="no">
<cfif isdefined('session.pp')>
	<cfset session_base = session.pp>
<cfelse>
	<cfset session_base = session.ww>
</cfif>

<cfquery name="GET_INST_INFO" datasource="#DSN#">
	SELECT
		IS_INSTALMENT_INFO
	FROM
		COMPANY_CREDIT
	WHERE
	<cfif isDefined("session.pp")>
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
	<cfelse>
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
	</cfif>
</cfquery>

<cfif isDefined("attributes.campaign_id") or (isDefined("attributes.order_id_info") and isDefined("attributes.camp_id_info") and len(attributes.camp_id_info))>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT DISTINCT OCPR.POS_ID,
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME,
			<cfif session_base.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			CPT.PAYMENT_TYPE_ID,
			CPT.CARD_NO,
			CP.SERVICE_COMM_MULTIPLIER PAYMENT_RATE,
			CPT.PAYMENT_RATE_DSP,
			CASE 
				WHEN CPT.NUMBER_OF_INSTALMENT = 0 THEN 1
				ELSE CPT.NUMBER_OF_INSTALMENT
       		END AS NUMBER_OF_INSTALMENT,
			CPT.IS_COMISSION_TOTAL_AMOUNT,
			OCPR.POS_TYPE,
			CARD_IMAGE_SERVER_ID,
			CARD_IMAGE,
			OCPR.IS_SECURE
		FROM
			ACCOUNTS ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE CPT,
			CAMPAIGN_PAYMETHODS CP,
			#dsn#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			(ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
			ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
			OCPR.POS_ID = CPT.POS_TYPE AND
			CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
			CP.COMMISSION_RATE IS NOT NULL AND
			CP.CAMPAIGN_ID = <cfif isDefined("attributes.camp_id_info") and len(attributes.camp_id_info)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id_info#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"></cfif> AND
			CP.USED_IN_CAMPAIGN = 1 AND
			CPT.IS_ACTIVE = 1 AND
			<cfif isDefined("session.pp")>
                CPT.IS_PARTNER = 1 AND
            <cfelse>
                CPT.IS_PUBLIC = 1 AND
            </cfif>
            <cfif GET_INST_INFO.IS_INSTALMENT_INFO neq 1>
                (CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
            </cfif>
			CPT.POS_TYPE IS NOT NULL
		UNION ALL
			SELECT
				DISTINCT OCPR.POS_ID,
				0 AS ACCOUNT_ID,
				OCPR.POS_NAME AS ACCOUNT_NAME,
				'#session_base.money#' AS ACCOUNT_CURRENCY_ID,
				CPT.PAYMENT_TYPE_ID,
				CPT.CARD_NO,
				CP.SERVICE_COMM_MULTIPLIER PAYMENT_RATE,
				CPT.PAYMENT_RATE_DSP,
				CASE 
					WHEN CPT.NUMBER_OF_INSTALMENT = 0 THEN 1
					ELSE CPT.NUMBER_OF_INSTALMENT
				END AS NUMBER_OF_INSTALMENT,
				CPT.IS_COMISSION_TOTAL_AMOUNT,
				OCPR.POS_TYPE,
				CARD_IMAGE_SERVER_ID,
				CARD_IMAGE,
				OCPR.IS_SECURE
			FROM
				CREDITCARD_PAYMENT_TYPE CPT,
				CAMPAIGN_PAYMETHODS CP,
				#dsn#.OUR_COMPANY_POS_RELATION OCPR
			WHERE
				OCPR.POS_ID = CPT.POS_TYPE AND
				CP.PAYMETHOD_ID = CPT.PAYMENT_TYPE_ID AND
				CP.COMMISSION_RATE IS NOT NULL AND
				CP.CAMPAIGN_ID = <cfif isDefined("attributes.camp_id_info") and len(attributes.camp_id_info)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id_info#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.campaign_id#"></cfif> AND
				CP.USED_IN_CAMPAIGN = 1 AND
				CPT.IS_ACTIVE = 1 AND
				CPT.COMPANY_ID IS NOT NULL AND
				CPT.POS_TYPE IS NOT NULL AND
				<cfif isDefined("session.pp")>
					CPT.IS_PARTNER = 1 AND
				<cfelse>
					CPT.IS_PUBLIC = 1 AND
				</cfif>
				<cfif GET_INST_INFO.IS_INSTALMENT_INFO neq 1>
					(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0)
				</cfif>
			ORDER BY
				CPT.CARD_NO
	</cfquery>
<cfelse>
	<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
		SELECT DISTINCT OCPR.POS_ID,
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME,
			<cfif session_base.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			CPT.PAYMENT_TYPE_ID,
			CPT.CARD_NO,
			<cfif isDefined("attributes.order_id_info") and isDefined("session.pp")><!--- siparişten farklı kartla ödeme seçildiğinde --->
				CPT.COMMISSION_MULTIPLIER PAYMENT_RATE,
				CPT.COMMISSION_MULTIPLIER_DSP PAYMENT_RATE_DSP,
			<cfelseif isDefined("attributes.order_id_info") and isDefined("session.ww")>
				CPT.PUBLIC_COMMISSION_MULTIPLIER PAYMENT_RATE,
				CPT.PUBLIC_COM_MULTIPLIER_DSP PAYMENT_RATE_DSP,
			<cfelse>
				CPT.PAYMENT_RATE,
				CPT.PAYMENT_RATE_DSP,
			</cfif>
			CASE 
				WHEN CPT.NUMBER_OF_INSTALMENT = 0 THEN 1
				ELSE CPT.NUMBER_OF_INSTALMENT
       		END AS NUMBER_OF_INSTALMENT,
			CPT.VFT_RATE,
			CPT.IS_COMISSION_TOTAL_AMOUNT,
			OCPR.POS_TYPE,
			CARD_IMAGE_SERVER_ID,
			CARD_IMAGE,
			OCPR.IS_SECURE
		FROM
			ACCOUNTS ACCOUNTS,
			CREDITCARD_PAYMENT_TYPE CPT,
			#dsn#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			(ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
			ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
			OCPR.POS_ID = CPT.POS_TYPE AND
			CPT.IS_ACTIVE = 1 AND
			<cfif isDefined("session.pp")>
				(
					<!---bu üye seçili üye listesindense ve ödeme yöntemi geçerlilk süresindeyse..AE --->
					CPT.PAYMENT_TYPE_ID IN (SELECT CC_PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE_MEMBER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND (#now()# BETWEEN START_DATE AND DATEADD(day,1,FINISH_DATE)))
				) AND
			
				CPT.IS_PARTNER = 1 AND
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
			</cfif>
			<cfif GET_INST_INFO.IS_INSTALMENT_INFO neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>
				CPT.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_to_account_id#"> AND
			</cfif>
			<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
				CPT.VFT_RATE IS NOT NULL AND
			<cfelse>
				CPT.VFT_RATE IS NULL AND
			</cfif>
			CPT.POS_TYPE IS NOT NULL
			UNION ALL
		SELECT
			DISTINCT OCPR.POS_ID,
			0 AS ACCOUNT_ID,
			OCPR.POS_NAME AS ACCOUNT_NAME,
			'#session_base.money#' AS ACCOUNT_CURRENCY_ID,
			CPT.PAYMENT_TYPE_ID,
			CPT.CARD_NO,
			<cfif isDefined("attributes.order_id_info") and isDefined("session.pp")><!--- siparişten farklı kartla ödeme seçildiğinde --->
				CPT.COMMISSION_MULTIPLIER PAYMENT_RATE,
				CPT.COMMISSION_MULTIPLIER_DSP PAYMENT_RATE_DSP,
			<cfelseif isDefined("attributes.order_id_info") and isDefined("session.ww")>
				CPT.PUBLIC_COMMISSION_MULTIPLIER PAYMENT_RATE,
				CPT.PUBLIC_COM_MULTIPLIER_DSP PAYMENT_RATE_DSP,
			<cfelse>
				CPT.PAYMENT_RATE,
				CPT.PAYMENT_RATE_DSP,
			</cfif>
			CASE 
				WHEN CPT.NUMBER_OF_INSTALMENT = 0 THEN 1
				ELSE CPT.NUMBER_OF_INSTALMENT
       		END AS NUMBER_OF_INSTALMENT,
			CPT.VFT_RATE,
			CPT.IS_COMISSION_TOTAL_AMOUNT,
			OCPR.POS_TYPE,
			CARD_IMAGE_SERVER_ID,
			CARD_IMAGE,
			OCPR.IS_SECURE
		FROM
			CREDITCARD_PAYMENT_TYPE CPT,
			#dsn#.OUR_COMPANY_POS_RELATION OCPR
		WHERE
			OCPR.POS_ID = CPT.POS_TYPE AND
			CPT.IS_ACTIVE = 1 AND
			<cfif isDefined("session.pp")>
				(
					<!---bu üye seçili üye listesindense ve ödeme yöntemi geçerlilk süresindeyse..AE --->
					CPT.PAYMENT_TYPE_ID IN (SELECT CC_PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE_MEMBER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND (#now()# BETWEEN START_DATE AND DATEADD(day,1,FINISH_DATE)))
				) AND
				CPT.IS_PARTNER = 1 AND
			<cfelse>
				CPT.IS_PUBLIC = 1 AND
			</cfif>
			<cfif GET_INST_INFO.IS_INSTALMENT_INFO neq 1>
				(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
			</cfif>
			<cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>
				CPT.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_to_account_id#"> AND
			</cfif>
			<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
				CPT.VFT_RATE IS NOT NULL AND
			<cfelse>
				CPT.VFT_RATE IS NULL AND
			</cfif>
			CPT.COMPANY_ID IS NOT NULL AND
			CPT.POS_TYPE IS NOT NULL
		ORDER BY
			CPT.CARD_NO
	</cfquery>
	<cfif not get_accounts.recordcount>
		<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
				SELECT  OCPR.POS_ID,
			ACCOUNTS.ACCOUNT_ID,
			ACCOUNTS.ACCOUNT_NAME,
			<cfif session_base.period_year lt 2009>
				CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
			<cfelse>
				ACCOUNTS.ACCOUNT_CURRENCY_ID,
			</cfif>
			CPT.PAYMENT_TYPE_ID,
			CPT.CARD_NO,
			<cfif isDefined("attributes.order_id_info") and isDefined("session.pp")><!--- siparişten farklı kartla ödeme seçildiğinde --->
                CPT.COMMISSION_MULTIPLIER PAYMENT_RATE,
                CPT.COMMISSION_MULTIPLIER_DSP PAYMENT_RATE_DSP,
            <cfelseif isDefined("attributes.order_id_info") and isDefined("session.ww")>
                CPT.PUBLIC_COMMISSION_MULTIPLIER PAYMENT_RATE,
                CPT.PUBLIC_COM_MULTIPLIER_DSP PAYMENT_RATE_DSP,
            <cfelse>
                CPT.PAYMENT_RATE,
                CPT.PAYMENT_RATE_DSP,
            </cfif>
			CASE 
				WHEN CPT.NUMBER_OF_INSTALMENT = 0 THEN 1
				ELSE CPT.NUMBER_OF_INSTALMENT
       		END AS NUMBER_OF_INSTALMENT,
			CPT.VFT_RATE,
			CPT.IS_COMISSION_TOTAL_AMOUNT,
			OCPR.POS_TYPE,
			CARD_IMAGE_SERVER_ID,
			CARD_IMAGE,
			OCPR.IS_SECURE
			FROM
				ACCOUNTS ACCOUNTS,
				CREDITCARD_PAYMENT_TYPE CPT,
				#dsn#.OUR_COMPANY_POS_RELATION OCPR
			WHERE
				(ACCOUNTS.ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> OR ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') AND
				ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
				OCPR.POS_ID = CPT.POS_TYPE AND
				CPT.IS_ACTIVE = 1 AND
				<cfif isDefined("session.pp")>
					(
						<!---bu üye seçili üye listesindense ve ödeme yöntemi geçerlilk süresindeyse..AE --->
						CPT.PAYMENT_TYPE_ID IN (SELECT CC_PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE_MEMBER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND (#now()# BETWEEN START_DATE AND DATEADD(day,1,FINISH_DATE)))
					) AND
				
					CPT.IS_PARTNER = 1 AND
				<cfelse>
					CPT.IS_PUBLIC = 1 AND
				</cfif>
				<cfif GET_INST_INFO.IS_INSTALMENT_INFO neq 1>
					(CPT.NUMBER_OF_INSTALMENT IS NULL OR CPT.NUMBER_OF_INSTALMENT = 0) AND
				</cfif>
				<cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>
					CPT.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_to_account_id#"> AND
				</cfif>
				<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
					CPT.VFT_RATE IS NOT NULL AND
				<cfelse>
					CPT.VFT_RATE IS NULL AND
				</cfif>
				CPT.POS_TYPE IS NOT NULL
			UNION ALL
			SELECT
				 OCPR.POS_ID,
				0 AS ACCOUNT_ID,
				OCPR.POS_NAME AS ACCOUNT_NAME,
				'#session_base.money#' AS ACCOUNT_CURRENCY_ID,
				CPT.PAYMENT_TYPE_ID,
				CPT.CARD_NO,
				<cfif isDefined("attributes.order_id_info") and isDefined("session.pp")><!--- siparişten farklı kartla ödeme seçildiğinde --->
					CPT.COMMISSION_MULTIPLIER PAYMENT_RATE,
					CPT.COMMISSION_MULTIPLIER_DSP PAYMENT_RATE_DSP,
				<cfelseif isDefined("attributes.order_id_info") and isDefined("session.ww")>
					CPT.PUBLIC_COMMISSION_MULTIPLIER PAYMENT_RATE,
					CPT.PUBLIC_COM_MULTIPLIER_DSP PAYMENT_RATE_DSP,
				<cfelse>
					CPT.PAYMENT_RATE,
					CPT.PAYMENT_RATE_DSP,
				</cfif>
				CASE 
					WHEN CPT.NUMBER_OF_INSTALMENT = 0 THEN 1
					ELSE CPT.NUMBER_OF_INSTALMENT
				END AS NUMBER_OF_INSTALMENT,
				CPT.VFT_RATE,
				CPT.IS_COMISSION_TOTAL_AMOUNT,
				OCPR.POS_TYPE,
				CARD_IMAGE_SERVER_ID,
				CARD_IMAGE,
				OCPR.IS_SECURE
			FROM
				CREDITCARD_PAYMENT_TYPE CPT,
				#dsn#.OUR_COMPANY_POS_RELATION OCPR
			WHERE
				OCPR.POS_ID = CPT.POS_TYPE AND
				CPT.IS_ACTIVE = 1 AND			
			
				<cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>
					CPT.PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_to_account_id#"> AND
				</cfif>
				<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
					CPT.VFT_RATE IS NOT NULL AND
				<cfelse>
					CPT.VFT_RATE IS NULL AND
				</cfif>
				CPT.POS_TYPE IS NOT NULL
			ORDER BY
				CPT.CARD_NO
		</cfquery>
	</cfif>
</cfif>

<cfif get_accounts.recordcount>
	<cfquery name="get_account_names" dbtype="query">
		SELECT POS_ID, POS_TYPE FROM get_accounts GROUP BY POS_ID, POS_TYPE ORDER BY POS_ID, POS_TYPE
	</cfquery>
	<cfquery name="get_instalment_size" dbtype="query">
		SELECT MAX(NUMBER_OF_INSTALMENT) AS INSTALMENT_SIZE FROM get_accounts
	</cfquery>
	<cfset account_array = arrayNew(2) />
	<cfoutput query="get_accounts">
		<cfscript>
			account_array[POS_ID][NUMBER_OF_INSTALMENT]						= structNew();
			account_array[POS_ID][NUMBER_OF_INSTALMENT].current_row			= currentrow;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].payment_type_id		= PAYMENT_TYPE_ID;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].number_of_instalment= NUMBER_OF_INSTALMENT;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].account_id			= ACCOUNT_ID;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].account_currency_id	= ACCOUNT_CURRENCY_ID;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].pos_type			= POS_TYPE;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].pos_id				= POS_ID;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].payment_rate		= PAYMENT_RATE;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].is_comission_total_amount = IS_COMISSION_TOTAL_AMOUNT;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].is_secure			= IS_SECURE;
			account_array[POS_ID][NUMBER_OF_INSTALMENT].card_no				= CARD_NO;
		</cfscript>
	</cfoutput>

	<cfscript>
		images_array 		= arrayNew(1);
		images_array[1]		= 'images/bankslogo/Akbank.png';
		images_array[2]		= '';
		images_array[3]		= 'images/bankslogo/IsBankasi.png';
		images_array[4]		= 'images/bankslogo/Denizbank.png';
		images_array[5]		= 'images/bankslogo/FinansBank.png';
		images_array[6]		= 'images/bankslogo/Hsbc.png';
		images_array[7]		= 'images/bankslogo/Vakıfbank.png';
		images_array[8]		= 'images/bankslogo/Garanti.png';
		images_array[9]		= 'images/bankslogo/YapıKredi.png';
		images_array[10]	= 'images/bankslogo/Halkbank.png';
		images_array[11]	= 'images/bankslogo/TurkiyeFinans.png';
		images_array[12]	= '';
		images_array[13]	= 'images/bankslogo/Citibank.png';
		images_array[14]	= 'images/bankslogo/TEB.png';
		images_array[15]	= 'images/bankslogo/Ziraatbank.png';
		images_array[16]	= 'images/bankslogo/Ing.png';
		images_array[17]	= 'images/bankslogo/Odeabank.png';
		images_array[18]	= 'images/bankslogo/SekerBank.png';
		images_array[19]	= '';
		images_array[20]	= 'images/bankslogo/Albaraka.png';
	</cfscript>
</cfif>

<style>
	table, th, td {
		border: solid 1px #DDD;
		border-collapse: collapse;
		padding: 1px 1px;
		text-align: center;
	}

	td {
		font-size: 12px;
	}

	.highlight_td {
		background-color:#CCC;
		color:#000;
	}

	.selected_type {
		height: 50px;
		font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
		font-size: 20px;
	}
</style>

<div class="table-responsive">
	<table class="table table-striped table-sm">
		<thead>
		<tr>
			<th style="width:50px;">Taksit Sayısı</th>
			<!--- <th nowrap="nowrap">Ödeme Yöntemi</th>
			<cfif isdefined("attributes.is_view_commision") and attributes.is_view_commision eq 1>
				<th style="text-align:right;" nowrap="nowrap">Komisyon Oranı</th>
			</cfif>
			<cfif isdefined('attributes.is_payment_rate')>
				<th style="text-align:right; width:90px;">Çarpan</th>
			</cfif>
			<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
				<th style="text-align:right; width:115px;">Taksit Tutarı</th>
			</cfif>
			<cfif isdefined('attributes.is_comission_total_amount') and attributes.is_comission_total_amount eq 1>
				<th style="text-align:right; width:120px;">Hesaba Yansıyacak Tutar</th>
			</cfif>
			<th style="text-align:right; width:115px;">Toplam Tutar</th>
			<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
				<th style="text-align:right; width:100px;">VFT Oranı</th>
				<th style="text-align:right; width:120px;">VFT Tutar</th>
			</cfif> --->
			<cfif get_accounts.recordcount>
			<cfoutput query="get_account_names">
			<th style="vertical-align: middle;"><cfif arrayIsDefined(images_array,POS_TYPE) And Len(images_array[POS_TYPE])><img src="#images_array[POS_TYPE]#" style="width:90px;" /></cfif></th>
			</cfoutput>
			</cfif>
		</tr>
		</thead>
		<tbody>
			<cfloop from="1" to="#get_instalment_size.INSTALMENT_SIZE#" index="x">
			<tr>
				<td><cfif x Eq 1>Tek Çekim<cfelse><cfoutput>#x#</cfoutput> Taksit</cfif></td>
				<cfloop from="1" to="#get_account_names.recordCount#" index="y">
				<td class="grpText"><cfif arrayIsDefined(account_array[y],x)><cfoutput>
					<input type="hidden" name="vft_rte" id="vft_rte#account_array[y][x].current_row#" value="">
					<input type="hidden" name="vft_kredi" id="vft_kredi#account_array[y][x].current_row#" value="">
					<input type="hidden" name="action_value" id="action_value#account_array[y][x].current_row#" value="" />
					<input type="hidden" name="cari_action_value" id="cari_action_value#account_array[y][x].current_row#" value="" />
					<input type="hidden" name="payment_type_name" id="payment_type_name#account_array[y][x].current_row#" value="#account_array[y][x].card_no#" />
					<input type="hidden" name="account_currency_id" id="account_currency_id#account_array[y][x].current_row#" value="#account_array[y][x].account_currency_id#" />
					<input type="radio" name="action_to_account_id" id="action_to_account_id#account_array[y][x].current_row#" class="mt-1" value="#account_array[y][x].account_id#;#account_array[y][x].account_currency_id#;#account_array[y][x].payment_type_id#;#account_array[y][x].pos_id#;0;#account_array[y][x].number_of_instalment#;#account_array[y][x].payment_rate#;#account_array[y][x].is_comission_total_amount#;#account_array[y][x].is_secure#" onclick="actionValueControl(#account_array[y][x].current_row#);show_jokervada(this.value);set_vft(#account_array[y][x].current_row#);" <cfif isDefined("attributes.action_to_account_id") and attributes.action_to_account_id eq account_array[y][x].payment_type_id>checked<cfelseif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>disabled</cfif>>
					<cfif isDefined("attributes.action_to_account_id") and attributes.action_to_account_id eq account_array[y][x].payment_type_id>
						<script type="text/javascript">
							show_jokervada("#account_array[y][x].account_id#;#account_array[y][x].account_currency_id#;#account_array[y][x].payment_type_id#;#account_array[y][x].pos_id#;0;#account_array[y][x].number_of_instalment#;#account_array[y][x].payment_rate#;#account_array[y][x].is_comission_total_amount#");
						</script>
					</cfif>
					<label for="action_to_account_id#account_array[y][x].current_row#"><span id="action_value_taksit#account_array[y][x].current_row#"></span></label></cfoutput></cfif></td>
				</cfloop>
			</tr>
			</cfloop>
		</tbody>
		<!--- <cfif get_accounts.recordcount>
			<tbody>
			<cfoutput query="get_accounts">
				<tr>
					<td>
						
						<label>
							<input type="hidden" name="vft_rte" id="vft_rte" value="">
							<input type="hidden" name="vft_kredi" id="vft_kredi" value="">
							<input type="radio" name="action_to_account_id" id="action_to_account_id" class="mt-1" value="#account_id#;#account_currency_id#;#payment_type_id#;#pos_id#;0;#number_of_instalment#;#payment_rate#;#is_comission_total_amount#;#is_secure#" onclick="actionValueControl(#currentrow#);show_jokervada(this.value);set_vft(#currentrow#);" <cfif isDefined("attributes.action_to_account_id") and attributes.action_to_account_id eq payment_type_id>checked<cfelseif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>disabled</cfif>>
							<cfif isDefined("attributes.action_to_account_id") and attributes.action_to_account_id eq payment_type_id>
								<script type="text/javascript">
									show_jokervada("#account_id#;#account_currency_id#;#payment_type_id#;#pos_type#;0;#number_of_instalment#;#payment_rate#;#is_comission_total_amount#");
								</script>
							</cfif>
							#card_no#
						</label>
					</td>
					<cfif isdefined("attributes.is_view_commision") and attributes.is_view_commision eq 1>
						<td  style="text-align:right;">%<cfif len(payment_rate_dsp)>#TLFormat(payment_rate_dsp)#<cfelse>0</cfif></td>
					</cfif>
					<cfif isdefined('attributes.is_payment_rate')>
						<td  style="text-align:right;">%<cfif len(payment_rate)>#TLFormat(payment_rate)#<cfelse>0</cfif></td>
					</cfif>
					<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
						<td  style="text-align:right;"><input type="text" name="action_value_taksit#currentrow#" id="action_value_taksit#currentrow#" value="" class="box" style="width:70px; text-align:right;" readonly=""></td>
					</cfif>
					<cfif isdefined('attributes.is_comission_total_amount') and attributes.is_comission_total_amount eq 1>
						<td  style="text-align:right;"><input type="text" name="cari_action_value#currentrow#" id="cari_action_value#currentrow#" value="" class="box" style="width:70px; text-align:right;" readonly=""></td>
					<cfelse>
						<input type="hidden" name="cari_action_value#currentrow#" id="cari_action_value#currentrow#" value="" class="box" style="width:70px; text-align:right;" readonly="">
					</cfif>
					<td  style="text-align:right;"><input type="text" name="action_value#currentrow#" id="action_value#currentrow#" value="" class="box" style="width:70px; text-align:right;" readonly=""></td>
					<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1>
						<td  id="vft_rate_#currentrow#" style="text-align:right;"></td>
						<td  class="formbold" id="vft_kredi_taksit_tutar_#currentrow#" style="text-align:right;"></td>
					</cfif>
				</tr>
			</cfoutput>
			</tbody>
		</cfif> --->
	</table>
	<div id="selected_type" class="selected_type"></div>
</div>

<script type="text/javascript">
	$(document).ready(function(){
		$('.grpText').hover(function() {
			$(this).addClass("highlight_td");
		}, function() {
			$(this).removeClass("highlight_td");
		});
	});
	
	var pay_method_control = 0;
	add_payment_rate();
	function add_payment_rate()
	{ 
		if(document.getElementById('account_recordcount') != undefined)
			document.getElementById('account_recordcount').value = <cfoutput>#get_accounts.recordcount#</cfoutput>;
		
		if(document.getElementById('sales_credit_dsp').value != "")
		{
			<cfif get_accounts.recordcount>
				<cfoutput query="get_accounts">
					<cfif len(get_accounts.payment_rate) and get_accounts.payment_rate gt 0>
						<cfif get_accounts.is_comission_total_amount eq 1>
							document.getElementById('action_value#currentrow#').value = commaSplit(filterNum(document.getElementById('sales_credit_dsp').value));
							document.getElementById('cari_action_value#currentrow#').value = commaSplit(parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) - (parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) * (parseFloat(#get_accounts.payment_rate#)/100)));
						<cfelse>
							document.getElementById('action_value#currentrow#').value = commaSplit(parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) + (parseFloat(filterNum(document.getElementById('sales_credit_dsp').value)) * (parseFloat(#get_accounts.payment_rate#)/100)));
							document.getElementById('cari_action_value#currentrow#').value = document.getElementById('action_value#currentrow#').value;
						</cfif>
						<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
							<cfif len(get_accounts.number_of_instalment) and get_accounts.number_of_instalment gt 0>
								document.getElementById('action_value_taksit#currentrow#').innerHTML = commaSplit(filterNum(document.getElementById('action_value#currentrow#').value)/#get_accounts.number_of_instalment#);
							<cfelse>
								document.getElementById('action_value_taksit#currentrow#').innerHTML = document.getElementById('action_value#currentrow#').value;
							</cfif>
						</cfif>
					<cfelse>
						document.getElementById('action_value#currentrow#').value = commaSplit(filterNum(document.getElementById('sales_credit_dsp').value));
						document.getElementById('cari_action_value#currentrow#').value = document.getElementById('action_value#currentrow#').value;
						<cfif (isdefined("attributes.is_view_multiplier") and attributes.is_view_multiplier eq 1) or not isdefined("attributes.is_view_multiplier")>
							<cfif len(get_accounts.number_of_instalment) and get_accounts.number_of_instalment gt 0>
								document.getElementById('action_value_taksit#currentrow#').innerHTML = commaSplit(filterNum(document.getElementById('sales_credit_dsp').value)/#get_accounts.number_of_instalment#);
							<cfelse>
								document.getElementById('action_value_taksit#currentrow#').innerHTML = commaSplit(filterNum(document.getElementById('sales_credit_dsp').value));
							</cfif>
						</cfif>
					</cfif>
					if(document.add_online_pos.action_to_account_id.length != undefined)
						if(document.add_online_pos.action_to_account_id[#currentrow-1#].checked)
							document.getElementById('sales_credit').value = document.getElementById('action_value#currentrow#').value;
					else
						if(document.add_online_pos.action_to_account_id.checked)
							document.getElementById('sales_credit').value = document.getElementById('action_value#currentrow#').value;
					<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1 and len(vft_rate)>
						vft_rt = #vft_rate#;
						vft_rate_#currentrow#.innerHTML = '%';
						vft_rate_#currentrow#.innerHTML += vft_rt;
						vft_kredi_taksit_tutar_#currentrow#.innerHTML = commaSplit(wrk_round(filterNum(document.getElementById('action_value#currentrow#').value)) + wrk_round(filterNum(document.getElementById('action_value#currentrow#').value) * (vft_rt/100)));
						document.getElementById('vft_rte#currentrow#').value = vft_rt;
						document.getElementById('vft_kredi#currentrow#').value = vft_kredi_taksit_tutar_#currentrow#.innerHTML;
					</cfif>
				</cfoutput>
			</cfif>
		}
	}
	
	function kontrol2()
	{
		<cfoutput query="get_accounts">
			if(#get_accounts.recordcount# == 1)
				{if(document.add_online_pos.action_to_account_id.checked)
					pay_method_control=1;}
			else if(#get_accounts.recordcount# > 1)		
				if(document.add_online_pos.action_to_account_id[#currentrow-1#].checked)
					pay_method_control=1;
		</cfoutput>
	
		if(pay_method_control==0)				
		{
			alert("Ödeme Yöntemi Seçiniz");
			return false;
		}
		return true;
	}
	
	function set_vft(idx)
	{
		<cfif get_accounts.recordcount>
			<cfoutput query="get_accounts">
				<cfif isdefined('attributes.is_vft_total') and attributes.is_vft_total eq 1 and len(VFT_RATE)>
					if (#currentrow# == idx)
					{
						document.getElementById('vft_rte#currentrow#').value = #vft_rate#;
						vft_rt = #vft_rate#;
						document.getElementById('vft_kredi#currentrow#').value = commaSplit(wrk_round(filterNum(eval("document.getElementById('action_value" + idx + "')").value)) + wrk_round(filterNum(eval("document.getElementById('action_value" + idx + "')").value) * (vft_rt/100)));
					}
				</cfif>
			</cfoutput>
		</cfif>
	}
	
	function actionValueControl(x)
	{
		if(document.getElementById('sales_credit_dsp').value == '')
		{
			alert('Lütfen Önce Tutar Giriniz!');
			<cfif get_accounts.recordcount eq 1>
				document.add_online_pos.action_to_account_id.checked = false;
			<cfelse>
				document.add_online_pos.action_to_account_id[x-1].checked = false;
			</cfif>
			return false;
		}
		else{
			document.getElementById('selected_type').innerHTML = 'Seçiminiz: ' + document.getElementById('payment_type_name' + x).value + ' = ' + document.getElementById('cari_action_value' + x).value + ' ' + document.getElementById('account_currency_id' + x).value;
		}
	}
</script>