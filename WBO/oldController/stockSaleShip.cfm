<cf_get_lang_set module_name="stock">
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
    <cf_xml_page_edit fuseact="stock.form_add_sale">
    <cfscript>
        if(isdefined('attributes.is_ship_copy') )
            session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
        else if(isDefined("attributes.order_id"))//siparisten gelen
            session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,to_table_type_id:1,process_type:1);
        else
            session_basket_kur_ekle(process_type:0);
    </cfscript>
    <cfset attributes.subscription_id=""><!--- cf_wrk_subscriptions custom tag'ine tanımlı gidebilmesi icin atandı --->
    <cfset attributes.paymethod_id = "">
    <cfset attributes.card_paymethod_id = "">
    <cfset attributes.commission_rate = "">
    <cfset attributes.commethod_id = "">
    <cfif isdefined('attributes.service_ids') and len(attributes.service_ids)><!--- servis modulunden cagrılmıssa --->
        <cfif isdefined("attributes.related_partner_id") and len(attributes.related_partner_id)>
            <cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
                SELECT
                    S.PROJECT_ID,
                    S.SERVICE_NO,
                    CP.COMPANY_PARTNER_ADDRESS + ' ' + CP.SEMT AS SERVICE_ADDRESS,
                    CP.COUNTY AS SERVICE_COUNTY,
                    CP.CITY AS SERVICE_CITY,
                    S.SERVICE_BRANCH_ID,
                    S.DEPARTMENT_ID,
                    D.DEPARTMENT_HEAD,
                    S.LOCATION_ID,
                    CP.PARTNER_ID AS SERVICE_PARTNER_ID,
                    CP.COMPANY_ID AS SERVICE_COMPANY_ID,
                    '' AS SERVICE_CONSUMER_ID,
                    S.SERVICE_ADDRESS
                FROM
                    SERVICE S,
                    #dsn_alias#.DEPARTMENT D,
                    #dsn_alias#.COMPANY_PARTNER CP,
                    #dsn_alias#.COMPANY C
                WHERE
                    S.RELATED_COMPANY_ID = C.COMPANY_ID AND
                    C.COMPANY_ID = CP.COMPANY_ID AND
                    CP.PARTNER_ID = #attributes.related_partner_id# AND
                    S.SERVICE_ID IN (#attributes.service_ids#) AND
                    S.DEPARTMENT_ID = D.DEPARTMENT_ID
            </cfquery>
        <cfelse>
            <cfquery name="GET_SERVICE" datasource="#DSN3#" maxrows="1">
                SELECT
                    S.PROJECT_ID,
                    S.SERVICE_NO,
                    S.SERVICE_ADDRESS,
                    '' AS SERVICE_COUNTY,
                    '' AS SERVICE_CITY,
                    S.SERVICE_BRANCH_ID,
                    S.DEPARTMENT_ID,
                    D.DEPARTMENT_HEAD,
                    S.LOCATION_ID,
                    S.SERVICE_PARTNER_ID,
                    S.SERVICE_COMPANY_ID,
                    S.SERVICE_CONSUMER_ID,
                    S.SERVICE_ADDRESS
                FROM
                    SERVICE S,
                    #dsn_alias#.DEPARTMENT D
                WHERE
                    S.SERVICE_ID IN (#attributes.service_ids#) AND
                    S.DEPARTMENT_ID = D.DEPARTMENT_ID
            </cfquery>
        </cfif>
        <cfif not GET_SERVICE.recordcount>
            <script type="text/javascript">
                alert("<cf_get_lang no='91.Servis Bulunamadı veya Servis Lokasyonu Eksik Hatalı Lütfen Düzenleyiniz'>!");
                window.close();
            </script>
            <cfabort>
        </cfif>
        <cfscript>
            attributes.company_id = get_service.service_company_id;
            attributes.comp_name= get_par_info(get_service.service_company_id,1,1,0);
            attributes.consumer_id = get_service.service_consumer_id;
            attributes.partner_id = get_service.service_partner_id;
            if(len(get_service.service_partner_id) and get_service.service_partner_id neq 0)
                attributes.partner_name=get_par_info(get_service.service_partner_id,0,-1,0);
            else
                attributes.partner_name=get_cons_info(get_service.service_consumer_id,0,0);
                
            attributes.deliver_date =  dateformat(now(),'dd/mm/yyyy');
            attributes.ship_date = dateformat(now(),'dd/mm/yyyy');
            attributes.service_paper_no =get_service.service_no;
            location_info_ = get_location_info(get_service.department_id,get_service.location_id,1,1);
            attributes.location_id = get_service.location_id;
            attributes.branch_id = listlast(location_info_,',');
            attributes.department_id = get_service.department_id;
            attributes.adres = get_service.SERVICE_ADDRESS;
            attributes.city_id = '#get_service.SERVICE_CITY#';
            attributes.county_id ='#get_service.SERVICE_COUNTY#';		
            attributes.txt_departman_ =listfirst(location_info_,',');
            attributes.project_id = get_service.project_id;
            txt_paper=get_service.service_no;
        </cfscript>
        <cfif len(attributes.county_id)>
            <cfquery name="GET_COUNTY" datasource="#DSN#">
                SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #attributes.county_id#
            </cfquery>
            <cfset attributes.adres = '#attributes.adres# #GET_COUNTY.COUNTY_NAME#'> 
        </cfif>
        <cfif len(attributes.city_id)>
            <cfquery name="GET_CITY" datasource="#DSN#">
                SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #attributes.city_id#
            </cfquery>
            <cfset attributes.adres = '#attributes.adres# #GET_CITY.CITY_NAME#'>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.is_ship_copy')>
        <cfinclude template="../stock/query/get_upd_purchase.cfm">
        <cfscript>
            location_info_ = get_location_info(get_upd_purchase.deliver_store_id,get_upd_purchase.location,1,1);
            attributes.location_id = get_upd_purchase.location;
            attributes.department_id = get_upd_purchase.deliver_store_id;
            attributes.branch_id = listlast(location_info_,',');
            attributes.txt_departman_ =listfirst(location_info_,',');
            attributes.company_id =get_upd_purchase.company_id;
            attributes.comp_name =get_par_info(get_upd_purchase.company_id,1,0,0);
            attributes.partner_id = get_upd_purchase.partner_id;
            attributes.consumer_id=get_upd_purchase.consumer_id;
            attributes.employee_id=get_upd_purchase.employee_id;
            if(len(get_upd_purchase.partner_id) and get_upd_purchase.partner_id neq 0)
                attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
            else
                attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
            attributes.city_id = GET_UPD_PURCHASE.CITY_ID;
            attributes.county_id = GET_UPD_PURCHASE.COUNTY_ID;
            attributes.ship_address_id = get_upd_purchase.ship_address_id;
            attributes.adres = trim(get_upd_purchase.address);
            attributes.project_id = get_upd_purchase.project_id;
            attributes.ship_method_name ='';
            attributes.ship_method_id=get_upd_purchase.ship_method;
            attributes.deliver_get = get_upd_purchase.deliver_emp;
            attributes.sale_emp = get_upd_purchase.sale_emp;
            attributes.deliver_date = dateformat(get_upd_purchase.deliver_date,'dd/mm/yyyy');
            attributes.sale_emp = get_upd_purchase.sale_emp;
            attributes.subscription_id = get_upd_purchase.subscription_id;
            attributes.order_detail = get_upd_purchase.ship_detail;
            attributes.ref_no = get_upd_purchase.ref_no;
            attributes.service_app_id = get_upd_purchase.service_id;
        </cfscript>
    </cfif>
    <cfif not isdefined("attributes.ship_id") and isdefined("attributes.project_id") and len(attributes.project_id) and not isdefined('attributes.service_ids')>
        <cfquery name="get_project_info" datasource="#dsn#">
            SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID FROM PRO_PROJECTS WHERE PROJECT_ID =#attributes.project_id#
        </cfquery>
        <cfif len(get_project_info.partner_id)>
            <cfset attributes.company_id = get_project_info.company_id>
            <cfset attributes.partner_id = get_project_info.partner_id>
            <cfset attributes.partner_name = get_par_info(get_project_info.partner_id,0,-1,0)>
            <cfset attributes.comp_name =get_par_info(get_project_info.company_id,1,0,0)>
        <cfelseif len(get_project_info.consumer_id)>
            <cfset attributes.consumer_id = get_project_info.consumer_id>
            <cfset attributes.partner_name = get_cons_info(get_project_info.consumer_id,0,0)>
            <cfset attributes.comp_name =get_cons_info(get_project_info.consumer_id,2,0)>
        </cfif>
    </cfif>
    <cfif isdefined('attributes.order_id') and len(attributes.order_id)>
        <cfinclude template="../stock/query/get_det_order_sale.cfm">
        <cfscript>
        attributes.company_id = get_upd_purchase.company_id;
        attributes.comp_name= get_par_info(get_upd_purchase.company_id,1,1,0);
        attributes.partner_id = get_upd_purchase.partner_id;
        attributes.consumer_id = get_upd_purchase.consumer_id;
        if(len(get_upd_purchase.partner_id))
                attributes.partner_name=get_par_info(get_upd_purchase.partner_id,0,-1,0);
            else
                attributes.partner_name=get_cons_info(get_upd_purchase.consumer_id,0,0);
        attributes.order_number = get_upd_purchase.order_number;
        attributes.ship_date = dateformat(now(),'dd/mm/yyyy');
        attributes.ref_no = get_upd_purchase.ref_no;
        attributes.sale_emp = get_upd_purchase.order_employee_id;
        attributes.location_id = get_upd_purchase.location_id;
        attributes.department_id = get_upd_purchase.DELIVER_DEPT_ID;
        location_info_ = get_location_info(get_upd_purchase.DELIVER_DEPT_ID,get_upd_purchase.location_id,1,1);
        attributes.branch_id = listlast(location_info_,',');
        attributes.txt_departman_ =listfirst(location_info_,',');
        attributes.city_id = get_upd_purchase.city_id;
        attributes.county_id = get_upd_purchase.county_id;
        attributes.deliver_comp_id = get_upd_purchase.deliver_comp_id;
        attributes.deliver_cons_id = get_upd_purchase.deliver_cons_id;
        attributes.ship_address_id = get_upd_purchase.ship_address_id;
        attributes.adres = trim(get_upd_purchase.ship_address);
        attributes.ship_method_id = get_upd_purchase.ship_method;
        attributes.order_detail = get_upd_purchase.order_detail;
        attributes.project_id = get_upd_purchase.project_id;
        attributes.subscription_id = get_upd_purchase.subscription_id;
        attributes.paymethod_id = get_upd_purchase.paymethod;
        attributes.card_paymethod_id = get_upd_purchase.card_paymethod_id;
        attributes.commethod_id = get_upd_purchase.commethod_id;
        </cfscript>
    </cfif>
    <cfif not (isdefined('attributes.service_ids') and len(attributes.service_ids))> <!--- servis modulunden cagrılmıssa servis basvurusunun belge nosu irsaliyeye taşınır --->
        <cf_papers paper_type = "ship">
    </cfif>
	<cfif not (isdefined('attributes.service_ids') and len(attributes.service_ids))>
        <cfif isdefined("paper_full")><cfset txt_paper=paper_full><cfelse><cfset txt_paper=""></cfif>		
    </cfif>
    <cfif isdefined('attributes.service_ids') and len(attributes.service_ids)> <!--- servis modulunden cagırılıyorsa --->
		<cfset attributes.basket_id = 48> 
    <cfelseif isdefined('attributes.order_id') and len(attributes.order_id)><!--- stock - emirlerden cagırılıyorsa --->
        <cfset attributes.basket_id = 14>
    <cfelseif session.ep.isBranchAuthorization eq 1><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
        <cfset attributes.basket_id = 21> 
    <cfelseif isdefined('attributes.is_from_report') and len(attributes.is_from_report)>	<!--- isbak için yapılan özel raporda kullanılıyor. --->
        <cfset attributes.basket_id = 10>
    <cfelse>
        <cfset attributes.basket_id = 10>
    </cfif>
    <cfif not isdefined('attributes.is_ship_copy') and not isdefined('attributes.service_ids') and not isdefined('attributes.order_id') and not isdefined('attributes.is_from_report')> <!--- irsaliye kopyalamadan gelmiyorsa --->
        <cfif not isdefined("attributes.file_format")>
            <cfset attributes.form_add = 1>
        <cfelse>
            <cfset attributes.basket_sub_id = 21>
        </cfif> 
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	<cf_xml_page_edit fuseact="stock.form_add_sale">
	<cfset attributes.upd_id = url.ship_id>
    <cfset attributes.cat ="">
    <cfinclude template="../stock/query/get_upd_purchase.cfm">
    <cfscript>
		if(get_upd_purchase.is_with_ship eq 1 and GET_INV_SHIPS.recordcount neq 0)
			session_basket_kur_ekle(action_id=GET_INV_SHIPS.INVOICE_ID,table_type_id:1,process_type:1);
		else
			session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);
    </cfscript>
    <cfquery name="CONTROL_SHIP_RESULT" datasource="#DSN2#">
        SELECT
            SR.SHIP_ID,
            S.SHIP_RESULT_ID
        FROM
            SHIP_RESULT_ROW SR,
            SHIP_RESULT S
        WHERE
            S.SHIP_RESULT_ID = SR.SHIP_RESULT_ID AND
            SR.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND
            S.IS_TYPE IS NULL
    </cfquery>
    <cfset attributes.ship_type = get_upd_purchase.ship_type>
    <cfset company_id = get_upd_purchase.company_id>
	<cfset attributes.company_id = get_upd_purchase.company_id>
	<cfif not get_upd_purchase.recordcount>
		<cfset hata  = 11>
        <cfsavecontent variable="message"><cf_get_lang_main no='585.Şube Yetkiniz Uygun Değil'> <cf_get_lang_main no='586.Veya'> <cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</cfsavecontent>
        <cfset hata_mesaj  = message>
        <cfinclude template="../dsp_hata.cfm">
        <cfabort>
   	</cfif>
    <cfquery name="get_ship_services" datasource="#DSN2#">
        SELECT DISTINCT SERVICE_ID FROM SHIP_ROW WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND SERVICE_ID IS NOT NULL
    </cfquery>
    <cfif get_ship_services.recordcount><cfset attributes.service_id = get_ship_services.service_id></cfif>
    <cfif Len(get_upd_purchase.service_id)>
        <cfquery name="get_service" datasource="#dsn3#">
            SELECT SERVICE_NO FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.service_id#">
        </cfquery>
    </cfif>
    <cfquery name="PACKEGE_CONTROL" datasource="#DSN2#">
        SELECT SHIP_ID FROM SHIP_PACKAGE_LIST WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
    </cfquery>
     <cfquery name="GET_SF" datasource="#dsn2#">
        SELECT FIS_ID FROM STOCK_FIS WHERE RELATED_SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_id#">
    </cfquery><!--- irsaliye ve demirbaş bağlantısı kontrol ediliyor, eğerki irsalieye bağlı demirbş stok fişinin demirbaşların ilişkili olduğu başka bir irsaliye varsa silme güncelleme vs işlemi yapılmaz, yoksa demirbaşlar silinip yeniden oluşturulur. --->
    <cfif get_sf.recordcount>
        <cfquery name="GET_INVENTORY" datasource="#dsn3#">
            SELECT		
                INVENTORY_ID
            FROM
                INVENTORY_ROW
            WHERE
                PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                AND ACTION_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_SF.FIS_ID#">
                AND PROCESS_TYPE = 1182
                AND INVENTORY_ID IN (SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_ID = #GET_SF.FIS_ID# AND PERIOD_ID = #session.ep.period_id#)
                AND SUBSCRIPTION_ID IS NOT NULL
        </cfquery>
        <cfquery name="GET_AMORTIZATION_COUNT" datasource="#DSN3#">
            SELECT 
                COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
            FROM 
                INVENTORY I,
                INVENTORY_ROW IR,
                INVENTORY_AMORTIZATON IA
            WHERE 
                I.INVENTORY_ID = IR.INVENTORY_ID
                AND IA.INVENTORY_ID = IR.INVENTORY_ID
                AND IR.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sf.fis_id#">
                AND IR.PERIOD_ID = #session.ep.period_id#
                AND IR.PROCESS_TYPE = 118
        </cfquery>
        <cfquery name="GET_SALE_COUNT" datasource="#DSN3#">
            SELECT 
                IR.INVENTORY_ROW_ID
            FROM 
                INVENTORY I,
                INVENTORY_ROW IR
            WHERE 
                I.INVENTORY_ID = IR.INVENTORY_ID
                AND IR.INVENTORY_ID IN(SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE ACTION_ID = #GET_SF.FIS_ID#)
                AND IR.PROCESS_TYPE = 66
        </cfquery>
    <cfelse>
        <cfset get_sale_count.recordcount = 0>
        <cfset get_amortization_count.recordcount = 0>
        <cfset get_inventory.recordcount = 0>
    </cfif>
	<cfif len(get_upd_purchase.paymethod_id)>
		<cfset attributes.paymethod_id = get_upd_purchase.paymethod_id>
        <cfinclude template="../stock/query/get_paymethod.cfm">
	<cfelseif len(get_upd_purchase.card_paymethod_id)>
    	<cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
            SELECT 
                CARD_NO
                <cfif get_upd_purchase.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si irsaliyeye tasınıyor) --->
                ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                ,COMMISSION_MULTIPLIER 
                </cfif>
            FROM 
                CREDITCARD_PAYMENT_TYPE 
            WHERE 
                PAYMENT_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.card_paymethod_id#">
        </cfquery>
	</cfif>
    <!--- Irsaliyenin bulundugu donem ile birlikte sonraki donemlerde de kullanilmis olabilir, hepsi gelmelidir, bu sekilde yeniden duzenledim FBS 20120316 --->
    <cfquery name="Get_Ship_Period" datasource="#dsn#">
        SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> ORDER BY PERIOD_YEAR ASC
    </cfquery>
    <cfif Get_Ship_Period.RecordCount>
        <cfquery name="get_inv" datasource="#dsn2#">
            <cfloop query="Get_Ship_Period">
                <cfset new_period_dsn = '#dsn#_#Get_Ship_Period.Period_Year#_#Get_Ship_Period.Our_Company_Id#'>
                SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM #new_period_dsn#.INVOICE_SHIPS WHERE SHIP_ID = #GET_UPD_PURCHASE.SHIP_ID# AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                <cfif Get_Ship_Period.currentrow neq Get_Ship_Period.recordcount>UNION ALL</cfif>
            </cfloop>
        </cfquery>
    </cfif>
    <cfquery name="GET_OUR_COMP_INF" datasource="#DSN#">
        SELECT IS_SHIP_UPDATE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
	<cfif listgetat(attributes.fuseaction,1,'.') is 'service'>
        <cfset attributes.basket_id = 48> 
    <cfelseif session.ep.isBranchAuthorization eq 1><!--- subeden cagırılıyorsa sube basket sablonunu kullansın--->
        <cfset attributes.basket_id = 21> 
    <cfelse>
        <cfset attributes.basket_id = 10>
    </cfif>
</cfif>
<script type="text/javascript">
	$(document).ready(function(){
		<cfif not isdefined("attributes.event") or attributes.event is 'add'>
			<cfif not isdefined("attributes.process_cat")>	
				toptan_satis_sec();
			</cfif>
		<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
			check_process_is_sale();
		</cfif>
		});
function add_order()
{
	if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
	{	
		str_irslink = '&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value;
		<cfif session.ep.our_company_info.project_followup eq 1>
			if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		</cfif>
		str_irslink = str_irslink + '&order_system_id_list=form_basket.order_system_id_list';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
		return true;
	}
	else
	{
		alert("<cf_get_lang no='303.Önce Üye Seçiniz'>");
		return false;
	}
}
function add_irsaliye()
{
	if(form_basket.company_id.value.length || form_basket.consumer_id.value.length || form_basket.employee_id.value.length)
	{ 
		str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif fusebox.circuit eq "store">+'&is_store='+1</cfif>;
		<cfif session.ep.our_company_info.project_followup eq 1>
			if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		 </cfif>
		 <cfif xml_control_process_type eq 1>
			if(document.form_basket.process_cat.value == '')
			{
				alert("İşlem Tipi Seçmelisiniz !");
				return false;
			}
		</cfif>
		str_irslink = str_irslink+'&process_cat='+form_basket.process_cat.value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship&from_ship=1' + str_irslink,'page');
		return true;
	}
	else
	{
		alert("<cf_get_lang no='303.Önce Üye Seçiniz'>!");
		return false;
	}
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
	{
		if(form_basket.company_id.value!="")
		{
			str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id&field_id=form_basket.deliver_comp_id';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&select_list=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
			document.getElementById('deliver_cons_id').value = '';
			return true;
		}
		else
		{
			str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id&field_id=form_basket.deliver_cons_id';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&select_list=2&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
			document.getElementById('deliver_comp_id').value = '';
			return true;
		}
	}
	else
	{
		alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'>!");
		return false;
	}
}
function check_process_is_sale()
{/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
	var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	if(selected_ptype!='')
	{
		eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
		<cfif attributes.basket_id is 10>
			if(proc_control==78||proc_control==79)
				sale_product= 0;
			else
				sale_product = 1;
		</cfif>
		<cfif x_add_dispatch_ship eq 1 and isdefined("get_upd_purchase") and get_upd_purchase.ship_type eq 72>		
			if(proc_control ==72)
				show_dispatch_ship_link.style.display='';
			else
				show_dispatch_ship_link.style.display='none';
		</cfif>
		if(list_find('78,79',proc_control))
		{ 
			td_ship_text_.style.display = '';
			td_ship_id_.style.display='';
		}
		else
		{
			td_ship_text_.style.display = 'none';
			td_ship_id_.style.display = 'none';
		}
	}
	return true;
}
function kontrol_firma()
{
	if(!paper_control(form_basket.ship_number,'SHIP')) return false;
	if(!chk_period(form_basket.ship_date,"İşlem")) return false;
	if(!chk_process_cat('form_basket')) return false;
	<cfif session.ep.our_company_info.subscription_contract eq 1>
		<cfif xml_control_order_system eq 1>
		if(document.form_basket.order_system_id_list.value != '' && document.form_basket.subscription_id.value == '')
			{
			alert('<cf_get_lang_main no="1420.Abone"><cf_get_lang_main no="322.Seçiniz">!');
			return false;
			}
		if(document.form_basket.order_system_id_list.value != '' && document.form_basket.subscription_id.value != '')
			{
			var system_list_uzunluk_ = list_len(document.form_basket.order_system_id_list.value);
			for(var str_i_row=1; str_i_row <= system_list_uzunluk_; str_i_row++)
				{
					var deger_ = list_getat(document.form_basket.order_system_id_list.value,str_i_row);
					if(deger_ != document.form_basket.subscription_id.value)
						{
						alert('<cf_get_lang no="95.İlgili İrsaliyeye Bağlı Siparişlerin Sistemleri İle İrsaliyede Seçilen Sistem Aynı Olmalıdır">!');
						return false;
						}
				}
			}
		</cfif>
	</cfif>
	
	if(form_basket.deliver_date_frm.value.length)
	{
		if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",form_basket.deliver_date_frm.value, 'Lütfen Geçerli Bir Tarih Giriniz!'))
		return false;
	}
	if(form_basket.partner_id.value =="" && form_basket.consumer_id.value =="" && form_basket.employee_id.value =="")
	{
		alert("<cf_get_lang no='131.Cari Hesap Seçmelisiniz'> !");
		return false;
	}
	if(document.form_basket.txt_departman_.value=="" || document.form_basket.department_id.value=="")
	{
		alert("<cf_get_lang no='507.Depo Seçmelisiniz'>!");
		return false;
	}
	<cfif xml_show_service_app eq 2> // Servis Basvuru Zorunlu ise
		if(document.getElementById("service_app_id").value == "" || document.getElementById("service_app_no").value == "")
		{
			alert("Girilmesi Zorunlu Alan: Servis Başvurusu !");
			return false;
		}
	</cfif>
	if (!check_display_files('form_basket')) return false;
	if(document.form_basket.irsaliye_iptal != undefined && document.form_basket.irsaliye_iptal.checked == false)
	{
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value)) return false;
			}
		}
	}
	if(check_stock_action('form_basket'))
	{
		var basket_zero_stock_status = wrk_safe_query('stk_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
		if(basket_zero_stock_status.IS_SELECTED != 1)
		{
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,temp_process_type.value)) return false;
		}
	}
	if(check_inventory('form_basket'))//demirbaş kontrolleri
	{
		var control_inv_type = wrk_safe_query('stk_kontrol_inv_type','dsn3');
		if(control_inv_type.recordcount == 0)
		{
			alert("<cf_get_lang no='97.Demirbaş Stok Fişi İşlem Kategorisi Tanımlayınız'> !");
			return false;
		}
		inv_product_list='';
		for(var str=0; str < window.basket.items.length; str++)
			{
				if(window.basket.items[str].PRODUCT_ID != '')
				{
					var listParam = window.basket.items[str].PRODUCT_ID + "*" + "<cfoutput>#session.ep.period_id#</cfoutput>";
					var get_inventory_kontrol =  wrk_safe_query("stk_kontrol_inv_type2","dsn3",0,listParam);
					if(get_inventory_kontrol.recordcount == 0 || get_inventory_kontrol.INVENTORY_CAT_ID == '')
						inv_product_list = inv_product_list + eval(str+1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
				}
			}
		if(inv_product_list != '')
		{
			alert("<cf_get_lang no='98.Aşağıda Belirtilen Ürünler İçin Sabit Kıymet Tanımlarını Kontrol Ediniz'>! \n\n" + inv_product_list);
			return false;
		}
	}
	var deger = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
	var fis_no = eval("document.form_basket.ct_process_type_" + deger).value;
	<cfif xml_control_process_type eq 1>
	<cfoutput>
		if(fis_no == 79)//konsinye irsaliye ise kontrol yapacak
		{
			var ship_product_list = '';
			var wrk_row_id_list_new = '';
			var amount_list_new = '';
				for(var str_i_row=0; str_i_row < window.basket.items.length; str_i_row++)
				{
					if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
						{
							if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID))
							{
								row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
								amount_info = list_getat(amount_list_new,row_info);
								amount_info = parseFloat(amount_info) + window.basket.items[str_i_row].AMOUNT);
								amount_list_new = list_setat(amount_list_new,row_info,amount_info);
							}
							else
							{
								wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
								amount_list_new = amount_list_new + ',' + window.basket.items[str_i_row].AMOUNT;
							}
					}
				}
				for(var str_i_row=0; str_i_row < window.basket.items.length; str_i_row++)
				{
					if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
					{
						var get_inv_control = wrk_safe_query("inv_get_ship_control2","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID );	
						var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
						
						if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
						{
							new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
							var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
							new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
						}
						else
							new_dsn2 = "#dsn2#";
						var get_ship_control =  wrk_safe_query("stk_get_ship_control",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
						row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
						amount_info = list_getat(amount_list_new,row_info);
						var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
						if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
						{
							if(total_inv_amount > get_ship_control.AMOUNT)
								ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
						}
					}
				}			
			if(ship_product_list != '')
			{
				alert("<cf_get_lang no='106.Aşağıda Belirtilen Ürünler İçin İade Miktarı Konsinye Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
				return false;
			}
		}
		else if(fis_no == 78)//toptan satis iade irsaliye ise kontrol yapacak
		{
			var ship_product_list = '';
			var wrk_row_id_list_new = '';
			var amount_list_new = '';
			for(var str_i_row=0; str_i_row < window.basket.items.length; str_i_row++)
			{
				if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
				{
					if(list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID))
					{
						row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
						amount_info = list_getat(amount_list_new,row_info);
						amount_info = parseFloat(amount_info) + window.basket.items[str_i_row].AMOUNT;
						amount_list_new = list_setat(amount_list_new,row_info,amount_info);
					}
					else
					{
						wrk_row_id_list_new = wrk_row_id_list_new + ',' + window.basket.items[str_i_row].WRK_ROW_RELATION_ID;
						amount_list_new = amount_list_new + ',' + window.basket.items[str_i_row].AMOUNT;
					}
				}
			}
			for(var str_i_row=0; str_i_row < window.basket.items.length; str_i_row++)
			{
				if(window.basket.items[str_i_row].PRODUCT_ID != '' && window.basket.items[str_i_row].WRK_ROW_RELATION_ID != '' && window.basket.items[str_i_row].ROW_SHIP_ID != '')
				{
					var get_inv_control = wrk_safe_query("inv_get_ship_control3","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);	
					var get_inv_control2 =  wrk_safe_query("inv_get_inv_control","dsn2",0,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
					
					if(list_len(window.basket.items[str_i_row].ROW_SHIP_ID,';') > 1)
					{
						new_period = list_getat(window.basket.items[str_i_row].ROW_SHIP_ID,2,';');
						var get_period = wrk_safe_query("stk_get_period","dsn",0,new_period);
						new_dsn2 = "#dsn#"+"_"+get_period.PERIOD_YEAR+"_"+get_period.OUR_COMPANY_ID;	
					}
					else
						new_dsn2 = "#dsn2#";
					var get_ship_control =  wrk_safe_query("stk_get_ship_control",new_dsn2,0, window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
					row_info = list_find(wrk_row_id_list_new,window.basket.items[str_i_row].WRK_ROW_RELATION_ID);
					amount_info = list_getat(amount_list_new,row_info);
					var total_inv_amount = parseFloat(get_inv_control2.AMOUNT)+parseFloat(get_inv_control.AMOUNT)+parseFloat(amount_info);
					if(get_ship_control != undefined && get_ship_control.recordcount > 0 && get_ship_control.AMOUNT >0 && get_inv_control != undefined && get_inv_control.recordcount > 0 && total_inv_amount >0)
					{
						if(total_inv_amount > get_ship_control.AMOUNT)
							ship_product_list = ship_product_list + eval(str_i_row+1) + '.Satır : ' + window.basket.items[str_i_row].PRODUCT_NAME + '\n';
					}
				}
			}
			if(ship_product_list != '')
			{
				alert("<cf_get_lang no='112.Aşağıda Belirtilen Ürünler İçin İade Miktarı Alım Miktarından Fazla Lütfen Ürünleri Kontrol Ediniz'> ! \n\n" + ship_product_list);
				return false;
			}
		}
	</cfoutput>
	</cfif>
	<cfif not isdefined("attributes.event") or attributes.event is 'add'>
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
		<cfif isdefined("xml_serialno_control") and (xml_serialno_control eq 1)>
			prod_name_list = '';
			for(var str=0; str < window.basket.items.length; str++)
			{
				if(window.basket.items[str].PRODUCT_ID != '')
				{
					wrk_row_id_ = window.basket.items[str].WRK_ROW_ID;
					amount_ = window.basket.items[str].AMOUNT;
					product_serial_control = wrk_safe_query("chk_product_serial1",'dsn3',0, window.basket.items[str].PRODUCT_ID);
					str1_ = "SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID = '"+ wrk_row_id_ +"'";
					var get_serial_control = wrk_query(str1_,'dsn3');
					if(product_serial_control.IS_SERIAL_NO=='1'&&get_serial_control.recordcount!=amount_)
					{
						prod_name_list = prod_name_list + eval(str +1) + '.Satır : ' + window.basket.items[str].PRODUCT_NAME + '\n';
					}
				}
			}
			if(prod_name_list!='')
			{
				alert(prod_name_list +" Adlı Ürünler İçin Seri Numarası Girmelisiniz!");
				return false;
			}
		</cfif>
	</cfif>
	<!---Satır bazında seri girilmesi zorunluluğu kontrolü --->
	<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1>
		project_field_name = 'project_head';
		project_field_id = 'project_id';
		apply_deliver_date('',project_field_name,project_field_id);
	</cfif>
	saveForm();
	return false;
}
<cfif not isdefined("attributes.event") or attributes.event is 'add'>	
	<cfif not isdefined("attributes.process_cat")>
		function toptan_satis_sec()
		{
			if(form_basket.process_cat.options.length != undefined && form_basket.process_cat.options.value == '')
			{
				max_sel = form_basket.process_cat.options.length;
				for(my_i=0;my_i<max_sel;my_i++)
				{
					deger = form_basket.process_cat.options[my_i].value;
					if(deger!="")
					{
						var fis_no = eval("form_basket.ct_process_type_" + deger );
						if(fis_no.value == <cfif listgetat(attributes.fuseaction,1,'.') is 'service'>141<cfelse>71</cfif>)
						{
							form_basket.process_cat.options[my_i].selected = true;
							my_i = max_sel + 1;
						}
					}
				}
			}
		}
	</cfif>
	function change_date()
	{
		document.form_basket.deliver_date_frm.value = document.form_basket.ship_date.value;
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	function kontrol2()
	{	
		if(document.form_basket.process_cat.value == '')
		{
			alert("İşlem Tipi Seçmelisiniz !");
			return false;
		}
	
		if (!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.ship_date,"İşlem")) return false;
		else if (form_basket.del_ship.value =1);
		return true;
	}
	function send_packetship()
	{
		$("#add_packetship").submit();
	}

</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.form_add_sale';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/form_add_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_sale.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.form_add_sale&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(detail_inv_purchase_ship)";

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.form_add_sale';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/form_upd_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_sale.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.form_add_sale&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ship_id=##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.ship_id##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_sale)";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_sale&ship_id=#attributes.ship_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/upd_sale.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/upd_sale.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_purchase';
		WOStruct['#attributes.fuseaction#']['del']['extraParams'] = 'active_period&process_cat&irsaliye_id_listesi&upd_id&old_process_type&del_ship&ship_number';
	}

	if((not isdefined('attributes.event') or attributes.event is 'add') and listgetat(attributes.fuseaction,1,'.') is not 'service')
	{
		//<cfinclude template="../query/get_find_ship_js.cfm">
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_from_file&from_where=3";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
			
	}
	else if(attributes.event is 'upd')
	{
		if(listgetat(attributes.fuseaction,1,'.') is not 'service')
		{
		 //   <cfinclude template="../query/get_find_ship_js.cfm">
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_ID' action_id='#url.ship_id#'>";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.form_upd_sale&action_name=ship_id&action_id=#attributes.ship_id#&relation_papers_type=SHIP_ID','list')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[479]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=stock.list_packetship&event=detail&window=detail&process_id=#attributes.upd_id#','project')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array.item[268]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_ship_receive_rate&ship_id=#attributes.ship_id#&is_sale=1','list','popup_list_ship_receive_rate')";
		counter_ = 3;

        if(session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is not 'service')
		{
			counter_ = counter_ + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#-#lang_array_main.item[170]#';

			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";
			counter_ = counter_ + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#";
		}
		if (session.ep.our_company_info.guaranty_followup and listgetat(attributes.fuseaction,1,'.') is 'service')
		{
			counter_ = counter_ + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#-#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_add_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#','list')";
			counter_ = counter_ + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array_main.item[305]#-#lang_array_main.item[306]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['js'] = "javascript:window.opener.location.href='#request.self#?fuseaction=stock.list_serial_operations&is_filtre=1&belge_no=#get_upd_purchase.ship_number#&process_cat_id=#get_upd_purchase.ship_type#&process_id=#attributes.UPD_ID#';self.close();";
		}
		if(session.ep.our_company_info.workcube_sector eq 'it')
		{
			counter_ = counter_ + 1;
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array_main.item[2267]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_upd_ship_stock_rows&process_cat_id=#get_upd_purchase.ship_type#&upd_id=#attributes.UPD_ID#&in_or_out=0','list')";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		if(listgetat(attributes.fuseaction,1,'.') is not 'service')
		{
			if(x_add_dispatch_ship eq 1 and get_upd_purchase.ship_type eq 72)//konsinye çıkış irsaliyesiyse ve xmlde depo sevke donustur secilmişse
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array.item[567]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "#request.self#?fuseaction=stock.add_ship_dispatch&ship_id=#url.ship_id#&from_sale_ship=3";
			}
			if(not control_ship_result.recordcount)
			{
				counter_ = counter_ + 1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['text'] = '#lang_array.item[500]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][#counter_#]['onClick'] = "javascript:send_packetship()";
			}
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=add";
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&is_ship_copy=1&event=add&ship_id=#url.ship_id#";

		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		if(fuseaction contains 'service')
			faction = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30&keyword=service','page')";
		else
			faction = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_id#&print_type=30','page')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "#faction#";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockSaleShip';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-process_cat','item-comp_name','item-ship_number','item-ship_date','item-deliver_date_frm','item-txt_departman_']"; 
</cfscript>