<cfquery name="get_defaults" datasource="#dsn3#">
  	 SELECT * FROM EZGI_DESIGN_DEFAULTS
</cfquery>
<cfif not len(get_defaults.DEFAULT_PROCESS_ID)>
		<script type="text/javascript">
		 alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='2917.Tasarım Genel Default Tanımları'> - <cfoutput>#getLang('settings',1133)# #getLang('settings',188)#</cfoutput>!");
		window.history.go(-1);
	</script>
</cfif>
<cfquery name="add_process" datasource="#dsn3#">
	INSERT INTO 
    	EZGI_DESIGN
    	(
            PROCESS_ID,
            STATUS, 
            DETAIL, 
            CONSUMER_ID, 
            COMPANY_ID, 
            MEMBER_TYPE,
            MEMBER_NAME,
            PROCESS_STAGE,
            PRODUCT_QUANTITY,
            IS_PRIVATE,
            RECORD_EMP, 
            RECORD_IP, 
            RECORD_DATE
        )
	VALUES        
    	(
            #get_defaults.DEFAULT_PROCESS_ID#,
            <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
            <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
            <cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
            <cfif len(attributes.member_type)>'#attributes.member_type#'<cfelse>NULL</cfif>,
            <cfif len(attributes.member_name)>'#attributes.member_name#'<cfelse>NULL</cfif>,
            #attributes.process_stage#,
            1,
            1,
            #session.ep.userid#,
            '#cgi.remote_addr#',
            #now()#
        )
</cfquery>
<cfquery name="GET_MAXID" datasource="#dsn3#">
	SELECT MAX(DESIGN_ID) AS MAX_ID FROM EZGI_DESIGN
</cfquery>
<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_private_product_tree_creative&design_id=#get_maxid.max_id#" addtoken="no">