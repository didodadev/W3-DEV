<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
    <cfquery name="get_gen" datasource="#dsn#">
        SELECT GENIUS_ID FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
    </cfquery>
	<cfquery name="Add_Customer_Cards" datasource="#dsn#">
        UPDATE CUSTOMER_CARDS SET ACTION_ID = #attributes.consumer_id#,ACTION_TYPE_ID = 'CONSUMER_ID' WHERE CARD_NO = '#attributes.card_no#'
    </cfquery>
<cfelse>
    <cfquery name="get_gen" datasource="#dsn#">
        SELECT GENIUS_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
    </cfquery>
    <cfquery name="Add_Customer_Cards" datasource="#dsn#">
        UPDATE CUSTOMER_CARDS SET ACTION_ID = #attributes.company_id#,ACTION_TYPE_ID = 'COMPANY_ID' WHERE CARD_NO = '#attributes.card_no#'
    </cfquery>
</cfif>
<cfif len(get_gen.genius_id)>
	<cfset genius_id = get_gen.GENIUS_ID>
    <cfquery name="UPD_CUST" datasource="#DSN_GEN#">
        UPDATE CARD SET FK_CUSTOMER = #genius_id# WHERE CODE = '#trim(attributes.card_no)#'
    </cfquery>
</cfif>
<!---
<cfquery name="SET_PASSIVE" datasource="#DSN#">
    UPDATE CONSUMER SET CONSUMER_STATUS = 0 WHERE CONSUMER_ID = #attributes.card_member_id#
</cfquery>
--->
<script type="text/javascript">
    <cfif isDefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	<cfelse>
		window.opener.location.reload();
	    window.close();
	</cfif>
	
</script>