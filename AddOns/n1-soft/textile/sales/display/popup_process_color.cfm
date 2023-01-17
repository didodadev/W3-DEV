    
    <cfquery name="products_services" datasource="#DSN#">
        SELECT * FROM SAMPLE_REQ_PROCESS_COLOR
    </cfquery>
    
    <cfif isdefined("attributes.is_submited") and len(attributes.is_submited)>
		 
        <cfif isdefined("attributes.processRow") and len(attributes.processRow)>
        <cfset attributes.processRow = listLast(attributes.processRow)>
        <cfscript>
            
            processColor = CreateObject("component","AddOns.N1-Soft.textile.cfc.processColor");

            for(kk=1;kk lte attributes.processRow;kk=kk+1)
                {
                    if(isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 1)
                        {
                            processColor.upd_process_row(
                                color_id : '#iif(isdefined("attributes.color_id#kk#"),"attributes.color_id#kk#",DE(""))#',
                                processId : '#iif(isdefined("attributes.processId#kk#"),"attributes.processId#kk#",DE(""))#',
                                processName : '#iif(isdefined("attributes.processName#kk#"),"attributes.processName#kk#",DE(""))#',
                                color : '#iif(isdefined("attributes.color#kk#"),"attributes.color#kk#",DE(""))#'

                            );
                        }
                    else if(isdefined("attributes.satir#kk#") and evaluate("attributes.satir#kk#") eq 0)
                        {
                            processColor.del_process_row(
                                color_id : '#iif(isdefined("attributes.color_id#kk#"),"attributes.color_id#kk#",DE(""))#'
                            );
                        }
                }
        </cfscript>
    </cfif>
    <script type="text/javascript">
        window.location.href="/<cfoutput>#request.self#</cfoutput>?fuseaction=textile.popup_process_color";
    </script>	
</cfif>

<cfform name="form_add_tariff" method="post" action="">
    <input type="hidden" name="tariff_additional_product" id="tariff_additional_product" value="<cfoutput>#products_services.recordcount#</cfoutput>">
    <input type="hidden" name="is_submited" value="1">
    <div class="row">
        <div class="col col-12 col-xs-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <div id="products_services">
                            <table biglist class="big_list products_services">
                                <thead>
                                    <th style="text-align:center;width:25px;"><input type="button" class="eklebuton" title="" onClick="addRow()" value=""></th>
                                    <th style="width:250px;">Process ID</th>
                                    <th>Process Name</th>
                                    <th>Color</th>
                                </thead>
                                <tbody id="products_services">
                                    <cfoutput query="products_services">
                                        <tr id="#currentrow#">
                                            <input type="hidden" name="color_id#currentrow#" value="#COLOR_ID#">
                                            <input type='hidden' name='satir#currentrow#' id='satir#currentrow#' value='1'>
                                            <td style='text-align:center;width:25px;'><a style='cursor:pointer;' onclick='sil(#currentrow#);'><img src='images/delete_list.gif' border='0'></a><input name='processRow' value='#currentrow#' type='hidden'></td>
                                            <td><input type='text' style='width:75px;' name='processId#currentrow#' value="#PROCESS_ROW_ID#"></td>
                                            <td><input type='text' style='width:75px;' name='processName#currentrow#' value="#PROCESS_NAME#"></td>
                                            <td><input type='color' style='width:75px;' name='color#currentrow#' value="#COLOR#"></td>
                                        </tr>
                                    </cfoutput>
                                    
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>                    
            </div>
        </div>
    </div>
</cfform>
<script>

var jsonArray = [
    {
    "sil" : "<a style='cursor:pointer;' onclick='sil(###id###);'><img src='images/delete_list.gif' border='0'></a><input name='processRow' value='###id###' type='hidden'>",
    "processId" : "<input type='number' id='processId' name='processId###id###'>",
    "processName": "<input type='text' id='processName' name='processName###id###'>",
    "color": "<input type='color' name='color###id###'>",
    }
];

var row_count_service = parseInt($("input[name=tariff_additional_product]").val());
function addRow(){
        row_count_service +=1;
        jsonArray.filter((a) => {
            var template="<tr id='"+row_count_service+"'><input type='hidden' name='satir###id###' id='satir###id###' value='1'><td style='text-align:center;width:25px;'>{sil}</td><td>{processId}</td><td>{processName}</td><td>{color}</td></tr>";
            $('.products_services').append(nano( template, a ).replace(/###id###/g,row_count_service));
        });
    }

function sil(no)
{
    $("#products_services tr#"+no).hide();
    $("#satir"+no).val("0");
}

function kontrol(){
    if( $("#processId").val() == "" || $("#processName").val() == "")
    {
        alert("<cf_get_lang dictionary_id='29722.Zorunlu Alanları Doldurunuz'>"); return false;
    }
}
</script>