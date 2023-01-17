<cfquery name="upd_process" datasource="#dsn3#">
	UPDATE
    	EZGI_DESIGN_MAIN_ROW
   	SET
        DESIGN_MAIN_NAME = '#attributes.design_name_main_row#', 
        DESIGN_MAIN_COLOR_ID = #attributes.color_type#, 
        MAIN_ROW_SETUP_ID = #attributes.setup_type#, 
        DESIGN_MAIN_STATUS = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>, 
        KARMA_KOLI_MIKTAR = <cfif len(attributes.main_row_amount)>#attributes.main_row_amount#<cfelse>NULL</cfif>, 
        OLCU1 = <cfif len(attributes.olcu1)>#attributes.olcu1#<cfelse>NULL</cfif>,
        OLCU2 = <cfif len(attributes.olcu2)>#attributes.olcu2#<cfelse>NULL</cfif>,
        SALES_PRICE = <cfif isdefined('attributes.sales_price') and len(attributes.sales_price)>#filternum(attributes.sales_price)#<cfelse>NULL</cfif>,
        MONEY = <cfif isdefined('attributes.money') and len(attributes.money)>'#attributes.money#'<cfelse>NULL</cfif>,
        MAIN_PROTOTIP_TYPE = <cfif isdefined('attributes.spect_type') and len(attributes.spect_type)>'#attributes.spect_type#'<cfelse>0</cfif>,
        UPDATE_EMP = #session.ep.userid#, 
      	UPDATE_IP = '#cgi.remote_addr#', 
        UPDATE_DATE = #now()#
 	WHERE
    	DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id#
</cfquery>
<script type="text/javascript">
        wrk_opener_reload();
        window.close();
</script>