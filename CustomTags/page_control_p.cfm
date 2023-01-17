<cfprocessingdirective suppresswhitespace="yes"><cfsetting enablecfoutputonly="yes">
<!---
Description :
	Sayfa kısıtı verilmiş partnerin sayfaya yetkisini kıstlar sayfa fbx_settings de cagrilir.
Parameters :
	denied_page	'optional
Syntax :
	<cf_page_control_p denied_page='objects2.list_extre,objects2.view_product_list,objects2.detail_content'>
	Created 20070523 Fatih Ayık
 --->
<cfparam name="attributes.denied_page" default=''>
<cfif caller.workcube_mode><!--- sadece development modda 5 dak bir query calissin --->
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,1,0,0)>
<cfelse>
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,0,1)><!--- CreateTimeSpan(0,0,5,0) --->
</cfif>

<cfif isdefined('session.pp.userid') and listlen(caller.attributes.fuseaction,'.') eq 2>
	<cfif listfindnocase(attributes.denied_page,listgetat(caller.attributes.fuseaction,2,'.'),',')>
		<cfquery name="GET_PAGE_LOCK_PARTNER" datasource="#CALLER.DSN#" cachedwithin="#caller.get_denied_page_cached_time#">
			SELECT
				PARTNER_ID
			FROM
				COMPANY_PARTNER_DENIED
			WHERE
				DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(cgi.query_string,'fuseaction=','')#">
		</cfquery>
		<cfif get_page_lock_partner.recordcount>
			<cfset lock_list = valuelist(get_page_lock_partner.partner_id)>
			<cfset lock_denied_type = 1>
		<cfelse>
			<cfset lock_list = "">
		</cfif>
		
		<cfif get_page_lock_partner.recordcount and ((lock_denied_type eq 1 and not listfindnocase(lock_list,session.pp.userid)))>
			<cfoutput>
				<script type="text/javascript">
                    alert("#caller.getLang('main',2156)#!");
                    history.back();
                </script>
			</cfoutput>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly="no"></cfprocessingdirective>
