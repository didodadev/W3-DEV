<cfsavecontent variable="right_images">
    <cfoutput>
        <li><a href="javascript://" onclick="import_countries()"><i class="fa fa-download" title="<cf_get_lang dictionary_id='63422.Data Services'> - <cf_get_lang dictionary_id='42893.Countries'>"></i></a></li>
    </cfoutput>
</cfsavecontent>

<cf_wrk_grid search_header = "#getLang('settings',910)#" dictionary_count="3" table_name="SETUP_COUNTRY" sort_column="COUNTRY_NAME" u_id="COUNTRY_ID" datasource="#dsn#" search_areas = "COUNTRY_NAME" right_images="#right_images#">
    <cf_wrk_grid_column name="COUNTRY_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="COUNTRY_NAME" required="true" header="#getLang('main',807)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="COUNTRY_PHONE_CODE" width="200" header="#getLang('main',1632)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="COUNTRY_CODE" width="200" header="#getLang('settings',2842)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TC_CHARNUMBER" width="50" type="number" header="#getLang('','Kimlik No Karakter Sayısı','65100')#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="VKN_CHARNUMBER" width="50" type="number" header="#getLang('','Vergi Kimlik No Karakter Sayısı','65101')#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_DEFAULT" width="250" header="#getLang('settings',1132)#" type="boolean" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>

<script>
    function import_countries() {
        message_confirm = "<cf_get_lang dictionary_id='63817.Mükerrer kayıt olmaması için eski kayıtların Ülke Kodunda eksik kayıt bırakmayınız!'>";
        saveMes = "<cf_get_lang dictionary_id='63819.Verileri almak için devam et'>";
        cancelMes = "<cf_get_lang dictionary_id='63818.Düzenleme yapmaya devam et'>";
        //Eğer devam edilirse data service kodlarına erişir. Kontrolleri Ülke Koduna göre yapar.
        Swal.fire({
            title: message_confirm,
            text: "",
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: saveMes,
            cancelButtonText: cancelMes,
        }).then((result) => {
            if (result.value) {
                goster(working_div_main);
                $.ajax({
                    url: "V16/settings/cfc/dataservice_control.cfc?method=runWexService",
                    method: "post",
                    dataType: "json",
                    data: {
                        functionName:"importCountry", 
                        start_date : "<cfoutput>#now()#</cfoutput>", 
                        finish_date : "<cfoutput>#now()#</cfoutput>"
                    },
                    success: function(e)
                    {
                        $("#working_div_main").hide();
                        Swal.fire(
                        '<cf_get_lang dictionary_id='61210.İşlem Başarılı'>!',
                        '<cf_get_lang dictionary_id='54060.İmport işlemi tamamlandı'>',
                        'success'
                        );

                    },error: function (objResponse) {
                        console.log(objResponse);
                    }
                });

            }else
            {
                return false;
            }
        });	
    }
</script>