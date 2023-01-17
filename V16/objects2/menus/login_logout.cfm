<cf_get_lang_set module_name="objects2"><!--- sayfanin en altinda kapanisi var --->
: 
<cfoutput>
<cfif isdefined("session.ww") and not isdefined("session.ww.userid")>
	<a href="#request.self#?fuseaction=objects2.public_login" class="upper_menu_link"><cf_get_lang no='123.Güvenli Giriş'></a>
<cfelseif isdefined("session.ww") and isdefined("session.ww.userid")>
	<a href="#request.self#?fuseaction=home.logout" class="upper_menu_link"><cf_get_lang no='967.Güvenli Çıkış'></a>
<cfelseif isdefined("session.pp") and not isdefined("session.pp.userid")>
	<a href="#request.self#?fuseaction=objects2.partner_login" class="upper_menu_link"><cf_get_lang no='123.Güvenli Giriş'></a>
<cfelseif isdefined("session.pp") and isdefined("session.pp.userid")>
	<a href="#request.self#?fuseaction=home.logout" class="upper_menu_link"><cf_get_lang no='967.Güvenli Çıkış'></a>
<cfelseif isdefined("session.cp") and not isdefined("session.cp.userid")>
	<a href="#request.self#?fuseaction=objects2.kariyer_login" class="upper_menu_link"><cf_get_lang no='123.Güvenli Giriş'></a>
<cfelseif isdefined("session.cp") and isdefined("session.cp.userid")>
	<a href="#request.self#?fuseaction=home.logout" class="upper_menu_link"><cf_get_lang no='967.Güvenli Çıkış'></a>
</cfif>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
