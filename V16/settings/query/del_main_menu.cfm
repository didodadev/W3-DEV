<cfquery name="GET_DOMAINS" datasource="#DSN#">
	SELECT MENU_ID FROM CATEGORY_SITE_DOMAIN WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
	UNION
	SELECT MENU_ID FROM COMPANY_CONSUMER_DOMAINS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
	UNION
	SELECT MENU_ID FROM TRAINING_CLASS_GROUPS_SITE_DOMAIN WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
	UNION	
	SELECT MENU_ID FROM TRAINING_CLASS_SITE_DOMAIN WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
	UNION
	SELECT MENU_ID FROM ORGANIZATION_SITE_DOMAIN WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>

<cfif get_domains.recordcount>
	<script type="text/javascript">
		alert("Silmek İstediğiniz Menüde Yayında Bir Kategori, Üye, Eğitim, Eğitim Sınıfı veya Etkinlik Var. Önce Bu Kayıtları Siliniz!");
		history.back();		
	</script>
	<cfabort>
</cfif>

<!--- menu kullancılar trafından secildigi zaman silmemek için FA-20070501 --->
<cfquery name="GET_MY_SETTINGS_" datasource="#DSN#">
	SELECT OZEL_MENU_ID FROM MY_SETTINGS WHERE OZEL_MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<cfquery name="GET_WRK_SESSION_" datasource="#DSN#">
	SELECT MENU_ID FROM WRK_SESSION WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<cfif get_my_settings_.recordcount or get_wrk_session_.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2529.Silmek istediğiniz menü kullanılmaktadır silemezsiniz'>.");
		history.back();		
	</script>
</cfif>
<!--- menu kullancılar trafından seçildiği zaman silememek için FA-20070501 --->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<!--- sitede tanimli dinamik sayfalar --->
        <cfquery name="DEL_MAIN_SITE_LAYOUTS" datasource="#DSN#">
            DELETE FROM MAIN_SITE_LAYOUTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
        </cfquery>
		<cfquery name="GET_MAIN_SITE_LAYOUTS_SELECTS" datasource="#DSN#">
			SELECT ROW_ID FROM MAIN_SITE_LAYOUTS_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
		</cfquery>
		<cfloop query="get_main_site_layouts_selects">
			 <cfquery name="DEL_MAIN_SITE_LAYOUTS_SELECTS" datasource="#DSN#">
				DELETE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_site_layouts_selects.row_id#">
			</cfquery>
		</cfloop>
        <!--- sitede tanimli dinamik sayfa objeleri --->
        <cfquery name="DEL_MAIN_SITE_LAYOUTS_SELECTS" datasource="#DSN#">
            DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
        </cfquery>
        <!--- site linkleri --->
        <cfquery name="GET_MAIN_MENU_SELECT" datasource="#DSN#">
            DELETE FROM MAIN_MENU_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
        </cfquery>
        <!--- site layerleri --->
        <cfquery name="GET_LAYERS" datasource="#DSN#">
            DELETE FROM MAIN_MENU_LAYER_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
        </cfquery>
        <!--- site alt menu --->
        <cfquery name="GET_SUBS" datasource="#DSN#">
            DELETE FROM MAIN_MENU_SUB_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
        </cfquery>
        <!--- site ayarlari --->
        <cfquery name="GET_OLD_MENU" datasource="#DSN#">
            DELETE FROM MAIN_MENU_SETTINGS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
        </cfquery>
	</cftransaction>
</cflock>

<cflocation url="#request.self#?fuseaction=settings.list_main_menu" addtoken="no">
