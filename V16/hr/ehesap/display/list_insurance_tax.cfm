<cfinclude template="../query/get_tax_slices.cfm">
<cf_grid_list>
    <thead>
        <tr> 
        <th colspan="2"><cf_get_lang dictionary_id='53050.Vergi Dilimleri'></th>
        <th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.personal_payment&event=addTax','add_tax_box','ui-draggable-box-medium');" title="<cf_get_lang dictionary_id='53058.Vergi Dilimi Ekle'>"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_tax_slices">
            <tr class="total"> 
                <td class="formbold" width="500">#name#-#status#</td>
                <td class="formbold"><cf_get_lang dictionary_id="54168.Sakatlık İndirimi"></td>
                <td align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.personal_payment&event=updTax&tax_sl_id=#tax_sl_id#','add_tax_box','ui-draggable-box-medium');"title="<cf_get_lang dictionary_id='58718.Düzenle'>" ><i class="fa fa-pencil"></i></a></td>
            </tr>
            <tr class="nohover"> 
                <td> 
                    <cf_flat_list>
                        <thead>
                            <tr> 
                                <th style="text-align:center" width="50"><cf_get_lang dictionary_id='53051.Dilim'></th>
                                <th style="text-align:right" width="100"><cf_get_lang dictionary_id='53052.Alt Sınır'></th>
                                <th style="text-align:right" width="100"><cf_get_lang dictionary_id='53053.Üst Sınır'></th>
                                <th style="text-align:right" width="50"><cf_get_lang dictionary_id='58456.Oran'></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="text-align:center">1</td>
                                <td style="text-align:right">#TLFormat(min_payment_1)#</td>
                                <td style="text-align:right">#TLFormat(max_payment_1)#</td>
                                <td style="text-align:right">#ratio_1#</td>
                            </tr>
                            <tr> 
                                <td style="text-align:center">2</td>
                                <td style="text-align:right">#TLFormat(min_payment_2)#</td>
                                <td style="text-align:right">#TLFormat(max_payment_2)#</td>
                                <td  style="text-align:right">#ratio_2#</td>
                            </tr>
                            <tr> 
                                <td style="text-align:center">3</td>
                                <td style="text-align:right">#TLFormat(min_payment_3)#</td>
                                <td style="text-align:right">#TLFormat(max_payment_3)#</td>
                                <td style="text-align:right">#ratio_3#</td>
                            </tr>
                            <tr> 
                                <td style="text-align:center">4</td>
                                <td style="text-align:right">#TLFormat(min_payment_4)#</td>
                                <td style="text-align:right">#TLFormat(max_payment_4)#</td>
                                <td style="text-align:right">#ratio_4#</td>
                            </tr>
                            <tr> 
                                <td style="text-align:center">5</td>
                                <td style="text-align:right">#TLFormat(min_payment_5)#</td>
                                <td style="text-align:right">#TLFormat(max_payment_5)#</td>
                                <td style="text-align:right">#ratio_5#</td>
                            </tr>	
                            <tr> 
                                <td style="text-align:center">6</td>
                                <td style="text-align:right">#TLFormat(min_payment_6)#</td>
                                <td style="text-align:right">#TLFormat(max_payment_6)#</td>
                                <td style="text-align:right">#ratio_6#</td>
                            </tr>
                        </tbody>
                    </cf_flat_list>
                </td>
                <td valign="top">
                    <cf_flat_list>
                        <thead>
                            <tr> 
                                <th style="text-align:center"><cf_get_lang dictionary_id="54179.Derece"></th>
                                <th style="text-align:right"><cf_get_lang dictionary_id="35553.Tutar"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="text-align:center">1</td>
                                <td style="text-align:right">#TLFormat(sakat1)#</td>
                            </tr>
                            <tr>
                                <td style="text-align:center">2</td>
                                <td style="text-align:right">#TLFormat(sakat2)#</td>
                            </tr>
                            <tr>
                                <td style="text-align:center">3</td>
                                <td style="text-align:right">#TLFormat(sakat3)#</td>
                            </tr>
                        </tbody>
                    </cf_flat_list>
                </td>
                <td>&nbsp;</td>
            </tr>
        </cfoutput> 
    </tbody>
</cf_grid_list>