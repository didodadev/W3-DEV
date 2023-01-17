<cf_get_lang_set module ="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.keyword" default="">
	<cfif isdefined("attributes.is_submit")>
        <cfquery name="get_product_segment" datasource="#dsn1#">
            SELECT
                *
            FROM
                PRODUCT_SEGMENT
            <cfif len(attributes.keyword)>
            WHERE
                PRODUCT_SEGMENT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            </cfif>
            ORDER BY
                PRODUCT_SEGMENT
        </cfquery>
    <cfelse>
        <cfset get_product_segment.recordcount = 0>
    </cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_product_segment.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif get_product_segment.recordcount>
		<cfoutput query="get_product_segment" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
        	<cfquery name="get_product_segment_branch" datasource="#DSN1#">
                SELECT * FROM PRODUCT_SEGMENT_BRANCH WHERE PRODUCT_SEGMENT_ID = #product_segment_id#
            </cfquery>
			<cfset my_list="">
            <cfif get_product_segment_branch.recordcount>
                <cfset my_list=valuelist(get_product_segment_branch.product_segment_branch_id)>
                <cfquery name="get_name" datasource="#DSN#">
                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID IN (#my_list#) ORDER BY BRANCH_NAME
                </cfquery>
                <cfset 'branch_#product_segment_id#' = valuelist(get_name.branch_name)>
            <cfelse>
                <cfset 'branch_#product_segment_id#' = ''>
                <cfset get_product_segment_branch.recordcount=0>
                <cfset get_name.recordcount =0>
            </cfif>
        </cfoutput>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfif is_popup neq 1>
        <cfinclude template="../objects/display/tree_back.cfm">
        <cfinclude template="../objects/display/tree_back.cfm">
        <td <cfoutput>#td_back#</cfoutput>>
	</cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfquery name="get_product_seg" datasource="#dsn1#">
		SELECT * FROM PRODUCT_SEGMENT WHERE PRODUCT_SEGMENT_ID = #attributes.product_segment_id#
	</cfquery>
<cfelseif (isdefined("attributes.event") and attributes.event is 'addsube') or (isdefined("attributes.event") and attributes.event is 'updsube')>
	<cfinclude template="../product/query/get_branches.cfm">
	<cfif (isdefined("attributes.event") and attributes.event is 'updsube')>
    <cfset my_list1="">
		<cfif get_branch.recordcount>
            <cfoutput query="get_branch">
                <cfquery name="get_pro_seg_branch" datasource="#DSN1#">
                    SELECT * FROM PRODUCT_SEGMENT_BRANCH WHERE PRODUCT_SEGMENT_ID = #attributes.product_segment_id# AND PRODUCT_SEGMENT_BRANCH_ID = #get_branch.BRANCH_ID#
                </cfquery>                
                <cfif get_pro_seg_branch.recordcount>
                    <cfset my_list1=listappend(my_list1,(get_pro_seg_branch.PRODUCT_SEGMENT_BRANCH_ID),",")>           
                </cfif>
            </cfoutput>
        </cfif>
     </cfif>
</cfif>  

<cfif (isdefined("attributes.event") and attributes.event is 'add') or (isdefined("attributes.event") and attributes.event is 'upd')>
	<script type="text/javascript">
		function kontrol()		{
			 
			if($('#detail').val().length > 150)
			{
				alert("<cf_get_lang_main no='217.Aciklama'><cf_get_lang_main no ='1928.Max Karakter Sayisi'>:150");
				return false;
			}
				
			var error_ = 0;
			if(document.upd_product_segment.min_point_1.value.length>0 && document.upd_product_segment.max_point_1.value.length==0)
				error_ = 1;
			if(document.upd_product_segment.max_point_1.value.length>0 && document.upd_product_segment.min_point_1.value.length==0)
				error_ = 1;
			if(document.upd_product_segment.min_point_2.value.length>0 && document.upd_product_segment.max_point_2.value.length==0)
				error_ = 1;
			if(document.upd_product_segment.max_point_2.value.length>0 && document.upd_product_segment.min_point_2.value.length==0)
				error_ = 1;
			if(document.upd_product_segment.min_point_3.value.length>0 && document.upd_product_segment.max_point_3.value.length==0)
				error_ = 1;
			if(document.upd_product_segment.max_point_3.value.length>0 && document.upd_product_segment.min_point_3.value.length==0)
				error_ = 1;
		
			if(error_==1)
			{
				alert("<cf_get_lang no ='747.Seviye Değerlerini Düzenleyiniz'>!");
				return false;
			}
				
			if(document.upd_product_segment.min_point_1.value.length>0 && parseInt(document.upd_product_segment.min_point_1.value)>=parseInt(document.upd_product_segment.max_point_1.value))
				error_ = 1;
			if(document.upd_product_segment.min_point_2.value.length>0 && parseInt(document.upd_product_segment.min_point_2.value)>=parseInt(document.upd_product_segment.max_point_2.value))
				error_ = 1;
			if(document.upd_product_segment.min_point_3.value.length>0 && parseInt(document.upd_product_segment.min_point_3.value)>=parseInt(document.upd_product_segment.max_point_3.value))
				error_ = 1;
				
			if(error_==1)
			{
				alert("<cf_get_lang no ='747.Seviye Değerlerini Düzenleyiniz'>!");
				return false;
			}
			return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_segment';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_segment.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;		
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.list_product_segment';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_product_segment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_segment.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_segment';
	
	WOStruct['#attributes.fuseaction#']['addsube'] = structNew();
	WOStruct['#attributes.fuseaction#']['addsube']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['addsube']['fuseaction'] = 'product.list_product_segment';
	WOStruct['#attributes.fuseaction#']['addsube']['filePath'] = 'product/form/form_add_seg_branch.cfm';
	WOStruct['#attributes.fuseaction#']['addsube']['queryPath'] = 'product/query/add_pro_seg_branch.cfm';
	WOStruct['#attributes.fuseaction#']['addsube']['parameters'] = 'product_segment_id=##attributes.product_segment_id##';
	WOStruct['#attributes.fuseaction#']['addsube']['nextEvent'] = 'product.list_product_segment';
	
	WOStruct['#attributes.fuseaction#']['updsube'] = structNew();
	WOStruct['#attributes.fuseaction#']['updsube']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['updsube']['fuseaction'] = 'product.list_product_segment';
	WOStruct['#attributes.fuseaction#']['updsube']['filePath'] = 'product/form/form_upd_seg_branch.cfm';
	WOStruct['#attributes.fuseaction#']['updsube']['queryPath'] = 'product/query/upd_pro_seg.cfm';
	WOStruct['#attributes.fuseaction#']['updsube']['parameters'] = 'product_segment_id=##attributes.product_segment_id##';
	WOStruct['#attributes.fuseaction#']['updsube']['nextEvent'] = 'product.list_product_segment';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_product_segment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_segment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_segment.cfm';	
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'product_segment_id=##attributes.product_segment_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.product_segment_id##';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_segment&event=upd';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_product_segment';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_product_segment.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_product_segment.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_segment';
	
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=product.list_product_segment&event=add&is_popup=1','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
		
	}
	

</cfscript>
