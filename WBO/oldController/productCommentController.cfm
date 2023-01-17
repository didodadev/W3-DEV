<cf_get_lang_set module ="product">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.keyword" default="">
    <script type="text/javascript">
        $('#keyword').focus();
        function connectAjax(div_id,comment_id,status_info)
        {
            var page = <cfoutput>'#request.self#?fuseaction=product.emptypopup_ajax_upd_product_comment_stage&comment_id='+comment_id+''</cfoutput>
            if(eval("document.getElementById('comment_" + comment_id + "')").checked == true)
                AjaxPageLoad(page,div_id);
            eval("document.getElementById('comment_" + comment_id + "')").style.display='none';
            document.getElementById(status_info).innerHTML ='Yayında!';		
        }
    </script>
    <cfif isdefined("attributes.form_submitted")>
        <cfquery name="get_product_comment" datasource="#dsn3#">
            SELECT 
                PC.PRODUCT_ID,
                PC.NAME +' '+ PC.SURNAME AS YORUM_YAPAN,
                PC.PRODUCT_COMMENT_POINT,
                PC.PRODUCT_COMMENT,
                PC.PRODUCT_COMMENT_ID,
                PC.RECORD_DATE,
                PC.GUEST,
                PC.STAGE_ID,
                P.PRODUCT_NAME
            FROM 
                PRODUCT_COMMENT PC,
                PRODUCT P
            WHERE 
                PC.STAGE_ID <> -2 AND
                P.PRODUCT_ID = PC.PRODUCT_ID 
                <cfif len(attributes.keyword)>
                    AND 
                    (
                    P.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                    PC.NAME LIKE '%#attributes.keyword#%' OR
                    PC.SURNAME LIKE '%#attributes.keyword#%'
                    )
                </cfif>
        </cfquery>
    <cfelse>
        <cfset get_product_comment.recordcount = 0>
    </cfif>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default="#get_product_comment.recordcount#">
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfquery name="GET_COMMENT" datasource="#DSN3#">
		SELECT * FROM PRODUCT_COMMENT WHERE	PRODUCT_COMMENT_ID = #attributes.PRODUCT_COMMENT_ID#
	</cfquery>
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_comment';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_comment.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.list_product_comment';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_comment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_comment.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_comment';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'product_comment_id=##attributes.product_comment_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.product_comment_id##';
	
	if(not attributes.event is 'list' and not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.list_product_comment&product_comment_id=#attributes.product_comment_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_product_comment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_product_comment.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_comment';
	}

</cfscript>
