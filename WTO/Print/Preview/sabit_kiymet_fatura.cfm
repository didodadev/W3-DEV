<cfif isdefined("attributes.action_id")>
	<cfset attributes.iid = attributes.action_id>
</cfif>
<cfquery name="GET_SALE_DET" datasource="#dsn2#">
	SELECT
		I.COMPANY_ID,
		I.CONSUMER_ID,
		I.INVOICE_DATE,
		I.INVOICE_NUMBER,
		I.SA_DISCOUNT,
		I.DUE_DATE,
		I.RECORD_DATE,
		I.GROSSTOTAL AS GRS,
		I.SHIP_ADDRESS,
		I.TAXTOTAL AS INVOICE_TAX,
		I.NETTOTAL AS INV_NETTOTAL,
		I.OTHER_MONEY_VALUE AS OMV,
		I.NOTE,
		I.INVOICE_CAT,
		IR.DESCRIPTION,
		IR.INVOICE_ID,
		IR.PRODUCT_ID,
		IR.NAME_PRODUCT,
		IR.AMOUNT,
		IR.NETTOTAL,
		IR.DISCOUNTTOTAL,
		IR.DISCOUNT1,
		IR.DISCOUNT2,
		IR.DISCOUNT3,
		IR.PRICE,
		IR.TAX,
		IR.TAXTOTAL,
		IR.UNIT,
		I.OTHER_MONEY,
		IR.OTHER_MONEY_VALUE,
		IR.GROSSTOTAL
	FROM
		INVOICE I,
		INVOICE_ROW IR
	WHERE
		<cfif not isdefined('attributes.id')>
		IR.INVOICE_ID= #attributes.iid#
		<cfelse>
		IR.INVOICE_ID= #attributes.id#
		</cfif>
		AND I.INVOICE_ID =IR.INVOICE_ID
</cfquery>

<!---irsaliye fiili sevk tarihi --->
<cfquery name="get_invoice_ship" datasource="#dsn2#">
	SELECT 
		DELIVER_DATE,
		S.SHIP_NUMBER,
		S.SHIP_DATE,
		S.SHIP_ID
	FROM 
		INVOICE_SHIPS ISS,
		SHIP S 
	WHERE 
		ISS.SHIP_ID = S.SHIP_ID  
		AND INVOICE_ID=#attributes.iid#
</cfquery>

<cfif len(get_sale_det.COMPANY_ID) and get_sale_det.COMPANY_ID neq 0>
	<cfquery name="GET_SALE_DET_COMP" datasource="#dsn#">
		SELECT
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			COUNTY,
			CITY,
			COUNTRY,
			FULLNAME,
			SEMT,
			MEMBER_CODE
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID=#GET_SALE_DET.COMPANY_ID#
	</cfquery>
<cfelseif len(GET_SALE_DET.CONSUMER_ID) and get_sale_det.CONSUMER_ID neq 0>
	<cfquery name="GET_CONS_NAME" datasource="#dsn#">
		SELECT 
			WORKADDRESS,
			TAX_NO,
			TAX_OFFICE,
			WORK_COUNTY_ID,
			WORK_CITY_ID,
			WORK_COUNTRY_ID,
			MEMBER_CODE
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID=#GET_SALE_DET.CONSUMER_ID#
	</cfquery>		
</cfif>
<cfscript>
	sepet.kdv_array = ArrayNew(2);
	invoice_bill_upd = arraynew(2);
	county_name='';
	country_name='';
	city_name='';
	satir_sayisi=0;
	sayfa_sayisi=22;
	urun = "";
	i=1;
	ara_toplam=0;
	son_toplam=0;
	indirim = 0;
	fatura_toplam= 0;
	vade = 0;
	sayfa_toplam = 0;
	devreden_toplam = 0;
	all_total=0;
	toplam_indirim = 0;
	son_tax_total = 0;
	if(len(get_sale_det.CONSUMER_ID) and get_sale_det.CONSUMER_ID neq 0)
	{
		fatura_verilen = get_cons_info(GET_SALE_DET.CONSUMER_ID,0,0);
		adres = get_cons_name.workaddress;
		vergi_no = get_cons_name.tax_no;
		vergi_dairesi = get_cons_name.tax_office;
		county_id = get_cons_name.work_county_id;
		city_id = get_cons_name.work_city_id;
		country_id = get_cons_name.work_country_id;
		uye_kodu = get_cons_name.member_code;
	}
	else if (len(get_sale_det.company_id) and get_sale_det.company_id neq 0)
	{
		fatura_verilen = get_sale_det_comp.fullname;
		adres = get_sale_det_comp.company_address;
		vergi_no = get_sale_det_comp.taxno;
		vergi_dairesi = get_sale_det_comp.taxoffice;
		county_id = get_sale_det_comp.county;
		city_id = get_sale_det_comp.city;
		country_id = get_sale_det_comp.country;
		uye_kodu = get_sale_det_comp.member_code;
	}
	else
	{
		fatura_verilen = "";
		adres = "";
		vergi_no = "";
		vergi_dairesi = "";
		county_id = "";
		city_id = "";
		country_id = "";
		uye_kodu = "";
	}
</cfscript>
<cfif len(county_id)>
	 <cfquery name="GET_COUNTY" datasource="#dsn#">
		SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #county_id#
	 </cfquery>
	 <cfset county_name=GET_COUNTY.COUNTY_NAME>
</cfif>
<cfif len(city_id)>
	  <cfquery name="GET_CITY" datasource="#dsn#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #city_id#
	  </cfquery>
	  <cfset city_name=GET_CITY.CITY_NAME>
</cfif>
<cfif len(country_id)>
	  <cfquery name="GET_COUNTRY" datasource="#dsn#">
		SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #country_id#
	  </cfquery> 
	  <cfset country_name=GET_COUNTRY.COUNTRY_NAME>
</cfif>
<cfif len(get_sale_det.due_date) and len(get_sale_det.invoice_date)>
	<cfset vade = datediff('d',get_sale_det.invoice_date,get_sale_det.due_date)>
<cfelse>
	<cfset vade = ''> 
</cfif>
<cfoutput query="get_sale_det">
	<cfset invoice_bill_upd[currentrow][2] = "#description#" >
	<cfset invoice_bill_upd[currentrow][4] = amount>
	<cfset invoice_bill_upd[currentrow][5] = unit>
	<cfset invoice_bill_upd[currentrow][6] = price>	
	<cfset invoice_bill_upd[currentrow][15] = amount*price>
	<cfset invoice_bill_upd[currentrow][16] = nettotal>	
	<cfset invoice_bill_upd[currentrow][18] = grosstotal>
	<cfset invoice_bill_upd[currentrow][17] = taxtotal>
	<cfset invoice_bill_upd[currentrow][19] = 0 >
	<cfset invoice_bill_upd[currentrow][20] = 0 > 
	<cfset invoice_bill_upd[currentrow][27] = 0 >
	<cfset invoice_bill_upd[currentrow][28] = 0 >
	<cfif len(TAX)>
		<cfset invoice_bill_upd[currentrow][7] = TAX>
		<!--- <cfset invoice_bill_upd[currentrow][17] = satir_tax_tutar> --->
		<cfelse>
			<cfif nettotal neq 0>
				<cfset invoice_bill_upd[currentrow][7] = (taxtotal/nettotal)*100 >
			<cfelse>	
				<cfset invoice_bill_upd[currentrow][7] = 0>
			</cfif>
	</cfif>	
	<cfset son_tax_total =	son_tax_total + taxtotal>
	<cfscript>
	kdv_flag = 0;
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
	{
		if (sepet.kdv_array[k][1] eq invoice_bill_upd[currentrow][7])
		{
			kdv_flag = 1;
			sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + invoice_bill_upd[currentrow][17];				
		}
	}
	if (not kdv_flag)
	{
		sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = invoice_bill_upd[currentrow][7];
		sepet.kdv_array[arraylen(sepet.kdv_array)][2] = invoice_bill_upd[currentrow][17];
	}	
	</cfscript>
	<cfset son_toplam=son_toplam+nettotal+taxtotal>
	<cfset fatura_toplam = fatura_toplam + (amount*price)>
	 <cfset sayfa_toplam = sayfa_toplam + nettotal>
	 <cfset urun = invoice_bill_upd[currentrow][2]>
</cfoutput>

<cfparam name="attributes.mode" default=22>
<cfscript>
	sayfa_toplam = 0;
	devreden_toplam = 0;	
</cfscript>

<cfloop from="1" to="#arraylen(invoice_bill_upd)#" index="i">
<cfif ((i mod attributes.mode eq 1)) or (i eq 1)>
	<cf_woc_header>
		<cf_woc_elements>
            <cf_wuxi id="tax_adm" data="#vergi_dairesi#" label="58762" type="cell">
			<cf_wuxi id="tax_no" data="#vergi_no#" label="57752" type="cell">

			<cf_wuxi id="comp" data="#fatura_verilen#" label="57519" type="cell">
			<cf_wuxi id="address" data="#adres#" label="58723" type="cell">
			<cf_wuxi id="cou_name" data="#county_name#" label="52664" type="cell">
			<cf_wuxi id="city_name" data="#city_name#" label="52661" type="cell">

			<cf_wuxi id="inv_date" data="#dateformat(get_sale_det.invoice_date,'dd.mm.yyyy')#" label="58759" type="cell">
			<cf_wuxi id="seri_num" data="#get_sale_det.invoice_number#" label="57637" type="cell">
			<cfif len(vade)><cf_wuxi id="maturity" data="#vade#" label="57640" type="cell"></cfif>
			<cf_wuxi id="waybill_no" data="#get_invoice_ship.ship_number#" label="58138" type="cell">
			<cf_wuxi id="pro_date" data="#dateformat(get_invoice_ship.ship_date,'dd.mm.yyyy')#" label="57879" type="cell">
		</cf_woc_elements>

		<cf_woc_elements>
			<cf_woc_list id="abc">
				<thead>
					<tr>
						<cf_wuxi label="36199" type="cell" is_row="0" id="wuxi_36199"> 
						<cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
						<cf_wuxi label="57673" type="cell" is_row="0" id="wuxi_57673"> 
						<cf_wuxi label="57397" type="cell" is_row="0" id="wuxi_57397"> 
						<cf_wuxi label="57639" type="cell" is_row="0" id="wuxi_57639"> 	
						<cf_wuxi label="57636" type="cell" is_row="0" id="wuxi_57636"> 
					</tr>
				</thead>
				<tbody>
					<tr>
						<cf_wuxi data="#invoice_bill_upd[i][2]#" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#invoice_bill_upd[i][4]#" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#TLFormat(invoice_bill_upd[i][6])# #session.ep.money#" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#TLFormat(invoice_bill_upd[i][18])# #session.ep.money#" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#invoice_bill_upd[i][7]#%" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#invoice_bill_upd[i][5]#" type="cell" is_row="0" style="text-align:right"> 
					</tr>
				</tbody>
				<cfset DISC_TOTAL=0>
				<cfset DISC_TOTAL = DISC_TOTAL + (invoice_bill_upd[i][15] - invoice_bill_upd[i][18])>
				<cfset sayfa_toplam = sayfa_toplam + invoice_bill_upd[i][18]>		
			</cf_woc_list>
			<cf_woc_list id="def">
				<thead>
					<tr>
						<cf_wuxi label="38878" type="cell" is_row="0" id="wuxi_38878"> 
						<cf_wuxi label="55447" type="cell" is_row="0" id="wuxi_55447"> 
						<cf_wuxi label="57639" type="cell" is_row="0" id="wuxi_57639"> 
						<cf_wuxi label="57643" type="cell" is_row="0" id="wuxi_57643"> 
						<cf_wuxi label="57680" type="cell" is_row="0" id="wuxi_57680"> 	
					</tr>
				</thead>
				<tbody>
					<tr>
						<cf_wuxi data="#TLFormat(devreden_toplam)#" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#TLFormat(sayfa_toplam)#" type="cell" is_row="0" style="text-align:right"> 
			
						<cfoutput>
						<cfif get_sale_det.nettotal gt 0 and get_sale_det.taxtotal gt 0>
							<cfset kdvcarpan = 1- (GET_SALE_DET.SA_DISCOUNT/(GET_SALE_DET.NETTOTAL-GET_SALE_DET.TAXTOTAL+GET_SALE_DET.SA_DISCOUNT))>
								<cfloop from="1" to="#arraylen(sepet.kdv_array)#" index="m">
									<cf_wuxi data="#TLFormat(sepet.kdv_array[m][2]*kdvcarpan)#" type="cell" is_row="0" style="text-align:right"> 
								</cfloop>
						</cfif>
						</cfoutput>
						
						<cf_wuxi data="#TLFormat(son_tax_total)#" type="cell" is_row="0" style="text-align:right"> 
						<cf_wuxi data="#TLFormat(get_sale_det.inv_nettotal)#" type="cell" is_row="0" style="text-align:right"> 
					</tr>
				</tbody>
			</cf_woc_list>
			<td>
				<strong><cf_get_lang dictionary_id='30017.Yalnız'> : </strong>
				<cfset mynumber = get_sale_det.inv_nettotal>
				<cf_n2txt number="mynumber"> <cfoutput>#mynumber#</cfoutput> 'dir.
			</td>
        </cf_woc_elements>
	<cf_woc_footer>
</cfif>
</cfloop>
