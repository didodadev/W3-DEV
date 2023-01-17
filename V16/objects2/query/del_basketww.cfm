<cfsetting showdebugoutput="no">
<cfif not isdefined("session.pp") and not isdefined("session.ww.userid") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
	<cfset cookie_name_ = createUUID()>
	<cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#cookie_name_#" expires="1">
</cfif>

<cfif isDefined("is_delete_info")><!--- burasi partner siparis kaydetmeden odeme yontemi bosaltma islemiyle girilir --->
	<cfquery name="DEL_ROWS" datasource="#DSN3#">
		DELETE FROM
			ORDER_PRE_ROWS
		WHERE
			<cfif isdefined("session.pp")>
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
			<cfelseif isdefined("session.ww.userid")>
				RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			<cfelseif isdefined("session.ep")>
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			<cfelseif not isdefined("session_base.userid")>
				RECORD_GUEST = 1 AND 
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
				COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
			</cfif>
			IS_COMMISSION = 1 AND
			PRODUCT_ID IS NOT NULL
	</cfquery>
	<cfif isdefined("ajax")>
		<script type="text/javascript">
			<cfif isdefined("attributes.is_from_credit")>
				sepet_adres_ += '&is_from_credit=1';
			</cfif>
			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		</script>
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_add_orderww&paymethod_id_com=#attributes.paymethod_id_com#">
	</cfif>
<cfelseif isDefined("is_delete_info2")><!--- komisyonlu bi alandan sonra baska ödeme yontemi secme --->
	<cfquery name="DEL2_ROWS" datasource="#DSN3#">
		DELETE FROM
			ORDER_PRE_ROWS
		WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")>
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>
			IS_COMMISSION = 1 AND
			PRODUCT_ID IS NOT NULL
	</cfquery>
	<cfif isdefined("ajax")>
		<script type="text/javascript">
			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		</script>
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_add_orderww">
	</cfif>
<cfelseif isDefined("is_delete_discount") and is_delete_discount eq 1><!---para puan silme --->
	<cfquery name="DEL2_ROWS" datasource="#DSN3#">
		DELETE FROM
			ORDER_PRE_ROWS
		WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")>
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>
			IS_DISCOUNT = 1
	</cfquery>
	<cfif isdefined("ajax")>
		<script type="text/javascript">
			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		</script>
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_add_orderww">
	</cfif>
<cfelseif isDefined("is_delete_discount") and is_delete_discount eq 2><!---hediye çeki silme --->
	<cfquery name="DEL2_ROWS" datasource="#DSN3#">
		DELETE FROM
			ORDER_PRE_ROWS
		WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")>
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>
			IS_DISCOUNT = 2
	</cfquery>
	<cfif isdefined("ajax")>
		<script type="text/javascript">
			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		</script>
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_add_orderww">
	</cfif>
<cfelseif isDefined("is_delete_discount") and is_delete_discount eq 3><!---indirim kodu silme --->
	<cfquery name="DEL2_ROWS" datasource="#DSN3#">
		DELETE FROM
			ORDER_PRE_ROWS
		WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")>
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>
			IS_DISCOUNT = 3
	</cfquery>
	<cfif isdefined("ajax")>
		<script type="text/javascript">
			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		</script>
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_add_orderww">
	</cfif>
<cfelseif isdefined("attributes.is_delete_cargo")>
	<cfquery name="DEL2_ROWS" datasource="#DSN3#">
		DELETE FROM
			ORDER_PRE_ROWS
		WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		<cfelseif isdefined("session.ep")>
			RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
		<cfelseif not isdefined("session_base.userid")>
			RECORD_GUEST = 1 AND 
			RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
			COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
		</cfif>
			(IS_COMMISSION = 1 OR IS_CARGO = 1) AND 
			PRODUCT_ID IS NOT NULL
	</cfquery>
	<cfif isdefined("ajax")>
		<script type="text/javascript">
			AjaxPageLoad(sepet_adres_,'sale_basket_rows_list','1',"Ürünler Listeleniyor!");
		</script>
	<cfelse>
		<cflocation addtoken="no" url="#request.self#?fuseaction=objects2.form_add_orderww">
	</cfif>	
<cfelse><!--- burasi standart sepet bosaltma bolumu --->
	<cfinclude template="get_basket_rows.cfm">
	<cfif get_rows.recordcount>
		<cfquery name="DEL_ROWS_SPECS" datasource="#DSN3#">
			DELETE FROM
				ORDER_PRE_ROWS_SPECS
			WHERE
				MAIN_ORDER_ROW_ID IN (#valuelist(get_rows.order_row_id)#)
		</cfquery>
		<cfquery name="DEL_ROWS" datasource="#DSN3#">
			DELETE FROM
				ORDER_PRE_ROWS
			WHERE
			<cfif isdefined("session.pp")>
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
			<cfelseif isdefined("session.ww.userid")>
				RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			<cfelseif isdefined("session.ep")>
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			<cfelseif not isdefined("session_base.userid")>
				RECORD_GUEST = 1 AND 
				RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
				COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
			</cfif>
				PRODUCT_ID IS NOT NULL
		</cfquery>
		<cfif fusebox.use_stock_speed_reserve> <!--- sipariste anında urun rezerve calısıyorsa, sepetteki urunlerin rezerveleri de siliniyor --->
			<!---<cfquery name="DEL_RESERVE_ROWS" datasource="#DSN3#">
				DELETE FROM ORDER_ROW_RESERVED WHERE PRE_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cftoken#">
			</cfquery>--->
            <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
                <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
            </cfstoredproc>
		</cfif>
	</cfif>

	<cfif not isDefined('attributes.fuseact')>
        <cfset attributes.fuseact = 'objects2.list_basket'>
    </cfif>

	<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
		<cflocation url="#request.self#?fuseaction=#attributes.fuseact#&consumer_id=#attributes.consumer_id#" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=#attributes.fuseact#" addtoken="no">
	</cfif>
</cfif>

