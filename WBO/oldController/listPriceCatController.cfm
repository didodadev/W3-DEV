<cf_get_lang_set module_name="product"> 
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
  <cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.is_submit")>
    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
        SELECT * FROM PRICE_CAT <cfif len(attributes.keyword)>WHERE PRICE_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"></cfif> ORDER BY PRICE_CAT
    </cfquery>
    <cfelse>
        <cfset get_price_cat.recordcount = 0>
    </cfif>
    <cfquery name="CALCULATE_AC_PRD_ALL" datasource="#DSN3#">
        SELECT COUNT(PRICE_ID) SUM_PRD, PRICE_CATID FROM PRICE WHERE STARTDATE <= #now()# AND (FINISHDATE >= #now()# OR FINISHDATE IS NULL) GROUP BY PRICE_CATID
    </cfquery>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_price_cat.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_price_cat.recordcount>
			<cfset consumer_cat_list = "">
			<cfset company_cat_list = "">
			<cfset branch_list = "">
			<cfoutput query="get_price_cat" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<cfif Len(consumer_cat) and not ListFind(consumer_cat_list,consumer_cat,',')>
					<cfset consumer_cat_list = ListAppend(consumer_cat_list,consumer_cat,',')>
				</cfif>
				<cfif Len(company_cat) and not ListFind(company_cat_list,company_cat,',')>
					<cfset company_cat_list = ListAppend(company_cat_list,company_cat,',')>
				</cfif>
				<cfif Len(branch) and not ListFind(company_cat_list,branch,',')>
					<cfset branch_list = ListAppend(branch_list,branch,',')>
				</cfif>
			</cfoutput>
			<cfif ListLen(consumer_cat_list)>
				<cfset consumer_cat_list=ListSort(consumer_cat_list,"numeric","ASC",",")>
				<cfquery name="get_consumer_cat" datasource="#dsn#">
					SELECT CONSCAT_ID, CONSCAT FROM CONSUMER_CAT WHERE CONSCAT_ID IN (#consumer_cat_list#) ORDER BY CONSCAT_ID
				</cfquery>
				<cfset consumer_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_consumer_cat.conscat_id)),'numeric','ASC',',')>
			</cfif>
			<cfif ListLen(company_cat_list)>
				<cfset company_cat_list=ListSort(company_cat_list,"numeric","ASC",",")>
				<cfquery name="get_company_cat" datasource="#dsn#">
					SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#company_cat_list#) ORDER BY COMPANYCAT_ID
				</cfquery>
				<cfset company_cat_list = ListSort(ListDeleteDuplicates(ValueList(get_company_cat.companycat_id)),'numeric','ASC',',')>
			</cfif>
			<cfif ListLen(branch_list)>
				<cfset branch_list=ListSort(branch_list,"numeric","ASC",",")>
				<cfquery name="get_branch" datasource="#dsn#">
					SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH  WHERE BRANCH_ID IN (#branch_list#) ORDER BY BRANCH_ID
				</cfquery>
				<cfset branch_list = ListSort(ListDeleteDuplicates(ValueList(get_branch.branch_id)),'numeric','ASC',',')>
			</cfif>
    </cfif>
    <cfquery name="GET_PRICE_CAT_ALL" datasource="#DSN3#">
        SELECT COMPANY_CAT,CONSUMER_CAT,BRANCH FROM PRICE_CAT ORDER BY PRICE_CAT
    </cfquery>
    <cfquery name="GET_CONS_CAT_" datasource="#DSN#">
        SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT
    </cfquery>
    <cfquery name="GET_COMP_CAT_" datasource="#DSN#">
        SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT
    </cfquery>
    <cfquery name="GET_BRANCH_" datasource="#DSN#">
        SELECT
            B.BRANCH_ID,
            B.BRANCH_NAME
        FROM
            BRANCH B,
            ZONE Z
        WHERE 
            B.BRANCH_STATUS = 1 AND
            Z.ZONE_ID = B.ZONE_ID AND
            Z.ZONE_STATUS = 1 AND
            B.COMPANY_ID = #session.ep.company_id#
        ORDER BY
            B.BRANCH_NAME
    </cfquery>
    <cfset company_cat_list = listdeleteduplicates(valuelist(get_price_cat_all.company_cat,','))>
    <cfset consumer_cat_list = listdeleteduplicates(valuelist(get_price_cat_all.consumer_cat,','))>
    <cfset branch_list = listdeleteduplicates(valuelist(get_price_cat_all.branch,','))>
    <cfset conscat_list = ''>
    <cfset companycat_list = ''>
    <cfset branch_name_list = ''>
    <cfoutput query="get_cons_cat_">
        <cfif not listfind(consumer_cat_list,conscat_id)><cfset conscat_list = listAppend(conscat_list,conscat)></cfif>
    </cfoutput>
    <cfoutput query="get_comp_cat_">
        <cfif not listfind(company_cat_list,companycat_id)><cfset companycat_list = listAppend(companycat_list,companycat)></cfif>
    </cfoutput>
    <cfoutput query="get_branch_">
        <cfif not listfind(branch_list,branch_id)><cfset branch_name_list = listAppend(branch_name_list,branch_name)></cfif>
    </cfoutput>
<cfelseif isdefined('attributes.event') and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="product.form_add_pricecat">
    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
        SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1
    </cfquery>
    <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
        SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
    </cfquery>
    <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
        SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT WHERE IS_ACTIVE = 1 ORDER BY CONSCAT
    </cfquery>
    <!--- coklu sube secimi icin eklendi --->
    <cfparam name="is_multi_branch" default="0">
    <cfinclude template="../product/query/get_branch.cfm">
<cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
	<cfset xml_page_control_list = 'is_multi_branch,is_calculate_type'>
    <cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
        SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 AND PRICE_CATID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#">
    </cfquery>
    <cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
        SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
    </cfquery>
    <cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
        SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
    </cfquery>
    <cfquery name="POSITION_CATEGORIES" datasource="#dsn#">
        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
    </cfquery>
    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
        SELECT * FROM PRICE_CAT WHERE PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#"> ORDER BY PRICE_CAT
    </cfquery>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="product.form_add_pricecat">
    <cfinclude template="../product/query/get_branch.cfm">
    <cfif len(listsort(get_price_cat.company_cat,'Numeric'))>
        <cfquery name="GET_COMPANY_RECORD" datasource="#DSN#">
            SELECT 
                COMPANYCAT 
            FROM 
                COMPANY_CAT 
            WHERE 
                COMPANYCAT_ID IN (#listsort(get_price_cat.company_cat,'Numeric')#)
        </cfquery>
    <cfelse>
        <cfset get_company_record.recordcount = 0>
    </cfif>
    <cfif len(listsort(get_price_cat.consumer_cat,'Numeric'))>
        <cfquery name="GET_CONSUMER_RECORD" datasource="#DSN#">
            SELECT 
              CONSCAT 
            FROM 
              CONSUMER_CAT 
            WHERE 
              CONSCAT_ID IN (#listsort(get_price_cat.consumer_cat,'Numeric')#)
        </cfquery>
    <cfelse>
        <cfset get_consumer_record.recordcount = 0>
    </cfif>
                
    <cfif len(listsort(get_price_cat.branch,'Numeric'))>
        <cfquery name="GET_BRANCH_RECORD" datasource="#DSN#">
          SELECT 
              BRANCH_NAME 
          FROM 
              BRANCH 
          WHERE 
              BRANCH_ID IN (#listsort(get_price_cat.branch,'Numeric')#)
        </cfquery>
    <cfelse>
        <cfset get_branch_record.recordcount = 0>
    </cfif>
</cfif>  
<cfif isdefined('attributes.event') and attributes.event is 'add'>
	<script type="text/javascript">		
		function kontrol()
		{
			if(document.form_add_pricecat.is_sales.checked == false && document.form_add_pricecat.is_purchase.checked == false)
			{
				alert("Alış Satış Seçeneklerinden En Az Birini Seçmelisiniz !");
				return false;
			}
			//Coklu sube secim kontrolu
			if(document.form_add_pricecat.is_multi_branch.value==0)
			{
				sayac = 0;
				if(document.form_add_pricecat.branch!= undefined && document.form_add_pricecat.branch.length != undefined)
				{
					for (i=0; i < form_add_pricecat.branch.length; i++)
					{
						if(form_add_pricecat.branch[i].checked==true)
							sayac = sayac + 1;
					}
				}		
				if(sayac > 1)
				{
						alert("<cf_get_lang no ='779.Yapılan Tanımdan Dolayı Listede Çoklu Şube Şeçimi Yapamazsınız'> !");
					return false;
				}
			}
			if ((document.form_add_pricecat.avg_due_day.value != '' && document.form_add_pricecat.target_due_date.value != '') || (document.form_add_pricecat.avg_due_day.value == '' && document.form_add_pricecat.target_due_date.value == ''))
			{
				alert("<cf_get_lang no ='781.Ortalama Vade ve Vade Tarihi alanları aynı anda boş veya dolu olamaz'> !");
				return false;
			}
			if (document.form_add_pricecat.margin.value > 10000 && document.form_add_pricecat.margin.value == '')
			{
				alert("<cf_get_lang no ='810.Girdiğiniz Düzenleme Oranı Yanlış! Lütfen Değiştirin'> !");
				return false;
			}
			var str_me = form_add_pricecat.number_of_installment;if(str_me!= null)str_me.value=filterNum(str_me.value);	
			var str_me = form_add_pricecat.avg_due_day;if(str_me!= null)str_me.value=filterNum(str_me.value);	
			var str_me = form_add_pricecat.due_diff_value;if(str_me!= null)str_me.value=filterNum(str_me.value);	
			var str_me = form_add_pricecat.early_payment;if(str_me!= null)str_me.value=filterNum(str_me.value);	
			return true;
		}
		function hesapla_vade()
		{
			document.form_add_pricecat.avg_due_day.value = (30+(document.form_add_pricecat.number_of_installment.value*30))/2;
		}
		function empty_due_day(deger)
		{
			if(deger==1)//taksit sayısından geliyo
				document.form_add_pricecat.target_due_date.value = '';
			else if(deger==2)//ortalama vadeden geliyorsa
				document.form_add_pricecat.target_due_date.value='';
			else if (deger==3)
			{
				document.form_add_pricecat.avg_due_day.value='';
				document.form_add_pricecat.number_of_installment.value='';
			}
		}
	</script>
<cfelseif isdefined('attributes.event') and attributes.event is 'upd'>
	<script type="text/javascript">		
        function kontrol()
        {
            //Coklu sube secim kontrolu
            if(document.form_upd_pricecat.is_multi_branch.value==0)
            {
                sayac = 0;
                if(document.form_upd_pricecat.branch!= undefined && document.form_upd_pricecat.branch.length != undefined)
                {
                    for (i=0; i < form_upd_pricecat.branch.length; i++)
                    {
                        if(form_upd_pricecat.branch[i].checked==true)
                            sayac = sayac + 1;
                    }
                }		
                if(sayac > 1)
                {
                    alert("<cf_get_lang no ='779.Yapılan Tanımdan Dolayı Listede Çoklu Şube Şeçimi Yapamazsınız'> !");
                    return false;
                }
            }	
            if ((document.form_upd_pricecat.avg_due_day.value == '' && document.form_upd_pricecat.TARGET_DUE_DATE.value == ''))
            {
                alert("<cf_get_lang no ='781.Ortalama Vade ve Vade Tarihi alanları aynı anda boş olamaz'> !");
                return false;
            }	
            if (document.form_upd_pricecat.margin.value > 10000 && document.form_upd_pricecat.margin.value == '')
            {
                window.alert("<cf_get_lang no ='810.Girdiğiniz Düzenleme Oranı Yanlış! Lütfen Değiştirin'> !");
                return false;
            }
            
            if (confirm("<cf_get_lang no ='784.Bütün Fiyatlar Yeniden Oluşacak Eminmisiniz! Onaylarsanız Fiyat Oluşturularak Güncellenecek Reddederseniz Fiyat Oluşturmadan Güncellenecek'> !"))
                document.form_upd_pricecat.go_val.value = "1";
            else
                document.form_upd_pricecat.go_val.value = "0";
                
            var str_me = form_upd_pricecat.number_of_installment;if(str_me!= null)str_me.value=filterNum(str_me.value);	
            var str_me = form_upd_pricecat.avg_due_day;if(str_me!= null)str_me.value=filterNum(str_me.value);	
            var str_me = form_upd_pricecat.due_diff_value;if(str_me!= null)str_me.value=filterNum(str_me.value);
            var str_me = form_upd_pricecat.early_payment;if(str_me!= null)str_me.value=filterNum(str_me.value);		
            return true;
        }
        function hesapla_vade()
        {
            document.form_upd_pricecat.avg_due_day.value = (30+(document.form_upd_pricecat.number_of_installment.value*30))/2;
        }
        function empty_due_day(deger)
        {
            if(deger==1)//taksit sayısından geliyo
                document.form_upd_pricecat.TARGET_DUE_DATE.value = '';
            else if(deger==2)//ortalama vadeden geliyorsa
                document.form_upd_pricecat.TARGET_DUE_DATE.value='';
            else if (deger==3)
            {
                document.form_upd_pricecat.avg_due_day.value='';
                document.form_upd_pricecat.number_of_installment.value='';
            }
        }
    </script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_price_cat';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_price_cat.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_pricecat';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/form_add_pricecat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_pricecat.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_price_cat&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.form_upd_pricecat';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/form_upd_pricecat.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/create_list.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_price_cat&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pcat_id=##attributes.pcat_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pcat_id##';	
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.del_pricecat';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_pricecat.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_pricecat.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_price_cat';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'pcat_id=##attributes.pcat_id##&head=##get_price_cat.price_cat##';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.pcat_id##';

		
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_price_cat&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listPriceCatController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRICE_CAT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-is_purchase','item-price_cat']";
	
</cfscript>