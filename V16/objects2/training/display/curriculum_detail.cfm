<cfset METHODS = createObject('component','V16.objects2.cfc.widget.training')>
<cfset GET_TRAININGS_CURRICULUM = METHODS.GET_TRAININGS_CURRICULUM(site: GET_PAGE.PROTEIN_SITE)>
<cfset GET_TRAININGS_CURRICULUM_DET = METHODS.GET_TRAININGS_CURRICULUM_DET(train_id : attributes.train_id)>

<style>
.syllabus .syllabus_box .syllabus_box_item{
    width: 273px;
    height: 290px;
}
.syllabus .syllabus_box .syllabus_box_item .syllabus_box_item_txt{
    font-weight: bold;
    font-size: 26px;
    line-height: 27px;
}
</style>

<div class="syllabus_detail">
    <!--- <h1>DİJİTAL KASLARI GÜÇLENDİREN EĞİTİM VE SERTİFİKA PROGRAMLARI</h1>
    <p>Workcube  eğitimleri Workcube Topluluğu ve Holistik Bilgi Teknolojileri Kooperatifi’nin ortak geliştirdiği 
        kurumların ve kişilerin dijital olgunluk düzeyini yükseltmek amacıyla tasarlanmıştır.
    </p> --->
    <div class="syllabus_detail_cont">
        <cfoutput query="GET_TRAININGS_CURRICULUM_DET">
            <div class="col-md-3">
                <img src="/documents/train_subject/#PATH#">
            </div>
            <div class="col-md-9">
                <div class="syllabus_detail_cont_txt">
                    <h2>#TRAIN_HEAD#</h2>
                    <p>#TRAIN_DETAIL#</p>                    
                </div>  
                <div class="syllabus_detail_cont_join_btn" >
                    <cfsavecontent  variable="title"><cf_get_lang dictionary_id='65493.Başvuru Formu'></cfsavecontent>
                    <a href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=trainingForm&isbox=1&train_id=#attributes.train_id#&title=#title#')"><cf_get_lang dictionary_id='65164.Katılmak için tıklayın'></a>
                </div>
            </div>       
        </cfoutput> 
    </div>
    <!--- <div class="syllabus mt-0">       
        <div class="syllabus_box">
            <cfoutput query="GET_TRAININGS_CURRICULUM"> 
                <cfif TRAIN_ID eq attributes.train_id>
                <cfelse>
                    <a href="#USER_FRIENDLY_URL#">
                        <div class="syllabus_box_item">
                            <img src="/documents/train_subject/#PATH#">
                            <div class="syllabus_box_item_txt">
                                #train_head#
                            </div>            
                        </div>
                    </a>
                </cfif> 
            </cfoutput>
        </div>
    </div> --->

</div>
<script>
    // var myColors = [
    // '#F37179','#808080', '#3C9CD8', '#5BBD72', '#FBB158', '#BD60A6','#F68D6F','#42C7C6','#CEA683'
    // ];
    // var i = 0;
    // $('.syllabus_box_item').each(function() {
    //     $(this).css('background-color', myColors[i]);
    //     i = (i + 1) % myColors.length;
    // });
</script>