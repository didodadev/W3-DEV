<cfprocessingdirective suppresswhitespace="yes"><cfsetting enablecfoutputonly="yes">
<!---
Description :
	kullanılan sayfanın sadece tek kişi tarafından kullanılmasını sağlar tag sayfa fbx_settings de cagrilir.
	bu sayfa sadece employee portal icindir ancak partner portalden bir modul ve action aynı anda verilerek de (ilgili x_id=sayi
	seklindeki url parametresi ayni olmak kaydiyla) calistirilir. Employee portal action lari modul adi olmadan partner portal
	action lari modul adi ile birlikte olmalidir.
Parameters :
	denied_page	'optional
Syntax :
	<cf_page_control denied_page='detail_invoice_sale,detail_invoice_purchase,order.form_upd_order_g'>

	Created 20030416
	Modify 20030504-20030617-20040127-ERK20040429-20040501-20040723
 --->
<cfparam name="attributes.denied_page" default=''>
<cfif caller.workcube_mode><!--- sadece development modda 5 dak bir query calissin --->
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,1,0,0)>
<cfelse>
	<cfset caller.get_denied_page_cached_time = CreateTimeSpan(0,0,0,1)><!--- CreateTimeSpan(0,0,5,0) --->
</cfif>

<cfif isdefined('session.ep.userid') and listlen(caller.attributes.fuseaction,'.') eq 2>
	<cfif listfindnocase(attributes.denied_page,listgetat(caller.attributes.fuseaction,2,'.'),',')>
		<cfquery name="get_page_lock" datasource="#caller.dsn#" cachedwithin="#caller.get_denied_page_cached_time#">
			SELECT
				DENIED_TYPE,
				POSITION_CODE,
				PERIOD_ID,
				OUR_COMPANY_ID
			FROM
				DENIED_PAGES_LOCK
			WHERE
				DENIED_PAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(CGI.QUERY_STRING,'fuseaction=','')#">
                AND 
                (
                    (
                    OUR_COMPANY_ID IS NULL 
                    AND
                    PERIOD_ID IS NULL
                    )
                    OR
                    ( 
                    OUR_COMPANY_ID = '#session.ep.company_id#'
                    OR
                    OUR_COMPANY_ID LIKE '%,#session.ep.company_id#,%'
                    OR
                    OUR_COMPANY_ID LIKE '#session.ep.company_id#,%'
                    OR
                    OUR_COMPANY_ID LIKE '%,#session.ep.company_id#'
                     )
                    OR
                    ( 
                    PERIOD_ID = '#session.ep.period_id#'
                    OR
                    PERIOD_ID LIKE '%,#session.ep.period_id#,%'
                    OR
                    PERIOD_ID LIKE '#session.ep.period_id#,%'
                    OR
                    PERIOD_ID LIKE '%,#session.ep.period_id#'
                     )
                )
		</cfquery>
		<cfif get_page_lock.recordcount>
			<cfset lock_list = valuelist(get_page_lock.position_code)>
			<cfset lock_denied_type = get_page_lock.denied_type>
		<cfelse>
			<cfset lock_list = "">
		</cfif>
		<cfif get_page_lock.recordcount and ((lock_denied_type eq 1 and not listfindnocase(lock_list,session.ep.position_code)) or (lock_denied_type eq 0 and listfindnocase(lock_list,session.ep.position_code)))>
			<cfif listlen(get_page_lock.period_id)>
				<cfif listlen(get_page_lock.period_id) and listfindnocase(get_page_lock.period_id,session.ep.period_id)>
                    <cfoutput>
						<script type="text/javascript">
                            alert("#caller.getLang('main',2156)# (#caller.getLang('main',1060)#)!");	
                            history.back();
                        </script>
                    </cfoutput>
                    <cfabort>
                </cfif>
            </cfif>
            <cfif listlen(get_page_lock.OUR_COMPANY_ID)>
				<cfif listlen(get_page_lock.our_company_id) and listfindnocase(get_page_lock.our_company_id,session.ep.company_id)>
					<cfoutput>
						<script type="text/javascript">
                            alert("#caller.getLang('main',2156)#! (#caller.getLang('main',162)#)");	
                            history.back();
                        </script>
                    </cfoutput>
                    <cfabort>
                </cfif>
            </cfif>
           	<cfif not listlen(get_page_lock.period_id) and not listlen(get_page_lock.OUR_COMPANY_ID)>
             	<cfoutput>
					<script type="text/javascript">
                        alert("#caller.getLang('main',2156)#! (#caller.getLang('main',2157)#)");	
                        history.back();
                    </script>
                </cfoutput>
                <cfabort>
            </cfif>
		</cfif>
	</cfif>
</cfif>
<cfsetting enablecfoutputonly="no"></cfprocessingdirective>
