<cfquery name = "get_documents" datasource="#dsn#">
    SELECT
        *
    FROM
        #dsn_alias#.WASTE_OPERATION_DOCUMENTS WOD
    WHERE
        WOD.OUR_COMPANY_ID = #session.ep.company_id#
    ORDER BY
        WOD.CATEGORY,
        WOD.DOC_CODE
</cfquery>
<cfoutput query = "get_documents" group = "category">
    <cf_box id="recycleDocs" title="#category#">
        <cf_grid_list sort="0">
            <thead>
                <tr>
                    <th width="300">Evrak Adı</th>
                    <th width="300">Dosya</th>
                    <th width="300">Dosya Adı</th>
                    <th width="300">Geçerlilik Başlangıç Tarihi</th>
                    <th width="300">Geçerlilik Bitiş Tarihi</th>
                    <th width="300">Aktif (Aktif seçilmeyenin dosyası yüklenmez!)</th>
                </tr>
            </thead>
            <tbody>
                <cfif not isDefined('attributes.waste_operation_id')>
                    <cfset attributes.waste_operation_id = 0>
                </cfif>
                <cfoutput>
                    <cfquery name = "get_wo_document" datasource="#dsn#">
                        SELECT
                            A.ASSET_ID,
                            A.ASSET_NAME,
                            A.ASSETCAT_ID,
                            A.ASSET_FILE_NAME,
                            AC.ASSETCAT_PATH,
                            RWOR.REFINERY_WASTE_OIL_ROW_ID
                        FROM
                            #dsn#.REFINERY_WASTE_OPERATION_ROW RWOR
                                LEFT JOIN #dsn#.ASSET A ON A.ASSET_ID = RWOR.ASSET_ID
                                LEFT JOIN #dsn#.ASSET_CAT AC ON AC.ASSETCAT_ID = A.ASSETCAT_ID
                        WHERE
                            RWOR.REFINERY_WASTE_OIL_ID = #attributes.waste_operation_id#
                            AND RWOR.ASSET_CODE = '#doc_code#'
                    </cfquery>
                    <tr>
                        <input type="hidden" name="row_title_#currentrow#" id="row_title#currentrow#" value="#doc_name#">
                        <input type="hidden" name="row_id_#currentrow#" id="row_id_#currentrow#" value="#get_wo_document.REFINERY_WASTE_OIL_ROW_ID#">
                        <input type="hidden" name="row_code_#currentrow#" id="row_code_#currentrow#" value="#doc_code#">
                        <td>#doc_name#</td>
                        <td>
                            <div class="form-group">
                                <input type="file" name="row_file_#currentrow#" id="row_file_#currentrow#">
                            </div>
                        </td>
                        <td>
                            <cfif len(get_wo_document.ASSET_NAME)>
                                <span>
                                    #get_wo_document.ASSET_NAME#
                                    <a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#get_wo_document.ASSET_ID#&assetcat_id=#get_wo_document.ASSETCAT_ID#" target="_blank"><i class="fa fa-external-link"></i></a>
                                    <cfset ext=lcase(listlast(get_wo_document.ASSET_FILE_NAME, '.')) />
                                    <cfset path_ = "#get_wo_document.ASSETCAT_PATH#">
                                    <cfset url_ = "#file_web_path#/#path_#/">
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##get_wo_document.ASSET_FILE_NAME#&file_control=asset.form_upd_asset&asset_id=#get_wo_document.ASSET_ID#&assetcat_id=#get_wo_document.ASSETCAT_ID#','medium');return false;"><i class="catalyst-cloud-download"  title="#getLang('asset',6)#"></i></a>
                                    <input type="hidden" name="row_asset_id_#currentrow#" id="row_asset_id_#currentrow#" value="#get_wo_document.ASSET_ID#">
                                </span>
                            </cfif>
                        </td>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="text" name="row_startdate_#currentrow#" id="row_startdate_#currentrow#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="row_startdate_#currentrow#"></span>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="text" name="row_finishdate_#currentrow#" id="row_finishdate_#currentrow#" validate="#validate_style#" maxlength="10">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="row_finishdate_#currentrow#"></span>
                                </div>
                            </div>
                        </td>
                        <td class="text-center"><input type="checkbox" name="row_status_#currentrow#" id="row_status_#currentrow#" checked value="1"></td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</cfoutput>

<!---
<cfloop from = "1" to = "#arrayLen(recycleDocuments)#" index = "g">

</cfloop>
--->
<!---
<cfset refinery = createObject("component","WBP/Recycle/files/cfc/refinery") />

<cfset rowCounter = 5 />
<cfset personelRow = ["Kimlik Fotokopisi", "SGK Bildirgesi", "I.S.G Eğitimi", "EK-2 Periyodik Muayene Formu", "Sürücü SRCS Belgesi"] />

<cf_grid_list sort="0">
    <thead>
        <tr>
            <th width="300">Evrak Adı</th>
            <th width="300">Dosya</th>
            <th width="300">Dosya Adı</th>
            <th width="300">Geçerlilik Başlangıç Tarihi</th>
            <th width="300">Geçerlilik Bitiş Tarihi</th>
            <th width="300">Aktif (Aktif seçilmeyenin dosyası yüklenmez!)</th>
        </tr>
    </thead>
    <tbody>
        <cfoutput>
            <cfloop array="#personelRow#" item="item">
                <cfset getWasteOilRow = refinery.getWasteOilRowDocs( row_number: rowCounter, driver_id: attributes.driver_id ) />
                <tr>
                    <td>#item# <input type="hidden" name="row_title#rowCounter#" id="row_title#rowCounter#" value="#item#"><input type="hidden" name="row_type#rowCounter#" id="row_type#rowCounter#" value="2"><input type="hidden" name="row_number#rowCounter#" id="row_number#rowCounter#" value="#rowCounter#"></td>
                    <td>
                        <div class="form-group">
                            <input type="file" name="row_file#rowCounter#" id="row_file#rowCounter#">
                        </div>
                    </td>
                    <td>
                        <cfif len(getWasteOilRow.ASSET_NAME)>
                            <span>
                                #getWasteOilRow.ASSET_NAME#
                                <a href="#request.self#?fuseaction=asset.list_asset&event=upd&asset_id=#getWasteOilRow.ASSET_ID#&assetcat_id=#getWasteOilRow.ASSETCAT_ID#" target="_blank"><i class="fa fa-external-link"></i></a>
                                <cfset ext=lcase(listlast(getWasteOilRow.ASSET_FILE_NAME, '.')) />
                                <cfset path_ = "#getWasteOilRow.ASSETCAT_PATH#">
                                <cfset url_ = "#file_web_path#/#path_#/">
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_download_file&<cfif ext eq "jpg" or ext eq "jpeg" or ext eq "png" or ext eq "bmp" or ext eq "pdf" or ext eq "txt" or ext eq "gif">direct_show=1&</cfif>file_name=#url_##getWasteOilRow.ASSET_FILE_NAME#&file_control=asset.form_upd_asset&asset_id=#getWasteOilRow.ASSET_ID#&assetcat_id=#getWasteOilRow.ASSETCAT_ID#','medium');return false;"><i class="catalyst-cloud-download"  title="#getLang('asset',6)#"></i></a>    
                                <input type="hidden" name="row_asset_id#rowCounter#" id="row_asset_id#rowCounter#" value="#getWasteOilRow.ASSET_ID#">
                            </span>
                        </cfif>
                    </td>
                    <td>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" name="row_startdate#rowCounter#" id="row_startdate#rowCounter#" validate="#validate_style#" value="#dateformat(getWasteOilRow.VALIDITY_START_DATE,dateformat_style)#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="row_startdate#rowCounter#"></span>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" name="row_finishdate#rowCounter#" id="row_finishdate#rowCounter#" validate="#validate_style#" value="#dateformat(getWasteOilRow.VALIDITY_FINISH_DATE,dateformat_style)#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="row_finishdate#rowCounter#"></span>
                            </div>
                        </div>
                    </td>
                    <td class="text-center"><input type="checkbox" name="row_status#rowCounter#" id="row_status#rowCounter#" checked value="1"></td>
                </tr>
                <cfset rowCounter++ />
            </cfloop>
        </cfoutput>
    </tbody>
</cf_grid_list>
--->