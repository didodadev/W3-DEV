<cfif IsArray(session.basketww_camp)>
	<cfscript>
		sid = session.basketww_camp[attributes.rowno][14];
		is_prom_asil_hediye = session.basketww_camp[attributes.rowno][16];
		ArrayDeleteAt(session.basketww_camp,attributes.rowno);
		for (i=1;i lte arraylen(session.basketww_camp);i=i+1)
			if (session.basketww_camp[i][14] is sid and is_prom_asil_hediye is 0 and session.basketww_camp[i][16] is 1 and i is attributes.rowno)
				ArrayDeleteAt(session.basketww_camp,i);
			else if (session.basketww_camp[i][14] is sid and is_prom_asil_hediye is 1 and session.basketww_camp[i][16] is 0 and i is attributes.rowno-1)
				ArrayDeleteAt(session.basketww_camp,i);
	</cfscript>
	<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.list_basket_camp">
<cfelse>
	<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.welcome">
</cfif>

