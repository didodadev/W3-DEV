<cf_get_lang_set module_name="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
   <cfquery name="GET_PRO_COMP" datasource="#DSN3#">
        SELECT 
            DETAIL,
            COMPETITIVE_ID,
            COMPETITIVE 
        FROM 
            PRODUCT_COMP
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="GET_PRO_COMP" datasource="#DSN3#">
        SELECT * FROM PRODUCT_COMP WHERE COMPETITIVE_ID = #attributes.id#
    </cfquery>
    <cfquery name="GET_PRO_PERM_POS" datasource="#DSN3#">
        SELECT STATUS, POSITION_CODE AS POS_CODE FROM PRODUCT_COMP_PERM WHERE COMPETITIVE_ID = #attributes.id#
    </cfquery>
    <cfquery name="GET_PRO_PERM_PAR" datasource="#DSN3#">
        SELECT STATUS, PARTNER_ID FROM PRODUCT_COMP_PERM WHERE COMPETITIVE_ID = #attributes.id#
    </cfquery>
    <cfset attributes.competitive_id = attributes.id>
    <cfif isDefined("session.product.emps") and not isDefined("attributes.session_delete")>
        <cfset structdelete(session.product,"emps")>
    </cfif>
    <cfif isDefined("session.product.pars") and not isDefined("attributes.session_delete")>
        <cfset structdelete(session.product,"pars")>
    </cfif>
    <cfif not isDefined("session.product.emps")>
        <cfset session.product.emps=arraynew(1)>
        <cfif get_pro_perm_pos.recordcount>
            <cfloop query="get_pro_perm_pos">
                <cfset uzun = arraylen(session.product.emps)>
                <cfset session.product.emps[uzun+1]= pos_code>
            </cfloop>
        </cfif>
    </cfif>
    <cfif not isDefined("session.product.pars")>
        <cfset session.product.pars=arraynew(1)>
        <cfif get_pro_perm_par.recordcount>
            <cfloop query="get_pro_perm_par">
                <cfset uzun = arraylen(session.product.pars)>
                <cfset session.product.pars[uzun+1]= partner_id>
            </cfloop>
        </cfif>
    </cfif>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_comp';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_comp.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.popup_add_product_comp';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/add_product_comp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_comp.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_comp';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_upd_product_comp';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_comp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_comp.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_comp';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ID=##COMPETITIVE_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.COMPETITIVE_ID##';
	
	if(attributes.event is 'upd')
	{		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=product.list_product_comp&event=add&popuppage=1";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listProductCompController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'PRODUCT_COMP';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-PRO_COMP']";
	
</cfscript>