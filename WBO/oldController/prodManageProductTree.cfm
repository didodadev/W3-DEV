<cf_get_lang_set module_name="prod">
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact ="prod.manage_product_tree" default_value="0">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.pro_type" default="1">
<cfparam name="attributes.upd_amount_type" default="0">
<cfparam name="attributes.miktar" default="1">
<cfparam name="attributes.new_stock_name" default="">
<cfparam name="attributes.new_product_id" default="">
<cfparam name="attributes.new_stock_id" default="">
<cfparam name="attributes.old_stock_name" default="">
<cfparam name="attributes.old_product_id" default="">
<cfparam name="attributes.old_stock_id" default="">
<cfparam name="attributes.product_id_1" default="">
<cfparam name="attributes.product_name_1" default="">
<cfparam name="attributes.product_id_2" default="">
<cfparam name="attributes.product_name_2" default="">
<cfparam name="attributes.product_id_3" default="">
<cfparam name="attributes.product_name_3" default="">
<cfparam name="attributes.product_id_4" default="">
<cfparam name="attributes.product_name_4" default="">
<cfparam name="attributes.product_id_5" default="">
<cfparam name="attributes.product_name_5" default="">
<cfparam name="attributes.spect_main_id_1" default="">
<cfparam name="attributes.spect_main_name_1" default="">
<cfparam name="attributes.spect_main_id_2" default="">
<cfparam name="attributes.spect_main_name_2" default="">
<cfparam name="attributes.spect_main_id_3" default="">
<cfparam name="attributes.spect_main_name_3" default="">
<cfparam name="attributes.spect_main_id_4" default="">
<cfparam name="attributes.spect_main_name_4" default="">
<cfparam name="attributes.spect_main_id_5" default="">
<cfparam name="attributes.spect_main_name_5" default="">
<cfparam name="attributes.operation_type" default="">
<cfparam name="attributes.operation_type_id" default="">
<cfparam name="attributes.is_upd_amount" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.report_type" default="0">
<cfparam name="attributes.question_id" default="">
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="get_questions" datasource="#dsn#">
	SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS ORDER BY QUESTION_NAME
</cfquery>
<cfinclude template="../production_plan/query/get_product_list.cfm">
<cfif isdefined("attributes.return")>
    <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
            <td>
                <cfquery name="get_update_message" datasource="#dsn3#">
                    SELECT DISTINCT UPDATE_MESSAGE FROM ##TEMP_PRODUCT_TREE 
                </cfquery>
                <cfif get_update_message.recordcount>
                    <cfoutput query="get_update_message"><li>#UPDATE_MESSAGE#</li><br></cfoutput>
                <cfelse>
                    <cf_get_lang_main no='1074.Kayıt Bulunamadı'>!
                </cfif>
            </td>
        </tr> 
    </table>
    <cfabort>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_PRODUCT_TREE') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_PRODUCT_TREE 
           END
    </cfquery>
    <cfquery name="get_temp_table" datasource="#dsn3#">
        IF object_id('tempdb..##TEMP_PRODUCT_TREE') IS NOT NULL
           BEGIN
            DROP TABLE ##TEMP_SPECT_MAIN_ROW 
           END
    </cfquery>
</cfif>
<script type="text/javascript">
	function form_kontrol()
	{
		if(document.report_special.cat.value == '' && (document.report_special.product_id_1.value == '' && document.report_special.product_name_1.value == '')  && (document.report_special.product_id_2.value == '' && document.report_special.product_name_2.value == '')  && (document.report_special.product_id_3.value == '' && document.report_special.product_name_3.value == '')  && (document.report_special.product_id_4.value == '' && document.report_special.product_name_4.value == '')  && (document.report_special.product_id_5.value == '' && document.report_special.product_name_5.value == ''))
		{
			alert('<cf_get_lang_main no="1604.Ürün Kategorisi"> <cf_get_lang_main no="586.veya"> <cf_get_lang_main no="815.Ürün Seçmelisiniz">!');
			return false;
		}
		if(document.report_special.pro_type[0].checked==true)//cikarma islemi
		{
			if(document.report_special.old_stock_id.value == '' || document.report_special.old_stock_name.value == '')//cikarilacak ürün secili olmali
			{
				alert('<cf_get_lang_main no="815.Ürün Seçmelisiniz">!');
				return false;
			}
		}
		else if(document.report_special.pro_type[1].checked==true)// ekleme islemi
		{
			if(document.report_special.new_stock_id.value == '' || document.report_special.new_stock_name.value == '')//eklenecek ürün secili olmali
			{
				alert('<cf_get_lang_main no="1262.Yeni"> <cf_get_lang_main no="815.Ürün Seçmelisiniz">!');
				return false;
			}
			if(document.report_special.miktar.value=='')
			{
				alert('<cf_get_lang no="73.Miktar Girmelisiniz">!');
				return false;
			}
		}
		else if(document.report_special.pro_type[2].checked==true)// update islemi
		{
	
			if(document.report_special.report_type[1].checked==false)
			{
				document.report_special.question_id.value = '';
			}
			if(document.report_special.question_id.value == '')
			{
				if(document.report_special.new_stock_id.value == '' || document.report_special.new_stock_name.value == '')//eklenecek ürün secili olmali
				{
					alert('<cf_get_lang_main no="1262.Yeni"> <cf_get_lang_main no="815.Ürün Seçmelisiniz">!');
					return false;
				}
				if(document.report_special.old_stock_id.value == '' || document.report_special.old_stock_name.value == '')//cikarilacak ürün secili olmali
				{
					alert('<cf_get_lang_main no="815.Ürün Seçmelisiniz">!');
					return false;
				}
			}
			else
			{
				if(document.report_special.is_upd_amount.checked == false)
				{
					alert('Miktarı Güncelleyi Seçiniz!');
					return false;
				}
			}
			if(document.report_special.miktar.value=='')
			{
				alert('<cf_get_lang no="73.Miktar Girmelisiniz">!');
				return false;
			}
		}
		document.report_special.miktar.value = filterNum(document.report_special.miktar.value,8);
		return process_cat_control();
	}
	function product_control(crntrw)/*Ürün seçmeden spect seçemesin.*/
	{
		if(document.getElementById("product_id_"+crntrw).value=="" || document.getElementById("product_name_"+crntrw).value=="" )
		{
			alert("Spect Seçmek için öncelikle ürün seçmeniz gerekmektedir.");
			return false;
		}
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=report_special.spect_main_id_'+crntrw+'&field_name=report_special.spect_main_name_'+crntrw+'&is_display=1&product_id='+document.getElementById('product_id_'+crntrw).value,'list');
	}
	function kontrol_type(type)
	{
		if(type == 2)
			amount_table.style.display = '';
		else
		{
			amount_table.style.display = 'none';
			amount_table2.style.display = 'none';
			document.report_special.is_upd_amount.checked = false;
		}
	}
	function kontrol_upd_type()
	{
		if(document.report_special.is_upd_amount.checked == true)
			amount_table2.style.display = '';
		else
			amount_table2.style.display = 'none';
	}

	$(function(){
	
		if(document.report_special.report_type[0].checked) type_ = 0; else type_ = 1;
	report_type_control(type_);
		
		
		})
	
	
	function report_type_control(type)
	{
		if(type == 1)
		{
			document.report_special.pro_type[0].disabled = true;
			document.report_special.pro_type[1].disabled = true;
			document.report_special.pro_type[2].checked = true;
			document.report_special.is_upd_amount.checked == true;
			amount_table.style.display = '';
			//question_id1.style.display = '';
			question_id2.style.display = '';
			if(document.report_special.is_upd_amount.checked == true)
				amount_table2.style.display = '';
			else
				amount_table2.style.display = 'none';
		}
		else
		{
			document.report_special.pro_type[0].disabled = false;
			document.report_special.pro_type[1].disabled = false;
			//question_id1.style.display = 'none';
			question_id2.style.display = 'none';
			if(document.report_special.is_upd_amount.checked == true)
				amount_table2.style.display = '';
			else
				amount_table2.style.display = 'none';
		}
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.manage_product_tree';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/manage_product_tree.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/manage_product_tree.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.manage_product_tree&event=add';
</cfscript>
