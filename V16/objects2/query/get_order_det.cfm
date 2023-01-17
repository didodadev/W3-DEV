<cfscript>
	if (listfindnocase(partner_url,'#cgi.http_host#',';'))
		attributes.company_id = session.pp.company_id;
	else if (listfindnocase(server_url,'#cgi.http_host#',';') )
	{	
		if(isdefined('session.ww.userid'))
			attributes.consumer_id = session.ww.userid;
	}
</cfscript>
<cfquery name="GET_ORDER_DET" datasource="#DSN3#">
	SELECT
		OTHER_MONEY_VALUE,
		GROSSTOTAL,
		CONSUMER_ID,
		ORDER_ID,
		COMPANY_ID,
		PARTNER_ID,
		DELIVER_DEPT_ID,
		SHIP_METHOD,
		ORDER_STAGE,
		ORDER_NUMBER,
		ORDER_HEAD,
		ORDER_DATE,
        ORDER_STATUS,
		PAYMETHOD,
		DUE_DATE,
		DELIVERDATE,
        COMMETHOD_ID,
		SHIP_ADDRESS,
		PROJECT_ID,
		ORDER_DETAIL,
		ISNULL(SA_DISCOUNT,0) AS SA_DISCOUNT,
		CARD_PAYMETHOD_ID,
		ISNULL(TAXTOTAL,0) AS TAXTOTAL,
		NETTOTAL
	FROM
		ORDERS
	WHERE
		ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> 
		<cfif isdefined("attributes.company_id")>
			AND	
			<cfif isdefined("attributes.my_company")>
				(
					COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) OR
					CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
				)
			<cfelse>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
		<cfelseif isdefined("attributes.consumer_id")>
			AND 
	  		<cfif isdefined("attributes.ref_company")>
				CONSUMER_ID IN (#list_ref_member#)
	  		<cfelse>
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	  		</cfif>				
		</cfif>
</cfquery>

<cfif not get_order_det.recordcount>
	<script language="JavaScript">
		alert("<cf_get_lang no ='1443.Sipariş No Bulunamadı! Kayıtları Kontrol Ediniz'>!");
	</script>
	<cflocation url="#request.self#?fuseaction=objects2.view_list_order" addtoken="No">
</cfif>

<cfif len(get_order_det.company_id) and get_order_det.company_id neq 0>
	<cfset comp = "1">
	<cfquery name="GET_ORDER_DET_COMP" datasource="#DSN#">
		SELECT
			COMPANY_ID,
			TAXOFFICE,
			TAXNO,
			COMPANY_ADDRESS,
			FULLNAME,
			IMS_CODE_ID
		FROM
			COMPANY
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.company_id#">
	</cfquery>
	<cfquery name="GET_ORDER_DET_CONS" datasource="#DSN#">
		SELECT
			PARTNER_ID,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = #iif(len(get_order_det.partner_id),get_order_det.partner_id,0)#
	</cfquery>
	<cfset ims_code_id = get_order_det_comp.ims_code_id>
<cfelseif len(get_order_det.consumer_id) and get_order_det.consumer_id neq 0>
	<cfquery name="GET_CONS_NAME" datasource="#DSN#">
		SELECT 
			IMS_CODE_ID,
			CONSUMER_NAME,
			CONSUMER_SURNAME,
			MEMBER_CODE
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.consumer_id#">
	</cfquery>	
	<cfset ims_code_id = get_cons_name.ims_code_id>
</cfif>
<cfif isdefined("ims_code_id") and len(ims_code_id)>
	<cfquery name="GET_IMS_CODE" datasource="#DSN#">
		SELECT 
			IMS_CODE_NAME
		FROM
			SETUP_IMS_CODE
		WHERE
			IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ims_code_id#">
	</cfquery>
	<cfset ims_code = get_ims_code.ims_code_name>
</cfif>
