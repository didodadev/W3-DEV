<cfscript>
	for (i=1; i lte ArrayLen(session.basketww_camp); i=i+1)
		session.basketww_camp[i][3] = evaluate('attributes.amount_#i#')/session.basketww_camp[i][15]; 		
	//session.basketww_camp[attributes.rowno][3] = evaluate('attributes.amount_#attributes.rowno#'); // miktar 
</cfscript>

<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.list_basket_camp">
