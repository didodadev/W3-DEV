<cfinclude template="../query/get_product_property.cfm">
<cfset general_toplam = 0>
<cfsavecontent variable="title_">
	<cfoutput>#attributes.product_name#</cfoutput> <cf_get_lang dictionary_id='33006.Dağılımlar'>
</cfsavecontent>
<cf_popup_box title="#title_#">
<cfif get_product_property.recordcount>
	<cfloop from="1" to="2" index="k">
		<cfset "counter_#k#"= get_product_property.PROPERTY[k]>
		<cfif len(get_product_property.PROPERTY_ID[k])>
			<cfquery name="get_property_detail#k#" datasource="#DSN1#">
				SELECT 
                	PROPERTY_DETAIL_ID, 
                    PRPT_ID, 
                    PROPERTY_DETAIL, 
                    UNIT
                FROM 
            	    PRODUCT_PROPERTY_DETAIL 
                WHERE 
        	        PRPT_ID = #get_product_property.PROPERTY_ID[k]#
				ORDER BY 
    	            PRPT_ID,
	                PROPERTY_DETAIL_ID
			</cfquery>
		<cfelse>
			<cfset "get_property_detail#k#.recordcount" = 0>
		</cfif>
	</cfloop>
	<cfset arr_assort = arraynew(2)>
	<cfset size_1 = get_property_detail1.recordcount>
	<cfset size_2 = get_property_detail2.recordcount>

	<cfloop from="1" to="#get_property_detail1.recordcount#" index="i">
	  <cfloop from="1" to="#get_property_detail2.recordcount#" index="j">
		<cfset x = get_property_detail1.PROPERTY_DETAIL_ID[i]>
		<cfset y = get_property_detail2.PROPERTY_DETAIL_ID[j]>
		<cfset arr_assort[i][j] = 0>
		<cfset arr_assort[size_1+1][j] = get_property_detail2.PROPERTY_DETAIL[j]>
		<cfset arr_assort[size_1+2][j] = get_property_detail2.PROPERTY_DETAIL_ID[j]>
		<cfset arr_assort[size_1+3][j] = get_property_detail2.PRPT_ID[j]>		
	  </cfloop>
	  <cfset arr_assort[i][size_2+1] = get_property_detail1.PROPERTY_DETAIL[i]>
	  <cfset arr_assort[i][size_2+2] = get_property_detail1.PROPERTY_DETAIL_ID[i]>
	  <cfset arr_assort[i][size_2+3] = get_property_detail1.PRPT_ID[i]>	  
	</cfloop>
	
	<form name="add_assortment">
	<input name="product_id" id="product_id" type="hidden" value="<cfoutput>#attributes.product_id#</cfoutput>">
	<input name="row_id" id="row_id" type="hidden" value="<cfoutput>#attributes.row_id#</cfoutput>">	
	<table width="100%">
		<tr>
			<td valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
			<tr clasS="color-border">
			  <td>
			  <table width="100%" cellpadding="2" cellspacing="1" height="100%">
				<tr class="color-header" height="22">
				  <td class="form-title"><cfoutput>#counter_1#/#counter_2#</cfoutput></td>
				  <cfloop  from="1" to="#size_2#" index="currentrow">
					<td style="text-align:right;" class="form-title" style="text-align:right;"><cfoutput>#arr_assort[size_1+1][currentrow]#</cfoutput></td>
				  </cfloop>
				</tr>
				<input type="hidden" name="size_1" id="size_1" value="<cfoutput>#size_1#</cfoutput>">
				<input type="hidden" name="size_2" id="size_2" value="<cfoutput>#size_2#</cfoutput>">
				<cfloop  from="1" to="#size_1#" index="i">
				  <tr class="color-row" height="20">
					<td> 
					  <cfoutput>#arr_assort[i][size_2+1]#</cfoutput>
					  <cfset toplam=0>
					</td>
					<cfloop from="1" to="#size_2#" index="j">
					  <td>
	  					<input type="hidden" name="<cfoutput>property_main_id_1_#i#_#j#</cfoutput>" id="<cfoutput>property_main_id_1_#i#_#j#</cfoutput>" value="<cfoutput>#arr_assort[i][size_2+3]#</cfoutput>">
	  					<input type="hidden" name="<cfoutput>property_main_id_2_#i#_#j#</cfoutput>" id="<cfoutput>property_main_id_2_#i#_#j#</cfoutput>" value="<cfoutput>#arr_assort[size_1+3][j]#</cfoutput>">						
	  					<input type="hidden" name="<cfoutput>property_id_1_#i#_#j#</cfoutput>" id="<cfoutput>property_id_1_#i#_#j#</cfoutput>" value="<cfoutput>#arr_assort[i][size_2+2]#</cfoutput>">
	  					<input type="hidden" name="<cfoutput>property_id_2_#i#_#j#</cfoutput>" id="<cfoutput>property_id_2_#i#_#j#</cfoutput>" value="<cfoutput>#arr_assort[size_1+2][j]#</cfoutput>">						
						<input type="text" name="<cfoutput>amount_#i#_#j#</cfoutput>" id="<cfoutput>amount_#i#_#j#</cfoutput>" value="<cfoutput>#arr_assort[i][j]#</cfoutput>" class="box" style="width:100%;">
						<cfset toplam = toplam + arr_assort[i][j]>
					  </td>
					</cfloop>
				  </tr>
				</cfloop>
			  </table>
			   </td>
				  </tr>
			  </table>
			</td>
		</tr>
		<tr>
			<td colspan="<cfoutput>#get_product_property.recordcount#</cfoutput>" style="text-align:right;" style="text-align:right;">
				<cf_workcube_buttons is_upd='0' add_function="kontrol_toplam()" >
			</td>
		</tr>
	</table>
	</form>
<cfelse>
	<br/>&nbsp;&nbsp;<cf_get_lang dictionary_id='36685.Kayıtlı Ürün Özelliği Bulunamadı'>
</cfif>
</cf_popup_box>
<script type="text/javascript">
olmasi_gereken_toplam=<cfoutput>#attributes.quantity#</cfoutput>;
function load_opener_values()
{
	counter = 1;
	if (opener.assortmentArray[<cfoutput>#attributes.row_id#</cfoutput>] != undefined)
		{
		for(i = 1; i < opener.assortmentArray[<cfoutput>#attributes.row_id#</cfoutput>].length ;i++)
			{
			if (opener.assortmentArray[<cfoutput>#attributes.row_id#</cfoutput>][i][3] != undefined)
				{
				y = counter % parseFloat(add_assortment.size_2.value);
				if (y == 0) y = parseFloat(add_assortment.size_2.value);
				x = ((counter - y) / add_assortment.size_2.value) + 1;
				temp_field = eval('add_assortment.amount_' + x + '_' + y);
				temp_field.value = opener.assortmentArray[<cfoutput>#attributes.row_id#</cfoutput>][i][3];
				counter++;
				}
			}
		}
}
load_opener_values();
function kontrol_toplam()
{
	var en_genel_toplam=0;
	var size1 = add_assortment.size_1.value;
	var size2 = add_assortment.size_2.value;
	var tempArray = new Array(1);
	var counter = 1;
	tempArray[0] = new Array(1);
	for(i = 1; i<= size1 ;i++)
		{
		for(j = 1; j <= size2 ;j++)
			{
			int_txt = eval('add_assortment.amount_' + i + '_' + j + '.value');
			if (int_txt.length)
				{
				en_genel_toplam = en_genel_toplam + parseFloat(int_txt);
				tempArray[counter] = new Array(4);
				tempArray[counter][0] = 0;
				tempArray[counter][1] = eval('add_assortment.property_id_1_' + i + '_' + j + '.value');
				tempArray[counter][2] = eval('add_assortment.property_id_2_' + i + '_' + j + '.value');
				tempArray[counter][3] = int_txt;
				counter++;
				}
			}
		}
	if(en_genel_toplam != olmasi_gereken_toplam)
		{
		alert("<cf_get_lang dictionary_id='60142.Ürün asorti toplamı sepet ürün miktarı ile aynı olmalı'>!");
		return false;
		}

	opener.asorti_doldur(<cfoutput>#attributes.row_id#</cfoutput>,size1,size2,tempArray);
	window.close();	
}
</script>
