<cfset counter = 0>
<cfset sel_box_status = isdefined("attributes.is_disable") ? 'disabled' : 'enabled'>
  
<cfif GET_PRICE.IS_GIFT_CARD eq 1>
    <cfquery name="GET_ALTERNATIVE" datasource="#new_dsn3#">
        SELECT 
            SPECT_MAIN_ID, 
            SPECT_MAIN_NAME, 
            SPECT_TYPE, 
            RECORD_EMP, 
            RECORD_DATE, 
            (SELECT TOP 1 SP.SPECT_VAR_ID FROM SPECTS SP WHERE SP.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID ORDER BY SP.RECORD_DATE) SPECT_VAR_ID 
        FROM 
            SPECT_MAIN 
        WHERE 
            1=1 AND 
            STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">  AND 
            SPECT_STATUS = 1 
        ORDER BY 
            RECORD_DATE DESC 
    </cfquery>
    <cf_grid_list id="mainSpect">
        <thead>
            <tr><th><cf_get_lang dictionary_id="33259.Main Spect Seçimi"></th></tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="form-group">
                        <select name="spect_var_id" id="spect_var_id">
                            <cfoutput query="get_alternative">
                                <option value="#spect_var_id#">#spect_main_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </td>
            </tr>
        </tbody>
    </cf_grid_list>
<cfelse>
    <cf_grid_list id="alternative">
        <thead>
            <tr>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id="34311.Alternatif"></th>
                <th><cf_get_lang dictionary_id='57564.Ürünler'></th>
            </tr>
        </thead>
        <tbody>
            <cfif len(main_spec_id_0)>
                <cfscript>
                    row_number= 0;
                    deep_level = 0;
                    no_count = 0;
                    function get_subs(spect_main_id,next_stock_id,type)
                    {
                        if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                        {											
                            SQLStr = "
                                    SELECT
                                        ISNULL(SMR.RELATED_MAIN_SPECT_ID,0) AS RELATED_ID,
                                        ISNULL(SMR.STOCK_ID,0) STOCK_ID,
                                        SPECT_MAIN_ROW_ID,
                                        ISNULL(SMR.QUESTION_ID,0) AS QUESTION_ID,
                                        ISNULL(SMR.PRODUCT_ID,0) AS PRODUCT_ID
                                    FROM 
                                        SPECT_MAIN_ROW SMR
                                    WHERE
                                        STOCK_ID IS NOT NULL AND
                                        SPECT_MAIN_ID = #spect_main_id#
                                    ORDER BY
                                        RELATED_TREE_ID,
                                        LINE_NUMBER										
                                    ";
                            }
                            else
                            {											
                                if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
                                SQLStr = "
                                        SELECT
                                            PRODUCT_TREE_ID RELATED_ID,
                                            ISNULL(PT.STOCK_ID,0) STOCK_ID,
                                            ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ROW_ID,
                                            ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
                                            ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
                                            ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
                                            ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
                                            ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
                                        FROM 
                                            PRODUCT_TREE PT
                                        WHERE
                                            #where_parameter#
                                        ORDER BY
                                            LINE_NUMBER,
                                            STOCK_ID DESC
                                    ";
                            }
                            query1 = cfquery(SQLString : SQLStr, Datasource : new_dsn3);
                            stock_id_ary='';
                            for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
                            {
                                stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
                                stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
                                stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ROW_ID[str_i],'§');
                                stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
                                stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
                                if(isdefined("query1.OPERATION_TYPE_ID"))
                                {
                                    stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
                                    stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
                                    stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
                                }
                            }
                            return stock_id_ary;
                        }
                        function GetDeepLevelMaınStockId(_deeplevel)
                        {
                            if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                            {
                                for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
                                    if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
                                        return Evaluate('_deep_level_main_stock_id_#lind_#');
                                }
                            }
                            else
                            {
                                for (lind_ = _deeplevel;lind_ gte 0; lind_ = lind_-1){
                                    if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
                                        return Evaluate('_deep_level_main_stock_id_#lind_#');
                                }
                            }
                            return 1;
                        }                                        
                        question_list = '';
                        get_row = QueryNew("QUESTION_NO,DETAIL","VarChar,VarChar");
                        row_of_query = 0;
                        function writeTree(next_spect_main_id,next_stock_id,type)
                        {
                            var i = 1;
                            var sub_products = get_subs(next_spect_main_id,next_stock_id,type);
                            deep_level = deep_level + 1;
                            
                            for (i=1; i lte listlen(sub_products,'█'); i = i+1)
                            {
                                _next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
                                _next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
                                _next_spect_main_row_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
                                _next_question_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
                                _next_product_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
                                select_image_div = 'spec_image_#_next_question_id_#';
                                if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                {
                                    _n_operation_id_ = 0;
                                    _n_spec_main_id_= '';
                                    _n_stock_related_id_= '';
                                }
                                else
                                {
                                    _n_operation_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
                                    _n_spec_main_id_= ListGetAt(ListGetAt(sub_products,i,'█'),7,'§');
                                    _n_stock_related_id_= ListGetAt(ListGetAt(sub_products,i,'█'),8,'§');
                                }
                                if(not ((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id))))
                                {
                                    if(_next_stock_id_ gt 0) '_deep_level_main_stock_id_#deep_level#' = _next_stock_id_; else '_deep_level_main_stock_id_#deep_level#' = '-1';
                                }
                                alterNativeProduct='';
                                alterNativeProduct_hidden='';
                                question_name ='';
                                if(_next_question_id_ gt 0 and _n_operation_id_ eq 0)
                                {
                                    if(listfindnocase(question_list,_next_question_id_))
                                    {
                                        is_hidden = 1;
                                    }
                                    else
                                    {
                                        is_hidden = 0;
                                        question_list = listappend(question_list,_next_question_id_);
                                    }
                                    
                                    if(isDefined('session.pp.userid') and session_base.language neq 'tr')	
                                    {
                                        questionNameStr="SELECT SLI.UNIQUE_COLUMN_ID QUESTION_NO, SLI.ITEM QUESTION_NAME FROM SETUP_LANGUAGE_INFO SLI WHERE SLI.UNIQUE_COLUMN_ID = #_next_question_id_# AND SLI.TABLE_NAME = 'SETUP_ALTERNATIVE_QUESTIONS' AND SLI.COLUMN_NAME = 'QUESTION_NAME' AND SLI.LANGUAGE = '#session_base.language#'";																									
                                        questionNameQuery = cfquery(SQLString : questionNameStr, Datasource : dsn);
                                        short_question_name = '';
                                        if(not questionNameQuery.recordcount)
                                        {
                                            questionNameStr='SELECT QUESTION_NAME,QUESTION_DETAIL,ISNULL(QUESTION_NO,0) QUESTION_NO FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID=#_next_question_id_# ORDER BY QUESTION_NO';
                                            questionNameQuery = cfquery(SQLString : questionNameStr, Datasource : dsn);
                                            short_question_name = '#questionNameQuery.QUESTION_DETAIL#';
                                        }
                                    }
                                    if( isDefined('session.ep.userid') or (isDefined('session.pp.userid') and session_base.language eq 'tr') )
                                    {													
                                        questionNameStr='SELECT QUESTION_NAME,QUESTION_DETAIL,ISNULL(QUESTION_NO,0) QUESTION_NO FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID=#_next_question_id_# ORDER BY QUESTION_NO';													
                                        questionNameQuery = cfquery(SQLString : questionNameStr, Datasource : dsn);
                                        short_question_name = '#questionNameQuery.QUESTION_DETAIL#';
                                    }
                                    question_no ='#questionNameQuery.QUESTION_NO#';
                                    question_name ='#questionNameQuery.QUESTION_NAME#';
                                    if(not len(short_question_name)) short_question_name=' ';
                                    alternativeQuestion="
                                        WITH CTE AS(
                                            SELECT DISTINCT
                                                ISNULL(AP.USAGE_RATE,0) AS USAGE_RATE,
                                                ISNULL(AP.USEAGE_PRODUCT_AMOUNT,0) AS USAGE_AMOUNT,
                                                S.STOCK_CODE_2,
                                                P.PRODUCT_NAME,
                                                CASE WHEN (S.STOCK_CODE=P.PRODUCT_CODE)
                                                    THEN P.PRODUCT_DETAIL2 
                                                ELSE
                                                    S.PROPERTY
                                                END AS PRODUCT_DETAIL2,
                                                S.STOCK_CODE,
                                                S.STOCK_ID,
                                                S.PRODUCT_ID,
                                                ISNULL(AP.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                                                ALTERNATIVE_PRODUCT_NO,
                                                ISNULL(AP.IS_PHANTOM,0) IS_PHANTOM,
                                                S2.STOCK_ID MAIN_STOCK_ID,
                                                S2.PRODUCT_ID MAIN_PRODUCT_ID,
                                                S2.PRODUCT_NAME MAIN_PRODUCT_NAME
                                            FROM 
                                                ALTERNATIVE_PRODUCTS AP, 
                                                #dsn1_alias#.STOCKS S,
                                                #dsn1_alias#.PRODUCT P,
                                                #new_dsn3_alias#.STOCKS S2
                                            WHERE 
                                                AP.QUESTION_ID = #_next_question_id_# AND
                                                TREE_STOCK_ID = #GetDeepLevelMaınStockId(deep_level)#  AND
                                                P.PRODUCT_ID =AP.ALTERNATIVE_PRODUCT_ID AND
                                                S.STOCK_ID = AP.STOCK_ID AND 
                                                P.PRODUCT_ID =S.PRODUCT_ID AND
                                                AP.PRODUCT_ID = S2.PRODUCT_ID AND
                                                (AP.START_DATE <= #createodbcdatetime(now())# OR AP.START_DATE IS NULL) AND
                                                (AP.FINISH_DATE >= #createodbcdatetime(DATEADD('d',-1,now()))# OR AP.FINISH_DATE IS NULL)
                                            ),
                                            CTE2 AS (
                                            SELECT DISTINCT
                                                0 AS USAGE_RATE,
                                                0 AS USAGE_AMOUNT,
                                                S.STOCK_CODE_2,
                                                P.PRODUCT_NAME,
                                                CASE WHEN (S.STOCK_CODE=P.PRODUCT_CODE)
                                                    THEN P.PRODUCT_DETAIL2 
                                                ELSE
                                                    S.PROPERTY
                                                END AS PRODUCT_DETAIL2,
                                                S.STOCK_CODE,
                                                S.STOCK_ID,
                                                S.PRODUCT_ID,
                                                0 SPECT_MAIN_ID,
                                                '' ALTERNATIVE_PRODUCT_NO,
                                                0 AS IS_PHANTOM,
                                                S.STOCK_ID MAIN_STOCK_ID,
                                                S.PRODUCT_ID MAIN_PRODUCT_ID,
                                                P.PRODUCT_NAME MAIN_PRODUCT_NAME
                                            FROM 
                                                #dsn1_alias#.STOCKS S,
                                                #dsn1_alias#.PRODUCT P
                                            WHERE 
                                                P.PRODUCT_ID =S.PRODUCT_ID AND
                                                S.STOCK_ID = #_next_stock_id_# AND S.STOCK_ID NOT IN(SELECT STOCK_ID FROM CTE)
                                                AND STOCK_ID NOT IN (#_deep_level_main_stock_id_0#)
                                            ),
                                            CTE1 AS (
                                            SELECT DISTINCT 
                                                ISNULL(AP.USAGE_RATE, 0) AS USAGE_RATE, 
                                                ISNULL(AP.USEAGE_PRODUCT_AMOUNT, 0) AS USAGE_AMOUNT, 
                                                S.STOCK_CODE_2, 
                                                S.PRODUCT_NAME, 
                                                CASE WHEN (S.STOCK_CODE = S.PRODUCT_CODE) 
                                                    THEN S.PRODUCT_DETAIL2 
                                                ELSE 
                                                    S.PROPERTY 
                                                END AS PRODUCT_DETAIL2, 
                                                S.STOCK_CODE, 
                                                S.STOCK_ID, 
                                                S.PRODUCT_ID, 
                                                ISNULL(AP.SPECT_MAIN_ID, 0) AS SPECT_MAIN_ID, 
                                                AP.ALTERNATIVE_PRODUCT_NO, 
                                                ISNULL(AP.IS_PHANTOM, 0) AS IS_PHANTOM, 
                                                S2.STOCK_ID AS MAIN_STOCK_ID, 
                                                S2.PRODUCT_ID AS MAIN_PRODUCT_ID, 
                                                S2.PRODUCT_NAME AS MAIN_PRODUCT_NAME
                                            FROM            
                                                #new_dsn3_alias#.PRODUCT_TREE PT,
                                                #new_dsn3_alias#.ALTERNATIVE_PRODUCTS AP,
                                                #new_dsn3_alias#.STOCKS S,
                                                #new_dsn3_alias#.STOCKS S2
                                            WHERE        
                                                PT.STOCK_ID = #GetDeepLevelMaınStockId(deep_level)# AND 
                                                PT.QUESTION_ID = #_next_question_id_# AND 
                                                ISNULL(AP.TREE_STOCK_ID, 0) = 0	AND
                                                PT.PRODUCT_ID = AP.PRODUCT_ID AND
                                                AP.STOCK_ID = S.STOCK_ID AND
                                                PT.RELATED_ID = S2.STOCK_ID
                                            )
                                        SELECT * FROM (		
                                                        SELECT * FROM CTE
                                                        UNION 
                                                        SELECT * FROM CTE1
                                                        UNION 
                                                        SELECT * FROM CTE2
                                                        )
                                                        CTE3 
                                        ORDER BY 
                                            ALTERNATIVE_PRODUCT_NO,PRODUCT_DETAIL2";
                                        alternativeQuestQuery = cfquery(SQLString : alternativeQuestion, Datasource : new_dsn3);
                                        if(alternativeQuestQuery.recordcount)
                                        {
                                            if(is_hidden eq 1)
                                            {
                                                hidden_value = '';
                                                for (ap_indx=1; ap_indx lte alternativeQuestQuery.recordcount; ap_indx = ap_indx+1)
                                                {
                                                        if(len(alternativeQuestQuery.PRODUCT_DETAIL2[ap_indx]))
                                                    {
                                                        alter_product_name_hidden = alternativeQuestQuery.PRODUCT_NAME[ap_indx];
                                                        alter_special_code_hidden = alternativeQuestQuery.PRODUCT_DETAIL2[ap_indx];
                                                    }
                                                    else
                                                    {
                                                        alter_product_name_hidden = alternativeQuestQuery.PRODUCT_NAME[ap_indx];
                                                        alter_special_code_hidden = alternativeQuestQuery.PRODUCT_NAME[ap_indx];
                                                    }
                                                    alter_product_name_hidden = replace(alter_product_name_hidden,',','','all');
                                                    alter_product_name_hidden = replace(alter_product_name_hidden,'/','','all');
                                                    alter_product_name_hidden = replace(alter_product_name_hidden,':','','all');
                                                    alter_special_code_hidden = replace(alter_special_code_hidden,',','','all');
                                                    alter_special_code_hidden = replace(alter_special_code_hidden,'/','','all');
                                                    alter_special_code_hidden = replace(alter_special_code_hidden,':','','all');
                                                    if(not len(alternativeQuestQuery.USAGE_RATE[ap_indx]))
                                                        usage_rate_ = 0;
                                                    else
                                                        usage_rate_ = alternativeQuestQuery.USAGE_RATE[ap_indx];
                                                        
                                                    if((isdefined('attributes.id') and len(attributes.id) or isdefined('attributes.upd_main_spect')) and _next_stock_id_ eq alternativeQuestQuery.STOCK_ID[ap_indx])//güncelleme sayfası ise ve satırdaki ürün ile alternatif ürün eşit ise...
                                                    {
                                                        hidden_value='#alternativeQuestQuery.STOCK_ID[ap_indx]#█#alter_product_name_hidden#█#alter_special_code_hidden#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_indx]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_indx]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_indx]#█#alternativeQuestQuery.IS_PHANTOM[ap_indx]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_indx]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_indx]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_indx]#';
                                                    }
                                                }													
                                                alterNativeProduct_hidden='<input type="hidden" #sel_box_status# title="#_next_question_id_#" id="altertive_selectbox" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" value="#hidden_value#">';
                                            }
                                            else
                                            {
                                                /*if(isDefined('session.pp.userid'))
                                                {*/
                                                if(session_base.language eq 'tr')
                                                    alterNativeProduct='<div class="form-group"><select title="#_next_question_id_#" onchange="add_hidden_value(this);" #sel_box_status# id="altertive_selectbox#counter#" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" style="width:245px;"><option value="">Seçiniz</option></div>';
                                                else
                                                    alterNativeProduct='<div class="form-group"><select title="#_next_question_id_#" onchange="add_hidden_value(this);" #sel_box_status# id="altertive_selectbox#counter#" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" style="width:245px;"><option value="">Please Select</option></div>';
                                                counter = counter + 1;
                                                /*}
                                                else
                                                    alterNativeProduct='<div class="form-group"><select title="#_next_question_id_#" onchange="add_hidden_value(this);" #sel_box_status# id="altertive_selectbox" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" style="width:245px;"><option value="">Seçiniz</option></div>';*/
                                            
                                                for (ap_in=1; ap_in lte alternativeQuestQuery.recordcount; ap_in = ap_in+1)
                                                {
                                                    if(len(alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]))
                                                    {
                                                        alter_product_name = alternativeQuestQuery.PRODUCT_NAME[ap_in];
                                                        if(isDefined('session.pp') and session_base.language neq 'tr')
                                                        {
                                                            alternativeRespQuery_ = cfquery(SQLString:"SELECT UNIQUE_COLUMN_ID, TABLE_NAME, COLUMN_NAME, LANGUAGE, ITEM FROM SETUP_LANGUAGE_INFO WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_DETAIL2' AND ITEM <> '' AND LANGUAGE = '#session_base.language#' AND UNIQUE_COLUMN_ID = #alternativeQuestQuery.PRODUCT_ID[ap_in]#",Datasource:dsn);
                                                            if(alternativeRespQuery_.recordcount)
                                                                alter_special_code = alternativeRespQuery_.item;
                                                            else																																					
                                                                alter_special_code = alternativeQuestQuery.PRODUCT_DETAIL2[ap_in];
                                                        }
                                                        else																																					
                                                            alter_special_code = alternativeQuestQuery.PRODUCT_DETAIL2[ap_in];
                                                    }
                                                    else
                                                    {
                                                        alter_product_name = alternativeQuestQuery.PRODUCT_NAME[ap_in];
                                                        alter_special_code = alternativeQuestQuery.PRODUCT_NAME[ap_in];
                                                    }
                                                    alter_product_name = replace(alter_product_name,',','','all');
                                                    alter_product_name = replace(alter_product_name,'/','','all');
                                                    alter_product_name = replace(alter_product_name,':','','all');
                                                    alter_special_code = replace(alter_special_code,',','','all');
                                                    alter_special_code = replace(alter_special_code,'/','','all');
                                                    alter_special_code = replace(alter_special_code,':','','all');
                                                    if(not len(alternativeQuestQuery.USAGE_RATE[ap_in]))
                                                        usage_rate_ = 0;
                                                    else
                                                        usage_rate_ = alternativeQuestQuery.USAGE_RATE[ap_in];
                                                    if((isdefined('attributes.id') and len(attributes.id) or isdefined('attributes.upd_main_spect')) and _next_stock_id_ eq alternativeQuestQuery.STOCK_ID[ap_in])//güncelleme sayfası ise ve satırdaki ürün ile alternatif ürün eşit ise...
                                                        is_selected='selected';
                                                    else
                                                        is_selected='';	
                                                    // writeoutput('#_next_stock_id_#-#alternativeQuestQuery.STOCK_ID[ap_in]#_#alter_product_name#<br/>');	
                                                    if(isdefined("is_alternative_stock_name") and is_alternative_stock_name eq 1)
                                                    {
                                                        if(usage_rate_ gt 0)
                                                            alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_NAME[ap_in]# #alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]# - (% #usage_rate_#)</option>';
                                                        else
                                                            alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_NAME[ap_in]# #alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]# </option>';
                                                    }
                                                    else
                                                    {
                                                        if(usage_rate_ gt 0)
                                                            alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]# - (% #usage_rate_#)</option>';
                                                        else
                                                            if(isDefined('session.pp') and session_base.language neq 'tr')
                                                            {
                                                                alternativeRespQuery_ = cfquery(SQLString:"SELECT UNIQUE_COLUMN_ID, TABLE_NAME, COLUMN_NAME, LANGUAGE, ITEM FROM SETUP_LANGUAGE_INFO WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_DETAIL2' AND ITEM <> '' AND LANGUAGE = '#session_base.language#' AND UNIQUE_COLUMN_ID = #alternativeQuestQuery.PRODUCT_ID[ap_in]#",Datasource:dsn);
                                                                if(alternativeRespQuery_.recordcount)
                                                                    alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeRespQuery_.item#</option>';
                                                                else
                                                                    alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]#</option>';
                                                            }
                                                            else
                                                                alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]#</option>';
                                                    }
                                                    if(len(_next_product_id_))
                                                    {
                                                        questionProductImage='SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = #_next_product_id_#';
                                                        questionProductImageQuery = cfquery(SQLString : questionProductImage, Datasource : new_dsn3);
                                                        if(questionProductImageQuery.recordcount)
                                                            specAlternativeProductImage = '<img src="documents/product/#questionProductImageQuery.PATH#" title="#questionProductImageQuery.DETAIL#" width="150" height="150" border="0" align="absmiddle" />';
                                                        else
                                                            specAlternativeProductImage = '';
                                                    }
                                                    else
                                                            specAlternativeProductImage = '';
                                                }
                                                alterNativeProduct='#alterNativeProduct#</select>';
                                            }
                                        }
                                        else
                                        {
                                                specAlternativeProductImage = '';
                                                no_count = no_count + 1;
                                        }
                                        if(is_hidden neq 1)
                                        {
                                            row_of_query = row_of_query + 1;
                                            QueryAddRow(get_row,1);
                                            zero = '';
                                            for(kk=1;kk<=3-len(question_no);kk++)
                                                zero = "#zero#0";
                                            QuerySetCell(get_row,"QUESTION_NO","#zero##question_no#",row_of_query);
                                            alterNativeProduct = replace(alterNativeProduct,',','.','all');
                                            QuerySetCell(get_row,"DETAIL","#question_no#~#question_name#~#alterNativeProduct#~#specAlternativeProductImage#",row_of_query);
                                            /*writeoutput('
                                            <tr height="20" class="color-row"> 
                                                <td valign="top">#row_number#</td>
                                                <td valign="top">#question_name#</td>
                                                <td valign="top">#alterNativeProduct#</td>
                                                <td><div id="#select_image_div#">#specAlternativeProductImage#</div></td>
                                            </tr>');*/
                                        }
                                        else
                                        {
                                            writeoutput('#alterNativeProduct_hidden#');
                                        }
                                }
                                if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                {
                                    '_deep_level_main_stock_id_#deep_level#' = _next_stock_id_;
                                    if(_next_spect_main_id_ gt 0)
                                    {
                                        writeTree(_next_spect_main_id_,_n_stock_related_id_,0);
                                    }
                                }
                                else								
                                {
                                    if(_n_operation_id_ gt 0) type_=3;else type_=0;
                                    writeTree(_next_spect_main_id_,_n_stock_related_id_,type_);
                                }                              
                                }
                                deep_level = deep_level-1;
                        }
                        writeTree(main_spec_id_0,_deep_level_main_stock_id_0,0);
                </cfscript>
                <cfquery name="GET_ROW" dbtype="query">
                    SELECT * FROM GET_ROW ORDER BY QUESTION_NO
                </cfquery>
                <cfset no_count = not GET_ROW.recordcount ? 1 : no_count />
                <cfoutput query="get_row">
                    <cfscript>	 							
                        new_row = detail;
                        question_name = listgetat(new_row,2,'~');
                        if(listlen(new_row,';') gte 3)
                            alterNativeProduct = listgetat(new_row,3,'~');
                        else
                            alterNativeProduct = '';
                        if(listlen(new_row,'~') gte 4)
                            specAlternativeProductImage = listgetat(new_row,4,'~');
                        else
                            specAlternativeProductImage = '';
                        writeoutput('
                        <tr> 
                            <td valign="top">#currentrow#</td>
                            <td valign="top">#question_name#</td>
                            <td valign="top">#alterNativeProduct#</td>
                        </tr>');
                    </cfscript>
                </cfoutput>
            <cfelse>
                <tr><td colspan="3"><cf_get_lang dictionary_id="34603.Ürüne Ait Bir Spec Kaydedilmemiş!"></td></tr>
            </cfif>
        </tbody>
    </cf_grid_list>
</cfif>

<table style="display:none;"><!--- Dövizler hiç gösterilmesin sadece arka tarafta hesaplanması yapılacak.. --->
    <tr>
        <td colspan="3" >&nbsp;&nbsp;<cf_get_lang dictionary_id ='33851.Dövizler'></td>
    </tr>
    <input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
    <cfoutput query="get_money">
        <tr>
            <input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
            <input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
            <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
            <td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money2>checked</cfif>>#money#</td>
            <td>#TLFormat(rate1,4)#/</td>
            <td><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));"></td>
        </tr>
    </cfoutput>
</table>

<cfoutput>
    <input type="hidden" name="toplam_miktar" id="toplam_miktar" value="<cfif len(get_price.price_kdv)>#get_price.price*evaluate('attributes.#get_price.money#')#<cfelse>0</cfif>">
    <input type="hidden" name="other_toplam" id="other_toplam" value="<cfif len(get_price.price_kdv)>#get_price.price#<cfelse>0</cfif>">
    <input type="hidden" name="other_money" id="other_money" value="<cfif len(get_price.other_money)>#get_price.other_money#<cfelse>#session_base.money#</cfif>">
    <input type="hidden" name="is_add_same_name_spect" id="is_add_same_name_spect" value="#is_add_same_name_spect#">
</cfoutput>