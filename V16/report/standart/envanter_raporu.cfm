<!--- 
Raporda; stokların maliyeti, stok kodu, açıklaması ve secilen tarih ve depoya gore ;
	Dönem Başı Stok : Başlangıc tarihi olarak yılbası secilmiş ise Acılıs (devir) Fisi (PROCESS_TYPE:114) stok hareketlerinden, 
						farklı bir tarih seçilmiş ise o gune kadar ki stok giriş çıkış hareketlerinin toplamını getirir 
	Dönem İçi Alış  : Alış tipindeki işlemlerin stok hareketlerinden  (PROCESS_TYPE:76,77,80,81,811,761,82,84,86)
	Dönem İçi Alış İade  : Alış İade tipindeki işlemlerinstok hareketlerinden  (PROCESS_TYPE:78,79)
	Dönem İçi Üretim : Üretim fişi stok hareketlerinden (PROCESS_TYPE:110)
	Dönem İçi Satış : Satış tipindeki işlemlerinstok hareketlerinden (PROCESS_TYPE:70,71,72,81,811,83,85)
	Dönem İçi Satış İade : Satış İade tipindeki işlemlerinstok hareketlerinden (PROCESS_TYPE:73,74,75)
	Dönem İçi Sarf : sarf fişi hareketlerinden (PROCESS_TYPE:111)
	Dönem İçi Fire : fire fişi hareketlerinden (PROCESS_TYPE:112)
	Dönem İçi Sayım : sayim fişi hareketlerinden (PROCESS_TYPE:115)
	Dönem İçi Sayım Sıfırlama : sayim sıfırlama fişi hareketlerinden (PROCESS_TYPE:117)
	Dönem Sonu Stok : Ürünün stokta bulunan miktarı
bilgileri listelenir. 
OZDEN 20060622
  --->
<cfparam name="attributes.date" default="01/01/#session.ep.period_year#">
<cfparam name="attributes.date2" default="#dateformat(createodbcdate(now()),dateformat_style)#">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfquery name="GET_DEPT" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM BRANCH B,DEPARTMENT D WHERE B.COMPANY_ID=#SESSION.EP.COMPANY_ID# AND B.BRANCH_ID=D.BRANCH_ID AND D.IS_STORE<>2 AND D.DEPARTMENT_STATUS=1
</cfquery>
<cfif isdate(attributes.date)>
	<cf_date tarih = 'attributes.date'>
</cfif>
<cfif isdate(attributes.date2)>
	<cf_date tarih = 'attributes.date2'>
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="GET_ALL_STOCK" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT DISTINCT
			S.STOCK_CODE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			(S.PRODUCT_NAME + ' ' + S.PROPERTY) URUN_ADI
		FROM        
			STOCKS_ROW AS SR,
			#dsn3_alias#.STOCKS S
		<cfif len(attributes.department_id)>
			,#dsn_alias#.DEPARTMENT AS D
		</cfif>
		WHERE
			SR.STOCK_ID=S.STOCK_ID
			AND S.IS_INVENTORY=1
		<cfif len(attributes.department_id)>
			AND D.DEPARTMENT_ID=SR.STORE
			AND D.DEPARTMENT_ID = #attributes.department_id#
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			AND S.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.pos_code) and len(attributes.employee)>
			AND S.PRODUCT_MANAGER = #attributes.pos_code#
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND S.BRAND_ID = #attributes.brand_id# 
		</cfif>	
		<cfif len(attributes.product_code) and len(attributes.product_cat)>
			AND S.STOCK_CODE LIKE '#attributes.product_code#%'
		</cfif>
		ORDER BY S.STOCK_ID
	</cfquery>

	<cfquery name="GET_STOCK_ROWS" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT   
			S.STOCK_CODE,
			S.STOCK_ID,
			S.PRODUCT_ID,
			(S.PRODUCT_NAME + ' ' + S.PROPERTY) URUN_ADI,
			SUM(SR.STOCK_IN) AS STOCK_IN,
			SUM(SR.STOCK_OUT) AS STOCK_OUT,
			SUM(SR.STOCK_IN-SR.STOCK_OUT) AS STOCK_TOTAL,
			SR.PROCESS_TYPE
		FROM        
			STOCKS_ROW AS SR,
			#dsn3_alias#.STOCKS S,
		<cfif len(attributes.department_id)>
			#dsn_alias#.DEPARTMENT AS D,
		</cfif>
			#dsn_alias#.STOCKS_LOCATION SL
		WHERE
			(SR.PROCESS_DATE BETWEEN #attributes.date# AND #attributes.date2#)
			AND SR.STOCK_ID=S.STOCK_ID
			AND S.IS_INVENTORY=1
			AND SR.STORE = SL.DEPARTMENT_ID
			AND SR.STORE_LOCATION=SL.LOCATION_ID
			AND SL.BELONGTO_INSTITUTION = 0
		<cfif len(attributes.department_id)>
			AND D.DEPARTMENT_ID=SR.STORE
			AND D.DEPARTMENT_ID = #attributes.department_id#
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			AND S.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.pos_code) and len(attributes.employee)>
			AND S.PRODUCT_MANAGER = #attributes.pos_code#
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND S.BRAND_ID = #attributes.brand_id# 
		</cfif>	
		<cfif len(attributes.product_code) and len(attributes.product_cat)>
			AND S.STOCK_CODE LIKE '#attributes.product_code#%'
		</cfif>
		GROUP BY
			S.PRODUCT_ID,
			S.STOCK_ID,
			S.STOCK_CODE,
			(S.PRODUCT_NAME + ' ' + S.PROPERTY),
			SR.PROCESS_TYPE
		ORDER BY S.STOCK_ID
	</cfquery>
<cfelse>
	<cfset GET_STOCK_ROWS.recordcount = 0>
	<cfset GET_ALL_STOCK.recordcount = 0>
</cfif>
<cfif attributes.date is '01/01/#session.ep.period_year#' and GET_STOCK_ROWS.recordcount>
	<cfquery name="acilis_stok" dbtype="query">
		SELECT	
			SUM(STOCK_IN-STOCK_OUT) AS ILK_STOK,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE =114
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
<cfelse>
	<cfquery name="acilis_stok" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		SELECT   
			S.STOCK_ID,
			S.PRODUCT_ID,
			SUM(SR.STOCK_IN - SR.STOCK_OUT) ILK_STOK
		FROM        
			STOCKS_ROW AS SR,
			#dsn3_alias#.STOCKS S,
		<cfif len(attributes.department_id)>
			#dsn_alias#.DEPARTMENT AS D,
		</cfif>
			#dsn_alias#.STOCKS_LOCATION SL
		WHERE
			SR.PROCESS_DATE < #attributes.date#
			AND SR.STOCK_ID=S.STOCK_ID
			AND S.IS_INVENTORY=1
			AND SR.STORE = SL.DEPARTMENT_ID
			AND SR.STORE_LOCATION=SL.LOCATION_ID
			AND SL.BELONGTO_INSTITUTION = 0
		<cfif len(attributes.department_id)>
			AND D.DEPARTMENT_ID=SR.STORE
			AND D.DEPARTMENT_ID = #attributes.department_id#
		</cfif>
		<cfif len(attributes.company_id) and len(attributes.company)>
			AND S.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif len(attributes.pos_code) and len(attributes.employee)>
			AND S.PRODUCT_MANAGER = #attributes.pos_code#
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)>
			AND S.BRAND_ID = #attributes.brand_id# 
		</cfif>	
		<cfif len(attributes.product_code) and len(attributes.product_cat)>
			AND S.STOCK_CODE LIKE '#attributes.product_code#%'
		</cfif>
		GROUP BY
			S.PRODUCT_ID,
			S.STOCK_ID
		ORDER BY S.STOCK_ID
	</cfquery>
</cfif>

<cfif GET_STOCK_ROWS.recordcount>
	<cfquery name="donemici_alis" dbtype="query">
		SELECT	
			SUM(STOCK_IN) AS TOPLAM_ALIS,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE IN <cfif isdefined("attributes.department_id") and len(attributes.department_id)>(76,77,80,81,811,761,82,84,86,140)<cfelse>(76,77,80,761,82,84,86,140)</cfif> 
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_satis" dbtype="query">
		SELECT	
			SUM(STOCK_OUT) AS TOPLAM_SATIS,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE IN <cfif isdefined("attributes.department_id") and len(attributes.department_id)>(70,71,72,81,811,83,85,141)<cfelse>(70,71,72,83,85,141)</cfif>
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_alis_iade" dbtype="query">
		SELECT	
			SUM(STOCK_OUT) AS TOPLAM_ALIS_IADE,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE IN (78,79)
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_satis_iade" dbtype="query">
		SELECT	
			SUM(STOCK_IN) AS TOPLAM_SATIS_IADE,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE IN (73,74,75)
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_uretim" dbtype="query">
		SELECT	
			SUM(STOCK_IN) AS TOPLAM_URETIM,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE = 110
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_sarf" dbtype="query">
		SELECT	
			SUM(STOCK_OUT) AS TOPLAM_SARF,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE = 111
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_fire" dbtype="query">
		SELECT	
			SUM(STOCK_OUT) AS TOPLAM_FIRE,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE =112
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_sayim" dbtype="query">
		SELECT	
			SUM(STOCK_IN-STOCK_OUT) AS TOPLAM_SAYIM,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE =115
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_servis_giris" dbtype="query">
		SELECT	
			SUM(STOCK_IN-STOCK_OUT) AS SERVIS_GIRIS,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE =140
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="donemici_servis_cikis" dbtype="query">
		SELECT	
			SUM(STOCK_IN-STOCK_OUT) AS SERVIS_CIKIS,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE =141
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="DONEMICI_SAYIM_SIFIR" dbtype="query">
		SELECT	
			SUM(STOCK_IN-STOCK_OUT) AS TOPLAM_SAYIM_SIFIR,
			STOCK_ID,
			PRODUCT_ID
		FROM
			GET_STOCK_ROWS
		WHERE
			PROCESS_TYPE =117
		GROUP BY
			PRODUCT_ID,
			STOCK_ID
		ORDER BY STOCK_ID
	</cfquery>

</cfif>
<cfquery name="get_product_cost" datasource="#dsn3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT 
		PRODUCT_ID, PURCHASE_NET, PURCHASE_EXTRA_COST, PURCHASE_NET_MONEY 
	FROM 
		PRODUCT_COST 
	WHERE 
		START_DATE <= #attributes.date2# 
	ORDER BY PRODUCT_ID, RECORD_DATE DESC
</cfquery>
<cfif GET_ALL_STOCK.recordcount>
	<cfoutput query="GET_ALL_STOCK">
		<cfscript>
		if(GET_STOCK_ROWS.recordcount neq 0)
		{
			//donem ici toplam sayım fisi miktarları set ediliyor
			for(i=1;i lte donemici_sayim.recordcount;i=i+1)
			{
				if( donemici_sayim.STOCK_ID[i] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'sayim_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_sayim.TOPLAM_SAYIM[i];
					break;
				}
			}
			//donem ici toplam sayım sıfırlama miktarları set ediliyor
			for(i=1;i lte DONEMICI_SAYIM_SIFIR.recordcount;i=i+1)
			{
				if( DONEMICI_SAYIM_SIFIR.STOCK_ID[i] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'sayim_sifir_miktar_#GET_ALL_STOCK.STOCK_ID#' = DONEMICI_SAYIM_SIFIR.TOPLAM_SAYIM_SIFIR[i];
					break;
				}
			}
			//donem ici toplam alis miktarları set ediliyor
			for(j=1;j lte donemici_alis.recordcount;j=j+1)
			{
				if( donemici_alis.STOCK_ID[j] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'alis_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_alis.TOPLAM_ALIS[j];
					break;
				}
			}
			//donem ici toplam satıs miktarları set ediliyor
			for(k=1; k lte donemici_satis.recordcount; k=k+1)
			{
				if( donemici_satis.STOCK_ID[k] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'satis_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_satis.TOPLAM_SATIS[k];
					break;
				}
			}
			//donem ici toplam alıs iade miktarları set ediliyor
			for(m=1; m lte donemici_alis_iade.recordcount; m=m+1)
			{
				if( donemici_alis_iade.STOCK_ID[m] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'alis_iade_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_alis_iade.TOPLAM_ALIS_IADE[m];
					break;
				}
			}
			//donem ici toplam satıs iade miktarları set ediliyor
			for(n=1; n lte donemici_satis_iade.recordcount; n=n+1)
			{
				if( donemici_satis_iade.STOCK_ID[n] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'satis_iade_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_satis_iade.TOPLAM_SATIS_IADE[n];
					break;
				}
			}
			//donem ici toplam uretim miktarları set ediliyor
			for(t=1; t lte donemici_uretim.recordcount; t=t+1)
			{
				if( donemici_uretim.STOCK_ID[t] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'uretim_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_uretim.TOPLAM_URETIM[t];
					break;
				}
			}
			//donem ici toplam sarf miktarları set ediliyor
			for(s=1; s lte donemici_sarf.recordcount; s=s+1)
			{
				if( donemici_sarf.STOCK_ID[s] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'sarf_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_sarf.TOPLAM_SARF[s];
					break;
				}
			}
			//donem ici toplam fire miktarları set ediliyor
			for(s=1; s lte donemici_fire.recordcount; s=s+1)
			{
				if( donemici_fire.STOCK_ID[s] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'fire_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_fire.TOPLAM_FIRE[s];
					break;
				}
			}
			//donem ici toplam servis giris miktarları set ediliyor
			for(serv_g=1; serv_g lte donemici_servis_giris.recordcount; serv_g=serv_g+1)
			{
				if( donemici_servis_giris.STOCK_ID[serv_g] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'servis_giris_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_servis_giris.SERVIS_GIRIS[serv_g];
					break;
				}
			}
			//donem ici toplam servis cikis miktarları set ediliyor
			for(serv_c=1; serv_c lte donemici_servis_cikis.recordcount; serv_c=serv_c+1)
			{
				if( donemici_servis_cikis.STOCK_ID[serv_c] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'servis_cikis_miktar_#GET_ALL_STOCK.STOCK_ID#' = donemici_servis_cikis.SERVIS_CIKIS[serv_c];
					break;
				}
			}
		}
		//donem bası toplam stok miktarı set ediliyor
		if(isdefined('acilis_stok') and (acilis_stok.recordcount gt 0) )
		{
			for(i=1;i lte acilis_stok.recordcount;i=i+1)
			{
				if( acilis_stok.STOCK_ID[i] eq GET_ALL_STOCK.STOCK_ID ) 
				{
					'acilis_miktar_#GET_ALL_STOCK.STOCK_ID#' = acilis_stok.ILK_STOK[i];
					break;
				}
			}
		}
			//urun maliyetleri set ediliyor
		if(isdefined('get_product_cost') and (get_product_cost.recordcount gt 0) )
		{
			for(i=1;i lte get_product_cost.recordcount;i=i+1)
			{
				if( get_product_cost.PRODUCT_ID[i] eq GET_ALL_STOCK.PRODUCT_ID ) 
				{
					'birim_maliyet_#GET_ALL_STOCK.PRODUCT_ID#' = ( get_product_cost.PURCHASE_NET[i] + get_product_cost.PURCHASE_EXTRA_COST[i] );
					'maliyet_para_br_#GET_ALL_STOCK.PRODUCT_ID#' = get_product_cost.PURCHASE_NET_MONEY[i];
					break;
				}
			}
		}
		</cfscript>
	</cfoutput>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif attributes.maxrows gt 1000>
	<cfset attributes.maxrows = 250>
</cfif>
<cfparam name="attributes.totalrecords" default=#GET_ALL_STOCK.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.date)>
	<cfset attributes.date = dateformat(attributes.date, dateformat_style)>
</cfif>
<cfif isdate(attributes.date2)>
	<cfset attributes.date2 = dateformat(attributes.date2, dateformat_style)>
</cfif>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
	<tr height="35" >
		<td class="headbold"><a href="javascript:gizle_goster(search_table);">&raquo;<cf_get_lang dictionary_id="39060.Envanter"></a></td>
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
	</tr>
	<tr height="35" class="color-border" id="search_table">
		<td colspan="2" align="right" valign="bottom" style="text-align:right;"> 
			<table cellspacing="1" cellpadding="2" width="100%" height="100%" border="0">
			<tr>
			<td class="color-row" height="30" valign="top">
				<cfform name="search_form" action="#request.self#?fuseaction=report.envanter_raporu" method="post">
				<table>
					<cfoutput>
					<tr> 
						<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
						<td><cf_get_lang dictionary_id='57544.Sorumlu'></td>
						<td>
							<input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.employee) and len(attributes.pos_code)>#attributes.pos_code#</cfif>">
							<input type="text" name="employee" id="employee" style="width:110px;" value="<cfif len(attributes.employee) and len(attributes.pos_code)>#attributes.employee#</cfif>" maxlength="255">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=search_form.pos_code&field_name=search_form.employee&select_list=1&keyword='+encodeURIComponent(document.search_form.employee.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						<td><cf_get_lang dictionary_id='29533.Tedarikçi'></td>
						<td>
							<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company_id#</cfif>">
							<input type="text" name="company" id="company" style="width:110px;" value="<cfif len(attributes.company_id) and len(attributes.company)>#attributes.company#</cfif>">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_name=search_form.company&field_comp_id=search_form.company_id&select_list=2&keyword='+encodeURIComponent(document.search_form.company.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
						<td><cf_get_lang dictionary_id='57486.Kategori'></td>
						<td>
							<input type="hidden" name="product_code" id="product_code" value="#attributes.product_code#">
							<input type="text" name="product_cat" id="product_cat" style="width:110px;" value="#attributes.product_cat#">
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_form.product_code&field_name=search_form.product_cat&keyword='+encodeURIComponent(document.search_form.product_cat.value));">
							<img src="/images/plus_thin.gif" border="0" title="Ürün Kategorisi Ekle!" align="absmiddle"></a>
						</td>
						<td><cf_get_lang dictionary_id='58847.Marka'></td>
						<td>
						<input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>#attributes.brand_id#</cfif>">
						<input type="text" name="brand_name" id="brand_name" value="<cfif isdefined("attributes.brand_name") and len(attributes.brand_name)>#attributes.brand_name#</cfif>" style="width:140px;">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_brands&brand_id=search_form.brand_id&brand_name=search_form.brand_name&keyword='+encodeURIComponent(document.search_form.brand_name.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						</td>
					</cfoutput>
						<td>
							<select name="department_id" id="department_id" style="width:150px; height:17px;" class="formthin" required="yes">
								<option value="" selected><cf_get_lang dictionary_id='39208.Depolar'>
								<cfoutput  query="get_dept">
									<option value="#department_id#" <cfif  attributes.department_id eq department_id>Selected</cfif>>#DEPARTMENT_HEAD#</option>
								</cfoutput>
							</select>
						</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
							<cfinput type="text" name="date" style="width:65px;" value="#attributes.date#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
							<cf_wrk_date_image date_field="date">
						</td>
						<td>
							<cfinput type="text" name="date2" style="width:65px;" value="#attributes.date2#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
							<cf_wrk_date_image date_field="date2"> 
						</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,1000" required="yes" message="#message#"></td>
						<td><cf_workcube_buttons is_upd='0' type_format='1'></td>
					</tr>
				</table>
				</cfform>
			</td>
			</tr>
			</table>
		</td>
	</tr>
</table>
			<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border" align="center">
				<tr class="color-header" height="22"> 
					<td class="form-title"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39449.Stok Açıklaması'></td>
					<td class="form-title"><cf_get_lang dictionary_id='29896.Dönem Başı Stok'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39102.Dönem İçi Alış'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39450.Dönem İçi Alış İade'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39104.Dönem İçi Üretim'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39103.Dönem İçi Satış'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39451.Dönem İçi Satış İade'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39452.Dönem İçi Servis Giriş'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39453.Dönem İçi Servis Çıkış'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39454.Dönem İçi Sarf'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39455.Dönem İçi Fire'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39456.Dönem İçi Sayım'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39457.Dönem İçi Sayım Sıfırlama'></td>
					<td class="form-title"><cf_get_lang dictionary_id='29897.Dönem Sonu Stok'></td>
					<td class="form-title"><cf_get_lang dictionary_id='39458.Ürün Maliyeti'></td>
				</tr>
				<cfif GET_ALL_STOCK.recordcount>
				<cfoutput query="GET_ALL_STOCK" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfset donem_sonu_stok=0>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">					
		                <td><a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#GET_ALL_STOCK.PRODUCT_ID#" class="tableyazi">#GET_ALL_STOCK.STOCK_CODE#</a></td>
						<td>#GET_ALL_STOCK.URUN_ADI#</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("acilis_miktar_#STOCK_ID#") and len(evaluate("acilis_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("acilis_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("acilis_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif></td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("alis_miktar_#STOCK_ID#") and len(evaluate("alis_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("alis_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("alis_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("alis_iade_miktar_#STOCK_ID#") and len(evaluate("alis_iade_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok - evaluate("alis_iade_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("alis_iade_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("uretim_miktar_#STOCK_ID#") and len(evaluate("uretim_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("uretim_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("uretim_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("satis_miktar_#STOCK_ID#") and len(evaluate("satis_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok - evaluate("satis_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("satis_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("satis_iade_miktar_#STOCK_ID#") and len(evaluate("satis_iade_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("satis_iade_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("satis_iade_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("servis_giris_miktar_#STOCK_ID#") and len(evaluate("servis_giris_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("servis_giris_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("servis_giris_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">
							<cfif isdefined("servis_cikis_miktar_#STOCK_ID#") and len(evaluate("servis_cikis_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("servis_cikis_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("servis_cikis_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;"><cfif isdefined("sarf_miktar_#STOCK_ID#") and len(evaluate("sarf_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok - evaluate("sarf_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("sarf_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;"><cfif isdefined("fire_miktar_#STOCK_ID#") and len(evaluate("fire_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok - evaluate("fire_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("fire_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;"><cfif isdefined("sayim_miktar_#STOCK_ID#") and len(evaluate("sayim_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("sayim_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("sayim_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;"><cfif isdefined("sayim_sifir_miktar_#STOCK_ID#") and len(evaluate("sayim_sifir_miktar_#STOCK_ID#"))>
								<cfset donem_sonu_stok = donem_sonu_stok + evaluate("sayim_sifir_miktar_#STOCK_ID#")>
								#TLFormat(evaluate("sayim_sifir_miktar_#STOCK_ID#"))#
							<cfelse>-</cfif>
						</td>
						<td align="right" style="text-align:right;">#TLFormat(donem_sonu_stok)#</td>
						<td align="right" style="text-align:right;">
						<cfif isdefined("birim_maliyet_#PRODUCT_ID#") and isdefined("maliyet_para_br_#PRODUCT_ID#")>
							#TLFormat(evaluate("birim_maliyet_#PRODUCT_ID#")*donem_sonu_stok)# #evaluate("maliyet_para_br_#PRODUCT_ID#")# 
						</cfif>
						</td>
					</tr>
				</cfoutput>
				<cfelse>
					<tr class="color-list" height="22">
						<td colspan="16"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</table>
<cfif attributes.maxrows lt attributes.totalrecords>
	<cfset adres = "report.envanter_raporu">
	<cfscript>
		if(len(attributes.employee) and len(attributes.pos_code))
			adres="#adres#&employee=#attributes.employee#&pos_code=#attributes.pos_code#";
		if(len(attributes.company) and len(attributes.company_id))
			adres="#adres#&company=#attributes.company#&company_id=#attributes.company_id#";
		if(len(attributes.product_code) and len(attributes.product_cat))
			adres="#adres#&product_code=#attributes.product_code#&product_cat=#attributes.product_cat#";
		if(isdefined('attributes.brand_id') and len(attributes.brand_id) and isdefined('attributes.brand_name') and len(attributes.brand_name))
			adres="#adres#&brand_id=#attributes.brand_id#&brand_name=#attributes.brand_name#";
		adres="#adres#&date=#attributes.date#&date2=#attributes.date2#";
		adres="#adres#&department_id=#attributes.department_id#";
		adres="#adres#&is_form_submitted=#attributes.is_form_submitted#";
	</cfscript>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
			<tr>
			<td><cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"></td>
			<!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	</cfif>
</cfif>
<br/>

