<cfform name="find_ship" method="post" action="" onsubmit="return (find_ship_f())">
	<td style="text-align:right; vertical-align:middle;">
		<input type="text" name="find_ship_number" id="find_ship_number" value="">
		<input type="hidden" name="my_input" id="my_input" value="0">
		<input type="hidden" name="circuit" id="circuit" value="<cfoutput>#fusebox.circuit#</cfoutput>">
		<cfif session.ep.isBranchAuthorization>
			<cfquery name="get_depts" datasource="#dsn#">
				SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# 
			</cfquery>
			<cfset dept_list = valuelist(get_depts.department_id)>
			<input type="hidden" name="department_list" id="department_list" value="<cfoutput>#dept_list#</cfoutput>">
		</cfif>
	</td>
	<td style="text-align:right; vertical-align:middle;"><cf_wrk_search_button search_function='find_ship_f()' is_excel='0'></td>
</cfform>
<script type="text/javascript">
function find_ship_f()
	{
		if (find_ship.find_ship_number.value.length)
		{
			<cfif IsDefined("attributes.ship_id")>
				var Get_Ship_Purchase_Sales = wrk_query('SELECT PURCHASE_SALES FROM SHIP WHERE SHIP_ID = <cfoutput>#attributes.ship_id#</cfoutput>','dsn2');		
				if(Get_Ship_Purchase_Sales.PURCHASE_SALES == 1)
					var listPurchaseSales = 1;
				else
					var listPurchaseSales = 0;
			</cfif>		
			if(find_ship.department_list != undefined)
				var listParam = find_ship.find_ship_number.value + "*" + find_ship.department_list.value;
			else
				{
					<cfif IsDefined("attributes.ship_id")>
						var listParam = find_ship.find_ship_number.value+'*'+listPurchaseSales;
					<cfelse>
						var listParam = find_ship.find_ship_number.value;
					</cfif>
				}
				
			<cfif session.ep.isBranchAuthorization>
				var new_sql = "stk_get_ship";
			<cfelse>
				var new_sql = "stk_get_ship_2";
			</cfif>

			var get_ship = wrk_safe_query(new_sql,'dsn2',0,listParam);
		
			if(get_ship.recordcount)
			{
				if(get_ship.PURCHASE_SALES[0] == 1)<!--- satis --->
					if(get_ship.SHIP_TYPE[0] == 81)<!--- sevk irsaliyesi ise --->
						find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
					else if(get_ship.SHIP_TYPE[0] == 811)<!--- ithal mal girisi ise --->
						find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
					else
						find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
				else<!--- alis --->
					find_ship.action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_purchase&event=upd&ship_id=</cfoutput>'+get_ship.SHIP_ID[0];
				find_ship.submit();
				return false;
			}
			else 
			{
				alert("<cf_get_lang_main no='1074.Kayıt Bulunamadı'>");
				return false;
			}
		}
		else 
			{ 
				alert("<cf_get_lang_main no='1231.İrsaliye Nosu Eksik'>");
				return false;
			}
	}
</script>
