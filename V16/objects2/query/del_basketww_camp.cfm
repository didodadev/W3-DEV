<cfsetting showdebugoutput="no">
 <cfif isDefined("attributes.is_delete_info")><!--- burası partner sipariş kaydetden ödeme yöntemi boşaltma işlemiyle girilir --->
	<cfloop from="1" to="#arraylen(session.basketww_camp)#" index="i">
		<cfif (session.basketww_camp[i][20] is 1)>
			<cfscript>ArrayDeleteAt(session.basketww_camp,i);</cfscript>
		</cfif>
	</cfloop>
	<script type="text/javascript">
		AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
	</script>
<cfelseif isDefined("attributes.is_delete_cargo")><!--- burası partner sipariş kaydetden ödeme yöntemi boşaltma işlemiyle girilir --->
	<cfloop from="1" to="#arraylen(session.basketww_camp)#" index="i">
		<cfif session.basketww_camp[i][20] is 1>
			<cfscript>ArrayDeleteAt(session.basketww_camp,i);</cfscript>
		</cfif>	
	</cfloop>
	<cfloop from="1" to="#arraylen(session.basketww_camp)#" index="i">
		<cfif session.basketww_camp[i][26] is 1>
			<cfscript>ArrayDeleteAt(session.basketww_camp,i);</cfscript>
		</cfif>	
	</cfloop>
	<script type="text/javascript">
		AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
	</script>
<cfelse><!--- burası standart sepet boşaltma bölümü --->
	<cfscript>
		structdelete(session,'basketww_camp');
	</cfscript>
	<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.list_basket_camp">
</cfif>
