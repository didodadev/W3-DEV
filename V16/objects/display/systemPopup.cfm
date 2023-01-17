<cfset hasselector=false>
<cfset types="">
<cfset idList = divLang = afterFunction = "" />
<cfparam name="attributes.columnChoice" default="1">
<cfparam name="attributes.defaultValue" default="">
<cfif isDefined("attributes.types")>
	<cfset hasselector=true>
	<cfset types=attributes.types>
</cfif>
<link rel="stylesheet" href="../../css/assets/template/catalyst/catalyst.css" type="text/css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css" type="text/css">
	<div class="col col-12">
		<cf_box title="Settings" popup_box="1">
			<cf_box_elements>
				<cfif hasselector>
					<cfif listContains(types, "dbs", ".") neq 0>
						<cfset idList = listAppend(idList, "DB") />
						<cfset divLang = listAppend(divLang, "DB",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('DB')","|") />
					</cfif>
					<cfif listContains(types, "ses", ".") neq 0>
						<cfset idList = listAppend(idList, "Session") />
						<cfset divLang = listAppend(divLang, "Session",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('Session')","|") />
					</cfif>
					<cfif listContains(types, "sys", ".") neq 0>
						<cfset idList = listAppend(idList, "SystemParam") />
						<cfset divLang = listAppend(divLang, "System Param",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('SystemParam')","|") />
					</cfif>
					<cfif listContains(types, "mtd", ".") neq 0>
						<cfset idList = listAppend(idList, "MethodQuery") />
						<cfset divLang = listAppend(divLang, "Method Query",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('MethodQuery')","|") />
					</cfif>
					<cfif listContains(types, "tag", ".") neq 0>
						<cfset idList = listAppend(idList, "CustomTag") />
						<cfset divLang = listAppend(divLang, "CustomTag",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('CustomTag')","|") />
					</cfif>
					<cfif listContains(types, "cmp", ".") neq 0>
						<cfset idList = listAppend(idList, "Autocomplete") />
						<cfset divLang = listAppend(divLang, "Autocomplete",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('Autocomplete')","|") />
					</cfif>
					<cfif listContains(types, "tri", ".") neq 0>
						<cfset idList = listAppend(idList, "ThreePoint") />
						<cfset divLang = listAppend(divLang, "ThreePoint",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('ThreePoint')","|") />
					</cfif>
					<cfif listContains(types, "cus", ".") neq 0>
						<cfset idList = listAppend(idList, "CustomCode") />
						<cfset divLang = listAppend(divLang, "Custom Code",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('CustomCode')","|") />
					</cfif>
					<cfif listContains(types, "map", ".") neq 0>
						<cfset idList = listAppend(idList, "Mapping") />
						<cfset divLang = listAppend(divLang, "Mapping",";") />
						<cfif isDefined("attributes.fromwidget") and len("attributes.fromwidget")><cfset mapperQueryString = "&fromwidget=#attributes.fromwidget#" />
						<cfelseif isDefined("attributes.tofuse") and len("attributes.tofuse")><cfset mapperQueryString = "&tofuse=#attributes.tofuse#" />
						<cfelseif isDefined("attributes.towidget") and len("attributes.towidget")><cfset mapperQueryString = "&towidget=#attributes.towidget#" />
						<cfelse><cfset mapperQueryString = "" />
						</cfif>
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('Mapper#mapperQueryString#')","|") />
					</cfif>
					<cfif listContains(types, "exp", ".") neq 0>
						<cfset idList = listAppend(idList, "ExpressionBuilder") />
						<cfset divLang = listAppend(divLang, "Expression Builder",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('ExpressionBuilder')","|") />
					</cfif>
					<cfif listContains(types, "lst", ".") neq 0>
						<cfset idList = listAppend(idList, "List") />
						<cfset divLang = listAppend(divLang, "Lists",";") />
						<cfset afterFunction = listAppend(afterFunction, "ajaxPage('List')","|") />
					</cfif>
					<cf_tab defaultOpen="#listFirst(idList)#" divId="#idList#" divLang="#divLang#" afterFunction="#afterFunction#">
						<cfloop list="#idList#" item="item">
							<div id="unique_<cfoutput>#item#</cfoutput>" class="uniqueBox"></div>
						</cfloop>
					</cf_tab>
				</cfif>
			</cf_box_elements>
		</cf_box>
	</div>
<script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
<link rel="stylesheet" href="/JS/assets/lib/jquery-expressionbuilder/expression-builder.css">
<script type="text/javascript" src="/JS/assets/lib/jquery-expressionbuilder/expression-builder-v2.js"></script>
<script type="text/javascript">
	<cfif attributes.columnChoice eq 0> <!--- imp steps adımları kısmından gelen değer//kolonları kullanmayacaksak  --->
		function ajaxPage()
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_systemPopupAjax</cfoutput>&type=DB&columnChoice=<cfoutput>#attributes.columnChoice#</cfoutput>','unique_DB',1);
			return true;
		}
		function getColumnName(column){
			opener.<cfoutput>#attributes.field_table_name#</cfoutput>.value = self.selectedTable;
			opener.<cfoutput>#attributes.field_schema_name#</cfoutput>.value = self.selectedScheme;
			opener.<cfoutput>#attributes.field_column_name#</cfoutput>.value = column;
			window.close();
		}
		ajaxPage();
	<cfelse>
		function ajaxPage(tab, tab_id, defaultValue = '')
		{
			var tab_element = (typeof(tab_id) != "undefined" && tab_id != '')  ? tab_id : tab;
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_systemPopupAjax</cfoutput>&type='+tab+'&defaultValue='+defaultValue, 'unique_'+tab_element+'', 1);
			return true;
		}
		<cfif len(idList)>
			ajaxPage('<cfoutput>#listFirst(idList)#</cfoutput>','','<cfoutput>#attributes.defaultValue#</cfoutput>');
		</cfif>
	</cfif>
	
</script>