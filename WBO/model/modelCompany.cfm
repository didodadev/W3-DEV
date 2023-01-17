<!---<cfscript>
	element = StructNew();
	
	element[1][0]['field'] = 'is_buyer';
	element[1][0]['label'] = 'Alıcı';
	element[1][0]['lang'] = '58733';
	element[1][0]['default'] = 0;
	element[1][0]['type'] = 'checkbox';
	element[1][0]['table'] = 'COMPANY';
	element[1][0]['tableField'] = 'IS_BUYER';
	element[1][0]['datatype'] = 'numeric';
	//Sorulacak. Anlatılmadı.
	element[1][0]['simpleCondition'] = '';
	element[1][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[1][0]['maxLength'] = ''; // int değer için
	element[1][0]['minLength'] = ''; // Boş geçilmesin diye
	element[1][0]['required'] = '1';
	element[1][0]['message'] = '58733';
	element[1][0]['fieldMethod'] = '';
	element[1][0]['threepointMethod'] = '';
	element[1][0]['autoComplete'] = '';
	element[1][0]['ifmethod'] = '';
	element[1][0]['js'] = '';
	
	element[1][1]['field'] = 'is_seller';
	element[1][1]['label'] = 'Satıcı';
	element[1][1]['lang'] = '58873';
	element[1][1]['default'] = 0;
	element[1][1]['type'] = 'checkbox';
	element[1][1]['table'] = 'COMPANY';
	element[1][1]['tableField'] = 'IS_SELLER';
	element[1][1]['datatype'] = 'numeric';
	//Sorulacak. Anlatılmadı.
	element[1][1]['simpleCondition'] = '';
	element[1][1]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[1][1]['maxLength'] = ''; // int değer için
	element[1][1]['minLength'] = ''; // Boş geçilmesin diye
	element[1][1]['required'] = '0';
	element[1][1]['message'] = '';
	element[1][1]['fieldMethod'] = '';
	element[1][1]['threepointMethod'] = '';
	element[1][1]['autoComplete'] = '';
	element[1][1]['ifmethod'] = '';
	element[1][1]['js'] = '';
	
	element[1][2]['field'] = 'is_person';
	element[1][2]['label'] = 'Şahıs';
	element[1][2]['lang'] = '30354';
	element[1][2]['default'] = 0;
	element[1][2]['type'] = 'checkbox';
	element[1][2]['table'] = 'COMPANY';
	element[1][2]['tableField'] = 'IS_PERSON';
	element[1][2]['datatype'] = 'numeric';
	//Sorulacak. Anlatılmadı.
	element[1][2]['simpleCondition'] = '';
	element[1][2]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[1][2]['maxLength'] = ''; // int değer için
	element[1][2]['minLength'] = ''; // Boş geçilmesin diye
	element[1][2]['required'] = '0';
	element[1][2]['message'] = '';
	element[1][2]['fieldMethod'] = '';
	element[1][2]['threepointMethod'] = '';
	element[1][2]['autoComplete'] = '';
	element[1][2]['ifmethod'] = '';
	element[1][2]['js'] = '';
	
	element[2][0]['field'] = 'fullname';
	element[2][0]['label'] = 'Unvan';
	element[2][0]['lang'] = '57571';
	element[2][0]['default'] = 1;
	element[2][0]['type'] = 'input';
	element[2][0]['table'] = 'COMPANY';
	element[2][0]['tableField'] = 'FULLNAME';
	element[2][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[2][0]['simpleCondition'] = '';
	element[2][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[2][0]['maxLength'] = '250'; // int değer için
	element[2][0]['minLength'] = '1'; // Boş geçilmesin diye
	element[2][0]['required'] = '1';
	element[2][0]['message'] = '57571';
	element[2][0]['fieldMethod'] = '';
	element[2][0]['threepointMethod'] = '';
	element[2][0]['autoComplete'] = '';
	element[2][0]['ifmethod'] = '';
	element[2][0]['js'] = '';
	
	element[3][0]['field'] = 'company_code';
	element[3][0]['label'] = 'No';
	element[3][0]['lang'] = '57487';
	element[3][0]['default'] = 0;
	element[3][0]['type'] = 'input';
	element[3][0]['table'] = 'COMPANY';
	element[3][0]['tableField'] = 'MEMBER_CODE';
	element[3][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[3][0]['simpleCondition'] = '';
	element[3][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[3][0]['maxLength'] = '50'; // int değer için
	element[3][0]['minLength'] = ''; // Boş geçilmesin diye
	element[3][0]['required'] = '';
	element[3][0]['message'] = '';
	element[3][0]['fieldMethod'] = '';
	element[3][0]['threepointMethod'] = '';
	element[3][0]['autoComplete'] = '';
	element[3][0]['ifmethod'] = '';
	element[3][0]['js'] = '';
	
	element[4][0]['field'] = 'pos_code';
	element[4][0]['label'] = '';//Temsilci Hidden
	element[4][0]['lang'] = '';
	element[4][0]['default'] = 0;
	element[4][0]['type'] = 'hidden';
	element[4][0]['table'] = 'COMPANY';
	element[4][0]['tableField'] = 'POS_CODE';
	element[4][0]['datatype'] = 'numeric';
	//Sorulacak. Anlatılmadı.
	element[4][0]['simpleCondition'] = '';
	element[4][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[4][0]['maxLength'] = ''; // int değer için
	element[4][0]['minLength'] = ''; // Boş geçilmesin diye
	element[4][0]['required'] = '';
	element[4][0]['message'] = '';
	element[4][0]['fieldMethod'] = '';
	element[4][0]['threepointMethod'] = '';
	element[4][0]['autoComplete'] = '';
	element[4][0]['ifmethod'] = '';
	element[4][0]['js'] = '';
	
	element[4][1]['field'] = 'pos_code_text';
	element[4][1]['label'] = 'Temsilci';
	element[4][1]['lang'] = '57908';
	element[4][1]['default'] = 0;
	element[4][1]['type'] = 'input';
	element[4][1]['table'] = 'COMPANY';
	element[4][1]['tableField'] = 'POS_CODE';
	element[4][1]['datatype'] = 'numeric';
	//Sorulacak. Anlatılmadı.
	element[4][1]['simpleCondition'] = '';
	element[4][1]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[4][1]['maxLength'] = ''; // int değer için
	element[4][1]['minLength'] = ''; // Boş geçilmesin diye
	element[4][1]['required'] = '';
	element[4][1]['message'] = '';
	element[4][1]['fieldMethod'] = '';
	element[4][1]['threepointMethod'] = "windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_code=form_add_company.pos_code&field_name=form_add_company.pos_code_text&select_list=1','list','popup_list_positions');return false";
	element[4][1]['autoComplete'] = "AutoComplete_Create('pos_code_text','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130')";
	element[4][1]['ifmethod'] = '';
	element[4][1]['js'] = "";
	
	element[5][0]['field'] = 'adres';
	element[5][0]['label'] = 'Adres';
	element[5][0]['lang'] = '58723';
	element[5][0]['default'] = 0;
	element[5][0]['type'] = 'textarea';
	element[5][0]['table'] = 'COMPANY_PARTNER';
	element[5][0]['tableField'] = 'COMPANY_PARTNER_ADDRESS';
	element[5][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[5][0]['simpleCondition'] = '';
	element[5][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[5][0]['maxLength'] = ''; // int değer için
	element[5][0]['minLength'] = ''; // Boş geçilmesin diye
	element[5][0]['required'] = '';
	element[5][0]['message'] = '';
	element[5][0]['fieldMethod'] = '';
	element[5][0]['threepointMethod'] = '';
	element[5][0]['autoComplete'] = '';
	element[5][0]['ifmethod'] = '';
	element[5][0]['js'] = '';
	
	element[6][0]['field'] = 'country';
	element[6][0]['label'] = 'Ulke';
	element[6][0]['lang'] = '58219';
	element[6][0]['default'] = 0;
	element[6][0]['type'] = 'select';
	element[6][0]['table'] = 'COMPANY_PARTNER';
	element[6][0]['tableField'] = 'COUNTRY';
	element[6][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[6][0]['simpleCondition'] = '';
	element[6][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[6][0]['maxLength'] = ''; // int değer için
	element[6][0]['minLength'] = ''; // Boş geçilmesin diye
	element[6][0]['required'] = '';
	element[6][0]['message'] = '';
	element[6][0]['fieldMethod'] = 'getCountry';
	element[6][0]['threepointMethod'] = '';
	element[6][0]['autoComplete'] = '';
	element[6][0]['ifmethod'] = '';
	element[6][0]['js'] = "onChange=LoadCity(this.value,'city_id','county_id',0)";
	
	element[7][0]['field'] = 'city_id';
	element[7][0]['label'] = 'Şehir';
	element[7][0]['lang'] = '57971';
	element[7][0]['default'] = 0;
	element[7][0]['type'] = 'select';
	element[7][0]['table'] = 'COMPANY_PARTNER';
	element[7][0]['tableField'] = 'SEMT';
	element[7][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[7][0]['simpleCondition'] = '';
	element[7][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[7][0]['maxLength'] = ''; // int değer için
	element[7][0]['minLength'] = ''; // Boş geçilmesin diye
	element[7][0]['required'] = '';
	element[7][0]['message'] = '';
	element[7][0]['fieldMethod'] = '';
	element[7][0]['threepointMethod'] = '';
	element[7][0]['autoComplete'] = '';
	element[7][0]['ifmethod'] = '';
	element[7][0]['js'] = "onchange=LoadCounty(this.value,'county_id','telcod')";
	
	element[8][0]['field'] = 'county_id';
	element[8][0]['label'] = 'İlçe';
	element[8][0]['lang'] = '58638';
	element[8][0]['default'] = 0;
	element[8][0]['type'] = 'select';
	element[8][0]['table'] = 'COMPANY_PARTNER';
	element[8][0]['tableField'] = 'COUNTY';
	element[8][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[8][0]['simpleCondition'] = '';
	element[8][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[8][0]['maxLength'] = ''; // int değer için
	element[8][0]['minLength'] = ''; // Boş geçilmesin diye
	element[8][0]['required'] = '';
	element[8][0]['message'] = '';
	element[8][0]['fieldMethod'] = '';
	element[8][0]['threepointMethod'] = '';
	element[8][0]['autoComplete'] = '';
	element[8][0]['ifmethod'] = '';
	element[8][0]['js'] = "";
	
	element[9][0]['field'] = 'firm_type';
	element[9][0]['label'] = 'Firma Tipi';
	element[9][0]['lang'] = '30146';
	element[9][0]['default'] = 0;
	element[9][0]['type'] = 'multiselect';
	element[9][0]['table'] = 'COMPANY';
	element[9][0]['tableField'] = 'FIRM_TYPE';
	element[9][0]['datatype'] = 'alphanumeric';
	//Sorulacak. Anlatılmadı.
	element[9][0]['simpleCondition'] = '';
	element[9][0]['simpleConditiontvalue'] = '';
	//Sorulacak. Anlatılmadı.
	element[9][0]['maxLength'] = ''; // int değer için
	element[9][0]['minLength'] = ''; // Boş geçilmesin diye
	element[9][0]['required'] = '';
	element[9][0]['message'] = '';
	element[9][0]['fieldMethod'] = 'multiSelectFirmType';
	element[9][0]['threepointMethod'] = '';
	element[9][0]['autoComplete'] = '';
	element[9][0]['ifmethod'] = '';
	element[9][0]['js'] = "";
	
</cfscript>

<cfoutput>
	<div class="row" type="row">
		<div class="col col-4 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<cfloop index="elemInd" from="1" to="#structCount(element)#"><!--- Struct döndürülüyor --->
				<div class="form-group" id="item-camp_head">
	                <cfset labelCount = 0>
                	<cfloop index="elemInsideInd" from="0" to="#structCount(element['#elemInd#'])-1#"><!--- İlgili formGroup'un label'i bulunuyor. --->
                    	<cfif isNumeric(element['#elemInd#']['#elemInsideInd#']['lang'])>
                        	<cfset labelForFormGroup = lang_array_all.item[element['#elemInd#']['#elemInsideInd#']['lang']]>
                            <cfset labelCount = labelCount + 1>
                        </cfif>
                    </cfloop>
                    <cfif labelCount gt 1>
                    	<cfloop index="elemInsideInd" from="0" to="#structCount(element['#elemInd#'])-1#">
                    		<label>
                            	<cf_get_lang_main dictionary_id="#element['#elemInd#']['#elemInsideInd#']['lang']#">
								<cfif element['#elemInd#']['#elemInsideInd#']['type'] is 'checkbox'>
                                    <input
                                        type="checkbox" 
                                        value="1"
                                        name="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                        id="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                        <cfif len(element['#elemInd#']['#elemInsideInd#']['maxlength'])>maxlength="#element['#elemInd#']['#elemInsideInd#']['maxlength']#"</cfif>
                                        <cfif element['#elemInd#']['#elemInsideInd#']['required'] eq 1>required="required" data-msg="<cf_get_lang_main dictionary_id=#element['#elemInd#']['#elemInsideInd#']['message']#>"</cfif>
                                    />
                                </cfif>
                            </label>
                        </cfloop>
                    <cfelse>
                    	<label class="col col-4 col-sm-12">
                        	#labelForFormGroup#
                        </label>
                        <div class="col col-8 col-sm-12">
                        	<cfloop index="elemInsideInd" from="0" to="#structCount(element['#elemInd#'])-1#">
                            	<cfif len(element['#elemInd#']['#elemInsideInd#']['threepointMethod']) or element['#elemInd#']['#elemInsideInd#']['dataType'] is 'date'>
                                	<div class="input-group">
                                </cfif>
                                <cfif listFindNoCase('input,hidden',element['#elemInd#']['#elemInsideInd#']['type'])>
                                    <input
                                        name="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                        <cfif element['#elemInd#']['#elemInsideInd#']['type'] is 'hidden'>
                                            type="hidden"
                                        <cfelse>
                                            type="text"
                                        </cfif>
                                        id="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                        <cfif len(element['#elemInd#']['#elemInsideInd#']['maxlength'])>
                                            maxlength="#element['#elemInd#']['#elemInsideInd#']['maxlength']#"
                                        </cfif>
                                        <cfif element['#elemInd#']['#elemInsideInd#']['required'] eq 1>
                                            required="required"
                                            data-msg="<cf_get_lang_main dictionary_id=#element['#elemInd#']['#elemInsideInd#']['message']#>"
                                        </cfif>
                                        <cfif len(element['#elemInd#']['#elemInsideInd#']['autoComplete'])>
                                            onfocus=#element['#elemInd#']['#elemInsideInd#']['autoComplete']#
                                        </cfif>
                                    />
                                    <cfif len(element['#elemInd#']['#elemInsideInd#']['threepointMethod'])>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="#element['#elemInd#']['#elemInsideInd#']['threepointMethod']#"></span>
                                        </div>
                                    </cfif>
                                <cfelseif element['#elemInd#']['#elemInsideInd#']['type'] is 'textarea'>
                                	<textarea id="#element['#elemInd#']['#elemInsideInd#']['field']#" name="#element['#elemInd#']['#elemInsideInd#']['field']#"></textarea>
                                <cfelseif element['#elemInd#']['#elemInsideInd#']['type'] is 'select'>
                                	<cfif len(element['#elemInd#']['#elemInsideInd#']['fieldMethod'])>
                                		<cfset selectData = deSerializeJson(evaluate("#element['#elemInd#']['#elemInsideInd#']['fieldMethod']#()"))>
                                        <cfset dataStatus = 1>
                                    <cfelse>
                                        <cfset dataStatus = 0>
                                    </cfif>
                                    <select
                                     	name="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                        id="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                        <cfif len(element['#elemInd#']['#elemInsideInd#']['js'])>
                                       		#element['#elemInd#']['#elemInsideInd#']['js']#
                                        </cfif>
                                     >
                                     	<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                        <cfif dataStatus eq 1>
                                            <cfloop index="selectIndex" from="1" to="#arrayLen(selectData['DATA'])#">
                                                <option value="#selectData['DATA']['#selectIndex#'][1]#" <cfif ArrayLen(selectData['DATA']['#selectIndex#']) eq 3><cfif selectData['DATA']['#selectIndex#'][3] eq 1>selected</cfif></cfif>>#selectData['DATA'][selectIndex][2]#</option>
                                            </cfloop>
                                        </cfif>
                                     </select>
                                <cfelseif element['#elemInd#']['#elemInsideInd#']['type'] is 'multiselect'>
									<cfif len(element['#elemInd#']['#elemInsideInd#']['fieldMethod'])>
                                    	<cfset selectData = deSerializeJson(evaluate("#element['#elemInd#']['#elemInsideInd#']['fieldMethod']#()"))>
                                        <cf_multiselect_check 
                                            table_name="#selectData['tableName']#"  
                                            name="#element['#elemInd#']['#elemInsideInd#']['field']#"
                                            option_name="#selectData['optionName']#" 
                                            option_value="#selectData['optionValue']#">
                                     </cfif>
                                </cfif>
                                <cfif element['#elemInd#']['#elemInsideInd#']['dataType'] is 'date'>
                                	<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="#element['#elemInd#']['#elemInsideInd#']['field']#"></span>
                                    </div>
                                </cfif>
                            </cfloop>
                        </div>
                    </cfif>
                </div>
            </cfloop>
        </div>
    </div>
</cfoutput>


<!--- ServerSideFunction --->
<cffunction name="getCountry" hint="Ülkeleri Çeker" access="public" returntype="string">
    <cfquery name="GET_COUNTRY" datasource="#dsn#">
        SELECT
            COUNTRY_ID,
            COUNTRY_NAME,
            IS_DEFAULT
        FROM
            SETUP_COUNTRY
        ORDER BY
            COUNTRY_NAME
    </cfquery>
    <cfreturn serializeJson(GET_COUNTRY)>
</cffunction>
<cffunction name="multiSelectFirmType" hint="Firma Tiplerini Doldurur" access="public" returntype="string">
    <cfset firmType = StructNew()>
    <cfset firmType['tableName'] = 'SETUP_FIRM_TYPE'>
    <cfset firmType['optionName'] = 'firm_type'>
    <cfset firmType['optionValue'] = 'firm_type_id'>
    <cfreturn serializeJson(firmType)>
</cffunction>
--->

