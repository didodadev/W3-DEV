<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction> 
    	<cfset product_id_list = ''> 	
        <cfquery name="DEL_RELATED_PRODUCT" datasource="#DSN3#">
            DELETE FROM RELATED_PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        </cfquery>
        <cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
                <cfif not listfind(product_id_list,evaluate("attributes.product_id#i#"))>
                    <cfquery name="ADD_RELATED_PRODUCT" datasource="#DSN3#">
                        INSERT INTO 
                            RELATED_PRODUCT
                            (
                                PRODUCT_ID,
                                RELATED_PRODUCT_NO,
                                RELATED_PRODUCT_ID
                            )
                            VALUES
                            (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">,
                                <cfif len(evaluate("attributes.product_no#i#"))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.product_no#i#')#"><cfelse>NULL</cfif>,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.product_id#i#')#">
                            )
                    </cfquery>
                </cfif>
            	<cfset product_id_list = ListAppend(product_id_list,evaluate("attributes.product_id#i#"))>
            </cfif>
        </cfloop>
    </cftransaction>
</cflock>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
        wrk_opener_reload();
	    window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__dsp_product_relations_');
    </cfif>
</script>
