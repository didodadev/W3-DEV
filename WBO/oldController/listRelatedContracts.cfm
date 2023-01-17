<cf_get_lang_set module_name="contract">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
	<cfsetting showdebugoutput="yes">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.our_company_id" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.startdate" default="">
    <cfparam name="attributes.finishdate" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.parts_partner_id" default="">
    <cfparam name="attributes.parts_position_code" default="">
    <cfparam name="attributes.parts_name" default="">
    <cfparam name="attributes.contract_cat" default="">
    <cfparam name="attributes.is_status" default="1">
    <cfparam name="attributes.contract_type" default="">
    <cfparam name="attributes.contract_calculation" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfif isdefined("attributes.form_submitted")>
        <cfif Len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
        <cfif Len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
        <cfquery name="get_related_contract" datasource="#dsn3#">
            SELECT
                COMPANY_ID,
                CONSUMER_ID,
                COMPANY,
                CONSUMERS,
                EMPLOYEE,
                STARTDATE,
                FINISHDATE,
                PROJECT_ID,
                CONTRACT_ID,
                CONTRACT_HEAD,
                CONTRACT_NO
            FROM 
                RELATED_CONTRACT
            WHERE 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#iif(len(attributes.our_company_id),attributes.our_company_id,DE(session.ep.company_id))#">
                <cfif attributes.is_status eq 1>AND STATUS = 1<cfelseif attributes.is_status eq 0>AND STATUS = 0</cfif>
                <cfif len(attributes.contract_type)>
                    AND CONTRACT_TYPE = #attributes.contract_type#
                </cfif>
                <cfif len(attributes.contract_calculation)>
                    AND CONTRACT_CALCULATION = #attributes.contract_calculation#
                </cfif>
                <cfif len(attributes.process_stage_type)>
                    AND STAGE_ID = #attributes.process_stage_type#
                </cfif>
                <cfif len(attributes.company_id) and len(attributes.company)>
                    AND COMPANY_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
                </cfif>
                <cfif len(attributes.consumer_id) and len(attributes.company)>
                    AND CONSUMER_ID LIKE <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
                </cfif>
                <cfif len(attributes.keyword)>
                    AND (
                        CONTRACT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
                        CONTRACT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> 
                        )
                </cfif>
                <cfif Len(attributes.project_id) and Len(attributes.project_head)>
                    AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                </cfif>
                <cfif Len(attributes.parts_name) and Len(attributes.parts_partner_id)>
                    AND COMPANY_PARTNER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.parts_partner_id#,%">
                </cfif>
                <cfif Len(attributes.parts_name) and Len(attributes.parts_position_code)>
                     AND EMPLOYEE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.parts_position_code#,%">
                </cfif>
                <cfif Len(attributes.startdate)>
                    AND STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                </cfif>
                <cfif Len(attributes.finishdate)>
                    AND FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                </cfif>
                <cfif Len(attributes.contract_cat)>
                    AND CONTRACT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.contract_cat#">
                </cfif>
                <cfif isDefined("attributes.not_contracts")>
                    AND (COMPANY_ID IS NULL AND CONSUMER_ID IS NULL)
                </cfif>
             ORDER BY
                CONTRACT_ID DESC
        </cfquery>
    <cfelse>
        <cfset get_related_contract.recordcount = 0>
    </cfif>
    <cfquery name="get_contract_stage" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%contract.list_related_contracts%">
    </cfquery> 
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default="#get_related_contract.recordcount#">
    <cfif GET_RELATED_CONTRACT.recordcount>
		<cfset company_list = "">
        <cfset consumer_list = "">
        <cfset employee_list = "">
        <cfset project_list = "">
        <cfset contract_company_list = "">
        <cfset contract_consumer_list = "">
        <cfoutput query="GET_RELATED_CONTRACT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <cfloop from="1" to="#listlen(company)#" index="sayac">
                <cfif len(ListGetAt(COMPANY,sayac,',')) and not listfind(company_list,ListGetAt(COMPANY,sayac,','))>
                    <cfset company_list = ListAppend(company_list,ListGetAt(COMPANY,sayac,','))>
                </cfif>
            </cfloop>
            <cfloop from="1" to="#listlen(consumers)#" index="sayac">
                <cfif len(ListGetAt(CONSUMERS,sayac,',')) and not listfind(consumer_list,ListGetAt(CONSUMERS,sayac,','))>
                    <cfset consumer_list = ListAppend(consumer_list,ListGetAt(CONSUMERS,sayac,','))>
                </cfif>	
            </cfloop>
            <cfloop from="1" to="#listlen(employee)#" index="sayac">
                <cfif len(ListGetAt(employee,sayac,',')) and not listfind(employee_list,ListGetAt(employee,sayac,','))>
                    <cfset employee_list = ListAppend(employee_list,ListGetAt(employee,sayac,','))>
                </cfif>	
            </cfloop>
            <cfloop from="1" to="#listlen(project_id)#" index="sayac">
                <cfif len(ListGetAt(project_id,sayac,',')) and not listfind(project_list,ListGetAt(project_id,sayac,','),',')>
                    <cfset project_list = Listappend(project_list,ListGetAt(project_id,sayac,','),',')>
                </cfif>
            </cfloop>
            <cfif Len(company_id) and not ListFind(contract_company_list,company_id,',')>
                <cfset contract_company_list = ListAppend(contract_company_list,company_id,',')>
            </cfif>
            <cfif Len(consumer_id) and not ListFind(contract_consumer_list,consumer_id,',')>
                <cfset contract_consumer_list = ListAppend(contract_consumer_list,consumer_id,',')>
            </cfif>
        </cfoutput>
        <cfif len(company_list)>
            <cfset company_list=listsort(company_list,"numeric","ASC",",")>
            <cfquery name="GET_PARTNER" datasource="#dsn#">
                SELECT FULLNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
            </cfquery>
            <cfset company_list = listsort(listdeleteduplicates(valuelist(GET_PARTNER.COMPANY_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(consumer_list)>
            <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
            <cfquery name="get_consumer" datasource="#dsn#">
                SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME AS FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(employee_list)>
            <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
            <cfquery name="get_employee" datasource="#dsn#">
                SELECT POSITION_ID, EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS FULLNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID IN (#employee_list#) ORDER BY POSITION_ID
            </cfquery>
            <cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employee.position_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif Len(project_list)>
            <cfquery name="get_projects" datasource="#dsn#">
                SELECT PROJECT_ID,PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_list#) ORDER BY PROJECT_ID
            </cfquery>
            <cfset project_list = ListSort(ListDeleteDuplicates(ValueList(get_projects.project_id,',')),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(contract_company_list)>
            <cfquery name="get_contract_company" datasource="#dsn#">
                SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#contract_company_list#) ORDER BY COMPANY_ID
            </cfquery>
            <cfset contract_company_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_company.company_id,',')),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(contract_consumer_list)>
            <cfquery name="get_contract_consumer" datasource="#dsn#">
                SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#contract_consumer_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset contract_consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_consumer.consumer_id,',')),"numeric","asc",",")>
        </cfif>
	</cfif> 
<cfelseif IsDefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
    <cf_xml_page_edit fuseact="contract.popup_add_contract">
    <cfparam name="attributes.short_code_id" default="">
    <cfparam name="attributes.short_code" default="">
    <cfinclude template="../contract/query/get_cat.cfm">
    <cfinclude template="../contract/query/get_moneys.cfm">
    <cfquery name="GET_KDV" datasource="#DSN2#">
        SELECT TAX_ID, TAX FROM SETUP_TAX ORDER BY TAX
    </cfquery>
    <cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
        SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
    </cfquery>
    <cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>
        <cfquery name="get_price_cat_exceptions" datasource="#DSN3#">
            SELECT 
                PRICE_CAT_EXCEPTION_ID, 
                IS_GENERAL, 
                COMPANY_ID, 
                PRODUCT_CATID, 
                CONSUMER_ID, 
                BRAND_ID, 
                PRODUCT_ID, 
                PRICE_CATID, 
                DISCOUNT_RATE, 
                COMPANYCAT_ID, 
                SUPPLIER_ID, 
                ACT_TYPE, 
                IS_DEFAULT, 
                PURCHASE_SALES, 
                DISCOUNT_RATE_2, 
                DISCOUNT_RATE_3, 
                DISCOUNT_RATE_4, 
                DISCOUNT_RATE_5, 
                PAYMENT_TYPE_ID, 
                SHORT_CODE_ID, 
                CONTRACT_ID, 
                PRICE, 
                PRICE_MONEY, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                PRICE_CAT_EXCEPTIONS 
            WHERE 
                CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#"> AND ISNULL(ACT_TYPE,1) IN(1,3)
        </cfquery>
    <cfelse>
        <cfset get_price_cat_exceptions.recordcount = 0>
    </cfif>
    <cfset row = get_price_cat_exceptions.RecordCount>
    <cfif IsDefined("attributes.event") and attributes.event is 'upd'>
    	<cfparam name="attributes.ship_method_id" default="">
		<cfquery name="get_contact_detail" datasource="#DSN3#">
            SELECT 
                CONTRACT_ID, 
                TERM, 
                FOLDER,
                CONTRACT_CAT_ID, 
                STARTDATE, 
                FINISHDATE, 
                CONTRACT_HEAD, 
                CONTRACT_BODY, 
                COMPANY, 
                COMPANY_PARTNER, 
                EMPLOYEE, 
                CONSUMERS, 
                STATUS, 
                STAGE_ID, 
                OUR_COMPANY_ID, 
                COMPANY_ID, 
                CONSUMER_ID, 
                CONTRACT_NO, 
                PAYMENT_TYPE_ID, 
                CONTRACT_AMOUNT, 
                CONTRACT_TAX, 
                CONTRACT_TAX_AMOUNT, 
                CONTRACT_UNIT_PRICE, 
                CONTRACT_MONEY, 
                GUARANTEE_AMOUNT, 
                GUARANTEE_RATE, 
                ADVANCE_AMOUNT, 
                TEVKIFAT_RATE_ID, 
                TEVKIFAT_RATE, 
                STOPPAGE_RATE_ID,
                STOPPAGE_RATE,
                ADVANCE_RATE, 
                CONTRACT_TYPE, 
                CONTRACT_CALCULATION, 
                DISCOUNT_RATE,
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP,
                UPDATE_DATE, 
                UPDATE_EMP,
                UPDATE_IP, 
                PROJECT_ID ,
                PAYMETHOD_ID,
                CARD_PAYMETHOD_ID,
                DELIVER_DEPT_ID,
                LOCATION_ID,
                SHIP_METHOD_ID
            FROM 
                RELATED_CONTRACT 
            WHERE 
                CONTRACT_ID = #attributes.contract_id#
        </cfquery>
		<!--- ilisklili isler --->
        <cfquery name="getContractWorks" datasource="#dsn#">
            SELECT 
                WORK_ID
            FROM 
                PRO_WORKS,
                #dsn3_alias#.RELATED_CONTRACT RC,
                OUR_COMPANY OC
            WHERE 
                OC.COMP_ID = RC.OUR_COMPANY_ID AND
                OC.COMP_ID = PRO_WORKS.OUR_COMPANY_ID AND
                (
                    (RC.CONTRACT_TYPE = 1 AND RC.CONTRACT_ID = PRO_WORKS.PURCHASE_CONTRACT_ID) OR
                    (RC.CONTRACT_TYPE = 2 AND RC.CONTRACT_ID = PRO_WORKS.SALE_CONTRACT_ID)
                ) AND
                RC.CONTRACT_ID = #attributes.contract_id#
        </cfquery>
        <!--- iliskili hakedisler --->
        <cfquery name="getProgress" datasource="#dsn3#">
            SELECT CONTRACT_ID,PROGRESS_VALUE FROM PROGRESS_PAYMENT WHERE CONTRACT_ID = #attributes.contract_id#
        </cfquery>
		<cfif len(get_contact_detail.consumer_id)>
            <cfquery name="get_consumer" datasource="#DSN#">
                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_contact_detail.consumer_id#">
            </cfquery>
            <cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
        <cfelseif len(get_contact_detail.company_id)>
            <cfquery name="get_company" datasource="#DSN#">
                SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_contact_detail.company_id#
            </cfquery>
            <cfset member_name = get_company.fullname>
        <cfelse>
            <cfset member_name = ''>
        </cfif>
        <cfif x_ship_method_id eq 1>
			<cfif len(get_contact_detail.ship_method_id)>
                <cfset attributes.ship_method=get_contact_detail.ship_method_id>
                <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
                    SELECT
                        SHIP_METHOD_ID,
                        SHIP_METHOD
                    FROM
                        SHIP_METHOD
                    WHERE 
                        SHIP_METHOD_ID=#get_contact_detail.ship_method_id#	
                </cfquery>            
                <cfset ship_method = get_ship_method.ship_method>
            <cfelse>
                <cfset ship_method = "">
            <cfset pay_id =get_contact_detail.paymethod_id>
            <cfquery name="GET_PAYMENT_METHOD" datasource="#dsn#">
                SELECT 
                    SP.* 
                FROM 
                    SETUP_PAYMETHOD SP
                    <cfif not(isDefined('pay_id') and len(pay_id))>
                        ,SETUP_PAYMETHOD_OUR_COMPANY SPOC
                    </cfif>
                WHERE	
                    <cfif isDefined('pay_id') and len(pay_id)>
                        SP.PAYMETHOD_ID = #pay_id#
                    <cfelse>
                        SP.PAYMETHOD_STATUS = 1
                        AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
                        AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                    </cfif>
            </cfquery>    
            </cfif>            
            <cfif len(get_contact_detail.card_paymethod_id)>
                <cfquery name="get_card_paymethod" datasource="#dsn3#">
                    SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#get_contact_detail.card_paymethod_id#
                </cfquery>
            </cfif>    
        </cfif>
    </cfif>    
	<cfif  IsDefined("attributes.event") and attributes.event is 'add'>
		<!---SöZLEŞME EKLE SAYFASI HEM NORMAL, HEM POPUP SAYFALARDA KULLANILDIĞI İÇİN NORMAL SAYFALARA GÖRE DÜZENLENMİŞTİR.--->        
        <cfquery name="get_module_cat" datasource="#DSN#">
            SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 17
        </cfquery>
        <cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
            <cfquery name="get_consumer" datasource="#DSN#">
                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfquery>
            <cfset member_name = '#get_consumer.consumer_name# #get_consumer.consumer_surname#'>
        <cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
            <cfquery name="get_company" datasource="#DSN#">
                SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
            </cfquery>
            <cfset member_name = get_company.fullname>
        <cfelse>
            <cfset member_name = ''>
        </cfif>
	</cfif>                   
</cfif>

<script type="text/javascript">
<cfif not IsDefined("attributes.event") or (IsDefined("attributes.event") and attributes.event is 'list')>
	$( document ).ready(function() {
		document.getElementById('keyword').focus();
	});	
	function uyar()
	{
		alert("<cf_get_lang no ='312.Anlasmayı Görebilmek İçin Lütfen Şirketinizi Değiştiriniz'>");
	}
<cfelseif IsDefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=cont.PRODUCT_CAT_ID' + no + '&field_name=cont.product_cat_name' + no ,'list');	/*&process=purchase_contract      var_=purchase_contr_cat_premium&*/
	}
	function pencere_paymethod(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=cont.payment_type_id' + no + '&field_name=cont.payment_type' + no,'list');
	}
	function pencere_pos(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=cont.PRODUCT_ID' + no + '&field_name=cont.product_name' + no,'list'); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
	function markaBul(no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=cont.brand_id' + no + '&brand_name=cont.brand_name' + no + '</cfoutput>','list');
	}
	function modelBul(no)
	{
		windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_product_model&model_id=cont.short_code_id' + no + '&model_name=cont.short_code' + no + '</cfoutput>','list');
	}
	function sil(sy)
	{
		var my_element=eval("cont.row_kontrol_2"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_2"+sy);
		my_element.style.display="none";
	}
	function unformat_fields()
	{
		cont.contract_amount.value = filterNum(cont.contract_amount.value);
		cont.contract_tax_amount.value = filterNum(cont.contract_tax_amount.value);
		cont.contract_unit_price.value = filterNum(cont.contract_unit_price.value);
		cont.guarantee_amount.value = filterNum(cont.guarantee_amount.value);
		cont.guarantee_rate.value = filterNum(cont.guarantee_rate.value);
		cont.advance_amount.value = filterNum(cont.advance_amount.value);
		cont.advance_rate.value = filterNum(cont.advance_rate.value);
		cont.tevkifat_oran.value = filterNum(cont.tevkifat_oran.value);
		cont.advance_rate.value = filterNum(cont.advance_rate.value);
		cont.stoppage_oran.value = filterNum(cont.stoppage_oran.value);
		cont.discount.value = filterNum(cont.discount.value);
		return true;
	}
	function kontrol()
	{
		if (cont.contract_cat_id.value == '')
		{	
			alert("<cf_get_lang_main no='59.Zorunlu alan'>:<cf_get_lang_main no='74.Kategori !'>");
			return false;		
		}
		if (document.getElementById('contract_head').value == '')
		{	
			alert("<cf_get_lang_main no='59.Zorunlu alan'>:<cf_get_lang no='59.Başlık !'>");
			return false;		
		}
		if (cont.start.value == '')
		{	
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'>");
			return false;		
		}
		if (cont.finish.value == '')
		{	
			alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='288.Bitiş Tarihi !'>");
			return false;		
		}
	
		<cfif x_tevkifat_rate eq 1>
			if(document.all.start.value != '' && document.all.finish.value != '')
			{
				var start_d = document.all.start.value.split(/\D+/);// \D sayı olmayan karakterleri temsil ediyor.
				var finish_d = document.all.finish.value.split(/\D+/);
				var d1=new Date(start_d[2]*1, start_d[1]-1, start_d[0]*1);
				var d2=new Date(finish_d[2]*1, finish_d[1]-1, finish_d[0]*1);
				var start_y = d1.getFullYear();
				var finish_y = d2.getFullYear();
				var fark = Math.abs(finish_y-start_y);
				if(fark != 0)
				{
					if(document.cont.tevkifat_oran_id.value == '' || document.cont.tevkifat_oran.value == '')
					{
						alert("<cf_get_lang_main no='59.Zorunlu alan'>:<cf_get_lang no='34.tevkifat oranı'>");
						return false;
					}
				}
			}
		</cfif>
		<cfif IsDefined("attributes.event") and attributes.event is 'upd'>
			document.all.contract_type.disabled = false;
			document.all.contract_calculation.disabled = false;
			document.all.advance_amount.disabled = false;
			document.all.advance_rate.disabled = false;
			document.all.guarantee_amount.disabled = false;
			document.all.guarantee_rate.disabled = false;
		</cfif>
		unformat_fields();
		return process_cat_control();
		return true;
	}
	<cfif IsDefined("attributes.event") and attributes.event is 'upd'>
		$( document ).ready(function() {		
			if(document.cont.our_company_id.value != <cfoutput>#session.ep.company_id#</cfoutput>)
			{
				alert("<cf_get_lang no ='316.Bu Anlaşma Bu Şirkete Ait Değildir Lütfen Şirket Değiştirin'>");
				window.close();
			}
			row_count_2 = <cfoutput>#get_price_cat_exceptions.RecordCount#</cfoutput>;	
		});
		function hesapla(type)
		{
			tax_ = document.all.contract_tax.value;
			if(type == 1)
			{
				if(document.all.contract_amount.value == '')
					amount_ = 0;
				else
					amount_ = filterNum(document.all.contract_amount.value);
				if(tax_ != 0 && amount_ != '')
				{
					kdvli_amount = ((parseFloat(tax_)*parseFloat(amount_))/100)+parseFloat(amount_);
					document.all.contract_tax_amount.value = commaSplit(kdvli_amount,'2');
				}
				else
					document.all.contract_tax_amount.value = commaSplit(amount_,'2');
			}
			else if(type == 2)
			{
				kdv_amount_ = filterNum(document.all.contract_tax_amount.value);
				if(tax_ != 0 && kdv_amount_ != '')
				{
					amount_ = (parseFloat(kdv_amount_)*100)/(parseFloat(tax_)+100);
					document.all.contract_amount.value = commaSplit(amount_,'2');
				}
				else
					document.all.contract_amount.value = commaSplit(kdv_amount_,'2');
			}
			else if(type == 3 || type == 4 || type == 5 || type == 6)
			{
				if(document.all.contract_amount.value != '' && parseFloat(document.all.contract_amount.value))
				{
					contract_amount_ = filterNum(document.all.contract_amount.value);
					if(document.all.guarantee_amount.value != "" && parseFloat(document.all.guarantee_amount.value)) guarantee_amount_ = filterNum(document.all.guarantee_amount.value); else guarantee_amount_ = 0;
					if(document.all.guarantee_rate.value != "" && parseFloat(document.all.guarantee_rate.value)) guarantee_rate_ = filterNum(document.all.guarantee_rate.value); else guarantee_rate_ = 0;
					if(document.all.advance_amount.value != "" && parseFloat(document.all.advance_amount.value)) advance_amount_ = filterNum(document.all.advance_amount.value); else advance_amount_ = 0;
					if(document.all.advance_rate.value != "" && parseFloat(document.all.advance_rate.value)) advance_rate_ = filterNum(document.all.advance_rate.value); else advance_rate_ = 0;
					
					if(type == 3 && parseFloat(contract_amount_) != 0)
					{
						if(parseFloat(guarantee_amount_) != 0)
							var deger_guarantee_rate = (parseFloat(guarantee_amount_)/parseFloat(contract_amount_))*100;
						else
							var deger_guarantee_rate = 0;
						document.all.guarantee_rate.value = commaSplit(deger_guarantee_rate);
					}
					if(type == 4)
					{
						var deger_guarantee_amount = (parseFloat(contract_amount_)*parseFloat(guarantee_rate_))/100;
						document.all.guarantee_amount.value = commaSplit(deger_guarantee_amount,'2');
					}
					if(type == 5 && contract_amount_ != 0)
					{
						if(parseFloat(advance_amount_) != 0)
							var deger_advance_rate = (parseFloat(advance_amount_)/parseFloat(contract_amount_))*100;
						else
							var deger_advance_rate = 0;
						document.all.advance_rate.value = commaSplit(deger_advance_rate);
					}
					if(type == 6)
					{
						var deger_advance_amount = (parseFloat(contract_amount_)*parseFloat(advance_rate_))/100;
						document.all.advance_amount.value = commaSplit(deger_advance_amount,'2');
					}
				}
				else
				{
					alert('<cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang no="285.Sözleşme Tutarı"> !');
					document.all.advance_amount.value = '';
					document.all.advance_rate.value = '';
				}
			}
		}
		function add_row()
		{
			row_count_2++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
			newRow.setAttribute("name","frm_row_2" + row_count_2);
			newRow.setAttribute("id","frm_row_2" + row_count_2);		
			document.cont.record_num_.value=row_count_2;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_2'+row_count_2 +'" ><a style="cursor:pointer" onclick="sil(' + row_count_2 + ');"><img  src="images/delete_list.gif" border="0"></a>';				
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<select name="price_cat' + row_count_2 + '" style="width:130px;"><cfoutput query="GET_PRICE_CATS"><option value="#PRICE_CATID#">#PRICE_CAT#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  name="PRODUCT_CAT_ID' + row_count_2 +'" ><input type="text" name="product_cat_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_ac(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Kategori Seç"></a>';			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  name="brand_id' + row_count_2 +'" ><input type="text" name="brand_name' + row_count_2 + '" style="width:90px;"><a href="javascript://" onClick="markaBul(' + row_count_2 + ');">&nbsp;<img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Marka Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  name="short_code_id' + row_count_2 +'" ><input type="text" name="short_code' + row_count_2 + '" style="width:90px;"><a href="javascript://" onClick="modelBul(' + row_count_2 + ');">&nbsp;<img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Model Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  name="PRODUCT_ID' + row_count_2 +'" ><input type="text" name="product_name' + row_count_2 + '" style="width:90px;"><a href="javascript://" onClick="pencere_pos(' + row_count_2 + ');">&nbsp;<img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input  type="hidden"  name="payment_type_id' + row_count_2 +'"><input type="text" name="payment_type' + row_count_2 + '" style="width:90px;"><a href="javascript://" onClick="pencere_paymethod(' + row_count_2 + ');">&nbsp;<img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ödeme Yöntemi Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="price' + row_count_2 + '" style="width:60px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="price_money' + row_count_2  +'" id="money_id' + row_count_2  +'" style="width:60px;" class="moneytext">';
			<cfoutput query="get_moneys">
				a += '<option value="#money#">#money#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="discount_info_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="discount_info2_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="discount_info3_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="discount_info4_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="discount_info5_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		}
	</cfif>		
	<cfif IsDefined("attributes.event") and attributes.event is 'add'>
		<cfif isdefined("attributes.template_id")>
			<cfinclude template="../query/get_templates.cfm">  	
			document.cont.contract_body.value = '<cfoutput>#SETUP_TEMPLATE.TEMPLATE_CONTENT#</cfoutput>';	
		</cfif>	
		function hesapla(type)
		{
			tax_ = document.all.contract_tax.value;
			if(type == 1)
			{
				amount_ = filterNum(document.all.contract_amount.value,'2');
				if(tax_ != 0 && amount_ != '')
				{
					kdvli_amount = ((parseFloat(tax_)*parseFloat(amount_))/100)+parseFloat(amount_);
					document.all.contract_tax_amount.value = commaSplit(kdvli_amount,'2');
				}
				else
					document.all.contract_tax_amount.value = commaSplit(amount_,'2');
			}
			else if(type == 2)
			{
				kdv_amount_ = filterNum(document.all.contract_tax_amount.value,'2');
				if(tax_ != 0 && kdv_amount_ != '')
				{
					amount_ = (parseFloat(kdv_amount_)*100)/(parseFloat(tax_)+100);
					document.all.contract_amount.value = commaSplit(amount_,'2');
				}
				else
					document.all.contract_amount.value = commaSplit(kdv_amount_,'2');;
			}
			else if(type == 3 || type == 4 || type == 5 || type == 6)
			{
				if(document.all.contract_amount.value != '')
				{
					contract_amount_ = filterNum(document.all.contract_amount.value);
					if(document.all.guarantee_amount.value != "" && parseFloat(document.all.guarantee_amount.value)) guarantee_amount_ = filterNum(document.all.guarantee_amount.value); else guarantee_amount_ = 0;
					if(document.all.guarantee_rate.value != "" && parseFloat(document.all.guarantee_rate.value)) guarantee_rate_ = filterNum(document.all.guarantee_rate.value); else guarantee_rate_ = 0;
					if(document.all.advance_amount.value != "" && parseFloat(document.all.advance_amount.value)) advance_amount_ = filterNum(document.all.advance_amount.value); else advance_amount_ = 0;
					if(document.all.advance_rate.value != "" && parseFloat(document.all.advance_rate.value)) advance_rate_ = filterNum(document.all.advance_rate.value); else advance_rate_ = 0;
					
					if(type == 3)
					{
						if(parseFloat(contract_amount_) != 0)
							var deger_guarantee_rate = (parseFloat(guarantee_amount_)/parseFloat(contract_amount_))*100;
						else
							var deger_guarantee_rate = 0;
						document.all.guarantee_rate.value = commaSplit(deger_guarantee_rate);
					}
					if(type == 4)
					{
						var deger_guarantee_amount = (parseFloat(contract_amount_)*parseFloat(guarantee_rate_))/100;
						document.all.guarantee_amount.value = commaSplit(deger_guarantee_amount,'2');
					}
					if(type == 5)
					{
						if(parseFloat(contract_amount_) != 0)
							var deger_advance_rate = (parseFloat(advance_amount_)/parseFloat(contract_amount_))*100;
						else
							var deger_advance_rate = 0;
						document.all.advance_rate.value = commaSplit(deger_advance_rate);
					}
					if(type == 6)
					{
						var deger_advance_amount = (parseFloat(contract_amount_)*parseFloat(advance_rate_))/100;
						document.all.advance_amount.value = commaSplit(deger_advance_amount,'2');
					}
				}
				else
				{
					alert("<cf_get_lang_main no='59.Zorunlu alan'>:<cf_get_lang no='285.Şözleşme Tutarı'>!");
					document.all.advance_amount.value = '';
					document.all.advance_rate.value = '';
				}
			}
		}
		
		//fiyat listeleri
		row_count_2=<cfoutput>#row#</cfoutput>;
		function add_row()
		{
			row_count_2++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
			newRow.setAttribute("name","frm_row_2" + row_count_2);
			newRow.setAttribute("id","frm_row_2" + row_count_2);		
			document.cont.record_num_.value=row_count_2;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden" value="1"  name="row_kontrol_2'+row_count_2 +'" ><a style="cursor:pointer" onclick="sil(' + row_count_2 + ');"><img  src="images/delete_list.gif" border="0"></a>';				
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<select name="price_cat' + row_count_2 + '" style="width:130px;"><cfoutput query="GET_PRICE_CATS"><option value="#PRICE_CATID#">#PRICE_CAT#</option></cfoutput></select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden"  name="PRODUCT_CAT_ID' + row_count_2 +'" ><input type="text" name="product_cat_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_ac(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Kategori Seç"></a>';			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden"  name="brand_id' + row_count_2 +'" ><input type="text" name="brand_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="markaBul(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Marka Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden"  name="short_code_id' + row_count_2 +'" ><input type="text" name="short_code' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="modelBul(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Model Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden"  name="PRODUCT_ID' + row_count_2 +'" ><input type="text" name="product_name' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_pos(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ürün Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input  type="hidden"  name="payment_type_id' + row_count_2 +'"><input type="text" name="payment_type' + row_count_2 + '" style="width:90px;">&nbsp;<a href="javascript://" onClick="pencere_paymethod(' + row_count_2 + ');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="Ödeme Yöntemi Seç"></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="text" name="price' + row_count_2 + '" style="width:60px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			a = '<select name="price_money' + row_count_2  +'" id="money_id' + row_count_2  +'" style="width:60px;" class="moneybox">';
			<cfoutput query="get_moneys">
				a += '<option value="#money#">#money#</option>';
			</cfoutput>
			newCell.innerHTML =a+ '</select>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="discount_info' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="discount_info2' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="discount_info3' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="discount_info4' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="discount_info5' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		}
		
	</cfif>				
</cfif>	
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined("attributes.event"))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'contract.list_related_contracts';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'contract/display/list_related_contracts.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'contract.popup_add_contract';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'contract/form/form_add_contract.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'contract/query/add_contract.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'contract.list_related_contracts&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'contract.popup_add_contract';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'contract/form/form_upd_contract.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'contract/query/upd_contract.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'contract.list_related_contracts&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'contract_id=##attributes.contract_id##';
	WOStruct['#attributes.fuseaction#']['upd']['identity'] = '##attributes.contract_id##';
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'contract.del&contract_id=#attributes.contract_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'contract/query/delete_contract.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'contract/query/delete_contract.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'contract.list_related_contracts';
	}
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
	
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[398]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.contract_id#&type_id=-21','list','cont')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['href'] = "#request.self#?fuseaction=contract.list_related_contracts&event=add";
			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onclick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.contract_id#&print_type=480','page')";		
						
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listRelatedContracts';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'RELATED_CONTRACT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-contract_cat_id','item-contract_head','item-contract_no','item-start','item-finish']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
