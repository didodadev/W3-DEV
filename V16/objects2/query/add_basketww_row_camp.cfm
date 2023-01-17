<cfsetting showdebugoutput="no">
<cfset campaign_control = 0>
<cfscript>
	if(not arraylen(session.basketww_camp))
		campaign_control = 1;
			
	if(isdefined("attributes.is_commission") and attributes.is_commission eq 1)
		{
			for (i=1;i lte arraylen(session.basketww_camp);i=i+1)
			{
				if(session.basketww_camp[i][20] is 1)//komisyon olan satır varsa silip yeniden kaydeddicek
					ArrayDeleteAt(session.basketww_camp,i);
			}
		}
		
	if(isdefined("attributes.is_cargo") and attributes.is_cargo eq 1)
		{
			for (i=1;i lte arraylen(session.basketww_camp);i=i+1)
			{
				if(session.basketww_camp[i][26] is 1)//cargo olan satır varsa silip yeniden kaydeddicek
					ArrayDeleteAt(session.basketww_camp,i);
				else if(session.basketww_camp[i][20] is 1)//komisyon olan satır varsa silip yeniden kaydeddicek
					ArrayDeleteAt(session.basketww_camp,i);
			}
		}
	
	for (i=1;i lte arraylen(session.basketww_camp);i=i+1)
		{
			if(session.basketww_camp[i][24] eq attributes.campaign_id)
				campaign_control = 1;
		}
</cfscript>
<cfif campaign_control eq 1>
	<cfquery datasource="#dsn3#" name="get_stock" maxrows="1">
		SELECT
			PRODUCT_ID,
			PRODUCT_NAME,
			TAX,
			PROPERTY,
			PRODUCT_UNIT_ID
		FROM
			STOCKS
		WHERE
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
	</cfquery>
	<cfset urun_onceden_eklenmismi = 0>
	<cfif not urun_onceden_eklenmismi>
		<cfset attributes.is_prom_asil_hediye = 0>
		<cfscript>
			new_row_no = arraylen(session.basketww_camp)+1;
			//ÜRÜN BİLGİLERİ	
			session.basketww_camp[new_row_no][1] = get_stock.product_id; //ürün id si
			if (trim(get_stock.property) is '-')
				{session.basketww_camp[new_row_no][2] = '#get_stock.product_name#';} //ürün adı 
			else
				{session.basketww_camp[new_row_no][2] = '#get_stock.product_name# #get_stock.property#';} //ürün adı 
			session.basketww_camp[new_row_no][3] = attributes.istenen_miktar; // miktar 
			session.basketww_camp[new_row_no][4] = attributes.price; // kdv siz birim fiyat 
			session.basketww_camp[new_row_no][5] = attributes.price_kdv;// kdv li birim fiyat //ESKİDEN:iif( get_price.IS_KDV is 1,get_price.PRICE_KDV,attributes.price * (1 + (get_stock.TAX / 100)) ); 
			session.basketww_camp[new_row_no][6] = attributes.price_money; // para birimi 
			session.basketww_camp[new_row_no][7] = get_stock.tax; // kdv oranı
			session.basketww_camp[new_row_no][8] = attributes.sid; //ürün stock id si
			session.basketww_camp[new_row_no][9] = get_stock.product_unit_id; //ürün ANA birim id si
			//PROMOSYON BİLGİLERİ
			session.basketww_camp[new_row_no][10] = attributes.prom_id; //Promosyon id si
			session.basketww_camp[new_row_no][11] = attributes.prom_discount; //Promosyon yüzde indirimi
			session.basketww_camp[new_row_no][12] = attributes.prom_amount_discount; //Promosyon iskonto tutarı
			session.basketww_camp[new_row_no][13] = attributes.prom_cost; //Promosyon maliyeti		
			session.basketww_camp[new_row_no][14] = attributes.sid; //Promosyonun asıl ürününün STOK id si
			session.basketww_camp[new_row_no][15] = attributes.prom_stock_amount; //asıl ürününün Promosyonun gerçekleşmesi için gerekli olan adedi
			session.basketww_camp[new_row_no][16] = attributes.is_prom_asil_hediye;//0:asıl ürün 1:hediye ürün
			if(len(attributes.prom_free_stock_id))
				session.basketww_camp[new_row_no][17] = 1;//1:Hediyeli promosyon 0:Hediyesiz
			else
				session.basketww_camp[new_row_no][17] = 0;//1:Hediyeli promosyon 0:Hediyesiz
			session.basketww_camp[new_row_no][18] = attributes.price_old; // kdv siz birim fiyat (eğer promosyonda yüzde veya tutar tanımlı ise üstünü çizmek için gelir)
			//SPEC BİLGİLERİ
			session.basketww_camp[new_row_no][19] = ''; // Spec id
			if(isDefined("attributes.is_commission") and attributes.is_commission eq 1)//komisyon ürünü varsa
				session.basketww_camp[new_row_no][20] = '1';	
			else
				session.basketww_camp[new_row_no][20] = '0';
			//son kullanici fiyatlari (=price_standart) AK 20060822
			session.basketww_camp[new_row_no][21] = attributes.price_standard; // kdv siz birim fiyat (son kullanici)
			session.basketww_camp[new_row_no][22] = attributes.price_standard_kdv;// kdv li birim fiyat (son kullanici)
			session.basketww_camp[new_row_no][23] = attributes.price_standard_money; // para birimi (son kullanici) 
			session.basketww_camp[new_row_no][24] = attributes.campaign_id; // kampanya id
			if(isdefined("attributes.catalog_id"))
				session.basketww_camp[new_row_no][25] = attributes.catalog_id; // aksiyon 
			else
				session.basketww_camp[new_row_no][25] = ''; // aksiyon 
			if(isDefined("attributes.is_cargo") and attributes.is_cargo eq 1)//cargo ürünü varsa
				session.basketww_camp[new_row_no][26] = '1';	
			else
				session.basketww_camp[new_row_no][26] = '0';
		</cfscript>
	</cfif>

	<cfif len(attributes.prom_free_stock_id)>
		<cfquery datasource="#dsn3#" name="get_prom_free_stock">
		SELECT 
			PRODUCT_ID, 
			PRODUCT_NAME, 
			TAX, 
			PRODUCT_UNIT_ID, 
			PROPERTY
		FROM 
			STOCKS
		WHERE 
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_free_stock_id#">
		</cfquery>
		<cfif get_prom_free_stock.recordcount>
			<cfset attributes.is_prom_asil_hediye = 1>
			<cfset attributes.is_prom_free_stock = 1>
			<cfset urun_onceden_eklenmismi = 0>
			<cfif not urun_onceden_eklenmismi>
				<cfscript>
					new_row_no = arraylen(session.basketww_camp)+1;
					//ÜRÜN BİLGİLERİ	
					session.basketww_camp[new_row_no][1] = get_prom_free_stock.product_id; //ürün id si
					if (trim(get_prom_free_stock.PROPERTY) is '-')
						{session.basketww_camp[new_row_no][2] = '#get_prom_free_stock.product_name#';} //ürün adı 
					else
						{session.basketww_camp[new_row_no][2] = '#get_prom_free_stock.product_name# #get_prom_free_stock.property#';} //ürün adı 
					session.basketww_camp[new_row_no][3] = attributes.istenen_miktar; // miktar 
					session.basketww_camp[new_row_no][4] = attributes.prom_free_stock_price; // kdv siz birim fiyat 
					session.basketww_camp[new_row_no][5] = attributes.prom_free_stock_price * (1 + (get_prom_free_stock.tax / 100));// kdv li birim fiyat 
					session.basketww_camp[new_row_no][6] = attributes.prom_free_stock_money; // para birimi 
					session.basketww_camp[new_row_no][7] = get_prom_free_stock.tax; // kdv oranı
					session.basketww_camp[new_row_no][8] = attributes.prom_free_stock_id; //ürün stock id si
					session.basketww_camp[new_row_no][9] = get_prom_free_stock.product_unit_id; //stokun birim id si
					//PROMOSYON BİLGİLERİ
					session.basketww_camp[new_row_no][10] = attributes.prom_id; //Promosyon id si
					session.basketww_camp[new_row_no][11] = ''; //Promosyon yüzde indirimi
					session.basketww_camp[new_row_no][12] = attributes.prom_free_stock_price; //Promosyon iskonto tutarı
					session.basketww_camp[new_row_no][13] = ''; //Promosyon maliyeti
					session.basketww_camp[new_row_no][14] = attributes.sid; //Promosyonun asıl ürününün STOK id si
					session.basketww_camp[new_row_no][15] = attributes.prom_free_stock_amount; //Hediye ürününün Promosyonun gerçekleşmesi için gerekli olan adedi
					session.basketww_camp[new_row_no][16] = attributes.is_prom_asil_hediye;//asil:0 hediye:1
					session.basketww_camp[new_row_no][17] = 1;//1:Hediyeli promosyon 0:Hediyesiz promosyon
					session.basketww_camp[new_row_no][18] = ''; // kdv siz birim fiyat (eğer promosyonda yüzde veya tutar tanımlı ise üstünü çizmek için gelir)
					//SPEC BİLGİLERİ
					session.basketww_camp[new_row_no][19] = ''; // Spec id
					if(isDefined("attributes.is_commission") and attributes.is_commission eq 1)//komisyon ürünü
						session.basketww_camp[new_row_no][20] = '1';
					else
						session.basketww_camp[new_row_no][20] = '0';
					//son kullanici fiyatlari (=price_standart) AK 20060822
					session.basketww_camp[new_row_no][21] = '0'; // kdv siz birim fiyat (son kullanici)
					session.basketww_camp[new_row_no][22] = '0';// kdv li birim fiyat (son kullanici)
					session.basketww_camp[new_row_no][23] = ''; // para birimi (son kullanici)
					session.basketww_camp[new_row_no][24] = attributes.campaign_id; // kampanya id
					session.basketww_camp[new_row_no][25] = ''; // aksiyon 
					if(isDefined("attributes.is_cargo") and attributes.is_cargo eq 1)//cargo ürünü
						session.basketww_camp[new_row_no][26] = '1';
					else
						session.basketww_camp[new_row_no][26] = '0';
				</cfscript>
			</cfif>
			<script type="text/javascript">
				if(parent.basketww_camp)
					parent.basketww_camp.location.reload();
					<cfif not isDefined("attributes.is_commission")>
						history.back();
					</cfif>
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1397.Promosyonda bedava verilen ürün ile ilgili bir sorun olduğu için sepete eklenmeyecektir'>.");
				if(parent.basketww_camp)
					parent.basketww_camp.location.reload();
					<cfif not isDefined("attributes.is_commission")>
						history.back();
					</cfif>
			</script>
		</cfif>
	<cfelse>
		<script type="text/javascript">
			if(parent.basketww_camp)
				parent.basketww_camp.location.reload();
				<cfif not isDefined("attributes.is_commission")>
					history.back();
				</cfif>
		</script>
	</cfif>
</cfif>
