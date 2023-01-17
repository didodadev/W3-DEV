<cfquery name="get_print_cats" datasource="#DSN#">
	 SELECT * FROM SETUP_PRINT_FILES_CATS
</cfquery>
<cfquery name="get_module_id" datasource="#DSN#">
	SELECT MODULE_ID FROM MODULES WHERE MODULE_SHORT_NAME = 'bank'
</cfquery>
<cfquery name="GET_DET_FORM" datasource="#dsn3#">
  	SELECT 
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME
	FROM 
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC
	WHERE
		SPF.MODULE_ID = #get_module_id.MODULE_ID# AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE
</cfquery>
<cf_popup_box>
	<cfform name="page_print" method="post" action="#request.self#?fuseaction=bank.popup_collected_print">
		<cfparam name="attributes.first_number" default="">
		<cfparam name="attributes.last_number" default="">
		<!-- sil -->
		<table>
			<tr>
                <td><cf_get_lang dictionary_id="51620.İlk No"></td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="51609.İlk No Girmelisiniz !"></cfsavecontent>
				<td><cfinput type="text" value="#attributes.first_number#" validate="integer" name="first_number" style="width:100px;" required="yes" message="#message#"></td>
				<td><cf_get_lang dictionary_id="51616.Son No"></td>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="51622.Son No Girmelisiniz !"></cfsavecontent>
				<td><cfinput type="text" value="#attributes.last_number#" validate="integer" name="last_number" style="width:100px;" required="yes" message="#message#"></td>
				<td>
				 <select name="form_type" id="form_type">
					  <option value=""><cf_get_lang dictionary_id ="57792.Modül İçi Yazıcı Belgeleri"> </option>
					  <cfoutput query="GET_DET_FORM">
						<option value="#form_id#" <cfif isdefined("attributes.form_type") and attributes.form_type eq form_id>selected</cfif>>
							#name# - #PRINT_NAME#
						</option>
					  </cfoutput>
				  </select>
				</td>
				<td><cf_wrk_search_button search_function='kontrol()'></td>
				<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1' trail="0"> 
			</tr>
		</table>
		<!-- sil -->
   </cfform>
	<cfif isdefined("attributes.form_type")>
        <cfquery name="GET_FORM" datasource="#DSN3#">
            SELECT 
                TEMPLATE_FILE,
                FORM_ID,
                NAME,
                PROCESS_TYPE,
                MODULE_ID,
                IS_STANDART
            FROM 
                SETUP_PRINT_FILES	
            WHERE
                FORM_ID = #attributes.form_type#
        </cfquery>
        <cfquery name="get_orders" datasource="#DSN2#">
            SELECT 
                BANK_ORDER_ID
            FROM 
                BANK_ORDERS 
            WHERE 		
                BANK_ORDER_ID BETWEEN #attributes.first_number# AND #attributes.last_number#
            ORDER BY 
                BANK_ORDER_ID ASC
        </cfquery>
        <cfset order_list = valuelist(get_orders.bank_order_id,',')>
        <cfloop list="#order_list#" index="i">
            <cfquery name="get_orders_" datasource="#dsn2#">
                SELECT 
                    BON.*,
                    BB.BANK_NAME,
                    BB.BANK_BRANCH_NAME,
                    A.ACCOUNT_NO
                FROM 
                    BANK_ORDERS BON,
                    #dsn3_alias#.ACCOUNTS AS A,
                    #dsn3_alias#.BANK_BRANCH AS BB
                WHERE 		
                    BON.BANK_ORDER_ID = #i# AND 
                    A.ACCOUNT_ID = BON.ACCOUNT_ID AND 
                    A.ACCOUNT_BRANCH_ID=BB.BANK_BRANCH_ID
            </cfquery>	
            <cfif get_orders_.recordcount>
                <cfif get_form.is_standart eq 1>
                    <cfset attributes.action_id = get_orders_.bank_order_id>
                    <cfset attributes.checked_value = get_orders_.bank_order_id>
                    <cfinclude template="/#get_form.template_file#">
                <cfelse>
                	<cfset attributes.action_id = get_orders_.bank_order_id>
                    <cfset attributes.checked_value = get_orders_.bank_order_id>
                    <cfinclude template="#file_web_path#settings/#get_form.template_file#">
                </cfif>
            </cfif>
        </cfloop>
    </cfif>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		x = document.page_print.form_type.selectedIndex;
		if (document.page_print.form_type[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id ="57804.Baskı Formu Seçiniz !">");
			return false;
		}
		return true;
	}
</script>
