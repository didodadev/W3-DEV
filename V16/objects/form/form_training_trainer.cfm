<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT 
		MONEY_ID,MONEY,RATE1,RATE2
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID#
</cfquery>

<cfquery name="GET_TRAINING_SEC_NAMES" datasource="#dsn#">
	SELECT
		TRAINING_CAT.TRAINING_CAT_ID,
		TRAINING_SEC.TRAINING_SEC_ID,
		TRAINING_SEC.SECTION_NAME,
		TRAINING_CAT.TRAINING_CAT
	FROM
		TRAINING_SEC,
		TRAINING_CAT
	WHERE
		TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
	<cfif isdefined("attributes.sec_id")>
		AND TRAINING_SEC.TRAINING_SEC_ID = #attributes.SEC_ID#
	</cfif>
	ORDER BY
		TRAINING_CAT.TRAINING_CAT,
		TRAINING_SEC.SECTION_NAME
</cfquery>
<cfquery name="get_training_cat" datasource="#dsn#">
	SELECT * FROM TRAINING_CAT
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33914.Çalışanın Verdiği Eğitimler'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="0" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="traning_trainer" method="post" action="#request.self#?fuseaction=objects.emptypopup_training_trainer" onsubmit="return unformat_fields();">
    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
    <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
    <cfif (isdefined("attributes.employee_id") and len(attributes.employee_id)) or (isdefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.consumer_id") and len(attributes.consumer_id))>
    <cfquery name="get_training_trainer" datasource="#DSN#">
        SELECT
            *
        FROM
            TRAINING_TRAINER
        WHERE
            <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                EMPLOYEE_ID = #attributes.employee_id#
            <cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
                PARTNER_ID = #attributes.partner_id#
            <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                CONSUMER_ID = #attributes.consumer_id#
            <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
                PARTNER_COMPANY_ID = #attributes.company_id#
            </cfif>
        ORDER BY TRAINING_TRAINER_ID ASC
        </cfquery>
    </cfif>
    <cfif isdefined("get_training_trainer") and get_training_trainer.recordcount>
        <cf_grid_list>
            <thead>
                <tr>
                    <input type="hidden" name="rowCount" id="rowCount" value="<cfoutput>#get_training_trainer.recordcount#</cfoutput>">
                    <th><a href="javascript://" onClick="addRow()"><i class="fa fa-plus"></i></a></th>
                    <th width="170"><cf_get_lang dictionary_id ='57486.Kategori'></th>
                    <th width="170"><cf_get_lang dictionary_id ='57995.Bölüm'></th>
                    <th width="75"><cf_get_lang dictionary_id ='58258.Maliyet'></th>
                    <th width="75"><cf_get_lang dictionary_id ='57489.Para Birim'></th>
                    <th width="190"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
                </tr>
            </thead>
            <tbody id="table_list">
            <cfoutput query="get_training_trainer">
                <cfquery name="get_training_sec" datasource="#dsn#">
                    SELECT * FROM TRAINING_SEC<cfif len(training_cat_id)> WHERE TRAINING_CAT_ID = #training_cat_id#</cfif>
                </cfquery>
                <input type="hidden" name="training_trainer_id#currentrow#" id="training_trainer_id#currentrow#" value="#training_trainer_id#">
                <tr id="frm_row#currentrow#">
                    <td><input  type="hidden" value="1" name="rowkontrol#currentrow#" id="rowkontrol#currentrow#"><a href="javascript://" onClick="sil('#currentrow#');"><i class="fa fa-minus"></i></a></td>
                    <td width="170">
                        <select name="training_cat_id#currentrow#" id="training_cat_id#currentrow#" size="1" onChange="get_tran_sec(this.value,#get_training_trainer.currentrow#)" style="width:170px">
                            <option value="0"><cf_get_lang dictionary_id='57486.kateogri'> !</option>
                            <cfloop query="get_training_cat">
                                <option value="#get_training_cat.training_cat_id#"<cfif evaluate('get_training_trainer.training_cat_id[#get_training_trainer.currentrow#]') eq get_training_cat.training_cat_id>selected</cfif>>#get_training_cat.training_cat#</option>
                            </cfloop>
                        </select>
                    </td>
                <td>
                    <select name="training_sec_id#currentrow#" id="training_sec_id#currentrow#" size="1" style="width:170px">
                        <option value="0"><cf_get_lang dictionary_id ='57995.Bölüm'>!</option>
                        <cfloop query="get_training_sec">
                            <option value="#get_training_sec.training_sec_id#" <cfif evaluate('get_training_trainer.training_sec_id[#get_training_trainer.currentrow#]') eq get_training_sec.training_sec_id>selected</cfif>>#get_training_sec.section_name#</option>
                        </cfloop>
                    </select>	
                </td>
                <td width="75">
                    <input type="text" name="training_cost#currentrow#" id="training_cost#currentrow#" style="width:75px;" class="moneybox" value="#training_cost#">
                </td>
                <td width="75">
                    <cfset money_selected=get_training_trainer.training_cost_money>
                    <select name="training_cost_money#currentrow#" id="training_cost_money#currentrow#" style="width:75px;">
                        <cfloop query="get_moneys">
                            <option value="#get_moneys.MONEY#" <cfif get_moneys.money eq money_selected >selected</cfif>>#get_moneys.money#</option>
                        </cfloop>
                    </select>
                </td>
                <td width="190">
                    <input type="text" name="training_detail#currentrow#" id="training_detail#currentrow#" style="width:190px;" value="#training_detail#">
                </td>
                </tr>
            </cfoutput>
            </tbody>
        </cf_grid_list>
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='1' is_delete='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('traning_trainer' , #attributes.modal_id#)"),DE(""))#'>
        </cf_popup_box_footer>
    <cfelse>
        <cf_grid_list>
            <thead>
                <tr>
                    <input type="hidden" name="rowCount" id="rowCount" value="0">
                    <th><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="addRow();"></th>
                    <th width="170"><cf_get_lang dictionary_id ='57486.Kategori'></th>
                    <th width="170"><cf_get_lang dictionary_id ='57995.Bölüm'></th>
                    <th width="75"><cf_get_lang dictionary_id ='58258.Maliyet'></th>
                    <th width="75"><cf_get_lang dictionary_id ='57489.Para Birim'></th>
                    <th width="190"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
                </tr>
            </thead>
            <tbody id="table_list"></tbody>
        </cf_grid_list>
        <cf_popup_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('traning_trainer' , #attributes.modal_id#)"),DE(""))#'>    
        </cf_popup_box_footer>
    </cfif>
    </cfform>
</cf_box>
<script type="text/javascript">
function get_tran_sec(cat_id,rowno)
{
	eval('document.traning_trainer.training_sec_id'+rowno).options.length = 0;
	var get_sec = wrk_safe_query('obj_get_sec','dsn',0,cat_id);
	eval('document.traning_trainer.training_sec_id'+rowno).options[0]=new Option('Bölüm !','0')
	for(var jj=0;jj<get_sec.recordcount;jj++)
	{
		eval('document.traning_trainer.training_sec_id'+rowno).options[jj+1]=new Option(get_sec.SECTION_NAME[jj],get_sec.TRAINING_SEC_ID[jj])
	}
}

rowCount=0;
satirsay=0;
<cfif isdefined('get_training_trainer') and (get_training_trainer.recordcount)>
	rowCount=<cfoutput>#get_training_trainer.recordcount#</cfoutput>;
	satirsay=0;
<cfelse>
	rowCount=0;
	satirsay=0;
</cfif>

function sil(sv)
{
	var my_element=eval("traning_trainer.rowkontrol"+sv);
	my_element.value=0;
	var my_element=eval("frm_row"+sv);
	my_element.style.display="none";
	satirsay--;
}

function addRow()
{
	rowCount++;
	satirsay++;
	traning_trainer.rowCount.value = rowCount;
	var newRow;
	var newCell;
	newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
	newRow.setAttribute("name","frm_row" + rowCount);
	newRow.setAttribute("id","frm_row" + rowCount);		
	newRow.setAttribute("NAME","frm_row" + rowCount);
	newRow.setAttribute("ID","frm_row" + rowCount);
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input  type="hidden" value="1" name="rowkontrol' + rowCount +'" ><a href="javascript://" onclick="sil(' + rowCount + ');"><i class="fa fa-minus"></i></a>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="training_cat_id' + rowCount + '" style="width:170px;" onChange="get_tran_sec(this.value,'+ rowCount +')"><option value="0"><cf_get_lang dictionary_id ='57734.Seçiniz'></option><cfoutput query="get_training_cat"><option value="#training_cat_id#">#training_cat#</option></cfoutput></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="training_sec_id' + rowCount + '" style="width:170px;" size="1"><option value="0"><cf_get_lang dictionary_id ='57995.bölüm'></option></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="training_cost' + rowCount + '" value="" style="width:75px;">';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<select name="training_cost_money' + rowCount + '" style="width:75px;"><cfoutput query="get_moneys"><option value="#MONEY#">#money#</option></cfoutput></select>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="text" name="training_detail' + rowCount + '" value="" style="width:190px;">';
}

function unformat_fields()
{
	for(var i=1; i<=rowCount; i++)
	{
		if (eval('traning_trainer.rowkontrol'+i).value != 0)
		{
			if(eval("traning_trainer.training_cost"+i ).value!= "")
				eval("traning_trainer.training_cost"+i ).value=filterNum(eval("traning_trainer.training_cost"+i ).value);
		}
	}
}

</script>
