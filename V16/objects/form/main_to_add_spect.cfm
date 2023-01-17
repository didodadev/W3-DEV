<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT	RATE1,RATE2,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 AND COMPANY_ID = #SESSION.EP.COMPANY_ID#
</cfquery>
<!--- Burası fatudan yada siparişten spect main spect seçilirken,seçilen main spect'e göre yeni bir spect oluşturulduktan sonra
o spect'i aşağı atarken,o yeni oluşturulan yeni spect bilgilerinin popup_list_spect_js sayfasına gönderilerek,varsa bir fiyat değişikliği
onlarında satırlara yansıması ve satırların en son güncel halini alması için kullanılıyor. --->
<form name="form_gonder_spect" id="form_gonder_spect"  method="post" action="<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_js</cfoutput>">
	<input type="hidden" name="spect_id" id="spect_id" value="">
	<cfif isdefined("attributes.search_process_date")>
		<input type="hidden" name="search_process_date" id="search_process_date" value="<cfoutput>#attributes.search_process_date#</cfoutput>">
	</cfif>
	<input type="hidden" name="price" id="price" value="">
	<input type="hidden" name="x_is_basket_price" id="x_is_basket_price" value="<cfif isdefined("attributes.x_is_basket_price")><cfoutput>#attributes.x_is_basket_price#</cfoutput><cfelse>0</cfif>">
	<input type="hidden" name="price_change" id="price_change" value="<cfif isdefined('attributes.price_change') and attributes.price_change eq 1>1<cfelse>0</cfif>">
	<input type="hidden" name="stock_id" id="stock_id" value="<cfif isdefined('attributes.stock_id')><cfoutput>#attributes.stock_id#</cfoutput></cfif>">
	<input type="hidden" name="product_id" id="product_id" value="<cfif isdefined('attributes.product_id')><cfoutput>#attributes.product_id#</cfoutput></cfif>">
	<cfif isdefined("attributes.row_id")>
	<input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.basket_id")>
		<input type="hidden" name="basket_id" id="basket_id" value="<cfoutput>#attributes.basket_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.form_name")>
		<input type="hidden" name="form_name" id="form_name" value="<cfoutput>#attributes.form_name#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.company_id")>
		<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
	</cfif>
	<cfif isdefined("attributes.consumer_id")>
		<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
	</cfif>
	<cfoutput>
		<cfloop query="GET_MONEY">
			<cfif isdefined("attributes.#money#") >
				<input type="hidden" name="#money#" id="#money#" value="#evaluate('attributes.#money#')#">
			</cfif>
		</cfloop>
	</cfoutput>
</form>
<!--- 
Bu sayfa objects'deki list_spect_main sayfasından açılır.
Sayfanın amacı:Üretim sonucunda main spec seçildiğinde,seçilen main spec'e ait bir spect oluşturmak 
ve bu oluşturulan spect'in değerlerini üretim sonucu sayfasına göndermek,ve gönderim yapıldığında da
yeni oluştulan spect'e göre üretim sonucundaki kayıtların güncellenmesinin yapılması.
M.ER 20070619
 --->
<cfif isdefined('attributes.BASKET_ID')><!--- Faturadan geliyorsa --->
	<cfquery name="get_spect_type" datasource="#dsn3#">
		SELECT SPECT_TYPE FROM SPECT_MAIN WHERE SPECT_MAIN_ID = #attributes.SPECT_MAIN_ID#
	</cfquery>
	<cfset attributes.spect_type = get_spect_type.SPECT_TYPE>
<cfelse><!--- Üretimden geliyorsa --->
	<cfif not len(attributes.spect_type)>
		<cfset attributes.spect_type= 1>
	</cfif><!--- Eğer type'ı yoksa sabit olarak 1 set edilsin. --->
</cfif>
<!--- Main spec id verilerek bir spect ekleniyor. --->
<cfscript>
	specer(
		dsn_type:dsn3,
		spec_type:attributes.spect_type,
		main_spec_id:attributes.spect_main_id,
		add_to_main_spec:1
		  );
</cfscript>
<cfquery name="get_spect_info" datasource="#dsn3#"><!--- Spect bilgileri geliyor. --->
	SELECT * FROM SPECTS WHERE SPECT_VAR_ID = #GET_MAX.MAX_ID#
</cfquery>
<cfset my_spect_name = replace(get_spect_info.SPECT_VAR_NAME,"'","","all")>
<cfset my_spect_name = replace(my_spect_name,'"','','all')>
<cfset my_spect_name = replace(my_spect_name,'#chr(13)#','','all')>
<cfset my_spect_name = replace(my_spect_name,'#chr(10)#','','all')>
<cfif isdefined("attributes.x_is_basket_price") and attributes.x_is_basket_price eq 1 and isdefined("attributes.basket_id") and len(attributes.price_catid)><!--- Eğer spect fiyatına göre fiyat güncelle seçili ise baskete spect fiyatı düşecek --->
	<cfif not len(attributes.product_id)>
		<cfquery name="get_product_id" datasource="#dsn3#">
			SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.stock_id#
		</cfquery>
		<cfset attributes.product_id = get_product_id.product_id>
	</cfif>
	<cfquery name="get_price" datasource="#dsn3#">
		SELECT
			PRICE
		FROM
			PRICE
		WHERE 
			STARTDATE <= #createodbcdatetime(attributes.search_process_date)# AND
			(FINISHDATE >= #createodbcdatetime(attributes.search_process_date)# OR FINISHDATE IS NULL) AND
			SPECT_VAR_ID = #get_spect_info.SPECT_MAIN_ID# AND
			PRODUCT_ID = #attributes.product_id# AND
			PRICE_CATID = #attributes.price_catid#
	</cfquery>
</cfif>
<script type="text/javascript">
	var spect_var_id = <cfoutput>#GET_MAX.MAX_ID#</cfoutput>;
	var spect_var_name = <cfoutput>'#my_spect_name#'</cfoutput>;
	var spect_main_id =<cfoutput>'#get_spect_info.SPECT_MAIN_ID#'</cfoutput>;
	<!--- <cfif not isdefined('attributes.BASKET_ID') or (isdefined('attributes.FIELD_MAIN_ID') and isdefined('attributes.SPECT_MAIN_ID'))>//faruradan gelmiyorsa --->
	<cfif isdefined('attributes.create_main_spect_and_add_new_spect_id')>//create_main_spect_and_add_new_spect_id == > Eğer üretim emri ekleme sayfasından main spect seçiliyor ise o main specte ait bir spect ekleniyor ve bilgiler güncelleniyor.
		spect_gonder(spect_var_id,spect_var_name,spect_main_id);
		function spect_gonder(spect_var_id,spect_var_name,spect_main_id)
		{
		//Bu kısım üretim emri ekleme sayfasından (prod.add_prod_order) geliyor.Üretim emri ekleme sayfasında main spect id'yi de gösterdiğimiz için
		//forma main spect id'yide gönderiyoruz.
		<cfif isdefined('attributes.spect_main_id') and isdefined('attributes.field_main_id')>
			<cfif ListLen(attributes.field_main_id,'.') eq 2>
				<cfset _field_main_id_ = ListGetAt(attributes.field_main_id,2,'.')><!--- Formu olmayan Sayfalara Değer Taşımak İçin Konuldu M.ER 01052008--->
			<cfelse>
				<cfset _field_main_id_ = attributes.field_main_id>
			</cfif>
			if(window.opener.document.getElementById(<cfoutput>'#_field_main_id_#'</cfoutput>) != undefined)
				window.opener.document.getElementById(<cfoutput>'#_field_main_id_#'</cfoutput>).value = spect_main_id;
			else	
				opener.document.<cfoutput>#attributes.field_main_id#</cfoutput>.value = spect_main_id;
				
		</cfif>
		// prod.add_prod_order,prod.add_prod_order_result,prod.upd_prod_order_result sayfalarından geliyor.Forma spect id ve adını atıyor.
		<cfif isdefined("attributes.field_id")>
			<cfif ListLen(attributes.field_id,'.') eq 2>
				<cfset _field_id_ = ListGetAt(attributes.field_id,2,'.')>
			<cfelse>
				<cfset _field_id_ = attributes.field_id >
			</cfif>
			if(window.opener.document.getElementById(<cfoutput>'#_field_id_#'</cfoutput>) != undefined)
				window.opener.document.getElementById(<cfoutput>'#_field_id_#'</cfoutput>).value = spect_var_id;
			else	
				opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value = spect_var_id;
			<cfif ListLen(attributes.field_name,'.') eq 2>
				<cfset _field_name_ = ListGetAt(attributes.field_name,2,'.')>
			<cfelse>
				<cfset _field_name_ = attributes.field_name >
			</cfif>
			if(window.opener.document.getElementById(<cfoutput>'#_field_name_#'</cfoutput>) != undefined)
				window.opener.document.getElementById(<cfoutput>'#_field_name_#'</cfoutput>).value = spect_var_name;
			else	
				opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value = spect_var_name;
			//üretim emri sonuç sayfalarında spect_değiştir diye bir fonksiyon o üretimin bilgilerini güncelliyor sayfayı refresh ediyor.
		</cfif>
		//üretim emri sonuç sayfalarında spect_değiştir diye bir fonksiyon o üretimin bilgilerini güncelliyor sayfayı refresh ediyor.
		<cfif isdefined('attributes.spect_change') and attributes.spect_change eq 1>
			window.opener.spect_degistir();
		</cfif>
		window.close();
		//alert('üretim');
		}
	<cfelse>
		//alert('fatura sipariş');
		document.form_gonder_spect.spect_id.value = spect_var_id;
		<cfif isdefined("attributes.x_is_basket_price") and attributes.x_is_basket_price eq 1 and isdefined("attributes.basket_id") and isdefined("get_price") and get_price.recordcount>
			document.form_gonder_spect.price.value = "<cfoutput>#get_price.price#</cfoutput>";
		</cfif>
		document.form_gonder_spect.submit();
	</cfif>
</script>
<!--- Bu blok Üretim emri için kullanılıyor.Kesinlikle Silinmesin M.ER 27042007 --->
<cfif isdefined('attributes.spect_change') and attributes.spect_change eq 1><!--- EKLEME EKRANINDAN GELİYORSA --->
	<cfif isdefined('attributes.P_ORDER_ID')>
		<cfquery name="upd_spect_change" datasource="#DSN3#"><!--- ÜRETİM EMRİNDEKİ SPECT ID VE SPECT NAME GÜNCELLENİYOR. --->
			UPDATE PRODUCTION_ORDERS
			SET 
				SPEC_MAIN_ID = #attributes.spect_main_id#,
                SPECT_VAR_ID = #GET_MAX.MAX_ID#,
				SPECT_VAR_NAME= '#get_spect_info.SPECT_VAR_NAME#'
			WHERE P_ORDER_ID = #attributes.p_order_id#
		</cfquery>
        <cfif isdefined('attributes.P_ORDER_ROW_ID') and len(attributes.P_ORDER_ROW_ID)>
        	<!--- Buraya girerse bu üretim sipariş ile ilişkilidir demektir,bu sebeble oluşan yeni spect_var_id için siparişide güncelliyoruz. --->
            <cfloop from="1" to="#ListLen(attributes.P_ORDER_ROW_ID,',')#" index="i_in_d">
                <cfquery name="UPD_ORDERS" datasource="#dsn3#">
                    UPDATE ORDER_ROW SET SPECT_VAR_ID =  #GET_MAX.MAX_ID# WHERE ORDER_ROW_ID = #ListGetAt(attributes.P_ORDER_ROW_ID,i_in_d,',')# 
                </cfquery>
            </cfloop>
        </cfif>
	</cfif>
	<cfif isdefined('attributes.pr_order_id') and len(attributes.pr_order_id)><!--- GÜNCELLEME EKRANINDAN GELİYORSA --->
		<cfquery name="GET_PRODUCT_QUANTITY" datasource="#DSN3#"><!--- ÜRETİM EMRİNİN KAÇ TANE OLDUĞU ÇEKİLİYOR,MİKTARI YANİ --->
			SELECT AMOUNT FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = #attributes.pr_order_id#  AND TYPE = 1
		</cfquery>
		<cfquery name="GET_PRODUCT_DATE" datasource="#DSN3#"><!--- ÜRETİM EMRİNİN KAÇ TANE OLDUĞU ÇEKİLİYOR,MİKTARI YANİ --->
			SELECT FINISH_DATE FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = #attributes.pr_order_id#
		</cfquery>
		<cfif GET_PRODUCT_QUANTITY.RECORDCOUNT><!--- SPECT BİLEŞLENLERİNİN MİKTARLARININ HESAPLAMAK İÇİN ÇARPILACAK OLAN ÜRETİM EMRİ MİKTARI BELİRLENİYOR. --->
			<cfset miktar=GET_PRODUCT_QUANTITY.AMOUNT>
		<cfelse>
			<cfset miktar=1>
		</cfif>
		<cfquery name="delete_row" datasource="#DSN3#"><!--- SARFLAR SİLİNİYOR. --->
			DELETE PRODUCTION_ORDER_RESULTS_ROW
			WHERE PR_ORDER_ID = #attributes.pr_order_id# AND TYPE = <cfif isdefined('attributes.is_demontaj')>1<cfelse>2</cfif><!--- Eğer demontaj ise sonuçlar değilse sarflar silinsin. --->
		</cfquery>
			<cfquery name="GET_SUB_PRODUCT" datasource="#DSN3#">
				SELECT
					'Spec' AS NAME,
					SPECTS_ROW.AMOUNT_VALUE AS AMOUNT,
					SPECTS_ROW.IS_SEVK,
					SPECTS_ROW.IS_PROPERTY,
                    SPECTS_ROW.RELATED_SPECT_ID AS RELATED_MAIN_SPECT_ID,
					SPECTS_ROW.PRODUCT_COST_ID AS PRODUCT_COST_ID,
					STOCKS.PRODUCT_NAME,
					STOCKS.PRODUCT_ID,
					STOCKS.STOCK_ID,
					PRODUCT.BARCOD,
					PRODUCT_UNIT.ADD_UNIT,
					PRODUCT_UNIT.MAIN_UNIT,
					PRODUCT.IS_PRODUCTION,
					PRODUCT.TAX,
					PRODUCT.TAX_PURCHASE,
					STOCKS.PRODUCT_UNIT_ID,
					PRICE_STANDART.PRICE,
					PRICE_STANDART.MONEY,
					STOCKS.PROPERTY
				FROM
					SPECTS,
					SPECTS_ROW,		
					STOCKS,
					PRODUCT,
					PRODUCT_UNIT,
					PRICE_STANDART
				WHERE
					PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
					PRICE_STANDART.PURCHASESALES = 1 AND
					PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
					SPECTS.SPECT_VAR_ID = #GET_MAX.MAX_ID# AND
					SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
					SPECTS_ROW.STOCK_ID = STOCKS.STOCK_ID AND
					STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
					PRODUCT_UNIT.PRODUCT_UNIT_ID = STOCKS.PRODUCT_UNIT_ID AND
					SPECTS_ROW.IS_PROPERTY=0 AND
					STOCKS.PRODUCT_UNIT_ID=PRICE_STANDART.UNIT_ID 
			</cfquery><!--- SEÇİLEN SPECTİN BİLGİLERİ GELİYOR. --->
			<cfloop query="GET_SUB_PRODUCT"><!--- SPECTDEKİ ÜRÜNLER DÖNÜYOR  --->
				<cfquery name="GET_PRODUCT" datasource="#dsn3#" maxrows="1"><!--- ÜRÜNÜN PARA ,MALIYETI VE BİRİMLERİ ÇEKİLİYOR. --->
					SELECT 
						PRODUCT_COST_ID,
						PURCHASE_NET,
						PURCHASE_NET_MONEY,
						PURCHASE_NET_SYSTEM,
						PURCHASE_NET_SYSTEM_MONEY,
						PURCHASE_EXTRA_COST,
						PURCHASE_EXTRA_COST_SYSTEM,
						PRODUCT_COST,
						MONEY 
					FROM 
						PRODUCT_COST 
					WHERE 
						PRODUCT_ID = #product_id# AND
						START_DATE <= #createodbcdate(GET_PRODUCT_DATE.FINISH_DATE)#
					ORDER BY 
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
				<cfscript>
					if(GET_PRODUCT.RECORDCOUNT eq 0)
					{
						cost_id = 0;
						purchase_extra_cost = 0;
						product_cost = 0;
						product_cost_money = session.ep.money;
						cost_price = 0;
						cost_price_money = session.ep.money;
						cost_price_system = 0;
						cost_price_system_money = session.ep.money;
						purchase_extra_cost_system = 0;
					}
					else
					{
						cost_id = get_product.product_cost_id;
						purchase_extra_cost = GET_PRODUCT.PURCHASE_EXTRA_COST;
						product_cost = GET_PRODUCT.PRODUCT_COST;
						product_cost_money = GET_PRODUCT.MONEY;
						cost_price = GET_PRODUCT.PURCHASE_NET;
						cost_price_money = GET_PRODUCT.PURCHASE_NET_MONEY;
						cost_price_system = GET_PRODUCT.PURCHASE_NET_SYSTEM;
						cost_price_system_money = GET_PRODUCT.PURCHASE_NET_SYSTEM_MONEY;
						purchase_extra_cost_system = GET_PRODUCT.PURCHASE_EXTRA_COST_SYSTEM;
					}
				</cfscript>
				<cfquery name="ADD_ROW_ENTER" datasource="#dsn3#">
					INSERT INTO
						PRODUCTION_ORDER_RESULTS_ROW
					(
						TYPE,
						PR_ORDER_ID,
						BARCODE,
						STOCK_ID,
						PRODUCT_ID,
						AMOUNT,
						UNIT_ID,
						NAME_PRODUCT,
						UNIT_NAME,
						IS_SEVKIYAT,
						SPECT_ID,
						SPEC_MAIN_ID,
						SPECT_NAME,
						
						COST_ID,
						KDV_PRICE,
						PURCHASE_NET_SYSTEM,
						PURCHASE_NET_SYSTEM_MONEY,
						PURCHASE_EXTRA_COST_SYSTEM,
						PURCHASE_NET_SYSTEM_TOTAL,
						PURCHASE_NET,
						PURCHASE_NET_MONEY,
						PURCHASE_EXTRA_COST,
						PURCHASE_NET_TOTAL
					)
					VALUES
					(
						<cfif isdefined('attributes.is_demontaj')>1<cfelse>2</cfif>,<!--- Eğer demontaj ise silinen sonuçların yerine sonuç diye eklensin değilse sarflar eklensin yani 2 eklensin --->
						#attributes.pr_order_id#,
						<cfif len(BARCOD)>'#BARCOD#'<cfelse>NULL</cfif>,
						<cfif len(STOCK_ID)>#STOCK_ID#<cfelse>NULL</cfif>,
						<cfif len(PRODUCT_ID)>#PRODUCT_ID#<cfelse>NULL</cfif>,
						<cfif len(AMOUNT)>#AMOUNT#*#miktar#<cfelse>NULL</cfif>,
						<cfif len(PRODUCT_UNIT_ID)>#PRODUCT_UNIT_ID#<cfelse>NULL</cfif>,
						'#left(PRODUCT_NAME,75)#',
						'#left(MAIN_UNIT,75)#',
						0,
						NULL,
						<cfif len(RELATED_MAIN_SPECT_ID)>#RELATED_MAIN_SPECT_ID#<cfelse>NULL</cfif>,
						NULL,
						<cfif len(cost_id) and (cost_id neq 0)>#cost_id#<cfelse>NULL</cfif>,
						<cfif len(TAX)>#TAX#<cfelse>0</cfif>,
						<cfif len(cost_price_system)>#cost_price_system#<cfelse>0</cfif>,
						<cfif len(cost_price_system_money)>'#cost_price_system_money#'<cfelse>'#session.ep.money#'</cfif>,
						<cfif len(purchase_extra_cost_system)>#purchase_extra_cost_system#<cfelse>0</cfif>,
						<cfif len(cost_price_system) and len(AMOUNT)>#cost_price_system*AMOUNT#<cfelse>0</cfif>,
						<cfif len(cost_price)>#cost_price#<cfelse>0</cfif>,
						<cfif len(cost_price_money)>'#cost_price_money#'<cfelse>'#session.ep.money#'</cfif>,
						<cfif len(purchase_extra_cost)>#purchase_extra_cost#<cfelse>0</cfif>,
						<cfif len(cost_price)>#cost_price*AMOUNT#<cfelse>0</cfif>
					)				
				</cfquery><!--- SİLİNEN SARFLARIN YERİNE SPECTDEN GELEN YENİ ÜRÜNLER EKLENİYOR. --->
			</cfloop>
			<cfquery name="upd_spect_change_row" datasource="#DSN3#">
				UPDATE 
                	PRODUCTION_ORDER_RESULTS_ROW
				SET 
                	SPECT_ID = #GET_MAX.MAX_ID#,
                    SPEC_MAIN_ID =#attributes.spect_main_id#
				WHERE 
                	PR_ORDER_ID = #attributes.pr_order_id#
				AND TYPE = <cfif isdefined('attributes.is_demontaj')>2<cfelse>1</cfif><!--- Burda tam tersini yapıyoruz çünkü asıl ürünün spect'ini güncelleştirmemiz lazım,demontaj olduğunda da gerçek ürün sarf kısmında görünnen ürün olduğu için is_demontaj tanımlı ise 2 olanı güncelliyoruz. --->
			</cfquery>
			<cfif isdefined('attributes.P_ORDER_ROW_ID') and len(attributes.P_ORDER_ROW_ID)>
				<!--- Buraya girerse bu üretim sipariş ile ilişkilidir demektir,bu sebeble oluşan yeni spect_var_id için siparişide güncelliyoruz. --->
                <cfloop from="1" to="#ListLen(attributes.P_ORDER_ROW_ID,',')#" index="i_in_d">
                    <cfquery name="UPD_ORDERS" datasource="#dsn3#">
                        UPDATE ORDER_ROW SET SPECT_VAR_ID =  #GET_MAX.MAX_ID# WHERE ORDER_ROW_ID = #ListGetAt(attributes.P_ORDER_ROW_ID,i_in_d,',')# 
                    </cfquery>
                </cfloop>
            </cfif>
			<!--- üRETİM EMRİ SATIRLARI GÜNCELLENİYOR. --->
	</cfif>
</cfif>
<!--- Bu blok Üretim emri için kullanılıyor.Kesinlikle Silinmesin M.ER 27042007 --->
