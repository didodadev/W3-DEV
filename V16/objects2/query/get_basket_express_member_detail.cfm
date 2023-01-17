<cfquery name="GET_ALL_PRE_ORDER_ROWS" datasource="#DSN3#">
	SELECT 
		OPR.STOCK_ID,
		OPR.PRODUCT_ID,
		OPR.QUANTITY,
		OPR.PROM_ID,
		OPR.IS_GENERAL_PROM,
		ISNULL(OPR.IS_PROM_ASIL_HEDIYE,0) AS IS_PROM_ASIL_HEDIYE,
		OPR.IS_PRODUCT_PROMOTION_NONEFFECT,
		OPR.TO_CONS,
		OPR.TO_PAR,
		OPR.TO_COMP,
		ISNULL(OPR.STOCK_ACTION_TYPE,0) AS STOCK_ACTION_TYPE,
		<cfif isdefined("session.pp")>
			(OPR.PRICE_KDV*OPR.QUANTITY*SM.RATEPP2) AS ROW_TOTAL,
			SM.RATEPP2 RATE2
		<cfelseif isdefined("session.ww")>
			(OPR.PRICE_KDV*OPR.QUANTITY*SM.RATEWW2) AS ROW_TOTAL,
			SM.RATEWW2 RATE2
		<cfelse>	
			(OPR.PRICE_KDV*OPR.QUANTITY*SM.RATE2) AS ROW_TOTAL ,
			RATE2
		</cfif>
	FROM
		ORDER_PRE_ROWS OPR,
		#dsn_alias#.SETUP_MONEY SM
	WHERE
		ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (1,3) AND <!--- bekleyen siparişe alınmaz aşamasındakiler promosyona dahil edilmiyor action type 2 olanlar miktarsal olarak promosyona katılsın diye bu bloktan cıkarıldı--->
		ISNULL(OPR.IS_PRODUCT_PROMOTION_NONEFFECT,0) = 0 AND <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
		SM.MONEY = OPR.PRICE_MONEY AND
		<cfif isdefined("session.pp")>
			OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
			SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
		<cfelseif isdefined("session.ww.userid")>
			OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
		<cfelseif isdefined("session.ep.userid")>
			OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		<cfelse>
			1=2 AND
		</cfif>
		STOCK_ID IS NOT NULL
</cfquery>
<cfif get_all_pre_order_rows.recordcount>
	<cfset attributes.consumer_id=''>
	<cfset attributes.partner_id=''>
	<cfset attributes.company_id=''>
	<cfscript>
		basket_express_cons_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.to_cons)),'numeric','asc');
		basket_express_partner_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.to_par)),'numeric','asc');
		basket_express_comp_list=listsort(listdeleteduplicates(valuelist(get_all_pre_order_rows.to_comp)),'numeric','asc');
		
		if(len(basket_express_cons_list))
		{
			attributes.consumer_id=listfirst(basket_express_cons_list);
			is_from_basket_express=1;
		}
		else if(len(basket_express_partner_list) and len(basket_express_comp_list))
		{
			attributes.partner_id=listfirst(basket_express_partner_list);
			attributes.company_id=listfirst(basket_express_comp_list);
			is_from_basket_express=1;
		}
		else if(isdefined("session.pp.userid"))
		{
			attributes.partner_id=session.pp.userid;
			attributes.company_id=session.pp.company_id;
		}
		else if(isdefined("session.ww.userid") )
			attributes.consumer_id=session.ww.userid;
	</cfscript>
	<cfif listlen(basket_express_cons_list) gt 1 or listlen(basket_express_comp_list) gt 1> <!--- aynı anda birden cok sayfa acıp birden fazla temsilci için ürün eklenmisse --->
		<cfquery name="DEL_PROM_ROWS" datasource="#DSN3#"> <!---sipariş sepeti siliniyor --->
			DELETE FROM 
				ORDER_PRE_ROWS
			WHERE
				<cfif isdefined("session.pp")>
					RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				<cfelseif isdefined("session.ww.userid")>
					RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
				<cfelseif isdefined("session.ep.userid")>
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				<cfelse>
					1=2
				</cfif>
		</cfquery>
		<script type="text/javascript">
			alert('Birden Fazla Temsilci İçin Aynı Anda Sipariş Oluşturulamaz. Lütfen Siparişinizi Yenileyiniz!');
			window.location.href='<cfoutput>#request.self#?fuseaction=objects2.list_basket</cfoutput>';
		</script>
		<cfabort>
	</cfif>
	<cfif not isdefined("get_credit_limit.recordcount")>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
				SELECT 
					PRICE_CAT
				FROM 
					COMPANY_CREDIT
				WHERE 
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
				<cfset attributes.price_catid = get_credit_limit.price_cat>
			<cfelse>		
				<cfquery name="GET_COMP_CAT" datasource="#DSN#">
					SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfquery>
				<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
					SELECT PRICE_CATID FROM PRICE_CAT WHERE COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
				</cfquery>
				<cfif get_price_cat.recordcount>
					<cfset attributes.price_catid = get_price_cat.price_catid>
				</cfif>		
			</cfif>
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
				SELECT 
					PRICE_CAT
				FROM 
					COMPANY_CREDIT
				WHERE 
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
			</cfquery>
			<cfif get_credit_limit.recordcount and len(get_credit_limit.price_cat)>
				<cfset attributes.price_catid = get_credit_limit.price_cat>
			<cfelse>		
				<cfquery name="GET_COMP_CAT" datasource="#DSN#">
					SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				</cfquery>
				<cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
					SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
				</cfquery>
				<cfif get_price_cat.recordcount>
					<cfset attributes.price_catid = get_price_cat.price_catid>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cfif>
