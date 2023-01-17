<cfif not listgetat(session.ep.user_level, 43)>
	<cfsavecontent variable="session.error_text"><cf_get_lang_main no='6.literature_modul'><cfoutput> </cfoutput><cf_get_lang_main no=127.yetki></cfsavecontent>
	<cflocation url="#request.self#?fuseaction=home.welcome" addtoken="No">
	<cfabort>
</cfif>

<cfset denied_list = "">
<cf_denied_control denied_page='#denied_list#'>

<cfset page_list = "">
<cf_page_control page_list='#page_list#' page_control_type="0">

<cf_get_lang_set>

<cfparam name="attributes.fuseaction" default="rule.welcome">
<cfparam name="request.self" default="index.cfm">
<cfset fusebox.layoutdir="">
<cfset fusebox.layoutfile="">
<cfinclude template="fbx_workcube_funcs.cfm">