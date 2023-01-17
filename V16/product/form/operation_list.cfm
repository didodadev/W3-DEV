<!--- operasyonların listesi --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_operations_type" datasource="#dsn3#">
	SELECT 
		SMR.OPERATION_TYPE_ID,
		OT.OPERATION_TYPE
	FROM 
		SPECT_MAIN_ROW SMR,
		OPERATION_TYPES OT
	WHERE 
		OT.OPERATION_TYPE_ID = SMR.OPERATION_TYPE_ID AND
		STOCK_ID IS NULL AND 
		SPECT_MAIN_ID = (SELECT TOP 1 SM.SPECT_MAIN_ID FROM SPECT_MAIN SM,STOCKS S WHERE SM.STOCK_ID = S.STOCK_ID AND S.PRODUCT_ID = #attributes.product_id# AND IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC) AND 
		IS_PROPERTY IN (0,3,4)
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Operasyonlar','37156')#" popup_box="1">
		<cf_flat_list>
			<tbody>
				<input type="hidden" name="prod_id" id="prod_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
				<input type="hidden" name="row_number" id="row_number" value="<cfoutput>#attributes.rows#</cfoutput>" />
				<cfoutput>
					<input type="hidden" name="op_id_list_#attributes.rows#" id="op_id_list_#attributes.rows#" value="">
					<input type="hidden" name="op_name_list_#attributes.rows#" id="op_name_list_#attributes.rows#" value="">
				</cfoutput>
				<cfoutput query="get_operations_type">
					<tr class="nohover">
						<td>#OPERATION_TYPE#</td>
						<td><input type="checkbox" name="row_demand#attributes.rows#" id="row_demand#attributes.rows#" value="#operation_type_id#;#operation_type#"></td>
					</tr>
				</cfoutput>
				
			</tbody>
		</cf_flat_list>
		<cf_box_footer>
			<a href="javascript://" class="ui-btn ui-btn-success"  name="operation" id="operation" onClick="op_list();"><cf_get_lang dictionary_id="57582.Ekle"></a>
		</cf_box_footer>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	function op_list()
	{
		var is_selected=0;
		if(document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>').length > 0)
		{
			var id_list="";
			var op_list="";
			if(document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>').length ==1)
			{
				if(document.getElementById('row_demand<cfoutput>#attributes.rows#</cfoutput>').checked==true)
				{
					is_selected=1;
					id_list+=list_getat(document.getElementById('row_demand<cfoutput>#attributes.rows#</cfoutput>').value,1,';');
					op_list+=list_getat(document.getElementById('row_demand<cfoutput>#attributes.rows#</cfoutput>').value,2,';');
					document.getElementById('row_demand<cfoutput>#attributes.rows#</cfoutput>').value ='';
				}
			}	
			else
			{
				var id_list="";
				var op_list="";
				for (i=0;i<document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>').length;i++)
				{
					if(document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>')[i].checked==true)
					{ 
						is_selected=1;
						id_list+=list_getat(document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>')[i].value,1,';')+',';
						op_list+=list_getat(document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>')[i].value,2,';')+',';
						document.getElementsByName('row_demand<cfoutput>#attributes.rows#</cfoutput>')[i].value='';
					}
				}		
			}	
		}
		if(is_selected==1)
		{
			if(list_len(id_list,',') > 1)
			{
				id_list = id_list.substr(0,id_list.length-1);
				document.getElementById('op_id_list_<cfoutput>#attributes.rows#</cfoutput>').value=id_list;
				document.getElementById('op_name_list_<cfoutput>#attributes.rows#</cfoutput>').value=op_list;
			}
			else
			{
				document.getElementById('op_id_list_<cfoutput>#attributes.rows#</cfoutput>').value=id_list;
				document.getElementById('op_name_list_<cfoutput>#attributes.rows#</cfoutput>').value=op_list;
			}
		}	
		else
		{
			alert("<cf_get_lang dictionary_id='60497.Organizasyon Seçiniz'>!");
			return false;
		}
		document.all.open_operation_<cfoutput>#attributes.rows#</cfoutput>.style.display ='none';
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
	}
</script>
