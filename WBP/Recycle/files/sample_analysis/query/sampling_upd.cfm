<cfset sampling = createObject("component","WBP/Recycle/files/sample_analysis/cfc/sampling") />
<cftransaction>

    <cfif not len(attributes.process_cat)>
        <script type = "text/javascript">
            alert('İşlem kategorisi seçmelisiniz!');
        </script>
        <cfabort>
    </cfif>
    <cfif attributes.samplingRowCount eq 0>
        <script type = "text/javascript">
            alert('Satır eklemelisiniz!');
        </script>
        <cfabort>
    </cfif>
    <cf_date tarih = 'attributes.sampling_time'>
        
    <cfset attributes.sampling_date = attributes.sampling_time>
    <cfset attributes.sampling_time = createdatetime(year(attributes.sampling_time),month(attributes.sampling_time),day(attributes.sampling_time),attributes.sampling_time_h,attributes.sampling_time_m,0)>	

    <cfset sampling_id = sampling.saveSampling(
        sampling_id : attributes.sampling_id,
        process_cat : attributes.process_cat,
        department_id : attributes.department_id,
        location_id : attributes.location_id,
        sampling_date : attributes.sampling_date,
        sampling_time : attributes.sampling_time,
        sample_analysis_id : attributes.sample_analysis_id
    )>

    <cfloop from = "1" to = "#attributes.samplingRowCount#" index = "i">
        <cfif evaluate("attributes.samplingRowDeleted#i#") eq 0>
            <cfif not len(evaluate("attributes.product_id#i#") and len(evaluate("attributes.product_name#i#")))>
                <script type = "text/javascript">
                    alert('<cfoutput>#i#</cfoutput>. satırda ürün seçmelisiniz!');
                </script>
                <cfabort>
            </cfif>
            <cfif filterNum(evaluate("attributes.sample_amount#i#")) gt filterNum(evaluate("attributes.stock_amount#i#"))>
                <script type = "text/javascript">
                    alert('<cfoutput>#i#</cfoutput>. satırda stoktan fazla numune alamazsınız! Stok miktarı: <cfoutput>#evaluate("attributes.stock_amount#i#")#, Numune miktarı : #evaluate("attributes.sample_amount#i#")#</cfoutput>');
                </script>
                <cfabort>
            </cfif>
            <cfset samplingRowResult =  sampling.saveSamplingRow(
                sampling_id : sampling_id,
                stock_id : evaluate("attributes.stock_id#i#"),
                product_id : evaluate("attributes.product_id#i#"),
                description : evaluate("attributes.description#i#"),
                lot_no : evaluate("attributes.lot_no#i#"),
                spect_var_id : evaluate("attributes.spect_var_id#i#"),
                serial_no : evaluate("attributes.serial_no#i#"),
                stock_unit_id : evaluate("attributes.stock_unit_id#i#"),
                sample_amount : evaluate("attributes.sample_amount#i#"),
                department_id : attributes.department_id,
                location_id : attributes.location_id,
                sampling_date : attributes.sampling_date,
                sampling_time : attributes.sampling_time
            )>

            <cfif samplingRowResult eq -1>
                <script type = "text/javascript">
                    alert('<cfoutput>#i#</cfoutput>. satır kaydedilirken bir sorun oluştu!');
                </script>
                <cfabort>
            </cfif>
        </cfif>
    </cfloop>
</cftransaction>
<cfset attributes.actionid = sampling_id />