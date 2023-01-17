<!---
    File: V16\hr\ehesap\display\deductible_contribution_rate.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-09-07
    Description: Kesenek katkı oranları ekleme widget
        
    History:
        
    To Do:

--->
<cfsavecontent variable="message"><cf_get_lang dictionary_id='63742.Kesenek Katkı Oranı Ekle'></cfsavecontent>
<cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="form_add_ratio" method="post">
		<cf_box_elements>
			<div class="row" type="row">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" sort="true" index="1">
					<div class="form-group" id="item-name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57480.Başlık'>*</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="title" id="title">
						</div>
					</div>
					<div class="form-group" id="item-date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="startdate" id="startdate" validate="#validate_style#">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="finishdate" validate="#validate_style#" d="finishdate">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
					</div>
                    <div class="col col-12 col-xs-12" type="column" sort="true" index="2">
                        <cf_grid_list sort="0">
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='63743.Ek Göstergesi'></th>
                                    <th><cf_get_lang dictionary_id='53052.Alt Sınır'></th>
                                    <th><cf_get_lang dictionary_id='53053.Üst Sınır'></th>
                                    <th><cf_get_lang dictionary_id='58456.Oran'>%</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop index="i" from="1" to="7">
                                    <cfoutput>
                                        <tr>
                                            <td style="width:25px; text-align: center;">#i#</td>
                                            <td><input type="text" name="min_payment_#i#" id="min_payment_#i#" style="width:100%;" value="" onkeyup="return(formatcurrency(this,event));" class="moneybox"></td> 
                                            <td><input type="text" name="max_payment_#i#" id="max_payment_#i#" style="width:100%;" value="" onkeyup="return(formatcurrency(this,event));" class="moneybox"></td>
                                            <td><input type="text" name="ratio_#i#" id="ratio_#i#" style="width:100%;" value="" onkeyup="return(formatcurrency(this,event));"></td>
                                        </tr>
                                    </cfoutput>
                                </cfloop>
                            </tbody>
                        </cf_grid_list>
                    </div>
				</div>
			</div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd = '0' add_function = 'control()' data_action = "V16/hr/ehesap/cfc/deductible_contribution_rate:ADD_DEDUCTIBLE_CONTRIBUTION_RATE" next_page="#request.self#?fuseaction=ehesap.personal_payment">
        </cf_box_footer>
    </cfform>
</cf_box>
<script>
    function control()
    {
        if($("#title").val() == '')
        {
            alert("<cf_get_lang dictionary_id ='57480.Başlık'>");
            return false;
        }
        if($("#startdate").val() == '' || $("#finishdate").val() == '')
        {
            alert("<cf_get_lang dictionary_id='57655.Başlama Tarihi'>/<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>");
            return false;
        }
        
        var data = new FormData();
        data.append('startdate',$("#startdate").val());
        data.append('finishdate',$("#finishdate").val());
        $.ajax({
            url: 'V16/hr/ehesap/cfc/deductible_contribution_rate.cfc?method=GET_DEDUCTIBLE_CONTRIBUTION_RATE_REMOTE',
            dataType: "json",
            method: "post",
            data: data,
            processData: false,
            contentType: false,
            async:false,
            success: function( response )
            {
                if(response > 0)
                {
                    alert("<cf_get_lang dictionary_id='62929.Girilen Tarihler Arasında Memur Gösterge Tablosu Bulunmaktadır!'>");
                    return false;
                }
                else
                {
                    for(i=1; i<=7 ; i++)
                    {
                        if($("#min_payment_"+i).val() != '')
                            $("#min_payment_"+i).val(filterNum($("#min_payment_"+i).val()));
                        else
                            $("#min_payment_"+i).val(0);
                        if($("#max_payment_"+i).val() != '')
                            $("#max_payment_"+i).val(filterNum($("#max_payment_"+i).val()));
                        else
                            $("#max_payment_"+i).val(0);
                        if($("#ratio_"+i).val() != '')
                            $("#ratio_"+i).val(filterNum($("#ratio_"+i).val()));
                        else
                            $("#ratio_"+i).val(0);
                    }
                }
            }
        });
    }
</script>