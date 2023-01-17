<cf_get_lang_set module_name="campaign">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.tmarket_id" default="">
    <cfif isdefined('attributes.form_submit')>
        <cfif fusebox.circuit is 'campaign'>
            <cfquery name="TMARKET" datasource="#DSN3#">
                SELECT
                    *
                FROM
                    TARGET_MARKETS
                WHERE
                    1=1 
                    <cfif isdefined("attributes.tmarket_module") and attributes.tmarket_module is 'call'>
                        AND TMARKET_ID IN (SELECT DISTINCT TMARKET_ID FROM TARGET_AUDIENCE_RECORD)
                    </cfif>
                    <cfif isDefined("attributes.tmarket_id") and len(attributes.tmarket_id)>
                        AND TMARKET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.tmarket_id#">)
                    <cfelseif isdefined("attributes.keyword") and len(attributes.keyword)>
                        AND (TMARKET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                        TMARKET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
                    </cfif>
                    <cfif isDefined("attributes.is_active") and len(attributes.is_active) and (attributes.is_active) neq 2>
                        AND IS_ACTIVE = #attributes.is_active#
                    </cfif>	
                ORDER BY
                    RECORD_DATE DESC
            </cfquery>
        </cfif>
    <cfelse>
        <cfset tmarket.recordcount = 0 >
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.is_active" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#tmarket.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif fuseaction contains "popup">
      <cfset is_popup=1>
    <cfelse>
      <cfset is_popup=0>
    </cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfif attributes.event is 'add'>
		<cfset xml_page_control_list = 'is_mail_list,is_company,is_consumer,is_segmentasyon,is_rel_type,is_ims_code,is_sales_part,is_hobby,is_rel_consmember,is_rel_represent,is_rel_members,is_company_type,is_product_category'>
        <cf_get_lang_set module_name="campaign">
    <cfelse>
    	<cfset xml_page_control_list = 'is_mail_list,is_company,is_consumer,is_segmentasyon,is_rel_type,is_ims_code,is_sales_part,is_hobby,is_rel_consmember,is_rel_represent,is_rel_members'>
    </cfif>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1" fuseact="campaign.form_add_target_market">
    <cfparam name="attributes.req_comp" default="">
    <cfparam name="attributes.req_cons" default="">
    <cfparam name="attributes.connect_member" default="">
    <cfif attributes.event is 'add'>
        <cfparam name="attributes.comp_want_eamil" default="2">
        <cfparam name="attributes.cons_want_eamil" default="2">
    <cfelse>
    	<cfparam name="attributes.is_active" default="">
    </cfif>
    <cfquery name="GET_COUNTRY" datasource="#DSN#">
        SELECT
            COUNTRY_ID,
            COUNTRY_NAME,
            COUNTRY_PHONE_CODE,
            IS_DEFAULT
        FROM
            SETUP_COUNTRY
        ORDER BY
            COUNTRY_NAME
    </cfquery>
    <cfif isdefined("is_company_type") and is_company_type eq 1>
        <cfquery name="get_firm_type" datasource="#dsn#">
            SELECT 
                FIRM_TYPE, 
                FIRM_TYPE_ID 
            FROM 
                SETUP_FIRM_TYPE 
            ORDER BY 
                FIRM_TYPE 
        </cfquery>
    </cfif>
    <cfquery name="GET_OUR_COMPANIES" datasource="#DSN#">
        SELECT 
            COMP_ID,
            NICK_NAME,
            RECORD_EMP,
            RECORD_DATE,
            UPDATE_EMP,
            UPDATE_DATE
        FROM
            OUR_COMPANY
    </cfquery>
    <cfquery name="ALL_DEPARTMENTS" datasource="#DSN#">
        SELECT 
            BRANCH_NAME,
            BRANCH_ID 
        FROM 
            BRANCH
        ORDER BY 
            BRANCH_NAME
    </cfquery>
    <cfquery name="TMARKET" datasource="#DSN3#">
        SELECT
            *
        FROM
            TARGET_MARKETS
        WHERE
            1=1 
            <cfif isdefined("attributes.tmarket_module") and attributes.tmarket_module is 'call'>
                AND TMARKET_ID IN (SELECT DISTINCT TMARKET_ID FROM TARGET_AUDIENCE_RECORD)
            </cfif>
            <cfif isDefined("attributes.tmarket_id") and len(attributes.tmarket_id)>
                AND TMARKET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.tmarket_id#">)
            <cfelseif isdefined("attributes.keyword") and len(attributes.keyword)>
                AND (TMARKET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                TMARKET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
            <cfif isDefined("attributes.is_active") and len(attributes.is_active) and (attributes.is_active) neq 2>
                AND IS_ACTIVE = #attributes.is_active#
            </cfif>	
        ORDER BY
            RECORD_DATE DESC
    </cfquery>
	<cfif attributes.event is 'add'>
        <cfinclude template="../campaign/query/get_product_cats.cfm">
    </cfif>
    <cfinclude template="../campaign/query/get_consumer_cats.cfm">
    <cfinclude template="../campaign/query/get_company_cats.cfm">
    <cfinclude template="../campaign/query/get_company_size_cats.cfm">
    <cfinclude template="../campaign/query/get_sector_cats.cfm">
    <cfinclude template="../campaign/query/get_partner_positions.cfm">
    <cfinclude template="../campaign/query/get_partner_departments.cfm">
    <cfif attributes.event is 'upd'>
	    <cfinclude template="../campaign/query/get_sector_cats.cfm">
    </cfif>
    <cfquery name="get_customer_value" datasource="#dsn#">
        SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
    </cfquery>
    <cfquery name="get_ims_code" datasource="#dsn#">
        SELECT IMS_CODE_ID,	IMS_CODE, IMS_CODE_NAME	FROM SETUP_IMS_CODE	WHERE IMS_CODE_ID IS NOT NULL ORDER BY IMS_CODE
    </cfquery>
    <cfquery name="get_hobby" datasource="#dsn#">
        SELECT HOBBY_ID,HOBBY_NAME FROM SETUP_HOBBY ORDER BY HOBBY_NAME
    </cfquery>
    <cfquery name="GET_SALES_ZONE" datasource="#dsn#">
        SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
    </cfquery>
    <cfquery name="GET_EDU_LEVEL" datasource="#dsn#">
        SELECT EDU_LEVEL_ID, EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL
    </cfquery>
    <cfquery name="GET_INCOME_LEVEL" datasource="#DSN#">
        SELECT INCOME_LEVEL_ID, INCOME_LEVEL FROM SETUP_INCOME_LEVEL ORDER BY INCOME_LEVEL
    </cfquery>    
    <cfif attributes.event is 'upd'>
    	<cfif isdefined("is_product_category") and is_product_category eq 1 >
			<cfif len(tmarket.comp_productcat_list)>
                <cfquery name="get_productCat" datasource="#dsn3#">
                        SELECT 
                            HIERARCHY,
                            PRODUCT_CAT,
                            PRODUCT_CATID
                        FROM 
                            PRODUCT_CAT
                        WHERE
                            PRODUCT_CATID IN (#tmarket.comp_productcat_list#)
                </cfquery>
            </cfif>
        </cfif>
        <cfif len(tmarket.COMPANY_COUNTY_ID)>
            <cfquery name="get_company_county" datasource="#dsn#">
                SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#tmarket.COMPANY_COUNTY_ID#)
            </cfquery>
        <cfelse>
            <cfset get_company_county.recordcount=0>
        </cfif>
        <cfif len(tmarket.company_city_id)>
            <cfquery name="get_company_city" datasource="#dsn#">
                SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#tmarket.company_city_id#)
            </cfquery>
        <cfelse>
            <cfset get_company_city.recordcount=0>
        </cfif>
        <cfif len(tmarket.county_id)>
            <cfquery name="get_cons_county" datasource="#dsn#">
                SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#tmarket.county_id#)
            </cfquery>
        <cfelse>
            <cfset get_cons_county.recordcount=0>
        </cfif>
        <cfif len(tmarket.city_id)>
            <cfquery name="get_cons_city" datasource="#dsn#">
                SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#tmarket.city_id#)
            </cfquery>
        <cfelse>
            <cfset get_cons_city.recordcount=0>
        </cfif>
    </cfif>
    <cfquery name="get_req" datasource="#DSN#">
        SELECT 
            REQ_ID,
            REQ_NAME,
            REQ_DETAIL,
            RECORD_DATE,
            RECORD_EMP,
            UPDATE_DATE,
            UPDATE_EMP
        FROM 
            SETUP_REQ_TYPE
    </cfquery>
    <cfquery name="get_commethod_types" datasource="#dsn#">
        SELECT
            COMMETHOD_ID,
            COMMETHOD,
            RECORD_DATE,
            RECORD_EMP,
            UPDATE_DATE,
            UPDATE_EMP 
        FROM 
            SETUP_COMMETHOD 
        ORDER BY 
            COMMETHOD
    </cfquery>
    <cfquery name="get_paymethod" datasource="#dsn#">
        SELECT
            SP.PAYMETHOD_ID,
            SP.PAYMETHOD,
            SP.RECORD_DATE,
            SP.RECORD_EMP,
            SP.UPDATE_DATE,
            SP.UPDATE_EMP
       FROM 
            SETUP_PAYMETHOD SP,
            SETUP_PAYMETHOD_OUR_COMPANY SPOC
        WHERE 
            SP.PAYMETHOD_STATUS = 1
            AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
            AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY 
            SP.PAYMETHOD
    </cfquery>
    <cfquery name="get_kk_paymethod" datasource="#dsn3#">
        SELECT PAYMENT_TYPE_ID,CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE IS_ACTIVE = 1 ORDER BY CARD_NO
    </cfquery>
    <cfquery name="get_process_cats" datasource="#dsn#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.add_consumer%">
    </cfquery>
    <cfquery name="get_process_cats_part" datasource="#dsn#">
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
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
    </cfquery>
</cfif>

<script type="text/javascript">
	$( document ).ready(function() {
		<cfif (isdefined("attributes.event") and attributes.event is 'add')>
			row_count1= 0;
			row_count2= 0;
			row_count3= 0;
			row_count4= 0;
			add_row1();
			add_row2();
			add_row3();
			add_row4();
		<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
			row_count1= <cfoutput>#listlen(tmarket.order_product_id)#</cfoutput>;
			row_count2= <cfoutput>#listlen(tmarket.order_productcat_id)#</cfoutput>;
			row_count3= <cfoutput>#listlen(tmarket.promotion_id)#</cfoutput>;
			row_count4= <cfoutput>#listlen(tmarket.training_id)#</cfoutput>;
			if(row_count1 == 0)
				add_row1();
			if(row_count2 == 0)
				add_row2();
			if(row_count3 == 0)
				add_row3();
			if(row_count4 == 0)
				add_row4();
		</cfif>
	});
	<cfif isdefined("is_segmentasyon")>
		var is_segmentasyon = '<cfoutput>#is_segmentasyon#</cfoutput>';
	</cfif>
	function remove_field(field_option_name)
	{
		<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
			field_option_name_value = eval('document.tmarketform.' + field_option_name);
		<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
			field_option_name_value = document.getElementById(field_option_name);
		</cfif>
		if(field_option_name_value != undefined)
		for (i=field_option_name_value.options.length-1;i>-1;i--)
		{
			if (field_option_name_value.options[i].selected==true)
			{
				field_option_name_value.options.remove(i);
			}	
		}
	}
	function select_all(selected_field)
	{
		if(eval("document.tmarketform." + selected_field + "") != undefined)
		{
			var m = eval("document.tmarketform." + selected_field + ".length");
			for(i=0;i<m;i++)
			{
				eval("document.tmarketform."+selected_field+"["+i+"].selected=true")
			}
		}
	}
	function hepsini_sec()
	{
		<cfif isdefined("is_product_category") and is_product_category eq 1>
			select_all('product_category');
		</cfif>
		select_all('cons_city_id');
		select_all('cons_county_id');
		select_all('company_city_id');
		select_all('company_county_id');
		<cfif isdefined("is_rel_represent") and is_rel_represent eq 1>
			select_all('comp_agent_pos_code');
			select_all('cons_agent_pos_code');
		</cfif>
	}
	function limit_control()
	{
		if((document.getElementById("age_lower") != undefined) && (document.getElementById("age_lower").value != '') && (document.getElementById("age_upper").value != '') && (document.getElementById("age_lower").value > document.getElementById("age_upper").value))
		{
			alert("<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no='93.Yaş Aralığı !'>");
			return false;
		}
		
		if(document.getElementById('process_stage').value == "")
		{
			alert("Süreç Yetkiniz Yok!");
			return false;
		}
		<cfif (isdefined("attributes.event") and attributes.event is 'add')>
			if(document.getElementById('tmarket_membership_startdate') != undefined && document.getElementById('tmarket_membership_startdate').value!= '' &&document.getElementById('tmarket_membership_finishdate') != undefined && document.getElementById('tmarket_membership_finishdate').value != '' )
			{
				return date_check(tmarketform.tmarket_membership_startdate,tmarketform.tmarket_membership_finishdate,"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
			}
		</cfif>
		if ((document.getElementById("tmarket_membership_startdate") != undefined) && (document.getElementById("tmarket_membership_startdate").value != '') && (document.getElementById("tmarket_membership_finishdate").value != '') && !date_check(document.getElementById("tmarket_membership_startdate"),document.getElementById("tmarket_membership_finishdate"),"<cf_get_lang no='167.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır !'>"))
			return false;

			hepsini_sec();
		
		if(document.getElementById("order_amount") != undefined)
			document.getElementById("order_amount").value = filterNum(document.getElementById("order_amount").value);
		return true;
	}
	function check_order(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_order").checked == true)
				document.getElementById("is_not_order").checked = false;
		}
		else
		{
			if(document.getElementById("is_not_order").checked == true)
				document.getElementById("is_order").checked = false;
		}
	}
	function check_product(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_product_and").checked == true)
				document.getElementById("is_product_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_product_or").checked == true)
				document.getElementById("is_product_and").checked = false;
		}
	}
	function check_productcat(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_productcat_and").checked == true)
				document.getElementById("is_productcat_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_productcat_or").checked == true)
				document.getElementById("is_productcat_and").checked = false;
		}
	}
	function check_prom(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_prom_and").checked == true)
				document.getElementById("is_prom_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_prom_or").checked == true)
				document.getElementById("is_prom_and").checked = false;
		}
	}
	function check_prom_sel(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_prom_select").checked == true)
				document.getElementById("is_notprom_select").checked = false;
		}
		else
		{
			if(document.getElementById("is_notprom_select").checked == true)
				document.getElementById("is_prom_select").checked = false;
		}
	}
	function check_train(kont)
	{
		if(kont==1)
		{
			if(document.getElementById("is_train_and").checked == true)
				document.getElementById("is_train_or").checked = false;
		}
		else
		{
			if(document.getElementById("is_train_or").checked == true)
				document.getElementById("is_train_and").checked = false;
		}
	}
	<cfif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd') or not isdefined("attributes.event")>
		<cfif (isdefined("is_segmentasyon") and  is_segmentasyon eq 1) or not isdefined("is_segmentasyon")>
			
			function sil1(sy)
			{
				var my_element=document.getElementById("row_kontrol1"+sy);
				my_element.value=0;
				var my_element=eval("frm_row1"+sy);
				my_element.style.display="none";
			}
			function add_row1()
			{
				row_count1++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);	
				newRow.setAttribute("name","frm_row1" + row_count1);
				newRow.setAttribute("id","frm_row1" + row_count1);
				document.getElementById("record_num1").value=row_count1;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="hidden" name="row_kontrol1'+row_count1+'" id="row_kontrol1'+row_count1+'" value="1"><a style="cursor:pointer" onclick="sil1(' + row_count1 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count1 +'" id="product_id' + row_count1 +'"><input type="text" name="product_name' + row_count1 +'" id="product_name' + row_count1 +'" class="text" style="width:178px;" readonly>'
								+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=tmarketform.product_id" + row_count1 + "&field_name=tmarketform.product_name" + row_count1 + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom" alt="Ekle"></a>';
			}
			function sil2(sy)
			{
				var my_element=document.getElementById("row_kontrol2"+sy);
				my_element.value=0;
				var my_element=eval("frm_row2"+sy);
				my_element.style.display="none";
			}
			function add_row2()
			{
				row_count2++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
				newRow.setAttribute("name","frm_row2" + row_count2);
				newRow.setAttribute("id","frm_row2" + row_count2);
				document.getElementById("record_num2").value=row_count2;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input type="hidden" name="row_kontrol2'+row_count2+'" id="row_kontrol2'+row_count2+'" value="1"><a style="cursor:pointer" onclick="sil2(' + row_count2 + ');"><img  src="images/delete_list.gif" alt="" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="productcat_id' + row_count2 +'" id="productcat_id' + row_count2 +'"><input type="text" name="productcat_name' + row_count2 +'" id="productcat_name' + row_count2 +'" class="text" style="width:178px;" readonly>'
								+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=tmarketform.productcat_id" + row_count2 + "&field_name=tmarketform.productcat_name" + row_count2 + "</cfoutput>','list');"+'"><img src="/images/plus_thin.gif" border="0" alt="" align="absbottom"></a>';
			}
			function sil3(sy)
			{
				var my_element=document.getElementById("row_kontrol3"+sy);
				my_element.value=0;
				var my_element=eval("frm_row3"+sy);
				my_element.style.display="none";
			}
			function add_row3()
			{
				row_count3++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table3").insertRow(document.getElementById("table3").rows.length);	
				newRow.setAttribute("name","frm_row3" + row_count3);
				newRow.setAttribute("id","frm_row3" + row_count3);
				document.getElementById("record_num3").value=row_count3;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="row_kontrol3'+row_count3+'" id="row_kontrol3'+row_count3+'" value="1"><a style="cursor:pointer" onclick="sil3(' + row_count3 + ');"><img  src="images/delete_list.gif" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="promotion_id' + row_count3 +'" id="promotion_id' + row_count3 +'"><input type="text" name="promotion_name' + row_count3 +'" id="promotion_name' + row_count3 +'" class="text" style="width:178px;" readonly>'
								+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_promotions&prom_id=tmarketform.promotion_id" + row_count3 + "&prom_head=tmarketform.promotion_name" + row_count3 + "</cfoutput>','small');"+'"><img src="/images/plus_thin.gif" border="0" alt="Ekle" align="absbottom"></a>';
			}
			function sil4(sy)
			{
				var my_element=document.getElementById("row_kontrol4"+sy);
				my_element.value=0;
				var my_element=eval("frm_row4"+sy);
				my_element.style.display="none";
			}
			function add_row4()
			{
				row_count4++;
				var newRow;
				var newCell;
				newRow = document.getElementById("table4").insertRow(document.getElementById("table4").rows.length);	
				newRow.setAttribute("name","frm_row4" + row_count4);
				newRow.setAttribute("id","frm_row4" + row_count4);
				document.getElementById("record_num4").value=row_count4;
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="row_kontrol4'+row_count4+'" id="row_kontrol4'+row_count4+'" value="1"><a style="cursor:pointer" onclick="sil4(' + row_count4 + ');"><img  src="images/delete_list.gif" alt="Sil" border="0"></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.setAttribute('nowrap','nowrap');
				newCell.innerHTML = '<input  type="hidden" name="training_id' + row_count4 +'" id="training_id' + row_count4 +'"><input type="text" name="training_name' + row_count4 +'" id="training_name' + row_count4 +'" class="text" style="width:178px;" readonly>'
								+' '+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_list_trainings&field_id=tmarketform.training_id" + row_count4 + "&field_name=tmarketform.training_name" + row_count4 + "</cfoutput>','list');"+'"><img src="/images/plus_thin.gif" alt="Ekle" border="0" align="absbottom"></a>';
			}
		</cfif>
	</cfif>	
</script>
<cfif (isdefined("attributes.event") and attributes.event is 'add')>
	<cf_get_lang_set module_name="campaign">
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'campaign.form_add_target_market';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'campaign/form/form_add_target_market.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'campaign/query/add_target_market.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'campaign.list_target_markets&event=upd';		

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'campaign.form_upd_target_market';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'campaign/form/form_upd_target_market.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'campaign/query/upd_target_market.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'campaign.list_target_markets&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'tmarket_id=##attributes.tmarket_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.tmarket_id##';

	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_target_markets';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'campaign/display/list_target_markets.cfm';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'campaign.del_target_market&tmarket_id=#attributes.tmarket_id#&head=#tmarket.tmarket_no# #tmarket.tmarket_name#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'campaign/query/del_target_market.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'campaign/query/del_target_market.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'campaign.list_target_markets';
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
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array.item[126]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['href'] = "#request.self#?fuseaction=campaign.list_target_list&event=add&tmarket_id=#attributes.tmarket_id#";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['text'] = 'Oklar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['extra']['customTag'] = '<cf_np tablename="target_markets" primary_key="tmarket_id" pointer="tmarket_id=#attributes.tmarket_id#,event=upd" dsn_var="DSN3" ekstraUrlParams="event=upd">';

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Ekle';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=campaign.list_target_markets&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
