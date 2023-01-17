<cfprocessingdirective suppresswhitespace="yes"><cfsetting enablecfoutputonly="yes">
<!---
Description :
	ilgili modülde izin verilen kisiler tarafindan kullanilmaya izin verilen sayfalar icin bu custom tag sayfa fbx_settings de cagrilir.
	bu sayfa sadece employee portal icindir ancak partner portalden bir modul ve action aynı anda verilerek de (ilgili x_id=sayi
	seklindeki url parametresi ayni olmak kaydiyla) calistirilir. Employee portal action lari modul adi olmadan partner portal
	action lari modul adi ile birlikte olmalidir.
Parameters :
	page_list	'optional
Syntax :
	<cf_denied_control page_list='detail_invoice_sale,detail_invoice_purchase,order.form_upd_order_g'>
	Created 20070514 FA
 --->
<cfparam name="attributes.page_list" default=''>
<cfparam name="attributes.page_control_type" default='0'>
<cfif caller.workcube_mode><!--- sadece development modda 5 dak bir query calissin --->
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,5,0)>
<cfelse>
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,0,1)><!--- CreateTimeSpan(0,0,5,0) --->
</cfif>

<cfset attributes.page_control_list = ''>
<cfset attributes.page_control_type_list = ''>

<cfif listlen(attributes.page_list)>
	<cfloop list="#attributes.page_list#" index="ccc">
		<cfset attributes.page_control_list  = listappend(attributes.page_control_list,listgetat(ccc,1,';'))>
		<cfif listlen(ccc,';') eq 2>
			<cfset attributes.page_control_type_list = listappend(attributes.page_control_type_list,'#listgetat(ccc,2,';')#')> 
		<cfelse>
			<cfset attributes.page_control_type_list = listappend(attributes.page_control_type_list,'#attributes.page_control_type#')> 
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined('session.ep.userid') and len(caller.page_code) and listlen(caller.attributes.fuseaction,'.') eq 2>
	<cfif listfindnocase(attributes.page_control_list,caller.attributes.fuseaction,',')>
		<cfset sira_ = listfindnocase(attributes.page_control_list,caller.attributes.fuseaction,',')>
		<cfset page_control_type_ = listgetat(attributes.page_control_type_list,sira_)>
		<cfstoredproc procedure="GET_FUSEACTION_FROM_WRK_APP" datasource="#CALLER.dsn#">
			<cfif page_control_type_ eq 2>				
				<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#session.ep.period_id#">
				<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="">
			<cfelseif page_control_type_ eq 1>
				<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="">
				<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#session.ep.company_id#">
			<cfelse>
				<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="">
				<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="">
			</cfif>	
			<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="%.#listgetat(caller.attributes.fuseaction,2,'.')#%">
			<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="%.#listgetat(caller.attributes.fuseaction,2,'.')#%">
			<cfprocresult name="GET_FUSEACTION_FROM_WRK_APP">
		</cfstoredproc>

		<!--- wrk_not : ustteki query nin kolonlarini ismiyle cagirmayin DB2 icin sorun oluyor 20040514 --->

		<cfloop query="get_fuseaction_from_wrk_app">
			
			<cfset used_page = 1>
			<!--- Uğur Hamurpet:12/06/2021 - caller.page_code değişkenine application.cfc dosyasında fuseaction dahil edilmiyor fakat burada action_page değeri olarak fuseaction geliyor ve her halukarda used_page değeri sıfırlanıyordu. Bu nedenle kapatıldı. --->
			<!--- <cfloop list="#caller.page_code#" index="k" delimiters="&">
				<cfif not listfindnocase(action_page,k,'&')>
					<cfset used_page = 0>
				</cfif>
			</cfloop> --->
			<cfif used_page and caller.attributes.fuseaction is get_fuseaction_from_wrk_app.ACTION_PAGE and (userid neq session.ep.userid) and get_fuseaction_from_wrk_app.is_only_show_page neq 1 and (isdefined("COMPANY_ID") and COMPANY_ID eq session.ep.company_id) and (IsDefined("get_fuseaction_from_wrk_app.ACTION_PAGE_Q_STRING") and cgi.QUERY_STRING eq get_fuseaction_from_wrk_app.ACTION_PAGE_Q_STRING)>
				<cfquery name="UPD_WORKCUBE_APP_ACTION" datasource="#CALLER.DSN#">
					UPDATE WRK_SESSION SET IS_ONLY_SHOW_PAGE = 1 WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND USER_TYPE = 0
				</cfquery>
				<cfset caller.is_only_show_page = 1>
				<cfoutput>
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><!--- real_dsp_sablon.cfm dosyasinda tanimlaniyor. Explorerda sayfada biri varsa alt taraftaki alertten sonra spry calismiyordu diye eklendi EY20131112 --->
					<script type="text/javascript">
						window.alert("#caller.getLang('main',2181)#!\n#caller.getLang('main',518)#: #name# #surname#\n#caller.getLang('main',2182)#!");
						<cfif caller.attributes.fuseaction contains 'popup'>//window.close();<cfelse>//window.history.back();</cfif>
					</script>
				</cfoutput>
			<cfelseif used_page and fuseaction is 'objects.popup_add_basket_row_from_barcod' and (userid neq session.ep.userid) and get_fuseaction_from_wrk_app.is_only_show_page neq 1>
				<cfquery name="UPD_WORKCUBE_APP_ACTION" datasource="#CALLER.DSN#">
					UPDATE WRK_SESSION SET IS_ONLY_SHOW_PAGE = 1 WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND USER_TYPE = 0
				</cfquery>
				<cfset caller.is_only_show_page = 1>
				<cfoutput>
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
					<script type="text/javascript">
						window.alert('<cf_get_lang dictionary_id="52050.Çalıştırmak istediğiniz sayfa şuanda başka biri tarafından kullanılıyor">!\n<cf_get_lang dictionary_id="52052.Sayfayı kullanan kişi">: #name# #surname# \n<cf_get_lang dictionary_id="52067.Sayfa görüntüleme modunda açılacak">!');
						<cfif caller.attributes.fuseaction contains 'popup'>//window.close();<cfelse>//window.history.back();</cfif>
					</script>
				</cfoutput>
			<cfelse>
				<cfquery name="UPD_WORKCUBE_APP_ACTION" datasource="#CALLER.DSN#">
					UPDATE WRK_SESSION SET IS_ONLY_SHOW_PAGE = 0 WHERE USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND USER_TYPE = 0
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly="no"></cfprocessingdirective>