<cfif len(head_pbs_code)>
	<cfset pbs_code = head_pbs_code & "." & pbs_code>
<cfelse>
	<cfset pbs_code = pbs_code>
</cfif>
<cfquery name="GET_PBS" datasource="#dsn3#">
	SELECT PBS_CODE FROM SETUP_PBS_CODE WHERE PBS_CODE= '#pbs_code#'
</cfquery>	
<cfif GET_PBS.recordcount>
	<script type="text/javascript">
		alert("Girdiğiniz PBS Kodu Kullanılıyor");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfscript>
		purchase_labour_price = filterNum(attributes.purchase_labour_price);
		purchase_material_price = filterNum(attributes.purchase_material_price);
		purchase_engineering_price = filterNum(attributes.purchase_engineering_price);
		purchase_management_price = filterNum(attributes.purchase_management_price);
		sales_labour_price = filterNum(attributes.sales_labour_price);
		sales_material_price = filterNum(attributes.sales_material_price);
		sales_engineering_price = filterNum(attributes.sales_engineering_price);
		sales_management_price = filterNum(attributes.sales_management_price);
	</cfscript>
	<cfquery name="ADD_PBS" datasource="#dsn3#">
		INSERT INTO
			SETUP_PBS_CODE
				(
					PBS_CODE,
					PBS_DETAIL,
					PBS_DETAIL2,
					PBS_CAT_ID,
					IS_ACTIVE,
					IS_SPECIAL,
					PURCHASE_LABOUR_PRICE,
					PURCHASE_LABOUR_MONEY,
					SALES_LABOUR_PRICE,
					SALES_LABOUR_MONEY,
					PURCHASE_LABOUR_UNIT_ID,
					SALES_LABOUR_UNIT_ID,
					PURCHASE_MATERIAL_PRICE,
					PURCHASE_MATERIAL_MONEY,
					SALES_MATERIAL_PRICE,
					SALES_MATERIAL_MONEY,
					PURCHASE_MATERIAL_UNIT_ID,
					SALES_MATERIAL_UNIT_ID,
					PURCHASE_ENGINEERING_PRICE,
					PURCHASE_ENGINEERING_MONEY,
					SALES_ENGINEERING_PRICE,
					SALES_ENGINEERING_MONEY,
					PURCHASE_ENGINEERING_UNIT_ID,
					SALES_ENGINEERING_UNIT_ID,
					PURCHASE_MANAGEMENT_PRICE,
					PURCHASE_MANAGEMENT_MONEY,
					SALES_MANAGEMENT_PRICE,
					SALES_MANAGEMENT_MONEY,
					PURCHASE_MANAGEMENT_UNIT_ID,
					SALES_MANAGEMENT_UNIT_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#pbs_code#">,
					<cfif len(attributes.pbs_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pbs_detail#"><cfelse>NULL</cfif>,
					<cfif len(attributes.pbs_detail2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.pbs_detail2#"><cfelse>NULL</cfif>,
					#attributes.pbs_cat_id#,
					<cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
					<cfif isdefined('attributes.is_special')>1<cfelse>0</cfif>,
					<cfif len(purchase_labour_price)>#purchase_labour_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_labour_money#">,
					<cfif len(sales_labour_price)>#sales_labour_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_labour_money#">,
					#attributes.purchase_labour_unit_id#,
					#attributes.sales_labour_unit_id#,
					<cfif len(purchase_material_price)>#purchase_material_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_material_money#">,
					<cfif len(sales_material_price)>#sales_material_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_material_money#">,
					#attributes.purchase_material_unit_id#,
					#attributes.sales_material_unit_id#,
					<cfif len(purchase_engineering_price)>#purchase_engineering_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_engineering_money#">,
					<cfif len(sales_engineering_price)>#sales_engineering_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_engineering_money#">,
					#attributes.purchase_engineering_unit_id#,
					#attributes.sales_engineering_unit_id#,
					<cfif len(purchase_management_price)>#purchase_management_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_management_money#">,
					<cfif len(sales_management_price)>#sales_management_price#<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_management_money#">,
					#attributes.purchase_management_unit_id#,
					#attributes.sales_management_unit_id#,
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
				)
	</cfquery>
	<cfif len(head_pbs_code)>
		<cfquery name="UPD_MAIN_PBS_CODE" datasource="#DSN3#">
			UPDATE SETUP_PBS_CODE SET HIERARCHY= 1 WHERE PBS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#head_pbs_code#">
		</cfquery>
	</cfif>	
 </cftransaction>
</cflock>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
	 wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		location.reload();
	</cfif>
</script>
