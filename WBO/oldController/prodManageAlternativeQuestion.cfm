<cf_get_lang_set module_name="prod">
<cfif not isdefined("attributes.event") or attributes.event is 'add'>
    <cfif isdefined("attributes.return")>
        <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
            <tr height="20" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
                <td>
                    <cfif not attributes.record_count>
                    	<cf_get_lang_main no='1074.Kayıt Bulunamadı'>!
                    <cfelse>
                        <cfquery name="get_update_message" datasource="#dsn#">
                            SELECT DISTINCT UPDATE_MESSAGE FROM ####TEMP_PRODUCT_TREE 
                        </cfquery>
                        <cfoutput query="get_update_message"><li>#UPDATE_MESSAGE#</li><br></cfoutput>
                        <cfquery name="get_temp_table" datasource="#dsn#">
                            IF object_id('tempdb..####TEMP_PRODUCT_TREE') IS NOT NULL
                               BEGIN
                                DROP TABLE ####TEMP_PRODUCT_TREE 
                               END
                        </cfquery>
                    </cfif>
                </td>
            </tr> 
        </table>
    	<cfabort>
    </cfif>
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.new_cat_id" default="">
    <cfparam name="attributes.question_id" default="">
    <cfparam name="attributes.pro_type" default="1">
    <cfparam name="attributes.katsayi_1" default="">
    <cfparam name="attributes.katsayi_2" default="">
    <cfparam name="attributes.katsayi_3" default="">
    <cfparam name="attributes.katsayi_4" default="">
    <cfparam name="attributes.katsayi_5" default="">
    <cfparam name="attributes.katsayi_6" default="">
    <cfparam name="attributes.katsayi_7" default="">
    <cfparam name="attributes.katsayi_8" default="">
    <cfparam name="attributes.katsayi_9" default="">
    <cfparam name="attributes.katsayi_10" default="">
    <cfparam name="attributes.question_stock_name_1" default="">
    <cfparam name="attributes.question_product_id_1" default="">
    <cfparam name="attributes.question_stock_id_1" default="">
    <cfparam name="attributes.question_stock_name_2" default="">
    <cfparam name="attributes.question_product_id_2" default="">
    <cfparam name="attributes.question_stock_id_2" default="">
    <cfparam name="attributes.question_stock_name_3" default="">
    <cfparam name="attributes.question_product_id_3" default="">
    <cfparam name="attributes.question_stock_id_3" default="">
    <cfparam name="attributes.question_stock_name_4" default="">
    <cfparam name="attributes.question_product_id_4" default="">
    <cfparam name="attributes.question_stock_id_4" default="">
    <cfparam name="attributes.question_stock_name_5" default="">
    <cfparam name="attributes.question_product_id_5" default="">
    <cfparam name="attributes.question_stock_id_5" default="">
    <cfparam name="attributes.question_stock_name_6" default="">
    <cfparam name="attributes.question_product_id_6" default="">
    <cfparam name="attributes.question_stock_id_6" default="">
    <cfparam name="attributes.question_stock_name_7" default="">
    <cfparam name="attributes.question_product_id_7" default="">
    <cfparam name="attributes.question_stock_id_7" default="">
    <cfparam name="attributes.question_stock_name_8" default="">
    <cfparam name="attributes.question_product_id_8" default="">
    <cfparam name="attributes.question_stock_id_8" default="">
    <cfparam name="attributes.question_stock_name_9" default="">
    <cfparam name="attributes.question_product_id_9" default="">
    <cfparam name="attributes.question_stock_id_9" default="">
    <cfparam name="attributes.question_stock_name_10" default="">
    <cfparam name="attributes.question_product_id_10" default="">
    <cfparam name="attributes.question_stock_id_10" default="">
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
    <cfparam name="attributes.product_id_6" default="">
    <cfparam name="attributes.product_name_6" default="">
    <cfparam name="attributes.product_id_7" default="">
    <cfparam name="attributes.product_name_7" default="">
    <cfparam name="attributes.product_id_8" default="">
    <cfparam name="attributes.product_name_8" default="">
    <cfparam name="attributes.product_id_9" default="">
    <cfparam name="attributes.product_name_9" default="">
    <cfparam name="attributes.product_id_10" default="">
    <cfparam name="attributes.product_name_10" default="">
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
            PCO.OUR_COMPANY_ID = #session.ep.company_id# 
        ORDER BY 
            HIERARCHY
    </cfquery>
    <cfquery name="get_questions" datasource="#dsn#">
        SELECT * FROM SETUP_ALTERNATIVE_QUESTIONS ORDER BY QUESTION_NAME
    </cfquery>
</cfif>
<script type="text/javascript">
	function form_kontrol()
	{
		if(document.manageAlternativeQuestions.cat.value == '' && (document.manageAlternativeQuestions.product_id_1.value == '' && document.manageAlternativeQuestions.product_name_1.value == '')  && (document.manageAlternativeQuestions.product_id_2.value == '' && document.manageAlternativeQuestions.product_name_2.value == '')  && (document.manageAlternativeQuestions.product_id_3.value == '' && document.manageAlternativeQuestions.product_name_3.value == '')  && (document.manageAlternativeQuestions.product_id_4.value == '' && document.manageAlternativeQuestions.product_name_4.value == '')  && (document.manageAlternativeQuestions.product_id_5.value == '' && document.manageAlternativeQuestions.product_name_5.value == '')  && (document.manageAlternativeQuestions.product_id_6.value == '' && document.manageAlternativeQuestions.product_name_6.value == '')  && (document.manageAlternativeQuestions.product_id_7.value == '' && document.manageAlternativeQuestions.product_name_7.value == '')  && (document.manageAlternativeQuestions.product_id_8.value == '' && document.manageAlternativeQuestions.product_name_8.value == '')  && (document.manageAlternativeQuestions.product_id_9.value == '' && document.manageAlternativeQuestions.product_name_9.value == 
		'')  && (document.manageAlternativeQuestions.product_id_10.value == '' && document.manageAlternativeQuestions.product_name_10.value == ''))
		{
			alert("<cf_get_lang no='430.Ürün Kategorisi veya Ürün Seçmelisiniz'>!");
			return false;
		}
		if(((document.manageAlternativeQuestions.question_product_id_1.value == '' && document.manageAlternativeQuestions.question_stock_name_1.value == '')  && (document.manageAlternativeQuestions.question_product_id_2.value == '' && document.manageAlternativeQuestions.question_stock_name_2.value == '')  && (document.manageAlternativeQuestions.question_product_id_3.value == '' && document.manageAlternativeQuestions.question_stock_name_3.value == '')  && (document.manageAlternativeQuestions.question_product_id_4.value == '' && document.manageAlternativeQuestions.question_stock_name_4.value == '')  && (document.manageAlternativeQuestions.question_product_id_5.value == '' && document.manageAlternativeQuestions.question_stock_name_5.value == '')  && (document.manageAlternativeQuestions.product_id_6.value == '' && document.manageAlternativeQuestions.question_stock_name_6.value == '')  && (document.manageAlternativeQuestions.question_product_id_7.value == '' && document.manageAlternativeQuestions.question_stock_name_7.value == '')  && (document.manageAlternativeQuestions.question_product_id_8.value == '' && document.manageAlternativeQuestions.question_stock_name_8.value == '')  && (document.manageAlternativeQuestions.product_id_9.value == '' && document.manageAlternativeQuestions.product_name_9.value == 
		'')  && (document.manageAlternativeQuestions.question_product_id_10.value == '' && document.manageAlternativeQuestions.question_stock_name_10.value == ''))  && document.manageAlternativeQuestions.new_cat_id.value == '')
		{
			alert('<cf_get_lang no="432.Hammadde İçin Ürün veya Kategori Seçmelisiniz">!');
			return false;
		}
		if(((document.manageAlternativeQuestions.question_product_id_1.value != '' && document.manageAlternativeQuestions.question_stock_name_1.value != '')  || (document.manageAlternativeQuestions.question_product_id_2.value != '' && document.manageAlternativeQuestions.question_stock_name_2.value != '')  || (document.manageAlternativeQuestions.question_product_id_3.value != '' && document.manageAlternativeQuestions.question_stock_name_3.value != '')  || (document.manageAlternativeQuestions.question_product_id_4.value != '' && document.manageAlternativeQuestions.question_stock_name_4.value != '')  || (document.manageAlternativeQuestions.question_product_id_5.value != '' && document.manageAlternativeQuestions.question_stock_name_5.value != '')  || (document.manageAlternativeQuestions.product_id_6.value == '' && document.manageAlternativeQuestions.question_stock_name_6.value != '')  || (document.manageAlternativeQuestions.question_product_id_7.value != '' && document.manageAlternativeQuestions.question_stock_name_7.value == '')  || (document.manageAlternativeQuestions.question_product_id_8.value != '' && document.manageAlternativeQuestions.question_stock_name_8.value != '')  || (document.manageAlternativeQuestions.product_id_9.value == '' && document.manageAlternativeQuestions.product_name_9.value !=
		'')  || (document.manageAlternativeQuestions.question_product_id_10.value != '' && document.manageAlternativeQuestions.question_stock_name_10.value != ''))  && document.manageAlternativeQuestions.new_cat_id.value != '')
		{
			alert('<cf_get_lang no="432.Hammadde İçin Ürün veya Kategori Seçmelisiniz">!');
			return false;
		}
		if(document.manageAlternativeQuestions.question_id.value == '')
		{
			alert('<cf_get_lang no="443.Alternatif Soru Seçmelisiniz">!');
			return false;
		}
		
		for(xx=1;xx<=10;xx++)
		{	//Ondalik Hane icin
			document.getElementById("katsayi_"+xx).value = filterNum(document.getElementById("katsayi_"+xx).value,4);
		}
		return true;
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
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.manage_alternative_questions&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/manage_alternative_questions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/manage_alternative_questions.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.manage_alternative_questions&event=add';
</cfscript>
