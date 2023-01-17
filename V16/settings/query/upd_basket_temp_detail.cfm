<cfset mod_id=attributes.BASKET_ID>
<cfswitch expression="#attributes.BASKET_ID#">
	<cfcase value="1"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="2"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="3"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="4"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="5"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="6"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="7"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="8"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="10"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="11"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="12"><cfset bit_sale_purchase=2></cfcase>
	<cfcase value="13"><cfset bit_sale_purchase=2></cfcase>
	<cfcase value="14"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="15"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="17"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="18"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="19"><cfset bit_sale_purchase=2></cfcase>
	<cfcase value="20"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="21"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="22"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="24"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="25"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="36"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="35"><cfset bit_sale_purchase=0></cfcase>	
	<cfcase value="26"><cfset bit_sale_purchase=3></cfcase>
	<cfcase value="28"><cfset bit_sale_purchase=3></cfcase>
	<cfcase value="29"><cfset bit_sale_purchase=3></cfcase>
	<cfcase value="31"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="32"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="33"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="34"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="38"><cfset bit_sale_purchase=1></cfcase>
	<cfcase value="37"><cfset bit_sale_purchase=0></cfcase>
	<cfcase value="39"><cfset bit_sale_purchase=0></cfcase>	
	<cfcase value="40"><cfset bit_sale_purchase=0></cfcase>	
	<cfcase value="41"><cfset bit_sale_purchase=0></cfcase>			
	<cfcase value="42"><cfset bit_sale_purchase=0></cfcase>			
	<cfcase value="43"><cfset bit_sale_purchase=0></cfcase>			
	<cfcase value="44"><cfset bit_sale_purchase=3></cfcase>
	<cfcase value="45"><cfset bit_sale_purchase=3></cfcase>
	<cfcase value="46"><cfset bit_sale_purchase=1></cfcase>
</cfswitch>
	<!--- moduller yazilir.--->
	<cfset module_str = "">
	<cfset module_str_display = "">

	<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'product_name') >
	  <cfset module_str=module_str & ",product_name"><cfelse><cfset module_str_display=ListAppend(module_str_display,"product_name",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'manufact_code')  >
	  <cfset module_str=module_str & ",manufact_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"manufact_code",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'stock_code')  >
	  <cfset module_str=module_str & ",stock_code"><cfelse><cfset module_str_display=ListAppend(module_str_display,"stock_code",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'Barcod')>
	  <cfset module_str=module_str & ",Barcod"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Barcod",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'spec') >
	  <cfset module_str=module_str & ",spec"><cfelse><cfset module_str_display=ListAppend(module_str_display,"spec",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_promotion') >
	  <cfset module_str=module_str & ",is_promotion"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_promotion",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'paymethod')>
	  <cfset module_str=module_str & ",paymethod"><cfelse><cfset module_str_display=ListAppend(module_str_display,"paymethod",",")>
	</cfif>		
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'disc_ount') >
	  <cfset dis_kontrol1=1>
	  <cfset module_str=module_str & ",disc_ount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount",",")>
	</cfif>
	<cfif isdefined("dis_kontrol1")or  not ListFind(attributes.module_content,'disc_ount2_')>
	  <cfset dis_kontrol2=2>	
	  <cfset module_str=module_str & ",disc_ount2_"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount2_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol1") or  isdefined("dis_kontrol2") or not ListFind(attributes.module_content,'disc_ount3_')>
	  <cfset dis_kontrol3=1>
	  <cfset module_str=module_str & ",disc_ount3_"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount3_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol1") or isdefined("dis_kontrol2") or  isdefined("dis_kontrol3") or not ListFind(attributes.module_content,'disc_ount4_') >
	  <cfset dis_kontrol4=1>
	  <cfset module_str=module_str & ",disc_ount4_"><cfelse><cfset module_str_display=ListAppend(module_str_display,"disc_ount4_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol4")  or not ListFind(attributes.module_content,'disc_ount5_') >
	  <cfset dis_kontrol5 = 1 >
	  <cfset module_str=module_str & ",disc_ount5_">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"disc_ount5_",",")>
	</cfif>	
	<cfif isdefined("dis_kontrol5")  or not ListFind(attributes.module_content,'disc_ount6_') >
	  <cfset dis_kontrol6 = 1 >
	  <cfset module_str=module_str & ",disc_ount6_">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"disc_ount6_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol6")  or not ListFind(attributes.module_content,'disc_ount7_') >
	  <cfset dis_kontrol7 = 1 >
	  <cfset module_str=module_str & ",disc_ount7_">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"disc_ount7_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol7")  or not ListFind(attributes.module_content,'disc_ount8_') >
	  <cfset dis_kontrol8 = 1 >
	  <cfset module_str = module_str & ",disc_ount8_">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"disc_ount8_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol8")  or not ListFind(attributes.module_content,'disc_ount9_') >
	  <cfset dis_kontrol9 = 1 >
	  <cfset module_str = module_str & ",disc_ount9_">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"disc_ount9_",",")>
	</cfif>
	<cfif isdefined("dis_kontrol9")  or not ListFind(attributes.module_content,'disc_ount10_') >
	  <cfset module_str=module_str & ",disc_ount10_">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"disc_ount10_",",")>
	</cfif>				
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Amount')  >
	  <cfset module_str=module_str & ",Amount"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Amount",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Price') >
		  <cfset module_str=module_str & ",Price">
		  <cfset int_price = 0>
	<cfelse>
	  	<cfset module_str_display=ListAppend(module_str_display,"Price",",")>
		<cfset int_price = 1>
	</cfif>
	<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Tax')  >
		<cfset int_control_tax=1>
	    <cfset int_kdv = 0>
		<cfset module_str=module_str & ",Tax">
	<cfelse>
		<cfset int_kdv = 1>
		<cfset module_str_display=ListAppend(module_str_display,"Tax",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'price_other') >
		<cfset module_str=module_str & ",price_other">
		<cfset int_price_other=0>		
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"price_other",",")> 
		<cfset int_price_other=1>
	</cfif>	
	<cfif  int_kdv eq 0 or  int_price eq 0 or not isdefined("attributes.module_content")  or   ( not ListFind(attributes.module_content,'row_taxtotal') or isdefined("int_control_tax"))>
	  <cfset module_str=module_str & ",row_taxtotal">
	  <cfset bool_kdv_all=0>
	 <cfelse>
 	  <cfset bool_kdv_all=1>
	  <cfset module_str_display=ListAppend(module_str_display,"row_taxtotal",",")>
	</cfif>	
	<cfif bool_kdv_all eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'Kdv') >
	   <cfset module_str=module_str & ",Kdv">
	<cfelse>
		<cfset module_str_display=ListAppend(module_str_display,"Kdv",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Unit')>
	  <cfset module_str=module_str & ",Unit"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Unit",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'Duedate')  >
	  <cfset module_str=module_str & ",Duedate"><cfelse><cfset module_str_display=ListAppend(module_str_display,"Duedate",",")>
	</cfif>
	<cfif int_price eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_total')  >
	  <cfset module_str=module_str & ",row_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_total",",")>
	</cfif>
	<cfif int_price eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_nettotal') >
	  <cfset module_str=module_str & ",row_nettotal">
		<cfset int_nettotal = 0 >
	  <cfelse>
		<cfset int_nettotal = 1 >
		<cfset module_str_display=ListAppend(module_str_display,"row_nettotal",",")>
	</cfif>

	<cfif   int_nettotal eq 0 or int_kdv eq 0 or  not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'row_lasttotal')  >
	  <cfset module_str=module_str & ",row_lasttotal"><cfelse><cfset module_str_display=ListAppend(module_str_display,"row_lasttotal",",")>
	</cfif>
	
	<cfif not isdefined("attributes.module_content") or not  ListFind(attributes.module_content,'deliver_date') >
	  <cfset module_str=module_str & ",deliver_date"><cfelse><cfset module_str_display=ListAppend(module_str_display,"deliver_date",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'deliver_dept') >
	  <cfset module_str=module_str & ",deliver_dept">
	<cfelse>
		<cfset deliver_dept_selected=1>
		<cfset module_str_display=ListAppend(module_str_display,"deliver_dept",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'deliver_dept_assortment') >
	  <cfset module_str=module_str & ",deliver_dept_assortment"><cfelse><cfset module_str_display=ListAppend(module_str_display,"deliver_dept_assortment",",")>
	</cfif>
	
	<cfif int_kdv eq 0 or  int_price eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'price_total') >
	  <cfset module_str=module_str & ",price_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"price_total",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'basket_cursor') >
	  <cfset module_str = module_str & ",basket_cursor"><cfelse><cfset module_str_display=ListAppend(module_str_display,"basket_cursor",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'is_parse')  >
	  <cfset module_str = module_str & ",is_parse"><cfelse><cfset module_str_display=ListAppend(module_str_display,"is_parse",",")>
	</cfif>
	<cfif int_price_other eq 0 or not isdefined("attributes.module_content") or not ListFind(attributes.module_content,'other_money') >
	  <cfset module_str = module_str & ",other_money"><cfelse><cfset module_str_display=ListAppend(module_str_display,"other_money",",")>
	</cfif>		
	<cfif int_price_other eq 0 or  not isdefined("attributes.module_content")  or not ListFind(attributes.module_content,'other_money_value') >
	  <cfset is_other_money = 1 >	
	  <cfset module_str = module_str & ",other_money_value" ><cfelse><cfset module_str_display = ListAppend(module_str_display,"other_money_value",",") >
	</cfif>		
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'lot_no') >
	  <cfset module_str = module_str & ",lot_no"><cfelse><cfset module_str_display=ListAppend(module_str_display,"lot_no",",")>
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'price_net')  >
	  <cfset module_str=module_str & ",price_net"><cfelse><cfset module_str_display=ListAppend(module_str_display,"price_net",",")>
	</cfif>
 	<cfif int_price_other eq 0 or not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'price_net_doviz') >
	  <cfset module_str=module_str & ",price_net_doviz"><cfelse><cfset module_str_display=ListAppend(module_str_display,"price_net_doviz",",")>
	</cfif>	
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'zero_stock_status') >
	  <cfset module_str=module_str & ",zero_stock_status"><cfelse><cfset module_str_display=ListAppend(module_str_display,"zero_stock_status",",")> 
	</cfif>	
	<cfif  int_price_other eq 0 or not isdefined("attributes.module_content")  or isdefined("is_other_money")>
	  <cfset module_str=module_str & ",other_money_gross_total"><cfelse><cfset module_str_display=ListAppend(module_str_display,"other_money_gross_total",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'net_maliyet') >
	  <cfset module_str=module_str & ",net_maliyet"><cfelse><cfset module_str_display=ListAppend(module_str_display,"net_maliyet",",")> 
	</cfif>	
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'extra_cost') >
	  <cfset module_str=module_str & ",extra_cost"><cfelse><cfset module_str_display=ListAppend(module_str_display,"extra_cost",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'marj') >
	  <cfset module_str=module_str & ",marj"><cfelse><cfset module_str_display=ListAppend(module_str_display,"marj",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'dara') >
	  <cfset module_str=module_str & ",dara"><cfelse><cfset module_str_display=ListAppend(module_str_display,"dara",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'darali') >
	  <cfset module_str=module_str & ",darali"><cfelse><cfset module_str_display=ListAppend(module_str_display,"darali",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'shelf_number') >
	  <cfset module_str=module_str & ",shelf_number"><cfelse><cfset module_str_display=ListAppend(module_str_display,"shelf_number",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'order_currency') >
	  <cfset module_str=module_str & ",order_currency"><cfelse><cfset module_str_display=ListAppend(module_str_display,"order_currency",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'reserve_type') >
	  <cfset module_str=module_str & ",reserve_type"><cfelse><cfset module_str_display=ListAppend(module_str_display,"reserve_type",",")> 
	</cfif>
	<cfif not isdefined("attributes.module_content") or  not ListFind(attributes.module_content,'reserve_date') >
	  <cfset module_str=module_str & ",reserve_date"><cfelse><cfset module_str_display=ListAppend(module_str_display,"reserve_date",",")> 
	</cfif>
	<cfif len(module_str)>
		<cfset module_str = mid(module_str,2,len(module_str)-1)>
	</cfif>
	<cfquery name="DEL_MODULE" datasource="#DSN3#">
		DELETE FROM
			SETUP_BASKET
		WHERE
			BASKET_ID = #attributes.BASKET_ID# AND
			B_TYPE = #attributes.B_TYPE#
	</cfquery> 
	<cfquery name="DEL_MODULE2" datasource="#DSN3#">
		DELETE FROM
			SETUP_BASKET_ROWS
		WHERE
			BASKET_ID = #attributes.BASKET_ID# AND
			B_TYPE = #attributes.B_TYPE#
	</cfquery> 

	<cfquery name="ADD_MODULE" datasource="#DSN3#">
		INSERT INTO 
			SETUP_BASKET
		(
			BASKET_ID,
			B_TYPE,
			PURCHASE_SALES,
			UPDATE_EMP,
			UPDATE_IP,
			UPDATE_DATE
		) 
		VALUES
		(
			#attributes.BASKET_ID#,
			#attributes.B_TYPE#,
			<cfif bit_sale_purchase lte 1>#bit_sale_purchase#<cfelse>NULL</cfif>,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)
	</cfquery> 
	<cfloop  list="#module_str_display#" index="lst_index">
		<cfquery name="add_q" datasource="#DSN3#">
			INSERT INTO
				SETUP_BASKET_ROWS 
			(
				TITLE,
				IS_SELECTED,
				BASKET_ID,
				LINE_ORDER_NO,
				B_TYPE,
				TITLE_NAME,
				GENISLIK
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#lst_index#">,
				1,
				#attributes.BASKET_ID#,
				<cfif isdefined("attributes.#lst_index#_sira") and len(evaluate("attributes.#lst_index#_sira"))>#evaluate("attributes.#lst_index#_sira")#<cfelse>NULL</cfif>,
				#attributes.B_TYPE#,
				<cfif isdefined("attributes.#lst_index#") and len(evaluate("attributes.#lst_index#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.#lst_index#")#'><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.#lst_index#_genislik") and len(evaluate("attributes.#lst_index#_genislik"))>#evaluate("attributes.#lst_index#_genislik")#<cfelse>25</cfif>
			)
		</cfquery>
	</cfloop>
	<cfloop  list="#module_str#" index="lst_index">
		<cfquery name="add_q_non" datasource="#DSN3#">
			INSERT
				INTO SETUP_BASKET_ROWS 
			(
				TITLE,
				IS_SELECTED,
				BASKET_ID,
				LINE_ORDER_NO,
				B_TYPE,
				TITLE_NAME,
				GENISLIK
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#lst_index#">,
				0,
				#attributes.BASKET_ID#,
				<cfif isdefined("attributes.#lst_index#_sira") and len(evaluate("attributes.#lst_index#_sira"))>#evaluate("attributes.#lst_index#_sira")#<cfelse>NULL</cfif>,
				#attributes.B_TYPE#,
				<cfif isdefined("attributes.#lst_index#") and len(evaluate("attributes.#lst_index#"))><cfqueryparam cfsqltype="cf_sql_varchar" value='#wrk_eval("attributes.#lst_index#")#'><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.#lst_index#_genislik") and len(evaluate("attributes.#lst_index#_genislik"))>#evaluate("attributes.#lst_index#_genislik")#<cfelse>25</cfif>
			)
		</cfquery>
	</cfloop>
	<cfquery name="UPD_ROW" datasource="#DSN3#">
		UPDATE SETUP_BASKET_ROWS SET TITLE_NAME = TITLE WHERE TITLE_NAME IS NULL
	</cfquery>
	<cfquery name="upd_row" datasource="#DSN3#">
		UPDATE SETUP_BASKET_ROWS SET GENISLIK = 25 WHERE GENISLIK IS NULL
	</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_upd_bskt_temp_detail&id=#BASKET_ID#&b_type=#attributes.B_TYPE#">
