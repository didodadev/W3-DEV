<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined("session.ww.userkey")>
    <cfoutput><a href="#request.self#?fuseaction=objects2.me"><cf_get_lang no='1037.Bilgilerim'></a></cfoutput>
<cfelse>
    <cfoutput><a href="#request.self#?fuseaction=objects2.add_member"><cf_get_lang_main no='674.Üyelik'></a></cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
