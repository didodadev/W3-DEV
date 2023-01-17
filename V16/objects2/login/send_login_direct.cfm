<cfif not isdefined("session_base.userid")>
	<cfif attributes.fuseaction is 'objects2.user_friendly'>
	<cflocation url="#request.self#?fuseaction=objects2.member_login&user_referer_adress=#attributes.user_friendly_url#" addtoken="no">
	<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.member_login&referer_adress=#attributes.fuseaction#" addtoken="no">
	</cfif>
</cfif>
