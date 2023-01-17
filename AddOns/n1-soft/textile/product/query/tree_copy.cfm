
<!---
<cfdump var="#attributes#">
<cfabort>
--->

<cfloop from="#attributes.row_start#" to="#attributes.row_count_stock#" index="j">
		<cfset stock_id=Evaluate('attributes.stock_id#j#')>
		<cfset guncelleme=Evaluate('attributes.update#j#')>
		<cfquery name="get_stock" datasource="#dsn3#">
			select *FROM STOCKS WHERE STOCK_ID=#stock_id#
		</cfquery>
		<cfif guncelleme eq 0>
			<cfinclude template="add_tree_copy.cfm">
		<cfelse>
			<cfinclude template="upd_tree_copy.cfm">
		</cfif>
		
</cfloop><!---&submit_form_search=&stock_color=#attributes.stock_color#--->
<!---
<cflocation url="#request.self#?fuseaction=textile.product_plan&event=add_tree&pid=#attributes.pid#&req_id=#attributes.req_id#" addtoken="no">
--->
<script>
	alert('Islem Tamamlandi!');
	window.close();
</script>