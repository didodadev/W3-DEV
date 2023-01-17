<!--- TolgaS 20070209 
belirtilen kriterlere göre faturadan yapılmış bütce hareketleri (dagilimları) siler ve ekler --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<script type="text/javascript">
function basamak_1()
	{
	if(confirm("<cf_get_lang no ='2098.Bütçe İşlemi Yapacaksınız Emin misiniz'>?"))
		document.form_.submit();
	else 
		return false;
	}
	
function basamak_2()
	{
	if(confirm("<cf_get_lang no ='2098.Bütçe İşlemi Yapacaksınız Emin misiniz'>?"))
		document.form1_.submit();
	else
		return false;
	}
</script>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
    	PERIOD_ID, 
        PERIOD, 
        PERIOD_YEAR, 
        OUR_COMPANY_ID, 
        OTHER_MONEY, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP,
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
    	SETUP_PERIOD 
    ORDER BY 
	    OUR_COMPANY_ID,
		PERIOD_YEAR
</cfquery>

<cfif not isdefined("attributes.hedef_period")>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent  variable="head"><cf_get_lang dictionary_id='44082.Budget Transactions'></cfsavecontent>
		<cf_box title="#head#">
			<cfform name="form_" method="post" action="">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang no ='2103.Dağılım Yapılacak Tipi Seçin'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="budget_type" id="budget_type">
									<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
									<option value="0" <cfif isdefined('attributes.budget_type') and attributes.budget_type eq 0>selected</cfif>><cf_get_lang_main no ='1266.Gider'></option>
									<option value="1" <cfif isdefined('attributes.budget_type') and attributes.budget_type eq 1>selected</cfif>><cf_get_lang_main no ='1265.Gelir'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-del">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">								
								<cf_get_lang no ='2102.Yapılmış Bütçe Haraketlerini Sil'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_budget_delete" id="is_budget_delete" value="1" <cfif isdefined('attributes.is_budget_delete')>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-process">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">								
								<cf_get_lang no ='1250.Bütce İşlemi Yap'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_budget" id="is_budget" value="1" <cfif isdefined('attributes.is_budget')>checked</cfif>>
							</div>
						</div>
						<div class="form-group" id="item-start-date">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang_main no ='641.Başlangıç Tarihi'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="date1" value="#attributes.date1#" validate="#validate_style#" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-finish-date">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang_main no ='288.Bitiş Tarihi'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput type="text" name="date2" value="#attributes.date2#" validate="#validate_style#" message="#message#" style="width:65px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
								</div>								
							</div>
						</div>
						<div class="form-group" id="item-period">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<cf_get_lang no ='1784.Kaynak Dönem'>
							</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="kaynak_period_1" id="kaynak_period_1">
									<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
									<cfoutput query="get_periods">
										<option value="#period_id#" <cfif isdefined("attributes.kaynak_period_1") and attributes.kaynak_period_1 eq period_id>selected</cfif>>#period# - (#period_year#)</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<div class="ui-info-text">
							<p><font color="red"><cf_get_lang no ='2101.Bu İşlem Kaynak Yıla Ait Dönemde Bulunan Faturalarda Bütçe İşlemlerinizi Düzenler'></font></p>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><input type="button" value="<cf_get_lang_main no ='1264.Aktar'>" onClick="basamak_1();" class="pull-right"></div>
				</cf_box_footer>
			</cfform>			
		</cf_box>
	</div>	
		
</cfif>
<cfif isdefined("attributes.kaynak_period_1") and isdefined("attributes.kaynak_period_1")>
	<cfif not len(attributes.kaynak_period_1)>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2064.Kaynak Dönem Secmelisiniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>


	<cfquery name="get_kaynak_period" datasource="#dsn#">
		SELECT 
            PERIOD_ID, 
            PERIOD, 
            PERIOD_YEAR, 
            OUR_COMPANY_ID, 
            OTHER_MONEY, 
            RECORD_DATE, 
            RECORD_IP, 
            RECORD_EMP,
            UPDATE_DATE, 
            UPDATE_IP, 
            UPDATE_EMP 
        FROM 
	        SETUP_PERIOD 
        WHERE 
        	PERIOD_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.kaynak_period_1#">
	</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<div class="ui-info-text">
				<form action="" name="form1_" method="post">
					<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#get_kaynak_period.period_id#</cfoutput>">
					<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#get_kaynak_period.period_year#</cfoutput>">
					<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#get_kaynak_period.our_company_id#</cfoutput>">
					<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfoutput>#attributes.date1#</cfoutput>">
					<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfoutput>#attributes.date2#</cfoutput>">
					<cfif isdefined('attributes.is_budget_delete') and len(attributes.is_budget_delete)>
					<input type="hidden" name="aktarim_is_budget_delete" id="aktarim_is_budget_delete" value="<cfoutput>#attributes.is_budget_delete#</cfoutput>"></cfif>
					<cfif isdefined('attributes.is_budget') and len(attributes.is_budget)>
					<input type="hidden" name="aktarim_is_budget" id="aktarim_is_budget" value="<cfoutput>#attributes.is_budget#</cfoutput>"></cfif>
					<input type="hidden" name="aktarim_budget_type" id="aktarim_budget_type" value="<cfoutput>#attributes.budget_type#</cfoutput>">
					<p><cf_get_lang no ='2028.Kaynak Veri Tabanı'> : <cfoutput>#get_kaynak_period.period# (#get_kaynak_period.period_year#)</cfoutput></p><br/>
					<input type="button" value="<cf_get_lang no ='2027.Aktarımı Başlat'>" onClick="basamak_2();">
				</form>
			</div>
		</cf_box>
	</div>	
</cfif>
<cfif isdefined("attributes.aktarim_kaynak_period")>
	<cfset kaynak_dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfif isdefined('attributes.aktarim_date1') or not len(attributes.aktarim_date1)>
		<cf_date tarih='attributes.aktarim_date1'>
	</cfif>
	<cfif isdefined('attributes.aktarim_date2') or not len(attributes.aktarim_date2)>
		<cf_date tarih='attributes.aktarim_date2'>
	</cfif>
	<cfquery name="GET_PROCESS_CAT" datasource="#kaynak_dsn3#"><!--- maliyet islemi yapacak kategori varmi --->
		SELECT
			PROCESS_CAT_ID,
			PROCESS_TYPE,
			IS_BUDGET,
			IS_PROJECT_BASED_BUDGET
		FROM 
			SETUP_PROCESS_CAT
		WHERE 
			IS_BUDGET = 1
	</cfquery>
	<cfif GET_PROCESS_CAT.RECORDCOUNT>
		<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
		<cfset proc_list_budget=valuelist(GET_PROCESS_CAT.IS_PROJECT_BASED_BUDGET,',')><!--- proje basında yapıp yapmadığı --->
	<cfelse>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2100.Bütce işlemi yapması için bir işlem kategorisi seçilmemiş'>!");
			history.go(-2);
		</script>
		<cfabort>
	</cfif>
	<cfquery name="GET_INVOICE" datasource="#kaynak_dsn2#">
		SELECT 
			INVOICE.INVOICE_ID,
			INVOICE.INVOICE_NUMBER,
			INVOICE.PROCESS_CAT,
			INVOICE.INVOICE_CAT,
			INVOICE.INVOICE_DATE,
			INVOICE.DEPARTMENT_ID,
			INVOICE.PROJECT_ID,
			INVOICE.PURCHASE_SALES,
			INVOICE.RECORD_EMP,
			INVOICE.UPDATE_EMP,
			INVOICE_ROW.INVOICE_ROW_ID,
			INVOICE_ROW.STOCK_ID,
			INVOICE_ROW.PRODUCT_ID,
			INVOICE_ROW.TAX,
			INVOICE_ROW.OTV_ORAN,
			INVOICE_ROW.NETTOTAL,
			INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
			INVOICE_ROW.OTHER_MONEY_VALUE,
			INVOICE_ROW.OTHER_MONEY,
			INVOICE_ROW.BASKET_EMPLOYEE_ID,
			INVOICE_ROW.DISCOUNTTOTAL,
			INVOICE.SALE_EMP
		FROM
			INVOICE,
			INVOICE_ROW
		WHERE
			INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID
			AND INVOICE.PROCESS_CAT IN (#proc_list#)
			AND INVOICE.INVOICE_CAT NOT IN (65,66)<!--- demirbaş alış-satış faturaları diğer faturalarla aynı tipte bütçeleştirmiyor --->
			AND ISNULL(IS_IPTAL,0) = 0
			<cfif len(attributes.aktarim_budget_type)>
			AND INVOICE.PURCHASE_SALES=<cfif attributes.aktarim_budget_type eq 0>0<cfelse>1</cfif><!--- dagilim tipine göre faturayı aliyor --->
			</cfif>
			<cfif not isdefined('attributes.aktarim_is_budget_delete') or not len(attributes.aktarim_is_budget_delete)><!--- silinmeyecekse sadece dagitim yapılmamışlar --->
			AND ISNULL(INVOICE.IS_COST,0) = 0
			</cfif>
			<cfif len(attributes.aktarim_date1) gt 5>
			AND INVOICE.INVOICE_DATE >= #attributes.aktarim_date1#
			</cfif>
			<cfif len(attributes.aktarim_date2) gt 5>
			AND INVOICE.INVOICE_DATE <= #attributes.aktarim_date2#
			</cfif>
		ORDER BY INVOICE.INVOICE_ID
	</cfquery>
	
	<cfscript>
	// eger eski dagilim silinsin dendi ise query donmeden once ıs_cost 0 set ediliyor ve dagilimlar siliniyor oncelikle
	if(isdefined('attributes.aktarim_is_budget_delete') and len(attributes.aktarim_is_budget_delete))
	{
		if(isdefined('attributes.aktarim_budget_type') and attributes.aktarim_budget_type eq 0)
		{
			exp_where_txt='AND INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE WHERE PURCHASE_SALES=0)'; // 'AND IS_INCOME=0';
			inv_where_txt='AND PURCHASE_SALES=0';
		}
		else if(isdefined('attributes.aktarim_budget_type') and attributes.aktarim_budget_type eq 1)
		{
			exp_where_txt='AND INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE WHERE PURCHASE_SALES=1)'; //'AND IS_INCOME=1';
			inv_where_txt='AND PURCHASE_SALES=1';
		}
		else
		{
			exp_where_txt='';
			inv_where_txt='';
		}
		if(len(attributes.aktarim_date1) gt 5 or len(attributes.aktarim_date2) gt 5)
		{
			date_where_txt='AND INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE WHERE ';
			if(len(attributes.aktarim_date1) gt 5)date_where_txt=date_where_txt&' INVOICE.INVOICE_DATE >= #attributes.aktarim_date1#';
			if(len(attributes.aktarim_date2) gt 5)date_where_txt=date_where_txt&' AND INVOICE.INVOICE_DATE <= #attributes.aktarim_date2#';
			date_where_txt=date_where_txt&')';
		}else
		{
			date_where_txt='';
		}
		del_expense_item_row = cfquery(SQLString:'DELETE FROM EXPENSE_ITEMS_ROWS WHERE INVOICE_ID IS NOT NULL #exp_where_txt# #date_where_txt#',Datasource:kaynak_dsn2,dbtype:'',is_select:0);
		upd_is_cost_0 = cfquery(SQLString:'UPDATE INVOICE SET IS_COST=0 WHERE IS_COST <> 0 #inv_where_txt# #date_where_txt#',Datasource:kaynak_dsn2,dbtype:"",is_select:0);
	}
	if(isdefined('attributes.aktarim_is_budget') and len(attributes.aktarim_is_budget))//dagilim yapsın secili ise
	{

		for(get_rw=1;get_rw lte GET_INVOICE.RECORDCOUNT;get_rw=get_rw+1)
		{
			//kategoride projeye gore dagıt secili ise proje idde faturada varsa butceciye yollanıyor yoksa yollanmıyor
			if(len(GET_INVOICE.PROJECT_ID[#get_rw#]) and listgetat(proc_list_budget,listfind(proc_list,GET_INVOICE.PROCESS_CAT[#get_rw#],','),',') eq 1 and session.ep.our_company_info.project_followup eq 1)
				inv_project_id=GET_INVOICE.PROJECT_ID[#get_rw#]; 
			else 
				inv_project_id='';
			
			if(len(GET_INVOICE.BASKET_EMPLOYEE_ID[#get_rw#]))
				emp_id=GET_INVOICE.BASKET_EMPLOYEE_ID[#get_rw#]; 
			else if(len(GET_INVOICE.SALE_EMP[#get_rw#]))
				emp_id=GET_INVOICE.SALE_EMP[#get_rw#];
			else
				emp_id=session.ep.userid;
			if(GET_INVOICE.PURCHASE_SALES[#get_rw#])is_income_expense="true"; else is_income_expense="false";
			if(len(GET_INVOICE.STOCK_ID[#get_rw#]))
			{
				butce=butceci(
					action_id:GET_INVOICE.INVOICE_ID[#get_rw#],
					muhasebe_db:kaynak_dsn2,
					stock_id: GET_INVOICE.STOCK_ID[#get_rw#],
					product_id: GET_INVOICE.PRODUCT_ID[#get_rw#],
					product_tax: GET_INVOICE.TAX[#get_rw#],
					product_otv: GET_INVOICE.OTV_ORAN[#get_rw#],
					invoice_row_id:GET_INVOICE.INVOICE_ROW_ID[#get_rw#],
					paper_no:GET_INVOICE.INVOICE_NUMBER[#get_rw#],
					detail:'#GET_INVOICE.INVOICE_NUMBER[get_rw]# Nolu Fatura',
					is_income_expense: is_income_expense,
					process_type:GET_INVOICE.INVOICE_CAT[#get_rw#],
					nettotal:GET_INVOICE.NETTOTAL[#get_rw#],
					other_money_value:GET_INVOICE.OTHER_MONEY_VALUE[#get_rw#],
					action_currency:GET_INVOICE.OTHER_MONEY[#get_rw#],
					expense_date:createodbcdate(GET_INVOICE.INVOICE_DATE[#get_rw#]),
					department_id:GET_INVOICE.DEPARTMENT_ID[#get_rw#],
					project_id:'#inv_project_id#',
					expense_member_type:'employee',
					expense_member_id:emp_id,
					branch_id : ListGetAt(session.ep.user_location,2,"-"),
					currency_multiplier : '',
					discounttotal:GET_INVOICE.DISCOUNTTOTAL[#get_rw#],
					discount_other_money_value:0 //0 yollandığında bütceci kur vs alarak işlemi yapar
					);
			}
		}
	}
	upd_is_cost_1 = cfquery(SQLString:'UPDATE INVOICE SET IS_COST=1 WHERE INVOICE_ID IN (SELECT DISTINCT INVOICE_ID FROM EXPENSE_ITEMS_ROWS WHERE INVOICE_ID IS NOT NULL)',Datasource:kaynak_dsn2,dbtype:"",is_select:0);
	</cfscript>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2020.İşlem Başarıyla Tamamlanmıştır'>!");
		history.go(-2);
	</script>
</cfif>﻿
