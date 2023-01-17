<cfquery name="del_related_product" datasource="#dsn1#">
	DELETE FROM RELATED_PRODUCT_CAT WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
<cfset product_cat_id_list = "">
<cfloop from="1" to="#attributes.row_count#" index="i">
	<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") and not listfind(product_cat_id_list,evaluate('attributes.product_cat_id#i#'),',')>
		<cfquery name="add_related_product" datasource="#dsn1#">
			INSERT INTO RELATED_PRODUCT_CAT
			(
				PRODUCT_ID,
				PRODUCT_CAT_ID,
                RECORD_DATE,
                RECORD_IP,
                RECORD_EMP
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.product_cat_id#i#')#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			)
		</cfquery>
        <cfset product_cat_id_list = listappend(product_cat_id_list,evaluate('attributes.product_cat_id#i#'),',')>
	</cfif>
</cfloop>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
        wrk_opener_reload();
	    window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>','unique__dsp_product_cat_relations_');
    </cfif>
</script>
