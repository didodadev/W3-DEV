<cfparam name="attributes.order_code" default="">
<cfparam name="attributes.order_id" default="">
<cfparam name="attributes.order_company_code" default="">
<cfparam name="attributes.order_date" default="">
<cfparam name="attributes.order_company_order_list" default="">
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (#my_branch_list#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	TYPE_ID ASC
</cfquery>

<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>


<cfset is_purchase_type = attributes.is_purchase_type>
<cfset attributes.selected_product_id = attributes.product_id>
<cfset dept_count_ = attributes.dept_count_>

<cfif attributes.new_page eq 0>
    <cfinclude template="coloum_positions.cfm">
    <cfinclude template="../query/get_products.cfm">
    
    <cfform name="add_row1" action="" method="post">
        <cfinclude template="speed_manage_product_table_rows.cfm">
    </cfform>
<cfelse>
	<cfquery name="get_price_types" datasource="#dsn_dev#">
        SELECT
            *
        FROM
            PRICE_TYPES
        ORDER BY
            IS_STANDART DESC,
            TYPE_ID ASC
	</cfquery>
	
	<cfinclude template="../query/get_products.cfm">
   
    <cfoutput>Tablo Dolduruluyor!</cfoutput>
    <cfinclude template="../form/speed_manage_product_table_rows3.cfm">
    
        	<script>
				datarow = document.getElementById('add_icerik_area').value;
				window.opener.$("#jqxgrid").jqxGrid('addrow',null,JSON.parse(datarow));
				window.opener.$("#jqxgrid").jqxGrid('applyfilters');
				veri_ = window.opener.document.getElementById('all_product_list').value;
				
				if(veri_ != '')
					window.opener.document.getElementById('all_product_list').value = window.opener.document.getElementById('all_product_list').value + ',' + '<cfoutput>#all_p_list#</cfoutput>';
				else
					window.opener.document.getElementById('all_product_list').value = '<cfoutput>#all_p_list#</cfoutput>';
            </script>
    <cfif not isdefined("attributes.is_excel")>
    	<script>
		<cfoutput>
            window.location.href = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product&layout_id=#attributes.layout_id#&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#&new_page=#attributes.new_page#';
        </cfoutput>
		</script>
    <cfelse>
        <script>
		<cfoutput>
            var rows = window.opener.$('##jqxgrid').jqxGrid('getboundrows');
			eleman_sayisi = rows.length;
			
			<cfif isdefined("attributes.is_update_rows") and listlen(attributes.update_product_list)>
				update_product_list_ = '#attributes.update_product_list#';
			<cfelse>
				update_product_list_ = '';		
			</cfif>
			
			product_list_ = '#attributes.product_id#';
			
			for (var m=0; m < eleman_sayisi; m++)
			{
				rows[m].active_row = false;	
			}
			
			for (var m=0; m < eleman_sayisi; m++)
			{
				if((product_list_ != '' && list_find(product_list_,rows[m].product_id)) || (update_product_list_ != '' && list_find(update_product_list_,rows[m].product_id)))
				{
					rows[m].active_row = true; 
					if(update_product_list_ != '' && list_find(update_product_list_,rows[m].product_id))
					{
						rows[m].standart_alis = eval("standart_alis_" + rows[m].product_id);
						rows[m].standart_alis_indirim_tutar = 0;
						rows[m].standart_alis_indirim_yuzde = eval("standart_alis_indirim_yuzde_" + rows[m].product_id);
					}				
					window.opener.std_p_discount_calc(m,'standart_alis',rows[m].standart_alis);
				}
			}
			window.opener.grid_duzenle();
			window.opener.secilileri_getir();
			window.location.href = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product_excel&layout_id=#attributes.layout_id#&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#&new_page=#attributes.new_page#';
        </cfoutput>
        </script>
    </cfif>
</cfif>
