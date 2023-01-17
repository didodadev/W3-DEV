<cfquery name="upd_process" datasource="#dsn3#">
	UPDATE 
    	EZGI_DESIGN
   	SET
        DESIGN_NAME = '#attributes.design_name#',
        COLOR_ID = #attributes.color_type#,
        PROCESS_ID = #attributes.design_type#, 
        STATUS = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>, 
	IS_PROTOTIP = <cfif isdefined('attributes.is_prototip')>1<cfelse>0</cfif>,
        DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        CONSUMER_ID = <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>, 
        COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>, 
        MEMBER_TYPE = <cfif len(attributes.member_type)>'#attributes.member_type#'<cfelse>NULL</cfif>,
        MEMBER_NAME = <cfif len(attributes.member_name)>'#attributes.member_name#'<cfelse>NULL</cfif>,
        PROJECT_ID = <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>, 
        PROJECT_HEAD = <cfif len(attributes.project_head)>'#attributes.project_head#'<cfelse>NULL</cfif>,
        PROCESS_STAGE = #attributes.process_stage#,
        PRODUCT_CAT = <cfif len(attributes.product_cat)>'#attributes.product_cat#'<cfelse>NULL</cfif>,
        PRODUCT_CAT_CODE = <cfif len(attributes.product_cat_code)>'#attributes.product_cat_code#'<cfelse>NULL</cfif>,
        PRODUCT_CATID = <cfif len(attributes.product_catid)>#attributes.product_catid#<cfelse>NULL</cfif>,
        PRODUCT_QUANTITY = <cfif len(attributes.product_quantity)>#attributes.product_quantity#<cfelse>NULL</cfif>,
        UPDATE_EMP = #session.ep.userid#, 
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_DATE = #now()#
   	WHERE
    	DESIGN_ID =	#attributes.design_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_product_tree_creative&design_id=#attributes.design_id#" addtoken="no">