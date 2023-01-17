<cfquery name="GET_EMP_POSITION_CAT_ID" datasource="#DSN#">
	SELECT POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 
</cfquery>
<cfquery name="PRICE_CATS" datasource="#DSN3#">
	SELECT
		PRICE_CATID,
		PRICE_CAT,
		TARGET_DUE_DATE,
		AVG_DUE_DAY
	FROM
		PRICE_CAT
	WHERE
		PRICE_CAT_STATUS = 1
		<cfif (isdefined("attributes.var_") and (session.ep.isBranchAuthorization)) or isdefined('attributes.is_store_module')><!--- and isdefined('attributes.sepet_process_type') and listfind('49,51,52,54,55,59,60,601,63,591',attributes.sepet_process_type)) alış ve parekende satış faturalarında subeyle iliskili fiyat listeleri seciliyor --->
			AND PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#LISTGETAT(SESSION.EP.USER_LOCATION,2,"-")#,%">
		</cfif>
		<!--- Pozisyon tipine gore yetki veriliyor  --->
		<cfif (isDefined("xml_related_position_cat") and  xml_related_position_cat eq 1) or not isDefined("xml_related_position_cat")>
			AND POSITION_CAT LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_emp_position_cat_id.position_cat_id#,%">
		</cfif>
		<!--- //Pozisyon tipine gore yetki veriliyor  --->
		<cfif isdefined('attributes.PRODUCT_SELECT_TYPE') and basket_prod_list.PRODUCT_SELECT_TYPE eq 13>
			<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
				AND PRICE_CAT.PAYMETHOD = 4
			<cfelseif isdefined("attributes.paymethod_vehicle") and len(attributes.paymethod_vehicle)>
				AND PRICE_CAT.PAYMETHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_vehicle#">
			</cfif>
		</cfif>
		<cfif isdefined('xml_use_member_price_cat_purchase') and xml_use_member_price_cat_purchase eq 1 and isdefined('attributes.company_id') and len(attributes.company_id)><!--- xmlde sadece risk bilgilerinde tanımlı fiyat listesi gelsin secili ise --->
			AND PRICE_CATID IN(SELECT PC.PRICE_CATID FROM PRICE_CAT_EXCEPTIONS PC WHERE PC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND PC.ACT_TYPE = 2 AND PC.PURCHASE_SALES = 0)
		</cfif>
		<cfif isdefined("GET_COMP_CAT") and basket_prod_list.PRODUCT_SELECT_TYPE neq 13 and isDefined("attributes.company_id") and len(attributes.company_id) and ListLen(ValueList(GET_COMP_CAT.COMPANYCAT_ID,','))>
			AND COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#ValueList(GET_COMP_CAT.COMPANYCAT_ID,',')#,%">
		</cfif>
		<cfif isdefined("attributes.is_sale_product") and attributes.is_sale_product eq 0>
			AND IS_PURCHASE = 1
		<cfelse>
			AND IS_SALES = 1
		</cfif>
	ORDER BY
		PRICE_CAT
</cfquery>
<cfif isdefined('xml_use_member_price_cat') and xml_use_member_price_cat eq 1 and PRICE_CATS.recordcount eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='1915.Üyeyi Bir Fiyat Listesine Dahil Ediniz !'>");
		window.close();
	</script>
	<cfabort>
</cfif>


 


