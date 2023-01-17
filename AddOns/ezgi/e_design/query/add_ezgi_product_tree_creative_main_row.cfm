<cfquery name="add_process" datasource="#dsn3#">
	INSERT INTO 
    	EZGI_DESIGN_MAIN_ROW
 		(
        DESIGN_ID, 
        DESIGN_MAIN_NAME, 
        DESIGN_MAIN_COLOR_ID, 
        MAIN_ROW_SETUP_ID, 
        DESIGN_MAIN_STATUS, 
        KARMA_KOLI_MIKTAR, 
        OLCU1,
        OLCU2,
        SALES_PRICE,
        MONEY,
        MAIN_PROTOTIP_TYPE,
        RECORD_EMP, 
      	RECORD_IP, 
        RECORD_DATE
        )
	VALUES        
    	(
        #attributes.design_id#,
        '#attributes.design_name_main_row#',
        #attributes.color_type#,
        #attributes.setup_type#,
        1,
        <cfif len(attributes.main_row_amount)>#attributes.main_row_amount#<cfelse>NULL</cfif>,
        <cfif len(attributes.olcu1)>#attributes.olcu1#<cfelse>NULL</cfif>,
        <cfif len(attributes.olcu2)>#attributes.olcu2#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.sales_price') and len(attributes.sales_price)>#filternum(attributes.sales_price)#<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.money') and len(attributes.money)>'#attributes.money#'<cfelse>NULL</cfif>,
        <cfif isdefined('attributes.spect_type') and len(attributes.spect_type)>'#attributes.spect_type#'<cfelse>0</cfif>,
        #session.ep.userid#,
        '#cgi.remote_addr#',
        #now()#
        )
</cfquery>
<script type="text/javascript">
        wrk_opener_reload();
        window.close();
</script>