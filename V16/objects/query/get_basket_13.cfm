<cfquery name="GET_FIS_DETAIL" datasource="#dsn2#">
	SELECT
		SF.*,
        SF.BASKET_EMPLOYEE_ID,
		S.*
	FROM
		STOCK_FIS_ROW SF,
		#dsn3_alias#.STOCKS S
	WHERE
		SF.FIS_ID=#attributes.UPD_ID# AND
		SF.STOCK_ID=S.STOCK_ID
	ORDER BY
		STOCK_FIS_ROW_ID
</cfquery>
<cfset row_project_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_FIS_DETAIL.ROW_PROJECT_ID)),'numeric','asc',',')>
<cfif len(row_project_id_list_)>
	<cfquery name="GET_ROW_PROJECTS" datasource="#dsn#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#row_project_id_list_#) ORDER BY PROJECT_ID
	</cfquery>
	<cfset row_project_id_list_=valuelist(GET_ROW_PROJECTS.PROJECT_ID)>
</cfif>
<cfset row_work_id_list_=listsort(ListDeleteDuplicates(valuelist(GET_FIS_DETAIL.ROW_WORK_ID)),'numeric','asc',',')>
<cfif len(row_work_id_list_)>
	<cfquery name="GET_ROW_WORKS" datasource="#dsn#">
		SELECT WORK_HEAD,WORK_ID FROM PRO_WORKS WHERE WORK_ID IN (#row_work_id_list_#) ORDER BY WORK_ID
	</cfquery>
	<cfset row_work_id_list_=valuelist(GET_ROW_WORKS.WORK_ID)>
</cfif>
<cfset basket_emp_id_list=listsort(ListDeleteDuplicates(valuelist(GET_FIS_DETAIL.BASKET_EMPLOYEE_ID)),'numeric','asc',',')>
<cfif len(basket_emp_id_list)>
	<cfquery name="GET_BASKET_EMPLOYEES" datasource="#dsn#">
		SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS BASKET_EMPLOYEE, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#basket_emp_id_list#) ORDER BY EMPLOYEE_ID
	</cfquery>
	<cfset basket_emp_id_list = valuelist(GET_BASKET_EMPLOYEES.EMPLOYEE_ID)>
</cfif>
<cfscript>
	sepet = StructNew();
	sepet.satir = ArrayNew(1);
	sepet.kdv_array = ArrayNew(2);
	sepet.total = 0;
	sepet.toplam_indirim = 0;
	sepet.total_tax = 0;
	sepet.net_total = 0;
	sepet.genel_indirim = 0;
</cfscript>
<cfoutput query="get_fis_detail">
	<cfscript>
	i = currentrow;
	sepet.satir[i] = StructNew();
	sepet.satir[i].product_id = get_fis_detail.PRODUCT_ID;
	sepet.satir[i].is_inventory = get_fis_detail.IS_INVENTORY;
	sepet.satir[i].is_production = get_fis_detail.IS_PRODUCTION;
	sepet.satir[i].product_name = get_fis_detail.PRODUCT_NAME & " " & get_fis_detail.PROPERTY;
	sepet.satir[i].amount = AMOUNT;
	sepet.satir[i].unit = UNIT;
	if (len(unit_id))
		sepet.satir[i].unit_id = UNIT_ID;
	else
		sepet.satir[i].unit_id = get_fis_detail.PRODUCT_UNIT_ID;
	if(len(PRICE))
		sepet.satir[i].price = PRICE;	
	else
		sepet.satir[i].price = 0;
	
	//Wrk_row_id Eklendi
	if(len(get_fis_detail.WRK_ROW_ID))
		sepet.satir[i].wrk_row_id = get_fis_detail.WRK_ROW_ID;
	else
		sepet.satir[i].wrk_row_id ="WRK#i##round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)##i#";
	sepet.satir[i].wrk_row_relation_id = '';

	if(len(BASKET_EMPLOYEE_ID))
		{	
			sepet.satir[i].basket_employee_id = BASKET_EMPLOYEE_ID; 
			sepet.satir[i].basket_employee = GET_BASKET_EMPLOYEES.BASKET_EMPLOYEE[listfind(basket_emp_id_list,BASKET_EMPLOYEE_ID)]; 
		}
		else
		{		
			sepet.satir[i].basket_employee_id = '';
			sepet.satir[i].basket_employee = '';
		}
	if (not len(get_fis_detail.discount1)) sepet.satir[i].indirim1=0; else  sepet.satir[i].indirim1=get_fis_detail.discount1;
	if (not len(get_fis_detail.discount2)) sepet.satir[i].indirim2=0; else  sepet.satir[i].indirim2=get_fis_detail.discount2;
	if (not len(get_fis_detail.discount3)) sepet.satir[i].indirim3=0; else  sepet.satir[i].indirim3=get_fis_detail.discount3;
	if (not len(get_fis_detail.discount4)) sepet.satir[i].indirim4=0; else  sepet.satir[i].indirim4=get_fis_detail.discount4;
	if (not len(get_fis_detail.discount5)) sepet.satir[i].indirim5=0; else  sepet.satir[i].indirim5=get_fis_detail.discount5;
	sepet.satir[i].indirim6 = 0;
	sepet.satir[i].indirim7 = 0;
	sepet.satir[i].indirim8 = 0;
	sepet.satir[i].indirim9 = 0;
	sepet.satir[i].indirim10 = 0;
	sepet.satir[i].marj = 0;
	if (len(COST_PRICE)) sepet.satir[i].net_maliyet = COST_PRICE; else sepet.satir[i].net_maliyet=0;
	if (len(extra_cost)) sepet.satir[i].extra_cost = extra_cost; else sepet.satir[i].extra_cost =0; 
	sepet.satir[i].indirim_carpan = (100-sepet.satir[i].indirim1) * (100-sepet.satir[i].indirim2) * (100-sepet.satir[i].indirim3) * (100-sepet.satir[i].indirim4) * (100-sepet.satir[i].indirim5) * (100-sepet.satir[i].indirim6) * (100-sepet.satir[i].indirim7) * (100-sepet.satir[i].indirim8) * (100-sepet.satir[i].indirim9) * (100-sepet.satir[i].indirim10);
	if(len(UNIQUE_RELATION_ID)) sepet.satir[i].row_unique_relation_id = UNIQUE_RELATION_ID; else sepet.satir[i].row_unique_relation_id = "";
	if(len(PRODUCT_NAME2)) sepet.satir[i].product_name_other = PRODUCT_NAME2; else sepet.satir[i].product_name_other = "";
	if(len(AMOUNT2)) sepet.satir[i].amount_other = AMOUNT2; else sepet.satir[i].amount_other = "";
	if(len(UNIT2)) sepet.satir[i].unit_other = UNIT2; else sepet.satir[i].unit_other = "";
	if(len(EXTRA_PRICE)) sepet.satir[i].ek_tutar = EXTRA_PRICE; else sepet.satir[i].ek_tutar = 0;
	if(len(EXTRA_PRICE_TOTAL)) sepet.satir[i].ek_tutar_total = EXTRA_PRICE_TOTAL; else sepet.satir[i].ek_tutar_total = 0;
	if(len(EXTRA_PRICE_OTHER_TOTAL)) sepet.satir[i].ek_tutar_other_total = EXTRA_PRICE_OTHER_TOTAL; else sepet.satir[i].ek_tutar_other_total = 0;
	if(len(WIDTH_VALUE)) sepet.satir[i].row_width = WIDTH_VALUE; else sepet.satir[i].row_width = '';
	if(len(DEPTH_VALUE)) sepet.satir[i].row_depth = DEPTH_VALUE; else  sepet.satir[i].row_depth = '';
	if(len(HEIGHT_VALUE)) sepet.satir[i].row_height = HEIGHT_VALUE; else  sepet.satir[i].row_height = '';
	if(len(ROW_PROJECT_ID))
		{
			sepet.satir[i].row_project_id=ROW_PROJECT_ID;
			sepet.satir[i].row_project_name=GET_ROW_PROJECTS.PROJECT_HEAD[listfind(row_project_id_list_,ROW_PROJECT_ID)];
		}
	if(len(ROW_WORK_ID))
		{
			sepet.satir[i].row_work_id=ROW_WORK_ID;
			sepet.satir[i].row_work_name=GET_ROW_WORKS.WORK_HEAD[listfind(row_work_id_list_,ROW_WORK_ID)];
		}
	if(len(SHELF_NUMBER)) sepet.satir[i].shelf_number = SHELF_NUMBER; else sepet.satir[i].shelf_number = "";
	if(len(TO_SHELF_NUMBER)) sepet.satir[i].TO_SHELF_NUMBER = TO_SHELF_NUMBER; else sepet.satir[i].TO_SHELF_NUMBER = "";
	sepet.satir[i].stock_id = stock_id;
	sepet.satir[i].barcode = get_fis_detail.BARCOD;
	sepet.satir[i].special_code = STOCK_CODE_2;
	sepet.satir[i].stock_code = get_fis_detail.STOCK_CODE;
	sepet.satir[i].manufact_code = PRODUCT_MANUFACT_CODE;
	if( len(DUE_DATE) ) sepet.satir[i].duedate = DUE_DATE; else sepet.satir[i].duedate = 0; //vade
	sepet.satir[i].row_total = (amount*sepet.satir[i].price)+sepet.satir[i].ek_tutar_total;
	if(len(NET_TOTAL))
		sepet.satir[i].row_nettotal = wrk_round(NET_TOTAL,price_round_number);
	else 
		sepet.satir[i].row_nettotal = wrk_round((sepet.satir[i].row_total/100000000000000000000) * sepet.satir[i].indirim_carpan,price_round_number);
		//sepet.satir[i].row_nettotal = 0; IC 20050212 kaldirildi
	if(len(TOTAL_TAX))
		sepet.satir[i].row_taxtotal = TOTAL_TAX;
	else
		sepet.satir[i].row_taxtotal = wrk_round(sepet.satir[i].row_nettotal * (tax/100),price_round_number);
		//sepet.satir[i].row_taxtotal = 0; IC 20050212 kaldirildi
	if(len(NET_TOTAL))
		sepet.satir[i].row_lasttotal = sepet.satir[i].row_nettotal + sepet.satir[i].row_taxtotal;
	else
		sepet.satir[i].row_lasttotal = 0;
	sepet.satir[i].other_money = OTHER_MONEY;
	sepet.satir[i].other_money_value = 1;
	if(len(TOTAL_TAX))
		sepet.satir[i].other_money_grosstotal = TOTAL_TAX;
	else
		sepet.satir[i].other_money_grosstotal = 0;
	
	sepet.satir[i].deliver_date = dateformat(DELIVER_DATE,dateformat_style);
	if(len(RESERVE_DATE)) sepet.satir[i].reserve_date = dateformat(RESERVE_DATE,dateformat_style); else sepet.satir[i].reserve_date ='';	
	/*sepet.satir[i].deliver_date = '';*/
	sepet.satir[i].deliver_dept = ""; 
	sepet.satir[i].spect_id = spect_var_id;
	sepet.satir[i].spect_name = spect_var_name;
	sepet.satir[i].lot_no = LOT_NO;
	sepet.satir[i].price_other = PRICE_OTHER;

	if(len(TAX))
		sepet.satir[i].tax_percent = TAX;
	else
		{
		if(sepet.satir[i].price neq 0) 
			if(sepet.satir[i].row_nettotal neq 0)
				sepet.satir[i].tax_percent =(sepet.satir[i].row_taxtotal/sepet.satir[i].row_nettotal)*100; 
			else
				sepet.satir[i].tax_percent =0;
		else 
			sepet.satir[i].tax_percent=0;
		}

	sepet.total = sepet.total + wrk_round(sepet.satir[i].row_total,basket_total_round_number); //subtotal_
	sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total,price_round_number) - wrk_round(sepet.satir[i].row_nettotal,price_round_number)); //discount_
	//sepet.toplam_indirim = sepet.toplam_indirim + (wrk_round(sepet.satir[i].row_total) - wrk_round(sepet.satir[i].row_nettotal)); IC 20050212 kaldirildi
	sepet.net_total = sepet.net_total + sepet.satir[i].row_nettotal; //nettotal_

	// kdv array
		kdv_flag = 0;
		for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
			{
			if (sepet.kdv_array[k][1] eq sepet.satir[i].tax_percent)
				{
				kdv_flag = 1;
				sepet.kdv_array[k][2] = sepet.kdv_array[k][2] + 0;
				sepet.kdv_array[k][3] = sepet.kdv_array[k][3] + wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);			
				}
			}
		if (not kdv_flag)
			{
			sepet.kdv_array[arraylen(sepet.kdv_array)+1][1] = sepet.satir[i].tax_percent;
			sepet.kdv_array[arraylen(sepet.kdv_array)][2] = 0;
			sepet.kdv_array[arraylen(sepet.kdv_array)][3] = wrk_round(sepet.satir[i].row_nettotal,basket_total_round_number);
			}
	
	sepet.satir[i].assortment_array = ArrayNew(1);		
	
	</cfscript>
</cfoutput>
<cfscript>
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.kdv_array[k][2] = wrk_round(sepet.kdv_array[k][3] * sepet.kdv_array[k][1] /100,basket_total_round_number);
	
	for (k=1;k lte arraylen(sepet.kdv_array);k=k+1)
		sepet.total_tax = sepet.total_tax + sepet.kdv_array[k][2];
	sepet.net_total = sepet.net_total + sepet.total_tax;
</cfscript>
