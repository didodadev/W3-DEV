<cfquery name="add_process" datasource="#dsn3#">
	INSERT INTO 
    	EZGI_DESIGN
    	(
        DESIGN_NAME, 
        COLOR_ID, 
        PROCESS_ID, 
        STATUS, 
        DETAIL, 
        CONSUMER_ID, 
        COMPANY_ID, 
        MEMBER_TYPE,
        MEMBER_NAME,
        PROJECT_ID, 
        PROJECT_HEAD, 
        PROCESS_STAGE,
        PRODUCT_CAT,
        PRODUCT_CAT_CODE,
        PRODUCT_CATID,
        PRODUCT_QUANTITY,
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE
        )
	VALUES        
    	(
        '#attributes.design_name#',
        #attributes.color_type#,
        #attributes.design_type#,
        <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.member_type)>'#attributes.member_type#'<cfelse>NULL</cfif>,
        <cfif len(attributes.member_name)>'#attributes.member_name#'<cfelse>NULL</cfif>,
        <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
        <cfif len(attributes.project_head)>'#attributes.project_head#'<cfelse>NULL</cfif>,
        #attributes.process_stage#,
        <cfif len(attributes.product_cat)>'#attributes.product_cat#'<cfelse>NULL</cfif>,
        <cfif len(attributes.product_cat_code)>'#attributes.product_cat_code#'<cfelse>NULL</cfif>,
        <cfif len(attributes.product_catid)>#attributes.product_catid#<cfelse>NULL</cfif>,
        <cfif len(attributes.product_quantity)>#attributes.product_quantity#<cfelse>NULL</cfif>,
        #session.ep.userid#,
        '#cgi.remote_addr#',
        #now()#
        )
</cfquery>
<cfquery name="GET_MAXID" datasource="#dsn3#">
	SELECT MAX(DESIGN_ID) AS MAX_ID FROM EZGI_DESIGN
</cfquery>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&design_id=#get_maxid.max_id#" addtoken="no">