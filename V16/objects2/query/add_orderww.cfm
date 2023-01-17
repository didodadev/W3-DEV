<cfquery name="GET_CART_COUNT" datasource="#DSN3#">
    SELECT
        PRODUCT_ID
    FROM
        ORDER_PRE_ROWS
    WHERE
        <cfif isdefined("session.pp")>
            RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
        <cfelseif isdefined("session.ww.userid")>
            RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
        <cfelseif isdefined("session.ep")>
            RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
        <cfelseif not isdefined("session_base.userid")>
            RECORD_GUEST = 1 AND 
            RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
            COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#')#"> AND
        </cfif>
        IS_CARGO <> 1 AND
       	PROM_ID IS NULL
</cfquery>

<cfif not get_cart_count.recordcount>
    <script type="text/javascript">
        alert("Sepetinizde Ürün Bulunmamaktadır! Lütfen Sepete Ürün Atınız!");		
        window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_basket";
    </script>
    <cfabort>
</cfif> 
<cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1 and isdefined('session.pp.userid')>
	<cfif not len(attributes.project_attachment)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='69.Bağlantı seçmelisiniz'>");
			history.back();
		</script>
		<cfabort>
	</cfif>	
</cfif>
<cfif not isDefined('attributes.is_order_type_form')>
	<script type="text/javascript">
		alert('Lütfen bu sayfayı sipariş sonlandırma sayfasından çağırınız!');
		history.back();
	</script>
    <cfabort>
</cfif>

<cfset attributes.is_order_type_ = attributes.is_order_type_form>
<cfset attributes.x_is_order_type_ = attributes.is_order_type_form>

<cfinclude template="../query/get_basket_rows.cfm">
<!--- Satılabilir stok kontrolü --->    
<cfscript> 
	//uye kontrolu
	basket_express_cons_list=listsort(listdeleteduplicates(valuelist(get_rows.to_cons)),'numeric','asc');
	basket_express_partner_list=listsort(listdeleteduplicates(valuelist(get_rows.to_par)),'numeric','asc');
	basket_express_comp_list=listsort(listdeleteduplicates(valuelist(get_rows.to_comp)),'numeric','asc');
	attributes.consumer_id='';
	attributes.partner_id='';
	attributes.company_id='';
	hata = '';
	
	if(len(basket_express_cons_list))//session ep deyken her durumda user seçildiği için bu alanlar dolu gelir
	{
		attributes.consumer_id=listfirst(basket_express_cons_list);
		attributes.order_from_basket_express=1;
	}
	else if(len(basket_express_partner_list) and len(basket_express_comp_list))
	{
		attributes.partner_id=listfirst(basket_express_partner_list);
		attributes.company_id=listfirst(basket_express_comp_list);
		attributes.order_from_basket_express=1;
	}
	else if(isdefined("session.pp.userid"))
	{
		attributes.partner_id=session.pp.userid;
		attributes.company_id=session.pp.company_id;
	}
	else if(isdefined("session.ww.userid") )
		attributes.consumer_id=session.ww.userid;
	
	if(attributes.is_control_zero_stock eq 1)
	{
		stock_id_list='';
		stock_amount_list='';
		
		for(brw=1;brw lte get_rows.recordcount;brw=brw+1)
		{
			if(get_rows.is_zero_stock[brw] eq 0)  //0 stok kontrolü
			{
				yer=listfind(stock_id_list,get_rows.stock_id[brw],',');
				if(yer eq 0)
				{
					stock_id_list=listappend(stock_id_list,get_rows.stock_id[brw],',');
					stock_amount_list=listappend(stock_amount_list,get_rows.quantity[brw],',');
				}
				else
				{
					total_stock_miktar=get_rows.quantity[brw]+listgetat(stock_amount_list,yer,',');
					stock_amount_list=listsetat(stock_amount_list,yer,total_stock_miktar,',');
				}
			}
		}
		
		if(not listlen(stock_id_list,','))
		{
			stock_id_list=0;
			stock_id_count = 0;
		}
		else
			stock_id_count = listlen(stock_id_list,',');
			
		if(not listlen(stock_amount_list,','))
			stock_amount_list=0;
		//stock kontrolleri

		//stock_id_count = listlen(stock_id_list,',');
		if(isDefined('attributes.is_zero_stock_dept') and len(attributes.is_zero_stock_dept))
			get_total_stocks = cfquery(SQLString:"get_stock_last_location_function '#stock_id_list#'",Datasource:dsn2);
		else		
			get_total_stocks = cfquery(SQLString:"get_stock_last_function '#stock_id_list#'",Datasource:dsn2);
		get_product_names = cfquery(SQLString:'SELECT S.STOCK_ID, S.PRODUCT_NAME FROM STOCKS S WHERE S.STOCK_ID IN (#stock_id_list#)',Datasource:dsn3);
		get_stock_names = cfquery(SQLString:'SELECT S.STOCK_ID, S.PRODUCT_NAME, P.IS_ZERO_STOCK, S.IS_PRODUCTION FROM STOCKS S, PRODUCT P WHERE P.PRODUCT_ID = S.PRODUCT_ID AND P.IS_ZERO_STOCK = 0 AND S.STOCK_ID IN (#stock_id_list#)',Datasource:dsn3);
		
		if(stock_id_count gt 0)
		{
			for(jj=1;jj lte stock_id_count;jj=jj+1)
			{
				stock_id=listgetat(stock_id_list,jj,',');
				stock_amount=listgetat(stock_amount_list,jj,',');
				if(isdefined('attributes.is_zero_stock_dept') and len(attributes.is_zero_stock_dept))
				{
					get_total_stock_ = new Query(sql="SELECT SUM(SALEABLE_STOCK) SALEABLE_STOCK, STOCK_ID FROM GET_TOTAL_STOCKS WHERE STOCK_ID = #stock_id# AND DEPARTMENT_ID = #listgetat(attributes.is_zero_stock_dept,1,'-')# AND LOCATION_ID = #listgetat(attributes.is_zero_stock_dept,2,'-')# GROUP BY STOCK_ID", dbtype="query", GET_TOTAL_STOCKS = GET_TOTAL_STOCKS);
					get_total_stock = get_total_stock_.execute().getResult();  
				}
				else if(isdefined('session.ww.department_ids') and len(session.ww.department_ids))
					get_total_stock = cfquery(SQLString:'SELECT SUM(SALEABLE_STOCK) AS SALEABLE_STOCK, S.STOCK_ID, S.PRODUCT_NAME FROM GET_STOCK_LAST_LOCATION GS,#dsn3_alias#.STOCKS S WHERE GS.DEPARTMENT_ID IN (#session.ww.department_ids#) AND S.STOCK_ID = GS.STOCK_ID AND S.STOCK_ID = #stock_id# GROUP BY S.STOCK_ID, S.PRODUCT_NAME',Datasource:dsn2);
				else if(isdefined('session.pp.department_ids') and len(session.pp.department_ids))
					get_total_stock = cfquery(SQLString:'SELECT SUM(SALEABLE_STOCK) AS SALEABLE_STOCK, S.STOCK_ID, S.PRODUCT_NAME FROM GET_STOCK_LAST_LOCATION GS,#dsn3_alias#.STOCKS S WHERE GS.DEPARTMENT_ID IN (#session.pp.department_ids#) AND S.STOCK_ID = GS.STOCK_ID AND S.STOCK_ID = #stock_id# GROUP BY S.STOCK_ID, S.PRODUCT_NAME',Datasource:dsn2);
				else
				{
					get_total_stock_ = new Query(sql="SELECT * FROM GET_TOTAL_STOCKS WHERE STOCK_ID = #stock_id#", dbtype="query", GET_TOTAL_STOCKS = GET_TOTAL_STOCKS);
					get_total_stock = get_total_stock_.execute().getResult();  
				}
				//get_total_stock = cfquery(SQLString:'get_stock_last_function "#stock_id#"',Datasource:dsn2);
				if(get_total_stock.recordcount)
				{
					//hiç giriş veya çıkış yoksa o üründe yoksayılır
					get_stock_name_ = new Query(sql="SELECT * FROM GET_STOCK_NAMES WHERE STOCK_ID = #get_total_stock.STOCK_ID#", dbtype="query", GET_STOCK_NAMES = GET_STOCK_NAMES);
					get_stock_name = get_stock_name_.execute().getResult();  							

					if(get_total_stock.SALEABLE_STOCK lt stock_amount and get_stock_name.recordcount)
					{
						get_product_name_ = new Query(sql="SELECT * FROM GET_PRODUCT_NAMES WHERE STOCK_ID = #get_total_stock.STOCK_ID#", dbtype="query", GET_PRODUCT_NAMES = GET_PRODUCT_NAMES);
						get_product_name = get_product_name_.execute().getResult();  
													
						hata = '#hata# Ürün: #get_product_name.PRODUCT_NAME#\n';
					}
				}
				else
				{
					//hiç giriş veya çıkış yoksa o üründe yoksayılır
					get_stock_name_ = new Query(sql="SELECT * FROM GET_STOCK_NAMES WHERE STOCK_ID = #stock_id#", dbtype="query", GET_STOCK_NAMES = GET_STOCK_NAMES);
					get_stock_name = get_stock_name_.execute().getResult();  							
					
					hata = '#hata# Ürün: #get_stock_name.PRODUCT_NAME#\n';
				}
			}
		}
	}	
</cfscript>
<cfif len(hata) and attributes.is_control_zero_stock eq 1>
	<script type="text/javascript">
		alert("<cfoutput>#hata#</cfoutput>\n\n <cf_get_lang no ='150.Yukarıdaki ürünlerde satılabilir stok miktarı yeterli değildir Lütfen miktarları kontrol ediniz !'>");		
		window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.list_basket";
	</script>
	<cfabort>
</cfif> 

<!--- odeme bolumu (odeme kismi basa alindi, odemesi olmayan acik siparisler olusmasin diye..)--->
<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined('attributes.is_add_bank_order') and attributes.is_add_bank_order eq 1><!---havale yöntemi--->
	<cfinclude template="../query/add_inc_bankorder_from_orders.cfm">
<cfelseif isdefined("attributes.paymethod_type") and listfind("2,4",attributes.paymethod_type)><!---tamamını kredi kartı veya limit aşımında kredi kartı durumunda önce sanalpos ve tahsilat işlemi yapılır--->
	<cfset attributes.order_related = 1><!--- sipariş kaydı sona alındığı için,sipariş sonlandır ekranından geldiği tutulacak.. --->
	<cfif isdefined("attributes.order_detail")>
		<cfset attributes.action_detail = attributes.order_detail>
	<cfelse>
		<cfset attributes.action_detail = ''>
	</cfif>
	<cfinclude template="add_online_pos_from_order.cfm">
</cfif>
<cfif isdefined("attributes.paymethod_type") and listfind("2,4",attributes.paymethod_type) and session_base.is_order_closed neq 1>
	<cfexit method="exittemplate"><cfabort>
</cfif>
<!--- //ödeme bölümü --->
<cfinclude template="../../objects/functions/add_invoice_from_order.cfm">
<!--- Detaylı adresten adres oluşturuluyor --->
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset my_acc_result = get_company_period(attributes.company_id)>
<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfset my_acc_result = get_consumer_period(attributes.consumer_id)>
</cfif>

<cfif isdefined('attributes.is_same_tax_ship') and len(attributes.is_same_tax_ship)>
	<cfset attributes.ship_address_row = attributes.tax_address_row>
</cfif>
<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
	<cfif not isdefined("attributes.ship_address0")>
		<cfif len(attributes.ship_work_doorno0)>
			<cfset door_no = '#attributes.ship_work_doorno0#'>
		<cfelse>
			<cfset door_no = ''>
		</cfif>
		<cfif isdefined("attributes.ship_district0") and len(attributes.ship_district0)>
			<cfif len(attributes.ship_main_street0)>
				<cfset attributes.ship_main_street0 = '#attributes.ship_main_street0# Cad.'>
			</cfif>
			<cfif len(attributes.ship_street0)>
				<cfset attributes.ship_street0 = '#attributes.ship_street0# Sok.'>
			</cfif>
			<cfset attributes.ship_address0 = '#attributes.ship_district0# #attributes.ship_main_street0# #attributes.ship_street0# #door_no#'>
		<cfelseif isdefined("attributes.ship_district_id0") and len(attributes.ship_district_id0)>
			<cfquery name="GET_DIST_NAME" datasource="#DSN#">
				SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_district_id0#"> 
			</cfquery>
			<cfif len(attributes.ship_main_street0)>
				<cfset attributes.ship_main_street0 = '#attributes.ship_main_street0# Cad.'>
			</cfif>
			<cfif len(attributes.ship_street0)>
				<cfset attributes.ship_street0 = '#attributes.ship_street0# Sok.'>
			</cfif>
			<cfset attributes.ship_address0 = '#get_dist_name.district_name# #attributes.ship_main_street0# #attributes.ship_street0# #door_no#'>
		</cfif>
	</cfif>
</cfif>
<!--- son kullanıcıdan sipariş girme --->
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfinclude template="add_consumer_from_lastuser.cfm">
</cfif>

<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id) and isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>
	<cfquery name="GET_STOCK" datasource="#DSN3#"  maxrows="1">
		SELECT
			PRODUCT_ID,
			PRODUCT_NAME,
			TAX,
			PROPERTY,
			PRODUCT_UNIT_ID
		FROM
			STOCKS
		WHERE
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.free_prom_stock_id#">
	</cfquery>
	<cfset attributes.is_prom_asil_hediye = 0>
	<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
		INSERT INTO
			ORDER_PRE_ROWS
            (
                PRODUCT_ID,
                PRODUCT_NAME,
                QUANTITY,
                PRICE,
                PRICE_KDV,
                PRICE_MONEY,
                TAX,
                STOCK_ID,
                PRODUCT_UNIT_ID,
                PROM_ID,
                PROM_DISCOUNT,
                PROM_AMOUNT_DISCOUNT,
                PROM_COST,
                PROM_MAIN_STOCK_ID,
                PROM_STOCK_AMOUNT,
                IS_PROM_ASIL_HEDIYE,
                PROM_FREE_STOCK_ID,
                PRICE_OLD,
                IS_COMMISSION,
                PRICE_STANDARD,
                PRICE_STANDARD_KDV,
                PRICE_STANDARD_MONEY,
                TO_CONS,
                IS_PART,
                IS_NONDELETE_PRODUCT,
                RECORD_PERIOD_ID,
                RECORD_PAR,
                RECORD_CONS,
                RECORD_GUEST,
                RECORD_EMP,
                COOKIE_NAME,
                RECORD_IP,
                RECORD_DATE
            )
            VALUES
            (
                #get_stock.product_id#,
                <cfif trim(get_stock.property) is '-'>'#get_stock.product_name#'<cfelse>'#get_stock.product_name# #get_stock.property#'</cfif>,
                1,
                #attributes.free_stock_price#,
                #attributes.free_stock_price * (1 + (get_stock.tax / 100))#,
                '#attributes.free_stock_money#',
                #get_stock.tax#,
                #attributes.free_prom_stock_id#,
                #get_stock.product_unit_id#,
                #attributes.free_prom_id#,
                NULL,
                #attributes.free_stock_price#,
                #attributes.free_prom_cost#,
                NULL,
                #attributes.free_prom_amount#,
                1,
                1,
                NULL,
                0,
                0,
                0,
                NULL,
                <cfif isdefined('attributes.to_cons') and len(attributes.to_cons)>#attributes.to_cons#<cfelse>NULL</cfif>,
                0,
                #session_base.period_id#,
                0,
                <cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
                <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
                <cfif not isdefined("session_base.userid")>1<cfelse>0</cfif>,
                <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
                <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                '#cgi.remote_addr#',
                #now()#
            )
	</cfquery>
</cfif>
<cfscript>
	if(isDefined("session.ep"))
		int_comp_id = session_base.company_id;
	else
		int_comp_id = session_base.our_company_id;
	int_period_id = session_base.period_id;
	int_money = session_base.money;
	int_money2 = session_base.money2;
	if (isDefined("attributes.company_id") and len(attributes.company_id))
	{
		MEMBER_TYPE = "PARTNER";
		MEMBER_ID = attributes.partner_id;
	}
	if (isDefined("attributes.consumer_id") and len(attributes.consumer_id))
	{
		MEMBER_TYPE = "CONSUMER";
		MEMBER_ID = "";
	}
</cfscript>

<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1>
	<cfset paymethod_id=evaluate("attributes.paymethod_id_#attributes.paymethod_type#")>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 7>
	<cfset paymethod_id=evaluate("attributes.paymethod_id_#attributes.paymethod_type#")><!--- FA --->
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2>
	<cfset attributes.paymethod_id_2 = listgetat(action_to_account_id,3,";")>
	<cfset card_paymethod_id=evaluate("attributes.paymethod_id_#attributes.paymethod_type#")>
<cfelseif isdefined("attributes.paymethod_type") and listfind("3,4",attributes.paymethod_type)>
	<cfset paymethod_id=attributes.risk_paymethod>
</cfif>
<cfset new_date_ = now()>
<cfif isdefined("session.pp.userid")>
	<cfset new_date = dateformat(date_add("h",session.pp.time_zone,new_date_),'dd/mm/yyyy')>
<cfelseif isdefined("session.ww.userid")>
	<cfset new_date = dateformat(date_add("h",session.ww.time_zone,new_date_),'dd/mm/yyyy')>
<cfelseif isdefined("session.ep.userid")>
	<cfset new_date = dateformat(date_add("h",session.ep.time_zone,new_date_),'dd/mm/yyyy')>
</cfif>
<cf_date tarih='new_date'>
<cfif isdefined("card_paymethod_id") and attributes.paymethod_type eq 2>
	<cfset order_due_date = new_date>
	<cfset order_row_due_date = datediff("d",now(),order_due_date)>
<cfelseif isdefined("paymethod_id") and listfind("3,4",attributes.paymethod_type)>
	<cfif len(attributes.risk_due_day)>
		<cfset order_due_date = date_add("d",attributes.risk_due_day,now())>
		<cfset order_row_due_date = datediff("d",now(),order_due_date)>
	</cfif>
<cfelse>
	<cfset order_due_date = "">
	<cfset order_row_due_date = "">
</cfif>
<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
	<cfif not isdefined("attributes.ship_address0")>
		<cfif len(attributes.ship_work_doorno0)>
			<cfset door_no = '#attributes.ship_work_doorno0#'>
		<cfelse>
			<cfset door_no = ''>
		</cfif>
		<cfif isdefined("attributes.ship_district0") and len(attributes.ship_district0)>
			<cfset attributes.ship_address0 = '#attributes.ship_district0# #attributes.ship_main_street0# #attributes.ship_street0# #door_no#'>
		<cfelseif isdefined("attributes.ship_district_id0") and len(attributes.ship_district_id0)>
			<cfquery name="GET_DIST_NAME" datasource="#DSN#">
				SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_district_id0#">
			</cfquery>
			<cfset attributes.ship_address0 = '#get_dist_name.district_name# #attributes.ship_main_street0# #attributes.ship_street0# #door_no#'>
		</cfif>
	</cfif>
	<cfif isDefined("attributes.ship_address0") and len(attributes.ship_address0)>
		<cfset ship_adres=attributes.ship_address0>
	<cfelse>
		<cfset ship_adres="">
	</cfif>
	<cfif len(attributes.ship_address_postcode0)>
		<cfset ship_adres=ship_adres&' '&attributes.ship_address_postcode0>
	</cfif>
	<cfif len(attributes.ship_address_semt0)>
		<cfset ship_adres=ship_adres&' '&attributes.ship_address_semt0>
	</cfif>
	<cfif len(attributes.ship_address_county0)>
		<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_address_county0#">
		</cfquery>
		<cfset ship_adres=ship_adres&' '&get_county_name.county_name>
		<cfset county_id1=attributes.ship_address_county0>
	</cfif>
	<cfif len(attributes.ship_address_city0)>
		<cfquery name="GET_CITY_NAME" datasource="#DSN#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_address_city0#">
		</cfquery>
		<cfset ship_adres=ship_adres&' / '&get_city_name.city_name>
		<cfset city_id1=attributes.ship_address_city0>
	</cfif>
	<cfif len(attributes.ship_address_country0)>
		<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_address_country0#">
		</cfquery>
		<cfset ship_adres=ship_adres&' '&get_country_name.country_name>
	</cfif>
<cfelseif isdefined("attributes.ship_address_row") and attributes.ship_address_row neq -1>
	<cfif isdefined('attributes.ship_address_row') and isdefined("attributes.ship_address#attributes.ship_address_row#") and len(evaluate('attributes.ship_address#attributes.ship_address_row#'))>
		<cfset ship_adres=evaluate('attributes.ship_address#attributes.ship_address_row#')>
	</cfif>
	<cfif isdefined('attributes.ship_address_row') and len(evaluate('attributes.ship_address_county#attributes.ship_address_row#'))>
		<cfset county_id1=evaluate('attributes.ship_address_county#attributes.ship_address_row#')>
	</cfif>
	<cfif isdefined('attributes.ship_address_row') and  len(evaluate('attributes.ship_address_city#attributes.ship_address_row#'))>
		<cfset city_id1=evaluate('attributes.ship_address_city#attributes.ship_address_row#')>
	</cfif>
	<cfif isdefined('attributes.ship_address_row') and len(evaluate('attributes.ship_address_branch_name#attributes.ship_address_row#'))>
		<cfset adress_branch_name=evaluate('attributes.ship_address_branch_name#attributes.ship_address_row#')>
	</cfif>
	<cfif isdefined('attributes.ship_address_row') and len(evaluate('attributes.ship_address_nick_name#attributes.ship_address_row#'))>
		<cfset branch_nick_name=evaluate('attributes.ship_address_nick_name#attributes.ship_address_row#')>
	</cfif>
</cfif>

<cfif isdefined("attributes.tax_address_row") and attributes.tax_address_row eq 0>
	<cfif not isdefined("attributes.tax_address0")>
		<cfif len(attributes.tax_work_doorno0)>
			<cfset door_no = '#attributes.tax_work_doorno0#'>
		<cfelse>
			<cfset door_no = ''>
		</cfif>
		<cfif isdefined("attributes.tax_district0") and len(attributes.tax_district0)>
			<cfset attributes.tax_address0 = '#attributes.tax_district0# #attributes.tax_main_street0# #attributes.tax_street0# #door_no#'>
		<cfelseif isdefined("attributes.tax_district_id0") and len(attributes.tax_district_id0)>
			<cfquery name="GET_DIST_NAME" datasource="#DSN#">
				SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tax_district_id0#">
			</cfquery>
			<cfset attributes.tax_address0 = '#get_dist_name.district_name# #attributes.tax_main_street0# #attributes.tax_street0# #door_no#'>
		</cfif>
	</cfif>
	<cfif isDefined("attributes.tax_address0") and len(attributes.tax_address0)>
		<cfset tax_adres=attributes.tax_address0>
	<cfelse>
		<cfset tax_adres="">
	</cfif>
	<cfif len(attributes.tax_address_postcode0)>
		<cfset tax_adres=tax_adres&' '&attributes.tax_address_postcode0>
	</cfif>
	<cfif len(attributes.tax_address_semt0)>
		<cfset tax_adres=tax_adres&' '&attributes.tax_address_semt0>
	</cfif>
	<cfif len(attributes.tax_address_county0)>
		<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tax_address_county0#">
		</cfquery>
		<cfset tax_adres=tax_adres&' '&get_county_name.county_name>
		<cfset county_id2=attributes.tax_address_county0>
	</cfif>
	<cfif len(attributes.tax_address_city0)>
		<cfquery name="GET_CITY_NAME" datasource="#DSN#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tax_address_city0#">
		</cfquery>
		<cfset tax_adres=tax_adres&' / '&get_city_name.city_name>
		<cfset city_id2=attributes.tax_address_city0>
	</cfif>
	<cfif len(attributes.tax_address_country0)>
		<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.tax_address_country0#">
		</cfquery>
		<cfset tax_adres=tax_adres&' '&get_country_name.country_name>
	</cfif>
<cfelseif isdefined("attributes.tax_address_row") and attributes.tax_address_row neq -1>
	<cfif isdefined('attributes.tax_address_row') and isdefined("attributes.tax_address#attributes.tax_address_row#") and len(evaluate('attributes.tax_address#attributes.tax_address_row#'))>
		<cfset tax_adres=evaluate('attributes.tax_address#attributes.tax_address_row#')>
	</cfif>
	<cfif isdefined('attributes.tax_address_row') and len(evaluate('attributes.tax_address_county#attributes.tax_address_row#'))>
		<cfset county_id2=evaluate('attributes.tax_address_county#attributes.tax_address_row#')>
	</cfif>
	<cfif isdefined('attributes.tax_address_row') and  len(evaluate('attributes.tax_address_city#attributes.tax_address_row#'))>
		<cfset city_id2=evaluate('attributes.tax_address_city#attributes.tax_address_row#')>
	</cfif>
	<cfif isdefined('attributes.tax_address_row') and len(evaluate('attributes.tax_address_branch_name#attributes.tax_address_row#'))>
		<cfset adress_branch_name=evaluate('attributes.tax_address_branch_name#attributes.tax_address_row#')>
	</cfif>
	<cfif isdefined('attributes.tax_address_row') and len(evaluate('attributes.tax_address_nick_name#attributes.tax_address_row#'))>
		<cfset branch_nick_name=evaluate('attributes.tax_address_nick_name#attributes.tax_address_row#')>
	</cfif>
<cfelse>
    <cfset tax_adres = ''>
    <cfif isDefined('session.pp.userid')>
        <cfquery name="GET_INV_ADDR" datasource="#DSN#">
            SELECT
                COMPBRANCH_ADDRESS TAX_ADRESS,
                COMPBRANCH_POSTCODE POSTCODE,
                COUNTY_ID TAX_COUNTY_ID,
                CITY_ID TAX_CITY_ID,
                COUNTRY_ID TAX_COUNTRY_ID,
                SEMT TAX_SEMT,
                '' TAX_DISTRICT_ID
            FROM
                COMPANY_BRANCH 
            WHERE 
                COMPANY_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
                IS_INVOICE_ADDRESS = 1
        </cfquery>
        <cfif not get_inv_addr.recordcount>
            <cfquery name="GET_INV_ADDR" datasource="#DSN#">
                SELECT
                    COMPANY_ADDRESS TAX_ADRESS,
                    COMPANY_POSTCODE POSTCODE,
                    COUNTY TAX_COUNTY_ID,
                    CITY TAX_CITY_ID,
                    COUNTRY TAX_COUNTRY_ID,
                    SEMT TAX_SEMT,
                    DISTRICT_ID TAX_DISTRICT_ID
                FROM 
                    COMPANY
                WHERE
                    COMPANY_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
                    COMPANY_STATUS = 1 
            </cfquery>
        </cfif>	
    <cfelse>
        <cfquery name="GET_INV_ADDR" datasource="#DSN#">
            SELECT 
                TAX_ADRESS,
                TAX_SEMT,
                TAX_COUNTY_ID,
                TAX_CITY_ID,
                TAX_COUNTRY_ID,  
                TAX_DISTRICT_ID 
            FROM 
                CONSUMER 
            WHERE
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
        </cfquery>
    </cfif>
    <cfif len(get_inv_addr.tax_district_id)>
        <cfquery name="GET_DISTRICT_NAME" datasource="#DSN#">
            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inv_addr.tax_district_id#">
        </cfquery>
        <cfset tax_adres = tax_adres&' '&get_district_name.district_name>
    </cfif>
    <cfset tax_adres = tax_adres&' '&get_inv_addr.tax_adress>
    <cfset tax_adres = tax_adres&' '&get_inv_addr.tax_semt>
    <cfif len(get_inv_addr.tax_county_id)>
        <cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inv_addr.tax_county_id#">
        </cfquery>
        <cfset tax_adres=tax_adres&' '&get_county_name.county_name>
        <cfset county_id2=get_inv_addr.tax_county_id>
    </cfif>
    <cfif len(get_inv_addr.tax_city_id)>
        <cfquery name="GET_CITY_NAME" datasource="#DSN#">
            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inv_addr.tax_city_id#">
        </cfquery>
        <cfset tax_adres=tax_adres&' / '&get_city_name.city_name>
        <cfset city_id2=get_inv_addr.tax_city_id>
    </cfif>
    <cfif len(get_inv_addr.tax_country_id)>
        <cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inv_addr.tax_country_id#">
        </cfquery>
        <cfset tax_adres=tax_adres&' '&get_country_name.country_name>
    </cfif>
</cfif>

<cfif isdefined('attributes.deliverdate') and  len(attributes.deliverdate)><cf_date tarih="attributes.deliverdate"></cfif>
<cfif isdefined("attributes.tc_identy_no") and isdefined("session.ww.userid")>
	<cfquery name="UPD_TC_" datasource="#DSN#">
		UPDATE CONSUMER SET TC_IDENTY_NO = '#attributes.tc_identy_no#' WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfquery>
</cfif>
<cfif isdefined("attributes.tc_identy_no") and isdefined("session.pp.userid")>
	<cfquery name="UPD_TC_" datasource="#DSN#">
		UPDATE 
			COMPANY 
		SET 
			TAXOFFICE = '#attributes.tax_office#',
			TAXNO = '#attributes.tax_no#'
		WHERE
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
</cfif>

<cfif isdefined('member_type') and member_type is "PARTNER">
	<cfquery name="GET_MEMBER_INFO" datasource="#DSN#">
		SELECT SALES_COUNTY,COMPANY_VALUE_ID CUSTOMER_VALUE_ID,RESOURCE_ID,IMS_CODE_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
	</cfquery>
	<cfquery name="GET_MANAGER_PARTNER" datasource="#DSN#">
	  SELECT 
	       C.MANAGER_PARTNER_ID,
		   C.COMPANY_EMAIL,
		   CP.PARTNER_ID,
		   CP.COMPANY_PARTNER_EMAIL
	  FROM 
	       COMPANY C,
		   COMPANY_PARTNER CP
	WHERE 
           C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
	       C.MANAGER_PARTNER_ID= CP.PARTNER_ID 
	</cfquery>
	<cfquery name="GET_SALES_MANAGER" datasource="#DSN#">
		SELECT 
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_EMAIL,   
			C.COMPANY_EMAIL
		FROM 
			COMPANY C,
			WORKGROUP_EMP_PAR WEP,
			EMPLOYEE_POSITIONS EP
		WHERE 
			WEP.COMPANY_ID IS NOT NULL AND
			C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			WEP.COMPANY_ID = C.COMPANY_ID AND
			EP.POSITION_CODE = WEP.POSITION_CODE AND
			WEP.IS_MASTER = 1 AND
			WEP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
 	<cfset employee_id=get_sales_manager.employee_id>
<cfelseif isdefined('member_type') and member_type is "CONSUMER">
	<cfquery name="GET_MEMBER_INFO" datasource="#DSN#">
		SELECT SALES_COUNTY,CUSTOMER_VALUE_ID,RESOURCE_ID,IMS_CODE_ID,CONSUMER_REFERENCE_CODE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfquery>
	<cfquery name="GET_SALES_MANAGER" datasource="#DSN#">
		SELECT 
			EP.EMPLOYEE_ID,
			EP.EMPLOYEE_EMAIL,
			C.CONSUMER_EMAIL,
			WEP.POSITION_CODE
		FROM    
			CONSUMER C,
			WORKGROUP_EMP_PAR WEP,
			EMPLOYEE_POSITIONS EP
		WHERE 
			WEP.CONSUMER_ID IS NOT NULL AND
			WEP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
			WEP.CONSUMER_ID = C.CONSUMER_ID AND
			WEP.IS_MASTER = 1 AND 
			EP.POSITION_CODE = WEP.POSITION_CODE
	</cfquery>
	<cfset employee_id=get_sales_manager.employee_id>
</cfif>
<cfquery name="GET_OUR_COMPANY_MAIL" datasource="#DSN#">
	 SELECT EMAIL FROM OUR_COMPANY  WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
</cfquery>
<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined("attributes.first_interest_rate") and len(attributes.first_interest_rate)>
	<cfset havale_indirim_orani_ = 1-(attributes.first_interest_rate/100)>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 7 and isdefined("attributes.first_interest_rate_door") and len(attributes.first_interest_rate_door)>
	<cfset havale_indirim_orani_ = 1-(attributes.first_interest_rate_door/100)><!--- FA --->
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2 and isdefined("attributes.kredi_karti_indirim_orani") and attributes.kredi_karti_indirim_orani gt 0>
	<cfset havale_indirim_orani_ = 1-(attributes.kredi_karti_indirim_orani/100)>
<cfelse>
	<cfset havale_indirim_orani_ = 1>
</cfif>
<cfif isdefined("form.genel_indirim") and len(form.genel_indirim)>
	<cfset indirim_total_ = form.genel_indirim>
<cfelse>
	<cfset indirim_total_ = 0>
</cfif>
<cfset tum_indirim = 0>
<cfquery name="GET_BASKET_ROWS_2" datasource="#DSN3#">
	SELECT 
		'0' AS TYPE,
		*,
		'' AS STOCK_CODE,
		'' AS STOCK_CODE_2,
  		0 AS IS_INVENTORY,
        '' ASPRODUCT_DETAIL,
		0 AS IS_LIMITED_STOCK,
		'' AS DIMENTION,
		'Adet' AS MAIN_UNIT,
		'' AS PROPERTY
	FROM
		ORDER_PRE_ROWS
	WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")><!--- sistemde olmayan misafir kullanıcılar için baskete atılan ürünler --->
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#')#"> AND
		</cfif>
		STOCK_ID = -1
</cfquery>
<cfoutput query="get_basket_rows_2">
	<cfquery name="GET_MONEY_RATE2_PRICE_STANDARD" datasource="#DSN2#">
		SELECT 
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelseif isDefined("session.ww")>
				RATEWW2 RATE2
			<cfelse>
				RATE2
			</cfif>	
		FROM 
			SETUP_MONEY
		WHERE 
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_money#"> AND
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
	<cfquery name="GET_MONEY_RATE2" datasource="#DSN2#">
		SELECT 
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelseif isDefined("session.ww")>
				RATEWW2 RATE2
			<cfelse>
				RATE2
			</cfif>	
		FROM 
			SETUP_MONEY
		WHERE 
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#price_standard_money#"> AND
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#int_comp_id#">
	</cfquery>
	<cfscript>
		if((not is_prom_asil_hediye or (len(prom_product_price) and prom_product_price gt 0)) and (not len(stock_action_type) or (len(stock_action_type) and not listfind('1,2,3',stock_action_type))))//promosyon verilen urunun promosyon fiyatı varsa toplama eklenir
		{
			if(not len(price_standard_kdv))
			{
				this_price_standart_kdv = 0;
				this_price_standart = 0;
			}
			else
			{
				this_price_standart_kdv = price_standard_kdv;
				this_price_standart = price_standard;
			}
			if(not get_money_rate2_price_standard.recordcount)
				my_money = 1;
			else
				my_money = get_money_rate2_price_standard.rate2;
			satir_toplam_std = wrk_round((price * quantity * prom_stock_amount * get_money_rate2.rate2),4);
			satir_toplam_std_ps = this_price_standart * quantity * prom_stock_amount * my_money;
			satir_toplam_std_kdvli = wrk_round((price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2),4);
			satir_toplam_std_kdvli_ps = this_price_standart_kdv * quantity * prom_stock_amount * my_money;
			if(is_commission neq 1)
				satir_toplam_komisyonsuz = wrk_round((price_kdv * quantity * prom_stock_amount * get_money_rate2.rate2),4);
			kdv_miktari = wrk_round((satir_toplam_std * (tax/100)),4);
			kdv_miktari_ps = satir_toplam_std_ps * (tax/100);
				
			if(is_checked eq 1)
				tum_indirim = tum_indirim + (-1 * satir_toplam_std);
		}
	</cfscript>
</cfoutput>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset discount_total_ = DISCOUNTTOTAL_PS>
<cfelseif isDefined('attributes.discounttotal')>
	<cfset discount_total_ = attributes.discounttotal>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset tax_total_ = TAXTOTAL_PS>
<cfelse>
	<cfset tax_total_ = attributes.taxtotal>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset net_total_ = NETTOTAL_PS>
<cfelseif isDefined('NETTOTAL')>
	<cfset net_total_ = NETTOTAL + tum_indirim>
</cfif>
<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
	<cfset gross_total_ = GROSSTOTAL_PS>
<cfelseif isDefined('GROSSTOTAL')>
	<cfset gross_total_ = GROSSTOTAL + tum_indirim>
</cfif>

<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined("attributes.first_interest_rate") and len(attributes.first_interest_rate)>
	<cfset havale_indirim_ = (gross_total_-cargo_toplam_kdvli) * attributes.first_interest_rate/100>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 7 and isdefined("attributes.first_interest_rate_door") and len(attributes.first_interest_rate_door)>
	<cfset havale_indirim_ = gross_total_ * attributes.first_interest_rate/100><!--- FA --->
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 2 and isdefined("attributes.kredi_karti_indirim_orani") and attributes.kredi_karti_indirim_orani gt 0>
	<cfset havale_indirim_ = gross_total_ * attributes.kredi_karti_indirim_orani / 100>
<cfelse>
	<cfset havale_indirim_ = 0>
</cfif>
<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined("attributes.first_interest_rate") and len(attributes.first_interest_rate)>
	<cfset tax_indirim_ = tax_total_ * attributes.first_interest_rate/100>
<cfelseif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 7 and isdefined("attributes.first_interest_rate_door") and len(attributes.first_interest_rate_door)>
	<cfset tax_indirim_ = tax_total_ * attributes.first_interest_rate/100><!--- FA --->
<cfelse>
	<cfset tax_indirim_ = 0>
</cfif>
<cfset tax_total_ = tax_total_ - tax_indirim_>
<cfset net_total_ = net_total_ - havale_indirim_ - tax_indirim_>
<cfset indirim_total_ = indirim_total_ + havale_indirim_>
<cfset discount_total_ = discount_total_ + havale_indirim_>

<cfif isDefined('attributes.is_spect_control') and attributes.is_spect_control eq 1>
	<cfset spect_list = ''>
    <cfoutput query="get_rows">
        <cfif len(spec_var_id) and not listfindnocase(spect_list,spec_var_id,',')>
            <cfset spect_list = listappend(spect_list,spec_var_id,',')>
        </cfif>    
    </cfoutput>
         
    <cfif len(spect_list)>   
        <cfquery name="GET_SPECT_MAIN" datasource="#DSN3#">
            SELECT 
                SM.SPECT_STATUS,
                S.SPECT_VAR_ID,
                SM.IS_LIMITED_STOCK,
                SM.SPECT_MAIN_ID,
                SM.SPECT_MAIN_NAME  
            FROM 
                SPECTS S,
                SPECT_MAIN SM
            WHERE 
                S.SPECT_MAIN_ID = SM.SPECT_MAIN_ID AND
                S.SPECT_VAR_ID IN (#spect_list#)            
        </cfquery>
    <cfelse>
        <cfset get_spect_main.recordcount = 0>
    </cfif>
</cfif>

<!--- baglanti kullaniliyor ise baglantinin odeme yontemi ve vadesi atılıyor --->
<cfif isdefined('attributes.project_id_new_') and len(attributes.project_id_new_)>
	<cfquery name="GET_PROJECT_PAYMETHOD" datasource="#DSN3#">
    	SELECT 
            PD.PAYMETHOD_ID,
            PD.CARD_PAYMETHOD_ID,
            SP.DUE_DAY
        FROM 
            PROJECT_DISCOUNTS PD
            LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP ON PD.PAYMETHOD_ID = SP.PAYMETHOD_ID
       	WHERE 
			PD.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id_new_#">
    </cfquery>
    <cfif len(get_project_paymethod.paymethod_id)>
    	<cfset paymethod_id = get_project_paymethod.paymethod_id>
        <cfif len(get_project_paymethod.due_day)>
            <cfset order_due_date = dateadd('d',get_project_paymethod.due_day,new_date)>
        </cfif>
    <cfelseif len(get_project_paymethod.card_paymethod_id)>
    	<cfset card_paymethod_id = get_project_paymethod.card_paymethod_id>
    </cfif>
</cfif>

<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session_base.userid#_'&round(rand()*100)>
<cfif get_rows.recordcount>
	<cfoutput query="get_rows">
		<cfif (isDefined('session.pp.userid') and len(is_extranet) and is_extranet neq 1) or (isDefined('session.ww.userid') and len(is_internet) and is_internet neq 1)>
			<script>
				alert('#product_name# ürünü internette yayında değil!');
				window.history.back(-1);
			</script>
		</cfif>
	</cfoutput>
	<cfquery name="GET_MEMBER_RISK" dbtype="query" maxrows="1">
		SELECT IS_PART FROM GET_ROWS WHERE IS_CHECKED = 1
	</cfquery>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="SET_GENERAL_PAPERS" datasource="#DSN3#">
				UPDATE
					GENERAL_PAPERS
				SET
					ORDER_NUMBER = ORDER_NUMBER+1
				WHERE
					PAPER_TYPE = 0 AND
					ZONE_TYPE = <cfif isDefined("session.ep.userid")>0<cfelse>1</cfif>
			</cfquery>
			<cfquery name="GET_GENERAL_PAPERS"  datasource="#DSN3#">
				SELECT 
					ORDER_NO,
					ORDER_NUMBER 
				FROM 
					GENERAL_PAPERS 
				WHERE 
					PAPER_TYPE = 0 AND
					ZONE_TYPE = <cfif isDefined("session.ep.userid")>0<cfelse>1</cfif>
			</cfquery>
			
			<cfset temp_order_number = '#get_general_papers.order_no#-#get_general_papers.order_number#'>
            
			<cfquery name="ADD_ORDER" datasource="#DSN3#" result="GET_MAX_ORDER">
				INSERT INTO
					ORDERS
					(
						WRK_ID,
						ORDER_NUMBER,
						<cfif isdefined("position_code") and len(position_code) and len(position)>
							VALIDATOR_POSITION_CODE,
						</cfif>
						ORDER_CURRENCY,
						ORDER_STATUS,
						PRIORITY_ID, 
						COMMETHOD_ID,
						<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>
							DELIVERDATE,
						</cfif>
						<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")><!--- son kullanıcıdan siperiş girme --->
							CONSUMER_ID,
						<cfelse>
							<cfif member_type is "PARTNER">
								PARTNER_ID,
								COMPANY_ID,
							<cfelseif member_type is "CONSUMER">
								CONSUMER_ID,
								CONSUMER_REFERENCE_CODE,
							</cfif>
						</cfif>
						<cfif isdefined("paymethod_id") and len(paymethod_id)>
							PAYMETHOD,
						<cfelseif isdefined("card_paymethod_id") and len(card_paymethod_id)>
							CARD_PAYMETHOD_ID,
							CARD_PAYMETHOD_RATE,
						</cfif>
						<cfif isdefined("offer_id") and len(offer_id) and len(offer_head)>
							OFFER_ID,
						</cfif>
						<cfif isdefined("sales_position_code") and len(sales_position_code) and len(sales_position)>
							SALES_POSITION_CODE,
						</cfif>
						SALES_PARTNER_ID,
						SALES_CONSUMER_ID,
						SHIP_ADDRESS,
						SHIP_ADDRESS_ID,
						TAX_ADDRESS,
						TAX_ADDRESS_ID,
						COUNTY_ID,
						CITY_ID,
						ORDER_HEAD,
						ORDER_DETAIL,
						ZONE_ID,
						RESOURCE_ID,
						IMS_CODE_ID,
						CUSTOMER_VALUE_ID,
						GROSSTOTAL,
						TAXTOTAL,
						OTV_TOTAL,
						DISCOUNTTOTAL,
						NETTOTAL,
						INCLUDED_KDV,
						OTHER_MONEY,
						OTHER_MONEY_VALUE,
						PURCHASE_SALES,
						RECORD_DATE,
						RECORD_IP,
						RECORD_CON,
						RECORD_PAR,
						RECORD_EMP,
						ORDER_ZONE
						<cfif isdefined("attributes.ship_method_id") and len(attributes.ship_method_id)>,SHIP_METHOD</cfif>
						,RESERVED
						,PROJECT_ID
						,ORDER_DATE
						,ORDER_STAGE
						,ORDER_EMPLOYEE_ID,
						DUE_DATE,
						REF_NO,
						SA_DISCOUNT,
						GENERAL_PROM_ID,
						GENERAL_PROM_LIMIT,
						GENERAL_PROM_AMOUNT,
						GENERAL_PROM_DISCOUNT, 
						FREE_PROM_ID,
						FREE_PROM_LIMIT,
						FREE_PROM_AMOUNT,
						FREE_PROM_STOCK_ID,
						FREE_STOCK_PRICE,
						FREE_STOCK_MONEY,
						FREE_PROM_COST,
						IS_ENDUSER_PRICE,
						IS_MEMBER_RISK,
						DELIVER_DEPT_ID,
						REF_COMPANY_ID,
						REF_PARTNER_ID,
						LOCATION_ID,
						ORDER_PAYMENT_VALUE 
					)
				VALUES
					(
						'#wrk_id#',
						'#temp_order_number#',
						<cfif isdefined("position_code") and len(position_code) and len(position)>
							#position_code#,
						</cfif>
						-1,
						1,
						1, 
						<cfif isDefined("attributes.company_id") and len(attributes.company_id)>7,<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>6,</cfif>
						<cfif isdefined("attributes.deliverdate") and len(attributes.deliverdate)>#attributes.deliverdate#,</cfif>
						<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
							#get_max_cons.max_cons#,
						<cfelse>
							<cfif member_type is "partner">
								<cfif len(member_id)>#member_id#<cfelse>null</cfif>,
								#attributes.company_id#,
							<cfelseif member_type is "consumer">
								#attributes.consumer_id#,
								<cfif isdefined("get_member_info") and len(get_member_info.consumer_reference_code)>'#get_member_info.consumer_reference_code#'<cfelse>NULL</cfif>,
							</cfif>
						</cfif>
						<cfif isdefined("paymethod_id") and len(paymethod_id)>
							#listfirst(paymethod_id)#,
						<cfelseif isdefined("card_paymethod_id") and len(card_paymethod_id)>
							#listfirst(card_paymethod_id)#,
							<cfif listlen(card_paymethod_id) gt 1>#listgetat(card_paymethod_id,2,',')#<cfelse>NULL</cfif>,
						</cfif>
						<cfif isdefined("offer_id") and len(offer_id) and len(offer_head)>#offer_id#,</cfif>
						<cfif isdefined("sales_position_code") and len(sales_position_code) and len(sales_position)>#sales_position_code#,</cfif>
						<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
							#session.pp.userid#,
						<cfelseif isdefined("sales_partner_id") and len(sales_partner_id) and len(sales_partner)>
							#sales_partner_id#,
						<cfelseif isdefined("get_rows.sale_partner_id") and len(get_rows.sale_partner_id)>
							#get_rows.sale_partner_id#,
						<cfelse>
							NULL,
						</cfif>
						<cfif isdefined("get_rows.sale_consumer_id") and len(get_rows.sale_consumer_id)>#get_rows.sale_consumer_id#<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.is_same_tax_ship') and len(attributes.is_same_tax_ship)>
							<cfif isdefined('tax_adres') and len(tax_adres)>'#left(tax_adres,500)#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.tax_address_row') and attributes.tax_address_row eq -1>
								-3,
							<cfelseif isdefined('attributes.tax_address_row') and attributes.tax_address_row eq 0>
								NULL,
							<cfelseif isdefined("attributes.tax_address_row")>
								#evaluate('attributes.tax_address_id#attributes.tax_address_row#')#,
							<cfelse>
								0,
							</cfif>
						<cfelse>
							<cfif isdefined('ship_adres') and len(ship_adres)>'#left(ship_adres,500)#'<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.ship_address_row') and attributes.ship_address_row eq 0>
								NULL,
							<cfelse>
								#evaluate('attributes.ship_address_id#attributes.ship_address_row#')#,
							</cfif>
						</cfif>
						<cfif isdefined('tax_adres') and len(tax_adres)>'#left(tax_adres,500)#'<cfelse>NULL</cfif>,
						<cfif isdefined('attributes.tax_address_row') and attributes.tax_address_row eq -1>
							-3,
						<cfelseif isdefined('attributes.tax_address_row') and attributes.tax_address_row eq 0>
							NULL,
						<cfelseif isdefined("attributes.tax_address_row")>
							#evaluate('attributes.tax_address_id#attributes.tax_address_row#')#,
						<cfelse>
							NULL,
						</cfif>
						<cfif isdefined('attributes.is_same_tax_ship') and len(attributes.is_same_tax_ship)>
							<cfif isdefined('county_id2') and len(county_id2)>#county_id2#<cfelse>NULL</cfif>,
                            <cfif isdefined('city_id2') and len(city_id2)>#city_id2#<cfelse>NULL</cfif>,
                        <cfelse>
                            <cfif isdefined('county_id1') and len(county_id1)>#county_id1#<cfelse>NULL</cfif>,
                            <cfif isdefined('city_id1') and len(city_id1)>#city_id1#<cfelse>NULL</cfif>,					
                        </cfif>	
						<cfif isdefined('attributes.order_head_') and len(attributes.order_head_)>'#attributes.order_head_#'<cfelseif isdefined("session.ep")>'Sipariş'<cfelse>'İnternetten Sipariş'</cfif>,
						<cfif isdefined("attributes.order_detail")>'#order_detail#'<cfelse>NULL</cfif>,
						<cfif len(get_member_info.sales_county) and not(isdefined("attributes.is_price_standart") and isdefined("attributes.consumer_info"))>#get_member_info.sales_county#,<cfelse>NULL,</cfif>
						<cfif len(get_member_info.resource_id) and not(isdefined("attributes.is_price_standart") and isdefined("attributes.consumer_info"))>#get_member_info.resource_id#,<cfelse>NULL,</cfif>
						<cfif len(get_member_info.ims_code_id) and not(isdefined("attributes.is_price_standart") and isdefined("attributes.consumer_info"))>#get_member_info.ims_code_id#,<cfelse>NULL,</cfif>
						<cfif len(get_member_info.customer_value_id) and not(isdefined("attributes.is_price_standart") and isdefined("attributes.consumer_info"))>#get_member_info.customer_value_id#,<cfelse>NULL,</cfif>
						#gross_total_#,
						#tax_total_#,
						0,
						#discount_total_#,
						#net_total_#,
						<cfif isdefined("included_kdv")>1<cfelse>0</cfif>,
						<cfif len(other_money)>'#other_money#',<cfelse>NULL,</cfif>
						<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
							#OTHER_MONEY_VALUE_PS * havale_indirim_orani_#,
						<cfelseif len(OTHER_MONEY_VALUE)>
							#OTHER_MONEY_VALUE * havale_indirim_orani_#,
						<cfelse>
							NULL,
						</cfif>
						<cfif isDefined("session.ep")>1,<cfelse>0,</cfif>
						#now()#,
						'#CGI.REMOTE_ADDR#',
						<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
						<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
						<cfif isDefined("session.ep")>0<cfelse>1</cfif>
						<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>
						,#attributes.ship_method_id#	
						</cfif>
						,1
						<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
							,#attributes.project_id#
						<cfelseif isdefined('attributes.project_attachment') and len(attributes.project_attachment)>
							,#attributes.project_attachment#
						<cfelse>
							,NULL
						</cfif>
						,#new_date#
						,#attributes.process_stage#
						,<cfif isdefined("employee_id") and len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
						<cfif isdefined("order_due_date") and len(order_due_date)>#order_due_date#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
						#indirim_total_#,
						<cfif isdefined("attributes.general_prom_id") and len(attributes.general_prom_id)>#attributes.general_prom_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.general_prom_limit") and len(attributes.general_prom_limit)>#attributes.general_prom_limit#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.general_prom_amount") and len(attributes.general_prom_amount)>#attributes.general_prom_amount#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.general_prom_discount") and len(attributes.general_prom_discount)>#attributes.general_prom_discount#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_id") and len(attributes.free_prom_id)>#attributes.free_prom_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_limit") and len(attributes.free_prom_limit)>#attributes.free_prom_limit#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>#attributes.free_prom_amount#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id)>#attributes.free_prom_stock_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_stock_price") and len(attributes.free_stock_price)>#attributes.free_stock_price#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_stock_money") and len(attributes.free_stock_money)>'#attributes.free_stock_money#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.free_prom_cost") and len(attributes.free_prom_cost)>#attributes.free_prom_cost#<cfelse>NULL</cfif>,
						<cfif isDefined("attributes.is_price_standart")>1<cfelse>0</cfif>,<!--- son kullanıcı fiyatı bilgisi --->
						<cfif get_member_risk.is_part eq 0>1<cfelse>0</cfif>,
						<cfif isdefined("attributes.sale_department_id") and len(attributes.sale_department_id)>#attributes.sale_department_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_company_id") and len(attributes.ref_company_id)>#attributes.ref_company_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.ref_partner_id") and len(attributes.ref_partner_id)>#attributes.ref_partner_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.sale_location_id") and len(attributes.sale_location_id)>#attributes.sale_location_id#<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.paymethod_type") and listfind("2,4",attributes.paymethod_type) and isdefined("cc_paym_id_info")><!--- kredi kartı ile ödemişse ödeyeceği tutar 0'dır --->
							0
						<cfelse>
							<cfif isdefined('attributes.order_payment_value') and len(attributes.order_payment_value)>#attributes.order_payment_value#<cfelse>NULL</cfif>
						</cfif> 
					)
			</cfquery> 
			<cfset get_max_order.max_id = get_max_order.identitycol>
			<cfif isdefined("attributes.is_order_info")><!--- ozel sepetten gelen info bilgileri icin YO--->
				<cfquery name="ADD_INFO" datasource="#DSN3#">
					UPDATE 
						ORDER_INFO_PLUS
					SET
						ORDER_ID = #GET_MAX_ORDER.MAX_ID#,
						RECORD_GUEST = NULL,
						COOKIE_NAME = NULL
					WHERE
						RECORD_GUEST = 1 AND 
						RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
						COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#">
				</cfquery>
			</cfif>
			<cfoutput query="get_rows">
				<cfif isdefined("attributes.is_checked") and listfindnocase(attributes.is_checked,order_row_id)><!--- secili satir kontrolu --->
					<cfif not len(stock_action_type) or (len(stock_action_type) and not listfind('1,2,3',stock_action_type))>
						<cf_date tarih="attributes.deliver_date">
						<cfloop from="1" to="#attributes.kur_say#" index="int_tr">
							<cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>
								<cfif price_standard_money eq evaluate("hidden_rd_money_#int_tr#")>
									<cfset satir_fiyati= price_standard * evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#") >
									<cfset oth_m_val = evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#")>
								</cfif>
							<cfelse>
								<cfif price_money eq evaluate("hidden_rd_money_#int_tr#")>
									<cfif len(price_old)>
										<cfset satir_fiyati= price_old * evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#")>
									<cfelse>
										<cfset satir_fiyati= price * evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#")>
									</cfif>
									<cfset oth_m_val = evaluate("txt_rate2_#int_tr#")/evaluate("txt_rate1_#int_tr#")>
								</cfif>
							</cfif>
						</cfloop>
						<cfset 'net_maliyet#currentrow#' = ''>
						<cfset 'extra_cost#currentrow#' = ''>
						<cfset 'row_spect_id#currentrow#' = ''>
						<cfquery name="GET_PRODUCTION" datasource="#DSN3#">
							SELECT IS_PRODUCTION,MANUFACT_CODE,ISNULL(IS_GIFT_CARD,0) IS_GIFT_CARD,GIFT_VALID_DAY FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
						</cfquery>
						<cfif not (len(get_rows.spec_var_id) and len(get_rows.spec_var_name))>
							<cfif is_spec eq 1>
								<cfset this_spec_ = 1>
								<cfset this_row_ = currentrow>
								<cfinclude template="add_orderww_spect.cfm">
							<cfelse>
								<cfif get_production.is_production>
									<cfif is_spec eq 1>
										<cfset this_spec_ = 1>
									<cfelse>
										<cfset this_spec_ = 0>
									</cfif>
									<cfset this_row_ = currentrow>
									<cfinclude template="add_orderww_spect.cfm">
								</cfif>
							</cfif>
						</cfif>
						<cfif (not isdefined('row_spect_id#currentrow#') or not len(evaluate('row_spect_id#currentrow#')))>				
							<cfquery name="GET_PRODUCT_COST" datasource="#DSN3#" maxrows="1">
								SELECT 
									PC.PURCHASE_NET_SYSTEM,
									PC.PURCHASE_EXTRA_COST_SYSTEM
								FROM 
									PRODUCT_COST PC,
									PRODUCT P
								WHERE 
									P.PRODUCT_ID = PC.PRODUCT_ID AND
									PC.PRODUCT_COST IS NOT NULL AND
									PC.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,now())#"> AND 
									PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
									P.IS_COST = 1
								ORDER BY 
									PC.START_DATE DESC,
									PC.RECORD_DATE DESC
							</cfquery>
							<cfif get_product_cost.recordcount>
								<cfset 'net_maliyet#currentrow#' = get_product_cost.purchase_net_system>
								<!--- <cfset 'cost_id#currentrow#' = get_product_cost.product_cost_id> --->
								<cfset 'extra_cost#currentrow#' = get_product_cost.purchase_extra_cost_system>
							</cfif>
						</cfif>
						<cfscript>
							if(len(discount1)) row_disc1=discount1; else row_disc1=0;
							if(len(discount2)) row_disc2=discount2; else row_disc2=0;
							if(len(discount3)) row_disc3=discount3; else row_disc3=0;
							if(len(discount4)) row_disc4=discount4; else row_disc4=0;
							if(len(discount5)) row_disc5=discount5; else row_disc5=0;
							order_disc_rate_=((100-row_disc1) * (100-row_disc2) * (100-row_disc3) * (100-row_disc4) * (100-row_disc5));
							satir_indirimli_fiyat=((satir_fiyati*order_disc_rate_)/10000000000);
							row_nettotal = satir_indirimli_fiyat * quantity * prom_stock_amount;//satir_fiyati * QUANTITY * PROM_STOCK_AMOUNT;
							if (isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info"))
							{
								if(len(prom_amount_discount))
									for(k=1;k lte attributes.kur_say;k=k+1)
										if(price_standard_money eq evaluate("hidden_rd_money_#k#"))
											row_nettotal = row_nettotal - (prom_amount_discount * evaluate("txt_rate2_#k#")/evaluate("txt_rate1_#k#") * quantity * prom_stock_amount);
								if(len(prom_discount))
									row_nettotal = row_nettotal * (100-prom_discount) /100;
								
								row_taxtotal = wrk_round(row_nettotal * (tax/100));
								row_lasttotal = row_nettotal + row_taxtotal;
								other_money_value = row_nettotal;
								for(k=1;k lte attributes.kur_say;k=k+1)
									if(price_standard_money eq evaluate("hidden_rd_money_#k#"))
										other_money_value = other_money_value / evaluate("txt_rate2_#k#");
							}
							else
							{
								if(len(prom_amount_discount))
									for(k=1;k lte attributes.kur_say;k=k+1)
										if(price_money eq evaluate("hidden_rd_money_#k#"))
											row_nettotal = row_nettotal - (prom_amount_discount * evaluate("txt_rate2_#k#")/evaluate("txt_rate1_#k#") * quantity * prom_stock_amount);
								if(len(prom_discount))
									row_nettotal = row_nettotal * (100-prom_discount) /100;
								row_taxtotal = wrk_round(row_nettotal * (tax/100));
								row_lasttotal = row_nettotal + row_taxtotal;
								other_money_value = row_nettotal;
								for(k=1;k lte attributes.kur_say;k=k+1)
									if(price_money eq evaluate("hidden_rd_money_#k#"))
										other_money_value = other_money_value / evaluate("txt_rate2_#k#");
							}
						</cfscript>
                        
                        <cfif isDefined('attributes.is_spect_control') and attributes.is_spect_control eq 1>
							<cfif (len(get_rows.spec_var_id) and len(get_rows.spec_var_name)) or (isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#')))>
                                <cfquery name="GET_SPEC_STAT" dbtype="query">
                                    SELECT 
                                        * 
                                    FROM 
                                        GET_SPECT_MAIN 
                                    WHERE 
                                        <cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
                                            SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_rows.spec_var_id#">
                                        <cfelse>
                                            SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('row_spect_id#currentrow#')#">
                                        </cfif>
                                </cfquery> 
                                
                                <cfif get_spec_stat.spect_status eq 0>
                                    <script language="javascript"> 
                                        alert('#get_spec_stat.spect_main_name# spect ürünü aktif değil!');
                                        window.history.back(-1);
                                    </script>
                                </cfif>  
                            </cfif>
                        </cfif>
                        
						<cfquery name="ADD_ORDER_ROW" datasource="#DSN3#" result="GET_MAX_ROW">
							INSERT INTO
								ORDER_ROW
								(
									WRK_ROW_ID,
									CATALOG_ID,
									UNIQUE_RELATION_ID,
									ORDER_ROW_CURRENCY,
									ORDER_ID,
									PRODUCT_ID,
									STOCK_ID,
									QUANTITY,
									UNIT,
									UNIT_ID,
									PRICE,
									LIST_PRICE,
									TAX,
									DUEDATE,
									PRODUCT_NAME,
									PRODUCT_NAME2,
									BASKET_EXTRA_INFO_ID,
									SELECT_INFO_EXTRA,
									DETAIL_INFO_EXTRA,
									DELIVER_DATE,
									DELIVER_DEPT,
									DELIVER_LOCATION,
									DISCOUNT_1,
									DISCOUNT_2,
									DISCOUNT_3,
									DISCOUNT_4,
									DISCOUNT_5,	
									DISCOUNT_6,
									DISCOUNT_7,
									DISCOUNT_8,
									DISCOUNT_9,
									DISCOUNT_10,
									OTHER_MONEY,
									OTHER_MONEY_VALUE,
									<cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
										SPECT_VAR_ID,
										SPECT_VAR_NAME,
									<cfelseif isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#'))>
										SPECT_VAR_ID,
										SPECT_VAR_NAME,
									</cfif>
									PRICE_OTHER,
									COST_PRICE,
									EXTRA_COST,
									MARJ,
									NETTOTAL,
									PROM_COMISSION,
									PROM_COST,
									DISCOUNT_COST,
									PROM_ID,
									IS_PROMOTION,
									IS_COMMISSION,
									PRODUCT_MANUFACT_CODE,
									RESERVE_TYPE,
									OTV_ORAN,
									OTVTOTAL,
									IS_PRODUCT_PROMOTION_NONEFFECT,
									IS_GENERAL_PROM,
									PROM_STOCK_ID,
									PRICE_CAT,
									LOT_NO
									<cfif isdefined("get_rows.version_no")>,VERSION_NO</cfif>
								)
							VALUES
								(
									<cfif isdefined("session.pp.userid")>
                                    	'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.pp.userid##round(rand()*100)##currentrow#',
									<cfelseif isdefined("session.ww.userid")>
                                    	'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ww.userid##round(rand()*100)##currentrow#',
									<cfelse>
                                    	'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##currentrow#',
									</cfif>
									<cfif len(catalog_id)>#catalog_id#<cfelse>NULL</cfif>,
									<cfif len(unique_relation_id)>'#unique_relation_id#'<cfelse>NULL</cfif>,
									-1,
									#get_max_order.max_id#,
									#product_id#,
									#stock_id#,
									#quantity*prom_stock_amount#,
									'#main_unit#',
									#product_unit_id#,
									#satir_fiyati#,
									<cfif len(satir_fiyati)>#satir_fiyati#<cfelse>NULL</cfif>,
									#tax#,
									<cfif isdefined("attributes.duedate#currentrow#") and len(evaluate("attributes.duedate#currentrow#"))>
										#evaluate("attributes.duedate#currentrow#")#,
									<cfelseif isdefined("order_row_due_date") and len(order_row_due_date)>
										#order_row_due_date#,
									<cfelse>
										0,
									</cfif>
									'#product_name#',
									<cfif isdefined('attributes.order_row_detail_#currentrow#') and len(evaluate("attributes.order_row_detail_#currentrow#"))>
										'#wrk_eval("attributes.order_row_detail_#currentrow#")#',
									<cfelse>
										<cfif isdefined("attributes.serial_no_#currentrow#")>
											'#wrk_eval("attributes.serial_no_#currentrow#")#',
										<cfelse>
											NULL,
										</cfif>
									</cfif>
									<cfif isdefined('attributes.basket_info_type_id_#currentrow#') and len(evaluate("attributes.basket_info_type_id_#currentrow#"))>
										#evaluate("attributes.basket_info_type_id_#currentrow#")#,
									<cfelse>
										NULL,
									</cfif>
									<cfif isdefined("attributes.deliver_date") and isdate(evaluate('attributes.deliver_date'))>#attributes.deliver_date#<cfelse>NULL</cfif>,
									<cfif isdefined("attributes.deliver_dept#currentrow#") and len(trim(evaluate("attributes.deliver_dept#currentrow#"))) and len(listfirst(evaluate("attributes.deliver_dept#currentrow#"),"-"))>
										#listfirst(evaluate("attributes.deliver_dept#currentrow#"),"-")#,
									<cfelse>
										NULL,
									</cfif>
									<cfif isdefined("attributes.deliver_dept#currentrow#") and listlen(trim(evaluate("attributes.deliver_dept#currentrow#")),"-") eq 2 and len(listlast(evaluate("attributes.deliver_dept#currentrow#"),"-"))>
										#listlast(evaluate("attributes.deliver_dept#currentrow#"),"-")#,
									<cfelse>
										NULL,
									</cfif>
									<cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                                    <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                                    <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                                    <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                                    <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                    <cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>'#price_standard_money#',<cfelse>'#price_money#',</cfif>
                                    #other_money_value#,
                                    <cfif len(get_rows.spec_var_id) and len(get_rows.spec_var_name)>
                                        #get_rows.spec_var_id#,
                                        '#get_rows.spec_var_name#',
                                    <cfelseif isdefined('row_spect_id#currentrow#') and len(evaluate('row_spect_id#currentrow#'))>
                                        #evaluate('row_spect_id#currentrow#')#,
                                        '#product_name#',
                                    </cfif>
                                    <cfif isDefined("attributes.is_price_standart") and isDefined("attributes.consumer_info")>#price_standard#,<cfelseif len(price_old)>#price_old#,<cfelse>#price#,</cfif>
                                    <cfif len(evaluate('net_maliyet#currentrow#'))>#evaluate('net_maliyet#currentrow#')#<cfelse>0</cfif>,
                                    <cfif len(evaluate('extra_cost#currentrow#'))>#evaluate('extra_cost#currentrow#')#<cfelse>0</cfif>,
                                    <cfif isdefined('attributes.marj#currentrow#') and len(evaluate('attributes.marj#currentrow#'))>#evaluate('attributes.marj#currentrow#')#<cfelse>0</cfif>,
                                    #row_nettotal#,
                                    <cfif len(prom_discount)>#prom_discount#,<cfelse>NULL,</cfif>
                                    <cfif len(prom_cost)>#prom_cost#,<cfelse>0,</cfif>
                                    <cfif len(prom_amount_discount)>#prom_amount_discount#,<cfelse>0,</cfif>
                                    <cfif len(prom_id)>#prom_id#,<cfelse>null,</cfif>
                                    <cfif len(is_prom_asil_hediye)>#is_prom_asil_hediye#,<cfelse>NULL,</cfif>				
                                    <cfif len(is_commission) and is_commission eq 1>1,<cfelse>0,</cfif>
                                    '#get_production.manufact_code#',
                                    -1,
                                    0,
                                    0,
                                    <cfif len(is_product_promotion_noneffect)>#is_product_promotion_noneffect#<cfelse>NULL</cfif>,
                                    <cfif len(is_general_prom)>#is_general_prom#<cfelse>NULL</cfif>,
                                    <cfif len(is_prom_asil_hediye) and is_prom_asil_hediye and len(prom_main_stock_id)>#prom_main_stock_id#<cfelse>NULL</cfif>,
                                    <cfif isdefined('attributes.prj_discount_price_cat') and len(attributes.prj_discount_price_cat)>#attributes.prj_discount_price_cat#<cfelse>NULL</cfif>,
                                    <cfif len(lot_no)>'#lot_no#'<cfelse>NULL</cfif>
									<cfif isdefined("get_rows.version_no")>,'#get_rows.version_no#'</cfif>
                                )
						</cfquery>
						<cfset get_max_row.max_id = get_max_row.identitycol>
						<cfif len(demand_id)>
							<cfquery name="UPD_DEMAND" datasource="#DSN3#">
								UPDATE ORDER_DEMANDS SET GIVEN_AMOUNT = GIVEN_AMOUNT + #quantity# WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#demand_id#">
							</cfquery>
							<cfquery name="ADD_DEMAND_ROW" datasource="#DSN3#">
								INSERT INTO
									ORDER_DEMANDS_ROW
									(
										DEMAND_ID,
										ORDER_ID,
										ORDER_ROW_ID,
										QUANTITY
									)
								VALUES
									(
										#demand_id#,
										#get_max_order.max_id#,
										#get_max_row.max_id#,
										#quantity#
									)
							</cfquery>
						</cfif>
						<cfif get_production.is_gift_card eq 1><!--- hediye kartı ise hediye kartı kaydı atılıyor --->
							<cfloop from="1" to="#quantity#" index="kk">
								<cfset letters = "1,2,3,4,5,6,7,8,9,0">
								<cfset gift_card_no_last = ''>
								<cfif isdefined('session.pp.userid')>
									<cfset gift_card_no = '#dateformat(now(),'YYYY')-622##dateformat(now(),'MMDD')##timeformat(now(),'HH')##GET_MAX_ROW.MAX_ID#'>
								<cfelseif isdefined('session.ww.userid')>
									<cfset gift_card_no = '#dateformat(now(),'YYYY')-622##dateformat(now(),'MMDD')##timeformat(now(),'HH')##GET_MAX_ROW.MAX_ID#'>
								</cfif>
								<cfset gift_card_no = left(gift_card_no,11)>
								<cfset remain_len = 16-len(gift_card_no)>
								<cfloop from="1" to="#remain_len#" index="ind">				     
									 <cfset random = RandRange(1, 10)>
									 <cfset gift_card_no_last = "#gift_card_no_last##ListGetAt(letters,random,',')#">
								</cfloop>
								<cfset gift_card_no = "#gift_card_no##gift_card_no_last#">
								<cfquery name="ADD_MONEY_CREDIT" datasource="#DSN3#">
									INSERT INTO
										ORDER_MONEY_CREDITS
										(
											ORDER_ID,
											CREDIT_RATE,
											MONEY_CREDIT,
											VALID_DATE,
											MONEY_CREDIT_STATUS,
											USE_CREDIT,
											IS_TYPE,
											GIFT_CARD_NO,
                                            RECORD_IP,
                                            RECORD_DATE
											<cfif isdefined('session.pp.userid')>
												,COMPANY_ID
											<cfelseif isdefined('session.ww.userid')>
                                            	,RECORD_CONS
												,CONSUMER_ID
											</cfif>
										)
										VALUES
										(
											#get_max_order.max_id#,
											0,
											#row_lasttotal/quantity#,
											#dateadd('d',get_production.gift_valid_day,new_date)#,
											0,
											0,
											1,
											'#left(gift_card_no,16)#',
                                            '#cgi.remote_addr#',
                                            #now()#
											<cfif isdefined('session.pp.userid')>
												,#attributes.company_id#
											<cfelseif isdefined('session.ww.userid')>
                                            	,#session.ww.userid#
												,#attributes.consumer_id#
											</cfif>
										)
								</cfquery>								
							</cfloop>
						</cfif>
					</cfif>
				</cfif> <!--- secili satir kontrolu --->
			</cfoutput>
			<!--- kazanılan parapuanlar kaydediliyor --->
			<cfif isdefined("attributes.order_money_credit_count") and attributes.order_money_credit_count gt 0>
				 <cfloop from="1" to="#order_money_credit_count#" index="crdt_indx">
					<cfset credit_value = evaluate("attributes.order_total_money_credit_#crdt_indx#")>
					<cfset credit_rate = evaluate("attributes.credit_rate_#crdt_indx#")>
					<cfset valid_date = evaluate("attributes.credit_valid_date_#crdt_indx#")>
					<cfif len(valid_date)><cf_date tarih="valid_date"></cfif>
					<cfif len(credit_value) and credit_value gt 0>
					<cfquery name="ADD_MONEY_CREDIT" datasource="#DSN3#">
						INSERT INTO
							ORDER_MONEY_CREDITS
							(
								ORDER_ID,
								CREDIT_RATE,
								MONEY_CREDIT,
								VALID_DATE,
								MONEY_CREDIT_STATUS,
								USE_CREDIT,
								IS_TYPE,
                                RECORD_IP,
                                RECORD_DATE
								<cfif isdefined('session.pp.userid')>
									,COMPANY_ID
								<cfelseif isdefined('session.ww.userid')>
                                    ,RECORD_CONS
									,CONSUMER_ID
								</cfif>
							)
							VALUES
							(
								#get_max_order.max_id#,
								#credit_rate#,
								#credit_value#,
								<cfif len(valid_date)>#valid_date#<cfelse>NULL</cfif>,
								0,
								0,
								0,
                                '#cgi.remote_addr#',
                                #now()#
								<cfif isdefined('session.pp.userid')>
									,#attributes.company_id#
								<cfelseif isdefined('session.ww.userid')>
                                    ,#session.ww.userid#
									,#attributes.consumer_id#
								</cfif>
							)
					</cfquery>
					</cfif>
				</cfloop>
			</cfif>
			<cfquery name="GET_INV_ACC" datasource="#DSN3#">
				SELECT * FROM SETUP_INVOICE
			</cfquery>
            
			<!--- Kullanılan hediye çeki kapatılıyor --->
			<cfif isdefined('attributes.gift_money_credit_id') and len(attributes.gift_money_credit_id) and len(attributes.gift_card_value)>
				<cfset used_money_credit_ = filterNum(attributes.gift_card_value)>
				<cfquery name="UPD_CREDIT" datasource="#DSN3#">
					UPDATE
						ORDER_MONEY_CREDITS
					SET
						USE_CREDIT = MONEY_CREDIT,
                        UPDATE_IP = '#cgi.remote_addr#',
                        UPDATE_DATE =  #now()#,
                        UPDATE_CONS = #session.ww.userid#
					WHERE
						ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_money_credit_id#">
				</cfquery>
				<cfquery name="GET_MONEY_CREDIT" datasource="#DSN3#">
					SELECT USE_CREDIT FROM ORDER_MONEY_CREDITS WHERE ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.gift_money_credit_id#">
				</cfquery>
				<cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN3#">
					INSERT INTO
						ORDER_MONEY_CREDIT_USED
						(
							ORDER_CREDIT_ID,
							ORDER_ID,
							USED_VALUE,
							USED_DATE
						)
						VALUES
						(
							#attributes.gift_money_credit_id#,
							#get_max_order.max_id#,
							#get_money_credit.use_credit#,
							#now()#
						)
				</cfquery>
				<cfset net_total_ = net_total_ - used_money_credit_>
				<cf_papers paper_type="debit_claim">
				<cfquery name="GET_MONEY_INFO" datasource="#DSN3#">
					SELECT 
						MONEY,
						RATE1,
						<cfif isDefined("session.pp")>
                            RATEPP2 RATE2
                        <cfelseif isDefined("session.ww")>
                            RATEWW2 RATE2
                        <cfelse>
                            RATE2
                        </cfif>
					FROM
						#dsn2_alias#.SETUP_MONEY
				</cfquery>
				<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN3#">
					SELECT 
						PROCESS_CAT_ID,
						IS_CARI,
						IS_ACCOUNT,
						PROCESS_CAT,
						ACTION_FILE_NAME,
						ACTION_FILE_FROM_TEMPLATE 
					FROM 
						SETUP_PROCESS_CAT 
					WHERE 
						PROCESS_TYPE = 42
						<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND IS_PARTNER = 1<cfelse>AND IS_PUBLIC = 1</cfif>
				</cfquery>
				<cfif get_process_cat_claim_note.recordcount>
					<cfscript>
						process_type = 42;
						form.process_cat = get_process_cat_claim_note.process_cat_id;
						is_cari = get_process_cat_claim_note.is_cari;
						is_account = get_process_cat_claim_note.is_account;
						get_process_type.action_file_name = get_process_cat_claim_note.action_file_name;
						get_process_type.action_file_from_template = get_process_cat_claim_note.action_file_from_template;
						action_currency_id = session_base.money;
						attributes.action_value = used_money_credit_;
						attributes.money_type = session_base.money;
						form.money_type = session_base.money;
						process_money_type = session_base.money;
						attributes.project_name = '';
						attributes.project_id = '';
						attributes.other_cash_act_value = used_money_credit_;
						attributes.company_id = attributes.company_id;
						attributes.consumer_id = attributes.consumer_id;
						attributes.employee_id = '';
						attributes.action_detail = '#temp_order_number# Hediye Çeki Karşılığı';
						attributes.action_account_code = '#get_inv_acc.GIFT_CARD#';
						attributes.action_date = new_date;
						attributes.paper_number = '#paper_code & '-' & paper_number#';
						attributes.system_amount = used_money_credit_;
						attributes.expense_center_1 = '';
						attributes.expense_center_2 = '';
						attributes.expense_center_id_1 = '';
						attributes.expense_item_id_1 = '';
						attributes.expense_item_name_1 = '';
						new_dsn_2 = dsn3;
					</cfscript>
					<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
				</cfif>
			</cfif>

			<!--- İndirim Kuponu kapatılıyor --->
			<cfif isdefined('attributes.disc_coup_money_credit_id1') and len(attributes.disc_coup_money_credit_id1) and len(attributes.disc_coup_value)>
            	<cfloop from="1" to="#attributes.record_num#" index="i">
					<cfset used_money_credit_ = filterNum(attributes.disc_coup_value)>
                    <cfquery name="UPD_DISCOUNT_COUP" datasource="#DSN3#">
                        UPDATE
                            ORDER_MONEY_CREDITS
                        SET
                            USE_CREDIT = MONEY_CREDIT     
                        WHERE
                            ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.disc_coup_money_credit_id#i#')#">
                    </cfquery>
                    <cfquery name="GET_MONEY_CREDIT" datasource="#DSN3#">
                        SELECT USE_CREDIT FROM ORDER_MONEY_CREDITS WHERE ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.disc_coup_money_credit_id#i#')#">
                    </cfquery>
                    <cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN3#">
                        INSERT INTO
                            ORDER_MONEY_CREDIT_USED
                            (
                                ORDER_CREDIT_ID,
                                ORDER_ID,
                                USED_VALUE,
                                USED_DATE
                            )
                            VALUES
                            (
                                #evaluate('attributes.disc_coup_money_credit_id#i#')#,
                                #get_max_order.max_id#,
                                #get_money_credit.use_credit#,
                                #now()#
                            )
                    </cfquery>
                    <cfset net_total_ = net_total_ - used_money_credit_>
                    <cf_papers paper_type="debit_claim">
                    <cfquery name="GET_MONEY_INFO" datasource="#DSN3#">
                        SELECT 
                            MONEY,
                            RATE1,
                            <cfif isDefined("session.pp")>
                                RATEPP2 RATE2
                            <cfelseif isDefined("session.ww")>
                                RATEWW2 RATE2
                            <cfelse>
                                RATE2
                            </cfif>
                        FROM
                            #dsn2_alias#.SETUP_MONEY
                    </cfquery>
                    <cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN3#">
                        SELECT 
                            PROCESS_CAT_ID,
                            IS_CARI,
                            IS_ACCOUNT,
                            PROCESS_CAT,
                            ACTION_FILE_NAME,
                            ACTION_FILE_FROM_TEMPLATE 
                        FROM 
                            SETUP_PROCESS_CAT 
                        WHERE 
                            PROCESS_TYPE = 42
                            <cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND IS_PARTNER = 1<cfelse>AND IS_PUBLIC = 1</cfif>
                    </cfquery>
                    <cfif get_process_cat_claim_note.recordcount>
                        <cfscript>
                            process_type = 42;
                            form.process_cat = get_process_cat_claim_note.process_cat_id;
                            is_cari = get_process_cat_claim_note.is_cari;
                            is_account = get_process_cat_claim_note.is_account;
                            get_process_type.action_file_name = get_process_cat_claim_note.action_file_name;
                            get_process_type.action_file_from_template = get_process_cat_claim_note.action_file_from_template;
                            action_currency_id = session_base.money;
                            attributes.action_value = used_money_credit_;
                            attributes.money_type = session_base.money;
                            form.money_type = session_base.money;
                            process_money_type = session_base.money;
                            attributes.project_name = '';
                            attributes.project_id = '';
                            attributes.other_cash_act_value = used_money_credit_;
                            attributes.company_id = attributes.company_id;
                            attributes.consumer_id = attributes.consumer_id;
                            attributes.employee_id = '';
                            attributes.action_detail = '#temp_order_number# Hediye Çeki Karşılığı';
                            attributes.action_account_code = '#get_inv_acc.GIFT_CARD#';
                            attributes.action_date = new_date;
                            attributes.paper_number = '#temp_order_number#';
                            attributes.system_amount = used_money_credit_;
                            attributes.expense_center_1 = '';
                            attributes.expense_center_2 = '';
                            attributes.expense_center_id_1 = '';
                            attributes.expense_item_id_1 = '';
                            attributes.expense_item_name_1 = '';
                            new_dsn_2 = dsn3;
                        </cfscript>
                        <cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
                    </cfif>
                </cfloop>
			</cfif>
			<!--- İndirim Kuponu kapatılıyor --->
			
			<!--- kazanılan parapuanların kullanılması --->
			<cfif isdefined('attributes.money_credit_id') and attributes.money_credit_id eq 1 and len(attributes.money_credit_value)>
				<cfset used_money_credit_ = Replace(attributes.money_credit_value,',','.')>
				<cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
					SELECT
						ORDER_CREDIT_ID,
						MONEY_CREDIT,
						VALID_DATE
					FROM
						ORDER_MONEY_CREDITS
					WHERE
						MONEY_CREDIT_STATUS = 1 AND
						MONEY_CREDIT <> 0 AND
						ISNULL(IS_TYPE,0) = 0 AND
						VALID_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
						<cfif isdefined('session.pp.userid')>
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
						<cfelse>
							CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
						</cfif>
					ORDER BY
						VALID_DATE
				</cfquery>
				<cfset used_total_ = 0>
				<cfloop query="get_money_credits">
					<cfif used_money_credit_ lte net_total_><cfset row_use_total = get_money_credits.money_credit><cfelse><cfset row_use_total = net_total_></cfif>
					<cfif row_use_total gt 0>
						<cfset used_money_credit_ = used_money_credit_ - row_use_total>
						<cfset used_total_ = used_total_ + row_use_total>
						<cfquery name="ADD_MONEY_CREDIT_USED" datasource="#DSN3#">
							INSERT INTO
								ORDER_MONEY_CREDIT_USED
								(
									ORDER_CREDIT_ID,
									ORDER_ID,
									USED_VALUE,
									USED_DATE
								)
								VALUES
								(
									#get_money_credits.order_credit_id#,
									#get_max_order.max_id#,
									#row_use_total#,
									#now()#
								)
						</cfquery>
						<cfquery name="UPD_MONEY_CREDIT" datasource="#DSN3#">
							UPDATE 
								ORDER_MONEY_CREDITS 
							SET
								USE_CREDIT = USE_CREDIT + #row_use_total#,
                        		UPDATE_IP = '#cgi.remote_addr#',
                        		UPDATE_DATE =  #now()#,
                        		UPDATE_CONS = #session.ww.userid#
								<cfif row_use_total eq get_money_credits.money_credit>
									,MONEY_CREDIT_STATUS = 0 
								</cfif>
							WHERE 
								ORDER_CREDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_money_credits.order_credit_id#">
						</cfquery>
					</cfif>
				</cfloop>
				<cfif used_total_ gt 0>
					<cf_papers paper_type="debit_claim">
					<cfquery name="GET_MONEY_INFO" datasource="#DSN3#">
						SELECT 
							MONEY,
							RATE1,
							<cfif isDefined("session.pp")>
                                RATEPP2 RATE2
                            <cfelseif isDefined("session.ww")>
                                RATEWW2 RATE2
                            <cfelse>
                                RATE2
                            </cfif>
						FROM
							#dsn2_alias#.SETUP_MONEY
					</cfquery>
					<cfquery name="GET_PROCESS_CAT_CLAIM_NOTE" datasource="#DSN3#">
						SELECT 
							PROCESS_CAT_ID,
							IS_CARI,
							IS_ACCOUNT,
							PROCESS_CAT,
							ACTION_FILE_NAME,
							ACTION_FILE_FROM_TEMPLATE 
						FROM 
							SETUP_PROCESS_CAT 
						WHERE 
							PROCESS_TYPE = 42
							<cfif isdefined("attributes.company_id") and len(attributes.company_id)>AND IS_PARTNER = 1<cfelse>AND IS_PUBLIC = 1</cfif>
					</cfquery>
					<cfif get_process_cat_claim_note.recordcount>
						<cfscript>
							process_type = 42;
							form.process_cat = get_process_cat_claim_note.process_cat_id;
							is_cari = get_process_cat_claim_note.is_cari;
							is_account = get_process_cat_claim_note.is_account;
							get_process_type.action_file_name = get_process_cat_claim_note.action_file_name;
							get_process_type.action_file_from_template = get_process_cat_claim_note.action_file_from_template;
							action_currency_id = session_base.money;
							attributes.action_value = used_total_;
							attributes.money_type = session_base.money;
							form.money_type = session_base.money;
							process_money_type = session_base.money;
							attributes.project_name = '';
							attributes.project_id = '';
							attributes.other_cash_act_value = used_total_;
							attributes.company_id = attributes.company_id;
							attributes.consumer_id = attributes.consumer_id;
							attributes.employee_id = '';
							attributes.action_detail = '#temp_order_number# Para Puan Karşılığı';
							attributes.action_account_code = '#get_inv_acc.money_credit#';
							attributes.action_date = new_date;
							attributes.paper_number = '#temp_order_number#';
							attributes.system_amount = used_total_;
							attributes.expense_center_1 = '';
							attributes.expense_center_2 = '';
							attributes.expense_center_id_1 = '';
							attributes.expense_item_id_1 = '';
							attributes.expense_item_name_1 = '';
							new_dsn_2 = dsn3;
						</cfscript>
						<cfinclude template="../../ch/query/add_debit_claim_note_ic.cfm">
					</cfif>
				</cfif>
			</cfif>
			
			<!--- Bekleyen siparişler için sipariş talebi kaydediliyor --->
			<cfquery name="GET_ROWS_OPEN" dbtype="query">
				SELECT * FROM GET_ROWS WHERE STOCK_ACTION_TYPE IS NOT NULL AND STOCK_ACTION_TYPE IN (2,3) AND IS_CHECKED = 1 <!--- secili satir kontrolu --->
			</cfquery>
			<cfoutput query="get_rows_open">
				<cfquery name="ADD_DEMAND" datasource="#DSN3#">
					INSERT INTO
						ORDER_DEMANDS
							(
								DEMAND_STATUS,
								STOCK_ID,
								DEMAND_TYPE,
								PRICE,
								PRICE_KDV,
								PRICE_MONEY,
								DEMAND_AMOUNT,
								GIVEN_AMOUNT,
								DEMAND_UNIT_ID,
								<!---DOMAIN_NAME,--->
                                MENU_ID,
								STOCK_ACTION_TYPE,
								ORDER_ID,
								PROMOTION_ID,
								RECORD_CON,
								RECORD_PAR,
								RECORD_DATE,
								RECORD_IP				
							)
						VALUES
							(
								1,
								#stock_id#,
								3,
								#price#,
								#price_kdv#,
								'#session_base.money#',
								#quantity*prom_stock_amount#,
								0,
								#product_unit_id#,
								<!---'#cgi.http_host#',--->
                                <cfif isDefined('session.ep.menu_id')>
                                	#session.ep.menu_id#,
                                <cfelseif isDefined('session.pp.menu_id')>
                                	#session.pp.menu_id#,
                                <cfelseif isDefined('session.ww.menu_id')>
                                	#session.ww.menu_id#,
                                </cfif>
								#stock_action_type#,
								#get_max_order.max_id#,
								<cfif len(prom_id)>#prom_id#<cfelse>NULL</cfif>,
								<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#,<cfelse>NULL,</cfif>
								<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
								#now()#,
								'#cgi.remote_addr#'
							)
				</cfquery>
			</cfoutput>
			<cfquery name="UPD_PRE_ROWS" datasource="#DSN3#">
				UPDATE 
					ORDER_PRE_ROWS 
				SET
					ORDER_ID = #GET_MAX_ORDER.MAX_ID# 
				WHERE 
					<cfif isdefined("session.pp.userid")>
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
					<cfelseif isdefined("session.ww.userid")>
						RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
					<cfelseif isdefined("session.ep.userid")>
						RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					</cfif>
					PRODUCT_ID IS NOT NULL
					AND IS_CHECKED = 1 <!--- secili satir kontrolu --->
			</cfquery>
			<cfscript>
				attributes.basket_money = other_money;
				basket_kur_ekle(action_id:get_max_order.max_id,table_type_id:3,process_type:0);
				include('add_order_row_reserved_stock.cfm','\objects\functions'); //rezerve edilen satırlar icin ORDER_ROW_RESERVED'a kayıt atıyor.
				add_reserve_row(
					reserve_order_id:get_max_order.max_id,
					reserve_action_type:0,
					is_order_process:0,
					order_from_partner:1,
					is_purchase_sales:1
					);
			</cfscript>
			<cfif fusebox.use_stock_speed_reserve> 
                <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
                    <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
                </cfstoredproc>
            </cfif>
			<!--- sepet boşaltılıyor --->
			<cfquery name="DEL_ROWS" datasource="#DSN3#">
				DELETE FROM
					ORDER_PRE_ROWS
				WHERE
					<cfif isdefined("session.pp.userid")>
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
					<cfelseif isdefined("session.ww.userid")>
						RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
					<cfelseif isdefined("session.ep.userid")>
						RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					</cfif>
					PRODUCT_ID IS NOT NULL AND 
					IS_CHECKED = 1 <!--- secili satir kontrolu --->
					<cfif isdefined('attributes.x_is_order_type_') and attributes.x_is_order_type_ eq 0>
						AND IS_PART = 0
					<cfelseif isdefined('attributes.x_is_order_type_') and attributes.x_is_order_type_ eq 1>
						AND IS_PART = 1
					</cfif>
			</cfquery>
			<cfquery name="UPD_UNCHECKED_ROWS_" datasource="#DSN3#">
				UPDATE
					ORDER_PRE_ROWS
				SET
					DISCOUNT1=0,
					DISCOUNT2=0,
					DISCOUNT3=0,
					DISCOUNT4=0,
					DISCOUNT5=0,
					PRICE_OLD=NULL,
					PRICE_KDV_OLD=NULL,
					PRICE=PRE_PRICE,
					PRICE_KDV=PRE_PRICE_KDV,
					PRICE_MONEY=PRE_PRICE_MONEY,
					PRE_PRICE=NULL,
					PRE_PRICE_KDV=NULL,
					PRE_PRICE_MONEY=NULL
				WHERE
					<cfif isdefined("session.pp.userid")>
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
					<cfelseif isdefined("session.ww.userid")>
						RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
					<cfelseif isdefined("session.ep.userid")>
						RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					</cfif>
					PRODUCT_ID IS NOT NULL AND 
					PRE_PRICE IS NOT NULL AND 
					PRE_PRICE_MONEY IS NOT NULL AND 
					ISNULL(IS_COMMISSION,0)=0 AND 
					ISNULL(IS_CARGO,0)=0 AND 
					ISNULL(IS_PROM_ASIL_HEDIYE,0)=0
			</cfquery>
			<cfif isDefined("get_rows.order_row_id") and len(get_rows.order_row_id)>
				<cfquery name="DEL_ROWS" datasource="#DSN3#">
					DELETE FROM
						ORDER_PRE_ROWS_SPECS
					WHERE
						MAIN_ORDER_ROW_ID IN (#valuelist(get_rows.order_row_id)#)
				</cfquery>
			</cfif>
			<cfif isDefined("session.pp")>
				<cfquery name="DEL_ROWS" datasource="#DSN3#">
					DELETE FROM
						ORDER_PRE_ROWS_SPECIAL
					WHERE
						RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
				</cfquery>
			</cfif>
			<!--- partnerin veya consumerin temsilcisine mail atıyor --->
			<cfif not isDefined("session.ep")><!--- mail atma işi zaten yanlışlar var gözüküyor, şimdilik ep den kapatıldı --->
            	<cfif isDefined('attributes.is_order_mail') and attributes.is_order_mail eq 1>
					<cfif (member_type is "partner") and len (get_manager_partner.company_partner_email) and len (get_our_company_mail.email)>
                        <cfquery name="GET_MAIL_ORDERS" datasource="#DSN3#">
                            SELECT ORDER_NUMBER,RECORD_DATE,RECORD_PAR FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
                        </cfquery>
                            <cfmail to="#get_manager_partner.company_partner_email#" from="#get_our_company_mail.email#"
                                subject="Sipariş" type="HTML">
                                <cfoutput>
                                    <font color="FF0000">#dateformat(date_add("h",session.pp.time_zone,get_mail_orders.record_date),"dd/mm/yyyy")#&nbsp;#TIMEFORMAT(date_add("h",session.pp.time_zone,get_mail_orders.record_date),"HH:mm")#</font>
                                    &nbsp;tarihinde <font color="FF0000">#get_par_info(get_mail_orders.RECORD_PAR,0,0,0)#</font> kullanıcısı tarafından 
                                    <a href ='#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.order_detail&order_id=#GET_MAX_ORDER.MAX_ID#'><font color="FF0000">#get_mail_orders.ORDER_NUMBER#</font></a> 
                                    nolu sipariş sisteme eklenmiştir.<br /><br />
                                    İyi Çalışmalar.
                                </cfoutput>
                            </cfmail>	
                    </cfif>
                    <cfif (member_type is "partner") and len(get_sales_manager.employee_email) and len(get_our_company_mail.email)>
                        <cfquery name="GET_MAIL_ORDERS" datasource="#DSN3#">
                            SELECT ORDER_NUMBER,RECORD_DATE,RECORD_PAR FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
                        </cfquery>
                        <cfmail to="#get_sales_manager.employee_email#" from="#get_our_company_mail.email#"
                            subject="Sipariş" type="HTML">
                            <cfoutput>
                                <font color="FF0000">#dateformat(date_add("h",session.pp.time_zone,get_mail_orders.record_date),"dd/mm/yyyy")#&nbsp;#TimeFormat(date_add("h",session.pp.time_zone,get_mail_orders.record_date),"HH:mm")#</font>
                                &nbsp;tarihinde <font color="FF0000">#get_par_info(get_mail_orders.record_par,0,0,0)#</font> kullanıcısı tarafından 
                                <a href ='#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.order_detail&order_id=#get_max_order.max_id#'><font color="FF0000">#get_mail_orders.order_number#</font></a> 
                                nolu sipariş sisteme eklenmiştir.<br /><br />
                                İyi Çalışmalar.
                            </cfoutput>
                        </cfmail>
                    <cfelseif (member_type is "consumer") and len(get_sales_manager.employee_email) and len(get_our_company_mail.email)>
                        <cfquery name="GET_MAIL_ORDERS" datasource="#DSN3#">
                            SELECT ORDER_NUMBER,RECORD_DATE,RECORD_PAR FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
                        </cfquery>
                        <cfmail to="#get_sales_manager.employee_email#" from="#get_our_company_mail.email#"
                            subject="Sipariş" type="HTML">
                            <cfoutput>
                                <font color="FF0000">#DateFormat(date_add("h",session.ww.time_zone,get_mail_orders.record_date),"dd/mm/yyyy")#&nbsp;#TimeFormat(date_add("h",session.ww.time_zone,get_mail_orders.record_date),"HH:mm")#</font>
                                &nbsp;tarihinde <font color="FF0000">#get_par_info(get_mail_orders.record_par,0,0,0)#</font> kullanıcısı tarafından 
                                <a href ='#cgi.HTTP_HOST#/#request.self#?fuseaction=objects2.order_detail&order_id=#get_max_order.max_id#'><font color="FF0000">#get_mail_orders.order_number#</font></a> 
                                nolu sipariş sisteme eklenmiştir.<br /><br />
                                İyi Çalışmalar.
                            </cfoutput>
                        </cfmail>
                    </cfif>
                </cfif>
			</cfif>
			<cfif isdefined("session.pp.userid") and isdefined("attributes.is_save_adresss")>
				<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
					<cfquery name="ADD_COMPANY_CONTACT" datasource="#DSN3#">
						INSERT INTO
							#dsn_alias#.COMPANY_BRANCH
						(
							COMPANY_ID,
							COMPBRANCH_STATUS,
							COMPBRANCH__NAME,
							COMPBRANCH_ADDRESS,
							COMPBRANCH_POSTCODE,
							COUNTY_ID,
							CITY_ID,
							COUNTRY_ID,
							SEMT,		
							RECORD_DATE,	
							RECORD_PAR,
							RECORD_IP
						)
							VALUES
						(
							<cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>#session.pp.company_id#</cfif>,
							1,
							<cfif isDefined("attributes.ship_contact_name0") and len(attributes.ship_contact_name0)>'#attributes.ship_contact_name0#'<cfelse>NULL</cfif>,
							<cfif isDefined("attributes.ship_address0") and len(attributes.ship_address0)>'#attributes.ship_address0#'<cfelse>NULL</cfif>,
							<cfif len('attributes.ship_address_postcode0')>'#attributes.ship_address_postcode0#'<cfelse>NULL</cfif>,
							<cfif len(county_id1)>#county_id1#<cfelse>NULL</cfif>,
							<cfif len(city_id1)>#city_id1#<cfelse>NULL</cfif>,
							<cfif len(attributes.ship_address_country0)>#attributes.ship_address_country0#<cfelse>NULL</cfif>,
							<cfif len(attributes.ship_address_semt0)>'#attributes.ship_address_semt0#'<cfelse>NULL</cfif>,
							#now()#,
							#session.pp.userid#,
							'#cgi.remote_addr#'
						)
					</cfquery>
					<cfquery name="GET_MAX_CONT_ADDR" datasource="#DSN3#">
						SELECT
							MAX(COMPBRANCH_ID) AS CONTACT_ID
						FROM
							#dsn_alias#.COMPANY_BRANCH
					</cfquery>
					<cfquery name="UPD_ORDER" datasource="#DSN3#">
						UPDATE
							#dsn3_alias#.ORDERS
						SET
							SHIP_ADDRESS_ID = #get_max_cont_addr.contact_id#
						WHERE
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
					</cfquery>
				</cfif>
				<cfif isdefined("attributes.tax_address_row") and attributes.tax_address_row eq 0>
					<cfquery name="ADD_COMPANY_CONTACT" datasource="#DSN3#">
						INSERT INTO
							#dsn_alias#.COMPANY_BRANCH
                            (
                                COMPANY_ID,
                                COMPBRANCH_STATUS,
                                COMPBRANCH__NAME,
                                COMPBRANCH_ADDRESS,
                                COMPBRANCH_POSTCODE,
                                COUNTY_ID,
                                CITY_ID,
                                COUNTRY_ID,
                                SEMT,		
                                RECORD_DATE,	
                                RECORD_PAR,
                                RECORD_IP
                            )
                                VALUES
                            (
                                <cfif isDefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>#session.pp.company_id#</cfif>,
                                1,
                                <cfif isDefined("attributes.tax_contact_name0") and len(attributes.tax_contact_name0)>'#attributes.tax_contact_name0#'<cfelse>NULL</cfif>,
                                <cfif isDefined("attributes.tax_address0") and len(attributes.tax_address0)>'#attributes.tax_address0#'<cfelse>NULL</cfif>,
                                <cfif len('attributes.tax_address_postcode0')>'#attributes.tax_address_postcode0#'<cfelse>NULL</cfif>,
                                <cfif isDefined('county_id2') and len(county_id2)>#county_id2#<cfelse>NULL</cfif>,
                                <cfif isDefined('city_id2') and len(city_id2)>#city_id2#<cfelse>NULL</cfif>,
                                <cfif len(attributes.tax_address_country0)>#attributes.tax_address_country0#<cfelse>NULL</cfif>,
                                <cfif len(attributes.tax_address_semt0)>'#attributes.tax_address_semt0#'<cfelse>NULL</cfif>,
                                #now()#,
                                #session.pp.userid#,
                                '#cgi.remote_addr#'
                            )
					</cfquery>
				    <cfquery name="GET_MAX_CONTACT" datasource="#DSN3#">
						SELECT
							MAX(COMPBRANCH_ID) AS CONTACT_ID
						FROM
							#dsn_alias#.COMPANY_BRANCH
					</cfquery>
					<cfquery name="UPD_ORDER" datasource="#DSN3#">
						UPDATE
							#dsn3_alias#.ORDERS
						SET
							TAX_ADDRESS_ID = #get_max_contact.contact_id#
						WHERE
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("session.ww.userid") and isdefined("attributes.is_save_adresss")>
				<cfif isdefined("attributes.ship_address_row") and attributes.ship_address_row eq 0>
					<cfif not (isdefined('attributes.is_same_tax_ship') and len(attributes.is_same_tax_ship))>
                        <cfquery name="ADD_CONSUMER_CONTACT" datasource="#DSN3#">
                            INSERT INTO
                                #dsn_alias#.CONSUMER_BRANCH
                                (
                                    CONSUMER_ID,
                                    STATUS,
                                    CONTACT_NAME,
                                    CONTACT_ADDRESS,
                                    CONTACT_TELCODE,
                                    CONTACT_TEL1,
                                    CONTACT_DELIVERY_NAME,
                                    CONTACT_POSTCODE,
                                    CONTACT_COUNTY_ID,
                                    CONTACT_CITY_ID,
                                    CONTACT_COUNTRY_ID,
                                    CONTACT_SEMT,		
                                    CONTACT_DISTRICT,
                                    CONTACT_DISTRICT_ID,
                                    CONTACT_MAIN_STREET,
                                    CONTACT_STREET,
                                    CONTACT_DOOR_NO,
                                    RECORD_DATE,	
                                    RECORD_CONS,
                                    RECORD_IP
                                )
                                    VALUES
                                (
                                    <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>#session.ww.userid#</cfif>,
                                    1,
                                    <cfif isDefined("attributes.ship_contact_name0") and len(attributes.ship_contact_name0)>'#attributes.ship_contact_name0#'<cfelse>NULL</cfif>,
                                    <cfif isDefined("attributes.ship_address0") and len(attributes.ship_address0)>'#attributes.ship_address0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_contact_telcode0") and len(attributes.ship_contact_telcode0)>'#attributes.ship_contact_telcode0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_contact_tel0") and len(attributes.ship_contact_tel0)>'#attributes.ship_contact_tel0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_contact_delivery0") and len(attributes.ship_contact_delivery0)>'#attributes.ship_contact_delivery0#'<cfelse>NULL</cfif>,
                                    <cfif len('attributes.ship_address_postcode0')>'#attributes.ship_address_postcode0#'<cfelse>NULL</cfif>,
                                    <!---<cfif len(county_id)>#county_id#<cfelse>NULL</cfif>,
                                    <cfif len(city_id)>#city_id#<cfelse>NULL</cfif>,--->
                                    <cfif len(attributes.ship_address_county0)>#attributes.ship_address_county0#<cfelse>NULL</cfif>,
                                    <cfif len(attributes.ship_address_city0)>'#attributes.ship_address_city0#'<cfelse>NULL</cfif>,
                                    <cfif len(attributes.ship_address_country0)>#attributes.ship_address_country0#<cfelse>NULL</cfif>,
                                    <cfif len(attributes.ship_address_semt0)>'#attributes.ship_address_semt0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_district0") and len(attributes.ship_district0)>'#attributes.ship_district0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_district_id0") and len(attributes.ship_district_id0)>#attributes.ship_district_id0#<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_main_street0") and len(attributes.ship_main_street0)>'#attributes.ship_main_street0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_street0") and len(attributes.ship_street0)>'#attributes.ship_street0#'<cfelse>NULL</cfif>,
                                    <cfif isdefined("attributes.ship_work_doorno0") and len(attributes.ship_work_doorno0)>'#attributes.ship_work_doorno0#'<cfelse>NULL</cfif>,
                                    #now()#,
                                    #session.ww.userid#,
                                    '#cgi.remote_addr#'
                                )
                        </cfquery>
                        <cfquery name="GET_MAX_CONT_ADDR" datasource="#DSN3#">
                            SELECT
                                MAX(CONTACT_ID) AS CONTACT_ID
                            FROM
                                #dsn_alias#.CONSUMER_BRANCH
                        </cfquery>
                        <cfquery name="UPD_ORDER" datasource="#DSN3#">
                            UPDATE
                                #dsn3_alias#.ORDERS
                            SET
                                CITY_ID = <cfif len(attributes.ship_address_city0)>'#attributes.ship_address_city0#'<cfelse>NULL</cfif>,
                                COUNTY_ID = <cfif len(attributes.ship_address_county0)>#attributes.ship_address_county0#<cfelse>NULL</cfif>,
                                COUNTRY_ID = <cfif len(attributes.ship_address_country0)>#attributes.ship_address_country0#<cfelse>NULL</cfif>,
                                SHIP_ADDRESS_ID = #get_max_cont_addr.contact_id#
                            WHERE
                                ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
                        </cfquery>
                    </cfif>
				</cfif>
				<cfif isdefined("attributes.tax_address_row") and attributes.tax_address_row eq 0>
                    <cfquery name="ADD_CONSUMER_CONTACT_" datasource="#DSN3#">
                        INSERT INTO
                            #dsn_alias#.CONSUMER_BRANCH
                            (
                                CONSUMER_ID,
                                STATUS,
                                CONTACT_NAME,
                                CONTACT_ADDRESS,
                                CONTACT_POSTCODE,
                                CONTACT_COUNTY_ID,
                                CONTACT_CITY_ID,
                                CONTACT_COUNTRY_ID,
                                CONTACT_SEMT,		
                                CONTACT_DISTRICT,
                                CONTACT_DISTRICT_ID,
                                CONTACT_MAIN_STREET,
                                CONTACT_STREET,
                                CONTACT_DOOR_NO,
                                IS_COMPANY,
                                COMPANY_NAME,
                                TAX_NO,
                                TAX_OFFICE,
                                RECORD_DATE,	
                                RECORD_CONS,
                                RECORD_IP
                            )
                                VALUES
                            (
                                <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>#session.ww.userid#</cfif>,
                                1,
                                'Diğer Adres',
                                <cfif isDefined("attributes.tax_address0") and len(attributes.tax_address0)>'#attributes.tax_address0#'<cfelse>NULL</cfif>,
                                <cfif len('attributes.tax_address_postcode0')>'#attributes.tax_address_postcode0#'<cfelse>NULL</cfif>,
                                <cfif isDefined("attributes.tax_address_county0") and len(attributes.tax_address_county0)>'#attributes.tax_address_county0#'<cfelse>NULL</cfif>,
                                <cfif isDefined("attributes.tax_address_city0") and len(attributes.tax_address_city0)>'#attributes.tax_address_city0#'<cfelse>NULL</cfif>,
                                <cfif isDefined("attributes.tax_address_country0") and len(attributes.tax_address_country0)>'#attributes.tax_address_country0#'<cfelse>NULL</cfif>,
                                <cfif len(attributes.tax_address_semt0)>'#attributes.tax_address_semt0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_district0") and len(attributes.tax_district0)>'#attributes.tax_district0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_district_id0") and len(attributes.tax_district_id0)>#attributes.tax_district_id0#<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_main_street0") and len(attributes.tax_main_street0)>'#attributes.tax_main_street0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_street0") and len(attributes.tax_street0)>'#attributes.tax_street0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_work_doorno0") and len(attributes.tax_work_doorno0)>'#attributes.tax_work_doorno0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.is_company0") and len(attributes.is_company0)>1<cfelse>0</cfif>,
                                <cfif isdefined("attributes.company_name0") and len(attributes.company_name0)>'#attributes.company_name0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_no0") and len(attributes.tax_no0)>'#attributes.tax_no0#'<cfelse>NULL</cfif>,
                                <cfif isdefined("attributes.tax_office0") and len(attributes.tax_office0)>'#attributes.tax_office0#'<cfelse>NULL</cfif>,
                                #now()#,
                                #session.ww.userid#,
                                '#cgi.remote_addr#'
                            )
                    </cfquery>
				    <cfquery name="GET_MAX_CONTACT" datasource="#DSN3#">
						SELECT
							MAX(CONTACT_ID) AS CONTACT_ID
						FROM
							#dsn_alias#.CONSUMER_BRANCH
					</cfquery>
					<cfquery name="UPD_ORDER" datasource="#DSN3#">
						UPDATE
							#dsn3_alias#.ORDERS
						SET
							TAX_ADDRESS_ID = #get_max_contact.contact_id#
						WHERE
							ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
					</cfquery>
				</cfif>
			</cfif>
			<!--- sipariş bilgileriyle ödeme ler ilişkilendirliyor --->
			<cfif isdefined("attributes.paymethod_type") and attributes.paymethod_type eq 1 and isdefined('attributes.is_add_bank_order') and attributes.is_add_bank_order eq 1><!---havale yöntemi--->
				<cfquery name="UPD_BANK_ORDER" datasource="#DSN3#">
					UPDATE
						#dsn2_alias#.BANK_ORDERS
					SET
						ORDER_ID = #get_max_order.max_id#
					WHERE
						BANK_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#bank_order_id_info#">
				</cfquery>
			<cfelseif isdefined("attributes.paymethod_type") and listfind("2,4",attributes.paymethod_type) and isdefined("cc_paym_id_info")><!---tamamını kredi kartı veya limit aşımında kredi kartı durumu--->
				<cfquery name="UPD_BANK_ORDER" datasource="#DSN3#">
					UPDATE
						CREDIT_CARD_BANK_PAYMENTS
					SET
						ORDER_ID = #get_max_order.max_id#
					WHERE
						CREDITCARD_PAYMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#cc_paym_id_info#">
				</cfquery>
				<cfquery name="PAID_INFO" datasource="#DSN3#">
					UPDATE ORDERS SET IS_PAID = 1 WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_order.max_id#">
				</cfquery>
			</cfif>
			<!---// sipariş bilgileriyle ödeme ler ilişkilendirliyor --->
			<cf_workcube_process is_upd='1' 
                data_source='#dsn3#' 
                old_process_line='0'
                process_stage='#attributes.process_stage#' 
                record_member='#session_base.userid#'
                record_date='#now()#' 
                action_table='ORDERS'
                action_column='ORDER_ID'
                action_id='#get_max_order.max_id#'
                action_page='#request.self#?fuseaction=objects2.order_detail&order_id=#get_max_order.max_id#' 
                warning_description="#getLang('','Sipariş',57611)# : #temp_order_number#">
		</cftransaction><!--- action_page='#request.self#?fuseaction=sales.list_order&event=upd&order_id=#GET_MAX_ORDER.MAX_ID#'  --->
	</cflock>
</cfif> 
<!--- Eğer xml de seçili ise fatura kaydediyor --->
<cfif (isDefined("session.ww") or isdefined("session.ep")) and attributes.invoice_kontrol eq 1 and len(attributes.invoice_process_cat) and len(attributes.invoice_department_id) and len(attributes.invoice_location_id)>
	<cftry> 
		<cfscript>
			add_invoice_from_order(order_id:get_max_order.max_id,process_catid:attributes.invoice_process_cat,department_id:attributes.invoice_department_id,location_id:attributes.invoice_location_id);
		</cfscript>
		<cfcatch> 
			<script type="text/javascript">
				alert("Fatura Kaydınız Yapılamadı.Fakat Siparişiniz Kaydedildi!");
			</script>
		</cfcatch>
	</cftry> 
</cfif>

<!--- Referans üyeye sipariş girilmişse eğer sessiondaki sipariş verilen alanını boşaltıyor --->
<cfif isdefined("session.ww")>
	<cfset session.ww.basket_cons_id = ''>
</cfif>
<script type="text/javascript">
<cfif isdefined('attributes.is_orderww_url_location') and len(attributes.is_orderww_url_location)>
	window.location.href='<cfoutput>#attributes.is_orderww_url_location#</cfoutput>';
<cfelse>
	<cfif isdefined('attributes.is_order_detail') and attributes.is_order_detail eq 1>
		window.location.href='<cfoutput>#request.self#?fuseaction=objects2.order_detail&order_id=#get_max_order.max_id#</cfoutput>';
	<cfelse>
		window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order<cfif not isdefined("session.ep")>&zone=1</cfif>&form_submitted=1<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif></cfoutput>';
	</cfif>
</cfif>
</script>
