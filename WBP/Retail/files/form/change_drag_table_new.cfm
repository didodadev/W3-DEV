<cfquery name="get_headers_all" datasource="#dsn_dev#">
    SELECT  
        *,
        (ROW_ID - 1)  AS KOLON_SIRA,
        1 AS KOLON_SHOW
    FROM 
        SEARCH_TABLES_COLOUMS 
    ORDER BY 
        KOLON_SIRA ASC
</cfquery>

<cfquery name="get_layout_info" datasource="#dsn_dev#">
    SELECT * FROM SEARCH_TABLES_LAYOUTS_NEW WHERE LAYOUT_ID = #attributes.layout_id#
</cfquery>
<cfif get_layout_info.recordcount and len(get_layout_info.sort_list)>
    <cfset sort_list = get_layout_info.sort_list>
    
    <cfoutput query="get_headers_all">
        <cfset sira_ = row_id>

        <cfif sira_ lte listlen(sort_list)>
            <cfset ozellik_ = listgetat(sort_list,sira_)>
            
            <cfset row_sira_ = listgetat(ozellik_,2,'*')>
            <cfset row_show_ = listgetat(ozellik_,3,'*')>
            <cfset querysetcell(get_headers_all,'KOLON_SIRA',row_sira_,currentrow)>
            
            <cfif row_show_ is 'hide'>
                <cfset querysetcell(get_headers_all,'KOLON_SHOW','0',currentrow)>
            <cfelse>
                <cfset querysetcell(get_headers_all,'KOLON_SHOW','1',currentrow)>
            </cfif>
        </cfif>
    </cfoutput>
</cfif>

<cfquery name="get_headers" dbtype="query">
    SELECT * FROM get_headers_all ORDER BY KOLON_SIRA ASC
</cfquery>
<cfquery name="get_headers_show" dbtype="query">
	SELECT * FROM get_headers_all WHERE KOLON_SHOW = 1 ORDER BY KOLON_SIRA ASC
</cfquery>
<script>
   gridColumns1 = [
        { text: 'Alt Eleman Sayısı', dataField: 'sub_rows_count', minWidth: 50, width: 50,hidden: true},
        { text: 'Fiyat Sayısı', dataField: 'product_price_change_count', minWidth: 50, width: 50,hidden: true},
        { text: 'Fiyat Değişimleri', dataField: 'product_price_change_detail', minWidth: 50, width: 50,hidden: true},
        { text: 'Eski Fiyat Satırı', dataField: 'product_price_change_lastrowid', minWidth: 50, width: 50,hidden:true},
        { text: 'Ürün Rengi', dataField: 'product_color', minWidth: 50, width: 50,hidden:true},
        { text: 'Özel Fiyatlı', dataField: 'price_control', minWidth: 50, width: 50,hidden:true},
        { text: 'Eski Fiyat', dataField: 'c_first_satis_price', minWidth: 50, width: 50,hidden:true},
        { text: 'Eski Fiyat Alış', dataField: 'c_new_alis_kdvli', minWidth: 50, width: 50,hidden:true},
        { text: 'Sipariş Kodu', dataField: 'order_code', minWidth: 50, width: 50,hidden:true},
        <cfoutput query="get_headers">
        { text: '<table class="jqx-grid-column-header-table" cellpadding="0" cellspacing="0" width="100%"><tr><td height="22" class="jqx-grid-column-header-search-td"><div id="div_#kolon_ad#" style="width:100%; height:20px;" class="jqx-grid-column-header-search-div"></div></td></tr><tr><td>#kolon_ozelad#</td></tr></table>',							
            <cfif kolon_ad is 'price_type'>
                    datafield: 'price_type_id', 
                    displayfield: 'price_type',
            <cfelse>
                datafield: '#kolon_ad#',	
            </cfif>
            <cfif len(KOLON_AGG)>
                aggregates:['#KOLON_AGG#'],
            </cfif>
            <cfif listfind('siparis_onay,siparis_miktar,siparis_miktar_k,siparis_miktar_p,siparis_tutar_1,siparis_tutar_kdv_1',kolon_ad)>
                aggregates: [
                {'' : function (aggregatedValue,currentValue,element,summaryData) 
                    {
                        var last_row = $('##jqxgrid').jqxGrid('getrowdatabyid',summaryData.uid);
                        deger_ = last_row.#kolon_ad#;
                        if(summaryData.siparis_onay)
                        {
                            <cfif kolon_ad is 'siparis_onay'>
                                aggregatedValue = aggregatedValue + 1;
                            <cfelse>
                                aggregatedValue = aggregatedValue + deger_;
                            </cfif>
                        }
                        return aggregatedValue;
                    }
                  }],
            </cfif>
            <cfif listfind('siparis_onay_2,siparis_miktar_2,siparis_miktar_k_2,siparis_miktar_p_2,siparis_tutar_2,siparis_tutar_kdv_2',kolon_ad)>
                aggregates: [
                {'' : function (aggregatedValue,value,element,summaryData) 
                    {
                        deger_ = summaryData.#kolon_ad#;
                        if(summaryData.siparis_onay_2)
                        {
                            <cfif kolon_ad is 'siparis_onay_2'>
                                aggregatedValue = aggregatedValue + 1;
                            <cfelse>
                                aggregatedValue = aggregatedValue + deger_;
                            </cfif>
                        }
                        return aggregatedValue;
                    }
                  }],
            </cfif>
            filterable:<cfif kolon_filtre eq 1>true<cfelse>false</cfif>,
			<cfif len(kolon_render)>cellsrenderer:#kolon_render#,</cfif>
            editable:<cfif KOLON_DUZENLEME eq 1>true<cfelse>false</cfif>,
            width:<cfif len(kolon_en)>#kolon_en#<cfelse>50</cfif>,
            minwidth:<cfif len(kolon_en)>#kolon_en#<cfelse>50</cfif>,
            cellclassname:cellclass,
            <cfif len(kolon_tip)>
                columntype:'#kolon_tip#',
                <cfif kolon_tip is 'datetimeinput'>
                    createfilterwidget: createfilterwidget,
                </cfif>
                <cfif kolon_tip is 'numberinput'>
                    createeditor: function (row, cellvalue, editor)
                    {
                        editor.jqxNumberInput(
                        {
                            decimalDigits:3,
                            promptChar:" ",
                            spinButtonsStep:0,
                            spinButtons:false,
                            spinMode: 'simple'
                        });
                    },
                </cfif>
            </cfif>
            <cfif len(kolon_begin_edit)>cellbeginedit:#kolon_begin_edit#,</cfif>
            <cfif len(kolon_end_edit)>cellendedit:#kolon_end_edit#,</cfif>
            <cfif kolon_filtre eq 1 and len(kolon_filtre_tipi)>filtertype:'#kolon_filtre_tipi#',</cfif>
            <cfif len(kolon_format)>cellsformat:'#kolon_format#',</cfif>
            align: '#kolon_align#', 
            cellsalign: '#kolon_align#',
            <cfif kolon_ad is 'price_type'>
                createeditor: function(row, value, editor) {
                    editor.jqxDropDownList({ source: p_types_Adapter, displayMember: 'label', valueMember: 'value' });
                      },
            </cfif>							
            <cfif KOLON_SHOW eq 0>hidden: true,</cfif>
            pinned:<cfif kolon_sabit eq 1>true<cfelse>false</cfif>
        },
    </cfoutput>
    { text: 'rt', dataField: 'row_type',columngroup:'product_name_header2',editable:false,filterable:false,width:10,hidden: true},
    { text: 'rt', dataField: 'ReportsTo',editable:false,filterable:false,width:10,hidden: true},
    { text: 'Tedarikçi K.', dataField: 'company_code', minWidth: 50, width: 50,hidden: true},
    { text: 'S.Alış Info', dataField: 'info_standart_alis', minWidth: 50, width: 50,hidden: true},
    { text: 'S.Satış Info', dataField: 'c_standart_satis', minWidth: 50, width: 50,hidden: true},
    { text: 'S.Satış Info KDV', dataField: 'c_standart_satis_kdv', minWidth: 50, width: 50,hidden: true},
    { text: 'SSK', dataField: 's_profit', minWidth: 50, width: 50,hidden: true}
    ];

	document.getElementById('layout_sort_list').value = '<cfoutput>#valuelist(get_headers_show.kolon_ad)#</cfoutput>';

	document.getElementById('run_count').value = '2';
	$('#jqxgrid').jqxGrid({columns: gridColumns1 });
	header_duzenle();
	
	$("#jqxgrid").jqxGrid('applyfilters');
	$('#jqxgrid').jqxGrid('refresh');

	var rows = $('#jqxgrid').jqxGrid('getboundrows');
	var eleman_sayisi = rows.length;
	hide('message_div_main');
</script>