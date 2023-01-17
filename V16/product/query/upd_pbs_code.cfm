<cfif len(head_pbs_code)>
	 <cfset pbs_code_ =head_pbs_code & "." & pbs_code >
<cfelse>
	<cfset pbs_code_ = pbs_code >
	<cfset head_pbs_code="">
</cfif>
<cfquery name="getPBSCode" datasource="#dsn3#">
	SELECT PBS_CODE FROM SETUP_PBS_CODE WHERE PBS_ID <> #attributes.pbs_id# AND PBS_CODE = '#pbs_code_#'
</cfquery>	
<cfif getPBSCode.recordcount>
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
	<cfquery name="UPD_PBS_CODE" datasource="#dsn3#">
		UPDATE
			SETUP_PBS_CODE 
		SET
			PBS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pbs_code_#">,
			PBS_DETAIL = <cfif len(pbs_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#pbs_detail#"><cfelse>NULL</cfif>,
			PBS_DETAIL2 = <cfif len(pbs_detail2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#pbs_detail2#"><cfelse>NULL</cfif>,
			PBS_CAT_ID = #attributes.pbs_cat_id#,
			IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
			IS_SPECIAL = <cfif isdefined('attributes.is_special')>1<cfelse>0</cfif>,
			PURCHASE_LABOUR_PRICE = <cfif len(purchase_labour_price)>#purchase_labour_price#<cfelse>0</cfif>,
			PURCHASE_LABOUR_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_labour_money#">,
			SALES_LABOUR_PRICE = <cfif len(sales_labour_price)>#sales_labour_price#<cfelse>0</cfif>,
			SALES_LABOUR_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_labour_money#">,
			PURCHASE_LABOUR_UNIT_ID = #attributes.purchase_labour_unit_id#,
			SALES_LABOUR_UNIT_ID = #attributes.sales_labour_unit_id#,
			PURCHASE_MATERIAL_PRICE = <cfif len(purchase_material_price)>#purchase_material_price#<cfelse>0</cfif>,
			PURCHASE_MATERIAL_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_material_money#">,
			SALES_MATERIAL_PRICE = <cfif len(sales_material_price)>#sales_material_price#<cfelse>0</cfif>,
			SALES_MATERIAL_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_material_money#">,
			PURCHASE_MATERIAL_UNIT_ID = #attributes.purchase_material_unit_id#,
			SALES_MATERIAL_UNIT_ID = #attributes.sales_material_unit_id#,
			PURCHASE_ENGINEERING_PRICE = <cfif len(purchase_engineering_price)>#purchase_engineering_price#<cfelse>0</cfif>,
			PURCHASE_ENGINEERING_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_engineering_money#">,
			SALES_ENGINEERING_PRICE = <cfif len(sales_engineering_price)>#sales_engineering_price#<cfelse>0</cfif>,
			SALES_ENGINEERING_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_engineering_money#">,
			PURCHASE_ENGINEERING_UNIT_ID = #attributes.purchase_engineering_unit_id#,
			SALES_ENGINEERING_UNIT_ID = #attributes.sales_engineering_unit_id#,
			PURCHASE_MANAGEMENT_PRICE = <cfif len(purchase_management_price)>#purchase_management_price#<cfelse>0</cfif>,
			PURCHASE_MANAGEMENT_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.purchase_management_money#">,
			SALES_MANAGEMENT_PRICE = <cfif len(sales_management_price)>#sales_management_price#<cfelse>0</cfif>,
			SALES_MANAGEMENT_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_management_money#">,
			PURCHASE_MANAGEMENT_UNIT_ID = #attributes.purchase_management_unit_id#,
			SALES_MANAGEMENT_UNIT_ID = #attributes.sales_management_unit_id#,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_DATE = #NOW()#
		WHERE
			PBS_ID = #attributes.pbs_id#
	</cfquery>
	<cfif attributes.HIERARCHY eq 1>
		<cfset bas = len(attributes.old_pbs_code)+1>
		<cfquery name="SUB_PBS_CODE" datasource="#dsn3#">
			UPDATE
				SETUP_PBS_CODE
			SET
				PBS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PBS_CODE#."> + RIGHT(PBS_CODE,LEN(PBS_CODE)-#BAS#),
				IS_ACTIVE = <cfif isdefined('attributes.is_active')>1<cfelse>0</cfif>,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#	
			WHERE
				PBS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.old_pbs_code#.%">
		</cfquery>
	</cfif>
	<cfif len(head_pbs_code)>
		<cfquery name="UPD_MAIN_PBS_CODE" datasource="#dsn3#">
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
