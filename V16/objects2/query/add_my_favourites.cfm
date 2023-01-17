<cfsetting showdebugoutput="no">
<cfquery name="CONTROL" datasource="#DSN3#">
	SELECT 
		PRODUCT_ID
	FROM 
		ORDER_PRE_PRODUCTS 
	WHERE 
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> 
	<cfif isdefined('session.ww.userid')>
		AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
	</cfif>
</cfquery>
<cfif not control.recordcount>
	<cfquery name="ADD_MY_FAVOURITE" datasource="#DSN3#">
	INSERT INTO 
		ORDER_PRE_PRODUCTS
	(
		PRODUCT_ID,
		RECORD_DATE,
		RECORD_IP,
		RECORD_PAR,
		RECORD_CONS,
		RECORD_GUEST,
		RECORD_EMP,
		COOKIE_NAME,
		TYPE,
		STOCK_ID
	)
	VALUES
	(
		#attributes.product_id#,
		#now()#,
		'#cgi.remote_addr#',
		<cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
		<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
		<cfif isdefined("session.ww.userid") or not isdefined("session_base.userid")>1<cfelse>0</cfif>,
		<cfif isdefined("session.ep")>#session.ep.userid#<cfelse>NULL</cfif>,
		<cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#wrk_eval("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
		#attributes.myType#,
		#attributes.stock_id#
	)
	</cfquery>
	<br /><br/>Ürün Favori Listenize Eklendi.
	<script type="text/javascript">
		goster(_message_);
		setTimeout("gizle_message_box()",2000);
		function gizle_message_box()
		{
		 gizle(_message_);
		}
	</script>
	<cfabort>
<cfelse>
	<br /><br/>Bu Ürün Daha Önce Eklenmiş.
	<script type="text/javascript">
		goster(_message_);
		setTimeout("gizle_message_box()",2000);
		function gizle_message_box()
		{
		 gizle(_message_);
		}
	</script>
	<cfabort>
</cfif>

