<cfset module_name="prod">
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='1622.Operasyon'> <cf_get_lang_main no='2488.Revizyon'></td>
	</tr>
</table>
<cfquery name="get_p_order_control" datasource="#dsn3#"> <!---Üretimi Tamamlanmış Emirler Listeden Çıkartılıyor--->
	SELECT     
     	P_ORDER_ID
	FROM            
    	PRODUCTION_ORDERS
	WHERE        
   		IS_STAGE IN (0, 4) AND
      	P_ORDER_ID IN (#attributes.p_order_id_list#)
</cfquery>
<cfif get_p_order_control.recordcount>
	<cfset attributes.p_order_id_list = ValueList(get_p_order_control.P_ORDER_ID)>
<cfelse>
	<script type="text/javascript">
		alert("<cfoutput>#getLang('production',88)# - #getLang('main',3570)#</cfoutput>!");
		window.close()
	</script>
    <cfabort>
</cfif>
<cfquery name="get_production_orders" datasource="#dsn3#">
	SELECT        
    	PO.OPERATION_TYPE_ID, 
        COUNT(*) AS SAY, 
        OT.OPERATION_TYPE, 
        SUM(ISNULL(TBL.SON, 0)) AS SON
	FROM            
    	PRODUCTION_OPERATION AS PO INNER JOIN
       	OPERATION_TYPES AS OT ON PO.OPERATION_TYPE_ID = OT.OPERATION_TYPE_ID LEFT OUTER JOIN
      	(
        	SELECT        
            	POO.OPERATION_TYPE_ID, 
                POO.P_OPERATION_ID, 
                1 AS SON
          	FROM            
            	PRODUCTION_OPERATION AS POO INNER JOIN
           		PRODUCTION_OPERATION_RESULT AS POR ON POO.P_OPERATION_ID = POR.OPERATION_ID
           	GROUP BY
            	POO.OPERATION_TYPE_ID, 
                POO.P_OPERATION_ID
      	) AS TBL ON PO.P_OPERATION_ID = TBL.P_OPERATION_ID
	WHERE        
    	PO.P_ORDER_ID IN 
                      	(
                         	SELECT     
                            	P_ORDER_ID
							FROM            
                             	PRODUCTION_ORDERS
							WHERE        
                            	IS_STAGE IN (0, 4) AND
                              	P_ORDER_ID IN (#attributes.p_order_id_list#)
                  		)
	GROUP BY 
    	PO.OPERATION_TYPE_ID, 
        OT.OPERATION_TYPE
	ORDER BY 
    	OT.OPERATION_TYPE
</cfquery>
<cfform name="upd_operation" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_product_operation_revision">
<cfinput type="hidden" name="p_order_id_list" value="#attributes.p_order_id_list#">
<cfinput type="hidden" name="operation_id_list" id="operation_id_list" value="">
<table style="width:100%;">
	<tr>
    	<td style="text-align:center; width:100%">
        <cf_form_box>
    <table style="width:100%; height:100%; text-align:center" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td valign="top" class="dpml" style="width:50%; height:470px">
            	<table style="width:100%; height:100%" border="1" cellspacing="0" cellpadding="0">
					<tr >
						<td colspan="4" class="txtboldblue" height="30px">&nbsp;&nbsp;<cf_get_lang_main no='1159.Mevcut'> <cf_get_lang_main no='1622.Operasyon'> </td>
                  	</tr>
                    <tr height="30px">
						<td style="text-align:center; width:65%"><strong><cf_get_lang_main no='3240.Operasyon Adı'></strong></td>
                        <td style="text-align:center; width:15%"><strong><cf_get_lang_main no='80.Toplam'></strong></td>
                        <td style="text-align:center; width:15%"><strong><cf_get_lang_main no='723.Sonuçlar'></strong></td>
                        <td style="text-align:center; width:20px">
                        	<input type="checkbox" alt="<cf_get_lang_main no='3009.Hepsini Seç'>" onClick="grupla(-1);">
                        </td>
                  	</tr>
                    <cfoutput query="get_production_orders">
                    <tr  height="20px">
                        <td>&nbsp;#OPERATION_TYPE#</td>
                        <td style="text-align:right">#SAY#&nbsp;</td>
                        <td style="text-align:right">#SON#&nbsp;</td>
                        <td style="text-align:center;">
                        	<cfif say gt son>
                        		<input type="checkbox" name="select_production" value="#OPERATION_TYPE_ID#">
                            <cfelse>
                            	<img src="/images/c_ok.gif" border="0" title="" />
                            </cfif>
                        </td>
              		</tr>
                    </cfoutput>
                    <tr ><td colspan="4"></td></tr>
               	</table>
            </td>
            <td valign="top" class="dpml" style="height:100%">
            	<table style="height:100%; width:100%" border="1" cellspacing="0" cellpadding="0" align="center">
                	<tr >
						<td class="txtboldblue" height="30px" colspan="2">&nbsp;&nbsp;<cfoutput>#getLang('product',535)#</cfoutput></td>
                  	</tr>
					<tr  height="100%">
						<td style="text-align:center; vertical-align:middle; width:100%; height:100%; vertical-align:top">
                        	<table style="height:25%; width:50%; vertical-align:top;">
                        		<tr>
                                	<td style="height:10px; text-align:right">
                                    	<cf_get_lang_main no='170.Ekle'>&nbsp;<input type="radio" name="ekle_radio" id="ekle_radio0" value="0"/>
                                    </td>
                                </tr>
                                <tr>
                                	<td style="height:10px; text-align:right">
                                    	<cf_get_lang_main no='3160.Çıkar'>&nbsp;<input type="radio" name="ekle_radio" id="ekle_radio1" value="1"/>
                                   	</td>
                                </tr>
                                <tr>
                                	<td style="height:10px; text-align:right">
                                    	<cfoutput>#getLang('account',72)#</cfoutput>&nbsp;<input type="radio" name="ekle_radio" id="ekle_radio2" checked="checked" value="2"/>
                                   	</td>
                                </tr>
                        	</table>
                        </td>
                  	</tr>
               	</table>
            </td>
            <td valign="top" class="dpml" style="width:280px">
            	<table width="100%" border="1" cellspacing="0" cellpadding="0"  align="center">
					<tr >
						<td class="txtboldblue" height="30px" colspan="3">&nbsp;&nbsp;<cfoutput>#getLang('prod',67)#</cfoutput></td>
                  	</tr>
                    <tr height="30px">
                    	<td style="text-align:center; width:20px">
                        	<input type="hidden" name="record_num" id="record_num" value="">
                         	<input type="button" class="eklebuton" title="<cf_get_lang_main no='170.Ekle'>" onclick="openOperatios();">
                        </td>
						<td style="text-align:center; width:220px"><strong><cf_get_lang_main no='3240.Operasyon Adı'></strong></td>
                        <td style="text-align:center; width:40px"><strong><cf_get_lang_main no='223.Miktar'></strong></td>
                  	</tr>
                    <tbody name="new_row" id="new_row">
                        <tr name="frm_row#currentrow#" id="frm_row#currentrow#">
                        </tr>
                    </tbody>
               	</table>
            </td>
       	</tr>
        <tr>
        	<td colspan="3">
                <cf_form_box>	
                    
                    <cf_form_box_footer>
                       	<cf_workcube_buttons 
                         	is_upd='0' 
                       		is_delete = '0' 
                        	add_function='kontrol()'>
                  	
          			</cf_form_box_footer>
            	</cf_form_box>
         	</td>
      	</tr>
    </table>
    </cf_form_box>
    </td>
    </tr>
    </table>
    
</cfform>
<script type="text/javascript">
	function grupla(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		operation_id_list = '';
		chck_leng = document.getElementsByName('select_production').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_production[ci];
			if(chck_leng == 1)
				var my_objets =document.all.select_production;
			if(type == -1)
			{//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
					operation_id_list +=my_objets.value+',';
			}
		}
		operation_id_list = operation_id_list.substr(0,operation_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		return true;
	}
	var row_count=document.upd_operation.record_num.value;
	function openOperatios()
	{
		window.open("<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_operations</cfoutput>","_blank","width=250,height=600,left=700,top=300");
	}
	function add_row(operation_type_id,operation_type)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.upd_operation.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';
			
			
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="operation_type_id'+row_count+'" name="operation_type_id'+row_count+'" value="'+operation_type_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="operation_type' + row_count + '" style="width:100%;" value="'+operation_type+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,2)#</cfoutput>" style="width:100%; text-align:right;">';
	}
	function sil(sy)
	{
		var element=eval("upd_operation.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";
	} 
	function kontrol()
	{
		grupla();
		document.getElementById('operation_id_list').value = operation_id_list;
		if(document.upd_operation.ekle_radio[0].checked==true)//ekleme islemi
		{

		}
		else if(document.upd_operation.ekle_radio[1].checked==true)//çıkarma islemi
		{
			operation_say = list_len(operation_id_list);
			if(operation_say<1)
			{
				alert('<cfoutput>#getLang('production',60)#</cfoutput>');
				return false;
			}
		}
		else if(document.upd_operation.ekle_radio[2].checked==true)//değiştir islemi
		{
			 operation_say = list_len(operation_id_list);
			if(operation_say<1)
			{
				alert('<cfoutput>#getLang('production',60)#</cfoutput>');
				return false;
			}
			if(document.getElementById('record_num').value<1)
			{
				alert('<cfoutput>#getLang('prod',478)#</cfoutput>');
				return false;
			}
		}
	}
</script>