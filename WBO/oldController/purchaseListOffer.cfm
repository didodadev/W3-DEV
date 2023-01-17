<cf_get_lang_set module_name="purchase">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact ="purchase.list_offer">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.offer_number" default="">
    <cfparam name="attributes.currency_id" default="">
    <cfparam name="attributes.offer_stage" default="">
    <cfparam name="attributes.public_partner" default="">
    <cfparam name="attributes.offer_status" default="1">
    <cfif isdefined("xml_employee") and xml_employee eq 1>
        <cfparam name="attributes.employee_id" default="#session.ep.userid#">
        <cfparam name="attributes.employee" default="#session.ep.name# #session.ep.surname#">
    <cfelse>
        <cfparam name="attributes.employee_id" default="">
        <cfparam name="attributes.employee" default="">
    </cfif>
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.listing_type" default="1">
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date = wrk_get_today()>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih="attributes.finish_date">
    <cfelse>
        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
            <cfset attributes.finish_date=''>
        <cfelse>
            <cfset attributes.finish_date = date_add('ww',1,attributes.start_date)>
        </cfif>
    </cfif>
    <cfif isdefined("attributes.public_start_date") and isdate(attributes.public_start_date)>
        <cf_date tarih="attributes.public_start_date">
    <cfelse>
        <cfset attributes.public_start_date = "">
    </cfif>
    <cfif isdefined("attributes.public_finish_date") and isdate(attributes.public_finish_date)>
        <cf_date tarih="attributes.public_finish_date">
    <cfelse>
        <cfset attributes.public_finish_date = "">
    </cfif>
    <cfif isdefined("attributes.is_form_submit")>
        <cfscript>
            get_offer_list_action = createObject("component", "purchase.cfc.get_offer_list");
            get_offer_list_action.dsn3 = dsn3;
            get_offer_list = get_offer_list_action.get_offer_list_fnc
                (	
                    listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                    product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
                    product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                    keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                    offer_number : '#IIf(IsDefined("attributes.offer_number"),"attributes.offer_number",DE(""))#',
                    currency_id : '#IIf(IsDefined("attributes.currency_id"),"attributes.currency_id",DE(""))#',
                    offer_stage : '#IIf(IsDefined("attributes.offer_stage"),"attributes.offer_stage",DE(""))#',
                    public_partner : '#IIf(IsDefined("attributes.public_partner"),"attributes.public_partner",DE(""))#',
                    offer_status : '#IIf(IsDefined("attributes.offer_status"),"attributes.offer_status",DE(""))#',
                    employee : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(""))#',
                    employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                    company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                    company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
                    consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                    public_start_date : '#IIf(IsDefined("attributes.public_start_date"),"attributes.public_start_date",DE(""))#',
                    public_finish_date : '#IIf(IsDefined("attributes.public_finish_date"),"attributes.public_finish_date",DE(""))#',
                    start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                    finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                    project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                    project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#'
                );
        </cfscript>
    <!---	<cfinclude template="../query/get_offer_list.cfm">--->
    <cfelse>
        <cfset get_offer_list.recordcount = 0>
    </cfif>
    <cfquery name="get_process_type" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_offer%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cffunction name="total_price">
        <cfargument name="id_" type="numeric">
        <cfargument name="total_" type="numeric" default="1">
        <cfargument name="type_" type="numeric" default="1">
        <cfquery name="get_total_sum" datasource="#dsn3#">
            SELECT
                <cfif total_ eq 1>
                    <cfif type_ eq 1>SUM(PRICE)<cfelse>PRICE</cfif> TOTAL_PRICE
                <cfelse>
                    <cfif type_ eq 1>SUM(OTHER_MONEY_VALUE)<cfelse>PRICE_OTHER</cfif> TOTAL_PRICE
                </cfif>
            FROM
                <cfif type_ eq 1>OFFER<cfelse>OFFER_ROW</cfif>
            WHERE
                <cfif type_ eq 1>OFFER_ID<cfelse>OFFER_ROW_ID</cfif> = #id_#
        </cfquery>
        <cfif get_total_sum.recordcount>
            <cfreturn get_total_sum.total_price>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>
    <cfinclude template="../purchase/query/get_offer_currencies.cfm">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_offer_list.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>   
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
    <cfinclude template="../purchase/query/get_moneys.cfm">
    <cfinclude template="../purchase/query/get_taxes.cfm">
    <cfinclude template="../purchase/query/get_setup_priority.cfm">
    <cfinclude template="../purchase/query/get_offer_currencies.cfm">
    <cfscript>
        if(isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id))
            session_basket_kur_ekle(process_type:1,table_type_id:7,action_id:attributes.internaldemand_id);
        else if(isdefined('attributes.offer_id') and len(attributes.offer_id))
            session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:url.offer_id);
        else if(isdefined('attributes.for_offer_id') and len(attributes.for_offer_id))
            session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:url.for_offer_id);
        else
            session_basket_kur_ekle(process_type:0);
    </cfscript>
    <cfif isdefined('attributes.internal_row_info')>
        <cfscript>
            internald_row_amount_list ="";
            internald_row_id_list ="";
            internaldemand_id_list ="";
            for(ind_i=1; ind_i lte listlen(attributes.internal_row_info); ind_i=ind_i+1)
            {
                temp_row_info_ = listgetat(attributes.internal_row_info,ind_i);
                if(isdefined('add_stock_amount_#replace(temp_row_info_,";","_")#') and len(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#')) )
                {
                    internald_row_amount_list = listappend(internald_row_amount_list,filterNum(evaluate('add_stock_amount_#replace(temp_row_info_,";","_")#'),4));
                    internald_row_id_list = listappend(internald_row_id_list,listlast(temp_row_info_,';'));
                    if(not listfind(internaldemand_id_list,listfirst(temp_row_info_,';')))
                        internaldemand_id_list = listappend(internaldemand_id_list,listfirst(temp_row_info_,';'));
                }
            }
        </cfscript>
    </cfif>
    <cfif isdefined('attributes.offer_id') and len(attributes.offer_id) or isdefined('attributes.for_offer_id') and len(attributes.for_offer_id)>
        <cfinclude template="../purchase/query/get_offer_detail.cfm">
    </cfif>
    <cfif isdefined('attributes.offer_id') and len(attributes.offer_id) or isdefined('attributes.for_offer_id') and len(attributes.for_offer_id)>
        <cfscript>
            attributes.offer_head = get_offer_detail.offer_head;
            attributes.offer_detail = get_offer_detail.offer_detail;
            attributes.ship_method_id = get_offer_detail.ship_method;
            attributes.paymethod_id = get_offer_detail.paymethod;
            attributes.card_paymethod_id = get_offer_detail.card_paymethod_id;
            attributes.comission_rate = get_offer_detail.card_paymethod_rate;
            attributes.priority = get_offer_detail.priority_id;
            attributes.offer_currency = get_offer_detail.offer_currency;
            attributes.ref_no = get_offer_detail.ref_no;
            if(len(get_offer_detail.deliver_place) and len(get_offer_detail.location_id))
            {
                location_info_ = get_location_info(get_offer_detail.deliver_place,get_offer_detail.location_id,1,1);
                attributes.branch_id = listlast(location_info_,',');
                attributes.deliver_state_id = get_offer_detail.deliver_place;
                attributes.deliver_loc_id = get_offer_detail.location_id;
                attributes.deliver_state = listfirst(location_info_,',');
            }
            else
            {
                attributes.branch_id = "";
                attributes.deliver_state_id = "";
                attributes.deliver_loc_id = "";
                attributes.deliver_state = "";
            }
            attributes.project_id = get_offer_detail.project_id;
            attributes.work_id = get_offer_detail.work_id;
            if(not isdefined("attributes.deliverdate"))
            attributes.deliverdate = dateformat(get_offer_detail.deliverdate,'dd/mm/yyyy');
            attributes.startdate = dateformat(get_offer_detail.startdate,'dd/mm/yyyy');
            attributes.finishdate = dateformat(get_offer_detail.finishdate,'dd/mm/yyyy');
            attributes.offer_finishdate = dateformat(get_offer_detail.offer_finishdate,'dd/mm/yyyy');
            attributes.is_public_zone = get_offer_detail.is_public_zone;
            attributes.is_partner_zone = get_offer_detail.is_partner_zone;
        </cfscript>
    <cfelseif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id) or (isdefined("internaldemand_id_list") and len(internaldemand_id_list))>
        <cfquery name="get_internaldemand_info" datasource="#dsn3#">
            SELECT 
                I.SUBJECT,
                I.PROJECT_ID,
                I.DEPARTMENT_IN,
                I.LOCATION_IN,
                I.SHIP_METHOD,
                I.TARGET_DATE,
                I.NOTES,
                I.REF_NO,
                I.PRIORITY,
                I.WORK_ID,
                I.INTERNAL_NUMBER
             FROM 
                 INTERNALDEMAND I
             WHERE 
                <cfif isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id)>
                    I.INTERNAL_ID = #attributes.internaldemand_id#
                <cfelseif Len(internaldemand_id_list)>
                    I.INTERNAL_ID IN (#internaldemand_id_list#)
                </cfif>
        </cfquery>
        <cfset internal_number_list = listdeleteduplicates(valuelist(get_internaldemand_info.INTERNAL_NUMBER,','))>
        <cfscript>
            attributes.offer_head = get_internaldemand_info.subject;
            attributes.offer_detail = get_internaldemand_info.notes;
            attributes.ship_method_id = get_internaldemand_info.ship_method;
            attributes.paymethod_id = "";
            attributes.card_paymethod_id = "";
            attributes.comission_rate = "";
            attributes.priority = get_internaldemand_info.priority;
            attributes.offer_currency = "";
            attributes.ref_no = get_internaldemand_info.ref_no;
            if(len(get_internaldemand_info.department_in) and len(get_internaldemand_info.location_in))
            {
                location_info_ = get_location_info(get_internaldemand_info.department_in,get_internaldemand_info.location_in,1,1);
                attributes.branch_id = listlast(location_info_,',');
                attributes.deliver_state_id = get_internaldemand_info.department_in;
                attributes.deliver_loc_id = get_internaldemand_info.location_in;
                attributes.deliver_state = listfirst(location_info_,',');
            }
            else
            {
                location_info_ = "";
                attributes.branch_id = "";
                attributes.deliver_state_id = "";
                attributes.deliver_loc_id = "";
                attributes.deliver_state = "";
            }
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,',')),',') eq 1)
                attributes.project_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.project_id,','));
            else
                attributes.project_id = "";
            if(ListLen(ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,',')),',') eq 1)
                attributes.work_id = ListDeleteDuplicates(ValueList(get_internaldemand_info.work_id,','));
            else
                attributes.work_id = "";
            attributes.deliverdate = dateformat(get_internaldemand_info.target_date,'dd/mm/yyyy');
            attributes.startdate = "";
            attributes.finishdate = "";
            attributes.offer_finishdate = "";
            attributes.is_public_zone = "";
            attributes.is_partner_zone = "";
        </cfscript>
    <cfelse>
    <cfsavecontent variable="message"><cf_get_lang no='39.Teklif İstiyoruz'></cfsavecontent>
        <cfscript>
            attributes.offer_head = "#message#";
            attributes.offer_detail = "";
            attributes.ship_method_id = "";
            attributes.paymethod_id = "";
            attributes.card_paymethod_id = "";
            attributes.comission_rate = "";
            attributes.priority = "";
            attributes.offer_currency = "";
            attributes.ref_no = "";
            attributes.branch_id = "";
            attributes.deliver_state_id = "";
            attributes.deliver_loc_id = "";
            attributes.deliver_state = "";
            if(not isdefined("attributes.deliverdate"))
            attributes.deliverdate = "";
            attributes.startdate = "";
            attributes.finishdate = "";
            attributes.offer_finishdate = "";
            attributes.is_public_zone = "";
            attributes.is_partner_zone = "";
        </cfscript>
    </cfif> 
    <cfset offer_to_info = 0>
<cfif isdefined("get_offer_detail")>
	<cfset partner_list = "">
	<cfset consumer_list = "">
	<cfif Len(get_offer_detail.offer_to_partner)><cfset partner_list = get_offer_detail.offer_to_partner></cfif>
	<cfif Len(get_offer_detail.offer_to_consumer)><cfset consumer_list = get_offer_detail.offer_to_consumer></cfif>
	<cfif (ListLen(partner_list)+ListLen(consumer_list)) eq 1>
		<cfif ListLen(partner_list)>
			<cfset offer_to_info = 1>
		<cfelse>
			<cfset offer_to_info = 2>
		</cfif>
	</cfif>
</cfif>
	<cfif isdefined('attributes.internal_row_info')><!--- iç talepler listesinden olusturulacaksa --->
        <cfset attributes.basket_related_action = 1> 
    </cfif>
    <cfset attributes.basket_id=5>
    <cfif isdefined('attributes.internaldemand_id') and len(attributes.internaldemand_id)>
        <cfset attributes.id = attributes.internaldemand_id>
        <cfset attributes.basket_sub_id = 5>
    <cfelseif isdefined("attributes.internal_row_info") and len(attributes.internal_row_info)>
        <cfset attributes.internal_row_info = attributes.internal_row_info>
        <cfset attributes.basket_sub_id = 5>
    <cfelseif isdefined("attributes.offer_id") and len(attributes.offer_id)>
        <cfset attributes.offer_id = url.offer_id>
    <cfelseif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id) and not isdefined("attributes.file_format")>
        <cfset attributes.offer_id = url.for_offer_id>
    <cfelseif not isdefined("attributes.file_format")>
        <cfset attributes.form_add = 1>
    <cfelse>
        <cfset attributes.basket_sub_id = 22>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>  
    <cf_xml_page_edit fuseact="purchase.detail_offer_ta">
    <cfscript>session_basket_kur_ekle(process_type:1,table_type_id:4,action_id:url.offer_id);</cfscript>
    <cfinclude template="../purchase/query/get_offer_detail.cfm">
    <cfinclude template="../purchase/query/get_moneys.cfm">
    <cfinclude template="../purchase/query/get_taxes.cfm">
    <cfif not get_offer_detail.recordcount or (isdefined("attributes.active_company") and attributes.active_company neq session.ep.company_id)>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfinclude template="../purchase/query/get_offer_currencies.cfm">
    <cfinclude template="../purchase/query/get_setup_priority.cfm">
    <cfinclude template="../purchase/query/get_stores.cfm">
    <cfset attributes.basket_id = 5>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	$( document ).ready(function() {
		document.getElementById('keyword').focus();
	});
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	function kontrolOfferAdd()
		{
			
			//Bagli Teklifte Tekli Cari Secimi Kontrolu
			if(form_basket.partner_names != undefined && (form_basket.partner_names.value == "" || (form_basket.partner_ids.value == "" && form_basket.consumer_ids.value == "")))
			{
				alert ("<cf_get_lang no='132.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
			//Ana Teklifte Teklif Istenenler Kontrolu, Public disinda zorunlu
			else if(form_basket.is_public_zone != undefined && form_basket.is_public_zone.checked == false)
			{
				var count = 0;
				var uzunluk_par = document.getElementsByName('to_par_ids').length;
				for(cind=0;cind<uzunluk_par;cind=cind+1)
				{
					my_obj_par = (uzunluk_par ==1)?document.getElementById('to_par_ids'):document.all.to_par_ids[cind];
					if(my_obj_par.value != '')//silinmemiş ise..
						count++;
				}
				var uzunluk_cons = document.getElementsByName('to_cons_ids').length;
				for(cid=0;cid<uzunluk_cons;cid=cid+1)
				{
					my_obj_cons = (uzunluk_cons ==1)?document.getElementById('to_cons_ids'):document.all.to_cons_ids[cid];
					if(my_obj_cons.value != '')//silinmemiş ise..
						count++;
				}
				if(count == 0)
				{
					alert ("<cf_get_lang no='175.Teklif İstenen Kişileri Seçmediniz'>!");
					return false;
				}
			}
			return (process_cat_control() && saveForm());
		}
	
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
		function sil(no,head)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.popup_del_offer&is_popup=1&offer_id='+ no + '&head='+ head ,'small');
		}
		function unformat_fields()
		{
			return true;
		}
		function kontrolOffer()
		{
			//Bagli Teklifte Tekli Cari Secimi Kontrolu
			if(form_basket.partner_names != undefined && (form_basket.partner_names.value == "" || (form_basket.partner_ids.value == "" && form_basket.consumer_ids.value == "")))
			{
				alert ("<cf_get_lang no='132.Cari Hesap Seçmelisiniz'>!");
				return false;
			}
			//Ana Teklifte Teklif Istenenler Kontrolu, Public disinda zorunlu
			else if(form_basket.is_public_zone != undefined && form_basket.is_public_zone.checked == false)
			{
				var count = 0;
				var uzunluk_par = document.getElementsByName('to_par_ids').length;
				for(cind=0;cind<uzunluk_par;cind=cind+1)
				{
					my_obj_par = (uzunluk_par ==1)?document.getElementById('to_par_ids'):document.all.to_par_ids[cind];
					if(my_obj_par.value != '')//silinmemiş ise..
						count++;
				}
				var uzunluk_cons = document.getElementsByName('to_cons_ids').length;
				for(cid=0;cid<uzunluk_cons;cid=cid+1)
				{
					my_obj_cons = (uzunluk_cons ==1)?document.getElementById('to_cons_ids'):document.all.to_cons_ids[cid];
					if(my_obj_cons.value != '')//silinmemiş ise..
						count++;
				}
				if(count == 0)
				{
					alert ("<cf_get_lang no='175.Teklif İstenen Kişileri Seçmediniz'>!");
					return false;
				}
			}
			return (process_cat_control() && saveForm());
		}
</cfif>
<cfif  isdefined("attributes.event") and ListFindNoCase('add,upd',attributes.event)>
		function opener_control()
		{
			var stock_id_list_ = '';
			if(document.all.product_id != undefined && form_basket.product_id.length >1)<!--- birden fazla satır var ise --->
			{
				var bsk_rowCount = document.all.product_id.length; 
				for(var brc=0; brc < bsk_rowCount; brc++)
				{	
					if(brc == 0)
						var stock_id_list_ = document.all.stock_id[brc].value;
					else
						var stock_id_list_ = stock_id_list_ +','+ document.all.stock_id[brc].value;
				}
			}
			else if (document.all.product_id != undefined && document.all.stock_id.value != '')<!--- tek satır var ise --->
			{
				var stock_id_list_ = document.all.stock_id.value;
			}
			if(stock_id_list_ != '')
			{
				var get_emp_ozel_code = wrk_query("SELECT SC.COMPANY_ID COMPANY_ID FROM SETUP_COMPANY_STOCK_CODE SC,STOCKS S WHERE SC.STOCK_ID = S.STOCK_ID AND S.STOCK_ID IN ("+stock_id_list_+") AND SC.IS_ACTIVE = 1","dsn1");
				if(get_emp_ozel_code.recordcount)
					document.all.comp_id_list.value = get_emp_ozel_code.COMPANY_ID;
			}
		}
</cfif>
</script>


<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'purchase.list_offer';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'purchase/display/list_offer.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'purchase.list_offer';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'purchase/form/add_offer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'purchase/query/add_offer.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'purchase.list_offer&event=upd';
	WOStruct['#attributes.fuseaction#']['add']['js'] = "javascript:gizle_goster_basket(add_offer);";
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'purchase.list_offer';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'purchase/form/detail_offer_ta.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'purchase/query/upd_offer.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'purchase.list_offer&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'offer_id=##attributes.offer_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##get_offer_detail.offer_number##';
	WOStruct['#attributes.fuseaction#']['upd']['js'] = "javascript:gizle_goster_basket(upd_offer);";
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=purchase.emptypopup_del_offer&offer_id=#get_offer_detail.OFFER_ID#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'purchase/query/del_offer.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'purchase/query/del_offer.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'purchase.list_offer';
	}
		
		
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=purchase.detail_offer_ta&action_name=offer_id&action_id=#attributes.offer_id#&relation_papers_type=OFFER_ID','list');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_offer_history&offer_id=#attributes.offer_id#&portal_type=employee','work')";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['text'] = '#lang_array.item[197]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][2]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_cost&id=#attributes.offer_id#&page_type=3&basket_id=#attributes.basket_id#','work');";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['text'] = '#lang_array_main.item[1034]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][3]['href'] = "#request.self#?fuseaction=purchase.form_add_order&offer_id=#attributes.offer_id#";
		if(not len(get_offer_detail.for_offer_id))
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['text'] = '#lang_array.item[198]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][4]['onClick'] = "windowopen('#request.self#?fuseaction=purchase.popup_list_coming_offer&offer_id=#attributes.offer_id#&basket_id=#attributes.basket_id#&is_popup=1','wwide');";
		
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['text'] = '#lang_array_main.item[2591]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][5]['href'] = "#request.self#?fuseaction=sales.form_add_offer&offer_id=#attributes.offer_id#&ref=offer";
	
			
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['text'] = '#lang_array.item[31]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][6]['onClick'] = "changePages('basket_main_div','other_details');";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=purchase.form_add_offer";
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array.item[64]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=purchase.list_offer&event=add&offer_id=#attributes.offer_id#';
	
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] =  '#lang_array_main.item[62]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] ="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.offer_id#&print_type=90','page');";
		}
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'purchaseListOffer';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'OFFER';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item15']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>