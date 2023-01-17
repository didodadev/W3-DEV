<cfsavecontent variable="title"><cf_get_lang dictionary_id='61532.7256 Kanun Dağılımı'></cfsavecontent>
<cfquery name="GET_PLUS_VAL" datasource="#dsn#">
    SELECT 
        SUM(BASE_AMOUNT_7256) AS BASE_AMOUNT_7256,
        SUM(SSK_ISVEREN_HISSESI_7256+SSK_ISCI_HISSESI_7256+ISSIZLIK_ISCI_HISSESI_7256+ISSIZLIK_ISVEREN_HISSESI_7256) AS TOTAL_LAW,
        SUM(BASE_AMOUNT_7256-(SSK_ISVEREN_HISSESI_7256+SSK_ISCI_HISSESI_7256+ISSIZLIK_ISCI_HISSESI_7256+ISSIZLIK_ISVEREN_HISSESI_7256)) AS DIFF_LAW
    FROM
        EMPLOYEES_PUANTAJ_ROWS
    WHERE
        PUANTAJ_ID = <cfqueryparam value = "#attributes.payroll_id#" CFSQLType = "cf_sql_integer">
        AND ISNULL(BASE_AMOUNT_7256,0) > 0
        AND IS_7256_PLUS = 0
</cfquery>
<cfquery name="GET_PLUS_LIST" datasource="#dsn#">
    SELECT 
        IN_OUT_ID,
        EMPLOYEE_ID,
        BASE_AMOUNT_7256,
        (SSK_ISVEREN_HISSESI_7256+SSK_ISCI_HISSESI_7256+ISSIZLIK_ISCI_HISSESI_7256+ISSIZLIK_ISVEREN_HISSESI_7256) AS TOTAL_LAW,
        (SSK_ISVEREN_HISSESI+SSK_ISCI_HISSESI+ISSIZLIK_ISCI_HISSESI+ISSIZLIK_ISVEREN_HISSESI) AS AVAILABLE
    FROM
        EMPLOYEES_PUANTAJ_ROWS
    WHERE
        PUANTAJ_ID = <cfqueryparam value = "#attributes.payroll_id#" CFSQLType = "cf_sql_integer">
        AND ISNULL(BASE_AMOUNT_7256,0) > 0
        AND IS_7256_PLUS = 1
</cfquery>
<cfquery name="GET_JSON_LIST" datasource="#dsn#">
    SELECT 
        JSON_7256_LIST
    FROM
        EMPLOYEES_PUANTAJ
    WHERE
        PUANTAJ_ID = <cfqueryparam value = "#attributes.payroll_id#" CFSQLType = "cf_sql_integer">
</cfquery>
<cf_box title="#title#" closable="1" draggable="1" popup_box="1" id="add_work_box">
    <cfif isdefined("GET_JSON_LIST.JSON_7256_LIST") and len(GET_JSON_LIST.JSON_7256_LIST)>
        <cfset get_7256_json.in_out=deserializeJSON(GET_JSON_LIST.JSON_7256_LIST)> 
    </cfif>
    <input type="hidden" name="payroll_id" id="payroll_id" value="<cfoutput>#attributes.payroll_id#</cfoutput>">
    <cf_grid_list sort="0">
        <tbody>
            <td>Şube Toplam Ek Yararlanabileceği Tutar</td>
            <td>
                <cfoutput>
                    <input type="text" name="total_val" id="total_val" value="#GET_PLUS_VAL.DIFF_LAW#" disabled>
                    <input type="hidden" name="total_val_hid" id="total_val_hid" value="#GET_PLUS_VAL.DIFF_LAW#" disabled>
                </cfoutput>
            </td>
        </tbody>
    </cf_grid_list>
    <cfform name="list_output_templates" id="list_output_templates" action="" method="post">
        <cf_grid_list sort="0">
            <thead>
                <tr>
                    <th>Adı Soyadı</th>
                    <th>Ekenecek Tutar</th>
                    <th>Maximum Eklenebilecek</th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="GET_PLUS_LIST">
                    <tr>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="hidden" name="in_out_id" id="in_out_id#currentrow#" value="#in_out_id#">
                                    <label>#get_emp_info(employee_id,0,0)#</label>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <cfif isdefined('GET_JSON_LIST.JSON_7256_LIST') and len(GET_JSON_LIST.JSON_7256_LIST)>
                                        <input type="text" name="add_low_val" id="add_low_val" value="#evaluate('get_7256_json.in_out.#in_out_id#')#"  <!--- onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(1); return false;}" ---> onblur="calc_val(this);"> 
                                    <cfelse>
                                        <input type="text" name="add_low_val" id="add_low_val" value="0" <!--- onkeyup="if (FormatCurrency(this,event)) {return true;} else {upd(1); return false;}" ---> onblur="calc_val(this);"> 
                                    </cfif>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <label id="emp_use_#employee_id#">#tlFormat(AVAILABLE-TOTAL_LAW)#</label>
                                </div>
                            </div>
                        </td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
        <div class="col col-12 form-group">
            <div class="col col-12 col-md-12 col-xs-12 mt-5" style="font-size : 15px">
                <input type="submit" value="<cf_get_lang dictionary_id='57461. Kaydet'>">
            </div>
        </div>
    </cfform>
</cf_box>
<script>
    (function() {
        
        function toJSONString( form ) {
            var obj = {};
            var elements = form.querySelectorAll( "input" );
            for( var i = 0; i < elements.length-1;i=i+2 ) {
               var element = elements[i];
                var name = element.name;
                var value = element.value;
                value = value.replace(/"/g,'');
                value = value.replace(/'/g,'');
                value = value.replace(/</g,'');
                value = value.replace(/>/g,'');
                value = value.replace(/`/g,'');
                value = value.replace(/ /g,'');
                var element2 = elements[i+1];
                var name2 = element2.name;
                var value2 = element2.value;
                value2 = value2.replace(/"/g,'');
                value2 = value2.replace(/'/g,'');
                value2 = value2.replace(/</g,'');
                value2 = value2.replace(/>/g,'');
                value2 = value2.replace(/`/g,'');
                if( value ) {
                    obj[value] = value2;
                }  
            }
            return JSON.stringify( obj );
        }
        
        document.addEventListener( "DOMContentLoaded", function() {
            var form = document.getElementById( "list_output_templates" );
            payroll_id = "<cfoutput>#attributes.payroll_id#</cfoutput>";
            form.addEventListener( "submit", function( e ) {
                e.preventDefault();
                json = toJSONString( this );
                console.log(json);
                
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/ehesap/cfc/create_puantaj.cfc?method=UPD_PAYROLL',  
                    data: { 
                    json : json,
                    payroll_id : payroll_id
                    },
                    success: function (msg) { 
                        alert("Başarı ile kaydedildi. Lütfen şube puantajını yeniden oluşturunuz!");
                        window.location.reload();
                    },
                    error: function (msg)
                    {
                        console.log(msg);
                        return false;
                    }
                }); 
            }, false);
        });
        $("input#add_low_val").blur();
    })();
    function calc_val(value_row)
    {
        total_val = $('#total_val_hid').val();
        law_history = $(value_row).attr("value");
        total_low_cal = 0;
        $( "input#add_low_val" ).each(function( index ) {

            total_low_cal=total_low_cal+parseFloat($( this ).val());
        });

        total_val = total_val - total_low_cal;
    
        if(total_val < 0) 
        {
            alert("Girdiğiniz tutar toplam girilebilecek tutarı aşmaktadır!");
            $(value_row).val(law_history);
            console.log(law_history);
            return false;
        }else
        {
            $('#total_val').val(commaSplit(total_val,2));
        }
    }

</script>