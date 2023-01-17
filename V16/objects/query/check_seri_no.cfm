<cfsetting showdebugoutput="no">
<cfset url_ = "">
<cfif isdefined("attributes.is_store")>
	<cfset url_ = "&is_store=1">
</cfif>
<cfif isdefined("attributes.rma_no") and len(attributes.rma_no)>
	<cfset rma_no = attributes.rma_no>
<cfelse>
	<cfset rma_no = "">
</cfif>
<cfif isdefined("attributes.company_send_form")>
	<cfset url_ = "&company_send_form=#attributes.company_send_form#">
</cfif>
<cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
	<cfset attributes.serial_no = UrlDecode(attributes.serial_no)>
<cfelse>
	<cfset attributes.serial_no = "">
</cfif>
<cfquery name="get_seri_services" datasource="#dsn3#" maxrows="1">
	SELECT
		SERVICE_ID
	FROM
		SERVICE
	WHERE 		
		<cfif len(attributes.serial_no)>
			PRO_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_no#"> OR
			MAIN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_no#">
		<cfelse>
			SERVICE_ID < 0
		</cfif>
</cfquery>

<cfquery name="get_search_results_" datasource="#dsn3#">
	SELECT DISTINCT
		SG.SERIAL_NO AS SERI_NO,
		SG.REFERENCE_NO,
		S.STOCK_ID,
		S.PRODUCT_CODE,
		S.PRODUCT_NAME
	FROM 
		SERVICE_GUARANTY_NEW SG,
		STOCKS S
	WHERE 
		<cfif len(attributes.serial_no)>
			(	SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_no#"> OR 
				SG.REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_no#"> OR 
				SG.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.serial_no#"> 
			) AND
		</cfif>
		<cfif isdefined("attributes.rma_no") and len(attributes.rma_no)>
			RMA_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.rma_no#"> AND
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			(
				PURCHASE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> OR
				SALE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			)
			AND
		</cfif>
		SG.STOCK_ID = S.STOCK_ID
		<cfif isdefined("attributes.is_store")>
			AND SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
		</cfif>
	ORDER BY 
		S.STOCK_ID DESC
</cfquery>
<cfset mystr = "">
<cfset mystr_bitis = "">
<cfif get_search_results_.recordcount>
	<cfoutput query="get_search_results_">
		<cfif isdefined("attributes.company_id")>
            <cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
				<cfif attributes.serial_no eq REFERENCE_NO>
                    <cfset seri_add_ = "#REFERENCE_NO#">
                <cfelseif attributes.serial_no eq SERI_NO>
                    <cfset seri_add_ = "#SERI_NO#">
                <cfelse>
                	<cfset seri_add_ = "#attributes.serial_no#">
                </cfif>
            </cfif>
            <cfif not len(attributes.serial_no)>
            	<cfif len(SERI_NO)>
            		<cfset seri_add_ = "#SERI_NO#">
                <cfelseif not len(SERI_NO) and len(REFERENCE_NO)>
            		<cfset seri_add_ = "#REFERENCE_NO#">
               	</cfif>
            </cfif>
		<cfelse>
        	<cfif isdefined("attributes.serial_no") and len(attributes.serial_no)>
				<cfif attributes.serial_no eq REFERENCE_NO>
                    <cfset seri_add_ = "#REFERENCE_NO#">
                <cfelseif attributes.serial_no eq SERI_NO>
                    <cfset seri_add_ = "#SERI_NO#">
                <cfelse>
                    <cfset seri_add_ = "#attributes.serial_no#">
                </cfif>
             </cfif>
		</cfif>
		<cfset mystr = mystr & "<tr><td><a id=link_#currentrow# href=#request.self#?fuseaction=objects.serial_no&event=det#url_#&product_serial_no=#UrlEncodedFormat(seri_add_)#&seri_stock_id=#stock_id#&rma_no=#rma_no# class=tableyazi>(#seri_add_#) #PRODUCT_NAME# (#stock_id#)</a></td></tr>">
	</cfoutput>
	<cfif get_search_results_.recordcount eq 1>
		<cfset my_control_ = 1>
	</cfif>
<cfelseif not get_search_results_.recordcount and get_seri_services.recordcount>
	<cfset mystr = mystr & "<tr><td height=20><li style=list-style:none;>#getlang('','Uygun Ürün Bulunamadı','63500')#!<br/><br/><a href=#request.self#?fuseaction=objects.serial_no&event=det#url_#&product_serial_no=#attributes.serial_no#&only_service=1 class=tableyazi>Servis Kayıtlarını Görmek İçin Tıklayınız</a></li></td></tr>">
<cfelse>
	<cfset mystr = mystr & "<tr><td>#getlang('','Uygun Kayıt Bulunamadı.','56725')#</td></tr>">
</cfif>
<script>
<cfif get_search_results_.recordcount eq 1>
	document.getElementById('check_seri_layer').style.display = "none";
	document.getElementById('unique_serial_search').style.display = "none";
	document.getElementById("link_1").click();
</cfif>
</script>
<cf_box id="serial_search" title="#getlang('','Uygun Ürünler','60239')#" resize="0" closable="1" collapsable="0" >
		<cf_ajax_list>
		<cfoutput>#mystr##mystr_bitis#
		</cfoutput>
		<cf_ajax_list>
</cf_box>
			