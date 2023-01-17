<!---
<cfdump var="#attributes#"><cfabort>
--->
<cfquery name="stock_count" datasource="#dsn3#">
	SELECT STOCK_ID,STOCK_CODE_2,PRODUCT_UNIT_ID,PRODUCT_NAME FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
</cfquery>
<cfquery name="get_product_unit_id" datasource="#dsn3#">
	SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND IS_MAIN = 1
</cfquery>

<cfset stock_count_ = stock_count.recordcount>
<!--- color-size id --->
<cfset property_detail_id = attributes.color_detail_id>
<cfset property_detail_id = listappend(property_detail_id,attributes.size_detail_id)>
<cfset property_detail_id = listappend(property_detail_id,attributes.len_detail_id)>
<!--- //color-size id --->
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction> 
		
		<cfif isdefined('attributes.recordnum') and attributes.recordnum gt 0>
			<!--- listeden gelen color-size id leri sira ile kaydeder --->
			<cfquery name="DEL_PROPERTIES" datasource="#DSN1#">
					DELETE #dsn3#.TEXTILE_ASSORTMENT
					where REQUEST_ID=#attributes.req_id#
				 </cfquery>
		<cfloop from="1" to="#attributes.recordnum#" index="i">
			<cfquery name="get_color_property_det" datasource="#dsn1#">
					SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.color_id#i#')#">
				</cfquery>
				<cfquery name="get_len_property_det" datasource="#dsn1#">
					SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.len_id#i#')#"> 
				</cfquery>
			<cfloop from="1" to="#attributes.recordnum_size#" index="k">
			<cfif not len(evaluate("attributes.assortment#i#_#k#"))>
				<cfcontinue>
			</cfif>
				<cfquery name="get_size_property_det" datasource="#dsn1#">
					SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.assortment_id#i#_#k#')#" > 
				</cfquery>
			
            	
			<cfif isdefined("attributes.stock_id#i#_#k#") and len(evaluate("attributes.stock_id#i#_#k#"))>
				<cfset updstock_id=evaluate("attributes.stock_id#i#_#k#")>
				<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_#updstock_id#_#attributes.req_id#_'&round(rand()*100)>
				 
				
				<cfquery name="add_PROPERTIES" datasource="#DSN1#">
					INSERT INTO #dsn3#.TEXTILE_ASSORTMENT
					   ([REQUEST_ID]
					   ,[COMPANY_ID]
					   ,[PRODUCT_ID]
					   ,[STOCK_ID]
					   ,[COLOR_ID]
					   ,[SIZE_ID]
					   ,[LEN_ID]
					   ,[ASSORTMENT_AMOUNT]
					   ,[WRK_ROW_ID]
					   ,[ORDER_AMOUNT]
					   ,STOCK_AMOUNT)
				 VALUES
					   (
					   #attributes.req_id#
					   ,NULL
					   ,#attributes.product_id#
					   ,#updstock_id#
					   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_color_property_det.property_detail_id#">
					   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property_det.property_detail_id#">
					   ,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property_det.property_detail_id#">
					   ,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.assortment_amount#i#')#">
					   ,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#wrk_id#">
					   ,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.order_amount#i#')#">
					    ,<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.assortment#i#_#k#')#">
					   )
				</cfquery>
				
				<cfcontinue>
			</cfif>	
		
                
			  </cfloop>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=textile.product_plan&event=add_order_assortment&send_order=&pid=#attributes.product_id#&req_id=#attributes.req_id#&project_id=#attributes.project_id#&company_id=#attributes.company_id#&partner_id=#attributes.partner_id#&pcode</cfoutput>';
/*	wrk_opener_reload();
	window.close();*/
</script>
