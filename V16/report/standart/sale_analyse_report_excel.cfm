<cf_xml_page_edit fuseact="report.sale_analyse_report">
<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfset file_name_ = "sale_analyse_report"&"_"&TimeFormat(now(),"hhmmss")>

<cfif not directoryexists("#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_#">
</cfif>

<cfif  fileexists("#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls")>
	<cffile action="delete" file="#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls">
</cfif>

<cfset workBook = createObject("java","org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
<!---<cfset newSheet = workBook.createSheet()/>--->
<cfset format = workBook.createDataFormat()>
<cfset style = workBook.createCellStyle()>
<cfset style.setDataFormat(format.getFormat("##,##0.00"))>
<cfset style2 = workBook.createCellStyle()>
<cfset style2.setDataFormat(format.getFormat("##,##0.0000"))>


<cfset sayac = 0>
<cfset newRowNumber = 1>
<cfset agirlik = 0>
<cfset miktar_1 = 0>
<cfset miktar_2 = 0>
<cfset brt_tutar = 0>
<cfset yüzde = 0>
<cfset net_fiyat = 0>
<cfset net_tutar = 0>
<cfset birim_fiyat = 0>
<cfoutput query="get_total_purchase" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<cfset newRowNumber = newRowNumber + 1>
	<cfset sayac = sayac + 1>
	<cfif sayac mod 65000 eq 1> <!--- Her 65000 kayıtta yeni sheetler oluştursun. --->
		<cfset newSheet = workBook.createSheet()/>
		<cfset newRowNumber = newRowNumber - currentrow>
		<!--- Başlıklar --->
		<cfset a = newSheet.createRow(newRowNumber)>

		<cfset i = 0 >
		<cfset a = newSheet.createRow(1)>
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Seri No")>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Fatura No')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Fatura Tarihi')>
		<cfset i = i + 1 >
		
		<cfif isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Açıklama')>
			<cfset i = i + 1 >
		</cfif>
		
		<cfif isDefined("x_show_invoice_branch") and x_show_invoice_branch eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Şube')>
			<cfset i = i + 1 >
		</cfif>
		
		<cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Sipariş Şubesi")>
			<cfset i = i + 1 >
		</cfif>
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Gelir Merkezi")>
		<cfset i = i + 1 >
			
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Satış Yapan")>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Üye No')>
		<cfset i = i + 1 >
		
		<cfif isdefined("x_show_account_code") and x_show_account_code eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Müşteri Muhasebe Kodu")>
			<cfset i = i + 1 >
		</cfif>
		
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Müşteri')>
		<cfset i = i + 1 >
		
		<cfif attributes.is_project eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Proje')>
			<cfset i = i + 1 >
		</cfif>
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Müşteri Tipi')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Müşteri Temsilcisi')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Fiyat Listesi')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Ürün Kod')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Üretici Kodu')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Ürün')>
		<cfset i = i + 1 >
		
		
		<cfif attributes.is_spect_info eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Spec')>
			<cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Spec Id")>
			<cfset i = i + 1 >
		</cfif>
		
		<cfif is_brand_show eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Marka')>
			<cfset i = i + 1 >
		</cfif>
        
        <cfif is_short_code_show eq 1>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue('Model')>
            <cfset i = i + 1 >
        </cfif>
        
        <cfif x_show_product_code_2>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Özel Kod')>
			<cfset i = i + 1 >
		</cfif>
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("Ürün Marj")>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Vade')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Miktar')>
		<cfset i = i + 1 >
        
        <cfif x_show_second_unit>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue('2.Miktar')>
            <cfset i = i + 1 >
		</cfif>
        
        <cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Birim')>
		<cfset i = i + 1 >
        
        <cfif x_show_second_unit>
			<cfset aa= a.createCell(i)>
            <cfset aa.setCellValue('2.Birim')>
            <cfset i = i + 1 >
        </cfif>
        
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Ağırlık')>
		<cfset i = i + 1 >
		
		<cfif attributes.is_priceless eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Mal Fazlası')>
			<cfset i = i + 1 >
		</cfif>
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Birim Fiyat')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Brüt Tutar')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Net Fiyat')>
		<cfset i = i + 1 >
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('Tutar')>
		<cfset i = i + 1 >
		
		
		<cfif attributes.is_discount eq 1>
			<cfif isdefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
				  <cfloop from="1" to="#listlen(attributes.exp_discounts)#" index="disc_indx">
						<cfset aa= a.createCell(i)>
						<cfset aa.setCellValue(listgetat(attributes.exp_discounts,disc_indx))>
						<cfset i = i + 1 >	
				  </cfloop>
			</cfif>
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('İskonto Tutar')>
			<cfset i = i + 1 >	
		</cfif>
		
		<cfif attributes.is_cost_price eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Net Maliyet")>
			<cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Toplam Maliyet')>
			<cfset i = i + 1 >
		</cfif>
		
		<cfif attributes.is_profit eq 1>
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Karlılık')>
			<cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("%")>
			<cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Sapma')>
			<cfset i = i + 1 >
		</cfif>	
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue('P.Birim')>
		<cfset i = i + 1 >
		
		<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
				
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Brüt Doviz')>
			<cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue('Doviz')>
			<cfset i = i + 1 >
			
			<cfset aa= a.createCell(i)>
			<cfset aa.setCellValue("Döviz Birim Fiyat")>
			<cfset i = i + 1 >
			
			<cfif attributes.is_discount eq 1>
				<cfset aa= a.createCell(i)>
				<cfset aa.setCellValue('İsk Doviz')>
				<cfset i = i + 1 >
			</cfif>
			
			 <cfif attributes.is_cost_price eq 1>
				<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1 and attributes.is_money2 eq 1>
					<cfset aa= a.createCell(i)>
					<cfset aa.setCellValue("Net Maliyet")&session.ep.money2>
					<cfset i = i + 1 >	
					
					<cfset aa= a.createCell(i)>
					<cfset aa.setCellValue('Toplam Maliyet'&session.ep.money2)>
					<cfset i = i + 1 > 
				</cfif>
			 </cfif>
			 
			 <cfif attributes.is_cost_price eq 1 and x_show_other_money_cost eq 1 and isdefined('attributes.cost_type') and attributes.cost_type eq 1>
					<cfset aa= a.createCell(i)>
					<cfset aa.setCellValue('Döviz'&'Maliyet')>
					<cfset i = i + 1 >
					
					<cfset aa= a.createCell(i)>
					<cfset aa.setCellValue('Toplam'&'Maliyet')>
					<cfset i = i + 1 >
					
					<cfset aa= a.createCell(i)>
					<cfset aa.setCellValue('Birim')>
					<cfset i = i + 1 >   
			 </cfif>
			 
			 <cfif attributes.is_profit eq 1>
				 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue('Doviz Kar')>
				 <cfset i = i + 1 >
				 
				 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue("%")>
				 <cfset i = i + 1 >
				 
				 <cfset aa= a.createCell(i)>
				 <cfset aa.setCellValue('Sapma')>
				 <cfset i = i + 1 >    
		
			 </cfif>
			 
			 <cfset aa= a.createCell(i)>
			 <cfset aa.setCellValue('Birim')>
			 <cfset i = i + 1 > 
		</cfif>
		
		<cfif attributes.is_cost_price eq 1>
			 <cfset aa= a.createCell(i)>
			 <cfset aa.setCellValue('Marj')>
			 <cfset i = i + 1 >	
			 
			 <cfset aa= a.createCell(i)>
			 <cfset aa.setCellValue('Marj'&'Toplam')>
			 <cfset i = i + 1 >
		</cfif>
		
		<cfset aa= a.createCell(i)>
		<cfset aa.setCellValue("%")>
		<cfset i = i + 1 >
	</cfif>

	<cfset m = 0 >
    <cfset a = newSheet.createRow(newRowNumber+1)>
	
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(serial_number)>
    <cfset m = m + 1 >
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(serial_no)>
    <cfset m = m + 1 >
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(dateformat(INVOICE_DATE,dateformat_style))>
    <cfset m = m + 1 >
    
    <cfif isdefined("x_show_invoice_detail") and x_show_invoice_detail eq 1>
		<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(NOTE)>
        <cfset m = m + 1 >	
    </cfif>
    
    <cfif isDefined("x_show_invoice_branch") and x_show_invoice_branch eq 1>
        <cfif Len(department_id)>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(get_invoice_branch.branch_name[listfind(branch_id_list,department_id,',')])>
            <cfset m = m + 1 >	
        <cfelse>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue("")>
            <cfset m = m + 1 >			
        </cfif>
    </cfif>
    <cfif isDefined("x_show_order_branch") and x_show_order_branch eq 1>
    	<cfif Len(order_branch_id)>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(get_invoice_branch2.branch_name[listfind(branch_id_list2,order_branch_id,',')])>
            <cfset m = m + 1 >	
        <cfelse>	
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue("")>
            <cfset m = m + 1 >	
        </cfif>	
    </cfif>
    
    <cfquery name="get_expense_center" datasource="#dsn2#">
        SELECT 
            EXPENSE_CENTER.EXPENSE
        FROM 
            EXPENSE_ITEMS_ROWS,
            EXPENSE_CENTER
        WHERE 
            EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
            EXPENSE_ITEMS_ROWS.INVOICE_ID = #INVOICE_ID# AND
            EXPENSE_ITEMS_ROWS.ACTION_ID = #INVOICE_ROW_ID#
    </cfquery>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(get_expense_center.EXPENSE)>
    <cfset m = m + 1 >	
    
    <cfquery name="get_sale_emp" datasource="#dsn2#">
        SELECT SALE_EMP,SALE_PARTNER FROM INVOICE WHERE INVOICE_ID = #INVOICE_ID#
    </cfquery>
    <cfsavecontent variable="txt"><cfif len(get_sale_emp.sale_emp)>#get_emp_info(get_sale_emp.sale_emp,0,0)#<cfelseif len(get_sale_emp.sale_partner)>#get_par_info(get_sale_emp.sale_partner,1,-1,0)#</cfif></cfsavecontent>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(txt)>
    <cfset m = m + 1 >	
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(UYE_NO)>
    <cfset m = m + 1 >	
    
    <cfif isdefined("x_show_account_code") and x_show_account_code eq 1>
   		<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(account_code)>
        <cfset m = m + 1 >		
    </cfif>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(MUSTERI)>
    <cfset m = m + 1 >	
	<!---Buraya dikkat --->
	<cfif attributes.is_project eq 1>
		<cfif len(get_total_purchase.row_project_id) and listfind(project_id_list,get_total_purchase.row_project_id,',')>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(get_project.project_head[listfind(project_id_list,get_total_purchase.row_project_id,',')])>
            <cfset m = m + 1 >	
        <cfelseif len(get_total_purchase.project_id) and listfind(project_id_list,get_total_purchase.project_id,',')>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')])>
            <cfset m = m + 1 >	
        <cfelse> 
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(get_project.project_head[listfind(project_id_list,get_total_purchase.project_id,',')])>
            <cfset m = m + 1 >	
    	</cfif> 
    </cfif>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(KATEGORI)>
    <cfset m = m + 1 >
    
    <cfif len(company_id) and company_id gt 0 and len(company_list)>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(get_pos_name.employee_name[listfind(company_list,company_id,',')] & get_pos_name.employee_surname[listfind(company_list,company_id,',')] )>
        <cfset m = m + 1 >
    <cfelseif len(consumer_id) and consumer_id gt 0 and len(consumer_list)>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(get_pos_name_2.employee_name[listfind(consumer_list,consumer_id,',')] & get_pos_name_2.employee_surname[listfind(consumer_list,consumer_id,',')])>
        <cfset m = m + 1 >
    <cfelse>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue("")>
        <cfset m = m + 1 >	
    </cfif>
    
    
    <cfif len(price_cat_list) and len(price_cat) and price_cat gt 0>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(get_price_cat.price_cat[listfind(price_cat_list,price_cat,',')])>
        <cfset m = m + 1 >	
    <cfelseif price_cat eq -2>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue("Standart Satış")>
        <cfset m = m + 1 >	
    <cfelseif price_cat eq -1>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue("Standart Alış")>
        <cfset m = m + 1 >	
    <cfelse>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue("")>
        <cfset m = m + 1 >	
    </cfif>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(STOCK_CODE)>
    <cfset m = m + 1 >
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(MANUFACT_CODE)>
    <cfset m = m + 1 >	
    
    <cfif session.ep.isBranchAuthorization>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(PRODUCT_NAME & PROPERTY)>
        <cfset m = m + 1 >
    <cfelse>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(PRODUCT_NAME & PROPERTY)>
        <cfset m = m + 1 >
    </cfif>
    
    <cfif attributes.is_spect_info eq 1>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(spect_var_name)>
        <cfset m = m + 1 >
        
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(spect_main_id)>
        <cfset m = m + 1 >
    </cfif>
    
    <cfif is_brand_show eq 1>
		<cfif isdefined("get_brand.brand_name") and len(get_brand.brand_name) and listfind(brand_id_list_new,get_total_purchase.brand_id,',')>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue(get_brand.brand_name[listfind(brand_id_list_new,get_total_purchase.brand_id,',')])>
            <cfset m = m + 1 >
        <cfelse>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue("")>
            <cfset m = m + 1 >	
        </cfif>
    </cfif>
    
    <!---Model--->
    <cfif is_short_code_show eq 1>
		<cfif len(short_code_id) and len(short_code_id_list)>
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(get_model.MODEL_NAME[listfind(short_code_id_list,short_code_id,',')])>
            <cfset m = m + 1 >
		<cfelse>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue("")>
            <cfset m = m + 1 >            
        </cfif>
    </cfif>
    
    <!---Özel Kod--->
    <cfif x_show_product_code_2>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(product_code_2)>
        <cfset m = m + 1 >
    </cfif>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(MIN_MARGIN)>
    <cfset m = m + 1 >
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(due_date)>
    <cfset m = m + 1 >
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(PRODUCT_STOCK)>
    <cfset aa.setCellStyle(style2)>
    <cfset m = m + 1 >
    <cfset miktar_1 = miktar_1 + PRODUCT_STOCK>
    
    <!--- 2.Miktar --->
    <cfif x_show_second_unit>
		<cfif len(MULTIPLIER_AMOUNT_2) and len(PRODUCT_STOCK)>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue(PRODUCT_STOCK/MULTIPLIER_AMOUNT_2)>
            <cfset m = m + 1 >
            <cfset miktar_2 = miktar_2 + PRODUCT_STOCK/MULTIPLIER_AMOUNT_2>
        <cfelse>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue("")>
            <cfset m = m + 1 >            
        </cfif>
    </cfif>
    
    <!---Birim--->
    <cfif len(birim)>
		<cfset aa= a.createCell(m)>
        <cfset aa.setCellValue(birim)>
        <cfset m = m + 1 >
    <cfelse>
        <cfset aa= a.createCell(m)>
        <cfset aa.setCellValue("")>
        <cfset m = m + 1 >            
    </cfif>
     
	<!---2.Birim --->
    <cfif x_show_second_unit>
		<cfif len(unit2)>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue(unit2)>
            <cfset m = m + 1 >
        <cfelse>
            <cfset aa= a.createCell(m)>
            <cfset aa.setCellValue("")>
            <cfset m = m + 1 >            
        </cfif>
    </cfif>
    
    <!--- Ağırlık --->
    <cfif len(UNIT_WEIGHT_1) and len(PRODUCT_STOCK)>
		<cfset aa= a.createCell(m)>
        <cfset aa.setCellValue(UNIT_WEIGHT_1*PRODUCT_STOCK)>
        <cfset m = m + 1 >
        <cfset agirlik = agirlik + (UNIT_WEIGHT_1*PRODUCT_STOCK)>
    <cfelse>
        <cfset aa= a.createCell(m)>
        <cfset aa.setCellValue("")>
        <cfset m = m + 1 >            
    </cfif>
    
    <!---Hesaplama--->
    <cfif len(priceless_amount)>
    	<cfset toplam_bedelsiz = toplam_bedelsiz + priceless_amount>
    </cfif>
    <cfif product_stock neq 0>
        <cfset toplam_net_fiyat=toplam_net_fiyat+(nettotal_row/product_stock)>
    <cfelse>
        <cfset toplam_net_fiyat=toplam_net_fiyat+(nettotal_row)>
    </cfif>
    
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(PRICE_ROW)>
    <cfset aa.setCellStyle(style)>
    <cfset m = m + 1 >
    <cfset birim_fiyat = birim_fiyat + PRICE_ROW>
    
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(GROSSTOTAL)>
    <cfset aa.setCellStyle(style)>
    <cfset m = m + 1 >
    <cfset brt_tutar = brt_tutar + GROSSTOTAL>
    
    <!---Hesaplama--->
    <cfif len(GROSSTOTAL)><cfset toplam_brut=GROSSTOTAL+toplam_brut></cfif>
    
    <cfif product_stock neq 0>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(nettotal_row/product_stock)>
        <cfset aa.setCellStyle(style)>
        <cfset m = m + 1 >
        <cfset net_fiyat =  + net_fiyat + (nettotal_row/product_stock)>
    <cfelse>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(nettotal_row)>
        <cfset aa.setCellStyle(style)>
        <cfset m = m + 1 >
        <cfset net_fiyat = net_fiyat + nettotal_row>
    </cfif>
    
    <cfset aa= a.createCell(m)>
	<cfset aa.setCellValue(PRICE)>
    <cfset aa.setCellStyle(style)>
    <cfset m = m + 1 >
    <cfset net_tutar = net_tutar + PRICE>
    
    <!---Hesaplama--->
    <cfif len(PRICE)><cfset toplam_satis=PRICE+toplam_satis></cfif>
    
    <cfif attributes.is_discount eq 1>
    
		<cfif isdefined("attributes.exp_discounts") and len(attributes.exp_discounts)>
            <cfset total_disc = 0>
            <cfloop from="1" to="10" index="disc_indx">
                <cfif disc_indx eq 1>
                    <cfset "disc_amount_#disc_indx#" = GROSSTOTAL_NEW*evaluate("DISCOUNT#disc_indx#")/100>
                    <cfset total_disc = GROSSTOTAL_NEW*evaluate("DISCOUNT#disc_indx#")/100>
                <cfelse>
                    <cfset "disc_amount_#disc_indx#" = (GROSSTOTAL_NEW - total_disc)*evaluate("DISCOUNT#disc_indx#")/100>
                    <cfset total_disc = total_disc + (GROSSTOTAL_NEW - total_disc)*evaluate("DISCOUNT#disc_indx#")/100>
                </cfif>									
            </cfloop>
            <cfloop from="1" to="#listlen(attributes.exp_discounts)#" index="disc_indx">
                <cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(evaluate("disc_amount_#listgetat(attributes.exp_discounts,disc_indx)#"))>
                <cfset aa.setCellStyle(style)>
                <cfset m = m + 1 >
                <cfset "total_discount_#listgetat(attributes.exp_discounts,disc_indx)#" = evaluate("total_discount_#listgetat(attributes.exp_discounts,disc_indx)#") + evaluate("disc_amount_#listgetat(attributes.exp_discounts,disc_indx)#")>
            </cfloop>
        </cfif>
    	<cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(DISCOUNT)>
        <cfset aa.setCellStyle(style)>
        <cfset m = m + 1 >
    	<cfif len(DISCOUNT)><cfset toplam_isk_tutar = DISCOUNT+toplam_isk_tutar></cfif>
    </cfif>
    <cfif not isdefined("cost_price_2")>
    	<cfset cost_price_2 = 0>
    </cfif>
    <cfif attributes.is_cost_price eq 1>
    	 <cfif not len(cost_price)><cfset row_cost_price= 0><cfelse><cfset row_cost_price= cost_price></cfif>
         <cfif not len(cost_price_2)><cfset row_cost_price_2= 0><cfelse><cfset row_cost_price_2= cost_price_2></cfif>
         <cfif not len(margin)><cfset row_margin= 0><cfelse><cfset row_margin= margin></cfif>
    	 <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(row_cost_price)>
         <cfset aa.setCellStyle(style)>
    	 <cfset m = m + 1 >
         
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(row_cost_price*PRODUCT_STOCK)>
         <cfset aa.setCellStyle(style)>
    	 <cfset m = m + 1 >
		 <cfif not isdefined("toplam_cost_price_2")>
         	<cfset toplam_cost_price_2 =0>
         </cfif>
         
         <cfset toplam_cost_price=toplam_cost_price+row_cost_price>
		 <cfset toplam_cost_price_2=toplam_cost_price_2+row_cost_price_2>
         <cfset toplam_marj_all=toplam_marj_all+(row_margin*row_cost_price*PRODUCT_STOCK/100)>
         <cfset toplam_cost_price_all=toplam_cost_price_all+(row_cost_price*PRODUCT_STOCK)>
         <cfset toplam_cost_price_all_2=toplam_cost_price_all_2+(row_cost_price_2*PRODUCT_STOCK)>
    </cfif>	
    <cfif attributes.is_profit eq 1>
    	 
		 <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(NET_KAR)>
         <cfset aa.setCellStyle(style)>
    	 <cfset m = m + 1 >	
    	 
		 <cfif len(NET_KAR)> <cfset toplam_karlilik = NET_KAR+toplam_karlilik></cfif>
    
    	<cfif butun_kar neq 0 and len(NET_KAR)>
        	 <cfset aa= a.createCell(m)>
			 <cfset aa.setCellValue(Replace(NumberFormat(NET_KAR*100/butun_kar,"00.00"),".",","))>
             <cfset aa.setCellStyle(style)>
             <cfset m = m + 1 >
        <cfelse>
        	 <cfset aa= a.createCell(m)>
			 <cfset aa.setCellValue("")>
             <cfset m = m + 1 >	
        </cfif>
    	
        <cfif PRICE neq 0 and len(NET_KAR)>
        	 <cfset aa= a.createCell(m)>
			 <cfset aa.setCellValue((NET_KAR*100)/PRICE)>
             <cfset aa.setCellStyle(style)>
             <cfset m = m + 1 >
        <cfelse>
        	<cfset aa= a.createCell(m)>
			 <cfset aa.setCellValue("")>
             <cfset m = m + 1 >
        </cfif>
        
    
    </cfif>
    
     <cfset aa= a.createCell(m)>
	 <cfset aa.setCellValue(session.ep.money)>
     <cfset m = m + 1 >
   
	<cfif attributes.is_other_money eq 1 or attributes.is_money2 eq 1>
    	 <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(GROSSTOTAL_DOVIZ)>
         <cfset aa.setCellStyle(style)>
         <cfset m = m + 1 >
    	 <cfif len(GROSSTOTAL_DOVIZ)><cfset toplam_brut_doviz = GROSSTOTAL_DOVIZ+toplam_brut_doviz></cfif>
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(PRICE_DOVIZ)>
         <cfset aa.setCellStyle(style)>
         <cfset m = m + 1 >
         <cfif len(PRICE_DOVIZ)><cfset toplam_doviz = PRICE_DOVIZ+toplam_doviz></cfif>
         
         <cfset aa= a.createCell(m)>
		 <cfset aa.setCellValue(PRICE_ROW_OTHER)>
         <cfset aa.setCellStyle(style)>
         <cfset m = m + 1 >
         
         <cfif attributes.is_discount eq 1>
         	 <cfset aa= a.createCell(m)>
			 <cfset aa.setCellValue(DISCOUNT_DOVIZ)>
             <cfset aa.setCellStyle(style)>
             <cfset m = m + 1 >	
             <cfif len(DISCOUNT_DOVIZ)><cfset toplam_isk_doviz = DISCOUNT_DOVIZ+toplam_isk_doviz></cfif>
         </cfif>
    	 <cfif attributes.is_cost_price eq 1>
         	<cfif isdefined('attributes.cost_type') and attributes.cost_type eq 1 and attributes.is_money2 eq 1>
         		<cfset aa= a.createCell(m)>
			    <cfset aa.setCellValue(row_cost_price_2)>
                <cfset aa.setCellStyle(style)>
                <cfset m = m + 1 >
                
                <cfset aa= a.createCell(m)>
			    <cfset aa.setCellValue(row_cost_price_2*PRODUCT_STOCK)>
                <cfset aa.setCellStyle(style)>
                <cfset m = m + 1 >
    	
    		</cfif>
    	</cfif>
        <cfif attributes.is_cost_price eq 1 and x_show_other_money_cost eq 1 and isdefined('attributes.cost_type') and attributes.cost_type eq 1>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(cost_price_other)>
            <cfset aa.setCellStyle(style)>
            <cfset m = m + 1 >
            
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(cost_price_other*PRODUCT_STOCK)>
            <cfset aa.setCellStyle(style)>
            <cfset m = m + 1 >
            
            <cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(cost_price_money)>
            <cfset m = m + 1 >

	
        </cfif>
        
        <cfif attributes.is_profit eq 1>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(NET_KAR_DOVIZ)>
            <cfset aa.setCellStyle(style)>
            <cfset m = m + 1 >	
        	<cfif len(NET_KAR_DOVIZ)><cfset toplam_doviz_kar = NET_KAR_DOVIZ+toplam_doviz_kar></cfif>
        
        	<cfif diger_butun_kar neq 0>
				<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue(Replace(NumberFormat(NET_KAR_DOVIZ*100/diger_butun_kar,"00.00"),".",","))>
                <cfset aa.setCellStyle(style)>
                <cfset m = m + 1 >
            <cfelse>
            	<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue("")>
                <cfset m = m + 1 >	
            </cfif>
			<cfif PRICE_DOVIZ neq 0>
            	<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue((NET_KAR_DOVIZ*100)/PRICE_DOVIZ)>
                <cfset aa.setCellStyle(style)>
                <cfset m = m + 1 >	
            <cfelse>
            	<cfset aa= a.createCell(m)>
                <cfset aa.setCellValue("")>
                <cfset m = m + 1 >
            </cfif>
        </cfif>

		<cfif attributes.is_other_money eq 1>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(OTHER_MONEY)>
            <cfset m = m + 1 >
        <cfelse>
        	<cfset aa= a.createCell(m)>
			<cfset aa.setCellValue(session.ep.money2)>
            <cfset m = m + 1 > 
        </cfif>
    
    </cfif>
    
    <cfif attributes.is_cost_price eq 1>
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(row_margin)>
        <cfset aa.setCellStyle(style)>
        <cfset m = m + 1 >
        
        <cfset aa= a.createCell(m)>
		<cfset aa.setCellValue(row_margin*row_cost_price*PRODUCT_STOCK/100)>
        <cfset aa.setCellStyle(style)>
        <cfset m = m + 1 > 
        
    </cfif>
        
	<cfif butun_toplam neq 0>
        <cfset aa= a.createCell(m)>
        <cfset aa.setCellValue(Replace(NumberFormat(PRICE*100/butun_toplam,"00.00"),".",","))>
        <cfset aa.setCellStyle(style)>
        <cfset m = m + 1 >
        <cfset yüzde = yüzde + (PRICE*100/butun_toplam)>
    <cfelse>
        <cfset aa= a.createCell(m)>
        <cfset aa.setCellValue("")>
        <cfset m = m + 1 >
    </cfif>
</cfoutput> 
<!--- Dip Toplam MT 06112015 --->
<cfset birim1 = valuelist(get_total_purchase.BIRIM)>
<cfset birim1 = listdeleteduplicates(birim1)>
<cfset birim2 = valuelist(get_total_purchase.unit2)>
<cfset birim2 = listdeleteduplicates(birim2)>

<cfset m = 0 >
<cfset a = newSheet.createRow(newRowNumber+2)>
<cfloop from="1" to="21" index="cc">
	<cfset aa= a.createCell(m)>
    <cfset aa.setCellValue("")>
    <cfset m = m + 1>
</cfloop>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue("Toplam")>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(miktar_1,4))>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(miktar_2,4))>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(birim1)>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(birim2)>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(agirlik,4))>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(birim_fiyat,4))>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(brt_tutar,4))>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(net_fiyat,4))>
<cfset m = m + 1> 

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(net_tutar,4))>
<cfset m = m + 1> 

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(session.ep.money)>
<cfset m = m + 1>

<cfset aa= a.createCell(m)>
<cfset aa.setCellValue(Tlformat(yüzde,4))>
<cfset m = m + 1>  

<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#download_folder#documents#dir_seperator#reserve_files#dir_seperator##drc_name_##dir_seperator##file_name_#.xls")/>
<cfset workBook.write(fileOutStream)/>
<cfset fileOutStream.flush()/>
<cfset fileOutStream.close()/>
