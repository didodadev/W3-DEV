<script type="text/javascript">

allocated_value = "";

function setValue(s) {
   allocated_value = s;
}

function getValue() {
   return allocated_value;
}

function getCurrency() {
   return document.getElementById('currency').value;
}

function getLabels() {
   return document.getElementById('labels').value;
}

function _CF_setFormParam( strFormName, strParamName, strParamValue )
{
	var strObjName = "document['" + strFormName + "']['" + strParamName +"']";
	try{
		var obj = eval( strObjName );
		if( obj == undefined )
		{
			return false;
		}else{
			obj.value = strParamValue;
			return true;
		}
	}
	catch(e){
		return false;
	}
}

</script>

<!--- Veritabanından Herbir Alan(Column) İçin Veri Tipini Alıyoruz... --->
<cfquery name="GET_INVOICE_ROW_TYPES" datasource="#dsn2#">
	(SELECT
		name,
		xtype
	FROM 
		syscolumns 
	WHERE 
		id IN (SELECT 
				  id 
			   FROM 
				  sysobjects 
			   WHERE 
				  name = 'INVOICE_ROW'
			   )
	)
	UNION ALL
	(SELECT
		name,
		xtype
	FROM 
		#dsn3_alias#.syscolumns 
	WHERE 
		id IN (SELECT 
				  id 
			   FROM 
				  #dsn3_alias#.sysobjects 
			   WHERE 
				  name = 'STOCKS'
			   )
	)
	ORDER BY name
</cfquery>
<cfset type_structure = StructNew()>
<cfoutput query="GET_INVOICE_ROW_TYPES">
	<cfscript>
		switch (xtype){
			case 104:
				type_structure['#name#'] = 'boolean';
				break;
			case 62:
			case 56:
				type_structure['#name#'] = 'numeric';
				break;
			case 61:
				type_structure['#name#'] = 'tarih';
				break;
			case 99:
			case 231:
				type_structure['#name#'] = 'string_nocase';
				break;
			default : type_structure['#name#'] = 'string_nocase';
		}
	</cfscript>
</cfoutput>
<!---<cfset type_list = StructKeyList(type_structure)>
<cfloop from="1" to="#ListLen(type_list)#" index="i">
	<cfoutput>#ListGetAt(type_list,i)# = #type_structure['#ListGetAt(type_list,i)#']# <br/></cfoutput>
</cfloop>
<cfabort>--->

<!--- Order Processes For Basket Fields--->
<cfscript>
	tmp_display_list = "";
	tmp_display_field_name_list = "";
	tmp_display_field_width_list = "";
	for(dli = 1; dli lte listlen(display_list,","); dli = dli + 1){
		element = LCase(ListGetAt(display_list,dli,","));
		switch(element){
			case "stock_code"              : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "barcod"                  : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "manufact_code"           : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "product_name"            : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "amount"                  : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "unit"                    : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "spec"                    : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "price"                   : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "price_other"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "price_net"               : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "price_net_doviz"         : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "tax"                     : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "duedate"                 : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount"               : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount2_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount3_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount4_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount5_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount6_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount7_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount8_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount9_"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "disc_ount10_"            : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "row_total"               : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "row_nettotal"            : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "row_taxtotal"            : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "row_lasttotal"           : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "other_money"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "other_money_value"       : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "other_money_gross_total" : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "deliver_date"            : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "deliver_dept"            : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "deliver_dept_assortment" : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "is_parse"                : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "lot_no"                  : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "net_maliyet"             : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "marj"                    : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "dara"                    : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
			case "darali"                  : tmp_display_field_name_list = tmp_display_field_name_list & ListGetAt(display_field_name_list, dli, ",") & ","; tmp_display_list = tmp_display_list & ListGetAt(display_list, dli, ",") & ","; tmp_display_field_width_list = tmp_display_field_width_list & ListGetAt(display_field_width_list, dli, ",") & ","; break;
		}
	}
	display_field_width_list = Left(tmp_display_field_width_list, Len(tmp_display_field_width_list) - 1);
	display_field_name_list = Left(tmp_display_field_name_list, Len(tmp_display_field_name_list) - 1);
	display_list = Left(tmp_display_list, Len(tmp_display_list) - 1);
	if(ListFindNoCase(display_list, 'other_money')){
		rc = MONEYS.RecordCount;
		currency_types = "";
		currency_radio_types = "";
		for(n = 1; n lte rc; n = n + 1){
			currency_types = currency_types & MONEYS.MONEY[n] & ";";
			currency_radio_types = currency_radio_types & MONEYS.MONEY[n] & ";" & MONEYS.RATE2[n] & ";";
		}
		if(Len(currency_types)){
			currency_types = Left(currency_types, Len(currency_types) - 1);
			currency_radio_types = Left(currency_radio_types, Len(currency_radio_types) - 1);
		}
	}	
</cfscript>
<!---
<cfoutput>
	#ListLen(display_list)#<br/>
   <cfset index = 0>
   <cfset type_list = StructKeyList(type_structure)>
   <cfloop from="1" to="#ListLen(display_list)#" index="i">
   	 <cfif StructKeyExists(type_structure, '#ListGetAt(display_list,i)#') and (type_structure['#ListGetAt(display_list,i)#'] neq 'tarih')>
	   #index#. #ListGetAt(display_list,i)# -- #ListGetAt(display_field_name_list,i)# -- #type_structure['#ListGetAt(display_list,i)#']# -- #ListGetAt(display_field_width_list,i)#<br/>
	   <cfset index = index + 1>
	 <cfelseif StructKeyExists(type_structure, '#ListGetAt(display_list,i)#') and (type_structure['#ListGetAt(display_list,i)#'] eq 'tarih')>
	   ..... #ListGetAt(display_list,i)# -- #ListGetAt(display_field_name_list,i)# -- #ListGetAt(display_field_width_list,i)#<br/>
	 <cfelse>
	   .. #index#. #ListGetAt(display_list,i)# -- #ListGetAt(display_field_name_list,i)# -- numeric -- #ListGetAt(display_field_width_list,i)#<br/>
	   <cfset index = index + 1>	 	
	 </cfif>
   </cfloop>
   
	<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="n">
		<cfscript>
			data = "";
			for(j = 1; j lte ListLen(display_list); j = j + 1){
				key = ListGetAt(display_list,j);
				if(StructKeyExists(sepet.satir[n], key)){
					if(key eq 'other_money'){
						rc = MONEYS.RecordCount;
						new_value = "";
						for(b = 1; b lte rc; b = b + 1)
							new_value = new_value & MONEYS.MONEY[b] & ";";
						if(Len(new_value))
							new_value = Left(new_value, Len(new_value) - 1);
					}
					else
						new_value = Evaluate("sepet.satir[#n#].#key#");
				}
				else{
					new_value = 0;
				}
				if(not Len(new_value))
					new_value = 0;
				data = data & new_value & ",";
			}
			data = Left(data, Len(data) - 1);
		</cfscript>
		#n#. #data#" <br/>
	</cfloop>
</cfoutput>
<cfabort>--->
<cfform>
	<!--- cfgridcolumn tags are used to change the parameters involved in displaying each data field in the table--->
	<cfgrid name = "FirstGrid" width="100%" height="600"
	   insert = "Yes" delete = "Yes" sort = "Yes"
	   font = "Verdana" bold = "No" italic = "No" appendKey = "yes" highlightHref = "No"
	   gridDataAlign = "LEFT" gridLines = "Yes" rowHeaders = "Yes"
	   rowHeaderAlign = "LEFT" rowHeaderItalic = "No" rowHeaderBold = "No"
	   colHeaders = "Yes" colHeaderAlign = "LEFT"
	   colHeaderItalic = "No" colHeaderBold = "No"
	   selectColor = "##0099FF" selectMode = "EDIT" pictureBar = "no"
	   insertButton = "To insert" deleteButton = "To delete"
	   sortAscendingButton = "Sort ASC" sortDescendingButton = "Sort DESC">
	   <cfloop from="1" to="#ListLen(display_list)#" index="i">
		 <cfif StructKeyExists(type_structure, '#ListGetAt(display_list,i)#') and ('#ListGetAt(display_list,i)#' eq 'other_money')>
		   <cfgridcolumn name = "#ListGetAt(display_list,i)#" header = "#ListGetAt(display_field_name_list,i)#"
			  headerAlign = "LEFT" dataAlign = "LEFT" type="#type_structure['#ListGetAt(display_list,i)#']#"
			  bold = "Yes" italic = "No" width="#ListGetAt(display_field_width_list,i)#" select = "Yes" display = "Yes" 
			  headerBold = "yes" headerItalic = "Yes" valuesdelimiter=";" values="#currency_types#" valuesdisplay="#currency_types#">
		 <cfelseif StructKeyExists(type_structure, '#ListGetAt(display_list,i)#') and (type_structure['#ListGetAt(display_list,i)#'] neq 'tarih')>
		   <cfgridcolumn name = "#ListGetAt(display_list,i)#" header = "#ListGetAt(display_field_name_list,i)#"
			  headerAlign = "LEFT" dataAlign = "LEFT" type="#type_structure['#ListGetAt(display_list,i)#']#"
			  bold = "Yes" italic = "No" width="#ListGetAt(display_field_width_list,i)#" select = "Yes" display = "Yes" 
			  headerBold = "yes" headerItalic = "Yes">
		 <cfelseif StructKeyExists(type_structure, '#ListGetAt(display_list,i)#') and (type_structure['#ListGetAt(display_list,i)#'] eq 'tarih')>
		   <cfgridcolumn name = "#ListGetAt(display_list,i)#" header = "#ListGetAt(display_field_name_list,i)#"
			  headerAlign = "LEFT" dataAlign = "LEFT" type="string_nocase"
			  bold = "Yes" italic = "No" width="#ListGetAt(display_field_width_list,i)#" select = "Yes" display = "Yes" 
			  headerBold = "yes" headerItalic = "Yes">
		   <cfgridcolumn name = "DATEBUTTON" dataAlign = "LEFT" type="image" href="tarih" 
			  bold = "No" italic = "No" width="20" select = "Yes" display = "Yes" values="/images/calendar.gif"
			  headerBold = "yes" headerItalic = "No">
		 <cfelse>
		   <cfgridcolumn name = "#ListGetAt(display_list,i)#" header = "#ListGetAt(display_field_name_list,i)#"
			  headerAlign = "LEFT" dataAlign = "LEFT" type="numeric"
			  bold = "Yes" italic = "No" width="#ListGetAt(display_field_width_list,i)#" select = "Yes" display = "Yes" 
			  headerBold = "yes" headerItalic = "Yes">
		 </cfif>
	   </cfloop>
		<cfloop from="1" to="#ArrayLen(sepet.satir)#" index="i">
			<cfscript>
				data = "";
				for(j = 1; j lte ListLen(display_list); j = j + 1){
					key = ListGetAt(display_list,j);
					if(StructKeyExists(sepet.satir[i], key))
						new_value = Evaluate("sepet.satir[#i#].#key#");
					else
						new_value = 0;
					if(not Len(new_value))
						new_value = 0;
					data = data & new_value & ",";
				}
				data = Left(data, Len(data) - 1);
			</cfscript>
			<cfgridrow data="#data#">
		</cfloop>	
	</cfgrid>
	<input type="hidden" name="gridEntered" id="gridEntered" value="gridEntered">
	<input type="hidden" name="currency" id="currency" value="<cfoutput>#currency_radio_types#</cfoutput>">
	<input type="hidden" name="labels" id="labels" value="Dövizler,Toplam,Fatura Altı İndirim,Toplam İndirim,KDV Toplam,KDV li Toplam">
	<input type="submit" value="Tamam">
</cfform>
