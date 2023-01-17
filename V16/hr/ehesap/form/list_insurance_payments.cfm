<cfinclude template="../query/get_insurance_payments.cfm">
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
            <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='53047.Taban'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='53048.Tavan'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id="53129.Kıdem Tazminatı Tavanı"></th>
            <th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.personal_payment&event=addPayments','add_payment_box','ui-draggable-box-medium');" title="<cf_get_lang dictionary_id='53055.Sigorta Primine Esas Ücret Ekle'>"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_insurance_payments">
            <tr>
                <td>#dateformat(startdate,dateformat_style)# </td>
                <td> #dateformat(finishdate,dateformat_style)#</td>
                <td style="text-align:right;">#TLFormat(min_payment)#</td>
                <td style="text-align:right;">#TLFormat(max_payment)#</td>
                <td style="text-align:right;">#TLFormat(seniority_compansation_max)#</td>
                <td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.personal_payment&event=updPayments&ins_pay_id=#ins_pay_id#','upd_payment_box','ui-draggable-box-medium');" title="<cf_get_lang dictionary_id='58718.Düzenle'>" ><i class="fa fa-pencil"></i></a></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>