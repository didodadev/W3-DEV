<!--- 
Girilen tarih aralığında ve aktif olunan dönemde tüm cari hareketlerden yola çıkarak alış-satış-iade faturaları, masraf gelir fişleri, banka hareketlerini,
finans senaryo ,stok-maliyet bilgilerini getirir.
Aysenur20070122
 --->
<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cfquery name="GET_MONEY_INFO" datasource="#dsn2#">
	SELECT (RATE2/RATE1) RATE_INFO FROM SETUP_MONEY WHERE MONEY = '#session.ep.money2#'
</cfquery>
<cfquery name="our_company" datasource="#dsn#">
	SELECT
		O.COMP_ID,
		O.COMPANY_NAME,
		O.NICK_NAME
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		EP.POSITION_ID IN (SELECT POSITION_ID FROM EMPLOYEE_POSITION_PERIODS WHERE PERIOD_ID = SP.PERIOD_ID) AND
		EP.POSITION_CODE = #session.ep.position_code# AND
		SP.PERIOD_YEAR = #session.ep.period_year# AND
		O.COMP_STATUS = 1
	ORDER BY
		COMPANY_NAME
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME,COMPANY_ID FROM BRANCH WHERE BRANCH_STATUS = 1
</cfquery>
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#date_add('d',-1,attributes.finishdate)#">
<cfparam name="attributes.money" default="#session.ep.money#,1">
<cfparam name="attributes.our_company_ids" default="#session.ep.company_id#">
<cfparam name="attributes.branch_id" default="">
<cfset inventory_total = 0>
<cfset cost_total = 0>
<cfprocessingdirective suppresswhitespace="yes">
<cfif isdefined("attributes.form_varmi")>
	<cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
	<cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	<cfquery name="GET_ACTIVITY_SUMMARY_DAILY" datasource="#dsn2#">
		SELECT
			SUM(GET_PURCHASES) GET_PURCHASES,
			SUM(GET_PURCHASES2) GET_PURCHASES2,
			SUM(GET_PURCHASES_PAPERS) GET_PURCHASES_PAPERS,
			SUM(GET_PURCHASE_DIFF) GET_PURCHASE_DIFF,
			SUM(GET_PURCHASE_DIFF2) GET_PURCHASE_DIFF2,
			SUM(GET_PURCHASE_DIFF_PAPERS) GET_PURCHASE_DIFF_PAPERS,
			SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
			SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
			SUM(GET_PURCHASE_RETURN_PAPERS) GET_PURCHASE_RETURN_PAPERS,
			SUM(GET_EXPENSE) GET_EXPENSE,
			SUM(GET_EXPENSE2) GET_EXPENSE2,
			SUM(GET_EXPENSE_PAPERS) GET_EXPENSE_PAPERS,
			SUM(GET_SALES) GET_SALES,
			SUM(GET_SALES2) GET_SALES2,
			SUM(GET_SALES_PAPERS) GET_SALES_PAPERS,
            SUM(GET_SALES_CANCELED) GET_SALES_CANCELED,
			SUM(GET_SALES2_CANCELED) GET_SALES2_CANCELED,
			SUM(GET_SALES_PAPERS_CANCELED) GET_SALES_PAPERS_CANCELED,
			SUM(GET_SALES_DIFF) GET_SALES_DIFF,
			SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
			SUM(GET_SALES_DIFF_PAPERS) GET_SALES_DIFF_PAPERS,
			SUM(GET_SALES_RETURN) GET_SALES_RETURN,
			SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
			SUM(GET_SALES_RETURN_PAPERS) GET_SALES_RETURN_PAPERS,
			SUM(GET_INCOME) GET_INCOME,
			SUM(GET_INCOME2) GET_INCOME2,
			SUM(GET_INCOME_PAPERS) GET_INCOME_PAPERS,
			SUM(GET_CASH) GET_CASH,
			SUM(GET_CASH2) GET_CASH2,
			SUM(GET_CASH_PAPERS) GET_CASH_PAPERS,
			SUM(GET_CHEQUE) GET_CHEQUE,
			SUM(GET_CHEQUE2)GET_CHEQUE2,
			SUM(GET_CHEQUE_PAPERS) GET_CHEQUE_PAPERS,
			SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
			SUM(GET_CHEQUE2_RETURN)GET_CHEQUE2_RETURN,
			SUM(GET_CHEQUE_RETURN_PAPERS) GET_CHEQUE_RETURN_PAPERS,
			SUM(GET_VOUCHER) GET_VOUCHER,		
			SUM(GET_VOUCHER2) GET_VOUCHER2,
			SUM(GET_VOUCHER_PAPERS) GET_VOUCHER_PAPERS,
			SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
			SUM(GET_VOUCHER2_RETURN) GET_VOUCHER2_RETURN,
			SUM(GET_VOUCHER_RETURN_PAPERS) GET_VOUCHER_RETURN_PAPERS,
			SUM(GET_REVENUE) GET_REVENUE,
			SUM(GET_REVENUE2)GET_REVENUE2,
			SUM(GET_REVENUE_PAPERS) GET_REVENUE_PAPERS,
			SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
			SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
			SUM(GET_CREDIT_REVENUE_PAPERS) GET_CREDIT_REVENUE_PAPERS,
			SUM(GET_PAYM) GET_PAYM,
			SUM(GET_PAYM2)GET_PAYM2,
			SUM(GET_PAYM_PAPERS) GET_PAYM_PAPERS,
			SUM(GET_CHEQUE_P) GET_CHEQUE_P,
			SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
			SUM(GET_CHEQUE_P_PAPERS) GET_CHEQUE_P_PAPERS,
			SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
			SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P2_RETURN,
			SUM(GET_CHEQUE_P_RETURN_PAPERS) GET_CHEQUE_P_RETURN_PAPERS,
			SUM(GET_VOUCHER_P) GET_VOUCHER_P,	
			SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
			SUM(GET_VOUCHER_P_PAPERS) GET_VOUCHER_P_PAPERS,	
			SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
			SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P2_RETURN,
			SUM(GET_VOUCHER_P_RETURN_PAPERS) GET_VOUCHER_P_RETURN_PAPERS,
			SUM(GET_PAYMENTS) GET_PAYMENTS,
			SUM(GET_PAYMENTS2) GET_PAYMENTS2,
			SUM(GET_PAYMENTS_PAPERS) GET_PAYMENTS_PAPERS,
			SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
			SUM(GET_CREDIT_PAYMENTS2) GET_CREDIT_PAYMENTS2,
			SUM(GET_CREDIT_PAYMENTS_PAPERS) GET_CREDIT_PAYMENTS_PAPERS,					
			SUM(GET_RECEIPT) GET_RECEIPT,
			SUM(GET_RECEIPT2) GET_RECEIPT2,
			SUM(GET_RECEIPT_PAPERS) GET_RECEIPT_PAPERS,
			SUM(GET_RECEIVE_RECEIPT) GET_RECEIVE_RECEIPT,
			SUM(GET_RECEIVE_RECEIPT2) GET_RECEIVE_RECEIPT2,
			SUM(GET_RECEIVE_RECEIPT_PAPERS) GET_RECEIVE_RECEIPT_PAPERS,
			SUM(GET_DEPT_RECEIPT) GET_DEPT_RECEIPT,
			SUM(GET_DEPT_RECEIPT2) GET_DEPT_RECEIPT2,
			SUM(GET_DEPT_RECEIPT_PAPERS) GET_DEPT_RECEIPT_PAPERS
		FROM
			(
			<cfloop list="#attributes.our_company_ids#" index="comp_ii">
				SELECT 
					SUM(GET_PURCHASES) GET_PURCHASES,
					SUM(GET_PURCHASES2) GET_PURCHASES2,
					SUM(GET_PURCHASES_PAPERS) GET_PURCHASES_PAPERS,
					SUM(GET_PURCHASE_DIFF) GET_PURCHASE_DIFF,
					SUM(GET_PURCHASE_DIFF2) GET_PURCHASE_DIFF2,
					SUM(GET_PURCHASE_DIFF_PAPERS) GET_PURCHASE_DIFF_PAPERS,
					SUM(GET_PURCHASE_RETURN) GET_PURCHASE_RETURN,
					SUM(GET_PURCHASE_RETURN2) GET_PURCHASE_RETURN2,
					SUM(GET_PURCHASE_RETURN_PAPERS) GET_PURCHASE_RETURN_PAPERS,
					SUM(GET_EXPENSE) GET_EXPENSE,
					SUM(GET_EXPENSE2) GET_EXPENSE2,
					SUM(GET_EXPENSE_PAPERS) GET_EXPENSE_PAPERS,
					SUM(GET_SALES) GET_SALES,
					SUM(GET_SALES2) GET_SALES2,
					SUM(GET_SALES_PAPERS) GET_SALES_PAPERS,
                    SUM(GET_SALES_CANCELED) GET_SALES_CANCELED,
                    SUM(GET_SALES2_CANCELED) GET_SALES2_CANCELED,
                    SUM(GET_SALES_PAPERS_CANCELED) GET_SALES_PAPERS_CANCELED,
					SUM(GET_SALES_DIFF) GET_SALES_DIFF,
					SUM(GET_SALES_DIFF2) GET_SALES_DIFF2,
					SUM(GET_SALES_DIFF_PAPERS) GET_SALES_DIFF_PAPERS,
					SUM(GET_SALES_RETURN) GET_SALES_RETURN,
					SUM(GET_SALES_RETURN2) GET_SALES_RETURN2,
					SUM(GET_SALES_RETURN_PAPERS) GET_SALES_RETURN_PAPERS,
					SUM(GET_INCOME) GET_INCOME,
					SUM(GET_INCOME2) GET_INCOME2,
					SUM(GET_INCOME_PAPERS) GET_INCOME_PAPERS,
					SUM(GET_CASH) GET_CASH,
					SUM(GET_CASH2) GET_CASH2,
					SUM(GET_CASH_PAPERS) GET_CASH_PAPERS,
					SUM(GET_CHEQUE) GET_CHEQUE,
					SUM(GET_CHEQUE2)GET_CHEQUE2,
					SUM(GET_CHEQUE_PAPERS) GET_CHEQUE_PAPERS,
					SUM(GET_CHEQUE_RETURN) GET_CHEQUE_RETURN,
					SUM(GET_CHEQUE2_RETURN)GET_CHEQUE2_RETURN,
					SUM(GET_CHEQUE_RETURN_PAPERS) GET_CHEQUE_RETURN_PAPERS,
					SUM(GET_VOUCHER) GET_VOUCHER,		
					SUM(GET_VOUCHER2) GET_VOUCHER2,
					SUM(GET_VOUCHER_PAPERS) GET_VOUCHER_PAPERS,
					SUM(GET_VOUCHER_RETURN) GET_VOUCHER_RETURN,
					SUM(GET_VOUCHER2_RETURN) GET_VOUCHER2_RETURN,
					SUM(GET_VOUCHER_RETURN_PAPERS) GET_VOUCHER_RETURN_PAPERS,
					SUM(GET_REVENUE) GET_REVENUE,
					SUM(GET_REVENUE2)GET_REVENUE2,
					SUM(GET_REVENUE_PAPERS) GET_REVENUE_PAPERS,
					SUM(GET_CREDIT_REVENUE) GET_CREDIT_REVENUE,
					SUM(GET_CREDIT_REVENUE2)GET_CREDIT_REVENUE2,
					SUM(GET_CREDIT_REVENUE_PAPERS) GET_CREDIT_REVENUE_PAPERS,
					SUM(GET_PAYM) GET_PAYM,
					SUM(GET_PAYM2)GET_PAYM2,
					SUM(GET_PAYM_PAPERS) GET_PAYM_PAPERS,
					SUM(GET_CHEQUE_P) GET_CHEQUE_P,
					SUM(GET_CHEQUE_P2) GET_CHEQUE_P2,
					SUM(GET_CHEQUE_P_PAPERS) GET_CHEQUE_P_PAPERS,
					SUM(GET_CHEQUE_P_RETURN) GET_CHEQUE_P_RETURN,
					SUM(GET_CHEQUE_P2_RETURN) GET_CHEQUE_P2_RETURN,
					SUM(GET_CHEQUE_P_RETURN_PAPERS) GET_CHEQUE_P_RETURN_PAPERS,
					SUM(GET_VOUCHER_P) GET_VOUCHER_P,	
					SUM(GET_VOUCHER_P2) GET_VOUCHER_P2,
					SUM(GET_VOUCHER_P_PAPERS) GET_VOUCHER_P_PAPERS,	
					SUM(GET_VOUCHER_P_RETURN) GET_VOUCHER_P_RETURN,
					SUM(GET_VOUCHER_P2_RETURN) GET_VOUCHER_P2_RETURN,
					SUM(GET_VOUCHER_P_RETURN_PAPERS) GET_VOUCHER_P_RETURN_PAPERS,
					SUM(GET_PAYMENTS) GET_PAYMENTS,
					SUM(GET_PAYMENTS2) GET_PAYMENTS2,
					SUM(GET_PAYMENTS_PAPERS) GET_PAYMENTS_PAPERS,
					SUM(GET_CREDIT_PAYMENTS) GET_CREDIT_PAYMENTS,
					SUM(GET_CREDIT_PAYMENTS2) GET_CREDIT_PAYMENTS2,
					SUM(GET_CREDIT_PAYMENTS_PAPERS) GET_CREDIT_PAYMENTS_PAPERS,					
					SUM(GET_RECEIPT) GET_RECEIPT,
					SUM(GET_RECEIPT2) GET_RECEIPT2,
					SUM(GET_RECEIPT_PAPERS) GET_RECEIPT_PAPERS,
					SUM(GET_RECEIVE_RECEIPT) GET_RECEIVE_RECEIPT,
					SUM(GET_RECEIVE_RECEIPT2) GET_RECEIVE_RECEIPT2,
					SUM(GET_RECEIVE_RECEIPT_PAPERS) GET_RECEIVE_RECEIPT_PAPERS,
					SUM(GET_DEPT_RECEIPT) GET_DEPT_RECEIPT,
					SUM(GET_DEPT_RECEIPT2) GET_DEPT_RECEIPT2,
					SUM(GET_DEPT_RECEIPT_PAPERS) GET_DEPT_RECEIPT_PAPERS
				FROM
					#dsn#_#session.ep.period_year#_#comp_ii#.ACTIVITY_SUMMARY_DAILY AS ACTIVITY_SUMMARY_DAILY			
				WHERE
					ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				<cfif len(attributes.branch_id)>
					AND
					(
						FROM_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> OR
						TO_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
					)
				</cfif>
				<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
			</cfloop>
			) AS ACTIVITY_SUMMARY_DAILY2
	</cfquery>
	<!--- Sabit kıymetler --->
	<cfquery name="GET_INVENTORY" datasource="#dsn3#">
		SELECT
			SUM(LAST_INVENTORY_VALUE) AS LAST_INVENTORY_VALUE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				(LAST_INVENTORY_VALUE*ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY)) AS LAST_INVENTORY_VALUE
			FROM
				#dsn#_#comp_ii#.INVENTORY AS I			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS INVENTORY2
	</cfquery>
	<cfif len(GET_INVENTORY.LAST_INVENTORY_VALUE)>
		<cfset inventory_total = GET_INVENTORY.LAST_INVENTORY_VALUE>
	<cfelse>
		<cfset inventory_total = 0>
	</cfif>
	
	<!--- aktif stok değeri --->
	<cfquery name="GET_STOCKS_INFO" datasource="#DSN2#">
		SELECT 
			SUM(COST_PRICE) COST_PRICE
		FROM
		(
			SELECT 
				SUM(STOCK_IN-STOCK_OUT)*(SELECT TOP 1 
											(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM) 
										FROM 
											GET_PRODUCT_COST_PERIOD 
										WHERE 
											START_DATE <= #now()#
											AND PRODUCT_ID=STOCKS_ROW.PRODUCT_ID 
											AND ISNULL(SPECT_MAIN_ID,0)=ISNULL(STOCKS_ROW.SPECT_VAR_ID,0) 
										ORDER BY 
											START_DATE DESC,
											RECORD_DATE DESC, 
											PRODUCT_COST_ID DESC
										) 
				COST_PRICE,
				PRODUCT_ID
			FROM
				STOCKS_ROW
			WHERE
				PROCESS_TYPE NOT IN (81,811)<!--- depolar arası olan belgeler alınmıyor bu yüzden stok analizinde depo seçerek çalıştırıldığında tutmayabilir--->
				AND PROCESS_DATE <= #now()#
			GROUP BY
				PRODUCT_ID,
				SPECT_VAR_ID
		) T1
	</cfquery>
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
</cfif>
<!--- <table class="dph">
	<tr>
    	<td class="dpht"><a href="javascript:gizle_goster_ikili('activity_summary','activity_summary_basket');" >&raquo;</a><cf_get_lang dictionary_id ='57921.Cari Faaliyet Özeti'></td>
		<td class="dphb"><!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'><!-- sil --></td>
	</tr>
</table>	 --->
<cfsavecontent variable="head"><cf_get_lang dictionary_id ='57921.Cari Faaliyet Özeti'></cfsavecontent>

<cfsavecontent  variable="title"><cf_get_lang dictionary_id="57434.Rapor"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#head#" id="activity_summary">
	<cfform name="form_search" action="#request.self#?fuseaction=report.activity_summary" method="post">
		<input type="hidden" value="1" name="form_varmi" id="form_varmi">
        <cf_box_elements vertical="1">
            <div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
                <label><cf_get_lang dictionary_id='29531.Şirketler'></label>
				<select multiple name="our_company_ids" id="our_company_ids" onchange="select_branch();">
					<cfoutput query="our_company">
					<option value="#comp_id#" <cfif listfind(attributes.our_company_ids,comp_id,',')>selected</cfif>>#nick_name#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
				<label><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></label>
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="startdate" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
				</div>
			</div>
			<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
				<label><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></label>
                <div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="finishdate" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
				</div>
			</div>
			<div class="form-group col col-3 col-md-3 col-sm-6 col-xs-12">
				<label><cf_get_lang dictionary_id='57453.Şube'></label>
				<select name="branch_id" id="branch_id">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<!---<cfif isdefined("attributes.our_company_ids") and len(attributes.our_company_ids)>--->
						<cfquery name="get_branches" dbtype="query">
							SELECT BRANCH_ID,BRANCH_NAME FROM GET_BRANCH WHERE COMPANY_ID IN (<cfif isDefined("attributes.our_company_ids") and len(attributes.our_company_ids)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_ids#" list="yes"></cfif>)
						</cfquery>                        
						<cfoutput query="get_branches">
							<option value="#BRANCH_ID#" <cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
						</cfoutput>
					<!---</cfif>--->
				</select>
            </div>
        </cf_box_elements>
        <div class="ui-form-list-btn flex-end">
        	<cf_wrk_search_button button_type='5' is_excel='0'>
        </div>
	</cfform>
</cf_box>
<cfif isdefined("attributes.form_varmi")>
	<!--- Açık sipariş ve irsaliyeler --->
	<cfscript>
		CreateCompenent = CreateObject("component","/../workdata/get_open_order_ships");
		get_open_order_ships = CreateCompenent.getCompenentFunction(our_company_id:attributes.our_company_ids,is_purchase:0);
		get_open_order_ships_pur = CreateCompenent.getCompenentFunction(our_company_id:attributes.our_company_ids,is_purchase:1);
		order_total = get_open_order_ships.order_total;
		order_total_purchase = -1*get_open_order_ships_pur.order_total;
		ship_total = get_open_order_ships.ship_total;
		ship_total_purchase = -1*get_open_order_ships_pur.ship_total;
	</cfscript>
	<cfquery name="GET_CHEQUE_IN_CASH" datasource="#DSN2#">
		SELECT 
			SUM(BAKIYE) AS BAKIYE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE) AS BAKIYE
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_IN_CASH_TOTAL AS CHEQUE_IN_CASH_TOTAL			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS CHEQUE_IN_CASH_TOTAL2
	</cfquery>
	<cfquery name="GET_CHEQUE_IN_BANK" datasource="#DSN2#">
		SELECT
			SUM(BORC) AS BORC
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BORC) AS BORC
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_IN_BANK AS CHEQUE_IN_BANK			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS CHEQUE_IN_BANK2
	</cfquery>
	<cfquery name="GET_CHEQUE_IN_GUARANTEE" datasource="#DSN2#">
		SELECT
			SUM(TEMINAT_CEKLER) AS TEMINAT_CEKLER
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(TEMINAT_CEKLER) AS TEMINAT_CEKLER
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_IN_GUARANTEE AS CHEQUE_IN_GUARANTEE			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS CHEQUE_IN_GUARANTEE2
	</cfquery>
	<cfquery name="GET_VOUCHER_IN_GUARANTEE" datasource="#DSN2#">
		SELECT
			SUM(TEMINAT_SENET) AS TEMINAT_SENETLER
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(TEMINAT_SENET) AS TEMINAT_SENET
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_IN_GUARANTEE AS VOUCHER_IN_GUARANTEE			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VOUCHER_IN_GUARANTEE2
	</cfquery>
	<cfquery name="GET_CHEQUE_TO_PAY" datasource="#DSN2#">
		SELECT
			SUM(BORC) AS BORC
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BORC) AS BORC
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CHEQUE_TO_PAY AS CHEQUE_TO_PAY			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS CHEQUE_TO_PAY2
	</cfquery>
	<cfquery name="GET_VOUCHER_TO_PAY" datasource="#DSN2#">
		SELECT
			SUM(BORC) AS BORC
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BORC) AS BORC
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_TO_PAY AS VOUCHER_TO_PAY			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VOUCHER_TO_PAY2
	</cfquery>
	<cfquery name="GET_VOUCHER_IN_BANK" datasource="#DSN2#">
		SELECT
			SUM(BORC) AS BORC
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BORC) AS BORC
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_IN_BANK AS VOUCHER_IN_BANK			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VOUCHER_IN_BANK2
	</cfquery>
	<cfquery name="GET_VOUCHER_IN_CASH" datasource="#DSN2#">
		SELECT
			SUM(BORC) AS BORC
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BORC) AS BORC
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.VOUCHER_IN_CASH AS VOUCHER_IN_CASH			
			<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VOUCHER_IN_CASH2
	</cfquery>
	<cfquery name="GET_CASH_TOTAL" datasource="#DSN2#">
		SELECT
			SUM(CASH_TOTAL) AS CASH_TOTAL
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE*(SM.RATE2/SM.RATE1)) AS CASH_TOTAL
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CASH_REMAINDER_LAST CRL,
				#dsn#_#session.ep.period_year#_#comp_ii#.CASH CASH,
				#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
			WHERE
				CASH.CASH_ID = CRL.CASH_ID AND
				SM.MONEY = CASH.CASH_CURRENCY_ID
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS CASH_TOTAL2
	
	</cfquery>
	<cfquery name="GET_BANK_TOTAL" datasource="#DSN2#">
		SELECT 
			SUM(BANK_TOTAL) AS BANK_TOTAL
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE *(SM.RATE2/SM.RATE1)) AS BANK_TOTAL
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.ACCOUNT_REMAINDER_LAST ACCOUNT_REMAINDER_LAST,
				#dsn#_#session.ep.period_year#_#comp_ii#.SETUP_MONEY SM
			WHERE
				SM.MONEY = ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID
				<cfif session.ep.period_year lt 2009>
					OR 
					(SM.MONEY = 'YTL' AND ACCOUNT_REMAINDER_LAST.ACCOUNT_CURRENCY_ID = 'TL')
				</cfif>
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS BANK_TOTAL2
	</cfquery>
	<cfquery name="GET_COMP_DEBT" datasource="#DSN2#">
		SELECT
			SUM(TOTAL_COMP_DEBT) AS TOTAL_COMP_DEBT
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE) AS TOTAL_COMP_DEBT
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.COMPANY_REMAINDER
			WHERE
				BAKIYE < 0
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS TOTAL_COMP_DEBT2
	</cfquery>
	<cfset TOTAL_COMP_DEBT=get_comp_debt.TOTAL_COMP_DEBT>
	<cfif not len(get_comp_debt.TOTAL_COMP_DEBT)>
		<cfset TOTAL_COMP_DEBT=0>
	</cfif>
	<cfquery name="GET_COMP_CLAIM" datasource="#DSN2#">
		SELECT
			SUM(TOTAL_COMP_CLAIM) AS TOTAL_COMP_CLAIM
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE) AS TOTAL_COMP_CLAIM
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.COMPANY_REMAINDER
			WHERE
				BAKIYE >= 0
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS TOTAL_COMP_CLAIM2
	</cfquery>
	<cfset TOTAL_COMP_CLAIM=wrk_round(get_comp_claim.TOTAL_COMP_CLAIM,2)>
	<cfif not len(get_comp_claim.TOTAL_COMP_CLAIM)>
		<cfset TOTAL_COMP_CLAIM=0>
	</cfif>
	<cfquery name="GET_CONS_DEBT" datasource="#DSN2#">
		SELECT
			SUM(TOTAL_CONS_DEBT) AS TOTAL_CONS_DEBT
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE) AS TOTAL_CONS_DEBT
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CONSUMER_REMAINDER
			WHERE
				BAKIYE < 0
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS TOTAL_CONS_DEBT2
	</cfquery>
	<cfset TOTAL_CONS_DEBT=get_cons_debt.TOTAL_CONS_DEBT>
	<cfif not len(get_cons_debt.TOTAL_CONS_DEBT)>
		<cfset TOTAL_CONS_DEBT=0>
	</cfif>
	<cfquery name="GET_CONS_CLAIM" datasource="#DSN2#">
		SELECT
			SUM(TOTAL_CONS_CLAIM) AS TOTAL_CONS_CLAIM
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM(BAKIYE) AS TOTAL_CONS_CLAIM
			FROM
				#dsn#_#session.ep.period_year#_#comp_ii#.CONSUMER_REMAINDER
			WHERE
				BAKIYE >= 0
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS TOTAL_CONS_CLAIM2
	</cfquery>
	<cfset TOTAL_CONS_CLAIM=get_cons_claim.TOTAL_CONS_CLAIM>
	<cfif not len(get_cons_claim.TOTAL_CONS_CLAIM)>
		<cfset TOTAL_CONS_CLAIM=0>
	</cfif>
	<cfquery name="GET_CREDIT_CARD_PAYMENTS" datasource="#dsn3#">
		SELECT
			SUM(VALUE) AS VALUE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT 
				SUM((CASE WHEN CCP.ACTION_TYPE_ID = 245 THEN CR.AMOUNT ELSE -CR.AMOUNT END)) AS VALUE
			FROM
				#dsn#_#comp_ii#.CREDIT_CARD_BANK_PAYMENTS_ROWS CR,
				#dsn#_#comp_ii#.CREDIT_CARD_BANK_PAYMENTS CCP
			WHERE
				CR.CREDITCARD_PAYMENT_ID = CCP.CREDITCARD_PAYMENT_ID AND
				ISNULL(CCP.IS_VOID,0) <> 1 AND
				ISNULL(CCP.RELATION_CREDITCARD_PAYMENT_ID,0) NOT IN (SELECT CCBP.CREDITCARD_PAYMENT_ID FROM #dsn#_#comp_ii#.CREDIT_CARD_BANK_PAYMENTS CCBP WHERE ISNULL(CCBP.IS_VOID,0) = 1) AND
				CR.BANK_ACTION_ID IS NULL AND
				CR.AMOUNT > 0
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
	</cfquery>
	<cfquery name="GET_SCN_REV" datasource="#dsn2#">
		SELECT
			SUM(VALUE) AS VALUE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(VALUE1-VALUE2) VALUE
			FROM
			(
				SELECT
					SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE1,
					0 VALUE2
				FROM
					#dsn#_#comp_ii#.CREDIT_CONTRACT_ROW CC,
					#dsn#_#comp_ii#.CREDIT_CONTRACT C,
					SETUP_MONEY SM
				WHERE
					C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
					C.IS_SCENARIO = 1 AND
					CREDIT_CONTRACT_TYPE = 2 AND
					TOTAL_PRICE > 0 AND
					SM.MONEY = CC.OTHER_MONEY AND
					CC.IS_PAID = 0
			UNION ALL
				SELECT
					0 VALUE1,
					SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE2
				FROM
					#dsn#_#comp_ii#.CREDIT_CONTRACT_ROW CC,
					#dsn#_#comp_ii#.CREDIT_CONTRACT C,
					SETUP_MONEY SM
				WHERE
					C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
					C.IS_SCENARIO = 1 AND
					CREDIT_CONTRACT_TYPE = 2 AND
					TOTAL_PRICE > 0 AND
					SM.MONEY = CC.OTHER_MONEY AND
					CC.IS_PAID = 1
			) GET_SCN_REV_VALUE
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
	</cfquery>
	<cfquery name="GET_SCN_PAYM" datasource="#dsn2#">
		SELECT
			SUM(VALUE) AS VALUE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				SUM(VALUE2-VALUE1) VALUE
			FROM
			(
				SELECT
					SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE1,
					0 VALUE2
				FROM
					#dsn#_#comp_ii#.CREDIT_CONTRACT_ROW CC,
					#dsn#_#comp_ii#.CREDIT_CONTRACT C,
					SETUP_MONEY SM
				WHERE
					C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
					C.IS_SCENARIO = 1 AND
					CREDIT_CONTRACT_TYPE = 1 AND
					TOTAL_PRICE > 0 AND
					SM.MONEY = CC.OTHER_MONEY AND
					CC.IS_PAID = 0
			UNION ALL
				SELECT
					0 VALUE1,
					SUM(TOTAL_PRICE * (SM.RATE2 / SM.RATE1)) AS VALUE2
				FROM
					#dsn#_#comp_ii#.CREDIT_CONTRACT_ROW CC,
					#dsn#_#comp_ii#.CREDIT_CONTRACT C,
					SETUP_MONEY SM
				WHERE
					C.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
					C.IS_SCENARIO = 1 AND
					CREDIT_CONTRACT_TYPE = 1 AND
					TOTAL_PRICE > 0 AND
					SM.MONEY = CC.OTHER_MONEY AND
					CC.IS_PAID = 1
			) GET_SCN_PAYM_VALUE
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
	</cfquery>
	<cfquery name="GET_PAYMENTS_WITH_CC" datasource="#dsn3#">
		SELECT
			SUM(VALUE) AS VALUE
		FROM
		(
		<cfloop list="#attributes.our_company_ids#" index="comp_ii">
			SELECT
				INSTALLMENT_AMOUNT-(ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CREDIT_CARD_BANK_EXPENSE_ROWS.CC_BANK_EXPENSE_ROWS_ID),0)) VALUE
			FROM			
				#dsn#_#comp_ii#.CREDIT_CARD_BANK_EXPENSE_ROWS			
		<cfif listlen(attributes.our_company_ids) neq 1 and comp_ii neq listlast(attributes.our_company_ids,',')> UNION ALL </cfif>
		</cfloop>
		) AS VALUE2
	</cfquery>
	<cfset total_debt = 0>
	<cfset total_claim = 0>
	<cfset total_debt = TOTAL_COMP_DEBT + TOTAL_CONS_DEBT>
	<cfset total_claim = wrk_round(TOTAL_COMP_CLAIM + TOTAL_CONS_CLAIM,2)>
	
<cfscript>
	brut_alis_toplam_money2 = 0;
    brut_alis_toplam = 0;
	net_alis_toplam = 0;
	net_alis_toplam_money2 = 0;
	brut_satis_toplam_money2 = 0;
    brut_satis_toplam = 0;
	net_satis_toplam = 0;
	net_satis_toplam_money2 = 0;
	tahsilat_toplam = 0;
	tahsilat_toplam_money2 = 0;
	odeme_toplam = 0;
	odeme_toplam_money2 = 0;
	
	credit_card_total = 0;
	cc_pay_total = 0;
	scen_rev = 0;
	scen_paym = 0;
	total_cheque_cash=0;
	total_cheque_bank=0;
	total_cheque_pay=0;
	total_voucher_bank=0;
	total_voucher_pay=0;
	total_voucher_cash=0;
	total_cheque_in_quarantee=0;
	total_voucher_in_quarantee=0;
	ctotal=0;
	btotal=0;
	if(isnumeric(get_cheque_in_cash.BAKIYE))
		total_cheque_cash = total_cheque_cash + get_cheque_in_cash.BAKIYE;
	if(isnumeric(get_cheque_in_bank.BORC))
		total_cheque_bank = total_cheque_bank + get_cheque_in_bank.BORC;
	if(isnumeric(get_cheque_to_pay.BORC))
		total_cheque_pay = total_cheque_pay - get_cheque_to_pay.BORC;
	if(isnumeric(get_voucher_in_bank.BORC))
		total_voucher_bank = total_voucher_bank + get_voucher_in_bank.BORC;
	if(isnumeric(get_voucher_to_pay.BORC))
		total_voucher_pay = total_voucher_pay - get_voucher_to_pay.BORC;
	if(isnumeric(get_voucher_in_cash.BORC))
		total_voucher_cash = total_voucher_cash + get_voucher_in_cash.BORC;
	if(isnumeric(get_cash_total.CASH_TOTAL))
		ctotal = get_cash_total.CASH_TOTAL;
	if(isnumeric(get_bank_total.BANK_TOTAL))
		btotal = get_bank_total.BANK_TOTAL;

	if (len(GET_CREDIT_CARD_PAYMENTS.VALUE))credit_card_total = credit_card_total + GET_CREDIT_CARD_PAYMENTS.VALUE;
	if (len(GET_PAYMENTS_WITH_CC.VALUE))cc_pay_total = cc_pay_total + GET_PAYMENTS_WITH_CC.VALUE;
	if (len(GET_SCN_REV.VALUE))scen_rev = GET_SCN_REV.VALUE;
	if (len(GET_SCN_PAYM.VALUE))scen_paym = GET_SCN_PAYM.VALUE;
	if (len(GET_CHEQUE_IN_GUARANTEE.teminat_cekler))total_cheque_in_quarantee = total_cheque_in_quarantee + GET_CHEQUE_IN_GUARANTEE.teminat_cekler;
	if (len(GET_VOUCHER_IN_GUARANTEE.teminat_senetler))total_voucher_in_quarantee = total_voucher_in_quarantee + GET_VOUCHER_IN_GUARANTEE.teminat_senetler;
	bugunku_durum = ctotal+btotal+total_cheque_bank+total_cheque_cash+total_voucher_bank+total_voucher_cash+total_cheque_pay+total_voucher_pay+total_claim+total_debt+credit_card_total+cc_pay_total+scen_rev+scen_paym+total_cheque_in_quarantee+total_voucher_in_quarantee ;
</cfscript>
<cfoutput>

<cf_box title="#title#" uidrop="1">
	<cf_seperator title="#getlang('','Alış-Satış','48025')#" id="alissatis">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0" id="alissatis">
		<!--- alislar --->
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12">	
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="125"><cf_get_lang dictionary_id ='39821.Alışlar'></th>
						<th width="30"><cf_get_lang dictionary_id ='57468.Belge'></th>
						<th width="140" style="text-align:right;">#session.ep.money#</th>
						<th width="140" style="text-align:right;">#session.ep.money2#</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39821.Alışlar'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=55&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id='58314.Satıştan İadeler'> (+)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=51,63&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39822.Fiyat ve Vade Farkları'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><a href="#request.self#?fuseaction=report.purchase_analyse_report&date1=#attributes.startdate#&date2=#attributes.finishdate#" class="tableyazi"><cf_get_lang dictionary_id ='39823.Brüt Alış'></a>
						</td>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)><cfset brut_alis_toplam = brut_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)><cfset brut_alis_toplam = brut_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)><cfset brut_alis_toplam = brut_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF></cfif>
			
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)><cfset brut_alis_toplam_money2 = brut_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)><cfset brut_alis_toplam_money2 = brut_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)><cfset brut_alis_toplam_money2 = brut_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2></cfif>
						<td></td>
						<td style="text-align:right;">#TLFormat(brut_alis_toplam)# #session.ep.money#</td>
						<td style="text-align:right;">#TLFormat(brut_alis_toplam_money2)# #session.ep.money2#</td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=62&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39824.Alıştan İadeler'> (-)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_submitted=1&listing_type=1&type=120&search_date1=#attributes.startdate#&search_date2=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cost.list_expense_income&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='58064.Masraf Fişi'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1=1&action_type_ch=105-131&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=ch.list_caris&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='29946.Ücret Dekontu'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT2)# #session.ep.money2#</cfif></td>
					</tr> 
					<tr>
						<td><cfset Url_Address = "form_varmi=1=1&action_type_ch=26-42&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=ch.list_caris&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='57848.alacak Dekontu'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT2)# #session.ep.money2#</cfif></td>
					</tr> 
				</tbody>
			</cf_grid_list>
			<div class="ui-info-bottom  margin-bottom-5">
				<p>
					<b><cf_get_lang dictionary_id ='39826.Net Alış'> : </b>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)><cfset net_alis_toplam = net_alis_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT)><cfset net_alis_toplam = net_alis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT></cfif>
					
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASES2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_DIFF2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_EXPENSE2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIPT2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT2)><cfset net_alis_toplam_money2 = net_alis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_RECEIVE_RECEIPT2></cfif>

					#TLFormat(net_alis_toplam)# #session.ep.money# &nbsp;&nbsp;
					#TLFormat(net_alis_toplam_money2)# #session.ep.money2#
				</p>
			</div>
		</div>
		<!--- satislar--->
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="125"><cf_get_lang dictionary_id ='39545.Satışlar'></th>
						<th width="30"><cf_get_lang dictionary_id ='57468.Belge'></th>
						<th width="140" style="text-align:right;">#session.ep.money#</th>
						<th width="140" style="text-align:right;">#session.ep.money2#</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=1&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&from_report=1&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39545.Satışlar'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=1&iptal_invoice=1&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39545.Satışlar'> <cf_get_lang dictionary_id ='58506.İptal'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_PAPERS_CANCELED#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_CANCELED)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_CANCELED)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2_CANCELED)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2_CANCELED)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=62&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39824.Alıştan İadeler'> (+)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=50,58&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39822.Fiyat ve Vade Farkları'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td>
							<a href="#request.self#?fuseaction=report.sale_analyse_report&date1=#dateformat(attributes.startdate,dateformat_style)#&date2=#dateformat(attributes.finishdate,dateformat_style)#" class="tableyazi"><cf_get_lang dictionary_id ='39827.Brüt Satış'></a>
						</td>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)><cfset brut_satis_toplam = brut_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_CANCELED></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)><cfset brut_satis_toplam = brut_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)><cfset brut_satis_toplam = brut_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF></cfif>
			
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)><cfset brut_satis_toplam_money2 = brut_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2 - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2_CANCELED></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)><cfset brut_satis_toplam_money2 = brut_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2></cfif>
						<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)><cfset brut_satis_toplam_money2 = brut_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2></cfif>
						<td></td>
						<td style="text-align:right;">#TLFormat(brut_satis_toplam)# #session.ep.money#</td>
						<td style="text-align:right;">#TLFormat(brut_satis_toplam_money2)# #session.ep.money2#</td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1&cat=55&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=invoice.list_bill&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id='58314.Satıştan İadeler'> (-)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_submitted=1&listing_type=1&type=121&search_date1=#attributes.startdate#&search_date2=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cost.list_expense_income&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='58065.Gelir Fişi'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "form_varmi=1=1&action_type_ch=210-41&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=ch.list_caris&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='49034.Borç Dekontu'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT2)# #session.ep.money2#</cfif></td>
					</tr>
				</tbody>
			</cf_grid_list>
			<div class="ui-info-bottom  margin-bottom-5">
				<p>
					<b><cf_get_lang dictionary_id ='39828.Net Satış'> : </b>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_CANCELED></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN)><cfset net_satis_toplam = net_satis_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT)><cfset net_satis_toplam = net_satis_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT></cfif>
		
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2 - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES2_CANCELED></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PURCHASE_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_DIFF2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_SALES_RETURN2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_INCOME2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT2)><cfset net_satis_toplam_money2 = net_satis_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_DEPT_RECEIPT2></cfif>
					#TLFormat(net_satis_toplam)# #session.ep.money# &nbsp;&nbsp;
					#TLFormat(net_satis_toplam_money2)# #session.ep.money2#
				</p>
			</div>
		</div>
		<!--- grafikler --->
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
			<p class="phead"><cf_get_lang dictionary_id ='57448.SATIŞ '>/<cf_get_lang dictionary_id='58176.ALIŞ '><cf_get_lang dictionary_id ='58583.FARK'>: #TLFormat(net_satis_toplam - net_alis_toplam)#</p>
			<p class="phead"><cf_get_lang dictionary_id ='57448.SATIŞ '><cf_get_lang dictionary_id='58176.ALIŞ '><cf_get_lang dictionary_id ='58671.ORANI'>: % <cfif net_alis_toplam gt 0>#TLFormat(net_satis_toplam/net_alis_toplam*100)#<cfelse>0</cfif></p>
		
			<script src="JS/Chart.min.js"></script>
			<canvas id="myChart"></canvas>
			<script>
				var ctx = document.getElementById("myChart");
				var myChart = new Chart(ctx, {
					type: 'bar',
					data: {
						labels: ["<cf_get_lang dictionary_id ='39561.Toplam Satış'>","<cf_get_lang dictionary_id ='39893.Toplam Alış'>"],
						datasets: [{
							label: ['<cf_get_lang dictionary_id='57921.Cari Faaliyet Özeti'>'],
							data: [<cfoutput>#net_satis_toplam#</cfoutput>,<cfoutput>#net_alis_toplam#</cfoutput>],
							backgroundColor: ['rgba(255, 99, 132, 0.2)','rgba(54, 162, 235, 0.2)'],
							borderColor: ['rgba(255,99,132,1)','rgba(54, 162, 235, 1)'],
							borderWidth: 1
						} 
						]
					},
					options: {
						scales: {
							yAxes: [{
								ticks: {
									beginAtZero:true
								}
							}]
						}
					}
				});
			</script>
		</div>
	</div>
	<cf_seperator title="#getlang('','Tahsilat-Ödeme','64596')#" id="tahsilatodeme">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0" id="tahsilatodeme">
		<!--- tahsilatlar--->
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="125"><cf_get_lang dictionary_id ='39829.Tahsilatlar'></th>
						<th width="30"><cf_get_lang dictionary_id ='57468.Belge'></th>
						<th width="140" style="text-align:right;">#session.ep.money#</th>
						<th width="140" style="text-align:right;">#session.ep.money2#</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=31&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cash.list_cash_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id='58645.Nakit'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CASH_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=90-0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39831.Çek Tahsilat'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=94-0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39832.Çek İade Çıkış'> (-)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=95-0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39833.Çek İade Giriş'> (+)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=97&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_voucher_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39834.Senet Tahsilat'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=101&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39835.Senet İade Çıkış'> (-)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=108&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39836.Senet İade Giriş'> (+)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=292&date1=#attributes.startdate#&date2=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=bank.list_bank_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='57839.Kredi Tahsilatı'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=24&date1=#attributes.startdate#&date2=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=bank.list_bank_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='57521.Banka'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2)# #session.ep.money2#</cfif></td>
					</tr>
				</tbody>
				
			</cf_grid_list>
			<div class="ui-info-bottom">
				<p>
					<b><cf_get_lang dictionary_id ='57492.Toplam'> : </b>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CASH></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)><cfset tahsilat_toplam = tahsilat_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)><cfset tahsilat_toplam = tahsilat_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE)><cfset tahsilat_toplam = tahsilat_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE></cfif>
			
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CASH2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_REVENUE2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2)><cfset tahsilat_toplam_money2 = tahsilat_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_REVENUE2></cfif>
					#TLFormat(tahsilat_toplam)# #session.ep.money# &nbsp;&nbsp;
					#TLFormat(tahsilat_toplam_money2)# #session.ep.money2#
					</p>
				</div>
		</div>
		<!--- odemeler--->
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="125"><cf_get_lang dictionary_id='58658.Ödemeler'></th>
						<th width="30"><cf_get_lang dictionary_id ='57468.Belge'></th>
						<th width="140" style="text-align:right;">#session.ep.money#</th>
						<th width="140" style="text-align:right;">#session.ep.money2#</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=32&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cash.list_cash_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id='58645.Nakit'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=91-0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39840.Çek Ödeme'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=95-0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39833.Çek İade Giriş'> (-)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=94-0&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39832.Çek İade Çıkış '>(+)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=98&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_voucher_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39841.Senet Ödeme'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=108&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39836.Senet İade Giriş'> (+)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=101&start_date=#attributes.startdate#&finish_date=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=cheque.list_cheque_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='39835.Senet İade Çıkış'> (-)</a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=291&date1=#attributes.startdate#&date2=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=bank.list_bank_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='57838.Kredi Ödemesi'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2)# #session.ep.money2#</cfif></td>
					</tr>
					<tr>
						<td><cfset Url_Address = "is_form_submitted=1&page_action_type=25&date1=#attributes.startdate#&date2=#attributes.finishdate#"><!--- Islem Tipi,Baslangic Tarihi, Bitis Tarihi --->
							<a href="#request.self#?fuseaction=bank.list_bank_actions&#Url_Address#" class="tableyazi"><cf_get_lang dictionary_id ='57521.Banka'></a>
						</td>
						<td align="center">#GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS_PAPERS#</td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS)# #session.ep.money#</cfif></td>
						<td style="text-align:right;"><cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2)>#TLFormat(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2)# #session.ep.money2#</cfif></td>
					</tr>
				</tbody>
			</cf_grid_list>
			
			<div class="ui-info-bottom margin-bottom-5">
				<p>
					<b><cf_get_lang dictionary_id ='57492.Toplam'> : </b>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN)><cfset odeme_toplam = odeme_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN)><cfset odeme_toplam = odeme_toplam - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS)><cfset odeme_toplam = odeme_toplam + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS></cfif>
			
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYM2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN)><cfset odeme_toplam_money2 = odeme_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_CHEQUE_P2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN)><cfset odeme_toplam_money2 = odeme_toplam_money2 - GET_ACTIVITY_SUMMARY_DAILY.GET_VOUCHER_P2_RETURN></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_PAYMENTS2></cfif>
					<cfif len(GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2)><cfset odeme_toplam_money2 = odeme_toplam_money2 + GET_ACTIVITY_SUMMARY_DAILY.GET_CREDIT_PAYMENTS2></cfif>
					#TLFormat(odeme_toplam)# #session.ep.money# &nbsp;&nbsp;
					#TLFormat(odeme_toplam_money2)# #session.ep.money2#
				</p>
			</div>
		</div>
		<!--- tahsilat ödeme grafik --->
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12">

			<p class="phead"><cf_get_lang dictionary_id ='57845.TAHSİLAT'>/<cf_get_lang dictionary_id ='57847.ÖDEME'><cf_get_lang dictionary_id ='58583.FARK '>: #TLFormat(tahsilat_toplam - odeme_toplam)#</p>
	
			<p class="phead"><cf_get_lang dictionary_id ='57845.TAHSİLAT'>/<cf_get_lang dictionary_id ='57847.ÖDEME'><cf_get_lang dictionary_id ='58671.ORANI'> : % <cfif odeme_toplam gt 0>#TLFormat(tahsilat_toplam/odeme_toplam*100)#<cfelse>0</cfif></p>
		
			<canvas id="myChart2"></canvas>
			<script>
				var ctx2 = document.getElementById("myChart2");
				var myChart2 = new Chart(ctx2, {
					type: 'bar',
					data: {
						labels: ["<cf_get_lang dictionary_id ='39894.Toplam Tahsilat'>","<cf_get_lang dictionary_id ='39895.Toplam Ödeme'>"],
						datasets: [{
							label: ['<cf_get_lang dictionary_id='57921.Cari Faaliyet Özeti'>'],
							data: [<cfoutput>#tahsilat_toplam#</cfoutput>,<cfoutput>#odeme_toplam#</cfoutput>],
							backgroundColor: ['rgba(255, 99, 132, 0.2)','rgba(54, 162, 235, 0.2)'],
							borderColor: ['rgba(255,99,132,1)','rgba(54, 162, 235, 1)'],
							borderWidth: 1
						}]
					},
					options: {
						scales: {
							yAxes: [{
								ticks: {
									beginAtZero:true
								}
							}]
						}
					}
				});
			</script>
					
		</div>
	</div>
	<!--- finans senaryolar --->
	<cf_seperator title="#getlang('','Finans Senaryolar','64597')#" id="finanssenaryo">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0" id="finanssenaryo">
		<cf_grid_list>
			<thead>
				<tr>
					<th  colspan="2" align="center"><cf_get_lang dictionary_id ='58670.Aktifler'></th>
					<th  colspan="2" align="center"><cf_get_lang dictionary_id ='58669.Pasifler'></th>
					<th  align="center" width="60"><cf_get_lang dictionary_id ='58668.Oranlar'></th>
					<th  colspan="2" align="center"><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tr>
				<td><cf_get_lang dictionary_id ='58657.Kasalar'><cf_get_lang dictionary_id ='58659.Toplamı'></td>
				<td style="text-align:right;">
					<cfif ctotal lt 0>
						<a href="#request.self#?fuseaction=cash.list_cashes" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(ctotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=cash.list_cashes" target="_blank" class="tableyazi">#TLFormat(ctotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57987.Bankalar'><cf_get_lang dictionary_id ='58659.Toplamı'></td>
				<td style="text-align:right;">
					<cfif btotal lt 0>
						<a href="#request.self#?fuseaction=bank.list_bank_account" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(btotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=bank.list_bank_account" target="_blank" class="tableyazi">#TLFormat(btotal*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='39418.Açık Hesap'><cf_get_lang dictionary_id ='40397.Alacaklar'></td>
				<td style="text-align:right;"><!--- borç alacakdan borçlu üyelere gider --->
					<cfif total_claim lt 0>
						<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=1" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(total_claim*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=1" target="_blank" class="tableyazi">#TLFormat(total_claim*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td><cf_get_lang dictionary_id ='39418.Açık Hesap'><cf_get_lang dictionary_id ='40396.Borçlar'></td>
				<td style="text-align:right;"><!--- borç alacakdan alacaklı üyelere gider --->
					<cfif total_debt lt 0>
						<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=2" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(total_debt*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=ch.list_duty_claim&is_submitted=1&duty_claim=2" target="_blank" class="tableyazi">#TLFormat(total_debt*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td style="text-align:right;"><cfif total_debt lt 0>% #TLFormat((abs(total_claim/total_debt))*100)#</cfif></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='40395.Portföydeki Çekler'></td>
				<td style="text-align:right;">
					<cfif (total_cheque_bank+total_cheque_cash) lt 0>
						<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=1,2" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat((total_cheque_bank+total_cheque_cash)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=1,2" target="_blank" class="tableyazi">#TLFormat((total_cheque_bank+total_cheque_cash)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td><cf_get_lang dictionary_id ='40394.Ödenecek Çekler'></td>
				<td style="text-align:right;">
					<cfif total_cheque_pay lt 0>
						<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=6" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(total_cheque_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=6" target="_blank" class="tableyazi">#TLFormat(total_cheque_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td style="text-align:right;"><cfif total_cheque_pay lt 0>% #TLFormat(((abs((total_cheque_bank+total_cheque_cash)/total_cheque_pay))*100))#</cfif></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='54422.Teminattaki Çekler'></td>
				<td style="text-align:right">
					<cfif len(GET_CHEQUE_IN_GUARANTEE.teminat_cekler)><a href="#request.self#?fuseaction=cheque.list_cheques&is_form_submitted=1&status=13" target="_blank" class="tableyazi">#TLFormat(GET_CHEQUE_IN_GUARANTEE.teminat_cekler)# #ListFirst(attributes.money,',')#</a></cfif>
				</td>
				<td><cf_get_lang dictionary_id ='40392.Ödenecek Senetler'></td>
				<td style="text-align:right;">
					<cfif total_voucher_pay lt 0>
						<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=6" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(total_voucher_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=6" target="_blank" class="tableyazi">#TLFormat(total_voucher_pay*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td style="text-align:right;"><cfif total_voucher_pay lt 0>% #TLFormat(((abs((total_voucher_bank+total_voucher_cash)/total_voucher_pay))*100))#</cfif></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='40393.Portföydeki Senetler'></td>
				<td style="text-align:right;">
					<cfif (total_voucher_bank+total_voucher_cash) lt 0>
						<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=1,2" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat((total_voucher_bank+total_voucher_cash)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelse>
						<a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=1,2" target="_blank" class="tableyazi">#TLFormat((total_voucher_bank+total_voucher_cash)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td><cf_get_lang dictionary_id='29553.Kredi Kartı Ödemeler'></td>
				<td style="text-align:right;">
					<cfif len(GET_PAYMENTS_WITH_CC.VALUE) and GET_PAYMENTS_WITH_CC.VALUE gt 0><!--- sıfırrdan büyükse eksi yapılıp kırmızı oluyor,cunku ödeme işlemi fazlaysa borclu demektir --->
						<a href="#request.self#?fuseaction=bank.list_credit_card_expense&form_submitted=1" target="_blank"><font color="FF0000">#TLFormat((-1*GET_PAYMENTS_WITH_CC.VALUE)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelseif len(GET_PAYMENTS_WITH_CC.VALUE)>
						<a href="#request.self#?fuseaction=bank.list_credit_card_expense&form_submitted=1" target="_blank">#TLFormat((-1*GET_PAYMENTS_WITH_CC.VALUE)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td style="text-align:right;"><cfif scen_paym lt 0 and len(GET_PAYMENTS_WITH_CC.VALUE) and len(GET_CREDIT_CARD_PAYMENTS.VALUE) and GET_PAYMENTS_WITH_CC.VALUE gt 0>% #TLFormat(((abs(GET_CREDIT_CARD_PAYMENTS.VALUE/GET_PAYMENTS_WITH_CC.VALUE))*100))# </cfif></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='54430.Teminattaki Senetler'></td>
				<td style="text-align:right">
					<cfif len(GET_VOUCHER_IN_GUARANTEE.teminat_senetler)><a href="#request.self#?fuseaction=cheque.list_vouchers&is_form_submitted=1&status=13" target="_blank" class="tableyazi">#TLFormat(GET_VOUCHER_IN_GUARANTEE.teminat_senetler)# #ListFirst(attributes.money,',')#</a></cfif>
				</td>
				<td><cf_get_lang dictionary_id ='40389.Kredi Sözleşme Borçları'></td>
				<td style="text-align:right;">
					<cfif len(GET_SCN_PAYM.VALUE) and GET_SCN_PAYM.VALUE lt 0>
						<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(GET_SCN_PAYM.VALUE*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelseif len(GET_SCN_PAYM.VALUE)>
						<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1" target="_blank" class="tableyazi">#TLFormat(GET_SCN_PAYM.VALUE*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td style="text-align:right;"><cfif scen_paym lt 0 and len(GET_SCN_PAYM.VALUE)>% #TLFormat(((abs(GET_SCN_PAYM.VALUE/scen_paym))*100))# </cfif></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='30101.Kredi Kartı Tahsilatları'></td>
				<td style="text-align:right;">
					<cfif len(GET_CREDIT_CARD_PAYMENTS.VALUE)>
						<a href="#request.self#?fuseaction=bank.list_creditcard_revenue&is_submitted=1" target="_blank" class="tableyazi">#TLFormat((GET_CREDIT_CARD_PAYMENTS.VALUE)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='40390.Kredi Sözleşme Alacakları'></td>
				<td style="text-align:right;">
					<cfif len(GET_SCN_REV.VALUE) and GET_SCN_REV.VALUE lt 0>
						<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1" target="_blank" class="tableyazi"><font color="FF0000">#TLFormat(GET_SCN_REV.VALUE*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font></a>
					<cfelseif len(GET_SCN_REV.VALUE)>
						<a href="#request.self#?fuseaction=credit.list_credit_contract&form_submitted=1" target="_blank" class="tableyazi">#TLFormat((GET_SCN_REV.VALUE)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</a>
					</cfif>
				</td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58038.Stok Değeri'></td>
				<td style="text-align:right;"><a href="#request.self#?fuseaction=report.stock_analyse&date=#dateformat(attributes.startdate,dateformat_style)#&date2=#dateformat(attributes.finishdate,dateformat_style)#" class="tableyazi">#TLFormat(GET_STOCKS_INFO.COST_PRICE)# #session.ep.money#</a></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id ='57531.Sabit Kıymetler'></td>
				<td style="text-align:right;"><cfif inventory_total gt 0><a href="#request.self#?fuseaction=invent.list_inventory" class="tableyazi">#TLFormat(inventory_total)# #session.ep.money#</a></cfif></td>
				<td class="txtbold"></td>
				<td style="text-align:right;"></td>
				<td></td>
				<td class="txtbold"><cf_get_lang dictionary_id ='40388.Nakit Mevcut'></td>
				<cfset bakiye=ctotal+btotal>
				<cfif len(GET_STOCKS_INFO.COST_PRICE)><cfset cost_total = wrk_round(GET_STOCKS_INFO.COST_PRICE,2)></cfif>
				<td style="text-align:right;">
					<cfif bakiye lt 0><font color="FF0000">#TLFormat(bakiye*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</font>
					<cfelse>#TLFormat(bakiye*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</cfif>
				</td>
			</tr>
			<tr>
				<td class="txtbold" width="125"><cf_get_lang dictionary_id ='40387.Aktif Toplamı'></td>
				<td width="125" style="text-align:right;">
				#TLFormat((ctotal+btotal+total_claim+total_cheque_bank+total_cheque_cash+total_voucher_bank+total_voucher_cash+credit_card_total+scen_rev+inventory_total+cost_total+total_cheque_in_quarantee+total_voucher_in_quarantee)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</td>
				<td class="txtbold" width="125"><cf_get_lang dictionary_id ='40386.Pasif Toplamı'></td>
				<td width="125" style="text-align:right;">#TLFormat((total_debt+total_voucher_pay+total_cheque_pay+scen_paym+cc_pay_total)*ListLast(attributes.money,','))# #ListFirst(attributes.money,',')#</td>
				<td width="50" style="text-align:right;"><cfif (total_debt+total_voucher_pay+total_cheque_pay) gt 0>% #TLFormat(((abs((ctotal+btotal+total_claim+total_cheque_bank+total_cheque_cash+total_voucher_bank+total_voucher_cash)/(total_debt+total_voucher_pay+total_cheque_pay)))*100))#</cfif></td>
				<td class="txtbold" width="125"><cf_get_lang dictionary_id='57756.Durum'></td>
				<td width="125" style="text-align:right;">
					<cfif (bugunku_durum+inventory_total+cost_total) lt 0><font color="FF0000">#TLFormat((bugunku_durum+inventory_total+cost_total)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</font>
					<cfelse>#TLFormat((bugunku_durum+inventory_total+cost_total)*ListLast(attributes.money,','))#  #ListFirst(attributes.money,',')#</cfif>
				</td>
			</tr>			
			<tr>
				<td><cf_get_lang dictionary_id ='58622.Açık Siparişler'></td>
				<td style="text-align:right;">#tlformat(order_total)#</td>
				<td><cf_get_lang dictionary_id ='58622.Açık Siparişler'></td>
				<td style="text-align:right;"><font color="FF0000">#tlformat(order_total_purchase)#</font></td>
				<td style="text-align:right;"><cfif order_total_purchase lt 0>% #TLFormat((abs(order_total/order_total_purchase))*100)#</cfif></td>
				<td></td>
				<td></td>
			</tr>			
			<tr>
				<td><cf_get_lang dictionary_id='58955.Faturalanmamış irsaliyeler'></td>
				<td style="text-align:right;">#tlformat(ship_total)#</td>
				<td><cf_get_lang dictionary_id='58955.Faturalanmamış irsaliyeler'></td>
				<td style="text-align:right;"><font color="FF0000">#tlformat(ship_total_purchase)#</font></td>
				<td style="text-align:right;"><cfif ship_total_purchase lt 0>% #TLFormat((abs(ship_total/ship_total_purchase))*100)#</cfif></td>
				<td></td>
				<td></td>
			</tr>
		</cf_grid_list>
	</div>
</cf_box>
</cfoutput>
</cfif>	
</div>
</cfprocessingdirective>
<script type="text/javascript">
function select_branch()
{
	var comp_id_list='';
	for(kk=0;kk<document.form_search.our_company_ids.length; kk++)
	{
		if(form_search.our_company_ids[kk].selected && form_search.our_company_ids.options[kk].value.length!='')
			comp_id_list = comp_id_list + ',' + form_search.our_company_ids.options[kk].value;
	}
	if(list_len(comp_id_list) > 2)//sadece tek şirkette şube seçilebilir
		document.form_search.branch_id.disabled = true;
	else
	{
		document.form_search.branch_id.disabled = false;
		my_comp = document.getElementById('our_company_ids').value;
		result = wrk_safe_query('rpr_get_branch','dsn',0,my_comp);
		var option_count = document.getElementById('branch_id').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('branch_id').options[x] = null;
		document.getElementById('branch_id').options[0]=new Option("<cf_get_lang dictionary_id='30126.Şube Seçiniz'>",'');
		for(var i=0;i<result.recordcount;i++)
		{
			document.getElementById('branch_id').options[i+1]=new Option(result.BRANCH_NAME[i],result.BRANCH_ID[i]);
		}
	}
	return true;
}	
</script>
<cfsetting showdebugoutput="yes">