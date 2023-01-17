<cfif attributes.action_type eq -1>
	<cfoutput>
		<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=10&op_f_name=add_row_#attributes.row_no#</cfoutput>','list');"><i class="icn-md fa fa-plus-square"></i></a>
	<script>
		function add_row_#attributes.row_no#(pid_,pname_,psales_)
		{
			icerik_ = '<div id="row_#attributes.row_no#_selected_product_' + pid_ + '">';
			icerik_ += '<a href="javascript://" onclick="del_row_p_#attributes.row_no#(' + pid_ +')">';
			icerik_ += '<img src="/images/delete_list.gif">';
			icerik_ += '</a>';
			icerik_ += '<input type="hidden" name="row_#attributes.row_no#_search_product_id" value="' + pid_ + '">';
			icerik_ += pname_;
			icerik_ += '</div>';
			$("##row_action_detail_#attributes.row_no#").append(icerik_);
		}
		
		function del_row_p_#attributes.row_no#(pid_)
		{
			$("##row_#attributes.row_no#_selected_product_" + pid_).remove();	
		}
	</script>
	</cfoutput>
<cfelseif attributes.action_type eq -8>
	<cfoutput>
		<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products&type=11&op_f_name=b_add_row_#attributes.row_no#</cfoutput>','list');"><i class="icn-md fa fa-plus-square"></i></a>
		<input type="text" name="manuel_barcode_#attributes.row_no#" style="width:100px;" id="manuel_barcode_#attributes.row_no#" value=""/>
        <a href="javascript://" onclick="add_manuel_#attributes.row_no#();"><i class="icn-md fa fa-plus-square"></i></a>
	<script>
		function b_add_row_#attributes.row_no#(barcode_)
		{
			icerik_ = '<div id="b_row_#attributes.row_no#_selected_product_' + barcode_ + '">';
			icerik_ += '<a href="javascript://" onclick="b_del_row_p_#attributes.row_no#(' + barcode_ +')">';
			icerik_ += '<img src="/images/delete_list.gif">';
			icerik_ += '</a>';
			icerik_ += '<input type="hidden" name="b_row_#attributes.row_no#_search_product_id" value="' + barcode_ + '">';
			icerik_ += barcode_;
			icerik_ += '</div>';
			$("##row_action_detail_#attributes.row_no#").append(icerik_);
		}
		
		function add_manuel_#attributes.row_no#()
		{
			deger_ = document.getElementById('manuel_barcode_#attributes.row_no#').value;
			if(deger_ != '')
			{
				b_add_row_#attributes.row_no#(deger_);	
			}	
		}
		
		function b_del_row_p_#attributes.row_no#(barcode_)
		{
			$("##b_row_#attributes.row_no#_selected_product_" + barcode_).remove();	
		}
	</script>
	</cfoutput>
<cfelseif attributes.action_type eq -2>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT 
            PRODUCT_CAT.PRODUCT_CATID, 
            PRODUCT_CAT.HIERARCHY, 
            PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
        FROM 
            PRODUCT_CAT,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = #session.ep.company_id# AND
            PRODUCT_CAT.HIERARCHY NOT LIKE '%.%'
        ORDER BY 
            HIERARCHY ASC
    </cfquery>
    <cf_multiselect_check 
        query_name="GET_PRODUCT_CAT"
        selected_text="" 
        name="hierarchy1_#attributes.row_no#"
        option_text="Ana Grup" 
        width="150"
        height="250"
        option_name="PRODUCT_CAT_NEW" 
        option_value="hierarchy"
        onchange="run_hierarchy1_#attributes.row_no#();"
        value="">
       <script>
		<cfoutput>
			function run_hierarchy1_#attributes.row_no#()
			{
				var selectedItems = $("##hierarchy1_#attributes.row_no#").multiselect("getChecked").map(function() 
				{
					return this.title;
				}).get();
				div_name_ = 'row_action_detail_#attributes.row_no#';
				document.getElementById(div_name_).innerHTML = selectedItems;
			}
		</cfoutput>
	</script>
<cfelseif attributes.action_type eq -6>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT 
            PRODUCT_CAT.PRODUCT_CATID, 
            PRODUCT_CAT.HIERARCHY, 
            PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
        FROM 
            PRODUCT_CAT,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = #session.ep.company_id# AND
            PRODUCT_CAT.HIERARCHY LIKE '%.%' AND
        	PRODUCT_CAT.HIERARCHY NOT LIKE '%.%.%'
        ORDER BY 
            HIERARCHY ASC
    </cfquery>
    <cf_multiselect_check 
        query_name="GET_PRODUCT_CAT"
        selected_text="" 
        name="hierarchy2_#attributes.row_no#"
        option_text="Alt Grup 1" 
        width="150"
        height="250"
        option_name="PRODUCT_CAT_NEW" 
        option_value="hierarchy"
        onchange="run_hierarchy2_#attributes.row_no#();"
        value="">
     <script>
		<cfoutput>
			function run_hierarchy2_#attributes.row_no#()
			{
				var selectedItems = $("##hierarchy2_#attributes.row_no#").multiselect("getChecked").map(function() 
				{
					return this.title;
				}).get();
				div_name_ = 'row_action_detail_#attributes.row_no#';
				document.getElementById(div_name_).innerHTML = selectedItems;
			}
		</cfoutput>
	</script>
<cfelseif attributes.action_type eq -7>
	<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT 
            PRODUCT_CAT.PRODUCT_CATID, 
            PRODUCT_CAT.HIERARCHY, 
            PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
        FROM 
            PRODUCT_CAT,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = #session.ep.company_id# AND
            PRODUCT_CAT.HIERARCHY LIKE '%.%.%' 
        ORDER BY 
            HIERARCHY ASC
    </cfquery>
    <cf_multiselect_check 
        query_name="GET_PRODUCT_CAT"
        selected_text="" 
        name="hierarchy3_#attributes.row_no#"
        option_text="Alt Grup 2" 
        width="150"
        height="250"
        option_name="PRODUCT_CAT_NEW" 
        option_value="hierarchy"
        onchange="run_hierarchy3_#attributes.row_no#();"
        value="">
     <script>
		<cfoutput>
			function run_hierarchy3_#attributes.row_no#()
			{
				var selectedItems = $("##hierarchy3_#attributes.row_no#").multiselect("getChecked").map(function() 
				{
					return this.title;
				}).get();
				div_name_ = 'row_action_detail_#attributes.row_no#';
				document.getElementById(div_name_).innerHTML = selectedItems;
			}
		</cfoutput>
	</script>
<cfelseif attributes.action_type eq -3>
	<cfquery name="get_product_kdvs" datasource="#dsn2#">
        SELECT * FROM SETUP_TAX ORDER BY TAX ASC
    </cfquery>
    <cf_multiselect_check 
        query_name="get_product_kdvs"
        selected_text=""  
        name="tax_ids_#attributes.row_no#"
        option_text="KDV" 
        width="150"
        height="250"
        option_name="TAX" 
        option_value="TAX"
        onchange="run_kriter_kdv_#attributes.row_no#();"
        value="">
     <script>
		<cfoutput>
			function run_kriter_kdv_#attributes.row_no#()
			{
				var selectedItems = $("##tax_ids_#attributes.row_no#").multiselect("getChecked").map(function() 
				{
					return this.title;
				}).get();
				div_name_ = 'row_action_detail_#attributes.row_no#';
				document.getElementById(div_name_).innerHTML = selectedItems;
			}
		</cfoutput>
	</script>
<cfelseif attributes.action_type gt 0>
	<cfquery name="get_alt_kriters" datasource="#dsn_Dev#">
        SELECT * FROM EXTRA_PRODUCT_TYPES_SUBS WHERE TYPE_ID = #attributes.action_type# ORDER BY SUB_TYPE_NAME ASC
    </cfquery>
    <cf_multiselect_check 
        query_name="get_alt_kriters"
        selected_text=""  
        name="sub_type_ids_#attributes.row_no#"
        option_text="Alt Tanımlar" 
        width="150"
        height="250"
        option_name="SUB_TYPE_NAME" 
        option_value="SUB_TYPE_ID"
        onchange="run_kriter_subs_#attributes.row_no#();"
        value="">
    <script>
		<cfoutput>
			function run_kriter_subs_#attributes.row_no#()
			{
				var selectedItems = $("##sub_type_ids_#attributes.row_no#").multiselect("getChecked").map(function() 
				{
					return this.title;
				}).get();
				div_name_ = 'row_action_detail_#attributes.row_no#';
				document.getElementById(div_name_).innerHTML = selectedItems;
			}
		</cfoutput>
	</script>
</cfif>